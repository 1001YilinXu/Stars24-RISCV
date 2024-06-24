`ifndef SIGNEXTENDER_IF_VH
`define SIGNEXTENDER_IF_VH

// all types
`include "cpu_pkg.vh"

interface signExtender_if;
import cpu_pkg::*;

logic [19:0] imm;
logic [x:x] CUOp;
word_t immOut;

modport dut (
input CUOp, imm,
output immOut
);

modport tb (
input CUOp, imm,
output immOut
);

endinterface
`endif 