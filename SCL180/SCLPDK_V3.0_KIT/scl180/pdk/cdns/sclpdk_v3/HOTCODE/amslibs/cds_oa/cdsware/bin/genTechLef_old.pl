#!/tools/bin/perl5
#-------------------------------------------
# FileName: genTechLef.pl
# Usage: genTechLeft <infoFile>
# Functions: based on infoFile, the program will generate
#            tech.lef, tech_doublevia.lef, se.ini, tech.dpux
# Author:    Jie Yu
# History:   Initial -- 01/24/01
#-------------------------------------------

if( $#ARGV < 0 ) {
  print "\n\t Usage: genTechLef <infoFileName>\n";
  print "\n\t A sample infoFile can copied from \$RDS_CDSWARE/template/genTechLef_info.txt\n\n";
  exit 1;
}

&readInputFile($ARGV[0]);	# read input information file
&genTechLef();			# generate tech.lef
&genTechLefDoubleVia();		# generate tech_doublevia.lef
&genSeIni();			# generate se.ini
&genDpux();			# generate tech.dpux

sub readInputFile {
  $inputFileName = shift;
  open(ifile, $inputFileName) || die "Cannot open $inputFileName for reading!\n";
  while(<ifile>) {
    chop();
    @words = split " ", $_;
    $paramName = $words[0];
    $paramValue = $words[1];
    if( $paramName =~ m/^processName$/ ) {
      $processName = $paramValue;
    } elsif( $paramName =~ m/^numOfMetLayers$/ ) {
      $numOfMetLayers = $paramValue;
    } elsif( $paramName =~ m/^resolution$/ ) {
      $resolution = $paramValue;
    } elsif( $paramName =~ m/^polyWidth$/ ) {
      $polyWidth= $paramValue;
    } elsif( $paramName =~ m/^polySpacing$/ ) {
      $polySpacing= $paramValue;
    } elsif( $paramName =~ m/^contWidth$/ ) {
      $contWidth= $paramValue;
    } elsif( $paramName =~ m/^contSpacing$/ ) {
      $contSpacing= $paramValue;
    } elsif( $paramName =~ m/^contArraySpacing$/ ) {
      $contArraySpacing= $paramValue;
    } elsif( $paramName =~ m/^polyEncCont$/ ) {
      $polyEncCont= $paramValue;
    } elsif( $paramName =~ m/^polyEndEncCont$/ ) {
      $polyEndEncCont= $paramValue;
    } elsif( $paramName =~ m/^met1Width$/ ) {
      $met1Width= $paramValue;
    } elsif( $paramName =~ m/^met1Spacing$/ ) {
      $met1Spacing= $paramValue;
    } elsif( $paramName =~ m/^met1WideSpacing$/ ) {
      $met1WideSpacing= $paramValue;
    } elsif( $paramName =~ m/^met1EncCont$/ ) {
      $met1EncCont= $paramValue;
    } elsif( $paramName =~ m/^met1EndEncCont$/ ) {
      $met1EndEncCont= $paramValue;
    } elsif( $paramName =~ m/^viaxWidth$/ ) {
      $viaxWidth= $paramValue;
    } elsif( $paramName =~ m/^viaxSpacing$/ ) {
      $viaxSpacing= $paramValue;
    } elsif( $paramName =~ m/^viaxArraySpacing$/ ) {
      $viaxArraySpacing= $paramValue;
    } elsif( $paramName =~ m/^metxWidth$/ ) {
      $metxWidth= $paramValue;
    } elsif( $paramName =~ m/^metxSpacing$/ ) {
      $metxSpacing= $paramValue;
    } elsif( $paramName =~ m/^metxWideSpacing$/ ) {
      $metxWideSpacing= $paramValue;
    } elsif( $paramName =~ m/^metxEncViax$/ ) {
      $metxEncViax= $paramValue;
    } elsif( $paramName =~ m/^metxEndEncViax$/ ) {
      $metxEndEncViax= $paramValue;
    } elsif( $paramName =~ m/^topViaWidth$/ ) {
      $topViaWidth= $paramValue;
    } elsif( $paramName =~ m/^topViaSpacing$/ ) {
      $topViaSpacing= $paramValue;
    } elsif( $paramName =~ m/^topViaArraySpacing$/ ) {
      $topViaArraySpacing= $paramValue;
    } elsif( $paramName =~ m/^topMetWidth$/ ) {
      $topMetWidth= $paramValue;
    } elsif( $paramName =~ m/^topMetSpacing$/ ) {
      $topMetSpacing= $paramValue;
    } elsif( $paramName =~ m/^topMetWideSpacing$/ ) {
      $topMetWideSpacing= $paramValue;
    } elsif( $paramName =~ m/^topMetEncVia$/ ) {
      $topMetEncVia= $paramValue;
    } elsif( $paramName =~ m/^contResistance$/ ) {
      $contResistance= $paramValue;
    } elsif( $paramName =~ m/(^via)(\d)(Resistance$)/ ) {
      $viaResistance[$2]= $paramValue;
    } elsif( $paramName =~ m/(^met)(\d)(Resistance$)/ ) {
      $metResistance[$2]= $paramValue;
    } elsif( $paramName =~ m/(^met)(\d)(AreaCap$)/ ) {
      $metAreaCap[$2]= $paramValue;
    } elsif( $paramName =~ m/(^met)(\d)(EdgeCap$)/ ) {
      $metEdgeCap[$2]= $paramValue;
    } elsif( $paramName =~ m/(^stdCellHeight$)/ ) {
      $stdCellHeight= $paramValue;
    }
  }
  close(ifile);
  if( $numOfMetLayers < 4 || $numOfMetLayers > 6 ){
    printf("\n\tCurrently only allows 4-6 metal process.\n\n");
    exit(1);
  }
  $routingPitchX = &max($metxWidth, $metxEndEncViax*2.0+$viaxWidth) + $metxSpacing;
  $routingPitchY = &max($metxWidth, $metxEncViax*2.0+$viaxWidth) + $metxSpacing;
  $topRoutingPitch = &max($topMetWidth, $topMetEncVia*2.0+$topViaWidth) + $topMetSpacing;
}

