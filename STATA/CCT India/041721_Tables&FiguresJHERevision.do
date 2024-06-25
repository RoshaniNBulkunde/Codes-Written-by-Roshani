*Mayra Pineda-Torres
*April 17, 2021

/*
This code contains the estimations for the paper as of 4/17/21. We decided that
the main estimations of the paper will compare TN, excluding Hamilton, Southeast,
Sullivan, and Northeast, because their behavior is weird, and we cannot explain it.

So, instead of comparing TN to the other states, we compare TN excluding those 
four areas with the groups of states.

NOTE: The figure "lnabrate_healthregions.png" is generated with the code 
"022721_HealthAreasAnalysis.do," in lines 411-442.

*/

****************************************************************************
************************ANALYSIS USING HEALTH AREA DATA*********************
****************************************************************************

clear all
set more off

cd "C:\Users\MayraBelinda\Dropbox\ResearchProjects\Reassessing the Effects of Mandatory Waiting Periods\Analysis\StateAnalysisNewData\StatesDataset"
gl outputdir "C:\Users\MayraBelinda\Dropbox\ResearchProjects\Reassessing the Effects of Mandatory Waiting Periods\Draft\GraphsResubmissionJHE"

*This path is in a different folder because the other path has blanks between words
*and for some reason the command does not work with such a path
gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

capture program drop preamble
program define preamble

*Generate population by health region

use "FemPop1544_counties.dta", clear

tempfile PopulationHealthArea

merge m:1 countyid using "countybyhealthareaTN.dta"
browse if _merge == 1
browse if _merge == 3
drop if _merge!=3
drop _merge

sort healtharea year

collapse(sum) fempop_15to44, by(healtharea year)

rename healtharea area

save "`PopulationHealthArea'"

clear
import excel using "TNHealthAreasData.xlsx", sheet(Data) firstrow

merge 1:1 area year using "`PopulationHealthArea'"
drop if year<2010
browse if _merge == 1 /*Whole state, Tennessee data*/
drop if _merge != 3
drop _merge

******************************************************
*Merge with information on female population by age group and race
merge 1:1 area year using "PopbyHealthAreaSexRaceTN.dta"
tab year if _merge == 2 /*2018*/
drop if _merge == 2
drop _merge

*Drop the four health areas that show weird jumps in the data or are more likely to have out-of-state abortions
drop if (area == "Hamilton" | area == "Southeast" | area == "Sullivan" | area == "Northeast")

collapse(sum) allres_* fempop_15to44 fem_*, by(year)

tempfile areas
save  `areas'

******************************************************
*Merge with information on unemployment by health area
clear
use "UnempRateHealthAreas.dta"
merge 1:1 area year using "`PopulationHealthArea'"
browse if _merge == 2
tab year if _merge == 2 /*2018*/
drop if _merge != 3
drop _merge

*Drop the four health areas that show weird jumps in the data or are more likely to have out-of-state abortions
drop if (area == "Hamilton" | area == "Southeast" | area == "Sullivan" | area == "Northeast")

collapse (mean) unemprate [pw=fempop_15to44], by(year)

tempfile unemprate
save `unemprate'

*******************************************************

clear
use `areas'
merge 1:1 year using `unemprate'
drop _merge

*****Create variables of interest*****

*Total abortions
egen ab_total_nomissga_rep = rowtotal(allres_6less allres_7to8 ///
allres_9to10 allres_11to12 allres_13to14 allres_15to16 ///
allres_17to20)

*First-trimester abortions
egen ab_le12 = rowtotal(allres_6less allres_7to8 allres_9to10 ///
allres_11to12)

*Percent of second-trimester abortions
gen frac_ab_gr12_rep = 100*(1-ab_le12/ab_total_nomissga_rep)

*Abortion rate
gen ab_all_nomissga_1544per1k_rep=1000*ab_total_nomissga_rep/fempop_15to44

*Second-trimester abortion rate
gen ab_gr12_1544per1k_rep=1000*(ab_total_nomissga_rep - ab_le12)/fempop_15to44


*I will assign the state name "HealthAreas" to this information to identify it
*easily once I append this information with the reports and CDC data
gen state = "HealthAreas"
rename fempop_15to44 tot1544
drop fem_tot1544

order state year

*Log rates
gen lnab_gr12_1544per1k_rep = ln(ab_gr12_1544per1k_rep)
gen lnab_all_nomissga_1544per1k_rep = ln(ab_all_nomissga_1544per1k_rep)

*Generate shares of female population by age group and race or ethnicity
gl ages 1519 2024 2529 3034 3539 4044 
 
foreach n in $ages{
	gen share`n' = (fem_`n'/tot1544)*100
}

gen hispanic1544 = (fem_hisp1544/tot1544)*100
gen whnohisp1544 = (fem_wanh1544/tot1544)*100
gen black1544 = (fem_ba1544/tot1544)*100

drop fem*

tempfile Health

save "`Health'"

**********************************
**********Health Reports**********
**********************************

tempfile Reports

use "ResidentsDataReadyForAnalysis_updated.dta", clear

*Drop information for Texas and Delaware
drop if state == "Texas" | state == "Delaware"

keep if frac_ab_gr12~=.

*Log rates
gen lnab_gr12_1544per1k_rep = ln(ab_gr12_1544per1k_rep)
gen lnab_all_nomissga_1544per1k_rep = ln(ab_all_nomissga_1544per1k_rep)

drop if state == "Alabama"

gen newcontrol = 0
replace newcontrol = 1 if (state == "Arizona" | state == "Illinois" | ///
state == "Minnesota" | state == "Missouri" | state == "New Mexico" | ///
state == "New York" | state == "North Carolina" | state == "Oklahoma" | ///
state == "Pennsylvania" | state == "Utah" | state == "Washington" | ///
state == "Wisconsin")

tab state newcontrol

gen group3 = 0 if TN==1
replace group3=1 if newcontrol == 1 /*Control + NC & MO*/

*Keep data of states we use in the main analysis
keep if group3 == 1 | TN == 1

*Keep variables of interest

keep state state_fips year frac_ab_gr12_rep lnab_gr12_1544per1k ///
lnab_all_nomissga_1544per1k_rep share1519 share2024 share2529 share3034 ///
share3539 share4044 black1544 hispanic1544 whnohisp1544 unemprate ///
ab_total_nomissga_rep tot1544 ///
group3 TN ab_all_nomissga_1544per1k_rep ab_gr12_1544per1k_rep

save "`Reports'"

****************************
**********CDC DATA**********
****************************

clear

tempfile CDC

use "CDCDatasetReadyforAnalysis.dta", clear

preserve
	keep if year == 2016

	set scheme s1color 
	grstyle init
	grstyle set plain, nogrid 

	histogram meanoutstate, frequency xtitle("Average percent of out-of-state abortions (2000-2016)") ///
	ytitle("Number of states") lcolor(white) fcolor(gray) ylabel(0(5)30) width(5) xlabel(0(5)50)
	graph export "$outputdir\CDCData_OutStateAbortions_Freq.png", replace

restore


*Drop states with incomplete data --> California, Louisiana and New Hampshire do
*not have data in 2006

drop if state == "California" | state == "New Hampshire" | state == "Louisiana"

keep if year >= 2010

*Find states with missing information of abortions by gestation age in some years
*between 2010-2016
bysort state: egen maxfrac12_2010 = max(frac_ab_gr12_rep) if year>=2010
su maxfrac12_2010 if maxfrac12_2010!=100

*The following graphs will start in 2010 and will only consider in the analysis
*states with complete data between 2010-2016

bysort state: egen totmaxfrac12_2010 = max(maxfrac12_2010)
tab state totmaxfrac12_2010
drop if totmaxfrac12_2010 >= 100

*Keep states with low interstate travel: the rule will be those will less than 40%
*out-of-state abortions because that includes states with less than 5% less
*than 10%, and less than 20%

keep if out40less == 1

*Keep variables of interest
keep state state_fips year frac_ab_gr12_rep lnab_gr12_1544per1k ///
lnab_all_nomissga_1544per1k_rep share1519 share2024 share2529 share3034 ///
share3539 share4044 black1544 hispanic1544 whnohisp1544 unemprate ///
ab_total_nomissga_rep ///
tot1544 out5less out10less out20less out40less ab_all_nomissga_1544per1k_rep ///
ab_gr12_1544per1k_rep

*Drop observations of states that are in the health department reports
drop if (state == "Arizona" | state == "Illinois" | ///
state == "Minnesota" | state == "Missouri" | state == "New Mexico" | ///
state == "New York" | state == "North Carolina" | state == "Oklahoma" | ///
state == "Pennsylvania" | state == "Utah" | state == "Washington" | ///
state == "Wisconsin" | state == "Tennessee")

*Eliminate states we already decided that should not be included in the analysis
drop if state == "Texas" | state == "Alabama"

tab state

tab year

save "`CDC'"

*Append datasets
clear
use "`Health'"
append using "`Reports'"
append using "`CDC'"

*Identify TN whole state as "TNState" and the selected health areas at "Tennessee"
replace state = "TNState" if state == "Tennessee"

replace state = "Tennessee" if state == "HealthAreas"

replace state_fips = 0 if state == "Tennessee" 
replace state_fips = 99 if state == "TNState"

*Control for comparison group 2 
gen newcontrol = 0
replace newcontrol = 1 if (state == "Arizona" | state == "Illinois" | ///
state == "Minnesota" | state == "Missouri" | state == "New Mexico" | ///
state == "New York" | state == "North Carolina" | state == "Oklahoma" | ///
state == "Pennsylvania" | state == "Utah" | state == "Washington" | ///
state == "Wisconsin")

tab state newcontrol
drop TN
gen TN = 1 if state == "Tennessee"
tab TN

gen TNState = 1 if state == "TNState"
tab TNState

*****Comparison group 2*****

*Refined TN
drop group3
gen group3 = 0 if TN==1
replace group3=1 if newcontrol == 1 /*Control + NC & MO*/

*All TN health areas
gen group3st = 0 if TNState==1
replace group3st=1 if newcontrol == 1 /*Control + NC & MO*/


*****Comparison group 1*****
*--> Only for TN refined analysis
*Group a) original control states plus states with less than 5% out-of-state abortions

gen groupa = 0 if TN == 1
replace groupa = 1 if (group3 == 1 | out5less == 1)

*Group b) original control states plus states with less than 10% out-of-state abortions

gen groupb = 0 if TN == 1
replace groupb = 1 if (group3 == 1 | out10less == 1)

*Group c) original control states plus states with less than 20% out-of-state abortions

gen groupc = 0 if TN == 1
replace groupc = 1 if (group3 == 1 | out20less == 1)

*To see which states are included in each group
tab state if groupa == 1
tab state if groupb == 1
tab state if groupc == 1

*Group d) original control states plus states with less than 20% out-of-state abortions,
*excluding states with major abortion policy changes
*--> THIS IS THE NEW COMPARISON GROUP

*Comparison with TN selected areas (refined TN)
gen groupd = 0 if TN == 1
replace groupd = 1 if (group3 == 1 | out20less == 1)
replace groupd = . if (state == "Arizona" | state == "Arkansas" | state == "Illinois" | ///
state == "Indiana" | state == "Pennsylvania" | state == "Virginia")

tab state if groupd == .

*Comparison with all TN
gen groupdst = 0 if TNState == 1
replace groupdst = 1 if (group3st == 1 | out20less == 1)
replace groupdst = . if (state == "Arizona" | state == "Arkansas" | state == "Illinois" | ///
state == "Indiana" | state == "Pennsylvania" | state == "Virginia")

tab state if groupdst == .

*For robustness checks --> Only defined for the refined TN

*Group e) original control states plus states with less than 5% out-of-state abortions,
*excluding states with major abortion policy changes
*--> THIS IS THE NEW COMPARISON GROUP
gen groupe = 0 if TN == 1
replace groupe = 1 if (group3 == 1 | out5less == 1)
replace groupe = . if (state == "Arizona" | state == "Arkansas" | state == "Illinois" | ///
state == "Indiana" | state == "Pennsylvania" | state == "Virginia")

tab state groupe
tab state if groupe == .

gen groupest = 0 if TNState == 1
replace groupest = 1 if (group3st == 1 | out5less == 1)
replace groupest = . if (state == "Arizona" | state == "Arkansas" | state == "Illinois" | ///
state == "Indiana" | state == "Pennsylvania" | state == "Virginia")

tab state groupest
tab state if groupest == .

*Group f) original control states plus states with less than 10% out-of-state abortions,
*excluding states with major abortion policy changes
*--> THIS IS THE NEW COMPARISON GROUP
gen groupf = 0 if TN == 1
replace groupf = 1 if (group3 == 1 | out10less == 1)
replace groupf = . if (state == "Arizona" | state == "Arkansas" | state == "Illinois" | ///
state == "Indiana" | state == "Pennsylvania" | state == "Virginia")

tab state groupf
tab state if groupf == .

gen groupfst = 0 if TNState == 1
replace groupfst = 1 if (group3st == 1 | out10less == 1)
replace groupfst = . if (state == "Arizona" | state == "Arkansas" | state == "Illinois" | ///
state == "Indiana" | state == "Pennsylvania" | state == "Virginia")

tab state groupfst
tab state if groupfst == .

*Group g) original control states plus states with less than 40% out-of-state abortions,
*excluding states with major abortion policy changes
*--> THIS IS THE NEW COMPARISON GROUP
gen groupg = 0 if TN == 1
replace groupg = 1 if (group3 == 1 | out40less == 1)
replace groupg = . if (state == "Arizona" | state == "Arkansas" | state == "Illinois" | ///
state == "Indiana" | state == "Pennsylvania" | state == "Virginia")

tab state groupg
tab state if groupg == .

gen groupgst = 0 if TNState == 1
replace groupgst = 1 if (group3st == 1 | out40less == 1)
replace groupgst = . if (state == "Arizona" | state == "Arkansas" | state == "Illinois" | ///
state == "Indiana" | state == "Pennsylvania" | state == "Virginia")

tab state groupgst
tab state if groupgst == .

********************************************************************************
*Declare panel
xtset state_fips year


*Weights
egen total_ab_allyears_mean=mean(ab_total_nomissga), by(state_fips)
egen total_ab_allyears_rep_mean=mean(ab_total_nomissga_rep), by(state_fips)
egen total_pop1544_mean=mean(tot1544), by(state_fips)


*Label variables for output tables*
label variable frac_ab_gr12_rep "Percent of second trimester abortions"
label variable unemprate "Unemp rate"
label variable ab_gr12_1544per1k_rep "Second-trimester abortion rate"
label variable ab_all_nomissga_1544per1k_rep "Overall abortion rate"
label variable lnab_gr12_1544per1k_rep "Log(Second-trimester abortion rate)"
label variable lnab_all_nomissga_1544per1k_rep "Log(ab rate)"


******Variables of Interest*****

*Refined TN
gen ShareTreated = 0
replace ShareTreated = 7/12 if (state == "Tennessee" & year == 2015)
replace ShareTreated = 12/12 if (state == "Tennessee" & year >= 2016)
replace ShareTreated = . if state == "TNState"

*All TN
gen ShareTreatedSt = 0
replace ShareTreatedSt = 7/12 if (state == "TNState" & year == 2015)
replace ShareTreatedSt = 12/12 if (state == "TNState" & year >= 2016)
replace ShareTreatedSt = . if state == "Tennessee"

*****Treatments*****
*Refined TN
forvalues i=10(1)17{
	gen TN`i' = 0
	replace TN`i' = 1 if (state == "Tennessee" & year == 20`i')
}

label variable TN10 "-5"
label variable TN11 "-4"
label variable TN12 "-3"
label variable TN13 "-2"
label variable TN14 "-1"
label variable TN15 "0"
label variable TN16 "1"
label variable TN17 "2"

*TN State
forvalues i=10(1)17{
	gen TNSt`i' = 0
	replace TNSt`i' = 1 if (state == "TNState" & year == 20`i')
}

label variable TNSt10 "-5"
label variable TNSt11 "-4"
label variable TNSt12 "-3"
label variable TNSt13 "-2"
label variable TNSt14 "-1"
label variable TNSt15 "0"
label variable TNSt16 "1"
label variable TNSt17 "2"

tab state

*Label state FIPS 
#delimit;
label define state_fips ///
1 "Alabama" ///
2 "Alaska" ///
4 "Arizona" ///
5 "Arkansas" ///
6 "California" ///
8 "Colorado" ///
9 "Connecticut" ///
10 "Delaware" ///
12 "Florida" ///
13 "Georgia" ///
15 "Hawaii" ///
16 "Idaho" ///
17 "Illinois" ///
18 "Indiana" ///
19 "Iowa" ///
20 "Kansas" ///
21 "Kentucky" ///
22 "Louisiana" ///
23 "Maine" ///
24 "Maryland" ///
25 "Massachusetts" ///
26 "Michigan" ///
27 "Minnesota" ///
28 "Mississippi" ///
29 "Missouri" ///
30 "Montana" ///
31 "Nebraska" ///
32 "Nevada" ///
33 "New Hampshire" ///
34 "New Jersey" ///
35 "New Mexico" ///
36 "New York" ///
37 "North Carolina" ///
38 "North Dakota" ///
39 "Ohio" ///
40 "Oklahoma" ///
41 "Oregon" ///
42 "Pennsylvania" ///
44 "Rhode Island" ///
45 "South Carolina" ///
46 "South Dakota" ///
0 "Tennessee" ///
99 "Tennessee State"
48 "Texas" ///
49 "Utah" ///
50 "Vermont" ///
51 "Virginia" ///
53 "Washington" ///
54 "West Virginia" ///
55 "Wisconsin" ///
56 "Wyoming" ///
60 "American Samoa" ///
66 "Guam" ///
69 "Northern Mariana Islands" ///
72 "Puerto Rico" ///
78 "Virgin Islands";
#delimit cr

label values state_fips state_fips
tab state_fips


end
exit
********************************************************************************
********************************************************************************
***************************TABLE 1: DESCRIPTIVE STATISTICS**********************
********************************************************************************
********************************************************************************

preamble

tab state group3
tab state groupd

scalar drop _all

*Comparison group 1
forvalues i=0(1)1{
su frac_ab_gr12_rep if year<2015 & groupd == `i'
scalar share12plus`i'_before = r(mean)
su frac_ab_gr12_rep if year>=2015 & groupd == `i'
scalar share12plus`i'_after = r(mean)

su ab_gr12_1544per1k_rep if year<2015 & groupd == `i'
scalar abrate12plus`i'_before = r(mean)
su ab_gr12_1544per1k_rep if year>=2015 & groupd == `i'
scalar abrate12plus`i'_after = r(mean)

su ab_all_nomissga_1544per1k_rep if year<2015 & groupd == `i'
scalar abrate`i'_before = r(mean)
su ab_all_nomissga_1544per1k_rep if year>=2015 & groupd == `i'
scalar abrate`i'_after = r(mean)

*Controls
gl age 1519 2024 2529 3034 3539 4044

foreach n in $age{
su share`n' if year<2015 & groupd == `i'
scalar share`n'`i'_before = r(mean)
su share`n' if year>=2015 & groupd == `i'
scalar share`n'`i'_after = r(mean)
}

gl race black hispanic whnohisp

foreach m in $race{
su `m'1544 if year<2015 & groupd == `i'
scalar `m'1544`i'_before = r(mean)
su `m'1544 if year>=2015 & groupd == `i'
scalar `m'1544`i'_after = r(mean)
}

su unemprate if year<2015 & groupd == `i'
scalar unrate`i'_before = r(mean)
su unemprate if year>=2015 & groupd == `i'
scalar unrate`i'_after = r(mean)
}


*Comparison group 2
su frac_ab_gr12_rep if year<2015 & group3 == 1
scalar share12plus1_before2 = r(mean)
su frac_ab_gr12_rep if year>=2015 & group3 == 1
scalar share12plus1_after2 = r(mean)

su ab_gr12_1544per1k_rep if year<2015 & group3 == 1
scalar abrate12plus1_before2 = r(mean)
su ab_gr12_1544per1k_rep if year>=2015 & group3 == 1
scalar abrate12plus1_after2 = r(mean)

su ab_all_nomissga_1544per1k_rep if year<2015 & group3 == 1
scalar abrate1_before2 = r(mean)
su ab_all_nomissga_1544per1k_rep if year>=2015 & group3 == 1
scalar abrate1_after2 = r(mean)

*Controls
gl age 1519 2024 2529 3034 3539 4044

foreach n in $age{
su share`n' if year<2015 & group3 == 1
scalar share`n'1_before2 = r(mean)
su share`n' if year>=2015 & group3 == 1
scalar share`n'1_after2 = r(mean)
}

gl race black hispanic whnohisp

foreach m in $race{
su `m'1544 if year<2015 & group3 == 1
scalar `m'15441_before2 = r(mean)
su `m'1544 if year>=2015 & group3 == 1
scalar `m'15441_after2 = r(mean)
}

su unemprate if year<2015 & group3 == 1
scalar unrate1_before2 = r(mean)
su unemprate if year>=2015 & group3 == 1
scalar unrate1_after2 = r(mean)


scalar list


********************************************************************************
********************************************************************************
*******************************FIGURES 3 AND 4**********************************
********************************************************************************
********************************************************************************

******************
*****FIGURE 3*****
******************

*****Percent second-trimester abortions*****
preamble

/*
preserve
	collapse frac_ab_gr12_rep [weight=ab_total_nomissga_rep], by(groupdst group3st year)
	drop if groupdst == .
	bysort groupdst : gen first = _n == 1
	expand 2 if first, gen(newvar)
	replace year = 2018 if newvar == 1
	replace frac_ab_gr12_rep = . if newvar == 1
	sort groupdst year
	drop first newvar
	set scheme s1color 
	grstyle init
	grstyle set plain, nogrid 
	separate frac_ab_gr12_rep, by(groupdst) veryshortlabel
	rename frac_ab_gr12_rep frac12
	separate frac12, by(group3st) veryshortlabel
	twoway scatteri 0 2014.5 20 2014.5 20 2015.5 0 2015.5, recast(area) color(gray*0.2) || ///
	scatteri 0 2015.5 20 2015.5 20 2017.5 0 2017.5, recast(area) color(gray*0.3) || /// 
	scatter frac_ab_gr12_rep0 year, ms(Oh) || ///
	scatter frac_ab_gr12_rep1 year if group3st == . & year!=2017, ms(Dh) || ///
	scatter frac121 year, ms(Th) legend(lab(3 "Tennessee") lab(4 "Comparison Group 1") lab(5 "Comparison Group 2") order(4 5 3) position(6) col(1)) ytitle(Percent of abortions in the second trimester) yscale(r(0 20))  xlabel(2010(1)2017) ///
	text(18 2015 "Partially" "affected", size(small)) ///
	text(18 2016 "         Fully", size(small)) ///
	text(18 2017 "affected      ", size(small))
	graph export "$outputdir/TNvsAugmentedControl_ab_gr12_rep.png", replace
restore
*/

*****Percent second-trimester abortions, including Refined TN*****
preamble

*Comparison group 1 and Whole TN
preserve
collapse frac_ab_gr12_rep [weight=ab_total_nomissga_rep], by(groupdst year)
drop if groupdst == .
tempfile data1
save `data1'
restore

*Comparison group 2
preserve
collapse frac_ab_gr12_rep [weight=ab_total_nomissga_rep], by(group3st year)
keep if group3st == 1
tempfile data2
save `data2'
restore

*Refined TN
preserve
collapse frac_ab_gr12_rep [weight=ab_total_nomissga_rep], by(group3 year)
keep if group3 == 0  /*Refined TN*/
tempfile data3
save `data3'
restore

clear
use `data1'
append using `data2'
append using `data3'

gen group = 0 if groupdst == 0 /*Whole TN*/
replace group = 1 if group3 == 0 /*Refined TN*/
replace group = 2 if groupdst == 1 /*Comparison group 1*/
replace group = 3 if group3st == 1 /*Comparison group 2*/

