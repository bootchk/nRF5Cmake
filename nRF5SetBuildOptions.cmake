

# set compiler options, definitions, and linker flags etc.
# This should have only that purpose, and not to list source files or include paths

# Family is nrf51 or nrf52
# Chip is nrf52832 or nrf52810,  chips for nrf51 family incomplete
# Softdevice is s112 or s132, others incomplete



#Obsolete but kept as documentation of the original
# Instead use: nRF5SetChipDefinitions(), nRF5SetTargetCompileOptions(), and nRF5SetSoftdeviceDefinitions
# each specific to a target
#
#macro(nRF5SetSoftdeviceOptions)

# Softdevice is specific to a chip family
# But family to Softdevice is one-to-many

#if (NRF_SOFTDEVICE MATCHES "s130")
#   set(NRF5_LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/gcc_nrf51.ld")
#   add_definitions(-DSOFTDEVICE_PRESENT -DS130 -DNRF_SD_BLE_API_VERSION=2 -DSWI_DISABLE0 -DBLE_STACK_SUPPORT_REQD)
#   set(SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s130/hex/s130_nrf51_2.0.1_softdevice.hex")
#elseif (NRF_SOFTDEVICE MATCHES "s132")
#    set(NRF5_LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/gcc_nrf52.ld")
#    add_definitions(-DSOFTDEVICE_PRESENT -DS132 -DBLE_STACK_SUPPORT_REQD -DNRF_SD_BLE_API_VERSION=5)
#    set(SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s132/hex/s132_nrf52_5.0.0_softdevice.hex")     
#else()
#   message("Building without Softdevice")
#   set(NRF5_LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/gcc_nrf52NoSD.ld")
#endif()
#
#endmacro()





# None of this is Softdevice specific or target family (51 or 52) specific
# However, you must call nRF5SetSoftdeviceLinkerScript(NRF5_LINKER_SCRIPT "s132") prior
# And you must call

macro(nRF5SetBuildOptions)
    # fix on macOS: prevent cmake from adding implicit parameters to Xcode
    set(CMAKE_OSX_SYSROOT "/")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "")

    # language standard/version settings
    set(CMAKE_C_STANDARD 99)
    # 98, 11, or 14
    set(CMAKE_CXX_STANDARD 14)

    # OBSOLETE: now done in a "toolchain file" because it plays better with add_subdirectory
    # configure cmake to use the arm-none-eabi-gcc
    #set(CMAKE_C_COMPILER "${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc")
    #set(CMAKE_CXX_COMPILER "${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-c++")
    #set(CMAKE_ASM_COMPILER "${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc")

    # CPU_FLAGS and FPU_FLAGS are set on target properties

    # TODO optimization flags a var
    # For really verbose compiling, add "-v" here
    set(COMMON_FLAGS "-MP -MD -mthumb -mabi=aapcs -Wall -Werror -O0 -g3 -ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin --short-enums")
    # append flags so c++ is lightweight
    set(COMMON_CXX_FLAGS "-fno-exceptions -fno-rtti -fno-use-cxa-atexit -fno-threadsafe-statics")
    # WAS also: ${CPU_FLAGS} ${FPU_FLAGS}")

    # compiler/assambler/linker flags
    set(CMAKE_C_FLAGS "${COMMON_FLAGS}")
    set(CMAKE_CXX_FLAGS "${COMMON_FLAGS} ${COMMON_CXX_FLAGS}")
    set(CMAKE_ASM_FLAGS "-MP -MD -std=c99 -x assembler-with-cpp")

    # ORIGINALLY: set(CMAKE_EXE_LINKER_FLAGS "-mthumb -mabi=aapcs -std=gnu++98 -std=c99 -L ${NRF5_SDK_PATH}/components/toolchain/gcc -T${NRF5_LINKER_SCRIPT} ${CPU_FLAGS} ${FPU_FLAGS} -Wl,--gc-sections --specs=nano.specs -lc -lnosys -lm")
    # elided "-lc, -lnosys, -lm" => --specs=nosys.specs : I don't use libm and libc is redundant to nano.specs
    # added -nodefaultlibs
    
    # Note path to linker scripts.  Default ones are not generally useful, but nrf52_common.ld is there, and most custom linker scripts include it.
    # See elsewhere for setting linker script on target
    set(LINK_SCRIPT_PATH ${NRF5_SDK_PATH}/components/toolchain/gcc)

    # using specs=nosys.specs doesn't seem to work.  See "nosys.specs in newlib 2.20" seems to indicate bug
    #set(CMAKE_EXE_LINKER_FLAGS "-mthumb -mabi=aapcs -std=gnu++98 -std=c99 -nodefaultlibs -L {LINK_SCRIPT_PATH}  -Wl,--gc-sections --specs=nano.specs --specs=nosys.specs")

    #set(CMAKE_EXE_LINKER_FLAGS "-mthumb -mabi=aapcs -std=gnu++98 -std=c99 -nodefaultlibs -L ${LINK_SCRIPT_PATH} -Wl,--gc-sections --specs=nano.specs -lc -lnosys")
    # w/o -std
    #set(CMAKE_EXE_LINKER_FLAGS "-mthumb -mabi=aapcs -nodefaultlibs -L ${LINK_SCRIPT_PATH} -Wl,--gc-sections --specs=nano.specs -lc -lnosys")
    # --specs=nosys.specs
    set(CMAKE_EXE_LINKER_FLAGS "-mthumb -mabi=aapcs -nodefaultlibs -L ${LINK_SCRIPT_PATH} -Wl,--gc-sections --specs=nano.specs --specs=nosys.specs")

    # Other linker artifacts (Map and other encodings such as hex) are specified elsewhere.  See nRF5CustomTargets.cmake, nRF5GenerateOtherArtifacts

    # note: we must override the default cmake linker flags so that CMAKE_C_FLAGS are not added implicitly
    # lkk: added LINK_LIBRARIES
    #set(CMAKE_C_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -o <TARGET>")
    #set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -lstdc++ -o <TARGET> <LINK_LIBRARIES>")
    #set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
    #set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")

    # lkk hack?? to prevent -rdynamic
    SET(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
    SET(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
    message("Linker flags ${CMAKE_EXE_LINKER_FLAGS}")
    message("Shared link flags ${CMAKE_SHARED_LIBRARY_LINK_C_FLAGS}")

    # TODO move this?
    include_directories(".")

endmacro()