###
### generate tech.lef
###
sub genTechLef{
  $techLefFileName = "tech.lef";
  if( -l $techLefFileName) {
    printf("\n\t$techLefFileName is a symbolic link, cannot be overwritten.\n");
    return;
  }
  open(ofile, ">$techLefFileName") || die "Cannot open $techLefFileName for writing!\n";

  ###
  ### HEADER
  ###
  &genTechLefHeader();
  
  ###
  ### LAYER
  ###
  &genTechLefSimpleLayer("poly", "MASTERSLICE");
  &genTechLefSimpleLayer("contact", "CUT");
  &genTechLefRoutingLayer("metal1", "ROUTING", $met1Width, $met1Spacing, 
     $met1WideSpacing, $routingPitchY, "HORIZONTAL", 
     $metAreaCap[1], $metEdgeCap[1], $metResistance[1]);

  for($i=2; $i<$numOfMetLayers; $i++) {

    $viaLayer = "via" . ($i-1);
    &genTechLefSimpleLayer($viaLayer, "CUT");

    $metLayer = "metal" . $i;
    if( $i%2 == 0 ){
      $routingPitch = $routingPitchX;
      $direction = "VERTICAL";
    } else {
      $routingPitch = $routingPitchY;
      $direction = "HORIZONTAL";
    }
    &genTechLefRoutingLayer($metLayer, "ROUTING", $metxWidth, $metxSpacing,
       $metxWideSpacing, $routingPitch, $direction,
       $metAreaCap[$i], $metEdgeCap[$i], $metResistance[$i]);
  }
  $viaLayer = "via" . ($numOfMetLayers-1);
  &genTechLefSimpleLayer($viaLayer, "CUT");
  $metLayer = "metal" . $numOfMetLayers;
  if( $numOfMetLayers%2 == 0 ){
    $direction = "VERTICAL";
  } else {
    $direction = "HORIZONTAL";
  }
  &genTechLefRoutingLayer($metLayer, "ROUTING", $topMetWidth, $topMetSpacing,
     $topMetWideSpacing, $topRoutingPitch, $direction,
     $metAreaCap[$numOfMetLayers], $metEdgeCap[$numOfMetLayers], 
     $metResistance[$numOfMetLayers]);

  ###
  ### VIA DEFAULT
  ###
  for( $i=$numOfMetLayers; $i>1; $i=$i-1) {
    $lowerMetLayer = "metal" . ($i-1);
    $upperMetLayer = "metal" . $i;
    $viaLayer = "via" . ($i-1);
    if( $i == $numOfMetLayers ) {
      $viaWidth = $topViaWidth;
      $viaSpacing = $topViaSpacing;
      $upperHEncVia = $topMetEncVia;
      $upperVEncVia = $topMetEncVia;
    } else {
      $viaWidth = $viaxWidth;
      $viaSpacing = $viaxSpacing;
      $upperHEncVia = $metxEndEncViax;
      $upperVEncVia = $metxEncViax;
    }
    $lowerHEncVia = $metxEndEncViax;
    $lowerVEncVia = $metxEncViax;
    $viaRes = $viaResistance[$i-1]; 
    $viaName = "M" . ($i-1) . "_M" . $i;
    &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                          $viaWidth, $viaSpacing, $upperHEncVia, $upperVEncVia,
                          $lowerHEncVia, $lowerVEncVia, $viaRes, 1);
    $viaName = "M" . ($i-1) . "R90_M" . $i;
    &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                          $viaWidth, $viaSpacing, $upperHEncVia, $upperVEncVia,
                          $lowerVEncVia, $lowerHEncVia, $viaRes, 1);
    $viaName = "M" . ($i-1) . "_M" . $i . "R90";
    &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                          $viaWidth, $viaSpacing, $upperVEncVia, $upperHEncVia,
                          $lowerHEncVia, $lowerVEncVia, $viaRes, 1);
    $viaName = "M" . ($i-1) . "R90_M" . $i . "R90";
    &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                          $viaWidth, $viaSpacing, $upperVEncVia, $upperHEncVia,
                          $lowerVEncVia, $lowerHEncVia, $viaRes, 1);
  }
  $viaName = "M1_POLY";
  $lowerMetLayer = "poly";
  $upperMetLayer = "metal1";
  $viaLayer = "contact";
  $viaWidth = $contWidth;
  $viaSpacing = $contSpacing;
  $upperHEncVia = $met1EndEncCont;
  $upperVEncVia = $met1EncCont;
  $lowerHEncVia = $polyEndEncCont;
  $lowerVEncVia = $polyEncCont;
  $viaRes = $contResistance;
  &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                        $viaWidth, $viaSpacing, $upperHEncVia, $upperVEncVia,
                        $lowerHEncVia, $lowerVEncVia, $viaRes, 1);

  ###
  ### VIARULE M1_M2_AR GENERATE
  ###
  for($i = $numOfMetLayers; $i > 1; $i-- ) {
    $viaName = "M" . ($i-1) . "_M" . $i . "_AR";
    $lowerMetLayer = "metal" . ($i-1);
    $upperMetLayer = "metal" . $i;
    $viaLayer = "via" . ($i-1);
    if( $i == $numOfMetLayers ) {
      $viaWidth = $topViaWidth;
      $viaSpacing = $topViaSpacing;
      $lowerOverhang = $topMetEncVia;
      $upperOverhang = $topMetEncVia;
    } else {
      $viaWidth = $viaxWidth;
      $viaSpacing = $viaxArraySpacing;
      $lowerOverhang = $metxEndEncViax;
      $upperOverhang = $metxEndEncViax;
    }
    if( $i%2 == 0 ){
      $upperDirection = "VERTICAL";
      $lowerDirection = "HORIZONTAL";
    } else {
      $upperDirection = "HORIZONTAL";
      $lowerDirection = "VERTICAL";
    }
    &genTechLefViaRule($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                       $viaWidth, $viaSpacing, $upperDirection, 
                       $lowerDirection, $upperOverhang, $lowerOverhang);
  }

  ###
  ### VIARULE TURNM GENERATE
  ###
  for( $i=1; $i<=$numOfMetLayers; $i++ ) {
    $viaName = "TURNM" . $i;
    $layerName = "metal" . $i;
    &genTechLefMetTurn($viaName, $layerName);
  }

  ###
  ### SPACING
  ###
  printf(ofile "SPACING\n");
  &genTechLefSameNet("contact", "contact", $contSpacing);
  for( $i=1; $i<$numOfMetLayers-1; $i++ ) {
    $viaLayer = "via" . $i;
    &genTechLefSameNet($viaLayer, $viaLayer, $viaxSpacing);
  }
  $viaLayer = "via" . ($numOfMetLayers-1);
  &genTechLefSameNet($viaLayer, $viaLayer, $topViaSpacing);
  &genTechLefSameNet("contact", "via1", 0.00);
  for( $i=1; $i<$numOfMetLayers-1; $i++ ) {
    $layer1 = "via" . $i;
    $layer2 = "via" . ($i+1);
    &genTechLefSameNet($layer1, $layer2, 0.00);
  }
  &genTechLefSameNet("metal1", "metal1", $met1Spacing);
  for( $i=2; $i<$numOfMetLayers; $i++ ) {
    $layer = "metal" . $i;
    &genTechLefSameNet($layer, $layer, $metxSpacing);
  }
  $layer = "metal" . $numOfMetLayers;
  &genTechLefSameNet($layer, $layer, $topMetSpacing);
  printf(ofile "END SPACING\n");
  printf(ofile "\n");

  ###
  ### SITE
  ###
  &genTechLefSite();

  ###
  ### END LIBRARY
  ###
  printf(ofile "END LIBRARY\n");
  close(ofile);

  printf("\n\t$techLefFileName is generated.\n");
}

