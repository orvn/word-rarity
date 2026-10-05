#!/usr/bin/env bash
#
# Builds word-rarity.sqlite ngram chunks
# Warning: replaces existing db!
# Takes ~2min for ~37M year rows

set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
db_dir="$(cd "$script_dir/.." && pwd)"
ngrams_dir="$(cd "$db_dir/../data/raw/ngrams" && pwd)"
db="$db_dir/word-rarity.sqlite"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for f in 1grams.tsv corpus-totals.tsv; do
  [[ -f "$ngrams_dir/$f" ]] || { echo "missing $ngrams_dir/$f, run fetch-ngrams first" >&2; exit 1; }
done

rm -f "$db" "$db-journal"
sqlite3 "$db" < "$db_dir/schema.sql"

echo "importing word_years"
perl "$script_dir/explode.pl" "$tmp/words.tsv" < "$ngrams_dir/1grams.tsv" \
  | sqlite3 -cmd ".mode tabs" -cmd ".output /dev/null" -cmd "pragma journal_mode = off" -cmd ".output stdout" -cmd "pragma synchronous = off" "$db" ".import /dev/stdin word_years"

echo "importing words and corpus_totals"
sqlite3 -cmd ".mode tabs" "$db" ".import $tmp/words.tsv words" ".import $ngrams_dir/corpus-totals.tsv corpus_totals"

sqlite3 "$db" <<SQL
INSERT INTO meta VALUES
  ('source', 'Google Books Ngram v3 20200217, corpus eng, filtered to enable1'),
  ('built_at', strftime('%Y-%m-%dT%H:%M:%SZ', 'now'));
SQL

echo "optimizing"
sqlite3 "$db" "pragma optimize; vacuum"

sqlite3 "$db" "select 'words', count(*) from words union all select 'word_years', count(*) from word_years union all select 'corpus_totals', count(*) from corpus_totals"
echo "$db: $(du -h "$db" | cut -f1)"
