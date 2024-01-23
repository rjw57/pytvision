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


def _bios_color_to_desired(color: int):
    r, g, b = [
        (0x00, 0x00, 0x00),
        (0x00, 0x00, 0xAA),
        (0x00, 0xAA, 0x00),
        (0x00, 0xAA, 0xAA),
        (0xAA, 0x00, 0x00),
        (0xAA, 0x00, 0xAA),
        (0xAA, 0x55, 0x00),
        (0xAA, 0xAA, 0xAA),
        (0x55, 0x55, 0x55),
        (0x55, 0x55, 0xFF),
        (0x55, 0xFF, 0x55),
        (0x55, 0xFF, 0xFF),
        (0xFF, 0x55, 0x55),
        (0xFF, 0x55, 0xFF),
        (0xFF, 0xFF, 0x55),
        (0xFF, 0xFF, 0xFF),
    ][color]
    return TColorDesired(TColorRGB(r, g, b))


class TApplication(TApplication_):
    def __init__(self) -> None:
        super().__init__()
        self._reset_palette()

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

    def _reset_palette(self) -> None:
        # Rather than relying on terminals to have the one true color palette, reset the palette to
        # correspond to CGA bios colors.
        palette = self.getPalette()
        for pal_idx in range(len(cpAppColor)):
            c = palette.at(pal_idx)
            if c.isBIOS():
                bios_c = c.asBIOS()
                new_c = TColorAttr(
                    _bios_color_to_desired(bios_c & 0xF),
                    _bios_color_to_desired((bios_c >> 4) & 0xF),
                )
                c.assign(new_c)
