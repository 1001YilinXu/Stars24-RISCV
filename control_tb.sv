//input 32 bits imemload 
// output read_reg1, read_reg2, writeReg - 5 bits, 
// Cuop - 6 bits. 
// Aluop - 4 bits
// regwrite, Alusrc 1 bit 
// imm 20 bits 
`include "src/cpu_pkg.vh"
`include "src/control_if.vh"

`timescale 1 ns / 1 ns

module control_unit_tb;
import cpu_pkg::*;
    control_if cuif ();
    control CU (.cuif);
    test PROG (.cuif);
endmodule

program test(
    control_if.tb cuif
);
    parameter PERIOD = 10;
    initial begin
        cuif.instr = 32'hAAAAA537; //Lui
         #(PERIOD)
        cuif.instr = 32'hAAAAA517; // AUIPC 
         #(PERIOD)
        cuif.instr = 32'hFACEE56F;  // JAL
        #(PERIOD)
        cuif.instr = 32'hFAC78567; // JALR
        #(PERIOD)
        cuif.instr = 32'h6EDA88E7;// BEQ
        #(PERIOD)
        cuif.instr = 32'h6EDA98E7;// BNE
        #(PERIOD)
        cuif.instr = 32'h6EDAC8E7 ;// BGE
        #(PERIOD)
        cuif.instr = 32'h6EDAD8E7; // BLTU
        #(PERIOD)
        cuif.instr = 32'h6EDAE8E7; // BEGU
        #(PERIOD)
        cuif.instr = 32'h6EDAF8E7; // BGEU
        #(PERIOD)
        cuif.instr = 32'hABCA8503; // LB
        #(PERIOD)
        cuif.instr = 32'hABCA9503 ;// LH
        #(PERIOD)
        cuif.instr = 32'hABCAA503; // LW
        #(PERIOD)
        cuif.instr = 32'hABCAC503 ;// LBU
        #(PERIOD)
        cuif.instr = 32'hABCAD503; // LHU
        #(PERIOD)
        cuif.instr = 32'hEEAC0723 ;// SB
        #(PERIOD)
        cuif.instr = 32'hEEAC1723; // SH
        #(PERIOD)
        cuif.instr = 32'hEEAC2723; // SW
        #(PERIOD)
        cuif.instr = 32'hABC50D13; // ADDI
        #(PERIOD)
        cuif.instr = 32'hABC52D13; // SLTI
        #(PERIOD)
        cuif.instr = 32'hABC53D13; //SLTIU 
        #(PERIOD)
        cuif.instr = 32'hABC54D13; //XORI
        #(PERIOD)
        cuif.instr = 32'hABC56D13; //ORI
        #(PERIOD)
        cuif.instr = 32'hABC57D13; //ANDI
        #(PERIOD)
        cuif.instr = 32'h002A9C13; // SLLI
        #(PERIOD)
        cuif.instr = 32'h402D9C13; // SRLI
        #(PERIOD)
        cuif.instr = 32'h402D9C13; // SRAI
        #(PERIOD)
        cuif.instr = 32'h00C50C33; // add
        #(PERIOD)
        cuif.instr = 32'h40C50C33; // sub
        #(PERIOD)
        cuif.instr = 32'h00C51C33; // sll
        #(PERIOD)
        cuif.instr = 32'h00C52C33; // slt
        #(PERIOD)
        cuif.instr = 32'h00C53C33; // sltu
        #(PERIOD)
        cuif.instr = 32'h00C54C33; // xor
        #(PERIOD)
        cuif.instr = 32'h00C55C33; // srl
        #(PERIOD)
        cuif.instr = 32'h40C55C33; // sra
        #(PERIOD)
        cuif.instr = 32'h00C56C33; //OR
        #(PERIOD)
        cuif.instr = 32'h00C57C33; // AND

    end
endprogram