bysort group: gen first = _n == 1	
expand 2 if first, gen(newvar)
replace year = 2018 if newvar == 1
replace frac_ab_gr12_rep = . if newvar == 1
sort group year
drop first newvar
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate frac_ab_gr12_rep, by(group) veryshortlabel
twoway scatteri 0 2014.5 20 2014.5 20 2015.5 0 2015.5, recast(area) color(gray*0.2) || ///
scatteri 0 2015.5 20 2015.5 20 2017.5 0 2017.5, recast(area) color(gray*0.3) || /// 
scatter frac_ab_gr12_rep0 year, ms(Oh) mcolor(navy) || ///
scatter frac_ab_gr12_rep1 year, ms(Sh)  mcolor(navy) || ///	
scatter frac_ab_gr12_rep2 year if year!=2017, ms(Dh) mcolor(maroon) || ///
scatter frac_ab_gr12_rep3 year, ms(Th) mcolor(dkgreen) legend(lab(3 "Tennessee") lab(4 "Refined Tennessee") lab(5 "Comparison Group 1") lab(6 "Comparison Group 2") order(5 6 3 4) position(6) col(2)) ytitle(Percent of abortions in the second trimester) yscale(r(0 20))  xlabel(2010(1)2017) ///
text(18 2015 "Partially" "affected", size(small)) ///
text(18 2016 "         Fully", size(small)) ///
text(18 2017 "affected      ", size(small))
graph export "$outputdir/Figure3.png", replace 


******************
*****FIGURE 4*****
******************

*****Log of Rate of second-trimester abortion*****
preamble

/*
preserve
	collapse lnab_gr12_1544per1k_rep [weight=tot1544], by(groupdst group3st year)
	drop if groupdst == .
	bysort groupdst : gen first = _n == 1
	expand 2 if first, gen(newvar)
	replace year = 2018 if newvar == 1
	replace lnab_gr12_1544per1k_rep = . if newvar == 1
	sort groupdst year
	drop first newvar
	set scheme s1color 
	grstyle init
	grstyle set plain, nogrid 
	separate lnab_gr12_1544per1k_rep, by(groupdst) veryshortlabel
	rename lnab_gr12_1544per1k_rep lnab_gr12
	separate lnab_gr12, by(group3st) veryshortlabel
	twoway scatteri -2 2014.5 2 2014.5 2 2015.5 -2 2015.5, recast(area) nodropbase color(gray*0.2) || ///
	scatteri -2 2015.5 2 2015.5 2 2017.5 -2 2017.5, recast(area) nodropbase color(gray*0.3) || ///
	scatter lnab_gr12_1544per1k_rep0 year, ms(Oh) || ///
	scatter lnab_gr12_1544per1k_rep1 year if group3st ==. & year!=2017, ms(Dh) || ///	
	scatter lnab_gr121 year, ms(Th) legend(lab(3 "Tennessee") lab(4 "Comparison Group 1") lab(5 "Comparison Group 2") order(4 5 3) position(6) col(1)) ytitle(Log(2nd trimester abortions per 1000 women)) yscale(r(-2 2)) ylabel(-2(.5)2) xlabel(2010(1)2017) ///
	text(1.5 2015 "Partially" "affected", size(small)) ///
	text(1.5 2016 "        Fully", size(small)) ///
	text(1.5 2017 "affected     ", size(small))
	graph export "$outputdir/TNvsAugmentedControl_lnab_gr12.png", replace 
restore
*/

*****Log of Rate of second-trimester abortion, including Refined TN*****

preamble

*Comparison group 1 and Whole TN
preserve
collapse lnab_gr12_1544per1k_rep [weight=tot1544], by(groupdst year)
drop if groupdst == .
tempfile data1
save `data1'
restore

*Comparison group 2
preserve
collapse lnab_gr12_1544per1k_rep [weight=tot1544], by(group3st year)
keep if group3st == 1
tempfile data2
save `data2'
restore

*Refined TN
preserve
collapse lnab_gr12_1544per1k_rep [weight=tot1544], by(group3 year)
keep if group3 == 0  /*Refined TN*/
tempfile data3
save `data3'
restore

clear
use `data1'
append using `data2'
append using `data3'

gen group = 0 if groupdst == 0 /*Whole TN*/
replace group = 1 if group3 == 0 /*Refined TN*/
replace group = 2 if groupdst == 1 /*Comparison group 1*/
replace group = 3 if group3st == 1 /*Comparison group 2*/

bysort group: gen first = _n == 1	
expand 2 if first, gen(newvar)
replace year = 2018 if newvar == 1
replace lnab_gr12_1544per1k_rep = . if newvar == 1
sort group year
drop first newvar
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate lnab_gr12_1544per1k_rep, by(group) veryshortlabel
twoway scatteri -2 2014.5 2 2014.5 2 2015.5 -2 2015.5, recast(area) nodropbase color(gray*0.2) || ///
scatteri -2 2015.5 2 2015.5 2 2017.5 -2 2017.5, recast(area) nodropbase color(gray*0.3) || ///
scatter lnab_gr12_1544per1k_rep0 year, ms(Oh) mcolor(navy) || ///
scatter lnab_gr12_1544per1k_rep1 year, ms(Sh)  mcolor(navy) || ///	
scatter lnab_gr12_1544per1k_rep2 year if year!=2017, ms(Dh) mcolor(maroon) || ///
scatter lnab_gr12_1544per1k_rep3 year, ms(Th) mcolor(dkgreen) legend(lab(3 "Tennessee") lab(4 "Refined Tennessee") lab(5 "Comparison Group 1") lab(6 "Comparison Group 2") order(5 6 3 4) position(6) col(2)) ytitle(Log(2nd trimester abortions per 1000 women)) yscale(r(-2 2)) ylabel(-2(.5)2) xlabel(2010(1)2017) ///
text(1.5 2015 "Partially" "affected", size(small)) ///
text(1.5 2016 "        Fully", size(small)) ///
text(1.5 2017 "affected     ", size(small))
graph export "$outputdir/Figure4A.png", replace 


*****Log of Overall abortion rate*****
/*
preserve
	collapse lnab_all_nomissga_1544per1k_rep [weight=tot1544], by(groupdst group3st year) 
	drop if groupdst == .
	bysort groupdst : gen first = _n == 1
	expand 2 if first, gen(newvar)
	replace year = 2018 if newvar == 1
	replace lnab_all_nomissga_1544per1k_rep = . if newvar == 1
	sort groupdst year
	drop first newvar
	set scheme s1color 
	grstyle init
	grstyle set plain, nogrid 
	separate lnab_all_nomissga_1544per1k_rep, by(groupdst) veryshortlabel
	rename lnab_all_nomissga_1544per1k_rep lnabrate
	separate lnabrate, by(group3st) veryshortlabel
	twoway scatteri 1 2014.5 3.5 2014.5 3.5 2015.5 1 2015.5, recast(area) color(gray*0.2) || ///
	scatteri 1 2015.5 3.5 2015.5 3.5 2017.5 1 2017.5, recast(area) color(gray*0.3) || ///
	scatter lnab_all_nomissga_1544per1k_rep0 year, ms(Oh) || ///
	scatter lnab_all_nomissga_1544per1k_rep1 year if group3st ==. & year!=2017, ms(Dh) || ///
	scatter lnabrate1 year, ms(Th) legend(lab(3 "Tennessee") lab(4 "Comparison Group 1") lab(5 "Comparison Group 2") order(4 5 3) position(6) col(1)) ytitle(Log (Abortions per 1000 women, ages 15-44)) yscale(r(1 3.5)) ylabel(1(.5)3.5) xlabel(2010(1)2017) ///
	text(3.3 2015 "Partially" "affected", size(small)) ///
	text(3.3 2016 "        Fully", size(small)) ///
	text(3.3 2017 "affected     ", size(small))
	graph export "$outputdir/TNvsAugmentedControl_lnab_all_nomissga.png", replace
restore
*/

*****Log of Overall abortion rate, including Refined TN*****

preamble

*Comparison group 1 and Whole TN
preserve
collapse lnab_all_nomissga_1544per1k_rep [weight=tot1544], by(groupdst year)
drop if groupdst == .
tempfile data1
save `data1'
restore

*Comparison group 2
preserve
collapse lnab_all_nomissga_1544per1k_rep [weight=tot1544], by(group3st year)
keep if group3st == 1
tempfile data2
save `data2'
restore

*Refined TN
preserve
collapse lnab_all_nomissga_1544per1k_rep [weight=tot1544], by(group3 year)
keep if group3 == 0  /*Refined TN*/
tempfile data3
save `data3'
restore

clear
use `data1'
append using `data2'
append using `data3'

gen group = 0 if groupdst == 0 /*Whole TN*/
replace group = 1 if group3 == 0 /*Refined TN*/
replace group = 2 if groupdst == 1 /*Comparison group 1*/
replace group = 3 if group3st == 1 /*Comparison group 2*/

bysort group: gen first = _n == 1	
expand 2 if first, gen(newvar)
replace year = 2018 if newvar == 1
replace lnab_all_nomissga_1544per1k_rep = . if newvar == 1
sort group year
drop first newvar
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate lnab_all_nomissga_1544per1k_rep, by(group) veryshortlabel
twoway scatteri 1 2014.5 3.5 2014.5 3.5 2015.5 1 2015.5, recast(area) color(gray*0.2) || ///
scatteri 1 2015.5 3.5 2015.5 3.5 2017.5 1 2017.5, recast(area) color(gray*0.3) || ///
scatter lnab_all_nomissga_1544per1k_rep0 year, ms(Oh) mcolor(navy) || ///
scatter lnab_all_nomissga_1544per1k_rep1 year, ms(Sh)  mcolor(navy) || ///	
scatter lnab_all_nomissga_1544per1k_rep2 year if year!=2017, ms(Dh) mcolor(maroon) || ///
scatter lnab_all_nomissga_1544per1k_rep3 year, ms(Th) mcolor(dkgreen) legend(lab(3 "Tennessee") lab(4 "Refined Tennessee") lab(5 "Comparison Group 1") lab(6 "Comparison Group 2") order(5 6 3 4) position(6) col(2)) ytitle(Log (Abortions per 1000 women, ages 15-44)) yscale(r(1 3.5)) ylabel(1(.5)3.5) xlabel(2010(1)2017) ///
text(3.3 2015 "Partially" "affected", size(small)) ///
text(3.3 2016 "        Fully", size(small)) ///
text(3.3 2017 "affected     ", size(small))
graph export "$outputdir/Figure4B.png", replace 


********************************************************************************
********************************************************************************
**************************FIGURE 5: EVENT STUDY*********************************
********************************************************************************
********************************************************************************

*NOTE: Figure A2 is generated with the information on this section

preamble

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

***Percent of second-trimester abortions***
*All controls --> Whole TN
*Control Group 1
preserve
keep if groupdst == 1 | TNState == 1 & year<=2016
xi: xtreg frac_ab_gr12_rep i.year TNSt10 TNSt11 TNSt12 TNSt13 TNSt15 TNSt16 TNSt14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)
estimates store frac12_3_1
restore

*Control Group 2
preserve
keep if group3st == 1 | TNState == 1
xi: xtreg frac_ab_gr12_rep i.year TNSt10 TNSt11 TNSt12 TNSt13 TNSt15 TNSt16 TNSt17 TNSt14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)
estimates store frac12_3_2
restore

coefplot(frac12_3_1, label("Comparison group 1") drop(_cons _Iyear* share* black1544 hispanic1544 ///
whnohisp1544 unemprate) ciopts(color(none)) msymbol(O) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(dash)) ///
(frac12_3_2, label("Comparison Group 2") drop(_cons _Iyear* share* black1544 hispanic1544 ///
whnohisp1544 unemprate) ciopts(color(none)) msymbol(T) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(shortdash)), ///
order(TNSt10 TNSt11 TNSt12 TNSt13 TNSt14 TNSt15 TNSt16 TNSt17) vertical omitted baselevels ///
xtitle(Years Since MWP Law Passed) ///
yscale(r(-2 8)) ylabel(-2(2)8) yline(0, lcolor(black) lpattern(shortdash_dot))
graph export "$outputdir/eventst_BothControls_2ndtrimab_3.png", replace


*All controls --> Refined TN
*Control Group 1
preserve
keep if groupd == 1 | TN == 1 & year<=2016
xi: xtreg frac_ab_gr12_rep i.year TN10 TN11 TN12 TN13 TN15 TN16 TN14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)
estimates store frac12_3_1
restore

*Control Group 2
preserve
keep if group3 == 1 | TN == 1
xi: xtreg frac_ab_gr12_rep i.year TN10 TN11 TN12 TN13 TN15 TN16 TN17 TN14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)
estimates store frac12_3_2
restore

coefplot(frac12_3_1, label("Comparison group 1") drop(_cons _Iyear* share* black1544 hispanic1544 ///
whnohisp1544 unemprate) ciopts(color(none)) msymbol(O) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(dash)) ///
(frac12_3_2, label("Comparison Group 2") drop(_cons _Iyear* share* black1544 hispanic1544 ///
whnohisp1544 unemprate) ciopts(color(none)) msymbol(T) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(shortdash)), ///
order(TN10 TN11 TN12 TN13 TN14 TN15 TN16 TN17) vertical omitted baselevels ///
xtitle(Years Since MWP Law Passed) ///
yscale(r(-2 8)) ylabel(-2(2)8) yline(0, lcolor(black) lpattern(shortdash_dot))
graph export "$outputdir/eventst_BothControls_2ndtrimab_Refined3.png", replace

***Log of the abortion rate after 12 weeks of gestation***
*All controls --> Whole TN
*Control Group 1
preserve
keep if groupdst == 1 | TNState == 1 & year<=2016
xi: xtreg lnab_gr12_1544per1k_rep i.year TNSt10 TNSt11 TNSt12 TNSt13 TNSt15 ///
TNSt16 TNSt14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)
estimates store lnab12_3_1
restore

*Control Group 2
preserve
keep if group3st == 1 | TNState == 1
xi: xtreg lnab_gr12_1544per1k_rep i.year TNSt10 TNSt11 TNSt12 TNSt13 TNSt15 ///
TNSt16 TNSt17 TNSt14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)
estimates store lnab12_3_2
restore

coefplot(lnab12_3_1, label("Comparison group 1") drop(_cons _Iyear* share* black1544 hispanic1544 ///
whnohisp1544 unemprate) ciopts(color(none)) msymbol(O) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(dash)) ///
(lnab12_3_2, label("Comparison Group 2") drop(_cons _Iyear* share* black1544 hispanic1544 ///
whnohisp1544 unemprate) ciopts(color(none)) msymbol(D) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(shortdash)), ///
order(TNSt10 TNSt11 TNSt12 TNSt13 TNSt14 TNSt15 TNSt16 TNSt17) vertical omitted baselevels ///
xtitle(Years Since MWP Law Passed) ///
yscale(r(-.2 .8)) ylabel(-.2(.2).8) yline(0, lcolor(black) lpattern(shortdash_dot))
graph export "$outputdir/eventst_BothControls_ln2ntrimabrate_3.png", replace


*All controls --> Refined TN
*Control Group 1
preserve
keep if groupd == 1 | TN == 1 & year<=2016
xi: xtreg lnab_gr12_1544per1k_rep i.year TN10 TN11 TN12 TN13 TN15 ///
TN16 TN14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)
estimates store lnab12_3_1
restore

*Control Group 2
preserve
keep if group3 == 1 | TN == 1
xi: xtreg lnab_gr12_1544per1k_rep i.year TN10 TN11 TN12 TN13 TN15 ///
TN16 TN17 TN14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)
estimates store lnab12_3_2
restore

coefplot(lnab12_3_1, label("Comparison group 1") drop(_cons _Iyear* share* black1544 hispanic1544 ///
whnohisp1544 unemprate) ciopts(color(none)) msymbol(O) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(dash)) ///
(lnab12_3_2, label("Comparison Group 2") drop(_cons _Iyear* share* black1544 hispanic1544 ///
whnohisp1544 unemprate) ciopts(color(none)) msymbol(D) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(shortdash)), ///
order(TN10 TN11 TN12 TN13 TN14 TN15 TN16 TN17) vertical omitted baselevels ///
xtitle(Years Since MWP Law Passed) ///
yscale(r(-.2 .8)) ylabel(-.2(.2).8) yline(0, lcolor(black) lpattern(shortdash_dot))
graph export "$outputdir/eventst_BothControls_ln2ntrimabrate_Refined3.png", replace

***Log of the abortion rate***
*All controls --> Whole TN
*Control Group 1
preserve
keep if groupdst == 1 | TNState == 1 & year<=2016
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year TNSt10 TNSt11 TNSt12 TNSt13 TNSt15 ///
TNSt16 TNSt14 share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)
estimates store lnab_3_1
restore

*Control Group 2
preserve
keep if group3st == 1 | TNState == 1 
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year TNSt10 TNSt11 TNSt12 TNSt13 TNSt15 ///
TNSt16 TNSt17 TNSt14 share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)
estimates store lnab_3_2
restore

coefplot(lnab_3_1, label("Comparison group 1") drop(_cons _Iyear* share* black1544 hispanic1544 ///
whnohisp1544 unemprate) ciopts(color(none)) msymbol(O) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(dash)) ///
(lnab_3_2, label("Comparison Group 2") drop(_cons _Iyear* share* black1544 hispanic1544 whnohisp1544 unemprate) ciopts(color(none)) msymbol(D) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(shortdash)), ///
order(TNSt10 TNSt11 TNSt12 TNSt13 TNSt14 TNSt15 TNSt16 TNSt17) vertical omitted baselevels ///
xtitle(Years Since MWP Law Passed) ///
yscale(r(-.2 .4)) ylabel(-.2(.2).4) yline(0, lcolor(black) lpattern(shortdash_dot))
graph export "$outputdir/eventst_BothControls_lnabrate_3.png", replace


*All controls --> Refined TN
*Control Group 1
preserve
keep if groupd == 1 | TN == 1 & year<=2016
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year TN10 TN11 TN12 TN13 TN15 ///
TN16 TN14 share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)
estimates store lnab_3_1
restore

*Control Group 2
preserve
keep if group3 == 1 | TN == 1 
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year TN10 TN11 TN12 TN13 TN15 ///
TN16 TN17 TN14 share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)
estimates store lnab_3_2
restore

coefplot(lnab_3_1, label("Comparison group 1") drop(_cons _Iyear* share* black1544 hispanic1544 ///
whnohisp1544 unemprate) ciopts(color(none)) msymbol(O) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(dash)) ///
(lnab_3_2, label("Comparison Group 2") drop(_cons _Iyear* share* black1544 hispanic1544 whnohisp1544 unemprate) ciopts(color(none)) msymbol(D) mcolor(black) msize(med) connect(l) lcolor(black) lpattern(shortdash)), ///
order(TN10 TN11 TN12 TN13 TN14 TN15 TN16 TN17) vertical omitted baselevels ///
xtitle(Years Since MWP Law Passed) ///
yscale(r(-.2 .4)) ylabel(-.2(.2).4) yline(0, lcolor(black) lpattern(shortdash_dot))
graph export "$outputdir/eventst_BothControls_lnabrate_Refined3.png", replace

*************************
*****Exact inference*****
*************************

******************************
**********Revised TN**********
******************************

