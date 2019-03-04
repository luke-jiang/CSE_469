// CSE 469
// Lab 1
// Chen Bai, Luke Jiang
// 10/05/2018

// This module creates a 32-to-1 mux.

`timescale 1ps / 1ps

module mux32_1 (out, d, sel);
  output logic out;
  input logic [31:0] d;
  input logic [4:0] sel;

  logic [1:0] tmp;

  mux16_1 mux0 (.out(tmp[0]), .d(d[15:0]), .sel(sel[3:0]));
  mux16_1 mux1 (.out(tmp[1]), .d(d[31:16]), .sel(sel[3:0]));
  mux2_1 mux2 (.out, .d(tmp), .sel(sel[4]));
endmodule

module mux32_1_testbench ();
  logic out;
  logic [31:0] d;
  logic [4:0] sel;

  mux32_1 dut (.out, .d, .sel);

  integer i;
  initial begin
    d = 32'hC5540F26;  // 11000101010101000000111100100110
    for (i = 0; i < 32; i++) begin
      sel = i; #10;
    end
    d = 32'h5D09A700;  // 1011101000010011010011100000000
    for (i = 0; i < 32; i++) begin
      sel = i; #10;
    end
  end
endmodule


