`ifndef PC_IF_VH
`define PC_IF_VH

`include "cpu_pkg.vh"

import cpu_pkg::*;

interface pc_if;
    cuOPType cuOP;
    logic [31:0] rs1Read, signExtend, PCaddr;
    logic ALUneg;
    logic Zero;
    logic iready;
    logic clk;
    logic nRST;


modport pc (
    input cuOP, rs1Read, signExtend, ALUneg, Zero, iready, clk, nRST,
    output PCaddr
);

modport tb (
    output cuOP, rs1Read, signExtend, ALUneg, Zero, iready, clk, nRST,
    input PCaddr
);

endinterface
`endif