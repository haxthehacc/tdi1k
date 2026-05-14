if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name lib_ss\
   -timing\
    [list ${::IMEX::libVar}/mmmc/tsl18fs120_scl_ss.lib]
create_library_set -name lib_ff\
   -timing\
    [list ${::IMEX::libVar}/mmmc/tsl18fs120_scl_ff.lib]
create_rc_corner -name default_rc_corner\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name dc_ss\
   -library_set lib_ss
create_delay_corner -name dc_ff\
   -library_set lib_ff
create_constraint_mode -name func\
   -sdc_files\
    [list /dev/null]
create_analysis_view -name av_ss -constraint_mode func -delay_corner dc_ss
create_analysis_view -name av_ff -constraint_mode func -delay_corner dc_ff
set_analysis_view -setup [list av_ss] -hold [list av_ff]
