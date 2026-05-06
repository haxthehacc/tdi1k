require 5.004;

package ctgen::tree;

# Constructor
sub new {
    my $type = shift;
    my $this = {};
    bless $this, $type;
    $this->{header} = "specify_tree";
    return $this;
}

sub getHeader {
    my $this = shift;
    return $this->{header};
}

sub setRootPin {
    my $this = shift;
    my $compName = shift;
    my $pinName = shift;
    $this->{rootPin} = ($compName, $pinName);
    return $this->{rootPin};
}

sub getRootPin {
    my $this = shift;
    return $this->{rootPin};
}

sub setRootIOPin {
    my $this = shift;
    my $rootIOPin = shift;
    $this->{rootIOPin} = $rootIOPin;
    return $this->{rootIOPin};
}

sub getRootIOPin {
    my $this = shift;
    return $this->{rootIOPin};
}

# Destructor
sub DESTROY {
    my $this = shift;
}

1;
