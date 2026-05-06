#!/bin/bash
# DRC run script for TDI sensor C2S0115
# Requires Calibre to be installed and licensed

GDS=/home/cmos/projects/tdi1k/C2S0115_30042026_v1.gds
TOPCELL=tdi_sensor_top
RULES=/home/cmos/projects/tdi1k_repo/rules/calibre/DRC_TS18SL_SCL_CALIBRE
OUTDIR=/home/cmos/projects/tdi1k_repo/DRC_REPORT

mkdir -p $OUTDIR

calibre -drc -hier -turbo 4 \
  -runset_variable LAYOUT_PATH $GDS \
  -runset_variable LAYOUT_PRIMARY $TOPCELL \
  -runset_variable LAYOUT_SYSTEM GDSII \
  -runset_variable DRC_RESULTS_DATABASE $OUTDIR/drc_results.db \
  -runset_variable DRC_SUMMARY_REPORT $OUTDIR/drc_summary.rpt \
  $RULES

echo "DRC complete. Results in $OUTDIR"