###
### generate tech_double.lef
###
sub genTechLefDoubleVia{
  $techLefFileName = "tech_doublevia.lef";
  if( -l $techLefFileName) {
    printf("\n\t$techLefFileName is a symbolic link, cannot be overwritten.\n");
    return;
  }
  open(ofile, ">$techLefFileName") || die "Cannot open $techLefFileName for writing!\n";
  ###
  ### HEADER
  ###
  &genTechLefHeader();
  
  ###
  ### LAYER
  ###
  &genTechLefSimpleLayer("poly", "MASTERSLICE");
  &genTechLefSimpleLayer("contact", "CUT");
  &genTechLefRoutingLayer("metal1", "ROUTING", $met1Width, $met1Spacing, 
     $met1WideSpacing, $routingPitchY, "HORIZONTAL", 
     $metAreaCap[1], $metEdgeCap[1], $metResistance[1]);

  for($i=2; $i<$numOfMetLayers; $i++) {

    $viaLayer = "via" . ($i-1);
    &genTechLefSimpleLayer($viaLayer, "CUT");

    $metLayer = "metal" . $i;
    if( $i%2 == 0 ){
      $routingPitch = $routingPitchX;
      $direction = "VERTICAL";
    } else {
      $routingPitch = $routingPitchY;
      $direction = "HORIZONTAL";
    }
    &genTechLefRoutingLayer($metLayer, "ROUTING", $metxWidth, $metxSpacing,
       $metxWideSpacing, $routingPitch, $direction,
       $metAreaCap[$i], $metEdgeCap[$i], $metResistance[$i]);
  }
  $viaLayer = "via" . ($numOfMetLayers-1);
  &genTechLefSimpleLayer($viaLayer, "CUT");
  $metLayer = "metal" . $numOfMetLayers;
  if( $numOfMetLayers%2 == 0 ){
    $direction = "VERTICAL";
  } else {
    $direction = "HORIZONTAL";
  }
  &genTechLefRoutingLayer($metLayer, "ROUTING", $topMetWidth, $topMetSpacing,
     $topMetWideSpacing, $topRoutingPitch, $direction,
     $metAreaCap[$numOfMetLayers], $metEdgeCap[$numOfMetLayers], 
     $metResistance[$numOfMetLayers]);

  ###
  ### VIA DEFAULT
  ###
  for( $i=$numOfMetLayers; $i>1; $i--) {
    $lowerMetLayer = "metal" . ($i-1);
    $upperMetLayer = "metal" . $i;
    $viaLayer = "via" . ($i-1);
    if( $i == $numOfMetLayers ) {
      $viaWidth = $topViaWidth;
      $viaSpacing = $topViaSpacing;
      $upperHEncVia = $topMetEncVia;
      $upperVEncVia = $topMetEncVia;
    } else {
      $viaWidth = $viaxWidth;
      $viaSpacing = $viaxSpacing;
      $upperHEncVia = $metxEndEncViax;
      $upperVEncVia = $metxEncViax;
    }
    $lowerHEncVia = $metxEndEncViax;
    $lowerVEncVia = $metxEncViax;
    $viaRes = $viaResistance[$i-1]; 
    if( $i != $numOfMetLayers ) {
      $viaName = "M" . ($i-1) . "_M" . $i;
      &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                            $viaWidth, $viaSpacing, $upperHEncVia, $upperVEncVia,
                            $lowerHEncVia, $lowerVEncVia, $viaRes, 1);
    }
    if( $i != $numOfMetLayers && $i%2 == 0 ) {
      $viaName = "M" . ($i-1) . "R90_M" . $i;
      &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                            $viaWidth, $viaSpacing, $upperHEncVia, $upperVEncVia,
                            $lowerVEncVia, $lowerHEncVia, $viaRes, 1);
    } 
    if ( $i != $numOfMetLayers && $i%2 != 0) {
      $viaName = "M" . ($i-1) . "_M" . $i . "R90";
      &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                            $viaWidth, $viaSpacing, $upperVEncVia, $upperHEncVia,
                            $lowerHEncVia, $lowerVEncVia, $viaRes, 1);
    }
    if( $i == $numOfMetLayers || $i%2 != 0){
      $viaName = "M" . ($i-1) . "_M" . $i . "_DOUBLE_EAST";
      &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                            $viaWidth, $viaSpacing, $upperHEncVia, $upperVEncVia,
                            $lowerHEncVia, $lowerVEncVia, $viaRes, 1, 2, "EAST");
      $viaName = "M" . ($i-1) . "_M" . $i . "_DOUBLE_WEST";
      &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                            $viaWidth, $viaSpacing, $upperHEncVia, $upperVEncVia,
                            $lowerHEncVia, $lowerVEncVia, $viaRes, 1, 2, "WEST");
    }
    if( $i == $numOfMetLayers || $i%2 == 0 ) { 
      $viaName = "M" . ($i-1) . "_M" . $i . "_DOUBLE_NORTH";
      &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                            $viaWidth, $viaSpacing, $upperVEncVia, $upperHEncVia,
                            $lowerVEncVia, $lowerHEncVia, $viaRes, 2, 1, "NORTH");
      $viaName = "M" . ($i-1) . "_M" . $i . "_DOUBLE_SOUTH";
      &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                            $viaWidth, $viaSpacing, $upperVEncVia, $upperHEncVia,
                            $lowerVEncVia, $lowerHEncVia, $viaRes, 2, 1, "SOUTH");
    }
  }
  $viaName = "M1_POLY";
  $lowerMetLayer = "poly";
  $upperMetLayer = "metal1";
  $viaLayer = "contact";
  $viaWidth = $contWidth;
  $viaSpacing = $contSpacing;
  $upperHEncVia = $met1EndEncCont;
  $upperVEncVia = $met1EncCont;
  $lowerHEncVia = $polyEndEncCont;
  $lowerVEncVia = $polyEncCont;
  $viaRes = $contResistance;
  &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                        $viaWidth, $viaSpacing, $upperHEncVia, $upperVEncVia,
                        $lowerHEncVia, $lowerVEncVia, $viaRes, 1);

  ###
  ### VIARULE M1_M2_AR GENERATE
  ###
  for($i = $numOfMetLayers; $i > 1; $i-- ) {
    $viaName = "M" . ($i-1) . "_M" . $i . "_AR";
    $lowerMetLayer = "metal" . ($i-1);
    $upperMetLayer = "metal" . $i;
    $viaLayer = "via" . ($i-1);
    if( $i == $numOfMetLayers ) {
      $viaWidth = $topViaWidth;
      $viaSpacing = $topViaSpacing;
      $lowerOverhang = $topMetEncVia;
      $upperOverhang = $topMetEncVia;
    } else {
      $viaWidth = $viaxWidth;
      $viaSpacing = $viaxArraySpacing;
      $lowerOverhang = $metxEndEncViax;
      $upperOverhang = $metxEndEncViax;
    }
    if( $i%2 == 0 ){
      $upperDirection = "VERTICAL";
      $lowerDirection = "HORIZONTAL";
    } else {
      $upperDirection = "HORIZONTAL";
      $lowerDirection = "VERTICAL";
    }
    &genTechLefViaRule($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                       $viaWidth, $viaSpacing, $upperDirection, 
                       $lowerDirection, $upperOverhang, $lowerOverhang);
  }

  ###
  ### VIARULE TURNM GENERATE
  ###
  for( $i=1; $i<=$numOfMetLayers; $i++ ) {
    $viaName = "TURNM" . $i;
    $layerName = "metal" . $i;
    &genTechLefMetTurn($viaName, $layerName);
  }

  ###
  ### SPACING
  ###
  printf(ofile "SPACING\n");
  &genTechLefSameNet("contact", "contact", $contSpacing);
  for( $i=1; $i<$numOfMetLayers-1; $i++ ) {
    $viaLayer = "via" . $i;
    &genTechLefSameNet($viaLayer, $viaLayer, $viaxSpacing);
  }
  $viaLayer = "via" . ($numOfMetLayers-1);
  &genTechLefSameNet($viaLayer, $viaLayer, $topViaSpacing);
  &genTechLefSameNet("contact", "via1", 0.00);
  for( $i=1; $i<$numOfMetLayers-1; $i++ ) {
    $layer1 = "via" . $i;
    $layer2 = "via" . ($i+1);
    &genTechLefSameNet($layer1, $layer2, 0.00);
  }
  &genTechLefSameNet("metal1", "metal1", $met1Spacing);
  for( $i=2; $i<$numOfMetLayers; $i++ ) {
    $layer = "metal" . $i;
    &genTechLefSameNet($layer, $layer, $metxSpacing);
  }
  $layer = "metal" . $numOfMetLayers;
  &genTechLefSameNet($layer, $layer, $topMetSpacing);
  printf(ofile "END SPACING\n");
  printf(ofile "\n");

  ###
  ### SITE
  ###
  &genTechLefSite();

  ###
  ### END LIBRARY
  ###
  printf(ofile "END LIBRARY\n");
  close(ofile);
  printf("\n\t$techLefFileName is generated.\n");
}

