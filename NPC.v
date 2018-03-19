`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:45:54 11/21/2016 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
	 input  [31:0] PCplus4D,     //PC+4
	 input  Jump,                //j,jal类跳转信号
    input  [25:0] imm26,        //j类指令26位立即数地址
	 input  B,                   //B类控制信号
	 input  [31:0] imm32_b,      //b类指令分支地址
	 input  JR,                  //jr类跳转信号
	 input  [31:0] mfReadData1,  //jr指令跳转地址
    output  [31:0] nPC          //下一条指令的地址
    );
	 assign nPC = Jump ? {PCplus4D[31:28],imm26[25:0],2'b00} : 
					  B ? (imm32_b + PCplus4D) : 
					  JR ? mfReadData1 : 
					  PCplus4D ;

endmodule
