/*------------------------------------------------------------
File:    06_fetal_death.do
Purpose: ZIP x year fetal-death rate vs pregnancy-window PM2.5 (mortality margin)
Inputs:  birth/combined_birth_data.dta (live births), birth/Fet{2005..2010}.dbf,
         earth_justic_data_codes/aqs/tx_88101.csv
Outputs: scripts/stata/_outputs/06_*.smcl (git-ignored)
------------------------------------------------------------*/
version 19
clear all
set more off
set seed 12345
cap log close _all
log using "scripts/stata/_outputs/06_fetal.smcl", replace text

* ---------- A) ZIP x year LIVE BIRTHS + zip centroid ----------
use b_mrzip bs_byear tract_lat tract_lng using "birth/combined_birth_data.dta", clear
keep if inrange(bs_byear,2005,2010)
gen zip5 = substr(b_mrzip,1,5)
destring zip5, gen(zipn) force
drop if missing(zipn)
gen byte one = 1
collapse (sum) births=one (mean) zlat=tract_lat zlon=tract_lng, by(zip5 bs_byear)
rename bs_byear year
tempfile bz
save `bz'

* ---------- B) ZIP x year FETAL DEATHS ----------
clear
tempfile fd
local first 1
foreach y in 2005 2006 2007 2008 2009 2010 {
    import dbase using "birth/Fet`y'.dbf", clear
    cap confirm string variable F_RZIP
    if _rc tostring F_RZIP, replace force
    gen zip5 = substr(F_RZIP,1,5)
    gen year = `y'
    keep zip5 year
    if `first' {
        save `fd', replace
        local first 0
    }
    else {
        append using `fd'
        save `fd', replace
    }
}
gen byte one2 = 1
collapse (sum) fdeaths_n=one2, by(zip5 year)
keep zip5 year fdeaths_n
tempfile fdz
save `fdz'

* ---------- C) merge -> fetal-death rate ----------
use `bz', clear
merge 1:1 zip5 year using `fdz', keep(1 3) nogen
replace fdeaths_n = 0 if missing(fdeaths_n)
gen frate = 1000*fdeaths_n/(births+fdeaths_n)     // per 1,000 pregnancies
destring zip5, gen(zipid) force
di "ZIP x year cells: " _N
sum births fdeaths_n frate, detail
qui sum fdeaths_n
di "Total fetal deaths 2005-2010 (matched zips): " %12.0fc r(sum)

* ---------- D) zip-year PM2.5 (annual mean at nearest monitor) ----------
preserve
import delimited "earth_justic_data_codes/aqs/tx_88101.csv", varnames(1) clear
gen edate = date(datelocal,"YMD")
gen yr = year(edate)
egen site = group(statecode countycode sitenum)
collapse (mean) pm25=arithmeticmean slat=latitude slon=longitude, by(site yr)
tempfile mp
save `mp'
collapse (mean) slat slon, by(site)
mkmat site slat slon, matrix(M)
restore
local NM = rowsof(M)
gen double mind=.
gen long site=.
local R 6371
forvalues r=1/`NM' {
    tempvar d
    gen double `d' = `R'*2*asin(sqrt(sin((M[`r',2]-zlat)*_pi/360)^2 ///
        + cos(zlat*_pi/180)*cos(M[`r',2]*_pi/180)*sin((M[`r',3]-zlon)*_pi/360)^2))
    replace site = M[`r',1] if `d'<mind | mind==.
    replace mind = `d' if `d'<mind | mind==.
    drop `d'
}
rename year yr
merge m:1 site yr using `mp', keep(1 3) keepusing(pm25) nogen
rename yr year
gen byte near30 = mind<=30

* ---------- E) estimate ----------
di _n "===== Fetal-death rate (per 1,000) ~ annual PM2.5; ZIP + year FE; wt=births; cl=ZIP ====="
reghdfe frate pm25 if near30 [aw=births], absorb(zipid year) cluster(zipid)
di "  (coef = change in fetal deaths per 1,000 pregnancies per 1 ug/m3 PM2.5)"
qui sum frate if near30 [aw=births]
di "  mean fetal-death rate (per 1,000) = " %5.2f r(mean)
cap which ppmlhdfe
if !_rc {
    di _n "===== Poisson (count) check: ppmlhdfe fdeaths ~ pm25, offset births, ZIP+year FE ====="
    gen lnbirths = ln(births+fdeaths_n)
    cap ppmlhdfe fdeaths_n pm25 if near30, absorb(zipid year) offset(lnbirths) cluster(zipid)
}
log close
