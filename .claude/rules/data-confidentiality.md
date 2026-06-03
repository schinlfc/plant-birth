# Data Confidentiality (Texas vital records)

**This project uses confidential Texas birth and fetal-death microdata geocoded to census tract.** Treat it as protected at all times. This rule is always-on (no `paths:` frontmatter) — it loads every session.

## Hard rules

1. **Never commit raw microdata.** `birth/`, `earth_justic_data_codes/`, and all data file types (`*.dta/.dbf/.csv/.xls*/.zip/.gph/.smcl`) are git-ignored. Never `git add -f` them. Before any commit, confirm `git status` shows no data files.
2. **Never echo identifiers.** Do not paste record-level values, tract IDs / FIPS, birth lat-long, or any individual-level row into committed files, the manuscript, logs, session notes, plans, commit messages, or any chat-persisted artifact.
3. **Commit only estimates and aggregates.** Regression output, event-study coefficients, and aggregated summary statistics are fine. Per the Texas DSHS data-use agreement there is **no fixed small-cell suppression threshold**; still avoid publishing counts so small they could identify individuals — aggregate or omit when in doubt.
4. **Logs are data-adjacent.** Stata/R logs can contain raw values (`list`, `browse`, dumped observations). Keep logs in git-ignored `_outputs/`; never commit a log that printed microdata. Avoid `list`/`browse` of identifiers in committed `.do`/`.R`.
5. **Inputs are read-only.** Do not modify, move, or delete files under `birth/`. Derive cleaned analysis files into git-ignored `_outputs/`.

## When unsure

If a task would put microdata or identifiers into a tracked file, **stop and ask Sayorn** rather than guessing.

## Cross-references

- `CLAUDE.md` — Core Principles (Confidentiality) + Data & Confidentiality table.
- `.gitignore` — confidential-data section.
- `.claude/rules/stata-code-conventions.md` — `_outputs/` log discipline.
