# 基本的控制单元和数据通路

<!-- !!! danger "本实验并未 release，内容随时都会变化。个人水平有限，如您发现文档中的疏漏欢迎 Issue！" -->

## 模块实现

本实验需要完成大部分指令，自行完成**数据通路**和**控制器**的设计，从而得到自己设计实现的 SCPU。

!!! tip "在本节实验中，你需要实现以下指令："

    * R-Type: add, sub, and, or, xor, slt, srl
    * I-Type: addi, andi, ori, xori, slti, srli, lw
    * S-Type: sw
    * B-Type: beq
    * J-Type: jal

其他指令将在 Lab4-3 指令拓展与 Lab4-4 中断处理两小节实现。如果不清楚以上指令的指令格式与含义，请查看 RISC-V 手册。

在分别完成 DataPath 和 CtrlUnit 两部分后，将 Lab4-0 中的 IP Core 替换，**得到自行实现的 SCPU**。

* CtrlUnit 的作用是根据指令的 OPcode 与 Funct3 以及 Funct7 产生相应的控制信号，用于控制数据通路中的各个模块。
* DataPath 可以自行设计，也可以参考附件 [DataPath.pdf](./attachment/DataPath.pdf)。注意这里的数据通路只支持部分指令，你需要在 Lab4-3 中拓展以支持所有指令。因此建议理解数据通路的数据流动后再进行实验，而不是单纯地参照附件连线。
* DataPath 中可能需要用到如下模块：ALU、RegFile、ImmGen、VGA、RAM、ROM、SCPU_ctrl。
    * ALU、RegFile 在之前的实验里已经实现，可以直接使用。
    * ImmGen 用来生成立即数，对于不同的指令类型要使用不同的生成方式。SCPU_ctrl 即我们上面提到的 CtrlUnit，用来产生控制信号。

* **我们鼓励你使用自己的方式完成设计**。对于不知道如何设计的同学，我们在下面提供了 SCPU_ctrl、ImmGen 模块的接口定义，你可以参考这些定义来完成你的设计。

!!! tip 
    * 在设计本次实验之前，请检查你是否完成了之前实验要求的修改，这些修改将方便你在板上 debug 时查看寄存器值的变化。
        * RegFile 有 32 个寄存器值读口，并在本次实验中接到 SCPU 的输出口。
        * VGA 模块拓展了 32 个寄存器值的入口，并修改 VGA 内部使这些值可以显示在屏幕上。
    * 修改 IMem.coe 或 DMem.coe 内容后，需要重新生成对应的存储器 IP 核。

### SCPU_ctrl

参考模块接口如下：
```verilog title="SCPU_ctrl.v"
module SCPU_ctrl(
  input [4:0]       OPcode, 
  input [2:0]       Fun3,
  input             Fun7,
  input             MIO_ready,
  output reg [1:0]  ImmSel,
  output reg        ALUSrc_B,
  output reg [1:0]  MemtoReg,
  output reg        Jump,
  output reg        Branch,
  output reg        RegWrite,
  output reg        MemRW,
  output reg [3:0]  ALU_Control,
  output reg        CPU_MIO
);

endmodule
```

这里我们规定控制信号及其含义如下：（参考附件 `Lab4_header.vh`）

??? Note "控制信号介绍"
    * `ImmSel` 用于选择生成立即数的方式，0 为 I-Type，1 为 S-Type，2 为 B-Type，3 为 J-Type。
    * `ALUSrc_B` 用于选择 ALU 的 B 输入口，0 为寄存器值，1 为立即数。
    * `MemtoReg` 用于选择写回寄存器的数据来源，0 为 ALU 输出，1 为存储器读出的值，2 为 PC+4。
    * `Jump` 用于选择 PC 的下一个值，0 为 PC+4，1 为 J-Type 指令的目标地址。
    * `Branch` 用于选择是否进行分支跳转，0 为不跳转，1 为跳转。
    * `RegWrite` 用于选择是否写回寄存器，0 为不写回，1 为写回。
    * `MemRW` 用于选择存储器的读写方式，0 为读，1 为写。
    * `ALU_Control` 用于选择 ALU 的运算方式，接口定义与 Lab2 中 ALU 的实现相同。
    * `CPU_MIO` 用于选择是否进行存储器的读写，0 为不进行，1 为进行。（实际上这个控制信号可有可无）

