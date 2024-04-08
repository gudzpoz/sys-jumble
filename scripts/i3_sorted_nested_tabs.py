#!/bin/python3

import argparse

from i3_splitv_tab_layout import TabLayoutMaker

class NestedLayoutMaker(TabLayoutMaker):
    nested_limit: int

    def __init__(self, nested_limit: int):
        super().__init__(1, "i3_nested_tabs_temp")
        self.nested_limit = nested_limit

    def layout(self):
        workspace = self.focused_workspace
        self.update_window_cache()
        self._mark_window(self.focused_workspace)
        children = self.get_all_children(workspace)
        if len(children) <= self.nested_limit:
            return
        children.sort(key=lambda w: w["name"].lower())
        chunks = [
            children[i:i + args.nested_limit]
            for i in range(0, len(children), args.nested_limit)
        ]
        chunks = [chunks[0]] + chunks[-1:0:-1]
        print([w["name"] for w in children])
        self.send(
            f"[con_id={workspace}] split h;\n[con_id={workspace}] focus;\n"
            + ";\n".join(
                self._move_windows_to_new_tabs(chunk, workspace) for chunk in chunks
            )
            + f";\n[con_id={workspace}] layout tabbed"
        )


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('nested_limit', type=int, default=10)
    args = parser.parse_args()
    NestedLayoutMaker(args.nested_limit).layout()
