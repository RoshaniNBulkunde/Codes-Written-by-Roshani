/*==============================================================================
     Clean NFHS 5- Children Recode data 	
	 Programmer: Roshani Bulkunde
==============================================================================*/
                                                 
clear all 
cap log close
set more off
						
* Directory of the main folder 					   
global dir "C:\Users\rosha\Dropbox (GaTech)\CCT India"
	
*log
log using "$dir\logs\clean_nfhs5.log", replace

*Import NFHS 5- Children Recode data
use "$dir\data\dhs 2019-2021\Children's Recode\IAKR7BFL.dta", replace
	
*-------------------------------------------------------------------------------------*
    
*dhs2019-21
gen survey=2
 
/*-------------------------------------------------------------- 
*            Demographic chatacteristics                       *
-------------------------------------------------------------- */

* State
ren v024 state
	label var state "State"

* District
ren sdist district
	label var district "District"
	
* Mother's age
ren v012 m_age
	label var m_age "Mother's Age"
	
* Place of residence (Rural area)
gen rural=1 if v102==2
	replace rural=0 if v102==1
	label var rural "Rural"
	
* Religion
* Hindu, Muslim, Other Religion
gen hindu=1 if v130==1
	replace hindu=0 if v130~=1
	
gen muslim=1 if v130==2
	replace muslim=0 if v130~=2
	
gen other_r=1 if v130==3|v130==4|v130==5|v130==6|v130==7|v130==8|v130==9|v130==96
	replace other_r=0 if v130==1|v130==2

	label var hindu "Hindu"
	label var muslim "Muslim"
	label var other_r "Other Religion"
	
* Mother's years of schooling
gen m_schooling=v133
	label var m_schooling "Mother's years of schooling"
	
* Number of chidren ever born
gen num_child=v201
	label var num_child "Total children ever born"
	
* Economic status
gen poor=0
	replace poor=1 if v190==1|v190==2
	
gen middle=0
	replace middle=1 if v190==3

gen rich=0 
	replace rich=1 if v190==4|v190==5
		
label var poor 		"Poor"
label var middle 	"Middle"
label var rich 		"Rich"
	
* Caste 
gen sch_caste_tribe=0 
	replace sch_caste_tribe=1 if s116==1|s116==2
	replace sch_caste_tribe=. if (s116==. | s116==8)
		
gen obc=0 
	replace obc=1 if s116==3
	replace obc=. if (s116==. | s116==8)
		
gen all_oth_caste=0 
	replace all_oth_caste=1 if s116==4
	replace all_oth_caste=. if (s116==. | s116==8)
		
    label var sch_caste_tribe "Schedule caste/tribe"
	label var obc "Backward class"
	label var all_oth_caste "All other caste"
		
* Education
gen m_educ=v106
	label var m_educ "Mother's education"

* Health insurance
gen health_ins=.
	replace health_ins=1 if  v481==1
	replace health_ins=0 if  v481==0

	label var health_ins "Health Insurance"
		
	
*	Age at first cohabitation *(1)
recode v511 (0/10=.), gen(afc)
	sum afc, detail
	replace afc=r(p99) if afc>=r(p99)
	label var afc "Cohabitation age"
	
*	Age at first birth
recode v212 (0/10=.), gen(afb)
	sum afb, detail
	replace afb=r(p99) if afb>=r(p99)
	label var afb "Age at first birth"
		
		
/*-------------------------------------------------------------- 
             *Sample weights
             *Children--birth history variables
-------------------------------------------------------------- */
    		
* Sample Weights
gen weight=v005/1000000 

* Birth Order
label var bord "Birth Order"
				
* year, month and day of birth
ren b2 yob
ren b1 mob
ren b17 dob 
	
label var yob "Year of birth"
label var mob "Month of birth"
label var dob "Day of birth"
		
gen m_d_y_birth= mdy(mob, dob, yob)
label var m_d_y_birth "month/day/year of birth"
	
* Age of children in month
ren b19 ch_age_month 
label var ch_age_month "Age of child in months"


