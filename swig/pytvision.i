%module(directors=1) tvision
%feature("autodoc", "3");

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
%ignore ::operator+;
%ignore ::operator-;
%ignore ::operator<<;
%ignore ::operator>>;
%ignore ::operator==;
%ignore ::operator!=;
%ignore ::operator new;

// Ignore genRefs which is not used in Python.
%ignore ::genRefs;
%ignore *::genRefs;

// Define away keywords not used by swig.
#define _NEAR
#define _FAR
#define _Cdecl

// Make sure all the Uses_... macros are defined.
%import "all_uses.hpp"
%import "tvision/tv.h"

// Typemaps for converting arguments.
%include "typemaps.i"

// Base types used by headers but not wrapped directly.
%import "tvision/ttypes.h"

// Utility functions are better implemented in Python so we import rather than include.
%import "tvision/util.h"

// %include "tvision/colors.h"
// %include "tvision/scrncell.h"

%include "tvision/tkeys.h"

// %include "tvision/ttext.h"

%ignore fLink;
%include "tvision/tvobjs.h"
%include "tvision/tobjstrm.h"

// %include "tvision/drawbuf.h"

%include "tvision/objects.h"

%include "system.i"

%ignore MsgBoxText;
%include "tvision/msgbox.h"

// %include "tvision/resource.h"

%include "views.i"

// %import "tvision/buffers.h"

%include "dialogs.i"

%include "tvision/validate.h"

%ignore TFileDialog::directory;
%include "tvision/stddlg.h"

%ignore TColorItem::name;
%ignore TColorGroup::name;
%include "tvision/colorsel.h"

%include "menus.i"

// %include "tvision/textview.h"
// %include "tvision/editors.h"
// %include "tvision/outline.h"
// %include "tvision/surface.h"

%include "application.i"
