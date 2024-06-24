//input 32 bits imemload 
// output read_reg1, read_reg2, writeReg - 5 bits, 
// Cuop - 6 bits. 
// Aluop - 4 bits
// regwrite, Alusrc 1 bit 
// imm 20 bits 
`include "control_unit_if.vh"
`include "control_unit_if.vh"

`timescale 1 ns / 1 ns

module control_unit_tb;
import cpu_types_pkg::*;
    control_unit_if cuif ();
    control_unit CU (.cuif);
    test PROG (.cuif);
endmodule
task check_outputs
    
endtask
program test(
    control_unit_if.tb cuif
);
    parameter PERIOD = 10;
    initial begin
        cuif.instruction = 32'h
        
    end
endprogram