interface request_unit_if
 import cpu_types_pkg::*;
 logic dmmWen, dmmRen, imemRen, i_ready, d_ready;
 bytoff d_fetch;
 word_t dmmstore, dmmaddr, imemaddr, imemload, dmmload;

 modport ru(
    input i_ready, d_ready, dmmstore, dmmaddr, imemaddr, d_fetch, dmmload, immload, 
    output imemload, dmmload, dmmstore, dmmaddr, imemaddr, imemRen, dmmWen, dmmRen
 );
endinterface
