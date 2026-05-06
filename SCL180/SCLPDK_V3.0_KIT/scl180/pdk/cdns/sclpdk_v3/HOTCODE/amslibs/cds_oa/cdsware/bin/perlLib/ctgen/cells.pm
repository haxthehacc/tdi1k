require 5.004;

package ctgen::cells;

# Constructor
sub new {
    my $type = shift;
    my $this = {};
    bless $this, $type;
    $this->{header} = "define_cells";
    return $this;
}

sub getHeader {
    my $this = shift;
    return $this->{header};
}

sub addBuffer {
    my $this = shift;
    my $buffer = shift;

    push(@{$this->{buffers}}, $buffer);
    return $buffer;
}

sub addBufferList {
    my $this = shift;
    my $listFile = shift;
    foreach $cell (readCellList($listFile)) {
	push(@{$this->{buffers}}, $cell);
    }
    return $listFile;
}

sub getBuffers {
    my $this = shift;
    if(defined($this->{buffers})) { return @{$this->{buffers}}; }
    else { my @l; return @l; }
}

sub addInverter {
    my $this = shift;
    my $inverter = shift;

    push(@{$this->{inverters}}, $inverter);
    return $inverter;
}

sub addInverterList {
    my $this = shift;
    my $listFile = shift;
    foreach $cell (readCellList($listFile)) {
	push(@{$this->{inverters}}, $cell);
    }
    return $listFile;
}

sub getInverters {
    my $this = shift;
    if(defined($this->{inverters})) { return @{$this->{inverters}}; }
    else { my @l; return @l; }
}

# Destructor
sub DESTROY {
    my $this = shift;
}

sub readCellList {
    my $fileName = shift;
    my @cellList;

    open(INP, "$fileName") || die "readCellList: Can't open file $fileName\n";
    while (<INP>) {
	chop;
	@cellList = (@cellList, $_);
    }
    close(INP);

    return @cellList;
}

1;
