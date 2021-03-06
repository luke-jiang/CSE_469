// CSE 469
// Lab 3
// Chen Bai, Luke Jiang
// 11/08/2018

// 1-bit full adder with select signal (sel). If sel = 0, the full adder
// selects B as input. Else, the full adder selects ~B as input.

`timescale 1ps / 1ps

module fullAdderSel (result, carry_out, cin, A, B, sel);
  output  logic result, carry_out;
  input   logic cin, A, B, sel;

  logic xor_out;

  xor #50 (xor_out, B, sel);  // Select B or ~B
  fullAdder fa (.result, .carry_out, .cin, .A, .B(xor_out));
endmodule

module fullAdderSel_testbench ();
  logic result, carry_out;
  logic cin, A, B, sel;

  fullAdderSel dut (.result, .carry_out, .cin, .A, .B, .sel);

  integer i;
  initial begin
    sel = 0;
    for (i = 0; i < 8; i++) begin
      {A, B, cin} = i; #1000;
    end
    sel = 1;
    for (i = 0; i < 8; i++) begin
      {A, B, cin} = i; #1000;
    end
  end
endmodule
