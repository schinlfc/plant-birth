version 19
clear all
set more off
cap log close _all
log using "explorations/plants/build_cems.log", text replace

local IDS 3470 3497 6146 6147 6178 6180 6181 6648 7030 7097 7902 52071
local files

foreach y in 2003 2004 2005 2006 2007 2008 2009 2010 {
    import delimited "earth_justic_data_codes/cems/emissions-daily-`y'-tx.csv", varnames(1) clear
    keep facilityid unitid date so2massshorttons noxmassshorttons co2massshorttons ///
         heatinputmmbtu grossloadmwh so2controls noxcontrols pmcontrols hgcontrols
    keep if inlist(facilityid, `=subinstr("`IDS'"," ",",",.)')
    gen edate = date(date,"YMD")
    gen yr = year(edate)
    gen mo = month(edate)
    tempfile f`y'
    save `f`y''
    local files `files' `f`y''
}
clear
append using `files'
di "plant-day rows for the 12 plants, 2003-2010: " _N

collapse (sum) so2=so2massshorttons nox=noxmassshorttons co2=co2massshorttons ///
               heat=heatinputmmbtu load=grossloadmwh, by(facilityid yr mo)
gen ym = ym(yr,mo)
format ym %tm
save "earth_justic_data_codes/cems/cems_tx12_monthly.dta", replace
di "monthly plant rows: " _N

di _n(2) "===== ANNUAL MEAN SO2 (short tons/month) by plant x year ====="
table facilityid yr, statistic(mean so2) nformat(%9.0f)
di _n(2) "===== ANNUAL MEAN NOx (short tons/month) by plant x year ====="
table facilityid yr, statistic(mean nox) nformat(%9.0f)
log close
