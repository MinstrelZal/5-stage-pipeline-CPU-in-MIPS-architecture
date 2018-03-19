`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:20 11/21/2016 
// Design Name: 
// Module Name:    Add4 
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
module Add4(
	 input  [31:0] PC,           //当前指令的地址
    output  [31:0] PCplus4      //PC+4
    );
	 assign PCplus4 = PC + 32'h0000_0004;

endmodule
