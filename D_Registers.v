`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:44 11/21/2016 
// Design Name: 
// Module Name:    D_Registers 
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
module D_Registers(             //9: 6 input 3 output
	 input  clk,                 //时钟
	 input  reset,               //复位
	 input  stall,               //阻塞信号
	 input  Int,
    input  [31:0] PCplus4F,     //PC+4 in IF
	 input  [31:0] PCplus8F,     //PC+8 in IF
	 input  [31:0] InstrF,       //Instr in IF
    output  [31:0] PCplus4D,    //PC+4 in ID
	 output  [31:0] PCplus8D,    //PC+8 in ID
	 output  [31:0] InstrD       //Instr in ID
    );
	 reg [31:0] Instr;
	 reg [31:0] PCplus4;
	 reg [31:0] PCplus8;
	 
	 assign InstrD = Instr,
		     PCplus4D = PCplus4,
			  PCplus8D = PCplus8;
			  
	 initial begin                   //初始化??需要吗
		Instr <= 32'h0000_0000;
		PCplus4 <= 32'h0000_3004;
		PCplus8 <= 32'h0000_3008;
	 end
			  
	 always @(posedge clk) begin
		if(reset | Int) begin
			Instr <= 32'h0000_0000;
			if (reset) begin
				PCplus4 <= 32'h0000_3004;     //??不知道对不对
				PCplus8 <= 32'h0000_3008;
			end
		end
		else begin
			if(!stall) begin            //若!stall=1,则可存入
				Instr <= InstrF;
				PCplus4 <= PCplus4F;
				PCplus8 <= PCplus8F;
			end
		end
	 end

endmodule
