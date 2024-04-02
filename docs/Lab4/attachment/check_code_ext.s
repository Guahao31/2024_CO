    auipc x1, 0
    j    start            # 00
dummy:
    nop                   # 04
    nop                   # 08
    nop                   # 0C
    nop                   # 10
    nop                   # 14
    nop                   # 18
    nop                   # 1C
    j    dummy

start:
    bnez x1, dummy
    beq  x0, x0, pass_0
    li   x31, 0
    auipc x30, 0
    j    dummy
pass_0:
    li x31, 1
    bne x0, x0, dummy
    bltu x0, x0, dummy
    li   x1, -1           # x1=FFFFFFFF
    xori x3, x1, 1        # x3=FFFFFFFE
    add  x3, x3, x3       # x3=FFFFFFFC
    add  x3, x3, x3       # x3=FFFFFFF8
    add  x3, x3, x3       # x3=FFFFFFF0
    add  x3, x3, x3       # x3=FFFFFFE0
    add  x3, x3, x3       # x3=FFFFFFC0
    add  x3, x3, x3       # x3=FFFFFF80
    add  x3, x3, x3       # x3=FFFFFF00
    add  x3, x3, x3       # x3=FFFFFE00
    add  x3, x3, x3       # x3=FFFFFC00
    add  x3, x3, x3       # x3=FFFFF800
    add  x3, x3, x3       # x3=FFFFF000
    add  x3, x3, x3       # x3=FFFFE000
    add  x3, x3, x3       # x3=FFFFC000
    add  x3, x3, x3       # x3=FFFF8000
    add  x3, x3, x3       # x3=FFFF0000
    add  x3, x3, x3       # x3=FFFE0000
    add  x3, x3, x3       # x3=FFFC0000
    add  x3, x3, x3       # x3=FFF80000
    add  x3, x3, x3       # x3=FFF00000
    add  x3, x3, x3       # x3=FFE00000
    add  x3, x3, x3       # x3=FFC00000
    add  x3, x3, x3       # x3=FF800000
    add  x3, x3, x3       # x3=FF000000
    add  x3, x3, x3       # x3=FE000000
    add  x3, x3, x3       # x3=FC000000
    add  x5, x3, x3       # x5=F8000000
    add  x3, x5, x5       # x3=F0000000
    add  x4, x3, x3       # x4=E0000000
    add  x6, x4, x4       # x6=C0000000
    add  x7, x6, x6       # x7=80000000
    ori  x8, zero, 1      # x8=00000001
    ori  x28, zero, 31
    srl  x29, x7, x28     # x29=00000001
    auipc x30, 0
    bne  x8, x29, dummy
    auipc x30, 0
    blt x8, x7, dummy
    sra x29, x7, x28 # x29=FFFFFFFF
    and x29, x29, x3 # x29=x3=F0000000
    auipc x30, 0
    bne x3, x29, dummy
    mv x29, x8 # x29=x8=00000001
    bltu x29, x7, pass_1 # unsigned 00000001 < 80000000
    auipc x30, 0
    j dummy

pass_1:
    nop
    li x31, 2
    sub  x3, x6, x7       # x3=40000000
    sub  x4, x7, x3       # x4=40000000
    slti x9, x0, 1        # x9=00000001
    slt  x10, x3, x4
    slt  x10, x4, x3      # x10=00000000
    auipc x30, 0
    beq  x9, x10, dummy   # branch when x3 != x4
    srli x29, x3, 30      # x29=00000001
    beq  x29, x9, pass_2
    auipc x30, 0
    j    dummy

pass_2:
    nop
# Test set-less-than
    li x31, 3
    slti x10, x1, 3       # x10=00000001
    slt  x11, x5, x1      # signed(0xF8000000) < -1
                          # x11=00000001
    slt  x12, x1, x3      # x12=00000001
    andi x10, x10, 0xff
    and  x10, x10, x11
    and  x10, x10, x12    # x10=00000001
    auipc x30, 0
    beqz x10, dummy
    sltu x10, x1, x8 # unsigned FFFFFFFF < 00000001 ?
    auipc x30, 0
    bnez x10, dummy
    sltu x10, x8, x3 # unsigned 00000001 < F0000000 ?
    auipc x30, 0
    beqz x10, dummy
    sltiu x10, x1, 3
    auipc x30, 0
    bnez x10, dummy
    li   x11, 1
    bne  x10, x11, pass_3
    auipc x30, 0
    j    dummy

pass_3:
    nop
    li   x31, 4
    or   x11, x7, x3      # x11=C0000000
    beq  x11, x6, pass_4
    auipc x30, 0
    j    dummy

pass_4:
    nop
    li x31, 5
    li x18, 0x20 # base addr=00000020
    ### uncomment instr. below when simulating on venus
    # lui x18, 0x10000 # base addr=10000000
    sw   x5, 0(x18)       # mem[0x20]=F8000000
    sw   x4, 4(x18)       # mem[0x24]=C0000000
    lw   x29, 0(x18)      # x29=mem[0x20]=F8000000
    xor  x29, x29, x5     # x29=00000000
    sw   x6, 0(x18)       # mem[0x20]=E0000000
    lw   x30, 0(x18)      # x30=mem[0x20]=E0000000
    xor  x29, x29, x30    # x29=E0000000
    beq  x6, x29, pass_5
    auipc x30, 0
    j    dummy

pass_5:
    li   x31, 0x666
    j    dummy