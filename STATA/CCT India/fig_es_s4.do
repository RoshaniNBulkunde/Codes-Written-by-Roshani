/* 
This file is to event study graphs for outcome variables 
*Roshani Bulkunde */

clear all
set more off
cap log close


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

*-------------------------------------------------------------*

** Pregrancy Registration
preserve

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

** model 1- Basic model
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.yob i.eligible firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod1_1
/*
The estimates are same as:
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend i.yob i.eligible [aw=weight]

Also same as:
reghdfe preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtre
> nd firstb10 firstb16 [aw=weight], absorb(yob eligible)

Also same as:
reghdfe preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible#c.yob firstb10 firstb16 [aw=weight], absorb(yob eligible)

Also same as:
reghdfe preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible#c.yob [aw=weight], absorb(yob eligible)

*/

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district)
estimates store mod2_1 
/* 
The estimates are same as:
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend i.eligible i.surveyXyob [aw=weight]

Also same as:
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible#c.yob i.eligible i.surveyXyob [aw=weight]

reghdfe preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 i.eligible#c.yob firstb10 firstb16 [aw=weight], absorb(eligible surveyXyob)
*/

** model 3- specification with basline characteristics
reg preg_regist firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstbtrend secondbtrend $baseline_char ///
i.eligible i.surveyXyob firstb10 firstb16 [aw=weight], vce(cluster district) 
estimates store mod3_1

* Fig ES2.1
coefplot(mod1_1,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/FigES2.1.pdf", as(pdf) replace 

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

* Fig ES2.1
coefplot(mod1_2,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/FigES2.2.pdf", as(pdf) replace 

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

* Fig ES2.3
coefplot(mod1_3,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/FigES2.3.pdf", as(pdf) replace 

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

* Fig ES2.4
coefplot(mod1_4,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/FigES2.4.pdf", as(pdf) replace 

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

* Fig ES2.5
coefplot(mod1_5,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion reported by card or mother)
graph export "$outputdir/FigES2.5.pdf", as(pdf) replace 

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

* Fig ES2.6
coefplot(mod1_6,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child first dose of vaccinantion by card)
graph export "$outputdir/FigES2.6.pdf", as(pdf) replace 

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

* Fig ES2.7
coefplot(mod1_7,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by mother or card)
graph export "$outputdir/FigES2.7.pdf", as(pdf) replace 

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

* Fig ES2.8
coefplot(mod1_8,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received BCG reported by card)
graph export "$outputdir/FigES2.8.pdf", as(pdf) replace 

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

* Fig ES2.9
coefplot(mod1_9,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by mother or card)
graph export "$outputdir/FigES2.9.pdf", as(pdf) replace 

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

* Fig ES2.10
coefplot(mod1_10,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose Hep-B reported by card)
graph export "$outputdir/FigES2.10.pdf", as(pdf) replace 

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

* Fig ES2.11
coefplot(mod1_11,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by mother or card)
graph export "$outputdir/FigES2.11.pdf", as(pdf) replace 

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

* Fig ES2.12
coefplot(mod1_12,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose DPT reported by card)
graph export "$outputdir/FigES2.12.pdf", as(pdf) replace 

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

* Fig ES2.13
coefplot(mod1_13,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by mother or card)
graph export "$outputdir/FigES2.13.pdf", as(pdf) replace 

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

* Fig ES2.14
coefplot(mod1_14,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Model include survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Model include controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received first dose OPV reported by card)
graph export "$outputdir/FigES2.14.pdf", as(pdf) replace 

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

* Fig ES2.15
coefplot(mod1_15,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother Anemic)
graph export "$outputdir/FigES2.15.pdf", as(pdf) replace 

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

* Fig ES2.16
coefplot(mod1_16,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("During pregnancy, given or bought iron tablets/syrup")
graph export "$outputdir/FigES2.16.pdf", as(pdf) replace 

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

* Fig ES2.17
coefplot(mod1_17,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Days iron tablets or syrup taken)
graph export "$outputdir/FigES2.17.pdf", as(pdf) replace 

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

* Fig ES2.18
coefplot(mod1_18,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child birth weight)
graph export "$outputdir/FigES2.18.pdf", as(pdf) replace 

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

* Fig ES2.19
coefplot(mod1_19,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_19,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_19,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Neonatal Mortality)
graph export "$outputdir/FigES2.19.pdf", as(pdf) replace 

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

* Fig ES2.20
coefplot(mod1_20,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_20,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_20,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title("Duration of Breastfed (months)")
graph export "$outputdir/FigES2.20.pdf", as(pdf) replace 

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

* Fig ES2.21
coefplot(mod1_21,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_21,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_21,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Moderately or severely stunted)
graph export "$outputdir/FigES2.21.pdf", as(pdf) replace 

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

* Fig ES2.22
coefplot(mod1_22,  label("Basic model") drop(_cons firstbtrend secondbtrend *.yob *.eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_22,  label("Model includes survey-by-birth-year fe") drop(_cons eligible firstbtrend secondbtrend *.eligible *.surveyXyob) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_22,  label("Model includes controls") drop(_cons $baseline_char firstbtrend secondbtrend *.eligible *.surveyXyob) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ) ///
vertical omitted baselevels ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Severely stunted)
graph export "$outputdir/FigES2.22.pdf", as(pdf) replace 

restore