###
### generate se.ini
###
sub genSeIni{
  $seIniFileName = "se.ini";
  if( -l $seIniFileName) {
    printf("\n\t$seIniFileName is a symbolic link, cannot be overwritten.\n");
    return;
  }
  $cdsware = $ENV{RDS_CDSWARE};
  $seTemplateFileName = $cdsware . "/template/se.ini.m" . $numOfMetLayers;
  if( !-f $seTemplateFileName ) {
    printf("Cannot find template file $seTemplateFileName for $seIniFileName.");
    printf("$seIniFileName is NOT generated.\n\n");
    return;
  }
  $routingPitchX1000 = $routingPitchX*1000;
  $routingPitchY1000 = $routingPitchY*1000;
  $tempSwitchFileName = "switch";
  open(ofile, ">$tempSwitchFileName") || die "Cannot open $tempSwitchFileName for writing";
  printf(ofile "s/<ROUTINGPITCHX>/$routingPitchX1000/\n");
  printf(ofile "s/<ROUTINGPITCHY>/$routingPitchY1000/\n");
  close(ofile);
  system("/bin/chmod a+x $tempSwitchFileName");
  system("/bin/sed -f $tempSwitchFileName $seTemplateFileName > $seIniFileName");
  system("/bin/rm $tempSwitchFileName");
  printf("\n\t$seIniFileName is generated.\n");
}

