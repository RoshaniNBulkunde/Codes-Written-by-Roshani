/* 
This file is to event study graphs for outcome variables 
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

*------------------------------------------------------------------------*
** Create variables for Event Study estimation.

* Group 1- firstborn
gen firstb=0
	replace firstb=1 if bord==1
	
* Group 2- secondborn
gen secondb=0
	replace secondb=1 if bord==2
	
* Create a year continuous variable.
gen y=.
	replace y=1 if yob==2010
	replace y=2 if yob==2011
	replace y=3 if yob==2012
	replace y=4 if yob==2013
	replace y=5 if yob==2014
	replace y=6 if yob==2015
	replace y=7 if yob==2016
	replace y=8 if yob==2017
	replace y=9 if yob==2018
	replace y=10 if yob==2019
	replace y=11 if yob==2020
	
* Trend variables
gen firstbtrend = firstb*y
gen secondbtrend = secondb*y

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

** Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_1

* Fig EST3.1
coefplot(mod1_1,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigEST3.1.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Atleast one ANC visit
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_2


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_2 

** model 3- specification with basline characteristics
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_2

* Fig EST3.1
coefplot(mod1_2,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigEST3.2.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Total ANC visits
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_3


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_3 

** model 3- specification with basline characteristics
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_3

* Fig EST3.3
coefplot(mod1_3,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigEST3.3.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Delivery at health facility
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_4


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_4 

** model 3- specification with basline characteristics
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_4

* Fig EST3.4
coefplot(mod1_4,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigEST3.4.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion reported by card or mother
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_5


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_5

** model 3- specification with basline characteristics
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_5

* Fig EST3.5
coefplot(mod1_5,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigEST3.5.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_6


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_6

** model 3- specification with basline characteristics
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_6

* Fig EST3.6
coefplot(mod1_6,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigEST3.6.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_7


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_7

** model 3- specification with basline characteristics
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_7

* Fig EST3.7
coefplot(mod1_7,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigEST3.7.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_8

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_8

** model 3- specification with basline characteristics
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_8

* Fig EST3.8
coefplot(mod1_8,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigEST3.8.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_9


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_9

** model 3- specification with basline characteristics
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_9

* Fig EST3.9
coefplot(mod1_9,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigEST3.9.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_10


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_10

** model 3- specification with basline characteristics
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_10

* Fig EST3.10
coefplot(mod1_10,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigEST3.10.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_11

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_11

** model 3- specification with basline characteristics
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_11

* Fig EST3.11
coefplot(mod1_11,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigEST3.11.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_12

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_12

** model 3- specification with basline characteristics
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_12

* Fig EST3.12
coefplot(mod1_12,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigEST3.12.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_13

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_13

** model 3- specification with basline characteristics
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_13

* Fig EST3.13
coefplot(mod1_13,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigEST3.13.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_14

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_14

** model 3- specification with basline characteristics
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_14

* Fig EST3.14
coefplot(mod1_14,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigEST3.14.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Mother Anemic
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_15

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_15

** model 3- specification with basline characteristics
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_15

* Fig EST3.15
coefplot(mod1_15,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigEST3.15.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** "During pregnancy, given or bought iron tablets/syrup"
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_16

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_16

** model 3- specification with basline characteristics
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_16

* Fig EST3.16
coefplot(mod1_16,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigEST3.16.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Days iron tablets or syrup taken
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_17

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_17

** model 3- specification with basline characteristics
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_17

* Fig EST3.17
coefplot(mod1_17,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Days iron tablets or syrup taken)
graph export "$outputdir/FigEST3.17.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child birth weight
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_18

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_18

** model 3- specification with basline characteristics
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_18

* Fig EST3.18
coefplot(mod1_18,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child birth weight)
graph export "$outputdir/FigEST3.18.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Neonatal Mortality
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_19

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_19

** model 3- specification with basline characteristics
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_19

* Fig EST3.19
coefplot(mod1_19,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Neonatal Mortality)
graph export "$outputdir/FigEST3.19.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Duration of Breastfed (months)
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_20

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_20

** model 3- specification with basline characteristics
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_20

* Fig EST3.20
coefplot(mod1_20,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigEST3.20.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Moderately or severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_21

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_21

** model 3- specification with basline characteristics
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_21

* Fig EST3.21
coefplot(mod1_21,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Moderately or severely stunted)
graph export "$outputdir/FigEST3.21.pdf", as(pdf) replace 

restore

*******************************************************************************************************************************************************************
** Severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_22

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_22

** model 3- specification with basline characteristics
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_22

* Fig EST3.22
coefplot(mod1_22,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Severely stunted)
graph export "$outputdir/FigEST3.22.pdf", as(pdf) replace 

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
** Create variables for Event Study estimation.

* Group 1- firstborn
gen firstb=0
	replace firstb=1 if bord==1
	
* Group 2- secondborn
gen secondb=0
	replace secondb=1 if bord==2
	
* Create a year continuous variable.
gen y=.
	replace y=1 if yob==2010
	replace y=2 if yob==2011
	replace y=3 if yob==2012
	replace y=4 if yob==2013
	replace y=5 if yob==2014
	replace y=6 if yob==2015
	replace y=7 if yob==2016
	replace y=8 if yob==2017
	replace y=9 if yob==2018
	replace y=10 if yob==2019
	replace y=11 if yob==2020
	
* Trend variables
gen firstbtrend = firstb*y
gen secondbtrend = secondb*y

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

** Keep the sample for middle income people
keep if middle==1

*----------------------------------------------------*

** Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_1

* Fig EST4.1
coefplot(mod1_1,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigEST4.1.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Atleast one ANC visit
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_2

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_2 

** model 3- specification with basline characteristics
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_2

* Fig EST4.2 
coefplot(mod1_2,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigEST4.2.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Total ANC visits
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_3

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_3 

** model 3- specification with basline characteristics
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_3

* Fig EST4.3
coefplot(mod1_3,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigEST4.3.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Delivery at health facility
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_4

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_4 

** model 3- specification with basline characteristics
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_4

* Fig EST4.4
coefplot(mod1_4,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigEST4.4.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion reported by card or mother
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_5


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_5

** model 3- specification with basline characteristics
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_5

* Fig EST4.5
coefplot(mod1_5,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigEST4.5.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_6

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_6

** model 3- specification with basline characteristics
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_6

* Fig EST4.6
coefplot(mod1_6,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigEST4.6.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_7


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_7

** model 3- specification with basline characteristics
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_7

* Fig EST4.7
coefplot(mod1_7,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigEST4.7.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_8

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_8

** model 3- specification with basline characteristics
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_8

* Fig EST4.8
coefplot(mod1_8,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigEST4.8.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_9


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_9

** model 3- specification with basline characteristics
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_9

* Fig EST4.9
coefplot(mod1_9,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigEST4.9.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_10


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_10

** model 3- specification with basline characteristics
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_10

* Fig EST4.10
coefplot(mod1_10,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigEST4.10.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_11

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_11

** model 3- specification with basline characteristics
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_11

* Fig EST4.11
coefplot(mod1_11,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigEST4.11.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_12

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_12

** model 3- specification with basline characteristics
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_12

* Fig EST4.12
coefplot(mod1_12,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigEST4.12.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_13

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_13

** model 3- specification with basline characteristics
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_13

* Fig EST4.13
coefplot(mod1_13,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigEST4.13.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_14

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_14

** model 3- specification with basline characteristics
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_14

* Fig EST4.14
coefplot(mod1_14,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigEST4.14.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Mother Anemic
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_15

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_15

** model 3- specification with basline characteristics
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_15

* Fig EST4.15
coefplot(mod1_15,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigEST4.15.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** "During pregnancy, given or bought iron tablets/syrup"
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_16

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_16

** model 3- specification with basline characteristics
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_16

* Fig EST4.16
coefplot(mod1_16,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigEST4.16.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Days iron tablets or syrup taken
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_17

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_17

** model 3- specification with basline characteristics
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_17

* Fig EST4.17
coefplot(mod1_17,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Days iron tablets or syrup taken)
graph export "$outputdir/FigEST4.17.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child birth weight
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_18

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_18

** model 3- specification with basline characteristics
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_18

* Fig EST4.18
coefplot(mod1_18,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child birth weight)
graph export "$outputdir/FigEST4.18.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Neonatal Mortality
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_19

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_19

** model 3- specification with basline characteristics
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_19

* Fig EST4.19
coefplot(mod1_19,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Neonatal Mortality)
graph export "$outputdir/FigEST4.19.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Duration of Breastfed (months)
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_20

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_20

** model 3- specification with basline characteristics
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_20

* Fig EST4.20
coefplot(mod1_20,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigEST4.20.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Moderately or severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_21

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_21

** model 3- specification with basline characteristics
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_21

* Fig EST4.21
coefplot(mod1_21,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Moderately or severely stunted)
graph export "$outputdir/FigEST4.21.pdf", as(pdf) replace 

restore

*******************************************************************************************************************************************************************
** Severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_22

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_22

** model 3- specification with basline characteristics
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_22

* Fig EST4.22
coefplot(mod1_22,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Severely stunted)
graph export "$outputdir/FigEST4.22.pdf", as(pdf) replace 

restore

***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************


*=============================================================*
*                   Social status: Rich                       *
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

* Baseline characheristics
global baseline_char m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r

*=============================================================*
*                     Event study                             *
*=============================================================*
** Create variables for Event Study estimation.

* Group 1- firstborn
gen firstb=0
	replace firstb=1 if bord==1
	
* Group 2- secondborn
gen secondb=0
	replace secondb=1 if bord==2
	
* Create a year continuous variable.
gen y=.
	replace y=1 if yob==2010
	replace y=2 if yob==2011
	replace y=3 if yob==2012
	replace y=4 if yob==2013
	replace y=5 if yob==2014
	replace y=6 if yob==2015
	replace y=7 if yob==2016
	replace y=8 if yob==2017
	replace y=9 if yob==2018
	replace y=10 if yob==2019
	replace y=11 if yob==2020
	
* Trend variables
gen firstbtrend = firstb*y
gen secondbtrend = secondb*y

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

** Keep the sample for rich income people
keep if rich==1

*----------------------------------------------------*

** Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_1

* Fig EST5.1
coefplot(mod1_1,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigEST5.1.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Atleast one ANC visit
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_2

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_2 

** model 3- specification with basline characteristics
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_2

* Fig EST5.2 
coefplot(mod1_2,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigEST5.2.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Total ANC visits
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_3

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_3 

** model 3- specification with basline characteristics
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_3

* Fig EST5.3
coefplot(mod1_3,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigEST5.3.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Delivery at health facility
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_4

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_4 

** model 3- specification with basline characteristics
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_4

* Fig EST5.4
coefplot(mod1_4,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigEST5.4.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion reported by card or mother
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_5


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_5

** model 3- specification with basline characteristics
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_5

* Fig EST5.5
coefplot(mod1_5,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigEST5.5.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_6

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_6

** model 3- specification with basline characteristics
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_6

* Fig EST5.6
coefplot(mod1_6,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigEST5.6.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_7


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_7

** model 3- specification with basline characteristics
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_7

* Fig EST5.7
coefplot(mod1_7,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigEST5.7.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_8

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_8

** model 3- specification with basline characteristics
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_8

* Fig EST5.8
coefplot(mod1_8,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigEST5.8.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_9


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_9

** model 3- specification with basline characteristics
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_9

* Fig EST5.9
coefplot(mod1_9,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigEST5.9.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_10


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_10

** model 3- specification with basline characteristics
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_10

* Fig EST5.10
coefplot(mod1_10,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigEST5.10.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_11

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_11

** model 3- specification with basline characteristics
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_11

* Fig EST5.11
coefplot(mod1_11,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigEST5.11.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_12

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_12

** model 3- specification with basline characteristics
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_12

* Fig EST5.12
coefplot(mod1_12,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigEST5.12.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_13

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_13

** model 3- specification with basline characteristics
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_13

* Fig EST5.13
coefplot(mod1_13,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigEST5.13.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_14

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_14

** model 3- specification with basline characteristics
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_14

* Fig EST5.14
coefplot(mod1_14,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigEST5.14.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Mother Anemic
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_15

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_15

** model 3- specification with basline characteristics
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_15

* Fig EST5.15
coefplot(mod1_15,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigEST5.15.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** "During pregnancy, given or bought iron tablets/syrup"
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_16

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_16

** model 3- specification with basline characteristics
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_16

* Fig EST5.16
coefplot(mod1_16,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigEST5.16.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Days iron tablets or syrup taken
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_17

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_17

** model 3- specification with basline characteristics
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_17

* Fig EST5.17
coefplot(mod1_17,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Days iron tablets or syrup taken)
graph export "$outputdir/FigEST5.17.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child birth weight
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_18

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_18

** model 3- specification with basline characteristics
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_18

* Fig EST5.18
coefplot(mod1_18,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child birth weight)
graph export "$outputdir/FigEST5.18.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Neonatal Mortality
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_19

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_19

** model 3- specification with basline characteristics
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_19

* Fig EST5.19
coefplot(mod1_19,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Neonatal Mortality)
graph export "$outputdir/FigEST5.19.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Duration of Breastfed (months)
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_20

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_20

** model 3- specification with basline characteristics
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_20

* Fig EST5.20
coefplot(mod1_20,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigEST5.20.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Moderately or severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_21

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_21

** model 3- specification with basline characteristics
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_21

* Fig EST5.21
coefplot(mod1_21,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Moderately or severely stunted)
graph export "$outputdir/FigEST5.21.pdf", as(pdf) replace 

restore

*******************************************************************************************************************************************************************
** Severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_22

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_22

** model 3- specification with basline characteristics
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_22

* Fig EST5.22
coefplot(mod1_22,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Severely stunted)
graph export "$outputdir/FigEST5.22.pdf", as(pdf) replace 

restore

***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************


*=============================================================*
*                  Caste: Scheduled caste/Tribe               *
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

* Baseline characheristics
global baseline_char m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r

*=============================================================*
*                     Event study                             *
*=============================================================*
** Create variables for Event Study estimation.

* Group 1- firstborn
gen firstb=0
	replace firstb=1 if bord==1
	
* Group 2- secondborn
gen secondb=0
	replace secondb=1 if bord==2
	
* Create a year continuous variable.
gen y=.
	replace y=1 if yob==2010
	replace y=2 if yob==2011
	replace y=3 if yob==2012
	replace y=4 if yob==2013
	replace y=5 if yob==2014
	replace y=6 if yob==2015
	replace y=7 if yob==2016
	replace y=8 if yob==2017
	replace y=9 if yob==2018
	replace y=10 if yob==2019
	replace y=11 if yob==2020
	
* Trend variables
gen firstbtrend = firstb*y
gen secondbtrend = secondb*y

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

** Keep if only people belong to scheduled caste or tribe
keep if sch_caste_tribe==1

*----------------------------------------------------*

** Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_1

* Fig EST6.1
coefplot(mod1_1,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigEST6.1.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Atleast one ANC visit
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_2

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_2 

** model 3- specification with basline characteristics
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_2

* Fig EST6.2 
coefplot(mod1_2,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigEST6.2.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Total ANC visits
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_3

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_3 

** model 3- specification with basline characteristics
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_3

* Fig EST6.3
coefplot(mod1_3,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigEST6.3.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Delivery at health facility
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_4

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_4 

** model 3- specification with basline characteristics
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_4

* Fig EST6.4
coefplot(mod1_4,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigEST6.4.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion reported by card or mother
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_5


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_5

** model 3- specification with basline characteristics
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_5

* Fig EST6.5
coefplot(mod1_5,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigEST6.5.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_6

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_6

** model 3- specification with basline characteristics
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_6

* Fig EST6.6
coefplot(mod1_6,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigEST6.6.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_7


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_7

** model 3- specification with basline characteristics
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_7

* Fig EST6.7
coefplot(mod1_7,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigEST6.7.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_8

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_8

** model 3- specification with basline characteristics
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_8

* Fig EST6.8
coefplot(mod1_8,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigEST6.8.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_9


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_9

** model 3- specification with basline characteristics
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_9

* Fig EST6.9
coefplot(mod1_9,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigEST6.9.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_10


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_10

** model 3- specification with basline characteristics
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_10

* Fig EST6.10
coefplot(mod1_10,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigEST6.10.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_11

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_11

** model 3- specification with basline characteristics
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_11

* Fig EST6.11
coefplot(mod1_11,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigEST6.11.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_12

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_12

** model 3- specification with basline characteristics
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_12

* Fig EST6.12
coefplot(mod1_12,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigEST6.12.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_13

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_13

** model 3- specification with basline characteristics
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_13

* Fig EST6.13
coefplot(mod1_13,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigEST6.13.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_14

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_14

** model 3- specification with basline characteristics
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_14

* Fig EST6.14
coefplot(mod1_14,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigEST6.14.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Mother Anemic
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_15

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_15

** model 3- specification with basline characteristics
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_15

* Fig EST6.15
coefplot(mod1_15,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigEST6.15.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** "During pregnancy, given or bought iron tablets/syrup"
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_16

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_16

** model 3- specification with basline characteristics
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_16

* Fig EST6.16
coefplot(mod1_16,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigEST6.16.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Days iron tablets or syrup taken
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_17

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_17

** model 3- specification with basline characteristics
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_17

* Fig EST6.17
coefplot(mod1_17,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Days iron tablets or syrup taken)
graph export "$outputdir/FigEST6.17.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child birth weight
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_18

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_18

** model 3- specification with basline characteristics
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_18

* Fig EST6.18
coefplot(mod1_18,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child birth weight)
graph export "$outputdir/FigEST6.18.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Neonatal Mortality
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_19

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_19

** model 3- specification with basline characteristics
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_19

* Fig EST6.19
coefplot(mod1_19,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Neonatal Mortality)
graph export "$outputdir/FigEST6.19.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Duration of Breastfed (months)
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_20

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_20

** model 3- specification with basline characteristics
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_20

* Fig EST6.20
coefplot(mod1_20,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigEST6.20.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Moderately or severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_21

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_21

** model 3- specification with basline characteristics
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_21

* Fig EST6.21
coefplot(mod1_21,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Moderately or severely stunted)
graph export "$outputdir/FigEST6.21.pdf", as(pdf) replace 

restore

*******************************************************************************************************************************************************************
** Severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_22

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_22

** model 3- specification with basline characteristics
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_22

* Fig EST6.22
coefplot(mod1_22,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Severely stunted)
graph export "$outputdir/FigEST6.22.pdf", as(pdf) replace 

restore


***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************


*=============================================================*
*                  Caste: OBC                                 *
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

* Baseline characheristics
global baseline_char m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r

*=============================================================*
*                     Event study                             *
*=============================================================*
** Create variables for Event Study estimation.

* Group 1- firstborn
gen firstb=0
	replace firstb=1 if bord==1
	
* Group 2- secondborn
gen secondb=0
	replace secondb=1 if bord==2
	
* Create a year continuous variable.
gen y=.
	replace y=1 if yob==2010
	replace y=2 if yob==2011
	replace y=3 if yob==2012
	replace y=4 if yob==2013
	replace y=5 if yob==2014
	replace y=6 if yob==2015
	replace y=7 if yob==2016
	replace y=8 if yob==2017
	replace y=9 if yob==2018
	replace y=10 if yob==2019
	replace y=11 if yob==2020
	
* Trend variables
gen firstbtrend = firstb*y
gen secondbtrend = secondb*y

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

** Keep if only people belong to OBC caste
keep if obc==1

*----------------------------------------------------*

** Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_1

* Fig EST7.1
coefplot(mod1_1,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigEST7.1.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Atleast one ANC visit
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_2

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_2 

** model 3- specification with basline characteristics
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_2

* Fig EST7.2 
coefplot(mod1_2,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigEST7.2.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Total ANC visits
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_3

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_3 

** model 3- specification with basline characteristics
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_3

* Fig EST7.3
coefplot(mod1_3,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigEST7.3.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Delivery at health facility
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_4

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_4 

** model 3- specification with basline characteristics
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_4

* Fig EST7.4
coefplot(mod1_4,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigEST7.4.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion reported by card or mother
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_5


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_5

** model 3- specification with basline characteristics
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_5

* Fig EST7.5
coefplot(mod1_5,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigEST7.5.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_6

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_6

** model 3- specification with basline characteristics
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_6

* Fig EST7.6
coefplot(mod1_6,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigEST7.6.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_7


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_7

** model 3- specification with basline characteristics
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_7

* Fig EST7.7
coefplot(mod1_7,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigEST7.7.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_8

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_8

** model 3- specification with basline characteristics
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_8

* Fig EST7.8
coefplot(mod1_8,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigEST7.8.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_9


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_9

** model 3- specification with basline characteristics
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_9

* Fig EST7.9
coefplot(mod1_9,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigEST7.9.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_10


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_10

** model 3- specification with basline characteristics
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_10

* Fig EST7.10
coefplot(mod1_10,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigEST7.10.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_11

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_11

** model 3- specification with basline characteristics
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_11

* Fig EST7.11
coefplot(mod1_11,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigEST7.11.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_12

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_12

** model 3- specification with basline characteristics
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_12

* Fig EST7.12
coefplot(mod1_12,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigEST7.12.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_13

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_13

** model 3- specification with basline characteristics
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_13

* Fig EST7.13
coefplot(mod1_13,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigEST7.13.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_14

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_14

** model 3- specification with basline characteristics
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_14

* Fig EST7.14
coefplot(mod1_14,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigEST7.14.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Mother Anemic
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_15

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_15

** model 3- specification with basline characteristics
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_15

* Fig EST7.15
coefplot(mod1_15,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigEST7.15.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** "During pregnancy, given or bought iron tablets/syrup"
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_16

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_16

** model 3- specification with basline characteristics
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_16

* Fig EST7.16
coefplot(mod1_16,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigEST7.16.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Days iron tablets or syrup taken
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_17

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_17

** model 3- specification with basline characteristics
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_17

* Fig EST7.17
coefplot(mod1_17,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Days iron tablets or syrup taken)
graph export "$outputdir/FigEST7.17.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child birth weight
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_18

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_18

** model 3- specification with basline characteristics
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_18

* Fig EST7.18
coefplot(mod1_18,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child birth weight)
graph export "$outputdir/FigEST7.18.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Neonatal Mortality
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_19

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_19

** model 3- specification with basline characteristics
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_19

* Fig EST7.19
coefplot(mod1_19,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Neonatal Mortality)
graph export "$outputdir/FigEST7.19.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Duration of Breastfed (months)
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_20

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_20

** model 3- specification with basline characteristics
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_20

* Fig EST7.20
coefplot(mod1_20,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigEST7.20.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Moderately or severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_21

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_21

** model 3- specification with basline characteristics
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_21

* Fig EST7.21
coefplot(mod1_21,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Moderately or severely stunted)
graph export "$outputdir/FigEST7.21.pdf", as(pdf) replace 

restore

*******************************************************************************************************************************************************************
** Severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_22

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_22

** model 3- specification with basline characteristics
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_22

* Fig EST7.22
coefplot(mod1_22,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Severely stunted)
graph export "$outputdir/FigEST7.22.pdf", as(pdf) replace 

restore


***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************


*=============================================================*
*                  Caste: All other caste                     *
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

* Baseline characheristics
global baseline_char m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r

*=============================================================*
*                     Event study                             *
*=============================================================*
** Create variables for Event Study estimation.

* Group 1- firstborn
gen firstb=0
	replace firstb=1 if bord==1
	
* Group 2- secondborn
gen secondb=0
	replace secondb=1 if bord==2
	
* Create a year continuous variable.
gen y=.
	replace y=1 if yob==2010
	replace y=2 if yob==2011
	replace y=3 if yob==2012
	replace y=4 if yob==2013
	replace y=5 if yob==2014
	replace y=6 if yob==2015
	replace y=7 if yob==2016
	replace y=8 if yob==2017
	replace y=9 if yob==2018
	replace y=10 if yob==2019
	replace y=11 if yob==2020
	
* Trend variables
gen firstbtrend = firstb*y
gen secondbtrend = secondb*y

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

** Keep if only people belong to OBC caste
keep if all_oth_caste==1

*----------------------------------------------------*

** Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_1

* Fig EST8.1
coefplot(mod1_1,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigEST8.1.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Atleast one ANC visit
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_2

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_2 

** model 3- specification with basline characteristics
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_2

* Fig EST8.2 
coefplot(mod1_2,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigEST8.2.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Total ANC visits
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_3

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_3 

** model 3- specification with basline characteristics
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_3

* Fig EST8.3
coefplot(mod1_3,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigEST8.3.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Delivery at health facility
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_4

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_4 

** model 3- specification with basline characteristics
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_4

* Fig EST8.4
coefplot(mod1_4,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigEST8.4.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion reported by card or mother
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_5


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_5

** model 3- specification with basline characteristics
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_5

* Fig EST8.5
coefplot(mod1_5,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigEST8.5.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_6

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_6

** model 3- specification with basline characteristics
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_6

* Fig EST8.6
coefplot(mod1_6,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigEST8.6.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_7


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_7

** model 3- specification with basline characteristics
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_7

* Fig EST8.7
coefplot(mod1_7,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigEST8.7.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_8

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_8

** model 3- specification with basline characteristics
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_8

* Fig EST8.8
coefplot(mod1_8,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigEST8.8.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_9


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_9

** model 3- specification with basline characteristics
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_9

* Fig EST8.9
coefplot(mod1_9,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigEST8.9.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_10


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_10

** model 3- specification with basline characteristics
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_10

* Fig EST8.10
coefplot(mod1_10,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigEST8.10.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_11

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_11

** model 3- specification with basline characteristics
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_11

* Fig EST8.11
coefplot(mod1_11,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigEST8.11.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_12

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_12

** model 3- specification with basline characteristics
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_12

* Fig EST8.12
coefplot(mod1_12,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigEST8.12.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_13

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_13

** model 3- specification with basline characteristics
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_13

* Fig EST8.13
coefplot(mod1_13,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigEST8.13.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_14

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_14

** model 3- specification with basline characteristics
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_14

* Fig EST8.14
coefplot(mod1_14,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigEST8.14.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Mother Anemic
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_15

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_15

** model 3- specification with basline characteristics
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_15

* Fig EST8.15
coefplot(mod1_15,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigEST8.15.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** "During pregnancy, given or bought iron tablets/syrup"
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_16

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_16

** model 3- specification with basline characteristics
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_16

* Fig EST8.16
coefplot(mod1_16,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigEST8.16.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Days iron tablets or syrup taken
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_17

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_17

** model 3- specification with basline characteristics
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_17

* Fig EST8.17
coefplot(mod1_17,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Days iron tablets or syrup taken)
graph export "$outputdir/FigEST8.17.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child birth weight
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_18

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_18

** model 3- specification with basline characteristics
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_18

* Fig EST8.18
coefplot(mod1_18,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child birth weight)
graph export "$outputdir/FigEST8.18.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Neonatal Mortality
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_19

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_19

** model 3- specification with basline characteristics
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_19

* Fig EST8.19
coefplot(mod1_19,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Neonatal Mortality)
graph export "$outputdir/FigEST8.19.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Duration of Breastfed (months)
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_20

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_20

** model 3- specification with basline characteristics
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_20

* Fig EST8.20
coefplot(mod1_20,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigEST8.20.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Moderately or severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_21

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_21

** model 3- specification with basline characteristics
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_21

* Fig EST8.21
coefplot(mod1_21,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Moderately or severely stunted)
graph export "$outputdir/FigEST8.21.pdf", as(pdf) replace 

restore

*******************************************************************************************************************************************************************
** Severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_22

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_22

** model 3- specification with basline characteristics
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_22

* Fig EST8.22
coefplot(mod1_22,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Severely stunted)
graph export "$outputdir/FigEST8.22.pdf", as(pdf) replace 

restore


***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************


*=============================================================*
*                  Place of residence: Rural                   *
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

* Baseline characheristics
global baseline_char m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r

*=============================================================*
*                     Event study                             *
*=============================================================*
** Create variables for Event Study estimation.

* Group 1- firstborn
gen firstb=0
	replace firstb=1 if bord==1
	
* Group 2- secondborn
gen secondb=0
	replace secondb=1 if bord==2
	
* Create a year continuous variable.
gen y=.
	replace y=1 if yob==2010
	replace y=2 if yob==2011
	replace y=3 if yob==2012
	replace y=4 if yob==2013
	replace y=5 if yob==2014
	replace y=6 if yob==2015
	replace y=7 if yob==2016
	replace y=8 if yob==2017
	replace y=9 if yob==2018
	replace y=10 if yob==2019
	replace y=11 if yob==2020
	
* Trend variables
gen firstbtrend = firstb*y
gen secondbtrend = secondb*y

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

** Keep if only people live in rural
keep if rural==1

*----------------------------------------------------*

** Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_1

* Fig EST9.1
coefplot(mod1_1,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigEST9.1.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Atleast one ANC visit
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_2

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_2 

** model 3- specification with basline characteristics
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_2

* Fig EST9.2 
coefplot(mod1_2,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigEST9.2.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Total ANC visits
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_3

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_3 

** model 3- specification with basline characteristics
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_3

* Fig EST9.3
coefplot(mod1_3,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigEST9.3.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Delivery at health facility
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_4

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_4 

** model 3- specification with basline characteristics
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_4

* Fig EST9.4
coefplot(mod1_4,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigEST9.4.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion reported by card or mother
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_5


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_5

** model 3- specification with basline characteristics
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_5

* Fig EST9.5
coefplot(mod1_5,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigEST9.5.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_6

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_6

** model 3- specification with basline characteristics
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_6

* Fig EST9.6
coefplot(mod1_6,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigEST9.6.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_7


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_7

** model 3- specification with basline characteristics
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_7

* Fig EST9.7
coefplot(mod1_7,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigEST9.7.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_8

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_8

** model 3- specification with basline characteristics
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_8

* Fig EST9.8
coefplot(mod1_8,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigEST9.8.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_9


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_9

** model 3- specification with basline characteristics
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_9

* Fig EST9.9
coefplot(mod1_9,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigEST9.9.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_10


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_10

** model 3- specification with basline characteristics
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_10

* Fig EST9.10
coefplot(mod1_10,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigEST9.10.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_11

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_11

** model 3- specification with basline characteristics
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_11

* Fig EST9.11
coefplot(mod1_11,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigEST9.11.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_12

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_12

** model 3- specification with basline characteristics
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_12

* Fig EST9.12
coefplot(mod1_12,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigEST9.12.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_13

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_13

** model 3- specification with basline characteristics
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_13

* Fig EST9.13
coefplot(mod1_13,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigEST9.13.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_14

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_14

** model 3- specification with basline characteristics
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_14

* Fig EST9.14
coefplot(mod1_14,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigEST9.14.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Mother Anemic
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_15

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_15

** model 3- specification with basline characteristics
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_15

* Fig EST9.15
coefplot(mod1_15,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigEST9.15.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** "During pregnancy, given or bought iron tablets/syrup"
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_16

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_16

** model 3- specification with basline characteristics
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_16

* Fig EST9.16
coefplot(mod1_16,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigEST9.16.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Days iron tablets or syrup taken
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_17

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_17

** model 3- specification with basline characteristics
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_17

* Fig EST9.17
coefplot(mod1_17,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Days iron tablets or syrup taken)
graph export "$outputdir/FigEST9.17.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child birth weight
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_18

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_18

** model 3- specification with basline characteristics
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_18

* Fig EST9.18
coefplot(mod1_18,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child birth weight)
graph export "$outputdir/FigEST9.18.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Neonatal Mortality
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_19

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_19

** model 3- specification with basline characteristics
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_19

* Fig EST9.19
coefplot(mod1_19,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Neonatal Mortality)
graph export "$outputdir/FigEST9.19.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Duration of Breastfed (months)
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_20

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_20

** model 3- specification with basline characteristics
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_20

* Fig EST9.20
coefplot(mod1_20,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigEST9.20.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Moderately or severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_21

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_21

** model 3- specification with basline characteristics
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_21

* Fig EST9.21
coefplot(mod1_21,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Moderately or severely stunted)
graph export "$outputdir/FigEST9.21.pdf", as(pdf) replace 

restore

*******************************************************************************************************************************************************************
** Severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_22

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_22

** model 3- specification with basline characteristics
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_22

* Fig EST9.22
coefplot(mod1_22,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Severely stunted)
graph export "$outputdir/FigEST9.22.pdf", as(pdf) replace 

restore


***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************
***************************************************************************************************************************************************************************


*=============================================================*
*                  Place of residence: Rural                   *
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

* Baseline characheristics
global baseline_char m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r

*=============================================================*
*                     Event study                             *
*=============================================================*
** Create variables for Event Study estimation.

* Group 1- firstborn
gen firstb=0
	replace firstb=1 if bord==1
	
* Group 2- secondborn
gen secondb=0
	replace secondb=1 if bord==2
	
* Create a year continuous variable.
gen y=.
	replace y=1 if yob==2010
	replace y=2 if yob==2011
	replace y=3 if yob==2012
	replace y=4 if yob==2013
	replace y=5 if yob==2014
	replace y=6 if yob==2015
	replace y=7 if yob==2016
	replace y=8 if yob==2017
	replace y=9 if yob==2018
	replace y=10 if yob==2019
	replace y=11 if yob==2020
	
* Trend variables
gen firstbtrend = firstb*y
gen secondbtrend = secondb*y

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

** Keep if only people live in rural
keep if rural==0

*----------------------------------------------------*

** Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 

** model 3- specification with basline characteristics
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_1

* Fig EST10.1
coefplot(mod1_1,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigEST10.1.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Atleast one ANC visit
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_2

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_2 

** model 3- specification with basline characteristics
reg anc_visit firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_2

* Fig EST10.2 
coefplot(mod1_2,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigEST10.2.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Total ANC visits
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_3

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_3 

** model 3- specification with basline characteristics
reg tot_anc9 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_3

* Fig EST10.3
coefplot(mod1_3,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigEST10.3.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Delivery at health facility
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_4

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_4 

** model 3- specification with basline characteristics
reg del_healthf firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_4

* Fig EST10.4
coefplot(mod1_4,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigEST10.4.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion reported by card or mother
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_5


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_5

** model 3- specification with basline characteristics
reg ch_firstvac firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_5

* Fig EST10.5
coefplot(mod1_5,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigEST10.5.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child first dose of vaccinantion by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_6

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_6

** model 3- specification with basline characteristics
reg ch_firstvac_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_6

* Fig EST10.6
coefplot(mod1_6,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigEST10.6.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_7


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_7

** model 3- specification with basline characteristics
reg ch_bcg firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_7

* Fig EST10.7
coefplot(mod1_7,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigEST10.7.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received BCG reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_8

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_8

** model 3- specification with basline characteristics
reg ch_bcg_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_8

* Fig EST10.8
coefplot(mod1_8,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigEST10.8.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_9


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_9

** model 3- specification with basline characteristics
reg ch_hep1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_9

* Fig EST10.9
coefplot(mod1_9,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigEST10.9.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose Hep-B reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_10


** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_10

** model 3- specification with basline characteristics
reg ch_hep1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_10

* Fig EST10.10
coefplot(mod1_10,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigEST10.10.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_11

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_11

** model 3- specification with basline characteristics
reg ch_dpt1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_11

* Fig EST10.11
coefplot(mod1_11,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigEST10.11.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose DPT reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_12

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_12

** model 3- specification with basline characteristics
reg ch_dpt1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_12

* Fig EST10.12
coefplot(mod1_12,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigEST10.12.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by mother or card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_13

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_13

** model 3- specification with basline characteristics
reg ch_opv1 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_13

* Fig EST10.13
coefplot(mod1_13,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigEST10.13.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Received first dose OPV reported by card
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_14

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_14

** model 3- specification with basline characteristics
reg ch_opv1_card firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_14

* Fig EST10.14
coefplot(mod1_14,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigEST10.14.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Mother Anemic
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_15

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_15

** model 3- specification with basline characteristics
reg m_anemia firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_15

* Fig EST10.15
coefplot(mod1_15,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigEST10.15.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** "During pregnancy, given or bought iron tablets/syrup"
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_16

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_16

** model 3- specification with basline characteristics
reg iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_16

* Fig EST10.16
coefplot(mod1_16,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigEST10.16.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Days iron tablets or syrup taken
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_17

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_17

** model 3- specification with basline characteristics
reg dur_iron_spplm firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_17

* Fig EST10.17
coefplot(mod1_17,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Days iron tablets or syrup taken)
graph export "$outputdir/FigEST10.17.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Child birth weight
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_18

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_18

** model 3- specification with basline characteristics
reg ch_bw firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_18

* Fig EST10.18
coefplot(mod1_18,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child birth weight)
graph export "$outputdir/FigEST10.18.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Neonatal Mortality
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_19

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_19

** model 3- specification with basline characteristics
reg neo_mort firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_19

* Fig EST10.19
coefplot(mod1_19,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Neonatal Mortality)
graph export "$outputdir/FigEST10.19.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Duration of Breastfed (months)
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_20

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_20

** model 3- specification with basline characteristics
reg breast_dur firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_20

* Fig EST10.20
coefplot(mod1_20,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigEST10.20.pdf", as(pdf) replace 

restore

************************************************************************************************************************************************************

** Moderately or severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_21

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_21

** model 3- specification with basline characteristics
reg mod_svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_21

* Fig EST10.21
coefplot(mod1_21,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Moderately or severely stunted)
graph export "$outputdir/FigEST10.21.pdf", as(pdf) replace 

restore

*******************************************************************************************************************************************************************
** Severely stunted
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_22

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_22

** model 3- specification with basline characteristics
reg svr_stunted firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_22

* Fig EST10.22
coefplot(mod1_22,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Severely stunted)
graph export "$outputdir/FigEST10.22.pdf", as(pdf) replace 

restore