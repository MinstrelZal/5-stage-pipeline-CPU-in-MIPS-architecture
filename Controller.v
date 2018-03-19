`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:48:53 11/21/2016 
// Design Name: 
// Module Name:    Controller 
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
`define func 5:0
module Controller(          
	 input [31:0] Instr,     //当前指令
	 output RegDst,          //Mux_RegAddr,Mux_Shamt选择信号
	 output ALUSrc,          //Mux_ALUSrc选择信号
	 output MemtoReg,        //Mux_RegData选择信号
	 output RegWrite,        //GRF写使能信号
	 output MemRead,         //DM读使能信号
	 output MemWrite,        //DM写使能信号
	 output zeroExtend,      //扩展方式选择信号
	 output Beq,             //beq分支信号
	 output Bne,             //bne分支信号
	 output J,               //j跳转信号
	 output Jal,             //jal跳转信号
	 output Jr,              //jr跳转信号
	 output Jalr,
	 output Bgezal,
	 output Blez,
	 output Bgtz,
	 output Bltz,
	 output Bgez,
	 output MDStart,
	 output [3:0] ALUOp,     //ALU运算选择信号
	 output [3:0] MDOp
    );
	 wire R,add,addu,sub,subu,sll,srl,And,Or,Xor,nop,sra,sllv,srav,Nor,srlv,sltu,slt,                  //共有种不同的指令
			lui,ori,addi,addiu,andi,xori,sltiu,slti,
			beq,bne,blez,bgtz,bltz,bgez,
			bgezal,
			lw,lh,lhu,lb,lbu,
			sw,sh,sb,
			j,
			jal,
			jr,
			jalr,
			mult,multu,div,divu,mfhi,mflo,mthi,mtlo,
			COP0,eret,mfc0,mtc0;
	 
	 //Op
	 assign R     = (Instr[`op] == 6'b000_000),                   //R = 000_000
			  lui   = (Instr[`op] == 6'b001_111),                   //lui = 001_111
			  ori   = (Instr[`op] == 6'b001_101),                   //ori = 001_101
			  addi  = (Instr[`op] == 6'b001_000),                   //addi = 001_000
			  addiu = (Instr[`op] == 6'b001_001),                   //addiu = 001_001
			  beq   = (Instr[`op] == 6'b000_100),                   //beq = 000_100
			  bne   = (Instr[`op] == 6'b000_101),                   //bne = 000_101
			  lw    = (Instr[`op] == 6'b100_011),                   //lw = 100_011
			  sw    = (Instr[`op] == 6'b101_011),                   //sw = 101_011
			  j     = (Instr[`op] == 6'b000_010),                   //j = 000_010
			  jal   = (Instr[`op] == 6'b000_011),                   //jal = 000_011
			  andi  = (Instr[`op] == 6'b001_100),                   //andi = 001_100
			  xori  = (Instr[`op] == 6'b001_110),                   //xori = 001_110
			  sltiu = (Instr[`op] == 6'b001_011),                   //sltiu = 001_011
			  sh    = (Instr[`op] == 6'b101_001),                   //sh = 101_011
			  sb    = (Instr[`op] == 6'b101_000),                   //sb = 101_000
			  lh    = (Instr[`op] == 6'b100_001),                   //lh = 100_001
			  lhu   = (Instr[`op] == 6'b100_101),                   //lhu = 100_101
			  lb    = (Instr[`op] == 6'b100_000),                   //lb = 100_000
			  lbu   = (Instr[`op] == 6'b100_100),                   //lbu = 100_100
			  blez  = (Instr[`op] == 6'b000_110),                   //blez = 000_110
			  bgtz  = (Instr[`op] == 6'b000_111),                   //bgtz = 000_111
			  slti  = (Instr[`op] == 6'b001_010),                   //slti = 001_010
			  COP0  = (Instr[`op] == 6'b010_000);                   //COP0 = 010_000
			  
	 //Func
	 assign add   = R && (Instr[`func] == 6'b100_000),              //add = 100_000
			  addu  = R && (Instr[`func] == 6'b100_001),              //addu = 100_001
			  sub   = R && (Instr[`func] == 6'b100_010),              //sub = 100_010
			  subu  = R && (Instr[`func] == 6'b100_011),              //subu = 100_011
			  sll   = R && (Instr[`func] == 6'b000_000),              //sll = 000_000
			  srl   = R && (Instr[`func] == 6'b000_010),              //srl = 000_010
			  And   = R && (Instr[`func] == 6'b100_100),              //and = 100_100
			  Or    = R && (Instr[`func] == 6'b100_101),              //or = 100_101
			  Xor   = R && (Instr[`func] == 6'b100_110),              //xor = 100_110
			  jr    = R && (Instr[`func] == 6'b001_000),              //jr = 001_000
			  movz  = R && (Instr[`func] == 6'b001_010),              //movz = 001_010 
			  sra   = R && (Instr[`func] == 6'b000_011),              //sra = 000_011
			  sllv  = R && (Instr[`func] == 6'b000_100),              //sllv = 000_100
			  srav  = R && (Instr[`func] == 6'b000_111),              //srav = 000_111
			  Nor   = R && (Instr[`func] == 6'b100_111),              //Nor = 100_111
			  srlv  = R && (Instr[6] == 1'b0) && (Instr[`func] == 6'b000_110),   //srlv = 7'b0_000_110
			  sltu  = R && (Instr[`func] == 6'b101_011),              //sltu = 101_011
			  slt   = R && (Instr[`func] == 6'b101_010),              //slt = 101_010
			  jalr  = R && (Instr[`func] == 6'b001_001),              //jalr = 001_001
			  mult  = R && (Instr[`func] == 6'b011_000),              //mult = 011_000
			  multu = R && (Instr[`func] == 6'b011_001),             //multu = 011_001
			  div   = R && (Instr[`func] == 6'b011_010),              //div = 011_010
			  divu  = R && (Instr[`func] == 6'b011_011),              //divu = 011_011
			  mfhi  = R && (Instr[`func] == 6'b010_000),              //mfhi = 010_000
			  mflo  = R && (Instr[`func] == 6'b010_010),              //mflo = 010_010
			  mthi  = R && (Instr[`func] == 6'b010_001),              //mthi = 010_001
			  mtlo  = R && (Instr[`func] == 6'b010_011);              //mtlo = 010_011
			  
	 assign bgezal = (Instr[`op] == 6'b000_001) && (Instr[`rt] == 5'b10001),
			  bltz   = (Instr[`op] == 6'b000_001) && (Instr[`rt] == 5'b00000),
			  bgez   = (Instr[`op] == 6'b000_001) && (Instr[`rt] == 5'b00001),
			  eret   = COP0 && Instr[25] && (Instr[`func] == 6'b011_000),
			  mfc0   = COP0 && (Instr[`rs] == 5'b00000),
			  mtc0   = COP0 && (Instr[`rs] == 5'b00100);
	 
	 assign RegDst = R,
			  ALUSrc = lw | sw | ori | lui | addi | addiu | andi | xori | sltiu | sh | sb | lh | lhu | lb | lbu | slti,
			  MemtoReg = lw | lh | lhu | lb | lbu | mfc0,
			  RegWrite = R | ori | lui | addi | addiu | lw | jal | andi | xori | sltiu | lh | lhu | lb | lbu | slti | mfc0,
			  MemRead = lw | lh | lhu | lb | lbu,
			  MemWrite = sw | sh | sb,
			  zeroExtend = ori | andi | xori,
			  Beq = beq,
			  Bne = bne,
			  J = j,
			  Jal = jal,
			  Jr = jr,
			  Jalr = jalr,
			  Bgezal = bgezal,
			  Blez = blez,
			  Bgtz = bgtz,
			  Bltz = bltz,
			  Bgez = bgez,
			  MDStart = mult | multu | div | divu | mfhi | mflo | mthi | mtlo;
			  
	 //ALUOp   0000:and 0001:or 0010:add 0011:sub 0100:sll 0101:srl 0110:xor 0111:lui 1000:move 1001:sra
				//1010:sllv 1011:srav 1100:nor 1101:srlv
	 assign ALUOp[3] = movz | sra | sllv | srav | Nor | srlv,
			  
			  ALUOp[2] = sll | srl | Xor | lui | xori | Nor | srlv,
			  
			  ALUOp[1] = add | addu | sub | subu | Xor | addi | addiu | lui | lw | sw |
							 xori | sllv | srav | sh | sb | lh | lhu | lb | lbu,
							 
			  ALUOp[0] = sub | subu | srl | Or | lui | ori | sra | srav | srlv;
	
	 //MDOp 0000:mult 0001:multu 0010:div 0011:divu 0100:mfhi 0101:mflo 0110:mthi 0111:mtlo
	 assign MDOp[3] = 1'b0,
			  
			  MDOp[2] = mfhi | mflo | mthi | mtlo,
			  
			  MDOp[1] = div | divu | mthi | mtlo,
			  
			  MDOp[0] = multu | divu | mflo | mtlo;

endmodule
