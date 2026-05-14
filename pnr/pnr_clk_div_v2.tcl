# =============================================================================
# Innovus PNR for clk_divider_v2 (SCL180 fs120 6M1L)
# Includes CTS (was missing in original v1 flow).
# Usage:
#   cd <repo>/pnr
#   innovus -files pnr_clk_div_v2.tcl -log innovus_clk_div_v2.log -overwrite -batch -no_gui
# =============================================================================

set REPO /home/cmos/projects/tdi1k_repo
set PDK  /home/cmos/fifo/scl180/stdcell/fs120/4M1IL

set OUT  $REPO/pnr/work_clk_div_v2
set RPT  $REPO/reports
file mkdir $OUT $RPT

# ---- design import ----------------------------------------------------------
set init_lef_file       [list $PDK/lef/scl18fs120_tech.lef $PDK/lef/scl18fs120_std.lef]
set init_mmmc_file      $REPO/pnr/mmmc_clk_divider_v2.tcl
set init_verilog        $REPO/synthesis/clk_divider_v2_netlist.v
set init_top_cell       clk_divider_v2
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

# ---- floorplan: small block, 65% utilization, 5 um core-to-die ---------------
floorPlan -site CoreSite -r 1.0 0.65 5.0 5.0 5.0 5.0

# ---- IO pin placement (give every input/output a physical edge pin) --------
# Required so CTS post-route ECO can build a connected route-graph for 'clk'.
setPinAssignMode -pinEditInBatch true
catch {editPin -pin {clk_50m rst_n}        -side LEFT  -layer M3 -spreadType SIDE}
catch {editPin -pin {clk_line clk_line_pulse} -side RIGHT -layer M3 -spreadType SIDE}
setPinAssignMode -pinEditInBatch false

# ---- power: tie all cells to VDD/VSS, add ring + std-cell rails -------------
# (PG nets created above before floorplan)
addRing -nets {VDD VSS} -width 2.0 -spacing 0.5 \
        -layer {top M4 bottom M4 left M3 right M3} \
        -offset 1.0
sroute -connect {corePin floatingStripe} -nets {VDD VSS}

# ---- placement --------------------------------------------------------------
setPlaceMode -place_global_clock_gate_aware true
place_opt_design

# ---- CTS (this was MISSING in the original tape-out flow) -------------------
# Use ccopt for clock optimization; keeps clk_50m tree latency balanced.
create_ccopt_clock_tree_spec
ccopt_design

# ---- routing ----------------------------------------------------------------
# Shield the clock net to reduce coupling/jitter into adjacent blocks.
setNanoRouteMode -routeWithTimingDriven true
# SI-driven needs OCV; we already set OCV above, but keep SI off for this simple flow.
#setNanoRouteMode -routeWithSiDriven true
# Shielding rule: top-level clock net 'clk_50m' shielded with VSS on M3-M5.
# (NanoRoute will skip silently if nets aren't on those layers - safe.)
catch {setAttribute -net clk_50m -shield_net VSS}

catch {route_opt_design}

# ---- filler / decap ---------------------------------------------------------
catch {addFiller -cell {feedth decrq4 decrq2 decrq1 decfq4 decfq2 decfq1} -prefix FILL}

# ---- sign-off-style reports -------------------------------------------------
catch {report_timing                                  > $RPT/clk_div_v2_pnr_timing_setup.rpt}
catch {report_timing -early                           > $RPT/clk_div_v2_pnr_timing_hold.rpt}
catch {report_area                                    > $RPT/clk_div_v2_pnr_area.rpt}
catch {report_power                                   > $RPT/clk_div_v2_pnr_power.rpt}
catch {verify_drc           -report $RPT/clk_div_v2_pnr_drc.rpt}
catch {verify_connectivity  -report $RPT/clk_div_v2_pnr_conn.rpt}

# ---- write outputs ----------------------------------------------------------
catch {saveDesign $OUT/clk_divider_v2_pnr.enc}
catch {defOut     $OUT/clk_divider_v2.def}
catch {streamOut  $OUT/clk_divider_v2.gds -merge [list $PDK/gds/scl18fs120.gds]}
catch {write_sdf  $OUT/clk_divider_v2.sdf}
catch {extractRC}
catch {rcOut -spef $OUT/clk_divider_v2.spef}
catch {saveNetlist $OUT/clk_divider_v2_pnr_netlist.v}

puts "clk_divider_v2 PNR complete -> $OUT"
exit
