require 5.004;

package const::clock;

# Constructor
sub new {
    my $type = shift;
    my $name = shift;
    my $this = {};
    bless $this, $type;
    $this->{name} = $name;
    return $this;
}

sub getName {
    my $this = shift;
    return $this->{name};
}

sub setRootPin {
    my $this = shift;
    my $rootPin = shift;
    $this->{rootPin} = $rootPin;
    return $rootPin;
}

sub getRootPin {
    my $this = shift;
    return $this->{rootPin};
}

sub setRootIOPin {
    my $this = shift;
    my $rootIOPin = shift;
    $this->{rootIOPin} = $rootIOPin;
    return $rootIOPin;
}

sub getRootIOPin {
    my $this = shift;
    return $this->{rootIOPin};
}

sub setPeriod {
    my $this = shift;
    my $period = shift;
    $this->{period} = $period;
    return $period;
}

sub getPeriod {
    my $this = shift;
    return $this->{period};
}

sub setRiseTime {
    my $this = shift;
    my $riseTime = shift;
    $this->{riseTime} = $riseTime;
    return $riseTime;
}

sub getRiseTime {
    my $this = shift;
    return $this->{riseTime};
}

sub setFallTime {
    my $this = shift;
    my $fallTime = shift;
    $this->{fallTime} = $fallTime;
    return $fallTime;
}

sub getFallTime {
    my $this = shift;
    return $this->{fallTime};
}

sub setPosTransTime {
    my $this = shift;
    my $posTransTime = shift;
    $this->{posTransTime} = $posTransTime;
    return $posTransTime;
}

sub getPosTransTime {
    my $this = shift;
    return $this->{posTransTime};
}

sub setNegTransTime {
    my $this = shift;
    my $negTransTime = shift;
    $this->{negTransTime} = $negTransTime;
    return $negTransTime;
}

sub getNegTransTime {
    my $this = shift;
    return $this->{negTransTime};
}

sub setMinInsertionDelay {
    my $this = shift;
    my $minDelay = shift;
    $this->{minDelay} = $minDelay;
    return $minDelay;
}

sub getMinInsertionDelay {
    my $this = shift;
    return $this->{minDelay};
}

sub setMaxInsertionDelay {
    my $this = shift;
    my $maxDelay = shift;
    $this->{maxDelay} = $maxDelay;
    return $maxDelay;
}

sub getMaxInsertionDelay {
    my $this = shift;
    return $this->{maxDelay};
}

sub setMaxSkew {
    my $this = shift;
    my $maxSkew = shift;
    $this->{maxSkew} = $maxSkew;
    return $maxSkew;
}

sub getMaxSkew {
    my $this = shift;
    return $this->{maxSkew};
}

sub setMaxTransition {
    my $this = shift;
    my $maxTransition = shift;
    $this->{maxTransition} = $maxTransition;
    return $maxTransition;
}

sub getMaxTransition {
    my $this = shift;
    return $this->{maxTransition};
}

sub addBufferCell {
    my $this = shift;
    my $buffer = shift;
    push(@{$this->{buffers}}, $buffer);
    return $buffer;
}

sub addBufferCellList {
    my $this = shift;
    my $listFile = shift;
    foreach $cell (readCellList($listFile)) {
	push(@{$this->{buffers}}, $cell);
    }
    return $listFile;
}

sub getBufferCells {
    my $this = shift;
    if(defined($this->{buffers})) { return @{$this->{buffers}}; }
    else { my @l; return @l; }
}

sub addInverterCell {
    my $this = shift;
    my $inverter = shift;

    push(@{$this->{inverters}}, $inverter);
    return $inverter;
}

sub addInverterCellList {
    my $this = shift;
    my $listFile = shift;
    foreach $cell (readCellList($listFile)) {
	push(@{$this->{inverters}}, $cell);
    }
    return $listFile;
}

sub getInverterCells {
    my $this = shift;
    if(defined($this->{inverters})) { return @{$this->{inverters}}; }
    else { my @l; return @l; }
}

sub readCellList {
    my $fileName = shift;
    my @cellList;

    open(INP, "$fileName") || die "readCellList: Can't open file $fileName\n";
    while (<INP>) {
	chop;
	@cellList = (@cellList, $_);
    }
    close(INP);

    return @cellList;
}

1;
