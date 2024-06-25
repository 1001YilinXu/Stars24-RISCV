`include "cpu_pkg.vh"
`include "register_file_if.vh"
module register_file
import cpu_pkg::*;
(
    input logic clk, nRST,
    register_file_if.rf rfif
);
word_t register [31:0], nxt_register[31:0];
assign register[0] = 32'b0;
always_ff@(posedge clk, negedge nRST) begin
    if (!nRST) begin
        register[0] <= 32'b0;
    end
    else if(rfif.reg_write) begin
        register <= nxt_register;
    end
end
always_comb begin
    if(rfif.reg_write & (rfif.write_data != 32'b0)) begin
    nxt_register [rfif.write_index]= rfif.write_data;
    end
    nxt_register = register;
end
assign rfif.read_data1 = register [rfif.read_index1];
assign rfif.read_data2 = register [rfif.read_index2];
endmodule