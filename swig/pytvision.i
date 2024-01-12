%module(directors=1) tvision

%feature("autodoc", "3");

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

// TSpan and TStringView are unsafe to wrap in Python since they do not own what they point to.
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
// %include "tvision/objects.h"

%ignore TTimerQueue;
%include "tvision/system.h"

// %include "tvision/msgbox.h"
// %include "tvision/resource.h"

%ignore TView::getColor;
%ignore TView::genRefs;
%ignore TView::mapColor;
%feature("director") TView;
%feature("nodirector") TView::mapColor;
%include "tvision/views.h"

// %include "tvision/buffers.h"
// %include "tvision/dialogs.h"
// %include "tvision/validate.h"
// %include "tvision/stddlg.h"
// %include "tvision/colorsel.h"

%include "tvision/menus.h"

// %include "tvision/textview.h"
// %include "tvision/editors.h"
// %include "tvision/outline.h"
// %include "tvision/surface.h"

%rename(TApplicationBase) TApplication;
%rename(TApplication) TPythonApplication;
%include "tvision/app.h"

%inline %{
class TPythonApplicationBase : public TApplication {
public:
  TPythonApplicationBase() : TProgInit(NULL, NULL, NULL) { }
};
%}

%pythoncode %{
class TApplication(TPythonApplicationBase):
    def __init__(self):
        super().__init__()
        self.insertInitialWidgets()

    def insertInitialWidgets(self):
        r = self.getExtent()
        self.insert(self.initDeskTop(r))
        self.insert(self.initStatusLine(r))
        self.insert(self.initMenuBar(r))
%}
