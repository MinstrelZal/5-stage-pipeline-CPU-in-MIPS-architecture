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
	 input  clk,                 //时钟
	 input  reset,               //清除置位信号
	 input  stall,               //PC使能信号,低电平有效
	 input  FlushPC,             //是否对PC进行更新的信号
	 input  [31:0] nPC,          //下一指令的地址
	 input  IntReqM,
	 input  IntBackM,
	 input  [31:0] EPCoutM,
    output  [31:0] PCplus4F,    //PC+4
	 output  [31:0] PCplus8F,    //PC+8
    output  [31:0] InstrF       //InstrF表示当前读出的指令
    );
	 wire [31:0] PCF;             //当前指令的地址
	 wire [31:0] nPCF;
	 
	 //获得当前指令的地址
	 PC pc_signal(clk,reset,stall,nPCF,IntReqM,IntBackM,EPCoutM,PCF);
    
	 //IM取指
	 IM im_signal(PCF,InstrF);
	 
	 //PC+4
	 Add4 add4_signal(PCF,PCplus4F);
	 
	 //PC+8
	 Add8 add8_signal(PCF,PCplus8F);
	 
	 //若遇到Instr_D为j指令,更新nPC
	 Mux_FlushPC_nPC mux_flushpc_pc_signal(FlushPC,PCplus4F,nPC,nPCF);

endmodule
