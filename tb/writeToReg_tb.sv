`include "src/writeToReg_if.vh"
`include "src/cpu_pkg.vh"
`include "src/pc.sv"

import cpu_pkg::*;

`timescale 1ms / 100us

module writeToReg_tb ();

localparam CLK_PERIOD = 10;

logic tb_clk;

always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end

writeToReg_if writeif ();

test PROG(.writeif(writeif), .tb_clk(tb_clk));




endmodule