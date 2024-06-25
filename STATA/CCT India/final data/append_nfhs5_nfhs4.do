* This file is to append nfhs4 and nfhs5 data

                                                 
clear all 
cap log close
set more off

* nfhs5
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\inter_nfhs5\nfhs5.dta", clear

append using "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\inter_nfhs4\nfhs4.dta"

save "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", replace