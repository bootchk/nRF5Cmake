
# Set properties on target that vary with CHIP and SOFTDEVICE
# Require properties CHIP and SOFTDEVICE already set on target
# Not setting global variable, setting properties on given target.



# TODO not exhaustive, and actually nrf51 is family but means 51422, etc.

# TODO don't know if the 52810 defs are correct
# Note the 52810 uses dev kit 52DK having 52832 as emulator

# BOARD is hardcoded to the DK board

# example makefiles for 52832 use DNRF52_PAN_74 and nothing else?  Most are for peripherals I am not interested in.

macro(nRF5SetTargetsCompileDefinitionsByChip TARGET CHIP )
    
    if (${CHIP} MATCHES "nrf51")
        set( RESULT 
             -DBOARD_PCA10028 -DNRF51 -DNRF51422
        )
    elseif (${CHIP} MATCHES "nrf52832_xxaa")
        set( RESULT 
                -DNRF52832_XXAA -DNRF52_PAN_64 -DNRF52_PAN_12 -DNRF52_PAN_58 -DNRF52_PAN_54 -DNRF52_PAN_31 -DNRF52_PAN_51 -DNRF52_PAN_36 -DNRF52_PAN_15 -DNRF52_PAN_20 -DNRF52_PAN_55 -DBOARD_PCA10040
        )
    elseif (${CHIP} MATCHES "nrf52810_xxaa")
        # TODO PAN
        set( RESULT 
                -DNRF52810_XXAA -DBOARD_PCA10040
        )
    elseif (${CHIP} MATCHES "nrf52810e")
        set( RESULT 
                -DNRF52810_XXAA -DDEVELOP_IN_NRF52832 -DBOARD_PCA10040
        )
    else()
        message("???No compiler definitions specific to chip: ${CHIP}. ")
    endif()

    target_compile_definitions( ${TARGET} PUBLIC ${RESULT} )
    message("Target: ${TARGET} compiler defs for chip ${CHIP}: ${RESULT}")
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
    target_compile_options( ${TARGET} PUBLIC ${RESULT} )

    # TODO configurable
    target_compile_options( ${TARGET} PUBLIC "-mfloat-abi=soft" )

    # TODO message get compiler options from target
    message("Target: ${TARGET} compiler options for chip ${CHIP}: ${RESULT}")
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
    message("Target ${TARGET} linker script: ${SCRIPT}")
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

   get_target_property(SD ${TARGET} SOFTDEVICE)
   nRF5SetSoftdeviceIncludePaths( ${TARGET} ${SD})
   nRF5SetSoftdeviceDefinitions( ${TARGET} ${SD})

   get_target_property(NRFCHIP ${TARGET} CHIP)
   nRF5SetTargetsCompileDefinitionsByChip(${TARGET} ${NRFCHIP})
   nRF5SetTargetsCompileOptionsByChip(${TARGET} ${NRFCHIP})

   #TODO FLOAT_ABI, currently always soft

   # We don't need a path to Softdevice hex to build target, only for target "FLASH_SOFTDEVICE"

endmacro()
