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

%ignore newLine;

// Bare const char*.
%ignore TMenuItem::name;

// Methods which return pointers/references.
%ignore TStatusLine::hint;

// We need to bring our own TMenuItem interface to avoid a nested union.
class TMenuItem
{
public:
  TMenuItem(
    TStringView aName,
    ushort aCommand,
    TKey aKey,
    ushort aHelpCtx = hcNoContext,
    TStringView p = NULL
  ) noexcept;
  ~TMenuItem();

  void append( TMenuItem *aNext ) noexcept;

  TMenuItem *next;
  ushort command;
  Boolean disabled;
  TKey keyCode;
  ushort helpCtx;
  TMenu *subMenu;
};

#undef Uses_TMenuItem
%feature("director");
%include "tvision/menus.h"
%feature("director", "");
#define Uses_TMenuItem

%newobject new_line_menu_item_;
%inline { TMenuItem* new_line_menu_item_() { return &newLine(); } }

%pythoncode "menu.py"
