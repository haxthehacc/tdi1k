# =============================================================================
# Genus synthesis script - row_sequencer_v2
# SCL 180nm fs120 standard cell library
#
# Usage (on the synth host where Genus + SCL180 .lib live):
#   cd <repo>/synthesis
#   genus -files synth_row_seq_v2.tcl -log genus_row_seq_v2.log
# =============================================================================

# ---- Paths -----------------------------------------------------------------
set REPO_ROOT  [file normalize [file dirname [info script]]/..]
set RTL_DIR    $REPO_ROOT/rtl
set REPORT_DIR $REPO_ROOT/reports
set OUT_DIR    $REPO_ROOT/synthesis

set SCL_LIB_DIR /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ss
set SCL_LIB     tsl18fs120_scl_ss.lib

set_db init_lib_search_path $SCL_LIB_DIR
set_db init_hdl_search_path $RTL_DIR

# ---- Read library and RTL --------------------------------------------------
read_libs [list $SCL_LIB]
read_hdl  row_sequencer_v2.v
elaborate row_sequencer_v2

# ---- Constraints -----------------------------------------------------------
# 50 MHz - same as clk_divider
create_clock -name clk -period 20.0 [get_ports clk]

# Clock uncertainty
set_clock_uncertainty -setup 0.5 [get_clocks clk]
set_clock_uncertainty -hold  0.1 [get_clocks clk]

# Inputs (sync to clk)
# rst_n and tdi_enable are async in the design (synchronizers are inside the
# RTL); declare false_path on their first stage to avoid bogus setup violations.
set_input_delay 2.0 -clock clk [get_ports tdi_enable]
set_input_delay 2.0 -clock clk [get_ports rst_n]

# Block timing checks across the rst_n / tdi_enable synchronizer first stage.
# (After the 2-FF chain inside the RTL, normal STA applies again.)
set_false_path -from [get_ports rst_n]
set_false_path -from [get_ports tdi_enable]

# Outputs - load all 60 RST/TX/SEL plus line_done / frame_done
set_output_delay 2.0 -clock clk [get_ports {RST[*]}]
set_output_delay 2.0 -clock clk [get_ports {TX[*]}]
set_output_delay 2.0 -clock clk [get_ports {SEL[*]}]
set_output_delay 2.0 -clock clk [get_ports line_done]
set_output_delay 2.0 -clock clk [get_ports frame_done]

# Loading
set_load 0.05 [all_outputs]

# Design rules
set_max_transition 1.5 [current_design]
set_max_fanout     16  [current_design]

# Cells to avoid
set_dont_use [get_lib_cells tsl18fs120_scl_ss/slbhb1]
set_dont_use [get_lib_cells tsl18fs120_scl_ss/slbhb2]
set_dont_use [get_lib_cells tsl18fs120_scl_ss/slbhb4]

# Synchronizers - keep intact
set_dont_touch [get_cells -hier -filter "name =~ *rst_meta*"]
set_dont_touch [get_cells -hier -filter "name =~ *rst_n_s*"]
set_dont_touch [get_cells -hier -filter "name =~ *en_meta*"]
set_dont_touch [get_cells -hier -filter "name =~ *tdi_en_s*"]

# ---- Synthesize ------------------------------------------------------------
syn_generic
syn_map
syn_opt

# ---- Reports ---------------------------------------------------------------
file mkdir $REPORT_DIR
report_timing      > $REPORT_DIR/row_seq_v2_timing.rpt
report_area        > $REPORT_DIR/row_seq_v2_area.rpt
report_power       > $REPORT_DIR/row_seq_v2_power.rpt
report_gates       > $REPORT_DIR/row_seq_v2_gates.rpt
check_design -all  > $REPORT_DIR/row_seq_v2_check.rpt

# Hold-corner report (need fast-fast .lib loaded with read_libs in MMMC; skip
# here if only one corner is loaded. PNR will do hold).

# ---- Outputs ---------------------------------------------------------------
write_hdl > $OUT_DIR/row_sequencer_v2_netlist.v
write_sdc > $OUT_DIR/row_sequencer_v2.sdc
write_db  $OUT_DIR/row_sequencer_v2.db

puts "row_sequencer_v2 synthesis complete."
