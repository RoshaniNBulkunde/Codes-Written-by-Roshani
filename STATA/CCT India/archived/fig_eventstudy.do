/* 
This file is to event study graphs for outcome variables 
*Roshani Bulkunde */

clear all
set more off
cap log close

log using "C:\Users\rosha\Dropbox (GaTech)\CCT India\logs\fig_eventstudy.log", replace

* nfhs data
use "C:\Users\rbulkunde3\Downloads\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rbulkunde3\Desktop\Cct India\output\figures"


* Keep the sample with birth order 1,2
drop if yob==2021 
keep if bord==1 | bord==2 
drop if bord==.

* Create eligible=1 if first born
gen  eligible=0
	replace eligible=1 if bord==1

* Baseline characheristics
global baseline_char m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r


*=============================================================*
*                     Event study                             *
*=============================================================*

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

*-------------------------------------------------------------*

** Fig Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

/* The above regression can also be written as
reghdfe preg_regist 1.eligible#1.treatT_* [aw=weight], absorb(eligible yob) cluster(fbXyob) */

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.1
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigES1.1.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig At least one ANC visit
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe anc_visit firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe anc_visit firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe anc_visit firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.2
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigES1.2.pdf", as(pdf) replace 

restore


******************************************************************************

** Total ANC visits
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe tot_anc9 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe tot_anc9 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe tot_anc9 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.3
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigES1.3.pdf", as(pdf) replace 

restore



******************************************************************************

** Delivery at health facility
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe del_healthf firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe del_healthf firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe del_healthf firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.4
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigES1.4.pdf", as(pdf) replace 

restore


******************************************************************************

** Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_firstvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_firstvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_firstvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.5
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion-hepb1 and opv1)
graph export "$outputdir/FigES1.5.pdf", as(pdf) replace 

restore


******************************************************************************

** Child required first dose of vaccinanation-hepb0, opv0, bcg, and dpt1
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_firstvac0 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_firstvac0 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_firstvac0 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.6
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion-hepb0 and opv0)
graph export "$outputdir/FigES1.6.pdf", as(pdf) replace 

restore



******************************************************************************

** Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1 by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_firstvac_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_firstvac_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_firstvac_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.7
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion-hepb1 and opv1 by card)
graph export "$outputdir/FigES1.7.pdf", as(pdf) replace 

restore


******************************************************************************

** Child required first dose of vaccinanation-hepb0, opv0, bcg, and dpt1 by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_firstvac0_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_firstvac0_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_firstvac0_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.8
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion-hepb0 and opv0 by card)
graph export "$outputdir/FigES1.8.pdf", as(pdf) replace 

restore

******************************************************************************

** Received BCG reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_bcg firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_bcg firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_bcg firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.9
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ylabel(-0.04(0.01)0.01) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigES1.9.pdf", as(pdf) replace 

restore

******************************************************************************

** Received BCG reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_bcg_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_bcg_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_bcg_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.10
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ylabel(-0.03(0.01)0.01) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigES1.10.pdf", as(pdf) replace 

restore


******************************************************************************

** Received Hep-B at birth reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_hepb firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_hepb firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_hepb firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.10
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received Hep-B at birth reported by mother or card)
graph export "$outputdir/FigES1.11.pdf", as(pdf) replace 

restore

******************************************************************************

** Received Hep-B at birth reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_hepb_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_hepb_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_hepb_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.10
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received Hep-B at birth reported by card)
graph export "$outputdir/FigES1.12.pdf", as(pdf) replace 

restore

******************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_hep1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_hep1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_hep1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.10
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigES1.13.pdf", as(pdf) replace 

restore

******************************************************************************

** Received first dose Hep-B reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_hep1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_hep1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_hep1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.10
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigES1.14.pdf", as(pdf) replace 

restore

******************************************************************************

** Received first dose DPT reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_dpt1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_dpt1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_dpt1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.15
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigES1.15.pdf", as(pdf) replace 

restore

******************************************************************************

** Received first dose DPT reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_dpt1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_dpt1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_dpt1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.16
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigES1.16.pdf", as(pdf) replace 

restore

******************************************************************************

** Received OPV at birth reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_opvb firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_opvb firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_opvb firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.17
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received OPV at birth reported by mother or card)
graph export "$outputdir/FigES1.17.pdf", as(pdf) replace 

restore

******************************************************************************

** Received OPV at birth reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_opvb_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_opvb_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_opvb_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.10
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received OPV at birth reported by card)
graph export "$outputdir/FigES1.18.pdf", as(pdf) replace 

restore

******************************************************************************

** Received first dose OPV reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_opv1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_opv1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_opv1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.19
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigES1.19.pdf", as(pdf) replace 

restore

******************************************************************************

** Received first dose OPV reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_opv1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_opv1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_opv1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.20
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigES1.20.pdf", as(pdf) replace 

restore


******************************************************************************

** Mother Anemic
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe m_anemia firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe m_anemia firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe m_anemia firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.21
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigES1.21.pdf", as(pdf) replace 

restore

******************************************************************************

** During pregnancy, given or bought iron tablets/syrup
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.22
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigES1.22.pdf", as(pdf) replace 

restore

******************************************************************************

** Days iron tablets or syrup taken
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe dur_iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe dur_iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe dur_iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.23
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Days iron tablets or syrup taken")
graph export "$outputdir/FigES1.23.pdf", as(pdf) replace 

restore

******************************************************************************

** Child birth weight
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe ch_bw firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe ch_bw firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe ch_bw firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.24
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Child birth weight")
graph export "$outputdir/FigES1.24.pdf", as(pdf) replace 

restore

******************************************************************************

** Neonatal Mortality
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe neo_mort firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe neo_mort firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe neo_mort firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.25
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Neonatal Mortality")
graph export "$outputdir/FigES1.25.pdf", as(pdf) replace 

restore

******************************************************************************

** Duration of Breastfed (months)
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe breast_dur firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe breast_dur firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe breast_dur firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.26
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigES1.26.pdf", as(pdf) replace 

restore

******************************************************************************

** Moderately or severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe mod_svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe mod_svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe mod_svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.27
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Moderately or severely stunted")
graph export "$outputdir/FigES1.27.pdf", as(pdf) replace 

restore

******************************************************************************

** Severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reghdfe svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_1 

** model 3- specification with basline characteristics
reghdfe svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 firstb16 $baseline_char [aw=weight], absorb(eligible surveyXyob) 
estimates store mod3_1

* Fig ES1.28
coefplot(mod1_1,  label("Basic model") drop(_cons) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Severely stunted")
graph export "$outputdir/FigES1.28.pdf", as(pdf) replace 

restore