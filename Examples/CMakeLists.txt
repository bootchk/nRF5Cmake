
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

# SDK v14.2 sources and includes defined
# TODO fix this by making it vary with CHIP


#set(NRF5_LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/gcc_nrf52.ld")

nRF5CheckSetupPreconditions()
nRF5SetBuildOptions()
nRF5SetIncludePaths()

# Here, modify or call additional macros
# according to what you are building (library, or minimal executable, or BLE executable, or multiprotocol)
nRF5SetSDKSourcesBasic()


# Executable without Softdevice
add_executable(Foo "")
set_target_properties( Foo
    PROPERTIES
       CHIP "nrf52832_xxaa"
       SOFTDEVICE "none"
       FLOAT_ABI "soft"
    )
nRF5CheckTargetProperties(Foo)
# Set paths and other definitions ON the executable target
nRF5ConfigTargetByProperties(Foo)
nRF5SetTargetStartupSources(Foo)
nRF5SetTargetsLinkerScript(Foo "${CMAKE_SOURCE_DIR}/gcc_nrf52_noSD.ld")

# Note we use define no SDK sources here, but startup sources from SDK are already defined on target
target_sources(Foo
   PUBLIC
      main.cpp
   )


# executable with Softdevice
add_executable(FooSD "")
set_target_properties( FooSD
    PROPERTIES
       CHIP "nrf52832_xxaa"
       SOFTDEVICE "s132"
       FLOAT_ABI "soft"
    )
nRF5CheckTargetProperties(FooSD)
# Set paths and other definitions ON the executable target
nRF5ConfigTargetByProperties(FooSD)
nRF5SetTargetStartupSources(FooSD)
nRF5SetTargetsLinkerScript(FooSD "${CMAKE_SOURCE_DIR}/gcc_nrf52_SD.ld")

target_sources(FooSD
   PUBLIC
      main.cpp
      "${SDK_SOURCES}"
   )


nRF5GenerateOtherArtifacts(Foo)
nRF5GenerateOtherArtifacts(FooSD)



nRF5AddCustomTargets(Foo)















