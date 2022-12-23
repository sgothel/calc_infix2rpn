# Source: https://gist.githubusercontent.com/KFAFSP/8ca884738f4558df29a3b32e47730306/raw/fe0d8a6366cc85f48a05d33328a8d4f3d864a776/FindFlexcpp.cmake
# 
# TODO: Add license.

#[========================================================================[.rst:
FindFlexcpp
----------

Finds and provides the Flexc++ lexer generator.

Supports the following signature::

    find_package(Flexcpp
        [version] [EXACT]       # Minimum or EXACT version e.g. 3.0.1
        [REQUIRED]              # Fail with error if Flexc++ is not found
    )

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Flexcpp::flexc++``
    The Flexc++ executable.

Result Variables
^^^^^^^^^^^^^^^^

``Flexcpp_FOUND``
    True if the system has the Flexc++ library and executable.
``Flexcpp_VERSION``
    The version of the Flexc++ executable which was found.
``Flexcpp_INCLUDE_DIRS``
    Include directories needed to use Flexc++ runtime library.

Cache variables
^^^^^^^^^^^^^^^

``Flexcpp_EXECUTABLE``
    Path to the Flexc++ executable.
``Flexcpp_INCLUDE_DIR``
    Path to the Flexc++ include directory.

Hints
^^^^^

``Flexcpp_ROOT``
    Path to a Flexcpp installation or build.

#]========================================================================]

### Step 1: Find the executable, library, and include path. ###

# Allows the user to specify a custom search path.
set(Flexcpp_ROOT "" CACHE PATH "Path to a Flexc++ installation or build.")

find_program(Flexcpp_EXECUTABLE
    NAMES
        flexc++
    HINTS
        "${Flexcpp_ROOT}/bin/"
    PATHS
        "/usr/local/bin/"
    DOC "Path to the flexc++ executable."
)
message(STATUS "Flexcpp_EXECUTABLE ${Flexcpp_EXECUTABLE}")

find_path(Flexcpp_INCLUDE_DIR
    NAMES
        flexc++/flexc++.h flexc++.h
    HINTS
        "${Flexcpp_ROOT}/share/"
    PATHS
        "/usr/share/" "/usr/local/share/"
    PATH_SUFFIXES
        flexc++
    DOC "Path to the flexc++ include directory."
)
message(STATUS "Flexcpp_INCLUDE_DIR ${Flexcpp_INCLUDE_DIR}")

mark_as_advanced(
    Flexcpp_ROOT
    Flexcpp_EXECUTABLE
    Flexcpp_INCLUDE_DIR
)

if (EXISTS "${Flexcpp_EXECUTABLE}")
    # Try to fetch the version from the found executable.
    execute_process(
        COMMAND
            "${Flexcpp_EXECUTABLE}" --version
        RESULT_VARIABLE _flexcpp_VERSION_RESULT
        OUTPUT_VARIABLE _flexcpp_VERSION
        ERROR_QUIET
    )

    string(REGEX MATCH "^flexc.. V([0-9\.]+)" _MATCH "${_flexcpp_VERSION}")
    if ((NOT _MATCH) OR _flexcpp_VERSION_RESULT)
        message(SEND_ERROR "The detected flexc++ executable is invalid!")
    else()
        set(Flexcpp_VERSION ${CMAKE_MATCH_1})
    endif()
endif()

### Step 2: Examine what we found. ###

# Run the standard handler to process all variables.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Flexcpp
    REQUIRED_VARS
        Flexcpp_EXECUTABLE
        Flexcpp_INCLUDE_DIR
    VERSION_VAR
        Flexcpp_VERSION
)
if(NOT Flexcpp_FOUND)
    # Optional dependency not fulfilled.
    return()
endif()

### Step 3: Declare targets and macros. ###

# Set legacy result variables.
set(Flexcpp_INCLUDE_DIRS "${Flexcpp_INCLUDE_DIR}")

