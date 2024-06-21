`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH
include "cpu_types_pkg.vh"

interface request_unit_if
 import cpu_types_pkg::*;
 logic dmmWen, dmmRen, imemRen, i_ready, d_ready;
 bytoff d_fetch;
 word_t dmmstorei, dmmstoreo, dmmaddri,dmmaddro, imemaddri, imemaddro, imemloadi, imemloado, dmmloadi, dmmloado;

 modport ru(
    // from mem ctr
    input i_ready, d_ready, dmmload, immload, 
    output dmmstore, dmmaddr, imemaddr, imemRen, dmmWen, dmmRen
    // from datapath
    input  dmmstore, dmmaddr, imemaddr, d_fetch, 
    output imemload, dmmload,
    
 );
endinterface
`endif