%rename(TMenuItem_) TMenuItem;
%rename(TMenu_) TMenu;
%rename(TSubMenu_) TSubMenu;
%rename(TMenuBar_) TMenuBar;
%rename(sub_menu_append_item_) ::operator+(TSubMenu&, TMenuItem&);
%ignore newLine;

%include "tvision/menus.h"

%newobject new_line_menu_item_;
%inline { TMenuItem* new_line_menu_item_() { return &newLine(); } }

%extend TSubMenu {
  TSubMenu(const char* nm, TKey key, ushort helpCtx = hcNoContext) {
    return new TSubMenu(nm, key, helpCtx);
  }
  TSubMenu(const char* nm, ushort key, ushort helpCtx = hcNoContext) {
    return new TSubMenu(nm, key, helpCtx);
  }
}

%extend TMenuItem {
  TMenuItem(const char* aName, ushort aCommand, TKey aKey, ushort aHelpCtx = hcNoContext, const char* p = NULL) {
    return new TMenuItem(aName, aCommand, aKey, aHelpCtx, p);
  }
  TMenuItem(const char* aName, ushort aCommand, ushort aKey, ushort aHelpCtx = hcNoContext, const char* p = NULL) {
    return new TMenuItem(aName, aCommand, aKey, aHelpCtx, p);
  }
}

%pythoncode "menu.py"
