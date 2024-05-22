# 基础流水线

## 模块实现

本实验需要实现一个五阶段流水线 CPU，流水线的五个阶段分别是：取指（IF）、译码（ID）、执行（EX）、访存（MEM）、写回（WB），不需要处理冲突。（假设本实验的仿真和验收代码均不存在数据冲突和控制冲突的情况）

* 你需要基于 Lab4-3 的代码进行修改。
* 和 Lab4-3 类似地，验收时，你需要提供自己绘制的 CPU datapath 图。（笔者建议在开始本次实验之前就开始绘制，以便更好地理解流水线 CPU 的数据流）你可以参考理论课 PPT 的 datapath 或者其他人的图，但每个人的实现不尽相同，请务必动手绘制属于自己的 datapath。这里以理论课 PPT 的 datapath 为例：

    ![](./pic/datapath.png)

* 流水线的验证较为繁琐，良好的仿真测试可以事半功倍。请做好仿真验证，让仿真代码尽量覆盖所有情况。

!!! Tip
    * 你可能需要改变某些指令的数值，这些指令与 PC 值有关（如 `AUIPC` 和 `JALR` 等）。
    * 流水线寄存器是本次实验的一大重点，在进行实验之前，思考并梳理有哪些值是需要传到下一个阶段的。流水线寄存器部分代码较多，且大部分均为类似代码。为了书写方便，减少出错，笔者建议统一模块、寄存器、变量的命名方式，同时可以利用文本批量替换、Copilot 等工具来加速编写。

## 仿真验证

请使用类似 Lab4 中的 testbench，自行编写仿真代码进行仿真测试。

## 下板验证

