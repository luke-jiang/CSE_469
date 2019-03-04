// CSE 469
// Lab 4
// Chen Bai, Luke Jiang
// 30/11/2018

// Top module for pipelined CPU

`include "header.svh"
`timescale 1ns/10ps

module CPU (
  input logic clk, reset
  );

  logic iclk;                           // inverse clk for RegFile

  logic lessThanF, newlessThanF;        // current and old less-than Flags
  logic flagMux_out;                    // output of less-than Flag Mux
  logic [3:0] regfl_out;                // output of the flag register
  // 400 register arrays
  logic [399:0] IF_REin, IF_REout;
  logic [399:0] RE_EXin, RE_EXout;
  logic [399:0] EX_MEMin, EX_MEMout;
  logic [399:0] MEM_WRin, MEM_WRout;
  // EX_MEM and MEM_WR control signals
  logic [15:0] EX_MEMcntrl, MEM_WRcntrl;
  assign EX_MEMcntrl = EX_MEMout[`cntrl+:16];
  assign MEM_WRcntrl = MEM_WRout[`cntrl+:16];

  // IFetch
  IFetch theIFetch (
    .out(IF_REin),
    .next_address(RE_EXin[`BrTarget+:64]),
    .cntrl(RE_EXin[`cntrl+:13]),
    .reset,
    .clk
  );
  register400 IF_RE (.out(IF_REout), .in(IF_REin), .reset, .clk, .en(1'b1));

  // RegDecode
  logic iclk;
  not #50 clkInvert (iclk, clk);
  RegDecode theRegDecode (
    .out(RE_EXin),
    .in(IF_REout),
    .WriteRegister(MEM_WRout[`Rd+:5]),
    .WriteData(MEM_WRout[`WriteData+:64]),
  	.RegWrite(MEM_WRcntrl[`RegWrite]),
  	.lessThanF(flagMux_out),
  	.EX_MEM_Rd(EX_MEMin[`Rd+:16]),
    .MEM_WR_Rd(MEM_WRin[`Rd+:16]),
  	.EX_MEM_RegWrite(EX_MEMcntrl[`RegWrite]),
  	.MEM_WR_RegWrite(MEM_WRcntrl[`RegWrite]),
  	.EX_MEM_Data(EX_MEMin[`ALUout+:64]),
    .MEM_WR_Data(MEM_WRin[`WriteData+:64]),
    .clk(iclk),
  	.reset
  );
  register400 RE_EX (.out(RE_EXout), .in(RE_EXin), .reset, .clk, .en(1'b1));

  // Exec
  Execute theExecute (
    .out(EX_MEMin),
    .in(RE_EXout),
    .EX_MEM_Rd(EX_MEMout[`Rd+:16]),
    .MEM_WR_Rd(MEM_WRout[`Rd+:16]),
    .EX_MEM_RegWrite(EX_MEMcntrl[`RegWrite]),
    .MEM_WR_RegWrite(MEM_WRcntrl[`RegWrite]),
    .EX_MEM_Data(MEM_WRin[`WriteData+:64]),
    .MEM_WR_Data(MEM_WRout[`WriteData+:64])
  );
  register400 EX_MEM (.out(EX_MEMout), .in(EX_MEMin), .reset, .clk, .en(1'b1));

  // The flag register
  regflag regfl(
    .out(regfl_out),
    .lessThanF,
    .in(EX_MEMin[`RegFlag+:4]),
    .reset,
    .clk,
    .en(RE_EXout[`cntrl+`FlagWrite])
  );

  // get current less-than Flag
  xor #50 (newlessThanF, EX_MEMin[`RegFlag+1], EX_MEMin[`RegFlag+3]);

  // less-than Flag Mux
  mux2_1 flagMux (
    .out(flagMux_out),
    .d({newlessThanF, lessThanF}),
    .sel(RE_EXout[`cntrl+`FlagWrite])
  );

  // Mem
  DMemWrite theDMemWrite (.out(MEM_WRin), .in(EX_MEMout), .clk);
  register400 MEM_WR (.out(MEM_WRout), .in(MEM_WRin), .reset, .clk, .en(1'b1));
endmodule

module CPU_testbench();
  parameter ClockDelay = 3000;

  logic clk, reset;

  CPU dut (.clk, .reset);

  initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

  integer i;

  initial begin
    reset <= 1; @(posedge clk);
    reset <= 0; @(posedge clk);
    for (i = 0; i < 1500; i++) begin
      @(posedge clk);
    end
	 $stop();
  end
endmodule
