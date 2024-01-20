from dataclasses import dataclass, field
from typing import Iterable, Optional, Sequence, Union


class TMenuLine:
    def make_(self):
        return new_line_menu_item_()


@dataclass
class TMenuItem:
    name: str
    command: int
    key: Union[TKey, int] = kbNoKey
    help_ctx: int = hcNoContext
    p: Optional[str] = None

    def make_(self) -> TMenuItem_:
        return TMenuItem_(self.name, self.command, self.key, self.help_ctx, self.p)


@dataclass
class TSubMenu:
    name: str
    key: Union[TKey, int] = kbNoKey
    help_ctx: int = hcNoContext
    items: Sequence[Union[TMenuItem, TMenuLine, "TSubMenu"]] = field(default_factory=list)

    def make_(self) -> TSubMenu_:
        sm = TSubMenu_(self.name, self.key, self.help_ctx)
        items = [item.make_() for item in self.items]
        for item in items:
            sub_menu_append_item_(sm, item)
        sm._items = items  # ensure sub-menu keeps references to its items for garbage collection
        return sm


class TMenuBar(TMenuBar_):
    def __init__(self, bounds: TRect, sub_menus: Iterable[TSubMenu]):
        # Keep references to the sub-menus for this menu bar
        self._sub_menus = [sm.make_() for sm in sub_menus]
        if len(self._sub_menus) == 0:
            raise ValueError("TMenuBar requires at least one TSubMenu")
        for prev, next in zip(self._sub_menus[:-1], self._sub_menus[1:]):
            sub_menu_chain_(prev, next)
        super().__init__(bounds, self._sub_menus[0])


@dataclass
class TStatusItem:
    text: Optional[str]
    key: Union[TKey, int]
    cmd: int

    def make_(self):
        return TStatusItem_(self.text, self.key, self.cmd)


@dataclass
class TStatusDef:
    min: int
    max: int
    items: Sequence[TStatusItem]

    def make_(self):
        sd = TStatusDef_(self.min, self.max)
        items = [item.make_() for item in self.items]
        for item in items:
            status_def_append_item_(sd, item)
        sd._items = items  # ensure status def keeps references to its items for garbage collection
        return sd


class TStatusLine(TStatusLine_):
    def __init__(self, bounds: TRect, defs: Iterable[TStatusDef]):
        # Keep references to the defs for this status line
        self._defs = [sd.make_() for sd in defs]
        for prev, next in zip(self._defs[:-1], self._defs[1:]):
            status_def_chain_(prev, next)
        super().__init__(bounds, self._defs[0] if len(self._defs) > 0 else None)
