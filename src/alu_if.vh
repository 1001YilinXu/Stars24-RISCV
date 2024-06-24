`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_pkg.vh"

interface alu_if;
import cpu_pkg::*;

//how do I make sure inputs A and B or signed?
logic negative, zero;
//word_t inputA, inputB, ALUResult;
logic signed [31:0] inputA, inputB, ALUResult;
aluCode_t ALUOp;



modport dut (
input inputA, inputB, ALUOp,
output ALUResult, negative, zero
);

modport tb (
output inputA, inputB, ALUOp,
input ALUResult, negative, zero
);

endinterface
`endif 