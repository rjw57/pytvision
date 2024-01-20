%feature("director") TProgram;
%feature("director") TApplication;
%rename(TApplication_) TApplication;

// TODO: handle TDeskInit
%feature("nodirector") TDeskTop;

%include "tvision/app.h"

%pythoncode "application.py"
