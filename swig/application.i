%rename(TApplicationBase) TApplication;
%rename(TDeskTop_) TDeskTop;

// Direct pointer access is dangerous. We only set these in wrapper classes which are careful with
// ownership.
%warnfilter(454) TProgram::application;
%warnfilter(454) TProgram::statusLine;
%warnfilter(454) TProgram::menuBar;
%warnfilter(454) TProgram::deskTop;

%ignore TProgram::insertWindow;
%rename(insertWindow) TProgram::insertWindow_disowning;

%feature("director");

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
  TEvent event;
  event.what = evCommand;
  event.message.command = cmQuit;
  TProgram::application->putEvent(event);
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

  virtual TWindow* insertWindow_disowning(TWindow* win) {
    return $self->insertWindow(win);
  }
}

%feature("director", "");

%pythoncode "application.py"
