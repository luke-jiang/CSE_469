// CSE 469
// Lab 1
// Chen Bai, Luke Jiang
// 10/05/2018

// This module creates a 16-to-1 mux.

`timescale 1ps / 1ps

module mux16_1 (out, d, sel);
  output  logic         out;
  input   logic [15:0]  d;
  input   logic [3:0]   sel;

  logic [3:0] tmp;

  genvar i;
  generate
    for (i = 0; i < 4; i++) begin : eachMux4_1
      mux4_1 muxes (.out(tmp[i]), .d(d[i*4+3:i*4]), .sel(sel[1:0]));
    end
  endgenerate

  mux4_1 mux (.out, .d(tmp), .sel(sel[3:2]));
endmodule

module mux16_1_testbench ();
  logic         out;
  logic [15:0]  d;
  logic [3:0]   sel;

  mux16_1 dut (.out, .d, .sel);

  integer i;
  initial begin
    d = 16'b0000111100100110;
    for (i = 0; i < 16; i++) begin
      sel = i; #10;
    end
    d = 16'b1100010101010100;
    for (i = 0; i < 16; i++) begin
      sel = i; #10;
    end
  end
endmodule