if(NOT TARGET Flexcpp::flexc++)
    add_executable(Flexcpp::flexc++ IMPORTED)

    set_target_properties(Flexcpp::flexc++ PROPERTIES
        VERSION                         "${Flexcpp_VERSION}"
        IMPORTED_LOCATION               "${Flexcpp_EXECUTABLE}"
    )
endif()

#[========================================================================[.rst:
.. command:: flexcpp_target

Implements a ``flex_target`` using Flexc++, copying the signature of that
command exactly. All variables ``FLEX_`` are named ``Flexcpp``, however.

#]========================================================================]
macro(flexcpp_target _name _input _output)
    cmake_parse_arguments(Flexcpp_TARGET_ARG
        ""
        "COMPILE_FLAGS;DEFINES_FILE"
        ""
        ${ARGN}
    )

    set(Flexcpp_TARGET_outputs "${_output}")
    set(Flexcpp_EXECUTABLE_opts "")

    if(NOT "${Flexcpp_TARGET_ARG_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(SEND_ERROR
            "Flexcpp_TARGET(<Name> <Input> <Output> [COMPILE_FLAGS <string>] [DEFINES_FILE <string>])"
        )
    else()
        if(NOT "${Flexcpp_TARGET_ARG_COMPILE_FLAGS}" STREQUAL "")
            set(Flexcpp_EXECUTABLE_opts "${Flexcpp_TARGET_ARG_COMPILE_FLAGS}")
            separate_arguments(Flexcpp_EXECUTABLE_opts)
        endif()
        if(NOT "${Flexcpp_TARGET_ARG_DEFINES_FILE}" STREQUAL "")
            list(APPEND Flexcpp_TARGET_outputs "${Flexcpp_TARGET_ARG_DEFINES_FILE}")
            list(APPEND Flexcpp_EXECUTABLE_opts --header-file=${Flexcpp_TARGET_ARG_DEFINES_FILE})
        endif()

        add_custom_command(
            OUTPUT              ${Flexcpp_TARGET_outputs}
            COMMAND             Flexcpp::flexc++ ${Flexcpp_EXECUTABLE_opts} --lex-source=${_output} ${_input}
            VERBATIM
            DEPENDS             ${_input}
            COMMENT             "[FLEXCPP][${_name}] Building scanner with Flexc++ ${Flexcpp_VERSION}"
            WORKING_DIRECTORY   ${CMAKE_CURRENT_SOURCE_DIR}
        )

        set(Flexcpp_${_name}_DEFINED TRUE)
        set(Flexcpp_${_name}_OUTPUTS ${_output})
        set(Flexcpp_${_name}_INPUT ${_input})
        set(Flexcpp_${_name}_COMPILE_FLAGS ${Flexcpp_EXECUTABLE_opts})
        if("${Flexcpp_TARGET_ARG_DEFINES_FILE}" STREQUAL "")
            set(Flexcpp_${_name}_OUTPUT_HEADER "")
        else()
            set(Flexcpp_${_name}_OUTPUT_HEADER ${Flexcpp_TARGET_ARG_DEFINES_FILE})
        endif()
    endif()
endmacro()

#[========================================================================[.rst:
.. command:: add_flexcpp_bison_dependency

Implements a ``add_flex_bison_dependency`` for a Flexc++ target, copying the
signature of that command exactly.

#]========================================================================]
macro(add_flexcpp_bison_dependency _flexcpp _bison)
    if(NOT Flexcpp_${_flexcpp}_OUTPUTS)
        message(SEND_ERROR "Flexcpp target `${_flexcpp}' does not exist.")
    endif()
    if(NOT BISON_${_bison}_OUTPUT_HEADER)
        message(SEND_ERROR "Bison target `${_bison}' does not exist.")
    endif()

    set_source_files_properties(${Flexcpp_${_flexcpp}_OUTPUTS} PROPERTIES
        OBJECT_DEPENDS ${BISON_${_bison}_OUTPUT_HEADER}
    )
endmacro()
