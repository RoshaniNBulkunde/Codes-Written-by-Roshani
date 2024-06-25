
/* Subgroup analysis by caste, wealth, and rural** This file is to see the impact on subgroups: 
1. Social status: a. poor b. middle c. rich
2. Caste: a.Schedulde caste/tribe b. OBC c. all other caste 
3. Place of residence: a. Urban b. Rural
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
              * Analysis by social status *
*---------------------------------------------------------------------------*/

*=============================================================*
*                  Social status: Poor                        *
*=============================================================*

* figure 3.1
preserve

keep if poor==1
collapse preg_regist [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist0 yob, ms(Oh) mcolor(navy) || ///
scatter preg_regist1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Pregnancy Registration) ylabel(0.8(0.05)1)  xlabel(2010(1)2020) ///
title("Poor") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.1.pdf", as(pdf) replace 

restore

* figure 3.2: At least one ANC visit
preserve

keep if poor==1 
collapse anc_visit [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit0 yob, ms(Oh) mcolor(navy) || ///
scatter anc_visit1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Atleast one ANC visit) ylabel(0.75(0.05)1)   xlabel(2010(1)2020) ///
title("Poor") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.2.pdf", as(pdf) replace 

restore


*figure 3.3: Total ANC visits
preserve

keep if poor==1
collapse tot_anc9 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9, by(eligible) veryshortlabel
twoway scatteri 5 2016.5 5 2017.5 5 2018.5 5 2019.5, recast(area) color(gray*0.2) || ///
scatteri 5 2017.5 5 2018.5 5 2019.5 5 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc90 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc91 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Total ANC visits) ylabel(3(0.5)5)   xlabel(2010(1)2020) ///
title("Poor") ///
text(4.7 2017 "Partially" "affected", size(small)) ///
text(4.7 2018.5 "         Fully", size(small)) ///
text(4.65 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.3.pdf", as(pdf) replace 

restore


* figure 3.4
preserve

keep if poor==1
collapse del_healthf [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf0 yob, ms(Oh) mcolor(navy) || ///
scatter del_healthf1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Delivery at health facility) ylabel(0.6(0.05)1)   xlabel(2010(1)2020) ///
title("Poor") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.985 2018.5 "         Fully", size(small)) ///
text(0.972 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.4.pdf", as(pdf) replace 

restore


* figure 3.5
preserve

keep if poor==1
collapse ch_firstvac [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion reported by card or mother) ylabel(0.5(0.1)1)   xlabel(2010(1)2020) ///
title("Poor") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.5.pdf", as(pdf) replace 

restore


* figure 3.6
preserve

keep if poor==1
collapse ch_firstvac_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion by card) ylabel(0.6(0.1)1)   xlabel(2010(1)2020) ///
title("Poor") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.6.pdf", as(pdf) replace 

restore


* figure 3.7:Received BCG reported by mother or card
preserve

keep if poor==1
collapse ch_bcg [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by mother or card) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.7.pdf", as(pdf) replace 

restore

* figure 3.8:Received BCG by  card
preserve

keep if poor==1
collapse ch_bcg_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by card) ylabel(0.94(0.01)1) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.993 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.8.pdf", as(pdf) replace 

restore

* figure 3.9: Received first dose Hep-B reported by mother or card
preserve

keep if poor==1
collapse ch_hep1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.9.pdf", as(pdf) replace 

restore

* figure 3.10: Received first dose Hep-B reported by card
preserve

keep if poor==1 
collapse ch_hep1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by card) ylabel(0.75(0.05)1) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.98 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.10.pdf", as(pdf) replace 

restore

* figure 3.11
preserve

keep if poor==1
collapse ch_dpt1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.11.pdf", as(pdf) replace 

restore

* figure 3.12
preserve

keep if poor==1
collapse ch_dpt1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by card) ylabel(0.7(0.1)1) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.12.pdf", as(pdf) replace 

restore

* figure 3.13
preserve

keep if poor==1
collapse ch_opv1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV reported by mother or card) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.985 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.13.pdf", as(pdf) replace 

restore

* figure 3.14
preserve

keep if poor==1
collapse ch_opv1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.992 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.14.pdf", as(pdf) replace 

restore

* figure 3.15
preserve

