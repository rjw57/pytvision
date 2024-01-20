cmake_policy(SET CMP0078 NEW)
cmake_policy(SET CMP0086 NEW)

find_package(SWIG 4.0 REQUIRED COMPONENTS python)
find_package(Python 3.8 REQUIRED COMPONENTS Development)

include(UseSWIG)

list(APPEND CMAKE_SWIG_FLAGS -py3 -dirvtable -O -builtin)
set_property(SOURCE pytvision.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE pytvision.i PROPERTY DEPENDS
  application.i
  menus.i

  all_uses.hpp

  application.py
  menu.py
)
swig_add_library(pytvision TYPE SHARED LANGUAGE python SOURCES pytvision.i)

set_property(TARGET pytvision PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES TRUE)
tv_add_private_includes(pytvision)
target_include_directories(
  pytvision
  PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
  PUBLIC ${Python_INCLUDE_DIRS}
)
target_link_libraries(pytvision
  PUBLIC tvision ${Python_LIBRARIES}
)
