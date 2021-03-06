// CSE 469
// Lab 3
// Chen Bai, Luke Jiang
// 11/08/2018

// ALU flag register.
// [negative, zero, overflow, carry_out] [3:0]
// lessthanF is true if A < B, where A, B are two inputs to ALU.

`timescale 1ps / 1ps

module regflag (out, lessThanF, in, reset, clk, en);
  input   logic [3:0]   in;
  input   logic         reset, clk, en;
  output  logic [3:0]   out;
  output  logic         lessThanF;

  genvar i;
  generate
    for(i = 0; i < 4; i++) begin: enDff
      enable_D_FF enDffs (.q(out[i]), .d(in[i]), .reset, .clk, .en);
    end
  endgenerate
  xor (lessThanF, out[1], out[3]);

endmodule

module regflag_testbench ();
  logic [3:0] in;
  logic       reset, clk, en;
  logic [3:0] out;
  logic       lessThanF;

  regflag dut (.out, .lessThanF, .in, .reset, .clk, .en);

  parameter ClockDelay = 5000;
  initial begin // Set up the clock
    clk <= 0;
    forever #(ClockDelay/2) clk <= ~clk;
  end

  initial begin
    in <= 4'b0101; en <= 1; @(posedge clk);
    in <= 4'b1111; @(posedge clk);
    in <= 4'b1100; @(posedge clk);
    in <= 4'b0101; en <= 0; @(posedge clk);
    in <= 4'b1111; @(posedge clk);
    in <= 4'b1100; @(posedge clk);
    @(posedge clk);
    $stop();
  end
endmodule
