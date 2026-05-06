#!/tools/bin/perl5
#-------------------------------------------
# FileName: genTechLef.pl
# Usage: genTechLeft <infoFile>
# Functions: based on infoFile, the program will generate
#            tech.lef, tech_doublevia.lef, se.ini, tech.dpux
# Author:    Jie Yu
# History:   Initial -- 01/24/01
# $Log: Revision 1 2019/07/01 11:02:24 GMT ronenha $
#   Initial revision.
# 
#  Revision 1 2019/07/01 11:02:09 GMT ronenha
#   Initial revision.
# 
#  Revision: 1.1 Wed Aug  6 22:38:16 2003 syncmgr
#  checkin of all bin files
# Revision 1.8  2003/03/26 18:13:54  gujrals
# change DBU to 2000, add MINFEATURE, THICKNESS, support input files without topXXX parameters defined explicitly.  Change routingpitch, MINFEATURE, XGRID, YGRID in se.ini (requires new se.ini template).
#
# Revision 1.7  2003/03/04 23:54:31  gujrals
# fix TOPOFSTACKONLY syntax
#
# Revision 1.6  2003/01/28 08:24:37  gujrals
# Major revision to support stacked vias with min area checking (new parameter in input file is metxArea, met1Area, etc.)
# Also turns via overplot on vias so they are oriented in preferred direction of that metal layer.
# Also checks min metal width on vias so that rule is not violated even if metal overplote rule does not require.
#
# Revision 1.5  2002/11/12 18:13:14  gujrals
# allow routing pitches to be defined per layer
#
# Revision 1.4  2002/10/03 21:20:11  gujrals
# Major revision to support separate rules & geometries for individual metal layers and vias.  Earlier versions required all middle layers to have the same rules.  Note that new parameters must be added to the tech.dpux templates and to this program's inpout file, genTechLef_info.txt.
#
# Revision 1.3  2002/10/02 19:23:27  gujrals
# added metxPitch and topMetPitch parameters which can be used to override calculated pitch value so we can match the asic library.
#
# Revision 1.2  2002/10/02 00:00:56  gujrals
# keep overplot for topmetal lower the same as overplot for topmetal upper
#
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
      $metWidth[1]= $paramValue;
    } elsif( $paramName =~ m/^met1Spacing$/ ) {
      $met1Spacing= $paramValue;
      $metSpacing[1]= $paramValue;
    } elsif( $paramName =~ m/^met1WideSpacing$/ ) {
      $met1WideSpacing= $paramValue;
    } elsif( $paramName =~ m/^met1EncCont$/ ) {
      $met1EncCont= $paramValue;
    } elsif( $paramName =~ m/^met1EndEncCont$/ ) {
      $met1EndEncCont= $paramValue;
    } elsif( $paramName =~ m/^met1Area$/ ) {
      $met1Area= $paramValue;
      $metArea[1] =  $paramValue;
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
    } elsif( $paramName =~ m/(^metxPitch$)/ ) {
      $metxPitch= $paramValue;
    } elsif( $paramName =~ m/(^metxArea$)/ ) {
      $metxArea= $paramValue;
    } elsif( $paramName =~ m/(^topMetPitch$)/ ) {
      $topMetPitch= $paramValue;
    } else {
      for ($layernum = 1 ; $layernum <= $numOfMetLayers ; $layernum++) {
	  # METAL Layers
	  $upperLayer = $layernum;
	  $lowerLayer = $layernum-1;
	  if ($paramName =~ m/(^met${layernum}Width$)/ ) {
	      $metWidth[$layernum] = $paramValue;      
	      $topMetWidth = $paramValue if ($layernum == $numOfMetLayers);
	  } elsif ($paramName =~ m/(^met${layernum}Spacing$)/ ) {
	      $metSpacing[$layernum] = $paramValue; 
	      $topMetSpacing = $paramValue if ($layernum == $numOfMetLayers);
	  } elsif ($paramName =~ m/(^met${layernum}WideSpacing$)/ ) {
	      $metWideSpacing[$layernum] = $paramValue; 
	      $topMetWideSpacing = $paramValue if ($layernum == $numOfMetLayers);
	  } elsif ($paramName =~ m/(^met${layernum}EncVia${upperLayer}$)/ ) {
	      $metEncViaU[$layernum] = $paramValue; 
	      #print "met${layernum}EncVia${upperLayer} = $layernum =$paramValue\n";
	  } elsif ($paramName =~ m/(^met${layernum}EndEncVia${upperLayer}$)/ ) {
	      $metEndEncViaU[$layernum] = $paramValue; 
	  } elsif ($paramName =~ m/(^met${layernum}EncVia${lowerLayer}$)/ ) {
	      #print "met${layernum}EncVia${lowerLayer} = $layernum =$paramValue\n";
	      $metEncViaL[$layernum] = $paramValue; 
	      $topMetEncVia = $paramValue if ($layernum == $numOfMetLayers); 
	  } elsif ($paramName =~ m/(^met${layernum}EndEncVia${lowerLayer}$)/ ) {
	      $metEndEncViaL[$layernum] = $paramValue;
	  } elsif ($paramName =~ m/(^met${layernum}Area$)/ ) {
	      $metArea[$layernum] = $paramValue; 
	      $topMetArea = $paramValue if ($layernum == $numOfMetLayers);
	  } elsif ($paramName =~ m/(^met${layernum}Thickness$)/ ) {
	      $metThickness[$layernum] = $paramValue; 
	  # VIAs
	  } elsif ($paramName =~ m/(^via${layernum}Width$)/ ) {
	      $viaWidth[$layernum] = $paramValue; 
	      $topViaWidth = $paramValue if ($layernum == $numOfMetLayers-1);
	  } elsif ($paramName =~ m/(^via${layernum}Spacing$)/ ) {
	      $viaSpacing[$layernum] = $paramValue; 
	      $topViaSpacing = $paramValue if ($layernum == $numOfMetLayers-1);
	  } elsif ($paramName =~ m/(^via${layernum}ArraySpacing$)/ ) {
	      $viaArraySpacing[$layernum] = $paramValue; 
	      $topViaArraySpacing = $paramValue if ($layernum == $numOfMetLayers-1);
	  # PITCH
	  } elsif ($paramName =~ m/(^met${layernum}Pitch$)/ ) {
	      $metPitch[$layernum] = $paramValue; 
	      $topMetPitch = $paramValue if ($layernum == $numOfMetLayers);
	  }
      }
   }
  }  
  close(ifile);

  # Set defaults
  for ($i = 1; $i <=  $numOfMetLayers ; $i++) {
      # METAL Layers
      $metWidth[$i] = $metxWidth if (!$metWidth[$i]);
      $metSpacing[$i] = $metxSpacing if (!$metSpacing[$i]);
      $metWideSpacing[$i] = $metxWideSpacing if (!$metWideSpacing[$i]);
      $metEncViaU[$i] = $metxEncViax if (!$metEncViaU[$i]);
      $metEndEncViaU[$i] = $metxEndEncViax if (!$metEndEncViaU[$i]);
      $metEncViaL[$i] = $metxEncViax if (!$metEncViaL[$i]);
      $metEndEncViaL[$i] = $metxEndEncViax if (!$metEndEncViaL[$i]);
      $metArea[$i] = $metxArea if (!$metArea[$i]);

      # VIAs
      $viaWidth[$i] = $viaxWidth if (!$viaWidth[$i]);
      $viaSpacing[$i] = $viaxSpacing if (!$viaSpacing[$i]);
      $viaArraySpacing[$i] = $viaxArraySpacing if (!$viaArraySpacing[$i]);

      # PITCH
      $metPitch[$i] = $metxPitch if (!$metPitch[$i]);
      $calcPitchX = $metWidth[$i]/2 + $metSpacing[$i] + max($metWidth[$i], $viaWidth[$i] + 2.0*$metEndEncViaL[$i])/2 ;
      $calcPitchY = $metWidth[$i]/2 + $metSpacing[$i] + max($metWidth[$i], $viaWidth[$i] + 2.0*$metEncViaL[$i])/2;

      $routingPitchX[$i] = $metPitch[$i];
      $routingPitchY[$i] = $metPitch[$i];

      if ($i%2 == 0) {
	  # VERTICAL layers
	  if ($calcPitchX - $routingPitchX[$i] > 1e-10) {
	      print "WARNING!!! m${i} Calc min pitch X is $calcPitchX, you specified $routingPitchX[$i].\n";
	      $routingPitchX[$i] =  $calcPitchX if !$routingPitchX[$i];
	  } else {
	      print "m${i} pitch is $routingPitchX[$i]  OK! Calc min pitch X= $calcPitchX\n";
	  }
      } else {
	  # HORIZONTAL layers
	  if ($calcPitchY - $routingPitchY[$i] > 1e-10) {
	      print "WARNING!!! m${i} Calc min pitch Y is $calcPitchY, you specified $routingPitchY[$i].\n";
	      $routingPitchY[$i] =  $calcPitchY if !$routingPitchY[$i];
	  } else {
	      print "m${i} pitch is $routingPitchY[$i] OK!  Calc min pitch Y= $calcPitchY\n";
	  }
      }
      


  }
  if( $numOfMetLayers < 3 || $numOfMetLayers > 6 ){
    printf("\n\tCurrently only allows 3-6 metal process.\n\n");
    exit(1);
  }
    
  $routingPitchX = &max($metxPitch, &max($metxWidth, $metxEndEncViax*2.0+$viaxWidth) + $metxSpacing);
  $routingPitchY = &max($metxPitch, &max($metxWidth, $metxEncViax*2.0+$viaxWidth) + $metxSpacing);
  $topRoutingPitch = &max($topMetPitch, &max($topMetWidth, $topMetEncVia*2.0+$topViaWidth) + $topMetSpacing);
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
     $met1WideSpacing, $routingPitchY[1], "HORIZONTAL", 
     $metAreaCap[1], $metEdgeCap[1], $metResistance[1], 1);

  for($i=2; $i<$numOfMetLayers; $i++) {

    $viaLayer = "via" . ($i-1);
    &genTechLefSimpleLayer($viaLayer, "CUT");

    $metLayer = "metal" . $i;
    if( $i%2 == 0 ){
      $routingPitch = $routingPitchX[$i];
      $direction = "VERTICAL";
    } else {
      $routingPitch = $routingPitchY[$i];
      $direction = "HORIZONTAL";
    }
    
    &genTechLefRoutingLayer($metLayer, "ROUTING", $metWidth[$i], $metSpacing[$i],
       $metWideSpacing[$i], $routingPitch, $direction,
       $metAreaCap[$i], $metEdgeCap[$i], $metResistance[$i], $i);
  }
  $viaLayer = "via" . ($numOfMetLayers-1);
  &genTechLefSimpleLayer($viaLayer, "CUT");
  $metLayer = "metal" . $numOfMetLayers;
  if( $numOfMetLayers%2 == 0 ){
    $topRoutingPitch = $routingPitchX[$i];
    $direction = "VERTICAL";
  } else {
    $topRoutingPitch = $routingPitchY[$i];
    $direction = "HORIZONTAL";
  }
  &genTechLefRoutingLayer($metLayer, "ROUTING", $topMetWidth, $topMetSpacing,
     $topMetWideSpacing, $topRoutingPitch, $direction,
     $metAreaCap[$numOfMetLayers], $metEdgeCap[$numOfMetLayers], 
     $metResistance[$numOfMetLayers],$numOfMetLayers );

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
      $lowerHEncVia = $topMetEncVia;
      $lowerVEncVia = $topMetEncVia;
    } else {
      $viaWidth = $viaWidth[$i-1];
      $viaSpacing = $viaSpacing[$i-1];
      if ($i % 2 == 0) {
	  # upper metal is vertical (m2, m4, m6)
	  #print "UPPER($i) is VERT";
	  $upperVEncVia = $metEndEncViaL[$i];
	  $upperHEncVia = $metEncViaL[$i];	  
	  $lowerHEncVia = $metEndEncViaU[$i-1];
	  $lowerVEncVia = $metEncViaU[$i-1];
	  
      } else {
	  # upper metal is horizontal (m1, m3, m5)
	  #print "UPPER($i) is HOR";
	  $upperVEncVia = $metEncViaL[$i];
	  $upperHEncVia = $metEndEncViaL[$i];
	  $lowerVEncVia = $metEndEncViaU[$i-1];
	  $lowerHEncVia = $metEncViaU[$i-1];
	  

      }	  
  }
    $viaRes = $viaResistance[$i-1]; 
    $viaName = "M" . ($i-1) . "_M" . $i . "_stack";
    print "$viaName viaWidth=$viaWidth viaSpacing=$viaSpacing lower=$lowerHEncVia, $lowerVEncVia  upper=$upperHEncVia, $upperVEncVia \n";
    &genTechLefViaDefault($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
                          $viaWidth, $viaSpacing, $upperHEncVia, $upperVEncVia,
                          $lowerHEncVia, $lowerVEncVia, $viaRes, 1);
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
      $viaWidth = $viaWidth[$i-1];
      $viaSpacing = $viaArraySpacing[$i-1];
      $lowerOverhang = $metEndEncViaU[$i-1]; # $metxEndEncViax;
      $upperOverhang = $metEndEncViaL[$i]; # $metxEndEncViax;
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
    &genTechLefSameNet($viaLayer, $viaLayer, $viaSpacing[$i]);
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
    &genTechLefSameNet($layer, $layer, $metSpacing[$i]);
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
     $met1WideSpacing, $routingPitchY[1], "HORIZONTAL", 
     $metAreaCap[1], $metEdgeCap[1], $metResistance[1], 1);

  for($i=2; $i<$numOfMetLayers; $i++) {

    $viaLayer = "via" . ($i-1);
    &genTechLefSimpleLayer($viaLayer, "CUT");

    $metLayer = "metal" . $i;
    if( $i%2 == 0 ){
      $routingPitch = $routingPitchX[$i];
      $direction = "VERTICAL";
    } else {
      $routingPitch = $routingPitchY[$i];
      $direction = "HORIZONTAL";
    }
    &genTechLefRoutingLayer($metLayer, "ROUTING", $metWidth[$i], $metSpacing[$i],
       $metWideSpacing[$i], $routingPitch, $direction,
       $metAreaCap[$i], $metEdgeCap[$i], $metResistance[$i], $i);
  }
  $viaLayer = "via" . ($numOfMetLayers-1);
  &genTechLefSimpleLayer($viaLayer, "CUT");
  $metLayer = "metal" . $numOfMetLayers;
  if( $numOfMetLayers%2 == 0 ){
      $routingPitch = $routingPitchX[$i];
      $direction = "VERTICAL";
  } else {
      $routingPitch = $routingPitchY[$i];
      $direction = "HORIZONTAL";
  }
  &genTechLefRoutingLayer($metLayer, "ROUTING", $topMetWidth, $topMetSpacing,
     $topMetWideSpacing, $topRoutingPitch, $direction,
     $metAreaCap[$numOfMetLayers], $metEdgeCap[$numOfMetLayers], 
     $metResistance[$numOfMetLayers],$numOfMetLayers );

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
      $lowerHEncVia = $topMetEncVia;
      $lowerVEncVia = $topMetEncVia;
    } else {
      $viaWidth = $viaWidth[$i-1]; #$viaxWidth;
      $viaSpacing = $viaSpacing[$i-1]; #$viaxSpacing;
      $upperHEncVia = $metEndEncViaL[$i]; #$metxEndEncViax;
      $upperVEncVia = $metEncViaL[$i]; #$metxEncViax;
      $lowerHEncVia = $metEndEncViaU[$i-1]; #$metxEndEncViax;
      $lowerVEncVia = $metEncViaU[$i-1]; #$metxEncViax;
    }
    $viaRes = $viaResistance[$i-1]; 
    if( $i != $numOfMetLayers ) {
      $viaName = "M" . ($i-1) . "_M" . $i;
      print "$viaName viaWidth=$viaWidth viaSpacing=$viaSpacing upper=$upperHEncVia, $upperVEncVia lower=$lowerHEncVia, $lowerVEncVia\n";
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
      $viaWidth = $viaWidth[$i-1]; #$viaxWidth;
      $viaSpacing = $viaArraySpacing[$i-1]; #$viaxArraySpacing;
      $lowerOverhang = $metEndEncViaU[$i-1]; #$metxEndEncViax;
      $upperOverhang = $metEndEncViaL[$i]; #$metxEndEncViax;
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
    &genTechLefSameNet($viaLayer, $viaLayer, $viaSpacing[$i]);
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
    &genTechLefSameNet($layer, $layer, $metSpacing[$i]);
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
  $routingPitchX2000 = $routingPitchX*2000;
  $routingPitchY2000 = $routingPitchY*2000;
  $tempSwitchFileName = "switch";
  open(ofile, ">$tempSwitchFileName") || die "Cannot open $tempSwitchFileName for writing";
  printf(ofile "s/<ROUTINGPITCHX>/$routingPitchX2000/\n");
  printf(ofile "s/<ROUTINGPITCHY>/$routingPitchY2000/\n");
  printf(ofile "s/<XGRID>/10/\n");
  printf(ofile "s/<YGRID>/10/\n");
  printf(ofile "s/<MINFEATURE>/2/\n");

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

  $dpuxTemplate = "tech.dpux.m" . $numOfMetLayers;
  $dpuxTemplateFileName = "temp/$dpuxTemplate";

  # Get the latest tech.dpux template from cvs
  unlink($dpuxTemplateFileName) if (-e $dpuxTemplateFileName);
  system("cvs -d /rds/cvsroot export -d temp -D today asic_libs/templates/$dpuxTemplate");

  #$cdsware = $ENV{RDS_CDSWARE};
  #$dpuxTemplateFileName = $cdsware . "/template/tech.dpux.m" . $numOfMetLayers;
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
  for ($i=1; $i <= $numOfMetLayers; $i++) {
      $viaPitch[$i] = $viaWidth[$i] + $viaSpacing[$i];
      $viaArrayPitch[$i] = $viaWidth[$i] + $viaArraySpacing[$i];
      $halfViaWidth[$i] = $viaWidth[$i]/2.0;

      $viaMetXB[$i] = $halfViaWidth[$i] + $metEndEncViaU[$i];
      $viaMetYB[$i] = $halfViaWidth[$i] + $metEncViaU[$i];
      $viaMetXA[$i] = $halfViaWidth[$i] + $metEndEncViaL[$i+1];
      $viaMetYA[$i] = $halfViaWidth[$i] + $metEncViaL[$i+1];

      printf(ofile "s/<VIA${i}WIDTH>/$viaWidth[$i]/g\n");
      printf(ofile "s/<VIA${i}SPACING>/$viaSpacing[$i]/g\n");
      printf(ofile "s/<VIA${i}PITCH>/$viaPitch[$i]/g\n");
      printf(ofile "s/<VIA${i}ARRAYPITCH>/$viaArrayPitch[$i]/g\n");

      printf(ofile "s/<MET${i}WIDTH>/$metWidth[$i]/g\n");
      printf(ofile "s/<MET${i}SPACING>/$metSpacing[$i]/g\n");
      printf(ofile "s/<MET${i}WIDESPACING>/$metWideSpacing[$i]/g\n");

      printf(ofile "s/<MET${i}ENDENCVIAL>/$metEndEncViaL[$i]/g\n");
      printf(ofile "s/<MET${i}ENDENCVIAU>/$metEndEncViaU[$i]/g\n");

      printf(ofile "s/<HALFVIA${i}WIDTH>/$halfViaWidth[$i]/g\n");
      printf(ofile "s/<VIA${i}METXB>/$viaMetXB[$i]/g\n");
      printf(ofile "s/<VIA${i}METYB>/$viaMetYB[$i]/g\n");
      printf(ofile "s/<VIA${i}METXA>/$viaMetXA[$i]/g\n");
      printf(ofile "s/<VIA${i}METYA>/$viaMetYA[$i]/g\n");
  }

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
  
  unlink ($dpuxTemplateFileName);
  rmdir ("temp");

  printf("\n\t$dpuxFileName is generated.\n");
}

