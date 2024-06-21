module request_unit
    import cpu_types_pkg::*;
(
    input logic CLK, nRST,
    request_unit_if.ru ruif
);
logic dmmRen, dmmWen, nxt_dmmRen, nxt_dmmWen, imemRen; 
always_ff@(posedge CLK, negedge !nRST) begin
    if (!nRST) begin
        dmmRen <= 0;
        dmmWen <= 0; 
    end
    else begin
        dmmRen <= nxt_dmmRen;
        dmmWen <= nxt_dmmWen;
    end
end
always_comb begin
    imemRen = 1; 
    if (i_ready) begin
        nxt_dmmRen = dfetch [1]; // change based on actual input of dfetch
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
assign ruif.imemaddro = ruif.imemaddri; 
assign ruif.dmmaddro = ruif.dmmaddri; 
assign ruif.dmmstoreo = ruif.dmmstorei;
assign ruif.imemloado = ruif.imemloado;
assign ruif.dmmloado = ruif.dmmloadi;
endmodule