/*------------------------------------------------------------
File:    03_analyze.do  (PRELIMINARY first look)
Purpose: Power/structure, event study, few-cluster inference, CS, balance
Inputs:  scripts/stata/_outputs/analysis_panel.dta (git-ignored)
Outputs: scripts/stata/_outputs/03_*.smcl, eventstudy figure
Run order: After 01_clean.do
------------------------------------------------------------*/
version 19
clear all
set more off
set seed 12345
cap log close _all
log using "scripts/stata/_outputs/03_analyze.smcl", replace text

use "scripts/stata/_outputs/analysis_panel.dta", clear
drop if parish==1                       // main sample excludes W A Parish (2004)
di "Main sample N = " %12.0fc _N
qui levelsof nearplant, local(cl)
di "plant-area clusters = " `: word count `cl''

* ---------- (1) Descriptive: birthweight & LBW by event time ----------
di _n "===== Mean birthweight & LBW by event time (years rel. to retrofit) ====="
gen evt_b = max(-4,min(4,evt))
table evt_b, statistic(mean bw) statistic(mean lbw) statistic(frequency) nformat(%9.1f)

* ---------- (2) TWFE event study (plant-area + year FE) ----------
di _n "===== TWFE event-study: birthweight (cluster = plant-area) ====="
gen evt_c = evt_b + 5                    // shift to positive for factor labels (-4->1 ... +4->9); base = evt=-1 -> 4
reghdfe bw ib4.evt_c, absorb(nearplant bs_byear) cluster(nearplant)
estimates store es

* ---------- (3) Simple post DiD + few-cluster wild bootstrap ----------
di _n "===== Pooled post effect on birthweight; cluster-robust + wild bootstrap (11 clusters) ====="
reghdfe bw post, absorb(nearplant bs_byear) cluster(nearplant)
cap boottest post, reps(1999) cluster(nearplant) nograph
di _n "===== Same for LBW ====="
reghdfe lbw post, absorb(nearplant bs_byear) cluster(nearplant)
cap boottest post, reps(1999) cluster(nearplant) nograph

* ---------- (4) Callaway-Sant'Anna (repeated cross-section) ----------
di _n "===== Callaway-Sant'Anna (not-yet-treated controls) ====="
cap noisily csdid bw, time(bs_byear) gvar(near_retro) cluster(nearplant) agg(simple)
cap noisily csdid_stats simple

* ---------- (5) Selective fertility / composition balance ----------
di _n "===== Composition check: covariates on post (selective fertility) ====="
foreach c in b_m_age education married hisp parity mom_wic {
    cap reghdfe `c' post, absorb(nearplant bs_byear) cluster(nearplant)
}

* ---------- (6) Event-study figure (TWFE) ----------
estimates restore es
cap coefplot es, keep(*.evt_c) vertical yline(0, lcolor(gs8)) ///
    xline(4.5, lpattern(dash) lcolor(red)) ///
    coeflabels(1.evt_c="-4" 2.evt_c="-3" 3.evt_c="-2" 4.evt_c="-1(base)" ///
               5.evt_c="0" 6.evt_c="+1" 7.evt_c="+2" 8.evt_c="+3" 9.evt_c="+4") ///
    title("Event study: birthweight around coal-plant control retrofits", size(small)) ///
    subtitle("TWFE, plant-area + year FE, 11 clusters (PRELIMINARY)", size(vsmall)) ///
    ytitle("grams vs. event year -1", size(small)) graphregion(color(white)) plotregion(color(white))
cap graph export "explorations/plants/figures/eventstudy_bw_twfe.png", replace width(2000)
log close
