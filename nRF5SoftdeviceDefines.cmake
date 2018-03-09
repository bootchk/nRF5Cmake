
# declares compiler definitions for a target specific to a softdevice

# # !!! Uses target_compile_definitions i.e. target is a parameter.
# Must be invoked AFTER target is declared

# This encapsulates knowledge of names used in the SDK, which could change

# Also, it hardcodes the API versions as of the time of this writing


macro(nRF5SetSoftdeviceDefinitions TARGET SOFTDEVICE )

if (${SOFTDEVICE} MATCHES "s132")
        set( RESULT 
             -DSOFTDEVICE_PRESENT -DS132 -DBLE_STACK_SUPPORT_REQD -DNRF_SD_BLE_API_VERSION=5
        )
    elseif (${SOFTDEVICE} MATCHES "s112")
        set( RESULT 
                -DSOFTDEVICE_PRESENT -DS112 -DBLE_STACK_SUPPORT_REQD -DNRF_SD_BLE_API_VERSION=5
        )
    elseif (${SOFTDEVICE} MATCHES "s130")
        set( RESULT 
                -DSOFTDEVICE_PRESENT -DS130 -DNRF_SD_BLE_API_VERSION=2 -DSWI_DISABLE0 -DBLE_STACK_SUPPORT_REQD
        )
    else()
        message("No compiler definitions specific to softdevice: ${SOFTDEVICE}. ")
    endif()

    target_compile_definitions( ${TARGET} PUBLIC ${RESULT} )
    message("Compiler definitions specific to Softdevice ${SOFTDEVICE}: ${RESULT}")
endmacro()




# Functions that set passed vars to Softdevice specific values

# Can and should be called multiple times, just before you use the vars

# hardcoded as of this writing


# Used to define custom targets FLASH_SOFTDEVICE_<foo>

function(nRF5SetSoftdevicePaths VAR SOFTDEVICE )
    if (${SOFTDEVICE} MATCHES "s132")
        set(RESULT "${NRF5_SDK_PATH}/components/softdevice/s132/hex/s132_nrf52_5.0.0_softdevice.hex")
    elseif (SOFTDEVICE MATCHES "s112")
        set(RESULT "${NRF5_SDK_PATH}/components/softdevice/s112/hex/s112_nrf52810_5.1.0_softdevice.hex")
    elseif (SOFTDEVICE MATCHES "s130")
        set(RESULT "${NRF5_SDK_PATH}/components/softdevice/s130/hex/s130_nrf51_2.0.1_softdevice.hex")
    else()
        message("No SOFTDEVICE defined, no path specific to softdevice. ")
	set(RESULT "")
    endif()
    set(${VAR} "${RESULT}" PARENT_SCOPE)    # Set the named variable in caller's scope
    message("Path to softdevice hex: ${RESULT} ")
endfunction()


# Used to define vars passed to target_link_libraries, as a linker flag 

# The SDK contains default linker scripts, specific to softdevice
# (loading the app above the Softdevice)

# Another version of this sets linker scripts to a canonically named script in the user's source i.e. customized by user

# !!! Currently doesn't work: the linker script it references leads to linker errors: undefined reference to `__start_sdh_req_observers'
# Instead just set(NRF5_LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/gcc_nrf52.ld") where the .ld is one you have magically created

function(nRF5SetSoftdeviceLinkerScript VAR SOFTDEVICE )
    message("Path to softdevice hex pat specific to Softdevice ${SOFTDEVICE} ")
    if (${SOFTDEVICE} MATCHES "s132")
        set(RESULT "${NRF5_SDK_PATH}/components/softdevice/s132/toolchain/armgcc/armgcc_s132_nrf52832_xxaa.ld")
    elseif (SOFTDEVICE MATCHES "s112")
        set(RESULT "${NRF5_SDK_PATH}/components/softdevice/s112/toolchain/armgcc/armgcc_s112_nrf52810_xxaa.ld")
    elseif (SOFTDEVICE MATCHES "s130")
        message("SDK 14.2 no longer supports s130 or nrf51 ")
    else()
        message("No SOFTDEVICE defined, no linker script specific to softdevice. ")
	set(RESULT "")
    endif()
    set(${VAR} "${RESULT}" PARENT_SCOPE)    # Set the named variable in caller's scope
    message("Path to softdevice specific linker script: ${RESULT} ")
endfunction()
