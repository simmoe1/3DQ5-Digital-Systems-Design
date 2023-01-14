onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 20 {Top-level signals}
add wave -noupdate -radix binary /TB/UUT/CLOCK_50_I
add wave -noupdate -radix binary /TB/UUT/resetn
add wave -noupdate /TB/UUT/top_state
add wave -noupdate -radix unsigned /TB/UUT/UART_timer
add wave -noupdate -divider -height 10 {SRAM signals}
add wave -noupdate -radix hexadecimal /TB/UUT/SRAM_address
add wave -noupdate -radix hexadecimal /TB/UUT/SRAM_write_data
add wave -noupdate -radix hexadecimal /TB/UUT/SRAM_we_n
add wave -noupdate -radix hexadecimal /TB/UUT/SRAM_read_data
add wave -noupdate -radix hexadecimal -childformat {{{/TB/UUT/m1_unit/Uj5[7]} -radix decimal} {{/TB/UUT/m1_unit/Uj5[6]} -radix decimal} {{/TB/UUT/m1_unit/Uj5[5]} -radix decimal} {{/TB/UUT/m1_unit/Uj5[4]} -radix decimal} {{/TB/UUT/m1_unit/Uj5[3]} -radix decimal} {{/TB/UUT/m1_unit/Uj5[2]} -radix decimal} {{/TB/UUT/m1_unit/Uj5[1]} -radix decimal} {{/TB/UUT/m1_unit/Uj5[0]} -radix decimal}} -subitemconfig {{/TB/UUT/m1_unit/Uj5[7]} {-height 15 -radix decimal} {/TB/UUT/m1_unit/Uj5[6]} {-height 15 -radix decimal} {/TB/UUT/m1_unit/Uj5[5]} {-height 15 -radix decimal} {/TB/UUT/m1_unit/Uj5[4]} {-height 15 -radix decimal} {/TB/UUT/m1_unit/Uj5[3]} {-height 15 -radix decimal} {/TB/UUT/m1_unit/Uj5[2]} {-height 15 -radix decimal} {/TB/UUT/m1_unit/Uj5[1]} {-height 15 -radix decimal} {/TB/UUT/m1_unit/Uj5[0]} {-height 15 -radix decimal}} /TB/UUT/m1_unit/Uj5
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/Uj3
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/Uj1
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/Ujn1
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/Ujn3
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/Ujn5
add wave -noupdate -divider -height 10 {M1 signals}
add wave -noupdate /TB/UUT/m1_unit/milestone1_state
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/R_ODD
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/G_ODD
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/B_ODD
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/R_EVEN
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/G_EVEN
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/B_EVEN
add wave -noupdate -radix hexadecimal -childformat {{{/TB/UUT/m1_unit/U_prime[31]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[30]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[29]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[28]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[27]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[26]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[25]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[24]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[23]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[22]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[21]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[20]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[19]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[18]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[17]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[16]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[15]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[14]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[13]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[12]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[11]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[10]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[9]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[8]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[7]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[6]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[5]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[4]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[3]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[2]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[1]} -radix hexadecimal} {{/TB/UUT/m1_unit/U_prime[0]} -radix hexadecimal}} -subitemconfig {{/TB/UUT/m1_unit/U_prime[31]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[30]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[29]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[28]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[27]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[26]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[25]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[24]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[23]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[22]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[21]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[20]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[19]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[18]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[17]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[16]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[15]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[14]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[13]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[12]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[11]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[10]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[9]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[8]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[7]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[6]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[5]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[4]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[3]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[2]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[1]} {-radix hexadecimal} {/TB/UUT/m1_unit/U_prime[0]} {-radix hexadecimal}} /TB/UUT/m1_unit/U_prime
add wave -noupdate -radix hexadecimal -childformat {{{/TB/UUT/m1_unit/mult1[31]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[30]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[29]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[28]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[27]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[26]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[25]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[24]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[23]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[22]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[21]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[20]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[19]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[18]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[17]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[16]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[15]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[14]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[13]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[12]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[11]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[10]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[9]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[8]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[7]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[6]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[5]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[4]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[3]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[2]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[1]} -radix hexadecimal} {{/TB/UUT/m1_unit/mult1[0]} -radix hexadecimal}} -subitemconfig {{/TB/UUT/m1_unit/mult1[31]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[30]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[29]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[28]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[27]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[26]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[25]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[24]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[23]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[22]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[21]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[20]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[19]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[18]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[17]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[16]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[15]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[14]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[13]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[12]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[11]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[10]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[9]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[8]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[7]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[6]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[5]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[4]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[3]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[2]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[1]} {-radix hexadecimal} {/TB/UUT/m1_unit/mult1[0]} {-radix hexadecimal}} /TB/UUT/m1_unit/mult1
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/op2
add wave -noupdate -radix decimal /TB/UUT/m1_unit/op1
add wave -noupdate -radix hexadecimal /TB/UUT/m1_unit/op4
add wave -noupdate -radix decimal /TB/UUT/m1_unit/op3
add wave -noupdate /TB/UUT/m1_unit/op4
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {824100 ps} 0}
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
configure wave -timelineunits us
update
WaveRestoreZoom {686800 ps} {910800 ps}
