`ifndef SIGNEXTENDER_IF_VH
`define SIGNEXTENDER_IF_VH

// all types
`include "cpu_pkg.vh"
import cpu_pkg::*;

interface signExtender_if;


logic [19:0] imm;
logic [x:x] CUOp;
word_t immOut;

modport dut (
input CUOp, imm,
output immOut
);

modport tb (
output CUOp, imm,
input immOut
);

endinterface
`endif 