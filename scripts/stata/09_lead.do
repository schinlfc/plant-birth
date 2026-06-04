/*------------------------------------------------------------
File:    09_lead.do  (coal-attributed exposure via ambient lead)
Inputs:  birth/combined_birth_data.dta, earth_justic_data_codes/lead_1990_2021.dta,
         cems_tx12_monthly.dta, retired_operational.dta
Outputs: scripts/stata/_outputs/09_*.smcl (git-ignored)
------------------------------------------------------------*/
version 19
clear all
set more off
set seed 12345
cap log close _all
log using "scripts/stata/_outputs/09_lead.smcl", replace text

* coal plant-year emissions + coords
use "earth_justic_data_codes/cems/cems_tx12_monthly.dta", clear
collapse (sum) so2 nox, by(facilityid yr)
gen emis=so2+nox
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
local NP=rowsof(E)

* TX lead monitor monthly panel
use statecode countycode sitenum latitude longitude arithmeticmean year_month ///
    using "earth_justic_data_codes/lead_1990_2021.dta", clear
keep if statecode==48
recode arithmeticmean (-99/-0.0001=.)
egen site=group(statecode countycode sitenum)
collapse (mean) pb=arithmeticmean slat=latitude slon=longitude, by(site year_month)
rename year_month ym
tsset site ym
forvalues k=1/9 {
    gen pl`k'=L`k'.pb
}
egen pb_preg=rowmean(pl1 pl2 pl3 pl4 pl5 pl6 pl7 pl8 pl9)
tempfile mp
save `mp'
collapse (mean) slat slon, by(site)
mkmat site slat slon, matrix(M)
local NM=rowsof(M)
di "TX lead monitors: `NM'"

* births
use bs_byear b_month tract_lat tract_lng b_wt_gr using "birth/combined_birth_data.dta", clear
keep if inrange(bs_byear,2005,2010)
drop if missing(tract_lat,tract_lng,b_month)
destring b_wt_gr, gen(bw) force
replace bw=. if bw<=0 | bw>6500
gen byte lbw=bw<2500 if !missing(bw)
gen ym=ym(bs_byear,b_month)
local R 6371
gen double mind=.
gen long site=.
forvalues r=1/`NM' {
    tempvar d
    gen double `d'=`R'*2*asin(sqrt(sin((M[`r',2]-tract_lat)*_pi/360)^2+cos(tract_lat*_pi/180)*cos(M[`r',2]*_pi/180)*sin((M[`r',3]-tract_lng)*_pi/360)^2))
    replace site=M[`r',1] if `d'<mind | mind==.
    replace mind=`d' if `d'<mind | mind==.
    drop `d'
}
gen byte near30=mind<=30
gen double coal_expo=0
forvalues r=1/`NP' {
    tempvar d
    gen double `d'=`R'*2*asin(sqrt(sin((E[`r',2]-tract_lat)*_pi/360)^2+cos(tract_lat*_pi/180)*cos(E[`r',2]*_pi/180)*sin((E[`r',3]-tract_lng)*_pi/360)^2))
    gen double `d'_e=0
    forvalues y=2005/2010 {
        local col=`y'-2001
        replace `d'_e=E[`r',`col'] if bs_byear==`y'
    }
    replace coal_expo=coal_expo+cond(`d'<=50 & `d'>0,`d'_e/`d',0)
    drop `d' `d'_e
}
merge m:1 site ym using `mp', keep(1 3) keepusing(pb_preg) nogen
egen tractid=group(tract_lat tract_lng)
qui sum coal_expo if near30 & !missing(pb_preg)
gen z_coal=(coal_expo-r(mean))/r(sd)
count if near30 & !missing(pb_preg) & !missing(bw)
di "N births w/ lead exposure (<=30km of a TX lead monitor): " %12.0fc r(N)
qui sum pb_preg if near30
di "mean pregnancy lead (ug/m3) = " %6.4f r(mean)

di _n "===== FIRST STAGE / link-2: ambient pregnancy LEAD ~ coal emissions exposure (per SD) ====="
cap noisily reghdfe pb_preg z_coal if near30, absorb(tractid ym) cluster(site)
di _n "===== LEAD dose-response: birthweight & LBW ====="
cap noisily reghdfe bw pb_preg if near30, absorb(tractid ym) cluster(site)
cap noisily reghdfe lbw pb_preg if near30, absorb(tractid ym) cluster(site)
log close
