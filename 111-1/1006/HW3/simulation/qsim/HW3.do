onerror {quit -f}
vlib work
vlog -work work HW3.vo
vlog -work work HW3.vt
vsim -novopt -c -t 1ps -L cycloneiv_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.HW3_vlg_vec_tst
vcd file -direction HW3.msim.vcd
vcd add -internal HW3_vlg_vec_tst/*
vcd add -internal HW3_vlg_vec_tst/i1/*
add wave /*
run -all
