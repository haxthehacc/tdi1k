############################################################
##   Defaults for all Unix environment variables used     ##
##    in the Design Kit are defined in this file          ##
############################################################
# $Id: cdsSystem.cshrc 1 2019/07/01 11:07:32 GMT ronenha Exp $
# $Log: Revision 1 2019/07/01 11:07:32 GMT ronenha $
#   Initial revision.
# 
#  Revision: 1.8 Tue Mar  8 21:26:58 2005 milkovr
#  Remove call to Inductor.cshrc. Rely on wrapper script instead.
# 
#  Revision: 1.7 Mon Nov 17 17:14:16 2003 milkovr
#  Delete unused code
#  Move sourcing of rds_*_config files to RDS_CUSTOM script
#  Move Inductor.cshrc to $RDS_CDSWARE
# 
#  Revision: 1.6 Wed Oct 22 10:49:09 2003 nasamrc
#  Changed prependPath from rfbin to $RDS_CDSWARE/bin
# 
#  Revision: 1.5 Tue Apr 15 00:44:34 2003 bani
#  Added env var RDS_CDS_PSF_WARN for PSF Delete message
#  By default set to Yes.  Set to No to stop display of message
#  
# Revision 1.4  2002/09/10 18:11:36  knightm
# Move automatic linking of $HOME/.simrc to cdsSite.cshrc
#
# Revision 1.3  2002/09/10 18:07:20  knightm
# Move .cdsplotinit setting to cdsSite.cshrc
#
# Revision 1.2  2002/07/15  13:15:00  knightm
# Moved umask setting from cdsSystem.cshrc to $RDS_CUSTOM/cdsSite.cshrc
# 
# Revision 1.1  2002/05/29  18:37:50  nasamrc (Chana  Nasamran)
# Initial Jazz revision
# 
############################################################

# Define RDS_AMS_CDSVER
   if ($?USER_RDS_AMS_CDSVER) then
      setenv RDS_AMS_CDSVER $USER_RDS_AMS_CDSVER
   else if ($?PROJ_RDS_AMS_CDSVER) then
      setenv RDS_AMS_CDSVER $PROJ_RDS_AMS_CDSVER
   else if (! $?RDS_AMS_CDSVER ) then
      setenv RDS_AMS_CDSVER cds_default
   endif

# check for user specific definition of RDS_ROOT 
# (to be used only for hot fixes)
   unset new_rds_root
   if ($?USER_RDS_ROOT) then
      setenv DEF_RDS_ROOT $RDS_ROOT_DEFAULT
      setenv RDS_ROOT $USER_RDS_ROOT 
      set new_rds_root = 1

# check for project specific definition of RDS_ROOT 
   else if ($?PROJ_RDS_ROOT) then
      setenv DEF_RDS_ROOT $RDS_ROOT_DEFAULT 
      setenv RDS_ROOT $PROJ_RDS_ROOT 
      set new_rds_root = 1
 
# otherwise use the default RDS_ROOT defined in your $HOME/.cshrc file
   else if ($?DEF_RDS_ROOT) then
      setenv RDS_ROOT $DEF_RDS_ROOT
      unsetenv DEF_RDS_ROOT
      set new_rds_root = 1
   endif


# Load site-specific configuration (prior to sourcing RDS.cshrc)
# Different default for PERL5 and LSF_HOME than those in RDS.cshrc
# can be specified
   if ($?RDS_SITE_ENV) then
     if (-e $RDS_SITE_ENV) source $RDS_SITE_ENV
   endif

   # source RDS.cshrc is required if new_rds_root
   if ($?new_rds_root) then
      if (-e $RDS_ROOT/etc/RDS.cshrc) source $RDS_ROOT/etc/RDS.cshrc
      # prepend path with the new RDS_ROOT
      set prepend = $RDS_CDSWARE/bin/prependPath
      set path = (`$prepend $RDS_CDSWARE/bin "$path"`)
      set path = (`$prepend $RDS_ROOT/bin/rfbin "$path"`)
   endif

   setenv  RFCAD_CDS $RDS_ROOT
   setenv  RDS_CDS_INIT_FILES $RDS_ETC

