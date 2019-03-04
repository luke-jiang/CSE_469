// CSE 469
// Lab 2
// Chen Bai, Luke Jiang
// 10/26/2018

// ALU top module and testbench

`timescale 1ns/10ps

module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
  output logic [63:0] result;
  output logic negative, zero, overflow, carry_out;
  input logic [63:0] A, B;
  input logic [2:0] cntrl;

  logic [63:0] carry;

  bitALU alu0 (
    .result         (result[0]),
    .carry_out      (carry[0]),
    .A              (A[0]),
    .B              (B[0]),
    .cin            (cntrl[0]),
    .cntrl
  );


  genvar i;
  generate
    for(i = 1; i < 64; i++) begin : eachalu
      bitALU alus (
        .result     (result[i]),
        .carry_out  (carry[i]),
        .A          (A[i]),
        .B          (B[i]),
        .cin        (carry[i-1]),
        .cntrl
      );
    end
  endgenerate

  assign negative = result[63];
  assign carry_out = carry[63];
  xor xor0 (overflow, carry[63], carry[62]);
  ifZero64 iz (zero, result);
endmodule



// Test bench for ALU
// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;


	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	logic [63:0] tmp, tmp2, tmp3;
	initial begin

		$display("%t testing PASS_A operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end

		// testing addition
		$display("%t testing addition: positive, no overflow", $time);
		cntrl = ALU_ADD;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);

		$display("%t testing addition: positive, overflow", $time);
		cntrl = ALU_ADD;
		A = 64'h9000000000000001; B = 64'hE000000000000001;
		#(delay);
		assert(result == 64'h7000000000000002 && carry_out == 1 && overflow == 1 && negative == 0 && zero == 0);

		$display("%t testing addition: zero, no overflow", $time);
		cntrl = ALU_ADD;
		A = 64'h0000000000000003; B = 64'hFFFFFFFFFFFFFFFD;
		#(delay);
		assert(result == 64'h0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);

		$display("%t testing addition: zero, overflow", $time);
		cntrl = ALU_ADD;
		A = 64'h8000000000000000; B = 64'h8000000000000000;
		#(delay);
		assert(result == 64'h0 && carry_out == 1 && overflow == 1 && negative == 0 && zero == 1);

		$display("%t testing addition: negative, no overflow", $time);
		cntrl = ALU_ADD;
		A = 64'hFFFFFFFFFFFFFFFD; B = 64'hFFFFFFFFFFFFFFFD;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFA && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);

		$display("%t testing addition: negative, overflow", $time);
		cntrl = ALU_ADD;
		A = 64'h5000000000000000; B = 64'h6000000000000000;
		#(delay);
		assert(result == 64'hB000000000000000 && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);

		// testing subtraction
		$display("%t testing subtraction: positive, no overflow", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h0000000000000001; B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);

		$display("%t testing subtraction: positive, overflow", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h9000000000000001; B = ~(64'hE000000000000001) + 64'h1;
		#(delay);
		assert(result == 64'h7000000000000002 && carry_out == 1 && overflow == 1 && negative == 0 && zero == 0);

		$display("%t testing subtraction: zero, no overflow", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h0000000000000003; B = ~(64'hFFFFFFFFFFFFFFFD) + 64'h1;
		#(delay);
		assert(result == 64'h0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);

		// will never happen
		/*$display("%t testing subtraction: zero, overflow", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h8000000000000000; B = 64'h8000000000000000; // A = 64'h8000000000000000; B = 64'h8000000000000000;
		#(delay);
		assert(result == 64'h0 && carry_out == 1 && overflow == 1 && negative == 1&& zero == 0); */

		$display("%t testing subtraction: negative, no overflow", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'hFFFFFFFFFFFFFFFD; B = ~(64'hFFFFFFFFFFFFFFFD) + 64'h1;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFA && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);

		$display("%t testing subtraction: negative, overflow", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h5000000000000000; B = ~(64'h6000000000000000) + 64'h1;
		#(delay);
		assert(result == 64'hB000000000000000 && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);

		$display("%t testing and", $time);
		cntrl = ALU_AND;
		for (i=0; i<10; i++) begin
			A = $random(); B = $random();
			#(delay);
			assign tmp = A & B;
			assert(result == tmp && negative == tmp[63] && zero == (tmp == '0));
		end

		$display("%t testing or", $time);
		cntrl = ALU_OR;
		for (i=0; i<10; i++) begin
			A = $random(); B = $random();
			#(delay);
			assign tmp2 = A | B;
			assert(result == tmp2 && negative == tmp2[63] && zero == (tmp2 == '0));
		end

		$display("%t testing XOR", $time);
		cntrl = ALU_XOR;
		for (i=0; i<10; i++) begin
			A = $random(); B = $random();
			#(delay);
			assign tmp3 = A ^ B;
			assert(result == tmp3 && negative == tmp3[63] && zero == (tmp3 == '0));
		end

	end
endmodule
