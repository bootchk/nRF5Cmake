
# macros to list optional sets of sources and include paths
# E.g. RTT is optional

# copied from CMake_nRF5x repository



# adds NRF_LOG
# sdk_config.h>NRF_LOG_ENABLED

macro(nRF5x_addNRF_LOG)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/log/src/"
    )
    
    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/libraries/log/src/nrf_log_backend_serial.c"
            "${NRF5_SDK_PATH}/components/libraries/log/src/nrf_log_frontend.c"
            )

endmacro(nRF5x_addNRF_LOG)


# adds Segger RTT
# sdk_config.h>NRF_LOG_BACKEND_RTT_ENABLED
macro(nRF5x_addRTT)
    include_directories(
            "${NRF5_SDK_PATH}/external/segger_rtt"
    )
    
    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/external/segger_rtt/RTT_Syscalls_GCC.c"
            "${NRF5_SDK_PATH}/external/segger_rtt/SEGGER_RTT.c"
            "${NRF5_SDK_PATH}/external/segger_rtt/SEGGER_RTT_printf.c"
            )

endmacro(nRF5x_addRTT)


# adds app-level scheduler library
macro(nRF5x_addAppScheduler)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/scheduler"
    )

    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/libraries/scheduler/app_scheduler.c"
            "${NRF5_SDK_PATH}/components/softdevice/common/softdevice_handler/softdevice_handler_appsh.c"
            )

endmacro(nRF5x_addAppScheduler)

# adds app-level FIFO libraries
macro(nRF5x_addAppFIFO)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/fifo"
    )

    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/libraries/fifo/app_fifo.c"
            )

endmacro(nRF5x_addAppFIFO)

# adds app-level Timer libraries
macro(nRF5x_addAppTimer)
    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/libraries/timer/app_timer.c"
            )
endmacro(nRF5x_addAppTimer)

# adds app-level UART libraries
macro(nRF5x_addAppUART)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/uart"
    )

    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/libraries/uart/app_uart_fifo.c"
            )

endmacro(nRF5x_addAppUART)

# adds app-level Button library
macro(nRF5x_addAppButton)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/button"
    )

    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/libraries/button/app_button.c"
            )

endmacro(nRF5x_addAppButton)

# adds BSP (board support package) library
macro(nRF5x_addBSP WITH_BLE_BTN WITH_ANT_BTN WITH_NFC)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/bsp"
    )

    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/libraries/bsp/bsp.c"
            )

    if (${WITH_BLE_BTN})
        list(APPEND SDK_SOURCES
                "${NRF5_SDK_PATH}/components/libraries/bsp/bsp_btn_ble.c"
                )
    endif ()

    if (${WITH_ANT_BTN})
        list(APPEND SDK_SOURCES
                "${NRF5_SDK_PATH}/components/libraries/bsp/bsp_btn_ant.c"
                )
    endif ()

    if (${WITH_NFC})
        list(APPEND SDK_SOURCES
                "${NRF5_SDK_PATH}/components/libraries/bsp/bsp_nfc.c"
                )
    endif ()

endmacro(nRF5x_addBSP)

# adds Bluetooth Low Energy GATT support library
macro(nRF5x_addBLEGATT)
    include_directories(
            "${NRF5_SDK_PATH}/components/ble/nrf_ble_gatt"
    )

    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/ble/nrf_ble_gatt/nrf_ble_gatt.c"
            )

endmacro(nRF5x_addBLEGATT)

# adds Bluetooth Low Energy advertising support library
macro(nRF5x_addBLEAdvertising)
    include_directories(
            "${NRF5_SDK_PATH}/components/ble/ble_advertising"
    )

    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/ble/ble_advertising/ble_advertising.c"
            )

endmacro(nRF5x_addBLEAdvertising)

# adds Bluetooth Low Energy advertising support library
macro(nRF5x_addBLEPeerManager)
    include_directories(
            "${NRF5_SDK_PATH}/components/ble/peer_manager"
    )

    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/ble/peer_manager/gatt_cache_manager.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/gatts_cache_manager.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/id_manager.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/peer_data.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/peer_data_storage.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/peer_database.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/peer_id.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/peer_manager.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/pm_buffer.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/pm_mutex.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/security_dispatcher.c"
            "${NRF5_SDK_PATH}/components/ble/peer_manager/security_manager.c"
            )

endmacro(nRF5x_addBLEPeerManager)

# adds app-level FDS (flash data storage) library
macro(nRF5x_addAppFDS)
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/fds"
            "${NRF5_SDK_PATH}/components/libraries/fstorage"
            "${NRF5_SDK_PATH}/components/libraries/experimental_section_vars"
    )

    list(APPEND SDK_SOURCES
            "${NRF5_SDK_PATH}/components/libraries/fds/fds.c"
            "${NRF5_SDK_PATH}/components/libraries/fstorage/fstorage.c"
            )

endmacro(nRF5x_addAppFDS)
