# Register Files

RV32I 可以使用的整型寄存器共有32个，本节将实现一个有32个 32-bit 寄存器的寄存器组。

## 模块实现

!!! note "报告中需要给出你写出的完整代码。"

Register File 需要实现读写指定寄存器的功能，并保证一定的时序。需要注意的是，**第 0 号寄存器需要始终保持恒定值 0**，无法通过写寄存器修改其值。

考虑一个简单的指令 `add x1, x2, x3`，它的含义是计算寄存器 `x2` 与 `x3` 的和，并将结果保存到寄存器 `x1` 中；在这个指令中 `x2, x3` 被称为源寄存器(Source Registers, `rs`)，`x1` 被称为目的寄存器(Destination Register, `rd`)。

观察到，我们有可能在一个指令运算中需要读取两个源寄存器的值，因此需要同时支持两个读口；本次实验只需要在时钟**上升沿**进行一次写，即一个时钟周期只进行最多一次的寄存器写。

如果你对 Verilog 的结构和语法很生疏，请先学习基础内容，如 `always` 块、赋值等。

在附件 `Regs/Regs.v` 给出端口的基础上，你需要添加32个固定的地址读口**以便Lab4中直接使用**，你的端口应类似于：

```verilog linenums="1" title="Regs.v"
module Regs(
	input clk,
	input rst,
	input [4:0] Rs1_addr, 
	input [4:0] Rs2_addr, 
	input [4:0] Wt_addr, 
	input [31:0]Wt_data, 
	input RegWrite, 
	output [31:0] Rs1_data, 
	output [31:0] Rs2_data,
	output [31:0] Reg00,
	output [31:0] Reg01,
	...,
	output [31:0] Reg31
);
// Your code here

endmodule
```

## 仿真测试

!!! note "报告中需要给出testbench代码，测试波形与解释（波形截图需要保证缩放与变量数制合适）。"

给出基本的测试代码如下，你需要补充完善测试更多情况。

```verilog linenums="1" title="Regs_tb.v"
`timescale 1ns / 1ns

module Regs_tb;
    reg clk;
    reg rst;
    reg [4:0] Rs1_addr; 
    reg [4:0] Rs2_addr; 
    reg [4:0] Wt_addr; 
    reg [31:0]Wt_data; 
    reg RegWrite; 
    wire [31:0] Rs1_data; 
    wire [31:0] Rs2_data;
    Regs Regs_U(
        .clk(clk),
        .rst(rst),
        .Rs1_addr(Rs1_addr),
        .Rs2_addr(Rs2_addr),
        .Wt_addr(Wt_addr),
        .Wt_data(Wt_data),
        .RegWrite(RegWrite),
        .Rs1_data(Rs1_data),
        .Rs2_data(Rs2_data)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        RegWrite = 0;
        Wt_data = 0;
        Wt_addr = 0;
        Rs1_addr = 0;
        Rs2_addr = 0;
        #100
        rst = 0;
        RegWrite = 1;
        Wt_addr = 5'b00101;
        Wt_data = 32'ha5a5a5a5;
        #50
        Wt_addr = 5'b01010;
        Wt_data = 32'h5a5a5a5a;
        #50
        RegWrite = 0;
        Rs1_addr = 5'b00101;
        Rs2_addr = 5'b01010;
        
        #100 $stop();
    end

endmodule
```