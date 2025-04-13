cmake_minimum_required(VERSION 3.15)
project(main LANGUAGES CXX)

# ---------------------------
# Directory Setup
# ---------------------------
# Create the bin directory directly in the source tree for output.
# This deviates from strict out-of-source principles for convenience.
file(MAKE_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)
message(STATUS "Output directory set to: ${PROJECT_SOURCE_DIR}/bin (inside source tree)")

# ---------------------------
# Build Configuration
# ---------------------------
# Set default build type with clear feedback
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the build type: Debug, Release" FORCE)
    message(STATUS "Build type not specified - defaulting to ${CMAKE_BUILD_TYPE}")
endif()

# Configure output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

# ---------------------------
# File Discovery
# ---------------------------
# Find source files with multiple extensions
message(STATUS "Searching for source files in: ${PROJECT_SOURCE_DIR}/src")
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
    "${PROJECT_SOURCE_DIR}/src/*.cpp"
    "${PROJECT_SOURCE_DIR}/src/*.cc"
    "${PROJECT_SOURCE_DIR}/src/*.cxx"
)
file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS
    "${PROJECT_SOURCE_DIR}/src/*.h"
    "${PROJECT_SOURCE_DIR}/src/*.hpp"
    "${PROJECT_SOURCE_DIR}/src/*.hxx"
)

# ---------------------------
# File Discovery Feedback
# ---------------------------
if(NOT SOURCES)
    message(FATAL_ERROR "No source files found in '${PROJECT_SOURCE_DIR}/src'.")
endif()

message(STATUS "Source Files Found:")
foreach(source ${SOURCES})
    file(RELATIVE_PATH rel_source ${PROJECT_SOURCE_DIR} ${source})
    message(STATUS " - ${rel_source}")
endforeach()

# message(STATUS "Source Files Found:")
# if(SOURCES)
#     foreach(source ${SOURCES})
#         file(RELATIVE_PATH rel_source ${PROJECT_SOURCE_DIR} ${source})
#         message(STATUS " - ${rel_source}")
#     endforeach()
# else()
#     message(WARNING " No source files found in src directory!")
#     message(FATAL_ERROR "No Source files found in '${PROJECT_SOURCE_DIR}/src'.")
# endif()
#
# message(STATUS "\nHeader Files Found:")
# if(HEADERS)
#     foreach(header ${HEADERS})
#         file(RELATIVE_PATH rel_header ${PROJECT_SOURCE_DIR} ${header})
#         message(STATUS " - ${rel_source}")
#     endforeach()
# else()
#     message(WARNING "No Header files found in '${PROJECT_SOURCE_DIR}/src'.")
# endif()

# ---------------------------
# Target Configuration
# ---------------------------
# Create executable with all sources and headers
add_executable(${PROJECT_NAME}
    ${SOURCES}
    ${HEADERS}  # For IDE integration
)

# Include directories
target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_SOURCE_DIR}/src
)

# C++ standard configuration
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Apply C++ standard to the target
set_target_properties(${PROJECT_NAME} PROPERTIES
    CXX_STANDARD ${CMAKE_CXX_STANDARD}
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)

# ---------------------------
# Compiler-Specific Settings
# ---------------------------
# Common message
message(STATUS "\nCompiler Configuration:")
message(STATUS " - Using ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS " - Build type: ${CMAKE_BUILD_TYPE}")

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    message(STATUS " - Applying GCC/Clang flags")
    target_compile_options(${PROJECT_NAME} PRIVATE
        -pedantic-errors
        -Wall
        -Weffc++
        -Wextra
        -Wconversion
        -Wsign-conversion
        # -Wshadow        # Warn when variable shadows another
        # -Wformat=2      # Check printf/scanf format strings
        # -Wundef         # Warn if identifier is evaluated in #if untested
        $<$<CONFIG:Debug>:-ggdb>
        $<$<CONFIG:Release>:-O2 -DNDEBUG>
    )
elseif(MSVC)
    message(STATUS " - Applying MSVC flags")
    target_compile_options(${PROJECT_NAME} PRIVATE
        /W4
        /WX
        /permissive-
        /Zc:__cplusplus
        $<$<CONFIG:Debug>:/Zi>
        $<$<CONFIG:Release>:/O2 /DNDEBUG>
    )
endif()


# ---------------------------
# Build Feedback & Utilities
# ---------------------------
# Post-build information
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo
    COMMAND ${CMAKE_COMMAND} -E echo "--------------------------------------------------"
    COMMAND ${CMAKE_COMMAND} -E echo "${PROJECT_NAME} Build Successful!"
    COMMAND ${CMAKE_COMMAND} -E echo "Executable located at: $<TARGET_FILE:${PROJECT_NAME}>"
    COMMAND ${CMAKE_COMMAND} -E echo "--------------------------------------------------"
    COMMAND ${CMAKE_COMMAND} -E echo "--- Running Executable ---"
    COMMAND ${CMAKE_COMMAND} -E echo
    COMMAND $<TARGET_FILE:${PROJECT_NAME}>  # <-- This line runs the executable
    COMMAND ${CMAKE_COMMAND} -E echo
    COMMAND ${CMAKE_COMMAND} -E echo "--- Execution Finished ---"
    COMMAND ${CMAKE_COMMAND} -E echo "--------------------------------------------------"
    VERBATIM
)

# ---------------------------
# Final Configuration Summary
# ---------------------------
message(STATUS "\nProject Configuration Summary:")
message(STATUS " - Project Name:        ${PROJECT_NAME}")
message(STATUS " - Source directory:    ${CMAKE_SOURCE_DIR}/src")
message(STATUS " - Build Directory:     ${PROJECT_BINARY_DIR}")
message(STATUS " - Output directory:    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
message(STATUS " - C++ standard:        ${CMAKE_CXX_STANDARD}")
message(STATUS " - Build type:          ${CMAKE_BUILD_TYPE}")
message(STATUS " - Compiler:            ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS " ------------------------------")
message(STATUS "Configuration successful! To build, navigate to the build directory ('${PROJECT_BINARY_DIR}') and run:")
message(STATUS "   cmake --build .")
message(STATUS "Or run: cmake --build build")
message(STATUS "To run the executable after building:")
message(STATUS "   ./${PROJECT_NAME}  (or .\\${CMAKE_BUILD_TYPE}\\${PROJECT_NAME}.exe on Windows)")
message(STATUS "-------------------------------\n")

