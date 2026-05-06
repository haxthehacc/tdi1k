#!/bin/tcsh -f

# add missing hierarchical schematic and layout devices into the flow based ipdk directory

set usage = "USAGE:$0 <HOTCODE> <flow> [dest_lib default:HOTCODE/flows] [flowDB default:HOTCODE/techs/flowDB]"

if ($# < 2) then
    echo
    echo "Error: bad number of arguments - is expected to be at least 2"
    echo
    echo "$usage"
    echo
    exit 1
endif

set hotcode = $1
set flow = $2
if ($# > 2) then
    set dest_lib = $3
    echo
    echo "Info: use the destination flow library '$dest_lib' provided by user"
    echo
endif

set flow_db = "$hotcode/techs/flowDB"
set flows_data = "$flow_db/flows.data"
set flows_file  = "$flow_db/flows_file"
if ($# > 3) then
    set flow_db = $4
    echo 
    echo "Info: use the flowDB path provided by user: '$flow_db'"
    echo
endif
if (-d $flow_db) then
    set flows_data = "$flow_db/flows.data"
    set flows_file  = "$flow_db/flows_file"
else
    echo
    echo "Error: the flowDB '$flow_db' does not exist or is no a directory."
    echo
    echo "$usage"
    echo
    exit 1
endif

set tech_name = `grep -w $flow $flows_file | awk '{print $2}'`
if ($tech_name == "") then
    echo
    echo "Error: the flow 'flow' is not defined in the '$flows_file' or the format is not supported"
    echo
    echo "$usage"
    echo
    exit 1
endif

set ver = `grep -w $flow $flows_file | awk '{print $3}' | sed 's/_/ /g' | awk '{print $2}'`
if ($ver == "") then
    echo
    echo "Error: the flow 'flow' is not defined in the '$flows_file' or the format is not supported"
    echo
    echo "$usage"
    echo
    exit 1
endif

if ($tech_name == "ts18pm") then
    set tech_lib = "ts018_pm_prim"
else if ($tech_name == "ts18sl") then
    set tech_lib = "ts018_prim"
else
    echo "Error: the tech_name '$tech_name' is not supported"
endif

set orig_tech_lib = "$hotcode/amslibs/cds_default/cdslibs/$tech_name/devices/devices_oa_${tech_name}_$ver"
if (! -d $orig_tech_lib) then
    echo
    echo "Error: the tech lib '$orig_tech_lib' does not exist. Please, check if the provided flow is appropriate for the provided HOTCODE library."
    echo
    echo "$usage"
    echo
    exit 1
endif

if (! $?dest_lib) then
    set dest_lib = "$hotcode/flows"
endif

set dest_tech_lib = "$dest_lib/$flow/$tech_lib"

echo
echo "Info: flow $flow"
echo "Info: flow_db $flow_db"
echo "Info: orig_tech_lib $orig_tech_lib"
echo "Info: dest_tech_lib $dest_tech_lib"
echo

#exit 0

rm -rf $dest_tech_lib
mkdir -p $dest_tech_lib
if ($status != 0) then
    echo
    echo "Error: failed to create the $dest_tech_lib"
    echo
    echo "$usage"
    echo
    exit 1
endif

cd $dest_tech_lib
foreach file (`ls $orig_tech_lib`)
    if (-f $orig_tech_lib/$file) then
	ln -s $orig_tech_lib/$file
    endif
end

set sons = ".sch_sons"
cat /dev/null >! $sons
set dev_list = `perl -wne 'BEGIN {$flow = shift} if (/^$flow\s+\S+/) {@dev = split; shift @dev} END {print join (" ", @dev), ""}' $flow $flows_data`

set sons_tmp = .sch_sons_tmp
cat /dev/null >! $sons_tmp
foreach dev ($dev_list)
    echo $dev >> $sons_tmp
end

while ("$dev_list" != "")
    foreach dev ( $dev_list)
	set dm = $orig_tech_lib/$dev/schematic/data.dm
	if (-e $dm) then
	    strings $dm | perl -wne 'BEGIN {$prim = shift; @sons = (); %sons = (); $sons_list = shift; open(SONS, $sons_list); while (<SONS>) { if (/^(\S+)/) { $sons_list{$1} = 1}}} if (/$prim/) { @sons = split(/$prim/, $_); foreach $son (@sons) { if ($son =~ /\"\s+\"([^\"]+)\"\s+\"symbol\"/ && ! defined($sons_list{$1})) { $sons{$1} = 1}} END { foreach $son (keys %sons) {print "$son\n"}}}' $tech_lib $sons_tmp >> $sons
	endif
    end 
    set dev_list = `cat $sons`
    cat $sons >> $sons_tmp
    cat /dev/null >! $sons
end
   
foreach son (`sort -u $sons_tmp`)
    if (-d $orig_tech_lib/$son) then
	cp -rL $orig_tech_lib/$son .
    endif
end

set lay_sons = ".lay_sons"
cat /dev/null >! $lay_sons
foreach lay ($orig_tech_lib/*/layout/layout.oa)
    strings $lay | perl -wne 'BEGIN {$prim = shift; %sons = ()} if (/$prim\.([^\.]+)\.layout/) { $sons{$1} = 1} END { foreach $son (keys %sons) {print "$son\n"}}' $tech_lib >> $lay_sons
end

foreach son (`sort -u $lay_sons`)
    cp -rL $orig_tech_lib/$son .
end

rm -r $sons $sons_tmp $lay_sons
