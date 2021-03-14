// CSE 469
// Lab 3
// Chen Bai, Luke Jiang
// 11/08/2018

// This module creates a 5-bit 2-to-1 mux.

`timescale 1ps / 1ps

module mux5x2_1 (out, d, sel);
  output  logic [4:0] out;
  input   logic [9:0] d;
  input   logic       sel;

  genvar i;
  generate
    for (i = 0; i < 5; i++) begin : eachMux2_1
      mux2_1 mux (.out(out[i]), .d({d[i+5], d[i]}), .sel);
    end
  endgenerate
endmodule

