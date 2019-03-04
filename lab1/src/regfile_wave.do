onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /regstim/dut/clk
add wave -noupdate /regstim/dut/ReadRegister1
add wave -noupdate /regstim/dut/ReadRegister2
add wave -noupdate /regstim/dut/WriteRegister
add wave -noupdate /regstim/dut/WriteData
add wave -noupdate /regstim/dut/RegWrite
add wave -noupdate /regstim/dut/ReadData1
add wave -noupdate /regstim/dut/ReadData2
add wave -noupdate /regstim/dut/decoderOut
add wave -noupdate -expand /regstim/dut/registerOut
add wave -noupdate /regstim/dut/muxIn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {217500000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 164
configure wave -valuecolwidth 111
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
WaveRestoreZoom {0 ps} {460272618 ps}
