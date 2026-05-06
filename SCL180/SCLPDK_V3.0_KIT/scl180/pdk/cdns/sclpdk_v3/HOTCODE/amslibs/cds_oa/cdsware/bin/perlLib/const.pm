require 5.004;

package const;

use const::clock;
use const::input;
use const::output;
use const::false;

# Constructor
sub new {
    my $type = shift;
    my $this = {};
    bless $this, $type;
    return $this;
}

sub readSynopsysConstraints {
    my $this = shift;
    my $constFile = shift;

    open(CONST, "$constFile") ||
	die "readSynopsysConstraints: Can't open file $constFile\n";

    while (<CONST>) {
	#
	# current_design
	#
	if (/^\s*current_design\s+(\S+)\s*/) {
	    $this->setDesign($1);
	}

	#
	# create_clock
	#
	if (/create_clock/) {
	    if (/^\s*create_clock\s+(?:-name\s+\"(\S+)\"\s+|)-period\s+(\S+)\s+-waveform\s+\{\s*(\S+)\s+(\S+)\s*\}\s+find\((port|pin),\s*\"(\S+)\"\)/) {
		my $clkname = $1;
		my $period = $2;
		my $posEdge = $3;
		my $negEdge = $4;
		my $rootType = $5;
		my $rootName = $6;
		if (!defined($clkname)) {$clkname = $rootName;}
		my $clock = new const::clock($clkname);
		if ($rootType eq "port") {
		    $clock->setRootIOPin($rootName);
		}
		elsif ($rootType eq "pin") {
		    $clock->setRootPin($rootName);
		}
		$clock->setPeriod($period);
		$clock->setPosTransTime($posEdge);
		$clock->setNegTransTime($negEdge);
		$this->addClock($clock);
	    }
	    else {
		print "WARNING: Can't parse create_clock constraint.\n";
		print "-->" . $_;
	    }
	}

	#
	# set_clock_skew
	#
	if (/set_clock_skew|set_clock_uncertainty/) {
	    #if (/^\s*set_clock_skew\s+-uncertainty\s+(\S+)\s+.*find\(clock,\s*\"(\S+)\"\)/) {
	    if ((/^\s*set_clock_skew\s+-uncertainty\s+(\S+)\s+.*find\(clock,\s*\"(\S+)\"\)/) ||
	    (/^\s*set_clock_uncertainty\s+(\S+)\s+.*find\(clock,\s*\"(\S+)\"\)/)) {
		my $clock = $this->getClock($2);
		if (defined($clock)) {
		    $clock->setMaxSkew($1);
		    $clock->setMinInsertionDelay(0.0);
		    $clock->setMaxInsertionDelay(0.0);
		}
	    }
	    else {
		print "WARNING: Can't parse set_clock_skew constraint.\n";
		print "-->" . $_;
	    }
	}

	#
	# set_clock_transition
	#
	if (/set_clock_transition/) {
	    if (/^\s*set_clock_transition\s+-(rise|fall)\s+(\S+)\s+find\(clock,\s*\"(\S+)\"\)/) {
		my $maxtrans = $2;
		my $clock = $this->getClock($3);
		if (defined($clock)) {
		    my $oldtrans = $clock->getMaxTransition() || 0.0;
		    if ($maxtrans >= $oldtrans) {
			$clock->setMaxTransition($maxtrans);
		    }
		}
	    }
	    else {
		print "WARNING: Can't parse set_clock_transition constraint.\n";
		print "-->" . $_;
	    }
	}

	#
	# set_input_delay
	#
#	if (/set_input_delay/) {
#	    if (/^\s*set_input_delay\s+(\S+)\s+(?:-(min|max)\s+|)-clock\s+\"(\S+)\"\s+find\((port|pin),\s*\"(\S+)\"\)/) {
#		my $delay = $1;
#		my $level = $2;
#		my $clock = $3;
#		my $port = $5;
#		my $input = $this->getInput($port);
#		if (!defined($input)) {
#		    $input = new const::input($port);
#		    $this->addInput($input);
#		}
#		if ($level eq "min") {
#		    $input->setMinArrivalTime($delay);
#		}
#		else {
#		    if (!defined($input->getMinArrivalTime())) {
#		        $input->setMinArrivalTime($delay);
#		    }
#		    $input->setMaxArrivalTime($delay);
#		}
#		$input->setClockName($clock);
#	    }
#	    else {
#		print "WARNING: Can't parse set_input_delay constraint.\n";
#		print "-->" . $_;
#	    }
#	}

	#
	# set_drive
	#
#	if (/set_drive/) {
#	    if (/^\s*set_drive\s+(\S+)\s+find\(port,\s*\"(\S+)\"\)/) {
#		my $drive = $1;
#		my $port = $2;
#		my $input = $this->getInput($port);
#		if (!defined($input)) {
#		    $input = new const::input($port);
#		    $this->addInput($input);
#		}
#		$input->setDriveStrength($drive);
#	    }
#	    else {
#		print "WARNING: Can't parse set_drive constraint.\n";
#		print "-->" . $_;
#	    }
#	}

	#
	# set_output_delay
	#
#	if (/set_output_delay/) {
#	    if (/^\s*set_output_delay\s+(\S+)\s+(?:-(min|max)\s+|)-clock\s+\"(\S+)\"\s+find\((port|pin),\s*\"(\S+)\"\)/) {
#		my $delay = $1;
#		my $level = $2;
#		my $clock = $3;
#		my $port = $5;
#		my $output = $this->getOutput($port);
#		if (!defined($output)) {
#		    $output = new const::output($port);
#		    $this->addOutput($output);
#		}
#		$output->setArrivalTime($delay);
#		$output->setClockName($clock);
#	    }
#	    else {
#		print "WARNING: Can't parse set_output_delay constraint.\n";
#		print "-->" . $_;
#	    }
#	}

	#
	# set_load
	#
#	if (/set_load/) {
#	    if (/^\s*set_load\s+-pin_load\s+(\S+)\s+find\(port,\s*\"(\S+)\"\)/) {
#		my $load = $1;
#		my $port = $2;
#		my $output = $this->getOutput($port);
#		if (!defined($output)) {
#		    $output = new const::output($port);
#		    $this->addOutput($output);
#		}
#		$output->setLoad($output->getLoad() + $load);
#	    }
#	    elsif (/^\s*set_load\s+-wire_load\s+(\S+)\s+(\S+)/) {
#		my $load = $1;
#		my $port = $2;
#		my $output = $this->getOutput($port);
#		if (!defined($output)) {
#		    $output = new const::output($port);
#		    $this->addOutput($output);
#		}
#		$output->setLoad($output->getLoad() + $load);
#	    }
#	    else {
#		print "WARNING: Can't parse set_load constraint.\n";
#		print "-->" . $_;
#	    }
#	}

	#
	# set_max_transition
	#
#	if (/set_max_transition/) {
#	    if (/^\s*set_max_transition\s+(\S+)\s+find\(port,\s*\"(\S+)\"\)/) {
#		my $maxtrans = $1;
#		my $port = $2;
#		my $output = $this->getOutput($port);
#		if (!defined($output)) {
#		    $output = new const::output($port);
#		    $this->addOutput($output);
#		}
#		$output->setMaxTransition($maxtrans);
#	    }
#	    elsif (/^\s*set_max_transition\s+(\S+)\s+current_design/) {
#		$this->setDefaultMaxTransition($1);
#	    }
#	    else {
#		print "WARNING: Can't parse set_max_transition constraint.\n";
#		print "-->" . $_;
#	    }
#	}

	#
	# set_false_path
	#
#	if (/set_false_path/) {
#	    while (/\\\s*$/) {
#		chop;
#		s/\\//;
#		$_ .= <CONST>;
#	    }
#            #----------------------------------------------------#
#            #-- Added to deal with to & from lists in {}       --#
#            #----------------------------------------------------#
#            my($fromType, $from, $toType, $to, $f, $t);
#            if (/{/) {
#              if (/-from\s+{(.*)\}\s*-to\s+find\((\S+),\s*\"(\S+)\"\)/) {
#                @fromlist = split(/find/, $1);
#                $toType = $2;
#                $to = $3;
#                foreach $f (@fromlist) {
#                  if ($f =~ /\((\S+),\s*\"(\S+)\"\)/ ){
#                    $fromType = $1;
#                    $from = $2;
#                    #if (!($fromType eq "clock" && $toType eq "clock")) {
#                    if ($fromType ne "clock" && $toType ne "clock") {
#                      $false = new const::false();
#                      $this->addFalsePath($false);
#                      if (defined($from)) {$false->setFromItem($from);}
#                      if (defined($to)) {$false->setToItem($to);}
#                    }#if
#                  }#if  
#                }#foreach
#              }#if 
#              if (/\s*-from\s+find\((\S+),\s*\"(\S+)\"\)\s*-to\s+\{(.*)\}/) {
#                $fromType = $1;
#                $from = $2;
#                @tolist = split(/find/, $3);
#                foreach $t (@tolist) {
#                  if ($t =~ /\((\S+),\s*\"(\S+)\"\)/ ){
#                    $toType = $1;
#                    $to = $2;
#                    #if (!($fromType eq "clock" && $toType eq "clock")) {
#                    if ($fromType ne "clock" && $toType ne "clock") {
#                        $false = new const::false();
#                        $this->addFalsePath($false);
#                        if (defined($to)) {$false->setToItem($to);}
#                    }#if 
#                  }#if
#                }#foreach
#              }#if
#	    } elsif (/^\s*set_false_path\s*(?:-from\s+find\((\S+),\s*\"(\S+)\"\)|)\s*(?:-to\s+find\((\S+),\s*\"(\S+)\"\)|)/) {
#		$fromType = $1;
#		$from = $2;
#		$toType = $3;
#		$to = $4;
#		#if (!($fromType eq "clock" && $toType eq "clock")) {
#		if ($fromType ne "clock" && $toType ne "clock") {
#		    $false = new const::false();
#		    $this->addFalsePath($false);
#		    if (defined($from)) {$false->setFromItem($from);}
#		    if (defined($to)) {$false->setToItem($to);}
#		}
#            }
#	    else {
#		print "WARNING: Can't parse set_false_path constraint.\n";
#		print "-->" . $_;
#	    }
#	}

	#
	# set_multicycle_path
	#
#	if (/set_multicycle_path/) {
#	    print "WARNING: Can't parse set_multicycle_path constraint yet.\n";
#	    print "-->" . $_;
#	}
    }
    close(CONST);

    return $constFile;
}

sub writeGCF {
    my $this = shift;
    my $fileName = shift;

    open(GCF, ">$fileName") || die "writeGCF: Can't open file $fileName\n";

    chop($date = `date`);

    print GCF "(GCF\n";
    print GCF "  (HEADER\n";
    print GCF "    (VERSION \"1.2\")\n";
    print GCF "    (DESIGN \"" . $this->getDesign() . "\")\n";
    print GCF "    (DATE \"$date\")\n";
    print GCF "    (PROGRAM \"syn2gcf.cmd\" \"1.0\" \"Pearl\")\n";
    print GCF "    (DELIMITERS \"/[]\")\n";
    print GCF "    (TIME_SCALE 1e-9)\n";
    print GCF "    (CAP_SCALE 1e-12)\n";
    print GCF "    (RES_SCALE 1)\n";
    print GCF "    (VOLTAGE_SCALE 1)\n";
    print GCF "  )\n";
    print GCF "  (GLOBALS\n";
    print GCF "    (GLOBALS_SUBSET ENVIRONMENT\n";
    print GCF "      (PROCESS  1.0000 1.0000)\n";
    print GCF "      (VOLTAGE  0.0 0.0)\n";
    print GCF "      (TEMPERATURE  0.0 0.0)\n";
    print GCF "      (OPERATING_CONDITIONS \"NOMINAL\" 1.0 0.0 0.0)\n";
    print GCF "      (VOLTAGE_THRESHOLD 10.0 90.0)\n";

    my @tlfFiles = $this->getTLFFiles();
    if (@tlfFiles) {
	print GCF "      (EXTENSION \"CTLF_FILES\"\n";
	print GCF "        (\n";
	my $tlfFile;
	foreach $tlfFile (@tlfFiles) {
	    print GCF "          $tlfFile\n";
	}
	print GCF "        )\n";
	print GCF "      )\n";
    }
    print GCF "    )\n";

    my @clocks = $this->getClocks();
    if (@clocks) {
	@clocks = sort(byName @clocks);
	print GCF "    (GLOBALS_SUBSET TIMING\n";
	my $clock;
	foreach $clock (@clocks) {
	    my $name = $clock->getName();
	    my $period = $clock->getPeriod();
	    my $posEdge = $clock->getPosTransTime();
	    my $negEdge = $clock->getNegTransTime();
	    print GCF "      (WAVEFORM \"$name\" $period ";
	    print GCF "(POSEDGE $posEdge) (NEGEDGE $negEdge))\n";
	}
	print GCF "      (LEVEL 1\n";
	foreach $clock (@clocks) {
	    my $name = $clock->getName();
	    print GCF "        (CLOCK_GROUP \"$name\" \"$name\")\n";
	}
	print GCF "      )\n";
	print GCF "    )\n";
    }
    print GCF "  )\n";

    my @inputs = $this->getInputs();
    if (@inputs) {
	@inputs = sort(byName @inputs);
	print GCF "  (CELL ()\n";
	print GCF "    (SUBSET TIMING\n";
	print GCF "      (ENVIRONMENT\n";
	foreach $clock (@clocks) {
	    my $name = $clock->getName();
	    #my $port = $clock->getRootIOPin();
	    my $port = $clock->getRootIOPin() || $clock->getRootPin();
	    print GCF "        (CLOCK \"$name\" $port)\n";
	}
	my $input;
	foreach $input (@inputs) {
	    my $name = $input->getName();
	    my $minAT = $input->getMinArrivalTime();
	    my $maxAT = $input->getMaxArrivalTime();
	    my $clockName = $input->getClockName();
	    my $drive = $input->getDriveStrength();
	    if (defined($minAT)) {
		print GCF "        (ARRIVAL (POSEDGE \"$clockName\") $minAT $maxAT $minAT $maxAT $name)\n";
	    }
	    if (defined($drive)) {
		print GCF "        (DRIVER_STRENGTH $drive $name)\n";
	    }
	}
	my $output;
	foreach $output (sort byName $this->getOutputs()) {
	    my $name = $output->getName();
	    my $at = $output->getArrivalTime();
	    my $hat = -1000000000.0;
	    my $clockName = $output->getClockName();
	    if (defined($at)) {
		print GCF "        (DEPARTURE (POSEDGE \"$clockName\") $at $at $hat $hat $name)\n";
	    }
	}
	print GCF "        (INPUT_SLEW 0.2)\n";
	print GCF "      )\n";
	print GCF "      (EXCEPTIONS\n";
	print GCF "        (LEVEL 1\n";
	foreach $clock (@clocks) {
	    my $name = $clock->getName();
	    my $port = $clock->getRootIOPin() || $clock->getRootPin();
	    my $skew = $clock->getMaxSkew();
	    my $slew = $clock->getMaxTransition();
	    my $minDelay = $clock->getMinInsertionDelay();
	    my $maxDelay = $clock->getMaxInsertionDelay();
	    if (defined($skew)) {
		print GCF "          (CLOCK_DELAY $port ((SKEW $skew)";
		print GCF " (INSERTION_DELAY $minDelay $maxDelay)";
		if (defined($slew)) {
		    print GCF " (SLEW $slew))";
		}
		else {
		    print GCF ")\n";
		}
		print GCF ")\n";
	    }
	}
	print GCF "        )\n";
	my $defMaxtrans = $this->getDefaultMaxTransition();
	if (defined($defMaxtrans)) {
	    print GCF "        (MAX_TRANSITION_TIME $defMaxtrans $defMaxtrans)\n";
	}
	foreach $output (sort byName $this->getOutputs()) {
	    my $name = $output->getName();
	    my $maxtrans = $output->getMaxTransition();
	    if (defined($maxtrans)) {
		print GCF "        (MAX_TRANSITION_TIME $maxtrans $maxtrans $name)\n";
	    }
	}
	my $falsePath;
	foreach $falsePath ($this->getFalsePaths()) {
	    my $from = $falsePath->getFromItem();
	    my $to = $falsePath->getToItem();
	    if (defined($from) && defined($to)) {
		print GCF "        (DISABLE ((FROM $from) (TO $to)))\n";
	    }
	    elsif (defined($from)) {
		print GCF "        (DISABLE (FROM $from))\n";
	    }
	    else {
		print GCF "        (DISABLE (TO $to))\n";
	    }
	}
	print GCF "      )\n";
	print GCF "    )\n";
	print GCF "    (SUBSET PARASITICS\n";
	print GCF "      (ENVIRONMENT\n";
	foreach $output (sort byName $this->getOutputs()) {
	    my $name = $output->getName();
	    my $load = $output->getLoad();
	    if (defined($load)) {
		print GCF "        (EXTERNAL_LOAD $load $name)\n";
	    }
	}
	print GCF "      )\n";
	print GCF "    )\n";
	print GCF "  )\n";
    }

    print GCF ")\n";
    close(GCF);
}

sub writeCTGENConstraints {
    my $this = shift;
    my $fileName = shift;

    open(CONST, ">$fileName") || die "writeCTGENConstraints: Can't open file $fileName\n";
    my $clock;
    foreach $clock ($this->getClocks()) {
	print CONST "specify_tree\n";
	print CONST "    root_iopin '" . $clock->getRootIOPin() . "'\n";

	my $period = $clock->getPeriod();
	my $posTrans = $clock->getPosTransTime();
	my $negTrans = $clock->getNegTransTime();
	my $highTime = $negTrans - $posTrans;
	my $lowTime = $period - $negTrans;
	print CONST "set_constraints\n";
	print CONST "    waveform 0 $highTime 0 $lowTime\n";
	print CONST "    min_delay " . $clock->getMinInsertionDelay() . "\n";
	print CONST "    max_delay " . $clock->getMaxInsertionDelay() . "\n";
	print CONST "    max_skew " . $clock->getMaxSkew() . "\n";
	my $maxTrans = $clock->getMaxTransition();
	if (defined($maxTrans)) {
	    print CONST "    max_transition $maxTrans\n";
	}

	print CONST "define_cells\n";
	print CONST "    buffers";
	my $cell;
	foreach $cell ($clock->getBufferCells()) {
	    print CONST " '$cell'";
	}
	print CONST "\n";
	print CONST "    inverters";
	foreach $cell ($clock->getInverterCells()) {
	    print CONST " '$cell'";
	}
	print CONST "\n\n";
    }
    close(CONST);
}

sub setDesign {
    my $this = shift;
    my $design = shift;
    $this->{design} = $design;
    return $design;
}

sub getDesign {
    my $this = shift;
    return $this->{design};
}

sub addTLFFile {
    my $this = shift;
    my $tlfFile = shift;
    push(@{$this->{tlfFiles}}, $tlfFile);
    return $tlfFile;
}

sub getTLFFiles {
    my $this = shift;
    if(defined($this->{tlfFiles})) {return @{$this->{tlfFiles}};}
    else { my @l; return @l; }
}

sub deleteTLFFiles {
    my $this = shift;
    delete $this->{tlfFiles};
}

sub addClock {
    my $this = shift;
    my $clock = shift;
    $this->{clocks}{$clock->getName()} = $clock;
    return $clock;
}

sub getClock {
    my $this = shift;
    my $clock = shift;
    return $this->{clocks}{$clock};
}

sub getClocks {
    my $this = shift;
    return values(%{$this->{clocks}});
}

sub addInput {
    my $this = shift;
    my $input = shift;
    $this->{inputs}{$input->getName()} = $input;
    return $input;
}

sub getInput {
    my $this = shift;
    my $portname = shift;
    return $this->{inputs}{$portname};
}

sub getInputs {
    my $this = shift;
    return values(%{$this->{inputs}});
}

sub addOutput {
    my $this = shift;
    my $output = shift;
    $this->{outputs}{$output->getName()} = $output;
    return $output;
}

sub getOutput {
    my $this = shift;
    my $portname = shift;
    return $this->{outputs}{$portname};
}

sub getOutputs {
    my $this = shift;
    return values(%{$this->{outputs}});
}

sub addFalsePath {
    my $this = shift;
    my $false = shift;
    push(@{$this->{falsepaths}}, $false);
    return $false;
}

sub getFalsePaths {
    my $this = shift;
    if(defined($this->{falsepaths})) {return @{$this->{falsepaths}};}
    else { my @l; return @l; }
}

sub setDefaultMaxTransition {
    my $this = shift;
    my $maxtrans = shift;
    $this->{maxtrans} = $maxtrans;
    return $maxtrans;
}

sub getDefaultMaxTransition {
    my $this = shift;
    return $this->{maxtrans};
}

sub byName {
    $a->getName() cmp $b->getName();
}

# Destructor
sub DESTROY {
    my $this = shift;
}

1;
