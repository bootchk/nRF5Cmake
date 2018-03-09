
# check caller set necessary toolchain SDK and tools paths.
macro(nRF5CheckSetupPreconditions)

if (NOT ARM_NONE_EABI_TOOLCHAIN_PATH)
    message(FATAL_ERROR "The path to the arm-none-eabi-gcc toolchain (ARM_NONE_EABI_TOOLCHAIN_PATH) must be set.")
endif ()


if (NOT NRF5_SDK_PATH)
    message(FATAL_ERROR "The path to the nRF5 SDK (NRF5_SDK_PATH) must be set.")
endif ()



if (NOT NRFJPROG)
    message(FATAL_ERROR "The path to the nrfjprog utility (NRFJPROG) must be set.")
endif ()


# check nRF target has been set
if (NRF_FAMILY MATCHES "nrf51")

elseif (NRF_FAMILY MATCHES "nrf52")

elseif (NOT NRF_FAMILY)
    message(FATAL_ERROR "NRF_FAMILY must be defined to nrf51 or nrf52")
else ()
    message(FATAL_ERROR "Only nRF51 and rRF52 boards are supported right now")
endif ()

endmacro()

