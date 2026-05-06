set init_lef_file {/home/cmos/fifo/scl180/stdcell/fs120/4M1IL/lef/scl18fs120_tech.lef /home/cmos/fifo/scl180/stdcell/fs120/4M1IL/lef/scl18fs120_std.lef}
set init_mmmc_file /home/cmos/projects/tdi1k/innovus/clk_divider/mmmc.tcl
set init_verilog /home/cmos/projects/tdi1k/scripts/clk_divider_netlist.v
set init_top_cell clk_divider
set init_power_nets VDD
set init_ground_nets VSS
init_design
setDesignMode -process 180
floorPlan -su 1.0 0.65 5.0 5.0 5.0 5.0
globalNetConnect VDD -type pgpin -pin VDD -inst * -override
globalNetConnect VSS -type pgpin -pin VSS -inst * -override
addRing -nets {VDD VSS} -width 2.0 -spacing 0.5 -layer {top M4 bottom M4 left M3 right M3}
sroute -connect corePin -nets {VDD VSS}
place_design
optDesign -preCTS
routeDesign
addFiller -cell {feedth decrq4 decrq2 decrq1 decfq4 decfq2 decfq1} -prefix FILL
report_timing > /home/cmos/projects/tdi1k/reports/clk_div_pnr_timing.rpt
report_area   > /home/cmos/projects/tdi1k/reports/clk_div_pnr_area.rpt
streamOut /home/cmos/projects/tdi1k/clk_divider.gds \
  -merge {/home/cmos/fifo/scl180/stdcell/fs120/4M1IL/gds/scl18fs120.gds}
puts "clk_divider P&R complete."
