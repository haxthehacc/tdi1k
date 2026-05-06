#!/tools/perl/bin/perl
# 9/16/02 - SSG - check for existence of techfile file, not directory

#------------------------------------------------------------------------------------
# Parse the command line options
#------------------------------------------------------------------------------------
&getOptions(@ARGV);

#------------------------------------------------------------------------------------
# Check the command line options
#------------------------------------------------------------------------------------
&checkOptions();

#------------------------------------------------------------------------------------
# Create a temporary working directory:
#------------------------------------------------------------------------------------
$workDir = "lefgen_workdir";
print(STDERR "Message: creating working directory $dir ...\n");
&createDirectory($workDir);

$gdsFileName = makeAbsolute($gdsFileName);
$verilogFileName = makeAbsolute($verilogFileName);
print(STDERR $outputLefFileName);
$outputLefFileName = makeAbsolute($outputLefFileName);
printf(STDERR "later: $outputLefFileName\n");
if( $cellListFileName ne "") {
  $cellListFileName = makeAbsolute($cellListFileName);
  createCellListTable($cellListFileName);
}

chdir($workDir) || die("Could not change directory to working directory $workDir\n");


$libName = "streamed";
$streamInTemplate = "streamin.template";
$infoFile = "abstract.info";

#------------------------------------------------------------------------------------
# Stream in the GDSII file:
#------------------------------------------------------------------------------------
&writeStreamInTemplate($streamInTemplate,$gdsFileName,"",$libName,$technologyFileName);
print(STDERR "Message: streaming in file $gdsFileName ...\n");
system("pipo strmin $streamInTemplate");

# check for trouble:
if (!existsAndReadable("PIPO.LOG")) {
  die("Error during streamin of file $gdsFileName, PIPO.LOG could not be found\n");
}

#------------------------------------------------------------------------------------
# Create the abstract info file:
#------------------------------------------------------------------------------------
print(STDERR "Message: extracting pin info from $verilogFileName ...\n");
system("create_abstract_info -o $infoFile $verilogFileName");

# check for trouble:
if (!existsAndReadable("$infoFile")) {
  die("Error while creating pin info file, $infoFile could not be found\n");
}

#------------------------------------------------------------------------------------
# Create the replay file:
#------------------------------------------------------------------------------------
$replayFileName = "abgen.replay";
$lispProgram = "$rdsCdsware/layout/bin/skill/rssLayAbgen.ile $rdsCdsware/layout/bin/skill/rssLayGenPin.ile";
$logDirName = "abgen.log";
if( %cellListTable ) {
  $tmpLibName = "tmplib";
  copyCellList($libName, $tmpLibName);
  $libName = $tmpLibName;
}
writeReplayFile($replayFileName,
		$lispProgram,
		$libName,
		$libType,
		$infoFile,
		$abgenRulesFileName,
		$outputLefFileName,
		$logDirName);

#------------------------------------------------------------------------------------
# Execute virtuoso with replay script
#------------------------------------------------------------------------------------
print(STDERR "Message: creating abstracts ...\n");
$icfbCommand = "virtuoso -nograph -replay $replayFileName";
system($icfbCommand);

sub getOptions {
  
  while (<@_> && ($_ = shift) ne "") {
  option: {
      
      /^-v$/ && do {
	$verilogFileName = shift;
	last option;
      };
      
      /^-g$/ && do {
	$gdsFileName = shift;
	last option;
      };
      
      /^-p$/ && do {
	$technologyName = shift;
	last option;
      };

      /^-r$/ && do {
	$abgenRules = shift;
	last option;
      };
      
      /^-t$/ && do {
	$libraryType = shift;
	last option;
      };
      
      /^-o$/ && do {
	$outputLefFileName = shift;
	last option;
      };
      
      /^-c$/ && do {
        $cellListFileName = shift;
	last option;
      };

      print(STDERR "Unknown option $_ specified.\n");
      shift;
    }
  }
}

