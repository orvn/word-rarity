CREATE TABLE words (
  id INTEGER PRIMARY KEY,
  word TEXT NOT NULL UNIQUE
);

CREATE TABLE word_years (
  word_id INTEGER NOT NULL REFERENCES words(id),
  year INTEGER NOT NULL,
  match_count INTEGER NOT NULL,
  volume_count INTEGER NOT NULL,
  PRIMARY KEY (word_id, year)
) WITHOUT ROWID;

CREATE TABLE corpus_totals (
  year INTEGER PRIMARY KEY,
  match_count INTEGER NOT NULL,
  page_count INTEGER NOT NULL,
  volume_count INTEGER NOT NULL
);

CREATE TABLE meta (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

-- relative frequency per word per year
CREATE VIEW word_frequency AS
SELECT w.word, wy.year, wy.match_count, wy.volume_count,
  wy.match_count * 1.0 / ct.match_count AS frequency
FROM word_years wy
JOIN words w ON w.id = wy.word_id
JOIN corpus_totals ct ON ct.year = wy.year;
