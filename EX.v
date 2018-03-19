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
	 input  [31:0] InstrE,       //��ǰָ��
	 input  [31:0] PCplus4E,     //PC+4
	 input  [31:0] PCplus8E,     //PC+8
	 input  [31:0] ReadData1E,   //MFRSE����00
	 input  [31:0] MF_selM,      //MFRSE,MFRTE����01
	 input  [31:0] raRegDataW,   //MFRSE,MFRTE����10
	 input  [31:0] ReadData2E,   //MFRTE����00
	 input  [31:0] ExtE,         //Mux_ALUSrc��ѡֵ1
	 input  [1:0] ForwardRSE,    //MFRSEѡ���ź�
	 input  [1:0] ForwardRTE,    //MFRTEѡ���ź�
	 output  [31:0] ALUOutE,     //������
	 output  ZeroE,              //if ALUOut=0,Zero=1
	 output  movWriteE,
	 output  MDStartE,
	 output  BusyE,
	 output  [31:0] RTE          //��ת��Muxѡ����ReadData2
    );
	 //EX wire
	 wire RegDstE,          //Mux_RegAddr,Mux_Shamtѡ���ź�
	      ALUSrcE,          //Mux_ALUSrcѡ���ź�
	      MemtoRegE,        //Mux_RegDataѡ���ź�
	      RegWriteE,        //GRFдʹ���ź�
	      MemReadE,         //DM��ʹ���ź�
	      MemWriteE,        //DMдʹ���ź�
			zeroExtendE,      //��չ��ʽѡ���ź�
	      BeqE,             //beq��֧�ź�
			BneE,             //bne��֧�ź�
	      JE,               //j��ת�ź�
			JalE,             //jal��ת�ź�
			JrE,              //jr��ת�ź�
			JalrE,
			BgezalE,
			BlezE,
			BgtzE,
			BltzE,
			BgezE;
	 wire [3:0] ALUOpE;     //ALUѡ���ź�
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
	 
	 
	 //EX�����������ź�
	 Controller EX_ctrl_signal(InstrE,RegDstE,ALUSrcE,MemtoRegE,RegWriteE,MemReadE,MemWriteE,
										zeroExtendE,BeqE,BneE,JE,JalE,JrE,JalrE,BgezalE,BlezE,BgtzE,BltzE,BgezE,MDStartE,ALUOpE,MDOpE);
										
	 //MFRSE logic
	 MFRSE mfrse_signal(ForwardRSE,ReadData1E,MF_selM,raRegDataW,RSE);
	 
	 //MFRTE logic
	 MFRTE mfrte_signal(ForwardRTE,ReadData2E,MF_selM,raRegDataW,RTE);
	 
	 //ѡ��ALU������B
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
