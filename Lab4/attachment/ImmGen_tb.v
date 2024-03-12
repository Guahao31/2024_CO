`timescale 1ns/1ps

`include "Lab4_header.vh"

module ImmGen_tb();
  reg [1:0]   ImmSel;
  reg [31:0]  inst_field;
  wire[31:0]  Imm_out;

  ImmGen m0 (.ImmSel(ImmSel), .inst_field(inst_field), .Imm_out(Imm_out));

`define LET_INST_BE(inst) \
  inst_field = inst; \
  #5;

  initial begin
    $dumpfile("ImmGen.vcd");
    $dumpvars(1, ImmGen_tb);

    #5;
    /* Test for I-Type */
    ImmSel = `IMM_SEL_I;
    `LET_INST_BE(32'h3E810093);   //addi x1, x2, 1000
    `LET_INST_BE(32'h00A14093);   //xori x1, x2, 10
    `LET_INST_BE(32'h00116093);   //ori x1, x2, 1
    `LET_INST_BE(32'h00017093);   //andi x1, x2, 0
    `LET_INST_BE(32'h01411093);   //slli x1, x2, 20
    `LET_INST_BE(32'h00515093);   //srli x1, x2, 5
    `LET_INST_BE(32'h41815093);   //srai x1, x2, 24
    `LET_INST_BE(32'hFFF12093);   //slti x1, x2, -1
    `LET_INST_BE(32'h3FF13093);   //sltiu x1, x2, 1023
    `LET_INST_BE(32'h0E910083);   //lb x1, 233(x2)

    #20;
    /* Test for S-Type */
    ImmSel = `IMM_SEL_S;
    `LET_INST_BE(32'hFE110DA3);   //sb x1, -5(x2)
    `LET_INST_BE(32'h00211023);   //sh x2, 0(x2)
    `LET_INST_BE(32'h00C0A523);   //sw x12, 10(x1)

    #20;
    /* Test for B-Type */
    ImmSel = `IMM_SEL_B;
    `LET_INST_BE(32'hFE108AE3);   //beq x1, x1, -12
    `LET_INST_BE(32'h00211463);   //bne x2, x2, 8
    `LET_INST_BE(32'h0031CA63);   //blt x3, x3, 20
    `LET_INST_BE(32'hFE4256E3);   //bge x4, x4, -20

    #20;
    /* Test for J-Type */
    ImmSel = `IMM_SEL_J;
    `LET_INST_BE(32'hF9DFF06F);   //jal x0, -100
    `LET_INST_BE(32'h3FE000EF);   //jal x1, 1023 NOTE: does ImmGen output 1023?
    #50; $finish();
  end
endmodule