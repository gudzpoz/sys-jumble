#!/bin/python3

import argparse
import json
import logging
import re
import subprocess
import typing

from i3_splitv_tab_layout import TabLayoutMaker

_logger = logging.getLogger("i3_maximize_window")
_debug = _logger.debug
_info = _logger.info

_maximized_mark = "_i3_maximizer_"

class Maximizer(TabLayoutMaker):
    def __init__(self):
        super().__init__()

    def _is_maximized(self):
        windows = self._get_all_children(self.focused_workspace)
        return len(windows) == 1

    def _current_workspace(self):
        for workspace in json.loads(self._send("-t", "get_workspaces").stdout):
            if workspace["focused"]:
                return workspace["num"]
        return None

    def _find_empty_workspace(self):
        workspaces = [
            workspace["num"]
            for workspace in json.loads(self._send("-t", "get_workspaces").stdout)
        ]
        i = 1
        while i in workspaces:
            i += 1
        return i

    def _get_focused_window(self):
        windows = [window for window in self.window_id_cache.values()
                   if window["focused"] and isinstance(window["window"], int)]
        if len(windows) == 1:
            return windows[0]
        else:
            return None

    def maximize(self):
        self._update_window_cache()
        window = self._get_focused_window()
        workspace = self._current_workspace()
        if window is None:
            return
        if self._is_maximized():
            prev = [int(mark[len(_maximized_mark):]) for mark in window["marks"] if mark.startswith(_maximized_mark)]
            for mark in prev:
                self._send(f"[con_id={window['id']}] unmark {_maximized_mark}{mark}")
            if len(prev) > 0:
                self._send(f"move container to workspace number {prev[0]}")
                self._send(f"workspace number {prev[0]}")
        else:
            empty_workspace = self._find_empty_workspace()
            for mark in window["marks"]:
                if mark.startswith(_maximized_mark):
                    self._send(f"[con_id={window['id']}] unmark {mark}")
            self._send(f"[con_id={window['id']}] mark --add {_maximized_mark}{workspace}")
            self._send(f"move container to workspace number {workspace}")
            self._send(f"workspace number {empty_workspace}")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    Maximizer().maximize()
