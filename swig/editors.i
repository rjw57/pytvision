%ignore TEditor::clipboard;
%extend TEditor {
  TEditor* getClipboard() { return $self->clipboard; }
}
// TODO:
%ignore TEditor::formatLine;
%ignore TEditor::formatCell;
%ignore TEditor::initContextMenu;

%feature("director");
%include "tvision/editors.h"
%feature("director", "");
