# 实现多路选择器 MUX

## 实验要求

本次实验你需要完成的内容有：

* 根据上述介绍创建一个工程，添加源文件，并实现 MUX 的功能。
* 对实现的工程进行仿真，上板验证。
* 实验报告里需要包含的内容：
    * MUX 代码。
    * 仿真代码与波形截图（注意缩放比例、数制选择合适）。
    * 约束文件（描述 MUX 的输入输出与开发板上的引脚、LED 灯的对应关系）。
    * 下板图片与描述。
    * 实验思考题。


本次实验你要实现的多路选择器如下：
四输入 MUX，其中 `SW[15:14]` 作为选择信号。

* `SW[15:14]=0` 时输出 `SW[3:0]`。
* `SW[15:14]=1` 时输出 `SW[7:4]`。
* `SW[15:14]=2` 时输出 `SW[11:8]`。
* `SW[15:14]=3` 时输出常数 `0`。
* 输出直接绑到四个 LED 灯。

这里给出约束代码供参考，你需要修改里面的 `_SOME_PIN` 以及 `_which_signal` 为正确的内容。当然你也可以完全自己写一份约束文件。

??? Note "约束代码"
    ``` verilog
    # LED
    set_property IOSTANDARD LVCMOS33       [get_ports {_which_signal}]
    set_property PACKAGE_PIN _SOME_PIN     [get_ports {_which_signal}]
    set_property IOSTANDARD LVCMOS33       [get_ports {_which_signal}]
    set_property PACKAGE_PIN _SOME_PIN     [get_ports {_which_signal}]
    set_property IOSTANDARD LVCMOS33       [get_ports {_which_signal}]
    set_property PACKAGE_PIN _SOME_PIN     [get_ports {_which_signal}]
    set_property IOSTANDARD LVCMOS33       [get_ports {_which_signal}]
    set_property PACKAGE_PIN _SOME_PIN     [get_ports {_which_signal}]

    # SW
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[0]}]				
    set_property PACKAGE_PIN AA10    [get_ports {SW[0]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[1]}]				
    set_property PACKAGE_PIN AB10    [get_ports {SW[1]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[2]}]				
    set_property PACKAGE_PIN AA13    [get_ports {SW[2]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[3]}]				
    set_property PACKAGE_PIN AA12    [get_ports {SW[3]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[4]}]				
    set_property PACKAGE_PIN Y13     [get_ports {SW[4]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[5]}]				
    set_property PACKAGE_PIN Y12     [get_ports {SW[5]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[6]}]				
    set_property PACKAGE_PIN AD11    [get_ports {SW[6]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[7]}]				
    set_property PACKAGE_PIN AD10    [get_ports {SW[7]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[8]}]				
    set_property PACKAGE_PIN AE10    [get_ports {SW[8]}]                  
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[9]}]				
    set_property PACKAGE_PIN AE12    [get_ports {SW[9]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[10]}]			
    set_property PACKAGE_PIN AF12    [get_ports {SW[10]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[11]}]			
    set_property PACKAGE_PIN AE8     [get_ports {SW[11]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[12]}]			
    set_property PACKAGE_PIN AF8     [get_ports {SW[12]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[13]}]			
    set_property PACKAGE_PIN AE13    [get_ports {SW[13]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[14]}]			
    set_property PACKAGE_PIN AF13    [get_ports {SW[14]}]                 
    set_property IOSTANDARD LVCMOS15 [get_ports {SW[15]}]			
    set_property PACKAGE_PIN AF10    [get_ports {SW[15]}]  
    ```

## 思考题

在你过完实验流程之后，请完成思考题：

???+ question "思考题"
    助教在做《计算机体系结构》实验时，在 `Message Window` 中看到了下列错误提示：

    > [Drc 23-20] Rule violation (NSTD-1) Unspecified I/O Standard: 41 out of 41 logical ports use I/O standard (IOSTANDARD) value 'DEFAULT', instead of a user assigned specific value. This may cause I/O contention or incompatibility with the board power or connectivity affecting performance, signal integrity or in extreme cases cause damage to the device or the components to which it is connected. To correct this violation, specify all I/O standards. This design will fail to generate a bitstream unless all logical ports have a user specified I/O standard value defined. To allow bitstream creation with unspecified I/O standard values (not recommended), use this command: set_property SEVERITY {Warning} [get_drc_checks NSTD-1].  NOTE: When using the Vivado Runs infrastructure (e.g. launch_runs Tcl command), add this command to a .tcl file and add that file as a pre-hook for write_bitstream step for the implementation run. Problem ports: BTN_X[4:0], BTN_Y[3], BTN_Y[0], SW[15], SW[14], SW[13], SW[7], SW[6], SW[5], SW[4], SW[3], SW[2], SW[1], SW[0], VGA_B[3:0]... and (the first 15 of 28 listed).

    请你帮助可怜的助教解决这个问题😭，完成实验！

    * 你需要说明：
        * 这个 Error 是出在哪个阶段 (Synthesis/Implementation/Generate Bitstream) ？
        * 助教应该怎么做？（请至少给出一种可能的解决方式）
        * 你是通过什么途径了解与解决这个 Error 的？（简单说明即可，参考内容请给出链接）
    * 你不需要理解与说明：
        * 这个错误到底是什么东西，这个错误是怎么产生的。
    * 你可能通过以下途径完成本题：
        * 认真阅读**报错信息**，说不定解决方案就在 Error 中了？
        * 使用搜索引擎（最好不要用 Baidu ），粘贴报错的**头部**，看看能不能借鉴前人的智慧。
        * 善用[ Xilinx Support](https://support.xilinx.com/)。
    
    感谢你帮助助教完成了实验😊！之后的实验中，如果你发现了各种报错（尤其是 Critical Warnings/Errors）也可以先尝试通过今天的途径解决。