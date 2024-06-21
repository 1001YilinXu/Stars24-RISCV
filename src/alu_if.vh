`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
import cpu_types_pkg::*;

//how do I make sure inputs A and B or signed?
logic negative, zero;
word_t inputA, inputB, ALUResult;
//can I use this instead of whats above?
//logic signed [31:0] inputA, inputB, ALUResult;
logic[3:0] op;



modport dut (
input inputA, inputB, ALUOp,
output ALUResult, negative, zero
);

modport tb (
input inputA, inputB, ALUOp,
output ALUResult, negative, zero
);

endinterface
`endif 