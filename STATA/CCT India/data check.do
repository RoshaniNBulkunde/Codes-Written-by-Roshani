* This do file is to check the missing data

clear all
set more off
cap log close

* Use nfhs final data. This data is the appended data from nfhs 4 and 5
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\final_nfhs.dta", clear

global mainoutvar preg_regist anc_visit tot_anc9 del_healthf ch_firstvac ch_anyvac ch_bcg ch_hep1 ch_dpt1 ch_opv1

global baseline_chrac m_schooling m_age rural afb poor middle rich  ///
	            sch_caste_tribe obc all_oth_caste hindu muslim other_r
				

* Check the stats from Nfhs5 data
clear all
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\inter_nfhs5\nfhs5.dta", clear
sum preg_regist [aw=weight]
sum tot_anc4 [aw=weight]
sum neo_mort [aw=weight]
sum del_healthf [aw=weight]
sum anc_visit [aw=weight]
sum iron_spplm [aw=weight]
sum iron_spplm_100days [aw=weight]
sum ch_low_bw [aw=weight]
sum ch_bcg [aw=weight]
sum ch_dpt1 [aw=weight]
sum ch_opv1 [aw=weight]
sum ch_hep1 [aw=weight]
 sum mod_svr_stunted [aw=weight]


clear all
use "C:\Users\rosha\Dropbox (GaTech)\CCT India\data\output\inter_nfhs4\nfhs4.dta", clear

sum preg_regist [aw=weight]
sum anc_visit [aw=weight]
sum tot_anc4 [aw=weight]
sum del_healthf [aw=weight]
sum neo_mort [aw=weight]
sum m_anemia [aw=weight]
sum ch_low_bw [aw=weight]	
sum ch_bcg [aw=weight]
sum ch_dpt1 [aw=weight]
sum ch_opv1 [aw=weight]
sum ch_hep1 [aw=weight]
 sum mod_svr_stunted [aw=weight]
 sum breast_dur [aw=weight], d