keep if poor==1
collapse m_anemia [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_anemia, by(eligible) veryshortlabel
twoway scatteri 0.7 2016.5 0.7 2017.5 0.7 2018.5 0.7 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.7 2017.5 0.7 2018.5 0.7 2019.5 0.7 2020.5, recast(area) color(gray*0.3) || ///
scatter m_anemia0 yob, ms(Oh) mcolor(navy) || ///
scatter m_anemia1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother Anemic") ylabel(0.5(0.05)0.7) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.68 2017 "Partially" "affected", size(small)) ///
text(0.68 2018.5 "         Fully", size(small)) ///
text(0.675 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.15.pdf", as(pdf) replace 

restore

* figure 3.16
preserve

keep if poor==1
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
title("Poor") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.16.pdf", as(pdf) replace 

restore


* figure 3.17
preserve

keep if poor==1
collapse dur_iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate dur_iron_spplm, by(eligible) veryshortlabel
twoway scatteri 120 2016.5 120 2017.5 120 2018.5 120 2019.5, recast(area) color(gray*0.2) || ///
scatteri 120 2017.5 120 2018.5 120 2019.5 120 2020.5, recast(area) color(gray*0.3) || ///
scatter dur_iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter dur_iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Days iron tablets or syrup taken") ylabel(70(10)120) xlabel(2010(1)2020) ///
title("Poor") ///
text(115 2017 "Partially" "affected", size(small)) ///
text(115 2018.5 "         Fully", size(small)) ///
text(113 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.17.pdf", as(pdf) replace 

restore

* figure 3.18
preserve

keep if poor==1
collapse ch_bw [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bw, by(eligible) veryshortlabel
twoway scatteri 2850 2016.5 2850 2017.5 2850 2018.5 2850 2019.5, recast(area) color(gray*0.2) || ///
scatteri 2850 2017.5 2850 2018.5 2850 2019.5 2850 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bw0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bw1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Child birth weight") ylabel(2700(50)2850) xlabel(2010(1)2020) ///
title("Poor") ///
text(2825 2017 "Partially" "affected", size(small)) ///
text(2825 2018.5 "         Fully", size(small)) ///
text(2822 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.18.pdf", as(pdf) replace 

restore


* figure 3.19
preserve

keep if poor==1
collapse neo_mort [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort, by(eligible) veryshortlabel
twoway scatteri 0.06 2016.5 0.06 2017.5 0.06 2018.5 0.06 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.06 2017.5 0.06 2018.5 0.06 2019.5 0.06 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort0 yob, ms(Oh) mcolor(navy) || ///
scatter neo_mort1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Neonatal Mortality") ylabel(0.02(0.01)0.06) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.058 2017 "Partially" "affected", size(small)) ///
text(0.058 2018.5 "         Fully", size(small)) ///
text(0.0565 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.19.pdf", as(pdf) replace 

restore

* figure 3.20
preserve

keep if poor==1
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
title("Poor") ///
text(24 2017 "Partially" "affected", size(small)) ///
text(24.2 2018.5 "         Fully", size(small)) ///
text(23.7 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.20.pdf", as(pdf) replace 

restore

* figure 3.21
preserve

keep if poor==1
collapse mod_svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate mod_svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.55 2016.5 0.55 2017.5 0.55 2018.5 0.55 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.55 2017.5 0.55 2018.5 0.55 2019.5 0.55 2020.5, recast(area) color(gray*0.3) || ///
scatter mod_svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter mod_svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Moderately or severely stunted") ylabel(0.25(0.05)0.55) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.52 2017 "Partially" "affected", size(small)) ///
text(0.52 2018.5 "         Fully", size(small)) ///
text(0.50 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.21.pdf", as(pdf) replace 

restore


* figure 3.22
preserve

keep if poor==1
collapse svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.3 2016.5 0.3 2017.5 0.3 2018.5 0.3 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.3 2017.5 0.3 2018.5 0.3 2019.5 0.3 2020.5, recast(area) color(gray*0.3) || ///
scatter svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Not first born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Severely stunted")  ylabel(0.1(0.05)0.3) xlabel(2010(1)2020) ///
title("Poor") ///
text(0.25 2017 "Partially" "affected", size(small)) ///
text(0.25 2018.5 "         Fully", size(small)) ///
text(0.24 2019 "affected      ", size(small))
graph export "$outputdir/Fig3.22.pdf", as(pdf) replace 

restore

*=============================================================*
*                  Social status: Middle                       *
*=============================================================*

* figure 4.1
preserve

keep if middle==1
collapse preg_regist [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist0 yob, ms(Oh) mcolor(navy) || ///
scatter preg_regist1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Pregnancy Registration) ylabel(0.85(0.05)1)  xlabel(2010(1)2020) ///
title("Middle") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.1.pdf", as(pdf) replace 

restore

* figure 4.2: At least one ANC visit
preserve

keep if middle==1
collapse anc_visit [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit0 yob, ms(Oh) mcolor(navy) || ///
scatter anc_visit1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Atleast one ANC visit) ylabel(0.85(0.05)1)   xlabel(2010(1)2020) ///
title("Middle") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.2.pdf", as(pdf) replace 

restore


*figure 4.3: Total ANC visits
preserve

keep if middle==1
collapse tot_anc9 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9, by(eligible) veryshortlabel
twoway scatteri 6 2016.5 6 2017.5 6 2018.5 6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 6 2017.5 6 2018.5 6 2019.5 6 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc90 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc91 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Total ANC visits) ylabel(4(0.5)6)   xlabel(2010(1)2020) ///
title("Middle") ///
text(5.7 2017 "Partially" "affected", size(small)) ///
text(5.7 2018.5 "         Fully", size(small)) ///
text(5.65 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.3.pdf", as(pdf) replace 

restore


* figure 4.4
preserve

keep if middle==1
collapse del_healthf [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf0 yob, ms(Oh) mcolor(navy) || ///
scatter del_healthf1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Delivery at health facility) ylabel(0.8(0.05)1)   xlabel(2010(1)2020) ///
title("Middle") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.985 2018.5 "         Fully", size(small)) ///
text(0.972 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.4.pdf", as(pdf) replace 

restore


* figure 4.5
preserve

keep if middle==1
collapse ch_firstvac [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion reported by card or mother) ylabel(0.5(0.1)1)   xlabel(2010(1)2020) ///
title("Middle") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.5.pdf", as(pdf) replace 

restore


* figure 4.6
preserve

keep if middle==1
collapse ch_firstvac_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion by card) ylabel(0.6(0.1)1)   xlabel(2010(1)2020) ///
title("Middle") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.6.pdf", as(pdf) replace 

restore


* figure 4.7:Received BCG reported by mother or card
preserve

keep if middle==1
collapse ch_bcg [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by mother or card) ylabel(0.85(0.05)1) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.7.pdf", as(pdf) replace 

restore

* figure 4.8:Received BCG by  card
preserve

keep if middle==1
collapse ch_bcg_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.993 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.8.pdf", as(pdf) replace 

restore

* figure 4.9: Received first dose Hep-B reported by mother or card
preserve

keep if middle==1
collapse ch_hep1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.9.pdf", as(pdf) replace 

restore

* figure 4.10: Received first dose Hep-B reported by card
preserve

keep if middle==1 
collapse ch_hep1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by card) ylabel(0.75(0.05)1) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.98 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.10.pdf", as(pdf) replace 

restore

* figure 4.11
preserve

keep if middle==1
collapse ch_dpt1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.11.pdf", as(pdf) replace 

restore

* figure 4.12
preserve

keep if middle==1
collapse ch_dpt1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by card) ylabel(0.7(0.1)1) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.12.pdf", as(pdf) replace 

restore

* figure 4.13
preserve

keep if middle==1
collapse ch_opv1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV reported by mother or card) ylabel(0.85(0.05)1) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.985 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.13.pdf", as(pdf) replace 

restore

* figure 4.14
preserve

keep if middle==1
collapse ch_opv1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.992 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.14.pdf", as(pdf) replace 

restore

* figure 4.15
preserve

keep if middle==1
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
title("Middle") ///
text(0.63 2017 "Partially" "affected", size(small)) ///
text(0.63 2018.5 "         Fully", size(small)) ///
text(0.625 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.15.pdf", as(pdf) replace 

restore

* figure 4.16
preserve

keep if middle==1
collapse iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate iron_spplm, by(eligible) veryshortlabel
twoway scatteri 0.95 2016.5 0.95 2017.5 0.95 2018.5 0.95 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.95 2017.5 0.95 2018.5 0.95 2019.5 0.95 2020.5, recast(area) color(gray*0.3) || ///
scatter iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("During pregnancy, given or bought iron tablets/syrup") ylabel(0.8(0.05)0.95) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.94 2017 "Partially" "affected", size(small)) ///
text(0.94 2018.5 "         Fully", size(small)) ///
text(0.935 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.16.pdf", as(pdf) replace 

restore


* figure 4.17
preserve

keep if middle==1
collapse dur_iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate dur_iron_spplm, by(eligible) veryshortlabel
twoway scatteri 140 2016.5 140 2017.5 140 2018.5 140 2019.5, recast(area) color(gray*0.2) || ///
scatteri 140 2017.5 140 2018.5 140 2019.5 140 2020.5, recast(area) color(gray*0.3) || ///
scatter dur_iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter dur_iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Days iron tablets or syrup taken") ylabel(90(10)140) xlabel(2010(1)2020) ///
title("Middle") ///
text(135 2017 "Partially" "affected", size(small)) ///
text(135 2018.5 "         Fully", size(small)) ///
text(133 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.17.pdf", as(pdf) replace 

restore

* figure 4.18
preserve

keep if middle==1
collapse ch_bw [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bw, by(eligible) veryshortlabel
twoway scatteri 2850 2016.5 2850 2017.5 2850 2018.5 2850 2019.5, recast(area) color(gray*0.2) || ///
scatteri 2850 2017.5 2850 2018.5 2850 2019.5 2850 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bw0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bw1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Child birth weight") ylabel(2700(50)2850) xlabel(2010(1)2020) ///
title("Middle") ///
text(2835 2017 "Partially" "affected", size(small)) ///
text(2835 2018.5 "         Fully", size(small)) ///
text(2832 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.18.pdf", as(pdf) replace 

restore


* figure 4.19
preserve

keep if middle==1
collapse neo_mort [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort, by(eligible) veryshortlabel
twoway scatteri 0.05 2016.5 0.05 2017.5 0.05 2018.5 0.05 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.05 2017.5 0.05 2018.5 0.05 2019.5 0.05 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort0 yob, ms(Oh) mcolor(navy) || ///
scatter neo_mort1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Neonatal Mortality") ylabel(0.01(0.01)0.05) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.048 2017 "Partially" "affected", size(small)) ///
text(0.048 2018.5 "         Fully", size(small)) ///
text(0.0465 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.19.pdf", as(pdf) replace 

restore

* figure 4.20
preserve

keep if middle==1
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
title("Middle") ///
text(24 2017 "Partially" "affected", size(small)) ///
text(24.2 2018.5 "         Fully", size(small)) ///
text(23.7 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.20.pdf", as(pdf) replace 

restore

* figure 4.21
preserve

keep if middle==1
collapse mod_svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate mod_svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.55 2016.5 0.55 2017.5 0.55 2018.5 0.55 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.55 2017.5 0.55 2018.5 0.55 2019.5 0.55 2020.5, recast(area) color(gray*0.3) || ///
scatter mod_svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter mod_svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Moderately or severely stunted") ylabel(0.25(0.05)0.55) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.52 2017 "Partially" "affected", size(small)) ///
text(0.52 2018.5 "         Fully", size(small)) ///
text(0.50 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.21.pdf", as(pdf) replace 

restore


* figure 4.22
preserve

keep if middle==1
collapse svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.2 2016.5 0.2 2017.5 0.2 2018.5 0.2 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.2 2017.5 0.2 2018.5 0.2 2019.5 0.2 2020.5, recast(area) color(gray*0.3) || ///
scatter svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Not first born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Severely stunted")  ylabel(0.05(0.05)0.2) xlabel(2010(1)2020) ///
title("Middle") ///
text(0.19 2017 "Partially" "affected", size(small)) ///
text(0.19 2018.5 "         Fully", size(small)) ///
text(0.185 2019 "affected      ", size(small))
graph export "$outputdir/Fig4.22.pdf", as(pdf) replace 

restore

*=============================================================*
*                  Social status: Rich                       *
*=============================================================*

* figure 5.1
preserve

keep if rich==1
collapse preg_regist [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist0 yob, ms(Oh) mcolor(navy) || ///
scatter preg_regist1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Pregnancy Registration) ylabel(0.85(0.05)1)  xlabel(2010(1)2020) ///
title("Rich") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.1.pdf", as(pdf) replace 

restore

* figure 5.2: At least one ANC visit
preserve

keep if rich==1
collapse anc_visit [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit0 yob, ms(Oh) mcolor(navy) || ///
scatter anc_visit1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Atleast one ANC visit) ylabel(0.9(0.02)1)   xlabel(2010(1)2020) ///
title("Rich") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.994 2018.5 "         Fully", size(small)) ///
text(0.987 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.2.pdf", as(pdf) replace 

restore


*figure 5.3: Total ANC visits
preserve

keep if rich==1
collapse tot_anc9 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9, by(eligible) veryshortlabel
twoway scatteri 6 2016.5 6 2017.5 6 2018.5 6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 6 2017.5 6 2018.5 6 2019.5 6 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc90 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc91 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Total ANC visits) ylabel(5(0.2)6)   xlabel(2010(1)2020) ///
title("Rich") ///
text(5.9 2017 "Partially" "affected", size(small)) ///
text(5.9 2018.5 "         Fully", size(small)) ///
text(5.85 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.3.pdf", as(pdf) replace 

restore


* figure 5.4
preserve

keep if rich==1
collapse del_healthf [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf0 yob, ms(Oh) mcolor(navy) || ///
scatter del_healthf1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Delivery at health facility) ylabel(0.9(0.02)1)   xlabel(2010(1)2020) ///
title("Rich") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.985 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.4.pdf", as(pdf) replace 

restore


* figure 5.5
preserve

keep if rich==1
collapse ch_firstvac [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion reported by card or mother) ylabel(0.6(0.1)1)   xlabel(2010(1)2020) ///
title("Rich") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.5.pdf", as(pdf) replace 

restore


* figure 5.6
preserve

keep if rich==1
collapse ch_firstvac_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion by card) ylabel(0.6(0.1)1)   xlabel(2010(1)2020) ///
title("Rich") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.6.pdf", as(pdf) replace 

restore


* figure 5.7:Received BCG reported by mother or card
preserve

keep if rich==1
collapse ch_bcg [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by mother or card) ylabel(0.88(0.02)1) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.7.pdf", as(pdf) replace 

restore

* figure 5.8:Received BCG by  card
preserve

keep if rich==1
collapse ch_bcg_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by card) ylabel(0.96(0.01)1) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.993 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.8.pdf", as(pdf) replace 

restore

* figure 5.9: Received first dose Hep-B reported by mother or card
preserve

keep if rich==1
collapse ch_hep1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by mother or card) ylabel(0.75(0.05)1) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.9.pdf", as(pdf) replace 

restore

* figure 5.10: Received first dose Hep-B reported by card
preserve

keep if rich==1 
collapse ch_hep1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by card) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.98 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.10.pdf", as(pdf) replace 

restore

* figure 5.11
preserve

keep if rich==1
collapse ch_dpt1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.11.pdf", as(pdf) replace 

restore

* figure 5.12
preserve

keep if rich==1
collapse ch_dpt1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by card) ylabel(0.7(0.1)1) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.12.pdf", as(pdf) replace 

restore

* figure 5.13
preserve

keep if rich==1
collapse ch_opv1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV reported by mother or card) ylabel(0.85(0.05)1) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.985 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.13.pdf", as(pdf) replace 

restore

* figure 5.14
preserve

keep if rich==1
collapse ch_opv1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.992 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.14.pdf", as(pdf) replace 

restore

* figure 5.15
preserve

keep if rich==1
collapse m_anemia [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_anemia, by(eligible) veryshortlabel
twoway scatteri 0.6 2016.5 0.6 2017.5 0.6 2018.5 0.6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.6 2017.5 0.6 2018.5 0.6 2019.5 0.6 2020.5, recast(area) color(gray*0.3) || ///
scatter m_anemia0 yob, ms(Oh) mcolor(navy) || ///
scatter m_anemia1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother Anemic") ylabel(0.48(0.02)0.6) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.58 2017 "Partially" "affected", size(small)) ///
text(0.58 2018.5 "         Fully", size(small)) ///
text(0.575 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.15.pdf", as(pdf) replace 

restore

* figure 5.16
preserve

keep if rich==1
collapse iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate iron_spplm, by(eligible) veryshortlabel
twoway scatteri 0.95 2016.5 0.95 2017.5 0.95 2018.5 0.95 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.95 2017.5 0.95 2018.5 0.95 2019.5 0.95 2020.5, recast(area) color(gray*0.3) || ///
scatter iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("During pregnancy, given or bought iron tablets/syrup") ylabel(0.85(0.02)0.95) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.94 2017 "Partially" "affected", size(small)) ///
text(0.94 2018.5 "         Fully", size(small)) ///
text(0.935 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.16.pdf", as(pdf) replace 

restore


* figure 5.17
preserve

keep if rich==1
collapse dur_iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate dur_iron_spplm, by(eligible) veryshortlabel
twoway scatteri 150 2016.5 150 2017.5 150 2018.5 150 2019.5, recast(area) color(gray*0.2) || ///
scatteri 150 2017.5 150 2018.5 150 2019.5 150 2020.5, recast(area) color(gray*0.3) || ///
scatter dur_iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter dur_iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Days iron tablets or syrup taken") ylabel(110(10)150) xlabel(2010(1)2020) ///
title("Rich") ///
text(148 2017 "Partially" "affected", size(small)) ///
text(148 2018.5 "         Fully", size(small)) ///
text(145 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.17.pdf", as(pdf) replace 

restore

* figure 5.18
preserve

keep if rich==1
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
title("Rich") ///
text(2880 2017 "Partially" "affected", size(small)) ///
text(2880 2018.5 "         Fully", size(small)) ///
text(2877 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.18.pdf", as(pdf) replace 

restore


* figure 5.19
preserve

keep if rich==1
collapse neo_mort [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort, by(eligible) veryshortlabel
twoway scatteri 0.03 2016.5 0.03 2017.5 0.03 2018.5 0.03 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.03 2017.5 0.03 2018.5 0.03 2019.5 0.03 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort0 yob, ms(Oh) mcolor(navy) || ///
scatter neo_mort1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Neonatal Mortality") ylabel(0(0.01)0.03) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.028 2017 "Partially" "affected", size(small)) ///
text(0.028 2018.5 "         Fully", size(small)) ///
text(0.0265 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.19.pdf", as(pdf) replace 

restore

* figure 5.20
preserve

keep if rich==1
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
title("Rich") ///
text(24 2017 "Partially" "affected", size(small)) ///
text(24.2 2018.5 "         Fully", size(small)) ///
text(23.7 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.20.pdf", as(pdf) replace 

restore

* figure 5.21
preserve

keep if rich==1
collapse mod_svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate mod_svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.35 2016.5 0.35 2017.5 0.35 2018.5 0.35 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.35 2017.5 0.35 2018.5 0.35 2019.5 0.35 2020.5, recast(area) color(gray*0.3) || ///
scatter mod_svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter mod_svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Moderately or severely stunted") ylabel(0.15(0.05)0.35) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.34 2017 "Partially" "affected", size(small)) ///
text(0.34 2018.5 "         Fully", size(small)) ///
text(0.33 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.21.pdf", as(pdf) replace 

restore


* figure 5.22
preserve

keep if rich==1
collapse svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.15 2016.5 0.15 2017.5 0.15 2018.5 0.15 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.15 2017.5 0.15 2018.5 0.15 2019.5 0.15 2020.5, recast(area) color(gray*0.3) || ///
scatter svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Not first born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Severely stunted")  ylabel(0(0.05)0.15) xlabel(2010(1)2020) ///
title("Rich") ///
text(0.14 2017 "Partially" "affected", size(small)) ///
text(0.14 2018.5 "         Fully", size(small)) ///
text(0.135 2019 "affected      ", size(small))
graph export "$outputdir/Fig5.22.pdf", as(pdf) replace 

restore


/*---------------------------------------------------------------------------*
              * Analysis by caste *
*---------------------------------------------------------------------------*/

*=============================================================*
*                  Caste: Scheduled caste/Tribe               *
*=============================================================*

* figure 6.1
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse preg_regist [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist0 yob, ms(Oh) mcolor(navy) || ///
scatter preg_regist1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Pregnancy Registration) ylabel(0.8(0.05)1)  xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.1.pdf", as(pdf) replace 

restore

* figure 6.2: At least one ANC visit
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse anc_visit [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit0 yob, ms(Oh) mcolor(navy) || ///
scatter anc_visit1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Atleast one ANC visit) ylabel(0.75(0.05)1)   xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.2.pdf", as(pdf) replace 

restore


*figure 6.3: Total ANC visits
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse tot_anc9 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9, by(eligible) veryshortlabel
twoway scatteri 6 2016.5 6 2017.5 6 2018.5 6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 6 2017.5 6 2018.5 6 2019.5 6 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc90 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc91 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Total ANC visits) ylabel(3.5(0.5)6)   xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.735 2017 "Partially" "affected", size(small)) ///
text(0.736 2018.5 "         Fully", size(small)) ///
text(0.73 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.3.pdf", as(pdf) replace 

restore


* figure 6.4
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse del_healthf [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf0 yob, ms(Oh) mcolor(navy) || ///
scatter del_healthf1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Delivery at health facility) ylabel(0.65(0.05)1)   xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.985 2018.5 "         Fully", size(small)) ///
text(0.972 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.4.pdf", as(pdf) replace 

restore


* figure 6.5
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse ch_firstvac [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion reported by card or mother) ylabel(0.5(0.1)1)   xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.5.pdf", as(pdf) replace 

restore


* figure 6.6
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse ch_firstvac_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion by card) ylabel(0.5(0.1)1)   xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.6.pdf", as(pdf) replace 

restore


* figure 6.7:Received BCG reported by mother or card
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse ch_bcg [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by mother or card) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.7.pdf", as(pdf) replace 

restore

* figure 6.8:Received BCG by  card
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse ch_bcg_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.993 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.8.pdf", as(pdf) replace 

restore

* figure 6.9: Received first dose Hep-B reported by mother or card
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse ch_hep1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.9.pdf", as(pdf) replace 

restore

* figure 6.10: Received first dose Hep-B reported by card
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse ch_hep1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by card) ylabel(0.75(0.05)1) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.98 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.10.pdf", as(pdf) replace 

restore

* figure 6.11
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse ch_dpt1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.11.pdf", as(pdf) replace 

restore

* figure 6.12
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse ch_dpt1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by card) ylabel(0.7(0.1)1) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.12.pdf", as(pdf) replace 

restore

* figure 6.13
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse ch_opv1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV reported by mother or card) ylabel(0.85(0.05)1) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.985 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.13.pdf", as(pdf) replace 

restore

* figure 6.14
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse ch_opv1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.992 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.14.pdf", as(pdf) replace 

restore

* figure 6.15
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse m_anemia [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_anemia, by(eligible) veryshortlabel
twoway scatteri 0.7 2016.5 0.7 2017.5 0.7 2018.5 0.7 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.7 2017.5 0.7 2018.5 0.7 2019.5 0.7 2020.5, recast(area) color(gray*0.3) || ///
scatter m_anemia0 yob, ms(Oh) mcolor(navy) || ///
scatter m_anemia1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother Anemic") ylabel(0.5(0.05)0.7) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.68 2017 "Partially" "affected", size(small)) ///
text(0.68 2018.5 "         Fully", size(small)) ///
text(0.675 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.15.pdf", as(pdf) replace 

restore

* figure 6.16
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate iron_spplm, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("During pregnancy, given or bought iron tablets/syrup") ylabel(0.75(0.05)1) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.16.pdf", as(pdf) replace 

restore


* figure 6.17
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
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
title("Scheduled caste/tribe") ///
text(135 2017 "Partially" "affected", size(small)) ///
text(135 2018.5 "         Fully", size(small)) ///
text(133 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.17.pdf", as(pdf) replace 

restore

* figure 6.18
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse ch_bw [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bw, by(eligible) veryshortlabel
twoway scatteri 2850 2016.5 2850 2017.5 2850 2018.5 2850 2019.5, recast(area) color(gray*0.2) || ///
scatteri 2850 2017.5 2850 2018.5 2850 2019.5 2850 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bw0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bw1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Child birth weight") ylabel(2700(50)2850) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(2825 2017 "Partially" "affected", size(small)) ///
text(2825 2018.5 "         Fully", size(small)) ///
text(2822 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.18.pdf", as(pdf) replace 

restore


* figure 6.19
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
collapse neo_mort [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort, by(eligible) veryshortlabel
twoway scatteri 0.05 2016.5 0.05 2017.5 0.05 2018.5 0.05 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.05 2017.5 0.05 2018.5 0.05 2019.5 0.05 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort0 yob, ms(Oh) mcolor(navy) || ///
scatter neo_mort1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Neonatal Mortality") ylabel(0.01(0.01)0.05) xlabel(2010(1)2020) ///
title("Scheduled caste/tribe") ///
text(0.048 2017 "Partially" "affected", size(small)) ///
text(0.048 2018.5 "         Fully", size(small)) ///
text(0.0465 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.19.pdf", as(pdf) replace 

restore

* figure 6.20
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
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
title("Scheduled caste/tribe") ///
text(24 2017 "Partially" "affected", size(small)) ///
text(24.2 2018.5 "         Fully", size(small)) ///
text(23.7 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.20.pdf", as(pdf) replace 

restore

* figure 6.21
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
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
title("Scheduled caste/tribe") ///
text(0.48 2017 "Partially" "affected", size(small)) ///
text(0.48 2018.5 "         Fully", size(small)) ///
text(0.47 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.21.pdf", as(pdf) replace 

restore


* figure 6.22
preserve

keep if sch_caste_tribe==1 // Keep only scheduled caste or tribe sample
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
title("Scheduled caste/tribe") ///
text(0.23 2017 "Partially" "affected", size(small)) ///
text(0.23 2018.5 "         Fully", size(small)) ///
text(0.24 2019 "affected      ", size(small))
graph export "$outputdir/Fig6.22.pdf", as(pdf) replace 

restore

*=============================================================*
*                  Caste: OBC              *
*=============================================================*

* figure 7.1
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse preg_regist [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist0 yob, ms(Oh) mcolor(navy) || ///
scatter preg_regist1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Pregnancy Registration) ylabel(0.8(0.05)1)  xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.1.pdf", as(pdf) replace 

restore

* figure 7.2: At least one ANC visit
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse anc_visit [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit0 yob, ms(Oh) mcolor(navy) || ///
scatter anc_visit1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Atleast one ANC visit) ylabel(0.8(0.05)1)   xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.2.pdf", as(pdf) replace 

restore


*figure 7.3: Total ANC visits
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse tot_anc9 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9, by(eligible) veryshortlabel
twoway scatteri 6 2016.5 6 2017.5 6 2018.5 6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 6 2017.5 6 2018.5 6 2019.5 6 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc90 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc91 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Total ANC visits) ylabel(4(0.5)6)   xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(5.5 2017 "Partially" "affected", size(small)) ///
text(5.5 2018.5 "         Fully", size(small)) ///
text(5.4 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.3.pdf", as(pdf) replace 

restore


* figure 7.4
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse del_healthf [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf0 yob, ms(Oh) mcolor(navy) || ///
scatter del_healthf1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Delivery at health facility) ylabel(0.75(0.05)1)   xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.985 2018.5 "         Fully", size(small)) ///
text(0.972 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.4.pdf", as(pdf) replace 

restore


* figure 7.5
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse ch_firstvac [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion reported by card or mother) ylabel(0.5(0.1)1)   xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.5.pdf", as(pdf) replace 

restore


* figure 7.6
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse ch_firstvac_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion by card) ylabel(0.6(0.1)1)   xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.6.pdf", as(pdf) replace 

restore


* figure 7.7:Received BCG reported by mother or card
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse ch_bcg [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by mother or card) ylabel(0.85(0.05)1) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.7.pdf", as(pdf) replace 

restore

* figure 7.8:Received BCG by  card
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse ch_bcg_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.993 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.8.pdf", as(pdf) replace 

restore

* figure 7.9: Received first dose Hep-B reported by mother or card
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse ch_hep1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.9.pdf", as(pdf) replace 

restore

* figure 7.10: Received first dose Hep-B reported by card
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse ch_hep1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by card) ylabel(0.75(0.05)1) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.98 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.10.pdf", as(pdf) replace 

restore

* figure 7.11
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse ch_dpt1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.11.pdf", as(pdf) replace 

restore

* figure 7.12
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse ch_dpt1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by card) ylabel(0.7(0.1)1) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.12.pdf", as(pdf) replace 

restore

* figure 7.13
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse ch_opv1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV reported by mother or card) ylabel(0.85(0.05)1) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.985 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.13.pdf", as(pdf) replace 

restore

* figure 7.14
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse ch_opv1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.992 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.14.pdf", as(pdf) replace 

restore

* figure 7.15
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse m_anemia [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_anemia, by(eligible) veryshortlabel
twoway scatteri 0.6 2016.5 0.6 2017.5 0.6 2018.5 0.6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.6 2017.5 0.6 2018.5 0.6 2019.5 0.6 2020.5, recast(area) color(gray*0.3) || ///
scatter m_anemia0 yob, ms(Oh) mcolor(navy) || ///
scatter m_anemia1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother Anemic") ylabel(0.5(0.05)0.6) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.58 2017 "Partially" "affected", size(small)) ///
text(0.58 2018.5 "         Fully", size(small)) ///
text(0.575 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.15.pdf", as(pdf) replace 

restore

* figure 7.16
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate iron_spplm, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("During pregnancy, given or bought iron tablets/syrup") ylabel(0.75(0.05)1) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.16.pdf", as(pdf) replace 

restore


* figure 7.17
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse dur_iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate dur_iron_spplm, by(eligible) veryshortlabel
twoway scatteri 140 2016.5 140 2017.5 140 2018.5 140 2019.5, recast(area) color(gray*0.2) || ///
scatteri 140 2017.5 140 2018.5 140 2019.5 140 2020.5, recast(area) color(gray*0.3) || ///
scatter dur_iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter dur_iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Days iron tablets or syrup taken") ylabel(90(10)140) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(135 2017 "Partially" "affected", size(small)) ///
text(135 2018.5 "         Fully", size(small)) ///
text(133 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.17.pdf", as(pdf) replace 

restore

* figure 7.18
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
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
title("Caste: OBC") ///
text(2875 2017 "Partially" "affected", size(small)) ///
text(2875 2018.5 "         Fully", size(small)) ///
text(2872 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.18.pdf", as(pdf) replace 

restore


* figure 7.19
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
collapse neo_mort [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort, by(eligible) veryshortlabel
twoway scatteri 0.05 2016.5 0.05 2017.5 0.05 2018.5 0.05 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.05 2017.5 0.05 2018.5 0.05 2019.5 0.05 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort0 yob, ms(Oh) mcolor(navy) || ///
scatter neo_mort1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Neonatal Mortality") ylabel(0.01(0.01)0.05) xlabel(2010(1)2020) ///
title("Caste: OBC") ///
text(0.048 2017 "Partially" "affected", size(small)) ///
text(0.048 2018.5 "         Fully", size(small)) ///
text(0.0465 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.19.pdf", as(pdf) replace 

restore

* figure 7.20
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
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
title("Caste: OBC") ///
text(24 2017 "Partially" "affected", size(small)) ///
text(24.2 2018.5 "         Fully", size(small)) ///
text(23.7 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.20.pdf", as(pdf) replace 

restore

* figure 7.21
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
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
title("Caste: OBC") ///
text(0.48 2017 "Partially" "affected", size(small)) ///
text(0.48 2018.5 "         Fully", size(small)) ///
text(0.47 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.21.pdf", as(pdf) replace 

restore


* figure 7.22
preserve

keep if obc==1 // Keep only the sample of women belongs to obc caste
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
title("Caste: OBC") ///
text(0.23 2017 "Partially" "affected", size(small)) ///
text(0.23 2018.5 "         Fully", size(small)) ///
text(0.24 2019 "affected      ", size(small))
graph export "$outputdir/Fig7.22.pdf", as(pdf) replace 

restore

*=============================================================*
*                  Caste: All other caste                 *
*=============================================================*

* figure 8.1
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse preg_regist [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist0 yob, ms(Oh) mcolor(navy) || ///
scatter preg_regist1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Pregnancy Registration) ylabel(0.8(0.05)1)  xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.1.pdf", as(pdf) replace 

restore

* figure 8.2: At least one ANC visit
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse anc_visit [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit0 yob, ms(Oh) mcolor(navy) || ///
scatter anc_visit1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Atleast one ANC visit) ylabel(0.85(0.05)1)   xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.2.pdf", as(pdf) replace 

restore


*figure 8.3: Total ANC visits
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse tot_anc9 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9, by(eligible) veryshortlabel
twoway scatteri 6 2016.5 6 2017.5 6 2018.5 6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 6 2017.5 6 2018.5 6 2019.5 6 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc90 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc91 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Total ANC visits) ylabel(4(0.5)6)   xlabel(2010(1)2020) ///
title("All other caste") ///
text(5.5 2017 "Partially" "affected", size(small)) ///
text(5.5 2018.5 "         Fully", size(small)) ///
text(5.4 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.3.pdf", as(pdf) replace 

restore


* figure 8.4
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse del_healthf [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf0 yob, ms(Oh) mcolor(navy) || ///
scatter del_healthf1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Delivery at health facility) ylabel(0.75(0.05)1)   xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.985 2018.5 "         Fully", size(small)) ///
text(0.972 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.4.pdf", as(pdf) replace 

restore


* figure 8.5
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse ch_firstvac [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion reported by card or mother) ylabel(0.5(0.1)1)   xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.5.pdf", as(pdf) replace 

restore


* figure 8.6
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse ch_firstvac_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion by card) ylabel(0.6(0.1)1)   xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.6.pdf", as(pdf) replace 

restore


* figure 8.7:Received BCG reported by mother or card
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse ch_bcg [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by mother or card) ylabel(0.85(0.05)1) xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.7.pdf", as(pdf) replace 

restore

* figure 8.8:Received BCG by  card
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse ch_bcg_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.993 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.8.pdf", as(pdf) replace 

restore

* figure 8.9: Received first dose Hep-B reported by mother or card
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse ch_hep1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.9.pdf", as(pdf) replace 

restore

* figure 8.10: Received first dose Hep-B reported by card
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse ch_hep1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by card) ylabel(0.75(0.05)1) xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.98 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.10.pdf", as(pdf) replace 

restore

* figure 8.11
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse ch_dpt1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.11.pdf", as(pdf) replace 

restore

* figure 8.12
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse ch_dpt1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by card) ylabel(0.7(0.1)1) xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.12.pdf", as(pdf) replace 

restore

* figure 8.13
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse ch_opv1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV reported by mother or card) ylabel(0.85(0.05)1) xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.985 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.13.pdf", as(pdf) replace 

restore

* figure 8.14
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse ch_opv1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.992 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.14.pdf", as(pdf) replace 

restore

* figure 8.15
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse m_anemia [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_anemia, by(eligible) veryshortlabel
twoway scatteri 0.6 2016.5 0.6 2017.5 0.6 2018.5 0.6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.6 2017.5 0.6 2018.5 0.6 2019.5 0.6 2020.5, recast(area) color(gray*0.3) || ///
scatter m_anemia0 yob, ms(Oh) mcolor(navy) || ///
scatter m_anemia1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother Anemic") ylabel(0.5(0.05)0.6) xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.58 2017 "Partially" "affected", size(small)) ///
text(0.58 2018.5 "         Fully", size(small)) ///
text(0.575 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.15.pdf", as(pdf) replace 

restore

* figure 8.16
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate iron_spplm, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("During pregnancy, given or bought iron tablets/syrup") ylabel(0.75(0.05)1) xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.16.pdf", as(pdf) replace 

restore


* figure 8.17
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse dur_iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate dur_iron_spplm, by(eligible) veryshortlabel
twoway scatteri 140 2016.5 140 2017.5 140 2018.5 140 2019.5, recast(area) color(gray*0.2) || ///
scatteri 140 2017.5 140 2018.5 140 2019.5 140 2020.5, recast(area) color(gray*0.3) || ///
scatter dur_iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter dur_iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Days iron tablets or syrup taken") ylabel(90(10)140) xlabel(2010(1)2020) ///
title("All other caste") ///
text(135 2017 "Partially" "affected", size(small)) ///
text(135 2018.5 "         Fully", size(small)) ///
text(133 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.17.pdf", as(pdf) replace 

restore

* figure 8.18
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
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
title("All other caste") ///
text(2875 2017 "Partially" "affected", size(small)) ///
text(2875 2018.5 "         Fully", size(small)) ///
text(2872 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.18.pdf", as(pdf) replace 

restore


* figure 8.19
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
collapse neo_mort [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort, by(eligible) veryshortlabel
twoway scatteri 0.05 2016.5 0.05 2017.5 0.05 2018.5 0.05 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.05 2017.5 0.05 2018.5 0.05 2019.5 0.05 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort0 yob, ms(Oh) mcolor(navy) || ///
scatter neo_mort1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Neonatal Mortality") ylabel(0.01(0.01)0.05) xlabel(2010(1)2020) ///
title("All other caste") ///
text(0.048 2017 "Partially" "affected", size(small)) ///
text(0.048 2018.5 "         Fully", size(small)) ///
text(0.0465 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.19.pdf", as(pdf) replace 

restore

* figure 8.20
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
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
title("All other caste") ///
text(24 2017 "Partially" "affected", size(small)) ///
text(24.2 2018.5 "         Fully", size(small)) ///
text(23.7 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.20.pdf", as(pdf) replace 

restore

* figure 8.21
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
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
title("All other caste") ///
text(0.48 2017 "Partially" "affected", size(small)) ///
text(0.48 2018.5 "         Fully", size(small)) ///
text(0.47 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.21.pdf", as(pdf) replace 

restore


* figure 8.22
preserve

keep if all_oth_caste==1 //Keep if only people belong to all other caste
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
title("All other caste") ///
text(0.23 2017 "Partially" "affected", size(small)) ///
text(0.23 2018.5 "         Fully", size(small)) ///
text(0.24 2019 "affected      ", size(small))
graph export "$outputdir/Fig8.22.pdf", as(pdf) replace 

restore

/*---------------------------------------------------------------------------*
              * Analysis by place of residence *
*---------------------------------------------------------------------------*/

*=============================================================*
*                  Place of residence: rural                       *
*=============================================================*

* figure 9.1
preserve

keep if rural==1
collapse preg_regist [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist0 yob, ms(Oh) mcolor(navy) || ///
scatter preg_regist1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Pregnancy Registration) ylabel(0.8(0.05)1)  xlabel(2010(1)2020) ///
title("Rural") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.1.pdf", as(pdf) replace 

restore

* figure 9.2: At least one ANC visit
preserve

keep if rural==1 
collapse anc_visit [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit0 yob, ms(Oh) mcolor(navy) || ///
scatter anc_visit1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Atleast one ANC visit) ylabel(0.75(0.05)1)   xlabel(2010(1)2020) ///
title("Rural") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.2.pdf", as(pdf) replace 

restore


*figure 9.3: Total ANC visits
preserve

keep if rural==1
collapse tot_anc9 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9, by(eligible) veryshortlabel
twoway scatteri 5.5 2016.5 5.5 2017.5 5.5 2018.5 5.5 2019.5, recast(area) color(gray*0.2) || ///
scatteri 5.5 2017.5 5.5 2018.5 5.5 2019.5 5.5 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc90 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc91 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Total ANC visits) ylabel(3.5(0.5)5.5)   xlabel(2010(1)2020) ///
title("Rural") ///
text(5.3 2017 "Partially" "affected", size(small)) ///
text(5.3 2018.5 "         Fully", size(small)) ///
text(5.25 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.3.pdf", as(pdf) replace 

restore


* figure 9.4
preserve

keep if rural==1
collapse del_healthf [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf0 yob, ms(Oh) mcolor(navy) || ///
scatter del_healthf1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Delivery at health facility) ylabel(0.65(0.05)1)   xlabel(2010(1)2020) ///
title("Rural") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.985 2018.5 "         Fully", size(small)) ///
text(0.972 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.4.pdf", as(pdf) replace 

restore


* figure 9.5
preserve

keep if rural==1
collapse ch_firstvac [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion reported by card or mother) ylabel(0.5(0.1)1)   xlabel(2010(1)2020) ///
title("Rural") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.5.pdf", as(pdf) replace 

restore


* figure 9.6
preserve

keep if rural==1
collapse ch_firstvac_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion by card) ylabel(0.6(0.1)1)   xlabel(2010(1)2020) ///
title("Rural") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.6.pdf", as(pdf) replace 

restore


* figure 9.7:Received BCG reported by mother or card
preserve

keep if rural==1
collapse ch_bcg [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by mother or card) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.7.pdf", as(pdf) replace 

restore

* figure 9.8:Received BCG by  card
preserve

keep if rural==1
collapse ch_bcg_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.993 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.8.pdf", as(pdf) replace 

restore

* figure 9.9: Received first dose Hep-B reported by mother or card
preserve

keep if rural==1
collapse ch_hep1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.9.pdf", as(pdf) replace 

restore

* figure 9.10: Received first dose Hep-B reported by card
preserve

keep if rural==1 
collapse ch_hep1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by card) ylabel(0.75(0.05)1) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.98 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.10.pdf", as(pdf) replace 

restore

* figure 9.11
preserve

keep if rural==1
collapse ch_dpt1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.11.pdf", as(pdf) replace 

restore

* figure 9.12
preserve

keep if rural==1
collapse ch_dpt1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by card) ylabel(0.7(0.1)1) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.12.pdf", as(pdf) replace 

restore

* figure 9.13
preserve

keep if rural==1
collapse ch_opv1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV reported by mother or card) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.985 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.13.pdf", as(pdf) replace 

restore

* figure 9.14
preserve

keep if rural==1
collapse ch_opv1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.992 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.14.pdf", as(pdf) replace 

restore

* figure 9.15
preserve

keep if rural==1
collapse m_anemia [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_anemia, by(eligible) veryshortlabel
twoway scatteri 0.7 2016.5 0.7 2017.5 0.7 2018.5 0.7 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.7 2017.5 0.7 2018.5 0.7 2019.5 0.7 2020.5, recast(area) color(gray*0.3) || ///
scatter m_anemia0 yob, ms(Oh) mcolor(navy) || ///
scatter m_anemia1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother Anemic") ylabel(0.5(0.05)0.7) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.68 2017 "Partially" "affected", size(small)) ///
text(0.68 2018.5 "         Fully", size(small)) ///
text(0.675 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.15.pdf", as(pdf) replace 

restore

* figure 9.16
preserve

keep if rural==1
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
title("Rural") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.16.pdf", as(pdf) replace 

restore


* figure 9.17
preserve

keep if rural==1
collapse dur_iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate dur_iron_spplm, by(eligible) veryshortlabel
twoway scatteri 130 2016.5 130 2017.5 130 2018.5 130 2019.5, recast(area) color(gray*0.2) || ///
scatteri 130 2017.5 130 2018.5 130 2019.5 130 2020.5, recast(area) color(gray*0.3) || ///
scatter dur_iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter dur_iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Days iron tablets or syrup taken") ylabel(80(10)130) xlabel(2010(1)2020) ///
title("Rural") ///
text(125 2017 "Partially" "affected", size(small)) ///
text(125 2018.5 "         Fully", size(small)) ///
text(123 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.17.pdf", as(pdf) replace 

restore

* figure 9.18
preserve

keep if rural==1
collapse ch_bw [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bw, by(eligible) veryshortlabel
twoway scatteri 2850 2016.5 2850 2017.5 2850 2018.5 2850 2019.5, recast(area) color(gray*0.2) || ///
scatteri 2850 2017.5 2850 2018.5 2850 2019.5 2850 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bw0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bw1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Child birth weight") ylabel(2700(50)2850) xlabel(2010(1)2020) ///
title("Rural") ///
text(2825 2017 "Partially" "affected", size(small)) ///
text(2825 2018.5 "         Fully", size(small)) ///
text(2822 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.18.pdf", as(pdf) replace 

restore


* figure 9.19
preserve

keep if rural==1
collapse neo_mort [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort, by(eligible) veryshortlabel
twoway scatteri 0.05 2016.5 0.05 2017.5 0.05 2018.5 0.05 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.05 2017.5 0.05 2018.5 0.05 2019.5 0.05 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort0 yob, ms(Oh) mcolor(navy) || ///
scatter neo_mort1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Neonatal Mortality") ylabel(0.01(0.01)0.05) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.048 2017 "Partially" "affected", size(small)) ///
text(0.048 2018.5 "         Fully", size(small)) ///
text(0.0465 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.19.pdf", as(pdf) replace 

restore

* figure 9.20
preserve

keep if rural==1
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
title("Rural") ///
text(24 2017 "Partially" "affected", size(small)) ///
text(24.2 2018.5 "         Fully", size(small)) ///
text(23.7 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.20.pdf", as(pdf) replace 

restore

* figure 9.21
preserve

keep if rural==1
collapse mod_svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate mod_svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.55 2016.5 0.55 2017.5 0.55 2018.5 0.55 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.55 2017.5 0.55 2018.5 0.55 2019.5 0.55 2020.5, recast(area) color(gray*0.3) || ///
scatter mod_svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter mod_svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Moderately or severely stunted") ylabel(0.25(0.05)0.55) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.52 2017 "Partially" "affected", size(small)) ///
text(0.52 2018.5 "         Fully", size(small)) ///
text(0.50 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.21.pdf", as(pdf) replace 

restore


* figure 9.22
preserve

keep if rural==1
collapse svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.25 2016.5 0.25 2017.5 0.25 2018.5 0.25 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.25 2017.5 0.25 2018.5 0.25 2019.5 0.25 2020.5, recast(area) color(gray*0.3) || ///
scatter svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Not first born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Severely stunted")  ylabel(0.1(0.05)0.25) xlabel(2010(1)2020) ///
title("Rural") ///
text(0.245 2017 "Partially" "affected", size(small)) ///
text(0.245 2018.5 "         Fully", size(small)) ///
text(0.24 2019 "affected      ", size(small))
graph export "$outputdir/Fig9.22.pdf", as(pdf) replace 

restore

*=============================================================*
*                  Place of residence: Urban                      *
*=============================================================*

* figure 10.1
preserve

keep if rural==0
collapse preg_regist [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate preg_regist, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter preg_regist0 yob, ms(Oh) mcolor(navy) || ///
scatter preg_regist1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Pregnancy Registration) ylabel(0.8(0.05)1)  xlabel(2010(1)2020) ///
title("Urban") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.1.pdf", as(pdf) replace 

restore

* figure 10.2: At least one ANC visit
preserve

keep if rural==0
collapse anc_visit [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate anc_visit, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter anc_visit0 yob, ms(Oh) mcolor(navy) || ///
scatter anc_visit1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Atleast one ANC visit) ylabel(0.75(0.05)1)   xlabel(2010(1)2020) ///
title("Urban") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.984 2018.5 "         Fully", size(small)) ///
text(0.977 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.2.pdf", as(pdf) replace 

restore


*figure 10.3: Total ANC visits
preserve

keep if rural==0
collapse tot_anc9 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate tot_anc9, by(eligible) veryshortlabel
twoway scatteri 6.5 2016.5 6.5 2017.5 6.5 2018.5 6.5 2019.5, recast(area) color(gray*0.2) || ///
scatteri 6.5 2017.5 6.5 2018.5 6.5 2019.5 6.5 2020.5, recast(area) color(gray*0.3) || ///
scatter tot_anc90 yob, ms(Oh) mcolor(navy) || ///
scatter tot_anc91 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Total ANC visits) ylabel(4.5(0.5)6.5)   xlabel(2010(1)2020) ///
title("Urban") ///
text(6.4 2017 "Partially" "affected", size(small)) ///
text(6.4 2018.5 "         Fully", size(small)) ///
text(6.35 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.3.pdf", as(pdf) replace 

restore


* figure 10.4
preserve

keep if rural==0
collapse del_healthf [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate del_healthf, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter del_healthf0 yob, ms(Oh) mcolor(navy) || ///
scatter del_healthf1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Delivery at health facility) ylabel(0.8(0.05)1)   xlabel(2010(1)2020) ///
title("Urban") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.985 2018.5 "         Fully", size(small)) ///
text(0.972 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.4.pdf", as(pdf) replace 

restore


* figure 10.5
preserve

keep if rural==0
collapse ch_firstvac [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion reported by card or mother) ylabel(0.5(0.1)1)   xlabel(2010(1)2020) ///
title("Urban") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.5.pdf", as(pdf) replace 

restore


* figure 10.6
preserve

keep if rural==0
collapse ch_firstvac_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_firstvac_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_firstvac_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_firstvac_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Child first dose of vaccinantion by card) ylabel(0.6(0.1)1)   xlabel(2010(1)2020) ///
title("Urban") ///
text(0.97 2017 "Partially" "affected", size(small)) ///
text(0.975 2018.5 "         Fully", size(small)) ///
text(0.962 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.6.pdf", as(pdf) replace 

restore


* figure 10.7:Received BCG reported by mother or card
preserve

keep if rural==0
collapse ch_bcg [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by mother or card) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.982 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.7.pdf", as(pdf) replace 

restore

* figure 10.8:Received BCG by  card
preserve

keep if rural==0
collapse ch_bcg_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bcg_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bcg_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bcg_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose of BCG by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.993 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.8.pdf", as(pdf) replace 

restore

* figure 9.10: Received first dose Hep-B reported by mother or card
preserve

keep if rural==0
collapse ch_hep1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.9.pdf", as(pdf) replace 

restore

* figure 10.10: Received first dose Hep-B reported by card
preserve

keep if rural==0 
collapse ch_hep1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_hep1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_hep1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_hep1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose Hep-B reported by card) ylabel(0.75(0.05)1) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.98 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.10.pdf", as(pdf) replace 

restore

* figure 10.11
preserve

keep if rural==0
collapse ch_dpt1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by mother or card) ylabel(0.6(0.1)1) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.11.pdf", as(pdf) replace 

restore

* figure 10.12
preserve

keep if rural==0
collapse ch_dpt1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_dpt1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_dpt1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_dpt1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(First dose of DPT by card) ylabel(0.7(0.1)1) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.12.pdf", as(pdf) replace 

restore

* figure 10.13
preserve

keep if rural==0
collapse ch_opv1 [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv10 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv11 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV reported by mother or card) ylabel(0.8(0.05)1) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.99 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.985 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.13.pdf", as(pdf) replace 

restore

* figure 10.14
preserve

keep if rural==0
collapse ch_opv1_card [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_opv1_card, by(eligible) veryshortlabel
twoway scatteri 1 2016.5 1 2017.5 1 2018.5 1 2019.5, recast(area) color(gray*0.2) || ///
scatteri 1 2017.5 1 2018.5 1 2019.5 1 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_opv1_card0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_opv1_card1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Second born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle(Received first dose OPV by card) ylabel(0.95(0.01)1) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.995 2017 "Partially" "affected", size(small)) ///
text(0.995 2018.5 "         Fully", size(small)) ///
text(0.992 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.14.pdf", as(pdf) replace 

restore

* figure 10.15
preserve

keep if rural==0
collapse m_anemia [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate m_anemia, by(eligible) veryshortlabel
twoway scatteri 0.6 2016.5 0.6 2017.5 0.6 2018.5 0.6 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.6 2017.5 0.6 2018.5 0.6 2019.5 0.6 2020.5, recast(area) color(gray*0.3) || ///
scatter m_anemia0 yob, ms(Oh) mcolor(navy) || ///
scatter m_anemia1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Mother Anemic") ylabel(0.45(0.05)0.6) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.58 2017 "Partially" "affected", size(small)) ///
text(0.58 2018.5 "         Fully", size(small)) ///
text(0.575 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.15.pdf", as(pdf) replace 

restore

* figure 10.16
preserve

keep if rural==0
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
title("Urban") ///
text(0.98 2017 "Partially" "affected", size(small)) ///
text(0.99 2018.5 "         Fully", size(small)) ///
text(0.975 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.16.pdf", as(pdf) replace 

restore


* figure 10.17
preserve

keep if rural==0
collapse dur_iron_spplm [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate dur_iron_spplm, by(eligible) veryshortlabel
twoway scatteri 150 2016.5 150 2017.5 150 2018.5 150 2019.5, recast(area) color(gray*0.2) || ///
scatteri 150 2017.5 150 2018.5 150 2019.5 150 2020.5, recast(area) color(gray*0.3) || ///
scatter dur_iron_spplm0 yob, ms(Oh) mcolor(navy) || ///
scatter dur_iron_spplm1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Days iron tablets or syrup taken") ylabel(80(10)150) xlabel(2010(1)2020) ///
title("Urban") ///
text(125 2017 "Partially" "affected", size(small)) ///
text(125 2018.5 "         Fully", size(small)) ///
text(123 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.17.pdf", as(pdf) replace 

restore

* figure 10.18
preserve

keep if rural==0
collapse ch_bw [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate ch_bw, by(eligible) veryshortlabel
twoway scatteri 3000 2016.5 3000 2017.5 3000 2018.5 3000 2019.5, recast(area) color(gray*0.2) || ///
scatteri 3000 2017.5 3000 2018.5 3000 2019.5 3000 2020.5, recast(area) color(gray*0.3) || ///
scatter ch_bw0 yob, ms(Oh) mcolor(navy) || ///
scatter ch_bw1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Child birth weight") ylabel(2700(50)3000) xlabel(2010(1)2020) ///
title("Urban") ///
text(2925 2017 "Partially" "affected", size(small)) ///
text(2925 2018.5 "         Fully", size(small)) ///
text(2922 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.18.pdf", as(pdf) replace 

restore


* figure 10.19
preserve

keep if rural==0
collapse neo_mort [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate neo_mort, by(eligible) veryshortlabel
twoway scatteri 0.05 2016.5 0.05 2017.5 0.05 2018.5 0.05 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.05 2017.5 0.05 2018.5 0.05 2019.5 0.05 2020.5, recast(area) color(gray*0.3) || ///
scatter neo_mort0 yob, ms(Oh) mcolor(navy) || ///
scatter neo_mort1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Neonatal Mortality") ylabel(0.01(0.01)0.05) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.048 2017 "Partially" "affected", size(small)) ///
text(0.048 2018.5 "         Fully", size(small)) ///
text(0.0465 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.19.pdf", as(pdf) replace 

restore

* figure 10.20
preserve

keep if rural==0
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
title("Urban") ///
text(24 2017 "Partially" "affected", size(small)) ///
text(24.2 2018.5 "         Fully", size(small)) ///
text(23.7 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.20.pdf", as(pdf) replace 

restore

* figure 10.21
preserve

keep if rural==0
collapse mod_svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate mod_svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.55 2016.5 0.55 2017.5 0.55 2018.5 0.55 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.55 2017.5 0.55 2018.5 0.55 2019.5 0.55 2020.5, recast(area) color(gray*0.3) || ///
scatter mod_svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter mod_svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "2nd born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Moderately or severely stunted") ylabel(0.2(0.05)0.55) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.52 2017 "Partially" "affected", size(small)) ///
text(0.52 2018.5 "         Fully", size(small)) ///
text(0.50 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.21.pdf", as(pdf) replace 

restore


* figure 10.22
preserve

keep if rural==0
collapse svr_stunted [aw=weight], by(eligible yob)

set scheme s1color 
grstyle init
grstyle set plain, nogrid 
separate svr_stunted, by(eligible) veryshortlabel
twoway scatteri 0.25 2016.5 0.25 2017.5 0.25 2018.5 0.25 2019.5, recast(area) color(gray*0.2) || ///
scatteri 0.25 2017.5 0.25 2018.5 0.25 2019.5 0.25 2020.5, recast(area) color(gray*0.3) || ///
scatter svr_stunted0 yob, ms(Oh) mcolor(navy) || ///
scatter svr_stunted1 yob, ms(Sh)  mcolor(maroon) ///
legend(lab(3 "Not first born") lab(4 "First born") order(4 3) position(6) col(2)) ytitle("Severely stunted")  ylabel(0(0.05)0.25) xlabel(2010(1)2020) ///
title("Urban") ///
text(0.245 2017 "Partially" "affected", size(small)) ///
text(0.245 2018.5 "         Fully", size(small)) ///
text(0.24 2019 "affected      ", size(small))
graph export "$outputdir/Fig10.22.pdf", as(pdf) replace 

restore

