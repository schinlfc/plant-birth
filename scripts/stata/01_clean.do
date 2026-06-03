/*------------------------------------------------------------
File:       01_clean.do
Purpose:    Build the cleaned plant x monitor x birth analysis panel
Inputs:     birth and earth_justic_data_codes raw data (read-only, git-ignored)
Outputs:    scripts/stata/_outputs/clean_panel.dta
Run order:  After 00_install.do
Project:    Decommissioning Coal-Fired Power Plants and Infant Health in TX
------------------------------------------------------------*/

version 19
clear all
set more off
set seed 12345
set sortseed 12345
cap log close _all
log using "scripts/stata/_outputs/01_clean.smcl", replace

* TODO: implement.
* Import EIA generators and EPA Pb monitors; match births and monitors to
* plants by distance; define treatment timing (capacity falling to zero).
* See .claude/rules/knowledge-base-template.md (design, variables, threats)
* and scripts/stata/legacy/Assemble_7_28_2021.do (reference pipeline).
* CONFIDENTIALITY: never list or browse or export raw microdata or tract IDs.

log close
