
# macros that define lists of source files

# These append to list:
#    SDK_SOURCES : in an executable or a library
# Startup files are added to target.
# This is different design from original cmake-nrf5x scripts




# Startup files
# !!! Not appending to same list as other macros
# Instead, adding to a target
macro(nRF5SetTargetStartupSources TARGET)

    get_target_property(CHIP ${TARGET} CHIP)
    if (CHIP MATCHES "nrf51")
	set(RESULT 
                "${NRF5_SDK_PATH}/components/toolchain/system_nrf51.c"
                "${NRF5_SDK_PATH}/components/toolchain/gcc/gcc_startup_nrf51.S"
           )
    elseif (CHIP MATCHES "nrf52832_xxaa")
        set(RESULT 
                "${NRF5_SDK_PATH}/components/toolchain/system_nrf52.c"
                "${NRF5_SDK_PATH}/components/toolchain/gcc/gcc_startup_nrf52.S"
           )
    elseif (CHIP MATCHES "nrf52810_xxaa")
        set(RESULT 
                "${NRF5_SDK_PATH}/components/toolchain/system_nrf52810.c"
                "${NRF5_SDK_PATH}/components/toolchain/gcc/gcc_startup_nrf52810.S"
           )
    elseif (CHIP MATCHES "nrf52810e")
        set(RESULT 
                "${NRF5_SDK_PATH}/components/toolchain/system_nrf52810.c"
                "${NRF5_SDK_PATH}/components/toolchain/gcc/gcc_startup_nrf52810.S"
           )
    else ()
         message("???No startup files for chip: ${CHIP}.")
    endif()
    message("Target ${TARGET} startup sources for chip ${CHIP}: ${RESULT}")
    target_sources( ${TARGET} PUBLIC ${RESULT} )
endmacro()




# Softdevice handler
# Required if SD compatible drivers used
macro(nRF5SDKSourcesSDH)
        list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/softdevice/common/nrf_sdh.c"
            )
endmacro()


# utils
# required for SD and SD compatible drivers

# another SDK file required for RTT
macro(nRF5SetTargetRTTUtilSources TARGET)

    set(RESULT
            "${NRF5_SDK_PATH}/components/libraries/util/app_util_platform.c"
            )
    message("Target ${TARGET} util sources: ${RESULT}")
    target_sources( ${TARGET} PUBLIC ${RESULT} )
endmacro()

# OLD implementation
macro(nRF5SDKSourcesUtils)

    # "${NRF5_SDK_PATH}/components/libraries/util/sdk_errors.c"
    
    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/libraries/hardfault/hardfault_implementation.c"
            "${NRF5_SDK_PATH}/components/libraries/util/nrf_assert.c"
            "${NRF5_SDK_PATH}/components/libraries/util/app_error.c"
            "${NRF5_SDK_PATH}/components/libraries/util/app_error_weak.c"
            "${NRF5_SDK_PATH}/components/libraries/util/app_util_platform.c"
            "${NRF5_SDK_PATH}/components/libraries/util/app_util_platform.c"
            "${NRF5_SDK_PATH}/components/libraries/util/sdk_mapped_flags.c"
            )    
endmacro()



# API to BLE functions of SD
macro(nRF5SDKSourcesBLE)
     # Optional for capability: negotiate connection params
     # sdk_config.h>NRF_BLE_CONN_PARAMS_ENABLED
     # "${NRF5_SDK_PATH}/components/ble/common/ble_conn_params.c"

    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/ble/common/ble_advdata.c"
            "${NRF5_SDK_PATH}/components/ble/common/ble_conn_state.c"
            "${NRF5_SDK_PATH}/components/ble/common/ble_srv_common.c"
            )   
endmacro()


# board support
# apparently conditionally compiled so no change to text size if no board is defined
macro(nRF5SDKSourcesBSP)
    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/boards/boards.c"
            )
endmacro()

# SD compatible drivers
# common is required by all drivers
macro(nRF5SDKSourcesDrivers)
    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/drivers_nrf/common/nrf_drv_common.c"
            # "${NRF5_SDK_PATH}/components/drivers_nrf/clock/nrf_drv_clock.c"
            #"${NRF5_SDK_PATH}/components/drivers_nrf/uart/nrf_drv_uart.c"
            #"${NRF5_SDK_PATH}/components/drivers_nrf/rtc/nrf_drv_rtc.c"
            #"${NRF5_SDK_PATH}/components/drivers_nrf/gpiote/nrf_drv_gpiote.c"
            )
endmacro()



# Basic i.e. required for most builds with SoftDevice
# e.g. when Softdevice and SD compatible drivers used
# !!! Not nRF5SDKSourcesStartup(), you must invoke that macro separately and add SDK_SOURCES_STARTUP to target_sources
macro(nRF5SetSDKSourcesBasic)
    nRF5SDKSourcesSDH()
    nRF5SDKSourcesDrivers()
    nRF5SDKSourcesUtils()
endmacro()

