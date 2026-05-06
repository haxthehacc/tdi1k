
require 5.004;

package Lef::Macro;

sub new {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to new";
    }
    my $type = shift;
    my $macroName = shift;
    my $this = {};
    bless $this, $type;

    $this->{name} = $macroName;

    return $this;
}

sub getName {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getName"; }
    my $this = shift;
    return $this->{name};
}

sub setClass {
    if(@_ != 2 ) { die "$0: Internal error: Bad number of args to setClass"; }
    my $this = shift; 
    my $class = shift;
    $this->{class} = $class;
    return $this->{class};
}
sub getClass {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getClass"; }
    my $this = shift;
    return $this->{class};
}

sub setSite {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setSite"; }
    my $this = shift; my $site = shift;
    $this->{site} = $site;
    return $this->{site};
}
sub getSite {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getSite"; }
    my $this = shift;
    return $this->{site};
}

sub setSize {
    if(@_ != 3) { die "$0: Internal error: Bad number of args to setSize"; }
    my $this = shift;
    my $xSize = shift; my $ySize = shift;
    @{$this->{size}} = ($xSize, $ySize);
    return @{$this->{size}};
}
sub getSize {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getSize"; }
    my $this = shift;
    return @{$this->{size}};
}

sub setForeign {
    if(@_ < 2 || @_ > 6 ) { die "$0: Internal error: Bad number of args to setForeign"; }
    my $this = shift;
    my @foreign = @_; @_ = ();
    @{$this->{foreign}} = @foreign;
    return @{$this->{foreign}};
}
sub getForeign {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getForeign"; }
    my $this = shift;
    return @{$this->{foreign}};
}

sub setOrigin {
    if(@_ != 3) { die "$0: Internal error: Bad number of args to setOrigin"; }
    my $this = shift;
    my $xOrg = shift; my $yOrg = shift;
    @{$this->{origin}} = ($xOrg, $yOrg);
    return @{$this->{origin}};
}
sub getOrigin {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getOrigin"; }
    my $this = shift;
    return @{$this->{origin}};
}

sub setSymmetries {
    if(@_ < 1) {
	die "$0: Internal error: Bad number of args to setSymmetries";
    }
    my $this = shift;
    my @symmetries = @_; @_ = ();
    @{$this->{symmetry}} = @symmetries;

    return @{$this->{symmetry}};
}
sub getSymmetries {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getSymmetries"; }
    my $this = shift;
    if(defined($this->{symmetry})) { return @{$this->{symmetry}}; }
    else { my @l; return @l; }
}

sub setPower {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setPower"; }
    my $this = shift; my $power = shift;
    $this->{power} = $power;
    return $this->{power};
}
sub getPower {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getPower"; }
    my $this = shift;
    return $this->{power};
}

sub addRegularPin {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to addRegularPin";
    }
    my $this = shift; my $pin = shift;
    if(!defined($pin->getName())) { die "$0: Internal error: Unnamed pin"; }
    $this->{pin}{$pin->getName()} = $pin;
    return $this->{pin}{$pin->getName()};
}
sub getRegularPin {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to getRegularPin";
    }
    my $this = shift; my $pinName = shift;
    return $this->{pin}{$pinName};
}
sub getRegularPins {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getRegularPins";
    }
    my $this = shift;
    if(!defined($this->{pin})) { %{$this->{pin}} = (); }
    return values(%{$this->{pin}});
}
sub removeRegularPin {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to removeRegularPin";
    }
    my $this = shift; my $pinName = shift;
    delete $this->{pin}{$pinName};
}
sub clearRegularPins {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to clearRegularPins";
    }
    my $this = shift;
    delete $this->{pin};
}

sub addMustJoinPin {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to addMustJoinPin";
    }
    my $this = shift; my $pin = shift;
    $this->{mustJoinPin}{$pin->getName()} = $pin;
    return $this->{mustJoinPin}{$pin->getName()};
}
sub getMustJoinPin {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to getMustJoinPin";
    }
    my $this = shift; my $pinName = shift;
    return $this->{mustJoinPin}{$pinName};
}
sub getMustJoinPins {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getMustJoinPins";
    }
    my $this = shift;
    if(!defined($this->{mustJoinPin})) { %{$this->{mustJoinPin}} = (); }
    return values(%{$this->{mustJoinPin}});
}
sub removeMustJoinPin {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to removeMustJoinPin";
    }
    my $this = shift; my $pinName = shift;
    delete $this->{mustJoinpin}{$pinName};
}
sub clearMustJoinPins {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to clearMustJoinPins";
    }
    my $this = shift;
    delete $this->{mustJoinPin};
}

sub addPin {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to addPin"; }
    my $this = shift; my $pin = shift;
    if(!defined($pin->getMustJoin)) { $this->{pin}{$pin->getName()} = $pin; }
    else { $this->{mustJoinPin}{$pin->getName()} = $pin; }
    return $pin;
}
sub getPin {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to getPin"; }
    my $this = shift; my $pinName = shift;
    if(defined($this->{pin}{$pinName})) { return $this->{pin}{$pinName}; }
    else { return $this->{mustJoinPin}{$pinName}; }
}
sub getPins {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getPins"; }
    my $this = shift;
    my @l = ($this->getRegularPins(), $this->getMustJoinPins());
    return @l;
}
sub getInputPins {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getInputPins"; }
    my $this = shift;
    my @pins = ($this->getRegularPins(), $this->getMustJoinPins());
    my @l;
    my $pin;
    foreach $pin (@pins) {
	if ($pin->getDirection() eq "input") {
	    push(@l, $pin);
	}
    }
    return @l;
}
sub getOutputPins {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getInputPins"; }
    my $this = shift;
    my @pins = ($this->getRegularPins(), $this->getMustJoinPins());
    my @l;
    my $pin;
    foreach $pin (@pins) {
	if ($pin->getDirection() eq "output") {
	    push(@l, $pin);
	}
    }
    return @l;
}
sub removePin {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to removePin"; }
    my $this = shift; my $pinName = shift;
    if(defined($this->{pin}{$pinName})) { delete $this->{pin}{$pinName}; }
    else { delete $this->{mustJoinPin}{$pinName}; }
}
sub clearPins {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to clearPins";
    }
    my $this = shift;
    delete $this->{pin};
    delete $this->{mustJoinPin};
}

sub addObs {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to addObs"; }
    my $this = shift; my $obs = shift;
    push(@{$this->{obs}{$obs->getLayerName()}}, $obs);
    return $obs;
}
sub getLayerNames {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getLayerNames"; }
    my $this = shift;
    return keys(%{$this->{obs}});
}
sub getObses {
    if(@_ < 1 || @_ > 2) {
	die "$0: Internal error: Bad number of args to getObses";
    }
    my $this = shift;
    my $layerName = shift;
    if(defined($layerName)) { return @{$this->{obs}{$layerName}}; }
    else {
	my @polyList;
	foreach $layerName ($this->getLayerNames()) {
	    @polyList = (@polyList, @{$this->{obs}{$layerName}});
	}
	return @polyList;
    }
}

sub clearObses {
    if(@_ < 1 || @_ > 2) {
	die "$0: Internal error: Bad number of args to clearObses";
    }
    my $this = shift;
    my $layerName = shift;
    if(defined($layerName)) {
        delete $this->{obs}{$layerName};
    }
    else {
        delete $this->{obs};
    }
}

# Destructor
sub DESTROY {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to DESTROY"; }
    my $this = shift;
}

############################################################################

1;
