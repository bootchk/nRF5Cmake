
# a "toolchain file" that cmake understands. See cmake docs.

# Strongly recommended by cmake org when cross-compiling.

# pass to cmake commands with -DCMAKE_TOOLCHAIN_FILE=<path>/toolchain-gnu-arm.cmake

# If you change this file, delete the build directory and regenerate it





set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)


# GNU Arm tools have a defined prefix: "arm-none-eabi-"


# >>> custom to local installation
# where GNU Arm toolchain is installed
# the toolchain includes tools (to run on the host) AND library/headers (such as newlib) specific to the target
set(ARM_TOOLCHAIN_DIR /home/bootch/gcc-arm-none-eabi-6-2017-q2-update)

# GNU Arm tools are in bin dir and have certain prefix
set(TOOLCHAIN_PREFIX ${ARM_TOOLCHAIN_DIR}/bin/arm-none-eabi-)



# Without this, CMake is not able to pass test compilation check
set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nosys.specs")



# define cmake variables for complete path to each tool in the GNU Arm set of tools
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}gcc)
# C compiler also is the assembler
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}objcopy CACHE INTERNAL "objcopy tool")
set(CMAKE_SIZE_UTIL ${TOOLCHAIN_PREFIX}size CACHE INTERNAL "size tool")




# adjust the default behaviour of the FIND_XXX() commands:

# List directories to search for target artifacts
# If you build libraries for the target and "install" them to a directory in the target "root", you should include a path to them here
set(CMAKE_FIND_ROOT_PATH ${ARM_TOOLCHAIN_DIR})

# NEVER search for programs in the target root (they would not run on the host)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# ONLY search for target libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)






