/*------------------------------------------------------------
File:    explorations/plants/explore_plants_tx.do
Purpose: Coal confirmation, geography, and retirement timing vs the
         2003-2010 Texas birth window (feasibility of the natural experiment)
Inputs:  earth_justic_data_codes/retired_operational.dta,
         collapsed_plant_capacity_1990_2020.dta (public EIA)
Outputs: explorations/plants/explore_plants_tx.log
------------------------------------------------------------*/
version 19
clear all
set more off
cap log close _all
log using "explorations/plants/explore_plants_tx.log", text replace

use "earth_justic_data_codes/retired_operational.dta", clear

di _n "===== Coal confirmation (energy source / technology / prime mover) ====="
tab energysourcecode, m
tab technology, m
tab primemovercode, m

di _n "===== Retired vs operational ====="
tab retired, m

di _n "===== Plant state (generator counts), sorted ====="
tab plantstate, sort

di _n "===== Texas? ====="
gen byte tx = plantstate=="TX"
tab tx, m
di "Distinct plants overall: "
egen tag_all = tag(plantid)
count if tag_all
di "Distinct plants in TX: "
egen tag_tx = tag(plantid) if tx
count if tag_tx

di _n "===== Retirement YEAR distribution (retired generators only) ====="
tab retirementyear if retired==1, m
di _n "--- flag the 2003-2010 birth window ---"
gen byte retire_in_window = inrange(retirementyear,2003,2010) if retired==1
tab retire_in_window if retired==1, m

di _n "===== TEXAS retired generators by retirement year ====="
tab retirementyear if retired==1 & tx==1, m

di _n "===== TEXAS: distinct retired plants, by whether retirement is in 2003-2010 ====="
preserve
keep if retired==1 & tx==1
egen tagp = tag(plantid)
gen byte inwin = inrange(retirementyear,2003,2010)
di "TX retired generators: " _N
count if tagp
di "  ^ distinct TX retired plants"
tab inwin if tagp, m
di _n "--- TX retired plants: id, name, retire year, nameplate MW (generator rows) ---"
sort plantid retirementyear
list plantid plantname retirementyear nameplatecapacitymw energysourcecode, sepby(plantid) noobs
restore

di _n(2) "===== Capacity->0 (full decommission) timing from the monthly panel ====="
use "earth_justic_data_codes/collapsed_plant_capacity_1990_2020.dta", clear
gen year = year(dofm(year_month))
xtset plantid year_month
* first month a plant hits exactly 0 after having been >0
gen byte was_on  = plant_capacity>0
bys plantid (year_month): gen byte turns_off = was_on[_n-1]==1 & plant_capacity==0
gen offyear = year if turns_off
di "Plant-months with a capacity->0 transition, by year (national):"
tab offyear, m
di "Distinct plants that ever fully switch off:"
egen everoff = max(turns_off), by(plantid)
egen tagp2 = tag(plantid)
count if tagp2 & everoff

log close
