// CSE 469
// Lab 1
// Chen Bai, Luke Jiang
// 10/05/2018

// This module creates a 4-to-1 mux.

`timescale 1ps / 1ps

module mux4_1 (out, d, sel);
  output logic out;
  input logic [3:0] d;
  input logic [1:0] sel;

  logic [1:0] q;
  
  mux2_1 mux0 (q[0], d[1:0], sel[0]);
  mux2_1 mux1 (q[1], d[3:2], sel[0]); 
  mux2_1 mux2 (out, q, sel[1]);
endmodule

module mux4_1_testbench ();
  logic out;
  logic [3:0] d;
  logic [1:0] sel;

  mux4_1 dut (.out, .d, .sel);

  integer i, j;
  initial begin
    for (i = 0; i < 16; i++) begin
      for (j = 0; j < 4; j++) begin
        d = i; sel = j; #10;
      end
    end
  end
endmodule
