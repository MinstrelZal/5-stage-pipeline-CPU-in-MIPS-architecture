`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:56:56 11/21/2016 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
	 input  [31:0] A,            //操作数1
    input  [31:0] B,            //操作数2
    input  [3:0] ALUOp,         //ALU运算种类选择信号
    input  [4:0] shamt,         //移位大小
	 output  [31:0] ALUOut,      //运算结果
	 output  Zero                //if ALUOut=0,Zero=1
    );
	 reg [31:0] result;
	 reg zero;
	 
	 parameter AND = 4'b0000,
				  OR = 4'b0001,
				  ADD = 4'b0010,
				  SUB = 4'b0011,
				  SLL = 4'b0100,
				  SRL = 4'b0101,
				  XOR = 4'b0110,
				  LUI = 4'b0111,
				  MOVE = 4'b1000,
				  SRA = 4'b1001,
				  SLLV = 4'b1010,
				  SRAV = 4'b1011,
				  NOR = 4'b1100,  //或非
				  SRLV = 4'b1101;
	 
	 assign ALUOut = result,
			  Zero = zero;
	 
	 always @(*) begin
		case (ALUOp[3:0])
			AND: result <= A & B;
			OR:  result <= A | B;
			ADD: result <= A + B;
			SUB: result <= A - B;
			SLL: result <= (B << shamt);
			SRL: result <= (B >> shamt);
			XOR: result <= A ^ B;      //按位逻辑异或
			LUI: result <= (B << 5'b10000);
			MOVE: result <= A;
			SRA: result <= ($signed(B) >>> shamt);
			SLLV: result <= (B << A[4:0]);
			SRAV: result <= ($signed(B) >>> A[4:0]);
			NOR: result <= ~(A | B);
			SRLV: result <= (B >> A[4:0]);
			default: result <= 32'h0000_0000;
		endcase
	 end
	 
	 always @(*) begin
		if(ALUOut == 0)
			zero <= 1'b1;
		else
			zero <= 1'b0;
	 end

endmodule
