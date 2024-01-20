#!/usr/bin/env python3
import enum

import tvision as tv


class Command(enum.IntEnum):
    GREET_THEM = 100


class HelloApp(tv.TApplication):
    def greeting_box(self) -> None:
        d = tv.TDialog(tv.TRect(25, 5, 55, 16), "Hello, World!")

        d.insert(tv.TStaticText(tv.TRect(3, 5, 15, 6), "How are you?"))
        d.insert(tv.TButton(tv.TRect(16, 2, 28, 4), "Terrific", tv.cmCancel, tv.bfNormal))
        d.insert(tv.TButton(tv.TRect(16, 4, 28, 6), "Ok", tv.cmCancel, tv.bfNormal))
        d.insert(tv.TButton(tv.TRect(16, 6, 28, 8), "Lousy", tv.cmCancel, tv.bfNormal))
        d.insert(tv.TButton(tv.TRect(16, 8, 28, 10), "Cancel", tv.cmCancel, tv.bfNormal))

        self.deskTop.execView(d)

    def handleEvent(self, event: tv.TEvent) -> None:
        super().handleEvent(event)

        if event.what == tv.evCommand:
            if event.message.command == Command.GREET_THEM:
                self.greeting_box()
                self.clearEvent(event)

    @staticmethod
    def initMenuBar(r: tv.TRect) -> tv.TMenuBar:
        r.b.y = r.a.y + 1
        return tv.TMenuBar(
            r,
            [
                tv.TSubMenu(
                    "~H~ello",
                    tv.kbAltH,
                    tv.hcNoContext,
                    [
                        tv.TMenuItem("~G~reeting...", Command.GREET_THEM, tv.kbAltG),
                        tv.TMenuLine(),
                        tv.TMenuItem("E~x~it", tv.cmQuit, tv.kbAltX, tv.hcNoContext, "Alt-X"),
                    ],
                ),
            ],
        )

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
                        tv.TStatusItem(None, tv.kbF10, tv.cmMenu),
                    ],
                )
            ],
        )


def main():
    app = HelloApp()
    app.run()


if __name__ == "__main__":
    main()
