#!/usr/bin/perl

use Getopt::Std;
use File::Find;

sub wanted
{
  open (GET, "isi get -DD '$File::Find::name'|") || die "Cant' run isi get on $File::Find:name";
  while (<GET>)
  {
    chomp;
    next if (-d $File::Find::name);
    @lf = split (/[ \t]+/);
    next if ($lf[1] ne "Stubbed:");
    @fstat = stat ($File::Find::name);
    if ($lf[2] eq "True")
    {
      print "$File::Find::name,$fstat[7],True\n" if ($STUBS);
    }
    else
    {
      print "$File::Find::name,$fstat[7],False\n" if ($NOT_STUBS);
    }
    last;
  }
  close (GET);
}

$STUBS = 1;
$NOT_STUBS = 1;
getopts ('sn');
if ($opt_s)
{
  $NOT_STUBS = 0;
}
elsif ($opt_n)
{
  $STUBS = 0;
}
find (\&wanted, @ARGV);
