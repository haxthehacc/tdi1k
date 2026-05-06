
require 5.004;

package Lef::Poly;

sub new {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to new"; }
    my $type = shift;
    my $this = {};
    bless $this, $type;

    return $this;
}

sub setLayerName {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to setLayerName";
    }
    my $this = shift;
    my $layerName = shift;

    $this->{layerName} = $layerName;

    return $this->{layerName};
}
sub getLayerName {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getLayerName"; }
    my $this = shift;

    return $this->{layerName};
}

sub setPoints {
    if(@_ < 3) { die "$0: Internal error: Bad number of args to setPoints"; }
    my $this = shift;
    my @points = @_; @_ = ();

    if($points[0] !~ /^ARRAY\(/ && $points[1] !~ /^ARRAY\(/ &&
       @points/2 == int(@points/2)) {
	my @oldPoints = @points;
	@points = ();
	my $i;
	for($i=0; $i<@oldPoints/2; $i++) {
	    $points[$i][0] = $oldPoints[$i*2];
	    $points[$i][1] = $oldPoints[$i*2+1];
	}
    }
    if(@points < 2 || !defined($points[0]) ||
       !defined($points[0][0]) || !defined($points[0][1]) ||
       !defined($points[1]) ||
       !defined($points[1][0]) || !defined($points[1][1])) {
	die "$0: Internal error";
    }
    @{$this->{points}} = @points;

    return @{$this->{points}};
}
sub getPoints {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getPoints"; }
    my $this = shift;

    return @{$this->{points}};
}

sub getShapeType {
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getShapeType";
    }
    my $this = shift;

    if($this->getPoints() == 0) { return undef(); }
    elsif($this->getPoints() == 1) {
	die "$0: Internal error: Invalid number of points";
    }
    elsif($this->getPoints() == 2) { return "rect"; }
    else { return "polygon"; }
}

# Destructor
sub DESTROY {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to DESTROY"; }
    my $this = shift;
}

############################################################################

1;
