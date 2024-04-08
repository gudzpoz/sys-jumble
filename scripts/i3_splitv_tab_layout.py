#!/bin/python3

import argparse
import json
import logging
import re
import subprocess
import typing

from i3_maximize_window import I3Kit


class TabLayoutMaker(I3Kit):
    splits: int
    mark: str

    def __init__(self, splits: int, mark: str = "_i3_splitv_tab_layout_temp"):
        super().__init__()
        self.splits = splits
        self.mark = mark

    def _mark_window(self, window: int):
        assert self.focused_workspace != -1
        self.send(f"unmark {self.mark}")
        self.send(f"unmark {self.mark}_tabbed")
        self.send(f"[con_id={window}] mark --add {self.mark}")

    def _move_windows_to_new_tabs(self, windows: list[typing.Any], workspace: int) -> str:
        prefix = f"""
        unmark {self.mark}_tabbed;
        [id={windows[0]['window']}] move window to mark {self.mark};
        [id={windows[0]['window']}] split v;
        [id={windows[0]['window']}] layout tabbed;
        [id={windows[0]['window']}] mark {self.mark}_tabbed;
        """
        return prefix + ";\n".join(
            f"[id={window['window']}] move window to mark {self.mark}_tabbed"
            for window in windows[-1:0:-1]
        ) + f";\nunmark {self.mark}_tabbed"

    def layout(self):
        workspace = self.focused_workspace
        self._mark_window(workspace)
        children = self.get_all_children(workspace)
        if len(children) < self.splits:
            return
        self.send(
            f"[con_id={workspace}] split h;\n"
            + ";\n".join(
                self._move_windows_to_new_tabs(children[i::self.splits], workspace)
                for i in range(self.splits)
            )
        )

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--splits", type=int, help="Horizontal pane count", default=2, required=False)
    args = parser.parse_args()
    TabLayoutMaker(args.splits).layout()
