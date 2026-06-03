/*------------------------------------------------------------
File:       03_analyze.do
Purpose:    Main DiD and event-study estimates (heterogeneity-robust)
Inputs:     scripts/stata/_outputs/clean_panel.dta
Outputs:    scripts/stata/_outputs/main_results.tex, eventstudy.pdf
Run order:  After 01_clean.do
Project:    Decommissioning Coal-Fired Power Plants and Infant Health in TX
------------------------------------------------------------*/

version 19
clear all
set more off
set seed 12345
set sortseed 12345
cap log close _all
log using "scripts/stata/_outputs/03_analyze.smcl", replace

* TODO: implement.
* Staggered DiD via csdid, did_multiplegt, or did2s; event-study pre-trends;
* esttab into _outputs as .tex. Cluster at treatment-assignment level.

log close
