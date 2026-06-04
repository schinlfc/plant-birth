/*------------------------------------------------------------
File:    explorations/plants/explore_plants.do
Purpose: First-pass schema and size of the EIA plant/generator data
Inputs:  earth_justic_data_codes/{operational,retired,retired_operational,
         collapsed_plant_capacity_1990_2020}.dta  (public EIA, read-only)
Outputs: explorations/plants/explore_plants.log
------------------------------------------------------------*/

version 19
clear all
set more off
cap log close _all
log using "explorations/plants/explore_plants.log", text replace

foreach f in operational retired retired_operational collapsed_plant_capacity_1990_2020 {
    di _newline(2) "{hline 72}"
    di "FILE: `f'.dta"
    di "{hline 72}"
    use "earth_justic_data_codes/`f'.dta", clear
    di "N obs = " %15.0fc _N
    describe, short
    di _newline "--- codebook (compact) ---"
    codebook, compact
}

log close
