class CDU_Scoreboard extends uvm_scoreboard;
    uvm_analysis_imp#(CDU_SequenceItem,CDU_Scoreboard) exp;
    CDU_SequenceItem packetQueue [$];
    logic       reset;
    CDU_SequenceItem refPacket;

    `uvm_component_utils(CDU_Scoreboard)
    function new(string name,uvm_component parent);
        super.new(name,parent);
        //exp = new("exp",this);
        endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        exp= new("exp",this);
        refPacket = new("sequenceItem");
        endfunction

    function void write(CDU_SequenceItem req);
        packetQueue.push_back(req);
        endfunction

    task run_phase(uvm_phase phase);
        CDU_SequenceItem packet;
        this.refPacket.command = 0;    
        this.refPacket.data_in = 0;
        this.refPacket.compressed_in =0;
        this.reset = 1;
        CDU_RF_model(this.reset,
                    this.refPacket.command,
                    this.refPacket.data_in,
                    this.refPacket.compressed_in,
                    this.refPacket.compressed_out,
                    this.refPacket.decompressed_out,
                    this.refPacket.response);
        this.reset =0;

        forever begin
            wait(packetQueue.size>0);
            packet = packetQueue.pop_front();
            CDU_RF_model(reset,packet.command,
                         packet.data_in,
                         packet.compressed_in,
                         this.refPacket.compressed_out,
                         this.refPacket.decompressed_out,
                         this.refPacket.response);
            if (is_equal(packet)) begin
                `uvm_info("pass", $sformatf("\033[1;32m ------ :: Match :: ------ \033[0m"), UVM_LOW);
                `uvm_info("MATCH", $sformatf("\033[1;32m\n\
                +------------------+------------------+----------------------+------------------+------------------+----------------------+------------------+\n\
                |       Field      |      Command     |        Data In       |  Compressed In   |  Compressed Out  |   Decompressed Out   |     Response     |\n\
                +------------------+------------------+----------------------+------------------+------------------+----------------------+------------------+\n\
                |      Actual      |        %b        | %h |        %h        |        %h        | %h |        %b        |\n\
                +------------------+------------------+----------------------+------------------+------------------+----------------------+------------------+\n\
                |     Expected     |        %b        | %h |        %h        |        %h        | %h |        %b        |\n\
                +------------------+------------------+----------------------+------------------+------------------+----------------------+------------------+\033[0m",
                packet.command, packet.data_in, packet.compressed_in, packet.compressed_out, packet.decompressed_out, packet.response,
                packet.command, packet.data_in, packet.compressed_in, this.refPacket.compressed_out, this.refPacket.decompressed_out, this.refPacket.response), UVM_LOW);
                end 
            else begin
                `uvm_info("fail", $sformatf("\033[1;31m ------ :: Mismatch :: ------ \033[0m"), UVM_LOW);
                `uvm_info("MISS", $sformatf("\033[1;31m\n\
                +------------------+------------------+----------------------+------------------+------------------+----------------------+------------------+\n\
                |       Field      |      Command     |        Data In       |  Compressed In   |  Compressed Out  |   Decompressed Out   |     Response     |\n\
                +------------------+------------------+----------------------+------------------+------------------+----------------------+------------------+\n\
                |      Actual      |        %b        | %h |        %h        |        %h        | %h |        %b        |\n\
                +------------------+------------------+----------------------+------------------+------------------+----------------------+------------------+\n\
                |     Expected     |        %b        | %h |        %h        |        %h        | %h |        %b        |\n\
                +------------------+------------------+----------------------+------------------+------------------+----------------------+------------------+\033[0m",
                packet.command, packet.data_in, packet.compressed_in, packet.compressed_out, packet.decompressed_out, packet.response,
                packet.command, packet.data_in, packet.compressed_in, this.refPacket.compressed_out, this.refPacket.decompressed_out, this.refPacket.response), UVM_LOW);
            end    
        
        end

        endtask

    function bit is_equal(CDU_SequenceItem packet);
        if (this.refPacket.compressed_out === packet.compressed_out &&
            this.refPacket.decompressed_out === packet.decompressed_out &&
            this.refPacket.response === packet.response)
            return 1;
        else
            return 0;
    endfunction

    static task CDU_RF_model(input reset,
                             input [1:0] command,
                             input [79:0] data_in,
                             input [7:0] compressed_in,
                             output logic [7:0] compressed_out,
                             output logic [79:0] decompressed_out,
                             output logic [1:0] response);
        // Internal memory (dictionary memory)
       static logic [79:0] dictionary[256];
       static logic [31:0] index_reg;
       static logic [7:0] compressed_data;
       static logic [1:0] response_data; 
       static logic [79:0] decompressed_data;   

        if(reset==1)begin
            for (int i=0; i<256; i++)begin         
                dictionary[i]=0;          
            end
            response_data = 0;
            compressed_data = 0;
            decompressed_data = 0;
            index_reg = 0;
        end
      // Compression and Decompression logic
        case (command)
            2'b00: begin // no op
                response_data=0;
                // compressed_data=0;
                // decompressed_data=0;
                end
            2'b01: begin // Compression
                for (int i = 0; i < 256; i++) begin
                    if (dictionary[i] == data_in) begin
                        compressed_data = i;
                        response_data = 2'b01; // Valid compressed_out
                        break;
                        end
                        
                    end
                if (response_data != 2'b01 && index_reg <=255) begin
                    dictionary[index_reg] = data_in;
                    compressed_data = index_reg;
                    index_reg ++;
                    response_data = 2'b01; // Valid compressed_out
                    end
                else begin
                    response_data = 2'b11; // Error
                    // compressed_data=0;
                    // decompressed_data=0;
                    end
                end
            2'b10: begin // Decompression
                if (compressed_in <= index_reg) begin
                    decompressed_data = dictionary[compressed_in];
                    response_data = 2'b10; // Valid decompressed_out
                end else begin
                    response_data = 2'b11; // Error
                    // compressed_data=0;
                    // decompressed_data=0;
                end
                end
            2'b11: begin
                response_data = 2'b11; // Error
                // compressed_data=0;
                // decompressed_data=0;
                end
            endcase
        
        // Assign outputs
        response = response_data;
        compressed_out = compressed_data;
        decompressed_out = decompressed_data;
        response_data=0;
        // compressed_data=0;
        // decompressed_data=0;
        endtask

endclass