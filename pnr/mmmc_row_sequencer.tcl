create_library_set -name lib_ss \
    -timing { /home/cmos/fifo/scl180/stdcell/fs120/4M1IL/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib }

create_constraint_mode -name func \
    -sdc_files { /home/cmos/projects/tdi1k/scripts/row_sequencer.sdc }

create_delay_corner -name dc_ss \
    -library_set lib_ss

create_analysis_view -name av_ss \
    -constraint_mode func \
    -delay_corner dc_ss

set_analysis_view \
    -setup { av_ss } \
    -hold  { av_ss }
