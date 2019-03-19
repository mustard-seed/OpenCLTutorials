cmake_minimum_required (VERSION 3.1)
set (PROJECT_NAME "template")

project (${PROJECT_NAME})
include (config.cmake)

############################################
#First, we must be able to find Intel FPGA OpenCL SDK
#############################################
if(DEFINED ENV{INTELFPGAOCLSDKROOT})
else()
    message(FATAL_ERROR "The environment variable INTELFPGAOCLSDKROOT isn't set.")
endif()

#########################
#Obtain the host source files
#########################
file(GLOB HOST_SRC
        ${CMAKE_CURRENT_SOURCE_DIR}/host/src/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/common/src/AOCLUtils/*.cpp
)

###########################
#Add the include files
###########################
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/common/inc
    ${CMAKE_CURRENT_SOURCE_DIR}/host/inc
)

include_directories(
    $ENV{INTELFPGAOCLSDKROOT}/host/include
)

##################################
#Add the Altera Library to link with
##################################
set (intel_fpga_libraries
        acl_emulator_kernel_rt
        alteracl
        alterahalmmd
        elf
        OpenCL
)

##################################
#Add the RTL directories and libraries
##################################
set (rtl_directory ${CMAKE_CURRENT_SOURCE_DIR}/device/RTL
)

set (rtl_lib )
###########################################################
#Intel FPGA OpenCL SDK Compile and linkage configurations
###########################################################
if (BOARD_NAME MATCHES "DE10Standard")
    ##Add library directories for DE10Standard
    message (STATUS "Linking against DE10-Standard libraries")
    message (STATUS "$ENV{INTELFPGAOCLSDKROOT}/host/arm32/lib")
    message (STATUS "$ENV{INTELFPGAOCLSDKROOT}/board/de10_standard/arm32/lib")
    link_directories(
        $ENV{INTELFPGAOCLSDKROOT}/host/arm32/lib
        $ENV{INTELFPGAOCLSDKROOT}/board/de10_standard/arm32/lib
    )

elseif (BOARD_NAME MATCHES "A10REF")
    ##Add library directories for a10_ref
    message (STATUS "Linking against A10-Ref libraries")
    message (STATUS "$ENV{INTELFPGAOCLSDKROOT}/host/linux64/lib")
    message (STATUS "$ENV{INTELFPGAOCLSDKROOT}/board/a10_ref/linux64/lib")
    link_directories(
        $ENV{INTELFPGAOCLSDKROOT}/host/linux64/lib
        $ENV{INTELFPGAOCLSDKROOT}/board/a10_ref/linux64/lib
    )
elseif (BOARD_NAME MATCHES "A10PAC")
    ##Add library directories for a10_pac
    message (STATUS "Linking against A10-Pac libraries")
    message (STATUS "$ENV{INTELFPGAOCLSDKROOT}/host/linux64/lib")
    message (STATUS "$ENV{AOCL_BOARD_PACKAGE_ROOT}/linux64/lib")
    link_directories(
        $ENV{INTELFPGAOCLSDKROOT}/host/linux64/lib
        $ENV{AOCL_BOARD_PACKAGE_ROOT}/linux64/lib
    ) 
elseif (BOARD_NAME MATCHES "DE5ANET")
    ##Add library directories for de5a_net
    message (STATUS "Linking against DE5A-NET libraries")
    message (STATUS "$ENV{INTELFPGAOCLSDKROOT}/host/linux64/lib")
    message (STATUS "$ENV{INTELFPGAOCLSDKROOT}/board/de5a_net_e1/linux64/lib")
    link_directories(
        $ENV{INTELFPGAOCLSDKROOT}/host/linux64/lib
        $ENV{INTELFPGAOCLSDKROOT}/board/de5a_net_e1/linux64/lib
    ) 
else()
    message (STATUS "The board is ${BOARD_NAME}")
    message (FATAL_ERROR "Unsupported board!")
endif()

#######################################
##Add the library for the host below
######################################

#####################################
##Add unit test for the host library below
#####################################
add_executable (${PROJECT_NAME}_host ${HOST_SRC})
set_target_properties (${PROJECT_NAME}_host PROPERTIES "CMAKE_CXX_FLAGS" "${CMAKE_CXX_FLAGS}")
target_link_libraries(${PROJECT_NAME}_host
        ${intel_fpga_libraries}                
    )


####################################
##Generate the hardware targets
####################################

include (aoc.cmake)

# Find the kernel source files. Note, GLOB isn't the recommended way. One needs to touch the CMakesList.txt to effect changes
file(GLOB_RECURSE kernel_files
     ${CMAKE_CURRENT_SOURCE_DIR}/device/*.cl
)

add_hw_emulation_target (
    TARGET_NAME ${PROJECT_NAME} 
    SOURCES_LIST ${kernel_files} 
    HEADER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/host 
    RTL_DIR ${rtl_directory} 
    RTL_LIB ${rtl_lib})

add_hw_report_target (
    TARGET_NAME ${PROJECT_NAME} 
    SOURCES_LIST ${kernel_files} 
    HEADER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/host 
    RTL_DIR ${rtl_directory} 
    RTL_LIB ${rtl_lib})

add_hw_profile_target (
    TARGET_NAME ${PROJECT_NAME} 
    SOURCES_LIST ${kernel_files} 
    HEADER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/host 
    RTL_DIR ${rtl_directory} 
    RTL_LIB ${rtl_lib})

add_hw_release_target (
    TARGET_NAME ${PROJECT_NAME} 
    SOURCES_LIST ${kernel_files} 
    HEADER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/host 
    RTL_DIR ${rtl_directory} 
    RTL_LIB ${rtl_lib})





