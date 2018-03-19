`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:13:12 11/21/2016 
// Design Name: 
// Module Name:    MFMux 
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
module MFRSD(                      //ID��ReadData1��ת��Mux
	 input  [1:0] ForwardRSD,       //ѡ���ź�
	 input  [31:0] ReadData1D,      //����00,����GRF�ж�����ֵ
	 input  [31:0] PCplus8E,        //����11,����PCplus8_E
	 input  [31:0] MFRSD_MFRTD_sel, //����01,����Mux_MFRSD_MFRTD_sel������MFRSD_MFRTD_sel
	 input  [31:0] RegDataW,        //����10,����RegData_W
	 output  [31:0] mfReadData1D    //������ȷ��ֵ
	 );
	 reg [31:0] mfreaddata1D;
	 
	 assign mfReadData1D = mfreaddata1D;
	 
	 always @(*) begin
		case (ForwardRSD[1:0])
			2'b00: mfreaddata1D <= ReadData1D;
			2'b11: mfreaddata1D <= PCplus8E;
			2'b01: mfreaddata1D <= MFRSD_MFRTD_sel;
			2'b10: mfreaddata1D <= RegDataW;
			default: mfreaddata1D <= 32'h0000_0000;
		endcase
 	 end
	 
endmodule


module MFRTD(                      //ID��ReadData1��ת��Mux
	 input  [1:0] ForwardRTD,       //ѡ���ź�
	 input  [31:0] ReadData2D,      //����00,����GRF�ж�����ֵ
	 input  [31:0] PCplus8E,        //����11,����PCplus8_E
	 input  [31:0] MFRSD_MFRTD_sel, //����01,����Mux_MFRSD_MFRTD_sel������MFRSD_MFRTD_sel
	 input  [31:0] JalRegDataW,     //����10,����Mux_JalRegData������JalRegData_W
	 output  [31:0] mfReadData2D    //������ȷ��ֵ
	 );
	 reg [31:0] mfreaddata2D;
	 
	 assign mfReadData2D = mfreaddata2D;
	 
	 always @(*) begin
		case (ForwardRTD[1:0])
			2'b00: mfreaddata2D <= ReadData2D;
			2'b11: mfreaddata2D <= PCplus8E;
			2'b01: mfreaddata2D <= MFRSD_MFRTD_sel;
			2'b10: mfreaddata2D <= JalRegDataW;
			default: mfreaddata2D <= 32'h0000_0000;
		endcase
 	 end
	 
endmodule


module MFRSE(                    //EX��ReadData1��ת��Mux
	 input  [1:0] ForwardRSE,     //ѡ���ź�
	 input  [31:0] ReadData1E,    //����00�����Ա�����ˮ�߼Ĵ���
	 input  [31:0] ALUOutM,       //����01������ALUOut_M
	 input  [31:0] JalRegDataW,   //����10������Mux_JalRegData������JalRegData_W
    output  [31:0] MFRD1         //������ȷ��ֵ
    );
	 reg [31:0] mfrd1;
	 
	 assign MFRD1 = mfrd1;
	 
	 always @(*) begin
		case (ForwardRSE[1:0])
			2'b00: mfrd1 <= ReadData1E;
			2'b01: mfrd1 <= ALUOutM;
			2'b10: mfrd1 <= JalRegDataW;
			default: mfrd1 <= 32'h0000_0000;
		endcase
	 end

endmodule


module MFRTE(                    //EX��ReadData2��ת��Mux
	 input  [1:0] ForwardRTE,     //ѡ���ź�
	 input  [31:0] ReadData2E,    //����00�����Ա�����ˮ�߼Ĵ���
	 input  [31:0] ALUOutM,       //����01������ALUOut_M
	 input  [31:0] RegDataW,      //����10������Mux_RegData������RegData_W
    output  [31:0] MFRD2         //������ȷ��ֵ
    );
	 reg [31:0] mfrd2;
	 
	 assign MFRD2 = mfrd2;
	 
	 always @(*) begin
		case (ForwardRTE[1:0])
			2'b00: mfrd2 <= ReadData2E;
			2'b01: mfrd2 <= ALUOutM;
			2'b10: mfrd2 <= RegDataW;
			default: mfrd2 <= 32'h0000_0000;
		endcase
	 end

endmodule


module MFRTM(                     //MEM��ReadData2��ת��Mux
	 input  [1:0] ForwardRTM,      //ѡ���ź�
	 input  [31:0] ReadData2M,     //����00�����Ա�����ˮ�߼Ĵ���
	 input  [31:0] RegDataW,       //����10��������Mux_RegDataѡ����RegData_W
	 output  [31:0] MFRT           //������ȷ��ֵ
	 );
	 reg [31:0] mfrt;
	 
	 assign MFRT = mfrt;
	 
	 always @(*) begin
		case (ForwardRTM[1:0])
			2'b00: mfrt <= ReadData2M;
			2'b10: mfrt <= RegDataW;
			default: mfrt <= 32'h0000_0000;
		endcase
	 end
endmodule
