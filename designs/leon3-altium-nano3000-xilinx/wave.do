onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/cpu/clkm
add wave -noupdate /testbench/cpu/bus_a
add wave -noupdate /testbench/cpu/bus_d
add wave -noupdate /testbench/cpu/bus_flash_nbusy
add wave -noupdate /testbench/cpu/bus_flash_ncs
add wave -noupdate /testbench/cpu/bus_flash_nreset
add wave -noupdate /testbench/cpu/bus_nbe
add wave -noupdate /testbench/cpu/bus_noe
add wave -noupdate /testbench/cpu/bus_nwe
add wave -noupdate /testbench/cpu/bus_sdram_cke
add wave -noupdate /testbench/cpu/bus_sdram_clk
add wave -noupdate /testbench/cpu/bus_sdram_feedback
add wave -noupdate /testbench/cpu/bus_sdram_ncas
add wave -noupdate /testbench/cpu/bus_sdram_ncs
add wave -noupdate /testbench/cpu/bus_sdram_nras
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {177000000 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {135074058 ps} {142075050 ps}
