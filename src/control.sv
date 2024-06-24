`include "src/cpu_pkg.vh"
`include "src/control_if.vh"

module control
import cpu_pkg::*;
(
	control_if.cu cuif	
);

always_comb begin : control
	cuif.regWrite = 0;
	cuif.memWrite = 0;
	cuif.branch = 0;
	cuif.memRead = 0;
	cuif.aluSrc = 0;
	cuif.sign = 0;
	cuif.imm = 0;
	cuif.reg1 = 0;
	cuif.reg2 = 0;
	cuif.regd = 0;
	r_t = cuif.instr;
	ishift_t = cuif.instr;
	j_t = cuif.instr;
	jrli_t = cuif.instr;
	bst_t = cuif.instr;

	casez(r_t.opType)
		LUI: begin
			cuif.cuOP = LUI;
			cuif.regWrite = 1;
			cuif.memToReg = 1;
			cuif.imm = j_t.imm;
		end
		AUIPC: begin
			cuif.cuOP = AUIPC;
			cuif.regWrite = 1;
			cuif.memToReg = 1;
			cuif.imm = j_t.imm;
		end
		JAL: begin 
			cuif.cuOP = JAL;
			cuif.regWrite = 1;
			cuif.memToReg = 1;
			cuif.imm = j_t.imm;
		end
		JALR:begin
			cuif.cuOP = JALR;
			cuif.regWrite = 1;
			cuif.memToReg = 1;
			cuif.imm = {8'b0, jrli_t.imm};
			cuif.regd = jrli_t.rd;
		end
		BTYPE: begin
			cuif.branch = 1;
			cuif.aluOP = ALU_SUB;
			cuif.reg1 = bst_t.r1;
			cuif.reg2 = bst_t.r2;
			cuif.imm = {8'b0, bst_t.imm_1, bst_t.imm_2};
			casez(bst_t.funct)
				BEQ: cuif.cuOP = BEQ;
				BNE: cuif.cuOP = BNE;
				BLT: cuif.cuOP = BLT;
				BGE: cuif.cuOP = BGE;
				BLTU: cuif.cuOP = BLTU;
				BGEU: cuif.cuOP = BGEU;
			endcase
		end
		LOAD: begin
			cuif.regWrite = 1;
			cuif.aluSrc = 1;
			cuif.memRead = 1;
			cuif.aluOP = ALU_ADD;
			cuif.reg1 = jrli_t.r1;
			cuif.regd = jrli_t.rd;
			cuif.imm = {8'b0, jrli_t.imm};
			casez(jrli_t.funct)
				LB: cuif.cuOP = LB;
				LH: cuif.cuOP = LH;
				LW: cuif.cuOP = LW;
				LBU: cuif.cuOP = LBU;
				LHU: cuif.cuOP = LHU;
			endcase
		end
		STORE: begin
			cuif.memWrite = 1;
			cuif.aluSrc = 1;
			cuif.aluOP = ALU_ADD;
			cuif.reg1 = bst_t.r1;
			cuif.reg2 = bst_t.r2;
			cuif.imm = {8'b0, bst_t.imm_1, bst_t.imm_2};
			case(bst_t.funct):
				SW: cuif.cuOP = SW;
				SH: cuif.cuOP = SH;
				SB: cuif.cuOP = SB;
			endcase
		end
		ITYPE: begin
			cuif.memWrite = 1;
			cuif.aluSrc = 1;
			cuif.reg1 = jrli_t.r1;
			cuif.regd = jrli_t.rd;
			cuif.imm = {8'b0, jrli_t.imm};
			case({|(jrli_t.funct), jrli_t.funct3})
				ADDI: cuif.aluOP = ALU_ADD;
				SLTI: cuif.aluOP = ALU_SLT;
				SLTIU: cuif.aluOP = ALU_SLTU;
				XORI: cuif.aluOP = ALU_XOR;
				ORI: cuif.aluOP = ALU_OR;
				ANDI: cuif.aluOP = ALU_AND;
				SLLI: cuif.aluOP = ALU_SLL;
				SRLI: cuif.aluOP = ALU_SRL;
				SRAI: cuif.aluOP = ALU_SRA;
			endcase
		end
		RTYPE: begin
				case({|(r_t.funct), r_t.funct3})
				ADD: cuif.aluOP = ALU_ADD;
				SUB: cuif.aluOP = ALU_SUB;
				SLT: cuif.aluOP = ALU_SLT;
				SLTU: cuif.aluOP = ALU_SLTU;
				XOR: cuif.aluOP = ALU_XOR;
				OR: cuif.aluOP = ALU_OR;
				AND: cuif.aluOP = ALU_AND;
				SLL: cuif.aluOP = ALU_SLL;
				SRL: cuif.aluOP = ALU_SRL;
				SRA: cuif.aluOP = ALU_SRA;
			endcase
		end
	endcase
end
endmodule