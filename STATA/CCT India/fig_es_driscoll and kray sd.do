/* 
This file is to event study graphs for outcome variables 
With Driscoll and Kraay standard errors
*Roshani Bulkunde */

clear all
set more off
cap log close

* nfhs data
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures\ES driscoll_kray se"


* Keep the sample with birth order 1,2
drop if yob==2021 
keep if bord==1 | bord==2 
drop if bord==.

* Create eligible=1 if first born
gen  eligible=0
	replace eligible=1 if bord==1

* Create a birth year-by-month variable
gen yobxmob = ym(yob, mob)

*reg preg_regist 1.eligible#i.yobxmob i.yobxmob m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r

* Aggreagate the data to group-by-birth-year-by-month level
collapse preg_regist anc_visit tot_anc9 del_healthf ch_firstvac ch_firstvac_card ch_bcg ch_bcg_card ch_hep1 ch_hep1_card ch_dpt1 ch_dpt1_card ch_opv1 ch_opv1_card ///
m_anemia iron_spplm dur_iron_spplm ch_bw neo_mort breast_dur mod_svr_stunted svr_stunted ///
weight m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r, by(eligible yobxmob yob mob)

* set the data to time series
tsset eligible yobxmob

* Baseline characheristics
global baseline_char m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r

** Create variables for Event Study estimation.

**Treatment
* Interaction terms between eligible and year indicator variables
forvalues i=10(1)20{
	gen firstb`i'= 0
	replace firstb`i' = 1 if (eligible==1 & yob==20`i')
}

*----------------------------------------------------------------------------------------------------------------------------------------------------------*

** Pregnancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Pregnancy registration)
	graph export "$outputdir/FigES_dk1.1.pdf", as(pdf) replace 
	
restore

*----------------------------------------------------------------------------------------------------------------------------------------------------------*
** Atleast one ANC visit
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc anc_visit firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc anc_visit firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Atleast one ANC visit)
	graph export "$outputdir/FigES_dk1.2.pdf", as(pdf) replace 
	
restore

*----------------------------------------------------------------------------------------------------------------------------------------------------------*
** Total ANC visits
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc tot_anc9 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc tot_anc9 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Total ANC visits)
	graph export "$outputdir/FigES_dk1.3.pdf", as(pdf) replace 
	
restore

*----------------------------------------------------------------------------------------------------------------------------------------------------------*
** Delivery at health facility
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc del_healthf firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc del_healthf firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Delivery at health facility)
	graph export "$outputdir/FigES_dk1.4.pdf", as(pdf) replace 
	
restore

*----------------------------------------------------------------------------------------------------------------------------------------------------------*
** Child first dose of vaccinantion reported by card or mother
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc ch_firstvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc ch_firstvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Child first dose of vaccinantion reported by card or mother)
	graph export "$outputdir/FigES_dk1.5.pdf", as(pdf) replace 
	
restore

*----------------------------------------------------------------------------------------------------------------------------------------------------------*
** Child first dose of vaccinantion by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc ch_firstvac_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc ch_firstvac_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Child first dose of vaccinantion by card)
	graph export "$outputdir/FigES_dk1.6.pdf", as(pdf) replace 
	
restore

*----------------------------------------------------------------------------------------------------------------------------------------------------------*
** Received BCG reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc ch_bcg firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc ch_bcg firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Received BCG reported by mother or card)
	graph export "$outputdir/FigES_dk1.7.pdf", as(pdf) replace 
	
restore

*----------------------------------------------------------------------------------------------------------------------------------------------------------*
** Received BCG reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc ch_bcg_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc ch_bcg_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Received BCG reported by card)
	graph export "$outputdir/FigES_dk1.8.pdf", as(pdf) replace 
	
restore


*----------------------------------------------------------------------------------------------------------------------------------------------------------*
** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc ch_hep1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc ch_hep1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Received first dose Hep-B reported by mother or card)
	graph export "$outputdir/FigES_dk1.9.pdf", as(pdf) replace 
	
restore

*----------------------------------------------------------------------------------------------------------------------------------------------------------*
** Received first dose Hep-B reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc ch_hep1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc ch_hep1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Received first dose Hep-B reported by card)
	graph export "$outputdir/FigES_dk1.10.pdf", as(pdf) replace 
	
restore

*----------------------------------------------------------------------------------------------------------------------------------------------------------*
** Received first dose DPT reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc ch_dpt1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc ch_dpt1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Received first dose DPT reported by mother or card)
	graph export "$outputdir/FigES_dk1.11.pdf", as(pdf) replace 
	
restore
*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

** Received first dose DPT reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc ch_dpt1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc ch_dpt1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Received first dose DPT reported by card)
	graph export "$outputdir/FigES_dk1.12.pdf", as(pdf) replace 
	
restore

*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

