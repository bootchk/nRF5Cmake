
cmake_minimum_required (VERSION 2.6)

project (example C CXX ASM)

# cmake includes modules from here
# !!! only for simple names without the .cmake suffix
# TODO append
set(CMAKE_MODULE_PATH "/home/bootch/git/nRF5Cmake")
message(" Module path is ${CMAKE_MODULE_PATH}")

# environment (location of NRF_SDK and other tools)
# i.e. file CMakeEnv.cmake on the MODULE_PATH
include("CMakeEnv")

include("nRF5")


# v14.2 sources and includes already defined
# TODO fix this

# vars that configure scripts
set(NRF_TARGET "nrf52")
set(NRF_SOFTDEVICE "s132")
# TODO version of SD

nRF5CheckSetupPreconditions()
nRF5SetBuildOptions()
nRF5SetIncludePaths()

# Here, modify or call additional macros
# according to what you are building (library, or minimal executable, or BLE executable, or multiprotocol)
nRF5SetSDKSourcesBasic()

# Define SDK_SOURCES_STARTUP
nRF5SDKSourcesStartup()

add_executable(Foo "")

target_sources(Foo
   PUBLIC
      main.cpp
      "${SDK_SOURCES}"
      "${SDK_SOURCES_STARTUP}"
   )

nRF5SetSoftdeviceIncludePaths(Foo "s132")

nRF5GenerateOtherArtifacts(Foo)
nRF5AddCustomTargets(Foo)















