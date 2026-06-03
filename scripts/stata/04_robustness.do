/*------------------------------------------------------------
File:       04_robustness.do
Purpose:    Alternative specs, distance bands, placebo, multiple testing
Inputs:     scripts/stata/_outputs/clean_panel.dta
Outputs:    scripts/stata/_outputs/robust_specs.tex
Run order:  After 03_analyze.do
Project:    Decommissioning Coal-Fired Power Plants and Infant Health in TX
------------------------------------------------------------*/

version 19
clear all
set more off
set seed 12345
set sortseed 12345
cap log close _all
log using "scripts/stata/_outputs/04_robustness.smcl", replace

* TODO: implement.
* Distance bands (3, 5, 10 km), dose-response, selective migration and
* fertility checks, multiple-hypothesis-testing adjustment across outcomes.

log close
