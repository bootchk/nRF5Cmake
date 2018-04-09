
# Set properties on target that vary with CHIP and SOFTDEVICE
# Require properties CHIP and SOFTDEVICE already set on target
# Not setting global variable, setting properties on given target.

# !!! Properties should mostly be PRIVATE (since PUBLIC properties would be visible to targets higher in build tree)
# i.e. we are not communicating upwards usually.



# TODO not exhaustive, and actually nrf51 is family but means 51422, etc.

# TODO don't know if the 52810 defs are correct
# Note the 52810 uses dev kit 52DK having 52832 as emulator

# BOARD is not always set !!!!  Because this decision is separate, responsibility of user
# Also, setting a board circularly defines the chip in some Nordic include files?

# example makefiles for 52832 use DNRF52_PAN_74 and nothing else?  Most are for peripherals I am not interested in.

macro(nRF5SetTargetsCompileDefinitionsByChip TARGET CHIP )
    
    if (${CHIP} MATCHES "nrf51")
        set( RESULT 
             -DNRF51 -DNRF51422 -DNRF51_SERIES
        )
    elseif (${CHIP} MATCHES "nrf52832_xxaa")
        set( RESULT 
                -DNRF52832_XXAA -DNRF52_SERIES -DNRF52_PAN_64 -DNRF52_PAN_12 -DNRF52_PAN_58 -DNRF52_PAN_54 -DNRF52_PAN_31 -DNRF52_PAN_51 -DNRF52_PAN_36 -DNRF52_PAN_15 -DNRF52_PAN_20 -DNRF52_PAN_55
        )
    elseif (${CHIP} MATCHES "nrf52810_xxaa")
        # TODO PAN
        set( RESULT 
                -DNRF52810_XXAA -DNRF52_SERIES
        )
    elseif (${CHIP} MATCHES "nrf52810e")
        # !!! Emulation is specific to the NRF52DK board
        set( RESULT 
                -DNRF52810_XXAA -DNRF52_SERIES -DDEVELOP_IN_NRF52832 -DBOARD_PCA10040
        )
    else()
        message("???No compiler definitions specific to chip: ${CHIP}. ")
    endif()

    target_compile_definitions( ${TARGET} PRIVATE ${RESULT} )
    message("Target: ${TARGET}, chip: ${CHIP}, compiler defs: ${RESULT}")
endmacro()



macro(nRF5SetTargetsCompileOptionsByChip TARGET CHIP )
    if (${CHIP} MATCHES "nrf51")
        set( RESULT  "-mcpu=cortex-m0" )
    elseif (${CHIP} MATCHES "nrf52832_xxaa")
        set( RESULT  "-mcpu=cortex-m4" )
    elseif (${CHIP} MATCHES "nrf52810_xxaa")
        set( RESULT   "-mcpu=cortex-m4" )
    elseif (${CHIP} MATCHES "nrf52810e")
        set( RESULT   "-mcpu=cortex-m4" )
    else()
        message("???No compiler options specific to family: ${CHIP}. ")
    endif()

    # !!! Set on compiler and linker
    target_compile_options( ${TARGET} PRIVATE ${RESULT} )
    target_link_libraries( ${TARGET} PRIVATE ${RESULT} )

    # TODO configurable
    target_compile_options( ${TARGET} PRIVATE "-mfloat-abi=soft" )

    message("Target: ${TARGET}, chip: ${CHIP}, compile options: ${RESULT}")
endmacro()



macro(nRF5SetTargetsLinkerScript TARGET SCRIPT )
    # !!! Obscure that target_link_libraries sets flags also
    target_link_libraries( ${TARGET} PUBLIC "-T ${SCRIPT}" )
    # target_link_libraries( ${TARGET} "-T${SCRIPT}" )
    # Make build depend on linker script
    set_target_properties(${TARGET} PROPERTIES LINK_DEPENDS ${SCRIPT})

    # This stuff also doesn't work(?), retained as documentation
    #set_target_properties( ${TARGET} PROPERTIES LINK_FLAGS "-T ${SCRIPT}" )
    #get_target_property(TMP ${TARGET} LINK_FLAGS)
    #message("Linker script for ${TARGET}: ${TMP}")

    # TODO message get compiler options from target
    
    message("Target: ${TARGET}, linker script: ${SCRIPT}")
endmacro()


# Check for common (Nordic) board defs in target_compile_definitions.
# User responsible for target_compile_options(BOARD_<foo>)
# These scripts do NOT set a BOARD definition
macro( nRF5CheckTargetsBoardDefinitions TARGET )
    get_target_property(targetCompileDefs ${TARGET} COMPILE_DEFINITIONS)
    
    set(BOARD BOARD_PCA10040)
    list(FIND targetCompileDefs ${BOARD} result)
    if (result LESS 0)
        set(BOARD BOARD_PCA10028)
	list(FIND targetCompileDefs ${BOARD} result)
        if (result LESS 0)
           # TODO search list regex "BOARD_.*"
           set(BOARD "Unknown i.e. not a Nordic board")
        endif()
    endif()
    message("Target: ${TARGET}, board: ${BOARD}")
endmacro()



#OBSOLETE
# Function to set var for CPU_FLAGS
# CPU_FLAGS is passed to compiler and linker
# Distinct from FPU_FLAGS

# TODO make this so it can be set on a target

# !!! The result is a single string, not a list of strings

function(nRF5SetChipCPUFlags VAR CHIP )
    
    if (${CHIP} MATCHES "nrf51")
        set( RESULT  "-mcpu=cortex-m0" )
    elseif (${CHIP} MATCHES "nrf52832_xxaa")
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


#OBSOLETE
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



macro(nRF5ConfigTargetByProperties TARGET)

   # print blank line ahead of specs for target.  Each subroutine prints its specs
   message("\nnRF5Cmake specs for target:  ${TARGET}")
   get_target_property(SD ${TARGET} SOFTDEVICE)
   nRF5SetSoftdeviceIncludePaths( ${TARGET} ${SD})
   nRF5SetSoftdeviceDefinitions( ${TARGET} ${SD})

   get_target_property(NRFCHIP ${TARGET} CHIP)
   nRF5SetTargetsCompileDefinitionsByChip(${TARGET} ${NRFCHIP})
   nRF5SetTargetsCompileOptionsByChip(${TARGET} ${NRFCHIP})

   nRF5CheckTargetsBoardDefinitions(${TARGET})

   #TODO FLOAT_ABI, currently always soft

   # message total properties, omitting CFLAGS not specific to target
   get_target_property(VALUE ${TARGET} "COMPILE_OPTIONS")
   message("Target: ${TARGET}, total COMPILE_OPTIONS: ${VALUE}")
   get_target_property(VALUE ${TARGET} "LINK_LIBRARIES")
   message("Target: ${TARGET}, total LINK_LIBRARIES: ${VALUE}")
   message("!!! Other compile options not specific to target also exist, e.g. -mthumb")

   # We don't need a path to Softdevice hex to build target, only for target "FLASH_SOFTDEVICE"

endmacro()
