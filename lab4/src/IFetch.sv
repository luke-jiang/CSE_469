// CSE 469
// Lab 4
// Chen Bai, Luke Jiang
// 30/11/2018

// Instruction Fetch stage.

`include "header.svh"
`timescale 1ns / 10ps

module IFetch (
  output logic [399:0] out,
  input  logic [63:0] next_address,
  input  logic [12:0] cntrl,
  input  logic reset, clk
  );

  parameter BrTaken = 8;
  logic [31:0] instruction;
  logic [63:0] address;
  logic [63:0] incr4Adder_out;          // to BrTakenMux option 0
  logic [63:0] BrTakenMux_out;

  // The Program Counter
  PC programCounter (
    .out                    (address),
    .in                     (BrTakenMux_out),
    .reset, .clk
  );

  // The InstructMem
  instructmem instrm (.address, .instruction, .clk);

  // Assign CPU inputs based on instruction
  assign out[`Rd+:16]       = instruction[4:0];
  assign out[`Rn+:16]       = instruction[9:5];
  assign out[`Rm+:16]       = instruction[20:16];
  assign out[`shamt+:16]    = instruction[15:10];
  assign out[`opCode+:16]   = instruction[31:21];
  assign out[`Imm9+:64]     = 64'(signed'(instruction[20:12]));
  assign out[`Imm12+:64]    = {52'b0, instruction[21:10]};
  assign out[`Imm19+:64]    = 64'(signed'(instruction[23:5]));
  assign out[`Imm26+:64]    = 64'(signed'(instruction[25:0]));
  assign out[`PC+:64]       = address;

  // Adder for incrementing 4 to current address
  alu incr4Adder (
    .A                      (64'd4),
    .B                      (address),
    .cntrl                  (3'b010),
    .result                 (incr4Adder_out),
    .negative               (),
    .zero                   (),
    .overflow               (),
    .carry_out              ()
  );
  // Select which address as the next address
  mux64x2_1 BrTakenMux (
    .out                    (BrTakenMux_out),
    .d                      ({next_address,
                            incr4Adder_out}),
    .sel                    (cntrl[BrTaken])
  );
endmodule
