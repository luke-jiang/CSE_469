// CSE 469
// Lab 4
// Chen Bai, Luke Jiang
// 30/11/2018

// Regfile/Decode stage.

`include "header.svh"
`timescale 1ns/10ps

module RegDecode (
  output logic [399:0] out,
  input logic [399:0] in,
  input logic [4:0] WriteRegister,
  input logic [63:0] WriteData,
  input logic [15:0] EX_MEM_Rd, MEM_WR_Rd,
  input logic EX_MEM_RegWrite, MEM_WR_RegWrite,
  input logic [63:0] EX_MEM_Data, MEM_WR_Data,
  input logic RegWrite,
  input logic lessThanF,
  input logic clk, reset
  );

  // Paramaters for bits in control signal.
  parameter Reg2Loc = 0;
  parameter ALUSrc0 = 1;
  parameter ALUSrc1 = 2;
  parameter Sel2Reg0 = 3;
  parameter Sel2Reg1 = 4;
  //parameter RegWrite = 5;
  parameter MemWrite = 6;
  parameter FlagWrite = 7;
  parameter BrTaken = 8;
  parameter CondBr = 9;
  parameter ALUOp0 = 10;
  parameter ALUOp1 = 12;

  logic [12:0] cntrl;
  logic [4:0] Reg2LocMux_out;           // to Regfile input Ab
  logic zeroF;


  logic [63:0] branchAdder_out;         // to BrTakenMux option 1
  logic [63:0] LS2_out;                 // to branchAdder
  logic [63:0] CondBrMux_out;           // to LS2
  logic [63:0] BrTakenMux_out;          // to PC
  logic [63:0] ReadData1, ReadData2;    // outputs of Regfile
  logic [63:0] ALUSrcMux_out;           // to ALU input B
  logic [63:0] FwdDbMux_out;
  logic [1:0] FwdDb_cntrl;
  logic [63:0] address;

  // Assign control logic
  controlLogic theControlLogic (.cntrl, .in(in[`opCode+:11]), .zeroF, .lessThanF);

  assign out[`Rd+:16] = in[`Rd+:16];
  assign out[`Rn+:16] = in[`Rn+:16];
  assign out[`Rm+:16] = in[`Rm+:16];
  assign out[`shamt+:16] = in[`shamt+:16];
  assign out[`cntrl+:16] = cntrl;
  assign out[`Da+:64] = ReadData1;
  assign out[`Db+:64] = ReadData2;
  assign out[`ALUSrc+:64] = ALUSrcMux_out;
  assign out[`BrTarget+:64] = branchAdder_out;
  assign address = in[`PC+:64];

    // Forwarding control Db
  always_comb begin
  	if (cntrl === 13'b00010000XX000 || cntrl === 13'b00011000XX000) begin
  		if (EX_MEM_Rd == in[`Rd+:16] && EX_MEM_Rd != 16'd31) begin
  			FwdDb_cntrl = 2'd2;
  		end else if (MEM_WR_Rd == in[`Rd+:16] && MEM_WR_Rd != 16'd31) begin
  			FwdDb_cntrl = 2'd1;
  		end else begin
  			FwdDb_cntrl = 2'd0;
  		end
  	end else begin
  		FwdDb_cntrl = 2'd0;
  	end
  end

  mux64x4_1 FwdDbMux (
    .out(FwdDbMux_out),
    .d({64'b0, EX_MEM_Data, MEM_WR_Data, ReadData2}),
    .sel(FwdDb_cntrl)
  );

  // The RegFile
  mux5x2_1 Reg2LocMux (
    .out(Reg2LocMux_out),
    .d({in[`Rm+:5], in[`Rd+:5]}),
    .sel(cntrl[Reg2Loc])
  );
  regfile regfi(
    .ReadData1,
    .ReadData2,
    .WriteData,
    .ReadRegister1(in[`Rn+:5]),
    .ReadRegister2(Reg2LocMux_out),
    .WriteRegister,
    .RegWrite,
    .clk
  );

  // Calculate zeroF that control logic needs
  mux64x4_1 ALUSrcMux (
    .out(ALUSrcMux_out),
    .d({64'b0, in[`Imm12+:64], in[`Imm9+:64], ReadData2}),
    .sel(cntrl[ALUSrc1:ALUSrc0])
  );
  ifZero64 DbZero (.out(zeroF), .a(FwdDbMux_out));

  // Adder for incrementing specified amount (branch) to current address
  alu branchAdder (
    .A(LS2_out),
    .B(address),
    .cntrl(3'b010),
    .result(branchAdder_out),
    .negative(), .zero(), .overflow(), .carry_out() // Don't care
  );

  // Calculate next instruction
  mux64x2_1 CondBrMux (
    .out(CondBrMux_out),
    .d({in[`Imm19+:64], in[`Imm26+:64]}),
    .sel(cntrl[CondBr])
  );

  // Left shift Imm26 by 2
  shifter LS2 (
    .value(CondBrMux_out),
    .direction(1'b0),
    .distance(6'd2),
    .result(LS2_out)
  );

endmodule
