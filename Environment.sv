

`include "Agent.sv"
`include "Scoreboard.sv"
`include "Subscriber.sv"
class CDU_Environment extends uvm_env;

    CDU_Agent agent;
    CDU_Scoreboard scoreboard;
    CDU_Subscriber subscriber; 
    
    `uvm_component_utils(CDU_Environment)
    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = CDU_Agent::type_id::create("agent",this);
        scoreboard = CDU_Scoreboard::type_id::create("scoreboard",this);
        subscriber = CDU_Subscriber::type_id::create("subscriber",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agent.monitor.port.connect(scoreboard.exp);
        agent.monitor.port.connect(subscriber.analysis_export);
    endfunction
endclass