#!/tools/public/bin/perl
#
# $Id: makeProjectTreeRDS.pl 5 2020/01/13 12:12:37 GMT ronenha Exp $
# $Log: Revision 5 2020/01/13 12:12:37 GMT ronenha $
#   Add option -pex
# 
#  Revision 4 2020/01/06 11:38:32 GMT ronenha
#   Add scl option
# 
#  Revision 4 2020/01/06 11:38:31 GMT ronenha
#   Add scl option
# 
#  Revision: 1.22 Mon Jan  6 02:22:55 2020 ronenha
#  Add support for scl
# 
#  Revision: 1.21 Tue Dec 10 00:28:04 2019 ronenha
#  If pvtech.lib file exists in $RDS_TECH/$RDS_CDS_VERIFY_TECH/pvs/default_scr copy it from there to cds workarea
# 
#  Revision: 1.20 Mon Nov 25 14:21:08 2019 oferta
#  add update option for flow based lib creation  add update to lib create option
# 
#  Revision: 1.19 Sat Jul  6 22:54:44 2019 ronenha
#  Improve pex type handling
# 
#  Revision: 1.18 Sun Jun 30 06:27:52 2019 oferta
#  update bug  sorry, my BUG
#  Fix == to eq
# 
#  Revision: 1.16 Sun Feb 24 07:45:25 2019 oferta
#  add flow base PDK  add option flow_lib and flow_lib_location to create a PDK with flow base device list ONLY
# 
#  Revision: 1.15 Mon Sep  3 06:49:34 2018 ronenha
#  Add support for ts11is
# 
#  Revision: 1.14 Thu Apr 19 16:44:32 2018 farnswg
#  Added EMX option
# 
#  Revision: 1.13 Thu Dec 15 01:00:54 2016 ronenha
#  Added ead option
# 
#  Revision: 1.12 Wed May 21 03:50:27 2014 ronenha
#  added support for ts60
# 
#  Revision: 1.11 Wed Mar 26 01:22:34 2014 leaam
#  Add techlib mapping for ts60 (ts60_prim)
# 
#  Revision: 1.10 Mon Dec 30 05:08:56 2013 ronenha
#  Changed techlib mapping for ts18rf (ts018_rf_prim)
# 
#  Revision: 1.9 Sun Nov 17 22:42:51 2013 ronenha
#  Add techlib mapping for ts18uhv (ts018_uhv_prim)
# 
#  Revision: 1.8 Wed Aug  7 17:33:43 2013 ronenha
#  added support flowDB
#  added support for pvs
# 
#  Revision: 1.7 Wed Apr 10 05:35:38 2013 ronenha
#  added ipd project
# 
#  Revision: 1.6 Tue Feb  5 00:39:39 2013 ronenha
#  Add techlib mapping for ts18hv (ts018_hv_prim)
# 
#  Revision: 1.5 Mon Nov 19 14:50:02 2012 milkovr
#  Cleanup of messages
# 
#  Revision: 1.4 Thu Jul 26 12:34:15 2012 milkovr
#  Remove several legacy options like Foundry, HPADS, Rose, idf, mgc
#  Remove softcells library since this is not needed in IC6
#  Change CDS techfile attach to use correct IC6.1 file tech.db
#  Improve sbc18 variant checking
#  Improve techfile attach error checking for virtuoso startup failure
# 
#  Revision: 1.3 Sun May 27 13:35:15 2012 ronenha
#  add more Tower processes
#
#  May 27 ronenha
#  Add more Tower processes
#
#  Revision: 1.2 Wed Feb  23 16:13:16 2011 juliaya
#  icfb replaced by virtuoso to support IC6.1.4 and up
#  add Tower prococesses
# 
#  add Tower prococesses
#  Revision: 1.1 Thu Sep  4 16:13:16 2008 bani
#  ic6.1 cdsware
# 
# README:
# This script creates a project directory structure according to the
# description contained in the "Cadence Design Kit Release Notes" document.
#
 
 
 
sub signature {
    print "\n";
    print "*******************************************************\n";
    print 'Program: makeProjectTreeRDS.pl  ver. $Revision: 5 $' . "\n";
    print "TowerJazz \n";
    print "*******************************************************\n";
    print "\n";

}
 
sub usage {
    print "\n";
    print "*****************************************************************************\n";
    print "usage: makeProjectTreeRDS.pl project_ID -tech <technology library> [options] \n";
    print "*****************************************************************************\n";
    print "
Options:
    -help: display this message
    -users <users_file_name>
    -cds: generates the Cadence tree                          -- Default: disabled
    -tdm: activates TDM revision control (only with -cds)     -- Default: disabled
    -tdmcur: setup TDM dynamic workarea (only with -cds)      -- Default: disabled
    -ver: generates the Verification tree                     -- Default: disabled
    -sim <sim_directory> full path of simulation data         -- Default: project user directory
             location, possibly a different disk partition 
             for simulation results  
    -attach: forces libraries attachment                      -- Default: disabled
    -noattach: forces not to attach libraries                 -- Default: disabled
    -flow: specifies a flow to be set and that                -- Default: none
           This determines -tech and -tech_ver
    -flows_file: specifies a flow file to be used             -- Default: <RDS_TECH>/flowDB/flows_file
    -flow_lib: Create Pcell lib per flow device list 	      -- create/use. Default: create, if location is not define set create under cds_master
    -flow_lib_location: Create flow base Pcell lib directory  -- Base on previous value, under that location create new flow Pcell or use existing. 
    -tech: specifies a technology to be set                   -- Default: none
           as default for the project 
    -tech_ver: specifies a technology to be set for           -- Default: same as -tech
           verification if different from tech
           (i.e. -tech sbc18 -tech_ver sbc18hx)
    -pex: define PEX_TYPE when no flow definition is used. FSG,USG,TBE, TBEALL...
    -assura: generates the assura_tech.lib for user_list      -- Default: disabled
    -pvs: generates the pvtech.lib for user_list      -- Default: disabled
    -ead: Build EAD setup                             -- Default: disabled
    Default : do not generate anything !!
    \n";
    &signature ; 
}

#    -mgc: generates the Mentor Graphics tree                  -- Default: disabled
#    -tdm: activates TDM revision control (only with -cds)     -- Default: disabled
#    -all: generates all the directory trees                   -- Default: disabled

#########################################################################################
#################### subroutine: printToLog ############################################
##
## PARAMETERS: string to print
## OUTPUT: prints string to STDOUT and to LOGFILE file handles
#########################################################################################
sub printToLog {
	my $message=shift;
	print $message;
	print LOGFILE $message;
}

#################### subroutine: print_list #############################################
##
## PARAMETERS: list
## OUTPUT: all the components of the list on std output and logfile
##
## RETURNS: none
#########################################################################################
sub print_list{
    foreach $_ (@_){
	printToLog $_ . "\n";
    }
    printToLog "\n";
}

#########################################################################################
#################### subroutine: parse_users_file #######################################
##
## PARAMETERS: file name
## OUTPUT: 
##
## RETURNS: list obtained by parsing the strings in the file
#########################################################################################
sub parse_users_file{ 
    local(@users_list, $user_name, $users_file_name);
    $users_file_name = shift;
    open(USERS_FILE_NAME, $users_file_name) || die "ERROR -- cannot open $users_file_name" ;
    while (<USERS_FILE_NAME>){
	my @line = split;
        # lines starting with ";" are considered comments
	if ((@line[0] ne ";") && (@line[0] ne(/^(\n\t)/))) {
	    $user_name = @line[0];
	    push(@users_list, $user_name);
	}
    }	
    close(USERS_FILE_NAME);
    return @users_list;
}

#########################################################################################
#################### subroutine: parse_flows_file #######################################
##
## PARAMETERS: file name
## OUTPUT: 
##
## RETURNS: list obtained by parsing the strings in the file
#########################################################################################
sub parse_flows_file{ 
    my $flows_file = shift;
	my %flows_array ;
    open(FLOWS_FILE_NAME, $flows_file) || print_error_and_die("ERROR -- cannot open $flows_file\n") ;
    while (<FLOWS_FILE_NAME>){
		$_ =~ /^\s*([^\s\n]+)\s+([^\s\n]+)\s+([^\s\n]+)\s+([^\s\n]+)/ ;
		$flows_array{$1}[1] = $2;
		$flows_array{$1}[2] = $3;
		$flows_array{$1}[3] = $4;
	}
	close(FLOWS_FILE_NAME);
	return %flows_array ;
}

