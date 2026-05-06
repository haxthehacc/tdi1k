############################################################
# This file sets the project-related environment variables #
############################################################
#
# $Id: cdsDesKit.cshrc 1 2019/07/01 11:07:32 GMT ronenha Exp $
# $Log: Revision 1 2019/07/01 11:07:32 GMT ronenha $
#   Initial revision.
# 
#  Revision: 1.4 Mon Nov 17 17:11:52 2003 milkovr
#  Change path to prependPath to use RDS_CDSWARE
# 
#  Revision: 1.3 Tue Oct 21 17:11:48 2003 nasamrc
#  point prependPath to $RDS_CDSWARE/bin
# 
#  Revision: 1.2 Thu Apr  3 03:43:41 2003 knightm
#  only set PROJ_ROOT if it's not already set.
#  
############################################################
#
#!/bin/csh -f
#
set prepend = $RDS_CDSWARE/bin/prependPath

setenv  RFCAD_CDS  $RDS_ROOT
setenv  RDS_ROOT_DEFAULT  $RDS_ROOT
set path = ( `$prepend $RDS_CDSWARE/bin $path` )
set path = ( `$prepend $RDS_ROOT/bin/rfbin $path` )

# Customize this variable to adapt the RDS Design Kit to your Site.
# If you cannot edit this file, redefine PROJ_ROOT in your .cshrc 
# after sourcing this file
if ( ! $?PROJ_ROOT ) then
   setenv  PROJ_ROOT  /prj
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


