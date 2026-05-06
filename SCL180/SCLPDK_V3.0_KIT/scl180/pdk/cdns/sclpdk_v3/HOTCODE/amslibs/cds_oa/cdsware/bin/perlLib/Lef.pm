
require 5.004;

package Lef;

use Lef::Macro;
use Lef::Poly;
use Lef::Port;
use Lef::Site;
use Lef::Pin;
use Lef::ViaRule;
use Lef::Layer;
use Lef::Via;

use vars qw($verboseMode);


#-----------------------------------------------#
#-- Static functions.                         --#
#-----------------------------------------------#

# Sorting routine, sort by object's name.
# @newList = sort _byName @oldList;
sub _byName {
    $a->getName() cmp $b->getName();
}

# Convert a general real number string to "minimum length" real number string
#     This function is used to eliminate trailing zeros or nines (e.g.
#     "1.000000" and "0.9999999" change to "1.00")
# Usage: $newReal = Lef::_simpleReal($oldReal);
sub _simpleReal {
    if(@_ != 1) { die "$0: Bad number of arguments to _simpleReal"; }
    my $org = shift;
    my $fin = sprintf("%10.8f", $org*1.00000000000001);
    if($fin !~ /^([+-]?\d+\.\d\d(\d*[1-9])?)0*$/) {
	die "$0: Internal error ($fin)";
    }
    $fin = $1;
    if($fin =~ /^([+-]?\d+\.\d*)([1-8])99+$/) {
	$fin = $1 . ($2+1);
    }
    return $fin;
}

#-----------------------------------------------#
#-- Regular methods.                          --#
#-----------------------------------------------#
# Set verbose mode to ON.
# Usage: Lef::doVerbose();
sub doVerbose {
    if(@_ != 0) { die "$0: Bad number of arguments to doVerbose"; }
    $verboseMode = 1;
    $| = 1;
}

# Constructor
# Usage: $lef = Lef->new();
#        $lef = Lef->new($fileName);
sub new {
    if(@_ < 1 || @_ > 2) {
	die "$0: Bad number of arguments to new";
    }
    my $type = shift;
    my $lefFileName = shift;

    my $this = {};
    bless $this, $type;

    if(defined($lefFileName)) {
	if(!$this->read($lefFileName)) {
            print "Errors occured during read.\n";
            return ();
	}
    }

    return $this;
}

sub setVersion {
    if(@_ != 2) { die "$0: Bad number of arguments to setVersion"; }
    my $this = shift;
    my $version = shift;

    $this->{version} = $version;

    return $this->{version};
}

sub getVersion {
    if(@_ != 1) { die "$0: Bad number of arguments to getVersion"; }
    my $this = shift;

    return $this->{version};
}

sub setNamesCaseSensitive {
    if(@_ != 2) { die "$0: Bad number of arguments to setNamesCaseSensitive"; }
    my $this = shift;
    my $NamesCaseSensitive = shift;

    $this->{NamesCaseSensitive} = $NamesCaseSensitive;

    return $this->{NamesCaseSensitive};
}

sub getNamesCaseSensitive {
    if(@_ != 1) { die "$0: Bad number of arguments to getNamesCaseSensitive"; }
    my $this = shift;

    return $this->{NamesCaseSensitive};
}

# Usage: $lef->setUnit($unitType, $baseUnit, $scale);
sub setUnit {
    if(@_ != 4) { die "$0: Bad number of arguments to setUnit"; }
    my $this = shift;
    my $type = shift;
    my $base = shift;
    my $scale = shift;

    @{$this->{units}{lc($type)}} = ($base, $scale);

    return ($base, $scale);
}

# Usage: ($baseUnit, $scale) = $lef->getUnitTypes($unitType);
sub getUnitTypes {
    if(@_ != 1) { die "$0: Bad number of arguments to getUnitTypes"; }
    my $this = shift;

    return keys(%{$this->{units}});
}

# Usage: ($baseUnit, $scale) = $lef->setUnit($unitType);
sub getUnit {
    if(@_ != 2) { die "$0: Bad number of arguments to getUnit"; }
    my $this = shift;
    my $type = shift;

    return @{$this->{units}{lc($type)}};
}

# Usage: $lef->addLayer($layer);
sub addLayer {
    if(@_ != 2) {
	die "$0: Bad number of arguments to addLayer";
    }
    my $this = shift;
    my $layer = shift;

    # Note: The order in which the layers are added is preserved.
    $this->{layer}{$layer->getName()} = $layer;
    push(@{$this->{layerOrder}}, $layer);

    return $layer;
}

# Usage: $lef->removeLayer($layerName);
sub removeLayer {
    if(@_ != 2) { die "$0: Bad number of arguments to removeLayer"; }
    my $this = shift;
    my $layerName = shift;

    delete $this->{viaRule}{$layerName};
}

# Usage: $layer = $lef->getLayer($layerName);
sub getLayer {
    if(@_ != 2) { die "$0: Bad number of arguments to getLayer"; }
    my $this = shift;
    my $layerName = shift;

    return $this->{layer}{$layerName};
}

# Usage: @layers = $lef->getLayers();
sub getLayers {
    if(@_ != 1) { die "$0: Bad number of arguments to getLayers"; }
    my $this = shift;

    # Note: The layers are returned in the same order.
    if(defined($this->{layerOrder})) { return @{$this->{layerOrder}}; }
    else { my @l; return @l; }
}

# Usage: $lef->addVia($via);
sub addVia {
    if(@_ != 2) { die "$0: Bad number of arguments to addVia"; }
    my $this = shift;
    my $via = shift;

    $this->{via}{$via->getName()} = $via;

    return $via;
}

# Usage: $lef->removeVia($viaName);
sub removeVia {
    if(@_ != 2) { die "$0: Bad number of arguments to removeVia"; }
    my $this = shift;
    my $viaName = shift;

    delete $this->{viaRule}{$viaName};
}

