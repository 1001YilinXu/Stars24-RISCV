`ifndef CONTROL_IF_VH
`define CONTROL_IF_VH

`include "cpu_pkg.vh"

interface control_if;
	import cpu_pkg::*;

	aluCode_t aluOP;
	logic [19:0] imm;
	logic [4:0] reg1, reg2, regd;
	logic regWrite, memWrite, memRead, aluSrc, branch, sign; 
	cuOPType cuOP;
	word_t instr;

	modport cu(
		input instr,
		output cuOP, aluOP, regWrite, memWrite, memRead, aluSrc, branch, sign, imm, reg1, reg2, regd
	);
	modport tb(
		output instr,
		input cuOP, aluOP, regWrite, memWrite, memRead, aluSrc, branch, sign, imm, reg1, reg2, regd
	);

endinterface
`endif