/*------------------------------------------------------------
File:    08_so2.do  (coal-attributed exposure via ambient SO2)
Purpose: First stage coal-emissions -> ambient SO2; SO2 -> infant health; 2SLS.
Inputs:  birth/combined_birth_data.dta, aqs/tx_42401.csv, cems_tx12_monthly.dta, retired_operational.dta
Outputs: scripts/stata/_outputs/08_*.smcl (git-ignored)
------------------------------------------------------------*/
version 19
clear all
set more off
set seed 12345
cap log close _all
log using "scripts/stata/_outputs/08_so2.smcl", replace text

* --- coal plant-year emissions + coords ---
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

* --- SO2 monitor monthly panel + pregnancy-window SO2 ---
import delimited "earth_justic_data_codes/aqs/tx_42401.csv", varnames(1) clear
gen edate = date(datelocal,"YMD")
gen ym = ym(year(edate), month(edate))
egen site = group(statecode countycode sitenum)
collapse (mean) so2=arithmeticmean slat=latitude slon=longitude, by(site ym)
tsset site ym
forvalues k=1/9 {
    gen sl`k' = L`k'.so2
}
egen so2_preg = rowmean(sl1 sl2 sl3 sl4 sl5 sl6 sl7 sl8 sl9)
tempfile mp
save `mp'
collapse (mean) slat slon, by(site)
mkmat site slat slon, matrix(M)
local NM = rowsof(M)
di "SO2 monitors: `NM'"

* --- births ---
use bs_byear b_month tract_lat tract_lng b_wt_gr using "birth/combined_birth_data.dta", clear
keep if inrange(bs_byear,2005,2010)
drop if missing(tract_lat,tract_lng,b_month)
destring b_wt_gr, gen(bw) force
replace bw=. if bw<=0 | bw>6500
gen byte lbw = bw<2500 if !missing(bw)
gen ym = ym(bs_byear, b_month)
local R 6371
* nearest SO2 monitor
gen double mind=.
gen long site=.
forvalues r=1/`NM' {
    tempvar d
    gen double `d' = `R'*2*asin(sqrt(sin((M[`r',2]-tract_lat)*_pi/360)^2 ///
        + cos(tract_lat*_pi/180)*cos(M[`r',2]*_pi/180)*sin((M[`r',3]-tract_lng)*_pi/360)^2))
    replace site = M[`r',1] if `d'<mind | mind==.
    replace mind = `d' if `d'<mind | mind==.
    drop `d'
}
gen byte near30 = mind<=30
* coal exposure
gen double coal_expo=0
forvalues r=1/`NP' {
    tempvar d
    gen double `d' = `R'*2*asin(sqrt(sin((E[`r',2]-tract_lat)*_pi/360)^2 ///
        + cos(tract_lat*_pi/180)*cos(E[`r',2]*_pi/180)*sin((E[`r',3]-tract_lng)*_pi/360)^2))
    gen double `d'_e=0
    forvalues y=2005/2010 {
        local col=`y'-2001
        replace `d'_e=E[`r',`col'] if bs_byear==`y'
    }
    replace coal_expo = coal_expo + cond(`d'<=50 & `d'>0,`d'_e/`d',0)
    drop `d' `d'_e
}
merge m:1 site ym using `mp', keep(1 3) keepusing(so2_preg) nogen
egen tractid = group(tract_lat tract_lng)
qui sum coal_expo if near30
gen z_coal = (coal_expo-r(mean))/r(sd)
qui sum so2_preg if near30
di _n "N with SO2 exposure (<=30km): " %12.0fc r(N) "  | mean SO2 (ppb) = " %5.2f r(mean)

di _n "===== FIRST STAGE / link-2: ambient pregnancy SO2 ~ coal emissions exposure (per SD) ====="
reghdfe so2_preg z_coal if near30, absorb(tractid ym) cluster(site)
di "  (coef = ppb SO2 per SD coal exposure; t^2 ~ first-stage F)"

di _n "===== SO2 dose-response: birthweight & LBW ~ pregnancy SO2 ====="
reghdfe bw so2_preg if near30, absorb(tractid ym) cluster(site)
reghdfe lbw so2_preg if near30, absorb(tractid ym) cluster(site)

cap which ivreghdfe
if !_rc {
    di _n "===== 2SLS: birthweight, SO2 instrumented by coal emissions exposure ====="
    cap noisily ivreghdfe bw (so2_preg = z_coal) if near30, absorb(tractid ym) cluster(site) first
}
log close
