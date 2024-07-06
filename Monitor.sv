class CDU_Monitor extends uvm_monitor;

    virtual CDU_Interface vif;
    uvm_analysis_port#(CDU_SequenceItem) port;
    CDU_SequenceItem packet;

    `uvm_component_utils(CDU_Monitor)
    function new(string name , uvm_component parent);
        super.new(name,parent);
        port = new("monitor_port",this);
        packet = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual CDU_Interface) :: get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "Not set at top level");
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            // wait(!vif.rst_l);
            // @(vif.driver_cb);
            @(vif.monitor_cb);
            packet.command = vif.command;
            packet.data_in = vif.data_in;
            packet.compressed_in = vif.compressed_in;
            `uvm_info(get_type_name(), $sformatf("\033[34m################ MONITOR ##########\033[0m"), UVM_HIGH);
            `uvm_info(get_type_name(), $sformatf("\033[34mCommand: %h, Data In: %h, Compressed In: %h\033[0m", packet.command, packet.data_in, packet.compressed_in), UVM_HIGH);
            packet.compressed_out = vif.compressed_out;
            packet.decompressed_out = vif.decompressed_out;
            packet.response = vif.response;
            `uvm_info(get_type_name(), $sformatf("\033[34mCompressed Out: %h, Decompressed Out: %h, Response: %b\033[0m", packet.compressed_out, packet.decompressed_out, packet.response), UVM_HIGH);
            port.write(packet);
        end
    endtask
endclass