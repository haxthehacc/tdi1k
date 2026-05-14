# ####################################################################

#  Created by Genus(TM) Synthesis Solution 22.15-s086_1 on Wed May 06 19:22:47 CEST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design clk_divider_v2

create_clock -name "clk_50m" -period 20.0 -waveform {0.0 10.0} [get_ports clk_50m]
set_load -pin_load 0.05 [get_ports clk_line]
set_load -pin_load 0.05 [get_ports clk_line_pulse]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk_50m] -add_delay 2.0 [get_ports rst_n]
set_output_delay -clock [get_clocks clk_50m] -add_delay 2.0 [get_ports clk_line]
set_output_delay -clock [get_clocks clk_50m] -add_delay 2.0 [get_ports clk_line_pulse]
set_max_fanout 16.000 [current_design]
set_max_transition 1.5 [current_design]
set_wire_load_mode "enclosed"
set_clock_uncertainty -setup 0.5 [get_clocks clk_50m]
set_clock_uncertainty -hold 0.1 [get_clocks clk_50m]
