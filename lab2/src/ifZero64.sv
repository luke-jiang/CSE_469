// CSE 469
// Lab 2
// Chen Bai, Luke Jiang
// 10/26/2018

// Check if input a == 0.

module ifZero64 (out, a);
  output logic out;
  input logic [63:0] a;

  logic [64:0] tmp;
  assign tmp[0] = 0;

  genvar i;
  generate
    for (i = 0; i < 64; i++) begin : eachOr
      or OR (tmp[i+1], tmp[i], a[i]);
    end
  endgenerate

  not NOT (out, tmp[64]);
endmodule

module ifZero64_testbench ();
  logic out;
  logic [63:0] a;

  ifZero64 dut (.out, .a);

  integer i;
  initial begin
    for (i = 64'b1; i != 0; i <<= 1) begin
      a = i; #10;
    end
    a = 64'b0; #10;
  end
endmodule