###
### generate tech.dpux
###
sub genDpux{
  $dpuxFileName = "tech.dpux";
  if( -l $dpuxFileName) {
    printf("\n\t$dpuxFileName is a symbolic link, cannot be overwritten.\n");
    return;
  }
  $cdsware = $ENV{RDS_CDSWARE};
  $dpuxTemplateFileName = $cdsware . "/template/tech.dpux.m" . $numOfMetLayers;
  if( !-f $dpuxTemplateFileName ) {
    printf("Cannot find template file $dpuxTemplateFileName for $dpuxFileName.");
    printf("$dpuxFileName is NOT generated.\n\n");
    return;
  }
  $tempSwitchFileName = "switch";

  $halfRoutingPitchX = $routingPitchX/2.0;
  $halfRoutingPitchY = $routingPitchY/2.0;
  $halfTopRoutingPitch = $topRoutingPitch/2.0;
  $contPitch = $contWidth + $contSpacing;
  $viaxPitch = $viaxWidth + $viaxSpacing;
  $viaxArrayPitch = $viaxWidth + $viaxArraySpacing;
  $topViaPitch = $topViaWidth + $topViaSpacing;
  $halfContWidth = $contWidth/2.0;
  $halfViaxWidth = $viaxWidth/2.0;
  $halfTopViaWidth = $topViaWidth/2.0;
  $contPolyX = $halfContWidth + $polyEndEncCont;
  $contPolyY = $halfContWidth + $polyEncCont;
  $contMetX = $halfContWidth + $met1EndEncCont;
  $contMetY = $halfContWidth + $met1EncCont;
  $viaxMetX = $halfViaxWidth + $metxEndEncViax;
  $viaxMetY = $halfViaxWidth + $metxEncViax;
  $topViaMetX = $halfTopViaWidth + $topMetEncVia;
  $topViaMetY = $halfTopViaWidth + $topMetEncVia;

  open(ofile, ">$tempSwitchFileName") || die "Cannot open $tempSwitchFileName for writing";
  printf(ofile "s/<PROCESSNAME>/$processName/g\n");
  printf(ofile "s/<RESOLUTION>/$resolution/g\n");
  printf(ofile "s/<ROUTINGPITCHX>/$routingPitchX/g\n");
  printf(ofile "s/<ROUTINGPITCHY>/$routingPitchY/g\n");
  printf(ofile "s/<TOPROUTINGPITCH>/$topRoutingPitch/g\n");
  printf(ofile "s/<HALFROUTINGPITCHX>/$halfRoutingPitchX/g\n");
  printf(ofile "s/<HALFROUTINGPITCHY>/$halfRoutingPitchY/g\n");
  printf(ofile "s/<HALFTOPROUTINGPITCH>/$halfTopRoutingPitch/g\n");
  printf(ofile "s/<POLYWIDTH>/$polyWidth/g\n");
  printf(ofile "s/<POLYSPACING>/$polySpacing/g\n");
  printf(ofile "s/<CONTWIDTH>/$contWidth/g\n");
  printf(ofile "s/<CONTSPACING>/$contSpacing/g\n");
  printf(ofile "s/<CONTPITCH>/$contPitch/g\n");
  printf(ofile "s/<MET1WIDTH>/$met1Width/g\n");
  printf(ofile "s/<MET1SPACING>/$met1Spacing/g\n");
  printf(ofile "s/<MET1WIDESPACING>/$met1WideSpacing/g\n");
  printf(ofile "s/<VIAXWIDTH>/$viaxWidth/g\n");
  printf(ofile "s/<VIAXSPACING>/$viaxSpacing/g\n");
  printf(ofile "s/<VIAXPITCH>/$viaxPitch/g\n");
  printf(ofile "s/<VIAXARRAYPITCH>/$viaxArrayPitch/g\n");
  printf(ofile "s/<METXWIDTH>/$metxWidth/g\n");
  printf(ofile "s/<METXSPACING>/$metxSpacing/g\n");
  printf(ofile "s/<METXWIDESPACING>/$metxWideSpacing/g\n");
  printf(ofile "s/<TOPVIAWIDTH>/$topViaWidth/g\n");
  printf(ofile "s/<TOPVIASPACING>/$topViaSpacing/g\n");
  printf(ofile "s/<TOPVIAPITCH>/$topViaPitch/g\n");
  printf(ofile "s/<TOPMETWIDTH>/$topMetWidth/g\n");
  printf(ofile "s/<TOPMETSPACING>/$topMetSpacing/g\n");
  printf(ofile "s/<TOPMETWIDESPACING>/$topMetWideSpacing/g\n");
  printf(ofile "s/<HALFCONTWIDTH>/$halfContWidth/g\n");
  printf(ofile "s/<HALFVIAXWIDTH>/$halfViaxWidth/g\n");
  printf(ofile "s/<HALFTOPVIAWIDTH>/$halfTopViaWidth/g\n");
  printf(ofile "s/<TOPMETENCVIA>/$topMetEncVia/g\n");
  printf(ofile "s/<METXENDENCVIAX>/$metxEndEncViax/g\n");
  printf(ofile "s/<VIAXMETX>/$viaxMetX/g\n");
  printf(ofile "s/<VIAXMETY>/$viaxMetY/g\n");
  printf(ofile "s/<TOPVIAMETX>/$topViaMetX/g\n");
  printf(ofile "s/<TOPVIAMETY>/$topViaMetY/g\n");
  printf(ofile "s/<CONTPOLYX>/$contPolyX/g\n");
  printf(ofile "s/<CONTPOLYY>/$contPolyY/g\n");
  printf(ofile "s/<CONTMETX>/$contMetX/g\n");
  printf(ofile "s/<CONTMETY>/$contMetY/g\n");
  printf(ofile "s/<STDCELLHEIGHT>/$stdCellHeight/g\n");
  close(ofile);
  system("/bin/chmod a+x $tempSwitchFileName");
  system("/bin/sed -f $tempSwitchFileName $dpuxTemplateFileName > $dpuxFileName");
  system("/bin/rm $tempSwitchFileName");
  printf("\n\t$dpuxFileName is generated.\n");
}

