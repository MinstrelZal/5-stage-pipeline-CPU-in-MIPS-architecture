`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:29:01 11/21/2016 
// Design Name: 
// Module Name:    Shift2 
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
module Shift2(
	 input  [31:0] in,      //32位立即数
    output  [31:0] out     //左移2位结果
    );
	 assign out = in << 2;

endmodule