sub checkOptions {

  $rdsRoot = $ENV{RDS_ROOT};
  $rdsCdsware = $ENV{RDS_CDSWARE};
  if (!(-e $rdsRoot)) {
    $rdsRoot = "/rds/prod/HOTCODE";
    print(STDERR "\$RDS_ROOT is not set, set to /rds/prod/HOTCODE.\n");
  }
  if($technologyName eq "") {
    print(STDERR "Required argument -t is missing\n");
    &usage();
  }
  if($outputLefFileName eq "") {
    print(STDERR "Required argument -o is missing\n");
    &usage();
  }
  # look first in amslibs
  if($technologyName !~ m|/|) {
	  $technologyFileName = "$rdsRoot/amslibs/cds_default/cdslibs/$technologyName/techfiles/$technologyName.tf";
	}
	# Or then look in techs
	if( ! -e $technologyFileName ) {
	  $technologyFileName = "$rdsRoot/techs/$technologyName/cadence/default/$technologyName.tf";
	}
  checkReadPermission($technologyFileName);
  checkReadPermission($gdsFileName);
  checkReadPermission($verilogFileName);
  if( $cellListFileName ne "") {
    checkReadPermission($cellListFileName);
  }
  if ($libraryType eq "macro") {
    $libType = "Macro";
    $abgenRulesFileName = "$rdsRoot/techs/$technologyName/cadence/default/abgen.custom";
  } elsif ($libraryType eq "io") {
    $libType = "IO";
    $abgenRulesFileName = "$rdsRoot/techs/$technologyName/cadence/default/abgen.pad";
  } elsif ($libraryType eq "stdcell") {
    $libType = "Standard";
    $abgenRulesFileName = "$rdsRoot/techs/$technologyName/cadence/default/abgen.stdcell";
#  } elsif ($libraryType eq "ramrom") {      # yuj 02/15/01, disable ramrom
#    $libType = "Ram&Roms";
#    $abgenRulesFileName = "$rdsRoot/techs/$technologyName/cadence/default/abgen.ram";
  } else {
    print(STDERR "Unknown value $libraryType for argument -l\n");
    &usage();
  }
}
  
sub usage {
    print "\n";
    print "********************************************************\n\n";
    print "usage: genLef <arguments>                               \n\n";
    print "********************************************************\n";
    print "    -p process                           required       \n";
    print "    -v verilog file                      required       \n";
    print "    -g gds file                          required       \n";
    print "    -t library type                      required       \n";
    print "       choices :                                        \n";
    print "          macro                                         \n";
    print "          io                                            \n";
    print "          stdcell                                       \n";
#    print "          ramrom                                        \n";
    print "    -c file with a list of needed cells  optional       \n";
    print "    -o output lef file                   required       \n";
    print "\n"; 
    exit(1);
}

sub createDirectory{
  my $dir = shift;
  my $remove_cmd = "/bin/rm -rf $dir";

  if (opendir (DIR, $dir)) {
    print(STDERR "Warning: working directory $dir exists, removing ... \n");
    closedir(DIR);
    if (system($remove_cmd)) {
      die("Could not remove working directory $dir");
    }
  }     
  mkdir("$dir", 0777) || die("Could not create working directory $dir");

}

sub writeReplayFile {
  my $replayFileName = shift;
  my $lispProgram = shift;
  my $libName = shift;
  my $libType = shift;
  my $infoFileName = shift;
  my $abgenRulesFileName = shift;
  my $outputLefFileName = shift;
  my $logDirName = shift;
  
  open(REPLAY,"> $replayFileName") || die("Cannot open replay file $replayFileName");

  @lispPrograms = split(" ", $lispProgram);
  foreach $program (@lispPrograms) {
    print(REPLAY "\\i load(\"$program\")\n");
  }

  #
  # change "<>" to "[]"
  #
  print(REPLAY "\\i rdsLayChangeBusDelimitersForALib(\"$libName\" \"<>\" \"[]\")\n");
  #
  # run abgen
  #
  print(REPLAY "\\i rdsLayRunRssAbgen(\"$libName\", \"$libType\", \"$infoFileName\", \"$abgenRulesFileName\", \"$outputLefFileName\", \"\", \"$logDirName\")\n");
  print(STDERR "\\i rdsLayRunRssAbgen(\"$libName\", \"$libType\", \"$infoFileName\", \"$abgenRulesFileName\", \"$outputLefFileName\", \"\", \"$logDirName\")\n");
  print(REPLAY "\\i exit()\n");

  close(REPLAY);

}

