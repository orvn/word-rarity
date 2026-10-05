#!/usr/bin/env perl
# chunks 1grams into 16MiB

use strict;
use warnings;
use FindBin;

my $ngrams_dir = "$FindBin::Bin/../raw/ngrams";
my $src = "$ngrams_dir/1grams.tsv";
my $out_dir = "$ngrams_dir/chunked1grams";
my $max = $ENV{CHUNK_BYTES} || 16_777_216;

mkdir $out_dir unless -d $out_dir;
unlink glob "$out_dir/1grams-*.tsv";

open my $in, '<', $src or die "cannot open $src: $!\n";
my ($n, $bytes, $out) = (-1, $max + 1, undef);
while (my $line = <$in>) {
  my $len = length $line;
  if ($bytes + $len > $max) {
    close $out if $out;
    $n++;
    my $path = sprintf "%s/1grams-%02d.tsv", $out_dir, $n;
    open $out, '>', $path or die "cannot write $path: $!\n";
    $bytes = 0;
  }
  print $out $line;
  $bytes += $len;
}
close $out if $out;
close $in;
printf "%d chunks of at most %d bytes written to %s\n", $n + 1, $max, $out_dir;
