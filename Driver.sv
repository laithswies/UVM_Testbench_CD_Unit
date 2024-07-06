class CDU_Driver extends uvm_driver#(CDU_SequenceItem);

    virtual CDU_Interface vif;

    `uvm_component_utils(CDU_Driver) 
    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         if(!uvm_config_db#(virtual CDU_Interface) :: get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "Not set at top level");
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive();
            `uvm_info(get_type_name(), $sformatf("\033[33m################ DRIVER ##########\033[0m"), UVM_HIGH);
            `uvm_info(get_type_name(), $sformatf("\033[33mCommand: %h, Data In: %h, Compressed In: %h\033[0m", req.command, req.data_in, req.compressed_in), UVM_HIGH);
            seq_item_port.item_done();
        end
    endtask

    task drive();
        vif.command <= req.command;
        vif.data_in <= req.data_in;
        vif.compressed_in <= req.compressed_in;
        @(vif.driver_cb);
    endtask

endclass