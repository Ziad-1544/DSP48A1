vlib work
vlog  Desgin.v test_bench_3.v Paramtrized_mux.v 
vsim -voptargs=+acc work.DSP48A1_tb
add wave -position insertpoint  \
sim:/DSP48A1_tb/CLK \
sim:/DSP48A1_tb/OPMODE \
sim:/DSP48A1_tb/DUT/OPMODE_REG/OUT \
sim:/DSP48A1_tb/D \
sim:/DSP48A1_tb/DUT/D_REG/OUT \
sim:/DSP48A1_tb/B \
sim:/DSP48A1_tb/BCIN \
sim:/DSP48A1_tb/DUT/B0_REG/OUT \
sim:/DSP48A1_tb/A \
sim:/DSP48A1_tb/DUT/A0_REG/OUT \
sim:/DSP48A1_tb/C \
sim:/DSP48A1_tb/DUT/C_REG/OUT \
sim:/DSP48A1_tb/DUT/pre_add_sub_mux_out \
sim:/DSP48A1_tb/DUT/pre_add_sub_out \
sim:/DSP48A1_tb/DUT/B1_REG/OUT \
sim:/DSP48A1_tb/BCOUT_tb \
sim:/DSP48A1_tb/DUT/A1_REG/OUT \
sim:/DSP48A1_tb/CARRYIN \
sim:/DSP48A1_tb/DUT/CYI_REG/OUT \
sim:/DSP48A1_tb/DUT/M_REG/OUT \
sim:/DSP48A1_tb/M_tb \
sim:/DSP48A1_tb/PCIN \
sim:/DSP48A1_tb/DUT/X_mux_out \
sim:/DSP48A1_tb/DUT/Z_mux_out \
sim:/DSP48A1_tb/DUT/post_add_sub_out \
sim:/DSP48A1_tb/DUT/post_add_sub_out_COUT \
sim:/DSP48A1_tb/DUT/P_REG/OUT \
sim:/DSP48A1_tb/P_tb \
sim:/DSP48A1_tb/PCOUT_tb \
sim:/DSP48A1_tb/DUT/CARRY_REG/OUT \
sim:/DSP48A1_tb/CARRYOUT_tb \
sim:/DSP48A1_tb/CARRYOUTF_tb 
run -all