sub genTechLefHeader{
  ###
  ### HEADER
  ###
  printf(ofile "NAMESCASESENSITIVE ON ;\n");
  printf(ofile "\n");
  printf(ofile "VERSION 5.3 ;\n");
  printf(ofile "\n");
  printf(ofile "BUSBITCHARS \"[]\" ;\n");
  printf(ofile "\n");
  printf(ofile "UNITS\n");
  printf(ofile "    DATABASE MICRONS 1000  ;\n");
  printf(ofile "END UNITS\n");
  printf(ofile "\n");
}

sub genTechLefSimpleLayer{
  local($layer, $type) = @_;
  printf(ofile "LAYER $layer\n");
  printf(ofile "    TYPE $type ;\n");
  printf(ofile "END $layer\n");
  printf(ofile "\n");
}

sub genTechLefRoutingLayer{
  local($layer, $type, $width, $spacing, $wideSpacing, $routingPitch,
        $direction, $areaCap, $edgeCap, $sheetRes) = @_;
  printf(ofile "LAYER $layer\n");
  printf(ofile "    TYPE $type ;\n");
  printf(ofile "    WIDTH $width ;\n");
  printf(ofile "    SPACING $spacing RANGE 0 9.9 ;\n");
  printf(ofile "    SPACING $wideSpacing RANGE 10.0 35.0 ;\n");
  printf(ofile "    PITCH $routingPitch ;\n");
  printf(ofile "    DIRECTION $direction ;\n");
  printf(ofile "    # Area cap is pF/um**2 which is the same as F/m**2 using C/A=epsilon/d\n");
  printf(ofile "    CAPACITANCE CPERSQDIST $areaCap ;\n");
  printf(ofile "    # Edge cap is pF/um\n");
  printf(ofile "    EDGECAPACITANCE $edgeCap ;\n");
  printf(ofile "    RESISTANCE RPERSQ $sheetRes ;\n");
  printf(ofile "END $layer\n");
  printf(ofile "\n");
}

