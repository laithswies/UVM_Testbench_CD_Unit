`include "SequenceItem.sv"
`include "Sequencer.sv"
`include "Sequence.sv"
`include "Driver.sv"
`include "Monitor.sv"
class CDU_Agent extends uvm_agent;
    
    CDU_Driver driver;
    CDU_Sequencer sequencer;
    CDU_Monitor monitor;

    `uvm_component_utils(CDU_Agent)
    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(get_is_active() == UVM_ACTIVE) begin
            sequencer = CDU_Sequencer::type_id::create("sequencer",this);
            driver = CDU_Driver::type_id::create("driver",this);
        end
        monitor = CDU_Monitor::type_id::create("monitor",this);
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        if(get_is_active() == UVM_ACTIVE)begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction

endclass