/*------------------------------------------------------------
File:       01_clean.do
Purpose:    Build the births x retrofit-plant analysis panel (20 km risk set)
Inputs:     birth/combined_birth_data.dta, earth_justic_data_codes/retired_operational.dta (read-only, git-ignored)
Outputs:    scripts/stata/_outputs/analysis_panel.dta (git-ignored; birth-derived)
Run order:  After 00_install.do
Project:    Coal-plant pollution controls and infant health in Texas
------------------------------------------------------------*/
version 19
clear all
set more off
set seed 12345
set sortseed 12345
cap log close _all
log using "scripts/stata/_outputs/01_clean.smcl", replace

* --- 12 retrofit plants: first major in-window retrofit YEAR ---
clear
input plantid retro_year
3470 2004
3497 2008
6146 2008
6147 2008
6178 2007
6180 2010
6181 2006
6648 2010
7030 2007
7097 2010
7902 2006
52071 2009
end
tempfile retro
save `retro'
use "earth_justic_data_codes/retired_operational.dta", clear
keep plantid plantname latitude longitude
bys plantid: keep if _n==1
merge 1:1 plantid using `retro', keep(3) nogen
rename (latitude longitude) (plat plon)
mkmat plantid plat plon retro_year, matrix(P)
local NP = rowsof(P)

* --- births ---
use birth_id bs_byear b_month tract_lat tract_lng b_wt_gr live_birth parity ///
    b_m_age education m_rwhite m_rblack b_m_ethn married mom_wic ///
    using "birth/combined_birth_data.dta", clear
keep if inrange(bs_byear,2005,2010)
drop if missing(tract_lat,tract_lng)

* nearest of the 12 retrofit plants + distance
gen double mind = .
gen long nearplant = .
gen int  near_retro = .
local R 6371
forvalues r=1/`NP' {
    tempvar d
    gen double `d' = `R'*2*asin(sqrt(sin((P[`r',2]-tract_lat)*_pi/360)^2 ///
        + cos(tract_lat*_pi/180)*cos(P[`r',2]*_pi/180)*sin((P[`r',3]-tract_lng)*_pi/360)^2))
    replace nearplant = P[`r',1] if `d'<mind | mind==.
    replace near_retro = P[`r',4] if `d'<mind | mind==.
    replace mind = `d' if `d'<mind | mind==.
    drop `d'
}
keep if mind<=20                          // 20 km risk set
gen byte parish = nearplant==3470          // W A Parish (2004) -> drop from main

* --- outcomes ---
destring b_wt_gr, gen(bw) force
replace bw = . if bw<=0 | bw>6500          // trim implausible
gen byte lbw = bw<2500 if !missing(bw)

* --- treatment / event time (annual) ---
gen byte post = bs_byear >= near_retro
gen int  evt  = bs_byear - near_retro      // event time in years
gen byte treated_cohort = 1                // all near a retrofit plant; CS uses timing

* --- covariates ---
destring b_m_ethn, gen(hisp) force
label var bw "Birthweight (g)"
label var lbw "Low birth weight (<2500g)"

compress
save "scripts/stata/_outputs/analysis_panel.dta", replace

* --- report sample structure (aggregates only) ---
di _n "===== Analysis panel: births within 20km of a retrofit plant, 2005-2010 ====="
di "N births (incl. Parish): " %12.0fc _N
count if !parish
di "N births (excl. Parish, main): " %12.0fc r(N)
di _n "births per plant-area + retrofit cohort:"
table nearplant near_retro, statistic(frequency) nformat(%10.0fc)
di _n "distinct plant-area clusters (excl Parish): "
egen tagp = tag(nearplant) if !parish
count if tagp
log close
