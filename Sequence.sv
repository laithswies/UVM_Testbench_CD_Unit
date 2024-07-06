class CDU_Sequence extends uvm_sequence#(CDU_SequenceItem);

    `uvm_object_utils(CDU_Sequence)
    function new(string name="CDU_Sequence");
        super.new(name);
    endfunction

    task body();
        `uvm_do(req)
    endtask
    
endclass

class CDU_NO_OP_Sequence extends uvm_sequence#(CDU_SequenceItem);

    `uvm_object_utils(CDU_NO_OP_Sequence)
    function new(string name="CDU_NO_OP_Sequence");
        super.new(name);
    endfunction

    task body();
        `uvm_do_with(req,{req.command == 0;})

    endtask
    
endclass

class CDU_C_Sequence extends uvm_sequence#(CDU_SequenceItem);

    `uvm_object_utils(CDU_C_Sequence)
    function new(string name="CDU_C_Sequence");
        super.new(name);
    endfunction

    task body();
        `uvm_do_with(req,{req.command == 1;})

    endtask
    
endclass

class CDU_D_Sequence extends uvm_sequence#(CDU_SequenceItem);

    `uvm_object_utils(CDU_D_Sequence)
    function new(string name="CDU_D_Sequence");
        super.new(name);
    endfunction

    task body();
        `uvm_do_with(req,{req.command == 2;})

    endtask
    
endclass

class CDU_ERROR_Sequence extends uvm_sequence#(CDU_SequenceItem);

    `uvm_object_utils(CDU_ERROR_Sequence)
    function new(string name="CDU_ERROR_Sequence");
        super.new(name);
    endfunction

    task body();
        `uvm_do_with(req,{req.command == 3;})

    endtask
    
endclass

class CDU_CD_Sequence extends uvm_sequence#(CDU_SequenceItem);

    `uvm_object_utils(CDU_CD_Sequence)
    function new(string name="CDU_CD_Sequence");
        super.new(name);
    endfunction

    task body();
        `uvm_do_with(req,{req.command == 1;})
        `uvm_do_with(req,{req.command == 2;})
    endtask
    
endclass


class CDU_DC_Sequence extends uvm_sequence#(CDU_SequenceItem);

    `uvm_object_utils(CDU_DC_Sequence)
    function new(string name="CDU_DC_Sequence");
        super.new(name);
    endfunction

    task body();
        `uvm_do_with(req,{req.command == 2;})
        `uvm_do_with(req,{req.command == 1;})
    endtask

endclass