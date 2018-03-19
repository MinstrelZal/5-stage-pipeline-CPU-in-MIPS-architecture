`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:31:51 12/05/2016 
// Design Name: 
// Module Name:    IDorWB 
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
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0
`define imm16 15:0
`define imm26 25:0
module IDorWB(
	 input  clk,                   //时钟
    input  reset,                 //复位
	 input  [31:0] InstrD,         //D级当前指令
	 input  [31:0] PCplus4D,       //PC+4 in ID
	 input  [31:0] PCplus8D,       //PC+8 in ID
	 input  [31:0] InstrW,         //W级当前指令
	 input  [31:0] PCplus4W,       //PC+4 in WB
	 input  [31:0] PCplus8W,       //PC+8 in WB
	 input  [31:0] ReadDataW,      //Mux_RegData输入1
	 input  [31:0] ALUOutW,        //Mux_RegData输入0
	 input  movWriteW,
	 input  bWriteW,
	 input  [31:0] PCplus8E,       //MFRSD,MFRTD输入11
	 input  [31:0] MF_selM,        //MFRSD,MFRTD输入01
	 input  [1:0] ForwardRSD,      //MFRSD选择信号
	 input  [1:0] ForwardRTD,      //MFRTD选择信号
    output  [31:0] RSD,           //Rs寄存器中的数据
    output  [31:0] RTD,           //Rt寄存器中的数据
	 output  [31:0] ExtD,          //32位立即数
	 output  FlushPC,              //nPC更新信号
	 output  bWriteD,
	 output  MDStartD,
	 output  [31:0] nPC,           //更新后的nPC
	 output  [31:0] raRegDataW     //写回GRF的值
    );
	 //ID wire
	 wire RegDstD,          //Mux_RegAddr,Mux_Shamt选择信号
	      ALUSrcD,          //Mux_ALUSrc选择信号
	      MemtoRegD,        //Mux_RegData选择信号
	      RegWriteD,        //GRF写使能信号
	      MemReadD,         //DM读使能信号
	      MemWriteD,        //DM写使能信号
			zeroExtendD,      //扩展方式选择信号
	      BeqD,             //beq分支信号
			BneD,             //bne分支信号
	      JD,               //j跳转信号
			JalD,             //jal跳转信号
			JrD,              //jr跳转信号
			JalrD,
			BgezalD,
			BlezD,
			BgtzD,
			BltzD,
			BgezD;
	 wire [3:0] ALUOpD;     //ALU选择信号
	 wire [3:0] MDOpD;
	 wire EqualD,LtzD;
	 wire [31:0] OffsetD;
	 wire [31:0] ReadData1D;
	 wire [31:0] ReadData2D;
	 wire JumpD,BranchD,JumpRegD;
	 wire [31:0] cmp2D;
	 
	 wire RegDstW,          //Mux_RegAddr,Mux_Shamt选择信号
	      ALUSrcW,          //Mux_ALUSrc选择信号
	      MemtoRegW,        //Mux_RegData选择信号
	      RegWriteW,        //GRF写使能信号
	      MemReadW,         //DM读使能信号
	      MemWriteW,        //DM写使能信号
			zeroExtendW,      //扩展方式选择信号
	      BeqW,             //beq分支信号
			BneW,             //bne分支信号
	      JW,               //j跳转信号
			JalW,             //jal跳转信号
			JrW,              //jr跳转信号
			JalrW,
			BgezalW,
			BlezW,
			BgtzW,
			BltzW,
			BgezW,
			MDStartW;
	 wire [3:0] ALUOpW;     //ALU选择信号
	 wire [3:0] MDOpW;
	 wire JumpLinkW,RegRAW;
	 wire [4:0] RegAddrW;
	 wire [4:0] raRegAddrW;
	 wire [31:0] RegDataW;
	 wire [31:0] LdReadDataW;
	 
	 wire RegWrite;
	 parameter R = 6'b000_000,
				  movz = 6'b001_010;
	 
	 //ID级产生控制信号
	 Controller ID_ctrl_signal(InstrD,RegDstD,ALUSrcD,MemtoRegD,RegWriteD,MemReadD,MemWriteD,
										zeroExtendD,BeqD,BneD,JD,JalD,JrD,JalrD,BgezalD,BlezD,BgtzD,BltzD,BgezD,MDStartD,ALUOpD,MDOpD);
	 
    assign RegWrite = ((InstrW[`op] == R) && (InstrW[`func] == movz)) ? movWriteW : 
							 BgezalW ? bWriteW : RegWriteW;	 
	 //GRF logic
	 GRF grf_signal(clk,reset,RegWrite,InstrD[`rs],InstrD[`rt],raRegAddrW,raRegDataW,ReadData1D,ReadData2D);
										
	 //立即数扩展
	 EXT ext_signal(InstrD[`imm16],zeroExtendD,ExtD);
	 
	 //计算分支地址
	 Shift2 shift2_signal(ExtD,OffsetD);
	 
	 //MFRSD logic
	 MFRSD mfrsd_signal(ForwardRSD,ReadData1D,PCplus8E,MF_selM,raRegDataW,RSD);
	 
	 //MFRTD logic
	 MFRTD mfrtd_signal(ForwardRTD,ReadData2D,PCplus8E,MF_selM,raRegDataW,RTD);
	 
	 //b类指令CMP模块:beq/bne/bgezal/blez/bgtz/bltz/bgez
	 assign cmp2D = (BgezalD || BlezD || BgtzD || BltzD || BgezD) ? 32'h0000_0000 : RTD;
	 CMP cmp_signal(RSD,cmp2D,EqualD,LtzD);
	 
	 assign JumpD = JD || JalD,
			  BranchD = (BeqD && EqualD) || (BneD && (!EqualD)) || (BgezalD && (!LtzD)) || (BlezD && (EqualD || LtzD)) ||
							(BgtzD && (!EqualD) && (!LtzD)) || (BltzD && (!EqualD) && LtzD) || (BgezD && (EqualD || (!LtzD))),
			  JumpRegD = JrD || JalrD;
	 assign FlushPC = JumpD || BranchD || JumpRegD;
	 assign bWriteD = (BgezalD && (!LtzD));
	 
	 //更新PC
	 NPC npc_signal(PCplus4D,JumpD,InstrD[`imm26],BranchD,OffsetD,JumpRegD,RSD,nPC);
	 
	 //WB产生控制信号
	 Controller WB_ctrl_signal(InstrW,RegDstW,ALUSrcW,MemtoRegW,RegWriteW,MemReadW,MemWriteW,
										zeroExtendW,BeqW,BneW,JW,JalW,JrW,JalrW,BgezalW,BlezW,BgtzW,BltzW,BgezW,MDStartW,ALUOpW,MDOpW);
	 
    assign JumpLinkW = JalW || (BgezalW && bWriteW) || JalrW;	 
	 assign RegRAW = JumpLinkW;
	 
	 //选择RegAddrW
	 Mux_RegAddr mux_regaddr_signal(RegDstW,InstrW[`rt],InstrW[`rd],RegAddrW);
	 Mux_RegRA mux_regra_signal((RegRAW && (!JalrW)),RegAddrW,raRegAddrW);
	 
	 //选择RegDataW
	 LDctrl ldctrl_signal(InstrW,ALUOutW[1:0],ReadDataW,LdReadDataW);
	 
	 Mux_RegData mux_regdata_signal(MemtoRegW,ALUOutW,LdReadDataW,RegDataW);
	 Mux_raRegData mux_raregdata_signal(RegRAW,RegDataW,PCplus8W,raRegDataW);

endmodule
