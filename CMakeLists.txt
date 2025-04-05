cmake_minimum_required(VERSION 3.15)
project(main LANGUAGES CXX)

# ---------------------------
# Directory Setup
# ---------------------------
# Create essential directories
file(MAKE_DIRECTORY
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/bin
)

# ---------------------------
# Build Configuration
# ---------------------------
# Set default build type with clear feedback
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type: Debug or Release" FORCE)
    message(STATUS "Build type not specified - defaulting to ${CMAKE_BUILD_TYPE}")
endif()

# Configure output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

# ---------------------------
# File Discovery
# ---------------------------
# Find source files with multiple extensions
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
    "src/*.cpp"
    "src/*.cc"
    "src/*.cxx"
)

# Find header files
file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS
    "src/*.h"
    "src/*.hpp"
    "src/*.hxx"
)

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

# C++ standard configuration - set the variable first
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Then apply to the target (this is still good practice)
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
# File Discovery Feedback
# ---------------------------
message(STATUS "\nSource Files:")
if(SOURCES)
    foreach(source ${SOURCES})
        message(STATUS " - ${source}")
    endforeach()
else()
    message(WARNING " No source files found in src directory!")
endif()

message(STATUS "\nHeader Files:")
if(HEADERS)
    foreach(header ${HEADERS})
        message(STATUS " - ${header}")
    endforeach()
else()
    message(STATUS " No headers found - creating empty src structure")
endif()

# ---------------------------
# Build Feedback & Utilities
# ---------------------------
# Post-build information
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo
    COMMAND ${CMAKE_COMMAND} -E echo "Build successful!"
    COMMAND ${CMAKE_COMMAND} -E echo "Executable: $<TARGET_FILE:${PROJECT_NAME}>"
    COMMAND $<TARGET_FILE:${PROJECT_NAME}>  # This line runs the executable
)

# Enhanced clean target that works cross-platform
if(CMAKE_HOST_WIN32)
    # Windows-specific clean command using a batch file
    add_custom_target(clean-all
        COMMAND ${CMAKE_COMMAND} -E echo "Cleaning all build artifacts..."
        # Clean everything except the build directory itself
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/bin
        # Create a batch file that will delete the build directory
        COMMAND ${CMAKE_COMMAND} -E echo "@echo off" > ${CMAKE_BINARY_DIR}/clean_build.bat
        COMMAND ${CMAKE_COMMAND} -E echo "timeout /t 1 /nobreak > nul" >> ${CMAKE_BINARY_DIR}/clean_build.bat
        COMMAND ${CMAKE_COMMAND} -E echo "rmdir /s /q \"${CMAKE_BINARY_DIR}\"" >> ${CMAKE_BINARY_DIR}/clean_build.bat
        COMMAND ${CMAKE_COMMAND} -E echo "echo Build directory cleaned!" >> ${CMAKE_BINARY_DIR}/clean_build.bat
        # Run the batch file in a separate process
        COMMAND start cmd.exe /c ${CMAKE_BINARY_DIR}/clean_build.bat
        COMMENT "Removing build artifacts and scheduling build directory cleanup..."
    )
else()
    # Linux/Unix clean command
    add_custom_target(clean-all
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
        # For Linux, we can use a shell script to clean the build directory
        COMMAND ${CMAKE_COMMAND} -E echo "#!/bin/sh" > ${CMAKE_BINARY_DIR}/clean_build.sh
        COMMAND ${CMAKE_COMMAND} -E echo "sleep 1" >> ${CMAKE_BINARY_DIR}/clean_build.sh
        COMMAND ${CMAKE_COMMAND} -E echo "rm -rf \"${CMAKE_BINARY_DIR}\"" >> ${CMAKE_BINARY_DIR}/clean_build.sh
        COMMAND ${CMAKE_COMMAND} -E echo "echo Build directory cleaned!" >> ${CMAKE_BINARY_DIR}/clean_build.sh
        COMMAND chmod +x ${CMAKE_BINARY_DIR}/clean_build.sh
        COMMAND ${CMAKE_BINARY_DIR}/clean_build.sh &
        COMMENT "Removing all build artifacts and binaries..."
    )
endif()

# ---------------------------
# Final Configuration Summary
# ---------------------------
message(STATUS "\nProject Configuration Summary:")
message(STATUS " - Source directory:    ${CMAKE_SOURCE_DIR}/src")
message(STATUS " - Output directory:    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
message(STATUS " - C++ standard:        ${CMAKE_CXX_STANDARD}")
message(STATUS " - Build type:          ${CMAKE_BUILD_TYPE}")
message(STATUS " - Compiler:            ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "\nConfigured successfully! Use 'cmake --build .' to compile\n")
