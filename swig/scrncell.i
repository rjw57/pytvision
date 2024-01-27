%rename(at) TCellChar::operator[];

%extend TScreenCell {
  void assign(TScreenCell *other) { *($self) = *other; }
}

%include "tvision/scrncell.h"
