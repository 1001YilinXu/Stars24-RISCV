`include "src/pc_if.vh"
`include "src/cpu_pkg.vh"

import cpu_pkg::*;

module pc #(parameter INITPC = 0)(
    pc_if.pc pcif
);
        //     input logic clk, nRST,
        //    input logic[5:0] cuOP,
        //    input logic[31:0] rs1Read,
        //    input logic extendZeroes,
        //    input logic Zero,
        //    input logic ALUneg,
        //    input logic iready
        //    output logic[31:0]current_pc);
            logic[31:0] next_pc, PC;
            assign pcif.PCaddr = PC;
            

 create mode 100644 src/register_file.sv
            always_ff@(posedge pcif.clk, negedge pcif.nRST)
                if (pcif.nRST == 0)
                    PC <= INITPC;
                else
                    PC <= next_pc;

           always_comb begin
            if (pcif.iready)
                case(pcif.cuOP)
                    JALR: next_pc = {pcif.rs1Read + pcif.signExtend}&~1'b1;
                    JAL: next_pc = PC + pcif.signExtend;
                    BEQ: next_pc = (pcif.Zero? PC + pcif.signExtend: PC + 4);
                    BNE: next_pc = (~pcif.Zero? PC + pcif.signExtend : PC + 4);
                    BLT: next_pc = (pcif.ALUneg? PC + pcif.signExtend : PC + 4);
                    BGE: next_pc = (~pcif.ALUneg | pcif.Zero? PC + pcif.signExtend : PC + 4);
                    BLTU: next_pc = (pcif.ALUneg? PC + pcif.signExtend : PC + 4);
                    BGEU: next_pc = (~pcif.ALUneg | pcif.Zero? PC + pcif.signExtend : PC + 4);
                    default: next_pc = PC + 4;
                endcase
                else
                next_pc = PC;
           end
           
           
endmodule

