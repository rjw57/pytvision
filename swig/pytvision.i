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
%ignore operator+;
%ignore operator-;
%ignore operator<<;
%ignore operator>>;
%ignore operator==;
%ignore operator!=;

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

// Implicit str -> TStringView
%typemap(typecheck, precedence=SWIG_TYPECHECK_UNISTRING) TStringView {
  $1 = (($input == Py_None) || (PyUnicode_Check($input))) ? 1 : 0;
}

%typemap(in) TStringView {
  if($input == Py_None) {
    $1 = NULL;
  } else if(PyUnicode_Check($input)) {
    $1 = TStringView(PyUnicode_AsUTF8($input));
    if(PyErr_Occurred()) {
      SWIG_fail;
    }
  } else {
    SWIG_exception_fail(SWIG_TypeError, "in method '$symname', expecting type str or None");
  }
}

// Implicit int -> TKey
%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER) TKey {
  if(PyLong_Check($input)) {
    $1 = 1;
  } else {
    void *vptr = 0;
    int res = SWIG_ConvertPtr($input, &vptr, $1_descriptor, 0);
    $1 = SWIG_IsOK(res) ? 1 : 0;
  }
}

%typemap(in) TKey {
  if (!SWIG_IsOK(SWIG_ConvertPtr($input, (void **) &$1, $1_descriptor, 0))) {
    if(PyLong_Check($input)) {
      $1 = TKey((ushort)PyLong_AsLong($input));
      if(PyErr_Occurred()) {
        SWIG_fail;
      }
    } else {
      SWIG_exception_fail(SWIG_TypeError, "in method '$symname', expecting type Foo");
    }
  }
}

// Make sure all the Uses_... macros are defined.
%import "all_uses.hpp"
%import "tvision/tv.h"

%include "tvision/config.h"
%include "tvision/ttypes.h"

// Utility functions are better implemented in Python so we import rather than include.
%import "tvision/util.h"

// %import "tvision/tspan.h"
// %import "tvision/tstrview.h"

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

%include "system.i"

%ignore MsgBoxText;
%include "tvision/msgbox.h"

// %include "tvision/resource.h"

%include "views.i"

// %include "tvision/buffers.h"
// %include "tvision/dialogs.h"
// %include "tvision/validate.h"
// %include "tvision/stddlg.h"
// %include "tvision/colorsel.h"

%include "menus.i"

// %include "tvision/textview.h"
// %include "tvision/editors.h"
// %include "tvision/outline.h"
// %include "tvision/surface.h"

%include "application.i"