# Usage: $via = $lef->getVia($viaName);
sub getVia {
    if(@_ != 2) { die "$0: Bad number of arguments to getVia"; }
    my $this = shift;
    my $viaName = shift;

    return $this->{via}{$viaName};
}

# Usage: @vias = $lef->getVias();
sub getVias {
    if(@_ != 1) { die "$0: Bad number of arguments to getVias"; }
    my $this = shift;

    return values(%{$this->{via}});
}

# Usage: $lef->addViaRule($viaRule);
sub addViaRule {
    if(@_ != 2) { die "$0: Bad number of arguments to addViaRule"; }
    my $this = shift;
    my $viaRule = shift;

    $this->{viaRule}{$viaRule->getName()} = $viaRule;

    return $viaRule;
}

# Usage: $lef->removeViaRule($viaRuleName);
sub removeViaRule {
    if(@_ != 2) {
	die "$0: Bad number of arguments to removeViaRule";
    }
    my $this = shift;
    my $ruleName = shift;

    delete $this->{viaRule}{$ruleName};
}

# Usage: $viaRule = $lef->getViaRule($viaRuleName);
sub getViaRule {
    if(@_ != 2) { die "$0: Bad number of arguments to getViaRule"; }
    my $this = shift;
    my $ruleName = shift;

    return $this->{viaRule}{$ruleName};
}

# Usage: @viaRules = $lef->getViaRules();
sub getViaRules {
    if(@_ != 1) {
	die "$0: Bad number of arguments to getViaRules";
    }
    my $this = shift;

    return values(%{$this->{viaRule}});
}

# Usage: $lef->addSpacing($layerName1, $layerName2, $distance);
#        $lef->addSpacing($layerName1, $layerName2, $distance, "STACK");
sub addSpacing {
    if(@_ < 4 || @_ > 5) { die "$0: Bad number of arguments to addSpacing"; }
    my $this = shift;
    my $layerName1 = shift; my $layerName2 = shift;
    my $dist = shift; my $opt = shift;

    ($layerName1, $layerName2) = sort ($layerName1, $layerName2);
    $this->{spacing}{samenet}{$layerName1}{$layerName2} = $dist;
    if(defined($opt)) {
	if(uc($opt) eq "STACK") {
	    $this->{stack}{$layerName1}{$layerName2} = 1;
	}
	else {
	    die "$0: Invalid option flag passed to assSpacing: $opt";
	}
    }

    return ($dist, $opt);
}

# Usage: $distance = $lef->addSpacing($layerName1, $layerName2);
#        ($distance, $stack) = $lef->addSpacing($layerName1, $layerName2);
sub getSameNetSpacing {
    if(@_ != 3) { die "$0: Bad number of arguments to getSameNetSpacing"; }
    my $this = shift;
    my $layerName1 = shift; my $layerName2 = shift;

    ($layerName1, $layerName2) = sort ($layerName1, $layerName2);
    if(!defined($this->{stack}{$layerName1}{$layerName2})) {
	return $this->{spacing}{samenet}{$layerName1}{$layerName2};
    }
    else {
	return ($this->{spacing}{samenet}{$layerName1}{$layerName2},
		$this->{stack}{$layerName1}{$layerName2});
    }
}

# The getFirstSNLayerNames and getSecondSNLayerNames are used to rapidly
#    cycle through the various pairs of layer names for which spacing
#    rules are defined.  The getFirstSNLayerNames returns a list of the
#    layer names stored first in each pair of layer names in the internal
#    data structure for Lef.
# Usage: @layerNames = $lef->getFirstSNLayerNames();
sub getFirstSNLayerNames {
    if(@_ != 1) { die "$0: Bad number of arguments to getFirstSNLayerNames"; }
    my $this = shift;

    return (keys(%{$this->{spacing}{samenet}}));
}

# The getFirstSNLayerNames and getSecondSNLayerNames are used to rapidly
#    cycle through the various pairs of layer names for which spacing
#    rules are defined.  The getSecondSNLayerNames returns a list of the
#    layer names stored second in each pair of layer names in the internal
#    data structure for Lef.
# Usage: @layerNames = $lef->getSecondSNLayerNames($firstLayerName);
sub getSecondSNLayerNames {
    if(@_ != 2) { die "$0: Bad number of arguments to getSecondSNLayerNames"; }
    my $this = shift;
    my $layerName1 = shift;

    return (keys(%{$this->{spacing}{samenet}{$layerName1}}));
}

# Usage: @layerPairs = $lef->getSameNetSpacingPairs();
sub getSameNetSpacingPairs {
    if(@_ != 1) { die "$0: Bad number of arguments to getSameNetSpacingPairs"; }
    my $this = shift;

    my @pairs;
    my $layerName1;
    foreach $layerName1 ($this->getFirstSNLayerNames()) {
	my $layerName2;
	foreach $layerName2 ($this->getSecondSNLayerNames($layerName1)) {
	    push(@pairs, [$layerName1, $layerName2]);
	}
    }

    return @pairs;
}

# Usage: $lef->addSite($site);
sub addSite {
    if(@_ != 2) { die "$0: Bad number of arguments to addSite"; }
    my $this = shift;
    my $site = shift;

    $this->{site}{$site->getName()} = $site;

    return $site;
}
# Usage: $lef->removeSite($siteName);
sub removeSite {
    if(@_ != 2) { die "$0: Bad number of arguments to removeSite"; }
    my $this = shift;
    my $siteName = shift;

    delete $this->{site}{$siteName};
}

# Usage: $site = $lef->getSite($siteName);
sub getSite {
    if(@_ != 2) { die "$0: Bad number of arguments to getSite"; }
    my $this = shift;
    my $siteName = shift;

    return $this->{site}{$siteName};
}

