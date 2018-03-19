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
	 input  [31:0] PrAddr,       //32位地址总线
	 input  [31:0] PrWD,         //CPU输出至Bridge模块的数据
	 input  PrWE,                //CPU输出的写使能
	 input  [31:0] RDTimer0,     //定时器0输出数据
	 input  [31:0] RDTimer1,     //定时器1输出数据
	 input  IRQTimer0,           //定时器0中断请求
	 input  IRQTimer1,           //定时器1中断请求
	 output  [31:0] Dev_DataIn,
	 output  [31:0] PrRD,        //CPU从Bridge模块读入的数据
	 output  [7:2] HWInt,        //6位硬件中断请求
	 output  [3:2] Dev_Addr,     //外设硬件地址
	 output  HitTimer0,          //定时器0命中
	 output  HitTimer1,          //定时器1命中
	 output  WETimer0,           //定时器0写使能
	 output  WETimer1            //定时器1写使能
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
