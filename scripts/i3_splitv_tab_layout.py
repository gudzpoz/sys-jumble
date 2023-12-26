#!/bin/python3

import argparse
import json
import logging
import re
import subprocess
import typing

from i3_maximize_window import I3Kit

_logger = logging.getLogger("i3_splitv_tab_layout")
_debug = _logger.debug
_info = _logger.info

_window_id_regex = re.compile("0x[\\dA-Fa-f]+")
_temp_window_mark = "_i3_splitv_tab_layout_temp"


class TabLayoutMaker(I3Kit):
    def __init__(self):
        super().__init__()

    def _mark_window(self, window: int):
        assert self.focused_workspace != -1
        self.send(f"unmark {_temp_window_mark}")
        self.send(f"unmark {_temp_window_mark}_tabbed")
        self.send(f"[con_id={window}] mark --add {_temp_window_mark}")

    def _move_windows_to_new_tabs(self, windows: list[typing.Any], workspace: int):
        self.send(f"[con_id={workspace}] split h")
        self.send(f"[id={windows[0]['window']}] move window to mark {_temp_window_mark}")
        self.send(f"[id={windows[0]['window']}] split v")
        self.send(f"[id={windows[0]['window']}] layout tabbed")
        self.update_window_cache()
        parent = self.get_parent(windows[0]["id"])
        assert parent is not None
        self.send(f"[con_id={parent['id']}] mark --add {_temp_window_mark}_tabbed")
        for window in windows[1:]:
            self.send(f"[id={window['window']}] move window to mark {_temp_window_mark}_tabbed")

    def layout(self):
        workspace = self.focused_workspace
        self._mark_window(workspace)
        children = self.get_all_children(workspace)
        if len(children) < 2:
            return
        mid = len(children) // 2
        A, B = children[:mid], children[mid:]
        self._move_windows_to_new_tabs(A, workspace)
        self._move_windows_to_new_tabs(B, workspace)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    TabLayoutMaker().layout()
