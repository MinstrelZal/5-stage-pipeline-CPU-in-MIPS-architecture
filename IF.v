`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:01:52 12/05/2016 
// Design Name: 
// Module Name:    IF 
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
module IF(
	 input  clk,                 //ʱ��
	 input  reset,               //�����λ�ź�
	 input  stall,               //PCʹ���ź�,�͵�ƽ��Ч
	 input  FlushPC,             //�Ƿ��PC���и��µ��ź�
	 input  [31:0] nPC,          //��һָ��ĵ�ַ
	 input  IntReqM,
	 input  IntBackM,
	 input  [31:0] EPCoutM,
    output  [31:0] PCplus4F,    //PC+4
	 output  [31:0] PCplus8F,    //PC+8
    output  [31:0] InstrF       //InstrF��ʾ��ǰ������ָ��
    );
	 wire [31:0] PCF;             //��ǰָ��ĵ�ַ
	 wire [31:0] nPCF;
	 
	 //��õ�ǰָ��ĵ�ַ
	 PC pc_signal(clk,reset,stall,nPCF,IntReqM,IntBackM,EPCoutM,PCF);
    
	 //IMȡָ
	 IM im_signal(PCF,InstrF);
	 
	 //PC+4
	 Add4 add4_signal(PCF,PCplus4F);
	 
	 //PC+8
	 Add8 add8_signal(PCF,PCplus8F);
	 
	 //������Instr_DΪjָ��,����nPC
	 Mux_FlushPC_nPC mux_flushpc_pc_signal(FlushPC,PCplus4F,nPC,nPCF);

endmodule
