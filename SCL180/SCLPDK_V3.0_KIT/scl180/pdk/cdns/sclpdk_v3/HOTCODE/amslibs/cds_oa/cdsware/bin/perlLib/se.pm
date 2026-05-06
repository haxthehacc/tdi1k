require 5.004;

package se;

use ipc;

sub execute {
  if (@_ != 3) {
    die "$0: Internal error: Bad number of args to execute";
  }#if

  my $memory_size = shift;
  my $journal_fn  = shift;
  my $macro_fn    = shift;

  # Check for a valid memory value.
  my @mem_sizes = (12, 24, 36, 48, 60, 72, 84, 96,
                  108, 120, 150, 300, 400, 500, 800,
                  1200, 1600, 1900);

  my $defaultMemory;
  foreach $defaultMemory (@mem_sizes) {
    if ($defaultMemory >= $memory_size) {
      $memory_size = $defaultMemory;
      last ;
    }#if
  }#foreach
  if ($memory_size > 1900) {
    $memory_size = 1900;
  }#if

   # Open the macro file and check for the existance of an FQUIT command.
  open(MFP, "<$macro_fn") || die "$0: Failed to open file \"$macro_fn\".\nError message: $!\n";
  my $fquit_found = 0;
  while (<MFP>) {
    my $line = uc($_);
    if ($line =~ /FQUIT/) {
      $fquit_found = 1;
      last;
    }#if
  }#while
  close(MFP);
  if (!$fquit_found) {
    print "*Error* Macro file must contain the FQUIT command.\n";
    return(0);
  }#if

  my $proc_cmd = "cds sedsm -gd=ansi -j=".$journal_fn." -m=".$memory_size;
  my $filehandle = ipc::beginProcess($proc_cmd);
  if (!$filehandle) { 
    print("*Error* beginProcess failed.\n");
    return(0);
  }#if

  # Let the process start and wait for the Silicon Ensemble prompt "SE>".
  my $data = ipc::readProcess($filehandle);
  while ($data !~ /^SE>/) {
    $data = ipc::readProcess($filehandle);
  }#while

  # At this point SE is ready to execute a command.
  my $se_cmd = "EXECUTE \"$macro_fn\" ;\n";
  ipc::writeProcess($filehandle, $se_cmd);
  
  # Let the process execute the macro file, if the SE> prompt is read,
  # the execute command failed for some reason therefore, kill the
  # process and return 0.
  while (ipc::isProcessAlive($filehandle)) {
    $data = ipc::readProcess($filehandle);
    if ($data =~ /^SE>/) {
      ipc::endProcess($filehandle);  
      print("*Error* SE ended unexpectedly. Check journal file.\n");
      return(0);
    }#if
  }#while
  ipc::endProcess($filehandle); # Added protection to kill the SE process.

  return(1);
}#execute_se

1;
