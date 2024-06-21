 module register_file
import cpu_types_pkg::*;
(
    input logic CLK, nRST,
    register_file_if.rf rfif
);
word_t [31:0] register, nxt_register;
always_ff@(posedge clk, negedge nRST) begin
    if (!nRST) begin
        register <= 0;
    end
    else if(reg_write) begin
        register <= nxt_register;
    end
end
always_comb begin
    nxt_register [write_index]= write_data;
end
assign read_data1 = register [read_index1];
assign read_data2 = register [read_index2];
endmodule