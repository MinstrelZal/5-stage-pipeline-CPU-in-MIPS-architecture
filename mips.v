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
	 wire [31:0] PrAddr; //32位地址总线
	 wire [31:0] PrWD;   //CPU输出至Bridge模块的数据
	 wire PrWE;           //CPU输出的写使能
	 
	 //Bridge wire
	 wire [31:0] Dev_DataIn;
	 wire [31:0] PrRD;        //CPU从Bridge模块读入的数据
	 wire [7:2] HWInt;        //6位硬件中断请求
	 wire [3:2] Dev_Addr;     //外设硬件地址
	 wire HitTimer0;          //定时器0命中
	 wire HitTimer1;          //定时器1命中
	 wire WETimer0;           //定时器0写使能
	 wire WETimer1;           //定时器1写使能
	 
	 //timer0 wire
	 wire [31:0] RDTimer0;    //32位数据输出
	 wire IRQTimer0;          //中断请求
	 
	 //timer1 wire
	 wire [31:0] RDTimer1;    //32位数据输出
	 wire IRQTimer1;          //中断请求
	 
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
