# Perl Module instance.pm used by elements.pm to handle instances 
#
# First release 1/31/99 in /rds/prod/HOTCODE
#
# $Id: instance.pm 1 2019/07/01 11:02:24 GMT ronenha Exp $
#
# $Log: Revision 1 2019/07/01 11:02:24 GMT ronenha $
#   Initial revision.
# 
#  Revision 1 2019/07/01 11:02:09 GMT ronenha
#   Initial revision.
# 
#  Revision: 1.1 Wed Aug  6 22:38:37 2003 syncmgr
#  checkin of all bin files
# Revision 1.2  1999/03/24 22:31:01  miliozp
# added function setNodeNames
#
# Revision 1.1  1999/03/17 18:29:46  miliozp
# "Initial version"
#
#
 
require 5.004;

package elements::instance;

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

sub setModelName {
    my $this = shift;
    my $modelName = shift;
    $this->{modelName} = $modelName;
    return $modelName;
}

sub getModelName {
    my $this = shift;
    return $this->{modelName};
}

sub addNodeName {
    my $this = shift;
    my $node = shift;
    push(@{$this->{nodeNames}}, $node);
    return $node;
}

sub getNodeNames {
    my $this = shift;
    if(defined($this->{nodeNames})) { return @{$this->{nodeNames}}; }
    else { my @l; return @l; }
}

sub setNodeNames {
    my $this = shift;
    my @nodeNames = @_;
    @{$this->{nodeNames}} = @nodeNames ;
    return @nodeNames; 
}

sub setNodeNumber {
    my $this = shift;
    my $nodeNumber = shift;
    $this->{nodeNumber} = $nodeNumber;
    return $nodeNumber;
}

sub getNodeNumber {
    my $this = shift;
    return $this->{nodeNumber};
}

sub addParameter {
    my $this = shift;
    my $paramName = shift;
    my $value = shift;
    $this->{parameters}{$paramName} = $value;
    return $value;
}

sub getParameters {
    my $this = shift;
    return %{$this->{parameters}};
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
