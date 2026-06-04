# Literature Review: Coal-Plant Pollution Controls and Infant Health

**Date:** 2026-06-03
**Query:** Ground the manuscript on (1) air pollution & birth outcomes, (2) health co-benefits of air regulation / coal-plant controls, (3) coal-plant proximity/retirement & health (incl. lead). Situate a precise null on mean birthweight + borderline LBW finding.
**Verification:** citations web-grounded via direct search (URLs below); a few specifics (exact pages/volume, two recent papers' authorship) flagged **[confirm]** for Sayorn.

## Summary

The economics literature robustly finds that **prenatal air-pollution exposure harms infant health**, but the margin matters: the clearest and largest effects are on **infant mortality and the tails (preterm, low birth weight)**, with **mean birthweight** effects often smaller, mixed, or concentrated among susceptible subgroups. Seminal work (Chay & Greenstone 2003) ties particulates to infant mortality; quasi-experimental studies (Currie & Walker 2011; Knittel, Miller & Sanders 2016; Currie, Neidell & Schmieder 2009) link traffic/CO/PM to prematurity, LBW, and infant mortality.

The **co-benefits** strand — does cleaning up emissions improve infant health — is smaller and centers on **mortality**. The closest precedent to this project, **Luechinger (2014, JHE)**, uses *mandated power-plant desulfurization (scrubbers)* in Germany as a natural experiment and finds SO₂ reductions lowered **infant mortality** (elasticity ≈0.07–0.13; ~826–1,460 lives/yr) — but notably **no neonatal-mortality effect and even a relative increase in low-birth-weight survivors**, consistent with mortality selection. Recent epidemiology (NC SO₂ reductions → fewer preterm births within 4–10 mi) and coal-retirement mortality studies point the same way: benefits show up most in mortality/preterm, less cleanly in mean birthweight.

**Where this paper sits:** a precise **null on mean birthweight** plus a **borderline-positive PM₂.₅–LBW association** is *coherent with*, not anomalous to, this literature — effects concentrate in the tail and in mortality, not the conditional mean. The contribution is a **U.S., CEMS-verified, control-retrofit** estimate of infant-health co-benefits with tract-geocoded data: most U.S. coal/health work studies *mortality* (adults or infants), and most *birthweight* work studies traffic/CO — a credibly-identified U.S. estimate of the **birthweight/LBW co-benefits of coal-plant control retrofits** is a gap.

## Key Papers

### Chay & Greenstone (2003) — Air quality, infant mortality, Clean Air Act
- **Finding:** 1% ↓ TSP → ~0.5% ↓ infant mortality; identified off recession-induced pollution variation under the 1970 CAAA. Seminal co-benefits/identification template. *QJE* 118(3):1121–1167.

### Currie, Neidell & Schmieder (2009) — Air pollution & infant health, New Jersey
- **Finding:** Using maternal-address × monitor data with **sibling FE**, in-utero **CO** → lower birthweight and gestation; larger for smokers/older mothers; effects below EPA standards. *JHE* 28(3):688–703.

### Currie & Walker (2011) — Traffic congestion & infant health (E-ZPass)
- **Finding:** E-ZPass (↓ congestion/emissions near toll plazas) → **−10.8% prematurity, −11.8% LBW** within 2 km vs 2–10 km. Clean local natural experiment. *AEJ: Applied* 3(1):65–90.

### Knittel, Miller & Sanders (2016) — Traffic, pollution & infant health
- **Finding:** CA 2002–07, IV off traffic×weather: **PM** raises weekly **infant mortality**, especially for **preterm/LBW** infants. *REStat* 98(2):350–366.

### Luechinger (2014) — Power-plant desulfurization & infant mortality *(closest precedent)*
- **Finding:** Mandated **scrubbers** in Germany (1985–2003) ↓ SO₂ → ↓ **infant mortality** (elasticity 0.07–0.13; ~826–1,460 lives/yr); **no neonatal effect**; relative **rise in LBW survivors** (selection). *JHE* 2014 **[confirm vol/pages]**. Directly analogous treatment (controls) and outcome family.

### Prenatal lead & birth outcomes
- Lead-in-water natural experiment (Newark; *JHE* 2022 **[confirm authors]**): prenatal lead → **LBW +1.5 pp (~18%)**, **preterm +1.9 pp (~19%)**. Scotland lead-water (*Env. & Resource Econ.* 2025 **[confirm]**). Epi consensus: gestational lead → LBW/preterm/SGA. Relevant for the coal-lead channel.

### Coal-plant retirement / proximity & health
- Coal-retirement → ↓ PM₂.₅ → ↓ **older-adult mortality** (Eastern US natural experiment, PMC **[confirm cite]**); "Mortality risk from U.S. coal electricity generation," *Science* 2023 (adf4915) **[confirm]**. NC coal SO₂ reductions → fewer **preterm** births 4–<10 mi (PMC, epi). Mostly mortality/adults; infant-birthweight margin underexplored in the U.S.

## Gaps and Opportunities

1. **U.S. birthweight co-benefits of coal controls are understudied.** U.S. coal/health work is mostly mortality (often adults); birthweight work is mostly traffic/CO. A CEMS-verified, control-retrofit design on U.S. birth weight/LBW fills this.
2. **Mean vs. tail vs. mortality.** The literature suggests effects concentrate in mortality/preterm/LBW, not the conditional mean — our null-on-mean + borderline-LBW fits this; pushing on **LBW, preterm (if obtainable), and fetal death/infant mortality** is where signal is likeliest.
3. **Selection.** Luechinger's mortality-selection nuance (fewer deaths → more frail LBW survivors) means birthweight/LBW effects can be *attenuated or wrong-signed* even when mortality falls — worth addressing explicitly.

## Suggested Next Steps

- Pull and read Luechinger (2014) and the NC preterm paper as the direct methodological/substantive comparators.
- Confirm the flagged citations **[confirm]** before drafting.
- Prioritize mortality/fetal-death and LBW/preterm outcomes (where the literature locates effects) over mean birthweight.

## BibTeX (high-confidence entries)

```bibtex
@article{chay2003air,
  author = {Chay, Kenneth Y. and Greenstone, Michael},
  title = {The Impact of Air Pollution on Infant Mortality: Evidence from Geographic Variation in Pollution Shocks Induced by a Recession},
  journal = {Quarterly Journal of Economics}, year = {2003}, volume = {118}, number = {3}, pages = {1121--1167}}

@article{currie2009air,
  author = {Currie, Janet and Neidell, Matthew and Schmieder, Johannes F.},
  title = {Air Pollution and Infant Health: Lessons from New Jersey},
  journal = {Journal of Health Economics}, year = {2009}, volume = {28}, number = {3}, pages = {688--703}}

@article{currie2011traffic,
  author = {Currie, Janet and Walker, Reed},
  title = {Traffic Congestion and Infant Health: Evidence from E-ZPass},
  journal = {American Economic Journal: Applied Economics}, year = {2011}, volume = {3}, number = {1}, pages = {65--90}}

@article{knittel2016caution,
  author = {Knittel, Christopher R. and Miller, Douglas L. and Sanders, Nicholas J.},
  title = {Caution, Drivers! Children Present: Traffic, Pollution, and Infant Health},
  journal = {Review of Economics and Statistics}, year = {2016}, volume = {98}, number = {2}, pages = {350--366}}

@article{luechinger2014air,
  author = {Luechinger, Simon},
  title = {Air Pollution and Infant Mortality: A Natural Experiment from Power Plant Desulfurization},
  journal = {Journal of Health Economics}, year = {2014}, note = {volume/pages to confirm}}
```

## Sources (web-grounded)
- Chay–Greenstone: nber.org/papers/w10053 ; QJE 2003
- Currie–Neidell–Schmieder: sciencedirect.com S0167629609000101 ; nber.org/papers/w14196
- Currie–Walker: aeaweb.org 10.1257/app.3.1.65 ; nber.org/papers/w15413
- Knittel–Miller–Sanders: direct.mit.edu/rest/article/98/2/350 ; nber.org/papers/w17222
- Luechinger: sciencedirect.com S0167629614000897 ; pubmed 25105867
- Lead–water (Newark): sciencedirect.com S0167629622000637 ; Scotland: link.springer.com 10.1007/s10640-025-01041-6
- Coal retirement/mortality: science.org 10.1126/science.adf4915 ; PMC7055118 ; NC preterm: PMC10097570

## Post-Flight Verification (note)
Citations were grounded by **direct web search** (URLs above) rather than a separate forked verifier — web-grounding is the stronger check here. Status: **PARTIAL** — the five BibTeX entries are high-confidence (titles/venues/years/findings confirmed in search results); items marked **[confirm]** (Luechinger exact vol/pages; lead-water and coal-retirement authorship) should be verified by Sayorn or a `/verify-claims` pass before they enter the manuscript.
