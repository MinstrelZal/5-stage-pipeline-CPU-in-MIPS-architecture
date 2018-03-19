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
	 input  clk,                   //ʱ��
    input  reset,                 //��λ
	 input  [31:0] InstrD,         //D����ǰָ��
	 input  [31:0] PCplus4D,       //PC+4 in ID
	 input  [31:0] PCplus8D,       //PC+8 in ID
	 input  [31:0] InstrW,         //W����ǰָ��
	 input  [31:0] PCplus4W,       //PC+4 in WB
	 input  [31:0] PCplus8W,       //PC+8 in WB
	 input  [31:0] ReadDataW,      //Mux_RegData����1
	 input  [31:0] ALUOutW,        //Mux_RegData����0
	 input  movWriteW,
	 input  bWriteW,
	 input  [31:0] PCplus8E,       //MFRSD,MFRTD����11
	 input  [31:0] MF_selM,        //MFRSD,MFRTD����01
	 input  [1:0] ForwardRSD,      //MFRSDѡ���ź�
	 input  [1:0] ForwardRTD,      //MFRTDѡ���ź�
    output  [31:0] RSD,           //Rs�Ĵ����е�����
    output  [31:0] RTD,           //Rt�Ĵ����е�����
	 output  [31:0] ExtD,          //32λ������
	 output  FlushPC,              //nPC�����ź�
	 output  bWriteD,
	 output  MDStartD,
	 output  [31:0] nPC,           //���º��nPC
	 output  [31:0] raRegDataW     //д��GRF��ֵ
    );
	 //ID wire
	 wire RegDstD,          //Mux_RegAddr,Mux_Shamtѡ���ź�
	      ALUSrcD,          //Mux_ALUSrcѡ���ź�
	      MemtoRegD,        //Mux_RegDataѡ���ź�
	      RegWriteD,        //GRFдʹ���ź�
	      MemReadD,         //DM��ʹ���ź�
	      MemWriteD,        //DMдʹ���ź�
			zeroExtendD,      //��չ��ʽѡ���ź�
	      BeqD,             //beq��֧�ź�
			BneD,             //bne��֧�ź�
	      JD,               //j��ת�ź�
			JalD,             //jal��ת�ź�
			JrD,              //jr��ת�ź�
			JalrD,
			BgezalD,
			BlezD,
			BgtzD,
			BltzD,
			BgezD;
	 wire [3:0] ALUOpD;     //ALUѡ���ź�
	 wire [3:0] MDOpD;
	 wire EqualD,LtzD;
	 wire [31:0] OffsetD;
	 wire [31:0] ReadData1D;
	 wire [31:0] ReadData2D;
	 wire JumpD,BranchD,JumpRegD;
	 wire [31:0] cmp2D;
	 
	 wire RegDstW,          //Mux_RegAddr,Mux_Shamtѡ���ź�
	      ALUSrcW,          //Mux_ALUSrcѡ���ź�
	      MemtoRegW,        //Mux_RegDataѡ���ź�
	      RegWriteW,        //GRFдʹ���ź�
	      MemReadW,         //DM��ʹ���ź�
	      MemWriteW,        //DMдʹ���ź�
			zeroExtendW,      //��չ��ʽѡ���ź�
	      BeqW,             //beq��֧�ź�
			BneW,             //bne��֧�ź�
	      JW,               //j��ת�ź�
			JalW,             //jal��ת�ź�
			JrW,              //jr��ת�ź�
			JalrW,
			BgezalW,
			BlezW,
			BgtzW,
			BltzW,
			BgezW,
			MDStartW;
	 wire [3:0] ALUOpW;     //ALUѡ���ź�
	 wire [3:0] MDOpW;
	 wire JumpLinkW,RegRAW;
	 wire [4:0] RegAddrW;
	 wire [4:0] raRegAddrW;
	 wire [31:0] RegDataW;
	 wire [31:0] LdReadDataW;
	 
	 wire RegWrite;
	 parameter R = 6'b000_000,
				  movz = 6'b001_010;
	 
	 //ID�����������ź�
	 Controller ID_ctrl_signal(InstrD,RegDstD,ALUSrcD,MemtoRegD,RegWriteD,MemReadD,MemWriteD,
										zeroExtendD,BeqD,BneD,JD,JalD,JrD,JalrD,BgezalD,BlezD,BgtzD,BltzD,BgezD,MDStartD,ALUOpD,MDOpD);
	 
    assign RegWrite = ((InstrW[`op] == R) && (InstrW[`func] == movz)) ? movWriteW : 
							 BgezalW ? bWriteW : RegWriteW;	 
	 //GRF logic
	 GRF grf_signal(clk,reset,RegWrite,InstrD[`rs],InstrD[`rt],raRegAddrW,raRegDataW,ReadData1D,ReadData2D);
										
	 //��������չ
	 EXT ext_signal(InstrD[`imm16],zeroExtendD,ExtD);
	 
	 //�����֧��ַ
	 Shift2 shift2_signal(ExtD,OffsetD);
	 
	 //MFRSD logic
	 MFRSD mfrsd_signal(ForwardRSD,ReadData1D,PCplus8E,MF_selM,raRegDataW,RSD);
	 
	 //MFRTD logic
	 MFRTD mfrtd_signal(ForwardRTD,ReadData2D,PCplus8E,MF_selM,raRegDataW,RTD);
	 
	 //b��ָ��CMPģ��:beq/bne/bgezal/blez/bgtz/bltz/bgez
	 assign cmp2D = (BgezalD || BlezD || BgtzD || BltzD || BgezD) ? 32'h0000_0000 : RTD;
	 CMP cmp_signal(RSD,cmp2D,EqualD,LtzD);
	 
	 assign JumpD = JD || JalD,
			  BranchD = (BeqD && EqualD) || (BneD && (!EqualD)) || (BgezalD && (!LtzD)) || (BlezD && (EqualD || LtzD)) ||
							(BgtzD && (!EqualD) && (!LtzD)) || (BltzD && (!EqualD) && LtzD) || (BgezD && (EqualD || (!LtzD))),
			  JumpRegD = JrD || JalrD;
	 assign FlushPC = JumpD || BranchD || JumpRegD;
	 assign bWriteD = (BgezalD && (!LtzD));
	 
	 //����PC
	 NPC npc_signal(PCplus4D,JumpD,InstrD[`imm26],BranchD,OffsetD,JumpRegD,RSD,nPC);
	 
	 //WB���������ź�
	 Controller WB_ctrl_signal(InstrW,RegDstW,ALUSrcW,MemtoRegW,RegWriteW,MemReadW,MemWriteW,
										zeroExtendW,BeqW,BneW,JW,JalW,JrW,JalrW,BgezalW,BlezW,BgtzW,BltzW,BgezW,MDStartW,ALUOpW,MDOpW);
	 
    assign JumpLinkW = JalW || (BgezalW && bWriteW) || JalrW;	 
	 assign RegRAW = JumpLinkW;
	 
	 //ѡ��RegAddrW
	 Mux_RegAddr mux_regaddr_signal(RegDstW,InstrW[`rt],InstrW[`rd],RegAddrW);
	 Mux_RegRA mux_regra_signal((RegRAW && (!JalrW)),RegAddrW,raRegAddrW);
	 
	 //ѡ��RegDataW
	 LDctrl ldctrl_signal(InstrW,ALUOutW[1:0],ReadDataW,LdReadDataW);
	 
	 Mux_RegData mux_regdata_signal(MemtoRegW,ALUOutW,LdReadDataW,RegDataW);
	 Mux_raRegData mux_raregdata_signal(RegRAW,RegDataW,PCplus8W,raRegDataW);

endmodule
