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
	 input  clk,                  //时钟
    input  reset,                //复位
    input  RegWrite,             //GRF的写使能信号
    input  [4:0] ReadReg1,       //Rs寄存器的地址
    input  [4:0] ReadReg2,       //Rt寄存器的地址
    input  [4:0] RegAddr,        //Rd寄存器的地址
    input  [31:0] RegData,       //写入GRF的数据
    output  [31:0] ReadData1,    //Rs寄存器中的数据
    output  [31:0] ReadData2     //Rt寄存器中的数据
    );
	 reg [31:0] GPR[31:0];        //定义一个寄存器组
	 integer i;
	 
	 //读寄存器，注意0号寄存器
	 assign ReadData1 = (ReadReg1 == 0) ? 0 :                               //判断所读的是否为0号寄存器
							  ((ReadReg1 == RegAddr) & RegWrite) ? RegData :      //判断所读的是否为正要进行写入的寄存器 (寄存器内部转发)
														             GPR[ReadReg1];      
	 assign ReadData2 = (ReadReg2 == 0) ? 0 : 
							  ((ReadReg2 == RegAddr) & RegWrite) ? RegData : 
														             GPR[ReadReg2];
	 
	 initial begin                  //初始化
		for(i=0;i<32;i=i+1)
			GPR[i] <= 0;
	 end
	 
	 always @(posedge clk) begin
		if(reset)                    //复位
			for(i=0;i<32;i=i+1)
				GPR[i] <= 0;
		else if(RegWrite) begin      //写寄存器，注意0号寄存器
			GPR[RegAddr] <= (RegAddr == 0) ? 0 : RegData;
			$display("$%d <= %h",RegAddr,RegData);
		end
	 end

endmodule
