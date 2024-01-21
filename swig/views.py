class TWindow(TWindow_):
    def __init__(self, bounds: TRect, aTitle: str, aNumber: int) -> None:
        super().__init__(bounds, aTitle, aNumber)

        frame = self.initFrame(self.getExtent())
        if frame:
            self.insert(frame)
            self.frame = frame

    @staticmethod
    def initFrame(r: TRect) -> TFrame:
        return TWindow_.initFrame(r)
