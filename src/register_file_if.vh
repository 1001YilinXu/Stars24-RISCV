interface register_file_if
    import cpu_types_pkg::*;
    logic reg_write; 
    index_t read_index1, read_index2, write_index;
    word_t write_data, read_data1, read_data2;

    modport rf(
        input reg_write, read_index1, readindex2, write_index, write_data,
        output read_data1, read_data2
    );
    modport tb(
        input reg_write, read_index1, readindex2, write_index, write_data,
        output read_data1, read_data2
        );
endinterface