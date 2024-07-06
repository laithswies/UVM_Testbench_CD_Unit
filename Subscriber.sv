class CDU_Subscriber extends uvm_subscriber #(CDU_SequenceItem);
   logic [ 1:0] command;
   logic [79:0] data_in;
   logic [ 7:0] compressed_in;
   logic [ 7:0] compressed_out;
   logic [79:0] decompressed_out;
   logic [ 1:0] response;

    `uvm_component_utils(CDU_Subscriber)
    function new(string name,uvm_component parent);
        super.new(name,parent);
        cduCoverage = new();
    endfunction

    covergroup cduCoverage;
        command: coverpoint command;
        data_in: coverpoint data_in;
        compressed_in: coverpoint compressed_in;
        compressed_out: coverpoint compressed_out;
        decompressed_out: coverpoint decompressed_out;
        response: coverpoint response;
    endgroup

    function void write (CDU_SequenceItem t);
        command = t.command;
        data_in = t.data_in;
        compressed_in = t.compressed_in;
        compressed_out = t.compressed_out;
        decompressed_out = t.decompressed_out;
        response = t.response;
        cduCoverage.sample();
    endfunction

endclass