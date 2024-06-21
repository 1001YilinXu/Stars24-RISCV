`include "source/cpu_types_pkg.vh"
`include "source/signExtender_if.vh"

module signExtender (
signExtender_if.dut signedExtif
);
always_comb begin
if ((signedExtif.CUOp == JAL) || (signedExtif.CUOp == AUIPC) || (signedExtif.CUOp == LUI))
    signedExtif.immOut = {12'b0, signedExtif.imm};
else 
    if (signedExtif.CUOp == ADDI || signedExtif.CUOp == SUB || signedExtif.CUOp == ADD || signedExtif.CUOp == SLTI || signedExtif.CUOp == SLT)
        signedExtif.immOut = {{20{signedExtif.imm[11]}}, signedExtif.imm[11:0]};
    else
        signedExtif.immOut = {20'b0, signedExtif.imm};
end
endmodule