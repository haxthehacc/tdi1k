# Perl Module used by elements.pm to handle instance terminals
#
# First release 1/31/99 in /rds/prod/HOTCODE
#
# $Id: instTerm.pm 1 2019/07/01 11:02:24 GMT ronenha Exp $
#
# $Log: Revision 1 2019/07/01 11:02:24 GMT ronenha $
#   Initial revision.
# 
#  Revision 1 2019/07/01 11:02:09 GMT ronenha
#   Initial revision.
# 
#  Revision: 1.1 Wed Aug  6 22:38:37 2003 syncmgr
#  checkin of all bin files
# Revision 1.1  1999/03/17 18:29:45  miliozp
# "Initial version"
#
#

require 5.004;

package elements::instTerm;

# Constructor
sub new {
    my $type = shift;
    my $this = {};
    bless $this, $type;
    return $this;
}

sub setSubNetName {
    my $this = shift;
    my $subNetName = shift;
    $this->{subNetName} = $subNetName;
    return $subNetName;
}

sub getSubNetName {
    my $this = shift;
    return $this->{subNetName};
}

sub setInstName {
    my $this = shift;
    my $instName = shift;
    $this->{instName} = $instName;
    return $instName;
}

sub getInstName {
    my $this = shift;
    return $this->{instName};
}

sub setTermName {
    my $this = shift;
    my $termName = shift;
    $this->{termName} = $termName;
    return $termName;
}

sub getTermName {
    my $this = shift;
    return $this->{termName};
}

sub setXCoord {
    my $this = shift;
    my $x = shift;
    $this->{x} = $x;
    return $x;
}

sub getXCoord {
    my $this = shift;
    return $this->{x};
}

sub setYCoord {
    my $this = shift;
    my $y = shift;
    $this->{y} = $y;
    return $y;
}

sub getYCoord {
    my $this = shift;
    return $this->{y};
}

1;
