#!/tools/perl/bin/perl
#
# FileName: extractDefIO
# Usage: extractDefIO -def defFileName [-t type] [-lef lefFileName] [-o ioFileName]
# Function: if type is chip, extract the IO placement information from DEF file, create
#           (1) an io pin list file for bonding, 
#           (2) a VDD location file for irdrop check
#           if type is block, extract the power pin locations from DEF file, create
#           (1) a VDD location file for irdrop check
# Author: Jie Yu 
# History: 02/26/01 -- Initial
#

package pinClass;
sub new {
  my $type = shift;
  my $self = {};
  my %params = @_;
#  printf("creating pin class\n");
  $self->{pinName} = $params{pinName};
  $self->{cellName} = $params{cellName};
  $self->{metLayer} = $params{metLayer};
  $self->{lx} = $params{lx};
  $self->{by} = $params{by};
  $self->{pinX} = $params{pinX};
  $self->{pinY} = $params{pinY};
  $self->{side} = $params{side};
  return bless $self, $type;
}

package padClass;
sub new {
  my $type = shift;
  my $self = {};
  my %params = @_;
#  printf("creating pad class\n");
  $self->{cellName} = $params{cellName};
  $self->{width} = $params{width};
  $self->{height} = $params{height};
  $self->{pinNames} = $params{pinNames};
  $self->{metLayers} = $params{metLayers};
  return bless $self, $type;
}

&getOptions(@ARGV);
if( $type eq "chip" ) {
  &parseLefFile($lefFileName);
  &parseDefFileForIOPins($defFileName);
  &writeIOFile($ioFileName);
  &writePWRFile($pwrIOFileName);
} else {
  &parseDefFileForPWRPins($defFileName);
  &writePWRFile($pwrIOFileName);
}
exit 0;

sub usage {
  print "\nUsage:\t$0 -def defFileName -t type [-lef lefFileName] [-o ioFileName]\n";
  print "Inputs: -def defFileName\t\trequired\n";
  print "        -t   type\t\toptional (choice is chip or block, default is chip)\n";
  print "        -lef lefFileName\t\trequired when type is chip\n";
  print "        -o   output IO fileName\t\toptional\n";
  exit 1;
}

