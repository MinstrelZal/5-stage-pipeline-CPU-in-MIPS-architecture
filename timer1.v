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
	 input  CLK_I,         //时钟
	 input  RST_I,         //复位信号
	 input  [3:2] ADD_I,   //地址输入
	 input  WE_I,          //写使能
	 input  [31:0] DAT_I,  //32位数据输入
	 output  [31:0] DAT_O, //32位数据输出
	 output  IRQ           //中断请求
    );
	 reg [31:0] CTRL;    //控制寄存器
								//[31:4]:Reserved;  / 
								//[3]:IM;(1:允许中断;0:屏蔽中断); R/W
								//[2:1]:Mode;(00:模式0;01:模式1;10:未定义;11:未定义) R/W
								//[0]:Enable;(1:允许计数;0:停止计数) R/W
	 reg [31:0] PRESET;  //初值寄存器  R/W
	 reg [31:0] COUNT;   //计数值寄存器  R
	 
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
	 
	 assign IRQ = _irq;        //中断请求信号
	 
	 assign DAT_O = (ADD_I == 2'b00) ? CTRL   :  //读操作
						 (ADD_I == 2'b01) ? PRESET :
						 (ADD_I == 2'b10) ? COUNT  :
									                0 ;
	 
	 always @(posedge CLK_I) begin     
		if (RST_I) begin               //复位
			CTRL <= 0;
			PRESET <= 0;
			COUNT <= 0;
			State <= IDLE;
			_irq <= 1'b0;
		end
		else if (WE_I) begin           //写操作
			case (ADD_I[3:2])
				2'b00: begin             //若对CTRL进行写入,则将State置为IDLE,_irq置为0
							CTRL <= DAT_I;
							State <= IDLE;
							_irq <= 1'b0;
						 end
				2'b01: PRESET <= DAT_I;
				default;
			endcase
		end
		else begin
			if (CTRL[`Mode] == 2'b00) begin        //模式0
				case (State[1:0])
					IDLE: begin                          //IDLE
								if (CTRL[`Enable]) begin    //若Enable=1,进入LOAD状态同时将_irq置为0
									_irq <= 1'b0;
									State <= LOAD;
								end
							end
					LOAD: begin                          //LOAD,将PRESET装载入COUNT,同时进入CNTING状态
								COUNT <= PRESET;
								State <= CNTING;
							end
					CNTING: begin                        //CNTING
								  if (COUNT == 0) begin     //若COUNT=0,则直接进入INT状态
								     State <= INT;
								  end
								  else begin                //否则,正常计数至COUNT=1,进入INT状态
								     COUNT <= COUNT - 1;
								     if (COUNT == 1) begin
								        State <= INT;
							        end
								  end
							  end
					INT: begin                           //INT,无条件进入IDLE状态同时将Enable置0
							  State <= IDLE;               //若允许中断,则产生中断请求信号
							  CTRL[`Enable] <= 1'b0;
						     if (CTRL[`IM]) begin
							     _irq <= 1'b1;
							  end
						  end
					default;
				endcase
			end
			else if (CTRL[`Mode] == 2'b01) begin       //模式1
				case (State[1:0])
					IDLE: begin                          //IDLE
								if (_irq == 1'b1) begin     //若中断请求信号有效,则将其置0(模式1下只有一个周期)
									_irq <= 1'b0;
								end
								if (CTRL[`Enable]) begin    //若Enable=1,进入LOAD状态
									State <= LOAD;
								end
							end
					LOAD: begin                          //LOAD
								COUNT <= PRESET;            //将PRESET装载入COUNT,同时进入CNTING状态
								State <= CNTING;
							end
					CNTING: begin                        //CNTING
								  if (COUNT == 0) begin     //若COUNT=0,则直接进入INT状态
								     State <= INT;
								  end
								  else begin                //否则,正常计数至COUNT=1,进入INT状态
								     COUNT <= COUNT - 1;
								     if (COUNT == 1) begin
								        State <= INT;
							        end
								  end
							  end
					INT: begin                           //INT,无条件进入IDLE状态并且不改变Enable的值
							  State <= IDLE;
						     if (CTRL[`IM]) begin         //若允许中断,则产生中断请求信号
							     _irq <= 1'b1;
							  end
						  end
					default;
				endcase
			end
		end
	 end

endmodule
