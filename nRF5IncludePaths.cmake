

# Set include_directories that are not specific to a softdevice or device family

macro(nRF5SetIncludePaths)
    # basic board definitions and drivers
    include_directories(
            "${NRF5_SDK_PATH}/components/boards"
            "${NRF5_SDK_PATH}/components/device"
            "${NRF5_SDK_PATH}/components/libraries/util"
            "${NRF5_SDK_PATH}/components/drivers_nrf/hal"
            "${NRF5_SDK_PATH}/components/drivers_nrf/common"
            "${NRF5_SDK_PATH}/components/drivers_nrf/delay"
            "${NRF5_SDK_PATH}/components/drivers_nrf/uart"
            "${NRF5_SDK_PATH}/components/drivers_nrf/clock"
            "${NRF5_SDK_PATH}/components/drivers_nrf/rtc"
            "${NRF5_SDK_PATH}/components/drivers_nrf/gpiote"
    )

    # toolchain specyfic
    include_directories(
            "${NRF5_SDK_PATH}/components/toolchain/"
            "${NRF5_SDK_PATH}/components/toolchain/gcc"
            "${NRF5_SDK_PATH}/components/toolchain/cmsis/include"
    )

    # log
    include_directories(
            "${NRF5_SDK_PATH}/components/libraries/log"
            "${NRF5_SDK_PATH}/components/libraries/log/src"
            "${NRF5_SDK_PATH}/components/libraries/timer"
    )

    # Segger RTT
    include_directories(
            "${NRF5_SDK_PATH}/external/segger_rtt/"
    )

    
    # Common Bluetooth Low Energy files
    include_directories(
            "${NRF5_SDK_PATH}/components/ble"
            "${NRF5_SDK_PATH}/components/ble/common"
    )

    # Common to all softdevices
    include_directories(
            "${NRF5_SDK_PATH}/components/softdevice/common"
    )

endmacro()





# Set target_include_directories that ARE specific to a softdevice

# !!! Uses target_include_directories i.e. target is a parameter.
# Must be invoked AFTER target is declared

# This encapsulates knowledge of the SDK dir structure, which could change

macro(nRF5SetSoftdeviceIncludePaths TARGET SOFTDEVICE )
    message("SOFTDEVICE is ${SOFTDEVICE} ")
    if (${SOFTDEVICE} MATCHES "s132")
        set(RESULT
                "${NRF5_SDK_PATH}/components/softdevice/s132/headers"
                "${NRF5_SDK_PATH}/components/softdevice/s132/headers/nrf52"
        )
    elseif (${SOFTDEVICE} MATCHES "s112")
         set(RESULT
                "${NRF5_SDK_PATH}/components/softdevice/s112/headers"
                "${NRF5_SDK_PATH}/components/softdevice/s112/headers/nrf52"
        )
    elseif (${SOFTDEVICE} MATCHES "s130")
         set(RESULT
                "${NRF5_SDK_PATH}/components/softdevice/s130/headers"
                "${NRF5_SDK_PATH}/components/softdevice/s130/headers/nrf51"
        )
    else()
        message("No SOFTDEVICE defined, include path to soc_nosd ")
        set(RESULT
                "${NRF5_SDK_PATH}/components/drivers_nrf/nrf_soc_nosd"
        )
    endif()

    message("Target ${TARGET} include path to SD ${SOFTDEVICE}: ${RESULT}")
    target_include_directories( ${TARGET} PUBLIC ${RESULT})
endmacro()




