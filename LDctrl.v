`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:58 12/12/2016 
// Design Name: 
// Module Name:    LDctrl 
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
module LDctrl(
	 input  [31:0] InstrW,   //WB级指令
	 input  [1:0] AddrLow,   //DM低二位地址
	 input  [31:0] DataIn,   //输入整个字
	 output  [31:0] DataOut  //输出需要的字节
    );
	 reg [31:0]dataout;
	 
	 parameter lw  = 6'b100_011,
				  lh  = 6'b100_001,
				  lhu = 6'b100_101,
				  lb  = 6'b100_000,
				  lbu = 6'b100_100;
	
	 assign DataOut = dataout;
	 
	 always @(*) begin
		case (InstrW[`op])
			lw: dataout <= DataIn;
			lh: begin
					if (AddrLow == 2'b00)
						dataout <= {{16{DataIn[15]}},DataIn[15:0]};
					else if (AddrLow == 2'b10)
						dataout <= {{16{DataIn[31]}},DataIn[31:16]};
				 end
			lhu: begin
					 if (AddrLow == 2'b00)
						 dataout <= {{16{1'b0}},DataIn[15:0]};
					 else if (AddrLow == 2'b10)
						 dataout <= {{16{1'b0}},DataIn[31:16]};
				  end
			lb: begin
					if (AddrLow == 2'b00)
						dataout <= {{24{DataIn[7]}},DataIn[7:0]};
					else if (AddrLow == 2'b01)
						dataout <= {{24{DataIn[15]}},DataIn[15:8]};
					else if (AddrLow == 2'b10)
						dataout <= {{24{DataIn[23]}},DataIn[23:16]};
					else if (AddrLow == 2'b11)
						dataout <= {{24{DataIn[31]}},DataIn[31:24]};
				 end
			lbu: begin
					 if (AddrLow == 2'b00)
						 dataout <= {{24{1'b0}},DataIn[7:0]};
					 else if (AddrLow == 2'b01)
					 	 dataout <= {{24{1'b0}},DataIn[15:8]};
					 else if (AddrLow == 2'b10)
					 	 dataout <= {{24{1'b0}},DataIn[23:16]};
					 else if (AddrLow == 2'b11)
					    dataout <= {{24{1'b0}},DataIn[31:24]};
				  end
			default: dataout <= DataIn;
		endcase
	 end

endmodule
