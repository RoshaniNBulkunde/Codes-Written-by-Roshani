/* 
This file is to check parallel trend graphs for outcome variables and mother's characterstics
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

* Create eligible group=1 if first born
gen  eligible=0
replace eligible=1 if bord==1


/*---------------------------------------------------------------------------*
              * Outcome variables *
*---------------------------------------------------------------------------*/

* figure 1.1
preserve

collapse preg_regist [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist0 yob, ms(Oh) mcolor(navy) || ///
scatter preg_regist1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Pregnancy Registration) ylabel(0.8(0.05)1)  xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.1.pdf", as(pdf) replace 

restore


* figure 1.2
preserve

collapse anc_visit [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit0 yob, ms(Oh) mcolor(navy) || ///
scatter anc_visit1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Atleast one ANC visit) ylabel(0.75(0.05)1)   xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.974 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.2.pdf", as(pdf) replace 

restore

*figure 1.3
preserve

collapse tot_anc4 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc4, by(eligible) veryshortlabel
twoway scatteri .75 2016.5 .75 2017.5 .75 2018.5 .75 2019.5, recast(area) color(gray*0.2) || ///
scatteri .75 2017.5 .75 2018.5 .75 2019.5 .75 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc40 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc41 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Four or more ANC visit) ylabel(0.5(0.05)0.75)   xlabel(2010(1)2020) ///
text(0.735 2017 "Partially" "affected", size(small)) ///
text(0.736 2018.5 "         Fully", size(small)) ///
text(0.73 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.3.pdf", as(pdf) replace 

restore


* figure 1.4
preserve

collapse tot_anc9 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9, by(eligible) veryshortlabel
twoway scatteri 6 2016.5 6 2017.5 6 2018.5 6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 6 2017.5 6 2018.5 6 2019.5 6 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc90 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc91 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Total ANC visits) ylabel(3.5(0.5)6)   xlabel(2010(1)2020) ///
text(5.7 2017 "Partially" "affected", size(small)) ///
text(5.72 2018.5 "         Fully", size(small)) ///
text(5.65 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.4.pdf", as(pdf) replace 

restore


* figure 1.5
preserve

collapse del_healthf [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf0 yob, ms(Oh) mcolor(navy) || ///
scatter del_healthf1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Delivery at health facility) ylabel(0.65(0.05)1)   xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.985 2018.5 "         Fully", size(small)) ///
text(0.972 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.5.pdf", as(pdf) replace 

restore


* figure 1.6
preserve

collapse ch_firstvac [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of required vaccines) ylabel(0.5(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.6.pdf", as(pdf) replace 

restore


/* figure 1.21
preserve

collapse ch_firstvac0 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac0, by(eligible) veryshortlabel
twoway scatteri 0.8 2016.5 0.8 2017.5 0.8 2018.5 0.8 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.8 2017.5 0.8 2018.5 0.8 2019.5 0.8 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac00 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac01 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of required vaccines-hep0 and opv0) ylabel(0.4(0.1)0.8)   xlabel(2010(1)2020) ///
text(0.77 2017 "Partially" "affected", size(small)) ///
text(0.77 2018.5 "         Fully", size(small)) ///
text(0.75 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.21.pdf", as(pdf) replace 

restore */


* figure 1.22
preserve

collapse ch_firstvac_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of required vaccines by card) ylabel(0.5(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.22.pdf", as(pdf) replace 

restore


/* figure 1.23
preserve

collapse ch_firstvac0_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac0_card, by(eligible) veryshortlabel
twoway scatteri 0.8 2016.5 0.8 2017.5 0.8 2018.5 0.8 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.8 2017.5 0.8 2018.5 0.8 2019.5 0.8 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac0_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of required vaccines card-hep0 and opv0 by card) ylabel(0.4(0.1)0.8)   xlabel(2010(1)2020) ///
text(0.77 2017 "Partially" "affected", size(small)) ///
text(0.77 2018.5 "         Fully", size(small)) ///
text(0.75 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.23.pdf", as(pdf) replace 

restore */


* figure 1.7
preserve

collapse ch_anyvac [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_anyvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_anyvac0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_anyvac1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of any required vaccines) ylabel(0.88(0.02)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.978 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.7.pdf", as(pdf) replace 

restore

* figure 1.8
preserve

collapse ch_bcg [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of BCG) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.8.pdf", as(pdf) replace 

restore

* figure 1.24
preserve

collapse ch_bcg_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of BCG by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.24.pdf", as(pdf) replace 

restore


* figure 1.9
preserve

collapse ch_hep1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of Hepatitis-B) ylabel(0.5(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.9.pdf", as(pdf) replace 

restore


* figure 1.25
preserve

collapse ch_hep1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of Hepatitis-B by card) ylabel(0.5(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.25.pdf", as(pdf) replace 
restore

/* figure 1.26
preserve

collapse ch_hepb [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hepb, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hepb0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hepb1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Hepatitis-B at birth) ylabel(0.5(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.26.pdf", as(pdf) replace 

restore

* figure 1.27
preserve

collapse ch_hepb_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hepb_card, by(eligible) veryshortlabel
twoway scatteri 0.9 2016.5 0.9 2017.5 0.9 2018.5 0.9 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.9 2017.5 0.9 2018.5 0.9 2019.5 0.9 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hepb_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hepb_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Hepatitis-B at birth by card) ylabel(0.5(0.1)0.9) xlabel(2010(1)2020) ///
text(0.88 2017 "Partially" "affected", size(small)) ///
text(0.88 2018.5 "         Fully", size(small)) ///
text(0.875 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.27.pdf", as(pdf) replace 

restore */



* figure 1.10
preserve

collapse ch_dpt1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.10.pdf", as(pdf) replace 

restore

* figure 1.28
preserve

collapse ch_dpt1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by card) ylabel(0.7(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.28.pdf", as(pdf) replace 

restore


* figure 1.11
preserve

collapse ch_opv1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of OPV) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.11.pdf", as(pdf) replace 

restore

* figure 1.29
preserve

collapse ch_opv1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of OPV by card) ylabel(0.92(0.02)1) xlabel(2010(1)2020) ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.99 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.29.pdf", as(pdf) replace 

restore


/* * figure 1.30
preserve

collapse ch_opvb [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opvb, by(eligible) veryshortlabel
twoway scatteri 0.9 2016.5 0.9 2017.5 0.9 2018.5 0.9 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.9 2017.5 0.9 2018.5 0.9 2019.5 0.9 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opvb0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opvb1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(OPV at birth) ylabel(0.7(0.05)0.9) xlabel(2010(1)2020) ///
text(0.88 2017 "Partially" "affected", size(small)) ///
text(0.88 2018.5 "         Fully", size(small)) ///
text(0.87 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.30.pdf", as(pdf) replace 

restore

* figure 1.31
preserve

collapse ch_opvb_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opvb_card, by(eligible) veryshortlabel
twoway scatteri 0.95 2016.5 0.95 2017.5 0.95 2018.5 0.95 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.95 2017.5 0.95 2018.5 0.95 2019.5 0.95 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opvb_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opvb_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(OPV at birth by card) ylabel(0.85(0.02)0.95) xlabel(2010(1)2020) ///
text(0.93 2017 "Partially" "affected", size(small)) ///
text(0.93 2018.5 "         Fully", size(small)) ///
text(0.92 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.31.pdf", as(pdf) replace 

restore

*/

*******************************************************************************************************************
*-------Secondary outcome variables----*

* figure 1.12
preserve

collapse m_anemia [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_anemia, by(eligible) veryshortlabel
twoway scatteri 0.65 2016.5 0.65 2017.5 0.65 2018.5 0.65 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.65 2017.5 0.65 2018.5 0.65 2019.5 0.65 2020.5, recast(area) color(gray*0.3) || ///
scatter m_anemia0 yob, ms(Oh) mcolor(navy) || ///
scatter m_anemia1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother Anemic") ylabel(0.5(0.05)0.65) xlabel(2010(1)2020) ///
text(0.64 2017 "Partially" "affected", size(small)) ///
text(0.64 2018.5 "         Fully", size(small)) ///
text(0.635 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.12.pdf", as(pdf) replace 

restore

* figure 1.13
preserve

collapse iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate iron_spplm, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("During pregnancy, given or bought iron tablets/syrup") ylabel(0.7(0.05)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.13.pdf", as(pdf) replace 

restore


* figure 1.14
preserve

collapse dur_iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate dur_iron_spplm, by(eligible) veryshortlabel
twoway scatteri 140 2016.5 140 2017.5 140 2018.5 140 2019.5, recast(area) color(gray*0.2) || ///
scatteri 140 2017.5 140 2018.5 140 2019.5 140 2020.5, recast(area) color(gray*0.3) || ///
scatter dur_iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter dur_iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Days iron tablets or syrup taken") ylabel(80(10)140) xlabel(2010(1)2020) ///
text(135 2017 "Partially" "affected", size(small)) ///
text(135 2018.5 "         Fully", size(small)) ///
text(133 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.14.pdf", as(pdf) replace 

restore

* figure 1.15
preserve

collapse ch_bw [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bw, by(eligible) veryshortlabel
twoway scatteri 2900 2016.5 2900 2017.5 2900 2018.5 2900 2019.5, recast(area) color(gray*0.2) || ///
scatteri 2900 2017.5 2900 2018.5 2900 2019.5 2900 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bw0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bw1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Child birth weight") ylabel(2700(50)2900) xlabel(2010(1)2020) ///
text(2870 2017 "Partially" "affected", size(small)) ///
text(2870 2018.5 "         Fully", size(small)) ///
text(2865 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.15.pdf", as(pdf) replace 

restore

* figure 1.16
preserve

collapse ch_low_bw [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_low_bw, by(eligible) veryshortlabel
twoway scatteri 0.25 2016.5 0.25 2017.5 0.25 2018.5 0.25 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.25 2017.5 0.25 2018.5 0.25 2019.5 0.25 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_low_bw0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_low_bw1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Birth weight less than 2.5 kg") ylabel(0.1(0.05)0.25) xlabel(2010(1)2020) ///
text(0.24 2017 "Partially" "affected", size(small)) ///
text(0.24 2018.5 "         Fully", size(small)) ///
text(0.235 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.16.pdf", as(pdf) replace 

restore

* figure 1.17
preserve

collapse neo_mort [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort, by(eligible) veryshortlabel
twoway scatteri 0.05 2016.5 0.05 2017.5 0.05 2018.5 0.05 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.05 2017.5 0.05 2018.5 0.05 2019.5 0.05 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort0 yob, ms(Oh) mcolor(navy) || ///
scatter neo_mort1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Neonatal Mortality") ylabel(0(0.01)0.05) xlabel(2010(1)2020) ///
text(0.048 2017 "Partially" "affected", size(small)) ///
text(0.048 2018.5 "         Fully", size(small)) ///
text(0.0465 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.17.pdf", as(pdf) replace 

restore

* figure 1.18
preserve

collapse breast_dur [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate breast_dur, by(eligible) veryshortlabel
twoway scatteri 25 2016.5 25 2017.5 25 2018.5 25 2019.5, recast(area) color(gray*0.2) || ///
scatteri 25 2017.5 25 2018.5 25 2019.5 25 2020.5, recast(area) color(gray*0.3) || ///
scatter breast_dur0 yob, ms(Oh) mcolor(navy) || ///
scatter breast_dur1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Duration of Breastfed (months)") ylabel(0(5)25) xlabel(2010(1)2020) ///
text(24 2017 "Partially" "affected", size(small)) ///
text(24.2 2018.5 "         Fully", size(small)) ///
text(23.7 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.18.pdf", as(pdf) replace 

restore

* figure 1.19
preserve

collapse mod_svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate mod_svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.5 2016.5 0.5 2017.5 0.5 2018.5 0.5 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.5 2017.5 0.5 2018.5 0.5 2019.5 0.5 2020.5, recast(area) color(gray*0.3) || ///
scatter mod_svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter mod_svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Moderately or severely stunted") ylabel(0.2(0.05)0.5) xlabel(2010(1)2020) ///
text(0.48 2017 "Partially" "affected", size(small)) ///
text(0.48 2018.5 "         Fully", size(small)) ///
text(0.47 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.19.pdf", as(pdf) replace 

restore


* figure 1.20
preserve

collapse svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.25 2016.5 0.25 2017.5 0.25 2018.5 0.25 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.25 2017.5 0.25 2018.5 0.25 2019.5 0.25 2020.5, recast(area) color(gray*0.3) || ///
scatter svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Not first born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Severely stunted")  ylabel(0.05(0.05)0.25) xlabel(2010(1)2020) ///
text(0.23 2017 "Partially" "affected", size(small)) ///
text(0.23 2018.5 "         Fully", size(small)) ///
text(0.24 2019 "affected      ", size(small))
graph export "$outputdir/Fig1.20.pdf", as(pdf) replace 

restore


/*---------------------------------------------------------------------------*
              * Baseline Characteristics*
*---------------------------------------------------------------------------*/

* figure 2.1
preserve

collapse m_schooling [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_schooling, by(eligible) veryshortlabel
twoway scatteri 12 2016.5 12 2017.5 12 2018.5 12 2019.5, recast(area) color(gray*0.2) || ///
scatteri 12 2017.5 12 2018.5 12 2019.5 12 2020.5, recast(area) color(gray*0.3) || ///
scatter m_schooling0 yob, ms(Oh) mcolor(navy) || ///
scatter m_schooling1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother's years of schooling") ylabel(3(1)12)  xlabel(2010(1)2020) ///
text(11.5 2017 "Partially" "affected", size(small)) ///
text(11.6 2018.5 "         Fully", size(small)) ///
text(11.3 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.1.pdf", as(pdf) replace 

restore


* figure 2.2
preserve

collapse m_age [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_age, by(eligible) veryshortlabel
twoway scatteri 32 2016.5 32 2017.5 32 2018.5 32 2019.5, recast(area) color(gray*0.2) || ///
scatteri 32 2017.5 32 2018.5 32 2019.5 32 2020.5, recast(area) color(gray*0.3) || ///
scatter m_age0 yob, ms(Oh) mcolor(navy) || ///
scatter m_age1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother's age (years)") ylabel(22(2)32)  xlabel(2010(1)2020) ///
text(31.5 2017 "Partially" "affected", size(small)) ///
text(31.5 2018.5 "         Fully", size(small)) ///
text(31.3 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.2.pdf", as(pdf) replace 

restore


* figure 2.3
preserve

collapse afb [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate afb, by(eligible) veryshortlabel
twoway scatteri 24 2016.5 24 2017.5 24 2018.5 24 2019.5, recast(area) color(gray*0.2) || ///
scatteri 24 2017.5 24 2018.5 24 2019.5 24 2020.5, recast(area) color(gray*0.3) || ///
scatter afb0 yob, ms(Oh) mcolor(navy) || ///
scatter afb1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother's age at first birth") ylabel(19(1)24)  xlabel(2010(1)2020) ///
text(23.5 2017 "Partially" "affected", size(small)) ///
text(23.6 2018.5 "         Fully", size(small)) ///
text(23.4 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.3.pdf", as(pdf) replace 

restore

* figure 2.4
preserve

collapse afc [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate afc, by(eligible) veryshortlabel
twoway scatteri 22 2016.5 22 2017.5 22 2018.5 22 2019.5, recast(area) color(gray*0.2) || ///
scatteri 22 2017.5 22 2018.5 22 2019.5 22 2020.5, recast(area) color(gray*0.3) || ///
scatter afc0 yob, ms(Oh) mcolor(navy) || ///
scatter afc1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother's cohabitation age") ylabel(16(1)22)  xlabel(2010(1)2020) ///
text(21.5 2017 "Partially" "affected", size(small)) ///
text(21.6 2018.5 "         Fully", size(small)) ///
text(21.4 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.4.pdf", as(pdf) replace 

restore

* figure 2.5
preserve

collapse rural [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate rural, by(eligible) veryshortlabel
twoway scatteri 0.8 2016.5 0.8 2017.5 0.8 2018.5 0.8 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.8 2017.5 0.8 2018.5 0.8 2019.5 0.8 2020.5, recast(area) color(gray*0.3) || ///
scatter rural0 yob, ms(Oh) mcolor(navy) || ///
scatter rural1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Rural") ylabel(0.6(0.05)0.8)  xlabel(2010(1)2020) ///
text(0.78 2017 "Partially" "affected", size(small)) ///
text(0.785 2018.5 "         Fully", size(small)) ///
text(0.775 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.5.pdf", as(pdf) replace 

restore


* figure 2.6
preserve

collapse poor [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate poor, by(eligible) veryshortlabel
twoway scatteri 0.6 2016.5 0.6 2017.5 0.6 2018.5 0.6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.6 2017.5 0.6 2018.5 0.6 2019.5 0.6 2020.5, recast(area) color(gray*0.3) || ///
scatter poor0 yob, ms(Oh) mcolor(navy) || ///
scatter poor1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Poor") ylabel(0.3(0.05)0.6)  xlabel(2010(1)2020) ///
text(0.58 2017 "Partially" "affected", size(small)) ///
text(0.585 2018.5 "         Fully", size(small)) ///
text(0.575 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.6.pdf", as(pdf) replace 

restore


* figure 2.7
preserve

collapse middle [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate middle, by(eligible) veryshortlabel
twoway scatteri 0.23 2016.5 0.23 2017.5 0.23 2018.5 0.23 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.23 2017.5 0.23 2018.5 0.23 2019.5 0.23 2020.5, recast(area) color(gray*0.3) || ///
scatter middle0 yob, ms(Oh) mcolor(navy) || ///
scatter middle1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Middle") ylabel(0.17(0.01)0.23)  xlabel(2010(1)2020) ///
text(0.24 2017 "Partially" "affected", size(small)) ///
text(0.24 2018.5 "         Fully", size(small)) ///
text(0.235 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.7.pdf", as(pdf) replace 

restore

* figure 2.8
preserve

collapse rich [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate rich, by(eligible) veryshortlabel
twoway scatteri 0.5 2016.5 0.5 2017.5 0.5 2018.5 0.5 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.5 2017.5 0.5 2018.5 0.5 2019.5 0.5 2020.5, recast(area) color(gray*0.3) || ///
scatter rich0 yob, ms(Oh) mcolor(navy) || ///
scatter rich1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Rich") ylabel(0.25(0.05)0.5)  xlabel(2010(1)2020) ///
text(0.47 2017 "Partially" "affected", size(small)) ///
text(0.47 2018.5 "         Fully", size(small)) ///
text(0.46 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.8.pdf", as(pdf) replace 

restore


* figure 2.9
preserve

collapse sch_caste_tribe [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate sch_caste_tribe, by(eligible) veryshortlabel
twoway scatteri 0.45 2016.5 0.45 2017.5 0.45 2018.5 0.45 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.45 2017.5 0.45 2018.5 0.45 2019.5 0.45 2020.5, recast(area) color(gray*0.3) || ///
scatter sch_caste_tribe0 yob, ms(Oh) mcolor(navy) || ///
scatter sch_caste_tribe1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Scheduled caste/tribe") ylabel(0.25(0.05)0.45)  xlabel(2010(1)2020) ///
text(0.43 2017 "Partially" "affected", size(small)) ///
text(0.43 2018.5 "         Fully", size(small)) ///
text(0.422 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.9.pdf", as(pdf) replace 

restore

* figure 2.10
preserve

collapse obc [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate obc, by(eligible) veryshortlabel
twoway scatteri 0.5 2016.5 0.5 2017.5 0.5 2018.5 0.5 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.5 2017.5 0.5 2018.5 0.5 2019.5 0.5 2020.5, recast(area) color(gray*0.3) || ///
scatter obc0 yob, ms(Oh) mcolor(navy) || ///
scatter obc1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("OBC caste") ylabel(0.42(0.02)0.5)  xlabel(2010(1)2020) ///
text(0.48 2017 "Partially" "affected", size(small)) ///
text(0.48 2018.5 "         Fully", size(small)) ///
text(0.475 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.10.pdf", as(pdf) replace 

restore


* figure 2.11
preserve

collapse all_oth_caste [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate all_oth_caste, by(eligible) veryshortlabel
twoway scatteri 0.25 2016.5 0.25 2017.5 0.25 2018.5 0.25 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.25 2017.5 0.25 2018.5 0.25 2019.5 0.25 2020.5, recast(area) color(gray*0.3) || ///
scatter all_oth_caste0 yob, ms(Oh) mcolor(navy) || ///
scatter all_oth_caste1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("All other caste") ylabel(0.1(0.05)0.25)  xlabel(2010(1)2020) ///
text(0.24 2017 "Partially" "affected", size(small)) ///
text(0.24 2018.5 "         Fully", size(small)) ///
text(0.235 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.11.pdf", as(pdf) replace 

restore

* figure 2.12
preserve

collapse hindu [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate hindu, by(eligible) veryshortlabel
twoway scatteri 0.9 2016.5 0.9 2017.5 0.9 2018.5 0.9 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.9 2017.5 0.9 2018.5 0.9 2019.5 0.9 2020.5, recast(area) color(gray*0.3) || ///
scatter hindu0 yob, ms(Oh) mcolor(navy) || ///
scatter hindu1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Hindu") ylabel(0.7(0.05)0.9)  xlabel(2010(1)2020) ///
text(0.88 2017 "Partially" "affected", size(small)) ///
text(0.88 2018.5 "         Fully", size(small)) ///
text(0.87 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.12.pdf", as(pdf) replace 

restore


* figure 2.13
preserve

collapse muslim [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate muslim, by(eligible) veryshortlabel
twoway scatteri 0.2 2016.5 0.2 2017.5 0.2 2018.5 0.2 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.2 2017.5 0.2 2018.5 0.2 2019.5 0.2 2020.5, recast(area) color(gray*0.3) || ///
scatter muslim0 yob, ms(Oh) mcolor(navy) || ///
scatter muslim1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Muslim") ylabel(0.08(0.02)0.2)  xlabel(2010(1)2020) ///
text(0.19 2017 "Partially" "affected", size(small)) ///
text(0.19 2018.5 "         Fully", size(small)) ///
text(0.185 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.13.pdf", as(pdf) replace 

restore

* figure 2.14
preserve

collapse other_r [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate other_r, by(eligible) veryshortlabel
twoway scatteri 0.08 2016.5 0.08 2017.5 0.08 2018.5 0.08 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.08 2017.5 0.08 2018.5 0.08 2019.5 0.08 2020.5, recast(area) color(gray*0.3) || ///
scatter other_r0 yob, ms(Oh) mcolor(navy) || ///
scatter other_r1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Other religion") ylabel(0.02(0.02)0.08)  xlabel(2010(1)2020) ///
text(0.067 2017 "Partially" "affected", size(small)) ///
text(0.067 2018.5 "         Fully", size(small)) ///
text(0.065 2019 "affected      ", size(small))
graph export "$outputdir/Fig2.14.pdf", as(pdf) replace 

restore


/*---------------------------------------------------------------------------*
              * Outcome variables separate for nfhs4 and nfhs5 *
*---------------------------------------------------------------------------*/

* figure 3.1
preserve

collapse preg_regist [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist, by(eligible ) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter preg_regist1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter preg_regist0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter preg_regist1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Pregnancy Registration) ylabel(0.8(0.05)1)  xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.1.pdf", as(pdf) replace 

restore



* figure 3.2
preserve

collapse anc_visit [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter anc_visit1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter anc_visit0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter anc_visit1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Atleast one ANC visit) ylabel(0.75(0.05)1)   xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.974 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.2.pdf", as(pdf) replace 

restore

*figure 3.3
preserve

collapse tot_anc4 [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc4, by(eligible) veryshortlabel
twoway scatteri .75 2016.5 .75 2017.5 .75 2018.5 .75 2019.5, recast(area) color(gray*0.2) || ///
scatteri .75 2017.5 .75 2018.5 .75 2019.5 .75 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc40 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter tot_anc41 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter tot_anc40 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter tot_anc41 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Four or more ANC visit) ylabel(0.5(0.05)0.75)   xlabel(2010(1)2020) ///
text(0.735 2017 "Partially" "affected", size(small)) ///
text(0.736 2018.5 "         Fully", size(small)) ///
text(0.73 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.3.pdf", as(pdf) replace 

restore


* figure 3.4
preserve

collapse tot_anc9 [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9, by(eligible) veryshortlabel
twoway scatteri 6 2016.5 6 2017.5 6 2018.5 6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 6 2017.5 6 2018.5 6 2019.5 6 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc90 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter tot_anc91 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter tot_anc90 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter tot_anc91 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Total ANC visits) ylabel(3.5(0.5)6)   xlabel(2010(1)2020) ///
text(5.7 2017 "Partially" "affected", size(small)) ///
text(5.72 2018.5 "         Fully", size(small)) ///
text(5.65 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.4.pdf", as(pdf) replace 

restore


* figure 3.5
preserve

collapse del_healthf [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter del_healthf1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter del_healthf0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter del_healthf1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Delivery at health facility) ylabel(0.65(0.05)1)   xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.985 2018.5 "         Fully", size(small)) ///
text(0.972 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.5.pdf", as(pdf) replace 

restore


* figure 3.6
preserve

collapse ch_firstvac [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_firstvac0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_firstvac1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Received first dose of required vaccines) ylabel(0.3(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.6.pdf", as(pdf) replace 

restore


* figure 3.21
preserve

collapse ch_firstvac0 [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac0, by(eligible) veryshortlabel
twoway scatteri 0.8 2016.5 0.8 2017.5 0.8 2018.5 0.8 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.8 2017.5 0.8 2018.5 0.8 2019.5 0.8 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac00 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac01 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_firstvac00 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_firstvac01 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Received first dose of required vaccines-hep0 and opv0) ylabel(0.3(0.1)0.8)   xlabel(2010(1)2020) ///
text(0.78 2017 "Partially" "affected", size(small)) ///
text(0.78 2018.5 "         Fully", size(small)) ///
text(0.74 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.21.pdf", as(pdf) replace 

restore


* figure 3.22
preserve

collapse ch_firstvac_card [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_firstvac_card0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_firstvac_card1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Received first dose of required vaccines by card) ylabel(0.3(0.1)1)   xlabel(2010(1)2020) ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.97 2018.5 "         Fully", size(small)) ///
text(0.96 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.22.pdf", as(pdf) replace 

restore


* figure 3.23
preserve

collapse ch_firstvac0_card [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac0_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0_card0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac0_card1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_firstvac0_card0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_firstvac0_card1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Received first dose of required vaccines by card) ylabel(0.3(0.1)1)   xlabel(2010(1)2020) ///
text(0.95 2017 "Partially" "affected", size(small)) ///
text(0.95 2018.5 "         Fully", size(small)) ///
text(0.94 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.23.pdf", as(pdf) replace 

restore


* figure 3.7
preserve

collapse ch_anyvac [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_anyvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_anyvac0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_anyvac1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_anyvac0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_anyvac1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(Received first dose of any required vaccines) ylabel(0.84(0.02)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.978 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.7.pdf", as(pdf) replace 

restore

* figure 3.8
preserve

collapse ch_bcg [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_bcg1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_bcg0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_bcg1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of BCG) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.8.pdf", as(pdf) replace 

restore


* figure 3.24
preserve

collapse ch_bcg_card [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_bcg_card0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_bcg_card1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of BCG by card) ylabel(0.92(0.02)1)   xlabel(2010(1)2020) ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.99 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.24.pdf", as(pdf) replace 

restore


* figure 3.9
preserve

collapse ch_hep1 [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep10 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_hep11 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_hep10 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_hep11 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 )  position(6) col(2)) ytitle(First dose of Hepatitis-B) ylabel(0.5(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.9.pdf", as(pdf) replace 

restore


* figure 3.25
preserve

collapse ch_hepb [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hepb, by(eligible) veryshortlabel
twoway scatteri 0.8 2016.5 0.8 2017.5 0.8 2018.5 0.8 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.8 2017.5 0.8 2018.5 0.8 2019.5 0.8 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hepb0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_hepb1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_hepb0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_hepb1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 )  position(6) col(2)) ytitle(Hepatitis-B at birth) ylabel(0.4(0.1)0.8) xlabel(2010(1)2020) ///
text(0.75 2017 "Partially" "affected", size(small)) ///
text(0.75 2018.5 "         Fully", size(small)) ///
text(0.74 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.25.pdf", as(pdf) replace 

restore


* figure 3.26
preserve

collapse ch_hepb_card [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hepb_card, by(eligible) veryshortlabel
twoway scatteri 0.8 2016.5 0.8 2017.5 0.8 2018.5 0.8 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.8 2017.5 0.8 2018.5 0.8 2019.5 0.8 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hepb_card0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_hepb_card1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_hepb_card0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_hepb_card1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 )  position(6) col(2)) ytitle(Hepatitis-B at birth by card) ylabel(0.5(0.05)0.8) xlabel(2010(1)2020) ///
text(0.77 2017 "Partially" "affected", size(small)) ///
text(0.77 2018.5 "         Fully", size(small)) ///
text(0.76 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.26.pdf", as(pdf) replace 

restore


* figure 3.10
preserve

collapse ch_dpt1 [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt10 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_dpt11 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_dpt10 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_dpt11 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of DPT) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.10.pdf", as(pdf) replace 

restore

* figure 3.27
preserve

collapse ch_dpt1_card [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_dpt1_card0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_dpt1_card1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of DPT by card) ylabel(0.5(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.27.pdf", as(pdf) replace 

restore


* figure 3.11
preserve

collapse ch_opv1 [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv10 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_opv11 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_opv10 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_opv11 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of OPV) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.11.pdf", as(pdf) replace 

restore


* figure 3.28
preserve

collapse ch_opv1_card [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_opv1_card0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_opv1_card1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(First dose of OPV by card) ylabel(0.5(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.28.pdf", as(pdf) replace 

restore

* figure 3.29
preserve

collapse ch_opvb [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opvb, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opvb0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_opvb1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_opvb0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_opvb1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(OPV at birth) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.29.pdf", as(pdf) replace 

restore


* figure 3.30
preserve

collapse ch_opvb_card [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opvb_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opvb_card0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_opvb_card1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_opvb_card0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_opvb_card1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle(OPV at birth by card) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.30.pdf", as(pdf) replace 

restore


*******************************************************************************************************************
*-------Secondary outcome variables----*

* figure 3.12
preserve

collapse m_anemia [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_anemia, by(eligible) veryshortlabel
twoway scatteri 0.65 2016.5 0.65 2017.5 0.65 2018.5 0.65 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.65 2017.5 0.65 2018.5 0.65 2019.5 0.65 2020.5, recast(area) color(gray*0.3) || ///
scatter m_anemia0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter m_anemia1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter m_anemia0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter m_anemia1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Mother Anemic") ylabel(0.5(0.05)0.65) xlabel(2010(1)2020) ///
text(0.64 2017 "Partially" "affected", size(small)) ///
text(0.64 2018.5 "         Fully", size(small)) ///
text(0.635 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.12.pdf", as(pdf) replace 

restore

* figure 3.13
preserve

collapse iron_spplm [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate iron_spplm, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter iron_spplm0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter iron_spplm1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter iron_spplm0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter iron_spplm1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("During pregnancy, given or bought iron tablets/syrup") ylabel(0.7(0.05)1) xlabel(2010(1)2020) ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.13.pdf", as(pdf) replace 

restore


* figure 3.14
preserve

collapse dur_iron_spplm [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate dur_iron_spplm, by(eligible) veryshortlabel
twoway scatteri 140 2016.5 140 2017.5 140 2018.5 140 2019.5, recast(area) color(gray*0.2) || ///
scatteri 140 2017.5 140 2018.5 140 2019.5 140 2020.5, recast(area) color(gray*0.3) || ///
scatter dur_iron_spplm0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter dur_iron_spplm1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter dur_iron_spplm0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter dur_iron_spplm1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Days iron tablets or syrup taken") ylabel(80(10)140) xlabel(2010(1)2020) ///
text(135 2017 "Partially" "affected", size(small)) ///
text(135 2018.5 "         Fully", size(small)) ///
text(133 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.14.pdf", as(pdf) replace 

restore

* figure 3.15
preserve

collapse ch_bw [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bw, by(eligible) veryshortlabel
twoway scatteri 2900 2016.5 2900 2017.5 2900 2018.5 2900 2019.5, recast(area) color(gray*0.2) || ///
scatteri 2900 2017.5 2900 2018.5 2900 2019.5 2900 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bw0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_bw1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_bw0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_bw1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Child birth weight") ylabel(2700(50)2900) xlabel(2010(1)2020) ///
text(2870 2017 "Partially" "affected", size(small)) ///
text(2870 2018.5 "         Fully", size(small)) ///
text(2865 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.15.pdf", as(pdf) replace 

restore

* figure 3.16
preserve

collapse ch_low_bw [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_low_bw, by(eligible) veryshortlabel
twoway scatteri 0.25 2016.5 0.25 2017.5 0.25 2018.5 0.25 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.25 2017.5 0.25 2018.5 0.25 2019.5 0.25 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_low_bw0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter ch_low_bw1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter ch_low_bw0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter ch_low_bw1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Birth weight less than 2.5 kg") ylabel(0.1(0.05)0.25) xlabel(2010(1)2020) ///
text(0.24 2017 "Partially" "affected", size(small)) ///
text(0.24 2018.5 "         Fully", size(small)) ///
text(0.235 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.16.pdf", as(pdf) replace 

restore

* figure 3.17
preserve

collapse neo_mort [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort, by(eligible) veryshortlabel
twoway scatteri 0.05 2016.5 0.05 2017.5 0.05 2018.5 0.05 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.05 2017.5 0.05 2018.5 0.05 2019.5 0.05 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter neo_mort1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter neo_mort0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter neo_mort1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Neonatal Mortality") ylabel(0(0.01)0.05) xlabel(2010(1)2020) ///
text(0.048 2017 "Partially" "affected", size(small)) ///
text(0.048 2018.5 "         Fully", size(small)) ///
text(0.0465 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.17.pdf", as(pdf) replace 

restore

* figure 3.18
preserve

collapse breast_dur [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate breast_dur, by(eligible) veryshortlabel
twoway scatteri 25 2016.5 25 2017.5 25 2018.5 25 2019.5, recast(area) color(gray*0.2) || ///
scatteri 25 2017.5 25 2018.5 25 2019.5 25 2020.5, recast(area) color(gray*0.3) || ///
scatter breast_dur0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter breast_dur1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter breast_dur0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter breast_dur1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Duration of Breastfed (months)") ylabel(0(5)25) xlabel(2010(1)2020) ///
text(24 2017 "Partially" "affected", size(small)) ///
text(24.2 2018.5 "         Fully", size(small)) ///
text(23.7 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.18.pdf", as(pdf) replace 

restore

* figure 3.19
preserve

collapse mod_svr_stunted [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate mod_svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.5 2016.5 0.5 2017.5 0.5 2018.5 0.5 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.5 2017.5 0.5 2018.5 0.5 2019.5 0.5 2020.5, recast(area) color(gray*0.3) || ///
scatter mod_svr_stunted0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter mod_svr_stunted1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter mod_svr_stunted0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter mod_svr_stunted1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Moderately or severely stunted") ylabel(0.2(0.05)0.5) xlabel(2010(1)2020) ///
text(0.48 2017 "Partially" "affected", size(small)) ///
text(0.48 2018.5 "         Fully", size(small)) ///
text(0.47 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.19.pdf", as(pdf) replace 

restore


* figure 3.20
preserve

collapse svr_stunted [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.25 2016.5 0.25 2017.5 0.25 2018.5 0.25 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.25 2017.5 0.25 2018.5 0.25 2019.5 0.25 2020.5, recast(area) color(gray*0.3) || ///
scatter svr_stunted0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter svr_stunted1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter svr_stunted0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter svr_stunted1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Severely stunted")  ylabel(0.05(0.05)0.25) xlabel(2010(1)2020) ///
text(0.23 2017 "Partially" "affected", size(small)) ///
text(0.23 2018.5 "         Fully", size(small)) ///
text(0.24 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.20.pdf", as(pdf) replace 

restore


/*---------------------------------------------------------------------------*
              * Baseline characteristics separate for nfhs4 and nfhs5 *
*---------------------------------------------------------------------------*/

* figure 4.1
preserve

collapse m_schooling [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_schooling, by(eligible) veryshortlabel
twoway scatteri 12 2016.5 12 2017.5 12 2018.5 12 2019.5, recast(area) color(gray*0.2) || ///
scatteri 12 2017.5 12 2018.5 12 2019.5 12 2020.5, recast(area) color(gray*0.3) || ///
scatter m_schooling0 yob if survey==1 , ms(Oh) mcolor(navy) || ///
scatter m_schooling1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter m_schooling0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter m_schooling1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Mother's years of schooling") ylabel(3(1)12)  xlabel(2010(1)2020) ///
text(11.5 2017 "Partially" "affected", size(small)) ///
text(11.6 2018.5 "         Fully", size(small)) ///
text(11.3 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.1.pdf", as(pdf) replace 

restore


* figure 4.2
preserve

collapse m_age [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_age, by(eligible) veryshortlabel
twoway scatteri 32 2016.5 32 2017.5 32 2018.5 32 2019.5, recast(area) color(gray*0.2) || ///
scatteri 32 2017.5 32 2018.5 32 2019.5 32 2020.5, recast(area) color(gray*0.3) || ///
scatter m_age0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter m_age1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter m_age0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter m_age1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Mother's age (years)") ylabel(22(2)32)  xlabel(2010(1)2020) ///
text(31.5 2017 "Partially" "affected", size(small)) ///
text(31.5 2018.5 "         Fully", size(small)) ///
text(31.3 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.2.pdf", as(pdf) replace 

restore


* figure 4.3
preserve

collapse afb [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate afb, by(eligible) veryshortlabel
twoway scatteri 24 2016.5 24 2017.5 24 2018.5 24 2019.5, recast(area) color(gray*0.2) || ///
scatteri 24 2017.5 24 2018.5 24 2019.5 24 2020.5, recast(area) color(gray*0.3) || ///
scatter afb0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter afb1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter afb0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter afb1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Mother's age at first birth") ylabel(19(1)24)  xlabel(2010(1)2020) ///
text(23.5 2017 "Partially" "affected", size(small)) ///
text(23.6 2018.5 "         Fully", size(small)) ///
text(23.4 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.3.pdf", as(pdf) replace 

restore

* figure 4.4
preserve

collapse afc [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate afc, by(eligible) veryshortlabel
twoway scatteri 22 2016.5 22 2017.5 22 2018.5 22 2019.5, recast(area) color(gray*0.2) || ///
scatteri 22 2017.5 22 2018.5 22 2019.5 22 2020.5, recast(area) color(gray*0.3) || ///
scatter afc0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter afc1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter afc0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter afc1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Mother's cohabitation age") ylabel(16(1)22)  xlabel(2010(1)2020) ///
text(21.5 2017 "Partially" "affected", size(small)) ///
text(21.6 2018.5 "         Fully", size(small)) ///
text(21.4 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.4.pdf", as(pdf) replace 

restore


* figure 4.5
preserve

collapse rural [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate rural, by(eligible) veryshortlabel
twoway scatteri 0.8 2016.5 0.8 2017.5 0.8 2018.5 0.8 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.8 2017.5 0.8 2018.5 0.8 2019.5 0.8 2020.5, recast(area) color(gray*0.3) || ///
scatter rural0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter rural1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter rural0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter rural1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 )  position(6) col(2)) ytitle("Rural") ylabel(0.6(0.05)0.8)  xlabel(2010(1)2020) ///
text(0.78 2017 "Partially" "affected", size(small)) ///
text(0.785 2018.5 "         Fully", size(small)) ///
text(0.775 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.5.pdf", as(pdf) replace 

restore


* figure 4.6
preserve

collapse poor [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate poor, by(eligible) veryshortlabel
twoway scatteri 0.6 2016.5 0.6 2017.5 0.6 2018.5 0.6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.6 2017.5 0.6 2018.5 0.6 2019.5 0.6 2020.5, recast(area) color(gray*0.3) || ///
scatter poor0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter poor1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter poor0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter poor1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Poor") ylabel(0.3(0.05)0.6)  xlabel(2010(1)2020) ///
text(0.58 2017 "Partially" "affected", size(small)) ///
text(0.585 2018.5 "         Fully", size(small)) ///
text(0.575 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.6.pdf", as(pdf) replace 

restore


* figure 4.7
preserve

collapse middle [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate middle, by(eligible) veryshortlabel
twoway scatteri 0.23 2016.5 0.23 2017.5 0.23 2018.5 0.23 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.23 2017.5 0.23 2018.5 0.23 2019.5 0.23 2020.5, recast(area) color(gray*0.3) || ///
scatter middle0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter middle1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter middle0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter middle1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Middle") ylabel(0.17(0.01)0.23)  xlabel(2010(1)2020) ///
text(0.24 2017 "Partially" "affected", size(small)) ///
text(0.24 2018.5 "         Fully", size(small)) ///
text(0.235 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.7.pdf", as(pdf) replace 

restore

* figure 4.8
preserve

collapse rich [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate rich, by(eligible) veryshortlabel
twoway scatteri 0.5 2016.5 0.5 2017.5 0.5 2018.5 0.5 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.5 2017.5 0.5 2018.5 0.5 2019.5 0.5 2020.5, recast(area) color(gray*0.3) || ///
scatter rich0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter rich1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter rich0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter rich1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Rich") ylabel(0.25(0.05)0.5)  xlabel(2010(1)2020) ///
text(0.47 2017 "Partially" "affected", size(small)) ///
text(0.47 2018.5 "         Fully", size(small)) ///
text(0.46 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.8.pdf", as(pdf) replace 

restore


* figure 4.9
preserve

collapse sch_caste_tribe [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate sch_caste_tribe, by(eligible) veryshortlabel
twoway scatteri 0.45 2016.5 0.45 2017.5 0.45 2018.5 0.45 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.45 2017.5 0.45 2018.5 0.45 2019.5 0.45 2020.5, recast(area) color(gray*0.3) || ///
scatter sch_caste_tribe0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter sch_caste_tribe1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter sch_caste_tribe0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter sch_caste_tribe1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Scheduled caste/tribe") ylabel(0.25(0.05)0.45)  xlabel(2010(1)2020) ///
text(0.43 2017 "Partially" "affected", size(small)) ///
text(0.43 2018.5 "         Fully", size(small)) ///
text(0.422 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.9.pdf", as(pdf) replace 

restore

* figure 4.10
preserve

collapse obc [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate obc, by(eligible) veryshortlabel
twoway scatteri 0.5 2016.5 0.5 2017.5 0.5 2018.5 0.5 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.5 2017.5 0.5 2018.5 0.5 2019.5 0.5 2020.5, recast(area) color(gray*0.3) || ///
scatter obc0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter obc1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter obc0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter obc1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 )  position(6) col(2)) ytitle("OBC caste") ylabel(0.42(0.02)0.5)  xlabel(2010(1)2020) ///
text(0.48 2017 "Partially" "affected", size(small)) ///
text(0.48 2018.5 "         Fully", size(small)) ///
text(0.475 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.10.pdf", as(pdf) replace 

restore


* figure 4.11
preserve

collapse all_oth_caste [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate all_oth_caste, by(eligible) veryshortlabel
twoway scatteri 0.25 2016.5 0.25 2017.5 0.25 2018.5 0.25 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.25 2017.5 0.25 2018.5 0.25 2019.5 0.25 2020.5, recast(area) color(gray*0.3) || ///
scatter all_oth_caste0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter all_oth_caste1 yob if survey==1, ms(Sh)  mcolor(maroon)|| ///
scatter all_oth_caste0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter all_oth_caste1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("All other caste") ylabel(0.1(0.05)0.25)  xlabel(2010(1)2020) ///
text(0.24 2017 "Partially" "affected", size(small)) ///
text(0.24 2018.5 "         Fully", size(small)) ///
text(0.235 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.11.pdf", as(pdf) replace 

restore

* figure 4.12
preserve

collapse hindu [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate hindu, by(eligible) veryshortlabel
twoway scatteri 0.9 2016.5 0.9 2017.5 0.9 2018.5 0.9 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.9 2017.5 0.9 2018.5 0.9 2019.5 0.9 2020.5, recast(area) color(gray*0.3) || ///
scatter hindu0 yob if survey==1 , ms(Oh) mcolor(navy) || ///
scatter hindu1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter hindu0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter hindu1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Hindu") ylabel(0.7(0.05)0.9)  xlabel(2010(1)2020) ///
text(0.88 2017 "Partially" "affected", size(small)) ///
text(0.88 2018.5 "         Fully", size(small)) ///
text(0.87 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.12.pdf", as(pdf) replace 

restore


* figure 4.13
preserve

collapse muslim [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate muslim, by(eligible) veryshortlabel
twoway scatteri 0.2 2016.5 0.2 2017.5 0.2 2018.5 0.2 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.2 2017.5 0.2 2018.5 0.2 2019.5 0.2 2020.5, recast(area) color(gray*0.3) || ///
scatter muslim0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter muslim1 yob if survey==1 , ms(Sh)  mcolor(maroon) || ///
scatter muslim0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter muslim1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Muslim") ylabel(0.08(0.02)0.2)  xlabel(2010(1)2020) ///
text(0.19 2017 "Partially" "affected", size(small)) ///
text(0.19 2018.5 "         Fully", size(small)) ///
text(0.185 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.13.pdf", as(pdf) replace 

restore

* figure 4.14
preserve

collapse other_r [aw=weight], by(survey eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate other_r, by(eligible) veryshortlabel
twoway scatteri 0.08 2016.5 0.08 2017.5 0.08 2018.5 0.08 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.08 2017.5 0.08 2018.5 0.08 2019.5 0.08 2020.5, recast(area) color(gray*0.3) || ///
scatter other_r0 yob if survey==1, ms(Oh) mcolor(navy) || ///
scatter other_r1 yob if survey==1, ms(Sh)  mcolor(maroon) || ///
scatter other_r0 yob if survey==2, ms(Dh) mcolor(green) || ///
scatter other_r1 yob if survey==2, ms(Th)  mcolor(purple) ///
legend(lab(3 "2nd born nfhs4") lab(4 "First born nfhs4") lab(5 "2nd born nfhs5") lab(6 "First born nfhs5") order( 6 5 4 3 ) position(6) col(2)) ytitle("Other religion") ylabel(0.02(0.02)0.08)  xlabel(2010(1)2020) ///
text(0.067 2017 "Partially" "affected", size(small)) ///
text(0.067 2018.5 "         Fully", size(small)) ///
text(0.065 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.14.pdf", as(pdf) replace 

restore