/*-------------------------------------------------------------- 
            * Maternal  health variables *
-------------------------------------------------------------- */
* Mother's BMI
gen m_bmi=v445/100
	replace m_bmi=. if v445==9998
	label var m_bmi "Mother's BMI"

* Mother is undernourished
gen m_undernourish=.
	replace m_undernourish=1 if m_bmi<18.5 & m_bmi~=.
	replace m_undernourish=0 if m_bmi>=18.5 & m_bmi~=.
	label var m_undernourish "Mother is undershourished"

*----Pregnancy registration-------*
* Pregnancy registered
recode s410 (1=1 "yes") (0=0 "no") (.=.), gen(preg_regist)
	label var preg_regist "Was this pregnancy registered?"
		
recode s411 (10 11 98=.) , gen(preg_known)
	label var preg_known "How many months pregnant were you when you registered?"
    
* With whom did you register?
recode s412 (1=1 "anm") (2=2 "asha") (3=3 "aww") (6=6 "other"), gen(preg_regist_hf)
	label var preg_regist_hf "With whom did you register?"
	
* Received Mother and child protection card
recode s413 (1=1 "yes") (0=0 "no"), gen(mcp_card)
	label var mcp_card "Received a mother and child protection card after registration?"
		 
*-----Financial Assistance----*

* Receive financial assistance
recode s457 (1=1 "yes") (0=0 "no"), gen(finc_asst)
	label var finc_asst "Received any financial assistance"
		 
* Janani Suraksha Yojana (JSY)
recode s458a (1=1 "yes") (0=0 "no"), gen(finc_asst_jsy)
	label var finc_asst "Received Janani Suraksha Yojana (JSY)"
		 
* Other government scheme
recode s458a (1=1 "yes") (0=0 "no"), gen(finc_asst_othergovp)
	label var finc_asst "Received financial assistance from other government scheme"


*-------Antenatal care visits------*

* Atleast one antenatal visits during pregnancy
recode m14 (1/97= 1 "yes") (0=0 "no") (98=.), gen(anc_visit) 
	label var anc_visit "Atleast one ANC visit"
		
* number of ANC visits
gen tot_anc9 = m14
	replace tot_anc9=. if m14==98
	replace tot_anc9=9 if tot_anc9>9 & tot_anc9~=.
	label var tot_anc9 "Number of ANC visits"
	
* More than 4 ANC Visit
gen tot_anc4 = m14
	replace tot_anc4=. if m14==98
	replace tot_anc4=0 if tot_anc4<4 & tot_anc4~=.
	replace tot_anc4=1 if tot_anc4>3 & tot_anc4~=.
	label var tot_anc4 "More than 4 ANC visits"

* number of ANC visits upto 4
gen tot_ancm4 = m14
	replace tot_ancm4=. if m14==98
	replace tot_ancm4=4 if tot_ancm4>3 & tot_ancm4~=.
	label var tot_ancm4 "Number of ANC visits upto 4"
		
* Anc place
gen anc_place=.
	replace anc_place=1 if m57a==1 | m57b==1 | m57c==1 | m57d==1
	replace anc_place=2 if m57e==1 | m57f==1 | m57g==1 | m57h==1 | m57i==1 | m57j==1 | m57k==1 | m57l==1 | m57m==1 | m57n==1 | m57o==1 | m57p==1 | m57q==1 | m57r==1 | m57s==1 | m57t==1
	replace anc_place=3 if m57u==1 | m57v==1 | m57x==1
	label define anc_place 1 "Home" 2 "Health care facility" 3 "Other"
	label values anc_place anc_place
	label var anc_place "Place for antenatal care"
	
** ANC at health facility
gen anc_health_facility =.
	replace anc_health_facility=0 if m57a==1 | m57b==1 | m57c==1 | m57d==1 | m57u==1 | m57v==1 | m57x==1
	replace anc_health_facility=1 if m57e==1 | m57f==1 | m57g==1 | m57h==1 | m57i==1 | m57j==1 | m57k==1 | m57l==1 | m57m==1 | m57n==1 | m57o==1 | m57p==1 | m57q==1 | m57r==1 | m57s==1 | m57t==1
	label var anc_health_facility "ANC at health facility"
		
