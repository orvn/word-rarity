#!/usr/bin/env perl
# Reads 1grams, writes words (id, word), streams word_years rows (word_id, year, match, volume) to stdout

use strict;
use warnings;

my ($words_path) = @ARGV or die "usage: $0 words.tsv < 1grams.tsv\n";
open my $words, '>', $words_path or die "cannot write $words_path: $!\n";

my $id = 0;
while (my $line = <STDIN>) {
  chomp $line;
  my @f = split /\t/, $line;
  my $word = shift @f;
  $id++;
  print $words "$id\t$word\n";
  for (@f) {
    my ($y, $m, $v) = split /,/;
    print "$id\t$y\t$m\t$v\n";
  }
}
close $words;
