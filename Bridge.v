`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:44:39 12/20/2016 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
	 input  [31:0] PrAddr,       //32λ��ַ����
	 input  [31:0] PrWD,         //CPU�����Bridgeģ�������
	 input  PrWE,                //CPU�����дʹ��
	 input  [31:0] RDTimer0,     //��ʱ��0�������
	 input  [31:0] RDTimer1,     //��ʱ��1�������
	 input  IRQTimer0,           //��ʱ��0�ж�����
	 input  IRQTimer1,           //��ʱ��1�ж�����
	 output  [31:0] Dev_DataIn,
	 output  [31:0] PrRD,        //CPU��Bridgeģ����������
	 output  [7:2] HWInt,        //6λӲ���ж�����
	 output  [3:2] Dev_Addr,     //����Ӳ����ַ
	 output  HitTimer0,          //��ʱ��0����
	 output  HitTimer1,          //��ʱ��1����
	 output  WETimer0,           //��ʱ��0дʹ��
	 output  WETimer1            //��ʱ��1дʹ��
    );
	 
	 assign Dev_DataIn = PrWD;                              //Dev_DataIn
	 
	 assign PrRD = HitTimer0 ? RDTimer0 :                   //PrRD
						HitTimer1 ? RDTimer1 :
												 0 ;
												 
	 assign HWInt = {4'b0,IRQTimer1,IRQTimer0};             //HWInt
												 
	 assign Dev_Addr = PrAddr[3:2];                         //Dev_Addr
	 
	 assign HitTimer0 = (PrAddr[31:4] == 28'h0000_7F0),     //HitTimer0
			  HitTimer1 = (PrAddr[31:4] == 28'h0000_7F1);     //HitTimer1
	 
	 assign WETimer0 = HitTimer0 && PrWE,                   //WETimer0
			  WETimer1 = HitTimer1 && PrWE;                   //WETimer1

endmodule