*---ANC component-----*
	
* Tetanus injection before birth
gen tetanus_count=m1
	replace tetanus_count=. if m1==8
	label var tetanus_count "Number of tetanus injections before birth"
		 
* Atleast one tetanus injection before birth
recode m1 (1/7=1 "yes") (0=0 "no") (8=.), gen(tetanus)
	label var tetanus "Received atleast one tetanus injection before birth"
	
* Iron supplementation
gen iron_spplm=m45
	replace iron_spplm=. if iron_spplm==8
	label var iron_spplm "During pregnancy, given or bought iron tablets/syrup"
		
gen dur_iron_spplm=m46
	replace dur_iron_spplm=. if dur_iron_spplm==998
	label var dur_iron_spplm "Days iron tablets or syrup taken"
	
* Took IFA for 100 days or more
gen iron_spplm_100days=.
	replace iron_spplm_100days=1 if m46>=100 & (m46~=998 & m46~=.)
	replace iron_spplm_100days=0 if m46<100 & (m46~=998 & m46~=.)
	label var iron_spplm_100days "Took IFA for 100 days or more"
		
* Intestinal parasite drugs 
recode m60 (1=1 "yes") (0=0 "no") (8=.) (.=.), gen(anc_parast)	
	label var anc_parast "Drugs for intestinal parasites during pregnancy"
	
* Anemia level
recode v457 (1/3=1 "anemic") (4=0 "not anemic"), gen(m_anemia)
		label var m_anemia "Mother's anemic"
		
*------Prenatal care------*
	
* Prenatal care provider for mother
gen pnc_prof_care=.

foreach i in a b c d e f {
	replace pnc_prof_care=1 if m2`i'==1
}
	replace pnc_prof_care=0 if (m2n==1) | (m2a==0 & m2b==0)
	label value pnc_prof_care yesno
	label var pnc_prof_care "Provider for mother's PNC check"
	
	
*-------Delivery care---------*

* The type of person who assisted with the delivery of the child
gen del_prof_asst=.

foreach i in a b c d e f {
	replace del_prof_asst=1 if m3`i'==1
}
	replace del_prof_asst=0 if (m3n==1) | (m3a==0 & m3b==0 & m3c==0)
		*br m3a m3b m3c m3d m3e m3f m3n prof_asst // Code checking
	label value del_prof_asst yesno
	label var del_prof_asst "Professional assistance at delivery"

* Place of delivery
recode m15 (20/39 = 1 "Health facility") (10/19 = 2 "Home") (96 = 3 "Other") , gen(del_place)
	label var del_place "Place of delivery"

* Place of delivery--at health facility
recode m15 (20/39=1) (10/19 = 0 ) (96 = 0 ) , gen(del_healthf)
	label var del_healthf "Delivery at health facility"

* Place of delivery - by place type
recode m15 (20/29 = 1 "Health facility - public") (30/39 = 2 "Health facility - private") (10/19 = 3 "Home")(96 = 4 "Other") , gen(del_pltype)
	label var del_pltype "Type of health facility"
	
* delivery by caesarean section
gen csection=m17
	label value csection yesno
	label var csection "Delivery by caesarean section"
		
		
*------- Duration of breastfeeding ---------*
	* 94  never breastfed, 98 dont know and outliers replaced with 99th percentile
		
recode m5 (94=0) (98=.), gen(breast_dur)
	label var breast_dur "Duration of Breastfed (months)"
	sum breast_dur,detail
	replace breast_dur=r(p99) if breast_dur>=r(p99)&breast_dur~=.	
		
		

/*-------------------------------------------------------------- 
            * Infant health variables *
-------------------------------------------------------------- */

* Child Birth weight
label variable m19      "Birth weight in kilograms (3 decimals)"
	
