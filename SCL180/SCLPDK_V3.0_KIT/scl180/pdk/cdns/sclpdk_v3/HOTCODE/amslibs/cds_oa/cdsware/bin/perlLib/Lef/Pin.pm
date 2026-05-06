
require 5.004;

package Lef::Pin;

sub new {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to new";
    }
    my $type = shift;
    my $pinName = shift;
    my $this = {};
    bless $this, $type;

    $this->{name} = $pinName;

    return $this;
}

sub getName {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getName"; }
    my $this = shift;
    return $this->{name};
}

sub setName {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setName"; }
    my $this = shift;
    my $name = shift;
    $this->{name} = $name;
    return $this->{name};
}

sub setDirection {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to setDirection";
    }
    my $this = shift; my $direction = shift;
    $this->{direction} = $direction;
    return $this->{direction};
}
sub getDirection {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getDirection";
    }
    my $this = shift;
    return $this->{direction};
}

sub setUse {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setUse"; }
    my $this = shift; my $use = shift;
    $this->{"use"} = $use;
    return $this->{"use"};
}
sub getUse {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getUse"; }
    my $this = shift;
    return $this->{"use"};
}

sub setShape {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setShape"; }
    my $this = shift; my $shape = shift;
    $this->{shape} = $shape;
    return $this->{shape};
}
sub getShape {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getShape"; }
    my $this = shift;
    return $this->{shape};
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

sub setCapacitance {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to setCapacitance";
    }
    my $this = shift; my $capacitance = shift;
    $this->{capacitance} = $capacitance;
    return $this->{capacitance};
}
sub getCapacitance {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getCapacitance";
    }
    my $this = shift;
    return $this->{capacitance};
}

sub addPort {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to addPort"; }
    my $this = shift; my $port = shift;
    push(@{$this->{port}}, $port);
    return $port;
}
sub getPorts {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getPorts";
    }
    my $this = shift;
    if(defined($this->{port})) { return @{$this->{port}}; }
    else { my @l; return @l; }
}
sub clearPorts {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to clearPorts";
    }
    my $this = shift;
    delete $this->{port};
}
sub getLayerNames {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getLayerNames";
    }
    my $this = shift;

    my @layerSet;
    my $port;
    foreach $port ($this->getPorts()) {
	@layerSet = (@layerSet, $port->getLayerNames());
    }
    return (@layerSet);
}
sub addPortPoly {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to addPortPoly"; }
    my $this = shift; my $poly = shift;
    my @ports = $this->getPorts();
    my $port;
    if(@ports == 0) { $port = new SE::Lef::Port; $this->addPort($port); }
    else { $port = $ports[$#ports]; }
    $port->addPoly($poly);
    return $poly;
}
sub getPortPolys {
    if(@_ < 1 || @_ > 2) {
	die "$0: Internal error: Bad number of args to getPortPolys";
    }
    my $this = shift;
    my $layerName = shift;

    my @polyList;
    my $port;
    foreach $port ($this->getPorts()) {
	@polyList = (@polyList, $port->getPolys($layerName));
    }

    return @polyList;
}
sub clearPortPolys {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to clearPortPolys";
    }
    my $this = shift;

    my $port;
    foreach $port ($this->getPorts()) {
	$port->clearPolys();
    }
}

sub setMustJoin {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setMustJoin"; }
    my $this = shift; my $pinName = shift;
    $this->{mustJoin} = $pinName;
    return $pinName;
}
sub getMustJoin {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getMustJoin";
    }
    my $this = shift;
    return $this->{mustJoin};
}

# Destructor
sub DESTROY {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to DESTROY"; }
    my $this = shift;
}

############################################################################

1;
