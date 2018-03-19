`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:31:22 11/21/2016 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
	 input  clk,                  //ʱ��
    input  reset,                //��λ
    input  RegWrite,             //GRF��дʹ���ź�
    input  [4:0] ReadReg1,       //Rs�Ĵ����ĵ�ַ
    input  [4:0] ReadReg2,       //Rt�Ĵ����ĵ�ַ
    input  [4:0] RegAddr,        //Rd�Ĵ����ĵ�ַ
    input  [31:0] RegData,       //д��GRF������
    output  [31:0] ReadData1,    //Rs�Ĵ����е�����
    output  [31:0] ReadData2     //Rt�Ĵ����е�����
    );
	 reg [31:0] GPR[31:0];        //����һ���Ĵ�����
	 integer i;
	 
	 //���Ĵ�����ע��0�żĴ���
	 assign ReadData1 = (ReadReg1 == 0) ? 0 :                               //�ж��������Ƿ�Ϊ0�żĴ���
							  ((ReadReg1 == RegAddr) & RegWrite) ? RegData :      //�ж��������Ƿ�Ϊ��Ҫ����д��ļĴ��� (�Ĵ����ڲ�ת��)
														             GPR[ReadReg1];      
	 assign ReadData2 = (ReadReg2 == 0) ? 0 : 
							  ((ReadReg2 == RegAddr) & RegWrite) ? RegData : 
														             GPR[ReadReg2];
	 
	 initial begin                  //��ʼ��
		for(i=0;i<32;i=i+1)
			GPR[i] <= 0;
	 end
	 
	 always @(posedge clk) begin
		if(reset)                    //��λ
			for(i=0;i<32;i=i+1)
				GPR[i] <= 0;
		else if(RegWrite) begin      //д�Ĵ�����ע��0�żĴ���
			GPR[RegAddr] <= (RegAddr == 0) ? 0 : RegData;
			$display("$%d <= %h",RegAddr,RegData);
		end
	 end

endmodule
