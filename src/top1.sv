// FPGA Top Level

`default_nettype none

module top1 (
  // I/O ports
  input  logic clk, nrst,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
  output logic [7:0] ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0
  // output logic red, green, blue,

  // // UART ports
  // output logic [7:0] txdata,
  // input  logic [7:0] rxdata,
  // output logic txclk, rxclk,
  // input  logic txready, rxready
);

	logic zero, negative, regWrite, aluSrc, d_ready, i_ready, memWrite, memRead, write_enable_cpu, write_enable, busy_o, nrstFPGA;
	logic [3:0] aluOP;
	logic [4:0] regsel1, regsel2, w_reg;
	logic [5:0] cuOP;
	logic [19:0] imm;
	logic [31:0] memload, aluIn, aluOut, immOut, pc, writeData, regData1, regData2, instruction_out;
  logic [31:0] datain, dataout;
  logic [31:0] addr;
  logic [31:0][31:0] test_memory;
  logic [31:0][31:0] test_nxt_memory; 

///////////////////////FPGA connection
// logic muxxedMemEnable, fpgaMemEnable;
// logic[31:0] muxxedDataOut, fpgaAddressOut, fpgaDataOut;

// mux enableWrite(.in1(32'd1), .in2({31'b0, memWrite}), .en(fpgaMemEnable), .out(intermedWriteEnable));
// mux enableFpgaData(.in1(fpgaDataOut), .in2(regData2), .en(fpgaMemEnable), .out(muxxedDataOut));
// mux enableFpgaAddress(.in1(fpgaAddressOut), .in2(aluOut), .en(fpgaMemEnable), .out(muxxedAddressOut));

logic [127:0] row1, row2;
logic [15:0] halfData;
logic [31:0] FPGAAdress, FPGADataOut;
logic FPGAEnable, writeFPGA, CPUEnable, keyStrobe, enData;

assign {left[2], left[4], left[6], left[0]} = scan_col;
assign left[5] = lcd_en;
assign left[3] = lcd_rw;
assign left[1] = lcd_rs;
assign read_row = pb[3:0];
assign right = lcd_data;

// fpgaModule a1 (.clk(clk), .nrst(nrst), .instruction(instruction), .dataIn(memload), .buttons(read_row), .ss1(ss0), .ss2(ss1), .ss3(ss2),
// .ss4(ss3), .ss5(ss4), .ss6(ss5), .ss7(ss6), .ss8(ss7), .FPGAEnable(FPGAEnable), .writeFPGA(writeFPGA), .CPUEnable(CPUEnable), .address(FPGAAdress), 
// .dataOut(FPGADataOut), .right(right), .left(left), .writeData(writeData), .nrstFPGA(nrstFPGA), .row1(row1), .row2(row2), .keyStrobe(keyStrobe), 
// .halfData(halfData), .enData(enData));

// logic [31:0] muxxedAddressOut, muxxedDataOut;
// logic [31:0]intermedWriteEnable;

// mux enableWrite(.in1({31'b0, writeFPGA}), .in2({31'b0, memWrite}), .en(FPGAEnable), .out(intermedWriteEnable));
// mux enableFpgaData(.in1(FPGADataOut), .in2(regData2), .en(FPGAEnable), .out(muxxedDataOut));
// mux enableFpgaAddress(.in1(FPGAAdress), .in2(aluOut), .en(FPGAEnable), .out(muxxedAddressOut));
// assign write_enable = intermedWriteEnable[0];

////////////////////

logic lcd_en, lcd_rw, lcd_rs;
logic [7:0] lcd_data;
logic [3:0] read_row, scan_col;

edgeDetector edg2(.clk(clk), .nRst_i(nrst), .button_i(~keyStrobe), .button_p(enData));
keypad pad (.clk(clk), .rst(nrst), .receive_ready(keyStrobe), .data_received(halfData), .read_row(read_row), .scan_col(scan_col));
lcd1602 lcd (.clk(clk), .rst(nrst), .row_1(row1), .row_2(row2), .lcd_en(lcd_en), .lcd_rw(lcd_rw), .lcd_rs(lcd_rs), .lcd_data(lcd_data));

logic [31:0] instruction;
logic [7:0] data_out8;
mux aluMux(.in1(immOut), .in2(regData2), .en(aluSrc), .out(aluIn));

alu arith(.aluOP(aluOP), .inputA(regData1), .inputB(aluIn), .ALUResult(aluOut), .zero(zero), .negative(negative));

logic [31:0] regData14;

register_file DUT(.clk(clk), .nRST(nrst & nrstFPGA), .reg_write(regWrite), .read_index1(regsel1), .read_index2(regsel2), .read_data14(regData14),
.read_data1(regData1), .read_data2(regData2), .write_index(w_reg), .write_data(writeData));

control controller (.cuOP(cuOP), .instruction(instruction), 
.reg_1(regsel1), .reg_2(regsel2), .rd(w_reg),
.imm(imm), .aluOP(aluOP), .regWrite(regWrite), .memWrite(memWrite), .memRead(memRead), .aluSrc(aluSrc));

pc testpc(.clk(clk), .nRST(nrst & nrstFPGA), .ALUneg(negative), .Zero(zero), .iready(i_ready), .PCaddr(pc), .cuOP(cuOP), .rs1Read(regData1), .signExtend(immOut), .enable(CPUEnable));

writeToReg write(.cuOP(cuOP), .memload(memload), .aluOut(aluOut), .imm(immOut), .pc(pc), .writeData(writeData), .negative(negative));

signExtender signex(.imm(imm), .immOut(immOut), .CUOp(cuOP));

//is address_IM and address_DM right?

ram rram (.clk(clk), .nRst(nrst), .write_enable(write_enable), .read_enable(1),
 .address_DM(muxxedAddressOut[11:0]), .address_IM(pc[11:0]), 
 .data_in(muxxedDataOut), .data_out(memload), .instr_out(instruction), .pc_enable(i_ready));
//ram ra(.clk(clk), .nRst(nrst), .write_enable(memWrite), .read_enable(1), .address_DM(aluOut[5:0]), .address_IM(pc[5:0]), .data_in(regData2), .data_out(memload), .instr_out(instruction), .pc_enable(i_ready), .CUOp(cuOP));



endmodule