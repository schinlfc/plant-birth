# CLAUDE.MD -- Decommissioning Coal-Fired Power Plants & Infant Health in Texas

**Project:** Decommissioning Coal-Fired Power Plants and Infant Health in Texas (manuscript)
**Author:** Sayorn Chin
**Institution:** Department of Economics, Lafayette College, Easton, PA
**Audience:** Health / environmental economics
**Branch:** main

---

## Core Principles

- **Plan first** -- enter plan mode before non-trivial tasks; save plans to `quality_reports/plans/`
- **Verify after** -- run the code (Stata batch / R), check the log + outputs at the end of every task
- **Confidentiality is non-negotiable** -- raw Texas vital-records microdata is never committed; tract-level or individual identifiers are never echoed into committed files, logs, tables, or session notes. Commit only model estimates and aggregated, non-identifying results. See [`.claude/rules/data-confidentiality.md`](.claude/rules/data-confidentiality.md).
- **Single source of truth for numbers** -- Stata `_outputs/` tables (`esttab` → `.tex`) and figures (`.pdf`/`.png`) are authoritative; the manuscript `\input{}`/`\includegraphics{}` them. Never hand-type a coefficient, SE, or N into the paper.
- **Quality gates** -- nothing ships below 80/100 (advisory; enforced inside `/commit`)
- **[LEARN] tags** -- when corrected, append `[LEARN:category] wrong → right` to [MEMORY.md](MEMORY.md)

Cross-session context lives in [MEMORY.md](MEMORY.md); plans, specs, and session logs are in [quality_reports/](quality_reports/).

---

## Empirical Design (one-liner)

Staggered **decommissioning of coal-fired generators** (EIA nameplate capacity → 0) as a natural experiment → change in **ambient air pollution** at nearby EPA monitors (criteria pollutants — e.g. ozone, PM, SO₂/NOₓ — and heavy metals such as lead; the specific pollutant set is being finalized) → effect on **infant-health outcomes** (birth weight, low birth weight, gestation, fetal death) for Texas births near plants. Exposure proxied by plant capacity × distance bands (≤3/5/10 km). Identification: **staggered DiD / event study** with modern estimators (robust to heterogeneous, dynamic treatment effects).

---

## Folder Structure

```
plant-birth/
├── CLAUDE.md                     # This file
├── .claude/                      # Rules, skills, agents, hooks, settings
├── README.md                     # Project overview + reproduction instructions
├── Bibliography_base.bib         # Centralized bibliography
├── birth/                        # CONFIDENTIAL Texas birth/fetal-death microdata (git-ignored)
├── earth_justic_data_codes/      # EIA/EPA pollution + plant data + legacy 2021 .do (data git-ignored)
├── scripts/
│   ├── stata/                    # PRIMARY: numbered .do pipeline (00_install … 99_run_all) + _outputs/
│   └── R/                        # SECONDARY: figures, maps, event-study plots
├── manuscript/                   # Paper .tex; \input{} tables + \includegraphics{} figures
├── Slides/                       # Beamer decks (e.g., 2021 reference draft)
├── Preambles/header.tex          # LaTeX headers
├── Figures/                      # Aggregated, non-identifying figures
├── quality_reports/              # Plans, specs, session logs, decisions
├── explorations/                 # Research sandbox (see rules)
└── templates/                    # Session log, quality report, spec templates
```

---

## Commands

```bash
# Stata — PRIMARY analysis engine (batch mode; logs are read back to verify)
STATA=/Applications/StataNow/StataSE.app/Contents/MacOS/stata-se
"$STATA" -b do scripts/stata/99_run_all.do      # one-command full reproduction
# Run from repo root. A single .do: "$STATA" -b do scripts/stata/01_clean.do

# R — SECONDARY (figures / event-study plots)
Rscript scripts/R/05_figures.R

# Manuscript build (XeLaTeX)
cd manuscript && latexmk -xelatex main.tex      # or 3-pass xelatex + bibtex

# Reproducibility audit: numeric claims in paper ↔ Stata outputs
# (skill) /audit-reproducibility manuscript/main.tex scripts/stata/_outputs/

# Quality score on a draft
python scripts/quality_score.py manuscript/main.tex

# Environment check
./scripts/validate-setup.sh
```

