#!/bin/csh -f
# =============================================================================
# run_synth_v2.csh - convenience launcher for Genus synthesis of v2 blocks
#
# This script is intended for the synthesis host (where genus is on PATH and
# the SCL180 stdcell Liberty is available).
#
# It will:
#   1. Source the PDK setup
#   2. Run synth_clk_div_v2.tcl
#   3. Run synth_row_seq_v2.tcl
#
# Edit SCL_LIB_DIR inside the .tcl scripts if your install is in a different
# location.
# =============================================================================

set SCRIPT_DIR = `dirname $0`
cd $SCRIPT_DIR
set REPO_ROOT  = `pwd`/..

if (! $?PDK_SETUP_SOURCED) then
  if (-f $REPO_ROOT/scripts/pdk_flow_setup.csh) then
    source $REPO_ROOT/scripts/pdk_flow_setup.csh
    setenv PDK_SETUP_SOURCED 1
  endif
endif

if (! `which genus >& /dev/null && echo ok` == "ok") then
  echo "ERROR: genus not on PATH. Run on the synth host or load the Cadence module."
  exit 1
endif

mkdir -p $REPO_ROOT/reports

echo "=== Synthesizing clk_divider_v2 ==="
genus -files synth_clk_div_v2.tcl -log $REPO_ROOT/reports/genus_clk_div_v2.log -no_gui

echo "=== Synthesizing row_sequencer_v2 ==="
genus -files synth_row_seq_v2.tcl -log $REPO_ROOT/reports/genus_row_seq_v2.log -no_gui

echo "=== Done. Outputs ==="
ls -lh $REPO_ROOT/synthesis/clk_divider_v2_netlist.v   $REPO_ROOT/synthesis/clk_divider_v2.sdc
ls -lh $REPO_ROOT/synthesis/row_sequencer_v2_netlist.v $REPO_ROOT/synthesis/row_sequencer_v2.sdc
ls -lh $REPO_ROOT/reports/*v2*.rpt
