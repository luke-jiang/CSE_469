# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "./CPU.sv"
vlog "./regfile.sv"
vlog "./datamem.sv"
vlog "./instructmem.sv"
vlog "./PC.sv"
vlog "./math.sv"
vlog "./ifZero64.sv"
vlog "./fullAdder.sv"
vlog "./fullAdderSel.sv"
vlog "./bitALU.sv"
vlog "./alu.sv"
vlog "./regflag.sv"
vlog "./enable_D_FF.sv"
vlog "./D_FF.sv"
vlog "./register.sv"
vlog "./mux16_1.sv"
vlog "./mux2_1.sv"
vlog "./mux64x4_1.sv"
vlog "./mux64x2_1.sv"
vlog "./mux32_1.sv"
vlog "./mux5x2_1.sv"
vlog "./mux4_1.sv"
vlog "./decoder5x32.sv"
vlog "./decoder4x16.sv"
vlog "./decoder1x2.sv"
vlog "./decoder2x4.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work CPU_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do CPU_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
