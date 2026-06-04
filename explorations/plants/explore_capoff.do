version 19
clear all
set more off
cap log close _all
log using "explorations/plants/explore_capoff.log", text replace

* TX plant ids from generator file
use "earth_justic_data_codes/retired_operational.dta", clear
keep plantid plantstate
duplicates drop plantid, force
tempfile st
save `st'

use "earth_justic_data_codes/collapsed_plant_capacity_1990_2020.dta", clear
merge m:1 plantid using `st', keep(1 3) nogen
gen byte tx = plantstate=="TX"
xtset plantid year_month
bys plantid (year_month): gen byte turns_off = (plant_capacity[_n-1]>0 & plant_capacity==0 & _n>1)

di _n "===== National: plant full capacity->0 transitions, by calendar year ====="
tab year if turns_off
di _n "===== TEXAS: plant full capacity->0 transitions, by calendar year ====="
tab year if turns_off & tx==1
di _n "===== Distinct TX plants that EVER fully switch off, and earliest off-year ====="
preserve
keep if tx==1
egen everoff = max(turns_off), by(plantid)
gen offy = year if turns_off
bys plantid: egen first_off = min(offy)
egen tagp = tag(plantid)
list plantid first_off if tagp & everoff, noobs
restore

di _n "===== Sanity: TX coal plant-month capacity range & coverage ====="
sum plant_capacity if tx==1, detail
tab year if tx==1 & plant_capacity>0, nofreq
log close