gen ch_bw=m19
	replace ch_bw=. if ch_bw==9996 | ch_bw==9998
	*sum ch_bw, detail
	*replace ch_bw=r(p99) if ch_bw>=r(p99) & (ch_bw~=9996 & ch_bw~=9998 & ch_bw~=.)
	*replace ch_bw=r(p1) if ch_bw<=r(p1)	& (ch_bw~=9996 & ch_bw~=9998 & ch_bw~=.)
	label var ch_bw "Child Birth Weight in grams"
	
	
* Birth weight less than 2.5 kg
gen ch_low_bw=.
	replace ch_low_bw=1 if ch_bw<2500 & ch_bw~=.
	replace ch_low_bw=0 if ch_bw>=2500 & ch_bw~=.
	label var ch_low_bw "Child birth weight less than 2.5 kg"
		
* Birth Size
recode m18 (5=1 "Very small") (4=2 "Smaller than average") (1/3 =3 "Average or larger") (8/9=9 "Don't know/missing"), gen(ch_birth_size)
	replace ch_birth_size=. if ch_birth_size==9
	label var ch_birth_size "Size of child at birth as reported by mother"
		

*-------Child Vaccines-------*
* Source of vaccination information. Seen the card?
recode h1 (1=1 "Yes") (0 2 3=0 "No") (.=.), gen(ch_vac_card)

* BCG 
gen ch_bcg = .
	replace ch_bcg = 1 if inlist(h2, 1, 2, 3)
	replace ch_bcg = 0 if h2 == 0
	label var ch_bcg	"Received BCG"
	
* BCG on vaccination card
gen ch_bcg_card = ch_bcg
	replace ch_bcg_card = . if ch_vac_card==0
	label var ch_bcg_card "Received BCG by card"

* DPT 
gen ch_dpt1 = .
	replace ch_dpt1 = 1 if inlist(h3, 1, 2, 3)
	replace ch_dpt1 = 0 if h3 == 0
	label var ch_dpt1	"Received DPT1"

* DPT- dose1 on card
gen ch_dpt1_card = ch_dpt1
	replace ch_dpt1_card = . if ch_vac_card==0
	label var ch_dpt1_card "Received DPT1 by card"

gen ch_dpt2 = .
	replace ch_dpt2 = 1 if inlist(h5, 1, 2, 3)
	replace ch_dpt2 = 0 if h5 == 0
	label var ch_dpt2	"Received DPT2"

gen ch_dpt3 = .
	replace ch_dpt3 = 1 if inlist(h7, 1, 2, 3)
	replace ch_dpt3 = 0 if h7 == 0
	label var ch_dpt3	"Received DPT3"

gen ch_dptall= .
	replace ch_dptall = 1 if ch_dpt1==1 & ch_dpt2==1 & ch_dpt3==1
	replace ch_dptall = 0 if ch_dpt1==0 | ch_dpt2==0 | ch_dpt3==0
	label var ch_dptall "Received all 3 doses of DPT"

gen ch_dptsum = ch_dpt1 + ch_dpt2 +ch_dpt3
	label var ch_dptsum "Number of DPT doses received"


/* OPV-Oral Polio Vaccine
gen ch_opvb=.
	replace ch_opvb = 1 if inlist(h0, 1, 2, 3)
	replace ch_opvb = 0 if h0 == 0
	label var ch_opvb	"Received oral polio at birth"
	
* OPV at birth by card
gen ch_opvb_card = ch_opvb
	replace ch_opvb_card = . if ch_vac_card==0
	label var ch_opvb_card "Received oral polio at birth by card"

gen ch_opv1 =.
	replace ch_opv1 = 1 if inlist(h4, 1, 2, 3)
	replace ch_opv1 = 0 if h4 == 0
	label var ch_opv1	"Received OPV1"
	
* OPV1 by card
gen ch_opv1_card = ch_opv1
	replace ch_opv1_card = . if ch_vac_card==0
	label var ch_opv1_card "Received OPV1 by card" */
	
