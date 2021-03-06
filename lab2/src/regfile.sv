// CSE 469
// Lab 1
// Chen Bai, Luke Jiang
// 10/05/2018

// This is the top module of regfile.

`timescale 1ns/10ps

// @param ReadData1, ReadData2: two outputs
// @param ReadRegister1, ReadRegister2: two register selection
// @param WriteData: input data to be written
// @param RegWrite: if write data into register or not
// @param writeReg: select which register to write data into
module regfile (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2,
  WriteRegister, RegWrite, clk);

  output logic [63:0] ReadData1, ReadData2;
  input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
  input logic [63:0] WriteData;
  input logic RegWrite, clk;

  // decoder
  logic [31:0] decoderOut;
  decoder5x32 decoder (
    .out(decoderOut),
    .in(WriteRegister),
    .en(RegWrite)
  );

  // register array
  logic [31:0][63:0] registerOut;
  genvar i;
  generate
    for (i = 0; i < 31; i++) begin : eachRegister
      register registers (
        .out      (registerOut[i]),
        .in       (WriteData),
        .reset    (0),
        .en       (decoderOut[i]),
        .clk
      );
    end
  endgenerate
  assign registerOut[31] = 64'd0;

  // index into mux input buses
  logic [63:0][31:0] muxIn;
  integer j, k;
  always_comb begin
    for (j = 0; j < 64; j++) begin
      for (k = 0; k < 32; k++) begin
        muxIn[j][k] = registerOut[k][j];
      end
    end
  end

  // mux
  genvar h;
  generate
    for (h = 0; h < 64; h++) begin : eachMux32_1
      mux32_1 mux1 (.out(ReadData1[h]), .d(muxIn[h]), .sel(ReadRegister1));
      mux32_1 mux2 (.out(ReadData2[h]), .d(muxIn[h]), .sel(ReadRegister2));
    end
  endgenerate
endmodule



module regstim ();

	parameter ClockDelay = 5000;

	logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	logic [63:0]	WriteData;
	logic 			RegWrite, clk;
	logic [63:0]	ReadData1, ReadData2;

	integer i;

	// Your register file MUST be named "regfile".
	// Also you must make sure that the port declarations
	// match up with the module instance in this stimulus file.
	regfile dut (.ReadData1, .ReadData2, .WriteData,
					 .ReadRegister1, .ReadRegister2, .WriteRegister,
					 .RegWrite, .clk);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

	initial begin
		// Try to write the value 0xA0 into register 31.
		// Register 31 should always be at the value of 0.
		RegWrite <= 5'd0;
		ReadRegister1 <= 5'd0;
		ReadRegister2 <= 5'd0;
		WriteRegister <= 5'd31;
		WriteData <= 64'h00000000000000A0;
		@(posedge clk);

		$display("%t Attempting overwrite of register 31, which should always be 0", $time);
		RegWrite <= 1;
		@(posedge clk);

		// Write a value into each register.
		$display("%t Writing pattern to all registers.", $time);
		for (i=0; i<31; i=i+1) begin
			RegWrite <= 0;
			ReadRegister1 <= i-1;
			ReadRegister2 <= i;
			WriteRegister <= i;
			WriteData <= i*64'h0000010204080001;
			@(posedge clk);

			RegWrite <= 1;
			@(posedge clk);
		end

		// Go back and verify that the registers
		// retained the data.
		$display("%t Checking pattern.", $time);
		for (i=0; i<32; i=i+1) begin
			RegWrite <= 0;
			ReadRegister1 <= i-1;
			ReadRegister2 <= i;
			WriteRegister <= i;
			WriteData <= i*64'h0000000000000100+i;
			@(posedge clk);
		end
		$stop;
	end
endmodule
