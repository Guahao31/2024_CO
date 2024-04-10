    auipc x1, 0
    j     start            # 00
dummy:
    nop                    # 04
    nop                    # 08
    nop                    # 0C
    nop                    # 10
    nop                    # 14
    nop                    # 18
    nop                    # 1C
    j     dummy

start:
    bnez  x1, dummy
    beq   x0, x0, pass_0
    li    x31, 0
    auipc x30, 0
    j     dummy
pass_0:
    li    x31, 1
    bne   x0, x0, dummy
    bltu  x0, x0, dummy
    li    x1, -1           # x1=FFFFFFFF
    xori  x3, x1, 1        # x3=FFFFFFFE
    add   x3, x3, x3       # x3=FFFFFFFC
    add   x3, x3, x3       # x3=FFFFFFF8
    add   x3, x3, x3       # x3=FFFFFFF0
    add   x3, x3, x3       # x3=FFFFFFE0
    add   x3, x3, x3       # x3=FFFFFFC0
    add   x3, x3, x3       # x3=FFFFFF80
    add   x3, x3, x3       # x3=FFFFFF00
    add   x3, x3, x3       # x3=FFFFFE00
    add   x3, x3, x3       # x3=FFFFFC00
    add   x3, x3, x3       # x3=FFFFF800
    add   x3, x3, x3       # x3=FFFFF000
    add   x3, x3, x3       # x3=FFFFE000
    add   x3, x3, x3       # x3=FFFFC000
    add   x3, x3, x3       # x3=FFFF8000
    add   x3, x3, x3       # x3=FFFF0000
    add   x3, x3, x3       # x3=FFFE0000
    add   x3, x3, x3       # x3=FFFC0000
    add   x3, x3, x3       # x3=FFF80000
    add   x3, x3, x3       # x3=FFF00000
    add   x3, x3, x3       # x3=FFE00000
    add   x3, x3, x3       # x3=FFC00000
    add   x3, x3, x3       # x3=FF800000
    add   x3, x3, x3       # x3=FF000000
    add   x3, x3, x3       # x3=FE000000
    add   x3, x3, x3       # x3=FC000000
    add   x5, x3, x3       # x5=F8000000
    add   x3, x5, x5       # x3=F0000000
    add   x4, x3, x3       # x4=E0000000
    add   x6, x4, x4       # x6=C0000000
    add   x7, x6, x6       # x7=80000000
    ori   x8, zero, 1      # x8=00000001
    ori   x28, zero, 31
    srl   x29, x7, x28     # x29=00000001
    auipc x30, 0
    bne   x8, x29, dummy
    auipc x30, 0
    blt   x8, x7, dummy
    sra   x29, x7, x28     # x29=FFFFFFFF
    and   x29, x29, x3     # x29=x3=F0000000
    auipc x30, 0
    bne   x3, x29, dummy
    mv    x29, x8          # x29=x8=00000001
    bltu  x29, x7, pass_1  # unsigned 00000001 < 80000000
    auipc x30, 0
    j     dummy

pass_1:
    nop
    li    x31, 2
    sub   x3, x6, x7       # x3=40000000
    sub   x4, x7, x3       # x4=40000000
    slti  x9, x0, 1        # x9=00000001
    slt   x10, x3, x4
    slt   x10, x4, x3      # x10=00000000
    auipc x30, 0
    beq   x9, x10, dummy   # branch when x3 != x4
    srli  x29, x3, 30      # x29=00000001
    beq   x29, x9, pass_2
    auipc x30, 0
    j     dummy

pass_2:
    nop
# Test set-less-than
    li    x31, 3
    slti  x10, x1, 3       # x10=00000001
    slt   x11, x5, x1      # signed(0xF8000000) < -1
                           # x11=00000001
    slt   x12, x1, x3      # x12=00000001
    andi  x10, x10, 0xff
    and   x10, x10, x11
    and   x10, x10, x12    # x10=00000001
    auipc x30, 0
    beqz  x10, dummy
    sltu  x10, x1, x8      # unsigned FFFFFFFF < 00000001 ?
    auipc x30, 0
    bnez  x10, dummy
    sltu  x10, x8, x3      # unsigned 00000001 < F0000000 ?
    auipc x30, 0
    beqz  x10, dummy
    sltiu x10, x1, 3
    auipc x30, 0
    bnez  x10, dummy
    li    x11, 1
    bne   x10, x11, pass_3
    auipc x30, 0
    j     dummy

