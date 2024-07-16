#!/bin/python3

import argparse
import json
import logging
import os
import re
import subprocess
import time
import typing

from i3_maximize_window import I3Kit

_logger = logging.getLogger("i3_window_back_and_forth")
_debug = _logger.debug
_info = _logger.info
_warning = _logger.warning

_window_id_regex = re.compile("0x[\\dA-Fa-f]+")
_last_window_mark = "_last_window"
_recent_window_mark = "_recent_window"


class ContinuousMarker(I3Kit):
    count: int

    stream: int

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

    def _title_of_window(self, wid: int):
        window = self.window_id_cache.get(wid)
        return "<not found>" if window is None or not self.is_window(window) else window["title"]

    def reorder(self):
        _debug("marking %s as recent windows", self.windows)
        for i in range(self.count):
            self.send(f"unmark {_recent_window_mark}_{i}")
        for i, wid in enumerate(self.windows):
            try:
                self.send(f"[con_id={wid}] mark --add {_recent_window_mark}_{i}")
            except:
                _warning(f"window {self._title_of_window(wid)} (id={wid}) closed already")

    def mark_last(self, last: int):
        _debug("marking window %d as the last window (%s)", last, self.windows)
        self.send(f"unmark {_last_window_mark}")
        try:
            self.send(f"[con_id={last}] mark --add {_last_window_mark}")
        except:
            _warning(f"window {self._title_of_window(last)} (id={last}) closed already")

    def try_loop(self):
        # TODO: Find an alternative in Wayland environments
        stream = subprocess.Popen(["xprop", "-root", "-spy", "_NET_ACTIVE_WINDOW"], stdout=subprocess.PIPE)
        _info("listening to %s", stream)
        try:
            for line in iter(stream.stdout.readline, ""):
                wid = self._extract_id_from_spy_line(line.decode())
                if wid is None:
                    continue

                self.update_window_cache()

                # Must be tiled window
                if wid not in self.window_id_cache or not self.is_window(self.window_id_cache[wid]):
                    continue

                self.windows = [wid for wid in self.windows if wid in self.window_id_cache and self.is_window(self.window_id_cache[wid])]

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
        finally:
            stream.stdout.close()

    def loop(self):
        while True:
            try:
                self.try_loop()
            except KeyboardInterrupt:
                _info("quitting due to user interrupt...")
                break
            except Exception as e:
                _warning("error captured: %s", e)
            _info("pipe broken, retrying in 5 seconds...")
            time.sleep(5)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, filename="/tmp/i3_window_back_and_forth.log")
    _info(f"pid: {os.getpid()}")

    parser = argparse.ArgumentParser(description="Marks recently focused windows to allow for convenient switching-to.")
    parser.add_argument("-c", "--count", help="The max number of recently focused windows to match.", required=False, default=3)
    args = parser.parse_args()
    ContinuousMarker(args.count).loop()
