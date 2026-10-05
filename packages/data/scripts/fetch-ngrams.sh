#!/usr/bin/env bash
# Streams Google ngram v3 english 1-gram export against enable1 words, normalizes case
# JOBS=n for parallel streams (default 3)

set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
data_dir="$(cd "$script_dir/.." && pwd)"
raw_dir="$data_dir/raw"
out_dir="$raw_dir/ngrams"
cache_dir="$data_dir/.cache/ngrams"
wordlist="$raw_dir/enable1.txt"
filter="$script_dir/filter-ngrams.pl"
base_url="https://storage.googleapis.com/books/ngrams/books/20200217/eng"
shards="${SHARDS:-$(seq -w 0 23)}"
jobs="${JOBS:-3}"

mkdir -p "$out_dir" "$cache_dir"

fetch_shard() {
  local n="$1" out="$cache_dir/shard-$1.tsv"
  if [[ -f "$out" ]]; then
    echo "shard $n cached"
    return
  fi
  echo "shard $n streaming"
  curl -fsSL --retry 3 "$base_url/1-000$n-of-00024.gz" | gzip -dc | perl "$filter" "$wordlist" > "$out.part"
  mv "$out.part" "$out"
  echo "shard $n done, $(wc -l < "$out" | tr -d ' ') matching lines"
}
export -f fetch_shard
export cache_dir base_url filter wordlist

printf '%s\n' $shards | xargs -P "$jobs" -I{} bash -c 'set -euo pipefail; fetch_shard "$1"' _ {}

cached="$(ls "$cache_dir"/shard-*.tsv | wc -l | tr -d ' ')"
if [[ "$cached" -lt 24 ]]; then
  echo "warning: only $cached of 24 shards cached, output will be partial"
fi

out="$out_dir/1grams.tsv"
echo "merging $cached shards"
cat "$cache_dir"/shard-*.tsv | LC_ALL=C sort -t "$(printf '\t')" -k1,1 | perl "$filter" --merge > "$out.part"
mv "$out.part" "$out"

echo "fetching totalcounts-1"
curl -fsSL --retry 3 "$base_url/totalcounts-1" | tr '\t' '\n' | tr ',' '\t' | grep -v '^[[:space:]]*$' > "$out_dir/corpus-totals.tsv"

found="$(wc -l < "$out" | tr -d ' ')"
total="$(wc -l < "$wordlist" | tr -d ' ')"
echo "$out: $found of $total enable1 words found, $(du -h "$out" | cut -f1)"
