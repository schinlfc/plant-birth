/*------------------------------------------------------------
File:       99_run_all.do
Purpose:    One-command reproduction of all results
Inputs:     all raw data (read-only, git-ignored)
Outputs:    everything in scripts/stata/_outputs
Run order:  Master. Run from repo ROOT:
            STATA=/Applications/StataNow/StataSE.app/Contents/MacOS/stata-se
            "$STATA" -b do scripts/stata/99_run_all.do
Project:    Decommissioning Coal-Fired Power Plants and Infant Health in TX
------------------------------------------------------------*/

version 19
clear all
set more off

do "scripts/stata/00_install.do"
do "scripts/stata/01_clean.do"
do "scripts/stata/02_descriptive.do"
do "scripts/stata/03_analyze.do"
do "scripts/stata/04_robustness.do"
do "scripts/stata/05_tables_figures.do"

display "99_run_all.do complete."
