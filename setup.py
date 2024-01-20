import sys
from pathlib import Path

import cmake_build_extension
import setuptools

setuptools.setup(
    ext_modules=[
        cmake_build_extension.CMakeExtension(
            name="pytvision",
            source_dir=str(Path(__file__).parent.absolute()),
            cmake_configure_options=[
                # This option points CMake to the right Python interpreter, and helps the logic of
                # FindPython3.cmake to find the active version
                f"-DPython3_ROOT_DIR={Path(sys.prefix)}",
            ],
            cmake_component="pytvision",
        ),
    ],
    cmdclass=dict(
        build_ext=cmake_build_extension.BuildExtension,
    ),
)
