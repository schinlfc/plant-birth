# Exploration: EIA plant data & the feasibility of a TX decommissioning design

**Date:** 2026-06-03 · **Status:** finding recorded · **Author:** Sayorn Chin / Claude

## What was checked
EIA coal generator + plant-capacity data in `earth_justic_data_codes/`
(`retired_operational.dta`, `collapsed_plant_capacity_1990_2020.dta`), via
`explore_plants.do`, `explore_plants_tx.do`, `explore_capoff.do` (logs alongside).

## Data summary
- **All coal** (energy source BIT/SUB/LIG/RC/WC; 99.7% Conventional Steam Coal, steam turbine).
- **575 distinct plants** nationally; 1,406 generator records (608 operating, 798 retired).
- Monthly capacity panel: 214,475 plant-months, 1990–2021.
- Retirement years 2002–2021, **clustered 2012–2020** (mean 2012.8).

## Decisive finding (binding constraint)
**Confidential TX birth/fetal data is only available for 2003–2010** (confirmed by Sayorn,
no newer vintage obtainable). But Texas coal decommissioning happens almost entirely
**after** that window:

| TX plant (full shutdown) | Capacity→0 year |
|---|---|
| Sandow No 5 (52071, lignite) | ~2007 (partial; later unit ran to 2018) |
| Norit/Marshall (54972) | 2008 (trivial 2 MW industrial unit) |
| Welsh (6139) | 2016 |
| Big Brown (3497), Monticello (6147), Sandow 4 (6648) | 2018 |
| Gibbons Creek (6136) | 2019 |
| Oklaunion (127) | 2020 |

Within **2003–2010**, Texas has **~1 marginal decommissioning** (Sandow 5) plus one
negligible 2 MW unit. Every substantial closure is **2016–2020**. Nationally, 2003–2010
has ~171 retired generators / ~58 full shutdowns — but the geocoded microdata is Texas-only.

**Implication:** a *decommissioning-event* DiD/event-study in Texas is **not feasible**
with 2003–2010 outcomes — the treatment wave and the outcome window do not overlap.
The limiting factor is the birth data, not the plant data (EIA covers retirements to 2021).

## Implication for design
The natural experiment must come from **in-window (2003–2010) plant variation**, not closures.
Candidate exposure shifters to investigate next:
1. **Pollution-control retrofits** (scrubbers/SCR), largely CAIR-driven ~2008–2010 — datable,
   plant-specific SO₂/PM/Pb cuts. Needs EPA Air Markets / EIA-860 environmental data (public).
2. **EPA CEMS hourly emissions** (SO₂/NOₓ/CO₂ by unit, 1995–present) — rich within-window
   variation in actual emissions; far more than capacity alone. Public.
3. **Capacity additions** (new TX coal units coming online ~2009–2010) as positive-exposure events.
4. Continuous pollution-proximity infant-health design (weaker "experiment").

