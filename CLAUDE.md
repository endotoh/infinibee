# Infinibee

A Spelling Bee word game clone, deployed as a static site on GitHub Pages.

## Architecture

Single-page static site. No framework, no bundler — just HTML/CSS/JS.

- `index.html` — the entire game (UI + logic)
- `words.js` — auto-generated dictionary data (do not edit by hand)
- `build.py` — processes `dictionary.txt` + `custom_words.txt` into `words.js`
- `dictionary.txt` — base word list (SCOWL size 60, American + British English)
- `custom_words.txt` — manually curated additions (linguistics, food, chess, medical, tech)
- `favicon.svg` — yellow hexagon favicon

## Game rules

- 7 letters in a honeycomb, one center letter (gold)
- Words must be 4+ letters, must include center letter, can reuse letters
- Scoring: 4-letter words = 1pt, longer = 1pt/letter, pangrams (all 7 letters) = +7 bonus
- Genius rank at 90% of max possible score
- Puzzles are seed-based and shareable via URL

## Build process

`python3 build.py` regenerates `words.js`. This must be run whenever `dictionary.txt` or `custom_words.txt` changes. The build:

1. Loads dictionary.txt (SCOWL-derived) and merges custom_words.txt
2. Filters to words that are lowercase, alpha, 4+ chars, max 7 unique letters
3. Pre-computes valid (letter set, center letter) puzzle pairs
4. Filters puzzles to max score <= 300 with at least one pangram and 2+ vowels
5. Outputs WORDS array and PUZZLES array as JS globals

## Updating vocabulary

1. Edit `custom_words.txt` (one word per line, `#` comments)
2. Run `make build` to regenerate `words.js`
3. Run `make publish` to build, commit, and push

## Key constraints

- words.js is committed (not gitignored) because GitHub Pages has no build step
- dictionary.txt is SCOWL at size 60 with American + British English
- Max puzzle score is capped at 300 to avoid pathological games
- localStorage persists game progress per seed for 24 hours