sub genTechLefViaDefault{
  local $i, $j;
  local($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
        $viaWidth, $viaSpacing, $upperHEncVia, $upperVEncVia, 
        $lowerHEncVia, $lowerVEncVia,
        $viaRes, $numOfRows, $numOfCols, $direction) = @_;
  if( $numOfCols eq "" ){
    $numOfCols = $numOfRows;
  }
  if( $direction eq "" ){
    $direction = "EAST";
  }
  $viaRes = 1.0*$viaRes/($numOfRows*$numOfCols);
  local($halfViaWidth) = $viaWidth/2.0;
  local($viaPitch) = $viaWidth+$viaSpacing;
  local($halfMetWidth1) = $halfViaWidth+$upperHEncVia;
  local($halfMetWidth2) = $halfViaWidth+$upperVEncVia;
  local($halfMetWidth3) = $halfViaWidth+$lowerHEncVia;
  local($halfMetWidth4) = $halfViaWidth+$lowerVEncVia;
  local($totalViaSizeX) = $numOfCols*$viaWidth+($numOfCols-1)*$viaSpacing;
  local($totalViaSizeY) = $numOfRows*$viaWidth+($numOfRows-1)*$viaSpacing;
  local($startX) = local($startY) = -$halfViaWidth;

  printf(ofile "VIA $viaName DEFAULT\n");
  printf(ofile "    RESISTANCE $viaRes ;\n");
  printf(ofile "    LAYER $upperMetLayer ;\n");
  if( $numOfRows == 1 && $numOfCols == 1) {
    printf(ofile "        RECT %s %s %s %s ;\n",
           -$halfMetWidth1, -$halfMetWidth2, $halfMetWidth1, $halfMetWidth2);
  } else {
    if( $direction eq "WEST" || $direction eq "SOUTH" ) {
      $left = $startX + $viaWidth - $totalViaSizeX - $upperHEncVia;
      $bottom = $startY + $viaWidth - $totalViaSizeY - $upperVEncVia;
      $right = $startX + $viaWidth + $upperHEncVia;
      $top = $startY + $viaWidth + $upperVEncVia;
    } else {
      $left = $startX - $upperHEncVia;
      $bottom = $startY - $upperVEncVia;
      $right = $startX + $totalViaSizeX + $upperHEncVia;
      $top = $startY + $totalViaSizeY + $upperVEncVia;
    }
    printf(ofile "        RECT $left $bottom $right $top ;\n");
  }

  printf(ofile "    LAYER $viaLayer ;\n");
  if( $direction eq "WEST" || $direction eq "SOUTH" ){
    for( $j=1; $j<=$numOfRows; $j++) {
      $bottom = $startY - ($j-1)*$viaPitch;
      $top = $startY - ($j-1)*$viaPitch + $viaWidth;
      for( $i=1; $i<=$numOfCols; $i++) {
        $left = $startX - ($i-1)*$viaPitch;
        $right = $startX - ($i-1)*$viaPitch + $viaWidth;
        printf(ofile "        RECT %s %s %s %s ;\n",
                     $left, $bottom, $right, $top);
      } 
    }
  } else {
    for( $j=1; $j<=$numOfRows; $j++) {
      $bottom = $startY + ($j-1)*$viaPitch;
      $top = $startY + ($j-1)*$viaPitch + $viaWidth;
      for( $i=1; $i<=$numOfCols; $i++) {
        $left = $startX + ($i-1)*$viaPitch;
        $right = $startX + ($i-1)*$viaPitch + $viaWidth;
        printf(ofile "        RECT %s %s %s %s ;\n",
                     $left, $bottom, $right, $top);
      } 
    }
  }

  printf(ofile "    LAYER $lowerMetLayer ;\n");
  if( $numOfRows == 1 && $numOfCols == 1) {
    printf(ofile "        RECT %s %s %s %s ;\n",
           -$halfMetWidth3, -$halfMetWidth4, $halfMetWidth3, $halfMetWidth4);
  } else {
    if( $direction eq "WEST" || $direction eq "SOUTH" ){
      $left = $startX + $viaWidth - $totalViaSizeX - $lowerHEncVia;
      $bottom = $startY + $viaWidth - $totalViaSizeY - $lowerVEncVia;
      $right = $startX + $viaWidth + $lowerHEncVia;
      $top = $startY + $viaWidth + $lowerVEncVia;
    } else {
      $left = $startX - $lowerHEncVia;
      $bottom = $startY - $lowerVEncVia;
      $right = $startX + $totalViaSizeX + $lowerHEncVia;
      $top = $startY + $totalViaSizeY + $lowerVEncVia;
    }
    printf(ofile "        RECT $left $bottom $right $top ;\n");
  }
  printf(ofile "END $viaName\n");
  printf(ofile "\n");
}

