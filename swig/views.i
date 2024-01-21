%rename(TWindow_) TWindow;

// For write_args we need to avoid a reserved word.
%rename(self_) write_args::self;

%ignore TPalette::operator =;
%ignore TPalette::operator [];

%ignore TView::read;
%ignore TView::write;

// We will replace insertion methods in TGroup with variants which disown their inputs. This is
// because, after insertion, TGroup will be responsible for delete-ing its children.
%ignore TGroup::insert;
%ignore TGroup::insertBefore;
%ignore TGroup::insertView;

// Ignore unwrappable operators
%ignore operator & (const TCommandSet&, const TCommandSet&);
%ignore operator | (const TCommandSet&, const TCommandSet&);

// TODO: returns pointers/referencees
%ignore TView::getPalette;
%ignore TWindow::title;
%ignore TWindow::getTitle;

%feature("director");

%include "tvision/views.h"

// "Unignore" TGroup methods which disown their input since we re-implement them below.
%rename("%s") TGroup::insert;
%rename("%s") TGroup::insertBefore;
%rename("%s") TGroup::insertView;

%extend TGroup {
  %apply void* DISOWN { TView* view };

  void insertView(TView *view, TView* Target) {
    $self->insertView(view, Target);
  }

  void insert(TView *view) {
    $self->insert(view);
  }

  void insertBefore(TView *view, TView *Target) {
    $self->insertBefore(view, Target);
  }
}

%feature("director", "");

%pythoncode "views.py"
