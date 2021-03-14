// CSE 469
// Lab 1
// Chen Bai, Luke Jiang
// 10/05/2018

// This module creates a register module, which contains 64
// enabled DFF for data storage.

`timescale 1ps / 1ps

module register (out, in, reset, clk, en);
  output  logic [63:0] out;
  input   logic [63:0] in;
  input   logic        reset, clk, en;

  genvar i;
  generate
    for (i = 0; i < 64; i++) begin : eachEnable_D_FF
      enable_D_FF dff (.q(out[i]), .d(in[i]), .reset, .clk, .en);
    end
  endgenerate
endmodule

module register_testbench ();
  logic [63:0] out;
  logic [63:0] in;
  logic reset, clk, en;

  register dut (.out, .in, .reset, .clk, .en);

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;
  end

  initial begin
    @(posedge clk);
    en <= 1; in <= 1; @(posedge clk);
    en <= 0; @(posedge clk);
    reset <= 1; @(posedge clk);
    reset <= 0; @(posedge clk);
    en <= 1; in <= 1; @(posedge clk);
    in <= 0; @(posedge clk);
     @(posedge clk);
    $stop();
  end
endmodule