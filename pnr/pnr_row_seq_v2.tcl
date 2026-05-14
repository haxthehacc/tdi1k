# =============================================================================
# Innovus PNR for row_sequencer_v2 (SCL180 fs120 6M1L)
# Larger block (~22.9k um^2 from synthesis); 60 RST/TX/SEL outputs.
# =============================================================================

set REPO /home/cmos/projects/tdi1k_repo
set PDK  /home/cmos/fifo/scl180/stdcell/fs120/4M1IL

set OUT  $REPO/pnr/work_row_seq_v2
set RPT  $REPO/reports
file mkdir $OUT $RPT

set init_lef_file       [list $PDK/lef/scl18fs120_tech.lef $PDK/lef/scl18fs120_std.lef]
set init_mmmc_file      $REPO/pnr/mmmc_row_sequencer_v2.tcl
set init_verilog        $REPO/synthesis/row_sequencer_v2_netlist.v
set init_top_cell       row_sequencer_v2
set init_pwr_net        VDD
set init_gnd_net        VSS
set init_power_nets     VDD
set init_ground_nets    VSS
set init_ignore_pgpin_polarity_check 1
# Suppress harmless CRR/Genus library-collection messages for LEF-only cells (feedth, mx08*).
catch {suppressMessage TCLCMD-513}
catch {suppressMessage TCLCMD-917}
init_design
setDesignMode -process 180
setAnalysisMode -analysisType onChipVariation

# Create power/ground nets explicitly with proper polarity (netlist has no supply ports)
catch {addNet -power VDD}
catch {addNet -ground VSS}
globalNetConnect VDD -type pgpin -pin VDD -inst * -override
globalNetConnect VSS -type pgpin -pin VSS -inst * -override

# Tall+narrow shape so the 60 outputs come out one side (toward pixel array).
# 0.7 utilization, ~10 um margin to die boundary on TOP (where SEL/RST/TX go).
floorPlan -site CoreSite -r 0.45 0.7 5.0 10.0 5.0 10.0

# ---- IO pin placement (give every input/output a physical edge pin) --------
# Required so CTS post-route ECO can build a connected route-graph for 'clk'.
setPinAssignMode -pinEditInBatch true
catch {editPin -pin {clk rst_n tdi_enable} -side LEFT  -layer M3 -spreadType SIDE}
catch {editPin -pin {TX RST SEL line_done frame_done} -side RIGHT -layer M3 -spreadType SIDE}
setPinAssignMode -pinEditInBatch false

# (PG nets created above before floorplan)
addRing -nets {VDD VSS} -width 3.0 -spacing 0.6 \
        -layer {top M4 bottom M4 left M3 right M3} \
        -offset 1.0
addStripe -nets {VDD VSS} -layer M5 -direction vertical -width 1.5 \
          -spacing 1.0 -set_to_set_distance 30 -start_from left
sroute -connect {corePin floatingStripe} -nets {VDD VSS}

setPlaceMode -place_global_clock_gate_aware true
place_opt_design

# CTS - 60 SEL/TX/RST flop endpoints at output stage need balanced clock.
create_ccopt_clock_tree_spec
ccopt_design

setNanoRouteMode -routeWithTimingDriven true
#setNanoRouteMode -routeWithSiDriven true
# Shield the synchronous clock net.
catch {setAttribute -net clk -shield_net VSS}

catch {route_opt_design}

catch {addFiller -cell {feedth decrq4 decrq2 decrq1 decfq4 decfq2 decfq1} -prefix FILL}

catch {report_timing                                 > $RPT/row_seq_v2_pnr_timing_setup.rpt}
catch {report_timing -early                          > $RPT/row_seq_v2_pnr_timing_hold.rpt}
catch {report_area                                   > $RPT/row_seq_v2_pnr_area.rpt}
catch {report_power                                  > $RPT/row_seq_v2_pnr_power.rpt}
catch {verify_drc          -report $RPT/row_seq_v2_pnr_drc.rpt}
catch {verify_connectivity -report $RPT/row_seq_v2_pnr_conn.rpt}

catch {saveDesign $OUT/row_sequencer_v2_pnr.enc}
catch {defOut     $OUT/row_sequencer_v2.def}
catch {streamOut  $OUT/row_sequencer_v2.gds -merge [list $PDK/gds/scl18fs120.gds]}
catch {write_sdf  $OUT/row_sequencer_v2.sdf}
catch {extractRC}
catch {rcOut -spef $OUT/row_sequencer_v2.spef}
catch {saveNetlist $OUT/row_sequencer_v2_pnr_netlist.v}

puts "row_sequencer_v2 PNR complete -> $OUT"
exit
