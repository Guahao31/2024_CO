# 解决冲突

## 模块实现

本实验需要实现一个可以处理冲突的五阶段流水线 CPU。在 Lab5-1 的基础上，处理数据冒险和结构冒险。

* 你需要基于 Lab4-3 或者 Lab5-1 的代码进行修改。
* 对于**数据冒险**，你可以通过 stall 或者 forwarding（前递）的方式解决冲突。
* 对于**控制冒险**，你可以通过 stall 或者 branch prediction（分支预测）的方式解决冲突。
    * 常见的 branch prediction 算法有：predict-taken（预测分支总是发生）、predict-not-taken（预测分支总是不发生）、2-bit predict（两位预测器）等。
* 如果你使用了 forwarding 解决数据冒险或者使用了 branch prediction 解决结构冒险，我们可以给予你一定的 **bonus** 作为奖励（分数仅记入本次实验，无法溢出到平时分），你需要在你的报告中说明你的实现。如果你对 forwarding、branch prediction 的实现有疑惑，请回顾理论课所讲内容。
* 无论你是先完成 Lab5-1 再完成 Lab5-2，还是直接进行 Lab5-2。验收时，你都需要提供自己绘制的 CPU datapath 图。
* 流水线的验证较为繁琐，良好的仿真测试可以事半功倍。请做好仿真验证，让仿真代码尽量覆盖所有情况。

!!! Tip
    * 在 Lab5-1 的验收代码里，我们在每两条指令之间放入 3 条 `add zero, zero, zero` 指令就可以保证避免冲突。回顾理论课所讲的 **Double Bump** 原理，实际上我们只需要 2 个 nop 即可做到这一点。结合自己的实现思考相关时序是否能做到 Double Bump（注意到我们流水线寄存器也是在时钟边沿赋值）。
    * 对于数据冒险，请思考是否考虑完整了所有情况。
    * 注意到 forwarding 无法解决所有的数据冒险，如 load-use hazard。

## 仿真验证

请自行设计仿真代码，要求必须包含所有的数据冒险类型，请解释你的代码与波形。

## 下板验证

代码参照 [Lab4 验收代码](../Lab4/instr_extension.md#check_code)。请自行修改代码，使得其测试尽可能多的流水线冲突情况，并在实验报告中标注出你添加的测试代码。

## 实验要求

本次实验你需要完成的内容有：

* 绘制自己的 CPU datapath 图。（如果 Lab5-1 中已经完成此步，这里不用再重复绘制）
* 根据自己的 datapath 完成处理冲突的五阶段流水线 CPU。
* 对实现的 CPU 进行仿真验证、下板验证、验收。
* 实验报告里需要包含的内容：
    * datapath 图。（如果 Lab5-1 中已经完成此步，这里不用再贴在报告里）
    * 流水线 CPU 代码（重点部分结合 datapath 和 Verilog 代码解释）
        * 如果你实现了 forwarding 或者 branch prediction，需要在报告中解释你的实现。
    * 仿真代码与波形截图（注意缩放比例、数制选择合适），并分析仿真波形。
        * 如果你实现了 forwarding 或者 branch prediction，需要在报告的波形分析中标出 forwarding 或者 branch prediction 起作用的位置，并加以分析。
    * 下板图片与现象描述。
    * 实验思考题。


## 思考题

!!! question "思考题"
    * 基于你完成的流水线，对于以下两段代码分别分析：不同指令之间是否存在冲突（如果有，请逐条列出）、在你的流水线上运行的 CPI 为何。
    ```assemble title="TP-0" linenums="1"
    addi    x1, x0, 0
    addi    x2, x0, -1
    addi    x3, x0, 1
    addi    x4, x0, -1
    addi    x5, x0, 1
    addi    x6, x0, -1
    addi    x1, x1, 0
    addi    x2, x2, 1
    addi    x3, x3, -1
    addi    x4, x4, 1
    addi    x5, x5, -1
    addi    x6, x6, 1
    ```
    ```assemble title="TP-1" linenums="1"
    addi    x1, x0, 1
    addi    x2, x1, 2
    addi    x3, x1, 3
    addi    x4, x3, 4
    ```
    * 请根据你的实现，在 testbench 上仿真以下代码，给出仿真结果，并写出完成所有指令用了多少拍，必须给出的信号有 `clk, IF-PC, ID-PC` 以及所有用到的寄存器值。**请务必注意调整数制为十六进制，缩放能够看到所有信号值！！！**
        * 如果你实现的流水线仅通过 stall 解决数据冲突
        ```assemble title="TP-2" linenums="1"
        addi    x1, x0, 1
        addi    x2, x1, 2
        addi    x0, x0, 0
        addi    x0, x0, 0
        addi    x0, x0, 0
        addi    x1, x0, 3
        addi    x2, x0, 4
        addi    x3, x1, 5
        addi    x4, x2, 6
        addi    x0, x0, 0
        addi    x0, x0, 0
        addi    x5, x4, 7
        ```
        * 如果你实现的流水线支持 Forwarding
        ```assemble title="TP-3" linenums="1"
        addi    x1, x0, 1
        addi    x2, x1, 2
        addi    x3, x2, 3
        sw      x3, 0(x0)
        lw      x4, 0(x0)
        addi    x5, x4, 4
        addi    x6, x4, 5
        ```