// CSE 469
// Lab 1
// Chen Bai, Luke Jiang
// 10/05/2018

// This file creates a 2x4 decoder.

`timescale 1ps / 1ps

module decoder2x4 (out, in, en);
  output logic [3:0] out;
  input logic [1:0] in;
  input logic en;

  logic [1:0] tmp;

  decoder1x2 dec0 (.out(tmp),      .in(in[1]), .en);
  decoder1x2 dec1 (.out(out[3:2]), .in(in[0]), .en(tmp[1]));
  decoder1x2 dec2 (.out(out[1:0]), .in(in[0]), .en(tmp[0]));
endmodule

module decoder2x4_testbench();
  logic [3:0] out;
  logic [1:0] in;
  logic en;

  decoder2x4 dut (.out, .in, .en);
  integer i;
  initial begin
    for(i = 0; i < 16; i++) begin
      {en, in} = i; #10;
    end
  end
endmodule
