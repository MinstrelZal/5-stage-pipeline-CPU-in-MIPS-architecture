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
	 input  clk,              //时钟
	 input  reset,            //复位
	 input  [4:0] ReadCp0,    //读CP0寄存器的编号,MFC0
	 input  [4:0] WriteCp0,   //写CP0寄存器的编号,MTC0
	 input  [31:0] DataIn,    //CP0寄存器写入数据
	 input  [31:0] PC,        //异常或中断发生的地址
	 input  [6:2] ExcCode,    //异常或中断的类型
	 input  [5:0] HWInt,      //6个设备中断请求
	 input  WECp0,            //CP0写使能
	 input  EXLSet,           //用于置位SR的EXL
	 input  EXLClr,           //用于清除SR的EXL
	 output  IntReq,          //中断请求,输出至CPU
	 output  [31:0] EPCout,   //EPC寄存器的输出
	 output  [31:0] DataOut   //CP0寄存器的输出数据,MFC0
    );
	 reg [15:10] im;  //SR中6位中断屏蔽位 1:允许中断 2：屏蔽中断
	 reg exl,ie;      //exl:异常级,1:进入异常不再允许中断; ie:全局中断使能,1允许中断
	 wire [31:0] SR;   //SR寄存器,编号12
	 
	 reg [15:10] hwint_pend; //Cause中锁存外部6个中断
	 reg [6:2] exccode_pend; //Cause中ExcCode域
	 wire [31:0] Cause;       //Cause寄存器,编号13
	 
	 reg [31:0] EPC;    //EPC寄存器,编号14
	 
	 reg [31:0] PrID;   //PrID寄存器,编号15
	 
	 integer i=0;
	 
	 assign DataOut = (ReadCp0 == 5'b01100) ? SR    :
							(ReadCp0 == 5'b01101) ? Cause :
							(ReadCp0 == 5'b01110) ? EPC   :
							(ReadCp0 == 5'b01111) ? PrID  :
							                            0 ;
																		
	 assign IntReq = (|(HWInt & im)) && !exl && ie && (i == 0);  //中断请求
	 
	 assign EPCout = EPC;
																		
	 assign SR = {16'b0,im,8'b0,exl,ie},
			  Cause = {16'b0,hwint_pend,3'b0,exccode_pend,2'b0};
	   
	 initial begin          //初始化
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
			if (EXLSet)        //若EXL置位,M级产生异常或中断
				exl <= 1'b1;
			if (EXLClr) begin  //若要清除EXL,执行eret指令
				exl <= 1'b0;
				//im <= 6'b111_111;
			end
			if (WECp0) begin    //对CP0寄存器中进行写操作
				case (WriteCp0[4:0])
					5'b01100: {im,exl,ie} <= {DataIn[15:10],DataIn[1],DataIn[0]};
					5'b01110: EPC <= PC;
					5'b01111: PrID <= 32'h1506_1075;
					default;
				endcase
			end
			else if (IntReq) begin  //若发生异常或中断
				EPC <= PC;
				//if ((HWInt == 6'b000_001) || (HWInt == 6'b000_011)) begin  //timer0的优先级高于timer1的优先级
					//im <= 6'b111_100;
				//end
			end
		end
	 end
	 

endmodule