#########################################################################################
#################### subroutine: create_directory #######################################
##
## PARAMETERS: directory name
## OUTPUT: directory is created / if directory exists nothing
##
## RETURNS: dir_exist_flag
#########################################################################################
sub create_directory{
    local($dir, $unix_cmd, $dir_exist_flag);

    $dir = shift;
    $dir_exist_flag = 0;
    if (opendir (DIR, $dir)) {
	printToLog "Warning: directory $dir already exists! \n";
	$dir_exist_flag = 1;
    } else {    
	$unix_cmd = "mkdir $dir" ;
	printToLog "$unix_cmd \n";
	mkdir ("$dir", 0777);
    }
    closedir(DIR);
    return $dir_exist_flag;
}

#########################################################################################
#################### subroutine: create_link ############################################
##
## PARAMETERS: link source, link target
## OUTPUT: link is created / if link exists nothing
##
## RETURNS: link_exist_flag
#########################################################################################
sub create_link{
    local($link_source, $link_target, $unix_cmd);

    $link_source = shift ;
    $link_target = shift ;
#    print "link_source $link_source \nlink_target $link_target\n\n";
    $link_exist_flag = 0;
    if (open (LINK_TARGET, $link_target)) {
	printToLog "Warning: a file/link/directory called $link_target already exists and cannot be modified to link to $link_source \nLink not created!! \n";
	$link_exist_flag = 1;
	close (LINK_TARGET) ;
    } elsif(!open(LINK_SOURCE, $link_source)) {
	print_error_and_die("$link_source does not exist \nLink not created");
    } else {
	$unix_cmd = "ln -s $link_source $link_target" ;
	printToLog "$unix_cmd \n";
	system("$unix_cmd");
    }
    close(LINK_SOURCE);
}

#########################################################################################
#########################################################################################
############################# MGC Project Tree Section  #################################
#########################################################################################


sub add_entry_to_master_location_map{
    local($soft_path, $entry) ;
    
    $soft_path = $_[0] ;
    $entry = $_[1] ;
    print MASTER_LOCATION_MAP "$soft_path \n" ; 
    print MASTER_LOCATION_MAP "$entry \n" ; 
    print MASTER_LOCATION_MAP "/tmp_mnt$entry \n\n" ; 
}

sub add_entry_to_local_location_map{
    local($soft_path, $entry) ;
    
    $soft_path = $_[0] ;
    $entry = $_[1] ;
    print LOCAL_LOCATION_MAP "$soft_path \n" ; 
    print LOCAL_LOCATION_MAP "$entry \n" ; 
    print LOCAL_LOCATION_MAP "/tmp_mnt$entry \n\n" ; 
}

sub create_mgc_tree{
    local($user_name, $mgc_root, $mentor_location_map, $master_location_map, $local_location_map);
    
    $mgc_root = "$PRJ/$project/mgc_master";
    $mentor_location_map = "\$MGC_LOC_MAP_VERS" ;
#
# create master directory tree
#
    printToLog "Creating mgc master directory tree\n";
# project master directory
    &create_directory($mgc_root);
# directory where the schematic capture of the design is stored
    &create_directory("$mgc_root/design");
# directory where files produced by or needed for remote runs are stored 
    &create_directory("$mgc_root/remote");
# directory for swap and other useless data
    &create_directory("$mgc_root/scratch");
# directories for all non-accusim simulations(eldo,hspice,mds,spectre)
    &create_directory("$mgc_root/simulation");
    &create_directory("$mgc_root/simulation/eldo");
    &create_directory("$mgc_root/simulation/hspice");
    &create_directory("$mgc_root/simulation/mds");
    &create_directory("$mgc_root/simulation/spectre");
# directories containing project-related hdla models (source, compiled, symbols)
    &create_directory("$mgc_root/hdla");
    &create_directory("$mgc_root/hdla/hdla_src");
    &create_directory("$mgc_root/hdla/hdla_lib");
    &create_directory("$mgc_root/hdla/hdla_symbols");

# creating or appending to master mgc_location_map

    $master_location_map = "$mgc_root/mgc_location_map";
    if (open(MASTER_LOCATION_MAP, "$master_location_map")){
	printToLog "Warning: Master Location Map already exists!  Appending to it\n";
	open(MASTER_LOCATION_MAP, ">>$master_location_map");
    } else {
	open(MASTER_LOCATION_MAP, ">$master_location_map");
	printToLog "Creating Master Location Map \n" ;
	print MASTER_LOCATION_MAP "# Project Location Map for Project $project\n" ; 
	print MASTER_LOCATION_MAP "MGC_LOCATION_MAP_2\n\n";
	$soft_path = "\$" . $project . "_master";
	&add_entry_to_master_location_map("$soft_path", "$mgc_root/design");
	$soft_path = "\$" . $project . "_master_hdla_symbols";
	&add_entry_to_master_location_map("$soft_path", "$mgc_root/hdla/hdla_symbols");
	$soft_path = "\$" . $project . "_master_hdla_src";
	&add_entry_to_master_location_map("$soft_path", "$mgc_root/hdla/hdla_src");
	$soft_path = "\$" . $project . "_master_hdla_lib";
	&add_entry_to_master_location_map("$soft_path", "$mgc_root/hdla/hdla_lib");
    }

# end of creating or appending to master mgc_location_map

# copy mgcprj.cshrc and mgcprj_layout.cshrc to mgc_master

    $mgc_templates_home = $rds_etc . "/templates" ;

    if ( open(MGCPRJ_SOURCE, "$mgc_templates_home/mgcprj.cshrc")){
	if ( open(MGCPRJ_TARGET, ">$mgc_root/mgcprj.cshrc")){
	    while (<MGCPRJ_SOURCE>) {
		my @line = split;
		if (@line[1] eq "PROJ_ROOT") {
		    print MGCPRJ_TARGET "setenv PROJ_ROOT $PRJ \n";
		} else {
		    print MGCPRJ_TARGET $_ ;
		}
	    }
	    print MGCPRJ_TARGET "setenv DEF_MOD_LIB  $tech \n\n";

	} else {
	    die " ERROR -- cannot write in $mgc_root! \n\n";
	}
    } else {
	die "ERROR -- mgcprj.cshrc not found in $mgc_templates_home! \n\n" ;
    }

    close(MGCPRJ_SOURCE);
    close(MGCPRJ_TARGET);

    if ( open(MGCPRJ_SOURCE, "$mgc_templates_home/mgcprj_layout.cshrc")){
	if ( open(MGCPRJ_TARGET, ">$mgc_root/mgcprj_layout.cshrc")){
	    while (<MGCPRJ_SOURCE>) {
		my @line = split;
		if (@line[1] eq "PROJ_ROOT") {
		    print MGCPRJ_TARGET "setenv PROJ_ROOT $PRJ \n";
		} else {
		    print MGCPRJ_TARGET $_ ;
		}
	    }
	} else {
	    die " ERROR -- cannot write in $mgc_root! \n\n";
	}
    } else {
	die "ERROR -- mgcprj.cshrc not found in $mgc_templates_home! \n\n" ;
    }

    close(MGCPRJ_SOURCE);
    close(MGCPRJ_TARGET);

#
# creating MGC users' directory trees
#
    if ($users){
	foreach $user_name (@users_list){
	    printToLog "Creating user $user_name directory tree\n";
	    &create_directory("$PRJ/$project/work_libs/$user_name");
	    $mgc_root = "$PRJ/$project/work_libs/$user_name/mgc";
	    &create_directory($mgc_root);
# directory where the schematic capture of the user design is stored
	    &create_directory("$mgc_root/design");
# directory where the user's dofiles (simulation scripts) are stored
	    &create_directory("$mgc_root/ample");
	    &create_directory("$mgc_root/doc");
# directory where files produced by or needed for remote runs are stored 
	    &create_directory("$mgc_root/remote");
# directory for swap and other useless data
	    &create_directory("$mgc_root/scratch");
# directories for all non-accusim simulations(eldo,hspice,mds,spectre)
	    &create_directory("$mgc_root/simulation");
	    &create_directory("$mgc_root/simulation/eldo");
	    &create_directory("$mgc_root/simulation/hspice");
	    &create_directory("$mgc_root/simulation/mds");
	    &create_directory("$mgc_root/simulation/spectre");
# directories containing hdla models developed by user(source, compiled, symbols)
	    &create_directory("$mgc_root/hdla");
	    &create_directory("$mgc_root/hdla/hdla_src");
	    &create_directory("$mgc_root/hdla/hdla_lib");
	    &create_directory("$mgc_root/hdla/hdla_symbols");
	    
# adding MGC users' soft_paths to master location map
	    
	    $soft_path = "\$" . $project . "_" . $user_name;
	    &add_entry_to_master_location_map("$soft_path", "$mgc_root/design");

# creating MGC users' location maps

	    $local_location_map = "$mgc_root/mgc_location_map";
	    if (open(LOCAL_LOCATION_MAP, "$local_location_map")){
		printToLog "Warning: Location Map already exists for User $user_name ! \n";
	    } else {
		open(LOCAL_LOCATION_MAP, ">$local_location_map");
		printToLog "Creating Location Map for User $user_name \n" ;
		print LOCAL_LOCATION_MAP "# User location Map for User $user_name and Project $project \n";
		print LOCAL_LOCATION_MAP "MGC_LOCATION_MAP_2\n\n";
		$soft_path = "\$" . $project . "_" . $user_name;
		&add_entry_to_local_location_map("$soft_path", "$mgc_root/design");
		$soft_path = "\$" . $project . "_" . $user_name . "_hdla_symbols";
		&add_entry_to_local_location_map("$soft_path", "$mgc_root/hdla/hdla_symbols");
		$soft_path = "\$" . $project . "_" . $user_name . "_hdla_src";
		&add_entry_to_local_location_map("$soft_path", "$mgc_root/hdla/hdla_src");
		$soft_path = "\$" . $project . "_" . $user_name . "_hdla_lib";
		&add_entry_to_local_location_map("$soft_path", "$mgc_root/hdla/hdla_lib");
		$soft_path = "\$" . $project . "_" . $user_name . "_ample";
		&add_entry_to_local_location_map("$soft_path", "$mgc_root/ample");
		$soft_path = "\$HSP_DIR";
		&add_entry_to_local_location_map("$soft_path", "$mgc_root/simulation/hspice");
		$soft_path = "\$ELDO_DIR";
		&add_entry_to_local_location_map("$soft_path", "$mgc_root/simulation/eldo");
		$soft_path = "\$MDS_DIR";
		&add_entry_to_local_location_map("$soft_path", "$mgc_root/simulation/mds");
		
		print LOCAL_LOCATION_MAP "INCLUDE $master_location_map \n\n";
		close(LOCAL_LOCATION_MAP);

# end of creation of MGC users' location maps
	    }
	}	
    }
    print MASTER_LOCATION_MAP "INCLUDE $mentor_location_map\n\n";
    close(MASTER_LOCATION_MAP);
}


