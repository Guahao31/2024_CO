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
* 请注意 RAM 中的数据存放方式为**小端序**，即数据的最低有效字节存放在最低的内存地址，最高有效字节存放在最高的内存地址。
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

为了方便测试，我们需要搭建一个简单的仅包含 SCPU 以及 Mem(IMem & DMem) 的测试平台。你可以直接使用以下代码，如果你的端口名与之不同请自行修改。

搭建好测试平台后，**请自行书写测试代码**，生成 ROM 核，并进行仿真。

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

## 下板验证

验收时，你需要使用以下验收代码。

??? tip "验收代码"
    === "check_code.s"

        ```linenums="1"
            j    start            # 00
        dummy:
            nop                   # 04
            nop                   # 08
            nop                   # 0C
            nop                   # 10
            nop                   # 14
            nop                   # 18
            nop                   # 1C
            j    dummy

        start:
            beq  x0, x0, pass_0
            li   x31, 0
            j    dummy
        pass_0:
            li   x1, -1           # x1=FFFFFFFF
            xori x3, x1, 1        # x3=FFFFFFFE
            add  x3, x3, x3       # x3=FFFFFFFC
            add  x3, x3, x3       # x3=FFFFFFF8
            add  x3, x3, x3       # x3=FFFFFFF0
            add  x3, x3, x3       # x3=FFFFFFE0
            add  x3, x3, x3       # x3=FFFFFFC0
            add  x3, x3, x3       # x3=FFFFFF80
            add  x3, x3, x3       # x3=FFFFFF00
            add  x3, x3, x3       # x3=FFFFFE00
            add  x3, x3, x3       # x3=FFFFFC00
            add  x3, x3, x3       # x3=FFFFF800
            add  x3, x3, x3       # x3=FFFFF000
            add  x3, x3, x3       # x3=FFFFE000
            add  x3, x3, x3       # x3=FFFFC000
            add  x3, x3, x3       # x3=FFFF8000
            add  x3, x3, x3       # x3=FFFF0000
            add  x3, x3, x3       # x3=FFFE0000
            add  x3, x3, x3       # x3=FFFC0000
            add  x3, x3, x3       # x3=FFF80000
            add  x3, x3, x3       # x3=FFF00000
            add  x3, x3, x3       # x3=FFE00000
            add  x3, x3, x3       # x3=FFC00000
            add  x3, x3, x3       # x3=FF800000
            add  x3, x3, x3       # x3=FF000000
            add  x3, x3, x3       # x3=FE000000
            add  x3, x3, x3       # x3=FC000000
            add  x5, x3, x3       # x5=F8000000
            add  x3, x5, x5       # x3=F0000000
            add  x4, x3, x3       # x4=E0000000
            add  x6, x4, x4       # x6=C0000000
            add  x7, x6, x6       # x7=80000000
            ori  x8, zero, 1      # x8=00000001
            ori  x28, zero, 31
            srl  x29, x7, x28     # x29=00000001
            beq  x8, x29, pass_1
            li   x31, 1
            j    dummy

        pass_1:
            nop
            sub  x3, x6, x7       # x3=40000000
            sub  x4, x7, x3       # x4=40000000
            slti x9, x0, 1        # x9=00000001
            slt  x10, x3, x4
            slt  x10, x4, x3      # x10=00000000
            beq  x9, x10, dummy   # branch when x3 != x4
            srli x29, x3, 30      # x29=00000001
            beq  x29, x9, pass_2
            li   x31, 2
            j    dummy

        pass_2:
            nop
        # Test signed set-less-than
            slti x10, x1, 3       # x10=00000001
            slt  x11, x5, x1      # signed(0xF8000000) < -1
                                # x11=00000001
            slt  x12, x1, x3      # x12=00000001
            andi x10, x10, 0xff
            and  x10, x10, x11
            and  x10, x10, x12    # x10=00000001
            li   x11, 1
            beq  x10, x11, pass_3
            li   x31, 3
            j    dummy

        pass_3:
            nop
            or   x11, x7, x3      # x11=C0000000
            beq  x11, x6, pass_4
            li   x31, 4
            j    dummy

        pass_4:
            nop
            li   x18, 0x20        # base addr=0x20
        ### uncomment instr. below when simulating on venus
            # srli x18, x7, 3     # base addr=10000000
            sw   x5, 0(x18)       # mem[0x20]=F8000000
            sw   x4, 4(x18)       # mem[0x24]=C0000000
            lw   x29, 0(x18)      # x29=mem[0x20]=F8000000
            xor  x29, x29, x5     # x29=00000000
            sw   x6, 0(x18)       # mem[0x20]=E0000000
            lw   x30, 0(x18)      # x30=mem[0x20]=E0000000
            xor  x29, x29, x30    # x29=E0000000
            beq  x6, x29, pass_5
            li   x31, 5
            j    dummy

        pass_5:
            li   x31, 0x666
            j    dummy
        ```

    === "IMem.coe"

        ```
        memory_initialization_radix=16;
        memory_initialization_vector=
        0240006F,
        00000013,
        00000013,
        00000013,
        00000013,
        00000013,
        00000013,
        00000013,
        FE5FF06F,
        00000663,
        00000F93,
        FD9FF06F,
        FFF00093,
        0010C193,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003181B3,
        003182B3,
        005281B3,
        00318233,
        00420333,
        006303B3,
        00106413,
        01F06E13,
        01C3DEB3,
        01D40663,
        00100F93,
        F41FF06F,
        00000013,
        407301B3,
        40338233,
        00102493,
        0041A533,
        00322533,
        F2A482E3,
        01E1DE93,
        009E8663,
        00200F93,
        F15FF06F,
        00000013,
        0030A513,
        0012A5B3,
        0030A633,
        0FF57513,
        00B57533,
        00C57533,
        00100593,
        00B50663,
        00300F93,
        EE9FF06F,
        00000013,
        0033E5B3,
        00658663,
        00400F93,
        ED5FF06F,
        00000013,
        02000913,
        00592023,
        00492223,
        00092E83,
        005ECEB3,
        00692023,
        00092F03,
        01EECEB3,
        01D30663,
        00500F93,
        EA5FF06F,
        66600F93,
        E9DFF06F;
        ```

