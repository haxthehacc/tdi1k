# =============================================================================
# Genus synthesis script - clk_divider_v2
# SCL 180nm fs120 standard cell library
#
# Usage (on the synth host where Genus + SCL180 .lib live):
#   cd <repo>/synthesis
#   genus -files synth_clk_div_v2.tcl -log genus_clk_div_v2.log
#
# Adjust the two paths below for your host if necessary.
# =============================================================================

# ---- Paths (edit for your host) --------------------------------------------
set REPO_ROOT  [file normalize [file dirname [info script]]/..]
set RTL_DIR    $REPO_ROOT/rtl
set REPORT_DIR $REPO_ROOT/reports
set OUT_DIR    $REPO_ROOT/synthesis

# SCL180 stdcell Liberty (slow-slow corner)
set SCL_LIB_DIR /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ss
set SCL_LIB     tsl18fs120_scl_ss.lib

set_db init_lib_search_path $SCL_LIB_DIR
set_db init_hdl_search_path $RTL_DIR

# ---- Read library and RTL --------------------------------------------------
read_libs [list $SCL_LIB]
read_hdl  clk_divider_v2.v
elaborate clk_divider_v2

# ---- Constraints -----------------------------------------------------------
# 50 MHz primary clock
create_clock -name clk_50m -period 20.0 [get_ports clk_50m]

# Clock uncertainty (jitter + margin) - the original script set NONE.
set_clock_uncertainty -setup 0.5 [get_clocks clk_50m]
set_clock_uncertainty -hold  0.1 [get_clocks clk_50m]

# Input/output delay budgets
set_input_delay  2.0 -clock clk_50m [get_ports rst_n]
set_output_delay 2.0 -clock clk_50m [get_ports clk_line]
set_output_delay 2.0 -clock clk_50m [get_ports clk_line_pulse]

# Realistic external loading (no pads in this block)
set_load 0.05 [all_outputs]

# Design rules
set_max_transition 1.5 [current_design]
set_max_fanout     16  [current_design]

# Don't use these scan/clock-buffer cells in functional path
set_dont_use [get_lib_cells tsl18fs120_scl_ss/slbhb1]
set_dont_use [get_lib_cells tsl18fs120_scl_ss/slbhb2]
set_dont_use [get_lib_cells tsl18fs120_scl_ss/slbhb4]

# Synchronizer chains - keep them as flop-by-flop, no merge/optimize across.
set_dont_touch [get_cells -hier -filter "name =~ *rst_sync_meta*"]
set_dont_touch [get_cells -hier -filter "name =~ *rst_n_sync*"]

# ---- Synthesize ------------------------------------------------------------
syn_generic
syn_map
syn_opt

# ---- Reports ---------------------------------------------------------------
file mkdir $REPORT_DIR
report_timing      > $REPORT_DIR/clk_div_v2_timing.rpt
report_area        > $REPORT_DIR/clk_div_v2_area.rpt
report_power       > $REPORT_DIR/clk_div_v2_power.rpt
report_gates       > $REPORT_DIR/clk_div_v2_gates.rpt
report_clock_gating > $REPORT_DIR/clk_div_v2_clock_gating.rpt
check_design -all  > $REPORT_DIR/clk_div_v2_check.rpt

# ---- Outputs ---------------------------------------------------------------
write_hdl > $OUT_DIR/clk_divider_v2_netlist.v
write_sdc > $OUT_DIR/clk_divider_v2.sdc
write_db  $OUT_DIR/clk_divider_v2.db

puts "clk_divider_v2 synthesis complete."