sub genTechLefViaRule{
  local($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
        $viaWidth, $viaSpacing, $upperDirection, $lowerDirection,
        $upperOverhang, $lowerOverhang) = @_;
  printf(ofile "VIARULE $viaName GENERATE\n");
  printf(ofile "    LAYER $upperMetLayer ;\n");
  printf(ofile "        DIRECTION $upperDirection ;\n");
  printf(ofile "        # this overhang is actually applied to both layers in this\n");
  printf(ofile "        # direction and needs to be set to the largest design rule\n");
  printf(ofile "        OVERHANG $upperOverhang ;\n");
  printf(ofile "        METALOVERHANG 0.0 ;\n");
  printf(ofile "\n");
  printf(ofile "    LAYER $lowerMetLayer ;\n");
  printf(ofile "        DIRECTION $lowerDirection ;\n");
  printf(ofile "        # this overhang is actually applied to both layers in this\n");
  printf(ofile "        # direction and needs to be set to the largest design rule\n");
  printf(ofile "        OVERHANG $lowerOverhang ;\n");
  printf(ofile "        METALOVERHANG 0.0 ;\n");
  printf(ofile "\n");
  printf(ofile "    LAYER $viaLayer ;\n");
  printf(ofile "        RECT %s %s %s %s ;\n", 
               -$viaWidth/2.0, -$viaWidth/2.0, $viaWidth/2.0, $viaWidth/2.0);
  printf(ofile "        # this spacing is center-to-center\n");
  printf(ofile "        SPACING %s BY %s ;\n",
               $viaWidth+$viaSpacing, $viaWidth+$viaSpacing);
  printf(ofile "END $viaName\n");
  printf(ofile "\n");
}

sub genTechLefMetTurn{
  local($viaName, $layer) = @_;
  printf(ofile "VIARULE $viaName GENERATE\n");
  printf(ofile "    LAYER $layer ;\n");
  printf(ofile "        DIRECTION VERTICAL ;\n");
  printf(ofile "    LAYER $layer ;\n");
  printf(ofile "        DIRECTION HORIZONTAL ;\n");
  printf(ofile "END $viaName\n");
  printf(ofile "\n");
}

sub genTechLefSameNet{
  local($layer1, $layer2, $spacing) = @_;
  printf(ofile "    SAMENET $layer1 $layer2 $spacing ;\n");
}

sub genTechLefSite{
  printf(ofile "SITE CORE\n");
  printf(ofile "    CLASS CORE  ;\n");
  printf(ofile "    SIZE %s BY %s ;\n", $routingPitchX, $stdCellHeight);
  printf(ofile "END CORE\n");
  printf(ofile "\n");
  printf(ofile "SITE IOSITE\n");
  printf(ofile "    CLASS    pad ;\n");
  printf(ofile "    SIZE 0.4 BY 388.8 ;\n");
  printf(ofile "END IOSITE\n");
  printf(ofile "\n");
  printf(ofile "SITE SBlockSite\n");
  printf(ofile "    CLASS    CORE ;\n");
  printf(ofile "    SIZE 1.0 BY 1.0 ;\n");
  printf(ofile "END SBlockSite\n");
  printf(ofile "\n");
}

sub max{
  local($num1, $num2) = @_;
  if( $num1 >= $num2) {
    return($num1);
  } else {
    return($num2);
  }
}

