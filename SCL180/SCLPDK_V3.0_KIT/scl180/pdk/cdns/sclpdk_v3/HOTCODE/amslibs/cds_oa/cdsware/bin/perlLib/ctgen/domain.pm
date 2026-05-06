require 5.004;

package ctgen::domain;

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

sub setTree {
    my $this = shift;
    my $tree = shift;
    $this->{tree} = $tree;
    return $tree;
}

sub getTree {
    my $this = shift;
    return $this->{tree};
}

sub setConstraints {
    my $this = shift;
    my $const = shift;
    $this->{const} = $const;
    return $const;
}

sub getConstraints {
    my $this = shift;
    return $this->{const};
}

sub setCells {
    my $this = shift;
    my $cells = shift;
    $this->{cells} = $cells;
    return $cells;
}

sub getCells {
    my $this = shift;
    return $this->{cells};
}

# Destructor
sub DESTROY {
    my $this = shift;
}

1;
