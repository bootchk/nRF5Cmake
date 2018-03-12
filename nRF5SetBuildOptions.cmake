

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


# TODO not exhaustive, and actually nrf51 is family but means 51422, etc.

# TODO don't know if the 52810 defs are correct
# Note the 52810 uses dev kit 52DK having 52832 as emulator

macro(nRF5SetChipCompileDefinitions TARGET CHIP )
    
    if (${CHIP} MATCHES "nrf51")
        set( RESULT 
             -DBOARD_PCA10028 -DNRF51 -DNRF51422
        )
    elseif (${CHIP} MATCHES "nrf52832")
        set( RESULT 
                -DNRF52 -DNRF52832 -DNRF52_PAN_64 -DNRF52_PAN_12 -DNRF52_PAN_58 -DNRF52_PAN_54 -DNRF52_PAN_31 -DNRF52_PAN_51 -DNRF52_PAN_36 -DNRF52_PAN_15 -DNRF52_PAN_20 -DNRF52_PAN_55 -DBOARD_PCA10040
        )
    elseif (${CHIP} MATCHES "nrf52810")
        set( RESULT 
                -DNRF52 -DNRF52810 -DNRF52_PAN_64 -DNRF52_PAN_12 -DNRF52_PAN_58 -DNRF52_PAN_54 -DNRF52_PAN_31 -DNRF52_PAN_51 -DNRF52_PAN_36 -DNRF52_PAN_15 -DNRF52_PAN_20 -DNRF52_PAN_55 -DBOARD_PCA10040
        )
    else()
        message("No compiler definitions specific to chip: ${CHIP}. ")
    endif()

    target_compile_definitions( ${TARGET} PUBLIC ${RESULT} )
    message("Compiler definitions specific to chip ${CHIP}: ${RESULT}")
endmacro()


# Function to set var for CPU_FLAGS
# CPU_FLAGS is passed to compiler and linker
# Distinct from FPU_FLAGS

# TODO make this so it can be set on a target

# !!! The result is a single string, not a list of strings

function(nRF5SetChipCPUFlags VAR CHIP )
    
    if (${CHIP} MATCHES "nrf51")
        set( RESULT  "-mcpu=cortex-m0" )
    elseif (${CHIP} MATCHES "nrf52832")
        set( RESULT  "-mcpu=cortex-m4" )
    elseif (${CHIP} MATCHES "nrf52810")
        set( RESULT   "-mcpu=cortex-m4" )
    else()
        message("No compiler options specific to family: ${CHIP}. ")
    endif()

    # This is not sufficient, since linker also needs flags: target_compile_options( ${TARGET} PUBLIC ${RESULT} )
    set(${VAR} "${RESULT}" PARENT_SCOPE)    # Set the named variable in caller's scope
    message("CPU_FLAGS specific to chip ${CHIP}: ${RESULT}")
endfunction()



function(nRF5SetChipFPUFlags VAR FLOAT_ABI )
    
    if (${FLOAT_ABI} MATCHES "soft")
        set( RESULT  "-mfloat-abi=soft" )
    elseif (${CHIP} MATCHES "hard")
        set( RESULT "mfloat-abi=hard -mfpu=fpv4-sp-d16" )
    else()
        message("No compiler options specific to float ABI: ${FLOAT_ABI}. ")
    endif()

    # This is not sufficient, since linker also needs flags: target_compile_options( ${TARGET} PUBLIC ${RESULT} )
    set(${VAR} "${RESULT}" PARENT_SCOPE)    # Set the named variable in caller's scope
    message("FPU_FLAGS specific to float ABI ${FLOAT_ABI}: ${RESULT}")
endfunction()


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

    # configure cmake to use the arm-none-eabi-gcc
    set(CMAKE_C_COMPILER "${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc")
    set(CMAKE_CXX_COMPILER "${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-c++")
    set(CMAKE_ASM_COMPILER "${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc")

    nRF5SetChipCPUFlags(CPU_FLAGS ${CHIP})
    nRF5SetChipFPUFlags(FPU_FLAGS ${FLOAT_ABI})

    set(COMMON_FLAGS "-MP -MD -mthumb -mabi=aapcs -Wall -Werror -O3 -g3 -ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin --short-enums ${CPU_FLAGS} ${FPU_FLAGS}")

    # compiler/assambler/linker flags
    set(CMAKE_C_FLAGS "${COMMON_FLAGS}")
    set(CMAKE_CXX_FLAGS "${COMMON_FLAGS}")
    set(CMAKE_ASM_FLAGS "-MP -MD -std=c99 -x assembler-with-cpp")
    set(CMAKE_EXE_LINKER_FLAGS "-mthumb -mabi=aapcs -std=gnu++98 -std=c99 -L ${NRF5_SDK_PATH}/components/toolchain/gcc -T${NRF5_LINKER_SCRIPT} ${CPU_FLAGS} ${FPU_FLAGS} -Wl,--gc-sections --specs=nano.specs -lc -lnosys -lm")
    # note: we must override the default cmake linker flags so that CMAKE_C_FLAGS are not added implicitly
    # lkk: added LINK_LIBRARIES
    set(CMAKE_C_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -o <TARGET>")
    set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -lstdc++ -o <TARGET> <LINK_LIBRARIES>")

    # lkk hack?? to prevent -rdynamic
    SET(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
    SET(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
    message("Linker flags ${CMAKE_EXE_LINKER_FLAGS}")
    message("Shared link flags ${CMAKE_SHARED_LIBRARY_LINK_C_FLAGS}")



    # TODO move this?
    include_directories(".")

endmacro()
