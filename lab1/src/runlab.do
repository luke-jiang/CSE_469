# CSE 469
# Lab 1
# Chen Bai, Luke Jiang
# 10/05/2018

# This is the runlab.do script file for running ModelSim simulation.

# Create work library
vlib work

# Compile Verilog
vlog "./regfile.sv"
vlog "./register.sv"
vlog "./enable_D_FF.sv"
vlog "./D_FF.sv"
vlog "./mux32_1.sv"
vlog "./mux16_1.sv"
vlog "./mux4_1.sv"
vlog "./mux2_1.sv"
vlog "./decoder5x32.sv"
vlog "./decoder4x16.sv"
vlog "./decoder2x4.sv"
vlog "./decoder1x2.sv"

# Call vsim to invoke simulator
vsim -voptargs="+acc" -t 1ps -lib work regstim

# Source the wave do file
do regfile_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all
