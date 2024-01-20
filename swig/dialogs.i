// TODO: getters
%ignore TButton::title;
%ignore TSItem::value;

%feature("nodirector") THistory;
%feature("nodirector") THistoryWindow;
%feature("nodirector") TParamText;

%feature("director");
%include "tvision/dialogs.h"
%feature("director", "");
