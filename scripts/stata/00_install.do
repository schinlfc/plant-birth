/*------------------------------------------------------------
File:       00_install.do
Purpose:    Install packages, set globals and paths, write sessionInfo
Inputs:     none
Outputs:    scripts/stata/_outputs/sessionInfo.txt
Run order:  Standalone (run first)
Project:    Decommissioning Coal-Fired Power Plants and Infant Health in TX
------------------------------------------------------------*/

version 19                         // StataNow/SE 19.5
clear all
set more off
set seed 12345                     // pin RNG
set sortseed 12345                 // pin sort stability
cap log close _all
log using "scripts/stata/_outputs/00_install.smcl", replace

* packages (uncomment as needed; safe to re-run)
* ssc install reghdfe, replace         // high-dimensional FE
* ssc install ftools, replace
* ssc install estout, replace          // esttab tables
* ssc install csdid, replace           // Callaway and Sant'Anna
* ssc install drdid, replace           // doubly-robust DiD (csdid dependency)
* ssc install eventdd, replace         // event-study plots
* ssc install did_multiplegt, replace  // de Chaisemartin and D'Haultfoeuille
* did2s / Sun-Abraham / Borusyak: install from preferred source

* project globals (paths RELATIVE to repo root; run Stata from root)
global BIRTH   "birth"
global ENERGY  "earth_justic_data_codes"
global OUT     "scripts/stata/_outputs"

* sessionInfo: record versions actually used (AEA compliance)
log close
log using "$OUT/sessionInfo.txt", text replace
about
* which reghdfe
* which csdid
* which estout
log close
