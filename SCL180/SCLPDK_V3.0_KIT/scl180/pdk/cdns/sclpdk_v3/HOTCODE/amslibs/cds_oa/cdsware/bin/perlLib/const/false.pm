require 5.004;

package const::false;

# Constructor
sub new {
    my $type = shift;
    my $this = {};
    bless $this, $type;
    return $this;
}

sub setFromItem {
    my $this = shift;
    my $item = shift;
    $this->{from} = $item;
    return $item;
}

sub getFromItem {
    my $this = shift;
    return $this->{from};
}

sub setToItem {
    my $this = shift;
    my $item = shift;
    $this->{to} = $item;
    return $item;
}

sub getToItem {
    my $this = shift;
    return $this->{to};
}

1;