*****Comparison Group 1*****
preamble
keep if (groupd == 1 | TN == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{


forvalues i=10(1)16{
	gen t`i' = 0
	replace t`i' = 1 if (state_fips == `l' & year == 20`i')
}


***Share of abortions after 12 weeks of gestation***
xi: xtreg frac_ab_gr12_rep i.year t10 t11 t12 t13 t15 t16 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen abgr12_`l'_t10_3 = _b[t10]
gen abgr12_`l'_t11_3 = _b[t11]
gen abgr12_`l'_t12_3 = _b[t12]
gen abgr12_`l'_t13_3 = _b[t13]
gen abgr12_`l'_t14_3 = _b[t14]
gen abgr12_`l'_t15_3 = _b[t15]
gen abgr12_`l'_t16_3 = _b[t16]

***Log of the abortion rate after 12 weeks of gestation***

*c)
xi: xtreg lnab_gr12_1544per1k_rep i.year t10 t11 t12 t13 t15 t16 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen abrategr12_`l'_t10_3 = _b[t10]
gen abrategr12_`l'_t11_3 = _b[t11]
gen abrategr12_`l'_t12_3 = _b[t12]
gen abrategr12_`l'_t13_3 = _b[t13]
gen abrategr12_`l'_t14_3 = _b[t14]
gen abrategr12_`l'_t15_3 = _b[t15]
gen abrategr12_`l'_t16_3 = _b[t16]

***Log of the abortion rate***
*c)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year t10 t11 t12 t13 t15 t16 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen abrate_`l'_t10_3 = _b[t10]
gen abrate_`l'_t11_3 = _b[t11]
gen abrate_`l'_t12_3 = _b[t12]
gen abrate_`l'_t13_3 = _b[t13]
gen abrate_`l'_t14_3 = _b[t14]
gen abrate_`l'_t15_3 = _b[t15]
gen abrate_`l'_t16_3 = _b[t16]

drop t10 t11 t12 t13 t14 t15 t16
}

*Simulated treatment effects for each equation
forvalues i=3(1)3{
	forvalues j=10(1)16{
		gen abgr12_t`j'_`i' = 0
		gen abrategr12_t`j'_`i' = 0
		gen abrate_t`j'_`i' = 0
	}
}

levelsof state_fips, local(loop)
foreach l of local loop{
	forvalues i=3(1)3{
		forvalues j=10(1)16{

		*Percent of abortions after 12 weeks of gestation
		replace abgr12_t`j'_`i' = abgr12_`l'_t`j'_`i' if state_fips == `l'

		*Log of the abortion rate after 12 weeks of gestation
		replace abrategr12_t`j'_`i' = abrategr12_`l'_t`j'_`i' if state_fips == `l'

		*Log of the abortion rate
		replace abrate_t`j'_`i' = abrate_`l'_t`j'_`i' if state_fips == `l'
		}
	}
}

collapse (mean) abgr12_t10_3  abgr12_t11_3 abgr12_t12_3 abgr12_t13_3 abgr12_t14_3 ///
abgr12_t15_3 abgr12_t16_3 abrategr12_t10_3 abrategr12_t11_3  abrategr12_t12_3 ///
abrategr12_t13_3 abrategr12_t14_3 abrategr12_t15_3   abrategr12_t16_3 ///
abrate_t10_3  abrate_t11_3 abrate_t12_3 abrate_t13_3 abrate_t14_3 abrate_t15_3 ///
abrate_t16_3, by(state_fips)


*****Comparison Group 2*****

preamble
keep if (group3 == 1 | TN == 1) 

levelsof state_fips, local(loop)
foreach l of local loop{


forvalues i=10(1)17{
	gen t`i' = 0
	replace t`i' = 1 if (state_fips == `l' & year == 20`i')
}


***Share of abortions after 12 weeks of gestation***
xi: xtreg frac_ab_gr12_rep i.year t10 t11 t12 t13 t15 t16 t17 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen abgr12_`l'_t10_3 = _b[t10]
gen abgr12_`l'_t11_3 = _b[t11]
gen abgr12_`l'_t12_3 = _b[t12]
gen abgr12_`l'_t13_3 = _b[t13]
gen abgr12_`l'_t14_3 = _b[t14]
gen abgr12_`l'_t15_3 = _b[t15]
gen abgr12_`l'_t16_3 = _b[t16]
gen abgr12_`l'_t17_3 = _b[t17]

***Log of the abortion rate after 12 weeks of gestation***
xi: xtreg lnab_gr12_1544per1k_rep i.year t10 t11 t12 t13 t15 t16 t17 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen abrategr12_`l'_t10_3 = _b[t10]
gen abrategr12_`l'_t11_3 = _b[t11]
gen abrategr12_`l'_t12_3 = _b[t12]
gen abrategr12_`l'_t13_3 = _b[t13]
gen abrategr12_`l'_t14_3 = _b[t14]
gen abrategr12_`l'_t15_3 = _b[t15]
gen abrategr12_`l'_t16_3 = _b[t16]
gen abrategr12_`l'_t17_3 = _b[t17]

***Log of the abortion rate***
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year t10 t11 t12 t13 t15 t16 t17 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen abrate_`l'_t10_3 = _b[t10]
gen abrate_`l'_t11_3 = _b[t11]
gen abrate_`l'_t12_3 = _b[t12]
gen abrate_`l'_t13_3 = _b[t13]
gen abrate_`l'_t14_3 = _b[t14]
gen abrate_`l'_t15_3 = _b[t15]
gen abrate_`l'_t16_3 = _b[t16]
gen abrate_`l'_t17_3 = _b[t17]

drop t10 t11 t12 t13 t14 t15 t16 t17
}

*Simulated treatment effects for each equation
forvalues i=3(1)3{
	forvalues j=10(1)17{
		gen abgr12_t`j'_`i' = 0
		gen abrategr12_t`j'_`i' = 0
		gen abrate_t`j'_`i' = 0
	}
}

levelsof state_fips, local(loop)
foreach l of local loop{
	forvalues i=3(1)3{
		forvalues j=10(1)17{

		*Percent of abortions after 12 weeks of gestation
		replace abgr12_t`j'_`i' = abgr12_`l'_t`j'_`i' if state_fips == `l'

		*Log of the abortion rate after 12 weeks of gestation
		replace abrategr12_t`j'_`i' = abrategr12_`l'_t`j'_`i' if state_fips == `l'

		*Log of the abortion rate
		replace abrate_t`j'_`i' = abrate_`l'_t`j'_`i' if state_fips == `l'
		}
	}
}

collapse (mean) abgr12_t10_3  abgr12_t11_3 abgr12_t12_3 abgr12_t13_3 ///
abgr12_t14_3 abgr12_t15_3 abgr12_t16_3 abgr12_t17_3 abrategr12_t10_3 ///
abrategr12_t11_3  abrategr12_t12_3 abrategr12_t13_3 abrategr12_t14_3 ///
abrategr12_t15_3 abrategr12_t16_3 abrategr12_t17_3 abrate_t10_3  ///
abrate_t11_3 abrate_t12_3 abrate_t13_3 abrate_t14_3 abrate_t15_3 ///
abrate_t16_3 abrate_t17_3, by(state_fips)

****************************
**********Whole TN**********
****************************

*****Comparison Group 1*****
preamble
keep if (groupdst == 1 | TNState == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{


forvalues i=10(1)16{
	gen t`i' = 0
	replace t`i' = 1 if (state_fips == `l' & year == 20`i')
}


***Share of abortions after 12 weeks of gestation***
xi: xtreg frac_ab_gr12_rep i.year t10 t11 t12 t13 t15 t16 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen abgr12_`l'_t10_3 = _b[t10]
gen abgr12_`l'_t11_3 = _b[t11]
gen abgr12_`l'_t12_3 = _b[t12]
gen abgr12_`l'_t13_3 = _b[t13]
gen abgr12_`l'_t14_3 = _b[t14]
gen abgr12_`l'_t15_3 = _b[t15]
gen abgr12_`l'_t16_3 = _b[t16]

***Log of the abortion rate after 12 weeks of gestation***

*c)
xi: xtreg lnab_gr12_1544per1k_rep i.year t10 t11 t12 t13 t15 t16 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen abrategr12_`l'_t10_3 = _b[t10]
gen abrategr12_`l'_t11_3 = _b[t11]
gen abrategr12_`l'_t12_3 = _b[t12]
gen abrategr12_`l'_t13_3 = _b[t13]
gen abrategr12_`l'_t14_3 = _b[t14]
gen abrategr12_`l'_t15_3 = _b[t15]
gen abrategr12_`l'_t16_3 = _b[t16]

***Log of the abortion rate***
*c)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year t10 t11 t12 t13 t15 t16 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen abrate_`l'_t10_3 = _b[t10]
gen abrate_`l'_t11_3 = _b[t11]
gen abrate_`l'_t12_3 = _b[t12]
gen abrate_`l'_t13_3 = _b[t13]
gen abrate_`l'_t14_3 = _b[t14]
gen abrate_`l'_t15_3 = _b[t15]
gen abrate_`l'_t16_3 = _b[t16]

drop t10 t11 t12 t13 t14 t15 t16
}

*Simulated treatment effects for each equation
forvalues i=3(1)3{
	forvalues j=10(1)16{
		gen abgr12_t`j'_`i' = 0
		gen abrategr12_t`j'_`i' = 0
		gen abrate_t`j'_`i' = 0
	}
}

levelsof state_fips, local(loop)
foreach l of local loop{
	forvalues i=3(1)3{
		forvalues j=10(1)16{

		*Percent of abortions after 12 weeks of gestation
		replace abgr12_t`j'_`i' = abgr12_`l'_t`j'_`i' if state_fips == `l'

		*Log of the abortion rate after 12 weeks of gestation
		replace abrategr12_t`j'_`i' = abrategr12_`l'_t`j'_`i' if state_fips == `l'

		*Log of the abortion rate
		replace abrate_t`j'_`i' = abrate_`l'_t`j'_`i' if state_fips == `l'
		}
	}
}

collapse (mean) abgr12_t10_3  abgr12_t11_3 abgr12_t12_3 abgr12_t13_3 abgr12_t14_3 ///
abgr12_t15_3 abgr12_t16_3 abrategr12_t10_3 abrategr12_t11_3  abrategr12_t12_3 ///
abrategr12_t13_3 abrategr12_t14_3 abrategr12_t15_3   abrategr12_t16_3 ///
abrate_t10_3  abrate_t11_3 abrate_t12_3 abrate_t13_3 abrate_t14_3 abrate_t15_3 ///
abrate_t16_3, by(state_fips)

*Sort state_fips from largest to smallest because whole TN label is 99 --> I need 
*TN to be first one for the Excel file that calculates the p-values to work
gsort -state_fips


*****Comparison Group 2*****

preamble
keep if (group3st == 1 | TNState == 1) 

levelsof state_fips, local(loop)
foreach l of local loop{


forvalues i=10(1)17{
	gen t`i' = 0
	replace t`i' = 1 if (state_fips == `l' & year == 20`i')
}


***Share of abortions after 12 weeks of gestation***
xi: xtreg frac_ab_gr12_rep i.year t10 t11 t12 t13 t15 t16 t17 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen abgr12_`l'_t10_3 = _b[t10]
gen abgr12_`l'_t11_3 = _b[t11]
gen abgr12_`l'_t12_3 = _b[t12]
gen abgr12_`l'_t13_3 = _b[t13]
gen abgr12_`l'_t14_3 = _b[t14]
gen abgr12_`l'_t15_3 = _b[t15]
gen abgr12_`l'_t16_3 = _b[t16]
gen abgr12_`l'_t17_3 = _b[t17]

***Log of the abortion rate after 12 weeks of gestation***
xi: xtreg lnab_gr12_1544per1k_rep i.year t10 t11 t12 t13 t15 t16 t17 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen abrategr12_`l'_t10_3 = _b[t10]
gen abrategr12_`l'_t11_3 = _b[t11]
gen abrategr12_`l'_t12_3 = _b[t12]
gen abrategr12_`l'_t13_3 = _b[t13]
gen abrategr12_`l'_t14_3 = _b[t14]
gen abrategr12_`l'_t15_3 = _b[t15]
gen abrategr12_`l'_t16_3 = _b[t16]
gen abrategr12_`l'_t17_3 = _b[t17]

***Log of the abortion rate***
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year t10 t11 t12 t13 t15 t16 t17 t14 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen abrate_`l'_t10_3 = _b[t10]
gen abrate_`l'_t11_3 = _b[t11]
gen abrate_`l'_t12_3 = _b[t12]
gen abrate_`l'_t13_3 = _b[t13]
gen abrate_`l'_t14_3 = _b[t14]
gen abrate_`l'_t15_3 = _b[t15]
gen abrate_`l'_t16_3 = _b[t16]
gen abrate_`l'_t17_3 = _b[t17]

drop t10 t11 t12 t13 t14 t15 t16 t17
}

*Simulated treatment effects for each equation
forvalues i=3(1)3{
	forvalues j=10(1)17{
		gen abgr12_t`j'_`i' = 0
		gen abrategr12_t`j'_`i' = 0
		gen abrate_t`j'_`i' = 0
	}
}

levelsof state_fips, local(loop)
foreach l of local loop{
	forvalues i=3(1)3{
		forvalues j=10(1)17{

		*Percent of abortions after 12 weeks of gestation
		replace abgr12_t`j'_`i' = abgr12_`l'_t`j'_`i' if state_fips == `l'

		*Log of the abortion rate after 12 weeks of gestation
		replace abrategr12_t`j'_`i' = abrategr12_`l'_t`j'_`i' if state_fips == `l'

		*Log of the abortion rate
		replace abrate_t`j'_`i' = abrate_`l'_t`j'_`i' if state_fips == `l'
		}
	}
}

collapse (mean) abgr12_t10_3  abgr12_t11_3 abgr12_t12_3 abgr12_t13_3 ///
abgr12_t14_3 abgr12_t15_3 abgr12_t16_3 abgr12_t17_3 abrategr12_t10_3 ///
abrategr12_t11_3  abrategr12_t12_3 abrategr12_t13_3 abrategr12_t14_3 ///
abrategr12_t15_3 abrategr12_t16_3 abrategr12_t17_3 abrate_t10_3  ///
abrate_t11_3 abrate_t12_3 abrate_t13_3 abrate_t14_3 abrate_t15_3 ///
abrate_t16_3 abrate_t17_3, by(state_fips)

*Sort state_fips from largest to smallest because whole TN label is 99 --> I need 
*TN to be first one for the Excel file that calculates the p-values to work
gsort -state_fips


********************************************************************************
********************************************************************************
********************************************************************************
***************TABLE 2 AND FIGURE 6: SHARE OF TREATED MONTHS BY THE LAW*********
********************************************************************************
********************************************************************************
********************************************************************************

preamble

eststo clear

************************
************************
***Comparison group 1***
************************
************************

***1) Percent of abortions after 12 weeks of gestation***

preserve

keep if (groupdst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
[pweight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [pweight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (groupd == 1 | TN == 1) & year<2017

eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [pweight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*2) Abortion rate after 12 weeks of gestation

preserve

keep if (groupdst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
[pweight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (groupd == 1 | TN == 1) & year<2017

eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore


*3) Abortion rate

preserve

keep if (groupdst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[pweight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (groupd == 1 | TN == 1) & year<2017
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore


*Output file
esttab using "$outputdir\042021_JHERevision_Table2A.tex", ///
keep (ShareTreated) ///
longtable title("Estimated Effects of Tennessee's Mandatory Waiting Period") ///
nodepvars replace nostar b(3) p(2) label nonumbers 

*************************
*****Exact inference*****
*************************

*****Whole TN*****
preamble

keep if (groupdst == 1 | TNState == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

*a)
xi: xtreg frac_ab_gr12_rep i.year Share ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_1 = _b[Share]

*b) 
xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_2 = _b[Share]

***Log of the abortion rate after 12 weeks of gestation***

*a)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_2 = _b[Share]

***Log of the abortion rate***

*a)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_2 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
forvalues i=1(1)2{
gen share_abgr12_`i' = 0
gen share_lnab_gr12_`i' = 0
gen share_lnab_all_`i' = 0

}

levelsof state_fips, local(loop)
foreach l of local loop{
forvalues i=1(1)2{

*Percent of abortions after 12 weeks of gestation
replace share_abgr12_`i' = share_abgr12_`l'_`i' if state_fips == `l'

*Log of the abortion rate after 12 weeks of gestation
replace share_lnab_gr12_`i' =  share_lnab_gr12_`l'_`i' if state_fips == `l'

*Log of the abortion rate
replace share_lnab_all_`i' = share_lnab_all_`l'_`i' if state_fips == `l'

}
}

collapse (mean) share_abgr12_1 share_abgr12_2 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_all_1 share_lnab_all_2, by(state_fips)

tempfile whole
save `whole'

*****Refined TN*****
preamble

keep if (groupd == 1 | TN == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_3 = _b[Share]

***Log of the abortion rate after 12 weeks of gestation***

xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_3 = _b[Share]

***Log of the abortion rate***
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_3 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
gen share_abgr12_3 = 0
gen share_lnab_gr12_3 = 0
gen share_lnab_all_3 = 0

levelsof state_fips, local(loop)
foreach l of local loop{
	*Percent of abortions after 12 weeks of gestation
	replace share_abgr12_3 = share_abgr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace share_lnab_gr12_3 =  share_lnab_gr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate
	replace share_lnab_all_3 = share_lnab_all_`l'_3 if state_fips == `l'
}

collapse (mean) share_abgr12_3 share_lnab_gr12_3 share_lnab_all_3, by(state_fips)

tempfile refined
save `refined'

*Merge the two temporal datasets
use `whole'
merge 1:1 state_fips using `refined'

replace state_fips = 0 if state_fips == 99

collapse(sum) share*, by(state_fips)

order state_fips share_abgr12_1 share_abgr12_2 share_abgr12_3 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_gr12_3 share_lnab_all_1 share_lnab_all_2 share_lnab_all_3


*************************************
*****Graphs for refined analysis*****
*************************************
gl vars abgr12 lnab_gr12 lnab_all
foreach m in $vars{
	gen true`m'_3 = share_`m'_3 if state_fips == 0 
	egen meantrue`m'_3 = mean(true`m'_3)
	drop true`m'_3
	rename meantrue`m'_3 true`m'_3
}

***Second-trimester abortions***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 


gl vars abgr12
foreach m in $vars{
	scalar true`m'_3 = true`m'_3
	histogram share_`m'_3, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_3)', lpattern(dash) lwidth(thin)) ///
	xtitle("") title("") ytitle("") xscale(r(-5 7)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-8(2)8)
	graph export "$outputdir/Kernel_share_`m'_group1.png", replace 
}

***Second-trimester abortion rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl vars lnab_gr12
foreach m in $vars{
	scalar true`m'_3 = true`m'_3
	histogram share_`m'_3, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_3)', lpattern(dash) lwidth(thin)) ///
	xtitle("") title("") ytitle("") xscale(r(-1 1)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-1(.5)1)
	graph export "$outputdir/Kernel_share_`m'_group1.png", replace 
}

***Abortion Rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl vars lnab_all
foreach m in $vars{
	scalar true`m'_3 = true`m'_3
	histogram share_`m'_3, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_3)', lpattern(dash) lwidth(thin)) ///
	xtitle("") title("") ytitle("") xscale(r(-1 1)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-1(.5)1)
	graph export "$outputdir/Kernel_share_`m'_group1.png", replace 
}


************************
************************
***Comparison group 2***
************************
************************

preamble

eststo clear

*1) Percent of abortions after 12 weeks of gestation

preserve

keep if (group3st == 1 | TNState == 1) 

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (group3 == 1 | TN == 1) 

eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*2) Abortion rate after 12 weeks of gestation

preserve

keep if (group3st == 1 | TNState == 1) 

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (group3 == 1 | TN == 1) 

eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*3) Abortion rate

preserve

keep if (group3st == 1 | TNState == 1) 

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (group3 == 1 | TN == 1) 

eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*Output file
esttab using "$outputdir\042021_JHERevision_Table2B.tex", ///
keep (ShareTreated) ///
longtable title("Estimated Effects of Tennessee's Mandatory Waiting Period") ///
nodepvars replace nostar b(3) p(2) label nonumbers 

*************************
*****Exact inference*****
*************************

*****Whole TN*****
preamble

keep if TNState == 1 | group3st == 1

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

*a)
xi: xtreg frac_ab_gr12_rep i.year Share ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_1 = _b[Share]

*b) 
xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_2 = _b[Share]

***Log of the abortion rate after 12 weeks of gestation***

*a)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_2 = _b[Share]

***Log of the abortion rate***

*a)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_2 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
forvalues i=1(1)2{
gen share_abgr12_`i' = 0
gen share_lnab_gr12_`i' = 0
gen share_lnab_all_`i' = 0

}

levelsof state_fips, local(loop)
foreach l of local loop{
forvalues i=1(1)2{

*Percent of abortions after 12 weeks of gestation
replace share_abgr12_`i' = share_abgr12_`l'_`i' if state_fips == `l'

*Log of the abortion rate after 12 weeks of gestation
replace share_lnab_gr12_`i' =  share_lnab_gr12_`l'_`i' if state_fips == `l'

*Log of the abortion rate
replace share_lnab_all_`i' = share_lnab_all_`l'_`i' if state_fips == `l'

}
}

collapse (mean) share_abgr12_1 share_abgr12_2 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_all_1 share_lnab_all_2, by(state_fips)

tempfile whole
save `whole'

*****Refined TN*****
preamble

keep if TN == 1 | group3 == 1

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_3 = _b[Share]

***Log of the abortion rate after 12 weeks of gestation***

xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_3 = _b[Share]

***Log of the abortion rate***
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_3 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
gen share_abgr12_3 = 0
gen share_lnab_gr12_3 = 0
gen share_lnab_all_3 = 0

levelsof state_fips, local(loop)
foreach l of local loop{
	*Percent of abortions after 12 weeks of gestation
	replace share_abgr12_3 = share_abgr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace share_lnab_gr12_3 =  share_lnab_gr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate
	replace share_lnab_all_3 = share_lnab_all_`l'_3 if state_fips == `l'
}

collapse (mean) share_abgr12_3 share_lnab_gr12_3 share_lnab_all_3, by(state_fips)

tempfile refined
save `refined'

*Merge the two temporal datasets
use `whole'
merge 1:1 state_fips using `refined'

replace state_fips = 0 if state_fips == 99

collapse(sum) share*, by(state_fips)

order state_fips share_abgr12_1 share_abgr12_2 share_abgr12_3 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_gr12_3 share_lnab_all_1 share_lnab_all_2 share_lnab_all_3


*************************************
*****Graphs for refined analysis*****
*************************************
gl vars abgr12 lnab_gr12 lnab_all
foreach m in $vars{
	gen true`m'_3 = share_`m'_3 if state_fips == 0 
	egen meantrue`m'_3 = mean(true`m'_3)
	drop true`m'_3
	rename meantrue`m'_3 true`m'_3
}


***Second-trimester abortions***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 


gl vars abgr12
foreach m in $vars{
	scalar true`m'_3 = true`m'_3
	histogram share_`m'_3, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_3)', lpattern(dash) lwidth(thin)) ///
	xtitle("") title("") ytitle("") xscale(r(-5 7)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-8(2)8)
	graph export "$outputdir/Kernel_share_`m'_group2.png", replace 
}

***Second-trimester abortion rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl vars lnab_gr12
foreach m in $vars{
	scalar true`m'_3 = true`m'_3
	histogram share_`m'_3, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_3)', lpattern(dash) lwidth(thin)) ///
	xtitle("") title("") ytitle("") xscale(r(-1 1)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-1(.5)1)
	graph export "$outputdir/Kernel_share_`m'_group2.png", replace 
}

***Abortion Rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl vars lnab_all
foreach m in $vars{
	scalar true`m'_3 = true`m'_3
	histogram share_`m'_3, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_3)', lpattern(dash) lwidth(thin)) ///
	xtitle("") title("") ytitle("") xscale(r(-1 1)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-1(.5)1)
	graph export "$outputdir/Kernel_share_`m'_group2.png", replace 
}

********************************************************************************
********************************************************************************
******************TABLE 3 AND FIGURE 7: SEPARATING 2015, 2015, 2017*************
********************************************************************************
********************************************************************************

************************
***Comparison group 1***
************************

preamble

*1) Percent of abortions after 12 weeks of gestation

eststo clear

preserve

keep if ((TNState == 1 | groupdst == 1) & year < 2017)

drop TN15 TN16
rename TNSt15 TN15
rename TNSt16 TN16

tab state groupdst

*a)
eststo: xi: xtreg frac_ab_gr12_rep i.year TN15 TN16 ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

*b)
eststo: xi: xtreg frac_ab_gr12_rep i.year TN15 TN16 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*c) 
preserve

keep if ((TN == 1 | groupd == 1) & year < 2017)

eststo: xi: xtreg frac_ab_gr12_rep i.year TN15 TN16 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*2) *Log of the abortion rate after 12 weeks of gestation

preserve

keep if ((TNState == 1 | groupdst == 1) & year < 2017)

drop TN15 TN16
rename TNSt15 TN15
rename TNSt16 TN16

tab state groupdst

*a)
eststo: xi: xtreg lnab_gr12_1544per1k i.year TN15 TN16 ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) 
eststo: xi: xtreg lnab_gr12_1544per1k i.year TN15 TN16 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) 
preserve

keep if ((TN == 1 | groupd == 1) & year < 2017)

eststo: xi: xtreg lnab_gr12_1544per1k i.year TN15 TN16 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*3) Log of abortion rate

preserve

keep if ((TNState == 1 | groupdst == 1) & year < 2017)

drop TN15 TN16
rename TNSt15 TN15
rename TNSt16 TN16

tab state groupdst

*a)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year TN15 TN16 ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year TN15 TN16 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c)
preserve

keep if ((TN == 1 | groupd == 1) & year < 2017)

eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year TN15 TN16 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*Output file
esttab using "$outputdir\042021_JHERevision_Table3A.tex", ///
keep (TN15 TN16) ///
longtable title("Estimated Effects of Tennessee's Mandatory Waiting Period") ///
nodepvars replace nostar b(3) p(2) label nonumbers 


***************************************************
*****Exact inference --> To calculate p-values*****
***************************************************

*RI for equations a) and b) above
preamble 

keep if ((groupdst == 1 | TNState == 1) & year<2017)

levelsof state_fips, local(loop)
foreach l of local loop{

	gen treat = 0
	replace treat = 1 if state_fips == `l'

	gen treat15 = 0
	replace treat15 = 1 if treat == 1 & year == 2015

	gen treat16 = 0
	replace treat16 = 1 if treat == 1 & year == 2016

	***Share of abortions after 12 weeks of gestation***

	*a)
	xi: xtreg frac_ab_gr12_rep i.year treat15 treat16 ///
	[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

	gen t15_abgr12_`l'_1 = _b[treat15]
	gen t16_abgr12_`l'_1 = _b[treat16]

	*b) 
	xi: xtreg frac_ab_gr12_rep i.year treat15 treat16 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
	whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

	gen t15_abgr12_`l'_2 = _b[treat15]
	gen t16_abgr12_`l'_2 = _b[treat16]

	***Log of the abortion rate after 12 weeks of gestation***

	*a)
	xi: xtreg lnab_gr12_1544per1k_rep i.year treat15 treat16 ///
	[weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrategr12_`l'_1 = _b[treat15]
	gen t16_abrategr12_`l'_1 = _b[treat16]

	*b)
	xi: xtreg lnab_gr12_1544per1k_rep i.year treat15 treat16 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
	hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrategr12_`l'_2 = _b[treat15]
	gen t16_abrategr12_`l'_2 = _b[treat16]

	***Log of the abortion rate***

	*a)
	xi: xtreg lnab_all_nomissga_1544per1k_rep i.year treat15 treat16 ///
	[weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrate_`l'_1 = _b[treat15]
	gen t16_abrate_`l'_1 = _b[treat16]

	*b)
	xi: xtreg lnab_all_nomissga_1544per1k_rep i.year treat15 treat16 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
	hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrate_`l'_2 = _b[treat15]
	gen t16_abrate_`l'_2 = _b[treat16]

	drop treat treat15 treat16
}

*Simulated treatment effects for each equation
forvalues i=1(1)2{
	gen t15_abgr12_`i' = 0
	gen t16_abgr12_`i' = 0

	gen t15_abrategr12_`i' = 0
	gen t16_abrategr12_`i' = 0

	gen t15_abrate_`i' = 0
	gen t16_abrate_`i' = 0
}

levelsof state_fips, local(loop)
foreach l of local loop{
	forvalues i=1(1)2{

	*Percent of abortions after 12 weeks of gestation
		replace t15_abgr12_`i' = t15_abgr12_`l'_`i' if state_fips == `l'
		replace t16_abgr12_`i' = t16_abgr12_`l'_`i' if state_fips == `l'

		*Log of the abortion rate after 12 weeks of gestation
		replace t15_abrategr12_`i' = t15_abrategr12_`l'_`i' if state_fips == `l'
		replace t16_abrategr12_`i' = t16_abrategr12_`l'_`i' if state_fips == `l'

		*Log of the abortion rate
		replace t15_abrate_`i' = t15_abrate_`l'_`i' if state_fips == `l'
		replace t16_abrate_`i' = t16_abrate_`l'_`i' if state_fips == `l'

	}
}

collapse (mean) t15_abgr12_1 t15_abgr12_2 t16_abgr12_1 t16_abgr12_2 ///
t15_abrategr12_1 t15_abrategr12_2 t16_abrategr12_1 t16_abrategr12_2 ///
t15_abrate_1 t15_abrate_2  t16_abrate_1 t16_abrate_2 , by(state_fips)

tempfile whole
save `whole'

*RI for equations c) above
preamble 

