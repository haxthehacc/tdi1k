require 5.004;

package dspf::instance;

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

sub setModelName {
    my $this = shift;
    my $modelName = shift;
    $this->{modelName} = $modelName;
    return $modelName;
}

sub getModelName {
    my $this = shift;
    return $this->{modelName};
}

sub addNodeName {
    my $this = shift;
    my $node = shift;
    push(@{$this->{nodeNames}}, $node);
    return $node;
}

sub getNodeNames {
    my $this = shift;
    if(defined($this->{nodeNames})) { return @{$this->{nodeNames}}; }
    else { my @l; return @l; }
}

sub addParameter {
    my $this = shift;
    my $paramName = shift;
    my $value = shift;
    $this->{parameters}{$paramName} = $value;
    return $value;
}

sub getParameters {
    my $this = shift;
    return %{$this->{parameters}};
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
