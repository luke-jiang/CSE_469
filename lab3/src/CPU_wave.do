onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /CPU_testbench/dut/clk
add wave -noupdate /CPU_testbench/dut/reset
add wave -noupdate /CPU_testbench/dut/address
add wave -noupdate /CPU_testbench/dut/instruction
add wave -noupdate /CPU_testbench/dut/cntrl
add wave -noupdate /CPU_testbench/dut/Imm9
add wave -noupdate /CPU_testbench/dut/Imm12
add wave -noupdate -radix decimal /CPU_testbench/dut/Imm19
add wave -noupdate /CPU_testbench/dut/Imm26
add wave -noupdate -radix unsigned /CPU_testbench/dut/Rn
add wave -noupdate -radix unsigned /CPU_testbench/dut/Rd
add wave -noupdate /CPU_testbench/dut/WriteData
add wave -noupdate /CPU_testbench/dut/ReadData1
add wave -noupdate /CPU_testbench/dut/regfi/ReadData2
add wave -noupdate -radix decimal /CPU_testbench/dut/regfi/registerOut
add wave -noupdate /CPU_testbench/dut/ALUSrcMux_out
add wave -noupdate /CPU_testbench/dut/ALU_out
add wave -noupdate /CPU_testbench/dut/regfIn
add wave -noupdate /CPU_testbench/dut/regfOut
add wave -noupdate /CPU_testbench/dut/lessThanF
add wave -noupdate /CPU_testbench/dut/branchAdder_out
add wave -noupdate /CPU_testbench/dut/BrTakenMux_out
add wave -noupdate /CPU_testbench/dut/LS2_out
add wave -noupdate /CPU_testbench/dut/CondBrMux_out
add wave -noupdate /CPU_testbench/dut/datam/mem
add wave -noupdate /CPU_testbench/dut/DataMem_out
add wave -noupdate /CPU_testbench/dut/datam/address
add wave -noupdate /CPU_testbench/dut/datam/write_data
add wave -noupdate /CPU_testbench/dut/datam/read_data
add wave -noupdate /CPU_testbench/dut/datam/write_enable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {183669517 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {488250 ns}
