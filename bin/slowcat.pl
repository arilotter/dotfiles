#!/bin/sh
exec ${PERL-perl} -wSx $0 ${1+"$@"}
#!perl

# slowcat --- write output slowly, emulating physical serial terminal

# Author: Noah Friedman <friedman@splode.com>
# Created: 2003-01-01
# Public domain

# $Id: slowcat,v 2.2 2003/05/13 10:27:27 friedman Exp $

# Commentary:
# Code:

use 5.003;
use strict;
use Getopt::Long;
use Symbol;

(my $progname = $0) =~ s|.*/||;

my $bits_per_sec  = 9600;
# Due to HZ resolution in most kernels, it is unlikely that select will
# return in a shorter period of time than 10ms.
my $usec_interval_min = 10000;
my $usec_interval = $usec_interval_min;

sub slowcat ($$$)
{
  my ($fh, $bits_per_sec, $usec_interval) = @_;
  $usec_interval = $usec_interval_min if $usec_interval < $usec_interval_min;

  my $bytes_per_sec = $bits_per_sec / 8;
  my $bytes_per_call = 0;
  my $sleep_interval;

  while ($bytes_per_call < 1
         || ($bytes_per_call - int ($bytes_per_call) >= .009))
    {
      $sleep_interval = $usec_interval++ / 1000000;
      $bytes_per_call = $bytes_per_sec * $sleep_interval;
    }
  $bytes_per_call = int ($bytes_per_call);

  while (sysread ($fh, $_, $bytes_per_call))
    {
      syswrite (STDOUT, $_, $bytes_per_call);
      select (undef, undef, undef, $sleep_interval);
    }
}

sub usage (@)
{
  print STDERR "$progname: @_\n\n" if @_;
  print STDERR "Usage: $progname {options} {files}\n
Options are:
-h, --help                   You're looking at it.
-b, --bps             BPS    Output BPS bits per second.
-i, --sleep-interval  USEC   Use USEC microseconds of granularity between
                             writes.\n";
  exit (1);
}

sub main ()
{
  Getopt::Long::config ('bundling', 'autoabbrev');
  GetOptions ("h|help",             sub { usage () },
              "b|bps=i",            \$bits_per_sec,
              "i|sleep-interval=i", \$usec_interval);

  unless (@ARGV)
    {
      slowcat (*STDIN{IO}, $bits_per_sec, $usec_interval);
      exit (0);
    }

  my $fh = gensym;
  while (@ARGV)
    {
      my $filename = shift @ARGV;
      sysopen ($fh, $filename, 0) || die "$filename: $!";
      slowcat ($fh, $bits_per_sec, $usec_interval);
      close ($fh);
    }
  exit (0);
}

main ();

# local variables:
# mode: perl
# end:

# slowcat ends here


