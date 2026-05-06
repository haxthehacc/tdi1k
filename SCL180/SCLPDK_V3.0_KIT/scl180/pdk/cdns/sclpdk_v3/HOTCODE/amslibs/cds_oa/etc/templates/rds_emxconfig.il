;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  
;;  This function will load TowerJazz configuration for EMX 
;;  including variant specific files.
;;
;;  There also exists code to configure some development settings
;;  if EMX_DEVEL_SETUP is defined as an environment variable.
;;
;; ---------------------------------------------------------------
;;
;;   Revision: 2.0   4/12/17 --- FMR
;;   Updated to better integrate into the PDK
;;
;;   Revision: 1.0   4/4/17 --- FMR
;;   Initial Creation
;;  


; this file only executes if EMX has been set-up already
; it will re-define some settings.  User should verify that they are
; not unintentionally clobbering any of these variables
if( boundp('EMX_interface_path) then
  printf("RDS_EMXCONFIG>> EMX installation found. Loading TowerJazz rds_emxconfig.il file.\n")

; This section defines location of default files for EMX
; For production release RDS_CDS_EMXLIB can be defined to the location of the file heirarchy
; If not defined then $RDS_ROOT/techs is used.
  if( not(getShellEnvVar("RDS_EMXLIB")) then
      setShellEnvVar( strcat( "RDS_EMXLIB=" getShellEnvVar("RDS_TECH")  ))
  )
  EMX_process_path=strcat( getShellEnvVar("RDS_EMXLIB") "/" getShellEnvVar("RDS_CDS_VERIFY_TECH") "/emx/default_scr" )
  EMX_process_name=strcat( getShellEnvVar("RDS_CDS_VERIFY_TECH")  "_default.proc" )
  techEMXsetupFile = strcat( getShellEnvVar("RDS_CDS_VERIFY_TECH") "_emxconfig.il")


; see if a development library is available in cds.lib
;   --- search for expected characters in name
;   --- this allows relative reference for s-parameter blocks
;   --- see EMX manual for "EMX_nport_sparam_view_prefix" variable
  tjEMXfoundTechLib = nil
  develLibnameEMX = nil
  foreach( develSearchEMX  ddGetLibList()~>name
     if( and(rexMatchp("_tj" develSearchEMX) rexMatchp("EMX_" develSearchEMX) rexMatchp("_cds" develSearchEMX) rexMatchp( getShellEnvVar("RDS_CDS_TECH") develSearchEMX) ) then
       develLibnameEMX = develSearchEMX
       if( tjEMXfoundTechLib develLibnameEMX = nil )
       tjEMXfoundTechLib = t
     )
  )
  if( tjEMXfoundTechLib then
     if( develLibnameEMX  then
        setShellEnvVar( strcat( "EMX_DEVEL_LIBPATH=" ddGetObj(develLibnameEMX)~>readPath ))
        printf("RDS_EMXCONFIG>> Found %s development library.\n", develLibnameEMX)
     else
        printf("RDS_EMXCONFIG>> Multiple EMX development libraries found.\n")
        develLibnameEMX = "Found Multiple."
     )
  else
     printf("RDS_EMXCONFIG>> No EMX development library found.\n")
     develLibnameEMX = "None Found"
  )

; define options for development purposes
  if( getShellEnvVar("EMX_DEVEL_SETUP") then
     EMX_symbol_name="symbol"
     EMX_symbol_nport_name="symbol"
     EMX_schematic_name="EMX_model"
     EMX_schematic_nport_name="EMX_spar"
     EMX_schematic_pz_name="EMX_pz"
     EMX_schematic_dc_name="EMX_dc"
     EMX_aucdl_name=nil
     EMX_aulvs_name=nil
     EMX_connectivity=t
     EMX_dialog_msgs=2
     EMX_EMX_opts=" --discrete-frequency=0.0 --discrete-frequency=2.0 --discrete-frequency=5.0 --discrete-frequency=1.0e1 --discrete-frequency=2.0e1 --discrete-frequency=5.0e1 --discrete-frequency=1.0e2 --discrete-frequency=2.0e2 --discrete-frequency=5.0e2 --discrete-frequency=1.0e3 --discrete-frequency=2.0e3 --discrete-frequency=5.0e3 --multi-sweep=1e4:2e4:1e5 --multi-sweep=2e5:2e5:1e6 --multi-sweep=2e6:2e6:1e7 --multi-sweep=2e7:1e7:1e8 --multi-sweep=2e8:2e7:5e8 --multi-sweep=5.5e8:5e7:0.95e9 --answer-relative-tolerance=0 --dc-answer-relative-tolerance=0 --relative-tolerance=1e-8 --dc-relative-tolerance=1e-10 --print-command-line --matlab-mesh-and-continue --print-double --include-command-line --double-precision --flexnet-queue"
     EMX_GDSview_opts=""
     EMX_nport_sparam_view_name="EMX_spdata"
     EMX_nport_sparam_view_prefix="EMX_DEVEL_LIBPATH"
  )

; check to make sure process file exists
  if( not(isFileName( EMX_process_name EMX_process_path)) then
     printf("RDS_EMXCONFIG>> %s EMX process file not found for variant.\n", EMX_process_name)
     EMX_process_name="FileNotFound"
  )

; load config file for variant if it exists
  if( isFileName( techEMXsetupFile EMX_process_path) then
    printf("RDS_EMXCONFIG>> Loading %s EMX set-up.\n", techEMXsetupFile)
    load( strcat( EMX_process_path "/" techEMXsetupFile))
  else 
    printf("RDS_EMXCONFIG>> %s EMX set-up not found.\n", techEMXsetupFile)
    techEMXsetupFile = "None Loaded"
  )

; re-initial EMX form
   printf("RDS_EMXCONFIG>> Re-initialize emxform with new configuration.\n")
   (load (strcat EMX_interface_path "/emxskill/emxform.ils"))
   printf("RDS_EMXCONFIG>> EMX completed re-initialization.\n")

)

