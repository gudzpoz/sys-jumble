#!/bin/python3

import argparse
import json
import logging
import re
import subprocess
import typing

_logger = logging.getLogger("i3_splitv_tab_layout")
_debug = _logger.debug
_info = _logger.info

_window_id_regex = re.compile("0x[\\dA-Fa-f]+")
_temp_window_mark = "_i3_splitv_tab_layout_temp"


class TabLayoutMaker:
    focused_workspace: int

    window_id_cache: dict[int, dict[str, typing.Any]]

    def __init__(self):
        self.focused_workspace = -1
        self.window_id_cache = {}

    @classmethod
    def _send(cls, msg: str):
        subprocess.run(["i3-msg", msg], stdout=subprocess.DEVNULL).check_returncode()

    @classmethod
    def _for_each_child_node(cls, node: dict[str, typing.Any], f: typing.Callable[[dict[str, typing.Any]], None]):
        nodes = [node]
        while len(nodes) > 0:
            node = nodes.pop()
            f(node)
            nodes.extend(node["nodes"])

    def _update_window_cache(self):
        p = subprocess.run(["i3-msg", "-t", "get_tree"], capture_output=True)
        p.check_returncode()
        self.window_id_cache = {}
        tree = json.loads(p.stdout)
        workspace = -1
        def update(node):
            nonlocal self, workspace
            self.window_id_cache[node["id"]] = node
            if node["type"] == "workspace":
                workspace = node["id"]
            if node["focused"]:
                self.focused_workspace = workspace
        self._for_each_child_node(tree, update)

    def _mark_window(self, window: int):
        assert self.focused_workspace != -1
        self._send(f"unmark {_temp_window_mark}")
        self._send(f"unmark {_temp_window_mark}_tabbed")
        self._send(f"[con_id={window}] mark --add {_temp_window_mark}")

    def _get_all_children(self, window: int):
        children = []
        def append(node):
            nonlocal children
            if isinstance(node["window"], int):
                children.append(node)
        self._for_each_child_node(self.window_id_cache[self.focused_workspace], append)
        return children

    def _get_parent(self, child: typing.Any):
        for window in self.window_id_cache.values():
            if any(node["id"] == child["id"] for node in window["nodes"]):
                return window
        return None

    def _move_windows_to_new_tabs(self, windows: list[typing.Any], workspace: int):
        self._send(f"[con_id={workspace}] split h")
        self._send(f"[id={windows[0]['window']}] move window to mark {_temp_window_mark}")
        self._send(f"[id={windows[0]['window']}] split v")
        self._send(f"[id={windows[0]['window']}] layout tabbed")
        self._update_window_cache()
        parent = self._get_parent(windows[0])
        assert parent is not None
        self._send(f"[con_id={parent['id']}] mark --add {_temp_window_mark}_tabbed")
        for window in windows[1:]:
            self._send(f"[id={window['window']}] move window to mark {_temp_window_mark}_tabbed")

    def layout(self):
        self._update_window_cache()
        workspace = self.focused_workspace
        self._mark_window(workspace)
        children = self._get_all_children(workspace)
        if len(children) < 2:
            return
        mid = len(children) // 2
        A, B = children[:mid], children[mid:]
        self._move_windows_to_new_tabs(A, workspace)
        self._move_windows_to_new_tabs(B, workspace)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    TabLayoutMaker().layout()
