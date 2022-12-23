
# Consider setting `REflex_ROOT` as a hint where reflex has been installed
set(REflex_USE_STATIC_LIBS ON)
find_package(REflex 3.2.3)

find_package(FLEX REQUIRED)

# set(USE_FLEXCPP ON)
# find_package(Flexcpp 2.08.00)

find_package(BISON REQUIRED)

include_directories(
  ${PROJECT_SOURCE_DIR}/include
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}
)

BISON_TARGET(InfixCalcParser infix_calc_parser.yy ${CMAKE_CURRENT_BINARY_DIR}/infix_calc_parser.cpp
             DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/infix_calc_parser.hpp)

if(FLEX_FOUND)
    message(STATUS "${PROJECT_NAME} flex found, FLEX_INCLUDE_DIRS ${FLEX_INCLUDE_DIRS}")
    FLEX_TARGET(InfixCalcScanner1 infix_calc_scanner1.ll  ${CMAKE_CURRENT_BINARY_DIR}/infix_calc_scanner1.cpp
          COMPILE_FLAGS "--header-file=${CMAKE_CURRENT_BINARY_DIR}/infix_calc_scanner1.hpp" )
    ADD_FLEX_BISON_DEPENDENCY(InfixCalcScanner1 InfixCalcParser)
    add_library (infix_calc1 SHARED infix_calc.cpp ${BISON_InfixCalcParser_OUTPUTS} ${FLEX_InfixCalcScanner1_OUTPUTS})
    target_include_directories(infix_calc1 SYSTEM PRIVATE ${FLEX_INCLUDE_DIRS})
    target_compile_options(infix_calc1 PRIVATE -DSCANNER_FLEX)
    #target_link_libraries (
    #  infix_calc1
    #  ${FLEX_LIBRARIES}
    #
    set_target_properties(
       infix_calc1
       PROPERTIES
       SOVERSION ${infix_calc_VERSION_MAJOR}
       VERSION ${infix_calc_VERSION_SHORT}
    )
    if(USE_STRIP)
    add_custom_command(TARGET infix_calc1 POST_BUILD
                       COMMAND ${STRIP} ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}infix_calc1${CMAKE_SHARED_LIBRARY_SUFFIX}.${infix_calc_VERSION_SHORT}
                       COMMENT "stripping infix_calc1"
                       VERBATIM
                       )
    endif(USE_STRIP)
    install(TARGETS infix_calc1 LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif(FLEX_FOUND)

if(REflex_FOUND)
    message(STATUS "${PROJECT_NAME} REflex found, REflex_INCLUDE_DIRS ${REflex_INCLUDE_DIRS}")
    REflex_TARGET(InfixCalcScanner2 infix_calc_scanner2.ll ${CMAKE_CURRENT_BINARY_DIR}/infix_calc_scanner2.cpp 
          COMPILE_FLAGS "--header-file=${CMAKE_CURRENT_BINARY_DIR}/infix_calc_scanner2.hpp" )
    ADD_REFLEX_BISON_DEPENDENCY(InfixCalcScanner2 InfixCalcParser)
    add_library (infix_calc2 SHARED infix_calc.cpp ${BISON_InfixCalcParser_OUTPUTS} ${REflex_InfixCalcScanner2_OUTPUTS})
    target_include_directories(infix_calc2 SYSTEM PRIVATE ${REflex_INCLUDE_DIRS})
    target_compile_options(infix_calc2 PRIVATE -fPIC -DSCANNER_REFLEX)
    target_link_options(infix_calc2 PRIVATE -fPIC)
    target_link_libraries (
      infix_calc2
      ${REflex_min_LIBRARIES}
    )
    set_target_properties(
       infix_calc2
       PROPERTIES
       SOVERSION ${infix_calc_VERSION_MAJOR}
       VERSION ${infix_calc_VERSION_SHORT}
    )
    if(USE_STRIP)
    add_custom_command(TARGET infix_calc2 POST_BUILD
                       COMMAND ${STRIP} ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}infix_calc2${CMAKE_SHARED_LIBRARY_SUFFIX}.${infix_calc_VERSION_SHORT}
                       COMMENT "stripping infix_calc2"
                       VERBATIM
                       )
    endif(USE_STRIP)
    install(TARGETS infix_calc2 LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif(REflex_FOUND)

if(USE_FLEXCPP)
    FLEXCPP_TARGET(InfixCalcScanner3 infix_calc_scanner3.ll  ${CMAKE_CURRENT_BINARY_DIR}/infix_calc_scanner3.cpp
          COMPILE_FLAGS "--class-header=${CMAKE_CURRENT_BINARY_DIR}/infix_calc_scanner3.hpp --implementation-header=${CMAKE_CURRENT_BINARY_DIR}/infix_calc_scanner3i.hpp --namespace=infix_calc_yy --class-name=scanner" )
    ADD_FLEXCPP_BISON_DEPENDENCY(InfixCalcScanner3 InfixCalcParser)
    add_library (infix_calc3 SHARED infix_calc.cpp ${BISON_InfixCalcParser_OUTPUTS} ${Flexcpp_InfixCalcScanner3_OUTPUTS})
    target_include_directories(infix_calc3 SYSTEM PRIVATE ${Flexcpp_INCLUDE_DIRS})
    target_compile_options(infix_calc3 PRIVATE -DSCANNER_FLEXCPP)
    set_target_properties(
       infix_calc3
       PROPERTIES
       SOVERSION ${infix_calc_VERSION_MAJOR}
       VERSION ${infix_calc_VERSION_SHORT}
    )
    if(USE_STRIP)
    add_custom_command(TARGET infix_calc3 POST_BUILD
                       COMMAND ${STRIP} ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}infix_calc3${CMAKE_SHARED_LIBRARY_SUFFIX}.${infix_calc_VERSION_SHORT}
                       COMMENT "stripping infix_calc3"
                       VERBATIM
                       )
    endif(USE_STRIP)
    install(TARGETS infix_calc3 LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif(USE_FLEXCPP)

install (DIRECTORY ${PROJECT_SOURCE_DIR}/include/infix_calc/ DESTINATION include/infix_calc)

