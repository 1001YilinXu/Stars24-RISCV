module request_unit
    mport cpu_types_pkg::*;
(
    input logic CLK, nRST,
    request_unit_if.ru ruif
);
logic dmmRen, dmmWen, nxt_dmmRen, dmmWen, imemRen; 
always_ff@(posedge CLK, negedge !nRST) begin
    if (!nRST) begin
        dmmRen, dmmWen <= 0; 
    end
    else begin
        dmmRen <= nxt_dmmRen;
        dmmWen <= nxt_dmmWen;
    end
end
always_comb begin
    imemRen = 1; 
    if (i_ready) begin
        nxt_dmmRen = dfetch [1];
        nxt_dmmWen = dfetch [0]; 
    end
    else if (d_ready) begin
        nxt_dmmRen = 0; 
        nxt_dmmWen = 0;
    end
end

assign ruif.dmmRen = dmmRen; 
assign ruif.dmmWen = dmmWen; 
assign ruif.imemRen = imemRen; 
assign ruif.imemaddr = imemaddr; 
assign ruif.dmmaddr = dmmaddr; 
assign ruif.dmmstore = dmmstore;
endmodule