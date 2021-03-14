// CSE 469
// Lab 1
// Chen Bai, Luke Jiang
// 10/05/2018

// This file created a 4x16 decoder.

`timescale 1ps / 1ps

module decoder4x16 (out, in, en);
  output  logic [15:0]  out;
  input   logic [3:0]   in;
  input   logic         en;

  logic [3:0] tmp;

  decoder2x4 dec0 (.out(tmp), .in(in[3:2]), .en);

  genvar i;
  generate
    for (i = 0; i < 4; i++) begin : eachDecoder2x4
      decoder2x4 dec (.out(out[i*4+3:i*4]), .in(in[1:0]), .en(tmp[i]));
    end
  endgenerate
endmodule

module decoder4x16_testbench();
  logic [15:0]  out;
  logic [3:0]   in;
  logic         en;

  decoder4x16 dut (.out, .in, .en);
  
  integer i;
  initial begin
    for (i = 0; i < 32; i++) begin
      {en, in} = i; #10;
    end
  end
endmodule
