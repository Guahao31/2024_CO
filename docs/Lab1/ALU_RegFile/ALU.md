# ALU

ALU (Arithmetic Logic Unit) 是负责对二进制整数进行算术运算和位运算的组合电路部件，本实验要求你设计一个32位的能够对两个输入进行：无符号数加法/减法与溢出判断、无符号与有符号逻辑/算术移位、按位与/或/异或。

## 模块实现

!!! note "报告中需要给出你写出的完整代码。"

参考[标准](https://ieeexplore.ieee.org/document/1620780)第5.1节 *Operators*，使用运算符完成。你可能需要参考标准第5.5节 *Signed expressions*，使用 `$signed(), $unsigned()` 完成实验。

你的模块名与端口名应为：

```verilog linenums="1" title="ALU.v"
module ALU (
  input [31:0]  A,
  input [31:0]  B,
  input [3:0]   ALU_operation,
  output[31:0]  res,
  output        zero
);
// Your code

endmodule
```

### 功能要求

输入端口中 `A, B` 为数据输入口，`ALU_operation` 用来选择 ALU 执行的运算类型。输出端口中 `res` 用来输出运算结果，`zero` 用来判断运算结果是否为 0。

`ALU_operation` 与运算类型的对应关系如下：

| 操作 | ALU_operation 值 |
| --- | :------------------------------------ |
| ADD | 4'd0 |
| SUB | 4'd1 |
| SLL | 4'd2 |
| SLT | 4'd3 |
| SLTU | 4'd4 |
| XOR | 4'd5 |
| SRL | 4'd6 |
| SRA | 4'd7 |
| OR | 4'd8 |
| AND | 4'd9 |

### 指令解释

#### 算术运算操作

ALU 处理的算术运算操作中 ADD SUB 将两个运算数当作**符号数**参与运算，分别给出结果 `A+B` 与 `A-B`。

比较操作 SLT SLTU 用于比较两操作数，若 `A<B` 则结果为 `1`，否则为 `0`。它们的区别在于，SLT 将运算数视作**符号数**，SLTU 将运算数视作**无符号数**。

#### 位运算操作

XOR OR AND 均为按位操作，输出对应的 `A^B, A|B, A&B` 即可。

移位操作 SLL SRL SRA。以 SLL 为例，本实验要求移位操作的结果是 `A << B[4:0]`，即移动位数由 `B` 的**低五位**决定，`B` 的高位应当忽略。它们的区别在于，逻辑左移 SLL 的结果右侧补 0；逻辑右移 SRL 的结果左侧补 0；算术右移 SRA 的结果左侧补符号位。**举个例子**，`A = 32'hDEADBEEF, B = 32'hF00000E4` 的 SRA 结果为 `32'hFDEADBEE`，因为 `A` 的最高位为 `1` 且 `B` 的低 5 位为 `5'b0_0100`，将 `A` 右移 4 位高位补 `1` 即得到结果。

## 仿真测试

!!! note "报告中需要给出 testbench 代码，测试波形与解释（波形截图需要保证缩放与变量数制合适）。"

基础的仿真波形如下，但它过于简单，你需要添加若干边界测试以完善。

```verilog linenums="1" title="ALU_tb.v"
`timescale 1ns / 1ps

module ALU_tb;
    reg [31:0]  A, B;
    reg [3:0]   ALU_operation;
    wire[31:0]  res;
    wire        zero;
    ALU ALU_u(
        .A(A),
        .B(B),
        .ALU_operation(ALU_operation),
        .res(res),
        .zero(zero)
    );

    initial begin
        A=32'hA5A5A5A5;
        B=32'h5A5A5A5A;
        ALU_operation =4'b1000;
        #100;
        ALU_operation =4'b1001;
        #100;
        ALU_operation =4'b0111;
        #100;
        ALU_operation =4'b0110;
        #100;
        ALU_operation =4'b0101;
        #100;
        ALU_operation =4'b0100;
        #100;
        ALU_operation =4'b0011;
        #100;
        ALU_operation =4'b0010;
        #100;
        ALU_operation =4'b0001;
        #100;
        ALU_operation =4'b0000;
        #100;
        A=32'h01234567;
        B=32'h76543210;
        ALU_operation =4'b0111;
    end
endmodule
```