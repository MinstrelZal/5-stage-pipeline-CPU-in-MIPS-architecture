`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:27:03 12/20/2016 
// Design Name: 
// Module Name:    CP0 
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
module CP0(
	 input  clk,              //ʱ��
	 input  reset,            //��λ
	 input  [4:0] ReadCp0,    //��CP0�Ĵ����ı��,MFC0
	 input  [4:0] WriteCp0,   //дCP0�Ĵ����ı��,MTC0
	 input  [31:0] DataIn,    //CP0�Ĵ���д������
	 input  [31:0] PC,        //�쳣���жϷ����ĵ�ַ
	 input  [6:2] ExcCode,    //�쳣���жϵ�����
	 input  [5:0] HWInt,      //6���豸�ж�����
	 input  WECp0,            //CP0дʹ��
	 input  EXLSet,           //������λSR��EXL
	 input  EXLClr,           //�������SR��EXL
	 output  IntReq,          //�ж�����,�����CPU
	 output  [31:0] EPCout,   //EPC�Ĵ��������
	 output  [31:0] DataOut   //CP0�Ĵ������������,MFC0
    );
	 reg [15:10] im;  //SR��6λ�ж�����λ 1:�����ж� 2�������ж�
	 reg exl,ie;      //exl:�쳣��,1:�����쳣���������ж�; ie:ȫ���ж�ʹ��,1�����ж�
	 wire [31:0] SR;   //SR�Ĵ���,���12
	 
	 reg [15:10] hwint_pend; //Cause�������ⲿ6���ж�
	 reg [6:2] exccode_pend; //Cause��ExcCode��
	 wire [31:0] Cause;       //Cause�Ĵ���,���13
	 
	 reg [31:0] EPC;    //EPC�Ĵ���,���14
	 
	 reg [31:0] PrID;   //PrID�Ĵ���,���15
	 
	 integer i=0;
	 
	 assign DataOut = (ReadCp0 == 5'b01100) ? SR    :
							(ReadCp0 == 5'b01101) ? Cause :
							(ReadCp0 == 5'b01110) ? EPC   :
							(ReadCp0 == 5'b01111) ? PrID  :
							                            0 ;
																		
	 assign IntReq = (|(HWInt & im)) && !exl && ie && (i == 0);  //�ж�����
	 
	 assign EPCout = EPC;
																		
	 assign SR = {16'b0,im,8'b0,exl,ie},
			  Cause = {16'b0,hwint_pend,3'b0,exccode_pend,2'b0};
	   
	 initial begin          //��ʼ��
		im <= 6'b111_111;
		exl <= 1'b0;
		ie <= 1'b1;
		hwint_pend <= 6'b0;
		exccode_pend <= 6'b0;
		EPC <= 32'h0000_3000;
		PrID <= 32'h1506_1075;
	 end
	 
	 always @(posedge clk) begin
		if (((|(HWInt & im)) && !exl && ie)) begin
			i = 1;
		end
		else begin
			i = 0;
		end
	 end
	 
	 always @(posedge clk) begin
		if (reset) begin
			im <= 6'b111_111;
			exl <= 1'b0;
			ie <= 1'b1;
			hwint_pend <= 6'b0;
			exccode_pend <= 6'b0;
			EPC <= 32'h0000_3000;
			PrID <= 32'h1506_1075;
		end
		else begin
			{hwint_pend,exccode_pend} <= {HWInt,ExcCode};
			if (EXLSet)        //��EXL��λ,M�������쳣���ж�
				exl <= 1'b1;
			if (EXLClr) begin  //��Ҫ���EXL,ִ��eretָ��
				exl <= 1'b0;
				//im <= 6'b111_111;
			end
			if (WECp0) begin    //��CP0�Ĵ����н���д����
				case (WriteCp0[4:0])
					5'b01100: {im,exl,ie} <= {DataIn[15:10],DataIn[1],DataIn[0]};
					5'b01110: EPC <= PC;
					5'b01111: PrID <= 32'h1506_1075;
					default;
				endcase
			end
			else if (IntReq) begin  //�������쳣���ж�
				EPC <= PC;
				//if ((HWInt == 6'b000_001) || (HWInt == 6'b000_011)) begin  //timer0�����ȼ�����timer1�����ȼ�
					//im <= 6'b111_100;
				//end
			end
		end
	 end
	 

endmodule
