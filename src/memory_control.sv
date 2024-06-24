`include "src/cpu_pkg.vh"
`include "src/memory_control_if.vh"
module memory_control
    import risc_pkg::*;
(
    input logic CLK, nRST,
    memory_control_if.rf mcif
);
logic i_ready, d_ready;
word_t prev_dmmaddr, prev_dmmstore, prev_imemload, dmmload, imemload;

always_ff@(posedge CLK, negedge nRST) begin
    if(!nRST) begin
        prev_dmmaddr <= 32'b0;
        prev_dmmstore <= 32'b0;
        prev_imemload <= 32'b0;
    end
    else begin
        prev_dmmaddr <= mcif.dmmaddr; 
        prev_dmmstore <= mcif.dmmstore;
        prev_imemload <= mcif.imemload; 
    end
end
always_comb begin
    if(mcif.dmmRen) begin
        ramaddr = prev_dmmaddr;
        Ren = mcif.dmmRen;
        dmmload = mcif.ramload;
        d_wait = mcif.busy_o;
    end
    else if (mcif.dmmWen) begin
        ramaddr = prevdmmaddr; 
        Wen = dmmWen; 
        ramstore = prev_dmmstore;
        d_wait = mcif.busy_o;
    end
    else if(mcif.imemRen) begin
        ramaddr = mcif.imemaddr;
        Ren = immRen; 
        imemload = mcif.ramload;
        i_wait = mcif.busy_o;
    end
    else begin
        Ren = 1;
        Wen = 1; 
    end
end
assign i_ready = immRen & ~i_wait; 
assign d_ready = (dmmRen | dmmWen) & ~dwait;


//interface
assign mcif.ramaddr = ramaddr; 
assign mcif.ramstore = ramstore; 
assign mcif.Ren = Ren; 
assign mcif.Wen = Wen; 
assign mcif.dmmload = dmmload;
assign mcif.imemload = imemload;
assign mcif.i_ready = i_ready; 
assign mcif.d_ready = d_ready;
endmodule