`include "uvm_macros.svh"
import uvm_pkg::*;
`include "Interface.sv"
`include "Test.sv"
`include "compression_decompression.sv"
module CDU_TestBench;
    bit clk;
    bit reset;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;
        #1;
        reset = 1;
        #1;
        reset = 0;
        end

    CDU_Interface vif(clk,reset);
    compression_decompression DUT (
        .clk(clk),
        .reset(reset),
        .command(vif.command),
        .compressed_in(vif.compressed_in),
        .data_in(vif.data_in),
        .compressed_out(vif.compressed_out),
        .response(vif.response),
        .decompressed_out(vif.decompressed_out)
    );
    initial begin
        // set interface in config_db
        uvm_config_db#(virtual CDU_Interface)::set(uvm_root::get(), "*", "vif", vif);
        
    end

    initial begin
        run_test("CDU_Regression_Test");
    end

  initial begin
    $fsdbDumpfile("debug.fsdb");
    $fsdbDumpvars;
    $fsdbDumpvars("+mda");
    $fsdbDumpvars("+struct");
    $fsdbDumpvars("+all");
    $fsdbDumpon;
  end
endmodule