`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:15:28 11/21/2016 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
	 input  [15:0] imm16,      //16位立即数
	 input	zeroExtend,       //零扩展信号
    output  [31:0] imm32      //32位立即数
    );
	 assign imm32 = zeroExtend ? {{16{1'b0}},imm16[15:0]} : {{16{imm16[15]}},imm16[15:0]} ;

endmodule
