// CSE 469
// Lab 3
// Chen Bai, Luke Jiang
// 11/08/2018

// The program counter (64x array of DFFs)

`timescale 1ps / 1ps

module PC (out, in, reset, clk);
  input   logic [63:0] in;
  input   logic        reset, clk;
  output  logic [63:0] out;

  genvar i;
  generate
    for(i = 0; i < 64; i++) begin: eachDFF
      D_FF DFFs(.q(out[i]), .d(in[i]), .reset, .clk);
    end
  endgenerate
endmodule // pc

module PC_testbench ();
  logic [63:0] in;
  logic        reset, clk;
  logic [63:0] out;

  PC dut (.out, .in, .reset, .clk);

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD/2) clk <= ~clk;
  end

  initial begin
    reset <= 1;
    @(posedge clk);
    reset <= 0;
    @(posedge clk);
    in <= $random(); @(posedge clk); 
    @(posedge clk); assert(out == in);
    in <= $random(); @(posedge clk); //assert(out == in);
    @(posedge clk); assert(out == in);
    in <= $random(); @(posedge clk); //assert(out == in);
    @(posedge clk); assert(out == in);
    in <= $random(); @(posedge clk); //assert(out == in);
    @(posedge clk); assert(out == in);
    in <= $random(); @(posedge clk); //assert(out == in);
    @(posedge clk); assert(out == in);
    in <= $random(); @(posedge clk); //assert(out == in);
    @(posedge clk); assert(out == in);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    $stop();
  end
endmodule
