version 19
clear all
set more off
use "earth_justic_data_codes/cems/cems_tx12_monthly.dta", clear

label define pl 3470 "W A Parish" 3497 "Big Brown" 6146 "Martin Lake" ///
  6147 "Monticello" 6178 "Coleto Creek" 6180 "Oak Grove" 6181 "J T Deely" ///
  6648 "Sandow 4" 7030 "Major Oak" 7097 "J K Spruce" 7902 "Pirkey" 52071 "Sandow 5"
label values facilityid pl

local opts graphregion(color(white)) plotregion(color(white)) ///
           xtitle("") ytitle(, size(small)) subtitle(, size(small))

* Fig 1: NOx small multiples
twoway line nox ym, sort lcolor(navy) lwidth(medthin) ///
   by(facilityid, note("") title("Monthly NOx emissions, TX coal plants with 2003-2010 control retrofits", size(small)) ///
       subtitle("short tons/month; source: EPA CAMPD daily CEMS", size(vsmall)) graphregion(color(white))) ///
   ylabel(, labsize(vsmall) angle(horizontal)) xlabel(516(24)612, labsize(vsmall)) `opts'
graph export "explorations/plants/figures/cems_nox_panel.png", replace width(2400)
graph export "explorations/plants/figures/cems_nox_panel.pdf", replace

* Fig 2: SO2 small multiples
twoway line so2 ym, sort lcolor(maroon) lwidth(medthin) ///
   by(facilityid, note("") title("Monthly SO{sub:2} emissions, TX coal plants with 2003-2010 control retrofits", size(small)) ///
       subtitle("short tons/month; source: EPA CAMPD daily CEMS", size(vsmall)) graphregion(color(white))) ///
   ylabel(, labsize(vsmall) angle(horizontal)) xlabel(516(24)612, labsize(vsmall)) `opts'
graph export "explorations/plants/figures/cems_so2_panel.png", replace width(2400)
graph export "explorations/plants/figures/cems_so2_panel.pdf", replace

* Hero 1: W A Parish NOx with SCR install (2003-04)
twoway line nox ym if facilityid==3470, sort lcolor(navy) lwidth(medium) ///
   xline(`=ym(2004,1)', lcolor(red) lpattern(dash)) ///
   title("W A Parish: NOx falls at SCR installation", size(medsmall)) ///
   subtitle("monthly NOx (short tons); dashed line = SCR online (2004)", size(vsmall)) ///
   ytitle("NOx (short tons/month)", size(small)) xtitle("") ///
   ylabel(, angle(horizontal) labsize(small)) xlabel(516(12)612, labsize(small)) ///
   graphregion(color(white)) plotregion(color(white))
graph export "explorations/plants/figures/hero_parish_nox.png", replace width(2000)

* Hero 2: Pirkey SO2 with control (2006)
twoway line so2 ym if facilityid==7902, sort lcolor(maroon) lwidth(medium) ///
   xline(`=ym(2006,1)', lcolor(red) lpattern(dash)) ///
   title("Pirkey: SO{sub:2} falls ~85% at 2006 control", size(medsmall)) ///
   subtitle("monthly SO{sub:2} (short tons); dashed line = control online (2006)", size(vsmall)) ///
   ytitle("SO{sub:2} (short tons/month)", size(small)) xtitle("") ///
   ylabel(, angle(horizontal) labsize(small)) xlabel(516(12)612, labsize(small)) ///
   graphregion(color(white)) plotregion(color(white))
graph export "explorations/plants/figures/hero_pirkey_so2.png", replace width(2000)
di "figures done"