** Received first dose OPV reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc ch_opv1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc ch_opv1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Received first dose OPV reported by mother or card)
	graph export "$outputdir/FigES_dk1.13.pdf", as(pdf) replace 
	
restore

*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

** Received first dose OPV reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc ch_opv1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc ch_opv1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Received first dose OPV reported by card)
	graph export "$outputdir/FigES_dk1.14.pdf", as(pdf) replace 
	
restore

*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

** Mother Anemic
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc m_anemia firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc m_anemia firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Mother Anemic)
	graph export "$outputdir/FigES_dk1.15.pdf", as(pdf) replace 
	
restore

*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

**During pregnancy, given or bought iron tablets/syrup
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title("During pregnancy, given or bought iron tablets/syrup")
	graph export "$outputdir/FigES_dk1.16.pdf", as(pdf) replace 
	
restore

*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

**Days iron tablets or syrup taken
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc dur_iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc dur_iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title("Days iron tablets or syrup taken")
	graph export "$outputdir/FigES_dk1.17.pdf", as(pdf) replace 
	
restore

*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

**Child birth weight
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc ch_bw firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc ch_bw firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Child birth weight)
	graph export "$outputdir/FigES_dk1.18.pdf", as(pdf) replace 
	
restore

*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

**Neonatal Mortality
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc neo_mort firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc neo_mort firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Neonatal Mortality)
	graph export "$outputdir/FigES_dk1.19.pdf", as(pdf) replace 
	
restore

*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

**Duration of Breastfed (months)
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc breast_dur firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc breast_dur firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Duration of Breastfed (months))
	graph export "$outputdir/FigES_dk1.20.pdf", as(pdf) replace 
	
restore

*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

**Moderately or severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc mod_svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc mod_svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Moderately or severely stunted)
	graph export "$outputdir/FigES_dk1.21.pdf", as(pdf) replace 
	
restore

*-----------------------------------------------------------------------------------------------------------------------------------------------------------*

**Severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

* Driscoll and Kray SE
xtscc svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b1_20`i' = _b[firstb`i']
		scalar se1_20`i' = _se[firstb`i']	
	}
	
xtscc svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 $baseline_char i.eligible i.yobxmob  [aw=weight]
**Save the beta coefficients and standard errors manually
	* Save the estimates from year 2010 to 2015
	forvalues i = 10(1)15{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']
	}
	
	* Save the estimates from year 2017 to 2020
	forvalues i = 17(1)20{
		scalar b2_20`i' = _b[firstb`i']
		scalar se2_20`i' = _se[firstb`i']	
	}
	
	capture drop order
	capture drop beta1
	capture drop high_bar1
	capture drop low_bar1
	capture drop beta2
	capture drop high_bar2
	capture drop low_bar2

	gen order = .
	gen beta1 =. 
	gen high_bar1 =. 
	gen low_bar1 =.
	gen beta2 =. 
	gen high_bar2 =. 
	gen low_bar2 =.


	local i = 10
	forvalues year = 10(1)15{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
		
		local i = `i' + 1
	}

	replace order = -1 in `i'

	replace beta1    = 0  in `i'
	replace high_bar1 = 0  in `i'
	replace low_bar1  = 0  in `i'
	replace beta2    = 0  in `i'
	replace high_bar2 = 0  in `i'
	replace low_bar2  = 0  in `i'

	local i = `i' + 1
	forvalues year = 17(1)20{
		local event_time = `year' - 17
		replace order = `event_time' in `i'
		
		replace beta1    = b1_20`year' in `i'
		replace high_bar1 = b1_20`year' + 1.96*se1_20`year' in `i'
		replace low_bar1  = b1_20`year' - 1.96*se1_20`year' in `i'
		replace beta2    = b2_20`year' in `i'
		replace high_bar2 = b2_20`year' + 1.96*se2_20`year' in `i'
		replace low_bar2  = b2_20`year' - 1.96*se2_20`year' in `i'
			
		local i = `i' + 1
	}
	
	capture drop ev1
	capture drop ev2
	
	gen ev1 = order - 0.2
	gen ev2 = order + 0.2
	
	twoway (scatter beta1 order, msymbol(O) mcolor(green) msize(medium) lwi(vthin)) (rcap high_bar1 low_bar1 order, lcolor(green) lp(solid) lw(thin))  ///
	(scatter beta2 ev2, msymbol(O) mcolor(navy) msize(medium) lwi(vthin)) (rcap high_bar2 low_bar2 ev2, lcolor(navy) lp(solid) lw(thin)) , ///
	xlab(-7(1)3) ///
	yline(0, lcolor(black) lpattern(shortdash_dot)) ///
	xtitle(Years since CCT implemented, size(small)) ///
	legend(lab(1 "Basic model") lab(3 "Model with baseline characteristics") order(1 3) position(6) col(2) size(small)) title(Severely stunted)
	graph export "$outputdir/FigES_dk1.22.pdf", as(pdf) replace 
	
restore



