`ifndef MEMORY_CONTROL_IF_VH
`define MEMORY_CONTROL_IF_VH
`include "cpu_pkg.vh"

interface memory_control_if;
import cpu_pkg::*;
logic dmmRen, dmmWen, imemRen, i_ready, d_ready, Ren, Wen, busy_o;
word_t imemaddr, dmmaddr, dmmstore, dmmload, imemload, ramaddr, ramstore, ramload; 
modport mc(
    // mc <-> RU
    input dmmRen, dmmWen, imemRen,  busy_o, imemaddr, dmmaddr, dmmstore,
    output i_ready, d_ready, dmmload, immload,
    // mc <-> RAM 
    input ramload, busy_o, 
    output Ren, Wen, ramaddr, ramstore
);
endinterface
`endif