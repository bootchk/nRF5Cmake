
# check caller set necessary vars
# - toolchain SDK and tools paths.
# - config vars
# - linker script

# set vars referenced by CMake_nRF5x macros
# nowhere are the valid combinations checked.
# Typically:
#  nrf52 nrf52832 s132 [soft,hard]
#  nrf52 nrf52810 s112 soft
#  nrf52 nrf52810e s112 soft	emulation on nrf52832

# Note that optimization is always off, not a var
# Note that the valid combinations could be more programmed, and fully supported.

# set(NRF_FAMILY ["nrf52", "nrf51")
# set(CHIP ["nrf52832_xxaa", "nrf52810_xxaa", "nrf52810e"])
# set(SOFTDEVICE ["s132", "s112"])
# set(FLOAT_ABI ["soft", "hard"])


macro(nRF5CheckSetupPreconditions)

# tools

if (NOT ARM_NONE_EABI_TOOLCHAIN_PATH)
    message(FATAL_ERROR "The path to the arm-none-eabi-gcc toolchain (ARM_NONE_EABI_TOOLCHAIN_PATH) must be set.")
endif ()


if (NOT NRF5_SDK_PATH)
    message(FATAL_ERROR "The path to the nRF5 SDK (NRF5_SDK_PATH) must be set.")
endif ()


if (NOT NRFJPROG)
    message(FATAL_ERROR "The path to the nrfjprog utility (NRFJPROG) must be set.")
endif ()


# check config vars set

# This actually declares architecture M4 vs M0, and nothing more
if (NRF_FAMILY MATCHES "nrf51")

elseif (NRF_FAMILY MATCHES "nrf52")

elseif (NOT NRF_FAMILY)
    message(FATAL_ERROR "NRF_FAMILY must be defined to nrf51 or nrf52")
else ()
    message(FATAL_ERROR "${NRF_FAMILY} not supported.")
endif ()



if (CHIP MATCHES "nrf52832_xxaa")

elseif (CHIP MATCHES "nrf52810_xxaa")

elseif (CHIP MATCHES "nrf52810e")

elseif (NOT CHIP)
    message(FATAL_ERROR "CHIP must be defined")
else ()
    message(FATAL_ERROR "${CHIP} not supported.")
endif ()



if (SOFTDEVICE MATCHES "s132")

elseif (SOFTDEVICE MATCHES "s112")

elseif (SOFTDEVICE MATCHES "none")

elseif (NOT SOFTDEVICE)
    message(FATAL_ERROR "SOFTDEVICE must be defined")
else ()
    message(FATAL_ERROR "${SOFTDEVICE} not supported.")
endif ()



if (FLOAT_ABI MATCHES "soft")

elseif (FLOAT_ABI MATCHES "hard")

elseif (NOT FLOAT_ABI)
    message(FATAL_ERROR "FLOAT_ABI must be defined")
else ()
    message(FATAL_ERROR "${FLOAT_ABI} not supported.")
endif ()




if (NOT NRF5_LINKER_SCRIPT)
    message(FATAL_ERROR "NRF5_LINKER_SCRIPT must be defined")
endif ()

endmacro()

