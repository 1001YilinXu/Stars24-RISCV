`include "src/cpu_pkg.vh"
`include "src/register_file_if.vh"
module register_file
import risc_pkg::*;
(
    input logic CLK, nRST,
    register_file_if.rf rfif
);
word_t [31:0] register, nxt_register;
assign register[0] = 32'b0;
always_ff@(posedge clk, negedge nRST) begin
    if (!nRST) begin
        register <= 0;
    end
    else if(reg_write) begin
        register <= nxt_register;
    end
end
always_comb begin
    nxt_register = register;
    if(rfif.reg_write & (rfif.write_data != 32'b0)) begin
    nxt_register [rfif.write_index]= rfif.write_data;
    end
end
assign rfif.read_data1 = register [rfif.read_index1];
assign rfif.read_data2 = register [rfif.read_index2];
endmodule