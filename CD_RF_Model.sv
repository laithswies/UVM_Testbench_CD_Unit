module test;
    logic       reset;
    logic [1:0] command;
    logic [79:0] data_in;
    logic [7:0] compressed_in;
    logic [7:0] compressed_out;
    logic [79:0] decompressed_out;
    logic [1:0] response;



    initial begin
        command = 0;    
        data_in = 0;
        compressed_in = 0;
        reset = 1;
        CDU_RF_model(reset,command,data_in,compressed_in,compressed_out,decompressed_out,response);
        reset = 0;

        #1;      
        command = 2;
        data_in = 'hFF;
        compressed_in = 00;
        CDU_RF_model(reset,command,data_in,compressed_in,compressed_out,decompressed_out,response);
        $display("\033[32m################ OUTPUT ##########\033[0m");
        $display("\033[32mCompressed Data: %h, Decompressed Data: %h, Response: %b\n\033[0m", compressed_out, decompressed_out, response);

        #1;
        command = 1;    
        data_in = 'hF1233F;
        compressed_in = 'hFF;
        CDU_RF_model(reset,command,data_in,compressed_in,compressed_out,decompressed_out,response);
        $display("\033[32m################ OUTPUT ##########\033[0m");
        $display("\033[32mCompressed Data: %h, Decompressed Data: %h, Response: %b\n\033[0m", compressed_out, decompressed_out, response);

        #1;


        command = 1;    
        data_in = 'hFF;
        compressed_in = 'hFF;
        CDU_RF_model(reset,command,data_in,compressed_in,compressed_out,decompressed_out,response);
        $display("\033[32m################ OUTPUT ##########\033[0m");
        $display("\033[32mCompressed Data: %h, Decompressed Data: %h, Response: %b\n\033[0m", compressed_out, decompressed_out, response);
        #1;

        command = 1;    
        data_in = 'hF123145F;
        compressed_in = 'hFF;
        CDU_RF_model(reset,command,data_in,compressed_in,compressed_out,decompressed_out,response);
        $display("\033[32m################ OUTPUT ##########\033[0m");
        $display("\033[32mCompressed Data: %h, Decompressed Data: %h, Response: %b\n\033[0m", compressed_out, decompressed_out, response);
        #1;


        command = 2;
        data_in = 'hFF;
        compressed_in = 1;
        CDU_RF_model(reset,command,data_in,compressed_in,compressed_out,decompressed_out,response);
        $display("\033[32m################ OUTPUT ##########\033[0m");
        $display("\033[32mCompressed Data: %h, Decompressed Data: %h, Response: %b\n\033[0m", compressed_out, decompressed_out, response);      
        end


    static task CDU_RF_model(input reset,
                             input [1:0] command,
                             input [79:0] data_in,
                             input [7:0] compressed_in,
                             output logic [7:0] compressed_out,
                             output logic [79:0] decompressed_out,
                             output logic [1:0] response);
        // Internal memory (dictionary memory)
        logic [256][79:0] dictionary;
        logic [31:0] index_reg;
        logic [7:0] compressed_data;
        logic [1:0] response_data; 
        logic [79:0] decompressed_data;   

        if(reset)begin
            for (int i=0; i<256; ++i)begin
                
                dictionary[i]=0;
            end
            response_data = 0;
            compressed_data = 0;
            decompressed_data = 0;
            index_reg = 0;
        end
        
      // Compression and Decompression logic
        case (command)
            2'b01: begin // no op
                response_data = 0;
            end
            2'b01: begin // Compression
                for (int i = 0; i < 256; i++) begin
                    if (dictionary[i] == data_in) begin
                        compressed_data = i;
                        response_data = 2'b01; // Valid compressed_out
                        break;
                    end
                end
                if (response_data != 2'b01) begin
                    dictionary[index_reg] = data_in;
                    compressed_data = index_reg;
                    index_reg ++;
                    response_data = 2'b01; // Valid compressed_out
                end
                if (index_reg == 256) begin
                    response_data = 2'b11; // Error
                end
            end
            2'b10: begin // Decompression
                if (compressed_in <= index_reg) begin
                    decompressed_data = dictionary[compressed_in];
                    response_data = 2'b10; // Valid decompressed_out
                end else begin
                    response_data = 2'b11; // Error
                end
            end
            default: begin
                response_data = 2'b11; // Error
            end
            endcase
        
        // Assign outputs
        response = response_data;
        compressed_out = compressed_data;
        decompressed_out = decompressed_data;
        response_data=0;
        compressed_data=0;
        decompressed_data=0;
        endtask
endmodule



