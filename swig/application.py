class TApplication(TApplication_):
    def __init__(self):
        super().__init__()
        r = self.getExtent()

        deskTop = self.initDeskTop(r)
        if deskTop:
            self.insert(deskTop)
            self.deskTop = deskTop

        statusLine = self.initStatusLine(r)
        if statusLine:
            self.insert(statusLine)
            self.statusLine = statusLine

        menuBar = self.initMenuBar(r)
        if menuBar:
            self.insert(menuBar)
            self.menuBar = menuBar

    @staticmethod
    def initDeskTop(r: "TRect"):
        return TApplication_.initDeskTop(r)

    @staticmethod
    def initMenuBar(r: "TRect"):
        return TApplication_.initMenuBar(r)

    @staticmethod
    def initStatusLine(r: "TRect"):
        return TApplication_.initStatusLine(r)
