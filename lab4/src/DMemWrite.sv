// CSE 469
// Lab 4
// Chen Bai, Luke Jiang
// 30/11/2018

// DataMen write stage.

`include "header.svh"
`timescale 1ns / 10ps

module DMemWrite (
  output logic [399:0] out,
  input  logic [399:0] in,
  input  logic clk
  );

  logic [15:0] control;
  logic [63:0] DataMem_out, Sel2RegMux_out;

  assign out[`Rd+:16]         = in[`Rd+:16];
  assign out[`WriteData+:64]  = Sel2RegMux_out;
  assign out[`cntrl+:16]      = in[`cntrl+:16];
  assign control              = in[`cntrl+:16];

  // The DataMem
  datamem datam (
    .address                  (in[`ALUout+:64]),
    .write_enable             (control[`MemWrite]),
    .read_enable              (control[`Sel2Reg1]),
    .write_data               (in[`Db+:64]),
    .xfer_size                (4'd8),
    .read_data                (DataMem_out),
    .clk
  );

  mux64x4_1 Sel2RegMux (
    .out                      (Sel2RegMux_out),
    .d                        ({64'b0,
                              DataMem_out,
                              in[`shifterOut+:64],
                              in[`ALUout+:64]}),
    .sel                      (control[Sel2Reg1:Sel2Reg0])
  );

endmodule
