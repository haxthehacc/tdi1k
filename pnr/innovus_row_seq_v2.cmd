#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Wed May  6 20:22:58 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v22.35-s091_1 (64bit) 02/28/2024 12:25 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 22.35-s091_1 NR240223-1321/22_15-UB (database version 18.20.620_1) {superthreading v2.20}
#@(#)CDS: AAE 22.15-s036 (64bit) 02/28/2024 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 22.15-s037_1 () Feb 28 2024 01:27:33 ( )
#@(#)CDS: SYNTECH 22.15-s014_1 () Feb 13 2024 19:37:21 ( )
#@(#)CDS: CPE v22.15-s064
#@(#)CDS: IQuantus/TQuantus 21.2.2-s347 (64bit) Mon Dec 11 17:11:11 PST 2023 (Linux 3.10.0-693.el7.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
set init_lef_file {/home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/scl180/stdcell/fs120/6M1L/lef/scl18fs120_tech.lef /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/scl180/stdcell/fs120/6M1L/lef/scl18fs120_std.lef}
set init_mmmc_file /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/tdi1k/pnr/mmmc_row_sequencer_v2.tcl
set init_verilog /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/tdi1k/synthesis/row_sequencer_v2_netlist.v
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
report_area > /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/tdi1k/reports/row_seq_v2_pnr_area.rpt
report_power > /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/tdi1k/reports/row_seq_v2_pnr_power.rpt
verify_drc -report /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/tdi1k/reports/row_seq_v2_pnr_drc.rpt
verify_connectivity -report /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/tdi1k/reports/row_seq_v2_pnr_conn.rpt
saveDesign /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/tdi1k/pnr/work_row_seq_v2/row_sequencer_v2_pnr.enc
defOut /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/tdi1k/pnr/work_row_seq_v2/row_sequencer_v2.def
streamOut /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/tdi1k/pnr/work_row_seq_v2/row_sequencer_v2.gds -merge /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/scl180/stdcell/fs120/6M1L/gds/scl18fs120.gds
write_sdf  $OUT/row_sequencer_v2.sdf
extractRC
rcOut -spef /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/tdi1k/pnr/work_row_seq_v2/row_sequencer_v2.spef
saveNetlist /home/ruby22.ivcs/P4/prasady/ruby_A0.p4/dv_regression.work/units/psvp/tdi1k/pnr/work_row_seq_v2/row_sequencer_v2_pnr_netlist.v
