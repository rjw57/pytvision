%rename(TApplication_) TApplication;

// TODO: handle TDeskInit
%feature("nodirector") TDeskTop;

// TODO: returns pointers/referencees
%ignore TProgram::insertWindow;

// Direct pointer access is dangerous. We only set these in wrapper classes which are careful with
// ownership.
%warnfilter(454) TProgram::application;
%warnfilter(454) TProgram::statusLine;
%warnfilter(454) TProgram::menuBar;
%warnfilter(454) TProgram::deskTop;

%ignore TProgram::executeDialog;
%ignore TProgram::insertWindow;
%ignore TProgram::validView;
%rename(executeDialog) TProgram::executeDialog_disowning;
%rename(insertWindow) TProgram::insertWindow_disowning;
%rename(validView) TProgram::validView_disowning;

%feature("director");
%include "tvision/app.h"
%feature("director", "");

%extend TProgram {
  // Special typemap which disowns passed views, dialogs and windows.
  %typemap(in) TView*, TDialog*, TWindow* {
    if (!SWIG_IsOK(SWIG_ConvertPtr($input, (void **) &$1, $1_descriptor, SWIG_POINTER_DISOWN))) {
      SWIG_exception_fail(SWIG_TypeError, "in method '$symname', expecting type $n_type");
    }
  }

  virtual ushort executeDialog_disowning(TDialog* dlg, void* data = NULL) {
    return $self->executeDialog(dlg, data);
  }

  virtual TWindow* insertWindow_disowning(TWindow* win) {
    return $self->insertWindow(win);
  }

  virtual TView* validView_disowning(TView* p) {
    return $self->validView(p);
  }
}

%pythoncode "application.py"
