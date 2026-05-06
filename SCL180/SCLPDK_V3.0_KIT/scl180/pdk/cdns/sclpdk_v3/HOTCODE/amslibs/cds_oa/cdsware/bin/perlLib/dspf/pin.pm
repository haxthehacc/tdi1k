require 5.004;

package dspf::pin;

# Constructor
sub new {
    my $type = shift;
    my $this = {};
    bless $this, $type;
    return $this;
}

sub setSubNetName {
    my $this = shift;
    my $subNetName = shift;
    $this->{subNetName} = $subNetName;
    return $subNetName;
}

sub getSubNetName {
    my $this = shift;
    return $this->{subNetName};
}

sub setXCoord {
    my $this = shift;
    my $x = shift;
    $this->{x} = $x;
    return $x;
}

sub getXCoord {
    my $this = shift;
    return $this->{x};
}

sub setYCoord {
    my $this = shift;
    my $y = shift;
    $this->{y} = $y;
    return $y;
}

sub getYCoord {
    my $this = shift;
    return $this->{y};
}

1;
