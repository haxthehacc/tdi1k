#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Thu May 14 06:52:38 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v21.15-s110_1 (64bit) 09/23/2022 13:08 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.15-s110_1 NR220912-2004/21_15-UB (database version 18.20.592) {superthreading v2.17}
#@(#)CDS: AAE 21.15-s039 (64bit) 09/23/2022 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.15-s038_1 () Sep 20 2022 11:42:13 ( )
#@(#)CDS: SYNTECH 21.15-s012_1 () Sep  5 2022 10:25:51 ( )
#@(#)CDS: CPE v21.15-s076
#@(#)CDS: IQuantus/TQuantus 21.1.1-s867 (64bit) Sun Jun 26 22:12:54 PDT 2022 (Linux 3.10.0-693.el7.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
set init_lef_file {/home/cmos/fifo/scl180/stdcell/fs120/4M1IL/lef/scl18fs120_tech.lef /home/cmos/fifo/scl180/stdcell/fs120/4M1IL/lef/scl18fs120_std.lef}
set init_mmmc_file /home/cmos/projects/tdi1k_repo/pnr/mmmc_row_sequencer_v2.tcl
set init_verilog /home/cmos/projects/tdi1k_repo/synthesis/row_sequencer_v2_netlist.v
set init_top_cell row_sequencer_v2
set init_pwr_net VDD
set init_gnd_net VSS
set init_ignore_pgpin_polarity_check 1
suppressMessage TCLCMD-513
suppressMessage TCLCMD-917
init_design
setDesignMode -process 180
setAnalysisMode -analysisType onChipVariation
addNet -power VDD
addNet -ground VSS
globalNetConnect VDD -type pgpin -pin VDD -inst * -override
globalNetConnect VSS -type pgpin -pin VSS -inst * -override
floorPlan -site CoreSite -r 0.45 0.7 5.0 10.0 5.0 10.0
setPinAssignMode -pinEditInBatch true
editPin -pin {clk rst_n tdi_enable} -side LEFT -layer M3 -spreadType SIDE
editPin -pin {TX RST SEL line_done frame_done} -side RIGHT -layer M3 -spreadType SIDE
setPinAssignMode -pinEditInBatch false
addRing -nets {VDD VSS} -width 3.0 -spacing 0.6 -layer {top M4 bottom M4 left M3 right M3} -offset 1.0
addStripe -nets {VDD VSS} -layer M5 -direction vertical -width 1.5 -spacing 1.0 -set_to_set_distance 30 -start_from left
sroute -connect {corePin floatingStripe} -nets {VDD VSS}
setPlaceMode -place_global_clock_gate_aware true
place_opt_design
create_ccopt_clock_tree_spec
ccopt_design
setNanoRouteMode -routeWithTimingDriven true
setAttribute -net clk -shield_net VSS
route_opt_design
addFiller -cell {feedth decrq4 decrq2 decrq1 decfq4 decfq2 decfq1} -prefix FILL
report_timing                                 > $RPT/row_seq_v2_pnr_timing_setup.rpt
report_timing -early                          > $RPT/row_seq_v2_pnr_timing_hold.rpt
report_area > /home/cmos/projects/tdi1k_repo/reports/row_seq_v2_pnr_area.rpt
report_power > /home/cmos/projects/tdi1k_repo/reports/row_seq_v2_pnr_power.rpt
verify_drc -report /home/cmos/projects/tdi1k_repo/reports/row_seq_v2_pnr_drc.rpt
verify_connectivity -report /home/cmos/projects/tdi1k_repo/reports/row_seq_v2_pnr_conn.rpt
saveDesign /home/cmos/projects/tdi1k_repo/pnr/work_row_seq_v2/row_sequencer_v2_pnr.enc
defOut /home/cmos/projects/tdi1k_repo/pnr/work_row_seq_v2/row_sequencer_v2.def
streamOut /home/cmos/projects/tdi1k_repo/pnr/work_row_seq_v2/row_sequencer_v2.gds -merge /home/cmos/fifo/scl180/stdcell/fs120/4M1IL/gds/scl18fs120.gds
write_sdf  $OUT/row_sequencer_v2.sdf
extractRC
rcOut -spef /home/cmos/projects/tdi1k_repo/pnr/work_row_seq_v2/row_sequencer_v2.spef
saveNetlist /home/cmos/projects/tdi1k_repo/pnr/work_row_seq_v2/row_sequencer_v2_pnr_netlist.v
