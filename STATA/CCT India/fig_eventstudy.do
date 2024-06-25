/* 
This file is to event study graphs for outcome variables 
*Roshani Bulkunde */

clear all
set more off
cap log close

*log using "C:\Users\rosha\Dropbox (GaTech)\CCT India\logs\fig_eventstudy.log", replace

* nfhs data
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures"


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
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.yob i.eligible firstb16 [aw=weight]
estimates store mod1_1

/* The above regression can also be written as
reghdfe preg_regist 1.eligible#1.treatT_* [aw=weight], absorb(eligible yob) cluster(fbXyob) */

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight]
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 $baseline_char i.eligible i.surveyXyob firstb16 [aw=weight]
estimates store mod3_1

* Fig ES1.1
coefplot(mod1_1,  label("Basic model") drop(_cons *.yob *.eligible)level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigES1.1.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig1.2: At least one ANC visit
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg anc_visit firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_2

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg anc_visit firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_2 

** model 3- specification with basline characteristics
reg anc_visit firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_2

* Fig ES1.2
coefplot(mod1_2,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
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
reg tot_anc9 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_3

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg tot_anc9 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_3 

** model 3- specification with basline characteristics
reg tot_anc9 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_3

* Fig ES1.3
coefplot(mod1_3,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigES1.3.pdf", as(pdf) replace 

restore



******************************************************************************

**Fig 1.4 Delivery at health facility
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg del_healthf firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_4

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg del_healthf firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_4

** model 3- specification with basline characteristics
reg del_healthf firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_4

* Fig ES1.4
coefplot(mod1_4,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigES1.4.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig 1.5 Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district)
estimates store mod1_5

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_5

** model 3- specification with basline characteristics
reg ch_firstvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_5

* Fig ES1.5
coefplot(mod1_5,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigES1.5.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig 1.6 Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1 by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district)
estimates store mod1_6

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_6

** model 3- specification with basline characteristics
reg ch_firstvac_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_6

* Fig ES1.6
coefplot(mod1_6,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigES1.6.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig 1.7 Received BCG reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_7

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_7 

** model 3- specification with basline characteristics
reg ch_bcg firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_7

* Fig ES1.7
coefplot(mod1_7,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ylabel(-0.04(0.01)0.01) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigES1.7.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig1.8 Received BCG reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_8

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_8

** model 3- specification with basline characteristics
reg ch_bcg_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_8

* Fig ES1.8
coefplot(mod1_8,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ylabel(-0.03(0.01)0.01) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigES1.8.pdf", as(pdf) replace 

restore


******************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district)
estimates store mod1_9

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_9

** model 3- specification with basline characteristics
reg ch_hep1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_9

* Fig ES1.9
coefplot(mod1_9,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigES1.9.pdf", as(pdf) replace 

restore

******************************************************************************

** Received first dose Hep-B reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_10

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_10 

** model 3- specification with basline characteristics
reg ch_hep1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_10

* Fig ES1.10
coefplot(mod1_10,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigES1.10.pdf", as(pdf) replace 

restore

******************************************************************************

** Received first dose DPT reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_11

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_11 

** model 3- specification with basline characteristics
reg ch_dpt1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_11

* Fig ES1.11
coefplot(mod1_11,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigES1.11.pdf", as(pdf) replace 

restore

******************************************************************************

** Received first dose DPT reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_12

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_12

** model 3- specification with basline characteristics
reg ch_dpt1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district) 
estimates store mod3_12

* Fig ES1.12
coefplot(mod1_12,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigES1.12.pdf", as(pdf) replace 

restore

******************************************************************************

** Received first dose OPV reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_13

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_13

** model 3- specification with basline characteristics
reg ch_opv1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_13

* Fig ES1.13
coefplot(mod1_13,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigES1.13.pdf", as(pdf) replace 

restore

******************************************************************************

** Received first dose OPV reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_14

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_14 

** model 3- specification with basline characteristics
reg ch_opv1_card firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_14

* Fig ES1.14
coefplot(mod1_14,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigES1.14.pdf", as(pdf) replace 

restore


******************************************************************************

** Mother Anemic
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg m_anemia firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district)
estimates store mod1_15

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg m_anemia firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_15 

** model 3- specification with basline characteristics
reg m_anemia firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district) 
estimates store mod3_15

* Fig ES1.15
coefplot(mod1_15,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigES1.15.pdf", as(pdf) replace 

restore

******************************************************************************

** During pregnancy, given or bought iron tablets/syrup
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16  [aw=weight], vce(cluster district) 
estimates store mod1_16

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20  i.eligible i.surveyXyob firstb16  [aw=weight], vce(cluster district) 
estimates store mod2_16

** model 3- specification with basline characteristics
reg iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16  $baseline_char [aw=weight], vce(cluster district) 
estimates store mod3_16

* Fig ES1.16
coefplot(mod1_16,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigES1.16.pdf", as(pdf) replace 

restore

******************************************************************************

** Days iron tablets or syrup taken
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg dur_iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_17

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg dur_iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_17 

** model 3- specification with basline characteristics
reg dur_iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_17

* Fig ES1.17
coefplot(mod1_17,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Days iron tablets or syrup taken")
graph export "$outputdir/FigES1.17.pdf", as(pdf) replace 

restore

******************************************************************************

** Child birth weight
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bw firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_18

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bw firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_18 

** model 3- specification with basline characteristics
reg ch_bw firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district) 
estimates store mod3_18

* Fig ES1.18
coefplot(mod1_18,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Child birth weight")
graph export "$outputdir/FigES1.18.pdf", as(pdf) replace 

restore

******************************************************************************

** Neonatal Mortality
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg neo_mort firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_19

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg neo_mort firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_19 

** model 3- specification with basline characteristics
reg neo_mort firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_19

* Fig ES1.19
coefplot(mod1_19,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Neonatal Mortality")
graph export "$outputdir/FigES1.19.pdf", as(pdf) replace 

restore

******************************************************************************

** Duration of Breastfed (months)
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg breast_dur firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_20

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg breast_dur firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_20 

** model 3- specification with basline characteristics
reg breast_dur firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_20 

* Fig ES1.20
coefplot(mod1_20,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigES1.20.pdf", as(pdf) replace 

restore

******************************************************************************

** Moderately or severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg mod_svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_21

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg mod_svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_21 

** model 3- specification with basline characteristics
reg mod_svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_21

* Fig ES1.21
coefplot(mod1_21,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Moderately or severely stunted")
graph export "$outputdir/FigES1.21.pdf", as(pdf) replace 

restore

******************************************************************************

** Severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.yob firstb16 [aw=weight], vce(cluster district) 
estimates store mod1_22

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district) 
estimates store mod2_22

** model 3- specification with basline characteristics
reg svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 $baseline_char [aw=weight], vce(cluster district)
estimates store mod3_22

* Fig ES1.22
coefplot(mod1_22,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Severely stunted")
graph export "$outputdir/FigES1.22.pdf", as(pdf) replace 

restore