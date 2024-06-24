`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH
`include "cpu_pkg.vh"

interface request_unit_if;
 import risc_pkg::*;
 logic dmmWen, dmmRen, imemRen, i_ready, d_ready;
 bytoff d_fetch;
 word_t dmmstorei, dmmstoreo, dmmaddri,dmmaddro, imemaddri, imemaddro, imemloadi, imemloado, dmmloadi, dmmloado;

 modport ru(
    // from mem ctr
    input i_ready, d_ready, dmmloadi, imemloadi, 
    output dmmstoreo, dmmaddro, imemaddro, imemRen, dmmWen, dmmRen,
    // from datapath
    input  dmmstorei, dmmaddri, imemaddri, d_fetch, 
    output imemloado, dmmloado,
    
 );
endinterface
`endif