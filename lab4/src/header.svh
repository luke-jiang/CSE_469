// CSE 469
// Lab 4
// Chen Bai, Luke Jiang
//

// This is the header file 
`ifndef _header_svh_
`define _header_svh_

// alignment 16bits

`define Rd 0
`define Rn 16
`define Rm 32
`define shamt 48
`define opCode 64
`define cntrl 64
`define Imm9 80
`define Imm12 144
`define Imm19 208
`define Imm26 272
`define PC 336
`define Da 80
`define Db 144
`define ALUSrc 208
`define BrTarget 272
`define RegFlag 272
`define ALUout 208
`define shifterOut 80
`define WriteData 80

// Paramaters for bits in control signal.
`define Reg2Loc 0
`define ALUSrc0 1
`define ALUSrc1 2
`define Sel2Reg0 3
`define Sel2Reg1 4
`define RegWrite 5
`define MemWrite 6
`define FlagWrite 7
`define BrTaken 8
`define CondBr 9
`define ALUOp0 10
`define ALUOp1 12

`endif