sub genTechLefHeader{
  ###
  ### HEADER
  ###
  printf(ofile "# Technology LEF for ${numOfMetLayers}-layer $processName process\n");
  printf(ofile "# \$Log\$ \n");
  printf(ofile "NAMESCASESENSITIVE ON ;\n");
  printf(ofile "\n");
  printf(ofile "VERSION 5.3 ;\n");
  printf(ofile "\n");
  printf(ofile "BUSBITCHARS \"[]\" ;\n");
  printf(ofile "\n");
  printf(ofile "UNITS\n");
  printf(ofile "    DATABASE MICRONS 2000  ;\n");
  printf(ofile "END UNITS\n");
  printf(ofile "MINFEATURE 0.005 0.005 ;\n");
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
        $direction, $areaCap, $edgeCap, $sheetRes, $layernum) = @_;
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
  printf(ofile "    THICKNESS $metThickness[$layernum] ;\n");
  printf(ofile "END $layer\n");
  printf(ofile "\n");
}

sub genTechLefViaDefault{
  local $i, $j;
  local($viaName, $viaLayer, $upperMetLayer, $lowerMetLayer,
        $viaWidth, $viaSpacing, $upperHEncVia, $upperVEncVia, 
        $lowerHEncVia, $lowerVEncVia,
        $viaRes, $numOfRows, $numOfCols, $direction) = @_;


  local($upper) = $upperMetLayer;
  local($lower) = $lowerMetLayer;
  $upper =~ s/metal(\d+)/\1/g;
  $lower =~ s/metal(\d+)/\1/g;

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
  if ($viaName =~ /_stack$/) {
      printf(ofile "    TOPOFSTACKONLY \n");
  }
  printf(ofile "    RESISTANCE $viaRes ;\n");
  printf(ofile "    LAYER $upperMetLayer ;\n");
  if( $numOfRows == 1 && $numOfCols == 1) {
      $left =  -$halfMetWidth1;
      $bottom = -$halfMetWidth2;
      $right = $halfMetWidth1;
      $top  =  $halfMetWidth2;
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
  }
  # check against min metal width
#  print "metal $upper is $left, $right\n";
  if ($right - $left < $metWidth[$upper]) {
      $left = -$metWidth[$upper]/2;
      $right = $metWidth[$upper]/2; 
  #    print "metal $upper adjusted to $left, $right\n";
  }
#  print "metal $upper ($metWidth[$upper]) is (top/bot) $top, $bottom\n";
  if ($top - $bottom < $metWidth[$upper]) {
      $bottom = -$metWidth[$upper]/2;
      $top = $metWidth[$upper]/2;
 #     print "metal $upper adjusted to (top/bot) $top, $bottom\n";
  }

  printf(ofile "        RECT $left $bottom $right $top ;\n");

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
      $left = -$halfMetWidth3; 
      $bottom = -$halfMetWidth4;
      $right = $halfMetWidth3;
      $top = $halfMetWidth4;
#      printf(ofile "        RECT %s %s %s %s ;\n",
#           -$halfMetWidth3, -$halfMetWidth4, $halfMetWidth3, $halfMetWidth4);
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

  }
  # check against min metal width
  if ($right - $left < $metWidth[$lower]) {
      $left = -$metWidth[$lower]/2;
      $right = $metWidth[$lower]/2;
  }
  if ($top - $bottom < $metWidth[$lower]) {
      $bottom = -$metWidth[$lower]/2;
      $top = $metWidth[$lower]/2;
  }

  # check min metal area on bottom of stacked vias
  print "min met $lower area is  ($metArea[$lower] > ($right - $left) * ($top - $bottom) \n";
  if ($viaName =~ /_stack$/ && ($metArea[$lower] > ($right - $left) * ($top - $bottom)) )  {
      printf (ofile "# check min metal area\n");
      printf(ofile "#       RECT $left $bottom $right $top ;\n");
      if ($lower %2 == 0) {
	  # vertical line so elongate bottom and top to meet min area
	  $top = $metArea[$lower]/($right - $left)/2;
	  $bottom = -$top;
      } else {
	  # horisontal line so elongate right and left to meet min area
	  $right = $metArea[$lower]/($top - $bottom)/2;
	  $left = -$right;
      }
	  
  }

  
  printf(ofile "        RECT $left $bottom $right $top ;\n");
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
  if (($layer1 =~ /metal/ && $layer2 =~ /metal/ && $layer1 ne "metal$numOfMetLayers") || $spacing ==0) {
        printf(ofile "    SAMENET $layer1 $layer2 $spacing STACK ;\n");
    } else {
	printf(ofile "    SAMENET $layer1 $layer2 $spacing ;\n");
    }
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

