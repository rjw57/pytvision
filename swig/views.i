%ignore TView::getColor;
%ignore TView::genRefs;
%ignore TView::mapColor;

%feature("director") TView;
%feature("director") TFrame;
%feature("director") TScrollBar;
%feature("director") TScroller;
%feature("director") TListViewer;
%feature("director") TGroup;

// TODO:
%feature("nodirector") TView::mapColor;
%feature("nodirector") TWindow;

// We will replace insertion methods in TGroup with variants which disown their inputs. This is
// because, after insertion, TGroup will be responsible for delete-ing its children.
%ignore TGroup::insert;
%rename(insert) TGroup::insert_disowning;
%ignore TGroup::insertBefore;
%rename(insertBefore) TGroup::insertBefore_disowning;

%include "tvision/views.h"

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
