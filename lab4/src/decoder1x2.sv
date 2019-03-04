// CSE 469
// Lab 1
// Chen Bai, Luke Jiang
// 10/05/2018

// This module creates a gate-level 1x2 decoder.

`timescale 1ps / 1ps

module decoder1x2 (out, in, en);
  output logic [1:0] out;
  input logic in, en;
  logic notOut;

  and #50 AND1 (out[1], en, in);
  not #50 NOT (notOut, in);
  and #50 AND2 (out[0], en, notOut);
endmodule

module decoder1x2_testbench();
  logic [1:0] out;
  logic in, en;

  decoder1x2 dut (.out, .in, .en);

  initial begin
    en = 0; in = 0; #10;
    in = 1; #10;
    en = 1; in = 0; #10;
    in = 1; #10;
  end
endmodule