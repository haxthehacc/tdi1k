# Genus synthesis script — row_sequencer
# SCL 180nm fs120 standard cell library

set_db init_lib_search_path /home/cmos/fifo/scl180/stdcell/fs120/4M1IL/liberty/lib_flow_ss
set_db init_hdl_search_path /home/cmos/projects/tdi1k/scripts

# Load liberty
read_libs {tsl18fs120_scl_ss.lib}

# Read RTL
read_hdl row_sequencer.v

# Elaborate
elaborate row_sequencer

# Constraints
create_clock -name clk -period 20 [get_ports clk]
set_input_delay  2 -clock clk [all_inputs]
set_output_delay 2 -clock clk [all_outputs]

# Synthesize
syn_generic
syn_map
syn_opt

# Reports
report_timing > /home/cmos/projects/tdi1k/reports/row_seq_timing.rpt
report_area   > /home/cmos/projects/tdi1k/reports/row_seq_area.rpt

# Export netlist
write_hdl > /home/cmos/projects/tdi1k/scripts/row_sequencer_netlist.v
write_sdc > /home/cmos/projects/tdi1k/scripts/row_sequencer.sdc

puts "Synthesis complete."