# Usage: @sites = $lef->getSites();
sub getSites {
    if(@_ != 1) { die "$0: Bad number of arguments to getSite"; }
    my $this = shift;

    return values(%{$this->{site}});
}

# Usage: $lef->addMacro($macro);
sub addMacro {
    if(@_ != 2) { die "$0: Bad number of arguments to addMacro"; }
    my $this = shift;
    my $macro = shift;

    $this->{macro}{$macro->getName()} = $macro;

    return $macro;
}

# Usage: $lef->removeMacro($macroName);
sub removeMacro {
    if(@_ != 2) { die "$0: Bad number of arguments to removeMacro"; }
    my $this = shift;
    my $macroName = shift;

    delete $this->{macro}{$macroName};
}

# Usage: $macro = $lef->getMacro($macroName);
sub getMacro {
    if(@_ != 2) { die "$0: Bad number of arguments to getMacro"; }
    my $this = shift;
    my $macroName = shift;

    if(!defined($this->{macro})) { return undef; }
    return $this->{macro}{$macroName};
}

# Usage: @macros = $lef->getMacro();
sub getMacros {
    if(@_ != 1) { die "$0: Bad number of arguments to getMacros"; }
    my $this = shift;

    return values(%{$this->{macro}});
}

# Usage: $lef->setFileName($fn);
sub setFileName {
    if(@_ != 2) { die "$0: Bad number of arguments to setFileName"; }
    my $this = shift;
    my $lefFileName = shift;

    $this->{fileName} = $lefFileName;

    return $this->{fileName};
}

# Usage: $fn = $lef->getFileName();
sub getFileName {
    if(@_ != 1) { die "$0: Bad number of arguments to getFileName"; }
    my $this = shift;

    return $this->{fileName};
}