???+ note "伪指令"
    在验收代码中，你会看到 `li, j, bnez` 等你并不熟悉的指令，这些指令都是“伪指令”。伪指令在标准指令集之外，**不是真正的机器指令**，而是汇编语言级别上提供的语法糖（或宏指令），用于简化编程并提高代码可读性。在实际的机器指令级别，它们会被汇编器翻译成等效的一条或多条标准指令来执行。下面简单介绍本次验收代码中给出的 RV32 伪指令，其他伪指令可以自行搜索：

    1. **`li(load immediate)`**，用于将一个立即数加载到寄存器中。**少于 12 位**的立即数加载，如 `li x1, 0x666`，可以翻译成 `addi x1, x0, 0x666` 一条指令完成；大立即数，如 `li x1, 0x66666666`，可以翻译成 `lui x1, 0x66666; addi x1, x1, 0x666` 两条指令来完成。
    2. **`j(jump)`**，用于无条件跳转到一个标签处。如 `j label` 会被翻译成 `jal x0, label`。

使用上述验收代码，如果没有非常严重的实现问题，不论是否通过测试，最后都会进入 `dummy` 的死循环，进入循环后，`x31(t6)` 寄存器会存放一个值，若为 `0x666` 即表示验收代码通过。

如果 `x31` 的值并不是 `0x666`，表明你的实现存在问题，你可以在 `check_code.s` 中搜索 `li   x31,` 快速定位产生问题的检测点；如果并没有进入 `dummy`，你的实现有严重问题，请从头开始单步调试，直到发现并解决问题。

给出的验收代码是完成验收的最低标准，我们很欢迎对验收代码的补充完善，优秀的测试代码将获得本实验的加分。

## 实验要求

* 实现 CtrlUnit 和 DataPath，得到自行实现的 SCPU。
* 对实现的 CPU 进行仿真验证、下板验证、验收。
* 实验报告里需要包含的内容：
    * CtrlUnit 和 DataPath 代码（包括 ImmGen 等子模块）并简要分析。
    * 仿真代码与波形截图（注意缩放比例、数制选择合适），并分析仿真波形。   
        * 你需要完成 SCPU_ctrl、ImmGen 的仿真测试（使用我们给的仿真代码或者自行书写），以及 SCPU 的仿真测试（自行书写仿真代码）。
    * 如果你完善了验收代码或自己设计了测试代码，请在报告中给出。