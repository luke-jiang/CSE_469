`timescale 1ns/10ps

module CPU (clk, reset);

  parameter Reg2Loc = 0;
  parameter ALUSrc0 = 1;
  parameter ALUSrc1 = 2;
  parameter Sel2Reg0 = 3;
  parameter Sel2Reg1 = 4;
  parameter RegWrite = 5;
  parameter MemWrite = 6;
  parameter FlagWrite = 7;
  parameter BrTaken = 8;
  parameter CondBr = 9;
  parameter ALUOp0 = 10;
  parameter ALUOp1 = 12;

  parameter negativeF = 3;
  parameter zeroF = 2;
  parameter overflowF = 1;
  parameter carry_outF = 0;

  input logic clk, reset;

  logic [63:0] address;           // Current Address
  logic [31:0] instruction;       // Current Instruction
  logic [12:0] cntrl;             // 13-bit control
  logic [3:0] regfIn, regfOut;    // Data input/output to flag reg
  logic lessThanF;                // less-than flag

  // input data to CPU
  logic [63:0] Imm12;
  logic [63:0] Imm26, Imm26LS2;
  logic [63:0] Imm9;
  logic [63:0] Imm19;
  logic [4:0] Rn, Rd, Rm;
  logic [5:0] shamt;

  // Connection between modules
  logic [63:0] incr4Adder_out;
  logic [63:0] branchAdder_out;
  logic [63:0] BrTakenMux_out;
  logic [63:0] CondBrMux_out;
  logic [63:0] LS2_out;
  logic [4:0] Reg2LocMux_out;
  logic [63:0] ALUSrcMux_out;
  logic [63:0] shifter_out;
  logic [63:0] DataMem_out;
  logic [63:0] WriteData;  // Dw input of regfile
  logic [63:0] ReadData1, ReadData2;  // Da output of regfile
  logic [63:0] ALU_out;

  // The Program Counter
  PC programCounter (.out(address), .in(BrTakenMux_out), .reset, .clk);

  // The InstructMem
  instructmem instrm (.address, .instruction, .clk);

  // Assign CPU inputs based on instruction
  assign Imm12 = {52'b0, instruction[21:10]};
  assign Rd = instruction[4:0];
  assign Rn = instruction[9:5];
  assign Rm = instruction[20:16];
  assign Imm26 = 64'(signed'(instruction[25:0]));
  assign Imm19 = 64'(signed'(instruction[23:5]));
  assign Imm9 = 64'(signed'(instruction[20:12]));
  assign shamt = instruction[15:10];

  // Assign control logic
  always_comb begin
    casex (instruction[31:21])
      11'b1001000100X: cntrl = 13'b010X00010010X; // ADDI
      11'b000101XXXXX: cntrl = 13'bXXX01000XXXXX; // B
      11'b11101011000: cntrl = 13'b011X010100001; // SUBS
      11'b10101011000: cntrl = 13'b010X010100001; // ADDS

      11'b10110100XXX: begin
        cntrl[FlagWrite:Reg2Loc] = 8'b000XX000;
        cntrl[BrTaken] = regfIn[zeroF];
        cntrl[ALUOp1:CondBr] = 4'b0001;
      end  // CBZ

      11'b11111000010: cntrl = 13'b010X00011001X; // LDUR
      11'b11111000000: cntrl = 13'b010X0010XX010; // STUR

      11'b01010100XXX: begin
        cntrl[FlagWrite:Reg2Loc] = 8'b000XXXXX;
        cntrl[BrTaken] = lessThanF;
        cntrl[ALUOp1:CondBr] = 4'bXXX1;
      end  // B.LT

      11'b10001010000: cntrl = 13'b100X010100001; // AND
      11'b11001010000: cntrl = 13'b110X010100001; // EOR
      11'b11010011010: cntrl = 13'bXXXX000101XXX; // LSR
		default: cntrl = 13'bX;
    endcase
  end

  mux64x2_1 CondBrMux (
    .out(CondBrMux_out),
    .d({Imm19, Imm26}),
    .sel(cntrl[CondBr])
  );

   // Left shift Imm26 by 2
  shifter LS2 (
    .value(CondBrMux_out),
    .direction(1'b0),
    .distance(6'd2),
    .result(LS2_out)
  );

  // Adder for incrementing 4 to current address
  alu incr4Adder (
    .A(64'd4), .B(address),
    .cntrl(3'b010),
    .result(incr4Adder_out),
    .negative(), .zero(), .overflow(), .carry_out()
  );

  // Adder for incrementing specified amount (branch) to current address
  alu branchAdder (
    .A(LS2_out), .B(address),
    .cntrl(3'b010),
    .result(branchAdder_out),
    .negative(), .zero(), .overflow(), .carry_out()
  );

  // Select which address as the next address
  mux64x2_1 BrTakenMux (
    .out(BrTakenMux_out),
    .d({branchAdder_out, incr4Adder_out}),
    .sel(cntrl[BrTaken])
  );

  // The RegFile
  mux5x2_1 Reg2LocMux (
    .out(Reg2LocMux_out),
    .d({Rm, Rd}),
    .sel(cntrl[Reg2Loc])
  );
  regfile regfi (
    .ReadData1, .ReadData2, .WriteData,
    .ReadRegister1(Rn), .ReadRegister2(Reg2LocMux_out),
    .WriteRegister(Rd), .RegWrite(cntrl[RegWrite]),
    .clk
  );

  // The ALU
  mux64x4_1 ALUSrcMux (
    .out(ALUSrcMux_out),
    .d({64'b0, Imm12, Imm9, ReadData2}),
    .sel(cntrl[ALUSrc1:ALUSrc0])
  );
  alu theALU (
    .A(ReadData1), .B(ALUSrcMux_out),
    .cntrl(cntrl[ALUOp1:ALUOp0]),
    .result(ALU_out),
    .negative(regfIn[negativeF]),
    .zero(regfIn[zeroF]),
    .overflow(regfIn[overflowF]),
    .carry_out(regfIn[carry_outF])
  );

  // The flag register
  regflag regfl (
    .out(regfOut),
    .lessThanF,
    .in(regfIn),
    .en(cntrl[FlagWrite]),
    .reset, .clk
  );

  // The shifter
  shifter theRightShifter (
    .result(shifter_out),
    .value(ReadData1),
    .direction(1'b1),
    .distance(shamt)
  );

  // The DataMem
  datamem datam (
    .address(ALU_out),
    .write_enable(cntrl[MemWrite]),
    .read_enable(cntrl[Sel2Reg1]),
    .write_data(ReadData2),
    .read_data(DataMem_out),
    .clk, .xfer_size(4'd8)
  );

  mux64x4_1 Sel2RegMux (
    .out(WriteData),
    .d({64'b0, DataMem_out, shifter_out, ALU_out}),
    .sel(cntrl[Sel2Reg1:Sel2Reg0])
  );

endmodule

module CPU_testbench ();
  parameter ClockDelay = 3000;

  logic clk, reset;

  CPU dut (.clk, .reset);

  initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

  integer i;

  initial begin
    reset <= 1; @(posedge clk);
    reset <= 0; @(posedge clk);
    for (i = 0; i < 2000; i++) begin
      @(posedge clk);
    end
	 $stop();
  end
endmodule
