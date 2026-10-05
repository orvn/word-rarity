## Datasets

Last updated 2026-10-05. All datasets used are open source or public domain.

### enable1

> This is the primary dataset used

ENABLE (Enhanced North American Benchmark LExicon), first version

- Source: https://raw.githubusercontent.com/dolph/dictionary/master/enable1.txt
- Format: one lowercase ascii word per line, no header
- Lines: 172,823
- Notes: Scrabble-style lexicon, no proper nouns, no capitalization, no punctuation.

### words_alpha

dwyl/english-words, alphabetic-only list

- Source: https://raw.githubusercontent.com/dwyl/english-words/master/words_alpha.txt
- Format: one lowercase ascii word per line, no header
- Lines: 370,105
- Notes: largest list, but known to be noisy (abbreviations, non-words, odd sort order).

### scowl80

SCOWL English Speller Database

- Source: http://app.aspell.net/create with parameters
- Format: one word per line, no header
- Lines: 253,025
- Notes: mixed case (41,713 capitalized entries, proper nouns and acronyms), 23,130 entries contain an apostrophe (possessives, contractions). Spelling US + GB (-ise and -ize) + CA + AU, variant level 2, diacritics stripped, special lists: hacker.
