// CSE 469
// Lab 4
// Chen Bai, Luke Jiang
//

`include "header.svh"
`timescale 1ns/10ps

module Execute (
  output logic [399:0] out,
  input logic [399:0] in,
  input logic [15:0] EX_MEM_Rd, MEM_WR_Rd,
  input logic EX_MEM_RegWrite, MEM_WR_RegWrite,
  input logic [63:0] EX_MEM_Data, MEM_WR_Data
  );

  logic [63:0] shifter_out;
  logic [63:0] ALU_out;
  logic [63:0] FwdAMux_out, FwdBMux_out, FwdDbMux_out;
  logic [1:0] FwdA_cntrl, FwdB_cntrl, FwdDb_cntrl;
  logic [12:0] control;
  logic negativeF, zeroF, overflowF, carry_outF;


  assign out[`Rd+:16] = in[`Rd+:16];
  assign out[`cntrl+:16] = in[`cntrl+:16];
  assign control = in[`cntrl+:13];
  assign out[`shifterOut+:64] = shifter_out;
  assign out[`Db+:64] = FwdDbMux_out;
  assign out[`ALUout+:64] = ALU_out;

  // [negative, zero, overflow, carry_out] [3:0]
  assign out[`RegFlag] = carry_outF;
  assign out[`RegFlag + 1] = overflowF;
  assign out[`RegFlag + 2] = zeroF;
  assign out[`RegFlag + 3] = negativeF;

  // Forwarding control A
  always_comb begin
    if (EX_MEM_RegWrite == 1 && EX_MEM_Rd == in[`Rn+:16] && EX_MEM_Rd != 16'd31) begin
      FwdA_cntrl = 2'd2;
    end else if (MEM_WR_RegWrite == 1 && MEM_WR_Rd == in[`Rn+:16] && MEM_WR_Rd != 16'd31) begin
      FwdA_cntrl = 2'd1;
    end else begin
      FwdA_cntrl = 2'd0;
    end
  end

  // Forwarding control B
  always_comb begin
	  if (control === 13'b010X00010010X
    || control === 13'b010X00011001X
    || control === 13'bXXXX000101XXX
    || control === 13'b010X0010XX010) begin
	  // no Rm: ADDI, LDUR, LSR, STUR
	    FwdB_cntrl = 2'd0;
    end else if (EX_MEM_RegWrite == 1 && EX_MEM_Rd == in[`Rm+:16] && EX_MEM_Rd != 16'd31) begin
      FwdB_cntrl = 2'd2;
    end else if (MEM_WR_RegWrite == 1 && MEM_WR_Rd == in[`Rm+:16] && MEM_WR_Rd != 16'd31) begin
      FwdB_cntrl = 2'd1;
    end else begin
      FwdB_cntrl = 2'd0;
    end
  end

  // Forwarding control Db
  always_comb begin
  	if (control === 13'b010X0010XX010) begin
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

  mux64x4_1 FwdAMux (
    .out(FwdAMux_out),
    .d({64'b0, EX_MEM_Data, MEM_WR_Data, in[`Da+:64]}),
    .sel(FwdA_cntrl)
  );
  mux64x4_1 FwdBMux (
    .out(FwdBMux_out),
    .d({64'b0, EX_MEM_Data, MEM_WR_Data, in[`ALUSrc+:64]}),
    .sel(FwdB_cntrl)
  );
  mux64x4_1 FwdDbMux (
    .out(FwdDbMux_out),
    .d({64'b0, EX_MEM_Data, MEM_WR_Data, in[`Db+:64]}),
    .sel(FwdDb_cntrl)
  );

  shifter theRightShifter (
    .result(shifter_out),
    .value(FwdAMux_out),
    .direction(1'b1),
    .distance(in[`shamt+:6])
  );

  alu theALU (
    .A(FwdAMux_out),
    .B(FwdBMux_out),
    .cntrl(control[`ALUOp1:`ALUOp0]),
    .result(ALU_out),
    .negative(negativeF),
    .zero(zeroF),
    .overflow(overflowF),
    .carry_out(carry_outF)
  );
endmodule
