# Lab2

!!! tip "[Lab2 附件](https://pan.zju.edu.cn/share/7b27f8d764318f072876e5412f)"

!!! Danger "请确认你使用的 slide 和 IP 核是 2024 年版，学在浙大上的文件不保证符合我们的要求。"

!!! warning "本实验不需要验收。"

## 实验平台搭建

本实验内容为使用提供的 IP core 搭建测试框架。

* 新建工程 `OExp02-IP2SOC`，导入附件 `OExp02-IP2SOC/IP/` 目录下的所有 IP 模块。（如果你对 IP 的导入有疑问，请回顾 [Lab0](../Lab0/vivado_guide.md)。
* 新建顶层文件 `CSSTE.v`，要求输入输出端口与下面保持一致：

    ??? tip "`CSSTE.v`"
        ``` Verilog linenums="1" 
        module CSSTE(
            input         clk_100mhz,
            input         RSTN,
            input  [3:0]  BTN_y,
            input  [15:0] SW,
            output [3:0]  Blue,
            output [3:0]  Green,
            output [3:0]  Red,
            output        HSYNC,
            output        VSYNC,
            output [15:0] LED_out,
            output [7:0] AN,
            output [7:0] segment
        );
        ```

* 参考附件中的电路图 `CSSTE.pdf`，在 `CSSTE.v` 文件里使用 Verilog 连线。
    * 在连线前你需要生成 ROM 核，并关联附件中的 `I_mem.coe` 文件；生成 RAM 核，关联附件中的 `D_mem.coe` 文件。如果你对 ROM 与 RAM 的生成有疑问，请回顾 [Lab0](../Lab0/vivado_guide.md)。其中 ROM 核对应电路图中的 U2 Distributed Memory Generato，RAM 核对应电路图中的 U3 RAM_B。
    * 实际上在我们的附件中已经给出了 RAM 这个 IP 核，你可以尝试使用，并关联对应文件。但是可能会有版本兼容问题，我们更推荐你自己生成一遍 RAM 核，以免出现问题。
* 处理 VGA，具体处理方法可见下文[#处理 VGA](#1)。
* 导入约束文件 `A7.xdc`。
* 生成比特文件，下板验证，具体要求可见下文[#下板验证](#2)。
* 本次实验涉及到大量 IP 核，你可以把他们当作黑盒不去了解。后面我们仅会修改其中的 SCPU、ROM、RAM 部分。如果你对实验中的某个 IP 核感兴趣或者有疑问，可以查看[马德老师的实验课 slide](./attachment/lab02.pdf)。


!!! Tips
    以下建议来自上上届助教：

    * 作为一个习惯，`wire` 型变量在驱动它的模块前进行声明，注意宽度，默认 1bit；不进行声明的变量会被认为是 1-bit `wire` 变量。请关注 critical warnings。
    * 你可以尝试使用 CS61C 提供的[汇编器](http://venus.cs61c.org/)。可以将机器码转化为汇编代码，方便你理解程序的功能。

<a name="1"></a> 

##  处理 VGA 

!!! warning "本节内容是 slide 中没有，但是要求在 Lab2 完成的。"

在之后的实验中我们将通过屏幕查看寄存器的值等 debug 信号，在本节你需要修改 VGA 接口，接入并显示各类 debug 信号；Lab2 中 SCPU 使用的是给定的 IP Core，我们不能将需要的信号从 SCPU 中接出到 VGA 模块中，因此本实验仅仅给 debug 信号留出位置，等待我们自己完成 SCPU 时直接接入。

具体来说，你需要完成以下流程：

* 你可能需要修改附件 `VGADisplay.v` 中的文件路径，需要和你放置 `font_8x16.mem`，`vga_debugger.mem` 文件的路径匹配。（你可以使用相对路径，也可以使用绝对路径）
* 阅读附件 `IP/VGA/VGA.srcs` 中的源代码，理解各部分作用。修改 `VGA.v` 中 `module VGA` 的端口描述（增加若干 debug 信号输入），将增加的输入接到 `VGA` 模块的 `vga_debugger` 实例即可。
    * 需要增加的输入你可以通过 `vga_debugger` 的端口来确定。
* 我们的实验板需要外连 VGA 才能显示，你可以选择使用实验室的显示器和 VGA 线，或者自行尝试使用自己的显示器。
* 成功设置 VGA 并上板之后，可以在 VGA 上看到若干 debug 信号，在后续实验中我们会使用这些信号进行调试。

!!! Tips
    * 如果你使用的是 Windows 系统且下板后 VGA 是“亮起来的黑”，那么最坏情况下你要尝试：`/, //, \, \\` 四种路径分隔符。
    * 修改 VGA.v 和 VGADisplay.v 后，我们需要重新进行 IP 封装，并在工程目录下进行 IP 状态更新。

<a name="2"></a> 

## 下板验证

在完成以上步骤后，我们需要进行下板验证。程序源码可以在附件 `I_mem.pdf` 中查看，本次实验**不要求**自己编写验收代码。

当烧录比特文件到板上后，`I_mem.pdf` 的值就已经被写入 ROM 中。你可以通过按下板上的按钮，调节开关，控制核观察程序的运行。

??? Note "按钮介绍"
    * `SW[8]SW[2]` 用于控制 CPU 时钟。
        * `SW[8]SW[2]=00`: CPU 全速时钟 100MHZ。
        * `SW[8]SW[2]=01`: CPU 自动单步时钟。
        * `SW[8]SW[2]=1X`: CPU 手动单步时钟。
    * `SW[10]` 用于手动时钟模式。此时拨一下 `SW[10]`（即从 0 拨到 1）时钟增加一个周期，相应地我们也会执行一条指令。
    * `SW[7:5]` 用于控制七段数码管的显示。
        * `SW[7:5]=001`: 显示 CPU 指令字地址 `PC_out[31:2]`，即我们下一条要执行的指令的地址。
        * `SW[7:5]=010`: 显示 ROM 指令输出 `Inst_in`，即我们正在执行的指令。
        * `SW[7:5]=100`: 显示 CPU 数据存储地址 `addr_bus`，在 Lab4 中你将会了解到 `addr_bus` 实际上就是 ALU 的运算结果。
        * `SW[7:5]=101`: 显示 CPU 数据输出 `Cpu_data2bus`，在 Lab4 中你将会了解到 `Cpu_data2bus` 实际上就是寄存器 B 的值（假设每个周期从寄存器堆中读取 A、B 寄存器）。
        * `SW[7:5]=110`: 显示 CPU 数据输入 `Cpu_data4bus`，在 Lab4 中你将会了解到 `Cpu_data4bus` 实际上就是 RAM 的输出，即从内存中读出来的值。
        * `SW[7:5]=111`: 显示 CPU 指令字地址 `PC_out`。
    * 如果你对上板的操作有疑问，或者想查看上板结果示例，可以查看[马德老师的实验课 slide](./attachment/lab02.pdf)（85 页起）。

请结合理论课所学的 RISC-V 知识，理解 `I_mem.pdf` 的程序意义，随后下板验证程序的正确性。

## 实验要求

本次实验你需要完成的内容有：

* 完成实验平台搭建，并处理 VGA。
* 上板验证。
* 实验报告里需要包含的内容：
    * 你写出的完整的 `CSSTE.v` 代码。
    * 对 VGA 模块做的修改。
    * `I_mem.pdf` 的程序实现了什么样的功能。
    * 下板图片与描述，其中至少包括前两条指令的执行情况，以及执行若干个循环之后的结果。