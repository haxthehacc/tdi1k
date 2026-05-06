############################################################
##                 DESIGN KIT SYSTEM SETUP                ##
############################################################
# $Id: deskit.cshrc 1 2019/07/01 11:07:32 GMT ronenha Exp $
# $Log: Revision 1 2019/07/01 11:07:32 GMT ronenha $
#   Initial revision.
# 
#  Revision: 1.2 Thu Jun 27 14:49:04 2002 milkovr
#  Add support for HP
#  
# Revision 1.1  2002/05/29  18:37:50  18:37:50  nasamrc (Chana  Nasamran)
# Initial Jazz revision
# 
# Revision 1.3  2002/04/26 15:49:46  nasamrc
# source RDS.cshrc only with new RDS_ROOT
#
# Revision 1.2  2002/04/02 22:47:41  nasamrc
# Modified from cdsDesKit.cshrc, intended as a single file to source
# for deskit setup
#
############################################################

# Get the OS type
  set os_info = `uname -sr`
  set os_type = $os_info[1]
  set os_version = $os_info[2]

  switch ($os_type)
    case "HP-UX":
      switch ("$os_version")
        case "B.11.*":
          setenv RDS_PT HP11X
          breaksw
        default:
          echo "RDS does not work with HP-UX version $os_version"
          exit 1
          breaksw
      endsw
      breaksw
    case "SunOS":
      switch ("$os_version")
        case "5*":
          setenv RDS_PT sun5
          breaksw
        default:
          echo "RDS does not work with Solaris version $os_version"
          exit 1
          breaksw
        endsw
    breaksw
      default:
      echo "RDS is currently only available for Sun and HP operating systems."
      exit 1
      breaksw
   endsw

# if not already, define RDS_ROOT
   if ( ! ${?RDS_ROOT} ) then
      setenv  RDS_ROOT  /rds/prod/HOTCODE
      echo "RDS_ROOT = $RDS_ROOT"
   endif

# Customize this variable to adapt the RDS Design Kit to your Site.
# Define PROJ_ROOT before sourcing this file to override this default
   if ( ! ${?PROJ_ROOT} ) then
      setenv  PROJ_ROOT  /prj
      echo "PROJ_ROOT = $PROJ_ROOT"
   endif

# Design Kit aliases
   alias cdsprj 'setenv PROJ_ID \!:1; setenv PROJ $PROJ_ID;\\
   if (-f {$PROJ_ROOT}/{$PROJ_ID}/work_libs/`whoami`/cds/cdsUsr.cshrc) source {$PROJ_ROOT}/{$PROJ_ID}/work_libs/`whoami`/cds/cdsUsr.cshrc ; \\
cd {$PROJ_ROOT}/{$PROJ_ID}/work_libs/`whoami`/cds ;\\
if (-e design_controlled) cd *.Work '

   alias adsprj 'setenv PROJ_ID \!:1; setenv PROJ $PROJ_ID;\\
if (-f {$PROJ_ROOT}/{$PROJ_ID}/work_libs/`whoami`/hpads/adsUsr.cshrc) source {$PROJ_ROOT}/{$PROJ_ID}/work_libs/`whoami`/hpads/adsUsr.cshrc ; \\
cd {$PROJ_ROOT}/{$PROJ_ID}/work_libs/`whoami`/hpads '

   alias apdprj 'setenv PROJ_ID \!:1; setenv PROJ $PROJ_ID;\\
if (-f {$PROJ_ROOT}/{$PROJ_ID}/work_libs/`whoami`/apd/apdUsr.cshrc) source {$PROJ_ROOT}/{$PROJ_ID}/work_libs/`whoami`/apd/apdUsr.cshrc ; \\
cd {$PROJ_ROOT}/{$PROJ_ID}/work_libs/`whoami`/apd '

   alias envcds 'env | grep CDS'
   alias envrds 'env | grep RDS'

# aliases to run the watch commands
   alias icmsw 'watch icms -log ./CDS.log &'
   alias icfbw 'watch icfb -log ./CDS.log &'

# complete the setup for rds
   setenv  RDS_ROOT_DEFAULT  $RDS_ROOT
   setenv  DEF_RDS_ROOT      $RDS_ROOT
   if (-e $RDS_ROOT/etc/cdsSystem.cshrc) source $RDS_ROOT/etc/cdsSystem.cshrc
