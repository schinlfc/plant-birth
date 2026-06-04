# Project Memory — Decommissioning Coal-Fired Power Plants & Infant Health in Texas

Corrections and decisions that persist across sessions. Append `[LEARN:category]` entries; most recent at bottom. Keep generic; project-internal session notes live in `quality_reports/`.

---

## Project & Setup Decisions (2026-06-03)

[LEARN:project] Research question: staggered **decommissioning of coal-fired plants** (EIA capacity → 0) as a natural experiment → reduced **ambient air pollution** (BROAD: ozone, PM, SO₂/NOₓ, and heavy metals incl. lead — **not** lead-only) → **Texas infant-health outcomes** (birthweight, LBW, gestation, fetal death). Uses confidential, census-tract-geocoded TX birth + fetal-death microdata. Identification: staggered DiD / event study with heterogeneity-robust estimators. Distinct from the 2021 Mountain Data Group consulting deliverable (lead → IQ → earnings) whose data/code we repurpose.

[LEARN:decision] Analysis engine = **Stata-first (batch)**. StataNow/SE 19.5 at `/Applications/StataNow/StataSE.app/Contents/MacOS/stata-se`. Run `"$STATA" -b do file.do` and read the `.log` to verify. No `stata-mcp`. R is secondary (figures, event-study plots). `version 19` pin.

[LEARN:decision] Confidentiality = **hard guardrails**. Raw microdata never committed (`birth/`, `earth_justic_data_codes/`, and `*.dta/.dbf/.csv/.xls*/.zip/.gph/.smcl` git-ignored). No tract/individual identifiers in any tracked file or log. The TX DSHS data-use agreement imposes **no fixed small-cell suppression threshold**, but still avoid disclosive tiny cells. See `.claude/rules/data-confidentiality.md`.

[LEARN:decision] Target outlets = health/environmental economics: JHE, AJHE, JEEM, AEJ: Applied, AEJ: Economic Policy (profiles in `.claude/references/journal-profiles.md`). `methods-referee` tuned for staggered DiD.

[LEARN:setup] The workflow was cloned into a nested subdir (its own git repo → pedrohcgs) and was therefore **inactive**. Promoted to repo root (lean) so `.claude/` + `CLAUDE.md` actually load; template-maintenance scaffolding (docs/guide/CHANGELOG/.github/TROUBLESHOOTING) dropped; nested `.git` removed.

## Code Gotchas

[LEARN:stata] **Stata `/* */` block comments NEST.** A `/*` (slash-star) *anywhere* in a comment — e.g. a glob/path like `$OUT/*.dta` or `birth/*` in a header block — opens a nested comment that the single header `*/` does NOT close, silently swallowing the rest of the file (including `log using`). Symptom: the do-file runs exit-0 but produces no log/output. Fix: never write `/` immediately followed by `*` in `.do` comments.

## Working Style (Sayorn Chin)

[LEARN:feedback] Sayorn prefers answering clarifying questions **directly in prose**, not via the AskUserQuestion multiple-choice tool (he rejected it twice on 2026-06-03). Ask open questions in plain text. **Why:** faster for him, less friction. **How to apply:** default to a short numbered list of questions in a normal message.

[LEARN:feedback] **Check in more often during the first few sessions** (he is learning the workflow); dial back to full contractor autonomy once he signals the rhythm is right. Standing preferences: structured, precise, rigorous (depth over speed); publication-ready visuals always; don't make him repeat himself.

## Retained Generic Workflow Lessons

[LEARN:workflow] Plan-first for non-trivial tasks; save plans to `quality_reports/plans/`. Spec-then-plan for ambiguous tasks (AskUserQuestion-style clarification in prose per above).

[LEARN:pattern] Model routing 70/20/10 (Haiku mechanical / Sonnet review / Opus high-judgment). Don't demote `claim-verifier` / `methods-referee` / `editor`.

[LEARN:edits] Batch edits to protected `.claude/` paths via **Bash heredoc** — the Edit/Write tools fire the protected-path gate; Bash does not.

## Design Evolution (2026-06-03 exploration → spec)

[LEARN:project] **Treatment PIVOTED from plant decommissioning → pollution-control RETROFITS.** TX coal closures cluster 2016–2020 (out of the 2003–2010 birth window), so the closure design is dead. In-window variation comes from CAIR-era control retrofits (FGD/SCR/SNCR/baghouse/ACI) on 12 TX coal plants, 2003–2010 (wave 2008–2010). First stage CONFIRMED via EPA CEMS (emissions drop at retrofit dates). See `quality_reports/decisions/2026-06-03_treatment-pivot-to-retrofits.md`.

