`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:51:01 11/21/2016 
// Design Name: 
// Module Name:    E_Registers 
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
module E_Registers(               
	 input  clk,                   //时钟
	 input  reset,                 //复位
	 input  stall,                 //清零(阻塞信号)
	 input  Int,
	 input  IntBackM,
	 input  [31:0] PCplus4F,
    input  [31:0] InstrD,         //Instr in ID
	 input  [31:0] PCplus4D,       //PC+4 in ID
	 input  [31:0] PCplus8D,       //PC+8 in ID
	 input  [31:0] ReadData1D,     //ReadData1 in ID
	 input  [31:0] ReadData2D,     //ReadData2 in ID
	 input  [31:0] ExtD,           //EXT in ID
	 input  bWriteD,
    output  [31:0] InstrE,        //Instr in EX
	 output  [31:0] PCplus4E,      //PC+4 in EX
	 output  [31:0] PCplus8E,      //PC+8 in EX
	 output  [31:0] ReadData1E,    //ReadData1 in EX
	 output  [31:0] ReadData2E,    //ReadData2 in EX
	 output  [31:0] ExtE,          //EXT in EX
	 output  bWriteE
    );
	 reg [31:0] Instr;
	 reg [31:0] PCplus4;
	 reg [31:0] PCplus8;
	 reg [31:0] ReadData1;
	 reg [31:0] ReadData2;
	 reg [31:0] Ext;
	 reg bWrite;
	 
	 assign InstrE = Instr,
			  PCplus4E = PCplus4,
			  PCplus8E = PCplus8,
			  ReadData1E = ReadData1,
			  ReadData2E = ReadData2,
			  ExtE = Ext,
			  bWriteE = bWrite;
			  
	 initial begin                   //初始化??
		Instr <= 32'h0000_0000;
		PCplus4 <= 32'h0000_3004;
		PCplus8 <= 32'h0000_3008;
		ReadData1 <= 32'h0000_0000;
		ReadData2 <= 32'h0000_0000;
		Ext <= 32'h0000_0000;
		bWrite <= 1'b0;
	 end
		
	 always @(posedge clk) begin
		if(reset | stall | Int) begin               //复位
			Instr <= 32'h0000_0000;
			ReadData1 <= 32'h0000_0000;
			ReadData2 <= 32'h0000_0000;
			Ext <= 32'h0000_0000;
			bWrite <= 1'b0;
			if (reset) begin
				PCplus4 <= 32'h0000_3004;
				PCplus8 <= 32'h0000_3008;
			end
			else if (IntBackM) begin
				PCplus4 <= PCplus4F - 32'h0000_0004;
			end
		end
		else begin
			Instr <= InstrD;
			PCplus4 <= PCplus4D;
			PCplus8 <= PCplus8D;
			ReadData1 <= ReadData1D;
			ReadData2 <= ReadData2D;
			Ext <= ExtD;
			bWrite <= bWriteD;
		end
	 end

endmodule
