---
paths:
  - "manuscript/**/*.tex"
  - "scripts/stata/**/*.do"
  - "scripts/R/**/*.R"
  - "Slides/**/*.tex"
  - "Quarto/**/*.qmd"
---

# Project Knowledge Base: Decommissioning Coal-Fired Power Plants & Infant Health in Texas

<!-- Claude reads this before writing analysis code or manuscript content. Keep it current. -->

## Status & Headline Finding (2026-06-04)

**Design evolved:** decommissioning (out of window) → **CAIR-era pollution-control RETROFITS** (in window).
**Result:** robust, well-identified **null co-benefit**. The causal chain is strong at link 1 and broken at link 2:
1. retrofit → plant SO₂/NOₓ emissions: **STRONG** (EPA CEMS, verified).
2. coal-emissions exposure → **local ambient pollution**: **≈ ZERO** (PM₂.₅ F=0.25; SO₂ p=0.97; lead p=0.06 weak/10-cluster).
3. ambient → infant health: mean birthweight precise null; general PM₂.₅ borderline on LBW (p=0.065) / fetal death (p=0.10), **not coal-attributable**.
Mechanism: coal SO₂/NOₓ → regional secondary PM (not local primary); low ambient SO₂/lead. Manuscript scaffolded (`manuscript/main.tex`).

## Research Design

- **Question:** Do coal-plant **pollution-control retrofits** improve infant health in Texas (intent-to-treat)?
- **Treatment:** staggered CAIR-era control retrofits (FGD/SCR/SNCR/baghouse/ACI), 12 TX coal plants, 2003–2010 (wave 2008–10); CEMS-verified emission drops.
- **Mechanism / exposure:** ambient pollution at EPA monitors — PM₂.₅ (88101), SO₂ (42401), lead (repo); pregnancy-window (trailing 9-mo) mean at nearest monitor; coal-attributed via inverse-distance CEMS emissions.
- **Outcomes:** birth weight (`b_wt_gr`), LBW (<2500g), fetal-death rate (ZIP×year, from `Fet*.dbf`). NO gestation/preterm var in the birth file.
- **Population:** TX live births 2005–2010 (`birth/combined_birth_data.dta`, live births only; 2003–04 too sparse); fetal deaths from `birth/Fet*.dbf` (`F_RZIP`).
- **Identification:** tract (or ZIP) + birth-year-month FE; cluster by monitor; CS/SA event study + continuous exposure + 2SLS (PM₂.₅/SO₂ instrumented by coal emissions). Pipeline: `scripts/stata/01–09`.

## Variable / Estimand Registry

| Concept | Definition | Source | Notes |
|---|---|---|---|
| Treatment timing | first month capacity → 0 (or large drop) | EIA generators | per plant; staggered |
| `capacity_on` | 1 if plant operating capacity > 0 | EIA | legacy .do var |
| `plant_capacity` | nameplate MW online, plant × month | EIA | legacy .do var |
| `distance` | km, birth tract centroid (or monitor) ↔ plant | computed | bands ≤3/5/10 |
| ambient Pb | daily arithmetic mean Pb at monitor | EPA AQS/IMPROVE | `arithmeticmean` in legacy .do |
| birthweight | grams | TX birth records | outcome |
| LBW | 1 if birthweight < 2500 g | derived | outcome |
| gestation | completed weeks | TX birth records | outcome |
| fetal death | 1 if fetal-death record | TX fetal records | outcome |

## Data Sources

| Dataset | Files | Notes |
|---|---|---|
| TX birth 2003–2007 | `birth/Bir200{3..7}.dbf` | confidential, geocoded |
| TX birth 2008–2010 | `birth/Birth2008_2010.dta` | confidential |
| TX fetal death 2003–2010 | `birth/Fet20{03..10}.dbf` | confidential |
| Dictionaries | `birth/*Dictionary*.xls`, `birth/DataDictionary_*.xls` | pre-2005 vs 2005+ schemas differ |
| EIA generators / capacity | `earth_justic_data_codes/{retired,operational,*plant_capacity*}.dta` | treatment |
| EPA Pb (AQS) | `earth_justic_data_codes/daily_LEAD_{1990..2021}.csv` | exposure |
| EPA Pb (IMPROVE) | `earth_justic_data_codes/lead_improve.*` | exposure |
| Monitor↔plant distance | `earth_justic_data_codes/monitor_plant_distances_unique*.csv` | matching |
| Legacy assembly | `scripts/stata/legacy/Assemble_7_28_2021.do` | reference pipeline |

## Identification Threats & Checks

| Threat | Check |
|---|---|
| Heterogeneous/dynamic effects under staggered timing | use CS / SA / dCDH; report event-study pre-trends; avoid forbidden comparisons (Goodman-Bacon 2021) |
| Parallel-trends violation | pre-period event-study coefficients ≈ 0 |
| SUTVA / spillovers | tracts near multiple plants; pollution drift; define a clean control distance |
| Selective migration / fertility | test for composition changes (maternal characteristics) around events |
| Exposure misattribution | monitor Pb may reflect other sources; use distance × capacity dose-response |
| Multiple outcomes | correct for MHT across the outcome family |
| Confidentiality | never report tract-level cells or identifiers; estimates/aggregates only |

## Stata Pitfalls (project)

| Bug | Fix |
|---|---|
| `.dbf` import | use `import dbase` (Stata 16+) or convert; verify encoding & field names vs dictionary |
| `recode arithmeticmean (-999=.)` | EPA missing/sentinel codes vary by file — verify per source |
| `merge m:1 plantid year_month` | `assert()` the match; legacy .do drops `_merge==1|2` — document why |
| StataSE matrix/variable limits | high-dimensional FE: prefer `reghdfe` over `areg`/`xi:` |

## Conventions

- Stata is **primary**; R **secondary** (figures / event-study plots). Tables via `esttab` → `scripts/stata/_outputs/*.tex`.
- AEA significance convention `* .10 ** .05 *** .01`; document in table notes.
- Cluster at the treatment-assignment level (plant, or county/tract per design — decide and document).
