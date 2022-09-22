onerror {quit -f}
vlib work
vlog -work work HW1_CSA.vo
vlog -work work HW1_CSA.vt
vsim -novopt -c -t 1ps -L cycloneiv_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.HW1_CSA_vlg_vec_tst
vcd file -direction HW1_CSA.msim.vcd
vcd add -internal HW1_CSA_vlg_vec_tst/*
vcd add -internal HW1_CSA_vlg_vec_tst/i1/*
add wave /*
run -all
