`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:59:53 12/20/2016 
// Design Name: 
// Module Name:    cpu 
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
module cpu(
	 input  clk,
	 input  reset,
	 input  [31:0] PrRD,    //CPU从Bridge模块读入的数据
	 input  [7:2] HWInt,    //6个设备中断请求
	 output  [31:0] PrAddr, //32位地址总线
	 output  [31:0] PrWD,   //CPU输出至Bridge模块的数据
	 output  PrWE           //CPU输出的写使能
    );
	 //IF wire
	 wire [31:0] PCplus4_F;
	 wire [31:0] PCplus8_F;
	 wire [31:0] Instr_F;
	 
	 //D_Registers wire
	 wire [31:0] PCplus4_D;
	 wire [31:0] PCplus8_D;
	 wire [31:0] Instr_D;
	 
	 //ID wire
	 wire [31:0] RS_D;
	 wire [31:0] RT_D;
	 wire [31:0] Ext_D;
	 wire FlushPC;
	 wire bWrite_D;
	 wire MDStart_D;
	 wire [31:0] nPC;
	 
	 //E_Registers wire
	 wire [31:0] PCplus4_E;
	 wire [31:0] PCplus8_E;
	 wire [31:0] Instr_E;
	 wire [31:0] ReadData1_E;
	 wire [31:0] ReadData2_E;
	 wire [31:0] Ext_E;
	 wire bWrite_E;
	 
	 //EX logic
	 wire [31:0] ALUOut_E;
	 wire Zero_E;
	 wire movWrite_E;
	 wire MDStart_E;
	 wire Busy_E;
	 wire [31:0] RT_E;
	 
	 //M_Registers
	 wire [31:0] Instr_M;
	 wire [31:0] PCplus4_M;
	 wire [31:0] PCplus8_M;
	 wire [31:0] ALUOut_M;
	 wire movWrite_M;
	 wire bWrite_M;
	 wire [31:0] ReadData2_M;
	 
	 //MEM logic
	 wire [31:0] ReadData_M;
	 wire [31:0] MF_sel_M;
	 wire IntReq_M;
	 wire IntBack_M;
	 wire [31:0] EPCout_M;
	 
	 //W_Registers
	 wire [31:0] Instr_W;
	 wire [31:0] PCplus4_W;
	 wire [31:0] PCplus8_W;
	 wire [31:0] ALUOut_W;
	 wire movWrite_W;
	 wire bWrite_W;
	 wire [31:0] ReadData_W;
	 
	 //WB wire
	 wire [31:0] raRegData_W;
	 
	 //Hazard wire
	 wire stall;
	 wire [1:0] ForwardRSD;
	 wire [1:0] ForwardRTD;
	 wire [1:0] ForwardRSE;
	 wire [1:0] ForwardRTE;
	 wire [1:0] ForwardRTM;
	 
	 //IF logic
	 IF if_signal(clk,reset,
					  (stall || (MDStart_E && MDStart_D && !IntReq_M) ||(Busy_E && MDStart_D && !IntReq_M)),
					  FlushPC,nPC,
					  IntReq_M,IntBack_M,EPCout_M,
					  PCplus4_F,PCplus8_F,Instr_F);
	 
	 //D_Registers
	 D_Registers d_regs_signal(clk,reset,
										(stall || (MDStart_E && MDStart_D && !IntReq_M) || (Busy_E && MDStart_D && !IntReq_M)),
										IntReq_M,
										PCplus4_F,PCplus8_F,Instr_F,
										PCplus4_D,PCplus8_D,Instr_D);
	 
	 //ID logic or WB logic
	 IDorWB idorwb_signal(clk,reset,
								Instr_D,PCplus4_D,PCplus8_D,
								Instr_W,PCplus4_W,PCplus8_W,ReadData_W,ALUOut_W,movWrite_W,bWrite_W,
								PCplus8_E,
								MF_sel_M,
								ForwardRSD,ForwardRTD,
								RS_D,RT_D,Ext_D,FlushPC,bWrite_D,MDStart_D,nPC,raRegData_W);
								
	 //E_Registers
	 E_Registers e_regs_signal(clk,reset,
										(stall || (MDStart_E && MDStart_D && !IntReq_M) || (Busy_E && MDStart_D && !IntReq_M)),
										(IntReq_M || IntBack_M),
										IntBack_M,
										PCplus4_F,
										Instr_D,PCplus4_D,PCplus8_D,RS_D,RT_D,Ext_D,bWrite_D,
										Instr_E,PCplus4_E,PCplus8_E,ReadData1_E,ReadData2_E,Ext_E,bWrite_E);
										
	 //EX logic
	 EX ex_signal(clk,reset,
					  Instr_E,PCplus4_E,PCplus8_E,ReadData1_E,
					  MF_sel_M,
					  raRegData_W,ReadData2_E,Ext_E,
					  ForwardRSE,ForwardRTE,
					  ALUOut_E,Zero_E,movWrite_E,MDStart_E,Busy_E,RT_E);
					  
	 //M_Registers
	 M_Registers m_regs_signal(clk,reset,
										(IntReq_M || IntBack_M),
										Instr_E,PCplus4_E,PCplus8_E,ALUOut_E,movWrite_E,bWrite_E,RT_E,
										Instr_M,PCplus4_M,PCplus8_M,ALUOut_M,movWrite_M,bWrite_M,ReadData2_M);
	 
	 //MEM logic
	 MEM mem_signal(clk,reset,
						 PCplus4_E,
						 Instr_M,PCplus4_M,PCplus8_M,ALUOut_M,movWrite_M,bWrite_M,ReadData2_M,
						 raRegData_W,
						 ForwardRTM,
						 PrRD,HWInt,
						 ReadData_M,MF_sel_M,
						 IntReq_M,IntBack_M,EPCout_M,
						 PrAddr,PrWD,PrWE);
	 
	 //W_Registers
	 W_Registers w_regs_signal(clk,reset,
										Instr_M,PCplus4_M,PCplus8_M,ALUOut_M,movWrite_M,bWrite_M,ReadData_M,
										Instr_W,PCplus4_W,PCplus8_W,ALUOut_W,movWrite_W,bWrite_W,ReadData_W);
										
	 //Hazard
	 Hazard hazard_signal(Instr_D,
								 Instr_E,movWrite_E,bWrite_E,
								 Instr_M,movWrite_M,bWrite_M,
								 Instr_W,movWrite_W,bWrite_W,
								 stall,ForwardRSD,ForwardRTD,ForwardRSE,ForwardRTE,ForwardRTM);

endmodule
