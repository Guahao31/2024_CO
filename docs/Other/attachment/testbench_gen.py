from math import log2
from math import ceil

f = open('console.out')
lines = f.readlines()
f.close()

f = open('test.s')
insts = f.readlines()
f.close()

# Init
ROM_width = 32
ROM_valid_depth = len(insts)

f_out = open('testbench.v', 'w')
msg = """// Generated code
module testbench(
    input clk,
    input rst
);

    /* SCPU 中接出 */
    wire [31:0] Addr_out;
    wire [31:0] Data_out;       
    wire        CPU_MIO;
    wire        MemRW;
    wire [31:0] PC_out;
    /* RAM 接出 */
    wire [31:0] douta;
    /* ROM_in_testbench 接出 */
    wire [31:0] spo;
    wire [8*30:1] inst_msg;

    SCPU u0(
        .clk(clk),
        .rst(rst),
        .Data_in(douta),
        .MIO_ready(CPU_MIO),
        .inst_in(spo),
        .Addr_out(Addr_out),
        .Data_out(Data_out),
        .CPU_MIO(CPU_MIO),
        .MemRW(MemRW),
        .PC_out(PC_out)
    );

    RAM_B u1(
        .clka(~clk),
        .wea(MemRW),
        .addra(Addr_out[11:2]),
        .dina(Data_out),
        .douta(douta)
    );

    ROM_in_testbench u2(
        .a(PC_out[11:2]),
        .spo(spo),
        .inst_msg(inst_msg)
    );

endmodule // tesebench

module ROM_in_testbench(
    input [9:0] a,
    output [31:0] spo,
    output [8*30:1] inst_msg
);
    reg[8*30:1] inst_string""" + '[0:' + str(ROM_valid_depth-1) + '];'+"""
    reg[31:0] inst [0:1023];

    assign spo = inst[a];
    assign inst_msg = inst_string[a];

    // Initial inst
"""

msg += '\tinitial begin\n'
cnt = 0
for line in lines:
    line = line.strip()[2:]
    msg += '\t\t' + 'inst[' + str(cnt) + ']\t <= 32\'h' + line + ';\n'
    cnt += 1
msg += '\tend\n\n'

msg += '\t// Initial inst_string\n'
msg += '\tinitial begin\n'
cnt = 0
for inst in insts:
    inst = inst.strip()
    msg += '\t\t' + 'inst_string[' + str(cnt) + ']\t <= \"' + inst + '\";\n'
    cnt += 1
msg += '\tend\n\n'

msg += 'endmodule // ROM_in_test'
f_out.write(msg)

f_out.close()