当然，**你可以使用任何你认为合适的方式来实现这些控制信号**，或者去掉某些你认为不重要的信号，增加你认为重要的信号，也可以改变控制信号的定义。（如果你的接口定义和上面不同，请在实验报告中说明）

### 立即数生成器

ImmGen 用来生成立即数，对于 I-Type、S-Type、B-Type、J-Type 指令，我们需要不同的生成方式。具体的指令格式可以查看 RISC-V 手册或[速查表](../Other/RISC_V.md)。

参考模块接口如下：
```verilog title="ImmGen.v"
module ImmGen(
  input [1:0]   ImmSel,
  input [31:0]  inst_field,
  output[31:0]  Imm_out
);
```

这里我们规定控制信号及其含义如下：（参考附件 `Lab4_header.vh`）

* ImmSel 为 0 时，生成 I-Type 指令的立即数；为 1 时，生成 S-Type 指令的立即数；为 2 时，生成 B-Type 指令的立即数；为 3 时，生成 J-Type 指令的立即数。

你可以使用其他方式实现，或者改变 ImmSel 与不同类型立即数生成方法的对应，这里仅作参考。

## 仿真测试

### ImmGen 的仿真测试
    
对于按照我们提供的接口定义实现的 ImmGen 模块，我们提供了一个仿真测试文件 [ImmGen_tb.v](./attachment/ImmGen_tb.v)。你可以自行进行验证，正确的参考波形可以查看[标准波形文件](./attachment/ImmGen.vcd)。

