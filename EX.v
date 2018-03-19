`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:43:46 12/05/2016 
// Design Name: 
// Module Name:    EX 
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
`define op 31:26
`define shamt 10:6
`define func 5:0
module EX(
	 input  clk,
	 input  reset,
	 input  [31:0] InstrE,       //当前指令
	 input  [31:0] PCplus4E,     //PC+4
	 input  [31:0] PCplus8E,     //PC+8
	 input  [31:0] ReadData1E,   //MFRSE输入00
	 input  [31:0] MF_selM,      //MFRSE,MFRTE输入01
	 input  [31:0] raRegDataW,   //MFRSE,MFRTE输入10
	 input  [31:0] ReadData2E,   //MFRTE输入00
	 input  [31:0] ExtE,         //Mux_ALUSrc待选值1
	 input  [1:0] ForwardRSE,    //MFRSE选择信号
	 input  [1:0] ForwardRTE,    //MFRTE选择信号
	 output  [31:0] ALUOutE,     //运算结果
	 output  ZeroE,              //if ALUOut=0,Zero=1
	 output  movWriteE,
	 output  MDStartE,
	 output  BusyE,
	 output  [31:0] RTE          //经转发Mux选择后的ReadData2
    );
	 //EX wire
	 wire RegDstE,          //Mux_RegAddr,Mux_Shamt选择信号
	      ALUSrcE,          //Mux_ALUSrc选择信号
	      MemtoRegE,        //Mux_RegData选择信号
	      RegWriteE,        //GRF写使能信号
	      MemReadE,         //DM读使能信号
	      MemWriteE,        //DM写使能信号
			zeroExtendE,      //扩展方式选择信号
	      BeqE,             //beq分支信号
			BneE,             //bne分支信号
	      JE,               //j跳转信号
			JalE,             //jal跳转信号
			JrE,              //jr跳转信号
			JalrE,
			BgezalE,
			BlezE,
			BgtzE,
			BltzE,
			BgezE;
	 wire [3:0] ALUOpE;     //ALU选择信号
	 wire [3:0] MDOpE;
	 wire [31:0] RSE;
	 wire [31:0] ALU_B_E;
	 wire [31:0] ALUOut_temp;
	 wire [31:0] ALUOut_temp2;
	 wire [31:0] HIout;
	 wire [31:0] LOout;
	 wire [31:0] MDout;
	 
	 parameter R = 6'b000_000,
				  movz = 6'b001_010,
				  movn = 6'b001_011,
				  sltu = 6'b101_011,
				  sltiu = 6'b001_011,
				  slt  = 6'b101_010,
				  slti = 6'b001_010;
	 
	 
	 //EX级产生控制信号
	 Controller EX_ctrl_signal(InstrE,RegDstE,ALUSrcE,MemtoRegE,RegWriteE,MemReadE,MemWriteE,
										zeroExtendE,BeqE,BneE,JE,JalE,JrE,JalrE,BgezalE,BlezE,BgtzE,BltzE,BgezE,MDStartE,ALUOpE,MDOpE);
										
	 //MFRSE logic
	 MFRSE mfrse_signal(ForwardRSE,ReadData1E,MF_selM,raRegDataW,RSE);
	 
	 //MFRTE logic
	 MFRTE mfrte_signal(ForwardRTE,ReadData2E,MF_selM,raRegDataW,RTE);
	 
	 //选择ALU操作数B
	 Mux_ALUSrc mux_alusrc_signal(ALUSrcE,RTE,ExtE,ALU_B_E);
	 
	 //ALU logic
	 ALU alu_signal(RSE,ALU_B_E,ALUOpE,InstrE[`shamt],ALUOut_temp,ZeroE);
	 
	 assign ALUOut_temp2 = (((InstrE[`op] == R) && (InstrE[`func] == sltu)) || (InstrE[`op] == sltiu)) ? (RSE < ALU_B_E) :
								  (((InstrE[`op] == R) && (InstrE[`func] == slt))  || (InstrE[`op] == slti))  ? ($signed(RSE) < $signed(ALU_B_E)) :
																																				ALUOut_temp ;
	 
	 assign movWriteE = ((InstrE[`op] == R) && (InstrE[`func] == movz)) ? (ALU_B_E == 0 ? 1'b1 : 1'b0) : 
							  ((InstrE[`op] == R) && (InstrE[`func] == movn)) ? (ALU_B_E == 0 ? 1'b0 : 1'b1) :
																																 1'b0 ;
	 
	 //MultDiv logic
	 MultDiv md_signal(clk,reset,MDOpE,RSE,ALU_B_E,MDStartE,HIout,LOout,MDout,BusyE);
	 
	 //ALUOutE
	 assign ALUOutE = MDStartE ? MDout : ALUOut_temp2;

endmodule