sub writeStreamInTemplate {
  my $streamInTemplate = shift;
  my $gdsFileName = shift;
  my $topCellName = shift;
  my $libName = shift;
  my $technologyFileName = shift;
  
  open(STREAMIN,"> $streamInTemplate") || die "Cannot open stream in template file $streamInTemplate";
  
  print(STREAMIN  "streamInKeys = list(nil\n");
  print(STREAMIN  "                  'runDir                 \".\"\n");
  print(STREAMIN  "                  'inFile                 \"$gdsFileName\"\n");
  print(STREAMIN  "                  'primaryCell            \"$topCellName\"\n");
  print(STREAMIN  "                  'libName                \"$libName\"\n");
  print(STREAMIN  "                  'techfileName           \"$technologyFileName\"\n");
  print(STREAMIN  "                  'viewName               \"layout\"\n");
  print(STREAMIN  "                  'scale                  0.001000\n");
  print(STREAMIN  "                  'units                  \"micron\"\n");
  print(STREAMIN  "                  'errFile                \"PIPO.LOG\"\n");
  print(STREAMIN  "                  'refLib                 nil\n");
  print(STREAMIN  "                  'hierDepth              20\n");
  print(STREAMIN  "                  'convertToGeo           \"\"\n");
  print(STREAMIN  "                  'maxVertices            1024\n");
  print(STREAMIN  "                  'checkPolygon           nil\n");
  print(STREAMIN  "                  'snapToGrid             nil\n");
  print(STREAMIN  "                  'arrayToSimMosaic       t\n");
  print(STREAMIN  "                  'caseSensitivity        \"preserve\"\n");
  print(STREAMIN  "                  'zeroPathToLine         \"lines\"\n");
  print(STREAMIN  "                  'skipUndefinedLPP       t\n");
  print(STREAMIN  "                  'ignoreBox              nil\n");
  print(STREAMIN  "                  'reportPrecision        nil\n");
  print(STREAMIN  "                  'runQuiet               nil\n");
  print(STREAMIN  "                  'saveAtTheEnd           nil\n");
  print(STREAMIN  "                  'noWriteExistCell       nil\n");
  print(STREAMIN  "                  'NOUnmappingLayerWarning  t\n");
  print(STREAMIN  "                  'cellMapTable           \"\"\n");
  print(STREAMIN  "                  'layerTable             \"\"\n");
  print(STREAMIN  "                  'textFontTable          \"\"\n");
  print(STREAMIN  "                  'restorePin             0\n");
  print(STREAMIN  "                  'pinTextMapTable        \"\"\n");
  print(STREAMIN  "                  'propMapTable           \"\"\n");
  print(STREAMIN  "                  'propSeparator          \",\"\n");
  print(STREAMIN  "                  'userSkillFile          \"\"\n");
  print(STREAMIN  ")\n");
  
  close(STREAMIN);
  
}

sub checkReadPermission() {
  my $file = shift;

  if ( -e $file ) {
    if (!(-r $file)) {
      print(STDERR "Error: file $file exists, but is unreadable by `whoami`\n");
      exit(1);
    }
  } else {
    print(STDERR "Error: file $file does not exist\n");
    exit(1);
  }

}

sub existsAndReadable() {
  my $file = shift;
  my $returnValue = 1;

  if ( -e $file ) {
    if (!(-r $file)) {
      $returnValue = 0;
    }
  } else {
    $returnValue = 0;
  }
  return $returnValue;
}

sub makeAbsolute() {
  my $file = shift;

  if (!($file =~ /^\//)) {
    $file = "$ENV{PWD}/$file";
  }
  return $file;
}

sub createCellListTable {
  my $file = shift;
  my @words, $word;
  open(IFILE, $file) || die "Cannot open $file for reading!\n";
  while(<IFILE>) {
    chop();
    @words = split(" ", $_);
    foreach $word (@words) {
      $cellListTable{$word} = 1;
#      printf("$word\n");
    }; 
  }; 
  close(IFILE);
}

############################################################
# copyCellList
# func: copy srcLib to dstLib, and delete cells not in cellListTable
############################################################
sub copyCellList{
  my $srcLibName = shift;
  my $dstLibName = shift;

  system("/bin/cp -r $srcLibName $dstLibName");

  chdir($dstLibName);
  my @files = `ls`;
  foreach $file (@files) {
    chop($file);
    if( -d $file && -d "$file/layout" && !$cellListTable{$file} ) {
      system("/bin/rm -r $file");
    }
  }
  chdir("..");
  system("echo \"DEFINE $dstLibName $dstLibName\" >> cds.lib");
}
