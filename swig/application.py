class TApplication(TApplication_):
    def __init__(self):
        super().__init__()

        deskTop = self.initDeskTop(self.getExtent())
        if deskTop:
            self.insert(deskTop)
            self.deskTop = deskTop

        statusLine = self.initStatusLine(self.getExtent())
        if statusLine:
            self.insert(statusLine)
            self.statusLine = statusLine

        menuBar = self.initMenuBar(self.getExtent())
        if menuBar:
            self.insert(menuBar)
            self.menuBar = menuBar

    @staticmethod
    def initDeskTop(r: "TRect") -> "TDeskTop":
        return TApplication_.initDeskTop(r)

    @staticmethod
    def initMenuBar(r: "TRect") -> "TMenuBar":
        return TApplication_.initMenuBar(r)

    @staticmethod
    def initStatusLine(r: "TRect") -> "TStatusLine":
        return TApplication_.initStatusLine(r)
