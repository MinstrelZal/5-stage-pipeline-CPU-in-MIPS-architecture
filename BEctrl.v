`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:35:33 12/12/2016 
// Design Name: 
// Module Name:    BEctrl 
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
`define op 31:26
module BEctrl(
	 input  [31:0] InstrM, //MEM级指令
	 input  [1:0] AddrLow, //DM低二位地址
	 output  [3:0] BE      //DM字节写入控制信号
    );
	 parameter sw = 6'b101_011,
				  sh = 6'b101_001,
				  sb = 6'b101_000;
				  
	 assign BE[3:0] = (InstrM[`op] == sw) ? 4'b1111 :   //sw
							(InstrM[`op] == sh) ? ((AddrLow == 2'b00) ? 4'b0011 :      //sh
														  (AddrLow == 2'b10) ? 4'b1100 : 4'b0000) :
							(InstrM[`op] == sb) ? ((AddrLow == 2'b00) ? 4'b0001 :      //sb
														  (AddrLow == 2'b01) ? 4'b0010 :
														  (AddrLow == 2'b10) ? 4'b0100 :
														  (AddrLow == 2'b11) ? 4'b1000 : 4'b0000) :
																									  4'b0000;

endmodule
