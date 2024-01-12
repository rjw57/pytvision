import tvision
import sys


class Application(tvision.TApplication):
    def handleEvent(self, event: tvision.TEvent):
        sys.exit(1)


def main():
    app = Application()
    app.run()


if __name__ == "__main__":
    main()
