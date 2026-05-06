#!/usr/local/bin/perl
# $Header: ./HOTCODE/amslibs/cds_oa/cdsware/bin/denstack.pl 1 2019/07/01 11:02:24 GMT ronenha Exp $
# $Log: Revision 1 2019/07/01 11:02:24 GMT ronenha $
#   Initial revision.
# 
#  Revision 1 2019/07/01 11:02:09 GMT ronenha
#   Initial revision.
# 
#  Revision: 1.1 Fri Apr 20 17:30:54 2007 milkovr
#  Initial checkin windowed density check programs

#Given stackToMet (def=3), finds avg. of metal density coverage and overlap
#from M1.density .. Mn.density and creates StackToMn.density, and
#M1_overlap.density .. Mn_overlap.density anc creates StackToMn_overlap.density

$stackToMet = shift || 3;
$topMet = shift || $stackToMet;
$err = 0;
for $i (1 .. $stackToMet) {
    $f = "M" . $i . ".density";
    unless (-f $f) {
        print "** $f does not exist\n";
        $err++;
    }
    push @covList, $f;
}
for $i (1 .. $stackToMet) {
    $f = "M" . $i . "_overlap.density";
    unless (-f $f) {
        print "** $f does not exist\n";
        $err++;
    }
    push @ovrList, $f;
}
exit if $err > 0;

$fileCount = 0;
for $f (@covList) {
    $fileCount++;
    open I, "$f" or die $!;
    $lineCount = 0;
    while (<I>) {
        ($xl,$yl,$xh,$yh,$v) = split /\s+/;
        if ($fileCount == 1) {
            push @xl, $xl;
            push @yl, $yl;
            push @xh, $xh;
            push @yh, $yh;
        }
        $covVal[$lineCount] += $v;
        $lineCount++;
    }
    close I;
}
$outFile = "StackToM" . $stackToMet . ".density";
open OUT, ">$outFile" or die $!;
for $i (0 .. $lineCount-1) {
    $stackVal = sprintf("%8.6f", $covVal[$i]/$topMet);
    print OUT "$xl[$i] $yl[$i] $xh[$i] $yh[$i] $stackVal\n";
}
close OUT;

$fileCount = 0;
undef @xl, @yl, @xh, @yh;
for $f (@ovrList) {
    $fileCount++;
    open I, "$f" or die $!;
    $lineCount = 0;
    while (<I>) {
        ($xl,$yl,$xh,$yh,$v) = split /\s+/;
        if ($fileCount == 1) {
            push @xl, $xl;
            push @yl, $yl;
            push @xh, $xh;
            push @yh, $yh;
        }
        $ovrVal[$lineCount] += $v;
        $lineCount++;
    }
    close I;
}
$outFile = "StackToM" . $stackToMet . "_overlap.density";
open OUT, ">$outFile" or die $!;
for $i (0 .. $lineCount-1) {
    $stackVal = sprintf("%8.6f", $ovrVal[$i]/$topMet);
    print OUT "$xl[$i] $yl[$i] $xh[$i] $yh[$i] $stackVal\n";
}
close OUT;
