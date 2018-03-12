



macro(nRF5GenerateOtherArtifacts EXECUTABLE_NAME)

    # artifact is .exe.  Not runnable on host.
    # Really don't need to change the suffix
    set_target_properties(${EXECUTABLE_NAME} PROPERTIES SUFFIX ".out")

    # link flags tell linker to generate a .map artifact
    set_target_properties(${EXECUTABLE_NAME} PROPERTIES LINK_FLAGS "-Wl,-Map=${EXECUTABLE_NAME}.map")

    # additional POST BUILD setps to create other file encodings ( .bin and .hex) files
    # since nrfjprog only takes a .hex
    add_custom_command(TARGET ${EXECUTABLE_NAME}
            POST_BUILD
            COMMAND ${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-size ${EXECUTABLE_NAME}.out
            # Really don't need a .bin?  Other flash tools may support .bin?
            #COMMAND ${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-objcopy -O binary ${EXECUTABLE_NAME}.out "${EXECUTABLE_NAME}.bin"
            COMMAND ${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-objcopy -O ihex ${EXECUTABLE_NAME}.out "${EXECUTABLE_NAME}.hex"
            COMMENT "post build steps for ${EXECUTABLE_NAME}"
            )
endmacro()





# add custom targets to flash  to embedded device:
#  cross-built target
#  softdevice (distributed in binary)
#  erase

# Using family unknown is slower but reduces complexity of scripts and increases robustness
# nrfjprog has no command to return the chip model number
# for "-f unknown" nrfjprog determinines the chip

macro(nRF5AddCustomTargets EXECUTABLE_NAME)

    # This has issues with excaped blanks: set(FAMILY_STRING "")

    add_custom_target("FLASH_${EXECUTABLE_NAME}" ALL
            COMMAND ${NRFJPROG} --program ${EXECUTABLE_NAME}.hex ${FAMILY_STRING} --sectorerase
            COMMAND sleep 0.5s
            COMMAND ${NRFJPROG} --reset -f unknown
            DEPENDS ${EXECUTABLE_NAME}
            COMMENT "flashing ${EXECUTABLE_NAME}.hex"
            )

   add_custom_target(FLASH_SOFTDEVICE ALL
            COMMAND ${NRFJPROG} --program ${SOFTDEVICE_PATH} -f unknown --sectorerase
            COMMAND sleep 0.5s
            COMMAND ${NRFJPROG} --reset -f unknown
            COMMENT "flashing SoftDevice"
            )

    add_custom_target(FLASH_ERASE ALL
            COMMAND ${NRFJPROG} --eraseall -f unknown
            COMMENT "erasing flashing"
            )

endmacro()
