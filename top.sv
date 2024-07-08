// FPGA Top Level

`default_nettype none
// Empty top module


	typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR
	} cuOPType;	

module top (
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

  // Your code goes here...
  logic [31:0]outputtig;
    alu a2(.inputA(32'd10), .inputB(32'd15), .aluOP(CU_JAL), .ALUResult(outputtig), .negative(right[0]), .zero(right[1]));
  
endmodule

`timescale 1ms / 100us

module alu(
    input logic[31:0]inputA, inputB,
    input cuOPType aluOP,
    output logic[31:0]ALUResult,
    output logic negative, zero
);
//input A and B must be signed!
logic [31:0] unsignedA, unsignedB;
assign unsignedA = inputA;
assign unsignedB = inputB;
always_comb begin
    //will this zero cause an issue?
    zero = 0;
    case (aluOP)
    CU_SLL: begin
        ALUResult = inputA << inputB[4:0];
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_SRA: begin
        ALUResult = inputA >>> inputB[4:0];
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_SRL: begin
        ALUResult = inputA >> inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_ADD: begin
        ALUResult = inputA + inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_SUB: begin
        ALUResult = inputA - inputB;
        if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
        negative = ALUResult[31];
    end
    CU_OR: begin
        ALUResult = inputA | inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_XOR: begin
        ALUResult = inputA ^ inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_AND: begin
        ALUResult = inputA & inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    CU_SLT: begin
        if (inputA < inputB)
            ALUResult = 32'd1;
        else
            ALUResult = 32'd0; 
            negative = ALUResult[31];
    end
    CU_SLTU: begin
        if (unsignedA < unsignedB)
            ALUResult = 32'd1;
        else
            ALUResult = 32'd0;
        negative = ALUResult[31];
             end
    //do I need a defualt case?
    default: begin
        ALUResult = 32'd0;
        negative = 0;
        zero = 0;
    end
    endcase
end
endmodule   