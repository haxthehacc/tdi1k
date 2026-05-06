
require 5.004;

package Lef::Site;

sub new {
    if(@_ != 2) {
	die "$0: Internal error: Bad number of args to new";
    }
    my $type = shift;
    my $siteName = shift;
    my $this = {};
    bless $this, $type;

    $this->{name} = $siteName;

    return $this;
}

sub getName {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getName"; }
    my $this = shift;
    return $this->{name};
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
    if(@_ != 1) {
	die "$0: Internal error: Bad number of args to getSymmetries";
    }
    my $this = shift;
    if(defined($this->{symmetry})) { return @{$this->{symmetry}}; }
    else { my @l; return @l; }
}

sub setClass {
    if(@_ != 2) { die "$0: Internal error: Bad number of args to setClass"; }
    my $this = shift; my $class = shift;
    $this->{class} = $class;
    return $this->{class};
}
sub getClass {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to getClass"; }
    my $this = shift;
    return $this->{class};
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

# Destructor
sub DESTROY {
    if(@_ != 1) { die "$0: Internal error: Bad number of args to DESTROY"; }
    my $this = shift;
}

############################################################################

1;
