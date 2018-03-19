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
	 input  clk,              //ʱ��
	 input  reset,            //�����λ�ź�
	 input  stall,            //�����ź�
	 input  [31:0] nPC,       //��һ��ָ��ĵ�ַ
	 input  IntReqM,
	 input  IntBackM,
	 input  [31:0] EPCoutM,
    output  [31:0] PC        //��ǰָ��ĵ�ַ
    );
	 reg [31:0] _PC;
	 
	 assign PC = IntBackM ? EPCoutM : _PC ;
	 
	 initial begin                //��ʼ��PCֵ
		_PC <= 32'h0000_3000;
	 end
	 
	 always @(posedge clk) begin
		if(reset)                  //��λ
			_PC <= 32'h0000_3000;
		else if (!stall) begin     //��!stall=1,���ȡ��һָ��
			if (IntReqM) begin
				_PC <= 32'h0000_4180;
			end
			else begin
				_PC <= nPC;
			end
		end
	 end

endmodule
