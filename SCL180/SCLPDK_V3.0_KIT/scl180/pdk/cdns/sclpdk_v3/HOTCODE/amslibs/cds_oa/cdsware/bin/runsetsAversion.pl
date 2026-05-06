#!/usr/bin/perl -w

use strict;

my $usage = "$0: <path of HOTCODE> <fileOut> <tech_ver>\n";
my $PathHTCD = shift || die $usage;
my $fileOut = shift || die $usage;
my $tech_ver = shift ||  die $usage;
my @tv = split /_/ , $tech_ver ;
my $tech = $tv[0];
my $METAL = $tv[1];
my $firstline = "" ;
my $assuraPath = "$PathHTCD/techs/${tech}_${METAL}/assura/default_scr" ;
my $calibrePath = "$PathHTCD/techs/${tech}_${METAL}/calibre/default_scr" ;
my $pvsPath = "$PathHTCD/techs/${tech}_${METAL}/pvs/default_scr" ;
open(my $fh, '>', $fileOut) || die "Could not open file '$fileOut' ";

##############################################
############ ASSURA ##########################
##############################################

my @arr = ("DRC.load" , "LVS.load") ;
my $leArr = $#arr + 1 ;
for(my $i=0 ; $i< $leArr ; $i++) {
	open(INFO1, "${assuraPath}/$arr[$i]")|| die("Error: open fail $arr[$i]\n");
	my $flag = 0;
	#print "$arr[$i]\n";
	while (my $line = <INFO1>) {
		if($flag == 0){
			if($line =~ /^\s*if\( rexMatchp\(\"$tech\"/) {
				$flag = 1 ;
			}
			elsif($line =~ /^\s*load\(/ ) {
				my @a = split /default_scr\// , $line ;
				my @b = split /"/ , $a[1] ;
				open (FILE , "${PathHTCD}/techs/ts18sl/assura/default_scr/$b[0]"); 
				while($firstline = <FILE>){
					if($firstline =~ /^\s*\d*(;|\/|\/\/|{|)\s*({|)\$Id/){
						last ;
					}
				}
				my @arr1 = split /rca/ , $firstline ;
				my @ver = split / / , $arr1[1] ;
				print $fh "$b[0]  $ver[1]\n" ;
			}
			elsif($line =~ /^\s*if\( rexMatchp\(/){
				$flag = 2;
			}
		}
		elsif ($flag == 1 &&  $line =~ /^\s*load\(/) {
			my @a = split /default_scr\// , $line ;
			my @b = split /"/ , $a[1] ;
				open (FILE , "${PathHTCD}/techs/ts18sl/assura/default_scr/$b[0]");
				while($firstline = <FILE>){
					if($firstline =~ /^\s*\d*(;|\/|\/\/|{|)\s*({|)\$Id/){
						last ;
					}
				}
			my @arr1 = split /rca/ , $firstline ;
			my @ver = split / / , $arr1[1] ;
			print $fh "$b[0]  $ver[1]\n";
		}
		elsif ($flag == 1 || ($flag == 2 && $line =~ /^\s*\)/)) {	
			$flag = 0;
		}
	}
close "${assuraPath}/$arr[$i]";
close INFO1;
}

#######################################################
############### CALIBRE ###############################
#######################################################

@arr = ("ANTENNA.header" , "DRC.header" , "DUMMY.header" , "${tech}.LVS.header" ) ;
$leArr = $#arr + 1 ;
for(my $i=0 ; $i< $leArr ; $i++) {
	open(INFO1, "${calibrePath}/$arr[$i]")|| die("Error: open fail $arr[$i]\n");
	my $flag = 0;
	#print "$arr[$i]\n";
	while (my $line = <INFO1>) {
		if($flag == 0){
			if($line =~ /^\s*#ifdef DRC_TECH ${tech}/ || $line =~ /^\s*#ifdef LVS_TECH ${tech}/) {
				$flag = 1 ;
			}
			elsif($line =~ /^\s*INCLUDE/ ) {
				my @a = split /default_scr\// , $line ;
				my @b = split /"/ , $a[1] ;
				my @c = split /_/ , $b[0] ;
				if($c[0] ne "RCE"){
					open (FILE , "${PathHTCD}/techs/ts18sl/calibre/default_scr/$b[0]"); 
					while($firstline = <FILE>){
						if($firstline =~ /^\s*\d*(;|\/|\/\/|{|)\s*({|)\$Id/){
							last ;
						}
					}
				my @arr1 = split /rca/ , $firstline ;
				my @ver = split / / , $arr1[1] ;
				print $fh "$b[0]  $ver[1]\n" ;
				}
			}
			elsif($line =~ /^\s*#ifdef DRC_TECH/ || $line =~ /^\s*#ifdef LVS_TECH/){
				$flag = 2;
			}
		}
		elsif ($flag == 1 &&  $line =~ /^\s*INCLUDE/) {
			my @a = split /default_scr\// , $line ;
			my @b = split /"/ , $a[1] ;
				open (FILE , "${PathHTCD}/techs/ts18sl/calibre/default_scr/$b[0]");
				while($firstline = <FILE>){
					if($firstline =~ /^\s*\d*(;|\/|\/\/|{|)\s*({|)\$Id/){
						last ;
					}
				}
			my @arr1 = split /rca/ , $firstline ;
			my @ver = split / / , $arr1[1] ;
			print $fh "$b[0]  $ver[1]\n";
		}
		elsif ($flag == 1 || ($flag == 2 && $line =~ /^\s*#endif/)) {	
			$flag = 0;
		}
	}
close "${calibrePath}/$arr[$i]";
close INFO1;
}

####################################################
##################### PVS ##########################
####################################################

@arr = ("ANTENNA.pvs.header" , "DRC.pvs.header" , "DUMMYFILL.pvs.header" , "LVS.pvs.header") ;
$leArr = $#arr + 1 ;
for(my $i=0 ; $i< $leArr ; $i++) {
	open(INFO1, "${pvsPath}/$arr[$i]")|| die("Error: open fail $arr[$i]\n");
	while (my $line = <INFO1>) {
		if($line =~ /^\s*include/) {
			my @a = split /default_scr\// , $line ;
			my @b = split /"/ , $a[1] ;
			open (FILE , "${PathHTCD}/techs/ts18sl/pvs/default_scr/$b[0]");
			while($firstline = <FILE>){
				if($firstline =~ /^\s*\d*(;|\/|\/\/|{|)\s*({|)\$Id/){
					last ;
				}
			}
			my @arr1 = split /rca/ , $firstline ;
			my @ver = split / / , $arr1[1] ;
			print $fh "$b[0]  $ver[1]\n" ;
		}
	}
close FILE ;
close "${pvsPath}/$arr[$i]";
close INFO1;
}
	
close $fileOut

