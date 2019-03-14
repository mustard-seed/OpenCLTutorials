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

add_executable (${PROJECT_NAME}_host ${HOST_SRC})
set_target_properties (${PROJECT_NAME}_host PROPERTIES "CMAKE_CXX_FLAGS" "${CMAKE_CXX_FLAGS}")
target_link_libraries(${PROJECT_NAME}_host
        acl_emulator_kernel_rt
        alteracl
        alterahalmmd
        elf
        OpenCL                
    )







