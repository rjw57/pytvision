// Implicit str -> TStringView
%typemap(typecheck, precedence=SWIG_TYPECHECK_UNISTRING) TStringView {
  $1 = (($input == Py_None) || (PyUnicode_Check($input))) ? 1 : 0;
}

%typemap(in) TStringView {
  if($input == Py_None) {
    $1 = NULL;
  } else if(PyUnicode_Check($input)) {
    $1 = TStringView(PyUnicode_AsUTF8($input));
    if(PyErr_Occurred()) {
      SWIG_fail;
    }
  } else {
    SWIG_exception_fail(SWIG_TypeError, "in method '$symname', expecting type str or None");
  }
}

// Implicit int -> TKey
%typemap(typecheck, precedence=SWIG_TYPECHECK_POINTER) TKey {
  if(PyLong_Check($input)) {
    $1 = 1;
  } else {
    void *vptr = 0;
    int res = SWIG_ConvertPtr($input, &vptr, $1_descriptor, 0);
    $1 = SWIG_IsOK(res) ? 1 : 0;
  }
}

%typemap(in) TKey {
  if (!SWIG_IsOK(SWIG_ConvertPtr($input, (void **) &$1, $1_descriptor, 0))) {
    if(PyLong_Check($input)) {
      $1 = TKey((ushort)PyLong_AsLong($input));
      if(PyErr_Occurred()) {
        SWIG_fail;
      }
    } else {
      SWIG_exception_fail(SWIG_TypeError, "in method '$symname', expecting type '$1_type'");
    }
  }
}

// String sequence -> TSItem
%typemap(typecheck) TSItem *aStrings {
  $1 = PySequence_Check($input) ? 1 : 0;
}

%typemap(in) TSItem *aStrings {
  if (!PySequence_Check($input)) {
    PyErr_SetString(PyExc_TypeError, "in method '$symname', expecting a sequence of strings");
    SWIG_fail;
  }

  $1 = NULL;
  for(Py_ssize_t i=PyObject_Length($input)-1; i >= 0; --i) {
    PyObject* item = PySequence_GetItem($input, i);
    if(!item || !PyUnicode_Check(item)) {
      PyErr_SetString(PyExc_TypeError, "in method '$symname', expecting a sequence of strings");
      Py_DECREF(item);
      SWIG_fail;
    }
    $1 = new TSItem(PyUnicode_AsUTF8(item), $1);
    Py_DECREF(item);
  }
}

// Special typemap which disowns passed objects both via thisown and __disown__() if the object is a
// director.
%typemap(in) void* DISOWN {
  if (!SWIG_IsOK(SWIG_ConvertPtr($input, (void **) &$1, $1_descriptor, SWIG_POINTER_DISOWN))) {
    SWIG_exception_fail(SWIG_TypeError, "in method '$symname', expecting type $n_type");
  } else {
    Swig::Director *d = SWIG_DIRECTOR_CAST($1);
    if(d) { d->swig_disown(); }
  }
}
