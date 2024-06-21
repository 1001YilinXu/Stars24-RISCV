interface memory_control_if;
import cpu_types_pkg::*;
logic dmmRen, dmmWen, imemRen, i_ready, d_ready, Ren, Wen, busy_o;
word_t imemaddr, dmmaddr, dmmstore, dmmload, imemload, ramaddr, ramstore, ramload; 
modport mc(
    input dmmRen, dmmWen, imemRen, i_ready, d_ready, busy_o, imemaddr, dmmaddr, dmmstore,
    output i_ready, d_ready, dmmload, ramaddr, ramstore, Ren, Wen
);
endinterface