# define the following env variable only if crcs is being used
# setenv  RDS_CDS_DMTYPE crcs
# reset the following flag env variable so that by default TDM is not enabled
# to enable TDM just set this env var to 1 in either cdsUsr or cdsPrj
   unsetenv RDS_TDM_ON

   setenv  RDS_CDS_LIB_VERS  $RDS_CDS_INIT_FILES/system.lib
   setenv  CDS_LIB_VERS  $RDS_CDS_LIB_VERS

   if (! $?RDS_CDS_TECH) then
       setenv  RDS_CDS_TECH  b25m
       setenv  CDS_TECH  $RDS_CDS_TECH
   endif

   unsetenv RDS_CDS_VERIFY_TECH


# by default this is defined as an internal skill variable.
# it can be set to a different directory for testing purposes
#   setenv  RDS_CDS_TECH_DIR  $RDS_CDSLIBS/$CDS_TECH/techfiles
#   setenv  CDS_TECH_DIR  $RDS_CDS_TECH_DIR

# Cadence variable used in its search-path
   setenv  CDS_SEARCHDIR  $RDS_CDSWARE

# Set the default Layout Editor to Virtuoso. The other option is Rose.
   setenv RDS_CDS_LAYOUT_TOOL Virtuoso

# The following env variables are set only if the proposed project setup
# is adopted
   if (($?PROJ_ROOT) && ($?PROJ_ID)) then

      # Cadence variable used in its search-path
         setenv CDS_WORKAREA ${PROJ_ROOT}/${PROJ_ID}/work_libs/`whoami`/cds

      # default directory-locations of project data used by integration code 
         setenv  TSP_DIR  {$PROJ_ROOT}/{$PROJ_ID}/rose/tsp_dir
         setenv  GDS_DIR  {$PROJ_ROOT}/{$PROJ_ID}/gds_dir
         setenv  DXF_DIR  {$PROJ_ROOT}/{$PROJ_ID}/dxf_dir
         setenv  BOND_INFO_DIR  {$PROJ_ROOT}/{$PROJ_ID}/bond_info_dir
         setenv  VER_DIR  {$PROJ_ROOT}/{$PROJ_ID}/verification
         setenv  CBR_DIR  {$VER_DIR}/cbr_dir
         setenv  PEX_DIR  {$VER_DIR}/pex
         setenv  HSP_DIR  {$CDS_WORKAREA}/hsp_dir
         setenv  VHDL_DIR {$CDS_WORKAREA}/vhdl_dir
       # Artist simulation directory
         setenv  RDS_ASI_DIR {$CDS_WORKAREA}/simulation
       # IC-Craftsman directory
         setenv ICCRAFT_DIR {$CDS_WORKAREA}/iccraft
   endif

# default model version (always latest)
#   setenv RDS_CDS_MODEL_VER  v1.1
# default model versions per technology 
   setenv RDS_CDS_MODEL_VER_PACKAGE v1.0

# default model type to be used by simulators
   setenv RDS_CDS_MOS_MODEL  bsim3v3
   setenv RDS_CDS_BJT_MODEL  gp

# HP-ADS Unix Environment variables
   setenv RFCAD_ADS     $RDS_ROOT
   setenv RDS_ADS_TECH  $RDS_CDS_TECH
   setenv RDS_ADS_MODEL_VER v1.0

# This env variable is set to make icfb and icms look the same
   setenv CDS_Netlisting_Mode Analog

# Use new locking mechanism for Cadence 4.4.5
   setenv CLS_CDSD_COMPATIBILITY_LOCKING No

# Use wrapper for cdsio, skip Inductor.cshrc
# Set environment variables for Inductor modeling tool
#   if ( -e $RDS_CDSWARE/bin/Inductor.cshrc ) then
#      source $RDS_CDSWARE/bin/Inductor.cshrc
#   endif

# Load site-specific configuration
   if ($?RDS_CUSTOM) then
      if (-e $RDS_CUSTOM/cdsSite.cshrc) \
         source $RDS_CUSTOM/cdsSite.cshrc
   endif
