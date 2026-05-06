require 5.004;

package dspf;

use dspf::net;
use dspf::pin;
use dspf::instTerm;
use dspf::parasitic;
use dspf::instance;

# Constructor
sub new {
    my $type = shift;
    my $this = {};
    bless $this, $type;
    return $this;
}

sub read {
    my $this = shift;
    my $dspfFile = shift;

    my $net;

    open(NETLIST, "$dspfFile") || die "$0: Can't open file $dspfFile\n";

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
	    $this->setSubcktName($1);
	}

	#
	# net
	#
	elsif (/^\*\|NET\s+(\S+)\s+(\S+)\s*$/) {
	    $net = new dspf::net($1);
	    $net->setTotalCap($2);
	    $this->addNet($net);
	}

	#
	# lumped parasitic net
	#
	elsif (/^\*\|NET\s+\((\S+)\s+(\S+)\)\s*$/) {
	    $net = new dspf::net($1);
	    $net->setTotalCap($2);
	    $this->addNet($net);
	}

	#
	# instance terminal
	#
	elsif (/^\*\|I\s+\((\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\)\s*$/) {
	    my $instTerm = new dspf::instTerm;
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
	elsif (/^\*\|P\s+\((\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\)\s*$/) {
	    my $pin = new dspf::pin;
	    $pin->setSubNetName($1);
	    $pin->setXCoord($4);
	    $pin->setYCoord($5);
	    $net->addSubNetName($1);
	    $net->addPin($pin);
	    $this->addPort($net);
	}

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
	    my $parasitic = new dspf::parasitic($1);
	    $parasitic->setNodeName1($2);
	    $parasitic->setNodeName2($3);
	    $parasitic->setValue($4);
	    $this->addParasiticCap($parasitic);
	}

	#
	# parasitic resistor
	#
	elsif (/^([r|R]\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*$/) {
	    my $parasitic = new dspf::parasitic($1);
	    $parasitic->setNodeName1($2);
	    $parasitic->setNodeName2($3);
	    $parasitic->setValue($4);
	    $this->addParasiticRes($parasitic);
	}

        #
        # primitive instance
        #
        else {
	    my @fields = split(' ');
            my $instName = $fields[0];
	    if ($instName =~ /^([x|X])/) {
	        my $inst = new dspf::instance($instName);
                $instName =~ s/^x_//;
	        $inst->setXCoord($instX{$instName});
	        $inst->setYCoord($instY{$instName});
	        my $keep = 1;
	        my @keepList = ();
	        my $field;
	        shift @fields;
	        foreach $field (@fields) {
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