* Combine OPV-Oral Polio Vaccine at birth and first dose
gen ch_opv1 =.
	replace ch_opv1 = 1 if (inlist(h4, 1, 2, 3) | inlist(h0, 1, 2, 3))
	replace ch_opv1 = 0 if (h4 == 0& h0==0)
	label var ch_opv1	"Received OPV1"
	
* OPV1 by card
gen ch_opv1_card = ch_opv1
	replace ch_opv1_card = . if ch_vac_card==0
	label var ch_opv1_card "Received OPV1 by card" 

gen ch_opv2 =.
	replace ch_opv2 = 1 if inlist(h6, 1, 2, 3)
	replace ch_opv2 = 0 if h6 == 0
	label var ch_opv2	"Received OPV2"

gen ch_opv3 =.
	replace ch_opv3 = 1 if inlist(h8, 1, 2, 3)
	replace ch_opv3 = 0 if h8 == 0
	label var ch_opv3	"Received OPV3"
/*
gen ch_opvall= .
	replace ch_opvall = 1 if ch_opvb==1 & ch_opv1==1 & ch_opv2==1 & ch_opv3==1
	replace ch_opvall = 0 if ch_opvb==0 | ch_opv1==0 | ch_opv2==0 | ch_opv3==0
	label var ch_opvall "Received all OPV"

gen ch_opvsum = ch_opvb + ch_opv1 + ch_opv2 +ch_opv3
	label var ch_opvsum "Number of OPV received" */

** Hepatitis B
/* Hep-B at birth
gen ch_hepb=.
	replace ch_hepb=1 if inlist(h50, 1, 2, 3) 
	replace ch_hepb=0 if h50 == 0
	label var ch_hepb	"Received Hepatitis-B at birth"
	
* Hep-B at birth by card
gen ch_hepb_card = ch_hepb
	replace ch_hepb_card = . if ch_vac_card==0
	label var ch_hepb_card "Received Hep-B by card"
		
* Hep-B1
gen ch_hep1=.
	replace ch_hep1=1 if inlist(h61, 1, 2, 3) 
	replace ch_hep1=0 if h61 == 0
	label var ch_hep1	"Received Hepatitis-B1"
	
* Hep-B1 at birth by card
gen ch_hep1_card = ch_hep1
	replace ch_hep1_card = . if ch_vac_card==0
	label var ch_hep1_card "Received Hep-B1 by card" */
	
* Hep-B1
gen ch_hep1=.
	replace ch_hep1=1 if (inlist(h61, 1, 2, 3) | inlist(h50, 1, 2, 3))
	replace ch_hep1=0 if (h61==0 & h50==0)
	label var ch_hep1	"Received Hepatitis-B1"
	
* Hep-B1 by card
gen ch_hep1_card = ch_hep1
	replace ch_hep1_card = . if ch_vac_card==0
	label var ch_hep1_card "Received Hep-B1 by card" 
		
* Hep-B2
gen ch_hep2= .
	replace ch_hep2=1 if inlist(h62, 1, 2, 3) 
	replace ch_hep2=0 if h62 == 0
	label var ch_hep2	"Received Hepatitis-B2"
		
* Hep-B3
gen ch_hep3 = .
	replace ch_hep3=1 if inlist(h63, 1, 2, 3) 
	replace ch_hep3=0 if h63 == 0
	label var ch_hep3	"Received Hepatitis-B3"

/*
gen ch_hepall=.
	replace ch_hepall=1 if ch_hepb==1 & ch_hep1==1 & ch_hep2==1 & ch_hep3==1
	replace ch_hepall=0 if ch_hepb==0 | ch_hep1==0 | ch_hep2==0 | ch_hep3==0
	label var ch_hepall "Received all Hepatitis-B doses"
		
gen ch_hepsum=ch_hepb + ch_hep1 + ch_hep2 + ch_hep3
	label var ch_hepsum "Number of Hepatitis-B received" */
		
	

