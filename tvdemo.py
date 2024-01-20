import enum

import tvision as tv


class Command(enum.IntEnum):
    ABOUT = 100


class HelpCtx(enum.IntEnum):
    SYSTEM = 10
    ABOUT = 11


class Application(tv.TApplication):
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
                        tv.TMenuItem("~A~bout", Command.ABOUT, tv.kbNoKey, HelpCtx.ABOUT),
                    ],
                ),
                tv.TSubMenu(
                    "~H~ello",
                    tv.kbAltH,
                    tv.hcNoContext,
                    [
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

    def aboutDlgBox(self):
        tv.messageBox("About dialog", tv.mfOKButton)


def main():
    app = Application()
    app.run()


if __name__ == "__main__":
    main()
