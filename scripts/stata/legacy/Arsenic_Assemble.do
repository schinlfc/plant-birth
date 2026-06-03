

clear all 
global directory "C:\Users\szahran\Desktop\Earth Justice Data\"

// Generator Data

use "${directory}retired.dta"
append using "${directory}operational.dta"
replace retired = 0 if retired==.
save "${directory}retired_operational.dta", replace

// Cross with Month and Year Shells

cross using "${directory}\month_shell.dta"
cross using "${directory}\year_shell.dta"

gen year_month = ym(year, month)
format year_month %tm
drop if year==2021 & month>=2

gen year_month_retire = ym(retirementyear, retirementmonth)
format year_month_retire %tm
quietly sum year_month_retire, detail
replace year_month_retire = `r(max)'+1 if year_month_retire==. 
gen year_month_operate = ym(operatingyear, operatingmonth)
format year_month_operate %tm

gen offline=1
replace offline =0 if year_month>=year_month_operate & year_month<=year_month_retire 

sort latitude longitude year_month
by latitude longitude year_month: egen plant_capacity = total(nameplatecapacitymw) if offline==0 
replace plant_capacity = 0 if plant_capacity==.

save "${directory}plant_capacity_1990_2020.dta", replace

collapse (mean) plant_capacity, by(year month entityid entityname plantid latitude longitude)

gen year_month = ym(year, month)
format year_month %tm

save "${directory}collapsed_plant_capacity_1990_2020.dta", replace


// Matched Monitors to Plants
	
clear
import delimited "${directory}arsenic_distance_matches.csv"
tostring monitor_id, gen(monitor)
rename plant_code plantid
save "${directory}matched_arsenic.dta", replace
clear 

// Import Improve Data\

import delimited "${directory}arsenic_IMPROVE.csv"
rename countyfips fips
rename asfval arithmeticmean
rename sitecode monitor_id

// Date operations

gen date1 = date(date, "MDY")
drop date
rename date1 date
format date %td
gen dow = dow(date)
gen month = month(date)
gen year = year(date)
gen year_month = ym(year, month)
format year_month %tm

// Drop missing

recode arithmeticmean (-999=.)

keep monitor_id date dow month year year_month latitude longitude fips arithmeticmean

save "${directory}arsenic_improve.dta", replace

// Address Duplicates

sort monitor_id date arithmeticmean
quietly by monitor_id date:  gen dup = cond(_N==1,0,_n)
drop if dup==1
drop dup

// Check

sort monitor_id date arithmeticmean
quietly by monitor_id date:  gen dup = cond(_N==1,0,_n)
sum dup


// Eclipse NAAQS

recode arithmeticmean (-99/0.004999999 =0) (0.005/9999=1), gen(excess)
gen count_cases = 1
sort monitor_id
by monitor_id: egen sum_count = total(count_cases)
by monitor_id: egen sum_excess = total(excess)
gen exceedance = (sum_excess/sum_count)*100
by monitor_id: egen max_year = max(year)
by monitor_id: egen min_year = min(year)

merge m:1 monitor_id using "${directory}matched_arsenic.dta"
drop _merge

// Join Capacity Data

merge m:1 plantid year_month using "${directory}collapsed_plant_capacity_1990_2020.dta"
drop if _merge==1 | _merge==2
drop _merge

// Capacity Categorical

recode plant_capacity (0=0) (.0001/99999=1), gen(capacity_on)
xtile capacity_terciles = plant_capacity, nquantiles(3)


// Recode Year

recode year (1990/1999=1) (2000/2009=2) (2010/2021=3), gen(decades)


// Logs

gen log_arithmeticmean = ln(arithmeticmean+.019)
gen log1_arithmeticmean = ln(arithmeticmean)

gen log_plant_capacity = ln(plant_capacity+.01)
gen log_distance = ln(distance)
gen sqr_distance = sqrt(distance)

// Declare Longitudinal
encode monitor_id, gen(monitor_id1)
xtset monitor_id1 date, daily

// Identify Phaseout
sort monitor_id1
by monitor_id1: egen min_capacity = min(plant_capacity)
by monitor_id1: egen max_capacity = max(plant_capacity)

// Restrict (Discover Dyads with Complete Phaseout, Long Monitor Series, and within 10km)
gen difference = max_year-min_year
tabstat difference monitor_id1 if min_capa==0 & distance<=10 , stat(max) by(plantid)


