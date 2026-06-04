version 19
clear all
set more off
cap log close _all
log using "explorations/plants/explore_controls.log", text replace

use "earth_justic_data_codes/retired_operational.dta", clear
keep if plantstate=="TX"
keep plantid plantname
duplicates drop
rename plantid PlantCode
tempfile txcoal
save `txcoal'

import excel using "earth_justic_data_codes/eia8602018/6_1_EnviroAssoc_Y2018.xlsx", ///
    sheet("Emissions Control Equipment") cellrange(A2) firstrow allstring clear
destring PlantCode InserviceYear RetirementYear, replace force

merge m:1 PlantCode using `txcoal'
di _n "merge result (3 = TX coal plant control devices):"
tab _merge
keep if _merge==3
drop _merge

di _n "===== TX coal-plant control devices: equipment type ====="
tab EquipmentType, m
di _n "===== In-service YEAR (all TX coal control devices) ====="
tab InserviceYear, m
gen byte inwin = inrange(InserviceYear,2003,2010)
di _n "===== Installed within 2003-2010 birth window? ====="
tab inwin, m
di _n "===== Type x in-window crosstab ====="
tab EquipmentType inwin, m
di _n "===== Distinct TX coal plants with a control device installed 2003-2010 ====="
preserve
keep if inwin==1
egen tagp = tag(PlantCode)
count if tagp
list PlantCode plantname EquipmentType InserviceYear if inwin==1, sepby(PlantCode) noobs
restore
log close
