#!/bin/python3

import json
import logging
import os
import signal
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
    """
    I3/Sway kit
    ===========

    In order to stay compatible with Sway, there are a few things to take note of:

    1. ``swaymsg`` does not support using ``[con_id=<workspace_con_id>]`` to use workspaces as containers.

    2. For Wayland windows, their ``window`` field in the output of ``swaymsg -t get_tree`` is always ``null``.
       This could potentially be used to differentiate between X/Wayland windows, but in order to tell
       which containers are windows instead of layouts, probably the ``layout`` field is more suitable
       (seemingly ``none`` for windows).

       But anyway, this means you will need to use ``[con_id=...] ...`` instead of ``[id=...] ...``.

    3. ``swaymsg`` cannot handle commands like ``focus; [con_id=...] focus``, where
       ``[con_id=...]`` seems to be the culprit. Using one command at a time might be better.

    4. Passing several (~20) commands to ``swaymsg`` seems to crash Sway sometimes.
       I do not wish to have to reproduce that.
    """

    focused_workspace: int
    window_id_cache: dict[int, dict[str, typing.Any]]
    workspace_cache: list[dict[str, typing.Any]]

    msg_program: str

    def __init__(self):
        self.focused_workspace = -1
        self.window_id_cache = {}
        self.workspace_cache = []
        self.msg_program = "i3-msg" if os.getenv("SWAYSOCK") is None else "swaymsg"
        self.update_window_cache()

    def send(self, *msg: str):
        if len(msg) == 1 and ";" in msg[0]:
            # Split the commands up to hopefully avoid Sway crashes
            for command in msg[0].split(";"):
                p = self.send(command.strip())
            return p
        else:
            p = subprocess.run([self.msg_program] + list(msg), capture_output=True)
            p.check_returncode()
            return p

    @classmethod
    def for_each_child_node(cls, node: dict[str, typing.Any], f: typing.Callable[[dict[str, typing.Any]], None]):
        nodes = [node]
        while len(nodes) > 0:
            node = nodes.pop()
            f(node)
            nodes.extend(node["nodes"])
            nodes.extend(node["floating_nodes"])

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

    def is_window(self, window: dict[str, typing.Any]):
        return window.get("layout") == "none"

    def get_all_children(self, window: int):
        children = []

        def append(node):
            nonlocal children
            if self.is_window(node):
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

    def current_container(self):
        windows = [window for window in self.window_id_cache.values() if window["focused"]]
        if len(windows) == 1:
            return windows[0]
        else:
            return None

    def current_window(self):
        window = self.current_container()
        if window is not None and self.is_window(window):
            return window
        return None

    def unmark_prefix(self, window: int, prefix: str):
        for mark in self.window_id_cache[window]["marks"]:
            if mark.startswith(prefix):
                self.send(f"[con_id={window}] unmark {mark}")


class Placeholder(I3Kit):
    window: int
    workspace: int
    tk_window: int
    restorable: bool
    closing: bool

    def __init__(self, window: int, workspace: int):
        super().__init__()
        self.window = window
        self.workspace = workspace
        self.tk_window = -1
        self.restorable = False
        self.closing = False
        self.root = tkinter.Tk()
        self.root.title(self.window_id_cache[window].get("name", "[maximized]"))
        frame = ttk.Frame(self.root)
        frame.pack(fill="both", expand=True)
        frame.place(anchor="center", relx=0.5, rely=0.5)
        box = ttk.Frame(frame)
        box.pack(fill="both")
        box.place(anchor="center", relx=0.5, rely=0.5)
        box.grid()
        ttk.Button(box, text="Switch To Window", command=self.focus).grid(column=0, row=0)
        ttk.Button(box, text="Close Placeholder Without Restoring Window", command=self.root.destroy).grid(column=0, row=1)
        ttk.Button(box, text="Restore Window", command=self.restore).grid(column=0, row=2)
        signal.signal(signal.SIGUSR1, lambda *_: self.set_closing())
        signal.signal(signal.SIGUSR2, lambda *_: self.focus())
        self.root.bind("<FocusIn>", self.onfocus)

    def set_closing(self):
        self.closing = True

    def focus(self):
        self.send(f"[con_id={self.window}] focus")

    def mainloop(self):
        self.root.mainloop()

    def onfocus(self, *_):
        self.update_window_cache()
        if self.window not in self.window_id_cache:
            self.root.destroy()
        elif not self.restorable:
            self.swap()
        elif self.closing:
            self.restore()

    def swap(self):
        window = self.current_container()
        if window is not None:
            self.tk_window = window["id"]
            self.send(f"[con_id={self.tk_window}] move container to workspace number {self.workspace}")
            self.send(f"workspace number {self.workspace}")
            self.send(f"[con_id={self.tk_window}] mark --add {_placeholder_mark}0_{os.getpid()}")
            self.send(f"[con_id={self.tk_window}] swap container with con_id {self.window}")
            self.unmark_prefix(self.window, _placeholder_mark)
            self.send(f"[con_id={self.window}] mark --add {_placeholder_mark}{self.tk_window}_{os.getpid()}")
            self.restorable = True

    def restore(self):
        self.restorable = False
        self.send(f"[con_id={self.tk_window}] swap container with con_id {self.window}")
        self.send(f"[con_id={self.window}] focus")
        self.unmark_prefix(self.window, _placeholder_mark)
        self.root.destroy()


class Maximizer(I3Kit):
    def __init__(self):
        super().__init__()

    def placeholder(self, wid: int):
        empty_workspace = self.find_empty_workspace()
        Placeholder(wid, empty_workspace).mainloop()

    def notify_placeholder(self, window: int, marks: list[str]):
        try:
            for mark in [mark[len(_placeholder_mark):] for mark in marks if mark.startswith(_placeholder_mark)]:
                wid, pid = map(int, mark.split("_"))
                if wid == 0:
                    os.kill(pid, signal.SIGUSR2)
                else:
                    os.kill(pid, signal.SIGUSR1)
                    self.send(f"[con_id={wid}] focus")
        except:
            self.placeholder(window)

    def maximize(self):
        window = self.current_container()
        workspace = self.current_workspace()
        if window is None:
            # empty workspace
            return

        if use_tk:
            if self.is_maximized() or any(mark.startswith(_placeholder_mark) for mark in window["marks"]):
                self.notify_placeholder(window["id"], window["marks"])
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
