#!/bin/python3

import argparse
import json
import logging
import re
import subprocess
import typing

_logger = logging.getLogger("i3_maximize_window")
_debug = _logger.debug
_info = _logger.info

_maximized_mark = "_i3_maximizer_"
_placeholder_mark = "_i3_max_holder_"

try:
    import tkinter
    from tkinter import ttk
    use_tk = True
except:
    use_tk = False

class I3Kit:
    focused_workspace: int
    window_id_cache: dict[int, dict[str, typing.Any]]
    workspace_cache: list[dict[str, typing.Any]]

    def __init__(self):
        self.focused_workspace = -1
        self.window_id_cache = {}
        self.workspace_cache = []
        self.update_window_cache()

    @classmethod
    def send(cls, *msg: str):
        p = subprocess.run(["i3-msg"] + list(msg), capture_output=True)
        p.check_returncode()
        return p

    @classmethod
    def for_each_child_node(cls, node: dict[str, typing.Any], f: typing.Callable[[dict[str, typing.Any]], None]):
        nodes = [node]
        while len(nodes) > 0:
            node = nodes.pop()
            f(node)
            nodes.extend(node["nodes"])

    def update_window_cache(self):
        self.window_id_cache = {}
        tree = json.loads(self.send("-t", "get_tree").stdout)
        workspace = -1
        def update(node):
            nonlocal self, workspace
            self.window_id_cache[node["id"]] = node
            if node["type"] == "workspace":
                workspace = node["id"]
            if node["focused"]:
                self.focused_workspace = workspace
        self.for_each_child_node(tree, update)
        self.workspace_cache = json.loads(self.send("-t", "get_workspaces").stdout)

    def get_all_children(self, window: int):
        children = []
        def append(node):
            nonlocal children
            if isinstance(node["window"], int):
                children.append(node)
        self.for_each_child_node(self.window_id_cache[window], append)
        return children

    def get_parent(self, child: int):
        for window in self.window_id_cache.values():
            if any(node["id"] == child for node in window["nodes"]):
                return window
        return None

    def is_maximized(self):
        windows = self.get_all_children(self.focused_workspace)
        return len(windows) == 1

    def current_workspace(self):
        for workspace in self.workspace_cache:
            if workspace["focused"]:
                return workspace["num"]
        return None

    def find_empty_workspace(self):
        workspaces = [workspace["num"] for workspace in self.workspace_cache]
        i = 1
        while i in workspaces:
            i += 1
        return i

    def current_window(self):
        windows = [window for window in self.window_id_cache.values()
                   if window["focused"] and isinstance(window["window"], int)]
        if len(windows) == 1:
            return windows[0]
        else:
            return None

    def unmark_prefix(self, window: int, prefix: str):
        for mark in self.window_id_cache[window]["marks"]:
            if mark.startswith(prefix):
                self.send(f"[con_id={window}] unmark {mark}")


class Placeholder(I3Kit):
    window: int
    tk_window: int
    restorable: bool

    def __init__(self, window: int):
        super().__init__()
        self.window = window
        self.tk_window = -1
        self.restorable = False
        self.root = tkinter.Tk()
        self.root.title(self.window_id_cache[window].get("name", "[maximized]"))
        ttk.Frame(self.root)
        self.root.bind("<FocusIn>", self.onfocus)

    def mainloop(self):
        self.root.mainloop()

    def onfocus(self, *_):
        self.update_window_cache()
        if self.restorable:
            self.restore()
        else:
            self.swap()

    def swap(self):
        window = self.current_window()
        if window is not None:
            self.tk_window = window["id"]
            self.send(f"[con_id={self.tk_window}] swap container with con_id {self.window}")
            self.unmark_prefix(self.window, _placeholder_mark)
            self.send(f"[con_id={self.window}] mark --add {_placeholder_mark}{self.tk_window}")
            self.restorable = True

    def restore(self):
        window = self.window_id_cache[self.window]
        self.restorable = False
        self.send(f"[con_id={self.tk_window}] swap container with con_id {self.window}")
        self.send(f"[con_id={self.window}] focus")
        self.unmark_prefix(self.window, _placeholder_mark)
        self.root.destroy()


class Maximizer(I3Kit):
    def __init__(self):
        super().__init__()

    def placeholder(self, wid: int):
        window = self.window_id_cache[wid]
        empty_workspace = self.find_empty_workspace()
        self.send(f"workspace number {empty_workspace}")
        p = Placeholder(wid)
        p.mainloop()

    def maximize(self):
        window = self.current_window()
        workspace = self.current_workspace()
        if window is None:
            return

        if use_tk:
            if self.is_maximized():
                for wid in [mark[len(_placeholder_mark):] for mark in window["marks"] if mark.startswith(_placeholder_mark)]:
                    self.send(f"[con_id={wid}] focus")
            else:
                self.placeholder(window["id"])
            return

        if self.is_maximized():
            prev = [mark[len(_maximized_mark):] for mark in window["marks"] if mark.startswith(_maximized_mark)]
            for mark in prev:
                self.send(f"[con_id={window['id']}] unmark {_maximized_mark}{mark}")
            if len(prev) > 0:
                self.send(f"move container to workspace number {prev[0]}")
                self.send(f"workspace number {prev[0]}")
        else:
            empty_workspace = self.find_empty_workspace()
            for mark in window["marks"]:
                if mark.startswith(_maximized_mark):
                    self.send(f"[con_id={window['id']}] unmark {mark}")
            self.send(f"[con_id={window['id']}] mark --add {_maximized_mark}{workspace}")
            self.send(f"move container to workspace number {workspace}")
            self.send(f"workspace number {empty_workspace}")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    Maximizer().maximize()
