`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:00:23 11/21/2016 
// Design Name: 
// Module Name:    M_Registers 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module M_Registers(               
	 input  clk,                   //时钟
	 input  reset,                 //复位
	 input  Int,
    input  [31:0] InstrE,         //Instr in EX
	 input  [31:0] PCplus4E,       //PC+4 in EX
	 input  [31:0] PCplus8E,       //PC+8 in EX
	 input  [31:0] ALUOutE,        //ALUOut in EX
	 input  movWriteE,
	 input  bWriteE,
	 input  [31:0] mfReadData2E,   //mfReadData2 in EX
	 output  [31:0] InstrM,        //Instr in MEM
	 output  [31:0] PCplus4M,      //PC+4 in MEM
	 output  [31:0] PCplus8M,      //PC+8 in MEM
	 output  [31:0] ALUOutM,       //ALUOut in MEM
	 output  movWriteM,
	 output  bWriteM,
	 output  [31:0] ReadData2M     // ReadData2 in MEM
    );
	 reg [31:0] Instr;
	 reg [31:0] PCplus4;
	 reg [31:0] PCplus8;
	 reg [31:0] ALUOut;
	 reg movWrite;
	 reg bWrite;
	 reg [31:0] ReadData2;
	 
	 assign InstrM = Instr,
			  PCplus4M = PCplus4,
			  PCplus8M = PCplus8,
			  ALUOutM = ALUOut,
			  movWriteM = movWrite,
			  bWriteM = bWrite,
			  ReadData2M = ReadData2;
			  
	 initial begin                    //初始化??
		Instr <= 32'h0000_0000;
		PCplus4 <= 32'h0000_3004;
		PCplus8 <= 32'h0000_3008;
		ALUOut <= 32'h0000_0000;
		movWrite <= 1'b0;
		bWrite <= 1'b0;
		ReadData2 <= 32'h0000_0000;
	 end
	 
	 always @(posedge clk) begin
		if(reset | Int) begin                //复位
			Instr <= 32'h0000_0000;
			ALUOut <= 32'h0000_0000;
			movWrite <= 1'b0;
			bWrite <= 1'b0;
			ReadData2 <= 32'h0000_0000;
			if (reset) begin
				PCplus4 <= 32'h0000_3004;
				PCplus8 <= 32'h0000_3008;
			end
		end
		else begin
			Instr <= InstrE;
			PCplus4 <= PCplus4E;
			PCplus8 <= PCplus8E;
			ALUOut <= ALUOutE;
			movWrite <= movWriteE;
			bWrite <= bWriteE;
			ReadData2 <= mfReadData2E;
		end
	 end

endmodule
