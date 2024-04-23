# 解决冲突

## 模块实现

本实验需要实现一个可以处理冲突的五阶段流水线 CPU。在 Lab5-1 的基础上，处理数据冒险和结构冒险。

* 你需要基于 Lab4-3 或者 Lab5-1 的代码进行修改。
* 对于**数据冒险**，你可以通过 stall 或者 forwarding（前递）的方式解决冲突。
* 对于**结构冒险**，你可以通过 stall 或者 branch prediction（分支预测）的方式解决冲突。
    * 常见的 branch prediction 算法有：predict-taken（预测分支总是发生）、predict-not-taken（预测分支总是不发生）、2-bit predict（两位预测器）等。
* 如果你使用了 forwarding 解决数据冒险或者使用了 branch prediction 解决结构冒险，我们可以给予你一定的 **bonus** 作为奖励（分数仅记入本次实验，无法溢出到平时分），你需要在你的报告中说明你的实现。如果你对 forwarding、branch prediction 的实现有疑惑，请回顾理论课所讲内容。
* 无论你是先完成 Lab5-1 再完成 Lab5-2，还是直接进行 Lab5-2。验收时，你都需要提供自己绘制的 CPU datapath 图。原理图不必包括冒险的处理。
* 流水线的验证较为繁琐，良好的仿真测试可以事半功倍。请做好仿真验证，让仿真代码尽量覆盖所有情况。

!!! Tip
    * 在 Lab5-1 的验收代码里，我们在每两条指令之间放入 3 条 `add zero, zero, zero` 指令就可以保证避免冲突。回顾理论课所讲的 **Double Bump** 原理，实际上我们只需要 2 个 nop 即可做到这一点。结合自己的实现思考相关时序是否能做到 Double Bump（注意到我们流水线寄存器也是在时钟边沿赋值）。
    * 对于数据冒险，请思考是否考虑完整了所有情况。
    * 注意到 forwarding 无法解决所有的数据冒险，如 load-use hazard。

## 仿真验证

代码参照 [Lab4 验收代码](../Lab4/instr_extension.md#check_code)。请自行修改代码，使得其测试尽可能多的流水线冲突情况，并在实验报告中标注出你添加的测试代码。

## 下板验证

验收时，你需要使用以下验收代码。IMem.coe、DMem.coe 的内容和格式与 Lab4-3 相同。验收代码、使用验收代码的预期表现与 Lab4-3 的结果基本相同。区别在于在本次实验中，因为存在冒险和分支指令（forwarding 和 branch prediction 无法完全避免 stall 的出现），因此执行的速度会比 Lab4-3 中略慢，快于 Lab5-1 的结果。

??? tip "验收代码"
    ``` linenums="1" 
    auipc x26, 0x40
    auipc x27, 0x80
    srli x27, x27, 3
    slli x27, x27, 3
    srai x27, x27, 1
    bne x27, x26, dummy
    lui x26, 0x40000
    lui x27, 0x80000
    srai x27, x27, 1
    beq x27, x26, dummy

    # change your first digit in Studen ID to 3320'2233
    addi x24, zero, 0x22
    sb x24, 0x21(zero)
    addi x24, zero, 0x20
    sb x24, 0x22(zero)

    # change your second digit in Studen ID to 2204'2122
    addi x24, zero, 0x421
    sh x24, 0x25(zero)

    start:
    addi x1, zero, -1 # x1=FFFFFFFF
    lb x24, 0x18(zero) # x24=FFFFFFFF
    bne x1, x24, dummy
    lbu x24, 0x18(zero)# x24=000000FF
    bge x1, x24, dummy
    lh x24, 0x60(zero) # x24=FFFFF7E0
    blt zero, x24, dummy
    lhu x24, 0x60(zero) # x24=0000F7E0
    blt x24, zero, dummy
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
    lui x8, 0x80000 # x8=80000000
    ori x26, zero, 1 # x26=00000001
    andi x26, x26, 0xff # x26=00000001
    sra x30, x8, x26
    srl x27, x8, x26

    blt zero, zero, dummy
    blt x26, zero, dummy
    blt zero, x8, dummy

    bge zero, x26, dummy
    bge x8, zero, dummy

    bne x27, x30, loop

    dummy:
    add zero, zero, zero # 4
    add zero, zero, zero # 8
    add zero, zero, zero # C
    add zero, zero, zero # 10
    add zero, zero, zero # 14
    add zero, zero, zero # 18
    add zero, zero, zero # 1C
    jal zero, dummy

    loop:
    slt x2, x1, zero # x2=00000001 针对ALU32位有符号数减
    sltu x25, x1, zero # x25=00000000
    sltiu x29, x1, 0 # x29=00000000
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
    slli x5, x5, 2 # 左移2位将SW与LED对齐, 同时D1D0置00, 选择计数器通道0
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
    bltu zero, x4, loop2

    L20:
    beq x10, x1, L4 # x10=ffffffff, 转移L4\\
    bgeu x4, zero, L3

    L4:
    addi x10, zero, -1 # x10=ffffffff
    add x10, x10, x10 # x10=fffffffe

    L3:
    sw x10, 0x0(x4) # SW[4: 3]=00, 7段显示点移位后显示
    jal zero, loop2

    L21:
    lw x9, 0x60(x17) # SW[4: 3]=11, 从内存取预存七段图形
    sw x9, 0x0(x4) # SW[4: 3]=11, 显示七段图形
    addi x31, zero, 0x150
    jalr zero, x31, 0x24 #jump to pc 0x174

    L22:
    lw x9, 0x20(x17) # SW[4: 3]=01, 从内存取预存数字
    sw x9, 0x0(x4) # SW[4: 3]=01, 七段显示预置数字
    blt x4, zero, loop2

    C_init:
    lw x13, 0x14(zero) # 取程序计数延时初始化常数
    add x10, x10, x10 # x10=fffffffc, 7段图形点左移121 or x10, x10, x2 # x10末位置1, 对应右上角不显示
    add x17, x17, x14 # x17=00000004, LED图形访存地址+4
    and x17, x17, x20 # x17=000000XX, 屏蔽地址高位, 只取6位
    add x9, x9, x2 # x9+1
    beq x9, x1, L6 # 若x9=ffffffff, 重置x9=5
    bge zero, zero, L7

    L6:
    add x9, zero, x14 # x9=4
    add x9, x9, x2 # 重置x9=5

    L7:
    lw x5, 0x0(x3) # 读GPIO端口F0000000状态
    add x11, x5, x5
    slli x11, x11, 1 # 左移2位将SW与LED对齐, 同时D1D0置00, 选择计数器通道0
    sw x11, 0x0(x3) # x5输出到GPIO端口F0000000, 计数器通道counter_set=00端口不变
    sw x6, 0x4(x3) # 计数器端口: F0000004, 送计数常数x6=F8000000
    bge zero, x4, l_next
    ```

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