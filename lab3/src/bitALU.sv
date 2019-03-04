// CSE 469
// Lab 3
// Chen Bai, Luke Jiang
// 11/08/2018

// 1-bit ALU 

`timescale 1ps / 1ps

module bitALU (result, carry_out, A, B, cin, cntrl);
  output logic result, carry_out;
  input logic A, B, cin;
  input logic [2:0] cntrl;

  logic [7:0] resultMIn;

  assign resultMIn[0] = B;
  assign resultMIn[1] = 64'b0;
  assign resultMIn[3] = resultMIn[2];
  assign resultMIn[7] = 64'b0;

  fullAdderSel faSel1 (.result(resultMIn[2]), .carry_out, .cin, .A, .B, .sel(cntrl[0]));
  and #50 AND (resultMIn[4], A, B);
  or #50 OR (resultMIn[5], A, B);
  xor #50 XOR (resultMIn[6], A, B);

  mux8_1 mux (.out(result), .d(resultMIn), .sel(cntrl));
endmodule

module bitALU_testbench ();
  logic result, carry_out;
  logic A, B, cin;
  logic [2:0] cntrl;

  bitALU dut (.result, .carry_out, .A, .B, .cin, .cntrl);

  integer i;
  initial begin
    cntrl = 3'b000;
    for (i = 0; i < 8; i++) begin
      {A, B, cin} = i; #1000;
    end
    cntrl = 3'b010;
    for (i = 0; i < 8; i++) begin
      {A, B, cin} = i; #1000;
    end
    cntrl = 3'b011;
    for (i = 0; i < 8; i++) begin
      {A, B, cin} = i; #1000;
    end
    cntrl = 3'b100;
    for (i = 0; i < 8; i++) begin
      {A, B, cin} = i; #1000;
    end
    cntrl = 3'b101;
    for (i = 0; i < 8; i++) begin
      {A, B, cin} = i; #1000;
    end
    cntrl = 3'b110;
    for (i = 0; i < 8; i++) begin
      {A, B, cin} = i; #1000;
    end
  end
endmodule
