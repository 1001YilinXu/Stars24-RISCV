`include "cpu_pkg.vh"
`include "control_if.vh"

module control
import cpu_pkg::*;
(
	control_if.cu cuif	
);

r_t rt;
ishift_t ishift;
j_t jt;
jrli_t jrli;
bst_t bst;

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
	rt = cuif.instr;
	ishift = cuif.instr;
	jt = cuif.instr;
	jrli = cuif.instr;
	bst = cuif.instr;

	casez(rt.opType)
		LUI: begin
			cuif.cuOP = CU_LUI;
			cuif.regWrite = 1;
			cuif.imm = jt.imm;
		end
		AUIPC: begin
			cuif.cuOP = CU_AUIPC;
			cuif.regWrite = 1;
			cuif.imm = jt.imm;
		end
		JAL: begin 
			cuif.cuOP = CU_JAL;
			cuif.regWrite = 1;
			cuif.imm = jt.imm;
		end
		JALR:begin
			cuif.cuOP = CU_JALR;
			cuif.regWrite = 1;
			cuif.imm = {8'b0, jrli.imm};
			cuif.regd = jrli.rd;
		end
		BTYPE: begin
			cuif.branch = 1;
			cuif.aluOP = ALU_SUB;
			cuif.reg1 = bst.r1;
			cuif.reg2 = bst.r2;
			cuif.imm = {8'b0, bst.imm_1, bst.imm_2};
			casez(bst.funct)
				BEQ: cuif.cuOP = CU_BEQ;
				BNE: cuif.cuOP = CU_BNE;
				BLT: cuif.cuOP = CU_BLT;
				BGE: cuif.cuOP = CU_BGE;
				BLTU: cuif.cuOP = CU_BLTU;
				BGEU: cuif.cuOP = CU_BGEU;
				default: cuif.cuOP = CU_ERROR;
			endcase
		end
		LOAD: begin
			cuif.regWrite = 1;
			cuif.aluSrc = 1;
			cuif.memRead = 1;
			cuif.aluOP = ALU_ADD;
			cuif.reg1 = jrli.r1;
			cuif.regd = jrli.rd;
			cuif.imm = {8'b0, jrli.imm};
			casez(jrli.funct)
				LB: cuif.cuOP = CU_LB;
				LH: cuif.cuOP = CU_LH;
				LW: cuif.cuOP = CU_LW;
				LBU: cuif.cuOP = CU_LBU;
				LHU: cuif.cuOP = CU_LHU;
				default: cuif.cuOP = CU_ERROR;
			endcase
		end
		STORE: begin
			cuif.memWrite = 1;
			cuif.aluSrc = 1;
			cuif.aluOP = ALU_ADD;
			cuif.reg1 = bst.r1;
			cuif.reg2 = bst.r2;
			cuif.imm = {8'b0, bst.imm_1, bst.imm_2};
			casez(bst.funct)
				SW: cuif.cuOP = CU_SW;
				SH: cuif.cuOP = CU_SH;
				SB: cuif.cuOP = CU_SB;
				default: cuif.cuOP = CU_ERROR;
			endcase
		end
		ITYPE: begin
			cuif.memWrite = 1;
			cuif.aluSrc = 1;
			cuif.reg1 = jrli.r1;
			cuif.regd = jrli.rd;
			cuif.imm = {8'b0, jrli.imm};
			casez({|(jrli.imm), jrli.funct})
				ADDI: begin
					cuif.aluOP = ALU_ADD;
					cuif.cuOP = CU_ADDI;
				end
				SLTI: begin
					cuif.aluOP = ALU_SLT;
					cuif.cuOP = CU_SLTI;
				end
				SLTIU: begin
					cuif.aluOP = ALU_SLTU;
					cuif.cuOP = CU_SLTIU;
				end 
				XORI: begin
					cuif.aluOP = ALU_XOR;
					cuif.cuOP = CU_XORI;
				end 
				ORI: begin
					cuif.aluOP = ALU_OR;
					cuif.cuOP = CU_ORI;
				end 
				ANDI: begin
					cuif.aluOP = ALU_AND;
					cuif.cuOP = CU_ANDI;
				end 
				SLLI: begin
					cuif.aluOP = ALU_SLL;
					cuif.cuOP = CU_SLLI;
				end 
				SRLI: begin
					cuif.aluOP = ALU_SRL;
					cuif.cuOP = CU_SRLI;
				end 
				SRAI: begin
					cuif.aluOP = ALU_SRA;
					cuif.cuOP = CU_SRAI;
				end 
				default: cuif.cuOP = CU_ERROR;
			endcase
		end
		RTYPE: begin
				casez({|(rt.funct), rt.funct})
				ADD: begin
					cuif.aluOP = ALU_ADD;
					cuif.cuOP = CU_ADD;
				end
				SUB: begin
					cuif.aluOP = ALU_SUB;
					cuif.cuOP = CU_SUB;
				end
				SLT: begin
					cuif.aluOP = ALU_SLT;
					cuif.cuOP = CU_SLT;
				end
				SLTU: begin
					cuif.aluOP = ALU_SLTU;
					cuif.cuOP = CU_SLTU;
				end 
				XOR: begin
					cuif.aluOP = ALU_XOR;
					cuif.cuOP = CU_XOR;
				end 
				OR: begin
					cuif.aluOP = ALU_OR;
					cuif.cuOP = CU_OR;
				end 
				AND: begin
					cuif.aluOP = ALU_AND;
					cuif.cuOP = CU_AND;
				end 
				SLL: begin
					cuif.aluOP = ALU_SLL;
					cuif.cuOP = CU_SLL;
				end 
				SRL: begin
					cuif.aluOP = ALU_SRL;
					cuif.cuOP = CU_SRL;
				end 
				SRA: begin
					cuif.aluOP = ALU_SRA;
					cuif.cuOP = CU_SRA;
				end 
				default: cuif.cuOP = CU_ERROR;
			endcase
		end
		default: cuif.cuOP = CU_ERROR;
	endcase
end
endmodule