
# Source specific to an SDK version
# SDK 14.2 changes

 # Softdevice handler requires these
 include_directories(
            "${NRF5_SDK_PATH}/components/libraries/experimental_log"
            "${NRF5_SDK_PATH}/components/libraries/experimental_log/src"
            "${NRF5_SDK_PATH}/components/libraries/experimental_memobj"
            "${NRF5_SDK_PATH}/components/libraries/balloc"
            "${NRF5_SDK_PATH}/components/libraries/strerror"
    )
 
 # "experimental" seems to suggest not fully supported by Nordic
 
 
 
 # Paths needed
 set(NRF5_SDK_SECTION "${NRF5_SDK_PATH}/components/libraries/experimental_section_vars")
 set(NRF5_SDK_SD_COMMON "${NRF5_SDK_PATH}/components/softdevice/common")
 set(NRF5_SDK_BLE_GATT "${NRF5_SDK_PATH}/components/ble/nrf_ble_gatt")
 
 # support for manipulating ASM section vars
 # used by new SD init() to calculate memory reqt
 
 include_directories(
       "${NRF5_SDK_SECTION}"
 )

 list(APPEND SDK_SOURCES
       "${NRF5_SDK_SECTION}/nrf_section_iter.c"
 )
 
 
 
 # source files new to 14.2 ?
 list(APPEND SDK_SOURCES
       "${NRF5_SDK_SD_COMMON}/nrf_sdh_ble.c"
       "${NRF5_SDK_BLE_GATT}/nrf_ble_gatt.c"
 )
 
 # some headers have moved to /ble ?
 include_directories(
       "${NRF5_SDK_BLE_GATT}"
 )
 
 
 
 
