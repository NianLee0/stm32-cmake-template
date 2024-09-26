# 必须修改为自己的芯片型号 ----------------------------------------------↓ example: stm32h7x.cfg
set(OPENOCD_CONFIG openocd -f interface/cmsis-dap.cfg -f target/stm32xxx.cfg -c init)
set(OPENOCD_RTT_CONFIG openocd -f ${CMAKE_SOURCE_DIR}/openocd/xxxx.cfg)
# 必须修改为自己的配置文件路径 ---------------------------------------↑ example: h7_rtt.cfg

################################# 下面代码无需修改 #################################

# elf2hex and elf2bin
add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}> ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}> ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.bin
)

add_custom_target(download
    COMMAND ${OPENOCD_CONFIG} -c halt -c "program ${CMAKE_PROJECT_NAME}.bin 0x08000000 verify reset exit"
    DEPENDS ${TARGET} # 确保目标文件是最新的
    COMMENT "Downloading program using OpenOCD"
)

add_custom_target(erase
    COMMAND ${OPENOCD_CONFIG} -c "reset halt" -c "flash erase_sector 0 0 last" -c shutdown
    COMMENT "Erasing program using OpenOCD"
)

add_custom_target(reset
    COMMAND ${OPENOCD_CONFIG} -c reset -c shutdown
    COMMENT "Resetting target using OpenOCD"
)

add_custom_target(rtt
    COMMAND ${OPENOCD_RTT_CONFIG}
    COMMENT "Starting RTT using OpenOCD"
)

# for example
# include("cmake/custom_commands.cmake")
# add_header_dirs(${CMAKE_SOURCE_DIR}/path)
# add_source_files(${CMAKE_SOURCE_DIR}/path)

# 递归查找include目录
function(add_header_dirs root_dir)
    if (IS_DIRECTORY ${root_dir})               # 当前路径是一个目录吗，是的话就加入到包含目录
        # message("include dir: " ${root_dir})
        include_directories(${root_dir})
    endif()
    file(GLOB ALL_SUB RELATIVE ${root_dir} ${root_dir}/*) # 获得当前目录下的所有文件
    foreach(sub ${ALL_SUB})
        if (IS_DIRECTORY ${root_dir}/${sub})
            add_header_dirs(${root_dir}/${sub}) # 对子目录递归调用，包含
        endif()
    endforeach()
endfunction()

function(add_source_files root_dir)
    if (IS_DIRECTORY ${root_dir})
        # message("source dir: " ${root_dir})
        file(GLOB_RECURSE SOURCE_FILES
            "${root_dir}/*.c"
            "${root_dir}/*.cpp"
            "${root_dir}/*.s")
        if (SOURCE_FILES)
            # 将找到的源文件添加到目标
            target_sources(${CMAKE_PROJECT_NAME} PRIVATE ${SOURCE_FILES})
        endif()
    endif()
endfunction()
