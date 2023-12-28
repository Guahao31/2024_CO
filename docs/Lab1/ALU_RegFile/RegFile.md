# Register Files

RV32I 可以使用的整型寄存器共有32个，本节将实现一个有32个 32-bit 寄存器的寄存器组。

## 模块实现

!!! note "报告中需要给出你写出的完整代码。"

Register File 需要实现读写指定寄存器的功能，并保证一定的时序。

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

附件 `Regs/Regs_tb.v` 给出了基本的测试代码，你需要补充完善测试更多情况。

## 封装IP Core

参考slides p22-27 解决封装过程中 `clk, rst` 两个信号的问题。
