#!/bin/csh -f
# File: $RDS_ROOT/etc/JDS.cshrc
# Created: 4/19/02 knightm
#
# Lines for user customization indicated with <user-update>

setenv RDS_ROOT /<user-update>/HOTCODE
setenv PROJ_ROOT /<user-update>
setenv PERL5 /<user-update>/perl
setenv CDS_LIC_FILE /<user-update>/cadence_lmgrd
setenv CDS_INST_DIR /<user-update>/cadence/icx.xx/sun5
setenv RDS_CDS_TECH <user-update>

setenv CDS_TECH $RDS_CDS_TECH
setenv RDS_CUSTOM rds_string
setenv RDS_TOOL rds_string
setenv RDS_LIC rds_string
setenv RDS_ACCESS rds_string
setenv RDS_TECH $RDS_ROOT/techs
setenv RDS_AMS_CDSVER cds_default
setenv RDS_BIN  $RDS_ROOT/bin
setenv RDS_DOC  $RDS_ROOT/doc
setenv RDS_ETC  $RDS_ROOT/amslibs/$RDS_AMS_CDSVER/etc
setenv RDS_CDSWARE  $RDS_ROOT/amslibs/$RDS_AMS_CDSVER/cdsware
setenv RDS_CDSLIBS  $RDS_ROOT/amslibs/$RDS_AMS_CDSVER/cdslibs
setenv RDS_ADSLIBS  $RDS_ROOT/adslibs
if (-e $RDS_ROOT/etc/cdsDesKit.cshrc) source $RDS_ROOT/etc/cdsDesKit.cshrc
if (-e $RDS_ROOT/etc/cdsSystem.cshrc) source $RDS_ROOT/etc/cdsSystem.cshrc

set prepend = $RDS_CDSWARE/bin/prependPath
set prependLib = $RDS_CDSWARE/bin/prependLib
set path = ( `$prepend $CDS_INST_DIR/tools/dfII/bin $path` )
set path = ( `$prepend $CDS_INST_DIR/tools/bin $path` )
set path = ( `$prepend $CDS_INST_DIR/tools/verilog/bin $path` )

# restore these lines if you have Cadence LDV tool
# setenv LDV_INST_DIR /tools/cadence/ldv3.1/sun5
# set path = ( `$prepend $LDV_INST_DIR/tools/bin $path` )

# restore these lines if you have Mentor Graphics tools
setenv MGLS_LICENSE_FILE /tools/licenses/license_files/dcdnis/mentor_lmgrd
setenv MGC_PATH /rds.nis/prod/tools/calibre/v8.8_11.1
setenv MGC_HOME $MGC_PATH/sun5
set path = ( `$prepend /rds.nis/prod/tools/bin $path` )

# restore this line if you wish to set a custom directory for spectre simulation results
# setenv RDS_ASI_DIR /prj/sim

# restore these lines if you wish to use LSF
# setenv LSF_HOME /tools/lsf 
# setenv LSF_ENVDIR $LSF_HOME/etc
# set path = ( `$prepend $LSF_HOME/bin $path` )
# setenv RDS_CDS_LSF_SERVER batch
# setenv LBS_BASE_SYSTEM LBS_LSF