keep if ((groupd == 1 | TN == 1) & year<2017)

levelsof state_fips, local(loop)
foreach l of local loop{

	gen treat = 0
	replace treat = 1 if state_fips == `l'

	gen treat15 = 0
	replace treat15 = 1 if treat == 1 & year == 2015

	gen treat16 = 0
	replace treat16 = 1 if treat == 1 & year == 2016

	***Share of abortions after 12 weeks of gestation***

	*c)
	xi: xtreg frac_ab_gr12_rep i.year treat15 treat16 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
	whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

	gen t15_abgr12_`l'_3 = _b[treat15]
	gen t16_abgr12_`l'_3 = _b[treat16]

	***Log of the abortion rate after 12 weeks of gestation***

	*c)
	xi: xtreg lnab_gr12_1544per1k_rep i.year treat15 treat16 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
	hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrategr12_`l'_3 = _b[treat15]
	gen t16_abrategr12_`l'_3 = _b[treat16]

	***Log of the abortion rate***

	*c)
	xi: xtreg lnab_all_nomissga_1544per1k_rep i.year treat15 treat16 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
	hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrate_`l'_3 = _b[treat15]
	gen t16_abrate_`l'_3 = _b[treat16]

	drop treat treat15 treat16
}

*Simulated treatment effects for each equation
gen t15_abgr12_3 = 0
gen t16_abgr12_3 = 0

gen t15_abrategr12_3 = 0
gen t16_abrategr12_3 = 0

gen t15_abrate_3 = 0
gen t16_abrate_3 = 0

levelsof state_fips, local(loop)
foreach l of local loop{

	*Percent of abortions after 12 weeks of gestation
	replace t15_abgr12_3 = t15_abgr12_`l'_3 if state_fips == `l'
	replace t16_abgr12_3 = t16_abgr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace t15_abrategr12_3 = t15_abrategr12_`l'_3 if state_fips == `l'
	replace t16_abrategr12_3 = t16_abrategr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate
	replace t15_abrate_3 = t15_abrate_`l'_3 if state_fips == `l'
	replace t16_abrate_3 = t16_abrate_`l'_3 if state_fips == `l'

}


collapse (mean) t15_abgr12_3 t16_abgr12_3 t15_abrategr12_3 t16_abrategr12_3 ///
t15_abrate_3 t16_abrate_3 , by(state_fips)

tempfile refined
save `refined'

*Merge the two temporal datasets
use `whole'
merge 1:1 state_fips using `refined'

replace state_fips = 0 if state_fips == 99

collapse(sum) t15* t16*, by(state_fips)

order state_fips t15_abgr12_1 t15_abgr12_2 t15_abgr12_3 t15_abrategr12_1 ///
t15_abrategr12_2 t15_abrategr12_3 t15_abrate_1 t15_abrate_2 t15_abrate_3 ///
t16_abgr12_1 t16_abgr12_2 t16_abgr12_3 t16_abrategr12_1 t16_abrategr12_2 ///
t16_abrategr12_3 t16_abrate_1 t16_abrate_2 t16_abrate_3


*************************************
*****Graphs for refined analysis*****
*************************************

gl te 16
gl vars abgr12 abrategr12 abrate
forvalues i=3(1)3{
	foreach m in $vars{
		foreach n in $te{
			gen true`m'_`n'_`i' = t`n'_`m'_`i' if state_fips == 0 
			egen meantrue`m'_`n'_`i' = mean(true`m'_`n'_`i')
			drop true`m'_`n'_`i'
			rename meantrue`m'_`n'_`i' true`m'_`n'_`i'
		}
	}
}

***Second-trimester abortions***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl te 16
gl vars abgr12
forvalues i=3(1)3{
	foreach m in $vars{
		foreach n in $te{
			scalar true`m'_`n'_`i' = true`m'_`n'_`i'

			histogram t`n'_`m'_`i', fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`n'_`i')', lpattern(dash) lwidth(thin)) ///
			xtitle("") title("") ytitle("") xscale(r(-5 6)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-6(1)6)
			graph export "$outputdir/Kernel_`m'_t`n'_group1.png", replace 
			}
		}
}

***Second-trimester abortion rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
gl te 16
gl vars abrategr12
forvalues i=3(1)3{
	foreach m in $vars{
		foreach n in $te{
			scalar true`m'_`n'_`i' = true`m'_`n'_`i'

			histogram t`n'_`m'_`i', fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`n'_`i')', lpattern(dash) lwidth(thin)) ///
			xtitle("") title("") ytitle("") xscale(r(-1.5 1.5)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-1.5(.5)1.5)
			graph export "$outputdir/Kernel_`m'_t`n'_group1.png", replace 
			}
		}
}

***Abortion Rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
gl te 16
gl vars abrate
forvalues i=3(1)3{
	foreach m in $vars{
		foreach n in $te{
			scalar true`m'_`n'_`i' = true`m'_`n'_`i'

			histogram t`n'_`m'_`i', fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`n'_`i')', lpattern(dash) lwidth(thin)) ///
			xtitle("") title("") ytitle("") xscale(r(-.5 .5)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-.5(.25).5)
			graph export "$outputdir/Kernel_`m'_t`n'_group1.png", replace 
			}
		}
}

********************************************************************************
************************
***Comparison group 2***
************************

preamble

*1) Percent of abortions after 12 weeks of gestation

eststo clear

preserve 

keep if (TNState == 1 | group3st == 1)

tab state group3st 

drop TN15 TN16 TN17
rename TNSt15 TN15
rename TNSt16 TN16
rename TNSt17 TN17

*a)
eststo: xi: xtreg frac_ab_gr12_rep i.year TN15 TN16 TN17 ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

*b)
eststo: xi: xtreg frac_ab_gr12_rep i.year TN15 TN16 TN17 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*c) 
preserve

keep if (TN == 1 | group3 == 1)

eststo: xi: xtreg frac_ab_gr12_rep i.year TN15 TN16 TN17 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*2) *Log of the abortion rate after 12 weeks of gestation

preserve

keep if (TNState == 1 | group3st == 1)

drop TN15 TN16 TN17
rename TNSt15 TN15
rename TNSt16 TN16
rename TNSt17 TN17

tab state groupdst

*a)
eststo: xi: xtreg lnab_gr12_1544per1k i.year TN15 TN16 TN17 ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) 
eststo: xi: xtreg lnab_gr12_1544per1k i.year TN15 TN16 TN17 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) 
preserve

keep if (TN == 1 | group3 == 1)

eststo: xi: xtreg lnab_gr12_1544per1k i.year TN15 TN16 TN17 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*3) Log of abortion rate

preserve

keep if (TNState == 1 | group3st == 1)

drop TN15 TN16 TN17
rename TNSt15 TN15
rename TNSt16 TN16
rename TNSt17 TN17

tab state groupdst

*a)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year TN15 TN16 TN17 ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year TN15 TN16 TN17 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c)
preserve

keep if (TN == 1 | group3 == 1)

eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year TN15 TN16 TN17 ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*Output file
esttab using "$outputdir\042021_JHERevision_Table3B.tex", ///
keep (TN15 TN16 TN17) ///
longtable title("Estimated Effects of Tennessee's Mandatory Waiting Period") ///
nodepvars replace nostar b(3) p(2) label nonumbers 


***************************************************
*****Exact inference --> To calculate p-values*****
***************************************************

*RI for equations a) and b) above
preamble 

keep if (TNState == 1 | group3st == 1)

levelsof state_fips, local(loop)
foreach l of local loop{

	gen treat = 0
	replace treat = 1 if state_fips == `l'

	gen treat15 = 0
	replace treat15 = 1 if treat == 1 & year == 2015

	gen treat16 = 0
	replace treat16 = 1 if treat == 1 & year == 2016

	gen treat17 = 0
	replace treat17 = 1 if treat == 1 & year == 2017

	***Share of abortions after 12 weeks of gestation***

	*a)
	xi: xtreg frac_ab_gr12_rep i.year treat15 treat16 treat17 ///
	[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

	gen t15_abgr12_`l'_1 = _b[treat15]
	gen t16_abgr12_`l'_1 = _b[treat16]
	gen t17_abgr12_`l'_1 = _b[treat17]

	*b) 
	xi: xtreg frac_ab_gr12_rep i.year treat15 treat16 treat17 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
	whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

	gen t15_abgr12_`l'_2 = _b[treat15]
	gen t16_abgr12_`l'_2 = _b[treat16]
	gen t17_abgr12_`l'_2 = _b[treat17]

	***Log of the abortion rate after 12 weeks of gestation***

	*a)
	xi: xtreg lnab_gr12_1544per1k_rep i.year treat15 treat16 treat17 ///
	[weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrategr12_`l'_1 = _b[treat15]
	gen t16_abrategr12_`l'_1 = _b[treat16]
	gen t17_abrategr12_`l'_1 = _b[treat17]

	*b)
	xi: xtreg lnab_gr12_1544per1k_rep i.year treat15 treat16 treat17 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
	hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrategr12_`l'_2 = _b[treat15]
	gen t16_abrategr12_`l'_2 = _b[treat16]
	gen t17_abrategr12_`l'_2 = _b[treat17]

	***Log of the abortion rate***

	*a)
	xi: xtreg lnab_all_nomissga_1544per1k_rep i.year treat15 treat16 treat17 ///
	[weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrate_`l'_1 = _b[treat15]
	gen t16_abrate_`l'_1 = _b[treat16]
	gen t17_abrate_`l'_1 = _b[treat17]

	*b)
	xi: xtreg lnab_all_nomissga_1544per1k_rep i.year treat15 treat16 treat17 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
	hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrate_`l'_2 = _b[treat15]
	gen t16_abrate_`l'_2 = _b[treat16]
	gen t17_abrate_`l'_2 = _b[treat17]

	drop treat treat15 treat16 treat17
}

*Simulated treatment effects for each equation
forvalues i=1(1)2{
	gen t15_abgr12_`i' = 0
	gen t16_abgr12_`i' = 0
	gen t17_abgr12_`i' = 0

	gen t15_abrategr12_`i' = 0
	gen t16_abrategr12_`i' = 0
	gen t17_abrategr12_`i' = 0

	gen t15_abrate_`i' = 0
	gen t16_abrate_`i' = 0
	gen t17_abrate_`i' = 0

}

levelsof state_fips, local(loop)
foreach l of local loop{
	forvalues i=1(1)2{

	*Percent of abortions after 12 weeks of gestation
		replace t15_abgr12_`i' = t15_abgr12_`l'_`i' if state_fips == `l'
		replace t16_abgr12_`i' = t16_abgr12_`l'_`i' if state_fips == `l'
		replace t17_abgr12_`i' = t17_abgr12_`l'_`i' if state_fips == `l'

		*Log of the abortion rate after 12 weeks of gestation
		replace t15_abrategr12_`i' = t15_abrategr12_`l'_`i' if state_fips == `l'
		replace t16_abrategr12_`i' = t16_abrategr12_`l'_`i' if state_fips == `l'
		replace t17_abrategr12_`i' = t17_abrategr12_`l'_`i' if state_fips == `l'

		*Log of the abortion rate
		replace t15_abrate_`i' = t15_abrate_`l'_`i' if state_fips == `l'
		replace t16_abrate_`i' = t16_abrate_`l'_`i' if state_fips == `l'
		replace t17_abrate_`i' = t17_abrate_`l'_`i' if state_fips == `l'

	}
}

collapse (mean) t15_abgr12_1 t15_abgr12_2 t16_abgr12_1 t16_abgr12_2 t17_abgr12_1 t17_abgr12_2 ///
t15_abrategr12_1 t15_abrategr12_2 t16_abrategr12_1 t16_abrategr12_2 t17_abrategr12_1 t17_abrategr12_2 ///
t15_abrate_1 t15_abrate_2 t16_abrate_1 t16_abrate_2 t17_abrate_1 t17_abrate_2, by(state_fips)

tempfile whole
save `whole'

*RI for equations c) above
preamble 

keep if (TN == 1 | group3 == 1)

levelsof state_fips, local(loop)
foreach l of local loop{

	gen treat = 0
	replace treat = 1 if state_fips == `l'

	gen treat15 = 0
	replace treat15 = 1 if treat == 1 & year == 2015

	gen treat16 = 0
	replace treat16 = 1 if treat == 1 & year == 2016
	
	gen treat17 = 0
	replace treat17 = 1 if treat == 1 & year == 2017

	***Share of abortions after 12 weeks of gestation***

	*c)
	xi: xtreg frac_ab_gr12_rep i.year treat15 treat16 treat17 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
	whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

	gen t15_abgr12_`l'_3 = _b[treat15]
	gen t16_abgr12_`l'_3 = _b[treat16]
	gen t17_abgr12_`l'_3 = _b[treat17]

	***Log of the abortion rate after 12 weeks of gestation***

	*c)
	xi: xtreg lnab_gr12_1544per1k_rep i.year treat15 treat16 treat17 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
	hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrategr12_`l'_3 = _b[treat15]
	gen t16_abrategr12_`l'_3 = _b[treat16]
	gen t17_abrategr12_`l'_3 = _b[treat17]

	***Log of the abortion rate***

	*c)
	xi: xtreg lnab_all_nomissga_1544per1k_rep i.year treat15 treat16 treat17 ///
	share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
	hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

	gen t15_abrate_`l'_3 = _b[treat15]
	gen t16_abrate_`l'_3 = _b[treat16]
	gen t17_abrate_`l'_3 = _b[treat17]

	drop treat treat15 treat16 treat17
}

*Simulated treatment effects for each equation
gen t15_abgr12_3 = 0
gen t16_abgr12_3 = 0
gen t17_abgr12_3 = 0

gen t15_abrategr12_3 = 0
gen t16_abrategr12_3 = 0
gen t17_abrategr12_3 = 0

gen t15_abrate_3 = 0
gen t16_abrate_3 = 0
gen t17_abrate_3 = 0

levelsof state_fips, local(loop)
foreach l of local loop{

	*Percent of abortions after 12 weeks of gestation
	replace t15_abgr12_3 = t15_abgr12_`l'_3 if state_fips == `l'
	replace t16_abgr12_3 = t16_abgr12_`l'_3 if state_fips == `l'
	replace t17_abgr12_3 = t17_abgr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace t15_abrategr12_3 = t15_abrategr12_`l'_3 if state_fips == `l'
	replace t16_abrategr12_3 = t16_abrategr12_`l'_3 if state_fips == `l'
	replace t17_abrategr12_3 = t17_abrategr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate
	replace t15_abrate_3 = t15_abrate_`l'_3 if state_fips == `l'
	replace t16_abrate_3 = t16_abrate_`l'_3 if state_fips == `l'
	replace t17_abrate_3 = t17_abrate_`l'_3 if state_fips == `l'

}


collapse (mean) t15_abgr12_3 t16_abgr12_3 t17_abgr12_3 t15_abrategr12_3 ///
t16_abrategr12_3 t17_abrategr12_3 t15_abrate_3 t16_abrate_3 t17_abrate_3, by(state_fips)

tempfile refined
save `refined'

*Merge the two temporal datasets
use `whole'
merge 1:1 state_fips using `refined'

replace state_fips = 0 if state_fips == 99

collapse(sum) t15* t16* t17*, by(state_fips)

order state_fips t15_abgr12_1 t15_abgr12_2 t15_abgr12_3 t15_abrategr12_1 ///
t15_abrategr12_2 t15_abrategr12_3 t15_abrate_1 t15_abrate_2 t15_abrate_3 ///
t16_abgr12_1 t16_abgr12_2 t16_abgr12_3 t16_abrategr12_1 t16_abrategr12_2 ///
t16_abrategr12_3 t16_abrate_1 t16_abrate_2 t16_abrate_3 ///
t17_abgr12_1 t17_abgr12_2 t17_abgr12_3 t17_abrategr12_1 t17_abrategr12_2 ///
t17_abrategr12_3 t17_abrate_1 t17_abrate_2 t17_abrate_3

*************************************
*****Graphs for refined analysis*****
*************************************

gl te 16
gl vars abgr12 abrategr12 abrate
forvalues i=3(1)3{
	foreach m in $vars{
		foreach n in $te{
			gen true`m'_`n'_`i' = t`n'_`m'_`i' if state_fips == 0 
			egen meantrue`m'_`n'_`i' = mean(true`m'_`n'_`i')
			drop true`m'_`n'_`i'
			rename meantrue`m'_`n'_`i' true`m'_`n'_`i'
		}
	}
}

***Second-trimester abortions***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl te 16
gl vars abgr12
forvalues i=3(1)3{
	foreach m in $vars{
		foreach n in $te{
			scalar true`m'_`n'_`i' = true`m'_`n'_`i'

			histogram t`n'_`m'_`i', fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`n'_`i')', lpattern(dash) lwidth(thin)) ///
			xtitle("") title("") ytitle("") xscale(r(-5 6)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-6(1)6)
			graph export "$outputdir/Kernel_`m'_t`n'_group2.png", replace 
			}
		}
}

***Second-trimester abortion rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
gl te 16
gl vars abrategr12
forvalues i=3(1)3{
	foreach m in $vars{
		foreach n in $te{
			scalar true`m'_`n'_`i' = true`m'_`n'_`i'

			histogram t`n'_`m'_`i', fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`n'_`i')', lpattern(dash) lwidth(thin)) ///
			xtitle("") title("") ytitle("") xscale(r(-1.5 1.5)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-1.5(.5)1.5)
			graph export "$outputdir/Kernel_`m'_t`n'_group2.png", replace 
			}
		}
}

***Abortion Rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
gl te 16
gl vars abrate
forvalues i=3(1)3{
	foreach m in $vars{
		foreach n in $te{
			scalar true`m'_`n'_`i' = true`m'_`n'_`i'

			histogram t`n'_`m'_`i', fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`n'_`i')', lpattern(dash) lwidth(thin)) ///
			xtitle("") title("") ytitle("") xscale(r(-.5 .5)) yscale(r(0 .5)) ylabel(0(.1).5) xlabel(-.5(.25).5)
			graph export "$outputdir/Kernel_`m'_t`n'_group2.png", replace 
			}
		}
}

********************************************************************************
********************************************************************************
********************FIGURES 8 AND 9: SYNTHETIC CONTROL METHOD*******************
********************************************************************************
********************************************************************************

*--> THIS ANALYSIS IS ONLY DONE FOR "REFINED-TENNESSEE"

*All the output obtained from this analysis is saved in a different shared folder
*"C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP," because the blanks in 
*usual path are creating issues to run these instructions
*The graphs are saved in "outputdir"
 
gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

************************
************************
***Comparison group 1***
************************
************************
clear
eststo clear
preamble

keep if (groupd == 1 | TN == 1) & year<2017
tab year

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

*Specifications for SC graphs in the paper (as of May 23, 2020)

/*
NOTE: EACH ONE OF THE FOLLOWING FIGURES SHOULD BE SAVED MANUALLY. THEY REQUIRE
TO CHANGE THE YTITLE. IT IS ALSO NECESSARY TO ADD A LABEL FOR 2018
(EDIT OR ADD INDIVIDUAL TICK OR LABEL --> ADD --> ADD 2018)

*/

*Percent of abortions in the second-trimester
synth demean_fracabgr12 demean_fracabgr12(2010) demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_fracabgr12_CDC&ReportsD", replace) ///
customV(1 1 1 1 1)

*Log of the second-trimester abortion rate
synth demean_lnabgr12 demean_lnabgr12(2010) demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabgr12_CDC&ReportsD", replace) ///
customV(1 1 1 1 1)

*Log of the abortion rate
synth demean_lnabrate demean_lnabrate(2010) demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabrate_CDC&ReportsD", replace) ///
customV(1 1 1 1 1)


************************************
**********PLACEBO ANALYSIS**********
************************************
gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

*****Percent of abortions in the second-trimester*****

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_fracabgr12 demean_fracabgr12(2010) demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(`l') ///
trperiod(2015) keep("$scm\SCM_fracabgr12_`l'_CDC&ReportsD", replace) ///
customV(1 1 1 1 1)
}


*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_fracabgr12_`l'_CDC&ReportsD", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_fracabgr12_`l'_CDC&ReportsD", replace
}

use "$scm\SCM_fracabgr12_0_CDC&ReportsD", clear
gl states 2 8 13 15 16 19 21 26 27 29 30 32 34 35 36 37 39 40 41 44 45 46 49 53 ///
54 55

foreach n in $states{
qui merge 1:1 years using "$scm\SCM_fracabgr12_`n'_CDC&ReportsD"
drop _merge
}


**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}


twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Percent of abortions in the second trimester") xlabel(2010(2)2018) ///
legend(on order(27 1) label(27 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot))
graph export "$outputdir/PlaceboSCM_fracabgr12_CDC&ReportsD.png", replace 


*****Second-trimester abortion rate*****
preamble

keep if (TN == 1 | groupd == 1) & year<2017

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}
**************

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabgr12 demean_lnabgr12(2010) demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabgr12_`l'_CDC&ReportsD", replace) ///
customV(1 1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabgr12_`l'_CDC&ReportsD", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabgr12_`l'_CDC&ReportsD", replace
}

use "$scm\SCM_lnabgr12_0_CDC&ReportsD", clear
gl states 2 8 13 15 16 19 21 26 27 29 30 32 34 35 36 37 39 40 41 44 45 46 49 53 ///
54 55
foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabgr12_`n'_CDC&ReportsD"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(2nd trimester abortions per 1000 women)")  xlabel(2010(2)2018) ///
legend(on order(27 1) label(27 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot))
graph export "$outputdir/PlaceboSCM_lnabgr12_CDC&ReportsD.png", replace 

*****Overall abortion rate*****
preamble

keep if (TN == 1 | groupd == 1) & year<2017

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

**************

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabrate demean_lnabrate(2010) demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabrate_`l'_CDC&ReportsD", replace) ///
customV(1 1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabrate_`l'_CDC&ReportsD", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabrate_`l'_CDC&ReportsD", replace
}

