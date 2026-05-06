require 5.004;

package const::input;

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

sub setMinArrivalTime {
    my $this = shift;
    my $minAT = shift;
    $this->{minAT} = $minAT;
    return $minAT;
}

sub getMinArrivalTime {
    my $this = shift;
    return $this->{minAT};
}

sub setMaxArrivalTime {
    my $this = shift;
    my $maxAT = shift;
    $this->{maxAT} = $maxAT;
    return $maxAT;
}

sub getMaxArrivalTime {
    my $this = shift;
    return $this->{maxAT};
}

sub setClockName {
    my $this = shift;
    my $clock = shift;
    $this->{clock} = $clock;
    return $clock;
}

sub getClockName {
    my $this = shift;
    return $this->{clock};
}

sub setDriveStrength {
    my $this = shift;
    my $drive = shift;
    $this->{drive} = $drive;
    return $drive;
}

sub getDriveStrength {
    my $this = shift;
    return $this->{drive};
}

1;
