/*------------------------------------------------------------
File:       05_tables_figures.do
Purpose:    Assemble final paper tables and figures
Inputs:     scripts/stata/_outputs estimates and .dta
Outputs:    scripts/stata/_outputs/tab_main.tex, fig_eventstudy.pdf and .png
Run order:  After 03 and 04
Project:    Decommissioning Coal-Fired Power Plants and Infant Health in TX
------------------------------------------------------------*/

version 19
clear all
set more off
set seed 12345
set sortseed 12345
cap log close _all
log using "scripts/stata/_outputs/05_tables_figures.smcl", replace

* TODO: implement.
* Final esttab tables and graph export (white background, vector PDF plus PNG).
* These are input and includegraphics targets for manuscript/main.tex.

log close
