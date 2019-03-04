// CSE 469
// Lab 3
// Chen Bai, Luke Jiang
// 11/08/2018

// 64-bit 4-to-1 mux

`timescale 1ps / 1ps

module mux64x4_1 (out, d, sel);
  output logic [63:0] out;
  input logic [255:0] d;
  input logic [1:0] sel;

  genvar i;
  generate
    for (i = 0; i < 64; i++) begin : eachMux4_1
      mux4_1 mux (.out(out[i]), .d({d[i+192], d[i+128], d[i+64], d[i]}), .sel);
    end
  endgenerate
endmodule

module mux64x4_1_testbench ();
  logic [63:0] out;
  logic [255:0] d;
  logic [1:0] sel;

  mux64x4_1 dut (.out, .d, .sel);

  integer i;
  initial begin
    for (i = 0; i < 100; i++) begin
      d[255:192] = $random();
      d[191:128] = $random();
      d[127:64] = $random();
      d[63:0] = $random();
      sel = 0; #1000;
      assert(out == d[63:0]);
      sel = 1; #1000;
      assert(out == d[127:64]);
      sel = 2; #1000;
      assert(out == d[191:128]);
      sel = 3; #1000;
      assert(out == d[255:192]);
      
    end
  end
endmodule
