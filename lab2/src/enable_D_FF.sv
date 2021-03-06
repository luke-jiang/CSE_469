// CSE 469
// Lab 1
// Chen Bai, Luke Jiang
// 10/05/2018

// This module creates a DFF with an enable signal.

`timescale 1ps / 1ps

module enable_D_FF (q, d, reset, clk, en);
  output  logic q;
  input   logic d, reset, clk, en;

  logic tmp;
  mux2_1 mux (.out(tmp), .d({d, q}), .sel(en));
  D_FF dff (.q, .d(tmp), .reset, .clk);
endmodule

module enable_D_FF_testbench ();
  logic q;
  logic d, reset, clk, en;

  enable_D_FF dut (.q, .d, .reset, .clk, .en);

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;
  end

  initial begin
    @(posedge clk);
    en <= 1; d <= 1; @(posedge clk);
    en <= 0; @(posedge clk);
    reset <= 1; @(posedge clk);
    reset <= 0; @(posedge clk);
    en <= 1; d <= 1; @(posedge clk);
    d <= 0; @(posedge clk);
    en <= 0; @(posedge clk);
    @(posedge clk);
    $stop();
  end
endmodule