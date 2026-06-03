/*------------------------------------------------------------
File:       02_descriptive.do
Purpose:    Summary statistics, balance, treatment-timing distribution
Inputs:     scripts/stata/_outputs/clean_panel.dta
Outputs:    scripts/stata/_outputs/desc_summary.tex
Run order:  After 01_clean.do
Project:    Decommissioning Coal-Fired Power Plants and Infant Health in TX
------------------------------------------------------------*/

version 19
clear all
set more off
set seed 12345
set sortseed 12345
cap log close _all
log using "scripts/stata/_outputs/02_descriptive.smcl", replace

* TODO: implement.
* Sample description, pre-treatment balance, event counts by cohort.
* Report aggregates only (no record-level output). See knowledge base.

log close