# Usage: $status = $lef->read();
# Usage: $status = $lef->read($fileName);
sub read {
    if(@_ < 1 || @_ > 2) { die "$0: Bad number of arguments to read"; }
    my $this = shift;
    my $lefFileName = shift;

    if(!defined($lefFileName)) { $lefFileName = $this->getFileName(); }

    if(!defined($lefFileName)) {
    	die "$0: Cannot call read on this object, no filename has been defined in the object";
    }

    $this->setFileName($lefFileName);

    if($verboseMode) { print "$0: Reading $lefFileName ... \n"; }

    if(!open(LEFFILE, "<$lefFileName")) {
	print "*Error* Failed to open $lefFileName\n";
	return 0;
    }
    my $vState = 0;
    my $macroCount = 0;
    while(<LEFFILE>) {
	if(/^\s*NAMESCASESENSITIVE\s+(ON|OFF)\s*;\s*$/i) {
          $this->setNamesCaseSensitive($1);
	} 
        elsif(/^\s*VERSION\s+(\S+)\s*;\s*$/i) {
          $this->setVersion($1);
	}
	elsif(/^\s*UNITSs*$/i) {
	    while(<LEFFILE>) {
		if(/^\s*END\s+UNITS\s*$/) { last; }
		elsif(/^\s*(\S+)\s+(\S+)\s+(\d+)\s*\;\s*$/) {
		    $this->setUnit($1, $2, $3);
		}
		elsif(!/^\s*$/ && !/^\s*#/) {
		    $_ =~ /^(.*)/;
		    print "*Error* Unrecognized statement: $1 at $. in $lefFileName\n";
		    close(LEFFILE);
		    return 0;
		}
	    }
	}
	elsif(/^\s*LAYER\s+(\S+)\s*$/i) {
	    if($verboseMode) {
		if($vState ne "layer") {
		    print "$0: Reading layer definitions\n";
		    $vState = "layer";
		}
	    }
	    my $layer = new Lef::Layer($1);
	    $this->addLayer($layer);
	    while(<LEFFILE>) {
		if(/^\s*END\s+(\S+)\s*$/i) {
		    if($1 eq $layer->getName()) { last; }
		}
		elsif(/^\s*TYPE\s+(\S+)\s*\;\s*$/i) {
		    $layer->setType(lc($1));
		}
		elsif(/^\s*WIDTH\s+(\S+)\s*\;\s*$/i) {
		    $layer->setWidth($1);
		}
		elsif(/^\s*SPACING\s+(\S+)\s*\;\s*$/i) {
		    $layer->setSpacing($1);
		}
		elsif(/^\s*PITCH\s+(\S+)\s*\;\s*$/i) {
		    $layer->setPitch($1);
		}
		elsif(/^\s*DIRECTION\s+(\S+)\s*\;\s*$/i) {
		    $layer->setDirection(lc($1));
		}
		elsif(/^\s*CAPACITANCE\s+(\S+)\s+(\S+)\s*\s;\s*$/i) {
		    $layer->setCapacitance($1, $2);
		}
		elsif(/^\s*RESISTANCE\s+(\S+)\s+(\S+)\s*\s;\s*$/i) {
		    $layer->setResistance($1, $2);
		}
		elsif(/^\s*HEIGHT\s+(\S+)\s*\;\s*$/i) {
		    $layer->setHeight($1);
		}
		elsif(/^\s*THICKNESS\s+(\S+)\s*\;\s*$/i) {
		    $layer->setThickness($1);
		}
		elsif(/^\s*SHRINKAGE\s+(\S+)\s*\;\s*$/i) {
		    $layer->setShrinkage($1);
		}
		elsif(/^\s*CAPMULTIPLIER\s+(\S+)\s*\;\s*$/i) {
		    $layer->setCapMultiplier($1);
		}
		elsif(/^\s*EDGECAPACITANCE\s+(\S+)\s*\;\s*$/i) {
		    $layer->setEdgeCapacitance($1);
		}
		elsif(!/^\s*$/ && !/^\s*#/) {
		    $_ =~ /^(.*)/;
		    print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
		    close(LEFFILE);
		    return 0;
		}
	    }
	}
	elsif(/^\s*VIA\s+(\S+)\s*(\S+)\s*$/i) {
	    if($verboseMode) {
		if($vState ne "via") {
		    print "$0: Reading via definitions\n";
		    $vState = "via";
		}
	    }
	    my $via = new Lef::Via($1);
	    $this->addVia($via);
	    $via->setType($2);
	    my $layerName;
	    while(<LEFFILE>) {
		if(/^\s*END\s+(\S+)\s*$/i) {
		    if($1 eq $via->getName()) { last; }
		}
		elsif(/^\s*LAYER\s+(\S+)\s*\;\s*$/i) {
		    $layerName = $1;
		}
		elsif(/^\s*RECT\s+(\S+)\s+(\S+)\s+(\S+)\s*(\S+)\s*\;\s*$/i) {
		    if(!defined($layerName)) {
                        print "*Error* No layer defined in via: ".$via->getName()."Line: $. $lefFileName\n";
			close(LEFFILE);
			return 0;
		    }
		    my $poly = new Lef::Poly;
		    $poly->setLayerName($layerName);
		    my @points;
		    $points[0][0] = $1; $points[0][1] = $2;
		    $points[1][0] = $3; $points[1][1] = $4;
		    $poly->setPoints(@points);
		    $via->addPoly($poly);
		}
		elsif(/^\s*RESISTANCE\s+(\S+)\s*\;\s*$/i) {
		    $via->setResistance($1);
		}
		elsif(!/^\s*$/ && !/^\s*#/) {
		    $_ =~ /^(.*)/;
		    print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
		    close(LEFFILE);
		    return 0;
		}
	    }
	}
	elsif(/^\s*VIARULE\s+(\S+)\s*(\S+)\s*$/i) {
	    if($verboseMode) {
		if($vState ne "viaRule") {
		    print "$0: Reading via rule definitions\n";
		    $vState = "viaRule";
		}
	    }
	    my $viaRule = new Lef::ViaRule($1);
	    $this->addViaRule($viaRule);
	    $viaRule->setType($2);
	    my $layerName;
	    while(<LEFFILE>) {
		if(/^\s*END\s+(\S+)\s*$/i) {
		    if($1 eq $viaRule->getName()) { last; }
		}
		elsif(/^\s*LAYER\s+(\S+)\s*\;\s*$/i) {
		    $layerName = $1;
		}
		elsif(/^\s*RECT\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*\;\s*$/i) {
		    if(!defined($layerName)) {
                        print "*Error* No layer defined in via rule: ".$viaRule->getName()."Line: $. $lefFileName\n";
			close(LEFFILE);
			return 0;
		    }
		    my $poly = new Lef::Poly;
		    $poly->setLayerName($layerName);
		    my @points;
		    $points[0][0] = $1; $points[0][1] = $2;
		    $points[1][0] = $3; $points[1][1] = $4;
		    $poly->setPoints(@points);
		    $viaRule->addPoly($poly);
		}
		elsif(/^\s*DIRECTION\s+(\S+)\s*\;\s*$/i) {
		    if(!defined($layerName)) {
                        print "*Error* No layer defined in via rule: ".$viaRule->getName()."Line: $. $lefFileName\n";
			close(LEFFILE);
			return 0;
		    }
		    $viaRule->addDirection($layerName, $1);
		}
		elsif(/^\s*OVERHANG\s+(\S+)\s*\;\s*$/i) {
		    if(!defined($layerName)) {
                        print "*Error* No layer defined in via rule: ".$viaRule->getName()."Line: $. $lefFileName\n";
			close(LEFFILE);
			return 0;
		    }
		    $viaRule->setOverhang($layerName, $1);
		}
		elsif(/^\s*METALOVERHANG\s+(\S+)\s*\;\s*$/i) {
		    if(!defined($layerName)) {
                        print "*Error* No layer defined in via rule: ".$viaRule->getName()."Line: $. $lefFileName\n";
			close(LEFFILE);
			return 0;
		    }
		    $viaRule->setMetalOverhang($layerName, $1);
		}
		elsif(/^\s*SPACING\s+(\S+)\s+BY\s+(\S+)\s*\;\s*$/i) {
		    if(!defined($layerName)) {
                        print "*Error* No layer defined in via rule: ".$viaRule->getName()."Line: $. $lefFileName\n";
			close(LEFFILE);
			return 0;
		    }
		    $viaRule->setSpacing($layerName, $1, $2);
		}
		elsif(!/^\s*$/ && !/^\s*#/) {
		    $_ =~ /^(.*)/;
		    print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
		    close(LEFFILE);
		    return 0;
		}
	    }
	}
	elsif(/^\s*SPACING\s*$/i) {
	    if($verboseMode) {
		if($vState ne "spacing") {
		    print "$0: Reading spacing definitions\n";
		    $vState = "spacing";
		}
	    }
	    while(<LEFFILE>) {
		if(/^\s*END\s+SPACING\s*$/i) { last; }
		elsif(/^\s*SAMENET\s+(\S+)\s*(\S+)\s*(\S+)\s*(\S+)?\s*\;\s*$/i) {
		    my $layer1 = $1; my $layer2 = $2;
		    my $dist = $3; my $opt = $4;
		    $this->addSpacing($1, $2, $3, $4);
		}
		elsif(!/^\s*$/ && !/\s*#/) {
		    $_ =~ /^(.*)/;
		    print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
		    close(LEFFILE);
		    return 0;
		}
	    }
	}
	elsif(/^\s*SITE\s+(\S+)\s*$/i) {
	    if($verboseMode) {
		if($vState ne "site") {
		    print "$0: Reading site definitions\n";
		    $vState = "site";
		}
	    }
	    my $site = new Lef::Site($1);
	    $this->addSite($site);
	    while(<LEFFILE>) {
		if(/^\s*END\s+(\S+)\s*$/) {
		    if($1 eq $site->getName()) { last; }
		}
		elsif(/^\s*CLASS\s+(\S+)\s*\;\s*$/i) {
		    $site->setClass(lc($1));
		}
		elsif(/^\s*SIZE\s+(\S+)\s+BY\s+(\S+)\s*\;\s*$/i) {
		    $site->setSize($1, $2);
		}
		elsif(/^\s*SYMMETRY\s+(\S([^\;]*\S+)?)\s*\;\s*$/i) {
		    my $symStr = $1;
		    my @symmetries = split(/\s*/, $symStr);
		    grep($_=lc($_), @symmetries);
		    $site->setSymmetries(@symmetries);
		}
		elsif(!/^\s*$/ && !/\s*#/) {
		    $_ =~ /^(.*)/;
		    print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
		    close(LEFFILE);
		    return 0;
		}
	    }
	}
	elsif(/^\s*MACRO\s+(\S+)\s*$/i) {
	    if($verboseMode) {
		if($vState ne "macro") {
		    print "$0: Reading macro definitions\n";
		    $vState = "macro";
		}
	    }
	    my $macro = new Lef::Macro($1);
	    $this->addMacro($macro);
	    if($verboseMode) {
		$macroCount++;
		if($macroCount/5 == int($macroCount/5)) {
		    print "    Read $macroCount\r";
		}
	    }
	    while(<LEFFILE>) {
		if(/^\s*END\s+(\S+)\s*$/i) {
		    if($1 eq $macro->getName()) { last; }
		    else {
		        print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
			close(LEFFILE);
			return 0;
		    }
		}
		##elsif(/^\s*CLASS\s+(\S+)\s*\;\s*$/i) {
		elsif(/^\s*CLASS\s+(\S+\s*(\S+)?)\s*\;\s*$/i) {
		    $macro->setClass(lc($1));
		}
		elsif(/^\s*SITE\s+(\S+)\s*\;\s*$/i) {
		    $macro->setSite($1);
		}
		elsif(/^\s*POWER\s+(\S+)\s*\;\s*$/i) {
		    $macro->setPower($1);
		}
		elsif(/^\s*FOREIGN\s+(\S([^\;]*\S+)?)\s*\;\s*$/i) {
                    my @foreign = split(/\s+/, $1);
                    $macro->setForeign(@foreign);
		}
		elsif(/^\s*ORIGIN\s+(\S+)\s+(\S+)\s*\;\s*$/i) {
		    $macro->setOrigin($1, $2);
		}
		elsif(/^\s*SIZE\s+(\S+)\s+BY\s+(\S+)\s*\;\s*$/i) {
		    $macro->setSize($1, $2);
		}
		elsif(/^\s*SYMMETRY\s+(\S([^\;]*\S+)?)\s*\;\s*$/i) {
		    my $symStr = $1;
		    my @symmetries = split(/\s+/, $symStr);
		    grep($_=lc($_), @symmetries);
		    $macro->setSymmetries(@symmetries);
		}
		elsif(/^\s*PIN\s+(\S+)\s*$/i) {
		    my $pin = new Lef::Pin($1);
		    $macro->addRegularPin($pin);
		    while(<LEFFILE>) {
			if(/^\s*END\s+(\S+)\s*$/) {
			    if($1 eq $pin->getName()) { last; }
			}
			elsif(/^\s*MUSTJOIN\s+(\S+)\s*\;\s*$/) {
			    $macro->removeRegularPin($pin->getName());
			    $macro->addMustJoinPin($pin);
			    $pin->setMustJoin($1);
			}
			elsif(/^\s*CAPACITANCE\s+(\S+)\s*\;\s*$/) {
			    $pin->setCapacitance($1);
			}
			elsif(/^\s*POWER\s+(\S+)\s*\;\s*$/) {
			    $pin->setPower($1);
			}
			elsif(/^\s*DIRECTION\s+(\S+)\s*\;\s*$/) {
			    $pin->setDirection(lc($1));
			}
			elsif(/^\s*USE\s+(\S+)\s*\;\s*$/) {
			    $pin->setUse(lc($1));
			}
			elsif(/^\s*SHAPE\s+(\S+)\s*\;\s*$/) {
			    $pin->setShape(lc($1));
			}
			elsif(/^\s*PORT\s*$/) {
			    my $port = new Lef::Port;
			    $pin->addPort($port);
			    my $layerName;
			    while(<LEFFILE>) {
				if(/^\s*END\s*$/) { last; }
				elsif(/^\s*LAYER\s+(\S+)\s*\;\s*$/) {
				    $layerName = $1;
				}
				elsif(/^\s*RECT\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*\;\s*$/) {
				    if(!defined($layerName)) {
                                        print "*Error* No layer defined in port within macro: ".$macro->getName()."Line: $. $lefFileName\n";
					close(LEFFILE);
					return 0;
				    }
				    my $poly = new Lef::Poly;
				    $poly->setLayerName($layerName);
				    $poly->setPoints($1, $2, $3, $4);
				    $port->addPoly($poly);
				}
				elsif(/^\s*POLYGON\s+(.*\S)\s*$/) {
                                    my $cList = $1;
                                    while($cList !~ /\;\s*$/) {
                                        $cList .= scalar(<LEFFILE>);
                                    }
                          
				    if(!defined($layerName)) {
                                        print "*Error* No layer defined in port within macro: ".$macro->getName()."Line: $. $lefFileName\n";
					close(LEFFILE);
					return 0;
				    }
                                    my @points;
                                    while($cList =~ /^\s*([^\s\;]+)\s+([^\s\;]+)/) {
                                        push(@points, $1); push(@points, $2);
                                        $cList = $';
                                    }
				    my $poly = new Lef::Poly;
				    $poly->setLayerName($layerName);
				    $poly->setPoints(@points);
				    $port->addPoly($poly);
				}
				elsif(/^\s*VIA\s+(\S+)\s+(\S+)\s*(\S+)\s*\;\s*$/) {
				  $_ =~ /^(.*)/;
                                  print "*Warning* Statement not supported: $1 Line: $. $lefFileName\n";
                                }
				else {
				    $_ =~ /^(.*)/;
		                    print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
				    close(LEFFILE);
				    return 0;
				}
			    }
			}
			elsif(!/^\s*$/ && !/\s*#/) {
			    $_ =~ /^(.*)/;
		            print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
			    close(LEFFILE);
			    return 0;
			}
		    }
		}
		elsif(/^\s*OBS\s*$/i) {
		    my $layerName;
		    while(<LEFFILE>) {
			if(/^\s*END\s*$/) { last; }
			elsif(/^\s*LAYER\s+(\S+)\s*\;\s*$/) {
			    $layerName = $1;
			}
			elsif(/^\s*RECT\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*\;\s*$/) {
			    if(!defined($layerName)) {
                                print "*Error* No layer defined in obstruction within macro: ".$macro->getName()."Line: $. $lefFileName\n";
				close(LEFFILE);
				return 0;
			    }
			    my $poly = new Lef::Poly;
			    $poly->setLayerName($layerName);
			    $poly->setPoints($1, $2, $3, $4);
			    $macro->addObs($poly);
			}
			elsif(/^\s*POLYGON\s+(.*\S)\s*$/) {
			    my $cList = $1;
			    while($cList !~ /\;\s*$/) {
				$cList .= scalar(<LEFFILE>);
			    }
			    if(!defined($layerName)) {
                                print "*Error* No layer defined in obstruction within macro: ".$macro->getName()."Line: $. $lefFileName\n";
				close(LEFFILE);
				return 0;
			    }
			    my @points;
			    while($cList =~ /^\s*([^\s\;]+)\s+([^\s\;]+)/) {
				push(@points, $1); push(@points, $2);
				$cList = $';
			    }
			    my $poly = new Lef::Poly;
			    $poly->setLayerName($layerName);
			    $poly->setPoints(@points);
			    $macro->addObs($poly);
			}
			elsif(!/^\s*$/ && !/^\s*#/) {
			    $_ =~ /^(.*)/;
		            print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
			    close(LEFFILE);
			    return 0;
			}
		    }
		}
		elsif(!/^\s*$/ && !/\s*#/) {
		    $_ =~ /^(.*)/;
		    print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
		    close(LEFFILE);
		    return 0;
		}
	    }
	}
	elsif(/^\s*END\s+LIBRARY\s*$/) {
	    while(<LEFFILE>) {
		if(!/^\s*$/ && !/\s*#/) {
		    $_ =~ /^(.*)/;
		    print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
		    close(LEFFILE);
		    return 0;
		}
	    }
	}
	elsif(!/^\s*$/ && !/^\s*\#/) {
	    $_ =~ /^(.*)/;
            print "*Error* Unrecognized statement: $1 Line: $. $lefFileName\n";
	    close(LEFFILE);
	    return 0;
	}
    }
    close(LEFFILE);

    return 1;
}

