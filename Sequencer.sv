class CDU_Sequencer extends uvm_sequencer#(CDU_SequenceItem);

    `uvm_component_utils(CDU_Sequencer)
    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

endclass