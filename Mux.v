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
	 input  FlushPC,           //选择信号
	 input  [31:0] PCplus4,    //输入0,PC+4
	 input  [31:0] nPC,        //输入1,跳转或分支地址
	 output  [31:0] F_nPC      //选择结果
	 );
	 assign F_nPC = FlushPC ? nPC : PCplus4;
	 
endmodule


module Mux_RegAddr(
	 input  RegDst,           //选择信号
	 input  [4:0] Rt,         //待选值0
	 input  [4:0] Rd,         //待选值1
	 output  [4:0] RegAddr    //选择结果
    );
	 assign RegAddr = RegDst ? Rd : Rt;

endmodule


module Mux_ALUSrc(
	 input ALUSrc,              //选择信号
	 input [31:0] ReadData2,    //待选值0
	 input [31:0] imm32,        //待选值1
	 output [31:0] ALU_B        //选择结果
    );
	 assign ALU_B = ALUSrc ? imm32 : ReadData2;

endmodule


module Mux_RegData(
	 input  MemtoReg,           //选择信号
	 input  [31:0] ALUOut,      //待选值0
	 input  [31:0] ReadData,    //待选值1
	 output  [31:0] RegData     //选择结果
    );
	 assign RegData = MemtoReg ? ReadData : ALUOut;

endmodule


module Mux_raRegData(
	 input  RegRA,               //选择信号
	 input  [31:0] RegData,      //输入0
	 input  [31:0] PCplus8,      //输入1
	 output  [31:0] raRegData    //输出结果
	 );
	 assign raRegData = RegRA ? PCplus8 : RegData;
	 
endmodule


module Mux_RegRA(
	 input  RegRA,               //选择信号           
	 input  [4:0] RegAddr,       //输入0
	 output  [4:0] raRegAddr    //输出结果
	 );
	 assign raRegAddr = RegRA ? 5'b11111 : RegAddr;
	 
endmodule


module Mux_MF_sel(
	 input  JumpLink,                //选择信号
	 input  [31:0] ALUOutM,          //输入0
	 input  [31:0] PCplus8M,         //输入1
	 output  [31:0] MF_sel           //输出结果
	 );
	 assign MF_sel = JumpLink ? PCplus8M : ALUOutM ;
	 
endmodule
