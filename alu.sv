`include "source/cpu_types_pkg.vh"
`include "source/alu_if.vh"

module alu(
input logic signed [31:0] inputA, inputB,
input logic [3:0] ALUOp,
output logic signed [31:0] ALUResult,
output logic negative, zero
);
//input A and B must be signed!
logic [31:0] unsignedA, unsignedB;
assign unsignedA = inputA;
assign unsignedB = inputB;
always_comb begin
    //will this zero cause an issue?
    zero = 0;
    case (ALUOp)
    ALU_SLL, ALU_SLLI:
        ALUResult = inputA << inputB[4:0];
    ALU_SRA, ALU_SRAI:
        ALUResult = inputA >>> inputB[4:0];
    ALU_SRL, ALU_SRLI:
        ALUResult = inputA >> inputB;
    ALU_ADD, ALU_ADDI:
        ALUResult = inputA + inputB;
    ALU_SUB: begin
        ALUResult = inputA - inputB;
        if (ALUResult == 0)
            zero = 1;
    end
    ALU_OR, ALU_ORI: 
        ALUResult = inputA | inputB;
    ALU_XOR, ALU_XORI:
        ALUResult = inputA ^ inputB;
    ALU_AND, ALU_ANDI:
        ALUResult = inputA & inputB;
    ALU_SLT, ALU_SLTI: begin
        if (inputA < inputB)
            ALUResult = 32'd1;
        else
            ALUResult = 32'd0;
    end 
    ALU_SLTU, ALU_SLTU: begin
        if (unsignedA < unsignedB)
            ALUResult = 32'd1;
        else
            ALUResult = 32'd0;
    end
    //do I need a defualt case?

    endcase
    negative = ALUResult[31];
end
endmodule   