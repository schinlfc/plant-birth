/*------------------------------------------------------------
File:    04_robustness.do  (ALTERNATIVE DESIGN: continuous tract-level exposure)
Purpose: Dose-response of birthweight to inverse-distance-weighted coal-plant
         CEMS emissions; tract + year FE; many tract clusters (vs 11 plant-areas)
Inputs:  birth/combined_birth_data.dta, cems_tx12_monthly.dta, retired_operational.dta
Outputs: scripts/stata/_outputs/04_*.smcl (git-ignored)
------------------------------------------------------------*/
version 19
clear all
set more off
set seed 12345
cap log close _all
log using "scripts/stata/_outputs/04_robustness.smcl", replace text

* --- plant-year emissions (12 retrofit plants) ---
use "earth_justic_data_codes/cems/cems_tx12_monthly.dta", clear
collapse (sum) so2 nox, by(facilityid yr)
gen emis = so2 + nox
keep facilityid yr emis
reshape wide emis, i(facilityid) j(yr)        // emis2003..emis2010 per plant
* plant coords
rename facilityid plantid
tempfile emisp
save `emisp'
use "earth_justic_data_codes/retired_operational.dta", clear
keep plantid latitude longitude
bys plantid: keep if _n==1
merge 1:1 plantid using `emisp', keep(3) nogen
mkmat plantid latitude longitude emis2005 emis2006 emis2007 emis2008 emis2009 emis2010, matrix(E)
local NP = rowsof(E)

* --- births within 50 km; build inverse-distance emissions exposure ---
use birth_id bs_byear tract_lat tract_lng b_wt_gr using "birth/combined_birth_data.dta", clear
keep if inrange(bs_byear,2005,2010)
drop if missing(tract_lat,tract_lng)
destring b_wt_gr, gen(bw) force
replace bw=. if bw<=0 | bw>6500
gen double expo = 0
gen double mind = .
local R 6371
forvalues r=1/`NP' {
    tempvar d
    gen double `d' = `R'*2*asin(sqrt(sin((E[`r',2]-tract_lat)*_pi/360)^2 ///
        + cos(tract_lat*_pi/180)*cos(E[`r',2]*_pi/180)*sin((E[`r',3]-tract_lng)*_pi/360)^2))
    replace mind = min(mind,`d')
    * emissions of plant r in the birth year / distance  (inverse-distance, within 50km)
    gen double `d'_e = 0
    forvalues y=2005/2010 {
        local col = `y'-2001          // emis2005->col4 ... emis2010->col9
        replace `d'_e = E[`r',`col'] if bs_byear==`y'
    }
    replace expo = expo + cond(`d'<=50 & `d'>0, `d'_e/`d', 0)
    drop `d' `d'_e
}
keep if mind<=50
gen tract = string(tract_lat,"%12.6f") + "_" + string(tract_lng,"%12.6f")
egen tractid = group(tract)
gen lexpo = ln(expo+1)
qui sum tractid
di "N births within 50km: " %12.0fc _N
di "distinct tracts (clusters): " r(max)

di _n "===== Dose-response: birthweight on inverse-distance coal emissions, tract + year FE ====="
reghdfe bw expo, absorb(tractid bs_byear) cluster(tractid)
di _n "===== log exposure ====="
reghdfe bw lexpo, absorb(tractid bs_byear) cluster(tractid)
di _n "===== standardized exposure (per SD) for interpretability ====="
qui sum expo
gen z_expo = (expo-r(mean))/r(sd)
reghdfe bw z_expo, absorb(tractid bs_byear) cluster(tractid)
di "  (coefficient = grams per 1-SD increase in inverse-distance coal emissions)"
log close
