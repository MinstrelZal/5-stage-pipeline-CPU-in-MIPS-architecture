`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:08:23 11/22/2016 
// Design Name: 
// Module Name:    Forward 
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
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0
module Forward(
	 input  [31:0] InstrD,           //ID级指令
	 input  [31:0] InstrE,           //EX级指令
	 input  movWriteE,
	 input  bWriteE,
	 input  [31:0] InstrM,           //MEM级指令
	 input  movWriteM,
	 input  bWriteM,
	 input  [31:0] InstrW,           //WB级指令
	 input  movWriteW,
	 input  bWriteW,
	 output  [1:0] ForwardRSD,       //ID级RS转发信号
	 output  [1:0] ForwardRTD,       //ID级RT转发信号
	 output  [1:0] ForwardRSE,       //EX级RS转发信号
	 output  [1:0] ForwardRTE,       //EX级RT转发信号
	 output  [1:0] ForwardRTM        //MEM级RT转发信号
    );
	 
	 //指令分类
	 wire un_b_D,con_b_D,jalr_D,jr_D,
			cal_r_E,cal_i_E,con_b_E,con_m_E,load_E,store_E,jal_E,jalr_E,
			cal_r_M,cal_i_M,con_b_M,con_m_M,store_M,jal_M,jalr_M,
			cal_r_W,cal_i_W,con_b_W,con_m_W,load_W,jal_W,jalr_W;
			
	 //将供给者分类,根据目的寄存器
	 wire write_ra_E,write_rd_E,
			write_ra_M,write_rd_M,write_rt_M,
			write_ra_W,write_rd_W,write_rt_W;
			
	 //将需求者分类,根据源寄存器
	 wire use_rs_D,use_rt_D,
			use_rs_E,use_rt_E,
			use_rt_M;
	 
	 //Op
	 parameter R     = 6'b000_000,       //R = 000_000
				  lui   = 6'b001_111,       //lui = 001_111
				  ori   = 6'b001_101,       //ori = 001_101
				  addi  = 6'b001_000,       //addi = 001_000
				  addiu = 6'b001_001,       //addiu = 001_001
				  beq   = 6'b000_100,       //beq = 000_100
				  bne   = 6'b000_101,       //bne = 000_101
				  lw    = 6'b100_011,       //lw = 100_011
			     sw    = 6'b101_011,       //sw = 101_011
			     j     = 6'b000_010,       //j = 000_010
			     jal   = 6'b000_011,       //jal = 000_011
				  andi  = 6'b001_100,       //andi = 001_100
				  xori  = 6'b001_110,       //xori = 001_110
				  sltiu = 6'b001_011,       //sltiu = 001_011
				  sh    = 6'b101_001,       //sh = 101_001
				  sb    = 6'b101_000,       //sb = 101_000
				  lh    = 6'b100_001,       //lh = 100_001
				  lhu   = 6'b100_101,       //lhu = 100_101
				  lb    = 6'b100_000,       //lb = 100_000
				  lbu   = 6'b100_100,       //lbu = 100_100
				  blez  = 6'b000_110,       //blez = 000_110
				  bgtz  = 6'b000_111,       //bgtz = 000_111
				  slti  = 6'b001_010,       //slti = 001_010
				  Regimmb = 6'b000_001,
				  special2 = 6'b011_100,
				  COP0  = 6'b010_000;
				  
	 //rs
	 parameter mfc0 = 5'b00000,
				  mtc0 = 5'b00100;
	 
	 //rt		  
	 parameter bgezal = 5'b10001,
				  bltz   = 5'b00000,
				  bgez   = 5'b00001;
	 
	 //Func
	 parameter add   = 6'b100_000,        //add = 100_000
			     addu  = 6'b100_001,        //addu = 100_001
			     sub   = 6'b100_010,        //sub = 100_010
			     subu  = 6'b100_011,        //subu = 100_011
			     sll   = 6'b000_000,        //sll = 000_000
			     srl   = 6'b000_010,        //srl = 000_010
			     And   = 6'b100_100,        //and = 100_100
			     Or    = 6'b100_101,        //or = 100_101
			     Xor   = 6'b100_110,        //xor = 100_110
			     jr    = 6'b001_000,        //jr = 001_000
				  jalr  = 6'b001_001,        //jalr = 001_001
				  movz  = 6'b001_010,        //movz = 001_010
				  sra   = 6'b000_011,        //sra = 000_011
				  sllv  = 6'b000_100,        //sllv = 000_100
				  srav  = 6'b000_111,        //srav = 000_111
				  Nor   = 6'b100_111,        //Nor = 100_111
				  srlv  = 7'b0_000_110,      //srlv = 0_000_110
				  sltu  = 6'b101_011,        //sltu = 101_011
				  slt   = 6'b101_010,        //slt = 101_010
				  mult  = 6'b011_000,        //mult = 011_000
				  multu = 6'b011_001,        //multu = 011_001
				  div   = 6'b011_010,        //div = 011_010
				  divu  = 6'b011_011,        //divu = 011_011
				  mfhi  = 6'b010_000,        //mfhi = 010_000
				  mflo  = 6'b010_010,        //mflo = 010_010
				  mthi  = 6'b010_001,        //mthi = 010_001
				  mtlo  = 6'b010_011;        //mtlo = 010_011

				  
	 assign un_b_D = (InstrD[`op] == beq)  ||
						  (InstrD[`op] == bne)  ||
						  (InstrD[`op] == blez) ||
						  (InstrD[`op] == bgtz) ||
						  ((InstrD[`op] == Regimmb) && InstrD[`rt] == bltz) ||
						  ((InstrD[`op] == Regimmb) && InstrD[`rt] == bgez),
			  con_b_D = ((InstrD[`op] == Regimmb) && (InstrD[`rt] == bgezal)),
			  jalr_D = (InstrD[`op] == R) && (InstrD[`func] == jalr),
			  jr_D = (InstrD[`op] == R) && (InstrD[`func] == jr);
	 
	 assign cal_r_E = InstrE[`op] == R,
			  cal_i_E = (InstrE[`op] == ori) ||
							(InstrE[`op] == lui) ||
							(InstrE[`op] == addiu) ||
							(InstrE[`op] == addi)  ||
							(InstrE[`op] == andi)  ||
							(InstrE[`op] == xori)  ||
							(InstrE[`op] == sltiu) ||
							(InstrE[`op] == slti),
			  con_b_E = ((InstrE[`op] == Regimmb) && (InstrE[`rt] == bgezal)),
			  con_m_E = (InstrE[`op] == R) && (InstrE[`func] == movz),
			  load_E = (InstrE[`op] == lw)  ||
						  (InstrE[`op] == lh)  ||
						  (InstrE[`op] == lhu) ||
						  (InstrE[`op] == lb)  ||
						  (InstrE[`op] == lbu),
			  store_E = (InstrE[`op] == sw) ||
							(InstrE[`op] == sh) ||
							(InstrE[`op] == sb),
			  jal_E = InstrE[`op] == jal,
			  jalr_E = (InstrE[`op] == R) && (InstrE[`func] == jalr);
	 
	 assign cal_r_M = InstrM[`op] == R,
			  cal_i_M = (InstrM[`op] == ori) ||
							(InstrM[`op] == lui) ||
							(InstrM[`op] == addiu) ||
							(InstrM[`op] == addi)  ||
							(InstrM[`op] == andi)  ||
							(InstrM[`op] == xori)  ||
							(InstrM[`op] == sltiu) ||
							(InstrM[`op] == slti),
			  con_b_M = ((InstrM[`op] == Regimmb) && (InstrM[`rt] == bgezal)),
			  con_m_M = (InstrM[`op] == R) && (InstrM[`func] == movz),
			  store_M = (InstrM[`op] == sw) ||
							(InstrM[`op] == sh) ||
							(InstrM[`op] == sb),
			  jal_M = InstrM[`op] == jal,
			  jalr_M = (InstrM[`op] == R) && (InstrM[`func] == jalr);
			  
	 assign cal_r_W = InstrW[`op] == R,
			  cal_i_W = (InstrW[`op] == ori) ||
							(InstrW[`op] == lui) ||
							(InstrW[`op] == addiu) ||
							(InstrW[`op] == addi)  ||
							(InstrW[`op] == andi)  ||
							(InstrW[`op] == xori)  ||
							(InstrW[`op] == sltiu) ||
							(InstrW[`op] == slti),
			  con_b_W = ((InstrW[`op] == Regimmb) && (InstrW[`rt] == bgezal)),
			  con_m_W = (InstrW[`op] == R) && (InstrW[`func] == movz),
			  load_W = (InstrW[`op] == lw)  ||
						  (InstrW[`op] == lh)  ||
						  (InstrW[`op] == lhu) ||
						  (InstrW[`op] == lb)  ||
						  (InstrW[`op] == lbu),
			  jal_W = InstrW[`op] == jal,
			  jalr_W = (InstrW[`op] == R) && (InstrW[`func] == jalr);
	 
    //给供给者赋值	 
	 assign write_ra_E = jal_E || (con_b_E && bWriteE),
			  write_rd_E = jalr_E,
			  
			  write_ra_M = jal_M || (con_b_M && bWriteM),
			  write_rd_M = (cal_r_M && (!con_m_M)) || jalr_M || (con_m_M && movWriteM),
			  write_rt_M = cal_i_M,
			  
			  write_ra_W = jal_W || (con_b_W && bWriteW),
			  write_rd_W = (cal_r_W && (!con_m_W)) || jalr_W || (con_m_W && movWriteW),
			  write_rt_W = cal_i_W || load_W || ((InstrW[`op] == COP0) && (InstrW[`rs] == mfc0));
	 
    //给需求者赋值	 
	 assign use_rs_D = un_b_D || con_b_D || jalr_D || jr_D,
			  use_rt_D = un_b_D,
			  
			  use_rs_E = cal_r_E || cal_i_E || con_m_E || load_E || store_E,
			  use_rt_E = cal_r_E || con_m_E || store_E || ((InstrE[`op] == COP0) && (InstrE[`rs] == mtc0)),
			  
			  use_rt_M = store_M || ((InstrM[`op] == COP0) && (InstrM[`rs] == mtc0));

				  
	 assign ForwardRSD =            InstrD[`rs] == 5'b00000    ? 2'b00 : //判断是不是0号寄存器
			use_rs_D && write_ra_E && InstrD[`rs] == 5'b11111    ? 2'b11 : //11
			use_rs_D && write_rd_E && InstrD[`rs] == InstrE[`rd] ? 2'b11 :   
			use_rs_D && write_ra_M && InstrD[`rs] == 5'b11111    ? 2'b01 : //01
			use_rs_D && write_rd_M && InstrD[`rs] == InstrM[`rd] ? 2'b01 :
			use_rs_D && write_rt_M && InstrD[`rs] == InstrM[`rt] ? 2'b01 :
			use_rs_D && write_ra_W && InstrD[`rs] == 5'b11111    ? 2'b10 : //10
			use_rs_D && write_rd_W && InstrD[`rs] == InstrW[`rd] ? 2'b10 :
			use_rs_D && write_rt_W && InstrD[`rs] == InstrW[`rt] ? 2'b10 :
			                                                       2'b00 ;
	 
	 assign ForwardRTD =            InstrD[`rt] == 5'b00000    ? 2'b00 : //判断是不是0号寄存器
			use_rt_D && write_ra_E && InstrD[`rt] == 5'b11111    ? 2'b11 : //11
			use_rt_D && write_rd_E && InstrD[`rt] == InstrE[`rd] ? 2'b11 :
			use_rt_D && write_ra_M && InstrD[`rt] == 5'b11111    ? 2'b01 : //01
			use_rt_D && write_rd_M && InstrD[`rt] == InstrM[`rd] ? 2'b01 :
			use_rt_D && write_rt_M && InstrD[`rt] == InstrM[`rt] ? 2'b01 :
			use_rt_D && write_ra_W && InstrD[`rt] == 5'b11111    ? 2'b10 : //10
			use_rt_D && write_rd_W && InstrD[`rt] == InstrW[`rd] ? 2'b10 :
			use_rt_D && write_rt_W && InstrD[`rt] == InstrW[`rt] ? 2'b10 :
			                                                       2'b00 ;
																			  
	 
	 assign ForwardRSE =            InstrE[`rs] == 5'b00000    ? 2'b00 : //判断是不是0号寄存器
			use_rs_E && write_ra_M && InstrE[`rs] == 5'b11111    ? 2'b01 : //01
			use_rs_E && write_rd_M && InstrE[`rs] == InstrM[`rd] ? 2'b01 :
			use_rs_E && write_rt_M && InstrE[`rs] == InstrM[`rt] ? 2'b01 :
			use_rs_E && write_ra_W && InstrE[`rs] == 5'b11111    ? 2'b10 : //10
			use_rs_E && write_rd_W && InstrE[`rs] == InstrW[`rd] ? 2'b10 :
			use_rs_E && write_rt_W && InstrE[`rs] == InstrW[`rt] ? 2'b10 :
			                                                       2'b00 ;
			
	 assign ForwardRTE =            InstrE[`rt] == 5'b00000    ? 2'b00 : //判断是不是0号寄存器
			use_rt_E && write_ra_M && InstrE[`rt] == 5'b11111    ? 2'b01 : //01
			use_rt_E && write_rd_M && InstrE[`rt] == InstrM[`rd] ? 2'b01 :
			use_rt_E && write_rt_M && InstrE[`rt] == InstrM[`rt] ? 2'b01 :
			use_rt_E && write_ra_W && InstrE[`rt] == 5'b11111    ? 2'b10 : //10
			use_rt_E && write_rd_W && InstrE[`rt] == InstrW[`rd] ? 2'b10 :
			use_rt_E && write_rt_W && InstrE[`rt] == InstrW[`rt] ? 2'b10 :
			                                                       2'b00 ;
																							 
	 assign ForwardRTM =            InstrM[`rt] == 5'b00000    ? 2'b00 : //判断是不是0号寄存器
			use_rt_M && write_ra_W && InstrM[`rt] == 5'b11111    ? 2'b10 : //10
			use_rt_M && write_rd_W && InstrM[`rt] == InstrW[`rd] ? 2'b10 :
			use_rt_M && write_rt_W && InstrM[`rt] == InstrW[`rt] ? 2'b10 :
																	             2'b00 ;

endmodule
