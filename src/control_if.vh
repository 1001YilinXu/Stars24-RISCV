`ifndef CONTROL_IF_VH
`define CONTROL_IF_VH

`include "cpu_pkg.vh"

interface control_if;
	//import cpu_pkg::*;

	logic [3:0] ALUop;
	logic [19:0] imm;
	logic [4:0] reg1, reg2, regd;
	logic regWrite, memWrite, memRead, aluSrc, branch, sign; 
	typedef enum logic [5:0] {
		LUI, AUIPC, JAL, JALR, 
		BEQ, BNE, BLT, BGE, BLTU, BGEU, 
		LB, LH, LW, LBU, LHU, SB, SH, SW, 
		ADDI, SLTI, SLIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI, 
		ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SEA, OR, AND
	} cuOP;	
	word_t instr;

	modport cu(
		input instr,
		output cuOPType, ALUop, regWrite, memWrite, memRead, aluSrc, branch, sign, imm, reg1, reg2, regd
	);
	modport tb(
		output instr,
		input cuOPType, ALUop, regWrite, memWrite, memRead, aluSrc, branch, sign, imm, reg1, reg2, regd
	);

endinterface
`endif