use "$scm\SCM_lnabrate_0_CDC&ReportsD", clear
gl states 2 8 13 15 16 19 21 26 27 29 30 32 34 35 36 37 39 40 41 44 45 46 49 53 ///
54 55
foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabrate_`n'_CDC&ReportsD"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(Abortions per 1000 women, ages 15-44)") ///
legend(on order(27 1) label(27 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot)) xlabel(2010(2)2018)
graph export "$outputdir/PlaceboSCM_lnabrate_CDC&ReportsD.png", replace 


************************
************************
***Comparison group 2***
************************
************************
clear
preamble

keep if group3 == 1 | TN == 1

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

/*
NOTE: EACH ONE OF THE FOLLOWING FIGURES SHOULD BE SAVED MANUALLY. THEY REQUIRE
TO CHANGE THE YTITLE.)
*/

*Percent of abortions in the second-trimester
synth demean_fracabgr12 demean_fracabgr12(2010) demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_fracabgr12_alldemeaned", replace) ///
customV(1 1 1 1 1)

*Log of the second-trimester abortion rate
synth demean_lnabgr12 demean_lnabgr12(2010) demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabgr12_alldemeaned", replace) ///
customV(1 1 1 1 1)

*Log of the abortion rate
synth demean_lnabrate demean_lnabrate(2010) demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabrate_alldemeaned", replace) ///
customV(1 1 1 1 1)


************************************
**********PLACEBO ANALYSIS**********
************************************
clear
eststo clear
preamble

keep if group3 == 1 | TN == 1

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

*****Percent of abortions in the second-trimester*****
levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_fracabgr12 demean_fracabgr12(2010) demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(`l') ///
trperiod(2015) keep("$scm\SCM_fracabgr12_`l'_alldemeaned", replace) ///
customV(1 1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_fracabgr12_`l'_alldemeaned", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_fracabgr12_`l'_alldemeaned", replace
}

use "$scm\SCM_fracabgr12_0_alldemeaned", clear
gl states 4 17 27 29 35 36 37 40 42 49 53 55
foreach n in $states{
qui merge 1:1 years using "$scm\SCM_fracabgr12_`n'_alldemeaned"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}


twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Percent of abortions in the second trimester") xlabel(2010(2)2018) ///
legend(on order(13 1) label(13 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot))
graph export "$outputdir/PlaceboSCM_fracabgr12.png", replace 

*********Second-trimester abortion rate**********
clear
eststo clear
preamble

keep if group3 == 1 | TN == 1

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabgr12 demean_lnabgr12(2010) demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabgr12_`l'_alldemeaned", replace) ///
customV(1 1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabgr12_`l'_alldemeaned", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabgr12_`l'_alldemeaned", replace
}

use "$scm\SCM_lnabgr12_0_alldemeaned", clear
gl states 4 17 27 29 35 36 37 40 42 49 53 55
foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabgr12_`n'_alldemeaned"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(2nd trimester abortions per 1000 women)") xlabel(2010(2)2018) ///
legend(on order(13 1) label(13 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot))
graph export "$outputdir/PlaceboSCM_lnabgr12.png", replace 


**********Log of the abortion rate*********
clear
eststo clear
preamble

keep if group3 == 1 | TN == 1

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabrate demean_lnabrate(2010) demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabrate_`l'_alldemeaned", replace) ///
customV(1 1 1 1 1)
}
 
gl states0 0 4 17 27 29 35 36 37 40 42 49 53 55
foreach n in $states0{
use "$scm\SCM_lnabrate_`n'_alldemeaned", clear
rename _time years
gen tr_effect_`n' = _Y_treated - _Y_synthetic
keep years tr_effect_`n'
drop if missing(years)
save "$scm\SCM_lnabrate_`n'_alldemeaned", replace
}

use "$scm\SCM_lnabrate_0_alldemeaned", clear
gl states 4 17 27 29 35 36 37 40 42 49 53 55
foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabrate_`n'_alldemeaned"
drop _merge
}

***********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(Abortions per 1000 women, ages 15-44)") xlabel(2010(2)2018) ///
legend(on order(13 1) label(13 "Tennessee") label(1 "control states")) xline(2015, lpattern(dot))
graph export "$outputdir/PlaceboSCM_lnabrate.png", replace 


********************************************************************************
********************************************************************************
********************************************************************************
********TABLE A1: SHARE OF TREATED MONTHS BY THE LAW. RAW ABORTION RATES********
********************************************************************************
********************************************************************************
********************************************************************************

preamble

eststo clear

************************
************************
***Comparison group 1***
************************
************************

*2) Abortion rate after 12 weeks of gestation

preserve

keep if (groupdst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg ab_gr12_1544per1k i.year ShareTreated ///
[pweight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg ab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (groupd == 1 | TN == 1) & year<2017

eststo: xi: xtreg ab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore


*3) Abortion rate

preserve

keep if (groupdst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg ab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[pweight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg ab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (groupd == 1 | TN == 1) & year<2017
eststo: xi: xtreg ab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore


*Output file
esttab using "$outputdir\042021_JHERevision_TableA1_A.tex", ///
keep (ShareTreated) ///
longtable title("Estimated Effects of Tennessee's Mandatory Waiting Period") ///
nodepvars replace nostar b(3) p(2) label nonumbers 

*************************
*****Exact inference*****
*************************

*****Whole TN*****
preamble

keep if (groupdst == 1 | TNState == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)


***Log of the abortion rate after 12 weeks of gestation***

*a)
xi: xtreg ab_gr12_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_gr12_`l'_1 = _b[Share]

*b)
xi: xtreg ab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_gr12_`l'_2 = _b[Share]

***Log of the abortion rate***

*a)
xi: xtreg ab_all_nomissga_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_all_`l'_1 = _b[Share]

*b)
xi: xtreg ab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_all_`l'_2 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
forvalues i=1(1)2{
gen share_ab_gr12_`i' = 0
gen share_ab_all_`i' = 0

}

levelsof state_fips, local(loop)
foreach l of local loop{
forvalues i=1(1)2{

*Log of the abortion rate after 12 weeks of gestation
replace share_ab_gr12_`i' =  share_ab_gr12_`l'_`i' if state_fips == `l'

*Log of the abortion rate
replace share_ab_all_`i' = share_ab_all_`l'_`i' if state_fips == `l'

}
}

collapse (mean) share_ab_gr12_1 share_ab_gr12_2 share_ab_all_1 ///
share_ab_all_2, by(state_fips)

tempfile whole
save `whole'

*****Refined TN*****
preamble

keep if (groupd == 1 | TN == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)


***Log of the abortion rate after 12 weeks of gestation***

xi: xtreg ab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_gr12_`l'_3 = _b[Share]

***Log of the abortion rate***
xi: xtreg ab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_all_`l'_3 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
gen share_ab_gr12_3 = 0
gen share_ab_all_3 = 0

levelsof state_fips, local(loop)
foreach l of local loop{
	*Log of the abortion rate after 12 weeks of gestation
	replace share_ab_gr12_3 =  share_ab_gr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate
	replace share_ab_all_3 = share_ab_all_`l'_3 if state_fips == `l'
}

collapse (mean) share_ab_gr12_3 share_ab_all_3, by(state_fips)

tempfile refined
save `refined'

*Merge the two temporal datasets
use `whole'
merge 1:1 state_fips using `refined'

replace state_fips = 0 if state_fips == 99

collapse(sum) share*, by(state_fips)

order state_fips share_ab_gr12_1 share_ab_gr12_2 share_ab_gr12_3 ///
share_ab_all_1 share_ab_all_2 share_ab_all_3

************************
************************
***Comparison group 2***
************************
************************

preamble

eststo clear

*2) Abortion rate after 12 weeks of gestation

preserve

keep if (group3st == 1 | TNState == 1) 

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg ab_gr12_1544per1k i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg ab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (group3 == 1 | TN == 1) 

eststo: xi: xtreg ab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*3) Abortion rate

preserve

keep if (group3st == 1 | TNState == 1) 

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg ab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg ab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (group3 == 1 | TN == 1) 

eststo: xi: xtreg ab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*Output file
esttab using "$outputdir\042021_JHERevision_TableA1_B.tex", ///
keep (ShareTreated) ///
longtable title("Estimated Effects of Tennessee's Mandatory Waiting Period") ///
nodepvars replace nostar b(3) p(2) label nonumbers 

*************************
*****Exact inference*****
*************************

*****Whole TN*****
preamble

keep if TNState == 1 | group3st == 1

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Log of the abortion rate after 12 weeks of gestation***

*a)
xi: xtreg ab_gr12_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_gr12_`l'_1 = _b[Share]

*b)
xi: xtreg ab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_gr12_`l'_2 = _b[Share]

***Log of the abortion rate***

*a)
xi: xtreg ab_all_nomissga_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_all_`l'_1 = _b[Share]

*b)
xi: xtreg ab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_all_`l'_2 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
forvalues i=1(1)2{
gen share_ab_gr12_`i' = 0
gen share_ab_all_`i' = 0

}

levelsof state_fips, local(loop)
foreach l of local loop{
forvalues i=1(1)2{

*Log of the abortion rate after 12 weeks of gestation
replace share_ab_gr12_`i' =  share_ab_gr12_`l'_`i' if state_fips == `l'

*Log of the abortion rate
replace share_ab_all_`i' = share_ab_all_`l'_`i' if state_fips == `l'

}
}

collapse (mean) share_ab_gr12_1 share_ab_gr12_2 share_ab_all_1 ///
share_ab_all_2, by(state_fips)

tempfile whole
save `whole'

*****Refined TN*****
preamble

keep if TN == 1 | group3 == 1

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Log of the abortion rate after 12 weeks of gestation***

xi: xtreg ab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_gr12_`l'_3 = _b[Share]

***Log of the abortion rate***
xi: xtreg ab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_ab_all_`l'_3 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
gen share_ab_gr12_3 = 0
gen share_ab_all_3 = 0

levelsof state_fips, local(loop)
foreach l of local loop{
	*Log of the abortion rate after 12 weeks of gestation
	replace share_ab_gr12_3 =  share_ab_gr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate
	replace share_ab_all_3 = share_ab_all_`l'_3 if state_fips == `l'
}

collapse (mean) share_ab_gr12_3 share_ab_all_3, by(state_fips)

tempfile refined
save `refined'

*Merge the two temporal datasets
use `whole'
merge 1:1 state_fips using `refined'

replace state_fips = 0 if state_fips == 99

collapse(sum) share*, by(state_fips)

order state_fips share_ab_gr12_1 share_ab_gr12_2 share_ab_gr12_3 ///
share_ab_all_1 share_ab_all_2 share_ab_all_3


********************************************************************************
********************************************************************************
**************** TABLE A3, FIGURES A5-A7: SHARE OF TREATED MONTHS **************
********************** BY THE LAW FOR DIFFERENT THRESHOLDS *********************
********************************************************************************
********************************************************************************

preamble

tab state groupe /*5% out-of-state abortions*/
tab state groupest /*5% out-of-state abortions*/

tab state groupf /*10% out-of-state abortions*/
tab state groupfst /*10% out-of-state abortions*/

tab state groupd /*20% out-of-state abortions*/
tab state groupdst /*20% out-of-state abortions*/

tab state groupg /*40% out-of-state abortions*/
tab state groupgst /*40% out-of-state abortions*/


eststo clear

*************************
*****1) 5% threshold*****
*************************

*1) Percent of abortions after 12 weeks of gestation

preserve

keep if (groupest == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole State without controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

*b) TN Whole State with all controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

preserve
keep if (groupe == 1 | TN == 1) & year<2017

*c) Refined TN with all controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*2) Abortion rate after 12 weeks of gestation

preserve
keep if (groupest == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole State without controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole State with all controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

preserve 
keep if (groupe == 1 | TN == 1) & year<2017

*c) Refined TN with all controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*3) Abortion rate

preserve
keep if (groupest == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole State without controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole State with all controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

preserve 
keep if (groupe == 1 | TN == 1) & year<2017

*c) Refined TN with all controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*Output file
esttab using "$outputdir\042021_JHERevision_TableA3_PanelA.tex", ///
keep (ShareTreated) ///
longtable title("Estimated Effects of Tennessee's Mandatory Waiting Period") ///
nodepvars replace nostar b(3) p(2) label nonumbers 

*************************
*****Exact inference*****
*************************

*****Whole TN*****

preamble

keep if (groupest == 1 | TNState == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

*a)
xi: xtreg frac_ab_gr12_rep i.year Share ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_1 = _b[Share]

*b) 
xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_2 = _b[Share]


***Log of the abortion rate after 12 weeks of gestation***

*a)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_2 = _b[Share]

***Log of the abortion rate***

*a)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_2 = _b[Share]


drop treat Share
}

*Simulated treatment effects for each equation
forvalues i=1(1)2{
	gen share_abgr12_`i' = 0
	gen share_lnab_gr12_`i' = 0
	gen share_lnab_all_`i' = 0

}

levelsof state_fips, local(loop)
foreach l of local loop{
	forvalues i=1(1)2{

	*Percent of abortions after 12 weeks of gestation
	replace share_abgr12_`i' = share_abgr12_`l'_`i' if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace share_lnab_gr12_`i' =  share_lnab_gr12_`l'_`i' if state_fips == `l'

	*Log of the abortion rate
	replace share_lnab_all_`i' = share_lnab_all_`l'_`i' if state_fips == `l'

	}
}

collapse (mean) share_abgr12_1 share_abgr12_2 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_all_1 share_lnab_all_2, by(state_fips)

tempfile whole
save `whole'

*****Refined TN*****
preamble

keep if (groupe == 1 | TN == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_3 = _b[Share]

***Log of the abortion rate after 12 weeks of gestation***

xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_3 = _b[Share]

***Log of the abortion rate***

xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_3 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
gen share_abgr12_3 = 0
gen share_lnab_gr12_3 = 0
gen share_lnab_all_3 = 0

levelsof state_fips, local(loop)
foreach l of local loop{
	*Percent of abortions after 12 weeks of gestation
	replace share_abgr12_3 = share_abgr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace share_lnab_gr12_3 =  share_lnab_gr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate
	replace share_lnab_all_3 = share_lnab_all_`l'_3 if state_fips == `l'
}

collapse (mean) share_abgr12_3 share_lnab_gr12_3 share_lnab_all_3, by(state_fips)

tempfile refined
save `refined'

*Merge the two temporal datasets
use `whole'
merge 1:1 state_fips using `refined'

replace state_fips = 0 if state_fips == 99

collapse(sum) share*, by(state_fips)

order state_fips share_abgr12_1 share_abgr12_2 share_abgr12_3 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_gr12_3 share_lnab_all_1 share_lnab_all_2 share_lnab_all_3


**************************
*****2) 10% threshold*****
**************************
*1) Percent of abortions after 12 weeks of gestation

preamble

eststo clear

preserve

keep if (groupfst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole State without controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

*b) TN Whole State with all controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

preserve
keep if (groupf == 1 | TN == 1) & year<2017

*c) Refined TN with all controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*2) Abortion rate after 12 weeks of gestation

preserve
keep if (groupfst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole State without controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole State with all controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

preserve 
keep if (groupf == 1 | TN == 1) & year<2017

*c) Refined TN with all controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*3) Abortion rate

preserve
keep if (groupfst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole State without controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole State with all controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

preserve 
keep if (groupf == 1 | TN == 1) & year<2017

*c) Refined TN with all controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*Output file
esttab using "$outputdir\042021_JHERevision_TableA3_PanelB.tex", ///
keep (ShareTreated) ///
longtable title("Estimated Effects of Tennessee's Mandatory Waiting Period") ///
nodepvars replace nostar b(3) p(2) label nonumbers 

*************************
*****Exact inference*****
*************************

*****Whole TN*****

preamble

keep if (groupfst == 1 | TNState == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

*a)
xi: xtreg frac_ab_gr12_rep i.year Share ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_1 = _b[Share]

*b) 
xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_2 = _b[Share]


***Log of the abortion rate after 12 weeks of gestation***

*a)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_2 = _b[Share]

***Log of the abortion rate***

*a)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_2 = _b[Share]


drop treat Share
}

*Simulated treatment effects for each equation
forvalues i=1(1)2{
	gen share_abgr12_`i' = 0
	gen share_lnab_gr12_`i' = 0
	gen share_lnab_all_`i' = 0

}

levelsof state_fips, local(loop)
foreach l of local loop{
	forvalues i=1(1)2{

	*Percent of abortions after 12 weeks of gestation
	replace share_abgr12_`i' = share_abgr12_`l'_`i' if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace share_lnab_gr12_`i' =  share_lnab_gr12_`l'_`i' if state_fips == `l'

	*Log of the abortion rate
	replace share_lnab_all_`i' = share_lnab_all_`l'_`i' if state_fips == `l'

	}
}

collapse (mean) share_abgr12_1 share_abgr12_2 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_all_1 share_lnab_all_2, by(state_fips)

tempfile whole
save `whole'

*****Refined TN*****
preamble

keep if (groupf == 1 | TN == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_3 = _b[Share]

***Log of the abortion rate after 12 weeks of gestation***

xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_3 = _b[Share]

***Log of the abortion rate***

xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_3 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
gen share_abgr12_3 = 0
gen share_lnab_gr12_3 = 0
gen share_lnab_all_3 = 0

levelsof state_fips, local(loop)
foreach l of local loop{
	*Percent of abortions after 12 weeks of gestation
	replace share_abgr12_3 = share_abgr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace share_lnab_gr12_3 =  share_lnab_gr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate
	replace share_lnab_all_3 = share_lnab_all_`l'_3 if state_fips == `l'
}

collapse (mean) share_abgr12_3 share_lnab_gr12_3 share_lnab_all_3, by(state_fips)

tempfile refined
save `refined'

*Merge the two temporal datasets
use `whole'
merge 1:1 state_fips using `refined'

replace state_fips = 0 if state_fips == 99

collapse(sum) share*, by(state_fips)

order state_fips share_abgr12_1 share_abgr12_2 share_abgr12_3 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_gr12_3 share_lnab_all_1 share_lnab_all_2 share_lnab_all_3

**************************
*****3) 40% threshold*****
**************************
*1) Percent of abortions after 12 weeks of gestation

preamble

eststo clear

preserve

keep if (groupgst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole State without controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

*b) TN Whole State with all controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

preserve
keep if (groupg == 1 | TN == 1) & year<2017

*c) Refined TN with all controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*2) Abortion rate after 12 weeks of gestation

preserve
keep if (groupgst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole State without controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole State with all controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

preserve 
keep if (groupg == 1 | TN == 1) & year<2017

*c) Refined TN with all controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*3) Abortion rate

preserve
keep if (groupgst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole State without controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole State with all controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

preserve 
keep if (groupg == 1 | TN == 1) & year<2017

*c) Refined TN with all controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*Output file
esttab using "$outputdir\042021_JHERevision_TableA3_PanelD.tex", ///
keep (ShareTreated) ///
longtable title("Estimated Effects of Tennessee's Mandatory Waiting Period") ///
nodepvars replace nostar b(3) p(2) label nonumbers 

*************************
*****Exact inference*****
*************************

*****Whole TN*****

preamble

keep if (groupgst == 1 | TNState == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

*a)
xi: xtreg frac_ab_gr12_rep i.year Share ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_1 = _b[Share]

*b) 
xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_2 = _b[Share]


***Log of the abortion rate after 12 weeks of gestation***

*a)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_2 = _b[Share]

***Log of the abortion rate***

*a)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_2 = _b[Share]


drop treat Share
}

*Simulated treatment effects for each equation
forvalues i=1(1)2{
	gen share_abgr12_`i' = 0
	gen share_lnab_gr12_`i' = 0
	gen share_lnab_all_`i' = 0

}

levelsof state_fips, local(loop)
foreach l of local loop{
	forvalues i=1(1)2{

	*Percent of abortions after 12 weeks of gestation
	replace share_abgr12_`i' = share_abgr12_`l'_`i' if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace share_lnab_gr12_`i' =  share_lnab_gr12_`l'_`i' if state_fips == `l'

	*Log of the abortion rate
	replace share_lnab_all_`i' = share_lnab_all_`l'_`i' if state_fips == `l'

	}
}

collapse (mean) share_abgr12_1 share_abgr12_2 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_all_1 share_lnab_all_2, by(state_fips)

tempfile whole
save `whole'

*****Refined TN*****
preamble

keep if (groupg == 1 | TN == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_3 = _b[Share]

***Log of the abortion rate after 12 weeks of gestation***

xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_3 = _b[Share]

***Log of the abortion rate***

xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_3 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
gen share_abgr12_3 = 0
gen share_lnab_gr12_3 = 0
gen share_lnab_all_3 = 0

levelsof state_fips, local(loop)
foreach l of local loop{
	*Percent of abortions after 12 weeks of gestation
	replace share_abgr12_3 = share_abgr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace share_lnab_gr12_3 =  share_lnab_gr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate
	replace share_lnab_all_3 = share_lnab_all_`l'_3 if state_fips == `l'
}

collapse (mean) share_abgr12_3 share_lnab_gr12_3 share_lnab_all_3, by(state_fips)

tempfile refined
save `refined'

*Merge the two temporal datasets
use `whole'
merge 1:1 state_fips using `refined'

replace state_fips = 0 if state_fips == 99

collapse(sum) share*, by(state_fips)

order state_fips share_abgr12_1 share_abgr12_2 share_abgr12_3 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_gr12_3 share_lnab_all_1 share_lnab_all_2 share_lnab_all_3


********************************************************************************
****************************SYNTHETIC CONTROL METHOD****************************
********************************************************************************
gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

***************************
*5% out-of-state abortions*
***************************

clear
eststo clear
preamble

keep if (groupe == 1 | TN == 1) & year<2017
tab year

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

*Specifications for SC graphs in the paper (as of May 23, 2020)

*Percent of abortions in the second-trimester
synth demean_fracabgr12 demean_fracabgr12(2010) demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_fracabgr12_CDC&ReportsE", replace) ///
customV(1 1 1 1 1)

*Log of the second-trimester abortion rate
synth demean_lnabgr12 demean_lnabgr12(2010) demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabgr12_CDC&ReportsE", replace) ///
customV(1 1 1 1 1)

*Log of the abortion rate --> I could not keep the nested option
synth demean_lnabrate demean_lnabrate(2010) demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(0) ///
trperiod(2015) figure  keep("$scm\SCM_lnabrate_CDC&ReportsE", replace) ///
customV(1 1 1 1 1)


************************************
**********PLACEBO ANALYSIS**********
************************************
gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

*****Percent of abortions in the second-trimester*****

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_fracabgr12 demean_fracabgr12(2010) demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(`l') ///
trperiod(2015) keep("$scm\SCM_fracabgr12_`l'_Robustness", replace) ///
customV(1 1 1 1 1)
}


*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_fracabgr12_`l'_Robustness", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_fracabgr12_`l'_Robustness", replace
}

use "$scm\SCM_fracabgr12_0_Robustness", clear
gl states 2	15	16	26	27	29	35	36	37	40	45	49	53	55

foreach n in $states{
qui merge 1:1 years using "$scm\SCM_fracabgr12_`n'_Robustness"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}


twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Percent of abortions in the second trimester") xlabel(2010(2)2016) ylabel(-6(2)6) ///
legend(on order(15 1) label(15 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot))
graph export "$scm/PlaceboSCM_fracabgr12_CDC&ReportsE.png", replace 


*****Second-trimester abortion rate*****
preamble

keep if (TN == 1 | groupe == 1) & year<2017

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}
**************

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabgr12 demean_lnabgr12(2010) demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabgr12_`l'_Robustness", replace) ///
customV(1 1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabgr12_`l'_Robustness", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabgr12_`l'_Robustness", replace
}

use "$scm\SCM_lnabgr12_0_Robustness", clear
gl states 2	15	16	26	27	29	35	36	37	40	45	49	53	55

foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabgr12_`n'_Robustness"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(2nd trimester abortions per 1000 women)")  xlabel(2010(2)2016) ///
legend(on order(15 1) label(15 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot))
graph export "$scm/PlaceboSCM_lnabgr12_CDC&ReportsE.png", replace 

*****Overall abortion rate*****
preamble

keep if (TN == 1 | groupe == 1) & year<2017

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

**************

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabrate demean_lnabrate(2010) demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabrate_`l'_Robustness", replace) ///
customV(1 1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabrate_`l'_Robustness", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabrate_`l'_Robustness", replace
}

use "$scm\SCM_lnabrate_0_Robustness", clear
gl states 2	15	16	26	27	29	35	36	37	40	45	49	53	55

foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabrate_`n'_Robustness"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(Abortions per 1000 women, ages 15-44)") ///
legend(on order(15 1) label(15 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot)) xlabel(2010(2)2016)
graph export "$scm/PlaceboSCM_lnabrate_CDC&ReportsE.png", replace 


********************************************************************************
****************************
*10% out-of-state abortions*
****************************

clear
eststo clear
preamble

keep if (groupf == 1 | TN == 1) & year<2017
tab year

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

*Specifications for SC graphs in the paper (as of May 23, 2020)

*Percent of abortions in the second-trimester
synth demean_fracabgr12 demean_fracabgr12(2010) demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_fracabgr12_CDC&ReportsF", replace) ///
customV(1 1 1 1 1)

*Log of the second-trimester abortion rate
synth demean_lnabgr12 demean_lnabgr12(2010) demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabgr12_CDC&ReportsF", replace) ///
customV(1 1 1 1 1)

*Log of the abortion rate --> I had to remove the nested option to make it work
synth demean_lnabrate demean_lnabrate(2010) demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(0) ///
trperiod(2015) figure keep("$scm\SCM_lnabrate_CDC&ReportsF", replace) ///
customV(1 1 1 1 1)


************************************
**********PLACEBO ANALYSIS**********
************************************
gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

*****Percent of abortions in the second-trimester*****

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_fracabgr12 demean_fracabgr12(2010) demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(`l') ///
trperiod(2015) keep("$scm\SCM_fracabgr12_`l'_Robustness", replace) ///
customV(1 1 1 1 1)
}


*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_fracabgr12_`l'_Robustness", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_fracabgr12_`l'_Robustness", replace
}

use "$scm\SCM_fracabgr12_0_Robustness", clear
gl states 2	15	16	26	27	29	32	34	35	36	37	39	40	45	49	53	55

foreach n in $states{
qui merge 1:1 years using "$scm\SCM_fracabgr12_`n'_Robustness"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}


twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Percent of abortions in the second trimester") xlabel(2010(2)2016) ylabel(-6(2)6) ///
legend(on order(18 1) label(18 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot))
graph export "$scm/PlaceboSCM_fracabgr12_CDC&ReportsF.png", replace 


*****Second-trimester abortion rate*****
preamble

keep if (TN == 1 | groupf== 1) & year<2017

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}
**************

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabgr12 demean_lnabgr12(2010) demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabgr12_`l'_Robustness", replace) ///
customV(1 1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabgr12_`l'_Robustness", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabgr12_`l'_Robustness", replace
}

use "$scm\SCM_lnabgr12_0_Robustness", clear
gl states 2	15	16	26	27	29	32	34	35	36	37	39	40	45	49	53	55

foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabgr12_`n'_Robustness"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(2nd trimester abortions per 1000 women)")  xlabel(2010(2)2016) ///
legend(on order(18 1) label(18 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot))
graph export "$scm/PlaceboSCM_lnabgr12_CDC&ReportsF.png", replace 

*****Overall abortion rate*****
preamble

keep if (TN == 1 | groupf == 1) & year<2017

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

**************

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabrate demean_lnabrate(2010) demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabrate_`l'_Robustness", replace) ///
customV(1 1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabrate_`l'_Robustness", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabrate_`l'_Robustness", replace
}

use "$scm\SCM_lnabrate_0_Robustness", clear
gl states 2	15	16	26	27	29	32	34	35	36	37	39	40	45	49	53	55

foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabrate_`n'_Robustness"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(Abortions per 1000 women, ages 15-44)") ///
legend(on order(18 1) label(18 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot)) xlabel(2010(2)2016)
graph export "$scm/PlaceboSCM_lnabrate_CDC&ReportsF.png", replace 


********************************************************************************
****************************
*40% out-of-state abortions*
****************************

clear
eststo clear
preamble

keep if (groupg == 1 | TN == 1) & year<2017
tab year

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

*Percent of abortions in the second-trimester
synth demean_fracabgr12 demean_fracabgr12(2010) demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_fracabgr12_CDC&ReportsG", replace) ///
customV(1 1 1 1 1)


*Log of the second-trimester abortion rate
synth demean_lnabgr12 demean_lnabgr12(2010) demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabgr12_CDC&ReportsG", replace) ///
customV(1 1 1 1 1)

*Log of the abortion rate
synth demean_lnabrate demean_lnabrate(2010) demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabrate_CDC&ReportsG", replace) ///
customV(1 1 1 1 1)


************************************
**********PLACEBO ANALYSIS**********
************************************
gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

*****Percent of abortions in the second-trimester*****

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_fracabgr12 demean_fracabgr12(2010) demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(`l') ///
trperiod(2015) keep("$scm\SCM_fracabgr12_`l'_Robustness", replace) ///
customV(1 1 1 1 1)
}


*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_fracabgr12_`l'_Robustness", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_fracabgr12_`l'_Robustness", replace
}

use "$scm\SCM_fracabgr12_0_Robustness", clear
gl states 2	8	13	15	16	19	21	26	27	29	30	32	34	35	36	37	38	39	40	41	44	45	46	49	53	54	55

foreach n in $states{
qui merge 1:1 years using "$scm\SCM_fracabgr12_`n'_Robustness"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}


twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Percent of abortions in the second trimester") xlabel(2010(2)2016)  ylabel(-6(2)6) ///
legend(on order(28 1) label(28 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot))
graph export "$scm/PlaceboSCM_fracabgr12_CDC&ReportsG.png", replace 


*****Second-trimester abortion rate*****
preamble

keep if (TN == 1 | groupg== 1) & year<2017

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}
**************

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabgr12 demean_lnabgr12(2010) demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabgr12_`l'_Robustness", replace) ///
customV(1 1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabgr12_`l'_Robustness", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabgr12_`l'_Robustness", replace
}

use "$scm\SCM_lnabgr12_0_Robustness", clear
gl states 2	8	13	15	16	19	21	26	27	29	30	32	34	35	36	37	38	39	40	41	44	45	46	49	53	54	55

foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabgr12_`n'_Robustness"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(2nd trimester abortions per 1000 women)")  xlabel(2010(2)2016) ///
legend(on order(28 1) label(28 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot))
graph export "$scm/PlaceboSCM_lnabgr12_CDC&ReportsG.png", replace 

*****Overall abortion rate*****
preamble

keep if (TN == 1 | groupg == 1) & year<2017

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

**************

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabrate demean_lnabrate(2010) demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabrate_`l'_Robustness", replace) ///
customV(1 1 1 1 1)
}


*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabrate_`l'_Robustness", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabrate_`l'_Robustness", replace
}

use "$scm\SCM_lnabrate_0_Robustness", clear
gl states 2	8	13	15	16	19	21	26	27	29	30	32	34	35	36	37	38	39	40	41	44	45	46	49	53	54	55

foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabrate_`n'_Robustness"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(Abortions per 1000 women, ages 15-44)") ///
legend(on order(28 1) label(28 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot)) xlabel(2010(2)2016)
graph export "$scm/PlaceboSCM_lnabrate_CDC&ReportsG.png", replace 

********************************************************************************
********* FIGURE A3. ESTIMATIONS DROPPING ONE STATE IN THE CONTROL *************
******************************* GROUP AT A TIME ********************************
********************************************************************************

************************
************************
***Comparison group 1***
************************
************************
clear
eststo clear
preamble

keep if (groupd == 1 | TN == 1) & year<2017

tab state groupd

*****Share Treated*****
levelsof state_fips if state!= "Tennessee", local(loop)
foreach l of local loop{

***Share of abortions after 12 weeks of gestation***
preserve
drop if state_fips == `l'

*a)
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_`l'_1 = _b[ShareTreated]

*b) 
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_`l'_2 = _b[ShareTreated]

*c)
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_`l'_3 = _b[ShareTreated]

***Log of the abortion rate after 12 weeks of gestation***

*a)
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_`l'_1 = _b[ShareTreated]

*b)
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_`l'_2 = _b[ShareTreated]

*c)
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_`l'_3 = _b[ShareTreated]

***Log of the abortion rate***

*a)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_`l'_1 = _b[ShareTreated]

*b)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_`l'_2 = _b[ShareTreated]

*c)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_`l'_3 = _b[ShareTreated]

restore
}

*Estimations including all the states--> The main results of the paper
*a)
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_0_1 = _b[ShareTreated]

*b) 
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_0_2 = _b[ShareTreated]

*c)
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_0_3 = _b[ShareTreated]

***Log of the abortion rate after 12 weeks of gestation***

*a)
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_0_1 = _b[ShareTreated]

*b)
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_0_2 = _b[ShareTreated]

eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_0_3 = _b[ShareTreated]

***Log of the abortion rate***

*a)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_0_1 = _b[ShareTreated]

*b)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_0_2 = _b[ShareTreated]

*c)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_0_3 = _b[ShareTreated]


*Simulated treatment effects for each equation
forvalues i=1(1)3{
	gen share_abgr12_`i' = 0

	gen share_abrategr12_`i' = 0

	gen share_abrate_`i' = 0
}

levelsof state_fips, local(loop)
foreach l of local loop{
	forvalues i=1(1)3{

		*Percent of abortions after 12 weeks of gestation
		replace share_abgr12_`i' = scalar(share_abgr12_`l'_`i') if state_fips == `l'

		*Log of the abortion rate after 12 weeks of gestation
		replace share_abrategr12_`i' = scalar(share_abrategr12_`l'_`i') if state_fips == `l'

		*Log of the abortion rate
		replace share_abrate_`i' = scalar(share_abrate_`l'_`i') if state_fips == `l'
	}
}

su share_abgr12_1 share_abgr12_2 share_abgr12_3 share_abrategr12_1 share_abrategr12_2 share_abrategr12_3 share_abrate_1 share_abrate_2 share_abrate_3

collapse (mean) share_abgr12_1 share_abgr12_2 share_abgr12_3 ///
share_abrategr12_1 share_abrategr12_2 share_abrategr12_3 ///
share_abrate_1 share_abrate_2 share_abrate_3, by(state_fips)

su share_abgr12_1 share_abgr12_2 share_abgr12_3 share_abrategr12_1 share_abrategr12_2 share_abrategr12_3 share_abrate_1 share_abrate_2 share_abrate_3


gl vars abgr12 abrategr12 abrate
forvalues i=1(1)3{
	foreach m in $vars{
		gen true`m'_`i' = share_`m'_`i' if state_fips == 0 
		egen meantrue`m'_`i' = mean(true`m'_`i')
		drop true`m'_`i'
		rename meantrue`m'_`i' true`m'_`i'
	}
}

***Second-trimester abortions***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl vars abgr12
forvalues i=1(1)3{
	foreach m in $vars{
		scalar true`m'_`i' = true`m'_`i'

		histogram share_`m'_`i' if state_fips!=0, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`i')', lpattern(dash) lwidth(thin)) ///
		xtitle("") title("") ytitle("") xscale(r(1 6)) yscale(r(0 .7)) ylabel(0(.1).7) xlabel(1(1)6)
		graph export "$outputdir/Histogram_share_CDC&ReportsD_`m'_`i'_dropstate.png", replace 
	}
}

***Second-trimester abortion rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl vars abrategr12
forvalues i=1(1)3{
	foreach m in $vars{
		scalar true`m'_`i' = true`m'_`i'

		histogram share_`m'_`i' if state_fips!=0, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`i')', lpattern(dash) lwidth(thin)) ///
		xtitle("") title("") ytitle("") xscale(r(.1 .4)) yscale(r(0 .7)) ylabel(0.(.1).7) xlabel(.1(.05).4)
		graph export "$outputdir/Histogram_share_CDC&ReportsD_`m'_`i'_dropstate.png", replace 
	}
}

***Abortion Rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl vars abrate
forvalues i=1(1)3{
	foreach m in $vars{
		scalar true`m'_`i' = true`m'_`i'

		histogram share_`m'_`i' if state_fips!=0, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`i')', lpattern(dash) lwidth(thin)) ///
		xtitle("") title("") ytitle("") xscale(r(-.3 0)) yscale(r(0 .7)) ylabel(0(.1).7) xlabel(-.3(.05)0)
		graph export "$outputdir/Histogram_share_CDC&ReportsD_`m'_`i'_dropstate.png", replace 
	}
}

************************
************************
***Comparison group 2***
************************
************************
clear
eststo clear
preamble

keep if TN == 1 | group3 == 1

levelsof state_fips if state!= "Tennessee", local(loop)
foreach l of local loop{

***Share of abortions after 12 weeks of gestation***
preserve
drop if state_fips == `l'

*a)
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_`l'_1 = _b[ShareTreated]

*b) 
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_`l'_2 = _b[ShareTreated]

*c)
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_`l'_3 = _b[ShareTreated]

***Log of the abortion rate after 12 weeks of gestation***

*a)
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_`l'_1 = _b[ShareTreated]

*b)
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_`l'_2 = _b[ShareTreated]

*c)
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_`l'_3 = _b[ShareTreated]

***Log of the abortion rate***

*a)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_`l'_1 = _b[ShareTreated]

*b)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_`l'_2 = _b[ShareTreated]

*c)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_`l'_3 = _b[ShareTreated]

restore
}

*Estimations including all the states--> The main results of the paper

*a)
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_0_1 = _b[ShareTreated]

*b) 
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_0_2 = _b[ShareTreated]

*c)
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

scalar share_abgr12_0_3 = _b[ShareTreated]

***Log of the abortion rate after 12 weeks of gestation***

*a)
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_0_1 = _b[ShareTreated]

*b)
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_0_2 = _b[ShareTreated]

eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrategr12_0_3 = _b[ShareTreated]

***Log of the abortion rate***

*a)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_0_1 = _b[ShareTreated]

*b)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_0_2 = _b[ShareTreated]

*c)
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

scalar share_abrate_0_3 = _b[ShareTreated]


*Simulated treatment effects for each equation
forvalues i=1(1)3{
	gen share_abgr12_`i' = 0

	gen share_abrategr12_`i' = 0

	gen share_abrate_`i' = 0
}

levelsof state_fips, local(loop)
foreach l of local loop{
	forvalues i=1(1)3{

		*Percent of abortions after 12 weeks of gestation
		replace share_abgr12_`i' = scalar(share_abgr12_`l'_`i') if state_fips == `l'

		*Log of the abortion rate after 12 weeks of gestation
		replace share_abrategr12_`i' = scalar(share_abrategr12_`l'_`i') if state_fips == `l'

		*Log of the abortion rate
		replace share_abrate_`i' = scalar(share_abrate_`l'_`i') if state_fips == `l'
	}
}

su share_abgr12_1 share_abgr12_2 share_abgr12_3 share_abrategr12_1 share_abrategr12_2 share_abrategr12_3 share_abrate_1 share_abrate_2 share_abrate_3

collapse (mean) share_abgr12_1 share_abgr12_2 share_abgr12_3 ///
share_abrategr12_1 share_abrategr12_2 share_abrategr12_3 ///
share_abrate_1 share_abrate_2 share_abrate_3, by(state_fips)

su share_abgr12_1 share_abgr12_2 share_abgr12_3 share_abrategr12_1 share_abrategr12_2 share_abrategr12_3 share_abrate_1 share_abrate_2 share_abrate_3


gl vars abgr12 abrategr12 abrate
forvalues i=1(1)3{
	foreach m in $vars{
		gen true`m'_`i' = share_`m'_`i' if state_fips == 0 
		egen meantrue`m'_`i' = mean(true`m'_`i')
		drop true`m'_`i'
		rename meantrue`m'_`i' true`m'_`i'
	}
}

***Second-trimester abortions***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl vars abgr12
forvalues i=1(1)3{
	foreach m in $vars{
		scalar true`m'_`i' = true`m'_`i'

		histogram share_`m'_`i' if state_fips!=0, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`i')', lpattern(dash) lwidth(thin)) ///
		xtitle("") title("") ytitle("") xscale(r(1 6)) yscale(r(0 .7)) ylabel(0(.1).7) xlabel(1(1)6)
		graph export "$outputdir/Histogram_share_`m'_`i'_dropstate.png", replace 
	}
}

***Second-trimester abortion rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl vars abrategr12
forvalues i=1(1)3{
	foreach m in $vars{
		scalar true`m'_`i' = true`m'_`i'

		histogram share_`m'_`i' if state_fips!=0, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`i')', lpattern(dash) lwidth(thin)) ///
		xtitle("") title("") ytitle("") xscale(r(.1 .4)) yscale(r(0 .7)) ylabel(0.(.1).7) xlabel(.1(.05).4)
		graph export "$outputdir/Histogram_share_`m'_`i'_dropstate.png", replace 
	}
}

***Abortion Rate***
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

gl vars abrate
forvalues i=1(1)3{
	foreach m in $vars{
		scalar true`m'_`i' = true`m'_`i'

		histogram share_`m'_`i' if state_fips!=0, fraction bin(15) color(white) lcolor(edkblue) xline(`=scalar(true`m'_`i')', lpattern(dash) lwidth(thin)) ///
		xtitle("") title("") ytitle("") xscale(r(-.3 0)) yscale(r(0 .7)) ylabel(0(.1).7) xlabel(-.3(.05)0)
		graph export "$outputdir/Histogram_share_`m'_`i'_dropstate.png", replace 
	}
}

********************************************************************************
********************************************************************************
************TABLE A4 AND FIGURE A8-A9. MAIN ANALYSIS INCLUDING DELAWARE*********
********************************************************************************
********************************************************************************

clear all
set more off

cd "C:\Users\MayraBelinda\Dropbox\ResearchProjects\Reassessing the Effects of Mandatory Waiting Periods\Analysis\StateAnalysisNewData\StatesDataset"
gl outputdir "C:\Users\MayraBelinda\Dropbox\ResearchProjects\Reassessing the Effects of Mandatory Waiting Periods\Draft\GraphsResubmissionJHE"

capture program drop
program define preamble2
*Generate population by health region

use "FemPop1544_counties.dta", clear

tempfile PopulationHealthArea

merge m:1 countyid using "countybyhealthareaTN.dta"
browse if _merge == 1
browse if _merge == 3
drop if _merge!=3
drop _merge

sort healtharea year

collapse(sum) fempop_15to44, by(healtharea year)

rename healtharea area

save "`PopulationHealthArea'"

clear
import excel using "TNHealthAreasData.xlsx", sheet(Data) firstrow

merge 1:1 area year using "`PopulationHealthArea'"
drop if year<2010
browse if _merge == 1 /*Whole state, Tennessee data*/
drop if _merge != 3
drop _merge

******************************************************
*Merge with information on female population by age group and race
merge 1:1 area year using "PopbyHealthAreaSexRaceTN.dta"
tab year if _merge == 2 /*2018*/
drop if _merge == 2
drop _merge

*Drop the four health areas that show weird jumps in the data or are more likely to have out-of-state abortions
drop if (area == "Hamilton" | area == "Southeast" | area == "Sullivan" | area == "Northeast")

collapse(sum) allres_* fempop_15to44 fem_*, by(year)

tempfile areas
save  `areas'

******************************************************
*Merge with information on unemployment by health area
clear
use "UnempRateHealthAreas.dta"
merge 1:1 area year using "`PopulationHealthArea'"
browse if _merge == 2
tab year if _merge == 2 /*2018*/
drop if _merge != 3
drop _merge

*Drop the four health areas that show weird jumps in the data or are more likely to have out-of-state abortions
drop if (area == "Hamilton" | area == "Southeast" | area == "Sullivan" | area == "Northeast")

collapse (mean) unemprate [pw=fempop_15to44], by(year)

tempfile unemprate
save `unemprate'

*******************************************************

clear
use `areas'
merge 1:1 year using `unemprate'
drop _merge

*****Create variables of interest*****

*Total abortions
egen ab_total_nomissga_rep = rowtotal(allres_6less allres_7to8 ///
allres_9to10 allres_11to12 allres_13to14 allres_15to16 ///
allres_17to20)

*First-trimester abortions
egen ab_le12 = rowtotal(allres_6less allres_7to8 allres_9to10 ///
allres_11to12)

*Percent of second-trimester abortions
gen frac_ab_gr12_rep = 100*(1-ab_le12/ab_total_nomissga_rep)

*Abortion rate
gen ab_all_nomissga_1544per1k_rep=1000*ab_total_nomissga_rep/fempop_15to44

*Second-trimester abortion rate
gen ab_gr12_1544per1k_rep=1000*(ab_total_nomissga_rep - ab_le12)/fempop_15to44


*I will assign the state name "HealthAreas" to this information to identify it
*easily once I append this information with the reports and CDC data
gen state = "HealthAreas"
rename fempop_15to44 tot1544
drop fem_tot1544

order state year

*Log rates
gen lnab_gr12_1544per1k_rep = ln(ab_gr12_1544per1k_rep)
gen lnab_all_nomissga_1544per1k_rep = ln(ab_all_nomissga_1544per1k_rep)

*Generate shares of female population by age group and race or ethnicity
gl ages 1519 2024 2529 3034 3539 4044 
 
foreach n in $ages{
	gen share`n' = (fem_`n'/tot1544)*100
}

gen hispanic1544 = (fem_hisp1544/tot1544)*100
gen whnohisp1544 = (fem_wanh1544/tot1544)*100
gen black1544 = (fem_ba1544/tot1544)*100

drop fem*

tempfile Health

save "`Health'"

**********************************
**********Health Reports**********
**********************************

tempfile Reports

use "ResidentsDataReadyForAnalysis_updated.dta", clear

*Drop information for Texas
drop if state == "Texas"

keep if frac_ab_gr12~=.

*Log rates
gen lnab_gr12_1544per1k_rep = ln(ab_gr12_1544per1k_rep)
gen lnab_all_nomissga_1544per1k_rep = ln(ab_all_nomissga_1544per1k_rep)

drop if state == "Alabama"

gen newcontrol = 0
replace newcontrol = 1 if (state == "Arizona" | state == "Illinois" | ///
state == "Minnesota" | state == "Missouri" | state == "New Mexico" | ///
state == "New York" | state == "North Carolina" | state == "Oklahoma" | ///
state == "Pennsylvania" | state == "Utah" | state == "Washington" | ///
state == "Wisconsin" | state == "Delaware")

tab state newcontrol

gen group3 = 0 if TN==1
replace group3=1 if newcontrol == 1 /*Control + NC & MO*/

*Keep data of states we use in the main analysis
keep if group3 == 1 | TN == 1

*Keep variables of interest

keep state state_fips year frac_ab_gr12_rep lnab_gr12_1544per1k ///
lnab_all_nomissga_1544per1k_rep share1519 share2024 share2529 share3034 ///
share3539 share4044 black1544 hispanic1544 whnohisp1544 unemprate ///
ab_total_nomissga_rep tot1544 ///
group3 TN ab_all_nomissga_1544per1k_rep ab_gr12_1544per1k_rep

save "`Reports'"

****************************
**********CDC DATA**********
****************************

clear

tempfile CDC

use "CDCDatasetReadyforAnalysis.dta", clear

*Drop states with incomplete data --> California, Louisiana and New Hampshire do
*not have data in 2006

drop if state == "California" | state == "New Hampshire" | state == "Louisiana"

keep if year >= 2010

*Find states with missing information of abortions by gestation age in some years
*between 2010-2016
bysort state: egen maxfrac12_2010 = max(frac_ab_gr12_rep) if year>=2010
su maxfrac12_2010 if maxfrac12_2010!=100

