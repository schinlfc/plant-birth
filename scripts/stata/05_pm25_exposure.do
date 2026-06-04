/*------------------------------------------------------------
File:    05_pm25_exposure.do  (REFINED exposure: ambient PM2.5, pregnancy window)
Purpose: Dose-response of birthweight to pregnancy-window PM2.5 at nearest monitor;
         tract + birth-year-month FE; cluster by monitor.
Inputs:  earth_justic_data_codes/aqs/tx_88101.csv, birth/combined_birth_data.dta
Outputs: scripts/stata/_outputs/05_*.smcl (git-ignored)
------------------------------------------------------------*/
version 19
clear all
set more off
set seed 12345
cap log close _all
log using "scripts/stata/_outputs/05_pm25.smcl", replace text

* ---------- PART 1: monthly PM2.5 monitor panel ----------
import delimited "earth_justic_data_codes/aqs/tx_88101.csv", varnames(1) clear
keep statecode countycode sitenum latitude longitude datelocal arithmeticmean
gen edate = date(datelocal, "YMD")
gen ym = ym(year(edate), month(edate))
egen site = group(statecode countycode sitenum)
collapse (mean) pm25=arithmeticmean slat=latitude slon=longitude, by(site ym)
tsset site ym
* pregnancy-window exposure = mean PM2.5 over the 9 months before birth (L1..L9)
forvalues k=1/9 {
    gen pml`k' = L`k'.pm25
}
egen pm_preg = rowmean(pml1 pml2 pml3 pml4 pml5 pml6 pml7 pml8 pml9)
drop pml1-pml9
tempfile mpanel
save `mpanel'
* monitor locations
collapse (mean) slat slon, by(site)
mkmat site slat slon, matrix(M)
local NM = rowsof(M)
di "PM2.5 monitors: `NM'"

* ---------- PART 2: assign births to nearest monitor + pregnancy PM2.5 ----------
use birth_id bs_byear b_month tract_lat tract_lng b_wt_gr using "birth/combined_birth_data.dta", clear
keep if inrange(bs_byear,2005,2010)
drop if missing(tract_lat,tract_lng,b_month)
destring b_wt_gr, gen(bw) force
replace bw=. if bw<=0 | bw>6500
gen ym = ym(bs_byear, b_month)
gen double mind=.
gen long site=.
local R 6371
forvalues r=1/`NM' {
    tempvar d
    gen double `d' = `R'*2*asin(sqrt(sin((M[`r',2]-tract_lat)*_pi/360)^2 ///
        + cos(tract_lat*_pi/180)*cos(M[`r',2]*_pi/180)*sin((M[`r',3]-tract_lng)*_pi/360)^2))
    replace site = M[`r',1] if `d'<mind | mind==.
    replace mind = `d' if `d'<mind | mind==.
    drop `d'
}
gen byte near30 = mind<=30
merge m:1 site ym using `mpanel', keep(1 3) keepusing(pm_preg) nogen
gen tractid_str = string(tract_lat,"%12.6f")+"_"+string(tract_lng,"%12.6f")
egen tractid = group(tractid_str)

di _n "===== sample with pregnancy-window PM2.5 (nearest monitor <=30km) ====="
count if near30 & !missing(pm_preg) & !missing(bw)
di "  N births: " %12.0fc r(N)
sum pm_preg if near30, detail

di _n "===== Birthweight ~ pregnancy-window PM2.5 (ug/m3); tract + birth-YM FE; cluster monitor ====="
reghdfe bw pm_preg if near30, absorb(tractid ym) cluster(site)
di "  (coef = grams per 1 ug/m3 PM2.5 over the 9 months pre-birth)"
* per-SD for interpretability
qui sum pm_preg if near30 & e(sample)
local sd = r(sd)
di "  SD(pm_preg) = " %5.2f `sd' "  => per-SD effect = " %6.1f _b[pm_preg]*`sd' " g"
di _n "===== Low birth weight (<2500g) ~ pregnancy-window PM2.5 ====="
gen byte lbw = bw<2500 if !missing(bw)
reghdfe lbw pm_preg if near30, absorb(tractid ym) cluster(site)
di "  (coef = pp change in LBW prob per 1 ug/m3 PM2.5)"
keep if near30
save "scripts/stata/_outputs/pm25_birth_sample.dta", replace
log close
