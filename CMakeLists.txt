cmake_minimum_required(VERSION 3.16)

# Get version from git tag
execute_process(
    COMMAND git describe --tags --always --dirty
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
)

# Strip leading 'v' if present (e.g., v1.6 -> 1.6)
string(REGEX REPLACE "^v" "" GIT_VERSION "${GIT_VERSION}")

# Fallback if git command fails
if(NOT GIT_VERSION)
    set(GIT_VERSION "1.6-unknown")
endif()

set(PROJECT_VER "${GIT_VERSION}")

message(STATUS "Project version from git: ${PROJECT_VER}")

add_compile_options(-Wno-missing-field-initializers)

include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(photoframe-api)
