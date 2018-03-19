`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:23:25 11/21/2016 
// Design Name: 
// Module Name:    Mux 
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
module Mux_FlushPC_nPC(
	 input  FlushPC,           //ѡ���ź�
	 input  [31:0] PCplus4,    //����0,PC+4
	 input  [31:0] nPC,        //����1,��ת���֧��ַ
	 output  [31:0] F_nPC      //ѡ����
	 );
	 assign F_nPC = FlushPC ? nPC : PCplus4;
	 
endmodule


module Mux_RegAddr(
	 input  RegDst,           //ѡ���ź�
	 input  [4:0] Rt,         //��ѡֵ0
	 input  [4:0] Rd,         //��ѡֵ1
	 output  [4:0] RegAddr    //ѡ����
    );
	 assign RegAddr = RegDst ? Rd : Rt;

endmodule


module Mux_ALUSrc(
	 input ALUSrc,              //ѡ���ź�
	 input [31:0] ReadData2,    //��ѡֵ0
	 input [31:0] imm32,        //��ѡֵ1
	 output [31:0] ALU_B        //ѡ����
    );
	 assign ALU_B = ALUSrc ? imm32 : ReadData2;

endmodule


module Mux_RegData(
	 input  MemtoReg,           //ѡ���ź�
	 input  [31:0] ALUOut,      //��ѡֵ0
	 input  [31:0] ReadData,    //��ѡֵ1
	 output  [31:0] RegData     //ѡ����
    );
	 assign RegData = MemtoReg ? ReadData : ALUOut;

endmodule


module Mux_raRegData(
	 input  RegRA,               //ѡ���ź�
	 input  [31:0] RegData,      //����0
	 input  [31:0] PCplus8,      //����1
	 output  [31:0] raRegData    //������
	 );
	 assign raRegData = RegRA ? PCplus8 : RegData;
	 
endmodule


module Mux_RegRA(
	 input  RegRA,               //ѡ���ź�           
	 input  [4:0] RegAddr,       //����0
	 output  [4:0] raRegAddr    //������
	 );
	 assign raRegAddr = RegRA ? 5'b11111 : RegAddr;
	 
endmodule


module Mux_MF_sel(
	 input  JumpLink,                //ѡ���ź�
	 input  [31:0] ALUOutM,          //����0
	 input  [31:0] PCplus8M,         //����1
	 output  [31:0] MF_sel           //������
	 );
	 assign MF_sel = JumpLink ? PCplus8M : ALUOutM ;
	 
endmodule
