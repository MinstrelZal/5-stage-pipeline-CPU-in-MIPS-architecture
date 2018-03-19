`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:01:49 11/22/2016 
// Design Name: 
// Module Name:    Stall 
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
module Stall(
	 input  [31:0] InstrD,         //ID级指令
	 input  [31:0] InstrE,         //EX级指令
	 input  movWriteE,
	 input  [31:0] InstrM,         //MEM级指令
	 output  Stall                 //冻结PC,冻结IF/ID流水级寄存器,将ID/EX流水级寄存器清零的信号
    );
	 
	 //指令分类
	 wire cal_r_D,cal_i_D,un_b_D,con_b_D,con_m_D,load_D,store_D,jalr_D,jr_D, //需要从GRF中取值的指令
			cal_r_E,cal_i_E,con_m_E,load_E, //EX,MEM级尚未产生结果的指令 
			load_M;
			
	 //暂停信号分类
	 wire stall_rsrt1,stall_rs1,stall_rsrt0,stall_rs0;
	 
	 //将供给者分类,根据目的寄存器
	 wire write_rd_E,write_rt1_E,write_rt2_E,
			write_rt_M;
			
	 //将IF/ID级的需求者分类,根据源寄存器
	 wire use_rsrt_0,use_rsrt_1,use_rs_0,use_rs_1;
			
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
				  lh	  = 6'b100_001,       //lh = 100_001
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
				  sra   = 6'b000_011,        //sra = b000_001
				  sllv  = 6'b000_100,        //sllv = b000_100
				  srav  = 6'b000_111,        //srav = b000_111
				  Nor   = 6'b100_111,        //Nor = b100_111
				  srlv  = 7'b0_000_110,      //srlv = b0_000_110
				  sltu  = 6'b101_011,        //sltu = b101_011
				  slt   = 6'b101_010,        //slt = 101_010
				  mult  = 6'b011_000,        //mult = 011_000
				  multu = 6'b011_001,        //multu = 011_001
				  div   = 6'b011_010,        //div = 011_010
				  divu  = 6'b011_011,        //divu = 011_011
				  mfhi  = 6'b010_000,        //mfhi = 010_000
				  mflo  = 6'b010_010,        //mflo = 010_010
				  mthi  = 6'b010_001,        //mthi = 010_001
				  mtlo  = 6'b010_011;        //mtlo = 010_011
				  
	 assign cal_r_D = InstrD[`op] == R,
			  cal_i_D = (InstrD[`op] == ori) ||
							(InstrD[`op] == lui) ||
							(InstrD[`op] == addiu) ||
							(InstrD[`op] == addi)  ||
							(InstrD[`op] == andi)  ||
							(InstrD[`op] == xori)  ||
							(InstrD[`op] == sltiu) ||
							(InstrD[`op] == slti),
			  un_b_D  = (InstrD[`op] == beq)  ||
							(InstrD[`op] == bne)  ||
							(InstrD[`op] == blez) ||
							(InstrD[`op] == bgtz) ||
							((InstrD[`op] == Regimmb) && InstrD[`rt] == bltz) ||
							((InstrD[`op] == Regimmb) && InstrD[`rt] == bgez),
			  con_b_D = ((InstrD[`op] == Regimmb) && (InstrD[`rt] == bgezal)),
			  con_m_D = (InstrD[`op] == R) && (InstrD[`func] == movz),
			  load_D  = (InstrD[`op] == lw)  ||
							(InstrD[`op] == lh)  ||
							(InstrD[`op] == lhu) ||
							(InstrD[`op] == lb)  ||
							(InstrD[`op] == lbu),
			  store_D = (InstrD[`op] == sw) ||
							(InstrD[`op] == sh) ||
							(InstrD[`op] == sb),
			  jalr_D  = (InstrD[`op] == R) && (InstrD[`func] == jalr),
			  jr_D    = (InstrD[`op] == R) && (InstrD[`func] == jr);
	 
	 assign cal_r_E = InstrE[`op] == R,
			  cal_i_E = (InstrE[`op] == ori) ||
							(InstrE[`op] == lui) ||
							(InstrE[`op] == addiu) ||
							(InstrE[`op] == addi)  ||
							(InstrE[`op] == andi)  ||
							(InstrE[`op] == xori)  ||
							(InstrE[`op] == sltiu) ||
							(InstrE[`op] == slti),
			  con_m_E = (InstrE[`op] == R) && (InstrE[`func] == movz),
			  load_E = (InstrE[`op] == lw)  ||
						  (InstrE[`op] == lh)  ||
						  (InstrE[`op] == lhu) ||
						  (InstrE[`op] == lb)  ||
						  (InstrE[`op] == lbu);
			  
	 assign load_M = (InstrM[`op] == lw)  ||
						  (InstrM[`op] == lh)  ||
						  (InstrM[`op] == lhu) ||
						  (InstrM[`op] == lb)  ||
						  (InstrM[`op] == lbu);
	 
	 assign write_rd_E  = (cal_r_E && (!con_m_E)) || (con_m_E && movWriteE),
			  write_rt1_E = cal_i_E,
			  write_rt2_E = load_E || ((InstrE[`op] == COP0) && (InstrE[`rs] == mfc0)),
			  
			  write_rt_M  = load_M || ((InstrM[`op] == COP0) && (InstrM[`rs] == mfc0));
			  
	 assign use_rsrt_0 = un_b_D,
			  use_rsrt_1 = cal_r_D || con_m_D,
			  use_rs_0   = jr_D || con_b_D || jalr_D,
			  use_rs_1   = cal_i_D || load_D || store_D;
	 
	 //给各个暂停信号赋值,注意0号寄存器
	 assign stall_rsrt1 = use_rsrt_1   && 
								 write_rt2_E  && ((InstrD[`rs] == InstrE[`rt]) || (InstrD[`rt] == InstrE[`rt])) && (InstrE[`rt] != 5'b00000),
	 
			  stall_rs1   = use_rs_1     && 
								 write_rt2_E  && (InstrD[`rs] == InstrE[`rt]) && (InstrE[`rt] != 5'b00000),
			  
			  stall_rsrt0 = use_rsrt_0  && 
								(write_rd_E  && ((InstrD[`rs] == InstrE[`rd]) || (InstrD[`rt] == InstrE[`rd])) && (InstrE[`rd] != 5'b00000) ||
								 write_rt1_E && ((InstrD[`rs] == InstrE[`rt]) || (InstrD[`rt] == InstrE[`rt])) && (InstrE[`rt] != 5'b00000) ||
								 write_rt2_E && ((InstrD[`rs] == InstrE[`rt]) || (InstrD[`rt] == InstrE[`rt])) && (InstrE[`rt] != 5'b00000) ||
								 write_rt_M  && ((InstrD[`rs] == InstrM[`rt]) || (InstrD[`rt] == InstrM[`rt])) && (InstrM[`rt] != 5'b00000)) ,
								 
			  stall_rs0   = use_rs_0    && 
								(write_rd_E  && (InstrD[`rs] == InstrE[`rd]) && (InstrE[`rd] != 5'b00000) ||
								 write_rt1_E && (InstrD[`rs] == InstrE[`rt]) && (InstrE[`rt] != 5'b00000) ||
								 write_rt2_E && (InstrD[`rs] == InstrE[`rt]) && (InstrE[`rt] != 5'b00000) ||
								 write_rt_M  && (InstrD[`rs] == InstrM[`rt]) && (InstrM[`rt] != 5'b00000)) ;
	 
    //给输出的暂停信号赋值	 
	 assign Stall = stall_rsrt1 || stall_rs1 || stall_rsrt0 || stall_rs0;

endmodule
