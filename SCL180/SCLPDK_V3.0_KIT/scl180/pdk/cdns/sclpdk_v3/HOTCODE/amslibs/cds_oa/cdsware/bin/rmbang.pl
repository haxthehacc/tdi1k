#
# Perl script to remove ! from gds files
#
# Koen Lampaert
#
if (@ARGV != 2) {
  &usage;
}
#
open(GDSI, "<$ARGV[0]") || die("Can't open input file $ARGV[0] for reading\n");
open(GDSO, ">$ARGV[1]") || die("Can't open output file $ARGV[0] for writing\n");
#
until (eof(GDSI)) {
  read(GDSI,$buf,1024);
  $buf =~ tr/\!/ /;
  print(GDSO $buf);
}

close(GDSI);
close(GDSO);

sub usage {
  print "\n";
  print "usage: rmbang inputFile outputFile  \n";
  print "\n"; 
  exit(1);
}
