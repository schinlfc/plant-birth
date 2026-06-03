# Decommissioning Coal-Fired Power Plants and Infant Health in Texas

Author: **Sayorn Chin** · Department of Economics, Lafayette College, Easton, PA

A manuscript (health / environmental economics) that exploits the **staggered
decommissioning of coal-fired power plants** as a natural experiment to estimate
effects on **infant-health outcomes** (birth weight, low birth weight, gestation,
fetal death) in Texas. Decommissioning reduces **ambient air pollution** at nearby
EPA monitors (lead in hand; ozone / PM / SO₂ / NOₓ to be added); we trace that
change through to infant health using confidential, census-tract-geocoded Texas
birth and fetal-death records. Identification: staggered DiD / event study with
heterogeneity-robust estimators.

> **This repository builds on the consulting deliverable** in
> `earth_justic_data_codes/` (Mountain Data Group, EarthJustice, 2021 — lead → IQ
> → earnings) and repurposes its plant-capacity / pollution pipeline for a new
> infant-health research question.

## ⚠️ Data confidentiality

The Texas birth and fetal-death microdata (`birth/`) are **confidential and
geocoded to census tract**. All raw data is **git-ignored and never committed**.
Only code and aggregated, non-identifying results live in version control. See
[`.claude/rules/data-confidentiality.md`](.claude/rules/data-confidentiality.md)
and `CLAUDE.md`.

## Reproduce

Analysis is **Stata-first** (StataNow/SE 19.5), run in batch:

```bash
STATA=/Applications/StataNow/StataSE.app/Contents/MacOS/stata-se
"$STATA" -b do scripts/stata/99_run_all.do      # from the repo root
```

Outputs land in `scripts/stata/_outputs/` (git-ignored logs/data; tables as `.tex`,
figures as `.pdf`/`.png`). R is used for selected figures (`scripts/R/`).

## Repository map

| Path | Contents |
|------|----------|
| `scripts/stata/` | Numbered pipeline `00_install` → `99_run_all`; `_outputs/`; `legacy/` (2021 `.do`) |
| `scripts/R/` | Figures, maps, event-study plots (secondary) |
| `manuscript/` | Paper `.tex` (tables/figures pulled in via `\input{}` / `\includegraphics{}`) |
| `birth/` | **Confidential** TX birth + fetal-death microdata (git-ignored) |
| `earth_justic_data_codes/` | EIA/EPA plant + pollution data, legacy code, 2021 draft (data git-ignored) |
| `Bibliography_base.bib` | Centralized bibliography |
| `Slides/` | Beamer decks (incl. 2021 reference draft) |
| `.claude/`, `CLAUDE.md`, `MEMORY.md` | Claude Code academic workflow (rules, skills, agents, memory) |
| `quality_reports/` | Plans, specs, session logs, decisions |

## Workflow

This repo uses the Claude Code academic workflow (forked from
`pedrohcgs/claude-code-my-workflow`, adapted for this project). See `CLAUDE.md`
and `.claude/WORKFLOW_QUICK_REF.md`.

## Status

Early setup. Stata pipeline is a runnable skeleton (no analysis yet); manuscript
not started. See `quality_reports/plans/` for the current plan.
