
require 5.004;

package Lef::ViaRule;

sub new {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to new";
    }
    my $type = shift;
    my $ruleName = shift;
    my $this = {};
    bless $this, $type;

    $this->{name} = $ruleName;

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

sub getLayerNames {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getLayerNames";
    }
    my $this = shift;

    my %l;
    if(defined($this->{poly})) { %l = (%l, %{$this->{poly}}); }
    if(defined($this->{direction})) { %l = (%l, %{$this->{direction}}); }
    if(defined($this->{overhang})) { %l = (%l, %{$this->{overhang}}); }
    if(defined($this->{spacing})) { %l = (%l, %{$this->{spacing}}); }
    return keys(%l);
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
    if(!defined($this->{poly}{$layerName})) { return (); }
    else { return @{$this->{poly}{$layerName}}; }
}
sub clearPolys {
    if(@_ < 1 || @_ > 2) {
	die "$0: Internal error: Bad number of args to clearPolys";
    }
    my $this = shift;
    my $layerName = shift;
    if(!defined($layerName)) { %{$this->{poly}} = (); }
    elsif(defined($this->{poly}{$layerName})) {
	delete $this->{poly}{$layerName};
    }
}

sub addDirection {
    if(@_ != 3) {
	die "$0: Internal error: Bad number of args to addDirection";
    }
    my $this = shift;
    my $layerName = shift;
    my $direction = shift;
    push(@{$this->{direction}{$layerName}}, $direction);

    return $direction;
}
sub getDirections {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to getDirections";
    }
    my $this = shift;
    my $layerName = shift;
    if(!defined($this->{direction}{$layerName})) { my @l; return @l; }
    else { return @{$this->{direction}{$layerName}}; }
}
sub clearDirections {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to clearDirections";
    }
    my $this = shift;
    my $layerName = shift;
    delete $this->{direction}{$layerName};
}
sub setDirection {
    if(@_ != 3) {
	die "$0: Internal error: Bad number of args to setDirection";
    }
    my $this = shift;
    my $layerName = shift;
    my $direction = shift;

    $this->clearDirections($layerName);
    $this->addDirection($layerName, $direction);

    return $direction;
}
sub getDirection {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to getDirection";
    }
    my $this = shift;
    my $layerName = shift;
    my @directions = $this->getDirections($layerName);
    if(@directions > 1) { die "$0: Internal error: Too many directions"; }
    return $directions[0];
}

sub setOverhang {
    if(@_ != 3) { die "$0: Internal error: Bad number of args to setOverhang"; }
    my $this = shift;
    my $layerName = shift;
    my $overhang = shift;
    $this->{overhang}{$layerName} = $overhang;

    return $this->{overhang}{$layerName};
}
sub getOverhang {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to getOverhang"; }
    my $this = shift;
    my $layerName = shift;
    return $this->{overhang}{$layerName};
}

sub setMetalOverhang {
    if(@_ != 3) { die "$0: Internal error: Bad number of args to setMetalOverhang"; }
    my $this = shift;
    my $layerName = shift;
    my $metaloverhang = shift;
    $this->{metaloverhang}{$layerName} = $metaloverhang;

    return $this->{metaloverhang}{$layerName};
}
sub getMetalOverhang {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to getMetalOverhang"; }
    my $this = shift;
    my $layerName = shift;
    return $this->{metaloverhang}{$layerName};
}

sub setSpacing {
    if(@_ != 4) { die "$0: Internal error: Bad number of args to setSpacing"; }
    my $this = shift;
    my $layerName = shift;
    my $xSpace = shift; my $ySpace = shift;
    @{$this->{spacing}{$layerName}} = ($xSpace, $ySpace);

    return @{$this->{spacing}{$layerName}};
}
sub getSpacing {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to getSpacing"; }
    my $this = shift;
    my $layerName = shift;
    return @{$this->{spacing}{$layerName}};
}

# Destructor
sub DESTROY {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to DESTROY"; }
    my $this = shift;
}

############################################################################

1;
