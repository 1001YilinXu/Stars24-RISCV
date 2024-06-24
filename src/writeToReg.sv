`include "writeToReg_if.vh"
`include "src/cpu_pkg.vh"

import cpu_pkg::*;

module writeToReg (
    writeToRegis.writeToReg wtr
);

logic [31:0] writeOut;
assign wtr.WriteData = writeOut;

always_comb begin
    case(wtr.cuOP)
        LB: writeOut = {24{wtr.memload[7], memload[7:0]}};
        LH: writeOut = {16{wtr.memload[7], memload[7:0]}};
        LW: writeOut = memload;
        LBU: writeOut = {24'b0, memload[7:0]};
        LHU: writeOut = {16'b0, memload[15:0]};
        AUIPC: writeOut = wtr.PC + {wtr.imm[19:0], 12'b0};
        LUI: writeOut = {wtr.imm[31:12], 12'b0};
        JAL: writeOut = wtr.linkReg + 4;
        JALR: writeOut = wtr.linkReg + 4;
        default: writeOut = wtr.aluOut;
    endcase
end






endmodule