* Received first cycle of all vaccines
* Child has received the first cycle of BCG, OPV, DPT, and Hepatitis-B or its equivalent or substitute
gen ch_firstvac=.
	replace ch_firstvac=1 if ch_bcg==1 & ch_hep1==1 & ch_dpt1 ==1 & ch_opv1==1
	replace ch_firstvac=0 if ch_bcg==0 | ch_hep1==0 | ch_dpt1 ==0 | ch_opv1==0
	label var ch_firstvac "Received the first cycle of BCG, OPV, DPT, and Hepatitis-B"
	
/* Child has received the first cycle of BCG, OPV(at birth), DPT, and Hepatitis-B (at birth) or its equivalent or substitute
gen ch_firstvac0=.
	replace ch_firstvac0=1 if ch_bcg==1 & ch_hepb==1 & ch_dpt1 ==1 & ch_opvb==1
	replace ch_firstvac0=0 if ch_bcg==0 | ch_hepb==0 | ch_dpt1 ==0 | ch_opvb==0
	label var ch_firstvac0 "Received the first cycle of BCG, OPV-b, DPT, and HepB-b" */
	
* Child has received the first cycle of BCG, OPV, DPT, and Hepatitis-B or its equivalent or substitute
gen ch_firstvac_card=.
	replace ch_firstvac_card=1 if ch_bcg_card==1 & ch_hep1_card==1 & ch_dpt1_card ==1 & ch_opv1_card==1
	replace ch_firstvac_card=0 if ch_bcg_card==0 | ch_hep1_card==0 | ch_dpt1_card ==0 | ch_opv1_card==0
	label var ch_firstvac_card "Received the first cycle of BCG, OPV, DPT, and Hepatitis-B by card"
	
/* Child has received the first cycle of BCG, OPV(at birth), DPT, and Hepatitis-B (at birth) or its equivalent or substitute
gen ch_firstvac0_card=.
	replace ch_firstvac0_card=1 if ch_bcg_card==1 & ch_hepb_card==1 & ch_dpt1_card ==1 & ch_opvb_card==1
	replace ch_firstvac0_card=0 if ch_bcg_card==0 | ch_hepb_card==0 | ch_dpt1_card ==0 | ch_opvb_card==0
	label var ch_firstvac0_card "Received the first cycle of BCG, OPV-b, DPT, and HepB-b by card" */
		
* Received any one vaccines
gen ch_anyvac=.
	replace ch_anyvac=1 if ch_bcg==1 | ch_hep1==1 | ch_dpt1 ==1 | ch_opv1==1
	replace ch_anyvac=0 if ch_bcg==0 & ch_hep1==0 & ch_dpt1 ==0 & ch_opv1==0
    label var ch_anyvac "Received any vaccine (BCG, OPV, DPT, and Hepatitis-B)"
	
/* Received any one vaccines
gen ch_anyvac_v1=.
	replace ch_anyvac_v1=1 if ch_bcg==1 | ch_hepb==1 | ch_dpt1 ==1 | ch_opvb==1
	replace ch_anyvac_v1=0 if ch_bcg==0 & ch_hepb==0 & ch_dpt1 ==0 & ch_opvb==0
    label var ch_anyvac_v1 "Received any vaccine (BCG, OPV, DPT, and Hepatitis-B)" */
	
*----Other Vaccines----*
* Measles
gen ch_measles1 = .
	replace ch_measles1=1 if inlist(h9, 1, 2, 3, 4) 
	replace ch_measles1=0 if h9 == 0
	label var ch_measles1	"Received measles 1"
		
gen ch_measles2 = .
	replace ch_measles2=1 if inlist(h9a, 1, 2, 3) 
	replace ch_measles2=0 if h9a == 0
	label var ch_measles2	"Received measles 2"
		
* Pentavalent
gen ch_pent1 = .
	replace ch_pent1=1 if inlist(h51, 1, 2, 3) 
	replace ch_pent1=0 if h51 == 0
	label var ch_pent1	"Received pentavalent 1"
		
