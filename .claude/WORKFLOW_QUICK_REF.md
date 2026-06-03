# Workflow Quick Reference — Plant-Birth (Sayorn Chin)

**Model:** Contractor (you direct, Claude orchestrates). **Engine:** Stata-first (batch), R for figures.

---

## The Loop

```
Your instruction
    ↓
[PLAN] (if multi-file or unclear) → Show plan → Your approval
    ↓
[EXECUTE] Implement, run (Stata/R), read the log, verify outputs
    ↓
[REPORT] Concise summary + what's ready
    ↓
Repeat
```

---

## I Ask You When

- **Design forks:** estimator choice, clustering level, sample/exclusion rules, distance bands, outcome set.
- **Code ambiguity:** a variable's meaning is unclear in the dictionary or legacy `.do`.
- **Replication edge case:** results don't reconcile with the legacy pipeline or expected sign/magnitude.
- **Confidentiality judgment:** anything that might put microdata/identifiers into a tracked file.
- **Early sessions:** while we're still building the workflow muscle, I check in **more often** at natural milestones — you asked for this. I'll dial back to full autonomy once you say the rhythm is right.

## I Just Execute When

- Code fix is obvious (bug, pattern application, convention compliance).
- Verification (run the `.do`/`.R`, read the log, confirm outputs exist and look sane).
- Documentation (session logs, plan updates).
- Figures/tables per established standards.
- Anything inside an already-approved plan that hits no fork above.

---

## Quality Gates (advisory; enforced in /commit)

| Score | Action |
|-------|--------|
| ≥ 80 | Ready to commit |
| < 80 | Fix blocking issues |

---

## Non-Negotiables

- **Confidentiality:** raw Texas microdata is never committed; no tract/individual identifiers in any tracked file or log. See `.claude/rules/data-confidentiality.md`. *(Hard rule, not a preference.)*
- **Stata reproducibility:** every `.do` is runnable clean — `version`, `clear all`, `set seed 12345`, `set sortseed 12345`, `log using …_outputs/`. Run via `"$STATA" -b do …` where `STATA=/Applications/StataNow/StataSE.app/Contents/MacOS/stata-se`.
- **Numbers come from code:** tables via `esttab` → `scripts/stata/_outputs/*.tex`, `\input{}` into the manuscript. Never hand-type a coefficient/SE/N.
- **Staggered DiD discipline:** under staggered timing use heterogeneity-robust estimators (CS / SA / dCDH / Borusyak); TWFE only as a labeled benchmark; always show pre-trends.
- **Figure standards:** white background, vector **PDF** for the paper + **PNG** for slides; readable fonts; no chart-junk.
- **Significance convention:** `* .10 ** .05 *** .01`, stated in table notes (AEA journals: no stars — switch when targeting AER/AEJ).
- **Replication tolerance:** reported estimates reproduce to ~1e-3 (flag near-misses rather than silently rounding).

---

## Preferences

**Working style:** structured, precise, rigorous — depth over speed.
**Reporting:** concise bullets; full detail on request. Lead with what changed and what's verified.
**Visual:** publication-ready always; show me the rendered figure/table, not just the code.
**Session logs:** always (post-plan, incremental, end-of-session).
**Replication:** strict; flag any near-miss against the legacy pipeline or literature priors.
**Memory:** when corrected, save a `[LEARN]` entry so I don't repeat it.

---

## Exploration Mode

For experimental work, use **Fast-Track** in `explorations/` (60/100 threshold, no full plan — just a 2-min value check). See `.claude/rules/exploration-fast-track.md`.

---

## Next Step

You provide task → I plan (if needed) → your approval → execute + verify → done.
