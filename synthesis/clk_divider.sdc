# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Wed Apr 29 13:21:36 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design clk_divider

create_clock -name "clk_50m" -period 20.0 -waveform {0.0 10.0} [get_ports clk_50m]
set_clock_gating_check -setup 0.0 
set_output_delay -clock [get_clocks clk_50m] -add_delay 2.0 [get_ports clk_line]
set_output_delay -clock [get_clocks clk_50m] -add_delay 2.0 [get_ports clk_line_pulse]
set_wire_load_mode "enclosed"
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb2]
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb1]
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb4]
