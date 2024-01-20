# Python bindings for tvision

## Building

```console
$ cmake -B ./build -DCMAKE_BUILD_TYPE=Release .
$ cmake --build ./build --parallel
$ PYTHONPATH=./build/swig python tvdemo.py
```
