# @word-rarity/db

SQLite mirror of `packages/data/raw/ngrams`, the production source of truth for word frequency over time

## Build

```sh
bun run --filter @word-rarity/db build
```

Writes `word-rarity.sqlite` (gitignored) from `1grams.tsv` and `corpus-totals.tsv`. Run `fetch-ngrams` in `@word-rarity/data` first

## Schema

- `words`: `id`, `word`
- `word_years`: `word_id`, `year`, `match_count`, `volume_count`, one row per word per year it was printed
- `corpus_totals`: `year`, `match_count`, `page_count`, `volume_count`, whole-corpus totals per year
- `meta`: `key`, `value`, source and build time
- `word_frequency` (view): `word`, `year`, `match_count`, `volume_count`, `frequency`, where frequency is the word's share of all 1-grams that year

```sql
select year, frequency from word_frequency where word = 'epidemic' and year between 1900 and 2019
```
