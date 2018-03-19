`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:20:48 11/21/2016 
// Design Name: 
// Module Name:    IM 
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
module IM(
	 input  [31:0] PC,          //PC_F��ʾ��ǰָ��ĵ�ַ
    output  [31:0] Instr       //Instr��ʾ��ǰ������ָ��
    );
	 reg [31:0] ROM[0:2047];       //����Ϊ32λ*1024��
	 wire [31:0] temp_PC;
	 
	 integer i ;
	 
	 initial begin                 //��ʼ��
		for (i=0;i<2048;i=i+1) begin
			ROM[i] = 0;
		end
		$readmemh("code.txt",ROM,0);
		$readmemh("EH.txt",ROM,1120);
	 end
	 
	 assign temp_PC = PC - 32'h0000_3000;
	 assign Instr = ROM[temp_PC[12:2]];      //������Ӧ��ַ��ָ�PC/4

endmodule
