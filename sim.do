if {[file isdirectory work]} { vdel -all -lib work }
vlib work
vmap work work

vcom -work work comp.vhd
vcom -work work tp3.vhd
vcom -work work tb.vhd

vsim -voptargs=+acc=lprn -t ns work.tb

set StdArithNoWarnings 1
set StdVitalGlitchNoWarnings 1

do wave.do 
add wave -divider comp_dado_a
add wave sim:/tb/DUT/comp_dado_a/*
add wave -divider comp_dado_b
add wave sim:/tb/DUT/comp_dado_b/*
add wave -divider comp_dado_c
add wave sim:/tb/DUT/comp_dado_c/*
add wave -divider comp_dado_d
add wave sim:/tb/DUT/comp_dado_d/*

run 1800 ns