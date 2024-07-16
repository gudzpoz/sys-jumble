#!/bin/python3

import argparse
import logging
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
        self.send(f"unmark {self.mark}_tabbed")

    def layout(self):
        children = self.get_all_children(self.focused_workspace)
        if len(children) < self.splits:
            return
        workspace = self.find_empty_workspace()
        self._layout([children[i::self.splits] for i in range(self.splits)], workspace)
        self.send(f"workspace {workspace}")

    def _layout(self, groups: list[list[typing.Any]], workspace: int):
        containers = [group[0] for group in groups]
        for container in containers:
            self.send(f"[con_id={container['id']}] move container to workspace {workspace}")
        for container in containers:
            self.send(f"""
            [con_id={container['id']}] split v;
            [con_id={container['id']}] layout tabbed
            """)
        for group in groups:
            container = group[0]
            self.send(f"unmark {self.mark}_tabbed")
            self.send(f"[con_id={container['id']}] mark {self.mark}_tabbed")
            for window in group[-1:0:-1]:
                self.send(f"[con_id={window['id']}] move window to mark {self.mark}_tabbed")
            self.send(f"unmark {self.mark}_tabbed")

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--splits", type=int, help="Horizontal pane count", default=2, required=False)
    args = parser.parse_args()
    TabLayoutMaker(args.splits).layout()
