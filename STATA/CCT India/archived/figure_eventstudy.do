/* 
This file is to event study graphs for outcome variables 
*Roshani Bulkunde */

clear all
set more off
cap log close

log using "C:\Users\rosha\Dropbox (GaTech)\CCT India\logs\fig_eventstudy.log", replace

* nfhs data
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures\parallel_birth order 1,2"


* Keep the sample with birth order 1,2
drop if yob==2021 
keep if bord==1 | bord==2 
drop if bord==.

* Create eligible=1 if first born
gen  eligible=0
	replace eligible=1 if bord==1

* Baseline characheristics
global baseline_char m_schooling m_age afb afc rural poor middle rich sch_caste_tribe obc all_oth_caste hindu muslim other_r


*Year indicator variables
forvalues i=10(1)20{
	gen y20`i' = 0
	replace y20`i' = 1 if yob == 20`i'
}


* Interaction terms between eligible and year indicator variables
forvalues i=10(1)20{
	gen firstb`i' = eligible*y20`i'
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

* Event Study
	* cct year
    gen treat_year=2017
	gen timeToTreat = yob - treat_year
	
	* Make dummies for period and omit -1 period
	char timeToTreat[omit] -1
	xi i.timeToTreat, pref(_T)
	
*renaming the time to treat names for clear understanding
rename _TtimeToTre_1  timetreat_n7
rename _TtimeToTre_2  timetreat_n6
rename _TtimeToTre_3  timetreat_n5
rename _TtimeToTre_4  timetreat_n4
rename _TtimeToTre_5  timetreat_n3
rename _TtimeToTre_6  timetreat_n2
rename _TtimeToTre_8  timetreat_0
rename _TtimeToTre_9  timetreat_p1
rename _TtimeToTre_10 timetreat_p2
rename _TtimeToTre_11 timetreat_p3

	
*=============================================================*
*                     Event study                             *
*=============================================================*

set scheme s1color 
grstyle init
grstyle set plain, nogrid 


** Pregrancy Registration
preserve

** model 1- Basic model
reghdfe preg_regist 1.eligible#1.timetreat_n7 1.eligible#1.timetreat_n6 1.eligible#1.timetreat_n5 ///
1.eligible#1.timetreat_n4 1.eligible#1.timetreat_n3 1.eligible#1.timetreat_n2 1.eligible#1.timetreat_0 ///
1.eligible#1.timetreat_p1  1.eligible#1.timetreat_p2 1.eligible#1.timetreat_p3 1.timetreat_n7 1.timetreat_n6 ///
1.timetreat_n5 1.timetreat_n4 1.timetreat_n3 1.timetreat_n2 1.timetreat_0 1.timetreat_p1  1.timetreat_p2 ///
1.timetreat_p3 [aw=weight], absorb(eligible yob)

estimates store mod1_1

xi: reghdfe preg_regist firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb17 firstb18 firstb19 firstb20 firstb16 [aw=weight], absorb(eligible yob) 

reghdfe preg_regist 1.eligible#1._T* 1.eligible [aw=weight], absorb(eligible yob)
estimates store mod1_1

*/

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe preg_regist 1.eligible#1.timetreat_n7 1.eligible#1.timetreat_n6 1.eligible#1.timetreat_n5 ///
1.eligible#1.timetreat_n4 1.eligible#1.timetreat_n3 1.eligible#1.timetreat_n2 1.eligible#1.timetreat_0 ///
1.eligible#1.timetreat_p1  1.eligible#1.timetreat_p2 1.eligible#1.timetreat_p3 1.timetreat_n7 1.timetreat_n6 ///
1.timetreat_n5 1.timetreat_n4 1.timetreat_n3 1.timetreat_n2 1.timetreat_0 1.timetreat_p1  1.timetreat_p2 ///
1.timetreat_p3 [aw=weight], absorb(eligible surveyXyob) 


estimates store mod2_1 

* model 3- specification with basline characteristics
reghdfe preg_regist 1.eligible#1.timetreat_n7 1.eligible#1.timetreat_n6 1.eligible#1.timetreat_n5 ///
1.eligible#1.timetreat_n4 1.eligible#1.timetreat_n3 1.eligible#1.timetreat_n2 1.eligible#1.timetreat_0 ///
1.eligible#1.timetreat_p1  1.eligible#1.timetreat_p2 1.eligible#1.timetreat_p3 1.timetreat_n7 1.timetreat_n6 ///
1.timetreat_n5 1.timetreat_n4 1.timetreat_n3 1.timetreat_n2 1.timetreat_0 1.timetreat_p1  ///
1.timetreat_p2 1.timetreat_p3 $baseline_char [aw=weight], absorb(eligible surveyXyob)  

estimates store mod3_1

* Fig 13.1
coefplot(mod1_1,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_1,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_1,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), vertical ///
order(1.eligible#1._TtimeToTre_1 1.eligible#1._TtimeToTre_2 1.eligible#1._TtimeToTre_3 1.eligible#1._TtimeToTre_4 1.eligible#1._TtimeToTre_5 1.eligible#1._TtimeToTre_6 1.eligible#1._TtimeToTre_8 1.eligible#1._TtimeToTre_9 1.eligible#1._TtimeToTre_10 1.eligible#1._TtimeToTre_11) ///
coeflabels(1.eligible#1._TtimeToTre_1="-7" 1.eligible#1._TtimeToTre_2="-6" 1.eligible#1._TtimeToTre_3="-5" 1.eligible#1._TtimeToTre_4="-4" 1.eligible#1._TtimeToTre_5="-3" 1.eligible#1._TtimeToTre_6="-2" 1.eligible#1._TtimeToTre_8="0" 1.eligible#1._TtimeToTre_9="1" 1.eligible#1._TtimeToTre_10="2" 1.eligible#1._TtimeToTre_11="3") ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Pregnancy registration)
graph export "$outputdir/Fig13.1.pdf", as(pdf) replace 

restore


*************************************************************************************************************************************************


** Atleast one ANC visit
preserve

** model 1- Basic model
reghdfe anc_visit 1.eligible#1._T* 1.eligible [aw=weight], absorb(eligible yob)
estimates store mod1_2

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe anc_visit  1.eligible#1._T* 1.eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_2

* model 3- specification with basline characteristics
reghdfe anc_visit 1.eligible#1._T* 1.eligible $baseline_char ///
[aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_2

* Fig 13.2
coefplot(mod1_2,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), vertical ///
order(1.eligible#1._TtimeToTre_1 1.eligible#1._TtimeToTre_2 1.eligible#1._TtimeToTre_3 1.eligible#1._TtimeToTre_4 1.eligible#1._TtimeToTre_5 1.eligible#1._TtimeToTre_6 1.eligible#1._TtimeToTre_8 1.eligible#1._TtimeToTre_9 1.eligible#1._TtimeToTre_10 1.eligible#1._TtimeToTre_11) ///
coeflabels(1.eligible#1._TtimeToTre_1="-7" 1.eligible#1._TtimeToTre_2="-6" 1.eligible#1._TtimeToTre_3="-5" 1.eligible#1._TtimeToTre_4="-4" 1.eligible#1._TtimeToTre_5="-3" 1.eligible#1._TtimeToTre_6="-2" 1.eligible#1._TtimeToTre_8="0" 1.eligible#1._TtimeToTre_9="1" 1.eligible#1._TtimeToTre_10="2" 1.eligible#1._TtimeToTre_11="3") ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/Fig13.2.pdf", as(pdf) replace 

restore

********************************************************************************

** Delivery at health facility
preserve

** model 1- Basic model
reghdfe del_healthf 1.eligible#1._T* 1.eligible [aw=weight], absorb(eligible yob)
estimates store mod1_3

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

reghdfe del_healthf  1.eligible#1._T* 1.eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_3

* model 3- specification with basline characteristics
reghdfe del_healthf 1.eligible#1._T* 1.eligible $baseline_char ///
[aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_3

* Fig 13.2
coefplot(mod1_3,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), vertical ///
order(1.eligible#1._TtimeToTre_1 1.eligible#1._TtimeToTre_2 1.eligible#1._TtimeToTre_3 1.eligible#1._TtimeToTre_4 1.eligible#1._TtimeToTre_5 1.eligible#1._TtimeToTre_6 1.eligible#1._TtimeToTre_8 1.eligible#1._TtimeToTre_9 1.eligible#1._TtimeToTre_10 1.eligible#1._TtimeToTre_11) ///
coeflabels(1.eligible#1._TtimeToTre_1="-7" 1.eligible#1._TtimeToTre_2="-6" 1.eligible#1._TtimeToTre_3="-5" 1.eligible#1._TtimeToTre_4="-4" 1.eligible#1._TtimeToTre_5="-3" 1.eligible#1._TtimeToTre_6="-2" 1.eligible#1._TtimeToTre_8="0" 1.eligible#1._TtimeToTre_9="1" 1.eligible#1._TtimeToTre_10="2" 1.eligible#1._TtimeToTre_11="3") ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/Fig13.3.pdf", as(pdf) replace 

restore




























































/*

** Atleast one ANC visits
preserve

** model 1- Basic model
xi: reghdfe anc_visit firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_2

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe anc_visit firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_2 

* model 3- specification with basline characteristics
xi: reghdfe anc_visit firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_2

* Fig 13.2
coefplot(mod1_2,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_2,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_2,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Atleast one ANC visit)
graph export "$outputdir/Fig13.2.pdf", as(pdf) replace 

restore


*************************************************************************************************************************************************

** Total Anc visits
preserve

** model 1- Basic model
xi: reghdfe tot_anc9 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_3

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe tot_anc9 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_3 

* model 3- specification with basline characteristics
xi: reghdfe tot_anc9 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_3

* Fig 13.3
coefplot(mod1_3,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_3,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_3,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Total ANC visits)
graph export "$outputdir/Fig13.3.pdf", as(pdf) replace 

restore


*************************************************************************************************************************************************

** Delivery at health facility
preserve

** model 1- Basic model
xi: reghdfe del_healthf firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_4

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe del_healthf firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_4 

* model 3- specification with basline characteristics
xi: reghdfe del_healthf firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_4

* Fig 13.3
coefplot(mod1_4,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_4,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_4,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Delivery at health facility)
graph export "$outputdir/Fig13.4.pdf", as(pdf) replace 

restore

*************************************************************************************************************************************************

** Received the first dose of required vaccines
preserve

** model 1- Basic model
xi: reghdfe ch_firstvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_5

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe ch_firstvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_5 

* model 3- specification with basline characteristics
xi: reghdfe ch_firstvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_5

* Fig 13.3
coefplot(mod1_5,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_5,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_5,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received the first dose of required vaccines)
graph export "$outputdir/Fig13.5.pdf", as(pdf) replace 

restore

*************************************************************************************************************************************************

** Received the first dose of any required vaccines
preserve

** model 1- Basic model
xi: reghdfe ch_anyvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_6

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe ch_anyvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_6 

* model 3- specification with basline characteristics
xi: reghdfe ch_anyvac firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_6

* Fig 13.3
coefplot(mod1_6,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_6,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_6,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received the first dose of any required vaccines)
graph export "$outputdir/Fig13.6.pdf", as(pdf) replace 

restore

*************************************************************************************************************************************************

** Received the first dose of BCG
preserve

** model 1- Basic model
xi: reghdfe ch_bcg firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_7

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe ch_bcg firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_7 

* model 3- specification with basline characteristics
xi: reghdfe ch_bcg firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_7

* Fig 13.3
coefplot(mod1_7,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_7,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_7,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received the first dose of BCG)
graph export "$outputdir/Fig13.7.pdf", as(pdf) replace 

restore


*************************************************************************************************************************************************

** Received the first dose of Hep-B
preserve

** model 1- Basic model
xi: reghdfe ch_hep1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_8

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe ch_hep1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_8 

* model 3- specification with basline characteristics
xi: reghdfe ch_hep1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_8

* Fig 13.3
coefplot(mod1_8,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_8,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_8,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received the first dose of Hep-B)
graph export "$outputdir/Fig13.8.pdf", as(pdf) replace 

restore


*************************************************************************************************************************************************

** Received the first dose of DPT
preserve

** model 1- Basic model
xi: reghdfe ch_dpt1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_9

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe ch_dpt1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_9

* model 3- specification with basline characteristics
xi: reghdfe ch_dpt1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_9

* Fig 13.3
coefplot(mod1_9,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_9,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_9,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received the first dose of DPT)
graph export "$outputdir/Fig13.9.pdf", as(pdf) replace 

restore


*************************************************************************************************************************************************

** Received the first dose of OPV
preserve

** model 1- Basic model
xi: reghdfe ch_opv1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_10

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe ch_opv1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_10

* model 3- specification with basline characteristics
xi: reghdfe ch_opv1 firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_10

* Fig 13.3
coefplot(mod1_10,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_10,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_10,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Received the first dose of OPV)
graph export "$outputdir/Fig13.10.pdf", as(pdf) replace 

restore


*************************************************************************************************************************************************

** Mother is anaemic
preserve

** model 1- Basic model
xi: reghdfe m_anemia firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_11

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe m_anemia firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_11

* model 3- specification with basline characteristics
xi: reghdfe m_anemia firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_11

* Fig 13.3
coefplot(mod1_11,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_11,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_11,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Mother is anaemic)
graph export "$outputdir/Fig13.11.pdf", as(pdf) replace 

restore


*************************************************************************************************************************************************

** During pregnancy given/bought iron tablets/syrup
preserve

** model 1- Basic model
xi: reghdfe iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_12

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_12

* model 3- specification with basline characteristics
xi: reghdfe iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_12

* Fig 13.3
coefplot(mod1_12,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_12,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_12,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(During pregnancy given/bought iron tablets/syrup)
graph export "$outputdir/Fig13.12.pdf", as(pdf) replace 

restore



*************************************************************************************************************************************************

** During pregnancy given/bought iron tablets/syrup
preserve

** model 1- Basic model
xi: reghdfe iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_13

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_13

* model 3- specification with basline characteristics
xi: reghdfe iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_13

* Fig 13.3
coefplot(mod1_13,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_13,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_13,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(During pregnancy given/bought iron tablets/syrup)
graph export "$outputdir/Fig13.13.pdf", as(pdf) replace 

restore

*************************************************************************************************************************************************

** Days iron tablets or syrup taken
preserve

** model 1- Basic model
xi: reghdfe dur_iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_14

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe dur_iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_14

* model 3- specification with basline characteristics
xi: reghdfe dur_iron_spplm firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_14

* Fig 13.3
coefplot(mod1_14,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_14,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_14,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Days iron tablets or syrup taken)
graph export "$outputdir/Fig13.14.pdf", as(pdf) replace 

restore


*************************************************************************************************************************************************

** Child birth weight
preserve

** model 1- Basic model
xi: reghdfe ch_bw firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_15

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe ch_bw firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_15

* model 3- specification with basline characteristics
xi: reghdfe ch_bw firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_15

* Fig 13.3
coefplot(mod1_15,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_15,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_15,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Child birth weight)
graph export "$outputdir/Fig13.15.pdf", as(pdf) replace 

restore

*************************************************************************************************************************************************

** Neonatal mortality
preserve

** model 1- Basic model
xi: reghdfe neo_mort firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20 ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_16

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe neo_mort firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_16

* model 3- specification with basline characteristics
xi: reghdfe neo_mort firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_16

* Fig 13.3
coefplot(mod1_16,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_16,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_16,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Neonatal mortality)
graph export "$outputdir/Fig13.16.pdf", as(pdf) replace 

restore


*************************************************************************************************************************************************

** Duration of Breastfed (months)
preserve

** model 1- Basic model
xi: reghdfe breast_dur firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_17

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe breast_dur firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_17

* model 3- specification with basline characteristics
xi: reghdfe breast_dur firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_17

* Fig 13.3
coefplot(mod1_17,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_17,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_17,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Duration of Breastfed (months))
graph export "$outputdir/Fig13.17.pdf", as(pdf) replace 

restore


*************************************************************************************************************************************************

** Moderate or severe stunting
preserve

** model 1- Basic model
xi: reghdfe svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible) 
estimates store mod1_18

** model 2- specification including survey-by-birth-year fixed effects.
* Create survey-by-birth-year fixed effects  
egen surveyXyob=group(survey yob), label

xi: reghdfe svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  ///
eligible [aw=weight], absorb(eligible surveyXyob) 
estimates store mod2_18

* model 3- specification with basline characteristics
xi: reghdfe svr_stunted firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20  $baseline_char ///
eligible [aw=weight], absorb(eligible surveyXyob)  
estimates store mod3_18

* Fig 13.3
coefplot(mod1_18,  label("Basic model") drop(_cons eligible) level(95) ciopts(color(green)) msymbol(O) mcolor(green) msize(green)) ///
(mod2_18,  label("Specification including survey-by-birth-year fe") drop(_cons eligible) level(95)  ciopts(color(navy)) msymbol(O) mcolor(navy) msize(navy)) ///
(mod3_18,  label("Specification including controls") drop(_cons eligible $baseline_char) level(95) ciopts(color(maroon)) msymbol(O) mcolor(maroon) msize(maroon)), ///
order(firstb10 firstb11 firstb12 firstb13 firstb14 firstb15 firstb16 firstb17 firstb18 firstb19 firstb20) vertical ///
xtitle(Years since CCT implemented, size(small)) ///
yline(0, lcolor(black) lpattern(shortdash_dot)) ///
title(Moderate or severe stunting)
graph export "$outputdir/Fig13.18.pdf", as(pdf) replace 

restore




























/*ssc install eventdd

* Fig 
preserve 
	* cct year
    gen treat_year=2017
	gen timeToTreat = yob - treat_year
	egen new_absorb=group(survey yob)
	/* 
eventdd lnmmrt i.year, timevar(timeToTreat) method(hdfe, absorb(country) cluster(country)) lags(10) leads(10) accum over(GDPp25) jitter(0.2) graph_op(ytitle("ln(Maternal Mortality)") legend(pos(6) order(2 "Point Estimate (GDP {&ge} 25 p)" 5 "Point Estimate (GDP < 25 p)" 1 "95% CI") rows(1)) ylabel(, format("%04.2f"))) coef_op(g1(ms(Sh)) g2(ms(Oh))) ci(rarea, g1(color(gs12%30)) g2(color(gs12%50))) */
    * Plot event study
	eventdd preg_regist eligible $baseline_char, timevar(timeToTreat) method(hdfe, absorb(eligible survey)) graph_op(xlabel(-7(1)3))

restore

preserve 
	* cct year
    gen treat_year=2017
	gen timeToTreat = yob - treat_year
	/* 
eventdd lnmmrt i.year, timevar(timeToTreat) method(hdfe, absorb(country) cluster(country)) lags(10) leads(10) accum over(GDPp25) jitter(0.2) graph_op(ytitle("ln(Maternal Mortality)") legend(pos(6) order(2 "Point Estimate (GDP {&ge} 25 p)" 5 "Point Estimate (GDP < 25 p)" 1 "95% CI") rows(1)) ylabel(, format("%04.2f"))) coef_op(g1(ms(Sh)) g2(ms(Oh))) ci(rarea, g1(color(gs12%30)) g2(color(gs12%50))) */
    * Plot event study
	eventdd del_healthf eligible i.eligible, timevar(timeToTreat) method(ols) graph_op(xlabel(-7(1)3))

	

restore


*----------------------------------

* create the lag/lead
* cct year
    gen treat_year=2017
	gen timeToTreat = yob - treat_year
	
	estimates clear
	// code for identification strategy 1
	
gen n=eligible*y2010

regress preg_regist n
estimates store A

coefplot (A)
	
	
gen y2010=1 if yob==2010
replace y2010=0 if yob!=2010
	
*/	
	
	
	