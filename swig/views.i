%include "pybuffer.i"

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

// We'll replace the data methods with ones which make use of the Python buffer protocol.
%ignore TGroup::setData;
%ignore TGroup::getData;

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

// "Unignore" data methods.
%rename("%s") TGroup::setData;
%rename("%s") TGroup::getData;

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

  %pybuffer_mutable_binary(uint8_t *rec, size_t rec_size);

  %exception TGroup::getData {
    try {
      $action
    } catch (std::length_error&) {
      PyErr_SetString(PyExc_ValueError, "Buffer is too small");
      SWIG_fail;
    }
  }

  virtual void getData(uint8_t *rec, size_t rec_size) {
    if(rec_size < $self->dataSize()) {
      throw std::length_error("Buffer not large enough");
    }
    $self->getData(rec);
  }

  %exception TGroup::setData {
    try {
      $action
    } catch (std::length_error&) {
      PyErr_SetString(PyExc_ValueError, "Buffer is too small");
      SWIG_fail;
    }
  }

  virtual void setData(uint8_t *rec, size_t rec_size) {
    if(rec_size < $self->dataSize()) {
      throw std::length_error("Buffer not large enough");
    }
    $self->getData(rec);
    $self->setData(rec);
  }
}

%feature("director", "");

%pythoncode "views.py"
