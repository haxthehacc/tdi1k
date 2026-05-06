require 5.004;

package dspf::parasitic;

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

sub setNodeName1 {
    my $this = shift;
    my $node = shift;
    $this->{node1} = $node;
    return $node;
}

sub getNodeName1 {
    my $this = shift;
    return $this->{node1};
}

sub setNodeName2 {
    my $this = shift;
    my $node = shift;
    $this->{node2} = $node;
    return $node;
}

sub getNodeName2 {
    my $this = shift;
    return $this->{node2};
}

sub setValue {
    my $this = shift;
    my $value = shift;
    $this->{value} = $value;
    return $value;
}

sub getValue {
    my $this = shift;
    return $this->{value};
}

1;
