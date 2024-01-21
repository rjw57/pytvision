class TDeskTop(TDeskTop_):
    def __init__(self) -> None:
        super().__init__()

        background = self.initBackground(self.getExtent())
        if background:
            self.background = background
            self.insert(background)

    @staticmethod
    def initBackground(r: TRect) -> TBackground:
        return TDeskTop_.initBackground(r)


class TApplication(TApplication_):
    def __init__(self) -> None:
        super().__init__()

        deskTop = self.initDeskTop(self.getExtent())
        if deskTop:
            self.deskTop = deskTop
            self.insert(deskTop)

        statusLine = self.initStatusLine(self.getExtent())
        if statusLine:
            self.statusLine = statusLine
            self.insert(statusLine)

        menuBar = self.initMenuBar(self.getExtent())
        if menuBar:
            self.menuBar = menuBar
            self.insert(menuBar)

    @staticmethod
    def initDeskTop(r: TRect) -> TDeskTop:
        return TApplication_.initDeskTop(r)

    @staticmethod
    def initMenuBar(r: TRect) -> TMenuBar:
        return TApplication_.initMenuBar(r)

    @staticmethod
    def initStatusLine(r: TRect) -> TStatusLine:
        return TApplication_.initStatusLine(r)
