#!/usr/bin/env perl

# Public Domain

use warnings;
use strict;

use File::Find;
use Cwd;
use Statistics::Basic qw(:all nofill);
use Carp;
use Encode::Guess;

my %drive_data;

sub analyze_log {
  my $fh = shift;
  my $drive;
  my $readmode;
  my $num_speeds = 0;
  my $speed_sum  = 0;
  while (<$fh>) {
    if (/^Used drive\s+:/) {
      my @toks = split /\s+/;
      $drive = join( ' ', @toks[ 3 .. (@toks - 5) ] );
    }
    elsif (/^Read mode\s+:/) {
      my @toks = split /\s+/;
      $readmode = $toks[3];
    }
    elsif (/^\s{5}Extraction speed/) {
      ++$num_speeds;
      my @toks = split /\s+/;
      $speed_sum += $toks[3];
    }
  }
  return if $num_speeds == 0 or $readmode ne 'Secure';

  my $d = ( $drive_data{$drive} = ( $drive_data{$drive} // [] ) );
  push @{$d}, ( $speed_sum / $num_speeds );
  return;
}

sub get_log_encoding {
  open( my $fh, '<', shift);
  my $line = <$fh>;
  my $rv;
  $rv = 'UTF-16LE' if $line =~ /\xff\xfe\x45\x00\x78\x00\x61\x00/;
  $rv = 'iso-8859-1' if $line =~ /\x45\x41\x43/ or $line =~ /\x45\x78\x61/;
  close($fh);
  return $rv;
}

sub open_log {
  my $filename = shift;
  my $openmode = get_log_encoding($filename);
  print STDERR $File::Find::name . "\n" if not defined $openmode;
  return if not defined $openmode;
  open( my $fh, "<:encoding(${openmode})", $filename )
    or croak "Cannot open $filename : $!";
  analyze_log($fh);
  close($fh);
  return;
}

find(
  sub {
    open_log($_) if /\.log$/;
  }, @ARGV == 0 ? getcwd() : @ARGV );

for my $drive ( sort { @{$drive_data{$b}} <=> @{$drive_data{$a}} } ( keys(%drive_data) ) ) {
  my $speeds = $drive_data{$drive};
  printf(
    "${drive} : %.1f X (%d rips, stddev = %.1f X)\n",
    mean( @{$speeds} ),
    scalar( @{$speeds} ),
    stddev( @{$speeds} )
  );
}
