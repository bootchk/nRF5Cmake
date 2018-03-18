
# check caller set necessary items
# - toolchain SDK and tools paths.
# - properties on target
# - linker script

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

# tool paths

if (NOT ARM_NONE_EABI_TOOLCHAIN_PATH)
    message(FATAL_ERROR "The path to the arm-none-eabi-gcc toolchain (ARM_NONE_EABI_TOOLCHAIN_PATH) must be set.")
endif ()


if (NOT NRF5_SDK_PATH)
    message(FATAL_ERROR "The path to the nRF5 SDK (NRF5_SDK_PATH) must be set.")
endif ()


if (NOT NRFJPROG)
    message(FATAL_ERROR "The path to the nrfjprog utility (NRFJPROG) must be set.")
endif ()

endmacro()



macro(nRF5CheckTargetProperties TARGET)
# check properties set on target

# Obsolete NRF_FAMILY actually declares architecture M4 vs M0, and nothing more

get_target_property(CHIP ${TARGET} CHIP)
if (CHIP MATCHES "nrf52832_xxaa")

elseif (CHIP MATCHES "nrf52810_xxaa")

elseif (CHIP MATCHES "nrf52810e")

elseif (CHIP MATCHES "unknown")
    message(FATAL_ERROR "${TARGET} lacks CHIP property.")
else ()
    message(FATAL_ERROR "${CHIP} not supported.")
endif ()


get_target_property(SOFTDEVICE ${TARGET} SOFTDEVICE)
if (SOFTDEVICE MATCHES "s132")

elseif (SOFTDEVICE MATCHES "s112")

elseif (SOFTDEVICE MATCHES "none")

elseif (SOFTDEVICE MATCHES "unknown")
    message(FATAL_ERROR "${TARGET} lacks property: SOFTDEVICE .")
else ()
    message(FATAL_ERROR "${SOFTDEVICE} not supported.")
endif ()


get_target_property(FLOAT_ABI ${TARGET} FLOAT_ABI)
if (FLOAT_ABI MATCHES "soft")

elseif (FLOAT_ABI MATCHES "hard")

elseif (FLOAT_ABI MATCHES "unknown")
    message(FATAL_ERROR "${TARGET} lacks property: FLOAT_ABI.")
else ()
    message(FATAL_ERROR "${FLOAT_ABI} not supported.")
endif ()


# TODO this check should be on the target property, after other macros
#if (NOT NRF5_LINKER_SCRIPT)
    # not fatal if building library
    #message("NRF5_LINKER_SCRIPT is not defined")
# endif ()

endmacro()