## UPDATE — a viable in-window design exists: pollution-control retrofits
Source: EIA-860 2018 Schedule 6 (`eia8602018.zip` → `6_1_EnviroAssoc` "Emissions Control
Equipment"), already local. Of 142 control devices on TX coal plants, **45 (32%) were
installed in 2003–2010**, spiking in **2009–2010** (CAIR / CAMR / Texas SIP wave).

**12 distinct TX coal plants** got controls in-window, with staggered timing and mixed types
(SO₂ scrubbers [JB/SP], NOx [SCR/SNCR], particulate [baghouse], mercury [ACI]):
W A Parish (SCR 2003–04), J T Deely (2006–07), Pirkey/Coleto Creek (2006/07), Major Oak
(SNCR 2007–08), Big Brown/Martin Lake/Monticello (SNCR 2008 + ACI 2009), Sandow 5 (FGD+SNCR+ACI
2009), Sandow 4/J K Spruce/Oak Grove (FGD/SCR/baghouse 2009–10).

→ **Pivot the natural experiment from plant *closures* (out of window) to *control retrofits*
(in window).** Treatment = plant installs control type X in month T; outcome = infant health
for births near X.

### Caveats to resolve
- **Control type ↔ pollutant:** ACI cuts mercury, SCR/SNCR cut NOx (→ ozone, secondary PM),
  FGD cuts SO₂, baghouse cuts PM (and particle-bound lead). The relevant *exposure* depends on
  control type — reinforces the broad-air-pollution framing, but lead alone is too narrow.
- **Retrofit vs new unit:** Oak Grove & J K Spruce came online ~2009–10 *with* controls (capacity
  addition, not retrofit of an existing source) — treat separately.
- **First stage must be shown:** need to confirm emissions actually dropped at the retrofit date
  (EPA CEMS SO₂/NOx by unit) and that nearby EPA monitors (SO₂/PM/ozone, not just sparse Pb)
  observe the change, with births nearby.

## UPDATE 2 — CEMS confirms the first stage (emissions drop at retrofit)
Pulled EPA CAMPD **daily CEMS**, Texas 2003–2010 (8 state files, ~184 MB, via the bulk-files
API with `DEMO_KEY`; downloads need no key). Built a plant×month SO₂/NOx panel for the 12 plants
(`build_cems.do` → `earth_justic_data_codes/cems/cems_tx12_monthly.dta`, gitignored). Facility ID
= EIA plant code. Clear emission step-downs at retrofit dates:

| Plant | First stage |
|---|---|
| W A Parish | NOx ~1,000–1,300 → ~350 t/mo at SCR (2004) |
| Pirkey | SO₂ ~1,800 → ~250 t/mo (~85%) at 2006 control |
| Sandow 4 | NOx 437 → 104 t/mo at SCR (2010) |
| J K Spruce | SO₂ → 74–107 t/mo at FGD (2009–10) |
| Monticello, Big Brown | SO₂ decline 2008–2010 |
| Oak Grove, Sandow 5 | enter 2009–10 as low-emission (scrubbed) new units |

Figures: `figures/{cems_nox_panel,cems_so2_panel}.{png,pdf}` (all 12) and
`figures/{hero_parish_nox,hero_pirkey_so2}.png` (annotated). **First stage = confirmed.**

## Status of the 3-link chain
1. retrofit → plant emissions ↓ — **CONFIRMED (CEMS)**
2. plant emissions ↓ → ambient pollution ↓ near plant — *not yet tested* (need EPA AQS monitors)
3. ambient ↓ → infant health — *not yet tested* (need births near plants; confidential data)

## UPDATE 3 — outcome-side power check (confidential `birth/combined_birth_data.dta`)
2,236,092 births, 171 vars. Geography = **tract centroid** (`tract_lat`/`tract_lng`); outcomes incl.
`b_wt_gr` (birthweight g), apgar, `congenital_anomalies`. All birth work in git-ignored `birth/_scratch/`.

**Two binding facts:**
1. **Usable years = 2005–2010 only.** Births by year: 2003≈15k, 2004≈50k, then ~360–383k/yr (2005–10).
   TX has ~390k/yr → 2003–04 are ~4%/13% complete. So the outcome window is effectively **2005–2010**.
2. **Plants are rural → tight bands are tiny.** Births near *nearest* of the 12 plants, 2005–2010:

   | band | births | | band | births |
   |---|---|---|---|---|
   | ≤3 km | 0 | | ≤15 km | 29,953 |
   | ≤5 km | 1,069 | | ≤20 km | 68,022 |
   | ≤10 km | 5,966 | | ≤25 km | 145,702 |

   Median distance to nearest treated plant = 104 km. Power is concentrated at ~3 city-adjacent
   plants: **W A Parish** (Houston; 2,517 within 10 km — but retrofit 2004 ⇒ no pre-period),
   the **San Antonio Calaveras site** (J T Deely 2006 + J K Spruce 2010, co-located), and **Pirkey**.
   Rural plants (Monticello, Big Brown, Martin Lake, Coleto Creek≈0) contribute few births at ≤10 km.

**Implication:** tight-band (≤5–10 km) proximity DiD is underpowered for binary/rare outcomes.
Feasible designs need either wider bands (≤15–20 km ⇒ 30k–68k births, weaker exposure contrast) or
a **continuous exposure** design (see below).

## Recommended design (to discuss)
**Tract-level continuous coal-pollution exposure from CEMS, with retrofits driving within-tract
time variation.** For each tract×month, exposure = Σ over plants of (emissions / distance‑decay),
using actual CEMS SO₂/NOx (which drop at retrofits). Every birth within ~50 km gets a continuous,
time-varying treatment intensity → uses the full sample and all CEMS variation, rather than a tiny
proximity band. Identification: staggered retrofit-driven emission changes; tract + time FE; CS/SA
estimators. Birthweight (continuous) is the best-powered outcome; LBW/preterm/fetal death weaker.
Alternative: simple ≤15–20 km staggered event study pooling 2006–2010 retrofits (drop Parish 2004).

## Open next steps
- Link 2 (ambient): EPA AQS monitor coverage near plants, 2003–2010 (does ambient track CEMS?).
- Decide design: continuous-exposure vs proximity-band; treated set = 12 retrofit plants vs all ~22.
- Formalize via `/research-ideation` or `/interview-me`.

## UPDATE 4 — preliminary estimates (both designs → null on birthweight)
Real pipeline built: `scripts/stata/01_clean.do` (20 km births×retrofit panel, git-ignored output),
`03_analyze.do` (proximity ITT), `04_robustness.do` (continuous tract-level exposure). All birth-derived
data stays git-ignored; only code + aggregate results tracked.

**Design A — proximity ITT (retrofit event study), excl. W A Parish:**
- 36,856 births, **only 11 plant-area clusters**; sample dominated by San Antonio (Deely/Spruce
  co-located with different retrofit years — an assignment problem).
- TWFE event study **fails pre-trends** (pre-coefs +290/+176/+118 g at evt −4/−3/−2) — confounded by
  secular/compositional trends.
- Callaway–Sant'Anna ATT (not-yet-treated) = **−20.6 g (SE 15.7, p=0.19)**; pooled DiD ≈ 0
  (bw −2 g p=0.85; LBW null). Underpowered + few clusters.

**Design B — continuous tract-level exposure (inverse-distance × CEMS SO₂+NOx), tract + year FE:**
- 535,154 births within 50 km; **934 tract clusters** (solves the cluster problem).
- Birthweight per 1-SD exposure = **+5.6 g (SE 6.5, p=0.39), 95% CI [−7, +18]** — a **precise null**
  (sign even positive). Rules out moderate birthweight effects.

**Takeaway:** the continuous design is well-powered; the preliminary signal is ~zero on birthweight.
BUT the exposure proxy is crude (SO₂+NOx only — no PM₂.₅/lead, no trimester timing, no meteorology,
12 plants not 22, no ambient-monitor calibration). Refinement could still surface effects (esp. PM/lead,
which are the birthweight-relevant pollutants; NOx/SO₂ are imperfect proxies).

## Decision point (for Sayorn)
1. **Refine exposure** before concluding — add PM₂.₅/lead (EPA AQS), trimester-specific exposure,
   meteorology, all ~22 plants, monitor-calibrated ambient (link 2). Most likely to change the answer.
2. **Accept the design + precise-null framing** — "coal-plant emissions/retrofits have no detectable
   effect on TX infant birthweight 2005–2010" is itself a finding if robust.
3. **Add outcomes** (LBW, fetal death, congenital anomalies) to the continuous design.
4. **Reconsider question/setting** if a null isn't the desired contribution.

## UPDATE 5 — mortality margin: fetal-death rate (ZIP×year)
Built `scripts/stata/06_fetal_death.do`: live births (combined file, `b_mrzip`) + fetal deaths
(`Fet{2005..2010}.dbf`, `F_RZIP`) → **ZIP×year fetal-death rate** per 1,000 pregnancies; ZIP centroids
derived from the birth data. 13,950 ZIP-years, **13,802 fetal deaths**, mean rate **6.4/1,000**.
- **Fetal-death rate ~ annual PM₂.₅** (ZIP + year FE, wt=births, cl=ZIP, 379 ZIPs):
  **+0.19 per 1,000 per µg/m³ (SE 0.11, p=0.10)** — positive, borderline; ≈ **+5.5% per SD PM₂.₅**.

### Full outcome picture (PM₂.₅ exposure, 2005–2010)
| Outcome | Estimate | p | Read |
|---|---|---|---|
| Mean birthweight | −0.8 g per µg/m³ (CI [−3.8,+2.1]) | 0.57 | **precise null** |
| Low birth weight | +0.083 pp per µg/m³ | 0.065 | borderline + |
| Fetal-death rate | +0.19 /1,000 per µg/m³ | 0.10 | borderline + |

**Coherent story:** no effect on the *mean*, but consistent borderline-adverse signals in the
**tail (LBW) and mortality (fetal death)** — exactly where the literature (Luechinger 2014;
Chay–Greenstone; Knittel–Miller–Sanders) locates pollution's infant-health burden. Signals are
borderline, plausibly power-/measurement-limited (annual ZIP PM₂.₅; rare events; not coal-attributed).

### Remaining refinements (incremental)
Poisson count model (ppmlhdfe) confirmation; coal-attributed exposure / IV (PM₂.₅ instrumented by
CEMS×distance); lead exposure (repo lead monitors); trimester timing; preterm if obtainable.

## UPDATE 6 — coal-attribution / IV: the chain breaks at link 2 (for PM₂.₅)
`scripts/stata/07_iv_coal.do`: instrument ambient pregnancy PM₂.₅ with coal-plant CEMS-emissions×distance.
- **First stage / link-2:** ambient PM₂.₅ ~ coal-emissions exposure (tract+year FE): **+0.67 µg/m³ per SD,
  p=0.62, first-stage F = 0.25** → coal-plant emissions do **NOT** move local ambient PM₂.₅. Weak instrument.
- **Reduced form (coal-attributed):** birthweight +6.3 g/SD (p=0.22), LBW −0.002 (p=0.19) — null.
- **2SLS:** unidentified (F=0.25).

**Interpretation:** the borderline PM₂.₅–tail/mortality signals (UPDATE 4–5) are **general ambient PM₂.₅,
NOT coal-attributable**. Coal's local PM₂.₅ contribution in this period is negligible — consistent with
atmospheric science (coal SO₂/NOₓ → *regional secondary* sulfate/nitrate PM, not *local primary* PM at
population monitors). So the "coal controls → infant health via local PM₂.₅" chain has **no link-2**.

### Updated 3-link chain
1. retrofit → plant SO₂/NOₓ emissions ↓ — **STRONG (CEMS)**
2. plant emissions → **local ambient PM₂.₅** — **≈ ZERO (F=0.25)**  ← chain breaks here
3. ambient PM₂.₅ → infant health — general PM₂.₅ borderline on tail/mortality; coal-attributed = null

### Pivot implied
PM₂.₅ is the wrong exposure for *coal* attribution. Coal's local signatures are **SO₂** (coal is the
dominant SO₂ source; scrubbers cut it directly — first stage should be strong) and **lead** (the original
project's focus; repo has TX lead monitors). Re-test link-2 + health with **ambient SO₂ and lead**.

## UPDATE 7 — SO₂ + lead re-test: link-2 fails across all pollutants
`scripts/stata/08_so2.do`, `09_lead.do`. First stage (coal-emissions exposure → local ambient, tract+year FE):

| Pollutant | Coal→ambient first stage | Health (ambient → outcomes) |
|---|---|---|
| PM₂.₅ | F = 0.25 (≈0) | bw null; LBW p=0.065, fetal p=0.10 (general PM, borderline) |
| SO₂ | +0.02 ppb/SD, p=0.97 (≈0) | wrong-signed (bw +2.7/ppb p=0.01) — confounded |
| Lead | +0.0008/SD, **p=0.061** (only hint; 10 clusters, F≈4.6 weak) | uninformative (bw SE=492) / wrong-signed LBW |

**Robust multi-pollutant conclusion:** coal-plant emissions and their CAIR-era control-driven changes do
**not** move local ambient pollution at TX population monitors (link-2 ≈ 0 for PM₂.₅ and SO₂; only a weak,
fragile lead hint consistent with lead being primary/local). The treatment→plant-emissions first stage is
strong (CEMS), but **treatment→population-ambient-exposure is the broken link** — so there is no
identifiable infant-health co-benefit pathway via ambient exposure in this setting. Borderline PM₂.₅
tail/mortality signals are general ambient PM, not coal-attributable.

**Why (mechanism):** coal SO₂/NOₓ → *regional secondary* PM (not local primary at monitors); ambient SO₂
already very low (~1 ppb); lead post-leaded-gasoline very low (~0.01 µg/m³) with sparse monitors; coal is a
small marginal contributor to local population ambient exposure in 2005–2010 TX.

## Bottom line for the manuscript (decision)
The coal-controls→infant-health design, identified off ambient monitors with tract+year FE, yields a
**robust, well-identified null** with a clear mechanistic explanation. Viable framings:
1. **Precisely-estimated null co-benefit** paper (policy-relevant; coal's small ambient footprint explains it).
2. **Reframe to general PM₂.₅ → infant health in TX** (drop coal attribution; tail/mortality borderline).
3. **Return to the original lead/proximity/IQ syllogism** (consulting-style; not a clean causal DiD).
4. **Reconsider viability** in TX 2005–2010 given binding data limits (window, monitor sparsity, coal footprint).