如果你的模块接口或者接口定义与我们提供的不同，请自行编写仿真测试文件。你可以在 [test.s](./attachment/test.s) 编写更多的仿真代码，通过 [Venus](https://venus.cs61c.org/) 平台获得十六进制文件并更名为 `console.out`，使用 [ImmGen_tb_gen.py](./attachment/ImmGen_tb_gen.py) 获得要填写进仿真激励文件的代码。这一段 Python 代码非常简单，请自行查看文件命名与含义。当然，你也可以使用其他方式获得测试代码，这里仅作示例，以后不再提供类似文件。

### SCPU_ctrl 的仿真测试

`SCPU_ctrl` 模块也将采取类似的仿真测试。对于按照我们提供的接口定义实现的 `SCPU_ctrl` 模块，我们提供了一个仿真测试文件 [SCPU_ctrl_tb.v](./attachment/SCPU_ctrl_tb.v)。

如果你的模块接口或者接口定义与我们提供的不同，请自行编写仿真测试文件。方式与上面类似，这里不再重复。

### SCPU 的仿真测试

为了方便测试，我们需要搭建一个简单的仅包含 SCPU 以及 Mem(IMem & DMem) 的测试平台。

你可以直接使用以下代码，如果你的端口名与之不同请自行修改。

=== "testbench"

    ```verilog
    module testbench(
        input clk,
        input rst
    );

        /* SCPU 中接出 */
        wire [31:0] Addr_out;
        wire [31:0] Data_out;       
        wire        CPU_MIO;
        wire        MemRW;
        wire [31:0] PC_out;
        /* RAM 接出 */
        wire [31:0] douta;
        /* ROM 接出 */
        wire [31:0] spo;

        SCPU u0(
            .clk(clk),
            .rst(rst),
            .Data_in(douta),
            .MIO_ready(CPU_MIO),
            .inst_in(spo),
            .Addr_out(Addr_out),
            .Data_out(Data_out),
            .CPU_MIO(CPU_MIO),
            .MemRW(MemRW),
            .PC_out(PC_out)
        );

        RAM_B u1(
            .clka(~clk),
            .wea(MemRW),
            .addra(Addr_out[11:2]),
            .dina(Data_out),
            .douta(douta)
        );

        ROM_B u2(
            .a(PC_out[11:2]),
            .spo(spo)
        );

    endmodule
    ```
=== "testbench_tb"

    ```verilog
    module testbench_tb();

        reg clk;
        reg rst;

        testbench m0(.clk(clk), .rst(rst));

        initial begin
            clk = 1'b0;
            rst = 1'b1;
            #5;
            rst = 1'b0;
        end

        always #50 clk = ~clk;

    endmodule
    ```

<!-- !!! danger "以上代码并未验证，如有问题请联系助教。" -->

**请自行书写测试代码**，生成 ROM 核，并进行仿真。

## 下板验证

验收时，你需要使用以下验收代码。（验收代码为上上届助教 [@NonoHh](https://github.com/NonoHh) 所写）

??? tip "验收代码"

    === "test.s"

        ``` linenums="1" 
        jal zero, start # 0
        add zero, zero, zero # 4
        add zero, zero, zero # 8
        add zero, zero, zero # C
        add zero, zero, zero # 10
        add zero, zero, zero # 14
        add zero, zero, zero # 18
        add zero, zero, zero # 1C

        start:
        addi x1, zero, -1 # x1=FFFFFFFF
        xori x3, x1, 1 # x3=FFFFFFFE
        add x3, x3, x3 # x3=FFFFFFFC
        add x3, x3, x3 # x3=FFFFFFF8
        add x3, x3, x3 # x3=FFFFFFF0
        add x3, x3, x3 # x3=FFFFFFE0
        add x3, x3, x3 # x3=FFFFFFC0
        xor x20, x3, x1 # x20=0000003F
        add x3, x3, x3 # x3=FFFFFF80
        add x3, x3, x3 # x3=FFFFFF00
        add x3, x3, x3 # x3=FFFFFE00
        add x3, x3, x3 # x3=FFFFFC00
        add x3, x3, x3 # x3=FFFFF800
        add x3, x3, x3 # x3=FFFFF000
        add x3, x3, x3 # x3=FFFFE000
        add x3, x3, x3 # x3=FFFFC000
        add x3, x3, x3 # x3=FFFF8000
        add x3, x3, x3 # x3=FFFF0000
        add x3, x3, x3 # x3=FFFE0000
        add x3, x3, x3 # x3=FFFC0000
        add x3, x3, x3 # x3=FFF80000
        add x3, x3, x3 # x3=FFF00000
        add x3, x3, x3 # x3=FFE00000
        add x3, x3, x3 # x3=FFC00000
        add x3, x3, x3 # x3=FF800000
        add x3, x3, x3 # x3=FF000000
        add x3, x3, x3 # x3=FE000000
        add x3, x3, x3 # x3=FC000000
        add x6, x3, x3 # x6=F8000000
        add x3, x6, x6 # x3=F0000000
        add x4, x3, x3 # x4=E0000000
        add x13, x4, x4 # x13=C0000000
        add x8, x13, x13 # x8=80000000
        ori x26, zero, 1 # x26=00000001
        andi x26, x26, 0xff
        srl x27, x8, x26

        loop:
        slt x2, x1, zero # x2=00000001 针对ALU32位有符号数减
        slti x2, x1, 0 # x2=00000001 针对ALU32位有符号数减
        add x14, x2, x2
        add x14, x14, x14 # x14=4
        sub x19, x14, x14 # x19=0
        srli x19, x19, 1
        addi x10, x19, -1
        or x10, x10, zero
        add x10, x10, x10 # x10=FFFFFFFE

        loop1:
        sw x6, 0x4(x3) # 计数器端口: F0000004, 送计数常数x6=F8000000
        lw x5, 0x0(x3) # 读GPIO端口F0000000状态: {counter0_out,counter1_out,counter2_out,led_out[12:0], SW}
        add x5, x5, x5 # 左移
        add x5, x5, x5 # 左移2位将SW与LED对齐, 同时D1D0置00, 选择计数器通道0
        sw x5, 0x0(x3) # x5输出到GPIO端口F0000000, 设置计数器通道counter_set=00端口
        add x9, x9, x2 # x9=x9+1
        sw x9, 0x0(x4) # x9送x4=E0000000七段码端口
        lw x13, 0x14(zero) # 取存储器20单元预存数据至x13, 程序计数延时常数

        loop2:
        lw x5, 0x0(x3) # 读GPIO端口F0000000状态: {out0, out1, out2, D28-D20, LED7
        add x5, x5, x5
        add x5, x5, x5 # 左移2位将SW与LED对齐, 同时D1D0置00, 选择计数器通道0
        sw x5, 0x0(x3) # x5输出到GPIO端口F0000000, 计数器通道counter_set=00端口不变
        lw x5, 0x0(x3) # 再读GPIO端口F0000000状态
        and x11, x5, x8 # 取最高位=out0, 屏蔽其余位送x11
        add x13, x13, x2 # 程序计数延时
        beq x13, zero, C_init # 程序计数x13=0, 转计数器初始化, 修改7段码显示: C_init

        l_next: # 判断7段码显示模式：SW[4: 3]控制
        lw x5, 0x0(x3) # 再读GPIO端口F0000000开关SW状态
        add x18, x14, x14 # x14=4, x18=00000008
        add x22, x18, x18 # x22=00000010
        add x18, x18, x22 # x18=00000018(00011000)
        and x11, x5, x18 # 取SW[4: 3]
        beq x11, zero, L20 # SW[4: 3]=00, 7段显示"点"循环移位：L20, SW0=0
        beq x11, x18, L21 # SW[4: 3]=11, 显示七段图形, L21, SW0=0
        add x18, x14, x14 # x18=8
        beq x11, x18, L22 # SW[4: 3]=01, 七段显示预置数字, L22, SW0=1
        sw x9, 0x0(x4) # SW[4: 3]=10, 显示x9, SW0=1
        jal zero, loop2

        L20:
        beq x10, x1, L4 # x10=ffffffff, 转移L4
        jal zero, L3

        L4:
        addi x10, zero, -1 # x10=ffffffff
        add x10, x10, x10 # x10=fffffffe

        L3:
        sw x10, 0x0(x4) # SW[4: 3]=00, 7段显示点移位后显示
        jal zero, loop2

        L21:
        lw x9, 0x60(x17) # SW[4: 3]=11, 从内存取预存七段图形
        sw x9, 0x0(x4) # SW[4: 3]=11, 显示七段图形
        jal zero, loop2

        L22:
        lw x9, 0x20(x17) # SW[4: 3]=01, 从内存取预存数字
        sw x9, 0x0(x4) # SW[4: 3]=01, 七段显示预置数字
        jal zero, loop2

        C_init:
        lw x13, 0x14(zero) # 取程序计数延时初始化常数
        add x10, x10, x10 # x10=fffffffc, 7段图形点左移121 or x10, x10, x2 # x10末位置1, 对应右上角不显示
        add x17, x17, x14 # x17=00000004, LED图形访存地址+4
        and x17, x17, x20 # x17=000000XX, 屏蔽地址高位, 只取6位
        add x9, x9, x2 # x9+1
        beq x9, x1, L6 # 若x9=ffffffff, 重置x9=5
        jal zero, L7

        L6:
        add x9, zero, x14 # x9=4
        add x9, x9, x2 # 重置x9=5

        L7:
        lw x5, 0x0(x3) # 读GPIO端口F0000000状态
        add x11, x5, x5
        add x11, x11, x11 # 左移2位将SW与LED对齐, 同时D1D0置00, 选择计数器通道0
        sw x11, 0x0(x3) # x5输出到GPIO端口F0000000, 计数器通道counter_set=00端口不变
        sw x6, 0x4(x3) # 计数器端口: F0000004, 送计数常数x6=F8000000
        jal zero, l_next
        ```
    === "IMem.coe"

        ```
        memory_initialization_radix=16;
        memory_initialization_vector=
        0200006F, 00000033, 00000033, 00000033, 00000033,
        00000033, 00000033, 00000033, FFF00093, 0010C193,
        003181B3, 003181B3, 003181B3, 003181B3, 003181B3,
        0011CA33, 003181B3, 003181B3, 003181B3, 003181B3,
        003181B3, 003181B3, 003181B3, 003181B3, 003181B3,
        003181B3, 003181B3, 003181B3, 003181B3, 003181B3,
        003181B3, 003181B3, 003181B3, 003181B3, 003181B3,
        003181B3, 00318333, 006301B3, 00318233, 004206B3,
        00D68433, 00106D13, 0FFD7D13, 01A45DB3, 0000A133,
        0000A113, 00210733, 00E70733, 40E709B3, 0019D993,
        FFF98513, 00056533, 00A50533, 0061A223, 0001A283,
        005282B3, 005282B3, 0051A023, 002484B3, 00922023,
        01402683, 0001A283, 005282B3, 005282B3, 0051A023,
        0001A283, 0082F5B3, 002686B3, 06068063, 0001A283,
        00E70933, 01290B33, 01690933, 0122F5B3, 00058C63,
        03258663, 00E70933, 03258863, 00922023, FB9FF06F,
        00150463, 00C0006F, FFF00513, 00A50533, 00A22023,
        FA1FF06F, 0608A483, 00922023, F95FF06F, 0208A483,
        00922023, F89FF06F, 01402683, 00A50533, 00E888B3,
        0148F8B3, 002484B3, 00148463, 00C0006F, 00E004B3,
        002484B3, 0001A283, 005285B3, 00B585B3, 00B1A023,
        0061A223, F6DFF06F;
        ```

    === "DMem.coe"
        ```
        memory_initialization_radix=16;
        memory_initialization_vector=
        f0000000, 000002AB, 80000000, 0000003F, 00000001, FFF70000, 0000FFFF, 80000000, 00000000, 11111111, 
        22222222, 33333333, 44444444, 55555555, 66666666, 77777777, 88888888, 99999999, aaaaaaaa, bbbbbbbb, 
        cccccccc, dddddddd, eeeeeeee, ffffffff, 557EF7E0, D7BDFBD9, D7DBFDB9, DFCFFCFB, DFCFBFFF, F7F3DFFF,
        FFFFDF3D, FFFF9DB9, FFFFBCFB, DFCFFCFB, DFCFBFFF, D7DB9FFF, D7DBFDB9, D7BDFBD9, FFFF07E0, 007E0FFF,
        03bdf020, 03def820, 08002300;
        ```

你需要修改 `DMem.coe` 中的 `00000000, 11111111, 22222222..., ffffffff` 部分，将它修改为你的学号(如 3210101145)与日期(如 230313)。修改后，这一段应为：

```
...
33333333, 22222222, 11111111, 00000000, 11111111, 00000000, 11111111, 
11111111, 44444444, 55555555, 22222222, 33333333, 00000000, 33333333,
11111111, 33333333
...
```

使用验收代码的预期表现：

* Graphics 模式下
    * `SW[4:3] = 00`
        * 重启后，七段数码管依次亮起。
        * 只在重启后亮一次，之后不变。
    * `SW[4:3] = 11`
        * 变化的矩形
* Number 模式下
    * `SW[4:3] = 01`
        * 显示你的学号与日期
    * `SW[4:3] = 10`
        * 数字自增

如果在某模式下你的表现与预期不符，请查看该模式对应代码，缩小检查范围。

!!! Tip "**如果你的下板现象并不符合预期**😭"
    * 四种现象完全没有，全部乱码，数码管显示 55AA。CPU 实现有严重错误，使用 testbench 与自己的测试代码进行仿真测试，调整到指令测试无误再下板。
    * LED 灯和开关不同步。考虑 `lw, sw, shift` 等指令是否正确。
    * 开机现象有，但是卡住不动。考虑 `slt` 指令是否正确。
    * 开机现象和自增有，学号和矩形动画没有。考虑 RAM 内容是否正确载入。
    * 仅矩形动画不正确。考虑 `jalr` 指令是否正确。

## 实验要求

* 实现 CtrlUnit 和 DataPath，得到自行实现的 SCPU。
* 对实现的 CPU 进行仿真验证、下板验证、验收。
* 实验报告里需要包含的内容：
    * CtrlUnit 和 DataPath 代码（包括 ImmGen 等子模块）并简要分析。
    * 仿真代码与波形截图（注意缩放比例、数制选择合适），并分析仿真波形。   
        * 你需要完成 SCPU_ctrl、ImmGen 的仿真测试（使用我们给的仿真代码或者自行书写），以及 SCPU 的仿真测试（自行书写仿真代码）。
    * 下板图片与现象描述。