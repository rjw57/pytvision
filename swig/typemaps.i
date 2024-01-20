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
      SWIG_exception_fail(SWIG_TypeError, "in method '$symname', expecting type Foo");
    }
  }
}

