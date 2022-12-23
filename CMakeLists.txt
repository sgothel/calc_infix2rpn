cmake_minimum_required (VERSION 3.13.0 FATAL_ERROR)
project (calc_infix2rpn LANGUAGES C CXX)

if(${CMAKE_VERSION} VERSION_LESS "3.18.0")
    message(STATUS "CMake ${CMAKE_VERSION}, please consider to switch to CMake 3.18.0 or later")
else()
    message(STATUS "CMake ${CMAKE_VERSION} >= 3.18.0, good.")
endif()

set (THREADS_PREFER_PTHREAD_FLAG ON)
find_package (Threads REQUIRED)

# set(CMAKE_MESSAGE_LOG_LEVEL DEBUG)

if(NOT DEFINED DONT_USE_RTTI)
    set(DONT_USE_RTTI ON)
    message(STATUS "${PROJECT_NAME} DONT_USE_RTTI ${DONT_USE_RTTI} (calc default)")
else()
    message(STATUS "${PROJECT_NAME} DONT_USE_RTTI ${DONT_USE_RTTI} (user)")
endif()

include(Setup.cmake)
Setup()

# this is the library version, derived from git tag and revision
set (infix_calc_VERSION_MAJOR      ${VERSION_MAJOR})
set (infix_calc_VERSION_MINOR      ${VERSION_MINOR})
set (infix_calc_VERSION_PATCH      ${VERSION_PATCH})
set (infix_calc_VERSION_COMMITS    ${VERSION_COMMITS})
set (infix_calc_VERSION_SHA1       ${VERSION_SHA1})
set (infix_calc_VERSION_SHA1_SHORT ${VERSION_SHA1_SHORT})
set (infix_calc_GIT_DIRTY          ${GIT_WORKDIR_DIRTY})
set (infix_calc_VERSION_LONG       ${VERSION_LONG})
set (infix_calc_VERSION_SHORT      ${VERSION_SHORT})
set (infix_calc_VERSION_API        ${VERSION_API})

find_path (SYSTEM_USR_DIR "stdlib.h")
include_directories (${SYSTEM_USR_DIR})

# set(REflex_ROOT "/opt-linux-x86_64/reflex")

#include(FindREflex)
#include(FindFlexcpp)
add_subdirectory (src)

add_subdirectory (examples)
