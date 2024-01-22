%module(directors=1) tvision
%feature("autodoc", "3");

%{
#include <stdexcept>

// noexcept and SWIG directors don't play nice.
#define noexcept

#include "all_uses.hpp"
#include "tvision/tv.h"
%}

// Defined in application.i
%{
static void bailFromRun();
%}

%feature("director:except") {
  if ($error != NULL) {
    bailFromRun();
  }
}

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

// Define away keywords not used by swig.
#define _NEAR
#define _FAR
#define _Cdecl

// Typemaps for converting arguments.
%include "typemaps.i"

// Make sure all the Uses_... macros are defined.
%import "all_uses.hpp"
%import "tvision/tv.h"

// Base types used by headers but not wrapped directly.
%import "tvision/ttypes.h"

// Re-define the TV_TRIVIALLY_ASSIGNABLE macro from ttypes.h since we don't expose the operators it
// defines.
#undef TV_TRIVIALLY_ASSIGNABLE
#define TV_TRIVIALLY_ASSIGNABLE(Self)

// Utility functions are better implemented in Python so we import rather than include.
%import "tvision/util.h"

%include "colors.i"
%include "scrncell.i"

%include "tvision/tkeys.h"

// %include "tvision/ttext.h"

%ignore fLink;
%ignore TNSCollection;
%ignore TNSSortedCollection;
%include "tvision/tvobjs.h"

// TStreamable is an abstract base class, it's not constructed directly.
%nodefaultctor TStreamable;
%nodefaultdtor TStreamable;
%ignore TStreamableClass;
%ignore pstream;
%ignore ipstream;
%ignore opstream;
%ignore iopstream;
%ignore ifpstream;
%ignore ofpstream;
%ignore fpstream;
%include "tvision/tobjstrm.h"

%include "tvision/drawbuf.h"

%ignore TCollection;
%ignore TSortedCollection;
%include "tvision/objects.h"

%include "system.i"

%ignore MsgBoxText;
%include "tvision/msgbox.h"

// Python has its own resource management mechanisms.
// %include "tvision/resource.h"

%include "views.i"

// We don't expose low-level video buffer functionality.
// %import "tvision/buffers.h"

%include "dialogs.i"

%include "tvision/validate.h"

%ignore TFileDialog::directory;
%include "tvision/stddlg.h"

%ignore TColorItem::name;
%ignore TColorGroup::name;
%include "tvision/colorsel.h"

%include "menus.i"

%ignore TTextDevice;
%include "tvision/textview.h"

%ignore TEditor::clipboard;
// TODO:
%ignore TEditor::formatLine;
%ignore TEditor::formatCell;
%include "tvision/editors.h"

%ignore TNode::text;
// Looks like these are never defined?
%ignore TOutlineViewer::build;
%ignore TOutlineViewer::name;
%include "tvision/outline.h"

%include "tvision/surface.h"

%include "application.i"
