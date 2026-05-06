#! /bin/csh -f
#
# This scripts is to be sourced by the project set-up script. It defines
# a basic set of environment variables of RDS. The variable $RDS_ROOT
# should already been defined to be the root directory of an RDS installation.
#
# $Id: RDS.cshrc 1 2019/07/01 11:07:32 GMT ronenha Exp $
# $Log: Revision 1 2019/07/01 11:07:32 GMT ronenha $
#   Initial revision.
# 
#  Revision: 1.8 Mon Nov 17 17:12:43 2003 milkovr
#  Add setting for prependPath
#  Remove RDS_TOOL setting
# 
#  Revision: 1.7 Mon Jul 14 00:27:28 2003 milkovr
#  Cleanup. Move platform identification to separate script.
#  
# Revision 1.6  2002/11/13 15:16:33  milkovr
# Removed path to RCVS tools.
# Removed path to LSF. Moved to Custom cdsSite.cshrc
#
# Revision 1.5  2002/09/10  21:03:16  21:03:16  knightm (Marion  Knight)
# Change value of RDS_ACCESS from $RDS_ROOT/tools/access
# to $RDS_TOOL/access
# 

if (! $?RDS_ROOT) then
	echo "ERROR: The variable RDS_ROOT is not set."
	echo "Cannot continue without RDS_ROOT."
	exit 1
endif


# General Setup
if ( ! $?RDS_AMS_CDSVER ) then
   setenv RDS_AMS_CDSVER cds_default
endif
setenv RDS_BIN  $RDS_ROOT/bin
setenv RDS_DOC  $RDS_ROOT/doc
setenv RDS_ETC  $RDS_ROOT/amslibs/$RDS_AMS_CDSVER/etc
setenv RDS_EXA  $RDS_ROOT/examples

# CDS Design Kits
setenv RDS_CDSWARE  $RDS_ROOT/amslibs/$RDS_AMS_CDSVER/cdsware
setenv RDS_CDSLIBS  $RDS_ROOT/amslibs/$RDS_AMS_CDSVER/cdslibs
setenv RDS_ADSLIBS  $RDS_ROOT/adslibs

# MGC Design Kits
setenv RSS_USERWARE $RDS_ROOT/mgcware
setenv RDS_MGCSYMB  $RDS_ROOT/mgcsymb
setenv RDS_MGCLIB $RDS_ROOT/mgclibs
setenv RSS_MODEL_LIB $RDS_ROOT/mgclibs

# Technology Libraries
setenv RDS_TECH $RDS_ROOT/techs

# ASIC Libraries
setenv ASIC_LIB $RDS_ROOT/asic_libs

# Simulation Libraries
setenv RDS_CMOS $RDS_ROOT/cmoslibs

# Needed tools
set prepend = $RDS_CDSWARE/bin/prependPath
set prependLib = $RDS_CDSWARE/bin/prependLib

# Site Specific Settings: License Files, Local Requirements,  Default Queues
  setenv RDS_LIC  /tools/licenses/license_files
  if ( ! $?RDS_CUSTOM ) then
     setenv RDS_CUSTOM /rds/prod/custom
  endif
  setenv RDS_CKM_QUEUE  checkmate
  setenv RDS_CAL_QUEUE  calibre

# Determine architecture for perl shell
  if ( ! $?PERL5 ) then
    setenv PERL5 /usr/local/bin/perl
  endif

# Set up RDS_PT platform
source $RDS_ROOT/etc/RDS.platform
if !($?RDS_PT) exit 1
