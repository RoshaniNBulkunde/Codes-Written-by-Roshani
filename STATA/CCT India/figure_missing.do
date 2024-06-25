/* 
* Graphs for missing observations
This file is to check parallel trend graphs for outcome variables and mother's characterstics
*Roshani Bulkunde */

clear all
set more off
cap log close

* nfhs data
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

* Output directory
gl outputdir "C:\Users\rosha\Dropbox (GaTech)\CCT India\output\figures\parallel_birth order 1,2"


* Keep the sample with birth order 1,2
drop if yob==2021 
keep if bord==1 | bord==2 
drop if bord==.

* Create eligible group=1 if first born
gen  eligible=0
replace eligible=1 if bord==1

/*---------------------------------------------------------------------------*
              * Outcome variables *
*---------------------------------------------------------------------------*/

* figure 11.1
preserve

gen preg_regist_miss=0
replace preg_regist_miss=1 if preg_regist==.

collapse preg_regist_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter preg_regist_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Pregnancy Registration Missing) ylabel(0(0.1)1)  xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.1.pdf", as(pdf) replace 

restore


* figure 11.2
preserve

gen anc_visit_miss=0
replace anc_visit_miss=1 if anc_visit==.

collapse anc_visit_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter anc_visit_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Atleast one ANC visit missing) ylabel(0(0.1)1)   xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.974 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.2.pdf", as(pdf) replace 

restore


*figure 11.3
preserve

gen tot_anc4_miss=0
replace tot_anc4_miss=1 if tot_anc4==.

