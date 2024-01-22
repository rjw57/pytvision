cmake_policy(SET CMP0078 NEW)
cmake_policy(SET CMP0086 NEW)

find_package(SWIG 4.0 REQUIRED COMPONENTS python)
find_package(Python 3.6 REQUIRED COMPONENTS Development.Module)

include(UseSWIG)

list(APPEND CMAKE_SWIG_FLAGS -dirvtable -builtin)
set_property(SOURCE pytvision.i PROPERTY CPLUSPLUS ON)
set_property(SOURCE pytvision.i PROPERTY DEPENDS
  all_uses.hpp
  application.i
  application.py
  colors.i
  dialogs.i
  menu.py
  menus.i
  scrncell.i
  system.i
  typemaps.i
  views.i
  views.py
)
swig_add_library(pytvision TYPE MODULE LANGUAGE python SOURCES pytvision.i)

set_property(TARGET pytvision PROPERTY SWIG_USE_TARGET_INCLUDE_DIRECTORIES TRUE)
tv_add_private_includes(pytvision)
target_include_directories(
  pytvision
  PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
  PUBLIC ${Python_INCLUDE_DIRS}
)
target_link_libraries(pytvision
  PUBLIC tvision Python::Module
)

get_property(WRAPPER_PY_FILE
  TARGET pytvision
  PROPERTY SWIG_SUPPORT_FILES
)

install(
  FILES ${WRAPPER_PY_FILE}
  DESTINATION ${CMAKE_INSTALL_PREFIX}
  COMPONENT pytvision
)

install(
 TARGETS pytvision
 COMPONENT pytvision
 LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}
 ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}
 RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}
)
