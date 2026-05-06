#!/bin/csh -f
#
# Template of cdsUsr.cshrc file
# This file should be found in /ProjRoot/ProjID/work_libs/Username/cds/cdsUsr.cshrc

# Purpose of this file:
# It is sourced first when the command cdsprj ProjID is issued.
# It is used to source the cdsPrj.cshrc file and allows to override
# both system and project defaults with local ones.
# All user-specific Unix and Cadence environment variables should be defined in this file.

# reset USER_RDS_ROOT in case it was defined elsewhere.
unsetenv USER_RDS_ROOT

# Define the following env variable if you want to point to a version of RDS 
# different from default
# setenv USER_RDS_ROOT  /rds/prod/.......

# source Project defaults
   source $PROJ_ROOT/$PROJ_ID/cds_master/cdsPrj.cshrc


# Write below this line all the Unix Environmental variables you wish to change 
# from project and/or system defaults


# Write below this line the tool version you wish to change 
# from project and/or system defaults


