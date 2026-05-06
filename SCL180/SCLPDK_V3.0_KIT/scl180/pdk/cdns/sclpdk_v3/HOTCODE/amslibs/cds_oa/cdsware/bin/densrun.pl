#!/usr/local/bin/perl

# $Header: ./HOTCODE/amslibs/cds_oa/cdsware/bin/densrun.pl 1 2019/07/01 11:02:24 GMT ronenha Exp $
# $Log: Revision 1 2019/07/01 11:02:24 GMT ronenha $
#   Initial revision.
# 
#  Revision 1 2019/07/01 11:02:09 GMT ronenha
#   Initial revision.
# 
#  Revision: 1.1 Fri Apr 20 17:30:54 2007 milkovr
#  Initial checkin windowed density check programs

# Script to run multiple steps for windowed density checks
# - densgen to write single-layer check
# - run.density and run.overla_density Calibre ruledecks
# - denstack to aggregate multi-layer window data
# - denshow to open data viewer

$gdsFile = shift;
$topCell = shift;
$windowSize = shift;
$topMetal = shift || 6;

$result = system("densgen", $gdsFile, $topCell, $windowSize, $topMetal);
if ($result) {
	print "Error completing densgen Calibre deck writing\n";
	exit 1;
}
$result = system("./run.density");
if ($result) {
	print "Error running Calibre density deck 'run.density'\n";
	exit 1;
}
$result = system("./run.overlap_density");
if ($result) {
	print "Error running Calibre density deck 'run.overlap_density'\n";
	exit 1;
}
for ($toMet=2; $toMet<$topMetal; $toMet++) {
	$result = system("denstack", $toMet, $topMetal);
	if ($result) {
		print "Error running density calculation 'denstack' for metal M1-$toMet of $topMetal\n";
		exit 1;
	}
}
$result  = exec("denshow");
print "Error running density viewer 'denshow'\n";
exit 1;
