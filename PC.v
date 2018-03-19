`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:15:33 11/21/2016 
// Design Name: 
// Module Name:    PC 
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
module PC(
	 input  clk,              //时钟
	 input  reset,            //清除置位信号
	 input  stall,            //阻塞信号
	 input  [31:0] nPC,       //下一条指令的地址
	 input  IntReqM,
	 input  IntBackM,
	 input  [31:0] EPCoutM,
    output  [31:0] PC        //当前指令的地址
    );
	 reg [31:0] _PC;
	 
	 assign PC = IntBackM ? EPCoutM : _PC ;
	 
	 initial begin                //初始化PC值
		_PC <= 32'h0000_3000;
	 end
	 
	 always @(posedge clk) begin
		if(reset)                  //复位
			_PC <= 32'h0000_3000;
		else if (!stall) begin     //若!stall=1,则可取下一指令
			if (IntReqM) begin
				_PC <= 32'h0000_4180;
			end
			else begin
				_PC <= nPC;
			end
		end
	 end

endmodule
