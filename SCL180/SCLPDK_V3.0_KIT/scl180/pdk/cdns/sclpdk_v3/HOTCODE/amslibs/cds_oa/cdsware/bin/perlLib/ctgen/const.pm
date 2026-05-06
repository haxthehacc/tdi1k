require 5.004;

package ctgen::const;

# Constructor
sub new {
    my $type = shift;
    my $this = {};
    bless $this, $type;
    $this->{header} = "set_constraints";
    return $this;
}

sub getHeader {
    my $this = shift;
    return $this->{header};
}

sub setWaveform {
    my $this = shift;
    my $riseTime = shift;
    my $highTime = shift;
    my $fallTime = shift;
    my $lowTime = shift;
    $this->{waveform} = [$riseTime, $highTime, $fallTime, $lowTime];
    return $this->{waveform};
}

sub getWaveform {
    my $this = shift;
    return @{$this->{waveform}};
}

sub setMinDelay {
    my $this = shift;
    my $minDelay = shift;
    $this->{minDelay} = $minDelay;
    return $this->{minDelay};
}

sub getMinDelay {
    my $this = shift;
    return $this->{minDelay};
}

sub setMaxDelay {
    my $this = shift;
    my $maxDelay = shift;
    $this->{maxDelay} = $maxDelay;
    return $this->{maxDelay};
}

sub getMaxDelay {
    my $this = shift;
    return $this->{maxDelay};
}

sub setMaxSkew {
    my $this = shift;
    my $maxSkew = shift;
    $this->{maxSkew} = $maxSkew;
    return $this->{maxSkew};
}

sub getMaxSkew {
    my $this = shift;
    return $this->{maxSkew};
}

sub setMaxTransition {
    my $this = shift;
    my $maxTransition = shift;
    $this->{maxTransition} = $maxTransition;
    return $this->{maxTransition};
}

sub getMaxTransition {
    my $this = shift;
    return $this->{maxTransition};
}

# Destructor
sub DESTROY {
    my $this = shift;
}

1;
