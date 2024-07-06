class CDU_SequenceItem extends uvm_sequence_item;
    rand logic [ 1:0] command;
    rand logic [79:0] data_in;       // 80 bit Input Data to be compressed
    rand logic [ 7:0] compressed_in; // 8 bit Input Data to be decompressed
         logic [ 7:0] compressed_out;    // 8 Output Output compressed data
         logic [79:0] decompressed_out;
         logic [ 1:0] response;           // the status of the output


    `uvm_object_utils_begin(CDU_SequenceItem)
        `uvm_field_int(command,UVM_ALL_ON)
        `uvm_field_int(data_in,UVM_ALL_ON)
        `uvm_field_int(compressed_in,UVM_ALL_ON)
        `uvm_field_int(compressed_out,UVM_ALL_ON)
        `uvm_field_int(decompressed_out,UVM_ALL_ON)
        `uvm_field_int(response,UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="sequenceItem");
        super.new(name);
    endfunction
endclass