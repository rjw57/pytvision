from dataclasses import dataclass, field
from typing import Optional, Sequence, Union


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
    def __init__(self, bounds: TRect, aMenu: TSubMenu):
        sm = aMenu.make_()
        super().__init__(bounds, sm)
        self._sub_menu = sm  # Keep reference to the sub-menu for this menu bar
