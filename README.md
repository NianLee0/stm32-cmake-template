# stm32 cmake template

## Requirements

* cmake`>=3.22`​
* openocd
* arm-none-eabi-gcc
* stm32cubemx`>=6.11`​
* vscode+cmake+cmake tools+cortex-debug extensions

## Usage

首先使用`stm32cubemx`​生成`HAL`​库初始项目，注意toolchain选择`cmake`​，然后将此模板中的内容全部复制到项目根目录，在`cmakelists.txt`​文件最后添加如下代码

```txt
include("cmake/custom_commands.cmake")

# 根据自己添加的代码目录修改
add_header_dirs(${CMAKE_SOURCE_DIR}/path)
add_source_files(${CMAKE_SOURCE_DIR}/path)
```

最后根据注释指引修改`.vscode/launch.json`​和`cmake/custom_commands.cmake`​中的内容即可

## Attention

1. `stm32cubemx`​版本**必须**​`＞=6.11`​才能生成cmake项目
2. 模板中需要修改的部分已经写成了不修改会报错的形式，如果遇到报错请首先检查是不是有地方没有修改
3. `Core`​，`Driver`​等cubemx自动生成的文件夹中的文件无需使用模板提供的函数手动添加，项目生成时已经自动添加
4. 模板中有`download`​，`erase`​，`reset`​，`rtt`​的快捷指令，使用`cmake tools`​插件可以方便调用
5. 模板中部分cmake配置根据湖南大学跃鹿战队[powerful_framework](https://gitee.com/hnuyuelurm/powerful_framework)项目修改而来

‍

**如果你觉得本项目有用🥰，别忘了给我一个star⭐**
