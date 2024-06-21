`include "src/cpu_pkg.vh"
`include "src/alu_if.vh"

module alu(
alu_if.dut aluif
);
//input A and B must be signed!
logic [31:0] unsignedA, unsignedB;
assign unsignedA = aluif.inputA;
assign unsignedB = aluif.inputB;
always_comb begin
    //will this zero cause an issue?
    aluif.zero = 0;
    case (aluif.op)
    ALU_SLL:
        aluif.ALUResult = aluif.inputA << aluif.inputB[4:0];
    ALU_SRA:
        aluif.ALUResult = aluif.inputA >>> aluif.inputB[4:0];
    ALU_SRL:
        aluif.ALUResult = aluif.inputA >> aluif.inputB;
    ALU_ADD:
        aluif.ALUResult = aluif.inputA + aluif.inputB;
    ALU_SUB: begin
        aluif.ALUResult = aluif.inputA - aluif.inputB;
        if (aluif.ALUResult == 0)
            aluif.zero = 1;
    end
    ALU_OR: 
        aluif.ALUResult = aluif.inputA | aluif.inputB;
    ALU_XOR:
        aluif.ALUResult = aluif.inputA ^ aluif.inputB;
    ALU_AND:
        aluif.ALUResult = aluif.inputA & aluif.inputB;
    ALU_SLT: begin
        if (aluif.inputA < aluif.inputB)
            aluif.ALUResult = 32'd1;
        else
            aluif.ALUResult = 32'd0;
    end 
    ALU_SLTU: begin
        if (aluif.unsignedA < aluif.unsignedB)
            aluif.ALUResult = 32'd1;
        else
            aluif.ALUResult = 32'd0;
    end
    //do I need a defualt case?

    endcase
    aluif.negative = aluif.ALUResult[31];
end
endmodule   