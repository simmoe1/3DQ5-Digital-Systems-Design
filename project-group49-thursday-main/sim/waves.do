# activate waveform simulation

view wave

# format signal names in waveform

configure wave -signalnamewidth 1
configure wave -timeline 0
configure wave -timelineunits us

# add signals to waveform

add wave -divider -height 20 {Top-level signals}
add wave -bin UUT/CLOCK_50_I
add wave -bin UUT/resetn
add wave UUT/top_state
add wave -uns UUT/UART_timer

add wave -divider -height 10 {SRAM signals}
add wave -uns UUT/SRAM_address
add wave -hex UUT/SRAM_write_data
add wave -bin UUT/SRAM_we_n
add wave -hex UUT/SRAM_read_data

add wave -divider -height 10 {u}
add wave -hex UUT/m1_unit/Uj5
add wave -hex UUT/m1_unit/Uj3
add wave -hex UUT/m1_unit/Uj1
add wave -hex UUT/m1_unit/Ujn1
add wave -hex UUT/m1_unit/Ujn3
add wave -hex UUT/m1_unit/Ujn5

#add wave -divider -height 10 {multiplier}
#add wave -hex UUT/m1_unit/oper1
#add wave -hex UUT/m1_unit/oper2
#add wave -hex UUT/m1_unit/oper3
#add wave -hex UUT/m1_unit/oper4
#add wave -hex UUT/m1_unit/multiplier1
#add wave -hex UUT/m1_unit/multiplier2

add wave -divider -height 10 {M1 signals}
add wave UUT/m1_unit/milestone1_state
add wave -hex UUT/m1_unit/r_odd
add wave -hex UUT/m1_unit/g_odd
add wave -hex UUT/m1_unit/b_odd
add wave -hex UUT/m1_unit/r_even
add wave -hex UUT/m1_unit/g_even
add wave -hex UUT/m1_unit/b_even

