%rename(TApplicationBase) TApplication;
%rename(TDeskTop_) TDeskTop;

// Direct pointer access is dangerous. We only set these in wrapper classes which are careful with
// ownership.
%warnfilter(454) TProgram::application;
%warnfilter(454) TProgram::statusLine;
%warnfilter(454) TProgram::menuBar;
%warnfilter(454) TProgram::deskTop;

// We will replace insertion methods in TProgram with variants which disown their inputs. This is
// because, after these are called, TProgram will be responsible for delete-ing its children.
%ignore TProgram::insertWindow;
%ignore TProgram::executeDialog;
%rename(insertWindow) TProgram::insertWindow_disowning;
%rename(executeDialog) TProgram::executeDialog_disowning;

%feature("director");

%inline {
// Command used to signal a Python exception happened.
const ushort cmException = 50;
}

%{
static PyObject* bailType = NULL;
static PyObject* bailValue = NULL;
static PyObject* bailTraceback = NULL;

static void bailFromRun() {
  // If there's no current application, the best we can do is throw.
  if(!TProgram::application) {
    throw Swig::DirectorMethodException();
  }

  // Otherwise we can raise from run().
  if(bailType) { Py_DECREF(bailType); }
  if(bailValue) { Py_DECREF(bailValue); }
  if(bailTraceback) { Py_DECREF(bailTraceback); }
  PyErr_Fetch(&bailType, &bailValue, &bailTraceback);
  PyErr_Clear();

  // endModal will signal that run should exit. The exception handler will then re-raise if bail...
  // variables are non-NULL.
  TProgram::application->endModal(cmException);
}
%}

%exception TProgram::run {
  $action
  if(bailType && bailValue && bailTraceback) {
    PyErr_Restore(bailType, bailValue, bailTraceback);
    bailType = bailValue = bailTraceback = NULL;
    SWIG_fail;
  }
}

%include "tvision/app.h"

%inline {
  class TApplication_ : public TApplication {
  public:
    TApplication_() { }
    virtual ~TApplication_() { }
  };
}

%extend TProgram {
  %apply void* DISOWN { TWindow* };
  %apply void* DISOWN { TDialog* };

  virtual TWindow* insertWindow_disowning(TWindow* win) {
    return $self->insertWindow(win);
  }

  virtual ushort executeDialog_disowning(TDialog* pD, void* data = NULL) {
    return $self->executeDialog(pD, data);
  }
}

%feature("director", "");

%pythoncode "application.py"
