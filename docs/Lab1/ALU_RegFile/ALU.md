# ALU

ALU (Arithmetic Logic Unit) 是负责对二进制整数进行算术运算和位运算的组合电路部件，本实验要求你设计一个32位的能够对两个输入进行：按位与/或/异或、无符号数加法/减法/溢出、逻辑右移。

## 模块实现

!!! note "报告中需要给出你写出的完整代码。"

你可以在两种实现方式中选择：

* 仿照 slides p12，使用提供的 IP core 完成（你需要使用 Verilog 而非原理图实现）；或
* （更推荐）参考[标准](https://ieeexplore.ieee.org/document/1620780)第5.1节 *Operators*，使用运算符完成。
    * 你可能需要参考标准第5.5节 *Signed expressions*，使用 `$signed(), $unsigned()` 完成实验。

不论你采用何种方式，你的模块名与端口名应为：

```verilog linenums="1" title="ALU.v"
module ALU (
  input [31:0]  A,
  input [31:0]  B,
  input [2:0]   ALU_operation, // 也可以直接写为 wire [3:0]，请见下文 2023.3.5 更新
  output[31:0]  res,
  output        zero
);
// Your code

endmodule
```

???+ tip "**2023.3.9**更新：对于移位指令（如 SRA ）的解释"
    指令 `sra rd, rs1, rs2`：把寄存器 `x[rs1]` 右移 `x[rs2]` 位，空位用 `x[rs1]` 最高位填充，结果写入 `x[rd]`。 **`x[rs2]` 的低 5 位为移动位数，高位则被忽略**。与 SRA 类似，其他移位指令 SRL、SLL 的移动位数都取决于**低 5 位**而非整体数值。

    相应的， ALU 中 SRA 的含义为，将输入 `A` 右移 `B[4:0]` 位，高位用 `A[31]` 填充。比如：`A = 32'hDEADBEEF, B = 32'hF00000E4` 的 SRA 结果为 `32'hFDEADBEE`，因为 `A` 的最高位为 `1` 且 `B` 的低 5 位为 `5'b0_0100`，将 `A` 右移 4 位高位补 `1` 即得到结果。

???+ tip "**2023.3.5**更新：对于 `ALU_operation` 的解释"
    本次实验中，你只需要根据 slides 提供的原理图实现 ADD, SUB, XOR, SRL, OR, AND, SLT 指令；也可以一次到位，直接将 `ALU_operation` 拓展为4位并实现全部指令。这对你本实验的实验分数没有任何影响。

    本次实验的 ALU 实现的功能并不足以在之后的实验中直接使用，在之后的实验中，你要实现的完整操作如下：

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
    
    需要注意的是，上表 `ALU_operation` 值与操作的对应和本实验并不完全相同，比如本实验中 `SLT` 对应 `3'b111` 而在之后的约定中对应 `4'b11`。
    


## 仿真测试

!!! note "报告中需要给出 testbench 代码，测试波形与解释（波形截图需要保证缩放与变量数制合适）。"

基础的仿真波形已经在附件 `ALU/ALU_tb.v`，但它过于简单，你需要添加若干边界测试以完善。


!!! question "思考题"
    现在对 ALU 进行拓展，要求修改 ALU 以**支持两个有符号数的大小比较**，你需要添加哪些端口以支持？（Hint：目前的ALU将两个输入都视作无符号数； `zero` 信号仅能用来判断是否相等）

## 封装IP Core

将你实现的 ALU 封装为 IP core 以便之后调用。
