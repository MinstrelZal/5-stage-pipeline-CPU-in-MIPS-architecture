`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:03:55 12/06/2016 
// Design Name: 
// Module Name:    MEM 
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
module MEM(
	 input  clk,                 //ʱ��
    input  reset,               //��λ
	 input  [31:0] PCplus4E,
    input  [31:0] InstrM,       //��ǰָ��
	 input  [31:0] PCplus4M,     //PC+4
	 input  [31:0] PCplus8M,     //PC+8
	 input  [31:0] ALUOutM,      //MemAddr
	 input  movWriteM,
	 input  bWriteM,
	 input  [31:0] ReadData2M,   //MemData,���Ա�����ˮ��,MFRTM����00
	 input  [31:0] raRegDataW,   //MFRTM����10
	 input  [1:0] ForwardRTM,    //MFRTMѡ���ź�
	 input  [31:0] PrRD,
	 input  [7:2] HWInt,         //6���豸�ж�����
    output  [31:0] ReadDataM,   //�������ڴ��е�����
	 output  [31:0] MF_selM,     //��ΪMF������01
	 output  IntReqM,
	 output  IntBackM,
	 output  [31:0] EPCoutM,
	 output  [31:0] PrAddr,      //32λ��ַ����
	 output  [31:0] PrWD,        //CPU�����Bridgeģ�������
	 output  PrWE                //CPU�����дʹ��
    );
	 //MEM wire
	 wire RegDstM,          //Mux_RegAddr,Mux_Shamtѡ���ź�
	      ALUSrcM,          //Mux_ALUSrcѡ���ź�
	      MemtoRegM,        //Mux_RegDataѡ���ź�
	      RegWriteM,        //GRFдʹ���ź�
	      MemReadM,         //DM��ʹ���ź�
	      MemWriteM,        //DMдʹ���ź�
			zeroExtendM,      //��չ��ʽѡ���ź�
	      BeqM,             //beq��֧�ź�
			BneM,             //bne��֧�ź�
	      JM,               //j��ת�ź�
			JalM,             //jal��ת�ź�
			JrM,              //jr��ת�ź�
			JalrM,
			BgezalM,
			BlezM,
			BgtzM,
			BltzM,
			BgezM,
			MDStartM;
	 wire [3:0] ALUOpM;     //ALUѡ���ź�
	 wire [3:0] MDOpM;
	 wire [31:0] RTM;
	 wire JumpLinkM;
	 wire [3:0] BE;
	 wire [6:2] ExcCodeM;
	 wire WECp0M;
	 wire EXLSetM;
	 wire EXLClrM;
	 wire [31:0] Cp0outM;
	 wire [31:0] EPCinM;
	 wire [31:0] ReadDataMtemp;
	 
	 parameter COP0 = 6'b010_000,  //op
				  eret = 6'b011_000,  //func
				  mfc0 = 5'b00000,    //rs
				  mtc0 = 5'b00100,    //rs
				  lw   = 6'b100_011,  //op     
			     sw   = 6'b101_011;  //op
				  
	 //cpu logic
	 assign PrAddr = (ALUOutM[31:8] == 24'h0000_7F) ? ALUOutM : 0,
			  PrWD = RTM,
			  PrWE = ((ALUOutM[31:8] == 24'h0000_7F) && MemWriteM);
				  
	 //Cp0 logic
	 assign WECp0M = ((InstrM[`op] == COP0) && (InstrM[`rs] == mtc0));
	 assign EXLSetM = 1'b0;
	 assign EXLClrM = ((InstrM[`op] == COP0) && InstrM[25] && (InstrM[`func] == eret));
	 assign ExcCodeM = 5'b00000;
	 assign IntBackM = EXLClrM;
	 assign EPCinM = IntReqM  ? ((BeqM || BneM || BlezM || BgtzM || BltzM || BgezM || BgezalM || JM || JalM || JrM || JalrM) ? (PCplus4M - 32'h0000_0004) : (PCplus4E - 32'h0000_0004)) : RTM;
	 CP0 cp0_signal(clk,reset,InstrM[`rd],InstrM[`rd],RTM,EPCinM,ExcCodeM,HWInt,WECp0M,EXLSetM,EXLClrM,IntReqM,EPCoutM,Cp0outM);
	 
	 //MEM�����������ź�
	 Controller MEM_ctrl_signal(InstrM,RegDstM,ALUSrcM,MemtoRegM,RegWriteM,MemReadM,MemWriteM,
										zeroExtendM,BeqM,BneM,JM,JalM,JrM,JalrM,BgezalM,BlezM,BgtzM,BltzM,BgezM,MDStartM,ALUOpM,MDOpM);
										
	 //Mux_MF_sel
	 assign JumpLinkM = JalM || (BgezalM && bWriteM) || JalrM;
	 Mux_MF_sel mux_mf_sel_signal(JumpLinkM,ALUOutM,PCplus8M,MF_selM);
										
	 //MFRTM logic
	 MFRTM mfrtm_signal(ForwardRTM,ReadData2M,raRegDataW,RTM);
	 
	 //BEctrl logic
	 BEctrl bectrl_signal(InstrM,ALUOutM[1:0],BE);
	 
	 //DM logic
	 DM dm_signal(clk,reset,(MemReadM && !(ALUOutM[31:8] == 24'h0000_7F)),(MemWriteM && !(ALUOutM[31:8] == 24'h0000_7F)),ALUOutM,RTM,BE,ReadDataMtemp);
	 assign ReadDataM = ((InstrM[`op] == COP0) && (InstrM[`rs] == mfc0)) ? Cp0outM : 
							  (MemReadM && (ALUOutM[31:8] == 24'h0000_7F))     ? PrRD    :
							                                               ReadDataMtemp ;

endmodule
