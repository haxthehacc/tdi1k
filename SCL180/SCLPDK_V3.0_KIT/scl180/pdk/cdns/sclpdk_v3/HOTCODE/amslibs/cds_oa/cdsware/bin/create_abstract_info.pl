#
# create_abstract_info - reads any number of verilog files passed on
# the command line and parses out the cell and pin information
# needed by "rssAbgen.il" to generate abstracts for silicon ensemble.
#
# 05/21/1998 - Steve Majors/Ed Mahr
#

#
# Set defaults for the command line arguments.
#
$infoFile = "abstract.info";

sub Usage {
    die "\nUsage: $0 {options} verilogFiles ...\n
    Options:
      -o infoFile ($infoFile is the default)
\n";
}

#
# Parse the command line.
#
if ($#ARGV == -1) {Usage;}
while ($ARGV[0] =~ m/^-/) {
    if ($ARGV[0] eq "-o") {$infoFile = $ARGV[1]; shift @ARGV;}
    elsif ($ARGV[0] =~ m/^-/)  {Usage();}
    shift @ARGV;
}

#
# Open the pin info files for rssAbgen.
#
open(PIN, ">$infoFile") || die "$0: Can't open file $infoFile\n";

# Read the verilog files sequentially.
#
while (<>) {

    # Blank out characters after the comment character
    substr($_, index($_, "\/\/")) = ""; 

    if (/^\s*module\s+\S+\s*\(/ .. /^\s*endmodule\s*$/) {
	if (/^\s*module\s+(\S+)\s*\(/) {
            if ($1 ne $cellName) {
	        $cellName = $1;
	        @parameters = ();
	        ###print PIN "$cellName VDD inputOutput power\n";
	        ###print PIN "$cellName VSS inputOutput ground\n";
            }
	}

	#
	# Evaluate parameters that may be used for bus sizes.
	#
	elsif (/^\s*parameter\s+(\S.*)$/) {
	    $parameterList = $1;
	    while ($parameterList !~ /\s*\;\s*$/) {
		$_ = <>;
		$parameterList .= $_;
	    }
	    @parameters = split(/\s*[,|;]\s*/, $parameterList);
	    foreach $param (@parameters) {
		eval '$' . $param;
	    }
	}

	#
	# Assume bus pins are one per line.
	#
	elsif (/^\s*(input|output|inout)\s+\[\s*(\S+)\s*:\s*(\S+)\s*\]\s+(\S+)\s*\;\s*$/) {
	    $pinDir = $1;
	    if ($pinDir eq "inout") {$pinDir = "inputOutput";}
	    $str1 = $2;
	    $str2 = $3;
	    $pinName = $4;

	    #
	    # If bus sizes are not integer values, try to calculate the
	    # size from the evaluated parameters.
	    #
	    if ($str1 =~ /^[0-9]+$/) {
		$index1 = $str1;
	    }
	    else {
		$index1 = eval '$' . $str1;
	    }
	    if ($str2 =~ /^[0-9]+$/) {
		$index2 = $str2;
	    }
	    else {
		$index2 = eval '$' . $str2;
	    }

	    #
	    # Print the pin information in scalar form.
	    #
	    $lsb = $index1 < $index2 ? $index1 : $index2;
	    $msb = $index1 > $index2 ? $index1 : $index2;
	    for ($i = $lsb; $i <= $msb; $i++) {
		print PIN "$cellName $pinName\[$i\] $pinDir signal\n";
	    }
	}

	#
	# Allow scalar pins to span multiple lines.
	#
	elsif (/^\s*(input|output|inout)\s+(\S.*)$/) {
	    $pinDir = $1;
	    if ($pinDir eq "inout") {$pinDir = "inputOutput";}
	    $pinList = $2;
	    while ($pinList !~ /\s*\;\s*$/) {
		$_ = <>;
		$pinList .= $_;
	    }

	    @pinNames = split(/\s*[,|;]\s*/, $pinList);
	    foreach $pinName (@pinNames) {
		print PIN "$cellName $pinName $pinDir signal\n";
	    }
	}
    }
}

close(PIN);
