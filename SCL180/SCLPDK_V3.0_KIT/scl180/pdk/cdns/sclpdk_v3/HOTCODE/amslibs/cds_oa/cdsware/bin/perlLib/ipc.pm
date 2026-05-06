require 5.004;

package ipc;

require 'Comm.pl';
&Comm'init();

sub beginProcess {
  my $cmd = shift;

  my($filehandler, $junk, $pid) = &Comm'open_proc($cmd);
  &Comm'wait_nohang( $pid );
  $PIDS{$filehandler} = $pid;

  return($filehandler);
}#beginProcess

sub writeProcess {
  my $fh = shift;
  my $data = shift;

  my $length = length($data);
  my $ret_length = syswrite($fh, $data, $length, 0);
  if ($ret_length != $length) {
    print "*Error* during write\n";
    return(0);
  }#if

  return(1);
}#writeProcess

sub readProcess {
  my $fh = shift;

  my $data;
  my $ret_length = sysread($fh, $data, 200, 0);
  if ($ret_length == 0 || $ret_length != length($data)) {
    print("*Error* during process read.\n");
    return(0);
  }#if

  return($data);
}#writeProcess

sub isProcessAlive {
  my $filehandler = shift;

  my $pid = $PIDS{$filehandler};
  if ($pid) {
    if (waitpid($pid, 1) > 0) {
      return(1);
    }#if
  }#if

  return(0);
}#isProcessAlive

sub endProcess {
  my $filehandle = shift;

  &close_it( $filehandle );
  return(0);
}#endProcess

1;
