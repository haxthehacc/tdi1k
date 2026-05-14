# MMMC for clk_divider_v2 - SS setup, FF hold
set REPO /home/cmos/projects/tdi1k_repo
set PDK  /home/cmos/fifo/scl180/stdcell/fs120/4M1IL

create_library_set -name lib_ss -timing [list $PDK/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib]
create_library_set -name lib_ff -timing [list $PDK/liberty/lib_flow_ff/tsl18fs120_scl_ff.lib]

create_constraint_mode -name func -sdc_files [list $REPO/synthesis/clk_divider_v2_pnr.sdc]

create_delay_corner -name dc_ss -library_set lib_ss
create_delay_corner -name dc_ff -library_set lib_ff

create_analysis_view -name av_ss -constraint_mode func -delay_corner dc_ss
create_analysis_view -name av_ff -constraint_mode func -delay_corner dc_ff

set_analysis_view -setup {av_ss} -hold {av_ff}
