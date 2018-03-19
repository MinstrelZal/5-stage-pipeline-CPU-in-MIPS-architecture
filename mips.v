`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:43:26 12/06/2016 
// Design Name: 
// Module Name:    mips 
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
module mips(
	 input  clk,
	 input  reset
    );
	 //cpu wire
	 wire [31:0] PrAddr; //32λ��ַ����
	 wire [31:0] PrWD;   //CPU�����Bridgeģ�������
	 wire PrWE;           //CPU�����дʹ��
	 
	 //Bridge wire
	 wire [31:0] Dev_DataIn;
	 wire [31:0] PrRD;        //CPU��Bridgeģ����������
	 wire [7:2] HWInt;        //6λӲ���ж�����
	 wire [3:2] Dev_Addr;     //����Ӳ����ַ
	 wire HitTimer0;          //��ʱ��0����
	 wire HitTimer1;          //��ʱ��1����
	 wire WETimer0;           //��ʱ��0дʹ��
	 wire WETimer1;           //��ʱ��1дʹ��
	 
	 //timer0 wire
	 wire [31:0] RDTimer0;    //32λ�������
	 wire IRQTimer0;          //�ж�����
	 
	 //timer1 wire
	 wire [31:0] RDTimer1;    //32λ�������
	 wire IRQTimer1;          //�ж�����
	 
	 //cpu logic
	 cpu cpu_signal(clk,reset,
						PrRD,HWInt,
						PrAddr,PrWD,PrWE);
						
	 //Bridge logic
	 Bridge bridge_logic(PrAddr,PrWD,PrWE,
								RDTimer0,RDTimer1,IRQTimer0,IRQTimer1,
								Dev_DataIn,PrRD,HWInt,Dev_Addr,HitTimer0,HitTimer1,WETimer0,WETimer1);
								
	 //timer0 logic
	 timer0 timer0_signal(clk,reset,Dev_Addr,WETimer0,Dev_DataIn,RDTimer0,IRQTimer0);
	 
	 //timer1 logic
	 timer1 timer1_signal(clk,reset,Dev_Addr,WETimer1,Dev_DataIn,RDTimer1,IRQTimer1);
	 

endmodule