gen ch_pent2 = .
	replace ch_pent2=1 if inlist(h52, 1, 2, 3) 
	replace ch_pent2=0 if h52 == 0
	label var ch_pent2	"Received pentavalent 2"
	
gen ch_pent3 = .
	replace ch_pent3=1 if inlist(h53, 1, 2, 3) 
	replace ch_pent3=0 if h53 == 0
	label var ch_pent3	"Received pentavalent 3"
		
* Rotavirus
gen ch_rotavirus1 = .
	replace ch_rotavirus1=1 if inlist(h57, 1, 2, 3) 
	replace ch_rotavirus1=0 if h57 == 0
	label var ch_rotavirus1	"Received Rotavirus 1"
		
gen ch_rotavirus2= .
	replace ch_rotavirus2=1 if inlist(h58, 1, 2, 3) 
	replace ch_rotavirus2=0 if h58 == 0
	label var ch_rotavirus2	"Received Rotavirus 2"
	
gen ch_rotavirus3 = .
	replace ch_rotavirus3=1 if inlist(h59, 1, 2, 3) 
	replace ch_rotavirus3=0 if h59 == 0
	label var ch_rotavirus3	"Received Rotavirus 3"
		
*-------- Child Mortality-------*
	
* Neonatal mortality:  the probability of dying in the first month of life;
gen neo_mort = 0
	replace neo_mort = 1 if b7<2
	label var neo_mort "Neonatal mortality"
		
* Infant mortality:  the probability of dying in the first year of life
gen infant_mort=0
	replace infant_mort=1 if b7<13
	label var infant_mort "Infant mortality"
	
*----------Variables for stunting--------*

* Height-for-age z-score		
recode hw70 (9997/9998=.), gen(height_age)
	label var height_age "Height for age"
	
* Standardized Height-for-age z-score
	
sum height_age [aw=weight] 
gen z_height_age=(height_age-r(mean))/r(sd)
	
		********
gen svr_stunted=.
	replace svr_stunted=1 if height_age<=-300&height_age~=.
	replace svr_stunted=0 if height_age>-300&height_age~=.
		
	label var svr_stunted "Severely stunted"
		**********
gen mod_svr_stunted=.
	replace mod_svr_stunted=1 if height_age<-200&height_age~=.
	replace mod_svr_stunted=0 if height_age>=-200&height_age~=.
		
	label var mod_svr_stunted "Moderately or severely stunted"
		
gen mod_svr_stunted_z=.
	replace mod_svr_stunted_z=1 if z_height_age<-2&z_height_age~=.
	replace mod_svr_stunted_z=0 if z_height_age>=-2&z_height_age~=.
		
	label var mod_svr_stunted_z "Moderately or severely stunted"	
		
		********
gen normal_height_age=.
	replace normal_height_age=1 if height_age<=200&height_age>=-200&height_age~=.
	replace normal_height_age=0 if normal_height_age==.&height_age~=.
		
	label var normal_height_age "Height-for-age normal"
		
* Weight-for-age z-score	
recode hw71 (9997/9998=.), gen(weight_age)
	replace weight_age=weight_age
		
	label var weight_age "Weight for age"
		
gen svr_underweight=.
	replace svr_underweight=1 if weight_age<=-300&weight_age~=.
	replace svr_underweight=0 if weight_age>-300&weight_age~=.
		
	label var svr_underweight "Severely underweight"
		
		*********
gen overweight_age=.
	replace overweight_age=1 if weight_age>=200&weight_age~=.
	replace overweight_age=0 if weight_age<200&weight_age~=.
		
	label var overweight_age "Overweight for age"
		
		*******
gen normal_weight_age=.
	replace normal_weight_age=1 if weight_age<=200&weight_age>=-200&weight_age~=.
	replace normal_weight_age=0 if normal_weight_age==.&weight_age~=.
		
	label var normal_weight_age "Weight-for-age normal"
		


	

save "$dir\data\output\inter_nfhs5\nfhs5.dta", replace
	
log close
	
	
/*
tab v130
label dir
numlabel `r(names)', add
tab v130	

*/