#########################################################################################
############################# CDS Project Tree Section  #################################
#########################################################################################


sub add_entry_to_master_cds_lib{
    local($soft_path, $entry) ;
    
    $soft_path = $_[0] ;
    $soft_path =~ s/-/_/g ;
    $entry = $_[1] ;
    print MASTER_CDS_LIB "DEFINE $soft_path  $entry  \n" ; 
}

sub add_entry_to_local_cds_lib{
    local($soft_path, $entry) ;
    
    $soft_path = $_[0] ;
    $soft_path =~ s/-/_/g ;
    $entry = $_[1] ;
    print LOCAL_CDS_LIB "DEFINE $soft_path  $entry  \n" ; 
}

#
# Return attachment library if it is different from $tech
#
sub get_tech_attach_lib{
 my $tech = shift;
 my $tech_ver = shift;
 # default to $tech
 my $tech_attach = $tech;

 # Hard-coded list of $tech libs that need separate technology lib
 my %techLibs = (
 	sbc18=>sbc18_techlib
	, sbc18pt=>sbc18_techlib
	, bc35=>bc35_techlib
	, sbc35x=>sbc35x_techlib
	, bcd05=>pbc4_primitives
	, CS100A=>fprim100a
	, CS200L=>fprim200l_nonDFM
	, ts11is=> ts011_is_prim
	, ts18sl=>ts018_prim
	, ts18pm=>ts018_pm_prim
	, ts18rf=>ts018_rf_prim
	, ts18c08=>ts018_c08_prim
	, ts35pm=>ts035_pm_prim
	, tsbl13=>ts013_rf_prim
	, ts13sl=>ts013_prim
	, ts100pm=>ts100_pm_prim
	, ts100pmhs=>ts100_pm_prim
	, ts18hv=>ts018_hv_prim
	, ts60=>ts60_prim
	, tsipd=>ipd_prim
	, ts18uhv=>ts018_uhv_prim
	, ts60=>ts60_prim
	, ts18scl=>ts018_scl_prim

);
 # Hard-code sbc18 GTE kit techlib
 if ( ($tech eq "sbc18" or $tech eq "sbc18_gte" ) && -f "$rds_cdslibs/$tech/.paskit") {
	 $techLibs{"sbc18"}="sbc18";
	 $techLibs{"sbc18_gte"}="sbc18";
}

 # Look up appropriate techlib name for this technology
 foreach $lib (keys %techLibs) {
 	if ($tech eq $lib) {
		$tech_attach = $techLibs{$lib};
		return $tech_attach;
	}
 }
 return $tech_attach;
}

sub flow_base_pdk {
	local($flow_lib, $flow_lib_location, $flow)=@_;
		$cdsware = $ENV{'RDS_CDSWARE'};
#		printToLog "path to utility is $cdsware/bin/create_pdk_by_flow.sh \n";
		$status = system("$cdsware/bin/create_pdk_by_flow.sh $rds_root $flow $flow_lib_location\n");
		if ($status) {
			die " ERROR -- fail to create flow Pcell library $flow under $flow_lib_location \n";
		}
}

