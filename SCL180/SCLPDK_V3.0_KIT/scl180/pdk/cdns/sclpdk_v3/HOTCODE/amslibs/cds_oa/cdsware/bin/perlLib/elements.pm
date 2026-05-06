# Perl Module used by pex2skill to read files extracted by xCalibre
# in both DSPF and spice format
#
# First release 1/31/99 in /rds/prod/HOTCODE
#
# $Id: elements.pm 1 2019/07/01 11:02:24 GMT ronenha Exp $
#
# $Log: Revision 1 2019/07/01 11:02:24 GMT ronenha $
#   Initial revision.
# 
#  Revision 1 2019/07/01 11:02:09 GMT ronenha
#   Initial revision.
# 
#  Revision: 1.1 Wed Aug  6 22:38:34 2003 syncmgr
#  checkin of all bin files
# Revision 1.9  2002/04/30 21:11:16  moyekj
# Added fix to include parasitic caps w/ global nets
#
# Revision 1.8  2000/09/19 22:15:06  miliozp
# added concatenation recognition for subckt definition in DSPF files
#
# Revision 1.7  1999/06/23 21:01:31  miliozp
# while reading in the netlist neglect fields starting with $[
#
# Revision 1.6  1999/05/22 02:08:49  miliozp
# substituted / with yy for pattern matching of node names
#
# Revision 1.5  1999/05/01 00:15:47  miliozp
# changed default gnd! into variable $substrateNetName
#
# Revision 1.4  1999/04/22 06:59:47  miliozp
# fixed problem to recognize node names containing [] <>
#
# Revision 1.3  1999/03/24 22:43:42  miliozp
# added line continuation capability with + sign
#
# Revision 1.2  1999/03/17 18:19:40  miliozp
# adding Log and Id info in the header
#
#
#


require 5.004;

package elements;

use elements::net;
use elements::pin;
use elements::instTerm;
use elements::parasitic;
use elements::instance;

# Constructor
sub new {
    my $type = shift;
    my $this = {};
    bless $this, $type;
    return $this;
}

