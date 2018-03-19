`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:06:47 11/21/2016 
// Design Name: 
// Module Name:    W_Registers 
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
module W_Registers(              
	 input  clk,                  //时钟
	 input  reset,                //复位
    input  [31:0] InstrM,        //Instr in MEM
	 input  [31:0] PCplus4M,      //PC+4 in MEM
	 input  [31:0] PCplus8M,      //PC+8 in MEM
	 input  [31:0] ALUOutM,       //ALUOut in MEM
	 input  movWriteM,
	 input  bWriteM,
	 input  [31:0] ReadDataM,     //ReadData in MEM
    output  [31:0] InstrW,       //Instr in WB
	 output  [31:0] PCplus4W,     //PC+4 in WB
	 output  [31:0] PCplus8W,     //PC+8 in WB
	 output  [31:0] ALUOutW,      //ALUOut in WB
	 output  movWriteW,
	 output  bWriteW,
	 output  [31:0] ReadDataW     //ReadData in WB
    );
	 reg [31:0] Instr;
	 reg [31:0] PCplus4;
	 reg [31:0] PCplus8;
	 reg [31:0] ALUOut;
	 reg movWrite;
	 reg bWrite;
	 reg [31:0] ReadData;
	 
	 assign InstrW = Instr,
			  PCplus4W = PCplus4,
			  PCplus8W = PCplus8,
			  ALUOutW = ALUOut,
			  movWriteW = movWrite,
			  bWriteW = bWrite,
			  ReadDataW = ReadData;
	 
	 initial begin                  //初始化??
		Instr <= 32'h0000_0000;
		PCplus4 <= 32'h0000_3004;
		PCplus8 <= 32'h0000_3008;
		ALUOut <= 32'h0000_0000;
		movWrite <= 1'b0;
		bWrite <= 1'b0;
		ReadData <= 32'h0000_0000;
	 end
	 
	 always @(posedge clk) begin
		if(reset) begin                   //复位
			Instr <= 32'h0000_0000;
			PCplus4 <= 32'h0000_3004;
			PCplus8 <= 32'h0000_3008;
			ALUOut <= 32'h0000_0000;
			movWrite <= 1'b0;
			bWrite <= 1'b0;
			ReadData <= 32'h0000_0000;
		end
		else begin
			Instr <= InstrM;
			PCplus4 <= PCplus4M;
			PCplus8 <= PCplus8M;
			ALUOut <= ALUOutM;
			movWrite <= movWriteM;
			bWrite <= bWriteM;
			ReadData <= ReadDataM;
		end
	 end

endmodule
