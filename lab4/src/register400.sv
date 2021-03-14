// CSE 469
// Lab 4
// Chen Bai, Luke Jiang
// 30/11/2018

// Register array of length 400, used as pipeline buffer registers.

`timescale 1ps / 1ps

module register400 (out, in, reset, clk, en);
  output  logic [399:0] out;
  input   logic [399:0] in;
  input   logic         reset, clk, en;

  genvar i;
  generate
    for (i = 0; i < 400; i++) begin : eachEnable_D_FF
      enable_D_FF dff (.q(out[i]), .d(in[i]), .reset, .clk, .en);
    end
  endgenerate
endmodule
