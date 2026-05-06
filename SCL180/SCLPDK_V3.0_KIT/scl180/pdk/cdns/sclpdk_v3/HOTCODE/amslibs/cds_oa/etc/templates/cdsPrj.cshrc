#!/bin/csh -f
#
# Template of cdsPrj.cshrc file
# This file should be found in /ProjRoot/ProjID/cds_master/cdsPrj.cshrc

# Purpose of this file:
# It is sourced after cdsUsr.cshrc when the command "cdsprj ProjID" is issued.
# It is used to source the cdsSystem.cshrc file and to override system defaults 
# specifying project defaults.
# All project-specific Unix and Cadence environment variables should be defined in this file.

# reset PROJ_RDS_ROOT in case it was defined elsewhere.
unsetenv PROJ_RDS_ROOT

# Define the following env variable if you want to point to a version of RDS 
# different from default
#setenv PROJ_RDS_ROOT /rds/prod/HOTCODE

# source System defaults
   if ($?USER_RDS_ROOT) then
	source $USER_RDS_ROOT/etc/cdsSystem.cshrc
   else if ($?PROJ_RDS_ROOT) then
	source $PROJ_RDS_ROOT/etc/cdsSystem.cshrc
   else if ($?DEF_RDS_ROOT) then
	source $DEF_RDS_ROOT/etc/cdsSystem.cshrc
   else
	source $RDS_ROOT/etc/cdsSystem.cshrc
   endif

# default technology for this project (e.g. bc35)
setenv RDS_CDS_TECH bc35
setenv CDS_TECH $RDS_CDS_TECH
setenv RDS_ADS_TECH bc35

# definitions for Tower PDKs
if ($RDS_CDS_TECH =~ *ts* ) then
#if (! $?MGC_CALIBRE_CUSTOMIZATION_FILE) setenv MGC_CALIBRE_CUSTOMIZATION_FILE $RDS_ROOT/techs/generic/calibre/calibre_ts_drc.custom
#if (! $?MGC_CALIBRE_PERC_RUNSET_FILE) setenv MGC_CALIBRE_PERC_RUNSET_FILE  $RDS_ROOT/amslibs/cds_default/cdslibs/$RDS_CDS_TECH/calibre/runsets/$RDS_CDS_VERIFY_TECH/${RDS_CDS_VERIFY_TECH}_perc
#if (! $?MGC_CALIBRE_DRC_RUNSET_FILE)  setenv MGC_CALIBRE_DRC_RUNSET_FILE  $RDS_ROOT/amslibs/cds_default/cdslibs/$RDS_CDS_TECH/calibre/runsets/$RDS_CDS_VERIFY_TECH/${RDS_CDS_VERIFY_TECH}_drc
#if (! $?MGC_CALIBRE_LVS_RUNSET_FILE) setenv MGC_CALIBRE_LVS_RUNSET_FILE  $RDS_ROOT/amslibs/cds_default/cdslibs/$RDS_CDS_TECH/calibre/runsets/$RDS_CDS_VERIFY_TECH/${RDS_CDS_VERIFY_TECH}_lvs
#if (! $?MGC_CALIBRE_PEX_RUNSET_FILE) setenv MGC_CALIBRE_PEX_RUNSET_FILE  $RDS_ROOT/amslibs/cds_default/cdslibs/$RDS_CDS_TECH/calibre/runsets/$RDS_CDS_VERIFY_TECH/${RDS_CDS_VERIFY_TECH}_pex
if (! $?MGC_CALIBRE_CUSTOMIZATION_FILE) setenv MGC_CALIBRE_CUSTOMIZATION_FILE $RDS_ROOT/techs/generic/calibre/calibre_ts_drc.custom
if (! $?MGC_CALIBRE_DRC_RUNSET_FILE)  setenv MGC_CALIBRE_DRC_RUNSET_FILE  $RDS_ROOT/techs/generic/calibre/calibre_gui_drc
if (! $?MGC_CALIBRE_LVS_RUNSET_FILE)  setenv MGC_CALIBRE_LVS_RUNSET_FILE  $RDS_ROOT/techs/generic/calibre/calibre_gui_lvs
if (! $?MGC_CALIBRE_PEX_RUNSET_FILE)  setenv MGC_CALIBRE_PEX_RUNSET_FILE  $RDS_ROOT/techs/generic/calibre/calibre_gui_pex
if (! $?MGC_CALIBRE_PERC_RUNSET_FILE)  setenv MGC_CALIBRE_PERC_RUNSET_FILE  $RDS_ROOT/techs/generic/calibre/calibre_gui_perc
if (! $?PERCRUNSET) setenv PERCRUNSET $RDS_ROOT/techs/perc_runsets
if (! $?RDS_PEX_HEADER) setenv RDS_PEX_HEADER ${RDS_CDS_TECH}.PEX.header
if (! $?RDS_LVS_HEADER) setenv RDS_LVS_HEADER ${RDS_CDS_TECH}.LVS.header
setenv ATKROOT $RDS_ROOT/apache/ATK/
set path = ( $ATKROOT/bin $path )
setenv ATK_PATH_EX_GENERIC $RDS_ROOT/apache/examples/ATK_examples/
endif



# Write below this line all the Unix Environmental variables you wish to change 
# from system defaults
# setenv RDS_ASI_DIR ....

# Write below this line the tool version you wish to change 
# from system defaults