# Usage: $status = $lef->read($fileName);
sub write {
    if(@_ != 2) {
	die "$0: Bad number of arguments to write";
    }
    my $this = shift;
    my $lefFileName = shift;

    $this->setFileName($lefFileName);

    if($verboseMode) { print "$0: Writing $lefFileName ... \n"; }

    if(!open(LEFFILE, ">$lefFileName")) {
        print "*Error* Failed to open $lefFileName for write\n";
	return 0;
    }

    print LEFFILE "NAMESCASESENSITIVE ".$this->getNamesCaseSensitive()." ;\n";
    print LEFFILE "\n";
    print LEFFILE "VERSION ".$this->getVersion()." ;\n";
    print LEFFILE "\n";

    if($this->getUnitTypes() > 0) {
	if($verboseMode) { print "$0: Writing unit definitions\n"; }
	print LEFFILE "UNITS\n";
	my $type;
	foreach $type ($this->getUnitTypes()) {
	    my @unitSet = $this->getUnit($type);
	    print LEFFILE "    " . uc($type) . " " . uc($unitSet[0]) . " " .
			$unitSet[1] . " ;\n";
	}
	print LEFFILE "END UNITS\n";
	print LEFFILE "\n";
    }

    if($verboseMode && $this->getLayers()) { print "$0: Writing layer definitions\n"; }
    my $layer;
    foreach $layer ($this->getLayers()) {
	print LEFFILE "LAYER " . $layer->getName() . "\n";
	if(defined($layer->getType())) {
	    print LEFFILE "    TYPE " . uc($layer->getType()) . " ;\n";
	}
	if(defined($layer->getWidth())) {
	    print LEFFILE "    WIDTH " . $layer->getWidth() . " ;\n";
	}
	if(defined($layer->getSpacing())) {
	    print LEFFILE "    SPACING " . $layer->getSpacing() . " ;\n";
	}
	if(defined($layer->getPitch())) {
	    print LEFFILE "    PITCH " . $layer->getPitch() . " ;\n";
	}
	if(defined($layer->getDirection())) {
	    print LEFFILE "    DIRECTION " . uc($layer->getDirection()) . " ;\n";
	}
	if($layer->getCapTypes() > 0) {
	    print LEFFILE "    CAPACITANCE ";
	    my $capType;
	    foreach $capType ($layer->getCapTypes()) {
		print LEFFILE uc($capType) . " " .
				$layer->getCapacitance($capType);
	    }
	    print LEFFILE " ;\n";
	}
	if($layer->getResTypes() > 0) {
	    print LEFFILE "    RESISTANCE ";
	    my $resType;
	    foreach $resType ($layer->getResTypes()) {
		print LEFFILE uc($resType) . " " .
				$layer->getResistance($resType);
	    }
	    print LEFFILE " ;\n";
	}
	if(defined($layer->getHeight())) {
	    print LEFFILE "    HEIGHT " . $layer->getHeight() . " ;\n";
	}
	if(defined($layer->getThickness())) {
	    print LEFFILE "    THICKNESS " . $layer->getThickness() . " ;\n";
	}
	if(defined($layer->getShrinkage())) {
	    print LEFFILE "    SHRINKAGE " . $layer->getShrinkage() . " ;\n";
	}
	if(defined($layer->getCapMultiplier())) {
	    print LEFFILE "    CAPMULTIPLIER " . $layer->getCapMultiplier() .
			" ;\n";
	}
	if(defined($layer->getEdgeCapacitance())) {
	    print LEFFILE "    EDGECAPACITANCE " .
					$layer->getEdgeCapacitance() . " ;\n";
	}
	print LEFFILE "END " . $layer->getName() . "\n";
	print LEFFILE "\n";
    }

    if($verboseMode && $this->getVias()) { print "$0: Writing via definitions\n"; }
    my $via;
    foreach $via (sort _byName $this->getVias()) {
	print LEFFILE "VIA " . $via->getName() . " " .  $via->getType() . "\n";
	if(defined($via->getResistance())) {
	    print LEFFILE "    RESISTANCE " . $via->getResistance() . " ;\n";
	}
	my $layerName;
	foreach $layerName (sort $via->getLayerNames()) {
	    print LEFFILE "    LAYER $layerName ;\n";
	    my $poly;
	    foreach $poly ($via->getPolys($layerName)) {
		if(!defined($poly->getShapeType())) {
		    die "$0: Bad polygon ";
		}
		my @points = $poly->getPoints();
		if($poly->getShapeType() eq "rect") {
		    print LEFFILE "        RECT ", _simpleReal($points[0][0]),
				" ", _simpleReal($points[0][1]), " ",
				_simpleReal($points[1][0]), " ",
				_simpleReal($points[1][1])," ;\n";
		}
		else {
		    die "$0: Only shape type RECT are supported";
		}
	    }
	}
	print LEFFILE "END " . $via->getName() . "\n";
	print LEFFILE "\n";
    }

    if($verboseMode && $this->getViaRules()) { print "$0: Writing via rule definitions\n"; }
    my $viaRule;
    foreach $viaRule (sort _byName $this->getViaRules()) {
	print LEFFILE "VIARULE " . $viaRule->getName() . " " .
			$viaRule->getType() . "\n";
	my $layerName;
	foreach $layerName (sort $viaRule->getLayerNames()) {
	    if(!($viaRule->getDirections($layerName) > 0)) {
		print LEFFILE "    LAYER $layerName ;\n";
	    }
	    else {
		my $direction;
		foreach $direction ($viaRule->getDirections($layerName)) {
		    print LEFFILE "    LAYER $layerName ;\n";
		    print LEFFILE "        DIRECTION " . uc($direction) . " ;\n";
		}
	    }
	    if(defined($viaRule->getOverhang($layerName))) {
		print LEFFILE "        OVERHANG " .
			      $viaRule->getOverhang($layerName) . " ;\n";
	    }
	    if(defined($viaRule->getMetalOverhang($layerName))) {
		print LEFFILE "        METALOVERHANG " .
			      $viaRule->getMetalOverhang($layerName) . " ;\n";
	    }
	    my $poly;
	    foreach $poly ($viaRule->getPolys($layerName)) {
		if(!defined($poly->getShapeType())) {
		    die "$0: Bad polygon ";
		}
		my @points = $poly->getPoints();
		if($poly->getShapeType() eq "rect") {
		    print LEFFILE "        RECT ", _simpleReal($points[0][0]), " ",
						_simpleReal($points[0][1]), " ",
						_simpleReal($points[1][0]), " ",
					      _simpleReal($points[1][1])," ;\n";
		}
	    }
	    if(defined($viaRule->getSpacing($layerName))) {
		my @spacing = $viaRule->getSpacing($layerName);
		print LEFFILE "        SPACING " . $spacing[0] . " BY " .
						$spacing[1] . " ;\n";
	    }
	}
	print LEFFILE "END " . $viaRule->getName() . "\n";
	print LEFFILE "\n";
    }

    if($this->getFirstSNLayerNames() > 0) {
        if($verboseMode) { print "$0: Writing spacing definitions\n"; }
	print LEFFILE "SPACING\n";
	my $pairPtr;
	my @layerNames1 = sort $this->getFirstSNLayerNames();
	my $layerName1;
	foreach $layerName1 (@layerNames1) {
	    my @layerNames2 = sort $this->getSecondSNLayerNames($layerName1);
	    my $layerName2;
	    foreach $layerName2 (@layerNames2) {
		my @spInfo = $this->getSameNetSpacing($layerName1, $layerName2);
		print LEFFILE "    SAMENET $layerName1 $layerName2 $spInfo[0] ";
		if(defined($spInfo[1])) { print LEFFILE "STACK "; }
		print LEFFILE ";\n";
	    }
	}
	print LEFFILE "END SPACING\n";
	print LEFFILE "\n";
    }

    if($verboseMode && $this->getSites()) { print "$0: Writing site definitions\n"; }
    my $site;
    foreach $site (sort _byName $this->getSites()) {
	print LEFFILE "SITE " . $site->getName() . "\n";
	if(defined($site->getClass())) {
	    print LEFFILE "    CLASS " . uc($site->getClass()) . " ;\n";
	}
	if($site->getSymmetries() > 0) {
	    print LEFFILE "    SYMMETRY " .
		join(" ", grep($_=uc($_), $site->getSymmetries())) . " ;\n";
	}
	if(defined($site->getSize())) {
	    my @dim = $site->getSize();
	    print LEFFILE "    SIZE $dim[0] BY $dim[1] ;\n";
	}
	print LEFFILE "END " . $site->getName() . "\n";
	print LEFFILE "\n";
    }

    if($verboseMode && $this->getMacros()) { print "$0: Writing macro definitions\n"; }
    my $macroCount = 0;
    my $macro;
    foreach $macro (sort _byName $this->getMacros()) {
	if($verboseMode) {
	    $macroCount++;
	    if($macroCount/5 == int($macroCount/5)) {
		print "    Wrote $macroCount\r";
	    }
	}
	print LEFFILE "MACRO " . $macro->getName() . "\n";
	if(defined($macro->getClass())) {
	    print LEFFILE "    CLASS " . uc($macro->getClass()) . " ;\n";
	}
	if(defined($macro->getForeign())) {
	    print LEFFILE "    FOREIGN " . 
                join(" ", $macro->getForeign()) . " ;\n";
	}
	if(defined($macro->getPower())) {
	    print LEFFILE "    POWER " . $macro->getPower() . " ;\n";
	}
	if(defined($macro->getOrigin())) {
	    my @point = $macro->getOrigin();
	    print LEFFILE "    ORIGIN " . $point[0] . " " . $point[1] . " ;\n";
	}
	if(defined($macro->getSize())) {
	    my @point = $macro->getSize();
	    print LEFFILE "    SIZE " . $point[0] . " BY " . $point[1] . " ;\n";
	}
	if(defined($macro->getSite())) {
	    print LEFFILE "    SITE " . $macro->getSite() . " ;\n";
	}
	if($macro->getSymmetries() > 0) {
	    print LEFFILE "    SYMMETRY " .
		join(" ", grep($_=uc($_), $macro->getSymmetries())) . " ;\n";
	}
	my @pinList = ((sort _byName $macro->getRegularPins()),
		       (sort _byName $macro->getMustJoinPins()));
	my $pin;
	foreach $pin (@pinList) {
	    print LEFFILE "    PIN " . $pin->getName() . "\n";
	    if(defined($pin->getPower())) {
		print LEFFILE "        POWER " . $pin->getPower() . " ;\n";
	    }
	    if(defined($pin->getCapacitance())) {
		print LEFFILE "        CAPACITANCE " . $pin->getCapacitance() .
									" ;\n";
	    }
	    if(defined($pin->getDirection())) {
		print LEFFILE "        DIRECTION " . uc($pin->getDirection()) .
									" ;\n";
	    }
	    if(defined($pin->getUse())) {
		print LEFFILE "        USE " . $pin->getUse() . " ;\n";
	    }
	    if(defined($pin->getShape())) {
		print LEFFILE "        SHAPE " . $pin->getShape() . " ;\n";
	    }
	    if(defined($pin->getMustJoin())) {
		print LEFFILE "        MUSTJOIN " .  $pin->getMustJoin() . " ;\n";
	    }
	    if($pin->getPorts() > 0) {
		my $port;
		foreach $port ($pin->getPorts()) {
		    print LEFFILE "        PORT\n";
		    my $poly;
		    my $layerName;
		    foreach $layerName (sort $port->getLayerNames()) {
			print LEFFILE "            LAYER $layerName ;\n";
			foreach $poly ($port->getPolys($layerName)) {
			    my @points = $poly->getPoints();
			    if($poly->getShapeType() eq "rect") {
				print LEFFILE "                RECT " .
					    _simpleReal($points[0][0]) . " " .
					    _simpleReal($points[0][1]) . " " .
					    _simpleReal($points[1][0]) . " " .
					    _simpleReal($points[1][1]) . " ;\n";
			    }
                            elsif($poly->getShapeType() eq "polygon") {
                                my $cList = "";
                                my $pPtr;
                                foreach $pPtr (@points) {
                                    my @point = @{$pPtr};
                                    $cList .= _simpleReal($point[0]) . " " .
                                              _simpleReal($point[1]) . " ";
                                }
                                print LEFFILE "                POLYGON $cList;\n";

                            }
			    else {
				die "$0: Only shape type RECT and POLYGON are supported";
			    }
			}
		    }
		    print LEFFILE "        END\n";
		}
	    }
	    print LEFFILE "    END " . $pin->getName() . "\n";
	}
	if($macro->getLayerNames() > 0) {
	    print LEFFILE "    OBS\n";
	    my $poly;
	    my $layerName;
	    foreach $layerName (sort $macro->getLayerNames()) {
		print LEFFILE "        LAYER $layerName ;\n";
		foreach $poly ($macro->getObses($layerName)) {
		    @points = $poly->getPoints();
		    if($poly->getShapeType() eq "rect") {
			print LEFFILE "            RECT " .
					_simpleReal($points[0][0]) . " " .
					_simpleReal($points[0][1]) . " " .
					_simpleReal($points[1][0]) . " " .
					_simpleReal($points[1][1]) . " ;\n";
		    }
		    else {
			my $cList = "";
			my $pPtr;
			foreach $pPtr (@points) {
			    my @point = @{$pPtr};
			    $cList .= _simpleReal($point[0]) . " " .
				      _simpleReal($point[1]) . " ";
			}
			print LEFFILE "            POLYGON $cList;\n";
		    }
		}
	    }
	    print LEFFILE "    END\n";
	}
	print LEFFILE "END " . $macro->getName() . "\n";
	print LEFFILE "\n";
    }

    print LEFFILE "END LIBRARY\n";

    close(LEFFILE);
    return 1;
}

# Destructor
sub DESTROY {
    if(@_ != 1) { die "$0: Bad number of arguments to DESTROY"; }
    my $this = shift;
}


1;