pass_3:
    nop
    li    x31, 4
    or    x11, x7, x3      # x11=C0000000
    beq   x11, x6, pass_4
    auipc x30, 0
    j     dummy

pass_4:
    nop
    li    x31, 5
    li    x18, 0x20        # base addr=00000020
### uncomment instr. below when simulating on venus
    # lui   x18, 0x10000     # base addr=10000000
    sw    x5, 0(x18)       # mem[0x20]=F8000000
    sw    x4, 4(x18)       # mem[0x24]=E0000000
    lw    x27, 0(x18)      # x27=mem[0x20]=F8000000
    xor   x27, x27, x5     # x27=00000000
    sw    x6, 0(x18)       # mem[0x20]=C0000000
    lw    x28, 0(x18)      # x28=mem[0x20]=C0000000
    xor   x27, x6, x28     # x27=C0000000
    auipc x30, 0
    bnez  x20, dummy
    lui   x20, 0xA0000     # x20=A0000000
    sw    x20, 8(x18)      # mem[0x28]=A0000000
    lui   x27, 0xFEDCB     # x27=FEDCB000
    srai  x27, x27, 12     # x27=FFFFEDCB
    li    x28, 8
    sll   x27, x27, x28    # x27=FFEDCB00
    ori   x27, x27, 0xff   # x27=FFEDCBFF
    lb    x29, 11(x18)     # x29=FFFFFFA0, little-endian, signed-ext
    and   x27, x27, x29    # x27=FFEDCBA0
    sw    x27, 8(x18)      # mem[0x28]=FFEDCBA0
    lhu   x27, 8(x18)      # x27=0000CBA0
    lui   x20, 0xFFFF0     # x20=FFFF0000
    and   x20, x20, x27    # x20=00000000
    auipc x30, 0
    bnez  x20, dummy       # check unsigned-ext
    li    x31, 6
    lbu   x28, 10(x18)     # x28=000000ED
    lbu   x29, 11(x18)     # x29=000000FF
    slli  x29, x29, 8      # x29=0000FF00
    or    x29, x29, x28    # x29=0000FFED
    slli  x29, x29, 16
    or    x29, x27, x29    # x29=FFEDCBA0
    lw    x28, 8(x18)      # x28=FFEDCBA0
    auipc x30, 0
    bne   x28, x29, dummy
    sw    x0, 0(x18)       # mem[0x20]=00000000
    sh    x27, 0(x18)      # mem[0x20]=0000CBA0
    li    x28, 0xD0
    sb    x28, 2(x18)      # mem[0x20]=00D0CBA0
    lw    x28, 0(x18)      # x28=00D0CBA0
    li    x29, 0x00D0CBA0
    auipc x30, 0
    bne   x28, x29, dummy
    lh    x27, 2(x18)      # x27=000000D0
    li    x28, 0xD0
    auipc x30, 0
    bne   x27, x28, dummy

pass_5:
    li    x31, 7
    auipc x30, 0
    bge   x1, x0, dummy    # -1 >= 0 ?
    bge   x8, x1, pass_6   # 1 >= -1 ?
    auipc x30, 0
    j     dummy

pass_6:
    auipc x30, 0
    bgeu  x0, x1, dummy    # 0 >= FFFFFFFF ?
    auipc x30, 0
    bgeu  x8, x1, dummy
    auipc x20, 0
    jalr  x21, x0, pass_7  # just for test : (
    auipc x30, 0
    j     dummy

pass_7:
# jalr ->
    addi  x20, x20, 8
    auipc x30, 0
    bne   x20, x21, dummy
    li    x31, 0x666
    j     dummy