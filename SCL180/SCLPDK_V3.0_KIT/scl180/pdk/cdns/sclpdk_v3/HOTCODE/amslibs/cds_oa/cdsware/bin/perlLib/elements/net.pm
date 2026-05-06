# Perl Module net.pm used by elements.pm to handle nets
#
# First release 1/31/99 in /rds/prod/HOTCODE
#
# $Id: net.pm 1 2019/07/01 11:02:24 GMT ronenha Exp $
#
# $Log: Revision 1 2019/07/01 11:02:24 GMT ronenha $
#   Initial revision.
# 
#  Revision 1 2019/07/01 11:02:09 GMT ronenha
#   Initial revision.
# 
#  Revision: 1.1 Wed Aug  6 22:38:37 2003 syncmgr
#  checkin of all bin files
# Revision 1.1  1999/03/17 18:29:47  miliozp
# "Initial version"
#
#
 
require 5.004;

package elements::net;

# Constructor
sub new {
    my $type = shift;
    my $name = shift;
    my $this = {};
    bless $this, $type;
    $this->{name} = $name;
    return $this;
}

sub getName {
    my $this = shift;
    return $this->{name};
}

sub setTotalCap {
    my $this = shift;
    my $cap = shift;
    $this->{totalCap} = $cap;
    return $cap;
}

sub getTotalCap {
    my $this = shift;
    return $this->{totalCap};
}

sub addPin {
    my $this = shift;
    my $pin = shift;
    push(@{$this->{pins}}, $pin);
    return $pin;
}

sub getPins {
    my $this = shift;
    if(defined($this->{pins})) { return @{$this->{pins}}; }
    else { my @l; return @l; }
}

sub addInstTerm {
    my $this = shift;
    my $instTerm = shift;
    push(@{$this->{instTerms}}, $instTerm);
    return $instTerm;
}

sub getInstTerms {
    my $this = shift;
    if(defined($this->{instTerms})) { return @{$this->{instTerms}}; }
    else { my @l; return @l; }
}

sub addSubNetName {
    my $this = shift;
    my $netName = shift;
    push(@{$this->{subNetNames}}, $netName);
    return $netName;
}

sub getSubNetNames {
    my $this = shift;
    if(defined($this->{subNetNames})) { return @{$this->{subNetNames}}; }
    else { my @l; return @l; }
}

1;