sub check_low_noise {
	local($noise)=@_;
	open(CIRFILE,"$rds_root/models/default/spectre/circuit.scs") || die "ERROR, can not open the file $rds_root/models/default/spectre/circuit.scs for reading";
	while (<CIRFILE>) {
		if (/uln_flag\s*=\s*(\d)/) {	
			if ($1 != $noise) {
				if ($noise == 1) {
					print_error_and_die("Flow is defined as low noise while PDK instalation is standard. Please download low noise PDK patch");
				}
				else {
					print_error_and_die("Flow is defined as standard while PDK instalation is low noise. Please contact TowerJazz sales to get low noise flow");
				}
			}
		}
	}
}
sub create_cds_tree{
    local($user_name, $cds_root, $local_cds_lib, $master_cds_lib, $system_cds_lib, $soft_path, $master_path, $tdm_project_name, $tech_attach);
    
    $cds_root = "$PRJ/$project/cds_master";
    $system_cds_lib = "\$RDS_CDS_LIB_VERS";


#
# create cds master directory tree
#
    printToLog "Creating cds master directory tree\n";
# project master directory
    &create_directory($cds_root);

# creating or appending to project.lib

    $master_cds_lib = "$cds_root/project.lib";
    if (open(MASTER_CDS_LIB, "$master_cds_lib")){
	printToLog "Warning: project.lib already exists! No further action is taken \n";
	if ($tech eq "ts13sl") {
		if (!$flow_lib) {
			$flow_lib = "update";
		}
	}
	if ($flow_lib eq "update") {
		$tech_attach = &get_tech_attach_lib($tech, $tech_ver);
		$flowLib = "$flow_lib_location/$flow/$tech_attach";
		if (-d $flowLib) {
			&flow_base_pdk($flow_lib, $flow_lib_location, $flow);
		} else {
			printToLog "Warning: Lib flow $flowLib does not exist, can not be update. Need to run the project with create\n";
		}
	}
    } else {
	open(MASTER_CDS_LIB, ">$master_cds_lib");
	printToLog "Creating project.lib \n" ;
	print MASTER_CDS_LIB "# project.lib for Project $project \n\n" ; 
### The master library is created only for projects not under TDM
	if( !$tdm ){
	    &create_directory("$cds_root/design");
	    $master_just_created = (!$dir_exist_flag) ;
	    $soft_path = $project . "_master";
	    &add_entry_to_master_cds_lib("$soft_path", "$cds_root/design");
	    # Adding cdsinfo.tag file to the master directory 
	    open(CDSINFO_TAG, ">$cds_root/design/cdsinfo.tag") ||
		die " ERROR -- cannot create file $cds_root/design/cdsinfo.tag \n\n";
	    print CDSINFO_TAG "# File created by makeProjectTree on ", &get_current_time(), "\n";
	    print CDSINFO_TAG "# Cadence Library \n";
	    print CDSINFO_TAG "CDSLIBRARY \n";
	    close(CDSINFO_TAG);
	}
	print MASTER_CDS_LIB "\nINCLUDE $system_cds_lib\n\n";
	if ($tech eq "ts13sl") {
		if (!$flow_lib) {
			$flow_lib = "create";
		}
	}
	if ($flow_lib) {
		printToLog "calling lib flow pdk creation utility\n";
		if ($flow_lib eq "create") {
			&flow_base_pdk($flow_lib, $flow_lib_location, $flow);
		}
# add flow base library to project.lib		
      		$tech_attach = &get_tech_attach_lib($tech, $tech_ver);
		print MASTER_CDS_LIB "UNDEFINE $tech_attach\n";
		if ($flow_lib eq "create") {
			print MASTER_CDS_LIB "DEFINE $tech_attach $cds_root/$flow/$tech_attach\n";
		} else {
			print MASTER_CDS_LIB "DEFINE $tech_attach $flow_lib_location/$flow/$tech_attach\n";
		}
	}
    }
    close(MASTER_CDS_LIB);

# end of creating master cds.lib

# copy the cdsPrj.cshrc template to cds_master

    $cds_templates_home = $rds_etc . "/templates" ;

    if (open(CDSPRJ_TARGET, "$cds_root/cdsPrj.cshrc")){
	printToLog "Warning: cdsPrj.cshrc already exists! No further action is taken \n";
    }else{
	if (open(CDSPRJ_SOURCE, "$cds_templates_home/cdsPrj.cshrc")){
	    if (open(CDSPRJ_TARGET, ">$cds_root/cdsPrj.cshrc")){
		while (<CDSPRJ_SOURCE>) {
		    my @line = split;
		    if (@line[1] eq "PROJ_ROOT") {
			print CDSPRJ_TARGET "setenv PROJ_ROOT $PRJ \n";
		    } elsif ($tech && (@line[1] eq "RDS_CDS_TECH")){
			print CDSPRJ_TARGET "setenv RDS_CDS_TECH $tech \n";
#		    } elsif ($tech && (@line[1] eq "RDS_CDS_VERIFY_TECH")){
			if ($tech_ver){
			    print CDSPRJ_TARGET "setenv RDS_CDS_VERIFY_TECH $tech_ver \n";
			} else {
			    print CDSPRJ_TARGET "setenv RDS_CDS_VERIFY_TECH $tech \n";
			}
			if ($flow) {
				print CDSPRJ_TARGET "setenv TSP_FLOW $flow \n";
				print CDSPRJ_TARGET "setenv TSP_FLOW_FILE $rds_tech/flowDB/flows.data \n";
				print CDSPRJ_TARGET "setenv RDS_CDS_PEX_TYPE $pex_type \n";
			}
			else {
				if ($pex_type ne "0") {
					print CDSPRJ_TARGET "setenv RDS_CDS_PEX_TYPE $pex_type \n";
				}
			}
		    } elsif ($tech && (@line[1] eq "RDS_ADS_TECH")){
			print CDSPRJ_TARGET "setenv RDS_ADS_TECH $tech \n";
		    } elsif ($sim && (@line[2] eq "RDS_ASI_DIR")){
			if ($sim){
			    print CDSPRJ_TARGET "setenv RDS_ASI_DIR \$PROJ_ROOT\/\$PROJ_ID\/simulation\/\$USER \n";
			} else {
			    print CDSPRJ_TARGET $_ ;
			}
		    } else {
			print CDSPRJ_TARGET $_ ;
		    }
		}
	    } else {
		die " ERROR -- cannot write in $cds_root \n\n";
	    }
	} else {
	    die "ERROR -- cdsPrj.cshrc not found in $cds_templates_home \n\n" ;
	}
    }

    close(CDSPRJ_SOURCE);
    close(CDSPRJ_TARGET);

#
# TDM: creating project structure 
#
    $tdm_project_name = $project . ".Fprj" ;
    if( $tdm ) {
	if( !opendir(TDMPRJ, "$cds_root/$tdm_project_name")) 
	{
	    printToLog "Creating project directory structure for TDM \n";
	    printToLog "tdmmkproject -project $project -location $cds_root -basic -catalog NONE \n";
	    system("tdmmkproject -project $project -location $cds_root -basic -catalog NONE");
	    $first_user = 1;
	    closedir(TDMPRJ);
	} else { 
	    printToLog "Project already set up for TDM \n";
	    closedir(TDMPRJ);
        }
    }
    if ( $tdmcur ) {
        if( -d "$cds_root/$tdm_project_name/.project_raw_data") {
            if( ! -e "$cds_root/$tdm_project_name/.project_raw_data/.tdmrc") {
	        if (open( TDMRC, ">$cds_root/$tdm_project_name/.project_raw_data/.tdmrc")) {
                    printToLog "Creating .tdmrc file for TDM dynamic workarea setup\n";
                    print TDMRC "TDMDYNAMICWA YES\n";
                }
            }        
            if (-d "$cds_root/$tdm_project_name/.project_raw_data/.policies/sun4v") {
                $checkin_post_file_from = "/rds/prod/HOTCODE/amslibs/cds_default/cdsware/bin/checkin.post.dynamic";
                $checkin_post_file_to = "$cds_root/$tdm_project_name/.project_raw_data/.policies/sun4v/checkin.post.dynamic";
                if (-f $checkin_post_file_from) {
                    unlink($checkin_post_file_to);
                    printToLog "Linking checkin.post.dynamic file for TDM post checkin policy\n";
                    symlink("$checkin_post_file_from","$checkin_post_file_to") || do {
	                printToLog "Can't symlink ( $checkin_post_file_from, $checkin_post_file_to):  $!";
                    };                    
                }
            }
        }
    }

#
# creating CDS users' directory trees
#
    if($users){
	foreach $user_name (@users_list){
	    printToLog "Creating user $user_name directory tree\n";
	    &create_directory("$PRJ/$project/work_libs/$user_name");
	    $cds_root = "$PRJ/$project/work_libs/$user_name/cds";
	    &create_directory($cds_root);
# directory where the schematic capture of the user design is stored
	    $dir_exist_flag = &create_directory("$cds_root/design");
	    $localLib_just_created = !$dir_exist_flag;
# Adding cdsinfo.tag file to the design directory 
	    if(open(CDSINFO_TAG, ">$cds_root/design/cdsinfo.tag")){
		print CDSINFO_TAG "# File created by makeProjectTree on ", &get_current_time(), "\n";
		print CDSINFO_TAG "# Cadence Library \n";
		print CDSINFO_TAG "CDSLIBRARY \n";
	    } else {
		die " ERROR -- cannot create file $cds_root/design/cdsinfo.tag \n\n";
	    }
	    &create_directory("$cds_root/doc");
# directory where files produced by or needed for remote runs are stored 
	    &create_directory("$cds_root/remote");
# directory for swap and other useless data
	    &create_directory("$cds_root/scratch");
# directories for cadence simulations
	    if($sim) {
		&create_directory("$sim/$user_name");
		&create_link("$sim_root/simulation/$user_name", "$cds_root/simulation");
	    } else {
		&create_directory("$cds_root/simulation");
	    }
# directory for hspice netlists created by AIF netlister
	    &create_directory("$cds_root/hsp_dir");
# directory for vhdl netlists created by AIF netlister
	    &create_directory("$cds_root/vhdl_dir");
# directory for ic-craftsman data 
	    &create_directory("$cds_root/iccraft");

	    
# creating users' cds.lib
	    
	    $local_cds_lib = "$cds_root/cds.lib";
	    if (open(LOCAL_CDS_LIB, "$local_cds_lib")){
		printToLog "Warning: cds.lib already exists for User $user_name ! \n";
		if ($tdm){
		    open(LOCAL_CDS_LIB, ">>$local_cds_lib");
		    $tdm_library = $project . "_" . work;
		    printToLog "Appending $tdm_library to existing cds.lib for User $user_name \n" ;
		    if ($newtdm){
			&add_entry_to_local_cds_lib("$tdm_library", "$cds_root/design_controlled/$tdm_library");
		    } else {
			&add_entry_to_local_cds_lib("$tdm_library", "$cds_root/design_controlled");
		    }
		    close(LOCAL_CDS_LIB);
		}		    
		
	    } else {
		open(LOCAL_CDS_LIB, ">$local_cds_lib");
		printToLog "Creating cds.lib for User $user_name \n" ;
		print LOCAL_CDS_LIB "# User cds.lib for User $user_name and Project $project \n\n";
		$soft_path = $project . "_" . $user_name;
		&add_entry_to_local_cds_lib("$soft_path", "$cds_root/design");
# adding controlled library to cds.lib
		if ($tdm){
		    $tdm_library = $project . "_" . work;
		    if($newtdm){
			&add_entry_to_local_cds_lib("$tdm_library", "$cds_root/design_controlled/$tdm_library");
		    } else {
			&add_entry_to_local_cds_lib("$tdm_library", "$cds_root/design_controlled");
		    }
		}	    
		print LOCAL_CDS_LIB "\nINCLUDE $master_cds_lib \n\n";
		close(LOCAL_CDS_LIB);
	    }
       
# end of creation of users' cds.lib

# If the -assura and -tech_ver options are specified, creating users' assura_tech.lib
            if ($assura && $tech_ver) {	    
        	$assura_lib = "$cds_root/assura_tech.lib";
	        if (open(ASSURA_LIB, "$assura_lib")){
		    printToLog "Warning: assura_tech.lib already exists for User $user_name ! \n";
	        } else {
		    open(ASSURA_LIB, ">$assura_lib") || die "Cannot open $assura_lib\n";
		    printToLog "Creating assura_tech.lib for User $user_name \n" ;
	            print ASSURA_LIB "# User assura_tech.lib for User $user_name and Project $project \n\n";
		    print ASSURA_LIB "DEFINE $tech_ver \$RDS_ROOT/techs/$tech_ver/assura/default_scr \n";
	        }
		    close(ASSURA_LIB);
	    }
       
# end of creation of users' assura_tech.lib

# If the -pvs and -tech_ver options are specified, creating users' pvtech.lib
            if ($pvs && $tech_ver) {	    
        	$pvs_lib = "$cds_root/pvtech.lib";
	        if (open(PVS_LIB, "$pvs_lib")){
		    printToLog "Warning: pvtech.lib already exists for User $user_name ! \n";
	        } else {
		    if (open(PVS_LIB_SRC, "$rds_tech/$tech_ver/pvs/default_scr/pvtech.lib")){
		        open(PVS_LIB, ">$pvs_lib") || die "Cannot open $pvs_lib\n";
		        printToLog "Creating pvtech.lib for User $user_name from $rds_tech/$tech_ver/pvs/default_scr/pvtech.lib\n" ;
			while (<PVS_LIB_SRC>) {
			    print PVS_LIB $_ ;
			}
		    } else {
		    open(PVS_LIB, ">$pvs_lib") || die "Cannot open $pvs_lib\n";
		    printToLog "Creating pvtech.lib for User $user_name \n" ;
	            print PVS_LIB "# User pvtech.lib for User $user_name and Project $project \n\n";
		    print PVS_LIB "DEFINE $tech_ver \$RDS_ROOT/techs/$tech_ver/pvs/default_scr \n";
                    }
	        }
		    close(PVS_LIB);
	    }
       
# end of creation of users' pvtech.lib

# EAD care

		if ($ead) {
		    system("mkdir -p $cds_root/.cadence");
		    $rds_tech = $ENV{'RDS_TECH'};
		    $rds_cds_verify_tech = $ENV{'RDS_CDS_VERIFY_TECH'};
		    @qrc_dir = glob("$rds_tech/$rds_cds_verify_tech/pvs/default_scr/RCE_*");
		    $mk_link = 1;
		    foreach $qrc_dir (@qrc_dir) {
				@qrc_name = split(/\//, $qrc_dir);
				$qrc_name = $qrc_name[-1];
				if (-d "$qrc_dir/EAD") {
				    warn "Setup the EAD environment...\n";
				    #system("mkdir -p $cds_root/.cadence/$qrc_name; cp -rL $qrc_dir/EAD $cds_root/.cadence/$qrc_name");
					$orig = "$qrc_dir/EAD/1";
				    $dest = "$cds_root/.cadence/$qrc_name/EAD/1";
				    system("mkdir -p $dest/process; mkdir -p $dest/setup");

				    @setup_in = glob("$orig/setup/*_setup.ini");
				    $setup_in = $setup_in[0];
				    @setup_name = split(/\//, $setup_in);
				    $setup_name = $setup_name[-1];
					open(SETUP_IN, $setup_in) || die "Error: cannot open the file '$setup_in' for reading\n";
				    $setup_out = "$dest/setup/$setup_name";
				    open(SETUP_OUT, ">$setup_out") || die "Error: cannot open the file '$setup_out' for writing\n";
				    $process_path = ".cadence/dfII/EAD/1/process/";
				    while (<SETUP_IN>) {
						s/(processSettings=)(.+)/$1$process_path$2/;
						print SETUP_OUT;
					}

				    @process_in = glob("$orig/process/*_process.ini");
				    $process_in = $process_in[0];
				    @process_name = split(/\//, $process_in);
				    $process_name = $process_name[-1];
				    open(PROCESS_IN, $process_in) || die "Error: cannot open the file '$process_in' for reading\n";
					$process_out = "$dest/process/$process_name";
				    open(PROCESS_OUT, ">$process_out") || die "Error: cannot open the file '$process_out' for writing\n";
				    $tech_path = "$qrc_dir/eadTechFile";
				    if (-e $tech_path) {
						$tech_path = "\$RDS_TECH/\$RDS_CDS_VERIFY_TECH/pvs/default_scr/$qrc_name/eadTechFile";
						while (<PROCESS_IN>) {
							s/(ICTModelFile=)(.+)/$1\$RDS_TECH\/\$RDS_CDS_VERIFY_TECH\/pvs\/default_scr\/$qrc_name\/eadTechFile/;
							print PROCESS_OUT;
						}
						if ($mk_link) {
							system("cd $cds_root/.cadence; ln -s $qrc_name dfII");
							$mk_link = 0;
						}  
					}
				    else {
						warn "\nWarning: the '$tech_path' is not provided for this flow/tech/tech_ver $qrc_name. Can be provided upon a request.\n";
				    }

				}
		    }
			if ($mk_link) {
				die "\nError: no eadTechFile exist in your QRC files. Do not use -ead option.\n";
			}
		}


# copy cdsUsr.cshrc and .cdsinit templates to user's account
#	    $cds_templates_home = $rds_etc . "/templates" ;
	    if (open(CDSUSR_TARGET, "$cds_root/cdsUsr.cshrc")){
		printToLog "Warning: cdsUsr.cshrc already exists! No further action is taken \n";
	    }else{
		if (open(CDSUSR_SOURCE, "$cds_templates_home/cdsUsr.cshrc")){
		    if (open(CDSUSR_TARGET, ">$cds_root/cdsUsr.cshrc")){
			while (<CDSUSR_SOURCE>) {
			    my @line = split;
			    if (@line[1] eq "PROJ_ROOT") {
				print CDSUSR_TARGET "setenv PROJ_ROOT $PRJ \n";
			    } elsif ($tech && (@line[1] eq "RDS_ADS_TECH")){
				print CDSUSR_TARGET "setenv RDS_ADS_TECH $tech \n";
			    } elsif ($tech && (@line[1] eq "RDS_CDS_TECH")){
				print CDSUSR_TARGET "setenv RDS_CDS_TECH $tech \n";
			    } else {
				print CDSUSR_TARGET $_ ;
			    }
			}
		    } else {
			die " ERROR -- cannot write in $cds_root! \n\n";
		    }
		} else {
		    die "ERROR -- cdsUsr.cshrc not found in $cds_templates_home! \n\n" ;
		}
	    }
	    close(CDSUSR_SOURCE);
	    close(CDSUSR_TARGET);
	    	
	    if (!open(FILE, "$cds_root/.cdsinit")){
		copy("$cds_templates_home/user.cdsinit", "$cds_root/.cdsinit") || die "ERROR -- .cdsinit couldn't be copied in $cds_root \n" ;
		printToLog "Copying $cds_templates_home/user.cdsinit to $cds_root/.cdsinit\n";
                if ($emx) {
		   system("cat $cds_templates_home/emx.cdsinit >> $cds_root/.cdsinit");
		   printToLog "Appending $cds_templates_home/emx.cdsinit to $cds_root/.cdsinit\n";
		}
	    } else {
		printToLog "Warning: File $cds_root/.cdsinit already exists: Not overridden!\n";
	    }
	    close(FILE);

#
# TDM: creating workarea structure 
#
	    $tdm_workarea_name = $project . "_" . $user_name;
            $tdm_workarea_dir_name = $tdm_workarea_name . ".Work";
	    if($tdm){
		$tdm_creates_links = 1;
		if(!(opendir(TDMWKAREA, "$cds_root/$tdm_workarea_dir_name"))){
		    printToLog "Creating TDM workarea directory structure for user $user_name in project $project \n";
		    printToLog "tdmmkworkarea -workarea $tdm_workarea_name -project $project -location $cds_root -localname $tdm_workarea_name -nousercatalog \n" ;	
		    system("tdmmkworkarea -workarea $tdm_workarea_name -project $project -location $cds_root -localname $tdm_workarea_name -nousercatalog");
		    if($newtdm) {
			&create_directory("$cds_root/$tdm_workarea_dir_name/$tdm_library");
# Adding cdsinfo.tag file to the work library directory 
			if( $first_user && open(CDSINFO_TAG, ">$cds_root/$tdm_workarea_dir_name/$tdm_library/cdsinfo.tag")){
			    print CDSINFO_TAG "# File created by makeProjectTree on ", &get_current_time(), "\n";
			    print CDSINFO_TAG "# Cadence Library \n";
			    print CDSINFO_TAG "CDSLIBRARY \n";
			    close(CDSINFO_TAG);
			} elsif (!$first_user){
			    printToLog "Warning: cdsinfo.tag file not created because already checked into the vault\n";
			    close(CDSINFO_TAG);
			} else {
			    die " ERROR -- cannot create file $cds_root/$tdm_workarea_dir_name/$tdm_library/cdsinfo.tag \n\n";
			}			
		    }
                    else {
# Adding cdsinfo.tag file to the work library directory 
			if( $first_user && open(CDSINFO_TAG, ">$cds_root/$tdm_workarea_dir_name/cdsinfo.tag")){
			    print CDSINFO_TAG "# File created by makeProjectTree on ", &get_current_time(), "\n";
			    print CDSINFO_TAG "# Cadence Library \n";
			    print CDSINFO_TAG "CDSLIBRARY \n";
			    close(CDSINFO_TAG);
			} elsif (!$first_user){
			    printToLog "Warning: cdsinfo.tag file not created because already checked into the vault\n";
			    close(CDSINFO_TAG);
			} else {
			    die " ERROR -- cannot create file $cds_root/$tdm_workarea_dir_name/cdsinfo.tag \n\n";
			}			
                    }
		} else {
		    print "Workarea already set up for TDM \n";
		    $tdm_creates_links = 0;
		    closedir(TDMWKAREA);
		}
	    }

# cd to user's location 

	    printToLog "cd $cds_root \n";
	    chdir $cds_root;

# creating proper links inside the tdm workarea

	    if($tdm && $tdm_creates_links){
		printToLog "ln -s $tdm_workarea_dir_name design_controlled \n";
		system("ln -s $tdm_workarea_dir_name design_controlled");
		printToLog "cd $tdm_workarea_dir_name \n";
		chdir $tdm_workarea_dir_name;
		printToLog "rm cds.lib project.lib \n";
		system("rm cds.lib project.lib"); 
		printToLog "ln -s ../cds.lib .\n";
		printToLog "ln -s ../.cdsinit .\n";
		system("ln -s ../cds.lib .");
		system("ln -s ../.cdsinit .");
                if($assura && $tech_ver) {
		    printToLog "ln -s ../assura_tech.lib .\n";
		    system("ln -s ../assura_tech.lib");
		}
        if($pvs && $tech_ver) {
			printToLog "ln -s ../pvtech.lib .\n";
			system("ln -s ../pvtech.lib");
		}
	    }

# Configuring the created directory as a Cadence library

	    printToLog "cd $cds_root \n";
	    chdir $cds_root;

# Attaching user's library to the technology file of the technology specified by the -tech option
# Attaching also master library if they have been created during this run

	 if (! $noattach){
      # Determine correct attachment library name based on tech and tech_ver
      $tech_attach = &get_tech_attach_lib($tech, $tech_ver);
		open(FILE, ">attachLib.il") || die "ERROR -- cannot create file attachLib.il! \n\n" ;
		if ($localLib_just_created || $attach){
		    $soft_path = $project . "_" . $user_name;
		    print FILE "techBindTechFile(ddGetObj(\"$soft_path\") \"$tech_attach\" \"tech.db\" t) \n";
		    printToLog "Attaching library $soft_path to technology library $tech_attach \n" ;
		}
		if ($master_just_created || $attach){
		    $master_path = $project . "_master";
		    print FILE "techBindTechFile(ddGetObj(\"$master_path\") \"$tech_attach\" \"tech.db\" t) \n";
		    printToLog "Attaching library $master_path to technology library $tech_attach \n" ;
		    $master_just_created = 0 ;
		}
		if ($tdm && $first_user){
		    print FILE "techBindTechFile(ddGetObj(\"$tdm_library\") \"$tech_attach\" \"tech.db\" t) \n";
		    printToLog "Attaching library $tdm_library to technology library $tech_attach \n" ;
		}
      		close(FILE);
		
# run icfb in the background to attach the libraries to the appropriate technology library
# iff attachLib.log is not empty
		if (-s "attachLib.il") {
		    printToLog "virtuoso -nograph -replay $cds_templates_home/attachLib.log \n" ;
		    $result = system("virtuoso -nograph -replay $cds_templates_home/attachLib.log");
			if ($result == 0) {
				 system("rm attachLib.il");
				 printToLog "Libraries attached to technology library $tech_attach \n" ;
			} else {
		    printToLog "Error attaching to technology library $tech_attach \n" ;
			}
		} else {
		    printToLog "No new libraries created. No attachment needed \n" ;
		    system("rm attachLib.il");
		}	    
	 }
	 if ($tdm && $first_user){
		printToLog "cd $tdm_workarea_dir_name \n";
		chdir $tdm_workarea_dir_name;
		printToLog "tdmcheckin -i $tdm_library \n" ;
		system("tdmcheckin -i $tdm_library \n");
		$first_user = 0;
	    } elsif ($tdm) {
		printToLog "cd $tdm_workarea_dir_name \n";
		chdir $tdm_workarea_dir_name;
		printToLog "tdmupdate \n" ; 
		system("tdmupdate \n");
	    }
	}
    }
}

#########################################################################################
################# Verification Project Tree Section with CDS Front-End ##################
#########################################################################################

sub create_verification_tree_cds{
    local($user_name, $ver_root);
    
    $ver_root = "$PRJ/$project/verification";

    &create_directory("$ver_root");
    &create_directory("$ver_root/ant");
    &create_directory("$ver_root/cbr_dir");
    &create_directory("$ver_root/ckm_dir");
    &create_directory("$ver_root/density");
    &create_directory("$ver_root/dfm");
    &create_directory("$ver_root/drc");
    &create_directory("$ver_root/drclvs");
    &create_directory("$ver_root/softerc");
#    &create_directory("$ver_root/erc");
    &create_directory("$ver_root/esd_lup");
    &create_directory("$ver_root/lup");
    &create_directory("$ver_root/lvs");
    &create_directory("$ver_root/pex");
    &create_directory("$ver_root/street");
    &create_directory("$ver_root/stress");

}


#########################################################################################
################# Verification Project Tree Section with MGC Front-End ##################
#########################################################################################

sub create_verification_tree_mgc{
    local($user_name, $ver_root, $mgc_root, $master_location_map);
    
    $mgc_root = "$PRJ/$project/mgc_master";
    $ver_root = "$PRJ/$project/verification";

    &create_directory("$ver_root");
    &create_directory("$ver_root/ckm_dir");
    &create_directory("$ver_root/cbr_dir");
    &create_directory("$ver_root/drc");
    &create_directory("$ver_root/lvs");
    &create_directory("$ver_root/drclvs");
    &create_directory("$ver_root/erc");
    &create_directory("$ver_root/ant");
    &create_directory("$ver_root/pex");
    &create_directory("$ver_root/lup");


# add $CKM_DIR and $CBR_DIR softpath in the master location map
 
    $master_location_map = "$mgc_root/mgc_location_map";
    if (open(MASTER_LOCATION_MAP, "$master_location_map")){
	printToLog "Warning: Master Location Map already exists!  Appending to it\n";
	open(MASTER_LOCATION_MAP, ">>$master_location_map");
	$soft_path = "\$" . "CKM_DIR";
	&add_entry_to_master_location_map("$soft_path", "$ver_root/ckm_dir");
	$soft_path = "\$" . "CBR_DIR";
	&add_entry_to_master_location_map("$soft_path", "$ver_root/cbr_dir");
	close(MASTER_LOCATION_MAP);
    } else {
	die "ERROR -- MGC tree should be created first! \n\n" ;
    }    

}

#########################################################################################
##################### subroutine: get_current_time ######################################
##
## PARAMETERS: none
##
## RETURNS: "$year/$mon/${mday}_$hour:$min:$sec"
#########################################################################################

sub get_current_time
{
    local($sec,$min,$hour,$mday,$mon,$year,@discard) = localtime(time);
    $mon = $mon + 1;
    if ($mon =~ /^\d$/) { $mon = "0$mon";}
    if ($mday =~ /^\d$/) { $mday = "0$mday";}
    if ($hour =~ /^\d$/) { $hour = "0$hour";}
    if ($min =~ /^\d$/) { $min = "0$min";}
    if ($sec =~ /^\d$/) { $sec = "0$sec";}
	 $year = $year + 1900; # Y2K correct
 
    return "$year/$mon/${mday}_$hour:$min:$sec";
}
#########################################################################################

#########################################################################################
##################### subroutine: print_error_and_die ###################################
##
## PARAMETERS: error string
##
## RETURNS: exit
#########################################################################################

sub print_error_and_die
{
    my $error_msg = shift ;
    &usage ;
    printToLog "\nERROR --  $error_msg \n" ;
    printToLog "Execution interrupted! \n\n" ;
    exit 0;
}

#########################################################################################
#########################################################################################
###################################### MAIN SCRIPT ######################################
#########################################################################################
#########################################################################################

use Cwd;
use File::Copy;

$PRJ = cwd();
$current_dir = cwd();

# load Unix Env variables
if (!($rds_root = $ENV{'RDS_ROOT'})) {die "ERROR -- Define RDS_ROOT first \n";}
if (!($rds_cdslibs = $ENV{'RDS_CDSLIBS'})) {die "ERROR -- Define RDS_CDSLIBS first \n";}
if (!($rds_etc = $ENV{'RDS_ETC'})) {die "ERROR -- Define RDS_ETC first \n";}
if (!($rds_tech = $ENV{'RDS_TECH'})) {die "ERROR -- Define RDS_TECH first \n";}

if ((!($ARGV[0]) || ($ARGV[0] =~ /^\-/))){
    if (!($ARGV[0] =~ /^(-help|-h)\b/)){
	&usage;
	print "ERROR -- project name not specified!! \n" ;
	print "Directory structure generation terminated! \n\n" ;
	exit 0;
    } else {
	print "\nHelp!! \n" ;
	&usage;
	exit 0;
    }
}

@line = split(/\./,$ARGV[0]);

$project = $ARGV[0];
shift;

if ($PRJ =~ /$project/) {
    $_ = $PRJ ;
    s/\/$project//;
    $PRJ = $_ ;
}

if ($PRJ =~ /tmp_mnt/) {
    $_ = $PRJ ;
    s/\/tmp_mnt//;
    $PRJ = $_ ;
}


# option variables initialization
$users = 0; $all = 0; $mgc = 0; $cds = 0; 
$verification = 0; $attach = 0; $noattach = 0;
$tech = 0; $sim = 0; $tech_ver = 0; 
$dir_exist_flag = 0; $tdm=0; $newtdm=0; $first_user=0; $assura = 0; $pvs = 0; $ead = 0 ;
$flow = 0; $flows_file = 0; $emx = 0; 
$flow_lib = 0 ; $flow_lib_location  = 0; $pex_type=0 ; 


# Read options
while (<@ARGV> && ($_ = shift) ne ""){
  option: {
      /^-users$/ && do { $users = 1; $users_file_name = shift; last option;};
      /^-cds$/ && do { $cds = 1; last option;};
      /^-newtdm$/ && do { $tdm = 1; $newtdm=1; last option;};
      /^-tdm$/ && do { $tdm = 1; $newtdm=1; last option;};
      /^-oldtdm$/ && do { $tdm = 1; last option;};
      /^-tdmcur$/ && do { $tdmcur = 1; $tdm = 1; $newtdm=1; last option;};
      /^-sim$/ && do { $sim = shift; last option;};
      /^-ver$/ && do { $verification = 1; last option;};
      /^-flow$/ && do { $flow = shift; last option;};
      /^-flows_file$/ && do {$flows_file = shift;  last option;};
      /^-flow_lib$/ && do {$flow_lib= shift;  last option;};
      /^-flow_lib_location$/ && do {$flow_lib_location = shift;  last option;};
      /^-tech$/ && do { $tech = shift; last option;};
      /^-tech_ver$/ && do { $tech_ver = shift; last option;};
      /^-pex$/ && do { $pex_type = shift; last option;};
      /^-assura$/ && do { $assura = 1; last option;};
      /^-pvs$/ && do { $pvs = 1; last option;};
      /^-ead$/ && do { $ead = 1; last option;};
      /^-emx$/ && do { $emx = 1; last option;};
      /^-attach$/ && do { $attach = 1; last option;};
      /^-noattach$/ && do { $noattach = 1; last option;};
      /^-help/ && do { $help = 1; &usage; exit 0;};
      /^-h/ && do { $help = 1; &usage; exit 0;};

# Give error message and exit if wrong option
      {
	&usage;
	print "ERROR --  option $_ unknown\n" ;
	print "Directory structure generation terminated! \n\n" ;
	exit 0;
    }
  }
}

printToLog "pex type is : $pex_type\n";
if ($flow_lib && $flow_lib ne "use" && $flow_lib ne "create"  &&  $flow_lib ne "update" ) {
	die "\n ERROR --flow lib can be 'use', 'update' or 'create'. illigal value for option -flow_lib $flow_lib \n\n";
}
if (!$flow_lib && $flow_lib_location) {
	die "\n ERROR --flow lib location can not be defined or used w/o -lib_flow definition\n";
}

if ($flow_lib && $flow_lib_location) {
	if (!-d $flow_lib_location) {
		die "\n ERROR --flow lib location $flow_lib_location does not exist\n";
	}
} else {
	$flow_lib_location = "$PRJ/$project/cds_master";
}
&signature;
print "\n***** Executing *****\n\n" ;

## create the project directory if it has not been created yet ##
if (opendir(PROJ_DIR, "$PRJ/$project")) {
    print "Warning: project directory $PRJ/$project already exists \n";
} else {
    &create_directory("$PRJ/$project");
}
closedir(PROJ_DIR);

# Activate LOGFILE handle and open logfile
$log_file = $project . "_creation.log" ; 
    if (open(LOGFILE, "$PRJ/$project/$log_file")){
	if (open(LOGFILE, ">>$PRJ/$project/$log_file")) {
	    printToLog "\n\nWarning: Log File $log_file already exists!  Appending to it\n\n";
	    print LOGFILE "Section appended by makeProjectTree on ", &get_current_time(), "\n\n";
	} else {
	    die "\n ERROR -- cannot append to existing $log_file in $PRJ/$project! \n\n";
	}
    } elsif (open(LOGFILE, ">$PRJ/$project/$log_file")){
	printToLog "\nCreating Log File $log_file in $PRJ/$project/ \n\n";
	print LOGFILE "File created by makeProjectTree on ", &get_current_time(), "\n\n";
    } else {
	die "\n ERROR -- cannot create $log_file in $PRJ/$project! \n\n";
    }

printToLog "Project directory being created is: $PRJ/$project \n" ;


#########################################################################################
##################################### Sanity Checks #####################################
#########################################################################################
# check flow option
# do not allow users that have flows_file set or in place to use -tech -tech_ver
if ($flows_file || -e "$rds_tech/flowDB/flows_file") {
	if ($tech) {
		print_error_and_die("Options -tech not allowed Please use -flow option.");
	}
	if ($tech_ver) {
		print_error_and_die("Options -tech_ver allowed Please use -flow option.");
	}
}
if ($flow) {
	if (!$flows_file) {
		$flows_file = "$rds_tech/flowDB/flows_file";
	}
	if ($tech) {
		print_error_and_die("Options -flow and -tech cannot be specified at the same time.");
	}
	if ($tech_ver) {
		print_error_and_die("Options -flow and -tech_ver cannot be specified at the same time.");
	}
	printToLog "Flows file :$flows_file\n";
	%flows_list = parse_flows_file($flows_file);
	printToLog "Flows being set up:\n";
	if (defined($flows_list{$flow})) {
		printToLog "Flow:$flow, Tech:$flows_list{$flow}[1], Tech_ver:$flows_list{$flow}[2] pex type:$flows_list{$flow}[3] \n";
		$tech = $flows_list{$flow}[1];
		$tech_ver = $flows_list{$flow}[2];
		if ($flows_list{$flow}[3] eq "TBEALL") {
			$pex_type = $flows_list{$flow}[3];
			printToLog "pex type is TBEALL: $flows_list{$flow}[3]\n";
		} else {
			if ($flows_list{$flow}[3] eq "TBE") {
				$pex_type = $flows_list{$flow}[3];
				printToLog "pex type is TBE : $flows_list{$flow}[3]\n";
			} else {
				if ($flows_list{$flow}[3] eq "USG") {
					$pex_type = $flows_list{$flow}[3];	
					printToLog "pex type is USG : $flows_list{$flow}[3]\n";
				} else {
					$pex_type = "FSG";	
					printToLog "pex type is FSG : $flows_list{$flow}[3]\n";
				}
			}
		}
	} else {
		print_error_and_die("Flow $flow spicified in option -flow is not supported.\nLook at $flows_file for all supported flows.\n");
	}
} else {
	if ($flows_file) {
		printToLog "-flows_file specified but -flow not specified ignoring\n";
	}
	if ($pex_type eq 0) {
		print_error_and_die("You must define either pex_type or flow\n");
	}
}

if ($tech eq "ts13sl" ) {
    	if ($tech_ver =~ /ts13su/) {
		$tech_ver =~ s/ts13su/ts13sl/;
		check_low_noise(1);
		printToLog "low noise PDK was installed"
        }
	else {
		check_low_noise(0);
	}
	if ($pex_type eq "NONE") {
		$pex_type = "FSG";
	}
}

# Check for conflicting options
if ($noattach && $attach) {
    print_error_and_die("Options -noattach and -attach cannot be specified at the same time.");
}
if ($assura && !($cds && $tech_ver) ) {
    print_error_and_die("Option -assura must be specified together with options -tech_ver and -cds.");
}
if ($pvs && !($cds && $tech_ver) ) {
    print_error_and_die("Option -pvs must be specified together with options -tech_ver and -cds.");
}
if ($ead && !($cds && $tech_ver && pvs) ) {
    print_error_and_die("Option -ead must be specified together with options -tech_ver and -cds and -pvs.");
}

# Exit if a technology is not specified
if (!$tech) {
    print_error_and_die("Technology not specified! Please specify a technology by using -tech");
} else {
    # Check for existence of specified cadence technology library
    if (!opendir(CDS_TECHS_DIR, "$rds_cdslibs")) {
	print_error_and_die("Directory $rds_cdslibs does not exist.");
    } else {    
	my $all_technologies = join ' ', (readdir CDS_TECHS_DIR) ;
	if (!($all_technologies =~ /\b$tech\b/)) {
	    print_error_and_die("Cadence technology libraries not available for specified technology $tech.");
	}
    }
    closedir(CDS_TECHS_DIR);
# Set Unix environment variable to be consistent with the value specified in $tech
    $ENV{'CDS_TECH'} = $tech ;
    $ENV{'RDS_CDS_TECH'} = $tech ;
}



# Check to see whether the verification technology is supported 
# And check if this tech REQUIRES that tech_ver be provided
if ($tech_ver) {
    if (!opendir(TECHS_DIR, "$rds_root/techs")) {
	print_error_and_die("directory $rds_root/techs does not exist.");
    } else {    
	my $all_technologies = join ' ', (readdir TECHS_DIR) ;
	if (!($all_technologies =~ /\b$tech_ver\b/)) {
	    print_error_and_die("Rule files not available for specified technology $tech_ver.");
	}
    }
    closedir(TECHS_DIR);
	 # Set the ENV var needed by kit:
	 $ENV{"RDS_CDS_VERIFY_TECH"} = $tech_ver;
} else {
  # See if tech is the same as the attach lib. If not, error out.
  if (!(&get_tech_attach_lib($tech, "") eq $tech) ) {
    print_error_and_die("Verification Technology must be specified for Technology '$tech'. Please provide the -tech_ver option.");
	}
}

if ($pex_type) {
	 $ENV{"RDS_CDS_PEX_TYPE"} = $pex_type;
} else {
    print_error_and_die("PEX option is not defined in flow_file for '$flow'. Please make sure pex type is defined");
}


#########################################################################################
######################## Directory Structure Creation Section ###########################
#########################################################################################
   
if ($sim){
    $sim_root = "$PRJ/$project";
    chdir $sim_root ;
    &create_link($sim, "simulation") ;
    chdir $current_dir;
}

if ($users){
    open(IN, $users_file_name) || die "ERROR -- file $users_file_name not found! \n\n";
    close(IN);
    @users_list = &parse_users_file($users_file_name);
    printToLog "Users being set up:\n";
    &print_list(@users_list);
}

&create_directory("$PRJ/$project/doc");
&create_directory("$PRJ/$project/gds_dir");
&create_directory("$PRJ/$project/dxf_dir");
&create_directory("$PRJ/$project/bond_info_dir");

if ($all || $mgc){
    &create_directory("$PRJ/$project/work_libs");
    &create_mgc_tree ;
}

if ($all || $cds){
    &create_directory("$PRJ/$project/work_libs");
    &create_cds_tree ;
}

if ($verification){
    if ($mgc){ 
	&create_verification_tree_mgc ;
    } elsif ($cds){
	create_verification_tree_cds ;
    } else {
	print_error_and_die("While creating verification tree: You must specify the System in use -cds or -mgc");
    }
}

close(LOGFILE);
