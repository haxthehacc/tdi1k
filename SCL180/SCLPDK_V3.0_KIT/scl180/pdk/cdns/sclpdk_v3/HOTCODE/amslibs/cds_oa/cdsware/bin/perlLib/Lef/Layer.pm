
require 5.004;

package Lef::Layer;


# Constructor
sub new {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to new";
    }
    my $type = shift;
    my $layerName = shift;
    my $this = {};
    bless $this, $type;

    $this->{name} = $layerName;

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

sub setWidth {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setWidth"; }
    my $this = shift; my $width = shift;
    $this->{width} = $width;
    return $this->{width};
}
sub getWidth {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getWidth"; }
    my $this = shift;
    return $this->{width};
}

sub setSpacing {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setSpacing"; }
    my $this = shift; my $spacing = shift;
    $this->{spacing} = $spacing;
    return $this->{spacing};
}
sub getSpacing {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getSpacing"; }
    my $this = shift;
    return $this->{spacing};
}

sub setPitch {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setPitch"; }
    my $this = shift; my $pitch = shift;
    $this->{pitch} = $pitch;
    return $this->{pitch};
}
sub getPitch {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getPitch"; }
    my $this = shift;
    return $this->{pitch};
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

sub setCapacitance {
    if(@_ != 3) {
	die "$0: Internal error: Bad number of args to setCapacitance";
    }
    my $this = shift; my $type = lc(shift); my $capacitance = shift;
    $this->{capacitance}{$type} = $capacitance;
    return $this->{capacitance}{$type};
}
sub getCapTypes {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getCapType";
    }
    my $this = shift;
    return keys(%{$this->{capacitance}});
}
sub getCapacitance {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to getCapacitance";
    }
    my $this = shift;
    my $type = lc(shift);
    return $this->{capacitance}{$type};
}

sub setResistance {
    if(@_ != 3) {
	die "$0: Internal error: Bad number of args to setResistance";
    }
    my $this = shift; my $type = lc(shift); my $resistance = shift;
    $this->{resistance}{$type} = $resistance;
    return $this->{resistance}{$type};
}
sub getResTypes {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getResType";
    }
    my $this = shift;
    return keys(%{$this->{resistance}});
}
sub getResistance {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to getResistance";
    }
    my $this = shift;
    my $type = lc(shift);
    return $this->{resistance}{$type};
}

sub setHeight {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to setHeight";
    }
    my $this = shift; my $height = shift;
    $this->{height} = $height;
    return $this->{height};
}
sub getHeight {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getHeight";
    }
    my $this = shift;
    return $this->{height};
}

sub setThickness {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to setThickness";
    }
    my $this = shift; my $thickness = shift;
    $this->{thickness} = $thickness;
    return $this->{thickness};
}
sub getThickness {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getThickness";
    }
    my $this = shift;
    return $this->{thickness};
}

sub setShrinkage {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to setShrinkage";
    }
    my $this = shift; my $shrinkage = shift;
    $this->{shrinkage} = $shrinkage;
    return $this->{shrinkage};
}
sub getShrinkage {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getShrinkage";
    }
    my $this = shift;
    return $this->{shrinkage};
}

sub setCapMultiplier {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to setCapMultiplier";
    }
    my $this = shift; my $capMultiplier = shift;
    $this->{capMultiplier} = $capMultiplier;
    return $this->{capMultiplier};
}
sub getCapMultiplier {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getCapMultiplier";
    }
    my $this = shift;
    return $this->{capMultiplier};
}

sub setEdgeCapacitance {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to setEdgeCapacitance";
    }
    my $this = shift; my $edgeCapacitance = shift;
    $this->{edgeCapacitance} = $edgeCapacitance;
    return $this->{edgeCapacitance};
}
sub getEdgeCapacitance {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getEdgeCapacitance";
    }
    my $this = shift;
    return $this->{edgeCapacitance};
}

# Destructor
sub DESTROY {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to DESTROY"; }
    my $this = shift;
}

############################################################################

1;
