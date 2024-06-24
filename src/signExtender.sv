`include "cpu_pkg.vh"
`include "signExtender_if.vh"

import cpu_pkg::*;

module signExtender (
signExtender_if.dut signedExtif
);
always_comb begin
//JAL operation
if (signedExtif.CUOp == JAL)
    signedExtif.immOut = {12'b0, signedExtif.imm[20], signedExtif.imm[10:1], signedExtif.imm[11], signedExtif[19:12]};
//All branch operations
else if (signedExtif.CUOp == BEQ || signedExtif.CUOp == BNE || signedExtif.CUOp == BLT || signedExtif.CUOp == BGE || signedExtif.CUOp == BLTU || signedExtif.CUOp == BGEU)
    signedExtif.immOut = {signedExtif.imm[12], signedExtif.imm[10:5], signedExtif.imm[4:1], signedExtif.imm[11]};
//other operations that are signed
else if (signedExtif.CUOp == ADDI || signedExtif.CUOp == SUB || signedExtif.CUOp == ADD || signedExtif.CUOp == SLTI || signedExtif.CUOp == SLT)
    signedExtif.immOut = {{20{signedExtif.imm[11]}}, signedExtif.imm[11:0]};
//all other operations
else
    signedExtif.immOut = {12'b0, signedExtif.imm};
end
endmodule