    and  or xor addi andi slti lw sw
    j    start                                # 00
dummy:
    nop                                       # 04
    nop                                       # 08
    nop                                       # 0C
    nop                                       # 10
    nop                                       # 14
    nop                                       # 18
    nop                                       # 1C
    j    dummy

start:
    beq  x0, x0, pass_0
    li   x31, 1
    j    dummy
pass_0:
    li   x1, -1                               # x1=FFFFFFFF
    xori x3, x1, 1                            # x3=FFFFFFFE
    add  x3, x3, x3                           # x3=FFFFFFFC
    add  x3, x3, x3                           # x3=FFFFFFF8
    add  x3, x3, x3                           # x3=FFFFFFF0
    add  x3, x3, x3                           # x3=FFFFFFE0
    add  x3, x3, x3                           # x3=FFFFFFC0
    add  x3, x3, x3                           # x3=FFFFFF80
    add  x3, x3, x3                           # x3=FFFFFF00
    add  x3, x3, x3                           # x3=FFFFFE00
    add  x3, x3, x3                           # x3=FFFFFC00
    add  x3, x3, x3                           # x3=FFFFF800
    add  x3, x3, x3                           # x3=FFFFF000
    add  x3, x3, x3                           # x3=FFFFE000
    add  x3, x3, x3                           # x3=FFFFC000
    add  x3, x3, x3                           # x3=FFFF8000
    add  x3, x3, x3                           # x3=FFFF0000
    add  x3, x3, x3                           # x3=FFFE0000
    add  x3, x3, x3                           # x3=FFFC0000
    add  x3, x3, x3                           # x3=FFF80000
    add  x3, x3, x3                           # x3=FFF00000
    add  x3, x3, x3                           # x3=FFE00000
    add  x3, x3, x3                           # x3=FFC00000
    add  x3, x3, x3                           # x3=FF800000
    add  x3, x3, x3                           # x3=FF000000
    add  x3, x3, x3                           # x3=FE000000
    add  x3, x3, x3                           # x3=FC000000
    add  x5, x3, x3                           # x5=F8000000
    add  x3, x5, x5                           # x3=F0000000
    add  x4, x3, x3                           # x4=E0000000
    add  x6, x4, x4                           # x6=C0000000
    add  x7, x7, x7                           # x7=80000000
    ori  x8, zero, 1                          # x8=00000001
    ori  x28, zero, 30
    srl  x29, x7, x28                         # x29=00000001
    beq  x8, x29, pass_1
    li   x31, 2
    j    dummy

pass_1:
    sub  x3, x6, x7                           # x3=40000000
    sub  x4, x7, x3                           # x4=40000000
    slti x9, x0, 1                            # x9=00000001
    slt  x10, x3, x4
    slt  x10, x4, x3                          # x10=00000000
    beq  x9, x10, dummy                       # branch when x3 != x4
    srli x29, x3, 30                          # x29=00000001
    beq x29, x9, pass_2
    li x31, 3
    j dummy

pass_2:
    slti x10, x1, 3 # x10=00000001