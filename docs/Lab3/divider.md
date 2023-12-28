# 除法器

你可以从理论课学到的几个版本中任选一个算法完成实验，基本的要求是**无符号、无溢出判断、有除零异常判断**，如果你不实现除零异常判断将无法获得全部的实验分数。

## 模块实现

!!! note "报告中需要给出你写出的完整代码。"

你的模块与端口名应该与下列相同：

```verilog title="divider.v"
module divider(
    input   clk,
    input   rst,
    input   start,          // 开始运算
    input[31:0] dividend,   // 被除数
    input[31:0] divisor,    // 除数
    output divide_zero,     // 除零异常
    output  finish,         // 运算结束信号
    output[31:0] res,       // 商
    output[31:0] rem        // 余数
);
```

如果除数是零，则直接将 `finish` 与 `divide_zero` 升至高位即可，此时 `res` 与 `rem` 可以是任意值。

## 仿真测试

!!! note "报告中需要给出 testbench 代码，测试波形与解释（波形截图需要保证缩放与变量数制合适）。"

附件中的 [divider_tb.v](./attachment/divider_tb.v) 已经给出了基本的测试代码，你需要添加更多的测试样例，尽可能多测试边界样例。