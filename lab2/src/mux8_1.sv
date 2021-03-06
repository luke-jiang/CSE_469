// CSE 469
// Lab 2
// Chen Bai, Luke Jiang
// 10/26/2018

// This module creates a 8-to-1 mux.

module mux8_1(out, d, sel);
  output  logic       out;
  input   logic [7:0] d;
  input   logic [2:0] sel;

  logic [1:0] q;

  mux4_1 mux0 (q[0], d[3:0], sel[1:0]);
  mux4_1 mux1 (q[1], d[7:4], sel[1:0]);
  mux2_1 mux2 (out, q, sel[2]);
endmodule
