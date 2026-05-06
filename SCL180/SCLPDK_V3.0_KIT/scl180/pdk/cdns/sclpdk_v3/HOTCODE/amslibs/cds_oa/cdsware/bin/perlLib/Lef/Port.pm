
require 5.004;

package Lef::Port;

sub new {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to new";
    }
    my $type = shift;
    my $this = {};
    bless $this, $type;

    return $this;
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
    my $this = shift; my $poly = shift;
    push(@{$this->{poly}{$poly->getLayerName()}}, $poly);
    return $poly;
}
sub getPolys {
    if(@_ < 1 || @_ > 2) {
	die "$0: Internal error: Bad number of args to getPolys";
    }
    my $this = shift;
    my $layerName = shift;
    if(defined($layerName)) { return @{$this->{poly}{$layerName}}; }
    else {
	my @polyList;
	foreach $layerName ($this->getLayerNames()) {
	    @polyList = (@polyList, @{$this->{poly}{$layerName}});
	}
	return @polyList;
    }
}
sub clearPolys {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to clearPolys";
    }
    my $this = shift;
    delete $this->{poly};
}

# Destructor
sub DESTROY {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to DESTROY"; }
    my $this = shift;
}

############################################################################

1;
