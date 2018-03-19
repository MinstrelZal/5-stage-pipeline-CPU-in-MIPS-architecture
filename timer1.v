`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:25:04 12/20/2016 
// Design Name: 
// Module Name:    timer1 
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
`define Reserved 31:4
`define IM 3
`define Mode 2:1
`define Enable 0
module timer1(
	 input  CLK_I,         //ʱ��
	 input  RST_I,         //��λ�ź�
	 input  [3:2] ADD_I,   //��ַ����
	 input  WE_I,          //дʹ��
	 input  [31:0] DAT_I,  //32λ��������
	 output  [31:0] DAT_O, //32λ�������
	 output  IRQ           //�ж�����
    );
	 reg [31:0] CTRL;    //���ƼĴ���
								//[31:4]:Reserved;  / 
								//[3]:IM;(1:�����ж�;0:�����ж�); R/W
								//[2:1]:Mode;(00:ģʽ0;01:ģʽ1;10:δ����;11:δ����) R/W
								//[0]:Enable;(1:�������;0:ֹͣ����) R/W
	 reg [31:0] PRESET;  //��ֵ�Ĵ���  R/W
	 reg [31:0] COUNT;   //����ֵ�Ĵ���  R
	 
	 reg [1:0] State;
	 reg _irq;
	 
	 parameter IDLE = 2'b00,
				  LOAD = 2'b01,
				  CNTING = 2'b10,
				  INT = 2'b11;
	 
	 initial begin
		CTRL <= 0;
		PRESET <= 0;
		COUNT <= 0;
		State <= IDLE;
		_irq <= 1'b0;
	 end
	 
	 assign IRQ = _irq;        //�ж������ź�
	 
	 assign DAT_O = (ADD_I == 2'b00) ? CTRL   :  //������
						 (ADD_I == 2'b01) ? PRESET :
						 (ADD_I == 2'b10) ? COUNT  :
									                0 ;
	 
	 always @(posedge CLK_I) begin     
		if (RST_I) begin               //��λ
			CTRL <= 0;
			PRESET <= 0;
			COUNT <= 0;
			State <= IDLE;
			_irq <= 1'b0;
		end
		else if (WE_I) begin           //д����
			case (ADD_I[3:2])
				2'b00: begin             //����CTRL����д��,��State��ΪIDLE,_irq��Ϊ0
							CTRL <= DAT_I;
							State <= IDLE;
							_irq <= 1'b0;
						 end
				2'b01: PRESET <= DAT_I;
				default;
			endcase
		end
		else begin
			if (CTRL[`Mode] == 2'b00) begin        //ģʽ0
				case (State[1:0])
					IDLE: begin                          //IDLE
								if (CTRL[`Enable]) begin    //��Enable=1,����LOAD״̬ͬʱ��_irq��Ϊ0
									_irq <= 1'b0;
									State <= LOAD;
								end
							end
					LOAD: begin                          //LOAD,��PRESETװ����COUNT,ͬʱ����CNTING״̬
								COUNT <= PRESET;
								State <= CNTING;
							end
					CNTING: begin                        //CNTING
								  if (COUNT == 0) begin     //��COUNT=0,��ֱ�ӽ���INT״̬
								     State <= INT;
								  end
								  else begin                //����,����������COUNT=1,����INT״̬
								     COUNT <= COUNT - 1;
								     if (COUNT == 1) begin
								        State <= INT;
							        end
								  end
							  end
					INT: begin                           //INT,����������IDLE״̬ͬʱ��Enable��0
							  State <= IDLE;               //�������ж�,������ж������ź�
							  CTRL[`Enable] <= 1'b0;
						     if (CTRL[`IM]) begin
							     _irq <= 1'b1;
							  end
						  end
					default;
				endcase
			end
			else if (CTRL[`Mode] == 2'b01) begin       //ģʽ1
				case (State[1:0])
					IDLE: begin                          //IDLE
								if (_irq == 1'b1) begin     //���ж������ź���Ч,������0(ģʽ1��ֻ��һ������)
									_irq <= 1'b0;
								end
								if (CTRL[`Enable]) begin    //��Enable=1,����LOAD״̬
									State <= LOAD;
								end
							end
					LOAD: begin                          //LOAD
								COUNT <= PRESET;            //��PRESETװ����COUNT,ͬʱ����CNTING״̬
								State <= CNTING;
							end
					CNTING: begin                        //CNTING
								  if (COUNT == 0) begin     //��COUNT=0,��ֱ�ӽ���INT״̬
								     State <= INT;
								  end
								  else begin                //����,����������COUNT=1,����INT״̬
								     COUNT <= COUNT - 1;
								     if (COUNT == 1) begin
								        State <= INT;
							        end
								  end
							  end
					INT: begin                           //INT,����������IDLE״̬���Ҳ��ı�Enable��ֵ
							  State <= IDLE;
						     if (CTRL[`IM]) begin         //�������ж�,������ж������ź�
							     _irq <= 1'b1;
							  end
						  end
					default;
				endcase
			end
		end
	 end

endmodule
