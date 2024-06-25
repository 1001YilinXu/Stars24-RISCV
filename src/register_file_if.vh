`ifndef REGISTER_FILE_IF_VH
`define REGISTER_FILE_IF_VH
`include "cpu_pkg.vh"

interface register_file_if;
    import cpu_pkg::*;
    logic reg_write; 
    regBits read_index1, read_index2, write_index;
    word_t write_data, read_data1, read_data2;

    modport rf(
        input reg_write, read_index1, read_index2, write_index, write_data,
        output read_data1, read_data2
    );
    modport tb(
        output read_index1, read_index2, write_index, write_data,
        input reg_write, read_data1, read_data2
        );
endinterface
`endif