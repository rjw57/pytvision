#!/usr/bin/env python3
import enum

import tvision as tv


class Command(enum.IntEnum):
    ABOUT = 100
    DIALOG = 101


class HelpCtx(enum.IntEnum):
    SYSTEM = 10
    ABOUT = 11


class TestWindow(tv.TWindow):
    def __init__(self):
        super().__init__(tv.TRect(0, 0, 34, 12), "Test window", tv.wnNoNumber)
        self.insert(tv.TStaticText(
            tv.TRect(9, 2, 30, 9),
            "\003Turbo Vision Demo\n\n"
            "\003C++ Version\n\n"
            "\003Copyright (c) 1994\n\n"
            "\003Borland International",
        ))


class Application(tv.TApplication):
    def __init__(self):
        super().__init__()
        self.deskTop.insert(TestWindow())

    def initMenuBar(self, r) -> tv.TMenuBar:
        r.b.y = r.a.y + 1
        return tv.TMenuBar(
            r,
            [
                tv.TSubMenu(
                    "~\u2261~",
                    0,
                    HelpCtx.SYSTEM,
                    [
                        tv.TMenuItem("~A~bout", Command.ABOUT, tv.kbAltA, HelpCtx.ABOUT),
                    ],
                ),
                tv.TSubMenu(
                    "~H~ello",
                    tv.kbAltH,
                    tv.hcNoContext,
                    [
                        tv.TMenuItem("Show ~D~ialog", Command.DIALOG, tv.kbAltD, p="Alt-D"),
                        tv.TMenuItem("~W~orld", 200, tv.kbAltW, p="Alt-W"),
                        tv.TMenuLine(),
                        tv.TMenuItem("~O~ther", 201, tv.kbAltO, p="Alt-O"),
                        tv.TSubMenu(
                            "~S~ub",
                            items=[
                                tv.TMenuItem(
                                    "E~x~it", tv.cmQuit, tv.kbAltY, tv.hcNoContext, "Alt-X"
                                ),
                            ],
                        ),
                    ],
                ),
                tv.TSubMenu(
                    "Othe~r~",
                    tv.kbAltR,
                    items=[
                        tv.TMenuItem("Title", 103),
                    ],
                ),
            ],
        )

    def initStatusLine(self, r: tv.TRect) -> tv.TStatusLine:
        r.a.y = r.b.y - 1
        return tv.TStatusLine(
            r,
            [
                tv.TStatusDef(
                    0,
                    0xFFFF,
                    [
                        tv.TStatusItem("~Alt-X~ Exit", tv.kbAltX, tv.cmQuit),
                        tv.TStatusItem(None, tv.kbAltF10, tv.cmMenu),
                    ],
                )
            ],
        )

    def handleEvent(self, event: tv.TEvent):
        super().handleEvent(event)

        if event.what == tv.evCommand:
            if event.message.command == Command.ABOUT:
                self.aboutDlgBox()
            elif event.message.command == Command.DIALOG:
                self.testDlgBox()

    def testDlgBox(self):
        dlg = tv.TFileDialog("*.*", "Open File", "~N~ame", tv.fdOpenButton, 1)
        self.executeDialog(dlg)

    def aboutDlgBox(self):
        about_box = tv.TDialog(tv.TRect(0, 0, 39, 13), "About")
        about_box.insert(tv.TStaticText(
            tv.TRect(9, 2, 30, 9),
            "\003Turbo Vision Demo\n\n"
            "\003C++ Version\n\n"
            "\003Copyright (c) 1994\n\n"
            "\003Borland International",
        ))
        about_box.insert(tv.TButton(tv.TRect(14, 10, 26, 12), " OK", tv.cmOK, tv.bfDefault))
        about_box.options |= tv.ofCentered
        self.executeDialog(about_box)


def main():
    app = Application()
    app.run()


if __name__ == "__main__":
    main()