collapse tot_anc4_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc4_miss, by(eligible) veryshortlabel
twoway scatteri .75 2016.5 .75 2017.5 .75 2018.5 .75 2019.5, recast(area) color(gray*0.2) || ///
scatteri .75 2017.5 .75 2018.5 .75 2019.5 .75 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc4_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc4_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Four or more ANC visit missing) ylabel(0(0.1)0.75)   xlabel(2010(1)2020) ///
text(0.735 2017 "Partially" "affected", size(small)) ///
text(0.736 2018.5 "         Fully", size(small)) ///
text(0.73 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.3.pdf", as(pdf) replace 

restore


* figure 11.4
preserve

gen tot_anc9_miss=0
replace tot_anc9_miss=1 if tot_anc9==.

collapse tot_anc9_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9_miss, by(eligible) veryshortlabel
twoway scatteri .75 2016.5 .75 2017.5 .75 2018.5 .75 2019.5, recast(area) color(gray*0.2) || ///
scatteri .75 2017.5 .75 2018.5 .75 2019.5 .75 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc9_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc9_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Total ANC visits missing) ylabel(0(0.1)0.75)   xlabel(2010(1)2020) ///
text(5.7 2017 "Partially" "affected", size(small)) ///
text(5.72 2018.5 "         Fully", size(small)) ///
text(5.65 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.4.pdf", as(pdf) replace 

restore

* figure 11.5
preserve

gen del_healthf_miss=0
replace del_healthf_miss=1 if del_healthf==.

collapse del_healthf_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf_miss, by(eligible) veryshortlabel
twoway scatteri 0.01 2016.5 0.01 2017.5 0.01 2018.5 0.01 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.01 2017.5 0.01 2018.5 0.01 2019.5 0.01 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter del_healthf_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Delivery at health facility missing) ylabel(0(0.002)0.01)   xlabel(2010(1)2020) ///
text(0.008 2017 "Partially" "affected", size(small)) ///
text(0.008 2018.5 "         Fully", size(small)) ///
text(0.0075 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.5.pdf", as(pdf) replace 

restore


* figure 11.6
preserve

gen ch_firstvac_miss=0
replace ch_firstvac_miss=1 if ch_firstvac==.

collapse ch_firstvac_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of required vaccines missing) ylabel(0(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.6.pdf", as(pdf) replace 

restore


* figure 11.21
preserve

gen ch_firstvac_v1_miss=0
replace ch_firstvac_v1_miss=1 if ch_firstvac_v1==.
collapse ch_firstvac_v1_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_v1_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_v1_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_v1_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of required vaccines missing-hepb and opvb) ylabel(0(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.21.pdf", as(pdf) replace 

restore


* figure 11.22
preserve

gen ch_firstvac_card_miss=0
replace ch_firstvac_card_miss=1 if ch_firstvac_card==.
collapse ch_firstvac_card_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of required vaccines missing by card) ylabel(0(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.22.pdf", as(pdf) replace 

restore


* figure 11.23
preserve

gen ch_firstvac_v1card_miss=0
replace ch_firstvac_v1card_miss=1 if ch_firstvac_v1card==.
collapse ch_firstvac_v1card_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_v1card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_v1card_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_v1card_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of required vaccines missing by card) ylabel(0(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.23.pdf", as(pdf) replace 

restore


* figure 11.7
preserve

gen ch_anyvac_miss=0
replace ch_anyvac_miss=1 if ch_anyvac==.

collapse ch_anyvac_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_anyvac_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_anyvac_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_anyvac_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of any required vaccines missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.978 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.7.pdf", as(pdf) replace 

restore

* figure 11.8
preserve

gen ch_bcg_miss=0
replace ch_bcg_miss=1 if ch_bcg==.

collapse ch_bcg_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of BCG missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.8.pdf", as(pdf) replace 

restore


* figure 11.24
preserve

gen ch_bcg_card_miss=0
replace ch_bcg_card_miss=1 if ch_bcg_card==.
collapse ch_bcg_card_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of BCG missing by card) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.24.pdf", as(pdf) replace 

restore


* figure 11.9
preserve

gen ch_hep1_miss=0
replace ch_hep1_miss=1 if ch_hep1==.
collapse ch_hep1_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of Hepatitis-B missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.9.pdf", as(pdf) replace 

restore


* figure 11.25
preserve

gen ch_hep1_card_miss=0
replace ch_hep1_card_miss=1 if ch_hep1_card==.
collapse ch_hep1_card_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_card_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_card_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of Hepatitis-B by card missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.25.pdf", as(pdf) replace 

restore


* figure 11.26
preserve

gen ch_hepb_miss=0
replace ch_hepb_miss=1 if ch_hepb==.
collapse ch_hepb_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hepb_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hepb_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hepb_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Hepatitis-B at birth missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.26.pdf", as(pdf) replace 

restore


* figure 11.27
preserve

gen ch_hepb_card_miss=0
replace ch_hepb_card_miss=1 if ch_hepb_card==.
collapse ch_hepb_card_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hepb_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hepb_card_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hepb_card_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Hepatitis-B at birth by card missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.27.pdf", as(pdf) replace 

restore


* figure 11.10
preserve

gen ch_dpt1_miss=0
replace ch_dpt1_miss=1 if ch_dpt1==.

collapse ch_dpt1_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.10.pdf", as(pdf) replace 

restore


* figure 11.28
preserve

gen ch_dpt1_card_miss=0
replace ch_dpt1_card_miss=1 if ch_dpt1_card==.
collapse ch_dpt1_card_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by card missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.28.pdf", as(pdf) replace 

restore


* figure 11.11
preserve

gen ch_opv1_miss=0
replace ch_opv1_miss=1 if ch_opv1==.

collapse ch_opv1_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of OPV missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.11.pdf", as(pdf) replace 

restore


* figure 11.29
preserve

gen ch_opv1_card_miss=0
replace ch_opv1_card_miss=1 if ch_opv1_card==.
collapse ch_opv1_card_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of OPV by card missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.29.pdf", as(pdf) replace 

restore


* figure 11.30
preserve

gen ch_opvb_card_miss=0
replace ch_opvb_card_miss=1 if ch_opvb_card==.
collapse ch_opvb_card_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opvb_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opvb_card_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opvb_card_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(OPV at birth by card missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.30.pdf", as(pdf) replace 

restore


* figure 11.31
preserve

gen ch_opvb_miss=0
replace ch_opvb_miss=1 if ch_opvb==.
collapse ch_opvb_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opvb_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opvb_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opvb_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(OPV at birth missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.31.pdf", as(pdf) replace 

restore

*******************************************************************************************************************
*-------Secondary outcome variables----*

* figure 11.12
preserve

gen m_anemia_miss=0
replace m_anemia_miss=1 if m_anemia==.

collapse m_anemia_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_anemia_miss, by(eligible) veryshortlabel
twoway scatteri 0.1 2016.5 0.1 2017.5 0.1 2018.5 0.1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.1 2017.5 0.1 2018.5 0.1 2019.5 0.1 2020.5, recast(area) color(gray*0.3) || ///
scatter m_anemia_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter m_anemia_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother Anemic missing") ylabel(0(0.05)0.1) xlabel(2010(1)2020) ///
text(0.088 2017 "Partially" "affected", size(small)) ///
text(0.088 2018.5 "         Fully", size(small)) ///
text(0.087 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.12.pdf", as(pdf) replace 

restore

* figure 11.13
preserve

gen iron_spplm_miss=0
replace iron_spplm_miss=1 if iron_spplm==.

collapse iron_spplm_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate iron_spplm_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter iron_spplm_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter iron_spplm_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("During pregnancy, given or bought iron tablets/syrup") ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.13.pdf", as(pdf) replace 

restore


* figure 11.14
preserve

gen dur_iron_spplm_miss=0
replace dur_iron_spplm_miss=1 if dur_iron_spplm==.

collapse dur_iron_spplm_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate dur_iron_spplm_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter dur_iron_spplm_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter dur_iron_spplm_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Days iron tablets or syrup taken_missing") ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.8 2017 "Partially" "affected", size(small)) ///
text(0.8 2018.5 "         Fully", size(small)) ///
text(0.75 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.14.pdf", as(pdf) replace 

restore

* figure 11.15
preserve

gen ch_bw_miss=0
replace ch_bw_miss=1 if ch_bw==.

collapse ch_bw_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bw_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bw_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bw_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Child birth weight missing") ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.8 2017 "Partially" "affected", size(small)) ///
text(0.8 2018.5 "         Fully", size(small)) ///
text(0.75 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.15.pdf", as(pdf) replace 

restore

* figure 11.16
preserve

gen ch_bw_low_miss=0
replace ch_bw_low_miss=1 if ch_low_bw==.

collapse ch_bw_low_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bw_low_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bw_low_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bw_low_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Birth weight less than 2.5 kg missing") ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.8 2017 "Partially" "affected", size(small)) ///
text(0.8 2018.5 "         Fully", size(small)) ///
text(0.75 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.16.pdf", as(pdf) replace 

restore

* figure 11.17
preserve

gen neo_mort_miss=0
replace neo_mort_miss=1 if neo_mort==.

collapse neo_mort_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort_miss, by(eligible) veryshortlabel
twoway scatteri 0.4 2016.5 0.4 2017.5 0.4 2018.5 0.4 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.4 2017.5 0.4 2018.5 0.4 2019.5 0.4 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter neo_mort_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Neonatal Mortality missing") ylabel(0(0.1)0.4) xlabel(2010(1)2020) ///
text(0.038 2017 "Partially" "affected", size(small)) ///
text(0.038 2018.5 "         Fully", size(small)) ///
text(0.0365 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.17.pdf", as(pdf) replace 

restore

* figure 11.18
preserve

gen breast_dur_miss=0
replace breast_dur_miss=1 if breast_dur==.

collapse breast_dur_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate breast_dur_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter breast_dur_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter breast_dur_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Duration of Breastfed (months) missing") ylabel(0(0.2)1)  xlabel(2010(1)2020) ///
text(0.8 2017 "Partially" "affected", size(small)) ///
text(0.8 2018.5 "         Fully", size(small)) ///
text(0.75 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.18.pdf", as(pdf) replace 

restore

* figure 11.19
preserve

gen mod_svr_stunted_miss=0
replace mod_svr_stunted_miss=1 if mod_svr_stunted==.

collapse mod_svr_stunted_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate mod_svr_stunted_miss, by(eligible) veryshortlabel
twoway scatteri 0.2 2016.5 0.2 2017.5 0.2 2018.5 0.2 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.2 2017.5 0.2 2018.5 0.2 2019.5 0.2 2020.5, recast(area) color(gray*0.3) || ///
scatter mod_svr_stunted_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter mod_svr_stunted_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Moderately or severely stunted") ylabel(0.1(0.05)0.2) xlabel(2010(1)2020) ///
text(0.18 2017 "Partially" "affected", size(small)) ///
text(0.18 2018.5 "         Fully", size(small)) ///
text(0.17 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.19.pdf", as(pdf) replace 

restore


* figure 11.20
preserve

gen svr_stunted_miss=0
replace svr_stunted_miss=1 if svr_stunted==.

collapse svr_stunted_miss [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate svr_stunted_miss, by(eligible) veryshortlabel
twoway scatteri 0.2 2016.5 0.2 2017.5 0.2 2018.5 0.2 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.2 2017.5 0.2 2018.5 0.2 2019.5 0.2 2020.5, recast(area) color(gray*0.3) || ///
scatter svr_stunted_miss0 yob, ms(Oh) mcolor(navy) || ///
scatter svr_stunted_miss1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Not first born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Severely stunted")  ylabel(0.1(0.05)0.2) xlabel(2010(1)2020) ///
text(0.18 2017 "Partially" "affected", size(small)) ///
text(0.18 2018.5 "         Fully", size(small)) ///
text(0.175 2019 "affected      ", size(small))
graph export "$outputdir/Fig11.20.pdf", as(pdf) replace 

restore


/*---------------------------------------------------------------------------*
              * Outcome variables separate for nfhs4 and nfhs5 *
*---------------------------------------------------------------------------*/

* figure 12.1
preserve

gen preg_regist_miss=0
replace preg_regist_miss=1 if preg_regist==.

collapse preg_regist_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist_miss, by(eligible ) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter preg_regist_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter preg_regist_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter preg_regist_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Pregnancy Registration Missing) ylabel(0(0.2)1)  xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.1.pdf", as(pdf) replace 

restore


* figure 12.2
preserve

gen anc_visit_miss=0
replace anc_visit_miss=1 if anc_visit==.

collapse anc_visit_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter anc_visit_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter anc_visit_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter anc_visit_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Atleast one ANC visit missing) ylabel(0(0.2)1)   xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.974 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.2.pdf", as(pdf) replace 

restore

*figure 12.3
preserve

gen tot_anc4_miss=0
replace tot_anc4_miss=1 if anc_visit==.

collapse tot_anc4_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc4_miss, by(eligible) veryshortlabel
twoway scatteri .8 2016.5 .8 2017.5 .8 2018.5 .8 2019.5, recast(area) color(gray*0.2) || ///
scatteri .8 2017.5 .8 2018.5 .8 2019.5 .8 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc4_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter tot_anc4_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter tot_anc4_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter tot_anc4_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Four or more ANC visit missing) ylabel(0(0.2)0.8)   xlabel(2010(1)2020) ///
text(0.735 2017 "Partially" "affected", size(small)) ///
text(0.736 2018.5 "         Fully", size(small)) ///
text(0.73 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.3.pdf", as(pdf) replace 

restore



* figure 12.4
preserve

gen tot_anc9_miss=0
replace tot_anc9_miss=1 if tot_anc9==.

collapse tot_anc9_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9_miss, by(eligible) veryshortlabel
twoway scatteri .8 2016.5 .8 2017.5 .8 2018.5 .8 2019.5, recast(area) color(gray*0.2) || ///
scatteri .8 2017.5 .8 2018.5 .8 2019.5 .8 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc9_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter tot_anc9_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter tot_anc9_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter tot_anc9_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Total ANC visits missing) ylabel(0(0.2)0.8)   xlabel(2010(1)2020) ///
text(0.735 2017 "Partially" "affected", size(small)) ///
text(0.736 2018.5 "         Fully", size(small)) ///
text(0.73 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.4.pdf", as(pdf) replace 

restore


* figure 12.5
preserve

gen del_healthf_miss=0
replace del_healthf_miss=1 if del_healthf==.

collapse del_healthf_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter del_healthf_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter del_healthf_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter del_healthf_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Delivery at health facility) ylabel(0(0.2)1)   xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.985 2018.5 "         Fully", size(small)) ///
text(0.972 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.5.pdf", as(pdf) replace 

restore

* figure 12.6
preserve

gen ch_firstvac_miss=0
replace ch_firstvac_miss=1 if ch_firstvac==.

collapse ch_firstvac_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_firstvac_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_firstvac_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Received first dose of required vaccines missing) ylabel(0(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.6.pdf", as(pdf) replace 

restore

* figure 12.21
preserve

gen ch_firstvac_v1_miss=0
replace ch_firstvac_v1_miss=1 if ch_firstvac_v1==.

collapse ch_firstvac_v1_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_v1_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_v1_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_v1_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_firstvac_v1_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_firstvac_v1_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Received first dose of required vaccines-hep0 missing) ylabel(0(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.21.pdf", as(pdf) replace 

restore


* figure 12.22
preserve

gen ch_firstvac_card_miss=0
replace ch_firstvac_card_miss=1 if ch_firstvac_card==.

collapse ch_firstvac_card_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_firstvac_card_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_firstvac_card_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Received first dose of required vaccines by card missing) ylabel(0(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.22.pdf", as(pdf) replace 

restore


* figure 12.23
preserve

gen ch_firstvac_v1card_miss=0
replace ch_firstvac_v1card_miss=1 if ch_firstvac_v1card==.

collapse ch_firstvac_v1card_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_v1card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_v1card_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_v1card_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_firstvac_v1card_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_firstvac_v1card_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Received first dose of required vaccines-hep0 missing) ylabel(0(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.23.pdf", as(pdf) replace 

restore

* figure 12.7
preserve

gen ch_anyvac_miss=0
replace ch_anyvac_miss=1 if ch_anyvac==.

collapse ch_anyvac_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_anyvac_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_anyvac_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_anyvac_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_anyvac_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_anyvac_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Received first dose of any required vaccines missing) ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.978 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.7.pdf", as(pdf) replace 

restore

* figure 12.8
preserve

gen ch_bcg_miss=0
replace ch_bcg_miss=1 if ch_bcg==.
collapse ch_bcg_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_bcg_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_bcg_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of BCG missing) ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.8.pdf", as(pdf) replace 

restore


* figure 12.24
preserve

gen ch_bcg_card_miss=0
replace ch_bcg_card_miss=1 if ch_bcg_card==.
collapse ch_bcg_card_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_bcg_card_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_bcg_card_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of BCG by card missing) ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.24.pdf", as(pdf) replace 

restore


* figure 12.9
preserve

gen ch_hep1_miss=0
replace ch_hep1_miss=1 if ch_hep1==.

collapse ch_hep1_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_hep1_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_hep1_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 )  position(6) col(2)) ytitle(First dose of Hepatitis-B missing) ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.9.pdf", as(pdf) replace 

restore

* figure 12.25
preserve

gen ch_hep1_card_miss=0
replace ch_hep1_card_miss=1 if ch_hep1_card==.

collapse ch_hep1_card_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_card_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_card_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_hep1_card_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_hep1_card_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 )  position(6) col(2)) ytitle(First dose of Hepatitis-B by card missing) ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.25.pdf", as(pdf) replace 

restore

* figure 12.26
preserve

gen ch_hepb_miss=0
replace ch_hepb_miss=1 if ch_hepb==.

collapse ch_hepb_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hepb_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hepb_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_hepb_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_hepb_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_hepb_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 )  position(6) col(2)) ytitle(Hepatitis-B at birth missing) ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.26.pdf", as(pdf) replace 

restore

* figure 12.27
preserve

gen ch_hepb_card_miss=0
replace ch_hepb_card_miss=1 if ch_hepb_card==.

collapse ch_hepb_card_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hepb_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hepb_card_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_hepb_card_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_hepb_card_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_hepb_card_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 )  position(6) col(2)) ytitle(Hepatitis-B at birth by card missing) ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.27.pdf", as(pdf) replace 

restore


* figure 12.10
preserve

gen ch_dpt1_miss=0
replace ch_dpt1_miss=1 if ch_dpt1==.

collapse ch_dpt1_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_dpt1_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_dpt1_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of DPT missing) ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.10.pdf", as(pdf) replace 

restore

* figure 12.28
preserve

gen ch_dpt1_card_miss=0
replace ch_dpt1_card_miss=1 if ch_dpt1_card==.

collapse ch_dpt1_card_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_dpt1_card_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_dpt1_card_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of DPT by card missing) ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.28.pdf", as(pdf) replace 

restore


* figure 12.11
preserve

gen ch_opv1_miss=0
replace ch_opv1_miss=1 if ch_opv1==.

collapse ch_opv1_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_opv1_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_opv1_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of OPV missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.11.pdf", as(pdf) replace 

restore

* figure 12.29
preserve

gen ch_opv1_card_miss=0
replace ch_opv1_card_miss=1 if ch_opv1_card==.

collapse ch_opv1_card_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_opv1_card_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_opv1_card_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of OPV by card missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.29.pdf", as(pdf) replace 

restore

* figure 12.30
preserve

gen ch_opvb_miss=0
replace ch_opvb_miss=1 if ch_opvb==.

collapse ch_opvb_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opvb_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opvb_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_opvb_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_opvb_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_opvb_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(OPV at birth missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.30.pdf", as(pdf) replace 

restore

* figure 12.31
preserve

gen ch_opvb_card_miss=0
replace ch_opvb_card_miss=1 if ch_opvb_card==.

collapse ch_opvb_card_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opvb_card_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opvb_card_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_opvb_card_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_opvb_card_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_opvb_card_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(OPV at birth by card missing) ylabel(0(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.31.pdf", as(pdf) replace 

restore


*******************************************************************************************************************
*-------Secondary outcome variables----*

* figure 12.12
preserve

gen m_anemia_miss=0
replace m_anemia_miss=1 if m_anemia==.

collapse m_anemia_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_anemia_miss, by(eligible) veryshortlabel
twoway scatteri 0.1 2016.5 0.1 2017.5 0.1 2018.5 0.1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.1 2017.5 0.1 2018.5 0.1 2019.5 0.1 2020.5, recast(area) color(gray*0.3) || ///
scatter m_anemia_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter m_anemia_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter m_anemia_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter m_anemia_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Mother Anemic missing") ylabel(0(0.02)0.1) xlabel(2010(1)2020) ///
text(0.09 2017 "Partially" "affected", size(small)) ///
text(0.09 2018.5 "         Fully", size(small)) ///
text(0.085 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.12.pdf", as(pdf) replace 

restore

* figure 12.13
preserve

gen iron_spplm_miss=0
replace iron_spplm_miss=1 if iron_spplm==.

collapse iron_spplm_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate iron_spplm_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter iron_spplm_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter iron_spplm_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter iron_spplm_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter iron_spplm_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("During pregnancy, given or bought iron tablets/syrup missing") ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.13.pdf", as(pdf) replace 

restore


* figure 12.14
preserve

gen dur_iron_spplm_miss=0
replace dur_iron_spplm_miss=1 if dur_iron_spplm==.

collapse dur_iron_spplm_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate dur_iron_spplm_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter dur_iron_spplm_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter dur_iron_spplm_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter dur_iron_spplm_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter dur_iron_spplm_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Days iron tablets or syrup taken missing") ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.98 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.14.pdf", as(pdf) replace 

restore

* figure 12.15
preserve

gen ch_bw_miss=0
replace ch_bw_miss=1 if ch_bw==.

collapse ch_bw_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bw_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bw_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_bw_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_bw_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_bw_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Child birth weight missing") ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.98 2018.5 "         Fully", size(small)) ///
text(0.97 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.15.pdf", as(pdf) replace 

restore

* figure 12.16
preserve

gen ch_low_bw_miss=0
replace ch_low_bw_miss=1 if ch_low_bw==.

collapse ch_low_bw_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_low_bw_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_low_bw_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_low_bw_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_low_bw_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_low_bw_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Birth weight less than 2.5 kg missing") ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.98 2018.5 "         Fully", size(small)) ///
text(0.97 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.16.pdf", as(pdf) replace 

restore

* figure 12.17
preserve

gen neo_mort_miss=0
replace neo_mort_miss=1 if neo_mort==.

collapse neo_mort_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter neo_mort_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter neo_mort_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter neo_mort_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Neonatal Mortality missing") ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.98 2018.5 "         Fully", size(small)) ///
text(0.97 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.17.pdf", as(pdf) replace 

restore

* figure 12.18
preserve

gen breast_dur_miss=0
replace breast_dur_miss=1 if breast_dur==.

collapse breast_dur_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate breast_dur_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter breast_dur_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter breast_dur_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter breast_dur_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter breast_dur_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Duration of Breastfed (months) missing") ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.98 2018.5 "         Fully", size(small)) ///
text(0.97 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.18.pdf", as(pdf) replace 

restore

* figure 12.19
preserve

gen mod_svr_stunted_miss=0
replace mod_svr_stunted_miss=1 if mod_svr_stunted==.

collapse mod_svr_stunted_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate mod_svr_stunted_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter mod_svr_stunted_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter mod_svr_stunted_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter mod_svr_stunted_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter mod_svr_stunted_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Moderately or severely stunted missing") ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.98 2018.5 "         Fully", size(small)) ///
text(0.97 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.19.pdf", as(pdf) replace 

restore


* figure 12.20
preserve

gen svr_stunted_miss=0
replace svr_stunted_miss=1 if mod_svr_stunted==.

collapse svr_stunted_miss [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate svr_stunted_miss, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter svr_stunted_miss0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter svr_stunted_miss1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter svr_stunted_miss0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter svr_stunted_miss1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Severely stunted missing")  ylabel(0(0.2)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.98 2018.5 "         Fully", size(small)) ///
text(0.97 2019 "affected      ", size(small))
graph export "$outputdir/Fig12.20.pdf", as(pdf) replace 

restore


