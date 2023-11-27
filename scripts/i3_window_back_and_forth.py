#!/bin/python3

import argparse
import json
import logging
import re
import subprocess
import typing

_logger = logging.getLogger("i3_window_back_and_forth")
_debug = _logger.debug
_info = _logger.info

_window_id_regex = re.compile("0x[\\dA-Fa-f]+")
_last_window_mark = "_last_window"
_recent_window_mark = "_recent_window"


class ContinuousMarker:
    count: int

    windows: list[int]

    window_id_cache: dict[int, dict[str, typing.Any]]

    def __init__(self, count: int):
        self.count = count
        self.windows = []
        self.window_id_cache = {}
        _info("will keep track of %d windows", count)

    @classmethod
    def _extract_id_from_spy_line(cls, line: str):
        if "_NET_ACTIVE_WINDOW" in line:
            result = _window_id_regex.search(line)
            if result is not None:
                wid = int(result.group(0), 16)
                _debug("window switching detected (%s)", wid)
                return wid
        return None

    @classmethod
    def _send(cls, msg: str):
        subprocess.run(["i3-msg", msg], stdout=subprocess.DEVNULL).check_returncode()

    def _update_window_id_cache(self):
        p = subprocess.run(["i3-msg", "-t", "get_tree"], capture_output=True)
        p.check_returncode()
        self.window_id_cache = {}
        tree = json.loads(p.stdout)
        nodes = [tree]
        while len(nodes) > 0:
            node = nodes.pop()
            self.window_id_cache[node["window"]] = node
            nodes.extend(node["nodes"])

    def reorder(self):
        _debug("marking %s as recent windows", self.windows)
        for i in range(self.count):
            self._send(f"unmark {_recent_window_mark}_{i}")
        for i, wid in enumerate(self.windows):
            self._send(f"[id={wid}] mark --add {_recent_window_mark}_{i}")

    def mark_last(self, last: int):
        _debug("marking window %d as the last window (%s)", last, self.windows)
        self._send(f"unmark {_last_window_mark}")
        self._send(f"[id={last}] mark --add {_last_window_mark}")

    def loop(self):
        stream = subprocess.Popen(["xprop", "-root", "-spy", "_NET_ACTIVE_WINDOW"], stdout=subprocess.PIPE)
        for line in iter(stream.stdout.readline, ""):
            wid = self._extract_id_from_spy_line(line.decode())
            if wid is None:
                continue

            self._update_window_id_cache()

            # Must be tiled window
            if wid not in self.window_id_cache:
                continue

            self.windows = [wid for wid in self.windows if wid in self.window_id_cache]

            last = self.windows[0] if len(self.windows) >= 1 else None
            if last is not None and last != wid:
                self.mark_last(last)

            is_recent = wid in self.windows
            if is_recent:
                self.windows.remove(wid)
            self.windows.insert(0, wid)
            if not is_recent:
                self.windows = self.windows[:self.count]
                self.reorder()

        popen.stdout.close()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    parser = argparse.ArgumentParser(description="Marks recently focused windows to allow for convenient switching-to.")
    parser.add_argument("-c", "--count", help="The max number of recently focused windows to match.", required=False, default=3)
    args = parser.parse_args()
    ContinuousMarker(args.count).loop()
