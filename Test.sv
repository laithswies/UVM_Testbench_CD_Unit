`include "Environment.sv"
class CDU_Random_Test extends uvm_test;

    CDU_Environment cdu_environment;
    CDU_C_Sequence cdu_sequence;

    `uvm_component_utils(CDU_Random_Test)
    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cdu_environment = CDU_Environment::type_id::create("environment",this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        cdu_sequence = CDU_C_Sequence::type_id::create("cdu_Sequence");
        repeat(500) begin
            cdu_sequence.start(cdu_environment.agent.sequencer);
        end


        phase.drop_objection(this);
        `uvm_info(get_type_name, "End of testcase", UVM_LOW);
    endtask
endclass

class CDU_Regression_Test extends uvm_test;

    CDU_Environment cdu_environment;
    CDU_Sequence cdu_sequence;
    CDU_NO_OP_Sequence cdu_no_op_sequence;
    CDU_C_Sequence cdu_c_sequence;
    CDU_D_Sequence cdu_d_sequence;
    CDU_CD_Sequence cdu_cd_sequence;
    CDU_DC_Sequence cdu_dc_sequence;
    CDU_ERROR_Sequence cdu_error_sequence;

    `uvm_component_utils(CDU_Regression_Test)
    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cdu_environment = CDU_Environment::type_id::create("environment",this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        cdu_sequence = CDU_Sequence::type_id::create("cdu_Sequence"); 
        cdu_no_op_sequence = CDU_NO_OP_Sequence::type_id::create("cdu_no_op_Sequence"); 
        cdu_c_sequence = CDU_C_Sequence::type_id::create("cdu_c_Sequence");
        cdu_d_sequence = CDU_D_Sequence::type_id::create("cdu_d_Sequence");
        cdu_cd_sequence = CDU_CD_Sequence::type_id::create("cdu_cd_Sequence");
        cdu_dc_sequence = CDU_DC_Sequence::type_id::create("cdu_dc_Sequence");
        cdu_error_sequence = CDU_ERROR_Sequence::type_id::create("cdu_error_Sequence");
        repeat(2) begin
            // cdu_cd_sequence.start(cdu_environment.agent.sequencer);
            // cdu_no_op_sequence.start(cdu_environment.agent.sequencer);
            // cdu_c_sequence.start(cdu_environment.agent.sequencer);
            // cdu_d_sequence.start(cdu_environment.agent.sequencer);
            // cdu_cd_sequence.start(cdu_environment.agent.sequencer);
            cdu_dc_sequence.start(cdu_environment.agent.sequencer);
            // cdu_error_sequence.start(cdu_environment.agent.sequencer);
        end
        phase.drop_objection(this);
        `uvm_info(get_type_name, "End of testcase", UVM_LOW);
    endtask
endclass

class CDU_Overflow_Test extends uvm_test;

    CDU_Environment cdu_environment;
    CDU_C_Sequence cdu_c_sequence;
    CDU_D_Sequence cdu_d_sequence;

    `uvm_component_utils(CDU_Overflow_Test)
    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cdu_environment = CDU_Environment::type_id::create("environment",this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        cdu_c_sequence = CDU_C_Sequence::type_id::create("cdu_c_Sequence");
        cdu_d_sequence = CDU_D_Sequence::type_id::create("cdu_d_Sequence");
        repeat(300) begin
            cdu_c_sequence.start(cdu_environment.agent.sequencer);
        end

        repeat(300) begin
            cdu_d_sequence.start(cdu_environment.agent.sequencer);
        end

        phase.drop_objection(this);
        `uvm_info(get_type_name, "End of testcase", UVM_LOW);
    endtask
endclass