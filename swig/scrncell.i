%rename(at) TCellChar::operator[];

%extend TScreenCell {
  void assign(TColorAttr *a) { (*$self) = *a; }
}

%include "tvision/scrncell.h"
