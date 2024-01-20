%rename(TMenuItem_) TMenuItem;
%rename(TMenu_) TMenu;
%rename(TSubMenu_) TSubMenu;
%rename(TMenuBar_) TMenuBar;
%rename(TStatusItem_) TStatusItem;
%rename(TStatusDef_) TStatusDef;
%rename(TStatusLine_) TStatusLine;
%rename(sub_menu_append_item_) ::operator+(TSubMenu&, TMenuItem&);
%rename(sub_menu_chain_) ::operator+(TSubMenu&, TSubMenu&);
%rename(status_def_append_item_) ::operator+(TStatusDef&, TStatusItem&);
%rename(status_def_chain_) ::operator+(TStatusDef&, TStatusDef&);

%feature("director") TMenuBar;
%feature("director") TStatusLine;

%ignore newLine;

// Bare const char*.
%ignore TMenuItem::name;

// Method which return pointers/references.
%ignore TMenuBar::getPalette;
%ignore TStatusLine::getPalette;
%ignore TStatusLine::hint;

%include "tvision/menus.h"

%newobject new_line_menu_item_;
%inline { TMenuItem* new_line_menu_item_() { return &newLine(); } }

%pythoncode "menu.py"