*The following graphs will start in 2010 and will only consider in the analysis
*states with complete data between 2010-2016

bysort state: egen totmaxfrac12_2010 = max(maxfrac12_2010)
tab state totmaxfrac12_2010
drop if totmaxfrac12_2010 >= 100

*Keep states with low interstate travel: the rule will be those will less than 40%
*out-of-state abortions because that includes states with less than 5% less
*than 10%, and less than 20%

keep if out40less == 1

*Keep variables of interest
keep state state_fips year frac_ab_gr12_rep lnab_gr12_1544per1k ///
lnab_all_nomissga_1544per1k_rep share1519 share2024 share2529 share3034 ///
share3539 share4044 black1544 hispanic1544 whnohisp1544 unemprate ///
ab_total_nomissga_rep ///
tot1544 out5less out10less out20less out40less ab_all_nomissga_1544per1k_rep ///
ab_gr12_1544per1k_rep

*Drop observations of states that are in the health department reports
drop if (state == "Arizona" | state == "Illinois" | ///
state == "Minnesota" | state == "Missouri" | state == "New Mexico" | ///
state == "New York" | state == "North Carolina" | state == "Oklahoma" | ///
state == "Pennsylvania" | state == "Utah" | state == "Washington" | ///
state == "Wisconsin" | state == "Tennessee")

*Eliminate states we already decided that should not be included in the analysis
drop if state == "Texas" | state == "Alabama"

tab state

tab year

save "`CDC'"

*Append datasets
clear
use "`Health'"
append using "`Reports'"
append using "`CDC'"

*Identify TN whole state as "TNState" and the selected health areas at "Tennessee"
replace state = "TNState" if state == "Tennessee"

replace state = "Tennessee" if state == "HealthAreas"

replace state_fips = 0 if state == "Tennessee" 
replace state_fips = 99 if state == "TNState"

*Control for comparison group 2 
gen newcontrol = 0
replace newcontrol = 1 if (state == "Arizona" | state == "Illinois" | ///
state == "Minnesota" | state == "Missouri" | state == "New Mexico" | ///
state == "New York" | state == "North Carolina" | state == "Oklahoma" | ///
state == "Pennsylvania" | state == "Utah" | state == "Washington" | ///
state == "Wisconsin" | state == "Delaware")

tab state newcontrol
drop TN
gen TN = 1 if state == "Tennessee"
tab TN

gen TNState = 1 if state == "TNState"
tab TNState

*****Comparison group 2*****

*Refined TN
drop group3
gen group3 = 0 if TN==1
replace group3=1 if newcontrol == 1 /*Control + NC & MO*/

*All TN health areas
gen group3st = 0 if TNState==1
replace group3st=1 if newcontrol == 1 /*Control + NC & MO*/


*****Comparison group 1*****

*Comparison with TN selected areas (refined TN)
gen groupd = 0 if TN == 1
replace groupd = 1 if (group3 == 1 | out20less == 1)
replace groupd = . if (state == "Arizona" | state == "Arkansas" | state == "Illinois" | ///
state == "Indiana" | state == "Pennsylvania" | state == "Virginia")

tab state if groupd == .

*Comparison with all TN
gen groupdst = 0 if TNState == 1
replace groupdst = 1 if (group3st == 1 | out20less == 1)
replace groupdst = . if (state == "Arizona" | state == "Arkansas" | state == "Illinois" | ///
state == "Indiana" | state == "Pennsylvania" | state == "Virginia")

tab state if groupdst == .

********************************************************************************
*Declare panel
xtset state_fips year


*Weights
egen total_ab_allyears_mean=mean(ab_total_nomissga), by(state_fips)
egen total_ab_allyears_rep_mean=mean(ab_total_nomissga_rep), by(state_fips)
egen total_pop1544_mean=mean(tot1544), by(state_fips)


*Label variables for output tables*
label variable frac_ab_gr12_rep "Percent of second trimester abortions"
label variable unemprate "Unemp rate"
label variable ab_gr12_1544per1k_rep "Second-trimester abortion rate"
label variable ab_all_nomissga_1544per1k_rep "Overall abortion rate"
label variable lnab_gr12_1544per1k_rep "Log(Second-trimester abortion rate)"
label variable lnab_all_nomissga_1544per1k_rep "Log(ab rate)"


******Variables of Interest*****

*Refined TN
gen ShareTreated = 0
replace ShareTreated = 7/12 if (state == "Tennessee" & year == 2015)
replace ShareTreated = 12/12 if (state == "Tennessee" & year >= 2016)
replace ShareTreated = . if state == "TNState"

*All TN
gen ShareTreatedSt = 0
replace ShareTreatedSt = 7/12 if (state == "TNState" & year == 2015)
replace ShareTreatedSt = 12/12 if (state == "TNState" & year >= 2016)
replace ShareTreatedSt = . if state == "Tennessee"

*Label state FIPS 
#delimit;
label define state_fips ///
1 "Alabama" ///
2 "Alaska" ///
4 "Arizona" ///
5 "Arkansas" ///
6 "California" ///
8 "Colorado" ///
9 "Connecticut" ///
10 "Delaware" ///
12 "Florida" ///
13 "Georgia" ///
15 "Hawaii" ///
16 "Idaho" ///
17 "Illinois" ///
18 "Indiana" ///
19 "Iowa" ///
20 "Kansas" ///
21 "Kentucky" ///
22 "Louisiana" ///
23 "Maine" ///
24 "Maryland" ///
25 "Massachusetts" ///
26 "Michigan" ///
27 "Minnesota" ///
28 "Mississippi" ///
29 "Missouri" ///
30 "Montana" ///
31 "Nebraska" ///
32 "Nevada" ///
33 "New Hampshire" ///
34 "New Jersey" ///
35 "New Mexico" ///
36 "New York" ///
37 "North Carolina" ///
38 "North Dakota" ///
39 "Ohio" ///
40 "Oklahoma" ///
41 "Oregon" ///
42 "Pennsylvania" ///
44 "Rhode Island" ///
45 "South Carolina" ///
46 "South Dakota" ///
0 "Tennessee" ///
99 "Tennessee State"
48 "Texas" ///
49 "Utah" ///
50 "Vermont" ///
51 "Virginia" ///
53 "Washington" ///
54 "West Virginia" ///
55 "Wisconsin" ///
56 "Wyoming" ///
60 "American Samoa" ///
66 "Guam" ///
69 "Northern Mariana Islands" ///
72 "Puerto Rico" ///
78 "Virgin Islands";
#delimit cr

label values state_fips state_fips
tab state_fips

*Keep information after 2010 --> Delaware does not have information in
*2010

keep if year>=2011

end

preamble2

eststo clear

************************
************************
***Comparison group 1***
************************
************************

***1) Percent of abortions after 12 weeks of gestation***

preserve

keep if (groupdst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
[pweight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [pweight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (groupd == 1 | TN == 1) & year<2017

eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [pweight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*2) Abortion rate after 12 weeks of gestation

preserve

keep if (groupdst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
[pweight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (groupd == 1 | TN == 1) & year<2017

eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore


*3) Abortion rate

preserve

keep if (groupdst == 1 | TNState == 1) & year<2017

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[pweight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (groupd == 1 | TN == 1) & year<2017
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [pweight=total_pop1544_mean], fe vce(cluster state_fips)

restore


*Output file
esttab using "$outputdir\042021_JHERevision_Table4A.tex", ///
keep (ShareTreated) ///
longtable title("Estimated Effects of Tennessee's Mandatory Waiting Period") ///
nodepvars replace nostar b(3) p(2) label nonumbers 

*************************
*****Exact inference*****
*************************

*****Whole TN*****
preamble2

keep if (groupdst == 1 | TNState == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

*a)
xi: xtreg frac_ab_gr12_rep i.year Share ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_1 = _b[Share]

*b) 
xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_2 = _b[Share]

***Log of the abortion rate after 12 weeks of gestation***

*a)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_2 = _b[Share]

***Log of the abortion rate***

*a)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_2 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
forvalues i=1(1)2{
gen share_abgr12_`i' = 0
gen share_lnab_gr12_`i' = 0
gen share_lnab_all_`i' = 0

}

levelsof state_fips, local(loop)
foreach l of local loop{
forvalues i=1(1)2{

*Percent of abortions after 12 weeks of gestation
replace share_abgr12_`i' = share_abgr12_`l'_`i' if state_fips == `l'

*Log of the abortion rate after 12 weeks of gestation
replace share_lnab_gr12_`i' =  share_lnab_gr12_`l'_`i' if state_fips == `l'

*Log of the abortion rate
replace share_lnab_all_`i' = share_lnab_all_`l'_`i' if state_fips == `l'

}
}

collapse (mean) share_abgr12_1 share_abgr12_2 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_all_1 share_lnab_all_2, by(state_fips)

tempfile whole
save `whole'

*****Refined TN*****
preamble2

keep if (groupd == 1 | TN == 1) & year<2017

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_3 = _b[Share]

***Log of the abortion rate after 12 weeks of gestation***

xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_3 = _b[Share]

***Log of the abortion rate***
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_3 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
gen share_abgr12_3 = 0
gen share_lnab_gr12_3 = 0
gen share_lnab_all_3 = 0

levelsof state_fips, local(loop)
foreach l of local loop{
	*Percent of abortions after 12 weeks of gestation
	replace share_abgr12_3 = share_abgr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace share_lnab_gr12_3 =  share_lnab_gr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate
	replace share_lnab_all_3 = share_lnab_all_`l'_3 if state_fips == `l'
}

collapse (mean) share_abgr12_3 share_lnab_gr12_3 share_lnab_all_3, by(state_fips)

tempfile refined
save `refined'

*Merge the two temporal datasets
use `whole'
merge 1:1 state_fips using `refined'

replace state_fips = 0 if state_fips == 99

collapse(sum) share*, by(state_fips)

order state_fips share_abgr12_1 share_abgr12_2 share_abgr12_3 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_gr12_3 share_lnab_all_1 share_lnab_all_2 share_lnab_all_3


************************
************************
***Comparison group 2***
************************
************************

preamble2

eststo clear

*1) Percent of abortions after 12 weeks of gestation

preserve

keep if (group3st == 1 | TNState == 1) 

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (group3 == 1 | TN == 1) 

eststo: xi: xtreg frac_ab_gr12_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

restore

*2) Abortion rate after 12 weeks of gestation

preserve

keep if (group3st == 1 | TNState == 1) 

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (group3 == 1 | TN == 1) 

eststo: xi: xtreg lnab_gr12_1544per1k i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*3) Abortion rate

preserve

keep if (group3st == 1 | TNState == 1) 

drop ShareTreated
rename ShareTreatedSt ShareTreated

*a) TN Whole state without controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

*b) TN Whole state with all controls
eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*c) Refined TN with all controls
preserve

keep if (group3 == 1 | TN == 1) 

eststo: xi: xtreg lnab_all_nomissga_1544per1k_rep i.year ShareTreated ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

restore

*Output file
esttab using "$outputdir\042021_JHERevision_Table4B.tex", ///
keep (ShareTreated) ///
longtable title("Estimated Effects of Tennessee's Mandatory Waiting Period") ///
nodepvars replace nostar b(3) p(2) label nonumbers 

*************************
*****Exact inference*****
*************************

*****Whole TN*****
preamble2

keep if TNState == 1 | group3st == 1

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

*a)
xi: xtreg frac_ab_gr12_rep i.year Share ///
[weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_1 = _b[Share]

*b) 
xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_2 = _b[Share]

***Log of the abortion rate after 12 weeks of gestation***

*a)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_2 = _b[Share]

***Log of the abortion rate***

*a)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
[weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_1 = _b[Share]

*b)
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_2 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
forvalues i=1(1)2{
gen share_abgr12_`i' = 0
gen share_lnab_gr12_`i' = 0
gen share_lnab_all_`i' = 0

}

levelsof state_fips, local(loop)
foreach l of local loop{
forvalues i=1(1)2{

*Percent of abortions after 12 weeks of gestation
replace share_abgr12_`i' = share_abgr12_`l'_`i' if state_fips == `l'

*Log of the abortion rate after 12 weeks of gestation
replace share_lnab_gr12_`i' =  share_lnab_gr12_`l'_`i' if state_fips == `l'

*Log of the abortion rate
replace share_lnab_all_`i' = share_lnab_all_`l'_`i' if state_fips == `l'

}
}

collapse (mean) share_abgr12_1 share_abgr12_2 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_all_1 share_lnab_all_2, by(state_fips)

tempfile whole
save `whole'

*****Refined TN*****
preamble2

keep if TN == 1 | group3 == 1

levelsof state_fips, local(loop)
foreach l of local loop{

gen treat = 0
replace treat = 1 if state_fips == `l'

gen Share = 0
replace Share = 7/12 if (treat == 1 & year == 2015)
replace Share = 12/12 if (treat == 1 & year >= 2016)

***Share of abortions after 12 weeks of gestation***

xi: xtreg frac_ab_gr12_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 hispanic1544 ///
whnohisp1544 unemprate [weight=total_ab_allyears_rep_mean], fe vce(cluster state_fips)

gen share_abgr12_`l'_3 = _b[Share]

***Log of the abortion rate after 12 weeks of gestation***

xi: xtreg lnab_gr12_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_gr12_`l'_3 = _b[Share]

***Log of the abortion rate***
xi: xtreg lnab_all_nomissga_1544per1k_rep i.year Share ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate [weight=total_pop1544_mean], fe vce(cluster state_fips)

gen share_lnab_all_`l'_3 = _b[Share]

drop treat Share
}

*Simulated treatment effects for each equation
gen share_abgr12_3 = 0
gen share_lnab_gr12_3 = 0
gen share_lnab_all_3 = 0

levelsof state_fips, local(loop)
foreach l of local loop{
	*Percent of abortions after 12 weeks of gestation
	replace share_abgr12_3 = share_abgr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate after 12 weeks of gestation
	replace share_lnab_gr12_3 =  share_lnab_gr12_`l'_3 if state_fips == `l'

	*Log of the abortion rate
	replace share_lnab_all_3 = share_lnab_all_`l'_3 if state_fips == `l'
}

collapse (mean) share_abgr12_3 share_lnab_gr12_3 share_lnab_all_3, by(state_fips)

tempfile refined
save `refined'

*Merge the two temporal datasets
use `whole'
merge 1:1 state_fips using `refined'

replace state_fips = 0 if state_fips == 99

collapse(sum) share*, by(state_fips)

order state_fips share_abgr12_1 share_abgr12_2 share_abgr12_3 share_lnab_gr12_1 ///
share_lnab_gr12_2 share_lnab_gr12_3 share_lnab_all_1 share_lnab_all_2 share_lnab_all_3

********************************************
**********SYNTHETIC CONTROL METHOD**********
********************************************

*--> THIS ANALYSIS IS ONLY DONE FOR "REFINED-TENNESSEE"

*All the output obtained from this analysis is saved in a different shared folder
*"C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP," because the blanks in 
*usual path are creating issues to run these instructions
*The graphs are saved in "outputdir"
 
gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

************************
************************
***Comparison group 1***
************************
************************
clear
eststo clear
preamble2

keep if (groupd == 1 | TN == 1) & year<2017
tab year

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

*Specifications for SC graphs in the paper (as of May 23, 2020)

/*
NOTE: EACH ONE OF THE FOLLOWING FIGURES SHOULD BE SAVED MANUALLY. THEY REQUIRE
TO CHANGE THE YTITLE. IT IS ALSO NECESSARY TO ADD A LABEL FOR 2018
(EDIT OR ADD INDIVIDUAL TICK OR LABEL --> ADD --> ADD 2018)

*/

*Percent of abortions in the second-trimester
synth demean_fracabgr12 demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_fracabgr12_CDC&ReportsD_DE", replace) ///
customV(1 1 1 1)

*Log of the second-trimester abortion rate
synth demean_lnabgr12 demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabgr12_CDC&ReportsD_DE", replace) ///
customV(1 1 1 1)

*Log of the abortion rate
synth demean_lnabrate demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabrate_CDC&ReportsD_DE", replace) ///
customV(1 1 1 1)


************************************
**********PLACEBO ANALYSIS**********
************************************
gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

*****Percent of abortions in the second-trimester*****

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_fracabgr12 demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(`l') ///
trperiod(2015) keep("$scm\SCM_fracabgr12_`l'_CDC&ReportsD", replace) ///
customV(1 1 1 1)
}


*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_fracabgr12_`l'_CDC&ReportsD", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_fracabgr12_`l'_CDC&ReportsD", replace
}

use "$scm\SCM_fracabgr12_0_CDC&ReportsD", clear
gl states 2 8 13 15 16 19 21 26 27 29 30 32 34 35 36 37 39 40 41 44 45 46 49 53 ///
54 55

foreach n in $states{
qui merge 1:1 years using "$scm\SCM_fracabgr12_`n'_CDC&ReportsD"
drop _merge
}


**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}


twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Percent of abortions in the second trimester") xlabel(2011(1)2017) ///
legend(on order(27 1) label(27 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot)) ///
yscale(r(-6 6)) ylabel(-6(2)6)
graph export "$outputdir/PlaceboSCM_fracabgr12_CDC&ReportsD_DE.png", replace 


*****Second-trimester abortion rate*****
preamble2

keep if (TN == 1 | groupd == 1) & year<2017

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}
**************

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabgr12 demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabgr12_`l'_CDC&ReportsD", replace) ///
customV(1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabgr12_`l'_CDC&ReportsD", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabgr12_`l'_CDC&ReportsD", replace
}

use "$scm\SCM_lnabgr12_0_CDC&ReportsD", clear
gl states 2 8 13 15 16 19 21 26 27 29 30 32 34 35 36 37 39 40 41 44 45 46 49 53 ///
54 55
foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabgr12_`n'_CDC&ReportsD"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(2nd trimester abortions per 1000 women)")  xlabel(2011(1)2017) ///
legend(on order(27 1) label(27 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot)) ///
yscale(r(-1 1)) ylabel(-1(0.5)1)
graph export "$outputdir/PlaceboSCM_lnabgr12_CDC&ReportsD_DE.png", replace 

*****Overall abortion rate*****
preamble2

keep if (TN == 1 | groupd == 1) & year<2017

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

**************

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabrate demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabrate_`l'_CDC&ReportsD", replace) ///
customV(1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabrate_`l'_CDC&ReportsD", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabrate_`l'_CDC&ReportsD", replace
}

use "$scm\SCM_lnabrate_0_CDC&ReportsD", clear
gl states 2 8 13 15 16 19 21 26 27 29 30 32 34 35 36 37 39 40 41 44 45 46 49 53 ///
54 55
foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabrate_`n'_CDC&ReportsD"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(abortions per 1000 women, ages 15-44)") ///
legend(on order(27 1) label(27 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot)) xlabel(2011(1)2017) ///
yscale(r(-.4 .4)) ylabel(-.4(.2).4)
graph export "$outputdir/PlaceboSCM_lnabrate_CDC&ReportsD_DE.png", replace 


************************
************************
***Comparison group 2***
************************
************************
clear
preamble2

gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

keep if group3 == 1 | TN == 1

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

/*
NOTE: EACH ONE OF THE FOLLOWING FIGURES SHOULD BE SAVED MANUALLY. THEY REQUIRE
TO CHANGE THE YTITLE.)
*/

*Percent of abortions in the second-trimester
synth demean_fracabgr12 demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_fracabgr12_alldemeaned_DE", replace) ///
customV(1 1 1 1)

*Log of the second-trimester abortion rate
synth demean_lnabgr12 demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabgr12_alldemeaned_DE", replace) ///
customV(1 1 1 1)

*Log of the abortion rate
synth demean_lnabrate demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(0) ///
trperiod(2015) figure nested keep("$scm\SCM_lnabrate_alldemeaned_DE", replace) ///
customV(1 1 1 1)


************************************
**********PLACEBO ANALYSIS**********
************************************
clear
eststo clear
preamble2

gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

keep if group3 == 1 | TN == 1

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

*****Percent of abortions in the second-trimester*****
levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_fracabgr12 demean_fracabgr12(2011) ///
demean_fracabgr12(2012) demean_fracabgr12(2013) demean_fracabgr12(2014), trunit(`l') ///
trperiod(2015) keep("$scm\SCM_fracabgr12_`l'_alldemeaned", replace) ///
customV(1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_fracabgr12_`l'_alldemeaned", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_fracabgr12_`l'_alldemeaned", replace
}

use "$scm\SCM_fracabgr12_0_alldemeaned", clear
gl states 4 17 27 29 35 36 37 40 42 49 53 55
foreach n in $states{
qui merge 1:1 years using "$scm\SCM_fracabgr12_`n'_alldemeaned"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}


twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Percent of abortions in the second trimester") xlabel(2011(1)2017) ///
legend(on order(13 1) label(13 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot)) ///
yscale(r(-6 6)) ylabel(-6(2)6)
graph export "$outputdir/PlaceboSCM_fracabgr12_DE.png", replace 

*********Second-trimester abortion rate**********
clear
eststo clear
preamble2

gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

keep if group3 == 1 | TN == 1

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabgr12 demean_lnabgr12(2011) ///
demean_lnabgr12(2012) demean_lnabgr12(2013) demean_lnabgr12(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabgr12_`l'_alldemeaned", replace) ///
customV(1 1 1 1)
}

*The following lines generate the information to create a placebos graph
levelsof state_fips, local(loop)
foreach l of local loop{
use "$scm\SCM_lnabgr12_`l'_alldemeaned", clear
rename _time years
gen tr_effect_`l' = _Y_treated - _Y_synthetic
keep years tr_effect_`l'
drop if missing(years)
save "$scm\SCM_lnabgr12_`l'_alldemeaned", replace
}

use "$scm\SCM_lnabgr12_0_alldemeaned", clear
gl states 4 17 27 29 35 36 37 40 42 49 53 55
foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabgr12_`n'_alldemeaned"
drop _merge
}

**********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 
local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(2nd trimester abortions per 1000 women)") xlabel(2011(1)2017) ///
legend(on order(13 1) label(13 "Tennessee") label(1 "control states"))  xline(2015, lpattern(dot)) ///
yscale(r(-1 1)) ylabel(-1(.5)1)
graph export "$outputdir/PlaceboSCM_lnabgr12_DE.png", replace 


**********Log of the abortion rate*********
clear
eststo clear
preamble2

gl scm "C:\Users\MayraBelinda\Dropbox\ResearchProjects\SCM_MWP"

keep if group3 == 1 | TN == 1

tsset state_fips year

gen fracabgr12 = frac_ab_gr12_rep
gen lnabgr12 = lnab_gr12_1544per1k_rep
gen lnabrate = lnab_all_nomissga_1544per1k_rep

gl vars fracabgr12 lnabgr12 lnabrate ///
share1519 share2024 share2529 share3034 share3539 share4044 black1544 ///
hispanic1544 whnohisp1544 unemprate

foreach n in $vars{
sort state_fips year
bysort state_fips: egen mean_`n' = mean(`n') if year<=2015
bysort state_fips: replace mean_`n' = mean_`n'[_n-1] if _n>=2
gen demean_`n' = `n'-mean_`n'
}

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