??? tip "验收代码"
    === "test_5_1.s"
    
        ``` linenums="1"
            auipc x1, 0
            nop
            nop
            nop
            j start    # 00
            nop
            nop
            nop
        dummy:
            nop
            nop
            nop
            nop
            nop
            nop
            j     dummy
            nop
            nop
            nop
        start:
            bnez  x1, dummy
            nop
            nop
            nop
            beq   x0, x0, pass_0
            nop
            nop
            nop
            li    x31, 0
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            j     dummy
            nop
            nop
            nop
        pass_0:
            li    x31, 1
            nop
            nop
            nop
            bne   x0, x0, dummy
            nop
            nop
            nop
            bltu  x0, x0, dummy
            nop
            nop
            nop
            li    x1, -1           # x1=FFFFFFFF
            nop
            nop
            nop
            xori  x3, x1, 1        # x3=FFFFFFFE
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFFFFC
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFFFF8
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFFFF0
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFFFE0
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFFFC0
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFFF80
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFFF00
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFFE00
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFFC00
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFF800
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFF000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFE000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFFC000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFF8000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFF0000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFE0000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFFC0000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFF80000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFF00000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFE00000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FFC00000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FF800000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FF000000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FE000000
            nop
            nop
            nop
            add   x3, x3, x3       # x3=FC000000
            nop
            nop
            nop
            add   x5, x3, x3       # x5=F8000000
            nop
            nop
            nop
            add   x3, x5, x5       # x3=F0000000
            nop
            nop
            nop
            add   x4, x3, x3       # x4=E0000000
            nop
            nop
            nop
            add   x6, x4, x4       # x6=C0000000
            nop
            nop
            nop
            add   x7, x6, x6       # x7=80000000
            nop
            nop
            nop
            ori   x8, zero, 1      # x8=00000001
            nop
            nop
            nop
            ori   x28, zero, 31
            nop
            nop
            nop
            srl   x29, x7, x28     # x29=00000001
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bne   x8, x29, dummy
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            blt   x8, x7, dummy
            nop
            nop
            nop
            sra   x29, x7, x28     # x29=FFFFFFFF
            nop
            nop
            nop
            and   x29, x29, x3     # x29=x3=F0000000
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bne   x3, x29, dummy
            nop
            nop
            nop
            mv    x29, x8          # x29=x8=00000001
            nop
            nop
            nop
            bltu  x29, x7, pass_1  # unsigned 00000001 < 80000000
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            j     dummy
            nop
            nop
            nop

        pass_1:
            li    x31, 2
            nop
            nop
            nop
            sub   x3, x6, x7       # x3=40000000
            nop
            nop
            nop
            sub   x4, x7, x3       # x4=40000000
            nop
            nop
            nop
            slti  x9, x0, 1        # x9=00000001
            nop
            nop
            nop
            slt   x10, x3, x4
            nop
            nop
            nop
            slt   x10, x4, x3      # x10=00000000
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            beq   x9, x10, dummy   # branch when x3 != x4
            nop
            nop
            nop
            srli  x29, x3, 30      # x29=00000001
            nop
            nop
            nop
            beq   x29, x9, pass_2
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            j     dummy
            nop
            nop
            nop

        pass_2:
        # Test set-less-than
            li    x31, 3
            nop
            nop
            nop
            slti  x10, x1, 3       # x10=00000001
            nop
            nop
            nop
            slt   x11, x5, x1      # signed(0xF8000000) < -1
                                # x11=00000001
            nop
            nop
            nop
            slt   x12, x1, x3      # x12=00000001
            nop
            nop
            nop
            andi  x10, x10, 0xff
            nop
            nop
            nop
            and   x10, x10, x11
            nop
            nop
            nop
            and   x10, x10, x12    # x10=00000001
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            beqz  x10, dummy
            nop
            nop
            nop
            sltu  x10, x1, x8      # unsigned FFFFFFFF < 00000001 ?
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bnez  x10, dummy
            nop
            nop
            nop
            sltu  x10, x8, x3      # unsigned 00000001 < F0000000 ?
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            beqz  x10, dummy
            nop
            nop
            nop
            sltiu x10, x1, 3
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bnez  x10, dummy
            nop
            nop
            nop
            li    x11, 1
            nop
            nop
            nop
            bne   x10, x11, pass_3
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            j     dummy
            nop
            nop
            nop
        pass_3:
            li    x31, 4
            nop
            nop
            nop
            or    x11, x7, x3      # x11=C0000000
            nop
            nop
            nop
            beq   x11, x6, pass_4
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            j     dummy
            nop
            nop
            nop
        pass_4:
            li    x31, 5
            nop
            nop
            nop
            li    x18, 0x20        # base addr=00000020
            nop
            nop
            nop
        ### uncomment instr. below when simulating on venus
        # lui x18, 0x10000 # base addr=10000000
        # nop
        # nop
        # nop
            sw    x5, 0(x18)       # mem[0x20]=F8000000
            nop
            nop
            nop
            sw    x4, 4(x18)       # mem[0x24]=40000000
            nop
            nop
            nop
            lw    x27, 0(x18)      # x27=mem[0x20]=F8000000
            nop
            nop
            nop
            xor   x27, x27, x5     # x27=00000000
            nop
            nop
            nop
            sw    x6, 0(x18)       # mem[0x20]=C0000000
            nop
            nop
            nop
            lw    x28, 0(x18)      # x28=mem[0x20]=C0000000
            nop
            nop
            nop
            xor   x27, x6, x28     # x27=00000000
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bnez  x27, dummy
            nop
            nop
            nop
            lui   x20, 0xA0000     # x20=A0000000
            nop
            nop
            nop
            sw    x20, 8(x18)      # mem[0x28]=A0000000
            nop
            nop
            nop
            lui   x27, 0xFEDCB     # x27=FEDCB000
            nop
            nop
            nop
            srai  x27, x27, 12     # x27=FFFFEDCB
            nop
            nop
            nop
            li    x28, 8
            nop
            nop
            nop
            sll   x27, x27, x28    # x27=FFEDCB00
            nop
            nop
            nop
            ori   x27, x27, 0xff   # x27=FFEDCBFF
            nop
            nop
            nop
            lb    x29, 11(x18)     # x29=FFFFFFA0, little-endian, signed-ext
            nop
            nop
            nop
            and   x27, x27, x29    # x27=FFEDCBA0
            nop
            nop
            nop
            sw    x27, 8(x18)      # mem[0x28]=FFEDCBA0
            nop
            nop
            nop
            lhu   x27, 8(x18)      # x27=0000CBA0
            nop
            nop
            nop
            lui   x20, 0xFFFF0     # x20=FFFF0000
            nop
            nop
            nop
            and   x20, x20, x27    # x20=00000000
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bnez  x20, dummy       # check unsigned-ext
            nop
            nop
            nop
            li    x31, 6
            nop
            nop
            nop
            lbu   x28, 10(x18)     # x28=000000ED
            nop
            nop
            nop
            lbu   x29, 11(x18)     # x29=000000FF
            nop
            nop
            nop
            slli  x29, x29, 8      # x29=0000FF00
            nop
            nop
            nop
            or    x29, x29, x28    # x29=0000FFED
            nop
            nop
            nop
            slli  x29, x29, 16
            nop
            nop
            nop
            or    x29, x27, x29    # x29=FFEDCBA0
            nop
            nop
            nop
            lw    x28, 8(x18)      # x28=FFEDCBA0
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bne   x28, x29, dummy
            nop
            nop
            nop
            sw    x0, 0(x18)       # mem[0x20]=00000000
            nop
            nop
            nop
            sh    x27, 0(x18)      # mem[0x20]=0000CBA0
            nop
            nop
            nop
            li    x28, 0xD0
            nop
            nop
            nop
            sb    x28, 2(x18)      # mem[0x20]=00D0CBA0
            nop
            nop
            nop
            lw    x28, 0(x18)      # x28=00D0CBA0
            nop
            nop
            nop
            # li    x29, 0x00D0CBA0
            lui x29, 3341
            nop
            nop
            nop
            addi x29, x29, -1120
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bne   x28, x29, dummy
            nop
            nop
            nop
            lh    x27, 2(x18)      # x27=000000D0
            nop
            nop
            nop
            li    x28, 0xD0
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bne   x27, x28, dummy
            nop
            nop
            nop
        pass_5:
            li    x31, 7
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bge   x1, x0, dummy    # -1 >= 0 ?
            nop
            nop
            nop
            bge   x8, x1, pass_6   # 1 >= -1 ?
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            j     dummy
            nop
            nop
            nop
        pass_6:
            auipc x30, 0
            nop
            nop
            nop
            bgeu  x0, x1, dummy    # 0 >= FFFFFFFF ?
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bgeu  x8, x1, dummy
            nop
            nop
            nop
            auipc x20, 0
            nop
            nop
            nop
            jalr  x21, x20, 64 # -> pass_7 # just for test : (
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            j     dummy
            nop
            nop
            nop
        pass_7:
        # jalr ->
            addi  x20, x20, 20
            nop
            nop
            nop
            auipc x30, 0
            nop
            nop
            nop
            bne   x20, x21, dummy
            nop
            nop
            nop
            li    x31, 0x666
            nop
            nop
            nop
            j     dummy
            nop
            nop
            nop
        ```

    === "IMEM_5_1.coe"

        ```
        memory_initialization_radix=16;
        memory_initialization_vector=
        00000097,00000013,00000013,00000013,0380006F,00000013,00000013,00000013,00000013,00000013,00000013,00000013,00000013,00000013,FE9FF06F,00000013,00000013,00000013,FC009CE3,00000013,00000013,00000013,04000063,00000013,00000013,00000013,00000F93,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,F99FF06F,00000013,00000013,00000013,00100F93,00000013,00000013,00000013,F6001CE3,00000013,00000013,00000013,F60064E3,00000013,00000013,00000013,FFF00093,00000013,00000013,00000013,0010C193,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003181B3,00000013,00000013,00000013,003182B3,00000013,00000013,00000013,005281B3,00000013,00000013,00000013,00318233,00000013,00000013,00000013,00420333,00000013,00000013,00000013,006303B3,00000013,00000013,00000013,00106413,00000013,00000013,00000013,01F06E13,00000013,00000013,00000013,01C3DEB3,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,D1D41CE3,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,CE744CE3,00000013,00000013,00000013,41C3DEB3,00000013,00000013,00000013,003EFEB3,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,CBD19CE3,00000013,00000013,00000013,00040E93,00000013,00000013,00000013,027EE863,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,C79FF06F,00000013,00000013,00000013,00200F93,00000013,00000013,00000013,407301B3,00000013,00000013,00000013,40338233,00000013,00000013,00000013,00102493,00000013,00000013,00000013,0041A533,00000013,00000013,00000013,00322533,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,BEA48CE3,00000013,00000013,00000013,01E1DE93,00000013,00000013,00000013,029E8863,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,BB9FF06F,00000013,00000013,00000013,00300F93,00000013,00000013,00000013,0030A513,00000013,00000013,00000013,0012A5B3,00000013,00000013,00000013,0030A633,00000013,00000013,00000013,0FF57513,00000013,00000013,00000013,00B57533,00000013,00000013,00000013,00C57533,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,B20504E3,00000013,00000013,00000013,0080B533,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,AE051CE3,00000013,00000013,00000013,00343533,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,AC0504E3,00000013,00000013,00000013,0030B513,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,A8051CE3,00000013,00000013,00000013,00100593,00000013,00000013,00000013,02B51863,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,A59FF06F,00000013,00000013,00000013,00400F93,00000013,00000013,00000013,0033E5B3,00000013,00000013,00000013,02658863,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,A09FF06F,00000013,00000013,00000013,00500F93,00000013,00000013,00000013,02000913,00000013,00000013,00000013,00592023,00000013,00000013,00000013,00492223,00000013,00000013,00000013,00092D83,00000013,00000013,00000013,005DCDB3,00000013,00000013,00000013,00692023,00000013,00000013,00000013,00092E03,00000013,00000013,00000013,01C34DB3,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,940D9CE3,00000013,00000013,00000013,A0000A37,00000013,00000013,00000013,01492423,00000013,00000013,00000013,FEDCBDB7,00000013,00000013,00000013,40CDDD93,00000013,00000013,00000013,00800E13,00000013,00000013,00000013,01CD9DB3,00000013,00000013,00000013,0FFDED93,00000013,00000013,00000013,00B90E83,00000013,00000013,00000013,01DDFDB3,00000013,00000013,00000013,01B92423,00000013,00000013,00000013,00895D83,00000013,00000013,00000013,FFFF0A37,00000013,00000013,00000013,01BA7A33,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,860A14E3,00000013,00000013,00000013,00600F93,00000013,00000013,00000013,00A94E03,00000013,00000013,00000013,00B94E83,00000013,00000013,00000013,008E9E93,00000013,00000013,00000013,01CEEEB3,00000013,00000013,00000013,010E9E93,00000013,00000013,00000013,01DDEEB3,00000013,00000013,00000013,00892E03,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,FDDE1463,00000013,00000013,00000013,00092023,00000013,00000013,00000013,01B91023,00000013,00000013,00000013,0D000E13,00000013,00000013,00000013,01C90123,00000013,00000013,00000013,00092E03,00000013,00000013,00000013,00D0DEB7,00000013,00000013,00000013,BA0E8E93,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,F5DE1263,00000013,00000013,00000013,00291D83,00000013,00000013,00000013,0D000E13,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,F1CD9263,00000013,00000013,00000013,00700F93,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,EC00DA63,00000013,00000013,00000013,02145863,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,EA4FF06F,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,E8107263,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,E6147263,00000013,00000013,00000013,00000A17,00000013,00000013,00000013,040A0AE7,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,E24FF06F,00000013,00000013,00000013,014A0A13,00000013,00000013,00000013,00000F17,00000013,00000013,00000013,DF5A1A63,00000013,00000013,00000013,66600F93,00000013,00000013,00000013,DD4FF06F,00000013,00000013,00000013;
        ```

实验现象与 Lab4 相同。

## 实验要求

本次实验你需要完成的内容有：

* 绘制自己的 CPU datapath 图。
* 根据自己的 datapath 完成不处理冲突的五阶段流水线 CPU。
* 对实现的 CPU 进行仿真验证、下板验证、验收。
* 实验报告里需要包含的内容：
    * datapath 图。
    * 流水线 CPU 代码并简要分析（重点部分结合 datapath 和 Verilog 代码解释）。
    * 仿真代码与波形截图（注意缩放比例、数制选择合适），并分析仿真波形。
    * 下板图片与现象描述。
