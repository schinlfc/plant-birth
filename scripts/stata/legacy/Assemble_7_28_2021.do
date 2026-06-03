********************************************************************************
* Monitor Data from Here: https://aqs.epa.gov/aqsweb/airdata/download_files.html
********************************************************************************


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

collapse (mean) plant_capacity, by(year month year_month entityid entityname plantid latitude longitude)

sort plantid year_month

save "${directory}collapsed_plant_capacity_1990_2020.dta", replace



// Graph Candidates Decreasing

local plantid 50 1378 2850  4941 2840 709 2866 3179 628 2341 2442 

foreach c of local plantid { 
twoway (scatter plant_capacity year_month if plantid==`c', mcolor(emidblue) msize(vsmall) msymbol(circle)), title(Plant ID `c' Decreasing, size(small)) ytitle(Production Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Monthly)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export "${directory}\decreasing_`c'.png", as(png) name("Graph") replace
}

// Graph Candidates Increasing

local plantid 60 130 602 1004 4078 6002 6019 6041 6096 6180 7030 7097

foreach c of local plantid { 
twoway (scatter plant_capacity year_month if plantid==`c', mcolor(emidblue) msize(vsmall) msymbol(circle)), title(Plant ID `c' Increasing, size(small)) ytitle(Production Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Monthly)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export "${directory}\increasing_`c'.png", as(png) name("Graph") replace
}

// Entering the World Counter-Factual

local plantid 10151 6019 6071 6180 7030 7097

foreach c of local plantid { 
twoway (scatter plant_capacity year_month if plantid==`c', mcolor(emidblue) msize(vsmall) msymbol(circle)), title(Plant ID `c' Counter-Factual, size(small)) ytitle(Production Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Monthly)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export "${directory}\counter_`c'.png", as(png) name("Graph") replace
}



// One Off

twoway (scatter plant_capacity year_month if plantid==50, mcolor(emidblue) msize(vsmall) msymbol(circle)), ytitle(Production Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Monthly)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	

// Matched Monitors to Plants
	
clear
import delimited "${directory}monitor_plant_distances_unique1.csv"
tostring monitor_id, gen(monitor)
rename plant_code plantid
save "${directory}matched.dta", replace
 

// Import Improve Data\
clear

import delimited "${directory}daily_LEAD_improve.csv"
rename countyfips fips
rename pbfval arithmeticmean
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

save "${directory}lead_improve.dta", replace

// Import Lead Monitor Data
clear 

import delimited "${directory}daily_LEAD_1990.csv"

save "${directory}lead_1990.dta", replace
clear 

import delimited "${directory}daily_LEAD_1991.csv"

save "${directory}lead_1991.dta", replace
clear 

import delimited "${directory}daily_LEAD_1992.csv"

save "${directory}lead_1992.dta", replace
clear 

import delimited "${directory}daily_LEAD_1993.csv"

save "${directory}lead_1993.dta", replace
clear 

import delimited "${directory}daily_LEAD_1994.csv"

save "${directory}lead_1994.dta", replace
clear 

import delimited "${directory}daily_LEAD_1995.csv"

save "${directory}lead_1995.dta", replace
clear 

import delimited "${directory}daily_LEAD_1996.csv"

save "${directory}lead_1996.dta", replace
clear 

import delimited "${directory}daily_LEAD_1997.csv"

save "${directory}lead_1997.dta", replace
clear 


import delimited "${directory}daily_LEAD_1998.csv"

save "${directory}lead_1998.dta", replace
clear 

import delimited "${directory}daily_LEAD_1999.csv"

save "${directory}lead_1999.dta", replace
clear 

import delimited "${directory}daily_LEAD_2000.csv"

save "${directory}lead_2000.dta", replace
clear 

import delimited "${directory}daily_LEAD_2001.csv"

save "${directory}lead_2001.dta", replace
clear 

import delimited "${directory}daily_LEAD_2002.csv"

save "${directory}lead_2002.dta", replace
clear 

import delimited "${directory}daily_LEAD_2003.csv"

save "${directory}lead_2003.dta", replace
clear 

import delimited "${directory}daily_LEAD_2004.csv"

save "${directory}lead_2004.dta", replace
clear 

import delimited "${directory}daily_LEAD_2005.csv"

save "${directory}lead_2005.dta", replace
clear 

import delimited "${directory}daily_LEAD_2006.csv"

save "${directory}lead_2006.dta", replace
clear 

import delimited "${directory}daily_LEAD_2007.csv"

save "${directory}lead_2007.dta", replace
clear 

import delimited "${directory}daily_LEAD_2008.csv"

save "${directory}lead_2008.dta", replace
clear 

import delimited "${directory}daily_LEAD_2009.csv"

save "${directory}lead_2009.dta", replace
clear 

import delimited "${directory}daily_LEAD_2010.csv"

save "${directory}lead_2010.dta", replace
clear 

import delimited "${directory}daily_LEAD_2011.csv"

save "${directory}lead_2011.dta", replace
clear 

import delimited "${directory}daily_LEAD_2012.csv"

save "${directory}lead_2012.dta", replace
clear 

import delimited "${directory}daily_LEAD_2013.csv"

save "${directory}lead_2013.dta", replace
clear 

import delimited "${directory}daily_LEAD_2014.csv"

save "${directory}lead_2014.dta", replace
clear 

import delimited "${directory}daily_LEAD_2015.csv"

save "${directory}lead_2015.dta", replace
clear 

import delimited "${directory}daily_LEAD_2016.csv"

save "${directory}lead_2016.dta", replace
clear 

import delimited "${directory}daily_LEAD_2017.csv"

save "${directory}lead_2017.dta", replace
clear 

import delimited "${directory}daily_LEAD_2018.csv"

save "${directory}lead_2018.dta", replace
clear 

import delimited "${directory}daily_LEAD_2019.csv"

save "${directory}lead_2019.dta", replace
clear 

import delimited "${directory}daily_LEAD_2020.csv"

save "${directory}lead_2020.dta", replace
clear 

import delimited "${directory}daily_LEAD_2021.csv"

save "${directory}lead_2021.dta", replace

append using "${directory}lead_2020.dta" "${directory}lead_2019.dta" "${directory}lead_2018.dta" "${directory}lead_2017.dta" "${directory}lead_2016.dta" "${directory}lead_2015.dta" "${directory}lead_2014.dta" "${directory}lead_2013.dta" "${directory}lead_2012.dta" "${directory}lead_2011.dta" "${directory}lead_2010.dta" "${directory}lead_2009.dta" "${directory}lead_2008.dta" "${directory}lead_2007.dta" "${directory}lead_2006.dta" "${directory}lead_2005.dta" "${directory}lead_2004.dta" "${directory}lead_2003.dta" "${directory}lead_2002.dta" "${directory}lead_2001.dta" "${directory}lead_2000.dta" "${directory}lead_1999.dta" "${directory}lead_1998.dta" "${directory}lead_1997.dta" "${directory}lead_1996.dta" "${directory}lead_1995.dta" "${directory}lead_1994.dta" "${directory}lead_1993.dta" "${directory}lead_1992.dta" "${directory}lead_1991.dta" "${directory}lead_1990.dta"

gen fips = statecode*1000+countycode

// Date operations

gen date = date(datelocal, "YMD")
format date %td
gen date1 = date(datelocal, "MDY")
replace date = date1 if date==.
format date1 %td
gen dow = dow(date)
gen month = month(date)
gen year = year(date)
gen year_month = ym(year, month)
format year_month %tm

// Create Monitor ID

tostring statecode, gen(state_code)
tostring countycode, gen(county_code)
tostring sitenum, gen(site)
gen monitor_id = state_code+county_code+site



// Append Improve 

append using "${directory}lead_improve.dta" 
encode monitor_id, gen(monitor_id1)
gen monitor_id2 = monitor_id1*1

// Address Duplicates

sort monitor_id1 date
quietly by monitor_id1 date:  gen dup = cond(_N==1,0,_n)
drop if dup>=2
drop dup

// Check

sort monitor_id1 date
quietly by monitor_id1 date:  gen dup = cond(_N==1,0,_n)
sum dup


// Eclipse NAAQS

recode arithmeticmean (-99/.1499999=0) (.15/9999=1), gen(excess)
gen count_cases = 1
sort monitor_id1
by monitor_id1: egen sum_count = total(count_cases)
by monitor_id1: egen sum_excess = total(excess)
gen exceedance = (sum_excess/sum_count)*100
by monitor_id1: egen max_year = max(year)
by monitor_id1: egen min_year = min(year)


save "${directory}lead_1990_2021.dta", replace



// Join Matched

merge m:1 monitor_id using "${directory}matched.dta"
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

gen log_arithmeticmean = ln(arithmeticmean+.01)
gen log1_arithmeticmean = ln(arithmeticmean)

gen log_plant_capacity = ln(plant_capacity+.01)
gen log_distance = ln(distance)
gen sqr_distance = sqrt(distance)

// Declare Longitudinal

xtset monitor_id1 date, daily

// Identify Phaseout
sort monitor_id1
by monitor_id1: egen min_capacity = min(plant_capacity)
by monitor_id1: egen max_capacity = max(plant_capacity)

gen difference_year = max_year-min_year


// Restrict (Discover Dyads with Complete Phaseout, Long Monitor Series, and within 10km)

tabstat difference_year monitor_id2 if min_capa==0 & distance<=10 , stat(max) by(plantid)


recode plantid (469 646 867 886 981 995 996 1732 1904 1912 1927 2838 3115 3161 3788 4125 6994 7286 10111 10377 10515 10566 10628 10640 10672 10676 10743 10866 50130 50651 50888 54556 55076 57907 = 1), gen(select_criteria)

recode select_criteria (2/99999=0)

********************************************************************************


// Candidate Case Studies


// Plant ID 646, Monitor ID 31/34 
// Conventional Steam Coal	BIT	27.9072	-82.4231
// https://www.google.com/maps/place/27%C2%B054'25.9%22N+82%C2%B025'23.2%22W/@27.9072,-82.4252887,795m/data=!3m2!1e3!4b1!4m5!3m4!1s0x0:0x0!8m2!3d27.9072!4d-82.4231


twoway (scatter ari date if [monitor_id1==34 | monitor_id1==31], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==34 | monitor_id1==31], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


// Plant ID 886, Monitor ID 120


twoway (scatter ari date if monitor_id1==120, yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if monitor_id1==120, mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


// Plant ID 981, Monitor ID 123/134/128/177

twoway (scatter ari date if [monitor_id1==123 | monitor_id1==134 | monitor_id1==128 | monitor_id1==177], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==123 | monitor_id1==134 | monitor_id1==128 | monitor_id1==177], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

// Plant ID 995, Monitor ID 995

twoway (scatter ari date if [monitor_id1==153], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==153], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


// Plant ID 996, Monitor ID 169/176

twoway (scatter ari date if [monitor_id1==169 | monitor_id1==176], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==169 | monitor_id1==176], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


// Plant ID 1927, Monitor ID 416/370

twoway (scatter ari date if [monitor_id1==416 | monitor_id1==370 ], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==416 | monitor_id1==370], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


// Plant ID 2838, Monitor ID 646/634

twoway (scatter ari date if [monitor_id1==646 | monitor_id1==634], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==646 | monitor_id1==634], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

// Plant ID 3115, Monitor ID 737/738

twoway (scatter ari date if [monitor_id1==738 | monitor_id1==737], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==738 | monitor_id1==737], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

// Plant ID 3161, Monitor ID 737/738

twoway (scatter ari date if [monitor_id1==731 | monitor_id1==781], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==731 | monitor_id1==781], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


// Plant ID 3788, Monitor ID 289


twoway (scatter ari date if monitor_id1==289, yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if monitor_id1==289, mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

// Plant ID 6094, Monitor ID 628 ***

twoway (scatter ari date if [monitor_id1==628], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==628], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

// Plant ID 7286, Monitor ID 621/623 ***

twoway (scatter ari date if [monitor_id1==623 | monitor_id1==621 ], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==623 | monitor_id1==621 ], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

// Plant ID 10515, Monitor ID 999 ***

twoway (scatter ari date if [monitor_id1==999 ], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==999 ], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


// Plant ID 10640, Monitor ID 1128

twoway (scatter ari date if [monitor_id1==1128], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==1128], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


// Plant ID 10676, Monitor ID 793


twoway (scatter ari date if monitor_id1==793, yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if monitor_id1==793, mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


// Plant ID 50130, Monitor ID 791/794


twoway (scatter ari date if [monitor_id1==791 | monitor_id1==794], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==791 | monitor_id1==794], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


//Plant ID 57907, Monitor ID 1103/1113

twoway (scatter ari date if [monitor_id1==1113 | monitor_id1==1103 ], yaxis(2) mcolor(maroon) msize(vsmall) msymbol(circle)) (scatter plant_capacity date if [monitor_id1==1113 | monitor_id1==1103], mcolor(emidblue) msize(vsmall) msymbol(circle)) , ytitle(Plant Capacity (MW)) ytitle(, size(medsmall)) ylabel(#10, labsize(small) nogrid) xtitle(Time (Daily)) xtitle(, size(medsmall)) xlabel(#10, labsize(vsmall) angle(forty_five) nogrid) legend(off) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


********************************************************************************

// Analysis ALL

// Regular Unit

regress arithmeticmean i.month  i.dow c.distance i.capacity_on i.plantid if select_criteria==1 & distance<=10
margins capacity_on

regress arithmeticmean i.month i.dow c.distance i.capacity_on i.plantid if select_criteria==1 & distance<=5
margins capacity_on

regress arithmeticmean i.month i.dow c.distance i.capacity_on i.plantid if select_criteria==1 & distance<=3
margins capacity_on


// Log Response

regress log_arithmeticmean i.month  i.dow c.distance i.capacity_on i.plantid if select_criteria==1 & distance<=10
margins capacity_on

// Log Response Areg

areg log_arithmeticmean i.month  i.dow c.distance i.capacity_on if select_criteria==1 & distance<=10, absorb(plantid)
margins capacity_on

// Log Response Log Capacity

areg log_arithmeticmean i.month  i.dow c.distance log_plant_capacity if select_criteria==1 & distance<=10, absorb(plantid)

areg log_arithmeticmean i.month  i.dow c.distance plant_capacity if select_criteria==1 & distance<=10, absorb(plantid)
margins, at (plant_capacity=(0(50)1000))

// Interaction of Distance and Capacity Dummy

areg log_arithmeticmean i.month  i.dow c.distance##i.capacity_on if select_criteria==1 & distance<=10, absorb(plantid)
margins capacity_on, at (distance = (0(.5)10))

********************************************************************************
// Most recent decade and 5km (This First)

areg ari i.month i.dow sqr_distance i.capacity_on if select_criteria==1 & distance<=5 & decade==3, absorb(plantid)
margins capacity_on


// Most recent decade and 3km (This Second)

areg ari i.month i.dow sqr_distance i.capacity_on if select_criteria==1 & distance<=3 & decade==3, absorb(plantid)
margins capacity_on


// Interaction

areg ari i.month i.dow c.sqr_distance##i.capacity_on if select_criteria==1 & distance<=5 & decade==3, absorb(plantid)

// Moving in increments of 0.25km till 5km

margins capacity_on, at (sqr_distance=(0.50 0.71 0.87 1.00 1.12 1.22 1.32 1.41 1.50 1.58 1.66 1.73 1.80 1.87 1.94 2.00 2.06 2.12 2.18 2.24))
marginsplot

areg ari i.month i.dow c.sqr_distance##i.capacity_on if select_criteria==1 & distance<=3 & decade==3, absorb(plantid)

// Moving in increments of 0.25km till 3km

margins capacity_on, at (sqr_distance=(0.50 0.71 0.87 1.00 1.12 1.22 1.32 1.41 1.50 1.58 1.66 1.73))
marginsplot

// No Zero out restriction


areg ari i.month i.dow sqr_distance i.capacity_on if  distance<=3 & decade==3, absorb(plantid)
margins capacity_on

areg ari i.month i.dow sqr_distance i.capacity_on if  distance<=5 & decade==3, absorb(plantid)
margins capacity_on


areg ari i.month i.dow sqr_distance i.capacity_on if  distance<=10 & decade==3, absorb(plantid)
margins capacity_on

********************************************************************************
// Analysis (Restricting to Candidates)

regress log_arithmeticmean i.month  i.dow c.distance i.capacity_on i.plantid if [plantid==646| plantid==867 | plantid==886 | plantid==981 | plantid==995 | plantid==996 | plantid==1917 | plantid==2838 | plantid==3115 | plantid==3161 | plantid==3788 | plantid==6094 | plantid==7286 | plantid==10515 | plantid==10640 | plantid==10676 | plantid==50130 | plantid==57907 ] & distance<=10
margins capacity_on

regress log_arithmeticmean i.month  i.dow c.distance i.capacity_on i.plantid if [plantid==646| plantid==867 | plantid==886 | plantid==981 | plantid==995 | plantid==996 | plantid==1917 | plantid==2838 | plantid==3115 | plantid==3161 | plantid==3788 | plantid==6094 | plantid==7286 | plantid==10515 | plantid==10640 | plantid==10676 | plantid==50130 | plantid==57907 ] & distance<=5
margins capacity_on


// Log Distance

regress log_arithmeticmean i.month  i.dow log_distance i.capacity_on i.plantid if [plantid==646| plantid==867 | plantid==886 | plantid==981 | plantid==995 | plantid==996 | plantid==1917 | plantid==2838 | plantid==3115 | plantid==3161 | plantid==3788 | plantid==6094 | plantid==7286 | plantid==10515 | plantid==10640 | plantid==10676 | plantid==50130 | plantid==57907 ] & distance<=10
margins capacity_on

// Log Capacity

regress log_arithmeticmean i.month  i.dow log_distance log_plant_capacity i.plantid if [plantid==646| plantid==867 | plantid==886 | plantid==981 | plantid==995 | plantid==996 | plantid==1917 |  plantid==2838 | plantid==3115 | plantid==3161 | plantid==3788 | plantid==6094 | plantid==7286 | plantid==10515 | plantid==10640 | plantid==10676 | plantid==50130 | plantid==57907 ] & distance<=10



// Interaction

regress log_arithmeticmean i.month  i.dow c.distance##i.capacity_on i.plantid if [plantid==646| plantid==867 | plantid==886 | plantid==981 | plantid==995 | plantid==996 | plantid==1917 | plantid==2838 | plantid==3115 | plantid==3161 | plantid==3788 | plantid==6094 | plantid==7286 | plantid==10515 | plantid==10640 | plantid==10676 | plantid==50130 | plantid==57907 ] & distance<=10
margins capacity_on, at (distance = (0(.5)10))













