#!/bin/bash

# Check if a file name is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file_name>"
    exit 1
fi

# Compile the Verilog code using VCS
vcs -full64 -sverilog -ntb_opts uvm-1.2 +vcs+lic+wait +vcs+flush+all -kdb +error+5000 -lca -debug_access+all $1
#-cov -fsa -b -line
# Run the simulation with VCD output

./simv -vcd -cov+fsa+b+line +UVM_NO_RELNOTES +UVM_VERBOSITY=UVM_HIGH

urg -dir simv.vdb -report report
# verdi -cov -covdir simv.vdb &