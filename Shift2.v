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
	 input  [31:0] in,      //32λ������
    output  [31:0] out     //����2λ���
    );
	 assign out = in << 2;

endmodule
