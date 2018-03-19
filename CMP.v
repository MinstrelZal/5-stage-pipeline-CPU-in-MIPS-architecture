`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:43:59 11/21/2016 
// Design Name: 
// Module Name:    CMP 
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
module CMP(
	 input  [31:0] ReadData1,          //RS中的数据
    input  [31:0] ReadData2,          //Rt中的数据
    output  EqualD,                   //若ReadData1=ReadData2, EqualD=1
	 output  LtzD                      //若ReadData1-ReadData2<0,LtzD=1
    );
	 wire [31:0] result;
	 
	 assign result = ReadData1 - ReadData2;
	 
	 assign EqualD = (result == 32'h0000_0000) ? 1'b1 : 1'b0;
	 
	 assign LtzD = result[31];

endmodule