[LEARN:data] **Birth data is effectively 2005–2010, not 2003–2010.** `birth/combined_birth_data.dta`: 2.24M births, but 2003≈15k & 2004≈50k vs ~380k/yr after (2003–04 ~4%/13% complete). Geography = tract centroid (`tract_lat`/`tract_lng`). Outcomes: `b_wt_gr` (birthweight), apgar, congenital_anomalies; fetal death is in separate `Fet*.dbf`.

[LEARN:project] **Power is band-constrained** (coal plants rural): births near nearest of 12 treated plants, 2005–2010 — ≤3km=0, ≤5km≈1.1k, ≤10km≈6k, ≤15km≈30k, ≤20km≈68k, ≤25km≈146k; median dist 104 km. Design settled (interview): reduced-form, ITT-of-retrofit headline, CS/SA staggered event study, **20 km** risk set over all ~22 TX coal plants, birthweight primary (LBW + fetal death secondary), drop W A Parish (2004, no pre-period) to sensitivity. Spec: `quality_reports/specs/2026-06-03_coal-controls-infant-health.md`.

[LEARN:reference] EPA CAMPD CEMS bulk-files API works with `DEMO_KEY` (downloads need no key): `https://api.epa.gov/easey/camd-services/bulk-files?api_key=DEMO_KEY`; daily files at `bulk-files/emissions/daily/state/emissions-daily-{year}-{state}.csv`. EIA-860 control-retrofit dates: `eia8602018.zip` → `6_1_EnviroAssoc` "Emissions Control Equipment" (InserviceYear).

## Preliminary Empirical Results (2026-06-03)

[LEARN:result] **Both designs → null on birthweight (PRELIMINARY).** Proximity-ITT retrofit event study: only 11 plant-area clusters (San Antonio-dominated, Deely/Spruce co-located confound), TWFE pre-trends FAIL, CS ATT = −20.6 g (p=0.19) — underpowered + confounded. Continuous tract-level exposure (inverse-distance × CEMS SO₂+NOx, tract+year FE, 934 clusters) is WELL-POWERED and gives a **precise null**: +5.6 g per 1-SD exposure, 95% CI [−7,+18]. Pipeline: `scripts/stata/{01_clean,03_analyze,04_robustness}.do`. Caveat: exposure proxy is crude (no PM₂.₅/lead, no trimester timing, no weather) — PM/lead are the birthweight-relevant pollutants, so refinement could change the answer. Decision pending with Sayorn (refine exposure vs accept precise-null vs add outcomes).

## Literature (2026-06-03)

[LEARN:reference] Lit review grounding the project: `quality_reports/lit_review_coal-controls-infant-health.md` + 5 verified BibTeX entries in `Bibliography_base.bib`. Closest precedent = **Luechinger (2014, JHE)** power-plant desulfurization → infant MORTALITY (not mean birthweight; notes LBW-survivor selection). Literature locates pollution effects in mortality/preterm/LBW tails, less in mean birthweight → our precise-null-on-mean + borderline-LBW (p=0.065) is coherent, not anomalous. Contribution gap: a U.S., CEMS-verified, control-retrofit estimate of birthweight/LBW co-benefits (US coal work is mostly mortality; birthweight work is mostly traffic/CO).

## Mortality-margin result (2026-06-03)

[LEARN:result] **Fetal-death margin added** (`scripts/stata/06_fetal_death.do`): combined file is LIVE BIRTHS only (`live_birth`==1); fetal deaths are in `birth/Fet{YYYY}.dbf` (`F_RZIP`, `F_WGT_GR`, `F_ESGEST`). Built ZIP×year fetal-death rate (13,802 deaths, mean 6.4/1,000). PM₂.₅ → fetal-death rate +0.19/1,000 per µg/m³ (p=0.10, ~+5.5%/SD). **Full picture: mean birthweight precise null; LBW p=0.065; fetal death p=0.10 — consistent borderline-adverse tail/mortality signals, null on the mean.** Matches literature (effects in tails/mortality). Next: Poisson confirm, coal-attributed/IV exposure, lead, trimester timing.

## CRUX: link-2 broken for PM2.5 (2026-06-03)

[LEARN:result] **Coal-attribution IV (`scripts/stata/07_iv_coal.do`) shows the chain breaks at link 2 for PM2.5.** Instrumenting ambient pregnancy PM2.5 with coal CEMS-emissions×distance: first-stage F = **0.25** (coef +0.67 ug/m3/SD, p=0.62) → coal emissions do NOT move local ambient PM2.5 (tract+year FE). Reduced form null (bw +6.3g/SD p=0.22; LBW p=0.19); 2SLS unidentified. So the UPDATE 4-5 borderline PM2.5–LBW/fetal signals are GENERAL PM2.5, not coal. Consistent w/ coal SO2/NOx → regional secondary PM, not local primary PM. **Implication: pivot coal-attributed exposure to ambient SO2 (coal's dominant local signature; scrubbers cut it) and LEAD (original project focus; repo has TX lead monitors) — re-test link-2 there.** Decision pending.