sub getOptions {
  $type = "chip";
  while (<@_> && ($_ = shift) ne "") {
    options: {
      /^-def/ && do {
        $defFileName = shift;
        last options;
      };
      /^-lef/ && do {
        $lefFileName = shift;
        last options;
      };
      /^-t/ && do {
        $type = shift;
        last options;
      };
      /^-o/ && do {
        $ioFileName = shift;
        last options;
      };
      usage;
    }
  }
  if( $defFileName eq "" ) {
    usage;
  }
  if( $type ne "chip" && $type ne "block" ) {
    usage;
  }
  if( $type eq "chip" && $lefFileName eq "" ) {
    usage;
  }
  if( $type eq "chip" ) {
    if( $ioFileName eq "" ) {
      @defFilePath = split("/", $defFileName);
      $ioFileName = $defFilePath[$#$defFilePath];
      $ioFileName =~ s/\.def/.io/;
    }
    $pwrIOFileName = $ioFileName ."_pwr";
  } else {
    if( $ioFileName eq "" ) {
      @defFilePath = split("/", $defFileName);
      $ioFileName = $defFilePath[$#$defFilePath];
      $ioFileName =~ s/\.def/.io_pwr/;
    }
    $pwrIOFileName = $ioFileName; 
  }
  if( !-f $defFileName ) { 
    die "$0: $defFileName doesn't exist\n"; 
  }
  if( $lefFileName ne "" && !-f $lefFileName ) { 
    die "$0: $lefFileName doesn't exist\n"; 
  }
}

###############################################################
# parseLefFile
# Func: parse the lef file to get io pads size information
###############################################################
sub parseLefFile {
  local($lefFileName) = @_;
  open(LEFFILE, "$lefFileName") || die "$0: Cannot open $lefFileName for reading\n";
  while(<LEFFILE>) {
    chop();
    if( /(^MACRO\s+)(\S+)/ ) {
      $inMacro = 1;
      $macroName = $2;
      $pinNames = "";
      $metLayers = "";
    } elsif( $inMacro && /(^\s*SIZE\s+)(\S+)(\s+BY\s+)(\S+)/ ) {
      $padWidth = $2;
      $padHeight = $4;
    } elsif( $inMacro && /(^\s*PIN\s+)(\S+)/ ){
      $pinNames = $pinNames . " " . $2;
    } elsif( $inMacro && /(^\s*LAYER\s+)(\S+)/ ){
      $metLayers = $metLayers . " " . $2;
    } elsif( $inMacro && /(^END\s+)(\S+)/ ) {
      if( $2 ne $macroName ) {
        printf("ERROR: $macroName doesn't match\n");
        exit 1;
      }
      if( $pinNames eq "" ) {
        push( @ignoreCells, $macroName );
      } else {
        push( @padCells, $macroName );
      }
      $ioPad = padClass->new(cellName=>$macroName, width=>$padWidth, 
                             height=>$padHeight, pinNames=>$pinNames,
                             metLayers=>$metLayers);
      $ioPads{$macroName} = $ioPad; 
      $inMacro = 0;
    }
  }
  close(LEFFILE);
}

###############################################################
# parseDefFileForIOPins
# Func: parse the def file to get io pads location information
###############################################################
sub parseDefFileForIOPins { 

  local($defFileName) = @_;
  local($inComponentsSection) = 0;
  $#ioPins = -1;
  $#pwrPins = -1;

  open(DEFFILE, "$defFileName") || die "$0: Cannot open $defFileName for reading\n";
  
  while(<DEFFILE>) {
    chop();
    $line = removeSpecialCharacters($_, "-+();");
    if( $line =~ m/(^\s*UNITS\s+DISTANCE\s+MICRONS\s+)(\S+)/ ){
      $unit = $2;
    } elsif ( $line =~ m/^\s*COMPONENTS\s+/ ) {
      $inComponentsSection = 1;
    } elsif( $inComponentsSection && $line =~ m/\s+PLACED\s+/ ) {
      @words = split(" ", $line);
      $pinName = $words[0];
      $cellName = $words[1];
      if( member($cellName, @padCells) &&
          !member($cellName, @ignoreCells) ) {
        $lx = $words[3]/$unit;
        $by = $words[4]/$unit;
        $dir = uc($words[5]);
        $ioPad = $ioPads{$cellName};
        $xInc = 0.5*$ioPad->{width};
        $yInc = yInc;
        $ioHeight = $ioPad->{height};
        if( $dir eq "N" ){
          $pinX = $lx+$xInc;
          $pinY = $by+$yInc;
          $dir = 2;
        } elsif( $dir eq "S" ) {
          $pinX = $lx+$xInc;
          $pinY = $by+$ioHeight-$yInc;
          $dir = 4;
        } elsif( $dir eq "E" ) {
          $pinX = $lx+$yInc;
          $pinY = $by+$xInc;
          $dir = 1;
        } elsif( $dir eq "W" ) {
          $pinX = $lx+$ioHeight-$yInc;
          $pinY = $by+$xInc;
          $dir = 35
        }
        # get top metal layer
        $ioPad = $ioPads{$cellName};
        $metLayers = $ioPad->{metLayers};
        @words = split(" ", $metLayers);
        $metNumber = 1;
        foreach $word (@words) {
          $metNumber = max($metNumber, substr($word, length($word)-1, 1));
        }
        $metLayer = "METAL_" . $metNumber;
        $pin = pinClass->new(pinName=>uc($pinName), cellName=>$cellName,
                             metLayer=>$metLayer, lx=>$lx, by=>$by, pinX=>$pinX, pinY=>$pinY,
                             side=>$dir);
        push(@ioPins, $pin);
        if( $pinName =~ /^VDD/ ) {
          push(@pwrPins, $pin);
        }
      } elsif( $line =~ m/^\s*END\s+COMPONENTS/ ){
        last;
      }
    }
  }
  close(DEFFILE);
}

###############################################################
# parseDefFileForPWRPins
# Func: parse the def file to get VDD location information
###############################################################
sub parseDefFileForPWRPins { 

  local($defFileName) = @_;
  local($inSpecialNetsSection) = 0;
  local($pinName) = "";
  $#pwrPins = -1;

  open(DEFFILE, "$defFileName") || die "$0: Cannot open $defFileName for reading\n";
  
  while(<DEFFILE>) {
    chop();
    $line = removeSpecialCharacters($_, "-+();");
    if( $line =~ m/(^\s*UNITS\s+DISTANCE\s+MICRONS\s+)(\S+)/ ){
      $unit = $2;
    } elsif( $line =~ m/^\s*DIEAREA\s+/ ) {
      @words = split(" ", $line);
      $dieLeft = $words[1]/$unit;
      $dieBottom = $words[2]/$unit;
      $dieRight = $words[3]/$unit;
      $dieTop = $words[4]/$unit;
    } elsif( $line =~ m/^\s*SPECIALNETS\s+/ ) {
      $inSpectialNetsSection = 1; 
    } elsif( $inSpectialNetsSection && $line =~ m/(^\s*\S+\s+$)/ ){
      @words = split(" ", $line);
      $pinName = $words[0];
      $readStripe = 0;
      $#thisPins = -1;
    } elsif( $inSpectialNetsSection && 
             ($line =~ m/FIXED/ || ($line =~ m/NEW/ && $readStripe)) && 
             $line =~ m/SHAPE\s+STRIPE/) {
      $readStripe = 1;
      @words = split(" ", $line);
      $metLayer = $words[1];
      $metLayer = "METAL_" . substr($metLayer, length($metLayer)-1, 1);
      $stripeWidth = $words[2]/$unit;
      $stripeX1 = $words[5];
      $stripeY1 = $words[6];
      $stripeX2 = $words[7];
      $stripeY2 = $words[8];
      if( $stripeX2 eq "*" || $stripeX1 == $stripeX2) { #vertical
        $stripeX2 = $stripeX1;
      } else { #horizontal
        $stripeY2 = $stripeY1;
      }
      $stripeX1 = $stripeX1/$unit;
      $stripeY1 = $stripeY1/$unit;
      $stripeX2 = $stripeX2/$unit;
      $stripeY2 = $stripeY2/$unit;
      $pin = pinClass->new(pinName=>$pinName, metLayer=>$metLayer, 
                           pinX=>$stripeX1, pinY=>$stripeY1);
      push @thisPins, $pin;
      $pin = pinClass->new(pinName=>$pinName, metLayer=>$metLayer, 
                           pinX=>$stripeX1, pinY=>$stripeY2);
      push @thisPins, $pin;
    } elsif( $inSpectialNetsSection && $line =~ m/^\s*USE\s+POWER/ )  {
      push @pwrPins, @thisPins;
    } elsif( $line =~ m/^\s*END\s+SPECIALNETS/ )  {
      last; 
    }
  }
  close(DEFFILE);
}

sub writeIOFile {
  local($ioFileName) = @_;
  if( $#ioPins == -1 ) {
    print "\nWARNING: NO IO Pad is found\n";
    return;
  }
  open(IOFILE, ">$ioFileName") || die "$0: Cannot open $ioFileName for writing\n";
  
  print IOFILE "#pinNum pinName x y\n\n";
  @sortedPins = sort counterClock @ioPins;
  $pinNum = 1;
  foreach $pin (@sortedPins) {
      printf(IOFILE "PIN%s\t%s\t%4.3f\t%4.3f\n",
             $pinNum, $pin->{pinName}, $pin->{pinX}, $pin->{pinY});
      $pinNum++;
  }
  close(IOFILE);
  print "\nIO output file for bonding: $ioFileName\n";
}

sub writePWRFile {
  local($pwrFileName) = @_;
  if( $#pwrPins == -1 ) {
    print "\nWARNING: NO VDD pin is found\n";
    return;
  }
  open(PWRFILE, ">$pwrFileName") || die "$0: Cannot open $pwrFileName for writing\n";
  
  foreach $pin (@pwrPins) {
    printf(PWRFILE "%s\t%4.3f\t%4.3f\n",
           $pin->{metLayer}, $pin->{pinX}, $pin->{pinY});
  }
  close(PWRFILE);
  print "\nVDD location file for IRDROP: $pwrFileName\n";
}

sub counterClock {
  if($a->{side} == $b->{side}) {
    if( $a->{side} == 1 ) {
      $b->{pinY} <=> $a->{pinY} ;
    } elsif( $a->{side} == 2 ){
      $a->{pinX} <=> $b->{pinX} ;
    } elsif( $a->{side} == 3 ){
      $a->{pinY} <=> $b->{pinY} ;
    } else {
      $b->{pinx} <=> $a->{pinX} ;
    }
  } else {
    $a->{side} <=> $b->{side};
  }
}

sub member {
  local($inputValue, @inputArray) = @_;
  foreach $value (@inputArray) {
    if( $inputValue eq $value ){
      return(1);
    }
  }
  return(0);
}

sub max {
  local($a, $b) = @_;
  if( $a >= $b ) {
    return($a);
  } else {
    return($b);
  }
}

sub min {
  local($a, $b) = @_;
  if( $a <= $b ) {
    return($a);
  } else {
    return($b);
  }
}

sub removeSpecialCharacters{
  local($inputString, $characters) = @_;
  for($i=0; $i<length($characters); $i++){
    $char = substr($characters, $i, 1);
    $char = "\\" . $char;
    $inputString =~ s/$char//g;
  }
  return($inputString);
}
