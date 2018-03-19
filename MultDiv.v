`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:05:34 12/12/2016 
// Design Name: 
// Module Name:    MultDiv 
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
`define op 31:26
`define func 5:0
module MultDiv(
	 input  clk,
	 input  reset,
	 input  [3:0] MDOp,
	 input  [31:0] A,
	 input  [31:0] B,
	 input  Start,
	 output  [31:0] HIout,
	 output  [31:0] LOout,
	 output  [31:0] MDOut,
	 output  Busy
    );
	 reg [31:0] HI_Reg;
	 reg [31:0] LO_Reg;
	 reg _busy;
	 reg [3:0] count;
	 
	 parameter MULT = 4'b0000,
				  MULTU = 4'b0001,
				  DIV = 4'b0010,
				  DIVU = 4'b0011,
				  MFHI = 4'b0100,
				  MFLO = 4'b0101,
				  MTHI = 4'b0110,
				  MTLO = 4'b0111;
				  
	 assign HIout = HI_Reg,
			  LOout = LO_Reg,
			  Busy = _busy;
			  
	 assign MDOut = (MDOp[3:0] == MFHI) ? HI_Reg :
						 (MDOp[3:0] == MFLO) ? LO_Reg :
						                32'h0000_0000 ;
			  
	 initial begin
		HI_Reg <= 32'h0000_0000;
		LO_Reg <= 32'h0000_0000;
		_busy <= 1'b0;
		count <= 4'b0000;
	 end
				  
	 always @(posedge clk) begin
		if (reset) begin
			HI_Reg <= 32'h0000_0000;
			LO_Reg <= 32'h0000_0000;
			_busy <= 1'b0;
			count <= 4'b0000;
		end
		else if (Start) begin
			case (MDOp[3:0])
				MULT: begin
							{ HI_Reg , LO_Reg } <= $signed(A) * $signed(B);
							count <= 4'b0100;
							_busy <= 1'b1;
						end
				MULTU: begin
							{ HI_Reg , LO_Reg } <= A * B;
							count <= 4'b0100;
							_busy <= 1'b1;
						 end
				DIV: if (B != 32'h0000_0000) begin
						 HI_Reg <= $signed(A) % $signed(B);
						 LO_Reg <= $signed(A) / $signed(B);
						 count <= 4'b1001;
						 _busy <= 1'b1;
					  end
				DIVU: if (B != 32'h0000_0000) begin
						  HI_Reg <= A % B;
						  LO_Reg <= A / B;
						  count <= 4'b1001;
						  _busy <= 1'b1;
						end
				MTHI: HI_Reg <= A;
				MTLO: LO_Reg <= A;
				default;
			endcase
		end
		else if (count > 4'b0000) begin
			count <= count - 1'b1;
			_busy <= 1'b1;
		end
		else begin
			_busy <= 1'b0;
		end
	 end

endmodule
