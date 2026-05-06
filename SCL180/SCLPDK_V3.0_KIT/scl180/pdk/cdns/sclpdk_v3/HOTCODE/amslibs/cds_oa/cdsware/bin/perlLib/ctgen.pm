require 5.004;

package ctgen;

use ctgen::domain;
use ctgen::tree;
use ctgen::const;
use ctgen::cells;

# Constructor
sub new {
    my $type = shift;
    my $this = {};
    bless $this, $type;
    return $this;
}

sub readSynopsysConstraints {
    my $this = shift;
    my $constFile = shift;

    open(CONST, "$constFile") || die "readSynopsysConstraints: Can't open file $constFile\n";
    while (<CONST>) {
	if (/^\s*create_clock\s+(?:-name\s+\"(\S+)\"\s+|)-period\s+(\S+)\s+.*find\(port,\s*\"(\S+)\"\)/) {
            my $clkname;
            if (defined($1)) {$clkname = $1;}
            else {$clkname = $3;}
	    my $period = $2;
	    my $halfcycle = $period/2;
	    my $tree = new ctgen::tree;
	    $tree->setRootIOPin($clkname);
	    my $const = new ctgen::const;
	    $const->setWaveform(0.0, $halfcycle, 0.0, $halfcycle);
	    $const->setMinDelay(0.0);
	    $const->setMaxDelay($period);
	    $const->setMaxTransition($halfcycle/10);
	    my $domain = new ctgen::domain($clkname);
	    $domain->setTree($tree);
	    $domain->setConstraints($const);
	    $this->addDomain($domain);
	}
	if (/^\s*set_clock_skew\s+.*-uncertainty\s+(\S+)\s+.*find\(clock,\s*\"(\S+)\"\)/) {
	    my $domain = $this->getDomain($2);
	    my $const = $domain->getConstraints();
	    $const->setMaxSkew($1);
	}
	if (/^\s*set_max_transition\s+(\S+)\s+find\([port|clock],\s*\"(\S+)\"\)/) {
	    my $domain = $this->getDomain($2);
	    if (defined($domain)) {
		my $const = $domain->getConstraints();
		$const->setMaxTransition($1);
	    }
	}
    }
    close(CONST);

    return $constFile;
}

sub addDomain {
    my $this = shift;
    my $domain = shift;
    $this->{domains}{$domain->getName()} = $domain;
    return $domain;
}

sub getDomain {
    my $this = shift;
    my $domain = shift;

    return $this->{domains}{$domain};
}

sub getDomains {
    my $this = shift;
    return values(%{$this->{domains}});
}

sub writeConstraints {
    my $this = shift;
    my $fileName = shift;

    open(CONST, ">$fileName") || die "writeConstraints: Can't open file $fileName\n";
    my $domain;
    foreach $domain ($this->getDomains()) {
	my $tree = $domain->getTree();
	print CONST $tree->getHeader() . "\n";
	print CONST "    root_iopin '" . $tree->getRootIOPin() . "'\n";

	my $const = $domain->getConstraints();
	my ($riseTime, $highTime, $fallTime, $lowTime) = $const->getWaveform();
	print CONST $const->getHeader() . "\n";
	print CONST "    waveform $riseTime $highTime $fallTime $lowTime\n";
	print CONST "    min_delay " . $const->getMinDelay() . "\n";
	print CONST "    max_delay " . $const->getMaxDelay() . "\n";
	print CONST "    max_skew " . $const->getMaxSkew() . "\n";
	my $maxTrans = $const->getMaxTransition();
	if (defined($maxTrans)) {
	    print CONST "    max_transition $maxTrans\n";
	}

	my $cells = $domain->getCells();
	if (defined($cells)) {
	    print CONST $cells->getHeader() . "\n";
	    print CONST "    buffers";
	    my $cell;
	    foreach $cell ($cells->getBuffers()) {
		print CONST " '$cell'";
	    }
	    print CONST "\n";
	    print CONST "    inverters";
	    foreach $cell ($cells->getInverters()) {
		print CONST " '$cell'";
	    }
	    print CONST "\n";
	}
    }
    close(CONST);
}

# Destructor
sub DESTROY {
    my $this = shift;
}

1;