---

## Data & Confidentiality

| Source | Location | Use |
| --- | --- | --- |
| Texas birth records 2003–2010 (geocoded, **confidential**) | `birth/Bir200*.dbf`, `birth/Birth2008_2010.dta` | Infant-health outcomes |
| Texas fetal-death records 2003–2010 (**confidential**) | `birth/Fet200*.dbf` | Fetal-death outcome |
| Data dictionaries | `birth/*.xls` | Variable definitions |
| EIA generators / plant capacity | `earth_justic_data_codes/*.dta` | Treatment (decommissioning, capacity) |
| EPA AQS + IMPROVE ambient air pollution | `earth_justic_data_codes/daily_LEAD_*.csv`, `lead_improve.*` (lead now; cadmium/arsenic present; ozone/PM/SO₂/NOₓ to be added) | Exposure (ambient pollution) |
| Monitor↔plant distances | `earth_justic_data_codes/monitor_plant_distances_unique*.csv` | Distance bands |

All raw data is **git-ignored** and treated as read-only input. Never `git add` data; never paste record-level values or tract identifiers into any committed artifact.

---

## Quality Thresholds (advisory)

| Score | Checkpoint | Meaning |
|-------|------------|---------|
| 80 | Commit | Good enough to save |
| 90 | PR / submission-track | Ready to circulate |
| 95 | Excellence | Aspirational |

Enforced by `/commit` (halts + asks for override); no git pre-commit hook blocks a direct `git commit`.

---

## Skills Quick Reference (project-relevant subset)

| Command | What It Does |
|---------|-------------|
| `/stata-replication [paper-or-data]` | End-to-end Stata pipeline scaffold + execution |
| `/data-analysis [dataset]` | End-to-end R analysis (figures / supplementary) |
| `/audit-reproducibility [paper]` | Numeric claims ↔ Stata/R outputs, tolerance-checked |
| `/simulation-study [estimator+DGP]` | Monte Carlo for the DiD estimator (bias/RMSE/coverage) |
| `/lit-review [topic]` | Literature search + synthesis (BibTeX-ready) |
| `/research-ideation` · `/interview-me` | Frame / refine the research design |
| `/review-paper [file]` | Manuscript review (`--adversarial`, `--peer <journal>`) |
| `/seven-pass-review [file]` | Seven-pass adversarial manuscript review |
| `/verify-claims [file]` | Chain-of-Verification fact-check (forked verifier) |
| `/respond-to-referees` | R&R response-letter generator |
| `/humanize [file]` | Detect AI-voice tells (read-only) |
| `/validate-bib` | Cross-reference citations ↔ bibliography |
| `/compile-latex [file]` | 3-pass XeLaTeX + bibtex (manuscript or slides) |
| `/preregister [--style ...]` | Draft a preregistration from the research spec |
| `/commit [msg]` | Stage, commit, PR, merge (never stages data) |
| `/checkpoint` · `/context-status` | Session handoff + health |

Slide skills (`/translate-to-quarto`, `/slide-excellence`, `/extract-tikz`, `/new-diagram`, …) remain available for the `Slides/` reference deck but are not central to the manuscript.

---

## Manuscript State

| Component | File | Status |
| --- | --- | --- |
| Manuscript | `manuscript/main.tex` | Not started |
| Stata pipeline | `scripts/stata/` | Skeleton (00–99) |
| 2021 reference draft (consulting) | `earth_justic_data_codes/decommissioning_coal-fired_power_plants.pdf` | Legacy DRAFT (Pb→IQ→earnings) |
| Legacy assembly code | `scripts/stata/legacy/Assemble_7_28_2021.do` | Reference only |
