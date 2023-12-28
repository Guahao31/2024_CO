`timescale 1ns/1ps

`include "Lab4_header.vh"

module SCPU_ctrl_tb();
  reg [4:0]     OPcode;
  reg [2:0]     Fun3;
  reg           Fun7;
  reg           MIO_ready;
  wire [1:0]    ImmSel;
  wire          ALUSrc_B;
  wire [1: 0]   MemtoReg;
  wire          Jump;
  wire          Branch;
  wire          RegWrite;
  wire          MemRW;
  wire [3:0]    ALU_Control;
  wire          CPU_MIO;

  SCPU_ctrl m0 (
    .OPcode(OPcode),
    .Fun3(Fun3),
    .Fun7(Fun7),
    .MIO_ready(MIO_ready),
    .ImmSel(ImmSel),
    .ALUSrc_B(ALUSrc_B),
    .MemtoReg(MemtoReg),
    .Jump(Jump),
    .Branch(Branch),
    .RegWrite(RegWrite),
    .MemRW(MemRW),
    .ALU_Control(ALU_Control),
    .CPU_MIO(CPU_MIO)
  );

  reg [31:0] inst_for_test;

`define LET_INST_BE(inst) \
  inst_for_test = inst; \
  OPcode = inst_for_test[6:2]; \
  Fun3 = inst_for_test[14:12]; \
  Fun7 = inst_for_test[30]; \
  #5;

  initial begin
    $dumpfile("SCPU_ctrl.vcd");
    $dumpvars(1, SCPU_ctrl_tb);

    #5;
    MIO_ready = 0;
    #5;
    `LET_INST_BE(32'h001100B3);   //add x1, x2, x1
    `LET_INST_BE(32'h400080B3);   //sub x1, x1, x0
    `LET_INST_BE(32'h002140B3);   //xor x1, x2, x2
    `LET_INST_BE(32'h002160B3);   //or x1, x2, x2
    `LET_INST_BE(32'h002170B3);   //and x1, x2, x2
    `LET_INST_BE(32'h002150B3);   //srl x1, x2, x2
    `LET_INST_BE(32'h002120B3);   //slt x1, x2, x2
    `LET_INST_BE(32'h3E810093);   //addi x1, x2, 1000
    `LET_INST_BE(32'h00A14093);   //xori x1, x2, 10
    `LET_INST_BE(32'h00116093);   //ori x1, x2, 1
    `LET_INST_BE(32'h00017093);   //andi x1, x2, 0
    `LET_INST_BE(32'h00515093);   //srli x1, x2, 5
    `LET_INST_BE(32'hFFF12093);   //slti x1, x2, -1
    `LET_INST_BE(32'h00812083);   //lw x1, 8(x2)
    `LET_INST_BE(32'h00C0A823);   //sw x12, 16(x1)
    `LET_INST_BE(32'hFE108AE3);   //beq x1, x1, -12
    `LET_INST_BE(32'hF9DFF06F);   //jal x0, -100
    `LET_INST_BE(32'h3FE000EF);   //jal x1, 1023

    #50; $finish();
  end
endmodule