levelsof state_fips, local(loop)
foreach l of local loop{
synth demean_lnabrate demean_lnabrate(2011) ///
demean_lnabrate(2012) demean_lnabrate(2013) demean_lnabrate(2014), trunit(`l') ///
trperiod(2015) figure keep("$scm\SCM_lnabrate_`l'_alldemeaned", replace) ///
customV(1 1 1 1)
}
 
gl states0 0 4 17 27 29 35 36 37 40 42 49 53 55
foreach n in $states0{
use "$scm\SCM_lnabrate_`n'_alldemeaned", clear
rename _time years
gen tr_effect_`n' = _Y_treated - _Y_synthetic
keep years tr_effect_`n'
drop if missing(years)
save "$scm\SCM_lnabrate_`n'_alldemeaned", replace
}

use "$scm\SCM_lnabrate_0_alldemeaned", clear
gl states 4 17 27 29 35 36 37 40 42 49 53 55
foreach n in $states{
qui merge 1:1 years using "$scm\SCM_lnabrate_`n'_alldemeaned"
drop _merge
}

***********
set scheme s1color 
grstyle init
grstyle set plain, nogrid 

local lp 
foreach n in $states{
local lp `lp' line tr_effect_`n' years, lcolor(gs12) ||
}

twoway `lp' || line tr_effect_0 years, ///
lcolor(black) lwidth(medthick) legend(off) xline(2015, lpattern(shortdash) lcolor(black) lwidth(vthin)) ///
ytitle("Log(Abortions per 1000 women, ages 15-44)") xlabel(2011(1)2017) ///
legend(on order(13 1) label(13 "Tennessee") label(1 "control states")) xline(2015, lpattern(dot)) ///
yscale(r(-.4 .4)) ylabel(-.4(.2).4)
graph export "$outputdir/PlaceboSCM_lnabrate_DE.png", replace 


****************************************************************************
****************************************************************************
****************************************************************************
************************ANALYSIS USING HEALTH AREA DATA*********************
****************************************************************************
****************************************************************************
****************************************************************************

clear all
set more off

cd "C:\Users\MayraBelinda\Dropbox\ResearchProjects\Reassessing the Effects of Mandatory Waiting Periods\Analysis\StateAnalysisNewData\StatesDataset"
gl outputdir "C:\Users\MayraBelinda\Dropbox\ResearchProjects\Reassessing the Effects of Mandatory Waiting Periods\Draft\GraphsResubmissionJHE"

tempfile Health

*Generate population by health region

use "FemPop1544_counties.dta", clear

tempfile PopulationHealthArea

merge m:1 countyid using "countybyhealthareaTN.dta"
browse if _merge == 1
browse if _merge == 3
drop if _merge!=3
drop _merge

sort healtharea year

collapse(sum) fempop_15to44, by(healtharea year)

rename healtharea area

save "`PopulationHealthArea'"

clear
import excel using "TNHealthAreasData.xlsx", sheet(Data) firstrow

merge 1:1 area year using "`PopulationHealthArea'"
drop if year<2010
browse if _merge == 1
drop if _merge != 3
drop _merge

merge 1:1 area year using "UnempRateHealthAreas.dta"
drop _merge

merge 1:1 area year using "PopSharesFem1544_HealthAreas.dta"
drop if _merge != 3
drop _merge

*****Create variables of interest*****

*Total abortions
egen ab_total_nomissga_rep = rowtotal(allres_6less allres_7to8 ///
allres_9to10 allres_11to12 allres_13to14 allres_15to16 ///
allres_17to20)

*First-trimester abortions
egen ab_le12 = rowtotal(allres_6less allres_7to8 allres_9to10 ///
allres_11to12)

*Percent of second-trimester abortions
gen frac_ab_gr12_rep = 100*(1-ab_le12/ab_total_nomissga_rep)

*Abortion rate
gen ab_all_nomissga_1544per1k_rep=1000*ab_total_nomissga_rep/fempop_15to44

*Second-trimester abortion rate
gen ab_gr12_1544per1k_rep=1000*(ab_total_nomissga_rep - ab_le12)/fempop_15to44


rename fempop_15to44 tot1544

order area year

*Log rates
gen lnab_gr12_1544per1k_rep = ln(ab_gr12_1544per1k_rep)
gen lnab_all_nomissga_1544per1k_rep = ln(ab_all_nomissga_1544per1k_rep)

egen total_ab_allyears_mean=mean(ab_total_nomissga), by(area)
egen total_ab_allyears_rep_mean=mean(ab_total_nomissga_rep), by(area)
egen total_pop1544_mean=mean(tot1544), by(area)

gen areacode = .
replace areacode = 1 if area == "Northeast"
replace areacode = 2 if area == "East"
replace areacode = 3 if area == "Knox"
replace areacode = 4 if area == "Upper Cumberland"
replace areacode = 5 if area == "Southeast"
replace areacode = 6 if area == "Hamilton"
replace areacode = 7 if area == "Davidson"
replace areacode = 8 if area == "Mid-Cumberland"
replace areacode = 9 if area == "South Central"
replace areacode = 10 if area == "Northwest"
replace areacode = 11 if area == "Southwest"
replace areacode = 12 if area == "Shelby"
replace areacode = 13 if area == "Madison"
replace areacode = 14 if area == "Sullivan"

label define areacode 1 "Northeast" 2 "East" 3 "Knox" 4 " Upper Cumberland" 5 "Southeast" ///
6 "Hamilton" 7 "Davidson" 8 "Mid-Cumberland" 9 "South Central" 10 "Northwest" ///
11 "Southwest" 12 "Shelby" 13 "Madison" 14 "Sullivan"

label values areacode areacode

tab areacode

label var frac_ab_gr12_rep "Percent of second-trimester abortions"
label var lnab_gr12_1544per1k_rep "Log(2nd trimester abortions per 1000 women)"
label var lnab_all_nomissga_1544per1k_rep "Log(Abortions per 1000 women, ages 15-44)"

xtset areacode year

********************************************************************************
**************FIGURES OF SELECTED HEALTH AREAS, GROUPED BY COLOR****************
********************************************************************************

preserve
drop if (area == "Hamilton" | area == "Southeast" | area == "Sullivan" | area == "Northeast")

set scheme plottigblind 

*****Percent of abortions in the second trimester*****
*Excluding Hamilton, Southeast, Sullivan, and Northeast
xtline frac_ab_gr12_rep, overlay legend(position(6) col(4) order(9 4 2 5 1 8 10 7 3 6)) ///
plot9(lc(navy)lp(solid)) plot4(lc(navy)lp(dash)) plot2(lc(navy)lp(dot)) ///
plot5(lc(dkgreen)lp(dash)) plot1(lc(dkgreen)lp(dot))  ///
plot8(lc(maroon)lp(solid)) plot10(lc(maroon)lp(dash)) plot7(lc(maroon)lp(dot)) plot3(lc(maroon)lp(longdash)) plot6(lc(maroon)lp("-.-")) ///
ytitle(Percent of abortions in the second trimester) ylabel(0(5)20) xlabel(2010(1)2017)
graph export "$outputdir\2ndtrimab_HealthAreasbyColors_4exclusions.png", replace

*****Second trimester abortion rate*****
*Excluding Hamilton, Southeast, Sullivan, and Northeast
xtline lnab_gr12_1544per1k_rep, overlay legend(position(6) col(4) order(9 4 2 5 1 8 10 7 3 6)) ///
plot9(lc(navy)lp(solid)) plot4(lc(navy)lp(dash)) plot2(lc(navy)lp(dot)) ///
plot5(lc(dkgreen)lp(dash)) plot1(lc(dkgreen)lp(dot))  ///
plot8(lc(maroon)lp(solid)) plot10(lc(maroon)lp(dash)) plot7(lc(maroon)lp(dot)) plot3(lc(maroon)lp(longdash)) plot6(lc(maroon)lp("-.-")) ///
ytitle(Log(2nd trimester abortions per 1000 women)) ylabel(-1.5(0.5)1) xlabel(2010(1)2017)
graph export "$outputdir\2ndtrimabrate_HealthAreasbyColors_4exclusions.png", replace

*****Total abortion rate*****
*Excluding Hamilton, Southeast, Sullivan, and Northeast
xtline lnab_all_nomissga_1544per1k_rep, overlay legend(position(6) col(4) order(9 4 2 5 1 8 10 7 3 6)) ///
plot9(lc(navy)lp(solid)) plot4(lc(navy)lp(dash)) plot2(lc(navy)lp(dot)) ///
plot5(lc(dkgreen)lp(dash)) plot1(lc(dkgreen)lp(dot))  ///
plot8(lc(maroon)lp(solid)) plot10(lc(maroon)lp(dash)) plot7(lc(maroon)lp(dot)) plot3(lc(maroon)lp(longdash)) plot6(lc(maroon)lp("-.-")) ///
ytitle(Log(Abortions per 1000 women, ages 15-44)) ylabel(1(0.5)3.5) xlabel(2010(1)2017)
graph export "$outputdir\abrate_HealthAreasbyColors_4exclusions.png", replace

restore

********************************************************************************
***********************FIGURES OF SINGLE COUNTY HEALTH AREAS********************
*****************************KNOX, SHELBY, AND DAVIDSON*************************
********************************************************************************

/*
preserve
keep if (area == "Shelby" | area == "Davidson" | area == "Knox") 

*****Percent of abortions in the second trimester*****
xtline frac_ab_gr12_rep, overlay legend(position(6) col(3) order(3 2 1)) ///
plot3(lc(navy)lp(solid)) plot2(lc(maroon)lp(dash)) plot1(lc(green)lp("-.-")) ///
ytitle(Percent of abortions in the second trimester) ylabel(0(5)20) xlabel(2010(1)2017)
graph export "$outputdir\2ndtrimab_SingleCountyAreas.png", replace

*****Second trimester abortion rate*****
xtline lnab_gr12_1544per1k_rep, overlay legend(position(6) col(3) order(3 2 1)) ///
plot3(lc(navy)lp(solid)) plot2(lc(maroon)lp(dash)) plot1(lc(green)lp("-.-")) ///
ytitle(Log(2nd trimester abortions per 1000 women)) ylabel(-1.5(0.5)1) xlabel(2010(1)2017)
graph export "$outputdir\2ndtrimabrate_SingleCountyAreas.png", replace

*****Total abortion rate*****
xtline lnab_all_nomissga_1544per1k_rep, overlay legend(position(6) col(3) order(3 2 1)) ///
plot3(lc(navy)lp(solid)) plot2(lc(maroon)lp(dash)) plot1(lc(green)lp("-.-")) ///
ytitle(Log(Abortions per 1000 women, ages 15-44)) ylabel(0(0.5)3.5) xlabel(2010(1)2017)
graph export "$outputdir\abrate_SingleCountyAreas.png", replace

restore
*/

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

*****Percent of abortions in the second trimester*****
preserve
keep if (area == "Shelby" | area == "Davidson" | area == "Knox") 
collapse frac_ab_gr12_rep [weight=ab_total_nomissga_rep], by(area year)
separate frac_ab_gr12_rep, by(area) veryshortlabel
twoway scatteri 0 2014.5 20 2014.5 20 2015.5 0 2015.5, recast(area) color(gray*0.2) || ///
scatteri 0 2015.5 20 2015.5 20 2017.5 0 2017.5, recast(area) color(gray*0.3) || /// 
scatter frac_ab_gr12_rep3 year, ms(Oh) mcolor(navy) || ///
scatter frac_ab_gr12_rep1 year, ms(Dh) mcolor(maroon) || ///
scatter frac_ab_gr12_rep2 year, ms(Th) mcolor(dkgreen) legend(lab(3 "Shelby") lab(4 "Davidson") lab(5 "Knox") order(3 4 5) position(6) col(3)) ytitle(Percent of abortions in the second trimester) yscale(r(0 2)) ylabel(0(5)20) xlabel(2010(1)2017) ///
text(18 2015 "Partially" "affected", size(small)) ///
text(18 2016 "         Fully", size(small)) ///
text(18 2017 "affected      ", size(small))
graph export "$outputdir\2ndtrimab_SingleCountyAreas.png", replace
restore

*****Log of abortions in the second trimester*****
preserve
keep if (area == "Shelby" | area == "Davidson" | area == "Knox") 
collapse lnab_gr12_1544per1k_rep [weight=tot1544], by(area year)
separate lnab_gr12_1544per1k_rep, by(area) veryshortlabel
twoway scatteri -2 2014.5 2 2014.5 2 2015.5 -2 2015.5, recast(area) nodropbase color(gray*0.2) || ///
scatteri -2 2015.5 2 2015.5 2 2017.5 -2 2017.5, recast(area) nodropbase color(gray*0.3) || ///
scatter lnab_gr12_1544per1k_rep3 year, ms(Oh) mcolor(navy) || ///
scatter lnab_gr12_1544per1k_rep1 year, ms(Dh) mcolor(maroon) || ///	
scatter lnab_gr12_1544per1k_rep2 year, ms(Th) mcolor(dkgreen) legend(lab(3 "Shelby") lab(4 "Davidson") lab(5 "Knox") order(3 4 5) position(6) col(3)) ytitle(Log(2nd trimester abortions per 1000 women)) yscale(r(-2 2)) ylabel(-2(.5)2) xlabel(2010(1)2017) ///
text(1.5 2015 "Partially" "affected", size(small)) ///
text(1.5 2016 "        Fully", size(small)) ///
text(1.5 2017 "affected     ", size(small))
graph export "$outputdir\2ndtrimabrate_SingleCountyAreas.png", replace
restore

*****Log abortions per 1000 women*****
preserve
keep if (area == "Shelby" | area == "Davidson" | area == "Knox") 
collapse lnab_all_nomissga_1544per1k_rep [weight=tot1544], by(area year) 
separate lnab_all_nomissga_1544per1k_rep, by(area) veryshortlabel
twoway scatteri 1 2014.5 3.5 2014.5 3.5 2015.5 1 2015.5, recast(area) color(gray*0.2) || ///
scatteri 1 2015.5 3.5 2015.5 3.5 2017.5 1 2017.5, recast(area) color(gray*0.3) || ///
scatter lnab_all_nomissga_1544per1k_rep3 year, ms(Oh) mcolor(navy) || ///
scatter lnab_all_nomissga_1544per1k_rep1 year, ms(Dh) mcolor(maroon) || ///
scatter lnab_all_nomissga_1544per1k_rep2 year, ms(Th) mcolor(dkgreen) legend(lab(3 "Shelby") lab(4 "Davidson") lab(5 "Knox") order(3 4 5) position(6) col(3)) ytitle(Log (Abortions per 1000 women, ages 15-44)) yscale(r(1 3.5)) ylabel(1(.5)3.5) xlabel(2010(1)2017) ///
text(3.3 2015 "Partially" "affected", size(small)) ///
text(3.3 2016 "        Fully", size(small)) ///
text(3.3 2017 "affected     ", size(small))
graph export "$outputdir\abrate_SingleCountyAreas.png", replace
restore



********************************************************************************
********FIGURE OF THE ABORTION RATE BY HEALTH AREA, INCLUDING ALL AREAS*********
********************************************************************************
set scheme s1color

xtline lnab_all_nomissga_1544per1k_rep, overlay legend(off) ///
ytitle("Log(Abortions per 1000 women, ages 15-44)") ylabel(0(0.5)3.5) ///
plot1(lc(cranberry)lp(solid)) plot2(lc(bluishgray)lp(solid)) plot3(lc(bluishgray)lp(solid)) ///
plot4(lc(bluishgray)lp(solid)) plot5(lc(navy)lp(solid)) plot6(lc(navy)lp(dash)) ///
plot7(lc(bluishgray)lp(solid)) plot8(lc(bluishgray)lp(solid)) plot9(lc(bluishgray)lp(solid)) ///
plot10(lc(bluishgray)lp(solid)) plot11(lc(bluishgray)lp(solid)) plot12(lc(bluishgray)lp(solid)) ///
plot13(lc(bluishgray)lp(solid)) plot14(lc(cranberry)lp(dash)) ///
text(2.786003 2017.4 "Shelby", size(vsmall)) ///
text(2.297172 2017.4 "Davidson", size(vsmall)) ///
text(1.954483 2017.4 "Madison", size(vsmall)) ///
text(1.880964 2017.4 "Knox", size(vsmall)) ///
text(1.6 2017.4 "Southwest", size(vsmall)) ///
text(1.5 2017.5 "Mid-Cumberland", size(vsmall)) ///
text(1.37 2017.2 "East", size(vsmall)) ///
text(1.267963 2017.3 "Sullivan", size(vsmall) color(cranberry)) ///
text(1.170252 2017.5 "Northwest", size(vsmall)) ///
text(1.09 2017.5 "South Central", size(vsmall)) ///
text(.95 2017.4 "Northeast", size(vsmall) color(cranberry)) ///
text(0.75 2017.5 "Upper Cumberland", size(vsmall)) ///
text(0.4849771 2017.4 "Southeast", size(vsmall) color(navy)) ///
text(0.2241834 2017.4 "Hamilton", size(vsmall) color(navy)) 
graph export "$outputdir\lnabrate_healthregions.png", replace



*********************************************************
********FIGURES BY DISTANCE TO NEAREST PROVIDER**********
*********************************************************

*Three regions, excluding Hamilton, Southeast, Sullivan and Northeast
gen threeregions_new = 0

*Single county areas with a provider in the county
replace threeregions_new = 1 if (areacode == 12 | areacode == 7 | areacode == 3)

*Areas where most people are in counties somewhat close (50 mi) to clinics
replace threeregions_new = 2 if (areacode == 8 | areacode == 2)

*Other areas where most people are far from clinics
replace threeregions_new = 3 if (areacode == 11 | areacode == 13 | areacode == 10 | areacode == 4 | areacode == 9)

tab area threeregions_new

label define threeregions_new 1 "Provider in county" 2 "Provider <50 miles away" 3 "Provider >50 miles away"

label values threeregions_new threeregions_new
tab threeregions_new

collapse (sum) ab_total_nomissga_rep ab_le12 tot1544, by(threeregions_new year)

drop if threeregions_new == 0

*Percent of second-trimester abortions
gen frac_ab_gr12_rep = 100*(1-ab_le12/ab_total_nomissga_rep)

*Abortion rate
gen ab_all_nomissga_1544per1k_rep=1000*ab_total_nomissga_rep/tot1544

*Second-trimester abortion rate
gen ab_gr12_1544per1k_rep=1000*(ab_total_nomissga_rep - ab_le12)/tot1544

order threeregions year

*Log rates
gen lnab_gr12_1544per1k_rep = ln(ab_gr12_1544per1k_rep)
gen lnab_all_nomissga_1544per1k_rep = ln(ab_all_nomissga_1544per1k_rep)

label var frac_ab_gr12_rep "Percent of abortions in the second trimester"
label var lnab_gr12_1544per1k_rep "Log(2nd trimester abortions per 1000 women)"
label var lnab_all_nomissga_1544per1k_rep "Log(Abortions per 1000 women, ages 15-44)"

xtset threeregions_new year

/*
set scheme plottigblind

xtline frac_ab_gr12_rep, overlay legend(position(6) cols(3) order(1 2 3)) ///
plot1(lc(navy)) plot2(lc(dkgreen)) plot3(lc(maroon)) ylabel(0(5)20) xlabel(2010(1)2017)
graph export "$outputdir\2ndtrimab_ThreeRegions_4exclusions.png", replace

xtline lnab_gr12_1544per1k_rep, overlay legend(position(6) cols(3) order(1 2 3))  ///
plot1(lc(navy)) plot2(lc(dkgreen)) plot3(lc(maroon)) ylabel(-1.5(0.5)1) xlabel(2010(1)2017)
graph export "$outputdir\2ndtrimabrate_ThreeRegions_4exclusions.png", replace

xtline lnab_all_nomissga_1544per1k_rep, overlay legend(position(6) cols(3) order(1 2 3))  ///
plot1(lc(navy)) plot2(lc(dkgreen)) plot3(lc(maroon)) ylabel(0(0.5)3.5) xlabel(2010(1)2017)
graph export "$outputdir\abrate_ThreeRegions_4exclusions.png", replace

*/

set scheme s1color 
grstyle init
grstyle set plain, nogrid 

*****Percent of abortions in the second trimester*****
preserve
collapse frac_ab_gr12_rep [weight=ab_total_nomissga_rep], by(threeregions_new year)
drop if threeregions_new == 0
separate frac_ab_gr12_rep, by(threeregions_new) veryshortlabel
twoway scatteri 0 2014.5 20 2014.5 20 2015.5 0 2015.5, recast(area) color(gray*0.2) || ///
scatteri 0 2015.5 20 2015.5 20 2017.5 0 2017.5, recast(area) color(gray*0.3) || /// 
scatter frac_ab_gr12_rep1 year, ms(Oh) mcolor(navy) || ///
scatter frac_ab_gr12_rep2 year, ms(Dh) mcolor(maroon) || ///
scatter frac_ab_gr12_rep3 year, ms(Th) mcolor(dkgreen) legend(lab(3 "Provider in county") lab(4 "Provider <50 miles away") lab(5 "Provider >50 miles away") order(3 4 5) position(6) col(1)) ytitle(Percent of abortions in the second trimester) yscale(r(0 20)) ylabel(0(5)20) xlabel(2010(1)2017) ///
text(18 2015 "Partially" "affected", size(small)) ///
text(18 2016 "         Fully", size(small)) ///
text(18 2017 "affected      ", size(small))
graph export "$outputdir\2ndtrimab_ThreeRegions_4exclusions.png", replace
restore

*****Log of abortions in the second trimester*****
preserve
collapse lnab_gr12_1544per1k_rep [weight=tot1544], by(threeregions_new year)
drop if threeregions_new == 0
separate lnab_gr12_1544per1k_rep, by(threeregions_new) veryshortlabel
twoway scatteri -2 2014.5 2 2014.5 2 2015.5 -2 2015.5, recast(area) nodropbase color(gray*0.2) || ///
scatteri -2 2015.5 2 2015.5 2 2017.5 -2 2017.5, recast(area) nodropbase color(gray*0.3) || ///
scatter lnab_gr12_1544per1k_rep1 year, ms(Oh) mcolor(navy) || ///
scatter lnab_gr12_1544per1k_rep2 year, ms(Dh) mcolor(maroon) || ///	
scatter lnab_gr12_1544per1k_rep3 year, ms(Th) mcolor(dkgreen) legend(lab(3 "Provider in county") lab(4 "Provider <50 miles away") lab(5 "Provider >50 miles away") order(3 4 5) position(6) col(1)) ytitle(Log(2nd trimester abortions per 1000 women)) yscale(r(-2 2)) ylabel(-2(.5)2) xlabel(2010(1)2017) ///
text(1.5 2015 "Partially" "affected", size(small)) ///
text(1.5 2016 "        Fully", size(small)) ///
text(1.5 2017 "affected     ", size(small))
graph export "$outputdir\2ndtrimabrate_ThreeRegions_4exclusions.png", replace
restore

*****Log abortions per 1000 women*****
preserve
collapse lnab_all_nomissga_1544per1k_rep [weight=tot1544], by(threeregions_new year) 
drop if threeregions_new == 0
separate lnab_all_nomissga_1544per1k_rep, by(threeregions_new) veryshortlabel
twoway scatteri 1 2014.5 3.5 2014.5 3.5 2015.5 1 2015.5, recast(area) color(gray*0.2) || ///
scatteri 1 2015.5 3.5 2015.5 3.5 2017.5 1 2017.5, recast(area) color(gray*0.3) || ///
scatter lnab_all_nomissga_1544per1k_rep1 year, ms(Oh) mcolor(navy) || ///
scatter lnab_all_nomissga_1544per1k_rep2 year, ms(Dh) mcolor(maroon) || ///
scatter lnab_all_nomissga_1544per1k_rep3 year, ms(Th) mcolor(dkgreen) legend(lab(3 "Provider in county") lab(4 "Provider <50 miles away") lab(5 "Provider >50 miles away") order(3 4 5)  position(6) col(1)) ytitle(Log (Abortions per 1000 women, ages 15-44)) yscale(r(1 3.5)) ylabel(1(.5)3.5) xlabel(2010(1)2017) ///
text(3.3 2015 "Partially" "affected", size(small)) ///
text(3.3 2016 "        Fully", size(small)) ///
text(3.3 2017 "affected     ", size(small))
graph export "$outputdir\abrate_ThreeRegions_4exclusions.png", replace
restore
