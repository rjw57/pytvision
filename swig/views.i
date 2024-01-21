%rename(TWindow_) TWindow;

// For write_args we need to avoid a reserved word.
%rename(self_) write_args::self;

%ignore TPalette::operator =;
%ignore TPalette::operator [];

%ignore TView::read;
%ignore TView::write;

// TODO:
%feature("nodirector") TView::mapColor;

// We will replace insertion methods in TGroup with variants which disown their inputs. This is
// because, after insertion, TGroup will be responsible for delete-ing its children.
%ignore TGroup::insert;
%rename(insert) TGroup::insert_disowning;
%ignore TGroup::insertBefore;
%rename(insertBefore) TGroup::insertBefore_disowning;

// TODO: unwrappable operators.
%ignore TCommandSet;

// TODO: returns pointers/referencees
%ignore TView::getPalette;
%ignore TWindow::title;
%ignore TWindow::getTitle;

%feature("director");
%include "tvision/views.h"
%feature("director", "");

%extend TGroup {
  // Special typemap which disowns views passed to the methods we define below if the argument is
  // named "view".
  %typemap(in) TView* view {
    if (!SWIG_IsOK(SWIG_ConvertPtr($input, (void **) &$1, $1_descriptor, SWIG_POINTER_DISOWN))) {
      SWIG_exception_fail(SWIG_TypeError, "in method '$symname', expecting type TView");
    }
  }

  void insert_disowning(TView *view) {
    $self->insert(view);
  }

  void insertBefore_disowning(TView *p, TView *view) {
    $self->insertBefore(p, view);
  }
}

%pythoncode "views.py"
