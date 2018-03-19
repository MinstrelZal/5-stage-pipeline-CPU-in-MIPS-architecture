`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:44:51 11/22/2016 
// Design Name: 
// Module Name:    Hazard 
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
module Hazard(                      
	 input  [31:0] InstrD,           //ID��ָ��
	 input  [31:0] InstrE,           //EX��ָ��
	 input  movWriteE,
	 input  bWriteE,
	 input  [31:0] InstrM,           //MEM��ָ��
	 input  movWriteM,
	 input  bWriteM,
	 input  [31:0] InstrW,           //WB��ָ��
	 input  movWriteW,
	 input  bWriteW,
	 output  Stall,                  //����PC,����IF/ID��ˮ���Ĵ���,��ID/EX��ˮ���Ĵ���������ź�
	 output  [1:0] ForwardRSD,       //ID��RSת���ź�
	 output  [1:0] ForwardRTD,       //ID��RTת���ź�
	 output  [1:0] ForwardRSE,       //EX��RSת���ź�
	 output  [1:0] ForwardRTE,       //EX��RTת���ź�
	 output  [1:0] ForwardRTM        //MEM��RTת���ź�
    );
	 
	 //��ͣ�ź�
	 Stall stall_signal(InstrD,InstrE,movWriteE,InstrM,Stall);
	 
	 //ת���ź�
	 Forward forward_signal(InstrD,InstrE,movWriteE,bWriteE,InstrM,movWriteM,bWriteM,InstrW,movWriteW,bWriteW,
								   ForwardRSD,ForwardRTD,ForwardRSE,ForwardRTE,ForwardRTM);

endmodule
