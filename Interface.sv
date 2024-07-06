interface CDU_Interface(input clk,reset);
   logic [ 1:0] command;
   logic [79:0] data_in;
   logic [ 7:0] compressed_in;
   logic [ 7:0] compressed_out;
   logic [79:0] decompressed_out;
   logic [ 1:0] response;

   clocking driver_cb @(posedge clk);
      default input #2 ;
      output command;
      output data_in;
      output compressed_in;
      endclocking

   clocking monitor_cb @(posedge clk);
      default input #0 output #2;
      input compressed_out;
      input decompressed_out;
      input response;
      endclocking
endinterface