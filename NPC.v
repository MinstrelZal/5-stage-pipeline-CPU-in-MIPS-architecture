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
	 input  Jump,                //j,jal����ת�ź�
    input  [25:0] imm26,        //j��ָ��26λ��������ַ
	 input  B,                   //B������ź�
	 input  [31:0] imm32_b,      //b��ָ���֧��ַ
	 input  JR,                  //jr����ת�ź�
	 input  [31:0] mfReadData1,  //jrָ����ת��ַ
    output  [31:0] nPC          //��һ��ָ��ĵ�ַ
    );
	 assign nPC = Jump ? {PCplus4D[31:28],imm26[25:0],2'b00} : 
					  B ? (imm32_b + PCplus4D) : 
					  JR ? mfReadData1 : 
					  PCplus4D ;

endmodule
