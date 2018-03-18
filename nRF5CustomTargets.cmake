



macro(nRF5GenerateOtherArtifacts TARGET)

    # Build artifact will have no suffix unless we set it.  Not runnable on host.
    # Set the suffix to what "file" cmd says: .elf
    set_target_properties(${TARGET} PROPERTIES SUFFIX ".elf")
    
    set(EXECUTABLE_FILE "${TARGET}.elf")

    # link flags tell linker to generate a .map artifact
    #set_target_properties(${TARGET} PROPERTIES LINK_FLAGS "-Wl,-Map=${TARGET}.map")
    # in cmake, link options are set using target_link_libraries
    target_link_libraries(${TARGET} INTERFACE "-Wl,-Map=${TARGET}.map")

    # additional POST BUILD setps to create other file encodings ( .bin and .hex) files
    # since nrfjprog only takes a .hex
    add_custom_command(TARGET ${TARGET}
            POST_BUILD
            COMMAND ${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-size ${EXECUTABLE_FILE}
            # Really don't need a .bin?  Other flash tools may support .bin?
            #COMMAND ${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-objcopy -O binary ${EXECUTABLE_FILE} "${TARGET}.bin"
            COMMAND ${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-objcopy -O ihex ${EXECUTABLE_FILE} "${TARGET}.hex"
            COMMENT "post build steps for ${TARGET}"
            )
endmacro()





# add custom targets to flash  to embedded device:
#  cross-built target
#  softdevice (distributed in binary)
#  erase

# Using family unknown is slower but reduces complexity of scripts and increases robustness
# nrfjprog has no command to return the chip model number
# for "-f unknown" nrfjprog determinines the chip

macro(nRF5AddCustomTargets TARGET)

    # This has issues with excaped blanks: set(FAMILY_STRING "")

    add_custom_target("FLASH_${TARGET}" ALL
            COMMAND ${NRFJPROG} --program ${TARGET}.hex ${FAMILY_STRING} --sectorerase
            COMMAND sleep 0.5s
            COMMAND ${NRFJPROG} --reset -f unknown
            DEPENDS ${TARGET}
            COMMENT "flashing ${TARGET}.hex"
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
