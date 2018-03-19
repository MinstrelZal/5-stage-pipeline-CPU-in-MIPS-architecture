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
	 input  [31:0] InstrD,           //ID级指令
	 input  [31:0] InstrE,           //EX级指令
	 input  movWriteE,
	 input  bWriteE,
	 input  [31:0] InstrM,           //MEM级指令
	 input  movWriteM,
	 input  bWriteM,
	 input  [31:0] InstrW,           //WB级指令
	 input  movWriteW,
	 input  bWriteW,
	 output  Stall,                  //冻结PC,冻结IF/ID流水级寄存器,将ID/EX流水级寄存器清零的信号
	 output  [1:0] ForwardRSD,       //ID级RS转发信号
	 output  [1:0] ForwardRTD,       //ID级RT转发信号
	 output  [1:0] ForwardRSE,       //EX级RS转发信号
	 output  [1:0] ForwardRTE,       //EX级RT转发信号
	 output  [1:0] ForwardRTM        //MEM级RT转发信号
    );
	 
	 //暂停信号
	 Stall stall_signal(InstrD,InstrE,movWriteE,InstrM,Stall);
	 
	 //转发信号
	 Forward forward_signal(InstrD,InstrE,movWriteE,bWriteE,InstrM,movWriteM,bWriteM,InstrW,movWriteW,bWriteW,
								   ForwardRSD,ForwardRTD,ForwardRSE,ForwardRTE,ForwardRTM);

endmodule
