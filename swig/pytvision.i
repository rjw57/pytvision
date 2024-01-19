%module(directors=1) tvision

%feature("autodoc", "3");
%feature("director");

%feature("director:except") {
  if ($error != NULL) {
    throw Swig::DirectorMethodException();
  }
}

%exception {
  try { $action }
  catch (Swig::DirectorException &e) { SWIG_fail; }
}

%{
#include "all_uses.hpp"
#include "tvision/tv.h"
%}

// Ignore constants which clash with Python builtins.
%ignore True;
%ignore False;

// Ignore unwrappable operators
%ignore operator+;
%ignore operator-;
%ignore operator<<;
%ignore operator>>;
%ignore operator==;
%ignore operator!=;

%ignore TStringView::operator[];

// Define away keywords not used by swig.
#define _NEAR
#define _FAR
#define _Cdecl

// Operators
%rename(__add__) *::operator+;
%rename(__sub__) *::operator-;
%rename(__lshift__) *::operator<<;
%rename(__rshift__) *::operator>>;
%rename(__eq__) *::operator==;
%rename(__ne__) *::operator!=;

// Make sure all the Uses_... macros are defined.
%import "all_uses.hpp"
%import "tvision/tv.h"

%include "tvision/config.h"
%include "tvision/ttypes.h"

// Utility functions are better implemented in Python so we import rather than include.
%import "tvision/util.h"

// %import "tvision/tspan.h"

%rename(TStringView_) TStringView;
%include "tvision/tstrview.h"

%ignore ::genRefs;

// %include "tvision/colors.h"
// %include "tvision/scrncell.h"
// %include "tvision/hardware.h"

%include "tvision/tkeys.h"

// %include "tvision/ttext.h"
// %include "tvision/tvobjs.h"
// %import "tvision/tobjstrm.h"
// %include "tvision/drawbuf.h"
%include "tvision/objects.h"

%ignore TTimerQueue;
%include "tvision/system.h"

// %include "tvision/msgbox.h"
// %include "tvision/resource.h"

%ignore TView::getColor;
%ignore TView::genRefs;
%ignore TView::mapColor;
%feature("nodirector") TView::mapColor;
%feature("nodirector") TWindow;

// We will replace insertion methods in TGroup with variants which disown their inputs. This is
// because, after insertion, TGroup will be responsible for delete-ing its children.
%ignore TGroup::insert;
%rename(insert) TGroup::insert_disowning;
%ignore TGroup::insertBefore;
%rename(insertBefore) TGroup::insertBefore_disowning;

%include "tvision/views.h"

%extend TGroup {
  // Special typemap which disowns views passed to the methods we define below if the argument is
  // named "view".
  %typemap(in) TView* view {
    if (!SWIG_IsOK(SWIG_ConvertPtr($input, (void **) &$1, $1_descriptor, SWIG_POINTER_DISOWN))) {
      SWIG_exception_fail(SWIG_TypeError, "in method '$symname', expecting type TView");
    }
  }

  void insert_disowning(TView *view) {
    $self->insert(view);
  }

  void insertBefore_disowning(TView *p, TView *view) {
    $self->insertBefore(p, view);
  }
}

// %include "tvision/buffers.h"
// %include "tvision/dialogs.h"
// %include "tvision/validate.h"
// %include "tvision/stddlg.h"
// %include "tvision/colorsel.h"

%rename(TMenuItem_) TMenuItem;
%rename(TMenu_) TMenu;
%rename(TSubMenu_) TSubMenu;
%rename(TMenuBar_) TMenuBar;
%rename(sub_menu_append_item_) ::operator+(TSubMenu&, TMenuItem&);
%include "tvision/menus.h"

%extend TSubMenu {
  TSubMenu(const char* nm, TKey key, ushort helpCtx = hcNoContext) {
    return new TSubMenu(nm, key, helpCtx);
  }
  TSubMenu(const char* nm, ushort key, ushort helpCtx = hcNoContext) {
    return new TSubMenu(nm, key, helpCtx);
  }
}

%extend TMenuItem {
  TMenuItem(const char* aName, ushort aCommand, TKey aKey, ushort aHelpCtx = hcNoContext) {
    return new TMenuItem(aName, aCommand, aKey, aHelpCtx);
  }
  TMenuItem(const char* aName, ushort aCommand, ushort aKey, ushort aHelpCtx = hcNoContext) {
    return new TMenuItem(aName, aCommand, aKey, aHelpCtx);
  }
}

%pythoncode "menu.py"

// %include "tvision/textview.h"
// %include "tvision/editors.h"
// %include "tvision/outline.h"
// %include "tvision/surface.h"

%feature("nodirector") TDeskTop;
%rename(TApplication_) TApplication;
%include "tvision/app.h"
%pythoncode "application.py"
