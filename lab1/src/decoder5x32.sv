// CSE 469
// Lab 1
// Chen Bai, Luke Jiang
// 10/05/2018

// This file created a 5x32 decoder.

`timescale 1ps / 1ps

module decoder5x32 (out, in, en);
  output  logic [31:0]  out;
  input   logic [4:0]   in;
  input   logic         en;

  logic [1:0] tmp;

  decoder1x2  dec0 (.out(tmp),        .in(in[4]),   .en);
  decoder4x16 dec1 (.out(out[31:16]), .in(in[3:0]), .en(tmp[1]));
  decoder4x16 dec2 (.out(out[15:0]),  .in(in[3:0]), .en(tmp[0]));
endmodule

module decoder5x32_testbench ();
  logic [31:0]  out;
  logic [4:0]   in;
  logic         en;

  decoder5x32 dut (.out, .in, .en);
  integer i;
  initial begin
    for (i = 0; i < 64; i++) begin
      {en, in} = i; #10;
    end
  end
endmodule
