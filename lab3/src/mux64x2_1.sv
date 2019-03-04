// CSE 469
// Lab 3
// Chen Bai, Luke Jiang
// 11/08/2018

// 64-bit 2-to-1 mux

`timescale 1ps / 1ps

module mux64x2_1 (out, d, sel);
  output logic [63:0] out;
  input logic [127:0] d;
  input logic sel;

  genvar i;
  generate
    for (i = 0; i < 64; i++) begin : eachMux2_1
      mux2_1 mux (.out(out[i]), .d({d[i+64], d[i]}), .sel);
    end
  endgenerate
endmodule

module mux64x2_1_testbench ();
  logic [63:0] out;
  logic [127:0] d;
  logic sel;

  mux64x2_1 dut (.out, .d, .sel);

  integer i;
  initial begin
    for (i = 0; i < 100; i++) begin
      d[127:64] = $random();
      d[63:0] = $random();
		
      sel = 0; #1000;
      assert(out == d[63:0]);
		
      sel = 1; #1000;
      assert(out == d[127:64]);
    end
  end
endmodule
