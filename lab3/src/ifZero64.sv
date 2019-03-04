// CSE 469
// Lab 3
// Chen Bai, Luke Jiang
// 11/08/2018

// This module checks if all 64 bits in input a are zero.

`timescale 1ps / 1ps

module ifZero64(out, a);
  input [63:0] a;
  output out;

  logic [15:0] inter1;
  logic [3:0] inter2;

  genvar i, j;

  generate
    for (i = 0; i < 16; i++) begin : en1
      nor #50 nor1s (inter1[i], a[i*4], a[i*4+1], a[i*4+2], a[i*4+3]); 
    end

    for (j = 0; j < 4; j++) begin : en2
      nor #50 nor2s (inter2[j], inter1[j*4], inter1[j*4+1], inter1[j*4+2], inter1[j*4+3]); 
    end
  endgenerate

  nor #50 result (out, inter2[0], inter2[1], inter2[2], inter2[3]);

endmodule

module ifZero64_testbench ();
  logic out;
  logic [63:0] a, i;

  ifZero64 dut (.out, .a);

  initial begin
    for (i = 64'b1; i != 0; i = i<<1) begin
      a = i; #10;
    end
    a = 64'b0; #10;
  end
endmodule

