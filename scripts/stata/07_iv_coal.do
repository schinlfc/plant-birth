/*------------------------------------------------------------
File:    07_iv_coal.do  (coal-attributed exposure: first stage / RF / 2SLS)
Purpose: Does coal-plant CEMS emissions move ambient PM2.5 (first stage)?
         Reduced-form + IV (PM2.5 instrumented by coal emissions x distance).
Inputs:  scripts/stata/_outputs/pm25_birth_sample.dta, cems_tx12_monthly.dta,
         earth_justic_data_codes/retired_operational.dta
Outputs: scripts/stata/_outputs/07_*.smcl (git-ignored)
------------------------------------------------------------*/
version 19
clear all
set more off
set seed 12345
cap log close _all
log using "scripts/stata/_outputs/07_iv.smcl", replace text

* --- coal plant-year emissions (12 plants) + coords ---
use "earth_justic_data_codes/cems/cems_tx12_monthly.dta", clear
collapse (sum) so2 nox, by(facilityid yr)
gen emis = so2 + nox
keep facilityid yr emis
reshape wide emis, i(facilityid) j(yr)
rename facilityid plantid
tempfile em
save `em'
use "earth_justic_data_codes/retired_operational.dta", clear
keep plantid latitude longitude
bys plantid: keep if _n==1
merge 1:1 plantid using `em', keep(3) nogen
mkmat plantid latitude longitude emis2005 emis2006 emis2007 emis2008 emis2009 emis2010, matrix(E)
local NP = rowsof(E)

* --- birth sample with pregnancy-window PM2.5 (from 05) + build coal exposure ---
use "scripts/stata/_outputs/pm25_birth_sample.dta", clear
gen double coal_expo = 0
gen double mindp = .
local R 6371
forvalues r=1/`NP' {
    tempvar d
    gen double `d' = `R'*2*asin(sqrt(sin((E[`r',2]-tract_lat)*_pi/360)^2 ///
        + cos(tract_lat*_pi/180)*cos(E[`r',2]*_pi/180)*sin((E[`r',3]-tract_lng)*_pi/360)^2))
    replace mindp = min(mindp,`d')
    gen double `d'_e = 0
    forvalues y=2005/2010 {
        local col = `y'-2001
        replace `d'_e = E[`r',`col'] if bs_byear==`y'
    }
    replace coal_expo = coal_expo + cond(`d'<=50 & `d'>0, `d'_e/`d', 0)
    drop `d' `d'_e
}
* standardize for readable coefficients
qui sum coal_expo if near30
gen z_coal = (coal_expo-r(mean))/r(sd)

di _n "===== FIRST STAGE / link-2: ambient pregnancy PM2.5 ~ coal emissions exposure ====="
reghdfe pm_preg z_coal if near30, absorb(tractid ym) cluster(site)
di "  (does coal emissions exposure move local ambient PM2.5? coef = ug/m3 per SD coal exposure)"

di _n "===== REDUCED FORM: outcomes ~ coal emissions exposure (per SD) ====="
di "-- birthweight --"
reghdfe bw z_coal if near30, absorb(tractid ym) cluster(site)
di "-- low birth weight --"
reghdfe lbw z_coal if near30, absorb(tractid ym) cluster(site)

cap which ivreghdfe
if !_rc {
    di _n "===== 2SLS: birthweight, PM2.5 instrumented by coal emissions exposure ====="
    cap noisily ivreghdfe bw (pm_preg = z_coal) if near30, absorb(tractid ym) cluster(site) first
}
log close
