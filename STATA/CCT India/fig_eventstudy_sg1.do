/*  This file is to event study graphs for outcome variables
** This file is to see the impact on subgroups: 
1. Social status: a. poor b. middle c. rich
2. Caste: a.Schedulde caste/tribe b. OBC c. all other caste 
3. Place of residence: a. Urban b. Rural */

clear all
set more off
cap log close

* nfhs data
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures\ES_subgroups"

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

*=============================================================*
*                   Social status: Poor                       *
*=============================================================*

** Keep if only poor people
keep if poor==1

** Fig Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.yob i.eligible firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

/* The above regression can also be written as
reghdfe preg_regist 1.eligible#1.treatT_* [aw=weight], absorb(eligible yob) cluster(fbXyob) */

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 $baseline_char i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod3_1

* Fig ES3.1
coefplot(mod1_1,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigES3.1.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: At least one ANC visit
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

* Fig ES3.2
coefplot(mod1_2,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigES3.2.pdf", as(pdf) replace 

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

* Fig ES3.3
coefplot(mod1_3,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigES3.3.pdf", as(pdf) replace 

restore



******************************************************************************

**Fig: Delivery at health facility
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

* Fig ES3.4
coefplot(mod1_4,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigES3.4.pdf", as(pdf) replace 

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

* Fig ES3.5
coefplot(mod1_5,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigES3.5.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1 by card
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

* Fig ES3.6
coefplot(mod1_6,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigES3.6.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig: Received BCG reported by mother or card
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

* Fig ES3.7
coefplot(mod1_7,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigES3.7.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig Received BCG reported by card
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

* Fig ES3.8
coefplot(mod1_8,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigES3.8.pdf", as(pdf) replace 

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

* Fig ES3.9
coefplot(mod1_9,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigES3.9.pdf", as(pdf) replace 

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

* Fig ES3.10
coefplot(mod1_10,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigES3.10.pdf", as(pdf) replace 

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

* Fig ES3.11
coefplot(mod1_11,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigES3.11.pdf", as(pdf) replace 

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

* Fig ES3.12
coefplot(mod1_12,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigES3.12.pdf", as(pdf) replace 

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

* Fig ES3.13
coefplot(mod1_13,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigES3.13.pdf", as(pdf) replace 

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

* Fig ES3.14
coefplot(mod1_14,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigES3.14.pdf", as(pdf) replace 

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

* Fig ES3.15
coefplot(mod1_15,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigES3.15.pdf", as(pdf) replace 

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

* Fig ES3.16
coefplot(mod1_16,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigES3.16.pdf", as(pdf) replace 

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

* Fig ES3.17
coefplot(mod1_17,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Days iron tablets or syrup taken")
graph export "$outputdir/FigES3.17.pdf", as(pdf) replace 

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

* Fig ES3.18
coefplot(mod1_18,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Child birth weight")
graph export "$outputdir/FigES3.18.pdf", as(pdf) replace 

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

* Fig ES3.19
coefplot(mod1_19,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Neonatal Mortality")
graph export "$outputdir/FigES3.19.pdf", as(pdf) replace 

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

* Fig ES3.20
coefplot(mod1_20,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigES3.20.pdf", as(pdf) replace 

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

* Fig ES3.21
coefplot(mod1_21,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Moderately or severely stunted")
graph export "$outputdir/FigES3.21.pdf", as(pdf) replace 

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

* Fig ES3.22
coefplot(mod1_22,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Severely stunted")
graph export "$outputdir/FigES3.22.pdf", as(pdf) replace 

restore

***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************


*=============================================================*
*                   Social status: Middle                     *
*=============================================================*

clear all
set more off
cap log close

* nfhs data
use "C:\Users\rbulkunde3\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rbulkunde3\Dropbox (GaTech)\CCT India\output\figures\ES_subgroups"

* Keep the sample with birth order 1,2
drop if yob==2021 
keep if bord==1 | bord==2 
drop if bord==.

* Create eligible=1 if first born
gen  eligible=0
	replace eligible=1 if bord==1
	
** Keep if only middle people
keep if middle==1

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

** Fig Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.yob i.eligible firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

/* The above regression can also be written as
reghdfe preg_regist 1.eligible#1.treatT_* [aw=weight], absorb(eligible yob) cluster(fbXyob) */

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 $baseline_char i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod3_1

* Fig ES4.1
coefplot(mod1_1,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigES4.1.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: At least one ANC visit
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

* Fig ES4.2
coefplot(mod1_2,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigES4.2.pdf", as(pdf) replace 

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

* Fig ES4.3
coefplot(mod1_3,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigES4.3.pdf", as(pdf) replace 

restore



******************************************************************************

**Fig: Delivery at health facility
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

* Fig ES4.4
coefplot(mod1_4,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigES4.4.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1
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

* Fig ES4.5
coefplot(mod1_5,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigES4.5.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1 by card
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

* Fig ES4.6
coefplot(mod1_6,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigES4.6.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig: Received BCG reported by mother or card
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

* Fig ES4.7
coefplot(mod1_7,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigES4.7.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig Received BCG reported by card
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

* Fig ES4.8
coefplot(mod1_8,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigES4.8.pdf", as(pdf) replace 

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

* Fig ES4.9
coefplot(mod1_9,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigES4.9.pdf", as(pdf) replace 

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

* Fig ES4.10
coefplot(mod1_10,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigES4.10.pdf", as(pdf) replace 

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

* Fig ES4.11
coefplot(mod1_11,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigES4.11.pdf", as(pdf) replace 

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

* Fig ES4.12
coefplot(mod1_12,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigES4.12.pdf", as(pdf) replace 

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

* Fig ES4.13
coefplot(mod1_13,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigES4.13.pdf", as(pdf) replace 

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

* Fig ES4.14
coefplot(mod1_14,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigES4.14.pdf", as(pdf) replace 

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

* Fig ES4.15
coefplot(mod1_15,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigES4.15.pdf", as(pdf) replace 

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

* Fig ES4.16
coefplot(mod1_16,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigES4.16.pdf", as(pdf) replace 

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

* Fig ES4.17
coefplot(mod1_17,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Days iron tablets or syrup taken")
graph export "$outputdir/FigES4.17.pdf", as(pdf) replace 

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

* Fig ES4.18
coefplot(mod1_18,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Child birth weight")
graph export "$outputdir/FigES4.18.pdf", as(pdf) replace 

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

* Fig ES4.19
coefplot(mod1_19,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Neonatal Mortality")
graph export "$outputdir/FigES4.19.pdf", as(pdf) replace 

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

* Fig ES4.20
coefplot(mod1_20,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigES4.20.pdf", as(pdf) replace 

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

* Fig ES4.21
coefplot(mod1_21,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Moderately or severely stunted")
graph export "$outputdir/FigES4.21.pdf", as(pdf) replace 

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

* Fig ES4.22
coefplot(mod1_22,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Severely stunted")
graph export "$outputdir/FigES4.22.pdf", as(pdf) replace 

restore


***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************


*=============================================================*
*                   Social status: Rich                     *
*=============================================================*

clear all
set more off
cap log close

* nfhs data
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures\ES_subgroups"

* Keep the sample with birth order 1,2
drop if yob==2021 
keep if bord==1 | bord==2 
drop if bord==.

* Create eligible=1 if first born
gen  eligible=0
	replace eligible=1 if bord==1
	
** Keep if only rich people
keep if rich==1

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


** Fig Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.yob i.eligible firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 $baseline_char i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod3_1

* Fig ES5.1
coefplot(mod1_1,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigES5.1.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: At least one ANC visit
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

* Fig ES5.2
coefplot(mod1_2,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigES5.2.pdf", as(pdf) replace 

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

* Fig ES5.3
coefplot(mod1_3,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigES5.3.pdf", as(pdf) replace 

restore



******************************************************************************

**Fig: Delivery at health facility
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

* Fig ES5.4
coefplot(mod1_4,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigES5.4.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1
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

* Fig ES5.5
coefplot(mod1_5,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigES5.5.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1 by card
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

* Fig ES5.6
coefplot(mod1_6,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigES5.6.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig: Received BCG reported by mother or card
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

* Fig ES5.7
coefplot(mod1_7,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigES5.7.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig Received BCG reported by card
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

* Fig ES5.8
coefplot(mod1_8,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigES5.8.pdf", as(pdf) replace 

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

* Fig ES5.9
coefplot(mod1_9,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigES5.9.pdf", as(pdf) replace 

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

* Fig ES5.10
coefplot(mod1_10,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigES5.10.pdf", as(pdf) replace 

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

* Fig ES5.11
coefplot(mod1_11,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigES5.11.pdf", as(pdf) replace 

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

* Fig ES5.12
coefplot(mod1_12,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigES5.12.pdf", as(pdf) replace 

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

* Fig ES5.13
coefplot(mod1_13,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigES5.13.pdf", as(pdf) replace 

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

* Fig ES5.14
coefplot(mod1_14,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigES5.14.pdf", as(pdf) replace 

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

* Fig ES5.15
coefplot(mod1_15,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigES5.15.pdf", as(pdf) replace 

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

* Fig ES5.16
coefplot(mod1_16,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigES5.16.pdf", as(pdf) replace 

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

* Fig ES5.17
coefplot(mod1_17,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Days iron tablets or syrup taken")
graph export "$outputdir/FigES5.17.pdf", as(pdf) replace 

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

* Fig ES5.18
coefplot(mod1_18,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Child birth weight")
graph export "$outputdir/FigES5.18.pdf", as(pdf) replace 

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

* Fig ES5.19
coefplot(mod1_19,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Neonatal Mortality")
graph export "$outputdir/FigES5.19.pdf", as(pdf) replace 

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

* Fig ES5.20
coefplot(mod1_20,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigES5.20.pdf", as(pdf) replace 

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

* Fig ES5.21
coefplot(mod1_21,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Moderately or severely stunted")
graph export "$outputdir/FigES5.21.pdf", as(pdf) replace 

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

* Fig ES5.22
coefplot(mod1_22,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Severely stunted")
graph export "$outputdir/FigES5.22.pdf", as(pdf) replace 

restore



***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************

clear all
set more off
cap log close

* nfhs data
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures\ES_subgroups"

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

*=============================================================*
*                  Caste: Scheduled caste/Tribe               *
*=============================================================*

** Keep if only people belong to scheduled caste or tribe
keep if sch_caste_tribe==1

** Fig Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.yob i.eligible firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 $baseline_char i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod3_1

* Fig ES6.1
coefplot(mod1_1,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigES6.1.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: At least one ANC visit
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

* Fig ES6.2
coefplot(mod1_2,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigES6.2.pdf", as(pdf) replace 

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

* Fig ES6.3
coefplot(mod1_3,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigES6.3.pdf", as(pdf) replace 

restore



******************************************************************************

**Fig: Delivery at health facility
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

* Fig ES6.4
coefplot(mod1_4,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigES6.4.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1
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

* Fig ES6.5
coefplot(mod1_5,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigES6.5.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1 by card
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

* Fig ES6.6
coefplot(mod1_6,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigES6.6.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig: Received BCG reported by mother or card
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

* Fig ES6.7
coefplot(mod1_7,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigES6.7.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig Received BCG reported by card
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

* Fig ES6.8
coefplot(mod1_8,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigES6.8.pdf", as(pdf) replace 

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

* Fig ES6.9
coefplot(mod1_9,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigES6.9.pdf", as(pdf) replace 

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

* Fig ES6.10
coefplot(mod1_10,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigES6.10.pdf", as(pdf) replace 

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

* Fig ES6.11
coefplot(mod1_11,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigES6.11.pdf", as(pdf) replace 

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

* Fig ES6.12
coefplot(mod1_12,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigES6.12.pdf", as(pdf) replace 

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

* Fig ES6.13
coefplot(mod1_13,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigES6.13.pdf", as(pdf) replace 

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

* Fig ES6.14
coefplot(mod1_14,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigES6.14.pdf", as(pdf) replace 

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

* Fig ES6.15
coefplot(mod1_15,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigES6.15.pdf", as(pdf) replace 

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

* Fig ES6.16
coefplot(mod1_16,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigES6.16.pdf", as(pdf) replace 

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

* Fig ES6.17
coefplot(mod1_17,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Days iron tablets or syrup taken")
graph export "$outputdir/FigES6.17.pdf", as(pdf) replace 

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

* Fig ES6.18
coefplot(mod1_18,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Child birth weight")
graph export "$outputdir/FigES6.18.pdf", as(pdf) replace 

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

* Fig ES6.19
coefplot(mod1_19,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Neonatal Mortality")
graph export "$outputdir/FigES6.19.pdf", as(pdf) replace 

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

* Fig ES6.20
coefplot(mod1_20,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigES6.20.pdf", as(pdf) replace 

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

* Fig ES6.21
coefplot(mod1_21,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Moderately or severely stunted")
graph export "$outputdir/FigES6.21.pdf", as(pdf) replace 

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

* Fig ES6.22
coefplot(mod1_22,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Severely stunted")
graph export "$outputdir/FigES6.22.pdf", as(pdf) replace 

restore




***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************

clear all
set more off
cap log close

* nfhs data
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures\ES_subgroups"

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

*=============================================================*
*                  Caste: OBC                  *
*=============================================================*

** Keep if only poor people
keep if obc==1

** Fig Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.yob i.eligible firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 $baseline_char i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod3_1

* Fig ES7.1
coefplot(mod1_1,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigES7.1.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: At least one ANC visit
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

* Fig ES7.2
coefplot(mod1_2,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigES7.2.pdf", as(pdf) replace 

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

* Fig ES7.3
coefplot(mod1_3,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigES7.3.pdf", as(pdf) replace 

restore



******************************************************************************

**Fig: Delivery at health facility
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

* Fig ES7.4
coefplot(mod1_4,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigES7.4.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1
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

* Fig ES7.5
coefplot(mod1_5,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigES7.5.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1 by card
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

* Fig ES7.6
coefplot(mod1_6,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigES7.6.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig: Received BCG reported by mother or card
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

* Fig ES7.7
coefplot(mod1_7,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigES7.7.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig Received BCG reported by card
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

* Fig ES7.8
coefplot(mod1_8,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigES7.8.pdf", as(pdf) replace 

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

* Fig ES7.9
coefplot(mod1_9,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigES7.9.pdf", as(pdf) replace 

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

* Fig ES7.10
coefplot(mod1_10,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigES7.10.pdf", as(pdf) replace 

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

* Fig ES7.11
coefplot(mod1_11,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigES7.11.pdf", as(pdf) replace 

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

* Fig ES7.12
coefplot(mod1_12,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigES7.12.pdf", as(pdf) replace 

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

* Fig ES7.13
coefplot(mod1_13,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigES7.13.pdf", as(pdf) replace 

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

* Fig ES7.14
coefplot(mod1_14,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigES7.14.pdf", as(pdf) replace 

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

* Fig ES7.15
coefplot(mod1_15,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigES7.15.pdf", as(pdf) replace 

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

* Fig ES7.16
coefplot(mod1_16,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigES7.16.pdf", as(pdf) replace 

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

* Fig ES7.17
coefplot(mod1_17,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Days iron tablets or syrup taken")
graph export "$outputdir/FigES7.17.pdf", as(pdf) replace 

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

* Fig ES7.18
coefplot(mod1_18,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Child birth weight")
graph export "$outputdir/FigES7.18.pdf", as(pdf) replace 

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

* Fig ES7.19
coefplot(mod1_19,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Neonatal Mortality")
graph export "$outputdir/FigES7.19.pdf", as(pdf) replace 

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

* Fig ES7.20
coefplot(mod1_20,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigES7.20.pdf", as(pdf) replace 

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

* Fig ES7.21
coefplot(mod1_21,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Moderately or severely stunted")
graph export "$outputdir/FigES7.21.pdf", as(pdf) replace 

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

* Fig ES7.22
coefplot(mod1_22,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Severely stunted")
graph export "$outputdir/FigES7.22.pdf", as(pdf) replace 

restore

***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************

clear all
set more off
cap log close

* nfhs data
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures\ES_subgroups"

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

*=============================================================*
*                  Caste: All other caste              *
*=============================================================*

** Keep if only people belong to all other caste
keep if all_oth_caste==1

** Fig Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.yob i.eligible firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 $baseline_char i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod3_1

* Fig ES8.1
coefplot(mod1_1,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigES8.1.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: At least one ANC visit
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

* Fig ES8.2
coefplot(mod1_2,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigES8.2.pdf", as(pdf) replace 

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

* Fig ES8.3
coefplot(mod1_3,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigES8.3.pdf", as(pdf) replace 

restore



******************************************************************************

**Fig: Delivery at health facility
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

* Fig ES8.4
coefplot(mod1_4,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigES8.4.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1
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

* Fig ES8.5
coefplot(mod1_5,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigES8.5.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1 by card
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

* Fig ES8.6
coefplot(mod1_6,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigES8.6.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig: Received BCG reported by mother or card
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

* Fig ES8.7
coefplot(mod1_7,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigES8.7.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig Received BCG reported by card
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

* Fig ES8.8
coefplot(mod1_8,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigES8.8.pdf", as(pdf) replace 

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

* Fig ES8.9
coefplot(mod1_9,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigES8.9.pdf", as(pdf) replace 

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

* Fig ES8.10
coefplot(mod1_10,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigES8.10.pdf", as(pdf) replace 

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

* Fig ES8.11
coefplot(mod1_11,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigES8.11.pdf", as(pdf) replace 

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

* Fig ES8.12
coefplot(mod1_12,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigES8.12.pdf", as(pdf) replace 

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

* Fig ES8.13
coefplot(mod1_13,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigES8.13.pdf", as(pdf) replace 

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

* Fig ES8.14
coefplot(mod1_14,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigES8.14.pdf", as(pdf) replace 

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

* Fig ES8.15
coefplot(mod1_15,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigES8.15.pdf", as(pdf) replace 

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

* Fig ES8.16
coefplot(mod1_16,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigES8.16.pdf", as(pdf) replace 

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

* Fig ES8.17
coefplot(mod1_17,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Days iron tablets or syrup taken")
graph export "$outputdir/FigES8.17.pdf", as(pdf) replace 

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

* Fig ES8.18
coefplot(mod1_18,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Child birth weight")
graph export "$outputdir/FigES8.18.pdf", as(pdf) replace 

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

* Fig ES8.19
coefplot(mod1_19,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Neonatal Mortality")
graph export "$outputdir/FigES8.19.pdf", as(pdf) replace 

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

* Fig ES8.20
coefplot(mod1_20,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigES8.20.pdf", as(pdf) replace 

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

* Fig ES8.21
coefplot(mod1_21,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Moderately or severely stunted")
graph export "$outputdir/FigES8.21.pdf", as(pdf) replace 

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

* Fig ES8.22
coefplot(mod1_22,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Severely stunted")
graph export "$outputdir/FigES8.22.pdf", as(pdf) replace 

restore

***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************

clear all
set more off
cap log close

* nfhs data
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures\ES_subgroups"

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

*=============================================================*
*                  Place of Residence: Rural            *
*=============================================================*

** Keep if only for the people who live in rural
keep if rural==1

** Fig Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.yob i.eligible firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 $baseline_char i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod3_1

* Fig ES9.1
coefplot(mod1_1,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigES9.1.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: At least one ANC visit
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

* Fig ES9.2
coefplot(mod1_2,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigES9.2.pdf", as(pdf) replace 

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

* Fig ES9.3
coefplot(mod1_3,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigES9.3.pdf", as(pdf) replace 

restore



******************************************************************************

**Fig: Delivery at health facility
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

* Fig ES9.4
coefplot(mod1_4,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigES9.4.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1
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

* Fig ES9.5
coefplot(mod1_5,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigES9.5.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1 by card
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

* Fig ES9.6
coefplot(mod1_6,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigES9.6.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig: Received BCG reported by mother or card
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

* Fig ES9.7
coefplot(mod1_7,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigES9.7.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig Received BCG reported by card
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

* Fig ES9.8
coefplot(mod1_8,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigES9.8.pdf", as(pdf) replace 

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

* Fig ES9.9
coefplot(mod1_9,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigES9.9.pdf", as(pdf) replace 

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

* Fig ES9.10
coefplot(mod1_10,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigES9.10.pdf", as(pdf) replace 

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

* Fig ES9.11
coefplot(mod1_11,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigES9.11.pdf", as(pdf) replace 

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

* Fig ES9.12
coefplot(mod1_12,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigES9.12.pdf", as(pdf) replace 

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

* Fig ES9.13
coefplot(mod1_13,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigES9.13.pdf", as(pdf) replace 

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

* Fig ES9.14
coefplot(mod1_14,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigES9.14.pdf", as(pdf) replace 

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

* Fig ES9.15
coefplot(mod1_15,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigES9.15.pdf", as(pdf) replace 

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

* Fig ES9.16
coefplot(mod1_16,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigES9.16.pdf", as(pdf) replace 

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

* Fig ES9.17
coefplot(mod1_17,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Days iron tablets or syrup taken")
graph export "$outputdir/FigES9.17.pdf", as(pdf) replace 

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

* Fig ES9.18
coefplot(mod1_18,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Child birth weight")
graph export "$outputdir/FigES9.18.pdf", as(pdf) replace 

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

* Fig ES9.19
coefplot(mod1_19,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Neonatal Mortality")
graph export "$outputdir/FigES9.19.pdf", as(pdf) replace 

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

* Fig ES9.20
coefplot(mod1_20,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigES9.20.pdf", as(pdf) replace 

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

* Fig ES9.21
coefplot(mod1_21,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Moderately or severely stunted")
graph export "$outputdir/FigES9.21.pdf", as(pdf) replace 

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

* Fig ES9.22
coefplot(mod1_22,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Severely stunted")
graph export "$outputdir/FigES9.22.pdf", as(pdf) replace 

restore



***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************

clear all
set more off
cap log close

* nfhs data
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures\ES_subgroups"

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

*=============================================================*
*                  Place of Residence: Urban            *
*=============================================================*

** Keep if only for the people who live in rural
keep if rural==0

** Fig Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.yob i.eligible firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 ///
firstb19 firstb20 $baseline_char i.eligible i.surveyXyob firstb16 [aw=weight], vce(cluster district)
estimates store mod3_1

* Fig ES10.1
coefplot(mod1_1,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigES10.1.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: At least one ANC visit
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

* Fig ES10.2
coefplot(mod1_2,  label("Basic model") drop(_cons *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model includes survey-by-birth-year fe") drop(_cons *.surveyXyob *.eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model includes controls") drop(_cons *.surveyXyob *.eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigES10.2.pdf", as(pdf) replace 

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

* Fig ES10.3
coefplot(mod1_3,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigES10.3.pdf", as(pdf) replace 

restore



******************************************************************************

**Fig: Delivery at health facility
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

* Fig ES10.4
coefplot(mod1_4,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigES10.4.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1
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

* Fig ES10.5
coefplot(mod1_5,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigES10.5.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig: Child required first dose of vaccinanation-hepb1, opv1, bcg, and dpt1 by card
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

* Fig ES10.6
coefplot(mod1_6,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigES10.6.pdf", as(pdf) replace 

restore


******************************************************************************

** Fig: Received BCG reported by mother or card
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

* Fig ES10.7
coefplot(mod1_7,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigES10.7.pdf", as(pdf) replace 

restore

******************************************************************************

** Fig Received BCG reported by card
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

* Fig ES10.8
coefplot(mod1_8,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigES10.8.pdf", as(pdf) replace 

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

* Fig ES10.9
coefplot(mod1_9,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigES10.9.pdf", as(pdf) replace 

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

* Fig ES10.10
coefplot(mod1_10,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigES10.10.pdf", as(pdf) replace 

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

* Fig ES10.11
coefplot(mod1_11,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigES10.11.pdf", as(pdf) replace 

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

* Fig ES10.12
coefplot(mod1_12,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigES10.12.pdf", as(pdf) replace 

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

* Fig ES10.13
coefplot(mod1_13,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigES10.13.pdf", as(pdf) replace 

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

* Fig ES10.14
coefplot(mod1_14,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigES10.14.pdf", as(pdf) replace 

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

* Fig ES10.15
coefplot(mod1_15,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigES10.15.pdf", as(pdf) replace 

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

* Fig ES10.16
coefplot(mod1_16,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigES10.16.pdf", as(pdf) replace 

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

* Fig ES10.17
coefplot(mod1_17,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Days iron tablets or syrup taken")
graph export "$outputdir/FigES10.17.pdf", as(pdf) replace 

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

* Fig ES10.18
coefplot(mod1_18,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Child birth weight")
graph export "$outputdir/FigES10.18.pdf", as(pdf) replace 

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

* Fig ES10.19
coefplot(mod1_19,  label("Basic model") drop(_cons *.eligible *.yob ) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Neonatal Mortality")
graph export "$outputdir/FigES10.19.pdf", as(pdf) replace 

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

* Fig ES10.20
coefplot(mod1_20,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigES10.20.pdf", as(pdf) replace 

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

* Fig ES10.21
coefplot(mod1_21,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Moderately or severely stunted")
graph export "$outputdir/FigES10.21.pdf", as(pdf) replace 

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

* Fig ES10.22
coefplot(mod1_22,  label("Basic model") drop(_cons *.eligible *.yob) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model include survey-by-birth-year fe") drop(_cons *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model include controls") drop(_cons *.eligible *.surveyXyob $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 )  ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Severely stunted")
graph export "$outputdir/FigES10.22.pdf", as(pdf) replace 

restore