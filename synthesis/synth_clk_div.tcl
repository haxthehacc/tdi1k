set_db init_lib_search_path /home/cmos/fifo/scl180/stdcell/fs120/4M1IL/liberty/lib_flow_ss
set_db init_hdl_search_path /home/cmos/projects/tdi1k/scripts

read_libs {tsl18fs120_scl_ss.lib}
read_hdl clk_divider.v
elaborate clk_divider

create_clock -name clk_50m -period 20 [get_ports clk_50m]
set_output_delay 2 -clock clk_50m [all_outputs]

syn_generic
syn_map
syn_opt

report_timing > /home/cmos/projects/tdi1k/reports/clk_div_timing.rpt
report_area   > /home/cmos/projects/tdi1k/reports/clk_div_area.rpt

write_hdl > /home/cmos/projects/tdi1k/scripts/clk_divider_netlist.v
write_sdc > /home/cmos/projects/tdi1k/scripts/clk_divider.sdc

puts "clk_divider synthesis complete."
