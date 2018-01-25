
nRF5Cmake


Cmake scripts for building using nRF5SDK for Nordic SoC 5x family.

Acknowledgements and motivation
-

Derived from https://github.com/Polidea/cmake-nRF5x.git
Changes are to divide a monolithic (one file) script into many scripts.
To support building libraries instead of just an executable.
So it is easier to find where to make changes.
For future flexibility: other SDK versions and SD versions.
(Lightly tested with SDK 14.2, NRF52, and s132 version 5.0.1)

Example
-

See Examples/CMakeList.txt for how to use.

To build the example

     cd Examples
     mkdir build
     # regenerate the build system
     cmake -H. -B"build"
     # build
     cmake --build "build" --target Foo
     

The files in the example are the absolute minimum required for these scripts to produce a null executable.
Their contents is also minimal:

    linker script
    main.cpp
    sdk_config.h  to configure conditional compile of SDK files

Other examples are some of my other Github projects that use these scripts.

Also see
-

     the Nordic BLE Mesh project, which uses cmake.
     mbed cmake




