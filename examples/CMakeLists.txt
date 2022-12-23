include_directories(
    ${PROJECT_SOURCE_DIR}/include
)

# These examples use the standard separate compilation
file(GLOB_RECURSE SOURCES_IDIOMATIC_EXAMPLES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "calc_*.cpp")

string( REPLACE ".cpp" "" BASENAMES_IDIOMATIC_EXAMPLES "${SOURCES_IDIOMATIC_EXAMPLES}" )
set( TARGETS_IDIOMATIC_EXAMPLES "" )

foreach( name ${BASENAMES_IDIOMATIC_EXAMPLES} )
    if( TARGET infix_calc1 ) 
        add_executable(${name}_1 ${name}.cpp)
        target_link_libraries(${name}_1 infix_calc1)
        add_dependencies(${name}_1 infix_calc1)
        set( TARGETS_IDIOMATIC_EXAMPLES "${TARGETS_IDIOMATIC_EXAMPLES};${name}_1" )
    endif( TARGET infix_calc1 ) 

    if( TARGET infix_calc2 ) 
        add_executable(${name}_2 ${name}.cpp)
        target_link_libraries(${name}_2 infix_calc2)
        add_dependencies(${name}_2 infix_calc2)
        set( TARGETS_IDIOMATIC_EXAMPLES "${TARGETS_IDIOMATIC_EXAMPLES};${name}_2" )
    endif( TARGET infix_calc2 ) 
endforeach()

install(TARGETS ${TARGETS_IDIOMATIC_EXAMPLES} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

