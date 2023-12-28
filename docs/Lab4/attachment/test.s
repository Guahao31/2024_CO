addi x1, x2, 1000
xori x1, x2, 10
ori x1, x2, 1
andi x1, x2, 0
slli x1, x2, 20
srli x1, x2, 5
srai x1, x2, 24
slti x1, x2, -1
sltiu x1, x2, 1023
lb x1, 233(x2)
sb x1, -5(x2)
sh x2, 0(x2)
sw x12, 10(x1)
beq x1, x1, -12
bne x2, x2, 8
blt x3, x3, 20
bge x4, x4, -20
jal x0, -100
jal x1, 1023