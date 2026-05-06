#!/tools/perl/bin/perl

# create_write_vgh_cscr - create two Synopsys scripts:
#     "write_vgh.scr" and "write_cscr.scr"
#     write_vgh.scr writes 
#       (1) hierarchical verilog file for the top: $top.vgh
#       (2) top verilog without module definition: $top_without_module.vgh
#       (3) hierarchical verilog file for each module: $module.vgh
#     write_cscr.scr writes
#       (1) constraint file for each module: $moduel.cscr
#
# Author: Jie Yu

BEGIN {
    $rds_cdsware = $ENV{RDS_CDSWARE};
    push(@INC, "$rds_cdsware/bin/perlLib");
}

use config;
use const;

sub Usage {die "\nUsage: $0 configFile\n\n";}
if ($#ARGV == -1) {Usage;}

$configFile = shift;

$vghFileName = "write_vgh.scr";
$cscrFileName = "write_cscr.scr";

#
# Read in project configuration variables
#
$topCell    = config::parseScalar($configFile, "top_cell");
@moduleList = config::parseList($configFile, "module_list");
$vgh_dir    = config::parseScalar($configFile, "vgh_dir");
$const_dir  = config::parseScalar($configFile, "const_dir");

open(OFILE, ">$vghFileName") || die "Cannot write $vghFileName\n";

#
# write full verilog for top
#
print OFILE "# write full verilog for top\n";
print OFILE "current_design $topCell\n";
print OFILE "write -format verilog -hierarchy -output $vgh_dir/$topCell.vgh\n\n";

#
# write top verilog without modules definition
#
print OFILE "# write top verilog without modules definition\n";
print OFILE "write -format verilog -output $vgh_dir/$topCell";
print OFILE "_without_modules.vgh\n\n";

#
# write verilog file for each module
#
print OFILE "# write verilog file for each module\n";
foreach $module (@moduleList) {
  print OFILE "current_design $module\n";
  print OFILE "write -format verilog -hierarchy -output $vgh_dir/$module.vgh\n\n";
}
close(OFILE);

open(OFILE, ">$cscrFileName") || die "Cannot write $cscrFileName\n";
#
# write constraint file for each module
#
print OFILE "# write constraint file for each module\n";
foreach $module (@moduleList) {
  print OFILE "write_script -no_annotated_check -no_annotated_delay ";
  print OFILE "-format dcsh -output $const_dir/$module.cscr\n\n";
};
close(OFILE);

print "\nOutput Synopsys scripts to $vghFileName and $cscrFileName\n\n";
exit 0;