sub readDSPF {
    my $this = shift;
    my $dspfFile = shift;
    my $substrateNetName = shift;

    my $net;

    open(NETLIST, "$dspfFile") || die "$0: Can't open file $dspfFile\n" ;

    while (<NETLIST>) {
	#
	# version
	#
	if (/^\*\|DSPF\s+(\S+)\s*$/) {
	    $this->setVersion($1);
	}

	#
	# design name
	#
	elsif (/^\*\|DESIGN\s+\"(\S+)\"\s*$/) {
	    $this->setDesignName($1);
	}
    
	#
	# creation date
	#
	elsif (/^\*\|DATE\s+\"(.*)\"\s*$/) {
	    $this->setCreationDate($1);
	}

	#
	# vendor
	#
	elsif (/^\*\|VENDOR\s+\"(.*)\"\s*$/) {
	    $this->setVendor($1);
	}

	#
	# vendor program
	#
	elsif (/^\*\|PROGRAM\s+\"(.*)\"\s*$/) {
	    $this->setVendorProgram($1);
	}

	#
	# vendor program version
	#
	elsif (/^\*\|VERSION\s+\"(.*)\"\s*$/) {
	    $this->setVendorProgramVersion($1);
	}

	#
	# hierarchy divider
	#
	elsif (/^\*\|DIVIDER\s+(\S+)\s*$/) {
	    $this->setHierarchyDivider($1);
	}

	#
	# delimiter
	#
	elsif (/^\*\|DELIMITER\s+(\S+)\s*$/) {
	    $this->setDelimiter($1);
	}

	#
	# sub-circuit definition
	#
	elsif (/^\.subckt\s+(\S+)\s*/) {
#	    $this->setSubcktName($1);
	    $line = concatLinesStartingWithPlus($_);
	    my @fields = split(' ', $line);
            my $instName = $fields[0];
	    $this->setSubcktName($fields[1]);
	    $this->setDesignName($fields[1]);
	    for (my $i=2 ; $i<= $#fields ; $i++) {
		my $pin = new elements::pin;
		$pin->setSubNetName($fields[$i]);
		$pin->setXCoord($pinX);
		$pin->setYCoord($pinY);
		$net = new elements::net($fields[$i]);
		$this->addNet($net);
#		push(@allNetNames, $fields[$i]); 
		$net->addSubNetName($fields[$i]);
		$net->addPin($pin);
		$this->addPort($net);
		$pinX += $pinXInc ;
	    }
	}

	#
	# lumped parasitic net
	#
	elsif (/^\*\|NET\s+\((\S+)\s+(\S+)\)\s*$/) {
	    $net = new elements::net($1);
	    $net->setTotalCap($2);
	    $this->addNet($net);
	}

	#
	# net
	#
	elsif (/^\*\|NET\s+(\S+)\s+(\S+)\s*$/) {
	    $net = new elements::net($1);
	    $net->setTotalCap($2);
	    $this->addNet($net);
	}

	#
	# instance terminal
	#
	elsif (/^\*\|I\s+\((\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\)\s*$/) {
	    my $instTerm = new elements::instTerm;
	    $instTerm->setSubNetName($1);
	    $instTerm->setInstName($2);
	    $instTerm->setTermName($3);
	    $instTerm->setXCoord($6);
	    $instTerm->setYCoord($7);
	    $net->addSubNetName($1);
	    $net->addInstTerm($instTerm);
            $instX{$2} = $6;
            $instY{$2} = $7;
	}

	#
	# pin
	#
#	elsif (/^\*\|P\s+\((\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\)\s*$/) {
#	    my $pin = new elements::pin;
#	    $pin->setSubNetName($1);
#	    $pin->setXCoord($4);
#	    $pin->setYCoord($5);
#	    $net->addSubNetName($1);
#	    $net->addPin($pin);
#	    $this->addPort($net);
#	}

	#
	# sub net
	#
	elsif (/^\*\|S\s+\((\S+)\)\s*$/) {
	    $net->addSubNetName($1);
	}

	#
	# parasitic capacitor
	#
	elsif (/^([c|C]\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*$/) {
	    my $parasitic = new elements::parasitic($1);
	    $parasitic->setNodeName1($2);
	    my $node2 = $3 ;
#	    if ($node2 eq '0') { $node2 = "gnd!"};
	    if ($node2 eq '0') { $node2 = $substrateNetName};
	    $parasitic->setNodeName2($node2);
	    $parasitic->setValue($4);
	    $this->addParasiticCap($parasitic);
	}

	#
	# parasitic resistor
	#
	elsif (/^([r|R]\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*$/) {
	    my $parasitic = new elements::parasitic($1);
	    $parasitic->setNodeName1($2);
	    $parasitic->setNodeName2($3);
	    $parasitic->setValue($4);
	    my ($coordName, $value) = split('=', $5);
	    $parasitic->setXCoord($value);
	    ($coordName, $value) = split('=', $6);
	    $parasitic->setYCoord($value);
	    $this->addParasiticRes($parasitic);
	}

        #
        # primitive instance
        #
        elsif (!/^\+/) {
	    $line = concatLinesStartingWithPlus($_);
	    my @fields = split(' ', $line);
            my $instName = $fields[0];
	    if ($instName =~ /^([x|X|m|M|q|Q|d|D])/) {
                $instName =~ s/^x_//;
                $instName =~ s/^m_//;
                $instName =~ s/^q_//;
                $instName =~ s/^d_//;
	        my $inst = new elements::instance($instName);
	        $inst->setXCoord($instX{$instName});
	        $inst->setYCoord($instY{$instName});
	        my $keep = 1;
	        my @keepList = ();
	        my $field;
	        shift @fields;
	        foreach $field (@fields) {
# if the coordinates are defined at the end of the line
		    if ($field =~ /\$x/) {
			my ($coordName, $value) = split('=', $field);
			$inst->setXCoord($value);
			next;
		    } 
		    if ($field =~ /\$y/) {
			my ($coordName, $value) = split('=', $field);
			$inst->setYCoord($value);
			next; 
		    }
# skip the field that starts with $[
		    if ($field =~ /\$\[/) {
			next;
		    }
		    if ($field =~ /=/) {
		        my ($paramName, $value) = split('=', $field);
		        $inst->addParameter($paramName, $value);
		        $keep = 0;
		    }
		    if ($keep) {push(@keepList, $field);}
	        }
	        for (my $i=0 ; $i<$#keepList ; $i++) {
		    $inst->addNodeName($keepList[$i]);
	        }
	        $inst->setModelName($keepList[$#keepList]);
	        $this->addInstance($inst);
	    }
	}
    }
    close(NETLIST);

    return $dspfFile;
}

sub readSpice {
    my $this = shift;
    my $spiceFile = shift;
    my $substrateNetName = shift;

    my $net;
    my @allNetNames;

    $pinX = 0;
    $pinY = -8;
    $pinXInc = 2;

    open(NETLIST, "$spiceFile") || die "$0: Can't open file $spiceFile\n";

    while (<NETLIST>) {
	#
	# sub-circuit definition
	#
	if (/^\.subckt/) {
	    $line = concatLinesStartingWithPlus($_);
	    my @fields = split(' ', $line);
            my $instName = $fields[0];
	    $this->setSubcktName($fields[1]);
	    $this->setDesignName($fields[1]);
	    for (my $i=2 ; $i<= $#fields ; $i++) {
		my $pin = new elements::pin;
		$pin->setSubNetName($fields[$i]);
		$pin->setXCoord($pinX);
		$pin->setYCoord($pinY);
		$net = new elements::net($fields[$i]);
		$this->addNet($net);
		push(@allNetNames, $fields[$i]); 
		$net->addSubNetName($fields[$i]);
		$net->addPin($pin);
		$this->addPort($net);
		$pinX += $pinXInc ;
	    }
	}
	#
	# parasitic capacitor
	#
	elsif (/^([c|C]\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*$/) {
	    my $parCapName = $1 ;
	    my $node1 = $2 ;
	    my $node2 = $3 ;
	    my $parCapVal = $4 ;
# added to solve the problem to search a node when it contains [] <> !
	    my $nodeComp1 = $node1 ;
	    $nodeComp1 =~ s/[\[,\]]/__/g ;
	    $nodeComp1 =~ s/[<,>]/xx/g ;
	    $nodeComp1 =~ s/\//yy/g ;
            $nodeComp1 =~ s/\!/BANG/g ;
# added to solve the problem to search a node when it contains [] <> !
	    my $nodeComp2 = $node2 ;
	    $nodeComp2 =~ s/[\[,\]]/__/g ;
	    $nodeComp2 =~ s/[<,>]/xx/g ;
	    $nodeComp2 =~ s/\//yy/g ;
            $nodeComp2 =~ s/\!/BANG/g ;
# added to solve the problem to search a node when it contains [] <> !
	    my $allNetNames = (join ' ', @allNetNames);
	    $allNetNames =~ s/[\[\]]/__/g ;
	    $allNetNames =~ s/[<,>]/xx/g ;
	    $allNetNames =~ s/\//yy/g ;
	    $allNetNames =~ s/\!/BANG/g ;
	    if (($allNetNames =~ /\b$nodeComp1\b/) && (($allNetNames =~ /\b$nodeComp2\b/) || ($nodeComp2 eq '0'))){
		my $parasitic = new elements::parasitic($parCapName);
		$parasitic->setNodeName1($node1);
		if ($node2 eq '0'){
#		    $node2 = "gnd!"; 
		    $node2 = $substrateNetName; 
		    foreach $myNet ($this->getNets()) {
			$myNetName = $myNet->getName();
			if ($myNetName eq $node1) {
			    $myNet->setTotalCap($parCapVal);
			}
		    }
		}
		$parasitic->setNodeName2($node2);
		$parasitic->setValue($parCapVal);
		$this->addParasiticCap($parasitic);
	    }
	}

	#
	# parasitic resistor
	#
	elsif (/^([r|R]\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*$/) {
	    my $parasitic = new elements::parasitic($1);
	    $parasitic->setNodeName1($2);
	    $parasitic->setNodeName2($3);
	    $parasitic->setValue($4);
	    my ($coordName, $value) = split('=', $5);
	    $parasitic->setXCoord($value);
	    ($coordName, $value) = split('=', $6);
	    $parasitic->setYCoord($value);
	    $this->addParasiticRes($parasitic);
	}

        #
        # primitive instance
        #
        elsif (!/^\+/) {
	    $line = concatLinesStartingWithPlus($_);
	    my @fields = split(' ', $line);
            my $instName = $fields[0];
	    if ($instName =~ /^([x|X|m|M|q|Q|d|D])/) {
                $instName =~ s/^x_//;
                $instName =~ s/^m_//;
                $instName =~ s/^q_//;
                $instName =~ s/^d_//;
	        my $inst = new elements::instance($instName);
	        $inst->setXCoord($instX{$instName});
	        $inst->setYCoord($instY{$instName});
	        my $keep = 1;
	        my @keepList = ();
	        my $field;
	        shift @fields;
	        foreach $field (@fields) {
# if the coordinates are defined at the end of the line
		    if ($field =~ /\$x/) {
			my ($coordName, $value) = split('=', $field);
			$inst->setXCoord($value);
			next;
		    } 
		    if ($field =~ /\$y/) {
			my ($coordName, $value) = split('=', $field);
			$inst->setYCoord($value);
			next; 
		    }
# skip the field that starts with $[
		    if ($field =~ /\$\[/) {
			next;
		    }
		    if ($field =~ /=/) {
		        my ($paramName, $value) = split('=', $field);
		        $inst->addParameter($paramName, $value);
		        $keep = 0;
		    }
		    if ($keep) {push(@keepList, $field);}
	        }
	        for (my $i=0 ; $i<$#keepList ; $i++) {
# added to solve the problem to search a node when it contains [] <>
		    my $newNet = $keepList[$i] ;
		    $newNet =~ s/[\[\]]/__/g ;
		    $newNet =~ s/[<,>]/xx/g ;
		    $newNet =~ s/\//yy/g ;
		    my $allNetNames = (join ' ', @allNetNames);
# added to solve the problem to search a node when it contains [] <>
		    $allNetNames =~ s/[\[\]]/__/g ;
		    $allNetNames =~ s/[<,>]/xx/g ;
		    $allNetNames =~ s/\//yy/g ;
#		    print "ALL_NET_NAMES = $allNetNames \n" ;
#		    print "NEW NET: $newNet \n";
		    if (!($allNetNames =~ /\b$newNet\b/)) {    
#			print "ADDED NET: $newNet \n";
			$net = new elements::net($keepList[$i]);
			$this->addNet($net);
			push(@allNetNames, $keepList[$i]); 
			$net->addSubNetName($keepList[$i]);
		    }
		    $inst->addNodeName($keepList[$i]);		    
	        }
	        $inst->setModelName($keepList[$#keepList]);
		$inst->setNodeNumber($#keepList);
	        $this->addInstance($inst);
	    }
	}
    }
    close(NETLIST);

    return $spiceFile;
}

sub concatLinesStartingWithPlus {
    my $line = shift;
    my $more_lines = 1;
    my $netlist_pointer = tell(NETLIST) ;
    while ($more_lines) {
	$_ = <NETLIST> ;
	if (/^\+/) {
	    s/^\+// ;
	    chomp($line);
	    $line = join " ", $line, $_ ;
	} else {
	    $more_lines = 0 ;
	    last ;
	}
    }
    seek NETLIST, $netlist_pointer, 0 ;
    return $line;
}

sub setVersion {
    my $this = shift;
    my $version = shift;
    $this->{version} = $version;
    return $version;
}

sub getVersion {
    my $this = shift;
    return $this->{version};
}

sub setDesignName {
    my $this = shift;
    my $designName = shift;
    $this->{designName} = $designName;
    return $designName;
}

sub getDesignName {
    my $this = shift;
    return $this->{designName};
}

sub setCreationDate {
    my $this = shift;
    my $date = shift;
    $this->{date} = $date;
    return $date;
}

sub getCreationDate {
    my $this = shift;
    return $this->{date};
}

sub setVendor {
    my $this = shift;
    my $vendor = shift;
    $this->{vendor} = $vendor;
    return $vendor;
}

sub getVendor {
    my $this = shift;
    return $this->{vendor};
}

sub setVendorProgram {
    my $this = shift;
    my $vendorProgram = shift;
    $this->{vendorProgram} = $vendorProgram;
    return $vendorProgram;
}

sub getVendorProgram {
    my $this = shift;
    return $this->{vendorProgram};
}

sub setVendorProgramVersion {
    my $this = shift;
    my $vendorProgramVersion = shift;
    $this->{vendorProgramVersion} = $vendorProgramVersion;
    return $vendorProgramVersion;
}

sub getVendorProgramVersion {
    my $this = shift;
    return $this->{vendorProgramVersion};
}

sub setHierarchyDivider {
    my $this = shift;
    my $divider = shift;
    $this->{divider} = $divider;
    return $divider;
}

sub getHierarchyDivider {
    my $this = shift;
    return $this->{divider};
}

sub setDelimiter {
    my $this = shift;
    my $delimiter = shift;
    $this->{delimiter} = $delimiter;
    return $delimiter;
}

sub getDelimiter {
    my $this = shift;
    return $this->{delimiter};
}

sub setSubcktName {
    my $this = shift;
    my $subckt = shift;
    $this->{subckt} = $subckt;
    return $subckt;
}

sub getSubcktName {
    my $this = shift;
    return $this->{subckt};
}

sub addNet {
    my $this = shift;
    my $net = shift;
    push(@{$this->{nets}}, $net);
    return $net;
}

sub getNets {
    my $this = shift;
    if(defined($this->{nets})) {return @{$this->{nets}};}
    else { my @l; return @l; }
}

sub addPort {
    my $this = shift;
    my $port = shift;
    push(@{$this->{ports}}, $port);
    return $port;
}

sub getPorts {
    my $this = shift;
    if(defined($this->{ports})) {return @{$this->{ports}};}
    else { my @l; return @l; }
}

sub addInstance {
    my $this = shift;
    my $inst = shift;
    push(@{$this->{instances}}, $inst);
    return $inst;
}

sub getInstances {
    my $this = shift;
    if(defined($this->{instances})) {return @{$this->{instances}};}
    else { my @l; return @l; }
}

sub addParasiticCap {
    my $this = shift;
    my $parasitic = shift;
    push(@{$this->{parasiticCaps}}, $parasitic);
    return $parasitic;
}
 
sub getParasiticCaps {
    my $this = shift;
    if(defined($this->{parasiticCaps})) { return @{$this->{parasiticCaps}}; }
    else { my @l; return @l; }
}
 
sub addParasiticRes {
    my $this = shift;
    my $parasitic = shift;
    push(@{$this->{parasiticResistors}}, $parasitic);
    return $parasitic;
}
 
sub getParasiticResistors {
    my $this = shift;
    if(defined($this->{parasiticResistors})) { return @{$this->{parasiticResistors}}; }
    else { my @l; return @l; }
}

# Destructor
sub DESTROY {
    my $this = shift;
}

1;
