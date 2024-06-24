`ifndef CPU_PKG_VH
`define CPU_PKG_VH

package cpu_pkg;
	parameter WORD_W = 32;
	parameter WORDBYTES = WORD_W/4;

	parameter OP_W = 7;
  parameter REG_W = 5;
  parameter SHAM_W = REG_W;
  parameter FUNC3_W = 3;
	parameter FUNC7_W = OP_W;
  parameter IMM_W = 20;

	parameter ALUOP_W = 4;

	typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;	

	//op code def
	typedef enum logic [OP_W - 1:0] {
		RTYPE = 7'b0110011,
		ITYPE = 7'b0010011,
		STORE = 7'b0100011,
		LOAD = 7'b0000011,
		BTYPE = 7'b1100011,
		JALR = 7'b1100111,
		JAL = 7'b1101111,
		AUIPC = 7'b0010111,
		LUI = 7'b0110111
	} opCode_t;	

	typedef enum logic [ALUOP_W - 1:0] {
		ALU_ADD = 0, 
		ALU_SUB = 1,
		ALU_OR = 2, 
		ALU_XOR = 3, 
		ALU_AND = 4, 
		ALU_SLL = 5, 
		ALU_SRA = 6, 
		ALU_SLTU = 7, 
		ALU_SLT = 8,
		ALU_SRL = 9
	}aluCode_t;
		
	//rtype def {inst[30], funct3}
	typedef enum logic [FUNC3_W:0] {
		ADD = 4'b0000,
		SUB = 4'b1000,
		SLL = 4'b0001,
		SLT = 4'b0010,
		SLTU = 4'b0011,
		XOR = 4'b0100,
		SRL = 4'b0101,
		SRA = 4'b1101,
		OR = 4'b110,
		AND = 4'b111
	} rfunc_t;

	//itype  def {inst[30], funct3}
	typedef enum logic [FUNC3_W:0] {
		ADDI = 4'b?000,
		SLTI = 4'b?010,
		SLTIU = 4'b?011,
		XORI = 4'b?100,
		SLLI = 4'b0001,
		SRLI = 4'b0101,
		SRAI = 4'b1101,
		ORI = 4'b?110,
		ANDI = 4'b?111
	} ifunc_t;

	//STORE def 
	typedef enum logic [FUNC3_W - 1:0] {
		SW = 3'b010,
		SH = 3'b001,
		SB = 3'b000
	} sfunc_t;

	//LOAD def 
	typedef enum logic [FUNC3_W - 1:0] {
		LW = 3'b010,
		LH = 3'b001,
		LB = 3'b000,
		LBU = 3'b100,
		LHU = 3'b101
	} lfunc_t;

	//BTYPE def 
	typedef enum logic [FUNC3_W - 1:0] {
		BEQ = 3'b000,
		BNE = 3'b001,
		BGE = 3'b101,
		BLT = 3'b100,
		BGEU = 3'b111,
		BLTU = 3'b110
	} bfunc_t;

	typedef logic [REG_W - 1:0] regBits;

	//JAL, LUI, AUIPC
		typedef struct packed {
		logic [IMM_W - 1:0] imm;
		regBits rd;
		opCode_t opType;
	} j_t;

	//JALR, Load, and immediate(nonshift)
	typedef struct packed {
		logic [11:0] imm;
		regBits r1;
		logic [FUNC3_W-1:0] funct;
		regBits rd;
		opCode_t opType;
	} jrli_t;
	
	//Btype and store
	typedef struct packed {
		logic [OP_W-1:0] imm_1;
		regBits r2;
		regBits r1;
		logic [FUNC3_W-1:0] funct;
		logic [REG_W - 1:0] imm_2;
		opCode_t opType;
	}bst_t;

	//Itype(shifting)
	typedef struct packed {
		logic [OP_W - 1:0] funct7;
		logic [SHAM_W - 1:0] shamt;
		regBits r1;
		logic [FUNC3_W-1:0] funct;
		regBits rd;
		opCode_t opType;
	} ishift_t;

	//Rtype
	typedef struct packed {
		logic [OP_W-1:0] funct7;
		regBits r2;
		regBits r1;
		logic [FUNC3_W-1:0] funct;
		regBits rd;
		opCode_t opType;
	} r_t;
	
	typedef logic [WORD_W - 1:0] word_t;

	typedef enum logic [1:0] {
		FREE,
		BUSY,
		ACCESS,
		ERROR
	} ramstate_t;

	typedef struct packed{
		logic valid;
		word_t data;
	} imem_t;
endpackage : cpu_pkg

`endif