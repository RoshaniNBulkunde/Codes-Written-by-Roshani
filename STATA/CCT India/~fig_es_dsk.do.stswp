/* 
This file is to event study graphs for outcome variables 
*Roshani Bulkunde */

clear all
set more off
cap log close

* nfhs data
use "C:\Users\rbulkunde3\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures\ES driscoll_kray se"


* Keep the sample with birth order 1,2
drop if yob==2021 
keep if bord==1 | bord==2 
drop if bord==.

* Create eligible=1 if first born
gen  eligible=0
	replace eligible=1 if bord==1

* Baseline characheristics
global baseline_char m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r
 
* Create a birth year-by-month variable
gen yobxmob = ym(yob, mob)

* Aggreagate the data to group-by-birth-year-by-month level
collapse preg_regist weight m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r, by(eligible yobxmob yob mob)


* set the data to time series
tsset eligible yobxmob

** Create variables for Event Study estimation.

**Treatment
* Interaction terms between eligible and year indicator variables
forvalues i=10(1)20{
	gen firstb`i'= 0
	replace firstb`i' = 1 if (eligible==1 & yob==20`i')
}
label var firstb10 "-7"
label var firstb11 "-6"
label var firstb12 "-5"
label var firstb13 "-4"
label var firstb14 "-3"
label var firstb15 "-2"
label var firstb16 "-1"
label var firstb17  "0"
label var firstb18  "1"
label var firstb19  "2"
label var firstb20  "3"

xtscc preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight] 

* Position of -2
	local pos_of_neg_2 = 6 

	* Position of 0
	local pos_of_zero = `pos_of_neg_2' + 2

	* Position of max
	local pos_of_max = `pos_of_zero' + 3
	
	* icu_charges only 1 period after
	
	forvalues i = 10(1)15{
		scalar b_tar_`i' = _b[firstb`i']
		scalar se_v2_tar_`i' = _se[firstb`i']
		scalar b_acq_`i' = _b[firstb`i']
		scalar se_v2_acq_`i' = _se[firstb`i']
		
	}
		

	forvalues i = 17(1)20{
		scalar b_tar_`i' = _b[firstb`i']
		scalar se_v2_tar_`i' = _se[firstb`i']
		scalar b_acq_`i' = _b[firstb`i']
		scalar se_v2_acq_`i' = _se[firstb`i']
		
	}
	
	
	capture drop order
	capture drop b_tar
	capture drop high_tar 
	capture drop low_tar
	capture drop b_acq
	capture drop high_acq 
	capture drop low_acq

	gen order = .
	gen b_tar =. 
	gen high_tar =. 
	gen low_tar =.
	gen b_acq =. 
	gen high_acq =. 
	gen low_acq =.
	

	local i = 1
	local graph_start  = 1
	forvalues day = 10(1)15{
		local event_time = `day' - 17
		replace order = `event_time' in `i'
		
		replace b_tar    = b_tar_`day' in `i'
		replace high_tar = b_tar_`day' + 1.96*se_v2_tar_`day' in `i'
		replace low_tar  = b_tar_`day' - 1.96*se_v2_tar_`day' in `i'
		
		replace b_acq    = b_acq_`day' in `i'
		replace high_acq = b_acq_`day' + 1.96*se_v2_acq_`day' in `i'
		replace low_acq  = b_acq_`day' - 1.96*se_v2_acq_`day' in `i'
			
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace b_tar    = 0  in `i'
	replace high_tar = 0  in `i'
	replace low_tar  = 0  in `i'

	local i = `i' + 1
	forvalues day = 17(1)20{
		local event_time = `day' - 17

		replace order = `event_time' in `i'
		
		replace b_tar    = b_tar_`day' in `i'
		replace high_tar = b_tar_`day' + 1.96*se_v2_tar_`day' in `i'
		replace low_tar  = b_tar_`day' - 1.96*se_v2_tar_`day' in `i'
		
		replace b_acq    = b_acq_`day' in `i'
		replace high_acq = b_acq_`day' + 1.96*se_v2_acq_`day' in `i'
		replace low_acq  = b_acq_`day' - 1.96*se_v2_acq_`day' in `i'
			
		local i = `i' + 1
	}
	
	twoway rarea low_tar high_tar order if order<=3 & order >= -7 , fcol(gs14%80) lcol(white%60) msize(1) /// estimates
		|| connected b_tar order if order<=3 & order >= -7, lw(0.2) msize(1) msymbol(s) lp(solid) /// connect estimates
			xlab(-7(1)3)
