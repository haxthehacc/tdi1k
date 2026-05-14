#-----------------------------------------------------------------------
# Re-streamout row_sequencer_v2 with foundry-aligned layer map for Calibre LVS
#-----------------------------------------------------------------------
setMultiCpuUsage -localCpu 4
restoreDesign work_row_seq_v2/row_sequencer_v2_pnr.enc.dat row_sequencer_v2

streamOut ../layout/gds/row_sequencer_v2_lvs.gds \
    -mapFile streamOut_foundry.map \
    -libName DesignLib \
    -merge "/home/cmos/fifo/scl180/stdcell/fs120/4M1IL/gds/scl18fs120.gds" \
    -units 1000 \
    -mode ALL

exit
