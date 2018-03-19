`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:06:53 11/21/2016 
// Design Name: 
// Module Name:    DM 
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
module DM(
	 input  clk,                 //ʱ��
    input  reset,               //��λ
    input  MemRead,             //DM�Ķ�ʹ���ź�
    input  MemWrite,            //DM��дʹ���ź�
    input  [31:0] MemAddr,      //�ڴ�ĵ�ַ
    input  [31:0] MemData,      //д����ʱд�������
	 input  [3:0] BE,
    output  [31:0] ReadData     //�������ڴ��е�����
    );
	 reg [31:0] RAM[2047:0];     //����32λ*2048��
	 integer i;
	 
	 assign ReadData = MemRead ? RAM[MemAddr[12:2]] : 0;  //������
	 
	 initial begin
		for (i=0;i<2048;i=i+1)
			RAM[i] <= 0;
	 end
	 
	 always @(posedge clk) begin
		if(reset)                              //��λ
			for(i=0;i<2048;i=i+1)
				RAM[i] <= 0;
		else if(MemWrite) begin                //д����
			case (BE[3:0])
				4'b1111: begin 
								RAM[MemAddr[12:2]] <= MemData;                //sw
								$display("*%h <= %h",MemAddr,MemData);
							end
				4'b0011:	begin
								RAM[MemAddr[12:2]][15:0] <= MemData[15:0];   //sh
								$display("*%h <= %h",MemAddr,MemData[15:0]);
							end
				4'b1100: begin
								RAM[MemAddr[12:2]][31:16]  <= MemData[15:0];
								$display("*%h <= %h",MemAddr,MemData[15:0]);
							end
				4'b0001: begin
								RAM[MemAddr[12:2]][7:0]   <= MemData[7:0];    //sb
								$display("*%h <= %h",MemAddr,MemData[7:0]);
							end
				4'b0010: begin
								RAM[MemAddr[12:2]][15:8]  <= MemData[7:0];
								$display("*%h <= %h",MemAddr,MemData[7:0]);
							end
				4'b0100: begin
								RAM[MemAddr[12:2]][23:16] <= MemData[7:0];
								$display("*%h <= %h",MemAddr,MemData[7:0]);
							end
				4'b1000: begin
								RAM[MemAddr[12:2]][31:24] <= MemData[7:0];
								$display("*%h <= %h",MemAddr,MemData[7:0]);
							end
				default: begin 
								RAM[MemAddr[12:2]] <= MemData;               
								$display("*%h <= %h",MemAddr,MemData);
							end
			endcase
		end
	 end

endmodule
