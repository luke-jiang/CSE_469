// CSE 469
// Lab 4
// Chen Bai, Luke Jiang
// 

`timescale 1ps / 1ps

module controlLogic (
  output logic [12:0] cntrl,
  input logic [10:0] in,
  input logic zeroF, lessThanF
  );

  always_comb begin
    casex (in)
      11'b1001000100X: cntrl = 13'b010X00010010X; // ADDI
      11'b000101XXXXX: cntrl = 13'bXXX01000XXXXX; // B
      11'b11101011000: cntrl = 13'b011X010100001; // SUBS
      11'b10101011000: cntrl = 13'b010X010100001; // ADDS

      11'b10110100XXX: begin
        cntrl[`FlagWrite:`Reg2Loc] = 8'b000XX000;
        cntrl[`BrTaken] = zeroF;
        cntrl[`ALUOp1:`CondBr] = 4'b0001;
      end  // CBZ

      11'b11111000010: cntrl = 13'b010X00011001X; // LDUR
      11'b11111000000: cntrl = 13'b010X0010XX010; // STUR

      11'b01010100XXX: begin
        cntrl[`FlagWrite:`Reg2Loc] = 8'b000XXXXX;
        cntrl[`BrTaken] = lessThanF;
        cntrl[`ALUOp1:`CondBr] = 4'bXXX1;
      end  // B.LT

      11'b10001010000: cntrl = 13'b100X010100001; // AND
      11'b11001010000: cntrl = 13'b110X010100001; // EOR
      11'b11010011010: cntrl = 13'bXXXX000101XXX; // LSR
		//default: cntrl = 13'b0;
    endcase
  end
endmodule
