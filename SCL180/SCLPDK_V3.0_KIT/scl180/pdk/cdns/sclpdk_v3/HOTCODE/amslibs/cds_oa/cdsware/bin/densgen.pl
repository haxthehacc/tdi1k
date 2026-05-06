#!/usr/local/bin/perl
# $Header: ./HOTCODE/amslibs/cds_oa/cdsware/bin/densgen.pl 1 2019/07/01 11:02:24 GMT ronenha Exp $
# $Log: Revision 1 2019/07/01 11:02:24 GMT ronenha $
#   Initial revision.
# 
#  Revision 1 2019/07/01 11:02:09 GMT ronenha
#   Initial revision.
# 
#  Revision: 1.1 Wed Sep 10 00:21:07 2008 bani
#  density analysis scripts
# 
#  Revision: 1.2 Wed May  9 16:11:27 2007 milkovr
#  Add error checking for gdsroot. Use /bin/sh instead of perl for runscript
# 
#  Revision: 1.1 Fri Apr 20 17:30:53 2007 milkovr
#  Initial checkin windowed density check programs

#creates calibre jobs for metal density coverage and overlap
#based on the given windowSize (def=500) and uptoMetal (def=4)

$inputGDS = shift or usage();
$gdsTopcell = shift;
$windowSize = shift || 500; #default window size is 500um
$uptoMetal = shift || 4;    #default is up to metal 4
$uptoMetal++;
$uptoMetal = "M" . $uptoMetal; #metal layer to stop in createCal()

if ($ENV{DENS_ROOT}) {
    $densTemplate = "$ENV{DENS_ROOT}/density.template";
} else {
    $densTemplate = "$ENV{RDS_TECH}/generic/calibre/density.template";
}
unless ($gdsTopcell) {
	 ($gdsroot) = grep {-x "$_/gdsroot" } (split /:/, $ENV{"PATH"} );
	 unless ($gdsroot) {
	 	print "** densgen: Cannot locate 'gdsroot' command.\nYou must provide the GDS top cell name\n";
		exit 1;
	}
    print "Getting topcell ..\n";
    @line = `gdsroot $inputGDS`;
    if ($# > 0) {
        print "** densgen: multiple topcells in $inputGDS\n";
        exit 1;
    }
    $line = shift @line;
    (@val) = split /\s+/, $line;
    $gdsTopcell = $val[$#val];
}
$| = 1;
createCal($windowSize, $uptoMetal, ".density", "density.rules");
createCal($windowSize/2, $uptoMetal, "_overlap.density", "overlap_density.rules");
createRunCal("density");
createRunCal("overlap_density");
exit;

sub createRunCal {
	my ($cal) = @_;
	$run = "run." . $cal;
	print "Creating $run ..\n";
	open R, ">$run" or die $!;
	print R "#!/bin/sh\n";
	print R "calibre -drc -hier ${cal}.rules >log.${cal}\n";
	close R;
	# Calculate mode based on current umask + execute
	chmod( (0777 & (~ umask())), $run);
}

sub createCal {
    my ($stepSize, $lastMetal, $suff, $densRule) = @_;
    print "Creating $densRule ..\n";
    undef @lines;
    open T, $densTemplate or die $!;
    while (<T>) {
        last if /^$lastMetal/;
        s/__GDS__/$inputGDS/;
        s/__TOP__/$gdsTopcell/;
        s/__SZ__/$windowSize/;
        s/__ST__/$stepSize/;
        s/__OUT__/$suff/;
        push @lines, $_;
    }
    close T;
    open R, ">$densRule" or die $!;
    for (@lines) {
        print R $_;
    }
    close R;
}

sub usage {
    print "Usage: densgen gds [topcell [window-size [upto-metal#]]]\n";
    print "       window-size default = 500um\n";
    print "       upto-metal# default = 4\n";
    exit;
}
