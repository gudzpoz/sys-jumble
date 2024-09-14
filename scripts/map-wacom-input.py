#!/bin/python3

import argparse
import dataclasses
import logging
import subprocess
import time
import typing

import numpy as np
import numpy.typing as npt
import Xlib
import Xlib.display

from evdev import InputDevice, UInput, ecodes, events


_logger = logging.getLogger()
_info = _logger.info
logging.basicConfig(level=logging.INFO)


def get_first_device(dev: typing.Optional[str] = None):
    if dev is None:
        sleep_seconds = 1
        devices = []
        while len(devices) == 0:
            time.sleep(sleep_seconds)
            sleep_seconds = min(sleep_seconds * 2, 10 * 60)
            libwacom_list = subprocess.run(
                [
                    "libwacom-list-local-devices",
                ],
                capture_output=True,
            ).stdout.decode()
            devices = [
                line.strip()
                for line in libwacom_list.split("\n")
                if line.startswith("  - ") and "/dev/input" in line
            ]
        dev = devices[0][2:].split(":")[0]
    _info("Registering %s", dev)
    return InputDevice(dev)


def init_window_getter():
    disp = Xlib.display.Display()
    root = disp.screen().root
    NET_WM_NAME = disp.intern_atom("_NET_WM_NAME")
    NET_ACTIVE_WINDOW = disp.intern_atom("_NET_ACTIVE_WINDOW")

    def get_current_window_name():
        nonlocal disp, root, NET_WM_NAME, NET_ACTIVE_WINDOW
        try:
            window_id = root.get_full_property(
                NET_ACTIVE_WINDOW, Xlib.X.AnyPropertyType
            ).value[0]
            window = disp.create_resource_object("window", window_id)
            prop = window.get_full_property(NET_WM_NAME, 0)
            return "" if prop is None else str(prop.value)
        except:
            return ""

    return get_current_window_name


@dataclasses.dataclass
class ScrollerConfig:
    threshold: int
    break_threshold: int
    scale: float
    block_list: list[str]
    allow_list: list[str]

    scroll_threshold: float = 1.0

    def is_allowed(self, name: str):
        for e in self.allow_list:
            if e in name.lower():
                return True
        return False

    def is_blocked(self, name: str):
        if self.is_allowed(name):
            return False
        for ban in self.block_list:
            if ban in name.lower():
                return True
        return False


class WacomScroller:
    wacom: InputDevice

    mouse: UInput

    pos: npt.NDArray[np.int_]
    last: npt.NDArray[np.int_]
    start: npt.NDArray[np.int_]
    offset: npt.NDArray[float]
    down: bool
    drag: bool

    current_window_name: typing.Callable[[], str]

    config: ScrollerConfig

    def __init__(
        self, wacom: InputDevice, mouse: UInput, config: ScrollerConfig
    ) -> None:
        self.wacom = wacom
        self.mouse = mouse
        self.pos, self.last, self.start = [np.zeros(2, dtype=np.int_) for _ in range(3)]
        self.offset = np.zeros(2)
        self.down, self.drag = False, False
        self.current_window_name = init_window_getter()
        self.config = config

    def event_loop(self):
        key_codes: dict[str, int] = ecodes.ecodes
        EV_KEY, EV_ABS, ABS_X, ABS_Y = (
            key_codes["EV_KEY"],
            key_codes["EV_ABS"],
            key_codes["ABS_X"],
            key_codes["ABS_Y"],
        )
        for event in self.wacom.read_loop():
            if event.type == EV_ABS:
                # Tracks pen position changes.
                if event.code == ABS_X:
                    self.pos[0] = event.value
                elif event.code == ABS_Y:
                    self.pos[1] = event.value
                if self.down:
                    self.try_scrolling()
            if event.type == EV_KEY:
                # Tracks button status.
                ke = events.KeyEvent(event)
                if ke.keycode == "BTN_STYLUS":
                    if ke.keystate == ke.key_down:
                        self.down = True
                        self.drag = False
                        self.start = self.pos.copy()
                        self.last = self.pos.copy()
                        self.offset = np.zeros(2)
                    elif ke.keystate == ke.key_up:
                        self.down = False

    def try_scrolling(self):
        if ((self.pos - self.last) ** 2).sum() > self.config.break_threshold**2:
            # Moving too fast, probably some unintentional flickers.
            self.down = False
            self.drag = False
        else:
            # Starts dragging only after reaching the threshold.
            if not self.drag and (
                ((self.pos - self.start) ** 2).sum() > self.config.threshold**2
            ):
                self.drag = True
            # For special apps (like Gimp or Krita), we do not use the BTN_STYLUS for scrolling.
            if self.config.is_blocked(self.current_window_name()):
                self.drag = False
            # Maps dragging to mouse scrolling.
            if self.drag:
                self.offset += (self.pos - self.last).astype(
                    np.float64
                ) / self.config.scale
                if np.abs(self.offset).max() > self.config.scroll_threshold:
                    offset = self.offset**3
                    self.scroll(offset[0], -offset[1])
                    self.offset = np.zeros(2)
                self.last = self.pos.copy()

    def scroll(self, x: int, y: int):
        for _ in range(abs(int(x * 120))):
            self.mouse.write(ecodes.EV_REL, ecodes.REL_HWHEEL_HI_RES, 1 if x > 0 else -1)
        for _ in range(abs(int(y * 120))):
            self.mouse.write(ecodes.EV_REL, ecodes.REL_WHEEL_HI_RES, 1 if y > 0 else -1)


parser = argparse.ArgumentParser(
    description="Maps BTN_STYLUS (probably mapped to the middle button) on your Wacom device to scrolling when dragged.",
)
parser.add_argument(
    "--threshold", type=int, help="Dragging threshold in pixels", default=100
)
parser.add_argument(
    "--breaking-threshold",
    type=int,
    help="The threshold to detect cursor flickers when no scrolling should be done.",
    default=400,
)
parser.add_argument(
    "--scale",
    type=float,
    help="How much dragging maps to a mouse scroll",
    default=100.0,
)
parser.add_argument(
    "--block-list",
    type=str,
    help="The appliction keywords to not use scrolling maping (comma separated)",
    default="gimp,krita,pdf,xournal",
)
parser.add_argument(
    "--allow-list",
    type=str,
    help="The appliction keywords to always use scrolling maping (comma separated)",
    default="firefox",
)
args = parser.parse_args()
WacomScroller(
    get_first_device(),
    UInput({ecodes.EV_REL: [
        ecodes.REL_HWHEEL,
        ecodes.REL_HWHEEL_HI_RES,
        ecodes.REL_WHEEL,
        ecodes.REL_WHEEL_HI_RES,
    ]}),
    ScrollerConfig(
        threshold=args.threshold,
        break_threshold=args.breaking_threshold,
        scale=args.scale,
        block_list=[s.strip() for s in args.block_list.split(',')],
        allow_list=[s.strip() for s in args.allow_list.split(',')],
    ),
).event_loop()
