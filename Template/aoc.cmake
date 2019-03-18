# Functions used to generate the hardware targets

function(add_hw_emulation_target TARGET_NAME SOURCES_LIST HEADER_DIR)

    list(REMOVE_DUPLICATES SOURCES_LIST)
    list(SORT SOURCES_LIST)

    set (target_name_local "${TARGET_NAME}_hw_emu")
    
    add_custom_target(${target_name_local}
        COMMAND aoc -v -report -march=emulator -emulator-channel-depth-model=strict -fp-relaxed -DEMULATOR
                -o ${target_name_local}
                "-I=${HEADER_DIR}"
                ${SOURCES_LIST}
    )
    
endfunction()

function(add_hw_report_target TARGET_NAME SOURCES_LIST HEADER_DIR)

    list(REMOVE_DUPLICATES SOURCES_LIST)
    list(SORT SOURCES_LIST)

    set (target_name_local "${TARGET_NAME}_hw_report")
    
    add_custom_target(${target_name_local}
        COMMAND aoc -v -report -fp-relaxed -c
                -o ${target_name_local}
                "-I=${HEADER_DIR}"
                ${SOURCES_LIST}
    )
    
endfunction()

function(add_hw_profile_target TARGET_NAME SOURCES_LIST HEADER_DIR)

    list(REMOVE_DUPLICATES SOURCES_LIST)
    list(SORT SOURCES_LIST)

    set (target_name_local "${TARGET_NAME}_hw_profile")
    
    add_custom_target(${target_name_local}
        COMMAND aoc -v -report -fp-relaxed -profile
                -o ${target_name_local}
                "-I=${HEADER_DIR}"
                ${SOURCES_LIST}
    )
    
endfunction()

function(add_hw_release_target TARGET_NAME SOURCES_LIST HEADER_DIR)

    list(REMOVE_DUPLICATES SOURCES_LIST)
    list(SORT SOURCES_LIST)

    set (target_name_local "${TARGET_NAME}_hw_release")
    
    add_custom_target(${target_name_local}
        COMMAND aoc -v -report -fp-relaxed -high-effort
                -o ${target_name_local}
                "-I=${HEADER_DIR}"
                ${SOURCES_LIST}
    )
    
endfunction()
