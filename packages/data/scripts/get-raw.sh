#!/usr/bin/env bash
#
# downloads or updates word lists into packages/data/raw

set -euo pipefail

raw_dir="$(cd "$(dirname "$0")/../raw" && pwd)"
readme="$raw_dir/readme.md"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

enable1_url="https://raw.githubusercontent.com/dolph/dictionary/master/enable1.txt"
words_alpha_url="https://raw.githubusercontent.com/dwyl/english-words/master/words_alpha.txt"
scowl80_url="http://app.aspell.net/create?max_size=80&spelling=US&spelling=GBs&spelling=GBz&spelling=CA&spelling=AU&max_variant=2&diacritic=strip&special=hacker&download=wordlist&encoding=utf-8&format=inline"

fetch() {
  echo "fetching $1"
  curl -fsSL --retry 3 "$2" -o "$tmp/$1"
}

fetch enable1.txt "$enable1_url"
fetch words_alpha.txt "$words_alpha_url"
fetch scowl80.txt "$scowl80_url"

# normalize to unix line endings
for f in enable1 words_alpha scowl80; do
  tr -d '\r' < "$tmp/$f.txt" > "$tmp/$f.clean"
done

sep="$(grep -n -m1 '^---$' "$tmp/scowl80.clean" | cut -d: -f1)"
if [[ -z "$sep" ]]; then
  echo "scowl80: could not find header separator, aborting" >&2
  exit 1
fi
tail -n +"$((sep + 1))" "$tmp/scowl80.clean" > "$tmp/scowl80.words"
mv "$tmp/scowl80.words" "$tmp/scowl80.clean"

for f in enable1 words_alpha scowl80; do
  mv "$tmp/$f.clean" "$raw_dir/$f.txt"
  printf '%-16s %s lines\n' "$f.txt" "$(wc -l < "$raw_dir/$f.txt" | tr -d ' ')"
done

today="$(date +%Y-%m-%d)"
perl -pi -e 's/^Last updated \d{4}-\d{2}-\d{2}\./Last updated '"$today"'./' "$readme"
echo "readme last updated set to $today"
