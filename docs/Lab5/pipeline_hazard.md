# 解决冲突

# Task

* Implement a 5-stage pipelined CPU (1 weeks), which can solve the hazard with appropriate bubbles.
    *Based on Lab5-2 & Lab5-3*.
* Use Lab4-3 code to check your implementation.
* Design your own validate code for your report.

# Report

* Write one report to presentate your pipelined CPU with hazard handling.

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