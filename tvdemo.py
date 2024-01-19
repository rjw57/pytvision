#!/usr/bin/env python
import tvision as tv


class Application(tv.TApplication):
    def initMenuBar(self, r):
        r.b.y = r.a.y + 1
        return tv.TMenuBar(
            r,
            tv.TSubMenu(
                "~H~ello",
                tv.kbAltH,
                tv.hcNoContext,
                [
                    tv.TMenuItem("~W~orld", 100, tv.kbAltW),
                    tv.TMenuItem("~O~ther", 101, tv.kbAltO),
                    tv.TSubMenu(
                        "~S~ub",
                        items=[
                            tv.TMenuItem("E~x~it", tv.cmQuit, tv.kbAltX),
                        ],
                    ),
                ],
            ),
        )

    def handleEvent(self, event: tv.TEvent):
        super().handleEvent(event)


def main():
    app = Application()
    app.run()


if __name__ == "__main__":
    main()
