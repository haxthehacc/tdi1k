# Perl Module parasitic.pm used by elements.pm to handle parasitics 
#
# First release 1/31/99 in /rds/prod/HOTCODE
#
# $Id: parasitic.pm 1 2019/07/01 11:02:24 GMT ronenha Exp $
#
# $Log: Revision 1 2019/07/01 11:02:24 GMT ronenha $
#   Initial revision.
# 
#  Revision 1 2019/07/01 11:02:09 GMT ronenha
#   Initial revision.
# 
#  Revision: 1.1 Wed Aug  6 22:38:37 2003 syncmgr
#  checkin of all bin files
# Revision 1.1  1999/03/17 18:29:48  miliozp
# "Initial version"
#
#
 
require 5.004;

package elements::parasitic;

# Constructor
sub new {
    my $type = shift;
    my $name = shift;
    $name = $name . "_par" ; 
    my $this = {};
    bless $this, $type;
    $this->{name} = $name;
    return $this;
}

sub getName {
    my $this = shift;
    return $this->{name};
}

sub setNodeName1 {
    my $this = shift;
    my $node = shift;
    $this->{node1} = $node;
    return $node;
}

sub getNodeName1 {
    my $this = shift;
    return $this->{node1};
}

sub setNodeName2 {
    my $this = shift;
    my $node = shift;
    $this->{node2} = $node;
    return $node;
}

sub getNodeName2 {
    my $this = shift;
    return $this->{node2};
}

sub setValue {
    my $this = shift;
    my $value = shift;
    $this->{value} = $value;
    return $value;
}

sub getValue {
    my $this = shift;
    return $this->{value};
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
