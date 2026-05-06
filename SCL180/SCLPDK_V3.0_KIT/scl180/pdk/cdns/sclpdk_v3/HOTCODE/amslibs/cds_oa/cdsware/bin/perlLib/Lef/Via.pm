
require 5.004;

package Lef::Via;

sub new {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to new";
    }
    my $type = shift;
    my $viaName = shift;
    my $this = {};
    bless $this, $type;

    $this->{name} = $viaName;

    return $this;
}

sub getName {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getName"; }
    my $this = shift;
    return $this->{name};
}

sub setType {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setType"; }
    my $this = shift; my $type = shift;
    $this->{type} = $type;
    return $this->{type};
}
sub getType {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getType"; }
    my $this = shift;
    return $this->{type};
}

sub setResistance {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setType"; }
    my $this = shift; my $resistance = shift;
    $this->{resistance} = $resistance;
    return $this->{resistance};
}
sub getResistance {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getType"; }
    my $this = shift;
    return $this->{resistance};
}

sub getLayerNames {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getLayerNames";
    }
    my $this = shift;

    return keys(%{$this->{poly}});
}

sub addPoly {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to addPoly"; }
    my $this = shift;
    my $poly = shift;

    my $layerName = $poly->getLayerName();
    if(!defined($this->{poly}{$layerName})) {
	@{$this->{poly}{$layerName}} = ();
    }
    push(@{$this->{poly}{$layerName}}, $poly);

    return $poly;
}
sub getPolys {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to getPolys"; }
    my $this = shift;
    my $layerName = shift;
    return @{$this->{poly}{$layerName}};
}
sub clearPolys {
    if(@_ < 1 || @_ > 2) {
	die "$0: Internal error: Bad number of args to clearPolys";
    }
    my $this = shift;
    my $layerName = shift;
    if(!defined($layerName)) { %{$this->{poly}} = (); }
    else { delete $this->{poly}{$layerName}; }
}

# Destructor
sub DESTROY {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to DESTROY"; }
    my $this = shift;
}

############################################################################

1;
