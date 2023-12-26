#!/bin/python3

import argparse
import json
import logging
import re
import subprocess
import typing

from i3_maximize_window import I3Kit

_logger = logging.getLogger("i3_window_back_and_forth")
_debug = _logger.debug
_info = _logger.info

_window_id_regex = re.compile("0x[\\dA-Fa-f]+")
_last_window_mark = "_last_window"
_recent_window_mark = "_recent_window"


class ContinuousMarker(I3Kit):
    count: int

    windows: list[int]

    def __init__(self, count: int):
        super().__init__()
        self.count = count
        self.windows = []
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

    def reorder(self):
        _debug("marking %s as recent windows", self.windows)
        for i in range(self.count):
            self.send(f"unmark {_recent_window_mark}_{i}")
        for i, wid in enumerate(self.windows):
            self.send(f"[id={wid}] mark --add {_recent_window_mark}_{i}")

    def mark_last(self, last: int):
        _debug("marking window %d as the last window (%s)", last, self.windows)
        self.send(f"unmark {_last_window_mark}")
        self.send(f"[id={last}] mark --add {_last_window_mark}")

    def loop(self):
        stream = subprocess.Popen(["xprop", "-root", "-spy", "_NET_ACTIVE_WINDOW"], stdout=subprocess.PIPE)
        for line in iter(stream.stdout.readline, ""):
            wid = self._extract_id_from_spy_line(line.decode())
            if wid is None:
                continue

            self.update_window_cache()
            window_id_map = dict((window["window"], window["id"]) for window in self.window_id_cache.values()
                                 if window["window"] is not None)

            # Must be tiled window
            if wid not in window_id_map:
                continue

            self.windows = [wid for wid in self.windows if wid in window_id_map]

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
