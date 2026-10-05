#!/usr/bin/env perl

# Filter: perl filter-ngrams.pl wordlist.txt < shard.tsv
# keeps untagged ngram lines whose lowercased token is in the wordlist,
# rewrites the token to lowercase so case variants share a key

# Merge: perl filter-ngrams.pl --merge < sorted.tsv
# sums match_count and volume_count per year for runs of identical keys

use strict;
use warnings;

if (@ARGV && $ARGV[0] eq '--merge') {
  merge();
} elsif (@ARGV == 1) {
  filter($ARGV[0]);
} else {
  die "usage: $0 wordlist.txt | $0 --merge\n";
}

sub filter {
  my ($path) = @_;
  open my $fh, '<', $path or die "cannot open $path: $!\n";
  my %words;
  while (<$fh>) { chomp; $words{$_} = 1 }
  close $fh;

  while (my $line = <STDIN>) {
    my $tab = index $line, "\t";
    next if $tab < 0;
    my $key = substr $line, 0, $tab;
    next unless $key =~ /^[A-Za-z]+$/;
    my $lc = lc $key;
    next unless $words{$lc};
    print $lc, substr $line, $tab;
  }
}

sub merge {
  my ($cur, %match, %vol);
  my $flush = sub {
    print join("\t", $cur, map { "$_,$match{$_},$vol{$_}" } sort { $a <=> $b } keys %match), "\n";
    %match = ();
    %vol = ();
  };
  while (my $line = <STDIN>) {
    chomp $line;
    my @f = split /\t/, $line;
    my $key = shift @f;
    $flush->() if defined $cur && $key ne $cur;
    $cur = $key;
    for (@f) {
      my ($y, $m, $v) = split /,/;
      $match{$y} += $m;
      $vol{$y} += $v;
    }
  }
  $flush->() if defined $cur;
}
