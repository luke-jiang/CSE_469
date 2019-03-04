// CSE 469
// Lab 2
// Chen Bai, Luke Jiang
// 10/26/2018

// 1-bit gate-level full adder.

`timescale 1ps / 1ps

module fullAdder (result, carry_out, cin, A, B);
  output logic result, carry_out;
  input logic cin, A, B;

  xor #50 XOR (result, A, B, cin);

  logic [2:0] tmp;
  and #50 AND0 (tmp[0], A, B);
  and #50 AND1 (tmp[1], A, cin);
  and #50 AND2 (tmp[2], B, cin);

  or #50 OR (carry_out, tmp[0], tmp[1], tmp[2]);
endmodule

module fullAdder_testbench ();
  logic result, carry_out;
  logic cin, A, B;

  fullAdder dut (.result, .carry_out, .cin, .A, .B);

  integer i;
  initial begin
    for (i = 0; i < 8; i++) begin
      {A, B, cin} = i; #10;
    end
  end
endmodule
