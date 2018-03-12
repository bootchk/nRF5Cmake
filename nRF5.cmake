
# Include scripts that define macros
include("nRF5Sanity")
include("nRF5SetBuildOptions")
include("nRF5Sources")
include("nRF5SourcesOptional")
include("nRF5IncludePaths")
include("nRF5CustomTargets")
include("nRF5SoftdeviceDefines")

# SDK version specific headers and sources
include("CMake_nRF5x_v14_2")


# Ensure
# SDKSources not empty
# SDKIncludes not empty
# SOFTDEVICE_PATH is set

