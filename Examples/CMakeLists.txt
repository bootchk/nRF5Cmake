
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

add_executable(Foo "")
set_target_properties( Foo
    PROPERTIES
       CHIP "nrf52832_xxaa"
       SOFTDEVICE "s132"
       FLOAT_ABI "soft"
    )
nRF5CheckTargetProperties(Foo)
# Set paths and other definitions ON the executable target
nRF5ConfigTargetByProperties(Foo)
nRF5SetTargetStartupSources(Foo)
nRF5SetTargetsLinkerScript(Foo "${CMAKE_SOURCE_DIR}/gcc_nrf52.ld")

target_sources(Foo
   PUBLIC
      main.cpp
      "${SDK_SOURCES}"
   )

nRF5GenerateOtherArtifacts(Foo)
nRF5AddCustomTargets(Foo)















