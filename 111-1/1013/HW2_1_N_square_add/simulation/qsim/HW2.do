onerror {quit -f}
vlib work
vlog -work work HW2.vo
vlog -work work HW2.vt
vsim -novopt -c -t 1ps -L cycloneiv_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.HW2_vlg_vec_tst
vcd file -direction HW2.msim.vcd
vcd add -internal HW2_vlg_vec_tst/*
vcd add -internal HW2_vlg_vec_tst/i1/*
add wave /*
run -all
