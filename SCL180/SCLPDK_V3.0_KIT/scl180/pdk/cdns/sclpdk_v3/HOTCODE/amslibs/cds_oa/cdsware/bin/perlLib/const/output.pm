require 5.004;

package const::output;

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

sub setArrivalTime {
    my $this = shift;
    my $at = shift;
    $this->{at} = $at;
    return $at;
}

sub getArrivalTime {
    my $this = shift;
    return $this->{at};
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

sub setLoad {
    my $this = shift;
    my $load = shift;
    $this->{load} = $load;
    return $load;
}

sub getLoad {
    my $this = shift;
    return $this->{load};
}

sub setMaxTransition {
    my $this = shift;
    my $maxtrans = shift;
    $this->{maxtrans} = $maxtrans;
    return $maxtrans;
}

sub getMaxTransition {
    my $this = shift;
    return $this->{maxtrans};
}

1;
