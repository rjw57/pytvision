#!/usr/bin/env python3
import enum
import random

import tvision as tv

with open(__file__) as f:
    LINES = [ln.rstrip("\n") for ln in f.readlines()]


class Command(enum.IntEnum):
    NEW_WIN = 199
    FILE_OPEN = 200
    NEW_DIALOG = 201


class Interior(tv.TScroller):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.growMode = tv.gfGrowHiX | tv.gfGrowHiY  # make size follow window's
        self.options |= tv.ofFramed
        self.setLimit(max(*(len(ln) for ln in LINES)), len(LINES))

    def draw(self) -> None:
        color = self.getColor(0x0301)
        for i in range(self.size.y):
            b = tv.TDrawBuffer()
            b.moveChar(0, " ", color.at(0), self.size.x)
            j = self.delta.y + i
            if j < len(LINES):
                b.moveStr(0, LINES[j][self.delta.x : self.delta.x + self.size.x], color.at(0))
            self.writeLine(0, i, self.size.x, 1, b)


class DemoWindow(tv.TWindow):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        bounds = self.getExtent()

        r = tv.TRect(bounds.a.x, bounds.a.y, bounds.b.x // 2 + 1, bounds.b.y)
        self.l_interior = self.make_interior(r, True)
        self.l_interior.growMode = tv.gfGrowHiY
        self.insert(self.l_interior)

        r = tv.TRect(bounds.b.x // 2, bounds.a.y, bounds.b.x, bounds.b.y)
        self.r_interior = self.make_interior(r, False)
        self.r_interior.growMode = tv.gfGrowHiX | tv.gfGrowHiY
        self.insert(self.r_interior)

    def make_interior(self, bounds: tv.TRect, left: bool) -> Interior:
        r = tv.TRect(bounds.b.x - 1, bounds.a.y + 1, bounds.b.x, bounds.b.y - 1)
        v_scroll_bar = tv.TScrollBar(r)
        v_scroll_bar.options |= tv.ofPostProcess
        if left:
            v_scroll_bar.growMode = tv.gfGrowHiY
        self.insert(v_scroll_bar)

        r = tv.TRect(bounds.a.x + 2, bounds.b.y - 1, bounds.b.x - 2, bounds.b.y)
        h_scroll_bar = tv.TScrollBar(r)
        h_scroll_bar.options |= tv.ofPostProcess
        if left:
            h_scroll_bar.growMode = tv.gfGrowHiY | tv.gfGrowLoY
        self.insert(h_scroll_bar)

        r = tv.TRect(bounds.a, bounds.b)
        r.grow(-1, -1)
        return Interior(r, h_scroll_bar, v_scroll_bar)

    def sizeLimits(self, min_p: tv.TPoint, max_p: tv.TPoint):
        super().sizeLimits(min_p, max_p)
        min_p.x = self.l_interior.size.x + 9


class MyApp(tv.TApplication):
    _win_number: int

    def __init__(self):
        super().__init__()
        self._win_number = 0

    @staticmethod
    def initStatusLine(r: tv.TRect) -> tv.TStatusLine:
        r.a.y = r.b.y - 1
        return tv.TStatusLine(
            r,
            [
                tv.TStatusDef(
                    0,
                    0xFFFF,
                    [
                        tv.TStatusItem("~Alt-X~ Exit", tv.kbAltX, tv.cmQuit),
                        tv.TStatusItem("~F4~ New", tv.kbF4, Command.NEW_WIN),
                        tv.TStatusItem("~Alt-F3~ Close", tv.kbAltF3, tv.cmClose),
                        tv.TStatusItem(None, tv.kbF10, tv.cmMenu),
                    ],
                )
            ],
        )

    @staticmethod
    def initMenuBar(r: tv.TRect) -> tv.TMenuBar:
        r.b.y = r.a.y + 1
        return tv.TMenuBar(
            r,
            [
                tv.TSubMenu(
                    "~F~ile",
                    tv.kbAltH,
                    tv.hcNoContext,
                    [
                        tv.TMenuItem("~O~pen", tv.cmFileOpen, tv.kbF3, tv.hcNoContext, "F3"),
                        tv.TMenuItem("~N~ew", Command.NEW_WIN, tv.kbF4, tv.hcNoContext, "F4"),
                        tv.TMenuLine(),
                        tv.TMenuItem("E~x~it", tv.cmQuit, tv.kbAltX, tv.hcNoContext, "Alt-X"),
                    ],
                ),
                tv.TSubMenu(
                    "~W~indow",
                    tv.kbAltW,
                    tv.hcNoContext,
                    [
                        tv.TMenuItem("~N~ext", tv.cmNext, tv.kbF6, tv.hcNoContext, "F6"),
                        tv.TMenuItem("~Z~oom", tv.cmZoom, tv.kbF5, tv.hcNoContext, "F5"),
                        tv.TMenuItem(
                            "~D~ialog", Command.NEW_DIALOG, tv.kbF2, tv.hcNoContext, "F2"
                        ),
                    ],
                ),
            ],
        )

    def handleEvent(self, event: tv.TEvent) -> None:
        super().handleEvent(event)

        if event.what == tv.evCommand:
            if event.message.command == Command.NEW_WIN:
                self.my_new_window()
            elif event.message.command == Command.NEW_DIALOG:
                self.new_dialog()
            self.clearEvent(event)

    def my_new_window(self) -> None:
        r = tv.TRect(0, 0, 26, 7)
        r.move(random.randint(0, 53), random.randint(0, 16))
        self._win_number += 1
        window = DemoWindow(r, "Demo Window", self._win_number)
        self.deskTop.insert(window)

    def new_dialog(self) -> None:
        pd = tv.TDialog(tv.TRect(20, 6, 60, 19), "Demo Dialog")
        pd.insert(tv.TButton(tv.TRect(15, 10, 25, 12), "~O~K", tv.cmOK, tv.bfDefault))
        pd.insert(tv.TButton(tv.TRect(28, 10, 38, 12), "~C~ancel", tv.cmCancel, tv.bfNormal))

        b = tv.TCheckBoxes(tv.TRect(3, 3, 18, 6), ["~H~varti", "~T~ilset", "~J~arlsberg"])
        pd.insert(b)
        pd.insert(tv.TLabel(tv.TRect(2, 2, 10, 3), "Cheeses", b))

        b = tv.TRadioButtons(tv.TRect(22, 3, 34, 6), ["~S~olid", "~R~unny", "~M~elted"])
        pd.insert(b)
        pd.insert(tv.TLabel(tv.TRect(21, 2, 33, 3), "Consistency", b))

        b = tv.TInputLine(tv.TRect(3, 8, 37, 9), 128)
        pd.insert(b)
        pd.insert(tv.TLabel(tv.TRect(2, 7, 24, 8), "Delivery Instructions", b))

        self.deskTop.execView(pd)


def main():
    app = MyApp()
    app.run()


if __name__ == "__main__":
    main()
