
nRF5Cmake


Cmake scripts for building using nRF5 SDK for Nordic SoC 5x family.

Acknowledgements and motivation
-

Derived from https://github.com/Polidea/cmake-nRF5x.git
Changes are to divide a monolithic (one file) script into many scripts.
More generic: support building libraries instead of just an executable.
More generic: configurable for SDK version and Softdevice version.
Easier to find where to make changes: each macro has a single concern.

Lightly tested with:
     SDK 14.2
     NRF52832 and s132 version 5.0.1
     NRF52810 and s112

Discussion
-

One contribution is that these scripts are intended to be declarative.
Cmake has evolved to be more declarative (using target_<foo> commands) but it is easy to use an old style: set vars, making non-declarative scripts that only have targets for a specific chip.
Here, configuration is done not by setting vars, but by setting properties on targets, and then using target_<foo> commands based on the target's properties.

Specifically, you set properties CHIP and SOFTDEVICE on a target foo, and then call nRF5ConfigTargetByProperties(foo).
Thus in the same CMakeLists.txt, you can target both the 52832 chip and the 52810 chip.


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

I am not recommending any of these, just pointing to other projects which use nrf5-sdk and cmake.

     the Nordic BLE Mesh project, which uses cmake.
     mbed cmake
     https://github.com/Polidea/cmake-nRF5x.git
     https://github.com/ryankurte/nrf52-base.git
     https://github.com/Jumperr-labs/nrf5-sdk-clion.git
     https://github.com/alexvanboxel/eddystone_nrf5x_beacon.git




