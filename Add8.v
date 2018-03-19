`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:48:50 11/30/2016 
// Design Name: 
// Module Name:    Add8 
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
module Add8(
	 input  [31:0] PC,           //当前指令的地址
    output  [31:0] PCplus8      //PC+8
    );
	 assign PCplus8 = PC + 32'h0000_0008;

endmodule
