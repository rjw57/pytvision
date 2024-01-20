// TODO: handle TDeskInit
%feature("nodirector") TDeskTop;

%rename(TApplication_) TApplication;

%include "tvision/app.h"

%pythoncode "application.py"
