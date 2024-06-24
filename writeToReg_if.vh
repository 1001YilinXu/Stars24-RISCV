`ifndef WTR_IF_VH
`define WTR_IF_VH

interface writeToRegis;

    logic [31:0]memload;
    logic [31:0]PC;
    logic [31:0]linkReg;
    logic [31:0]aluOut;
    logic [31:0]imm;
    logic ALUneg;
    logic [5:0]cuOP;
    logic[31:0]WriteData;

    modport writeToReg(
        input memload, PC, linkReg, aluOut, imm, ALUneg, cuOP,
        output WriteData
    );

    modport wtrTB(
        output memload, PC, linkReg, aluOut, imm, ALUneg, cuOP,
        input WriteData
    );

    endinterface

`endif