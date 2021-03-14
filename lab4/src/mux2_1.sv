// CSE 469
// Lab 1
// Chen Bai, Luke Jiang
// 10/05/2018

// This module creates a 2-to-1 mux.


`timescale 1ps / 1ps

module mux2_1 (out, d, sel);
  output  logic       out;
  input   logic [1:0] d;
  input   logic       sel;

  logic sel_neg;
  not #50 NOT (sel_neg, sel);

  logic [1:0] tmp;
  and #50 AND1 (tmp[1], d[1], sel);
  and #50 AND0 (tmp[0], d[0], sel_neg);

  or #50 OR (out, tmp[1], tmp[0]);
endmodule

module mux2_1_testbench();
  logic         out;
  logic [1:0]   d;
  logic         sel;

  mux2_1 dut (.out, .d, .sel);

  integer i, j;
  initial begin
    for (i = 0; i < 4; i++) begin
      d = i; sel = 0; #10;
      d = i; sel = 1; #10;
    end
  end
endmodule
