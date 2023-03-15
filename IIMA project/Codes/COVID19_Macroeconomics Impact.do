                      
/*=========================================================================================
*******************************************************************************************
                        
	   Project name: Lights Out? COVID-19 Containment policies and Economic output								
						
	Robert C. M. Beyer			      Tarun Jain							Sonalika Sinha
	  World Bank		Indian Institute of Management Ahmedabad        Reserve Bank of India
							
							
			Programmer:  Roshani Bulkunde, Research Assistant, IIMA
							
					Last updated:  28th October 2020
						 					
						                     	      
******************************************************************************************						 						 
=========================================================================================*/
					  
					  
					  
					  
			
			
			
					  				  
					  
					  
/*=============================================================================
 ******************************************************************************
						SECTION: A
					
      **  CLEANING AND CREATING REQUIRED DATASET  **	   			   
******************************************************************************						 						 
================================================================================*/

/*-----------------------------------------------
Notes: Datasets
1)   COVID-19 
2)	 SHRUG 
3) 	 NIGHT-LIGHT 
4)   RBI
5)   Zone Classification data
6)   CENSUS 2011 AGE Data
7)   INFORMALITY (CENSUS 2011 Data)		
8)   MOBILITY data
9)   Consumer pyramid data				
------------------------------------------------*/

clear
cap log close
set more off

*===============================================================================
                           * set folder path *
						   *-----------------*

* Directory of the folder where all above datasets are present						   
global datasets "C:\Users\rosha\Desktop\IIMA"	//In the drive it is present in the Datasets folder

* Note that to run this do-file you will need to download the "dataset" folder as it is.

*===============================================================================	




				   
					
/*==============================================================================
		                  COVID-19 dataset 
		   AIM: To create by-month district level panel of infections
==============================================================================*/	

/* Notes:
path of the folder: Datasets-> COVID19-India.API
The datasets downloaded from COVID-19-India.API website.  
*/

*Change the directory to the folder name COVID19-India.API
cd "$datasets\COVID19-India.API"   // change the directory to access all COVID-19 dataset 


/*As we can not directly append the COVID19-India.API datasets. We will import the data one by one and 
save it as dta file and then will append it*/

/*********       raw_data1      ****************/
//This data is from 31st January to 19th April
import delimited "raw_data1.csv", clear  //importing data

describe //this will give the general information about the dataset

*drop the variables that are not required for the analysis
drop patientnumber statepatientnumber estimatedonsetdate agebracket gender detectedcity notes ///
statecode contractedfromwhichpatientsuspec nationality typeoftransmission statuschangedate ///
source_1 source_2 source_3 backupnotes

save "raw_data1.dta", replace  //saving into dta file


/**************   raw_data2  *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
//This data is from 20th April to 25th April
import delimited "raw_data2.csv", clear  //importing data

*drop the variables that are not required for the analysis
drop patientnumber statepatientnumber estimatedonsetdate agebracket gender detectedcity notes ///
statecode contractedfromwhichpatientsuspec nationality typeoftransmission statuschangedate ///
source_1 source_2 source_3 backupnotes

save "raw_data2.dta", replace  //saving into dta file


/**************   raw_data3 *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
//data from 27th April to 9th may
import delimited "raw_data3.csv", clear  //importing data


*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data3.dta", replace  //saving into dta file

/**************   raw_data4  *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
//Data from 10th May to 23rd May
import delimited "raw_data4.csv", clear  //importing data

*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data4.dta", replace  //saving into dta file


/**************   raw_data5  *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
//Data from 24th May to 4th June
import delimited "raw_data5.csv", clear  //importing data

*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data5.dta", replace  //saving into dta file


/**************   raw_data6  *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
//data from 5th june to 19th June
import delimited "raw_data6.csv", clear  //importing data

*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data6.dta", replace  //saving into dta file


/**************   raw_data7  *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
//data from 20th june to 30th June
import delimited "raw_data7.csv", clear  //importing data

*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data7.dta", replace  //saving into dta file

/**************   raw_data8  *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
//data from July 1st to July 7th
import delimited "raw_data8.csv", clear  //importing data

*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data8.dta", replace  //saving into dta file

/**************   raw_data9  *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
//data from July 8th to July 13th
import delimited "raw_data9.csv", clear  //importing data


*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data9.dta", replace  //saving into dta file

/**************   raw_data10 *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
//data from July 14th to July 17th
import delimited "raw_data10.csv", clear  //importing data

*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data10.dta", replace  //saving into dta file


/**************   raw_data11  *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
//data from July 18th to July 22nd
import delimited "raw_data11.csv", clear  //importing data

*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data11.dta", replace  //saving into dta file


/**************   raw_data12  *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
import delimited "raw_data12.csv", clear  //importing data

*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data12.dta", replace  //saving into dta file

/**************   raw_data13  *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
import delimited "raw_data13.csv", clear  //importing data

*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data13.dta", replace  //saving into dta file

/**************   raw_data14  *************************/
clear all
*Importing the datasets downloaded from COVID-19-India.API website
import delimited "raw_data14.csv", clear  //importing data

*drop the variables that are not required for the analysis
drop entry_id statepatientnumber agebracket detectedcity contractedfromwhichpatientsuspec notes ///
source_1 source_2 source_3 nationality typeoftransmission statuschangedate patientnumber ///
gender statecode

save "raw_data14.dta", replace  //saving into dta file




*===============Appending the COVID-19 infections datasets==========================================*

clear all
cd "$datasets\COVID19-India.API"   // The directory for the folder COVID-19-India.API
append using "raw_data1.dta" "raw_data2.dta" "raw_data3.dta" "raw_data4.dta" "raw_data5.dta" "raw_data6.dta" "raw_data7.dta" ///
"raw_data8.dta" "raw_data9.dta" "raw_data10.dta" "raw_data11.dta" "raw_data12.dta" "raw_data13.dta" "raw_data14.dta" //appending all the COVID-19 datasets
sort dateannounced   //sorting with the date 


*------ Cleaning the COVID-19 data  -----------------*

drop if numcases <0 //Negative numbers are for corrections

//dropping the unwanted district name
drop if inlist( detecteddistrict, "Airport Quarantine", "Airport quarantine", "Other Region", ///
"Other State", "other State", "Railway Quarantine", "Other state", "Italians", "Foreign Evacuees")

drop if inlist( detecteddistrict, "BSF Camp", "Evacuees", "Gaurela Pendra Marwahi", "Unassigned", "Others", "others", "Capf Personnel", "Unknown")

/*The date in this dataset is in the string format. Converting this into date format 
so that STATA can perform date function properly */
generate date = date(dateannounced, "MDY")   //date() is a function   
format date %td    //formation this date into 03mar2020 like this format

//Generate month
gen month = month(date)

sort dateannounced date   //Cross-checking the date created by datefunction we got the correct output
order dateannounced date
drop dateannounced    //drop the string format of date 

*Uniform names
gen district= strproper(detecteddistrict)   // strproper() is a function 
drop detecteddistrict

//changing some of the districts names which has same name
/* We are doing this because following  are the same district name in the two differnt state
so this will be a problem while merging using the district name */
replace district="AurangabadBH" if district=="Aurangabad" & detectedstate=="Bihar"
replace district="AurangabadMH" if district=="Aurangabad" & detectedstate=="Maharashtra"
replace district="BilaspurCH" if district=="Bilaspur" & detectedstate=="Chhattisgarh"
replace district="BilaspurHP" if district=="Bilaspur" & detectedstate=="Himachal Pradesh"
replace district="BalrampurCh" if district=="Balrampur" & detectedstate=="Chhattisgarh"
replace district="BalrampurUP" if district=="Balrampur" & detectedstate=="Uttar Pradesh"
replace district="HamirpurHP" if district=="Hamirpur" & detectedstate=="Himachal Pradesh"
replace district="HamirpurUP" if district=="Hamirpur" & detectedstate=="Uttar Pradesh"
replace district="PratapgarhUP" if district=="Pratapgarh" & detectedstate=="Uttar Pradesh"
replace district="PratapgarhRJ" if district=="Pratapgarh" & detectedstate=="Rajasthan"

replace district="Delhi" if district=="" & detectedstate=="Delhi"  //They are not distinguishing districts inside Delhi
replace district="Dadra and Nagar Haveli" if district=="Dadra And Nagar Haveli"    //Just to match the string with the zone classification data
replace district="North and Middle Andaman" if district=="North And Middle Andaman"  //Just to match the string with the zone classification data
replace district="Dibang Valley" if district=="Upper Dibang Valley"     //Because in the  order it is Dibang valley
replace district="Kradaadi" if district=="Kra Daadi"
*There are some missing district name.
*tab detecteddistrict, m  //Checking for the missing values
drop if district=="" //deleting missing observations
drop if currentstatus==""  //status is not specified
*============= CREATING DISTRICTWISE MONTHLY PANEL DATA  ========================*
//Creating dataset districtwise monthly for each current status 
collapse(sum) numcases, by(detectedstate district month currentstatus)



*============== CREATING WIDE DATA==========================*
gen infected=0   //hospitalized are the NUMBER OF CASES CONFIRMED 
replace infected= numcases if currentstatus=="Hospitalized"  //MONTHLY NUMBER OF CASES CONFIRMED

gen recovered=0 // receovered are the NUMBER OF CASES RECOVERED
replace recovered= numcases if currentstatus=="Recovered"   //MONTHLY NUMBER OF CASES RECOVERED

gen deceased=0
replace deceased= numcases if currentstatus=="Deceased"

*creating monthly data
collapse(sum) infected recovered deceased, by(detectedstate district month)

gen active=0   // MONTHLY ACTIVE cases
replace active= infected - recovered - deceased

// Creating cumulative number of confirmed cases
by detectedstate district: gen infection= sum(infected)  //CUMULATIVE MONTHLY CONFIRMED CASES

//Creating cumulative number of active cases
by detectedstate district: gen current_active= sum(active)   // CUMULATIVE MONTHLY ACTIVE CASES

*--------Labels 
label var infected "Number of infection per month"
label var deceased "Number of patients deceased per month"
label var recovered "Number of patients recovered per month"
label var active "Number of active patients per month"
label var infection "Cumulative infection"
label var current_active "Active number of patient"
label var month "month of the year"


drop if detectedstate==""  //droping the observations where state is unknown
drop if month==9 //We don't want September data

sort detectedstate district month // First sorting with state, then district, and the with MONTH
order detectedstate district month 

save "district_panel.dta", replace   //This is by-MONTH district level panel of infections
//But this dataset is not balance. 


/*================================================================================
Creating balanced by-Month district level panel of infections
================================================================================*/

/* The following codes are for adding observations in the panel data for missing periods */

clear all
cd "$datasets\COVID19-India.API"  //Changing the directory

use district_panel.dta,  //Using above data "district_panel.dta"
keep detectedstate district //Only keeping state and district
duplicates drop detectedstate district, force   // dropping duplicates

expand 8   //8 months 

*Creating each week from month1 to month 7 for each district
bysort detectedstate district:gen month=0+_n  // from January to August ( 8 months)

sort detectedstate district month // sort the data in the same manner we sort it for above data

merge detectedstate district month using district_panel.dta, // This will merge the observations

sort detectedstate district month 
drop _merge detectedstate

*replacing missing with zeroes
*Because missing values means zero infections
replace infected=0 if infected==.
replace recovered =0 if recovered ==.
replace deceased =0 if deceased ==.
replace active =0 if active ==.
replace infection =0 if infection ==.
replace current_active =0 if current_active ==.

*--------Lables
label var district "detected district"
*-----------------------
collapse(sum) infected recovered deceased active infection current_active, by(district month)

//In India Covid-19 infections started in year 2020
gen year=2020
*drop state
sort district month 
order district year month 
drop if district=="Capf Personnel" //unwanted

save "district_monthlypanel.dta", replace  //This is district-wise monthly data




















/*==================================================================================
                           SHRUG DATA

MERGED DATA USING SHRUGID AND THEN AGGREGATED AT DISTRICT LEVEL
================================================================================*/

/* The SHRUG data has 2011 districts i.e 640 districts. It contains all the villages and towns.
   For our analysis, we need 733 districts as per year 2020. So, I need to reorganisethe districts.
   In the following section I am reorganising the districts, so that, I will get the data for 733 disitrcts.
   For this, I downloded the official orders which describe how new destricts were formed. */


clear all
cd "$datasets\SHRUG" //All the SHRUG data required for the analysis
  
use "shrug_names.dta", clear    // This data contains state name, district name, subdistrict name, and places names in that districrs

*----Gujarat---*
tab district_name if state_name=="gujarat"

//sabar kantha--> sabarkantha and aravalli  //501867
tab subdistrict_name if district_name=="sabar kantha"
replace district_name="Aravalli" if inlist( subdistrict_name, "bhiloda", "modasa", "meghraj", "malpur", "dhansura", "bayad")

//I am thinking to give SHRUG-id
//Junagadh---> Junagadh and Gir Somnath
tab subdistrict_name if district_name=="junagadh"
replace district_name="Gir Somnath" if inlist( subdistrict_name, "patan veraval", "sutrapada", "kodinar", "talala", "una")

// Vadodara--> Vadodara and Chotaudepur
tab subdistrict_name if district_name=="vadodara"
replace district_name="Chhota Udaipur" if inlist( subdistrict_name, "chhota udaipur", "jetpur pavi", "kavant", "nasvadi", "sankheda")

//bhavnagar-->botad    could not find--ranpur, barvala
tab subdistrict_name if district_name=="bhavnagar"
replace district_name="Botad" if inlist( subdistrict_name, "botad", "gadhada")

//kheda,panchmahal, mahisagar
tab subdistrict_name if district_name=="kheda"
tab subdistrict_name if district_name=="panch mahals"
replace district_name="Mahisagar" if inlist( subdistrict_name, "lunawada", "kadana", "khanpur", "santrampur", "balasinor", "virpur")
 
//Rajkot, jamnagar, Surendranagar, Morbi
tab subdistrict_name if district_name=="surendranagar"
tab subdistrict_name if district_name=="jamnagar"
tab subdistrict_name if district_name=="rajkot"
replace district_name="Morbi" if inlist( subdistrict_name, "halvad", "maliya", "morvi", "tankara", "wankaner")

//Jamngar, Devbhumi Dwarka
tab subdistrict_name if district_name=="jamnagar"
replace district_name="Devbhumi Dwarka" if inlist(subdistrict_name, "kalavad", "khambhalia", "okhamandal", "bhanvad")

*----Haryana---*
tab district_name if state_name=="haryana"
//Bhiwani, Charkhi Dadri
tab subdistrict_name if district_name=="bhiwani"
replace district_name="Charkhi Dadri" if inlist( subdistrict_name, "badhra", "dadri") 

*----arunachal pradesh---*
//administrative units


//pakke kesang-- carved out from east kameng
tab subdistrict_name if district_name=="east kameng"
replace district_name="Pakke Kessang" if inlist( subdistrict_name, "pakke kessang", "seijosa", "pizirang veo", "dissing passo")

//Kamle--> upper subansiri and lower subansiri
tab subdistrict_name if district_name=="upper subansiri"
tab subdistrict_name if district_name=="lower subansiri"
replace district_name="Kamle" if inlist( subdistrict_name, "daporijo",  "puchi geko", "dollungmukh", "kamporijo", "raga")

//Kradaadi--> carved out of Kurung Kumey
tab subdistrict_name if district_name=="kurung kumey"
replace district_name="Kradaadi" if inlist( subdistrict_name, "palin", "yangte", "chambang", "gangte", "tarak lengdi", "longding koling pipsorang", "tali") //pania

//Lower Siang--> east and west siang
tab subdistrict_name if district_name=="east siang"
tab subdistrict_name if district_name=="west siang"
replace district_name="Lower Siang" if inlist( subdistrict_name, "kora", "koyu", "nari", "new seren", "basar")
replace district_name="Lower Siang" if inlist( subdistrict_name, "daring", "tirbin", "likabali", "kangku", "sibe", "gensi")

//Leparada--> bifurcating from lower siang
tab subdistrict_name if district_name=="Lower Siang"
replace district_name="Leparada" if inlist( subdistrict_name, "basar", "daring", "tirbin", "sago") //sago

//Longding --> carved out from Tirap district
tab subdistrict_name if district_name=="tirap"
replace district_name="Longding" if inlist( subdistrict_name, "longding", "kanubari", "pangchao", "wakka", "lawnu", "pumao")

//Namsai --> Lohit
tab subdistrict_name if district_name=="lohit"
replace district_name="Namsai" if inlist( subdistrict_name, "chongkham", "lathao", "piyong", "namsai", "lekang mahadevpur")

//Shi Yomi-->bifurcating from West Siang
tab subdistrict_name if district_name=="west siang"
replace district_name="Shi Yomi" if inlist( subdistrict_name, "mechuka", "tato", "pidi", "monigong")

//siang-->bifurcating from east and west siang
tab subdistrict_name if district_name=="east siang"
tab subdistrict_name if district_name=="west siang"
replace district_name="Siang" if inlist( subdistrict_name, "rumgong", "kaying", "jomlo mobuk", "boleng", "pangin", "riga", "rebo perging", "kebang" )

*----Assam---*
/* Sub-divisons in Assam in administrative units such as Tehsils and mandals*/
tab district_name if state_name=="assam"

//Biswanath-->sonitpur
tab subdistrict_name if district_name=="sonitpur"
replace district_name="Biswanath" if inlist( subdistrict_name, "biswanath", "gohpur")

//Charaideo--> Sivasagar
tab subdistrict_name if district_name=="sivasagar"
replace district_name="Charaideo" if inlist( subdistrict_name, "sonari")

//Hojai comprised of three tehsils nagaon district, namely, Hojai, Doboka, lanka
tab subdistrict_name if district_name=="nagaon"
replace district_name="Hojai" if inlist( subdistrict_name, "doboka", "lanka", "hojai")

//Majuli-->Northern part of Jorhat
tab subdistrict_name if district_name=="jorhat"
replace district_name="Majuli" if inlist( subdistrict_name, "majuli")

//South Salmara Mankachar: hatsingimari-->dhubri district
tab subdistrict_name if district_name=="dhubri"
replace district_name="South Salmara Mankachar" if inlist(subdistrict_name, "mankacha", "south salmara")


//West Karbi Anglong: Hamren-->donka
tab subdistrict_name if district_name=="karbi anglong"
replace district_name="West Karbi Anglong" if inlist( subdistrict_name, "donka")


*------Chattisgarh----------*
tab district_name if state_name=="chhattisgarh"

//Balod-->Daundi,Daundilohara,Gurur, Balod,Gundardehi of District Durg
tab subdistrict_name if district_name=="durg"
replace district_name="Balod" if inlist( subdistrict_name, "dondi", "dondi luhara", "gurur", "balod", "gunderdehi")

//Baloda Bazar--> Bilaigarh, Kasdol, Balodabazar, Palari, Bhatapara, Sigma of District Raipur
tab subdistrict_name if district_name=="raipur"
replace district_name="Baloda Bazar" if inlist( subdistrict_name, "bilaigarh", "kasdol", "baloda bazar", "palari", "bhatapara", "sigma")

//Balrampur--> Balrampur, Ramchandrapur(Ramanujganj) Wadrafnagar, Rajpur, Kusmi,Shankargarh of District Surguja
tab subdistrict_name if district_name=="surguja"
replace district_name="Balrampur" if inlist( subdistrict_name, "balrampur", "ramanujganj", "ramanujnagar", "wadrafnagar", "rajpur", "samri kusmi", "shankargarh")

//Bametara--> Nawagarh, Bemetara, Berla, Saja,Thankhamariya of District Durg
tab subdistrict_name if district_name=="durg"
replace district_name="Bametara" if inlist( subdistrict_name, "bemetara", "berla", "nawagarh", "saja", "thanakhamria")

//Gariaband--> Fingeshwar, Chhura, Gariyaband, Mainpur, Devbhog of District Raipur
tab subdistrict_name if district_name=="raipur"
replace district_name="Gariaband" if inlist( subdistrict_name, "chhura", "bindranavagarh gariyaband", "mainpur", "deobhog")

//Kondagaon-->Keshkal, Baderajpur, Makdi, Kondagaon, Pharasgaon of District Bastar
tab subdistrict_name if district_name=="bastar"
replace district_name="Kondagaon" if inlist( subdistrict_name, "keskal", "bade rajpur", "makdi", "kondagaon", "farasgaon") 

//Mungeli--> Mungeli, Pathariya, Lormi of District Bilaspur
tab subdistrict_name if district_name=="bilaspur"
replace district_name="Mungeli" if inlist(subdistrict_name, "mungeli", "pathariya", "lormi")

//Sukma--> Chhindgarh, Sukma, Konta of district Dantewada
tab subdistrict_name if district_name=="dakshin bastar dantewada"
replace district_name="Sukma" if inlist( subdistrict_name, "chhindgarh", "konta", "sukma")

//Surajpur--> Surajpur, Bhaiyathan, Odgi, Ramanujnagar, Premnagar, Pratappur of District Surguja
tab subdistrict_name if district_name=="surguja"
replace district_name="Surajpur" if inlist( subdistrict_name, "surajpur", "bhaiyathan", "oudgi", "pratappur", "premnagar")

*-----Madhya Pradesh------------
tab district_name if state_name=="madhya pradesh"

//Agar malwa
tab subdistrict_name if district_name=="shajapur"
replace district_name="Agar Malwa" if inlist( subdistrict_name, "agar", "badod", "susner", "nalkheda")

//Niwari-->tikamgarh
tab subdistrict_name if district_name=="tikamgarh"
replace district_name="Niwari" if inlist( subdistrict_name, "prithvipur", "niwari", "orchha")

*-------Manipur-----*
tab district_name if state_name=="manipur"

//Jiribam-->Imphal East
tab subdistrict_name if district_name=="imphal east"
replace district_name="Jiribam" if inlist( subdistrict_name, "jiribam")

//Kangpokpi-->senapati
tab subdistrict_name if district_name=="senapati"
replace district_name="Kangpokpi" if inlist( subdistrict_name, "saitu gamphazol") //Not all

//Kakching--> thoubal
tab subdistrict_name if district_name=="thoubal"
replace district_name="Kakching" if inlist( subdistrict_name, "kakching")

//Kamjong--> Urkhul
tab subdistrict_name if district_name=="ukhrul"
replace district_name="Kamjong" if inlist( subdistrict_name, "kamjong chassad", "phungyar phaisat")

//Noney-->tamenglong
tab subdistrict_name if district_name=="tamenglong"
replace district_name="Noney" if inlist( subdistrict_name, "nungba")

//Pherzawl--> churachandpur
tab subdistrict_name if district_name=="churachandpur"
replace district_name="Pherzawl" if inlist( subdistrict_name, "singngat", "thanlon", "tipaimukh")

//Tengnoupal-->chandel
tab subdistrict_name if district_name=="chandel"
replace district_name="Tengnoupal" if inlist( subdistrict_name, "machi", "tengnoupal")

*-------Tamil Nadu----------*
tab district_name if state_name=="tamil nadu"

//kancheepuram--> Chengalpattu & kancheepuram
tab subdistrict_name if district_name=="kancheepuram"
replace district_name="Chengalpattu" if inlist( subdistrict_name, "chengalpattu", "maduranthakam", "cheyyur", "tirukalukundram", "tambaram") 

//tirunelveli--> tirunelveli & Tenkasi
tab subdistrict_name if district_name=="tirunelveli"
replace district_name="Tenkasi" if inlist( subdistrict_name, "shenkottai", "tenkasi", "sivagiri", "veerakeralamputhur", "sankarankoil", "alangulam")

//Vellore-> Vellore & Ranipet & Tirupathur
tab subdistrict_name if district_name=="vellore"
replace district_name="Tirupathur" if inlist( subdistrict_name, "ambur", "tirupathur", "vaniyambadi") //Natrampalli
replace district_name="Ranipet" if inlist( subdistrict_name, "arakonam", "arcot", "wallajah") //Nemili

//Viluppuram--> Viluppuram & Kallakuruchi
tab subdistrict_name if district_name=="viluppuram"
replace district_name="Kallakurichi" if inlist( subdistrict_name, "kallakkurichi", "sankarapuram", "tirukkoyilur", "ulundurpettai") //Chinnasalem, kalvarayan Hills

*-----telangana--------*
tab district_name if state_name=="andhra pradesh"

//Hyderabd, Medchal Malkajgiri, Ranga Reddy



*-------Tripura------------*

//Gomati--> Bifurcating south tripura
tab district_name if state_name=="tripura"
tab subdistrict_name if district_name =="south tripura"
replace district_name="Gomati" if inlist( subdistrict_name, "amarpur", "karbuk", "udaipur") //Udaipur

//Khowai --> carved out from "west tripura"
tab subdistrict_name if district_name =="west tripura"
replace district_name="Khowai" if inlist( subdistrict_name, "khowai", "teliamura") 

//Sipahijala --> west tripura
tab subdistrict_name if district_name =="west tripura"
replace district_name="Sipahijala" if inlist( subdistrict_name, "bishalgarh", "jampuijala", "sonamura")

//Unokoti-->bifurcating north tripura
tab subdistrict_name if district_name =="north tripura"
replace district_name="Unokoti" if inlist( subdistrict_name, "kumarghat", "kailashaha") //Kailashaha


*-------------West Bengal--------*
tab district_name if state_name=="west bengal"

//Kalimpong--> "darjiling"
tab subdistrict_name if district_name=="darjiling"
replace district_name="Kalimpong" if inlist( subdistrict_name,"kalimpong-1", "kalimpong-2", "gorubathan")

//Alipurduar--> "darjiling"
replace district_name="Alipurduar" if inlist( subdistrict_name, "alipurduar-1", "alipurduar-2", "madarihat", "falakata", "kalchini", "kumargram")

//Jhargram--> 
replace district_name="Jhargram" if inlist( subdistrict_name, "jhargram")

//https://en.wikipedia.org/wiki/Purba_Bardhaman_district
//Purba Bardhaman + Paschim Bardhaman
tab subdistrict_name if district_name =="barddhaman"
replace district_name="Purba Bardhaman" if inlist( subdistrict_name, "kalna-1", "kalna-2", "manteswar", "purbasthali-1", "purbasthali-2", "katwa-1", "katwa-2")
replace district_name="Purba Bardhaman" if inlist( subdistrict_name, "ketugram-1", "ketugram-2", "mangolkote", "ausgram-1", "ausgram-2", "bhatar")
replace district_name="Purba Bardhaman" if inlist( subdistrict_name, "burdwan-1", "burdwan-2", "galsi-1", "galsi-2", "khandaghosh", "jamalpur") 
replace district_name="Purba Bardhaman" if inlist( subdistrict_name, "memari-1",  "memari-2", "raina-1", "raina-2")

//
replace district_name="Paschim Bardhaman" if district_name =="barddhaman"


*------------Meghalaya-------------*
tab district_name if state_name=="meghalaya"

//South West Garo Hills--> west garo hills
tab subdistrict_name if district_name=="west garo hills"
replace district_name="South West Garo Hills" if inlist( subdistrict_name, "betasing", "zikzak")

//North Garo Hills--> Carved out from east Garo hills
tab subdistrict_name if district_name=="east garo hills"
replace district_name="North Garo Hills" if inlist( subdistrict_name, "kharkutta", "resubelpara")

//South West Khasi Hills--> west khasi hills
tab subdistrict_name if district_name=="west khasi hills"
replace district_name="South West Khasi Hills" if inlist( subdistrict_name, "mawkyrwat", "ranikor")

//East Jaintia Hills-->Janitia Hills
tab subdistrict_name if district_name=="jaintia hills"
replace district_name="East Jaintia Hills" if inlist( subdistrict_name,"khliehriat", "saipung")
*--------Mizoram--------------------*
tab district_name if state_name=="mizoram"

//Hnahthial
tab subdistrict_name if district_name=="lunglei"
replace district_name="Hnahthial" if inlist( subdistrict_name, "hnahthial")

//Khawzawl
tab subdistrict_name if district_name=="champhai"
replace district_name="Khawzawl" if inlist( subdistrict_name, "khawzawl")

//Saitual
replace district_name="Saitual" if inlist(shrid, "11-15-801507", "11-15-271286", "11-15-271281", "11-15-271285")
replace district_name="Saitual" if inlist(shrid, "11-15-271271", "11-15-271285", "11-15-271269", "11-15-271268", "11-15-271270", "11-15-271266")
replace district_name="Saitual" if inlist(subdistrict_name, "phullen", "ngopa")


*---------Uttar Pradesh---------*
tab district_name if state_name =="uttar pradesh"

//Sambhal--> 
//https://sambhal.nic.in/about-district/
replace district_name="Sambhal" if inlist(subdistrict_name,"chandausi", "sambhal", "gunnaur")

//Hapur-->https://hapur.nic.in/hi/%e0%a4%a4%e0%a4%b9%e0%a4%b8%e0%a5%80%e0%a4%b2/
replace district_name="Hapur" if inlist(subdistrict_name, "garhmukteshwar", "hapur")

//Shamli:     https://shamli.nic.in/tehsil/
replace district_name="Shamli" if inlist(subdistrict_name, "kairana", "shamli")

//Amethi: https://amethi.nic.in/
replace district_name="Amethi" if inlist(subdistrict_name, "tiloi", "amethi", "gauriganj", "musafirkhana")


*------------Punjab----------------*
tab district_name if state_name =="punjab"

*https://revenue.punjab.gov.in/?q=revenue-establishment<- this is the link for the orders but cannot download

//Fazilka-->Firozpur
*https://db0nus869y26v.cloudfront.net/en/Fazilka_district
tab subdistrict_name if district_name=="firozpur"
replace district_name="Fazilka" if inlist(subdistrict_name, "fazilka", "abohar", "jalalabad")


// Pathankot district by the partition of Gurdaspur district
*https://db0nus869y26v.cloudfront.net/en/Pathankot_district
tab subdistrict_name if district_name=="gurdaspur"
replace district_name="Pathankot" if inlist(subdistrict_name, "pathankot", "dhar kalan")

*-------------Maharashtra------------*
tab district_name if state_name =="maharashtra"

//Palghar
//Palghar District was carved out of the old Thane district
* https://en.wikipedia.org/wiki/Palghar_district#:~:text=Palghar%20District%20is%20a%20district%20in%20the%20state,Dahanu%20at%20the%20north%20and%20ends%20at%20Naigaon.
tab subdistrict_name if district_name=="thane"
replace district_name="Palghar" if inlist(subdistrict_name, "palghar", "vada", "vikramgad", "jawhar", "mokhada", "dahanu", "talasari", "vasai")

//mumbai suburban--> "11-27-802794"

//mumbai--"11-27-553514", "11-27-802788", 

//

replace district_name="Mumbai Suburban" if inlist(shrid, "11-27-802794")
replace district_name="Mumbai" if inlist(shrid, "11-27-553514", "11-27-802788")

//"nct of delhi"

***********************************************************************************************************************************************
*-------Telangana------*
tab subdistrict_name if state_name=="andhra pradesh"

* sub-districts are mandals

//Bhadradri Kothagudem-- khammam
tab subdistrict_name if district_name=="khammam"

*New manddals in Bhadradri Kothagudem
*Sujathanagar is formed from Kothagudem
tab place_name if subdistrict_name=="kothagudem" 
replace subdistrict_name= "Sujathanagar" if inlist(place_name, "Sarvaram", "Sujathanagar", "Singabhupalem", "Seethampeta", "Raghavapuram")

*Chunchupalli is formed from Kothagudem mandal
tab place_name if subdistrict_name=="kothagudem" 
replace subdistrict_name= "Chunchupalli" if inlist(place_name, "garimella padu u", "chunchupalle u")

*Laxmidevipalli is formed from kothagudem mandal
replace subdistrict_name= "Laxmidevipalli" if inlist(place_name, "chatakonda ct", "laxmidevipalle", "Regalla", "Karukonda", "Gattumalla")
replace subdistrict_name= "Laxmidevipalli" if inlist(place_name, "Kunaram", "Punukuduchelka", "Bangaru Chelka", "gollagudem")

*Allapalli is formed from gundala
tab place_name if subdistrict_name=="gundala" 
replace subdistrict_name= "Allapalli" if inlist(place_name, "Adavi Ramavaram", "appaipeta", "Markode", "Pedda Venkatapuram", "Allapalle", "Anantharam")

*Annapureddypalli is formed from chandrugonda
tab place_name if subdistrict_name=="chandrugonda"
replace subdistrict_name= "Annapureddypalli" if inlist(place_name,"Gumpena", "Vootupalle", "Peddireddigudem", "Abbugudem", "Namavaram")
replace subdistrict_name= "Annapureddypalli" if inlist(place_name, "Annapureddipalle", "Narsapuram", "Annadevam", "Teligerla", "Pentlam")

*Karakagudem is formed from Pinapaka
tab place_name if subdistrict_name=="pinapaka"
replace subdistrict_name= "Karakagudem" if inlist(place_name,  "Mothe (Pattimallur)",  "Samath Mothe", "Regalla", "Samathbhattupalle", "Bhattupalle")
replace subdistrict_name= "Karakagudem" if inlist(place_name, "Anantharam (Patimallur)", "Chirramalla", "Kalvalanagaram", "Karakagudem")

**
replace district_name="Bhadradri Kothagudem" if inlist(subdistrict_name, "kothagudem", "palwancha", "tekulapalle", "yellandu", "aswaraopeta", "dummugudem", "cherla")
replace district_name="Bhadradri Kothagudem" if inlist(subdistrict_name, "chandrugonda", "dammapeta", "mulkalapalle", "gundala", "julurpad", "bhadrachalam")
replace district_name="Bhadradri Kothagudem" if inlist(subdistrict_name, "burgampahad", "aswapuram", "manuguru", "pinapaka")
replace district_name="Bhadradri Kothagudem" if inlist(subdistrict_name, "Sujathanagar", "Chunchupalli", "Laxmidevipalli", "Allapalli")
replace district_name="Bhadradri Kothagudem" if inlist(subdistrict_name, "Annapureddypalli", "Karakagudem")

//hyderabad
replace district_name="Hyderabad" if inlist(place_name, "hyderabad", "greater hyderabad municipal corporation part")

//Jagtial--Karimnagar
tab subdistrict_name if district_name=="karimnagar"

*Jagtial Rural i formed from jagtial
replace subdistrict_name="Jagtial Rural" if subdistrict_name=="jagtial"
replace subdistrict_name="jagtial" if inlist(place_name, "jagtial")

*Beerpur is formed form sarangapur
tab place_name if subdistrict_name=="sarangapur"
replace subdistrict_name="Beerpur" if inlist(place_name, "Beerpur", "Narsimlapalle", "Cherlapalle", "Kandlapalle", "Thungur", "Kandlapalle")
replace subdistrict_name="Beerpur" if inlist(place_name, "Kolvai", "Mangela", "Rangasagar", "Thalladharmaram", "Kammunur", "Rekulapalle")

*Buggaram
tab place_name if subdistrict_name=="dharmapuri"
tab place_name if subdistrict_name=="gollapalle"
replace subdistrict_name="Buggaram" if inlist(place_name, "Buggaram", "Chinnapur", "Velgonda", "Sirivanchakota", "Madnoor", "Gopulapur", "Beersani", "Sirikonda")
replace subdistrict_name="Buggaram" if inlist(place_name, "Yeshwanthraopet", "Shakalla", "Gangapuram")

**"Jagtial"
replace district_name="Jagtial" if inlist(subdistrict_name, "jagtial", "Jagtial Rural", "raikal", "sarangapur", "Beerpur", "mallial")
replace district_name="Jagtial" if inlist(subdistrict_name, "dharmapuri", "Buggaram", "pegadapalle", "gollapalle", "kodimial", "velgatoor")
replace district_name="Jagtial" if inlist(subdistrict_name, "koratla", "metpalle", "mallapur", "ibrahimpatnam", "medipalle", "kathlapur")


//Ranga Reddy
tab subdistrict_name if district_name=="rangareddy"
tab subdistrict_name if state_name =="andhra pradesh"

*"Choudergudem"
replace subdistrict_name="Choudergudem" if inlist(place_name, "Indranagar", "Gurrampalle", "Pedda Yelkicherla", "Veerannapet", "Chegireddy Ghanpur")
replace subdistrict_name="Choudergudem" if inlist(place_name, "Jakaram", "Gunjalapahad ", "Edira", "Raviryal", "Tummalapalle", "Padmaram") 
replace subdistrict_name="Choudergudem" if inlist(place_name, "Thoompalle", "Chennareddiguda", "Malkapahad", "Chalivendrampalle", "Vanampalle")

//ranga reddy
replace district_name="Ranga Reddy" if inlist(subdistrict_name, "ibrahimpatnam", "rajendranagar", "shadnagar", "kandukur", "chevella")
replace district_name="Ranga Reddy" if inlist(subdistrict_name, "hayathnagar", "abdullapurmet", "ibrahimpatnam", "madgul", "manchal")
replace district_name="Ranga Reddy" if inlist(subdistrict_name, "yacharam", "serilingampally", "rajendranagar", "gandipet", "shamshabad")
replace district_name="Ranga Reddy" if inlist(subdistrict_name, "nandigama", "kothur", "farooqnagar", "keshampet", "kondurg", "Choudergudem")
replace district_name="Ranga Reddy" if inlist(subdistrict_name, "saroornagar", "Balapur", "Maheshwaram", "kandukur", "Kadthal", "amangal")
replace district_name="Ranga Reddy" if inlist(subdistrict_name, "Thalakondapally", "shankarpalle", "shabad")


//Jangaon-->warangal & nalagonda
tab subdistrict_name if district_name=="warangal"
tab subdistrict_name if district_name=="nalgonda"

*"Tharigoppula"-->narmatta
tab place_name if subdistrict_name=="narmetta"
replace subdistrict_name="Tharigoppula" if inlist(place_name, "Ankushapuram", "Bonthagattunagaram", "Tarigoppula", "Solipuram")
replace subdistrict_name="Tharigoppula" if inlist(place_name, "Potharam", "Akkerajapalle", "Narasapur", "Abdulnagaram")

* Chilpur--ghanpur station
tab place_name if subdistrict_name=="ghanpur station"
replace subdistrict_name="Chilpur" if inlist(place_name, "Chilpur", "Sreepathipalle", "Chinnapendyal", "Kondapur", "Lingam Palle", "Malkapur")
replace subdistrict_name="Chilpur" if inlist(place_name, "Venkatadripeta", "Krishnajigudem", "Fathepur", "Pallagutta", "Rajawaram", "Nashkal")

replace district_name="Jangaon" if inlist(subdistrict_name, "jangaon", "lingalaghanpur", "palakurthi", "gundala")
replace district_name="Jangaon" if inlist(subdistrict_name, "bachannapet", "devaruppula", "narmetta", "Tharigoppula")
replace district_name="Jangaon" if inlist(subdistrict_name, "raghunathpalle", "ghanpur station", "Chilpur", "zaffergadh", "kodakandla")


//Jayashankar Bhupalapally--warangal and khammam and karimnagar
tab subdistrict_name if district_name=="warangal"
tab subdistrict_name if district_name=="karimnagar"
tab subdistrict_name if district_name=="khammam"

*Tekumatla--> chityal
tab place_name if subdistrict_name=="chityal"
replace subdistrict_name="Tekumatla" if inlist(place_name, "Tekumatta", "Kalikota", "Venkatraopalle", "Garimillapalle")
replace subdistrict_name="Tekumatla" if inlist(place_name, "Boina Palle", "Emped", "Gummadavelli", "Raghavapur")
replace subdistrict_name="Tekumatla" if inlist(place_name, "Ramakistapur (T)", "Ramakistapur (V)", "Kundanpalle")
replace subdistrict_name="Tekumatla" if inlist(place_name, "Vellampalle", "Velchal", "Pangidipalle", "Ankushapur", "Somanpalle")

tab place_name if subdistrict_name=="mogullapalle"
replace subdistrict_name="Tekumatla" if inlist(place_name, "Raghavareddipet", "Dubyala")

*Palimela-->mahadevpur
tab place_name if subdistrict_name=="mahadevpur"
replace subdistrict_name="Palimela" if inlist(place_name, "Palmela", "Pankena", "Lenkalagadda", "garkepalle", "Moded", "bheemanpalle")
replace subdistrict_name="Palimela" if inlist(place_name, "Medigadda", "Dammur", "Burgugudem", "Neelampalle", "Sarvaipet")
replace subdistrict_name="Palimela" if inlist(place_name, "Timmatigudem", "Venchepalle", "kishtapur", "Muknur", "Kamanpalle")

*Kannaigudem --> eturnagaram
tab place_name if subdistrict_name=="eturnagaram"
replace subdistrict_name="Kannaigudem" if inlist(place_name, "Thupakulagudem", "Gangaram(Guttala)", "andukapalle", "Rajannapet")
replace subdistrict_name="Kannaigudem" if inlist(place_name, "Gangugudem", "Kannaigudem", "Bhupathipuram", "Laxmipuram", "kothur")
replace subdistrict_name="Kannaigudem" if inlist(place_name, "Chityala", "Sarvai", "marepalle", "paredu", "padigapuram", "malkapalle")
replace subdistrict_name="Kannaigudem" if inlist(place_name, "Gurrevula", "Devadhumula", "Laxmipuram", "kothur", "Rampuragrahar", "Muppanapalle")
replace subdistrict_name="Kannaigudem" if inlist(place_name, "Buttaigudem", "Chinthagudem", "Etur", "Singaram (Pattigorrevula)", "Kanthanpalle")

replace district_name="Jayashankar Bhupalapally" if inlist(subdistrict_name, "bhupalpalle", "ghanpur mulug", "regonda", "mogullapalle")
replace district_name="Jayashankar Bhupalapally" if inlist(subdistrict_name, "chityal", "Tekumatla", "mulug", "venkatapur", "govindaraopet")
replace district_name="Jayashankar Bhupalapally" if inlist(subdistrict_name, "eturnagaram", "tadvai", "Kannaigudem", "mangapet")
replace district_name="Jayashankar Bhupalapally" if inlist(subdistrict_name, "malharrao", "kataram", "mahadevpur", "Palimela")
replace district_name="Jayashankar Bhupalapally" if inlist(subdistrict_name, "mutharam mahadevpur", "venkatapuram", "wazeed")

//Jogulamba Gadwal
tab subdistrict_name if district_name=="mahabubnagar"

*"Undavelly"
tab place_name if subdistrict_name=="manopad"
replace subdistrict_name="Undavelly" if inlist(place_name, "Undavelli", "A.Burdipad", "Chinnaamudyala Padu", "Kanchupadu")
replace subdistrict_name="Undavelly" if inlist(place_name, "Pullur", "Kalgotla", "Mennipadu", "Bonkur", "Itkyalpadu")
tab place_name if subdistrict_name=="alampur"
replace subdistrict_name="Undavelly" if inlist(place_name, "Maramunagala", "Seripalle", "Pragatoor", "Thakkasila", "Bhairapur", "Baswapur")


*KaloorThimmandoddi
tab place_name if subdistrict_name=="ghattu" 
replace subdistrict_name="KaloorThimmandoddi" if inlist(place_name, "Kaloor Timmanadoddi", "Naudinne", "Kuchinerla", "Easarlapad", "Chintalakunta")
tab place_name if subdistrict_name=="dharur"
replace subdistrict_name="KaloorThimmandoddi" if inlist(place_name, "Guvvaladinne", "Kondapur", "Venkatapuram", "Pagunta")
replace subdistrict_name="KaloorThimmandoddi" if inlist(place_name, "Erlabanda", "Umithyala", "Ganganapalle", "Musaldoddi")

*Rajoli
tab place_name if subdistrict_name=="waddepalle"
replace subdistrict_name="Rajoli" if inlist(place_name, "Turpugarlapadu", "Padamatigarlapadu", "Thummella", "Mundladinne", "Pedda Thandrapadu")
replace subdistrict_name="Rajoli" if inlist(place_name, "Rajoli", "Patcharla", "Mandoddi", "Nasnur", "Chinnadhanwada", "Peddadhanwada")

replace district_name="Jogulamba Gadwal" if inlist(subdistrict_name, "gadwal", "dharur", "ghattu", "itikyal", "Undavelly", "manopad")
replace district_name="Jogulamba Gadwal" if inlist(subdistrict_name, "ieej", "alampur", "waddepalle", "Rajoli", "KaloorThimmandoddi", "maldakal")


//Kamareddy-->
*Rajampet
tab place_name if subdistrict_name=="bhiknoor"
tab place_name if subdistrict_name=="tadwai"
replace subdistrict_name="Rajampet" if inlist(place_name, "Rajampet", "Pondurthi", "Talmadla", "Peddapalle", "Argonda", "Siddapur", "Gundaram")

*Bibipet
tab place_name if subdistrict_name=="domakonda"
replace subdistrict_name="Bibipet" if inlist(place_name, "Bibipet", "Tujalpur", "Yadaram", "Ramreddipalle", "Malkapur", "Issanagar")
replace subdistrict_name="Bibipet" if inlist(place_name, "Jangaon", "Konapur", "Mohammadapur", "Ramchandrapur")

*Nasrullabad--"birkoor"
tab place_name if subdistrict_name=="birkoor"
replace district_name="Kamareddy" if inlist(subdistrict_name, "kamareddy", "bhiknoor", "tadwai", "Rajampet", "domakonda", "Bibipet")
replace district_name="Kamareddy" if inlist(subdistrict_name, "machareddy", "sadasivanagar", "Ramareddy", "banswada", "birkoor", "Nasrullabad")
replace district_name="Kamareddy" if inlist(subdistrict_name, "bichkunda", "jukkal", "pitlam", "Pedda Kodapgal", "madnoor", "nizamsagar")
replace district_name="Kamareddy" if inlist(subdistrict_name, "yellareddy", "nagareddipet", "lingampet", "gandhari")

//Medchal Malkajgiri--was part of ranga-reddy
tab subdistrict_name if district_name=="rangareddy"
replace district_name="Medchal Malkajgiri" if inlist(subdistrict_name, "uppalaguptam", "balanagar")

//Suryapet-> nalgonada
tab subdistrict_name if district_name=="nalgonda"

*Nagaram
tab place_name if inlist(subdistrict_name, "thungathurthi", "thirumalgiri", "jaji reddi gudem")
replace subdistrict_name="Bibipet" if inlist(place_name, "Pasthala", "Pasnur", "Laxmapur")
replace subdistrict_name="Bibipet" if inlist(place_name, "Mamidi Palle", "Etoor", "Phanigiri", "Chenna Puram", "Nagaram")

*Maddirala
tab place_name if inlist(subdistrict_name, "nuthankal", "thungathurthi" )
replace subdistrict_name="Maddirala" if inlist(place_name, "Maddirala", "Mukundapuram", "Chandu Patla", "Polumalla", "Gorentla", "Mamindla Madava")
replace subdistrict_name="Maddirala" if inlist(place_name, "Gummadavally", "Chinna Nemila", "Ramachandrapuram", "Kukkadam", "Kunta Palle", "Reddiguda")

*Palakeedu
tab place_name if inlist(subdistrict_name, "neredcherla")
replace subdistrict_name="Palakeedu" if inlist(place_name, "Guduguntla Palem", "Musivoddusingaram", "Yellapuram", "Sajjapuram", "Palakeedu", "Komatikunta")
replace subdistrict_name="Palakeedu" if inlist(place_name, "Sunya Pahad", "Mahankali Gudem", "Ravipahad", "Gundeboina Gudem", "Janapahad", "Bothalapalem")
replace subdistrict_name="Palakeedu" if inlist(place_name, "Alangapuram", "Gundlapahad")

*Ananthagiri
tab place_name if inlist(subdistrict_name, "kodad", "nadigudem")
replace subdistrict_name="Palakeedu" if inlist(place_name, "Palaram", "Chan Palle", "Yasanthapuram", "Singavaram", "Tiru Annaram", "Gondriyala", "Khana Puram")
replace subdistrict_name="Palakeedu" if inlist(place_name, "Lakmavaram", "Tiru Annaram", "Khana Puram", "Anantha Giri")

replace district_name="Suryapet" if inlist(subdistrict_name, "atmakur s", "chivvemla", "mothey", "jaji reddi gudem", "nuthankal", "penpahad")
replace district_name="Suryapet" if inlist(subdistrict_name, "suryapet", "thirumalgiri", "thungathurthi", "garide palle", "neredcherla", "Nagaram")
replace district_name="Suryapet" if inlist(subdistrict_name, "Maddirala", "Palakeedu", "chilkur", "huzurnagar", "kodad", "mattam palle")
replace district_name="Suryapet" if inlist(subdistrict_name, "mella cheruvu", "munagala", "nadigudem", "Chinthalapalem", "Ananthagiri")


//Vikarabad
replace district_name="Vikarabad" if inlist(subdistrict_name, "Marpalle", "nawabpet", "Mominpet", "Vikarabad", "Pudur", "Kulkacherla")
replace district_name="Vikarabad" if inlist(subdistrict_name, "parigi", "dharur", "kotapalle", "Kodangal", "bomraspet", "Doulthabad", "tadoor")

//Komaram Bheem--> Adilabad
tab subdistrict_name if district_name=="adilabad"

*Lingapur-->Sirpur-U
tab place_name if inlist(subdistrict_name, "sirpur", "tiryani")
replace subdistrict_name="Lingapur" if inlist(place_name, "Lingapur", "Jamuldhara", "Yellapatar", "Khanchanpalle", "Ghumnur (Buzurg)")
replace subdistrict_name="Lingapur" if inlist(place_name, "Ghumnur (Khurd)", "Kothapalle", "Mamidipalle", "Chorpalle", "Vankamaddi", "Loddiguda")

*"Penchicalpet"
tab place_name if inlist(subdistrict_name, "bejjur", "kagaznagar", "dahegaon" )
replace subdistrict_name="Penchicalpet" if inlist(place_name, "Bombaiguda", "Gundepalle", "Kammarpalle", "Nandigaon", "Kondapalle", "Lodpalle")
replace subdistrict_name="Penchicalpet" if inlist(place_name, "Muraligunda", "Jilleda", "telapalle", "Penchikalpet", "Agarguda")

*"Chintalamanepally"
tab place_name if inlist(subdistrict_name, "kouthala", "sirpur", "bejjur")
replace subdistrict_name="Chintalamanepally" if inlist(place_name, "Babapur", "Babasagar", "Balaji Ankoda", "Chintala Manepalle", "Gangapur")
replace subdistrict_name="Chintalamanepally" if inlist(place_name, "Burepalle", "Korisini", "bandepalle", "Ranvalli", "Ravindranagar", "Kethini")
replace subdistrict_name="Chintalamanepally" if inlist(place_name, "Dimda", "Chittam", "Gudem", "Buruguda", "Koyapalle", "Shivapalle")

replace district_name="Komaram Bheem" if inlist(subdistrict_name, "sirpur town", "Lingapur", "jainoor", "tiryani", "asifabad", "kerameri")
replace district_name="Komaram Bheem" if inlist(subdistrict_name, "wankdi", "rebbana", "bejjur", "Penchicalpet", "kagaznagar", "kouthala")
replace district_name="Komaram Bheem" if inlist(subdistrict_name, "Chintalamanepally", "dahegaon", "sirpur")


//Mancherial
replace district_name="Mancherial" if inlist(subdistrict_name, "chennur", "jaipur", "bheemaram", "kotapalle", "luxettipet", "mancherial")
replace district_name="Mancherial" if inlist(subdistrict_name, "Naspur", "Hajipur", "mandamarri", "mandamarri", "dandepalle", "jannaram")

//Medak
replace district_name="Medak" if inlist(subdistrict_name, "Yeldurthy", "Medak", "Havelighanapur", "Papannapet", "Shankarampet-R", "nizampatnam", "shayampet")

//Narayanpet-->mahbubnagar
tab subdistrict_name if district_name=="mahbubnagar"
replace district_name="Narayanpet" if inlist(subdistrict_name, "narayanpet", "damaragidda", "dhanwada", "marikal", "kosgi", "maddur")
replace district_name="Narayanpet" if inlist(subdistrict_name, "utkoor", "narva", "makthal", "maganoor", "krishna")

//Nirmal-->Adilabad
tab subdistrict_name if district_name=="adilabad"

*Nirmal Rural-->nirmal
tab place_name if subdistrict_name=="nirmal"
tab place_name if subdistrict_name=="sarangapur"
replace subdistrict_name="Nirmal Rural" if inlist(place_name, "Dyangapur", "Yellareddipet", "Medpalle", "Neelaipet", "Ananthpet", "Kamlapur")
replace subdistrict_name="Nirmal Rural" if inlist(place_name, "Yedlapur", "Nagnaipet", "Langdapur", "Talwada", "Manjulapur", "Chityal", "New Mujgi")
replace subdistrict_name="Nirmal Rural" if inlist(place_name, "Thamsa", "Yellapalle", "Bhagyanagar", "New Pochampad", "Ratnapur Kondli", "Kondapur")
replace subdistrict_name="Nirmal Rural" if inlist(place_name, "mambapur", "Koutla (K)", "Muktapur", "Akkapur", "Ratnapur Kondli")
replace subdistrict_name="Nirmal Rural" if inlist(place_name, "Ranapur", "Gangapur", "Pakpatla", "Madapur", "Jafrapur", "Ganjal")
replace subdistrict_name="Soan" if inlist(place_name, "Soan", "Shakari", "Kadthal", "Siddankunta (New)", "Old Pochampad")
replace subdistrict_name="Soan" if inlist(place_name, "Pakptla", "Madhapur", "Jafrapur") 

*Narsapur G--> 
tab place_name if inlist(subdistrict_name, "dilawarpur", "kuntala")
replace subdistrict_name="Narsapur G" if inlist(place_name, "Anjani", "Naseerabad", "Rampur", "Temborni", "shakapur", "Nandan", "Chakepalle")
replace subdistrict_name="Narsapur G" if inlist(place_name, "Dongargaon", "Arly (Khurd)", "Burgupalle (K)", "Mutakapalle")
replace subdistrict_name="Narsapur G" if inlist(place_name, "Gulmadaga", "Turati", "Burugupalle (G)", "velgudhari", "tekulpahad")

*Dasturabad--> kaddam peddur
tab place_name if inlist(subdistrict_name, "kaddam peddur")
tab place_name if subdistrict_name=="Sarangapur"
replace district_name="Nirmal" if inlist(subdistrict_name, "Nirmal Rural", "Soan", "dilawarpur", "Narsapur G", "kaddam peddur")
replace district_name="Nirmal" if inlist(subdistrict_name, "Dasturabad", "khanapur", "mamda", "Pembi", "laxmanchanda", "Sarangapur")
replace district_name="Nirmal" if inlist(subdistrict_name, "kubeer", "kuntala", "bhainsa", "mudhole", "Basar", "lokeswaram", "tanoor")

//Rajanna Sircilla

*Thangallapalli
tab place_name if subdistrict_name=="sircilla"
replace subdistrict_name="Thangallapalli" if inlist(place_name, "Chintalthana", "Cheerlavancha", "Thadur", "Mandepalle", "Oblapur(PK)")
replace subdistrict_name="Thangallapalli" if inlist(place_name, "Kasbekatkur", "Venugopalpur", "Gandilachachapet", "Jillella", "Sarampalle")
replace subdistrict_name="Thangallapalli" if inlist(place_name, "Badnepalle", "Baswapur", "Nerella", "Ramchandrapur", "Narsimhulapalle")

*"vemulawada Rural"
tab place_name if subdistrict_name=="vemulawada"
replace subdistrict_name="vemulawada" if inlist(place_name, "Jayavaram", "Kodumunja", "Anupuram", "Rudraram", "Hanumajipet", "Mallaram")
replace subdistrict_name="vemulawada" if inlist(place_name, "Bollaram", "Marripalle", "Venkatampalle", "Nookalamarri", "Vattemla")
replace subdistrict_name="vemulawada" if inlist(place_name, "Fazil Nagar", "Chekkapalle", "Edurugatla", "Lingampalle")

*Veernapalli-->yellareddipet
tab place_name if subdistrict_name=="yellareddipet"
replace subdistrict_name="Veernapalli" if inlist(place_name, "Veernapalle", "Venapalle", "Garjanpalle", "Adivipadira", "Kancherla", "Maddimalla")

replace district_name="Rajanna Sircilla" if inlist(subdistrict_name, "sircilla", "Thangallapalli", "gambhiraopet", "vemulawada Rural")
replace district_name="Rajanna Sircilla" if inlist(subdistrict_name, "chandurthi", "Rudrangi", "boinpalle", "yellareddipet", "Veernapalli")
replace district_name="Rajanna Sircilla" if inlist(subdistrict_name, "mustabad", "ellanthakunta", "konaraopeta")

//Sangareddy
replace district_name="Sangareddy" if inlist(subdistrict_name, "ramachandrapuram", "Sangareddy", "Kandi", "Sadasivpet", "Patancheru", "Ameerpur")
replace district_name="Sangareddy" if inlist(subdistrict_name, "Munipally", "Jinnaram", "Pulkal", "Andole", "Vatpally", "Hathnooora") 

//Mahabubabad
tab subdistrict_name if district_name=="warangal"
tab subdistrict_name if district_name=="khammam"

*Gangaram- 
tab place_name if subdistrict_name=="kothagudem"
replace subdistrict_name="Gangaram" if inlist(place_name, "Peddayellapur", "Jangalpalle", "Chintaguda", "Komatlagudem", "Bavurugonda")
replace subdistrict_name="Gangaram" if inlist(place_name, "Mahadevuniguda", "Kamaram", "Marriguda", "Ponugonda", "Ramram", "Mamadigudem")
replace subdistrict_name="Gangaram" if inlist(place_name, "Dubbaguda", "Gangaram", "Kodishalamitta", "Pandem", "bhupalapatnam", "Puttalabhupathy")

*Chinnagudur -> Maripeda
tab place_name if subdistrict_name=="maripeda"
replace subdistrict_name="Chinnagudur" if inlist(place_name, "Uggampalle", "Chinnagudur", "Jayyaram", "Veesampalle", "Gundamrajupalle")

*Danthalapalle -> narsimhulapet 
tab place_name if subdistrict_name=="narsimhulapet"
replace subdistrict_name="Danthalapalle" if inlist(place_name, "Danthalapalle", "Vemulapalle", "Kummarikuntla", "Gunnepalle", "Peddamupparam")
replace subdistrict_name="Danthalapalle" if inlist(place_name, "Ramavaram", "Agapet", "Reponi", "Datla", "kalavapalle")

*Peddavangara -> thorrur & Kodakandla
tab place_name if inlist(subdistrict_name, "thorrur", "kodakandla")
replace subdistrict_name="Peddavangara" if inlist(place_name, "Gantlakunta", "Authapur", "Peddavangara", "Koripalle", "Waddekothapalle")
replace subdistrict_name="Peddavangara" if inlist(place_name, "Pocharam", "Pochanpalle", "Bommakal", "Chinnavangara", "Chityal")

replace district_name="Mahabubabad" if inlist(subdistrict_name, "mahabubabad", "kuravi", "kesamudram", "dornakal", "gudur", "Gangaram", "bayyaram")
replace district_name="Mahabubabad" if inlist(subdistrict_name, "garla", "Chinnagudur", "Danthalapalle", "thorrur", "nellikudur")
replace district_name="Mahabubabad" if inlist(subdistrict_name, "maripeda", "narsimhulapet", "Peddavangara")


//Mulugu -> Jayashankar Bhupalapally
tab subdistrict_name if district_name=="Jayashankar Bhupalapally"
replace district_name="Mulugu" if inlist(subdistrict_name, "mulug", "venkatapur", "govindaraopet", "tadvai", "eturnagaram")
replace district_name="Mulugu" if inlist(subdistrict_name, "Kannaigudem", "mangapet", "venkatapuram", "wazeed")

//Nagarkurnool -> mahabubnagar
tab subdistrict_name if district_name=="mahbubnagar"

*Pentlavelli -> kollapur & 
tab place_name if subdistrict_name=="kollapur"
replace subdistrict_name="Pentlavelli" if inlist(place_name, "Pentlavelli", "Manchalakatta", "Vemkal", "Malleswaram")

*Charakonda -> vangoor and veldanda
tab place_name if inlist(subdistrict_name, "vangoor", "veldanda")
replace subdistrict_name="Charakonda" if inlist(place_name, "Charakonda", "Sirsangandla", "Thimmaipalle", "Kamalpur")
replace subdistrict_name="Charakonda" if inlist(place_name, "Jupalle", "Gokaram", "Seriappareddipalle")

*Urkonda -> midgil
tab place_name if subdistrict_name=="midjil"
replace subdistrict_name="Urkonda" if inlist(place_name, "Jagboinpalle", "Urkondapeta", "Revally", "Gudiganpalle")
replace subdistrict_name="Urkonda" if inlist(place_name, "Urkonda", "Madharam", "Bommarasipalle", "Rachalapalle")
replace subdistrict_name="Urkonda" if inlist(place_name, "Jakanalapalle", "Ippaipahad", "Narsampalle")

replace district_name="Nagarkurnool" if inlist(subdistrict_name, "bijinapalle", "nagarkurnool", "peddakothapalle", "telkapalle", "thimmajipet", "Padara")
replace district_name="Nagarkurnool" if inlist(subdistrict_name, "kollapur", "Pentlavelli", "kodair", "kalwakurthy", "kalwakurthy", "veldanda", "Urkonda")
replace district_name="Nagarkurnool" if inlist(subdistrict_name, "vangoor", "Charakonda", "achampet", "amrabad", "balmoor", "lingal", "uppununthala")

//Peddapalli -> karimnagar
tab subdistrict_name if district_name=="karimnagar"

*Anthergaon -> ramagundam
tab place_name if subdistrict_name=="ramagundam" 
replace subdistrict_name="Anthergaon" if inlist(place_name, "Somanapalle", "Murmoor", "Yellampalle", "Goelwada", "Antargoan", "Brahmanapalle")
replace subdistrict_name="Anthergaon" if inlist(place_name, "Akenpalle", "Eklaspur", "mogalpahad")

*Palakurthy -> 
tab place_name if inlist(subdistrict_name, "kamanpur", "velgatur")
replace subdistrict_name="Palakurthy" if inlist(place_name, "Putnoor", "Gudipalle", "Jayyaram", "Esalatakkallapalle", "palakurthy", "Kukkalagudur")
replace subdistrict_name="Palakurthy" if inlist(place_name, "Vemnoor", "Elkalpalle", "Kannala")

replace district_name="Peddapalli" if inlist(subdistrict_name, "peddapalle", "odela", "sultanabad", "julapalle", "elgaid", "dharmaram", "ramagundam")
replace district_name="Peddapalli" if inlist(subdistrict_name, "Anthergaon", "Palakurthy", "srirampur", "kamanpur", "Ramagiri", "manthani", "mutharam manthani")

//Siddipet
tab subdistrict_name if inlist(district_name, "Medak", "karimnagar", "warangal")

*Akkannapet
tab place_name if subdistrict_name=="husnabad"
replace subdistrict_name="Akkannape" if inlist(place_name, "Regonda", "Gouravelli", "Potharam (J)", "Nandaram", "Ramvaram", "Gandipalle", "Dongala Dharmaram")
replace subdistrict_name="Akkannape" if inlist(place_name, "Jangaon", "Akkannapeta", "Anthakkapeta", "Choutapalle", "Kesavapur", "Mallampalle")

replace district_name="Siddipet" if inlist(subdistrict_name, "Siddipet (Urban)", "Siddipet (Rural)", "Nangnoor", "Chinnakodur", "Thoguta", "doulathabad")
replace district_name="Siddipet" if inlist(subdistrict_name, "Mirdoddi", "Dubbak", "Cherial", "Komuravelli", "Gajwel", "Jagdevpur", "Kondapak", "mulug")
replace district_name="Siddipet" if inlist(subdistrict_name, "Markook", "Wargal", "Raipole")
replace district_name="Siddipet" if inlist(subdistrict_name, "husnabad", "Akkannapet", "koheda", "bejjanki", "maddur")

//Yadadri Bhuvanagiri
tab subdistrict_name if district_name=="nalgonda"

*Motakonduru -> 
tab place_name if inlist(subdistrict_name, "alair", "yadagirigutta", "atmakur m", "gundala")
replace subdistrict_name="Motakonduru" if inlist(place_name, "Moota Kondur", "Dilawarpur", "Amman Bole", "Ikkurthi", "Matoor", "Dursagani Palle")
replace subdistrict_name="Motakonduru" if inlist(place_name, "Chande Palle", "Chada", "Chamapuru", "Teryala")

*Addaguduru -> mothkur
tab place_name if inlist(subdistrict_name, "mothkur")
replace subdistrict_name="Addaguduru" if inlist(place_name, "Janakipur", "Chinnapadishala", "Veldevi", "Repaka (P)", "Kanchan Palle", "Adda Gudur")
replace subdistrict_name="Addaguduru" if inlist(place_name, "Choulla Ramaram", "Dharmaram", "Singaram (P)", "Chirra Gudur", "Kotamarthi")

replace district_name="Yadadri Bhuvanagiri" if inlist(subdistrict_name, "alair", "Motakonduru", "rajapet", "mothkur", "yadagirigutta", "bommalaramaram")
replace district_name="Yadadri Bhuvanagiri" if inlist(subdistrict_name, "atmakur m", "Addaguduru", "pochampalle", "ramannapeta", "valigonda")
replace district_name="Yadadri Bhuvanagiri" if inlist(subdistrict_name, "choutuppal", "narayanapur", "bibinagar")


//Wanaparthy --> 
tab subdistrict_name if district_name=="mahbubnagar"

*Revally -> golapet
tab place_name if subdistrict_name=="gopalpeta"
replace subdistrict_name="Revally" if inlist(place_name, "Yedula", "Bandaraipakula", "Chennaram", "Kesampeta", "Shanaipalle", "Thalpunur")
replace subdistrict_name="Revally" if inlist(place_name, "Cheerkapalle", "Nagapur", "Revally", "Vallabhanpalle", "Konkalapalle")

*Chinnambavi -> veepangandla 
tab place_name if subdistrict_name=="veepangandla"
replace subdistrict_name="Chinnambavi" if inlist(place_name, "Dagada", "Peddamarur", "Chinnamarur", "Vellatur", "chellepahad", "Ayyavaripalle")
replace subdistrict_name="Chinnambavi" if inlist(place_name, "Kalloor", "Lakshmipalle", "Solipuram", "Ammaipalle", "Dagadapalle", "Velgonda")
replace subdistrict_name="Chinnambavi" if inlist(place_name, "Miyapuram", "Bekkam", "Gaddabaswapuram")

*Srirangapur -> pebbair
tab place_name if subdistrict_name=="pebbair"
replace subdistrict_name="Srirangapur" if inlist(place_name, "Srirangapur", "Thatipamula", "Nagarala", "Kamballapur", "Venkatapur (S)")
replace subdistrict_name="Srirangapur" if inlist(place_name, "Nagasanipalle", "Janampeta")

*Madanapur -> kothakota &  atmakur
tab place_name if inlist(subdistrict_name, "kothakota", "atmakur")
replace subdistrict_name="Madanapur" if inlist(place_name, "Madanapur", "Govindahalli", "Dantanoor", "Shankarampeta", "Thirumalaipalle")
replace subdistrict_name="Madanapur" if inlist(place_name, "Ramanpadu", "Ajjakollu", "Narsingapur", "Konnur", "Dwarakanagar")
replace subdistrict_name="Madanapur" if inlist(place_name, "Nelividi", "Gopanpeta", "Karvena")

*Amarachintha -> atmakur & narwa
tab place_name if inlist(subdistrict_name, "atmakur", "narwa")
replace subdistrict_name="Amarachintha" if inlist(place_name, "Amarchinta", "Mastipur", "Pamireddipalle", "Kankanvanipalle", "Singampeta", "Nandimalla")

replace district_name="Wanaparthy" if inlist(subdistrict_name, "wanaparthy", "gopalpeta", "Revally", "peddamandadi", "ghanpur", "pangal", "pebbair")
replace district_name="Wanaparthy" if inlist(subdistrict_name, "Srirangapur", "veepangandla", "Chinnambavi", "kothakota", "Madanapur", "atmakur", "Amarachintha")

//east and eastdistrict are same
replace district_name="east district" if district_name=="east" & state_name=="sikkim"
replace district_name="ribhoi" if district_name=="ri bhoi"
replace district_name="south district" if district_name=="south"

//warangal urban
//Now rest of the villages in warangal is warangal rural
replace district_name="Warangal Rural" if district_name=="warangal"
//https://www.districtsinfo.com/2017/02/warangal-urban-district-revenue-divisions-mandals.html#:~:text=Warangal%20%28Urban%29%20District%20List%20of%20new%20Revenue%20Divisions%2C,of%20Warangal%20and%20is%20sub-divided%20into%2011%20mandals.
tab subdistrict_name if district_name=="Warangal Rural"
tab subdistrict_name if district_name=="karimnagar"


//Khila Warangal -> 
tab place_name if inlist(subdistrict_name, "hanamkonda", "geesugonda", "warangal", "sangam")
replace subdistrict_name="Khila Warangal" if inlist(place_name, "warangal part", "urus", "rangasaipet", "Allipur", "Thimmapur", "Mamnoor")
replace subdistrict_name="Khila Warangal" if inlist(place_name, "Nakkalapalli", "Vasanthapur", "stambampalle", "Bollikunta", "Gadepalle")

//"Khazipet"
tab place_name if inlist(subdistrict_name, "hanamkonda")
replace subdistrict_name="Khazipet" if inlist(place_name, "khazipet j", "Somidi", "Madikonda", "Tharalapalle", "Kadipikonda", "Kothapalle (H)")

//Inavole
tab place_name if inlist(subdistrict_name, "wardhannapet", "zaffergadh", "hanamkonda")
replace subdistrict_name="Inavole" if inlist(place_name, "Inole", "Singaram", "Punnole", "Nandanam", "Kakkiralapalle", "Panthini")
replace subdistrict_name="Inavole" if inlist(place_name, "Kondaparthy", "Vanamalakanaparthi", "Venkatapuram", "Garmillapalle")

//"Velair"
tab place_name if inlist(subdistrict_name, "dharmasagar")
replace subdistrict_name="Velair" if inlist(place_name, "Velair", "Peechera", "Sodeshapalle", "Mallikudurla")

//warangal urban
replace district_name="Warangal Urban" if inlist(subdistrict_name, "warangal", "Khila Warangal", "hanamkonda", "Khazipet", "dharmasagar", "Velair")
replace district_name="Warangal Urban" if inlist(subdistrict_name, "Inavole", "hasanparthy", "elkathurthi", "bheemadevarpalle", "kamalapur")

//Now rest of the villages in warangal is warangal rural
replace district_name="Warangal Rural" if district_name=="warangal"

save "shrug_reorganized.dta", replace

*=================== Merging the reorganised data with the SHRUG data ========================================

clear all
cd "$datasets\SHRUG"
use "shrug_reorganized.dta", clear

//Aurangabad
replace district_name="AurangabadBH" if district_name=="aurangabad" & state_name=="bihar"
replace district_name="AurangabadMH" if district_name=="aurangabad" & state_name=="maharashtra"

//Balrampur
replace district_name="BalrampurUP" if district_name=="balrampur" & state_name=="uttar pradesh"
replace district_name="BalrampurCh" if district_name=="Balrampur" & state_name=="chhattisgarh"
//Bijapur
replace district_name="Vijayapura" if district_name=="bijapur" & state_name=="karnataka"


//Bilaspur
drop if district_name=="bilaspur" & state_name=="madhya pradesh"
replace district_name="BilaspurCH" if district_name=="bilaspur" & state_name=="chhattisgarh"
replace district_name="BilaspurHP" if district_name=="bilaspur" & state_name=="himachal pradesh"

//Hamirpur
replace district_name="HamirpurHP" if district_name=="hamirpur" & state_name=="himachal pradesh"
replace district_name="HamirpurUP" if district_name=="hamirpur" & state_name=="uttar pradesh"

//pratapgarh
replace district_name="PratapgarhUP" if district_name=="pratapgarh" & state_name=="uttar pradesh"
replace district_name="PratapgarhRJ" if district_name=="pratapgarh" & state_name=="rajasthan"

*Merging this data with POPULATION CENSUS 2011 data
merge 1:1 shrid using "shrug_pc11.dta"

*Droping the not required variables
/*We need : Total Population, Rural Population, Urban Population, Schedule Caste Population,
Schedule Tribe Population, Literate Population, Number of Household, Number of village primary schools
Number of town primary schools, Indicator for paved road (1=Yes), Indicator for power for all uses (1=Yes)
Daily hours of power for [type] use in summer, Daily hours of power for [type] use in winter*/

drop pc11_vd_m_sch pc11_vd_s_sch pc11_vd_s_s_sch pc11_vd_college ///
pc11_vd_power_dom_sum pc11_vd_power_dom_win pc11_vd_power_agr_sum pc11_td_area ///
pc11_vd_power_agr_win pc11_vd_power_com_sum pc11_vd_power_com_win pc11_vd_power_dom pc11_vd_power_agr ///
pc11_td_m_sch pc11_td_s_sch pc11_td_college pc11_td_s_s_sch _merge pc11_vd_tar_road pc11_vd_power_all

*Now merge the ancillary data set
/* This dataset contains: Rural per-capita imputed consumption using full IHDS sample,
Share of households whose main source of income is cultivation  */ 
merge 1:1 shrid using "shrug_ancillary.dta"

drop tdist_10 tdist_50 tdist_100 tdist_500 thiessen_polygon road_award_date_new road_award_date_upg ///
road_comp_date_new road_comp_date_upg road_comp_date_stip_new road_comp_date_stip_upg road_sanc_year_upg ///
road_sanc_year_new road_length_new road_length_upg road_cost_new road_cost_upg ///
road_cost_sanc_new road_cost_sanc_upg road_cost_state_new road_cost_state_upg _merge

*now merge economic census data
/* This data contains total non-farm employment in 2013 */
merge 1:1 shrid using "shrug_ec.dta"
drop _merge ec05_emp_all ec98_emp_all ec90_emp_all

*Aggregate at district level
collapse(sum) pc11_pca_tot_p pc11_pca_tot_p_r pc11_pca_tot_p_u pc11_pca_no_hh pc11_pca_p_sc pc11_pca_p_st ///
pc11_pca_p_lit pc11_vd_p_sch pc11_vd_power_all_sum pc11_vd_power_all_win ///
pc11_td_p_sch secc_rural_cons_pc secc_inc_cultiv_share ec13_emp_all, by( district_name)


*---Label Variables
label var district_name "Population Census 2011 district name"
label var pc11_vd_p_sch "Number of village primary schools"
label var pc11_td_p_sch "Number of town primary schools"
label var pc11_vd_power_all_win "Daily hours of power for all use in winter"
label var pc11_vd_power_all_sum "Daily hours of power for all use in summer"
label var secc_rural_cons_pc "Small-area estimate of per capita consumption"
label var secc_inc_cultiv_share "Share of households where cultivation is main income source"
label var ec13_emp_all "Non farm employment in 2013"

*----Renaming variables
rename district_name pc11_district_name 
rename pc11_pca_tot_p tot_population
rename pc11_pca_tot_p_r rural_population
rename pc11_pca_tot_p_u urban_population
rename pc11_pca_no_hh total_households
rename pc11_pca_p_sc schedule_caste_pop
rename pc11_pca_p_st schedule_tribe_pop
rename pc11_pca_p_lit literate_pop
rename pc11_vd_p_sch village_primary_schools
rename pc11_vd_power_all_sum power_use_summer
rename pc11_vd_power_all_win power_use_winter
rename pc11_td_p_sch town_primary_school
rename secc_rural_cons_pc percapita_consumption
rename secc_inc_cultiv_share cultivationHH_share
rename ec13_emp_all nonfarm_employment_2013


*destring district_id, gen(SHRUG_id) //Converting string into numeric
*drop district_id 
order pc11_district_name


*Population in thousands
gen tot_population_in_thousands = tot_population/1000
gen ruralpop_in_thousand= rural_population/1000
gen urbanpop_in_thousand= urban_population/1000
gen households_in_thousand=total_households/1000
gen schedulecaste_pop_thousands=schedule_caste_pop/1000
gen scheduletribe_pop_inthousand=schedule_tribe_pop/1000
gen literatepop_inthousand= literate_pop/1000
gen nonfarm_employment2013_thousands =nonfarm_employment_2013/1000

*Dropping the variables
drop tot_population rural_population urban_population total_households schedule_caste_pop schedule_tribe_pop literate_pop

*------------Lable the variables
label var tot_population_in_thousands "Total population ('000s)"
label var ruralpop_in_thousand "Rural population ('000s)"
label var urbanpop_in_thousand "Urban population ('000s)"
label var households_in_thousand "Number of households ('000s)"
label var schedulecaste_pop_thousands "Schedule Caste population ('000s)"
label var scheduletribe_pop_inthousand "Schedule Tribe population ('000s)"
label var literatepop_inthousand "Literate population ('000s)"
label var nonfarm_employment2013_thousands "Non farm employment ('000s) in 2013"


*Ordering the variables
order pc11_district_name tot_population_in_thousands ruralpop_in_thousand urbanpop_in_thousand ///
households_in_thousand schedulecaste_pop_thousands scheduletribe_pop_inthousand literatepop_inthousand

save "shrug1.dta", replace

**************************************************************************************


clear all
cd "$datasets\SHRUG" //cd "C:\Users\rosha\Desktop\IIMA\SHRUG"

* loading the population census district key to match with the other datasets
* This data contains state id, state name, district id, district code, and the shrug ids of the places in particular district
use "shrug_reorganized.dta", clear

//Aurangabad
replace district_name="AurangabadBH" if district_name=="aurangabad" & state_name=="bihar"
replace district_name="AurangabadMH" if district_name=="aurangabad" & state_name=="maharashtra"

//Balrampur
replace district_name="BalrampurUP" if district_name=="balrampur" & state_name=="uttar pradesh"
replace district_name="BalrampurCh" if district_name=="Balrampur" & state_name=="chhattisgarh"
//Bijapur
replace district_name="Vijayapura" if district_name=="bijapur" & state_name=="karnataka"

//Bilaspur
drop if district_name=="bilaspur" & state_name=="madhya pradesh"
replace district_name="BilaspurCH" if district_name=="bilaspur" & state_name=="chhattisgarh"
replace district_name="BilaspurHP" if district_name=="bilaspur" & state_name=="himachal pradesh"

//Hamirpur
replace district_name="HamirpurHP" if district_name=="hamirpur" & state_name=="himachal pradesh"
replace district_name="HamirpurUP" if district_name=="hamirpur" & state_name=="uttar pradesh"

//pratapgarh
replace district_name="PratapgarhUP" if district_name=="pratapgarh" & state_name=="uttar pradesh"
replace district_name="PratapgarhRJ" if district_name=="pratapgarh" & state_name=="rajasthan"

*Merging this data with POPULATION CENSUS 2011 data
merge 1:1 shrid using "shrug_pc11.dta"

* Keep only Indicator for paved road (1=Yes), Indicator for power for all uses (1=Yes)
keep pc11_vd_tar_road pc11_vd_power_all district_name

*renaming the variable
rename pc11_vd_tar_road tar_road
rename pc11_vd_power_all allpower_use


*Aggregate at district level
collapse tar_road allpower_use, by( district_name)

*Labeling the variables
label var tar_road "Black topped road (share of villages in a district)"
label var allpower_use "Indicator for power for all uses"

rename district_name pc11_district_name 
*save the data
save "shrug2.dta", replace

*******************************************************
//Now, merge above two datasets
clear all
cd "$datasets\SHRUG"

use shrug1.dta, clear
merge m:m  pc11_district_name using "shrug2.dta"
drop _merge
drop if pc11_district_name==""
save "district_shrug.dta", replace

************************************************************************************

clear all
cd "$datasets\SHRUG"

use "shrug_pc11_district_key.dta", clear

//want distinct district_shrug_ids
drop shrid
duplicates drop pc11_state_id pc11_state_name pc11_district_id pc11_district_name, force
drop if pc11_district_name==""

//Aurangabad
replace pc11_district_name="AurangabadBH" if pc11_district_name=="aurangabad" & pc11_state_name=="bihar"
replace pc11_district_name="AurangabadMH" if pc11_district_name=="aurangabad" & pc11_state_name=="maharashtra"

//Balrampur
replace pc11_district_name="BalrampurUP" if pc11_district_name=="balrampur" & pc11_state_name=="uttar pradesh"
replace pc11_district_name="BalrampurCh" if pc11_district_name=="Balrampur" & pc11_state_name=="chhattisgarh"
//Bijapur
replace pc11_district_name="Vijayapura" if pc11_district_name=="bijapur" & pc11_state_name=="karnataka"

//Bilaspur
drop if pc11_district_name=="bilaspur" & pc11_state_name=="madhya pradesh"
replace pc11_district_name="BilaspurCH" if pc11_district_name=="bilaspur" & pc11_state_name=="chhattisgarh"
replace pc11_district_name="BilaspurHP" if pc11_district_name=="bilaspur" & pc11_state_name=="himachal pradesh"

//Hamirpur
replace pc11_district_name="HamirpurHP" if pc11_district_name=="hamirpur" & pc11_state_name=="himachal pradesh"
replace pc11_district_name="HamirpurUP" if pc11_district_name=="hamirpur" & pc11_state_name=="uttar pradesh"

//pratapgarh
replace pc11_district_name="PratapgarhUP" if pc11_district_name=="pratapgarh" & pc11_state_name=="uttar pradesh"
replace pc11_district_name="PratapgarhRJ" if pc11_district_name=="pratapgarh" & pc11_state_name=="rajasthan"

//merge this with shrug level district data
merge m:m pc11_district_name using "$datasets\SHRUG\district_shrug.dta"

drop if _merge==1

destring( pc11_district_id), replace

//Now create one unique district id
gen dist_code=pc11_district_id //dist_code in the data is same as district code in the 

// Now give the id's for the districts where id's are missing
//Note that this dist_code is same as night light data.
replace dist_code=572  if pc11_district_name=="bangalore"
replace dist_code=182  if pc11_district_name=="BalrampurUP"
replace dist_code=557  if  pc11_district_name=="Vijayapura"
replace dist_code=714  if  pc11_district_name=="East Jaintia Hills"
replace dist_code=724  if  pc11_district_name=="Agar Malwa"
replace dist_code=774  if  pc11_district_name=="Alipurduar"
replace dist_code=706  if  pc11_district_name=="Amethi"
replace dist_code=725  if  pc11_district_name=="Aravalli"
replace dist_code=719  if  pc11_district_name=="Balod"
replace dist_code=721  if  pc11_district_name=="Baloda Bazar"
replace dist_code=716 if  pc11_district_name=="BalrampurCh"
replace dist_code=749  if  pc11_district_name=="Warangal Rural"
replace dist_code=718  if  pc11_district_name=="Bametara"
replace dist_code=753  if  pc11_district_name=="Bhadradri Kothagudem"
replace dist_code=756  if  pc11_district_name=="Biswanath"
replace dist_code=726  if  pc11_district_name=="Botad"
replace dist_code=755  if  pc11_district_name=="Charaideo"
replace dist_code=765  if  pc11_district_name=="Charkhi Dadri"
replace dist_code=804  if  pc11_district_name=="Chengalpattu"
replace dist_code=731  if  pc11_district_name=="Chhota Udaipur"
replace dist_code=728  if  pc11_district_name=="Devbhumi Dwarka"
replace dist_code=701  if  pc11_district_name=="Fazilka"
replace dist_code=720 if  pc11_district_name=="Gariaband"
replace dist_code=7291  if  pc11_district_name=="Gir Somnath"
replace dist_code=709  if  pc11_district_name=="Gomati"
replace dist_code=705  if  pc11_district_name=="Hapur"
replace dist_code=10002  if  pc11_district_name=="Hnahthial"
replace dist_code=757  if  pc11_district_name=="Hojai"
replace dist_code=536  if  pc11_district_name=="Hyderabad"
replace dist_code=737  if  pc11_district_name=="Jagtial"
replace dist_code=752  if  pc11_district_name=="Jangaon"
replace dist_code=750  if  pc11_district_name=="Jayashankar Bhupalapally"
replace dist_code=776  if  pc11_district_name=="Jhargram"
replace dist_code=766  if  pc11_district_name=="Jiribam"
replace dist_code=744  if  pc11_district_name=="Jogulamba Gadwal"
replace dist_code=768  if  pc11_district_name=="Kakching"
replace dist_code=775  if  pc11_district_name=="Kalimpong"
replace dist_code=729  if  pc11_district_name=="Kallakurichi"
replace dist_code=736  if  pc11_district_name=="Kamareddy"
replace dist_code=770  if  pc11_district_name=="Kamjong"
replace dist_code=778  if  pc11_district_name=="Kamle"
replace dist_code=767  if  pc11_district_name=="Kangpokpi"
replace dist_code=10003  if  pc11_district_name=="Khawzawl"
replace dist_code=708  if  pc11_district_name=="Khowai"
replace dist_code=733  if  pc11_district_name=="Komaram Bheem"
replace dist_code=722  if  pc11_district_name=="Kondagaon"
replace dist_code=763  if  pc11_district_name=="Kradaadi"
replace dist_code=784  if  pc11_district_name=="Leparada"
replace dist_code=761  if  pc11_district_name=="Longding"
replace dist_code=779  if  pc11_district_name=="Lower Siang"
replace dist_code=751  if  pc11_district_name=="Mahabubabad"
replace dist_code=730  if  pc11_district_name=="Mahisagar"
replace dist_code=760  if  pc11_district_name=="Majuli"
replace dist_code=735  if  pc11_district_name=="Mancherial"
replace dist_code=535  if  pc11_district_name=="Medak"
replace dist_code=742  if  pc11_district_name=="Medchal Malkajgiri"
replace dist_code=727  if  pc11_district_name=="Morbi"
replace dist_code=780  if  pc11_district_name=="Mulugu"
replace dist_code=519  if  pc11_district_name=="Mumbai"
replace dist_code=518  if  pc11_district_name=="Mumbai Suburban"
replace dist_code=717  if  pc11_district_name=="Mungeli"
replace dist_code=746  if  pc11_district_name=="Nagarkurnool"
replace dist_code=762  if  pc11_district_name=="Namsai"
replace dist_code=781  if  pc11_district_name=="Narayanpet"
replace dist_code=734  if  pc11_district_name=="Nirmal"
replace dist_code=782  if  pc11_district_name=="Niwari"
replace dist_code=771  if  pc11_district_name=="Noney"
replace dist_code=712  if  pc11_district_name=="North Garo Hills"
replace dist_code=783  if  pc11_district_name=="Pakke Kessang"
replace dist_code=732  if  pc11_district_name=="Palghar"
replace dist_code=777  if  pc11_district_name=="Paschim Bardhaman"
replace dist_code=773  if  pc11_district_name=="Pathankot"
replace dist_code=738  if  pc11_district_name=="Peddapalli"
replace dist_code=772  if  pc11_district_name=="Pherzawl"
replace dist_code=335  if  pc11_district_name=="Purba Bardhaman"
replace dist_code=739  if  pc11_district_name=="Rajanna Sircilla"
replace dist_code=537  if  pc11_district_name=="Ranga Reddy"
replace dist_code=805  if  pc11_district_name=="Ranipet"
replace dist_code=10001  if  pc11_district_name=="Saitual"
replace dist_code=754  if  pc11_district_name=="Sambhal"
replace dist_code=740  if  pc11_district_name=="Sangareddy"
replace dist_code=704  if  pc11_district_name=="Shamli"
replace dist_code=785  if  pc11_district_name=="Shi Yomi"
replace dist_code=764  if  pc11_district_name=="Siang"
replace dist_code=741  if  pc11_district_name=="Siddipet"
replace dist_code=707  if  pc11_district_name=="Sipahijala"
replace dist_code=758  if  pc11_district_name=="South Salmara Mankachar"
replace dist_code=711  if  pc11_district_name=="South West Garo Hills"
replace dist_code=713  if  pc11_district_name=="South West Khasi Hills"
replace dist_code=723  if  pc11_district_name=="Sukma"
replace dist_code=715  if  pc11_district_name=="Surajpur"
replace dist_code=748  if  pc11_district_name=="Suryapet"
replace dist_code=769  if  pc11_district_name=="Tengnoupal"
replace dist_code=806  if  pc11_district_name=="Tenkasi"
replace dist_code=0  if  pc11_district_name=="Tirupathur"
replace dist_code=710 if  pc11_district_name=="Unokoti"
replace dist_code=743  if  pc11_district_name=="Vikarabad"
replace dist_code=745  if  pc11_district_name=="Wanaparthy"
replace dist_code=759  if  pc11_district_name=="West Karbi Anglong"
replace dist_code=747  if  pc11_district_name=="Yadadri Bhuvanagiri"
replace dist_code=474  if  pc11_district_name=="ahmadabad"
replace dist_code=176  if  pc11_district_name=="barabanki"
replace dist_code=496  if  pc11_district_name=="dadra and nagar haveli"
replace dist_code=416  if  pc11_district_name=="dantewada"
replace dist_code=575  if  pc11_district_name=="dakshin kannad"
replace dist_code=106  if  pc11_district_name=="dholpur"
replace dist_code=360  if  pc11_district_name=="hazaribag"
replace dist_code=304  if  pc11_district_name=="marigaon"
replace dist_code=550  if  pc11_district_name=="nellore"
replace dist_code=661  if  pc11_district_name=="nilgiri"
replace dist_code=90  if  pc11_district_name=="north west"
replace dist_code=492  if  pc11_district_name=="surat"
replace dist_code=614  if  pc11_district_name=="tiruchchirappalli"
replace dist_code=628  if  pc11_district_name=="tirunelveli kattabomman"
replace dist_code=606  if  pc11_district_name=="tiruvannamalai sambuvarayar"
replace dist_code=563  if  pc11_district_name=="uttar kannad"
replace dist_code=540  if  pc11_district_name=="Warangal Urban"
replace dist_code=260 if  pc11_district_name=="anjaw"

drop if inlist(pc11_district_name, "andamans", "chengai anna", "chhimtuipui")
drop if inlist(pc11_district_name, "chidambaranar", "cuddapah", "dindigul quaid e milleth", "imphal")
drop if inlist(pc11_district_name, "kamarajar", "kanker", "medinipur", "north arcot ambedker")
drop if inlist(pc11_district_name, "north cachar hills", "pasumpon thevar thirumagan", "periyar")
drop if inlist(pc11_district_name, "phulabani", "sibsagar", "south arcot", "pondicherry district", "trivandrum")

drop _merge

save "districtshrug.dta", replace 

***********************************************************************************************










/*=============================================================================
					NIGHT-LIGHT DATA
===============================================================================*/

clear all
use "$datasets\Night Light Data\VIIRS_lights_monthly_2012_2020_DistrictLevel_up_aug_2020_newSHP_Updated.dta", clear
rename dist_name district

drop if inlist(district, "Mirpur", "Muzaffarabad")

//Matching the name of the district
replace district="Almora" if dist_code=="064"
replace district="Ahmedabad" if district=="Ahmadabad"
replace district="Ahmednagar" if district=="Ahmadnagar"
replace district="Angul" if district=="Anugul"
replace district="AurangabadBH" if district=="Aurangabad" & State_name=="BIHAR"
replace district="AurangabadMH" if district=="Aurangabad" & State_name=="MAHARASHTRA"
replace district="Ayodhya" if district=="Faizabad"
replace district="Budgam" if district=="Badgam"
replace district="Balasore" if district=="Baleshwar"
replace district="BalrampurCh" if district=="Balrampur" & State_name=="CHHATTISGARH"
replace district="BalrampurUP" if district=="Balrampur" & State_name=="UTTAR PRADESH"
replace district="Banaskantha" if district=="Banas Kantha"
replace district="Bandipora" if district=="Bandipore"
replace district="Bengaluru Urban" if district=="Bangalore"
replace district="Barabanki" if district=="Bara Banki"
replace district="Baramulla" if district=="Baramula"
replace district="Boudh" if district=="Baudh"
replace district="Beed" if district=="Bid"
replace district="BilaspurCH" if district=="Bilaspur" & State_name=="CHHATTISGARH"
replace district="BilaspurHP" if district=="Bilaspur" & State_name=="HIMACHAL PRADESH"
replace district="Buldhana" if district=="Buldana"
replace district="Central Delhi" if district=="Central"
replace district="Chhota Udaipur" if district=="Chota Udaipur"
replace district="Chittorgarh" if district=="Chittaurgarh"
replace district="Dadra and Nagar Haveli" if district=="Dadra & Nagar Haveli"
replace district="Darjeeling" if district=="Darjiling"
replace district="Deogarh" if district=="Debagarh"
replace district="Dholpur" if district=="Dhaulpur"
replace district="East Delhi" if district=="East"
replace district="East Sikkim" if district=="East District"
replace district="Khandwa" if district=="East Nimar"
replace district="Ferozepur" if district=="Firozpur"
replace district="Gondia" if district=="Gondiya"
replace district="HamirpurHP" if district=="Hamirpur" & State_name=="HIMACHAL PRADESH"
replace district="HamirpurUP" if district=="Hamirpur" & State_name=="UTTAR PRADESH"
replace district="Haridwar" if district=="Hardwar"
replace district="Jagatsinghpur" if district=="Jagatsinghapur"
replace district="Jagtial" if district=="Jagitial"
replace district="Jajpur" if district=="Jajapur"
replace district="Jalore" if district=="Jalor"
replace district="Janjgir Champa" if district=="Janjgir - Champa"
replace district="Jayashankar Bhupalapally" if district=="Jayashankar"
replace district="Jhunjhunu" if district=="Jhunjhunun"
replace district="Kutch" if district=="Kachchh"
replace district="Kaimur" if district=="Kaimur (bhabua)"
replace district="Kanyakumari" if district=="Kanniyakumari"
replace district="Lakhimpur Kheri" if district=="Kheri"
replace district="Koderma" if district=="Kodarma"
replace district="Kradaadi" if district=="Kra Daadi"
replace district="Komaram Bheem" if district=="Kumuram Bheem Asifabad"
replace district="Lahaul And Spiti" if district=="Lahul & Spiti"
replace district="Mehsana" if district=="Mahesana"
replace district="Malda" if district=="Maldah"
replace district="Paschim Medinipur" if district=="Medinipur West"
replace district="Narsinghpur" if district=="Narsimhapur"
replace district="North Delhi" if district=="North"
replace district="North and Middle Andaman" if district=="North  & Middle Andaman"
replace district="North Sikkim" if district=="North  District"
replace district="North East Delhi" if district=="North East"
replace district="North 24 Parganas" if district=="North Twenty Four Pargan*"
replace district="North West Delhi" if district=="North West"
replace district="Panchmahal" if district=="Panch Mahals"
replace district="West Champaran" if district=="Pashchim Champaran"
replace district="West Singhbhum" if district=="Pashchimi Singhbhum"
replace district="PratapgarhRJ" if district=="Pratapgarh" & State_name=="RAJASTHAN"
replace district="PratapgarhUP" if district=="Pratapgarh" & State_name=="UTTAR PRADESH"
replace district="East Champaran" if district=="Purba Champaran"
replace district="East Singhbhum" if district=="Purbi Singhbhum"
replace district="Purulia" if district=="Puruliya"
replace district="S.A.S. Nagar" if district=="Sahibzada Ajit Singh Nag*"
replace district="Saraikela-Kharsawan" if district=="Saraikela-kharsawan"
replace district="Shopiyan" if district=="Shupiyan"
replace district="Saiha" if district=="Siaha"
replace district="South Delhi" if district=="South"
replace district="South Sikkim" if district=="South District"
replace district="South East Delhi" if district=="South East"
replace district="South Salmara Mankachar" if district=="South Salmara Mancachar"
replace district="South 24 Parganas" if district=="South Twenty Four Pargan*"
replace district="South West Delhi" if district=="South West"
replace district="S.P.S. Nellore" if district=="Sri Potti Sriramulu Nell*"
replace district="Dang" if district=="The Dangs"
replace district="Nilgiris" if district=="The Nilgiris"
replace district="West Delhi" if district=="West"
replace district="West Sikkim" if district=="West District"
replace district="Khargone" if district=="West Nimar"
replace district="Y.S.R. Kadapa" if district=="Y.S.R."
replace district="Charkhi Dadri" if district=="Charki Dadri"
replace district="Almora" if district=="Almora"
replace district="Dahod" if district=="Dohad"
replace district="Dibang Valley" if district=="Upper Dibang Valley"
replace district="Jangaon" if district=="Jangoan"
replace district="Maharajganj" if district=="Mahrajganj"
replace district="Pauri Garhwal" if district=="Garhwal"
replace district="Sabarkantha" if district=="Sabar Kantha"
replace district="Raigad" if district=="Raigarh" & State_name=="MAHARASHTRA"

destring(dist_code), replace  //Change string variablr into int

*Dist_code should be changed for these 
replace dist_code=804  if  district=="Chengalpattu"
replace dist_code=805  if district=="Ranipet"
replace dist_code=806  if  district=="Tenkasi"
replace dist_code=7291  if  district=="Gir Somnath"

save "$datasets\Night Light Data\VIIRS_NightLight.dta", replace


*---------(a) Night-light wide data- where pre2019-dec will be as a separate variables
*Following codes are for reshaping the night light data
clear all
cd "$datasets\Night Light Data"
use "VIIRS_NightLight.dta", replace   //Night lights data from 2012 to 2020

//we want post 2019Dec as a separate variable and feb-July in the merged data


*-----Generating month variable
gen montH=""
replace montH="Jan" if month==1
replace montH="Feb" if month==2
replace montH="Mar" if month==3
replace montH="Apr" if month==4
replace montH="May" if month==5
replace montH="June" if month==6
replace montH="July" if month==7
replace montH="Aug" if month==8
replace montH="Sep" if month==9
replace montH="Oct" if month==10
replace montH="Nov" if month==11
replace montH="Dec" if month==12

*------Creating month year variable
 egen year_month=concat( year montH) 

drop iso_codes State_code State_name dist_code satellite year month montH

//Reshaping the data
reshape wide ntl_s_n_cl ntl_s_n_cl_a, i( district id_dist) j( year_month) string

save "NightLight_wide.dta", replace

 

 
 
 
 
 
 
            
/*==============================================================================
				CENSUS 2011 AGE Data
				https://censusindia.gov.in/2011census/C-series/C-13.html
===============================================================================*/

/*
Notes: This dataset contains data Total population, Total male population, Total female population,
Total rural population, Total rural male population, Total rural female population, 
Total urban population, Total urban male population, Total urban female population.

Here, I am calculating mean, median, 25th percentile, and 75th percentile
*/
 
clear all

//Change the directory for the folder having all csv file. The below loop 
//change all csv file into dta file and then we can append it easily.
cd "$datasets\Census 2011"

local myfilelist : dir . files"*.csv"
foreach file of local myfilelist {
drop _all
insheet using `file'
local outfile = subinstr("`file'",".csv","",.)
save "`outfile'", replace
}



***********  Appending datasets ******************

append using "andamannicobar.dta" "andhrapradesh.dta" "arunachalpradesh.dta" "assam.dta" "bihar.dta" ///
"chandigarh.dta" "chhattisgarh.dta" "dadranagarhaveli.dta" "daman&diu.dta" "goa.dta" "gujarat.dta" ///
"haryana.dta" "himachalpradesh.dta" "jammuandkashmir.dta" "jharakhand.dta" "karnataka.dta" "kerala.dta" /// 
"lakshwadeep.dta" "madhyapradesh.dta" "maharashtra.dta" "manipur.dta" "meghalaya.dta" "mizoram.dta" ///
"nagaland.dta" "nctofdelhi.dta" "odisha.dta" "pudduchery.dta" "punjab.dta" "rajashthan.dta" "sikkim.dta" "tamilnadu.dta" ///
"tripura.dta" "uttarakhand.dta" "uttarpradesh.dta" "westbengal.dta"


drop if inlist(age, "100+", "Age not stated", "All ages")

destring( distt_code), replace
destring(age), replace
destring( state_code), replace

drop if distt_code==0

rename distt_code Distt_code

/*At the same time
mean Age [fweight = Total_persons], over(State_code Distt_code) */

*For individual group
*mean Age [fweight = Total_persons] if State_code==35 & Distt_code==638

*==== TOTAL POPULATION===*
gen wtmedian=.
gen percentile25=.
gen percentile75=.
gen wtmean=.

*=====NOTE: Run the following command at once; otherwise it will give a error

levelsof Distt_code, local(levels) 
qui foreach l of local levels{ 
 
   summarize age [fweight = total_persons] if Distt_code == `l', detail 
   replace wtmedian = r(p50) if Distt_code == `l' 
   replace percentile25 = r(p25) if Distt_code == `l'
   replace percentile75 = r(p75) if Distt_code == `l'
   replace wtmean = r(mean) if Distt_code == `l' 
}

*===== TOTAL MALE POPULATION ====*
gen male_wtmedian=.
gen male_percentile25=.
gen male_percentile75=.
gen male_wtmean=.

levelsof Distt_code, local(levels) 
qui foreach l of local levels{ 
 
   summarize age [fweight = total_males] if Distt_code == `l', detail 
   replace male_wtmedian = r(p50) if Distt_code == `l' 
   replace male_percentile25 = r(p25) if Distt_code == `l'
   replace male_percentile75 = r(p75) if Distt_code == `l'
   replace male_wtmean= r(mean) if Distt_code == `l' 
}

*===== TOTAL FEMALE POPULATION ====*
gen female_wtmedian=.
gen female_percentile25=.
gen female_percentile75=.
gen female_wtmean=.

levelsof Distt_code, local(levels) 
qui foreach l of local levels{ 
 
   summarize age [fweight = total_females] if Distt_code == `l', detail 
   replace female_wtmedian = r(p50) if Distt_code == `l' 
   replace female_percentile25 = r(p25) if Distt_code == `l'
   replace female_percentile75 = r(p75) if Distt_code == `l'
   replace female_wtmean= r(mean) if Distt_code == `l' 
}

************************************************************************************
******************||  RURAL POPULATION     ||**************************************

*==== TOTAL RURAL POPULATION===*
gen rural_wtmedian=.
gen rural_percentile25=.
gen rural_percentile75=.
gen rural_wtmean=.

*=====NOTE: Run the following command at once; otherwise it will give a error

levelsof Distt_code, local(levels) 
qui foreach l of local levels{ 
 
   summarize age [fweight = rural_persons] if Distt_code == `l', detail 
   replace rural_wtmedian = r(p50) if Distt_code == `l' 
   replace rural_percentile25 = r(p25) if Distt_code == `l'
   replace rural_percentile75 = r(p75) if Distt_code == `l'
   replace rural_wtmean = r(mean) if Distt_code == `l' 
}

*===== TOTAL RURAL MALE POPULATION ====*
gen rural_male_wtmedian=.
gen rural_male_percentile25=.
gen rural_male_percentile75=.
gen rural_male_wtmean=.

levelsof Distt_code, local(levels) 
qui foreach l of local levels{ 
 
   summarize age [fweight = rural_males] if Distt_code == `l', detail 
   replace rural_male_wtmedian = r(p50) if Distt_code == `l' 
   replace rural_male_percentile25 = r(p25) if Distt_code == `l'
   replace rural_male_percentile75 = r(p75) if Distt_code == `l'
   replace rural_male_wtmean= r(mean) if Distt_code == `l' 
}

*===== TOTAL RURAL FEMALE POPULATION ====*
gen rural_female_wtmedian=.
gen rural_female_percentile25=.
gen rural_female_percentile75=.
gen rural_female_wtmean=.

levelsof Distt_code, local(levels) 
qui foreach l of local levels{ 
 
   summarize age [fweight = rural_females] if Distt_code == `l', detail 
   replace rural_female_wtmedian = r(p50) if Distt_code == `l' 
   replace rural_female_percentile25 = r(p25) if Distt_code == `l'
   replace rural_female_percentile75 = r(p75) if Distt_code == `l'
   replace rural_female_wtmean= r(mean) if Distt_code == `l' 
}

************************************************************************************
******************||  URBAN POPULATION     ||**************************************

*==== TOTAL URBAN POPULATION===*
gen urban_wtmedian=.
gen urban_percentile25=.
gen urban_percentile75=.
gen urban_wtmean=.

*=====NOTE: Run the following command at once; otherwise it will give a error

levelsof Distt_code, local(levels) 
qui foreach l of local levels{ 
 
   summarize age [fweight = urban_persons] if Distt_code == `l', detail 
   replace urban_wtmedian = r(p50) if Distt_code == `l' 
   replace urban_percentile25 = r(p25) if Distt_code == `l'
   replace urban_percentile75 = r(p75) if Distt_code == `l'
   replace urban_wtmean = r(mean) if Distt_code == `l' 
}

*===== TOTAL URBAN MALE POPULATION ====*
gen urban_male_wtmedian=.
gen urban_male_percentile25=.
gen urban_male_percentile75=.
gen urban_male_wtmean=.

levelsof Distt_code, local(levels) 
qui foreach l of local levels{ 
 
   summarize age [fweight = urban_males] if Distt_code == `l', detail 
   replace urban_male_wtmedian = r(p50) if Distt_code == `l' 
   replace urban_male_percentile25 = r(p25) if Distt_code == `l'
   replace urban_male_percentile75 = r(p75) if Distt_code == `l'
   replace urban_male_wtmean= r(mean) if Distt_code == `l' 
}

*===== TOTAL URBAN FEMALE POPULATION ====*
gen urban_female_wtmedian=.
gen urban_female_percentile25=.
gen urban_female_percentile75=.
gen urban_female_wtmean=.

levelsof Distt_code, local(levels) 
qui foreach l of local levels{ 
 
   summarize age [fweight = urban_females] if Distt_code == `l', detail 
   replace urban_female_wtmedian = r(p50) if Distt_code == `l' 
   replace urban_female_percentile25 = r(p25) if Distt_code == `l'
   replace urban_female_percentile75 = r(p75) if Distt_code == `l'
   replace urban_female_wtmean= r(mean) if Distt_code == `l' 
}

drop v1 age total_persons total_males total_females rural_persons rural_males rural_females urban_persons urban_males urban_females


duplicates drop state_code Distt_code areaname wtmedian percentile25 percentile75 wtmean male_wtmedian ///
male_percentile25 male_percentile75 male_wtmean female_wtmedian female_percentile25 female_percentile75 female_wtmean ///
rural_wtmedian rural_percentile25 rural_percentile75 rural_wtmean rural_male_wtmedian rural_male_percentile25 ///
rural_male_percentile75 rural_male_wtmean rural_female_wtmedian rural_female_percentile25 ///
rural_female_percentile75 rural_female_wtmean urban_wtmedian urban_percentile25 urban_percentile75 urban_wtmean ///
urban_male_wtmedian urban_male_percentile25 urban_male_percentile75 urban_male_wtmean urban_female_wtmedian ///
urban_female_percentile25 urban_female_percentile75 urban_female_wtmean, force

*------Labels
label var wtmedian "Median of age of total population (years)"
label var percentile25 "25 percentile of age of total population (years)"
label var percentile75 "75 percentile of age of total population (years)"
label var wtmean "Average district age (years)"

label var male_wtmedian "Median of age of male population (years)"
label var male_percentile25 "25 percentile of age of male population (years)"
label var  male_percentile75 "75 percentile of age of male population (years)"
label var  male_wtmean "Mean of age of male population (years)"

label var female_wtmedian "Median of age of female population (years)"
label var female_percentile25 "25 percentile of age of female population (years)"
label var female_percentile75 "75 percentile of age of female population (years)"
label var female_wtmean "Mean of age of female population (years)"
***************************************************************************************
label var rural_wtmedian "Median of age of rural population (years)"
label var rural_percentile25 "25 percentile of age of rural population (years)"
label var rural_percentile75 "75 percentile of age of rural population (years)"
label var rural_wtmean "Mean of age of rural population (years)"

label var rural_male_wtmedian "Median of age of rural male population (years)"
label var rural_male_percentile25 "25 percentile of age of rural male population (years)"
label var  rural_male_percentile75 "75 percentile of age of rural male population (years)"
label var  rural_male_wtmean "Mean of age of rural male population (years)"

label var rural_female_wtmedian "Median of age of rural female population (years)"
label var rural_female_percentile25 "25 percentile of age of rural female population (years)"
label var rural_female_percentile75 "75 percentile of age of rural female population (years)"
label var rural_female_wtmean "Mean of age of rural female population (years)"
**********************************************************************************************
label var urban_wtmedian "Median of age of urban population (years)"
label var urban_percentile25 "25 percentile of age of urban population (years)"
label var urban_percentile75 "75 percentile of age of urban population (years)"
label var urban_wtmean "Mean of age of urban population (years)"

label var urban_male_wtmedian "Median of age of urban male population (years)"
label var urban_male_percentile25 "25 percentile of age of urban male population (years)"
label var  urban_male_percentile75 "75 percentile of age of urban male population (years)"
label var  urban_male_wtmean "Mean of age of urban male population (years)"

label var urban_female_wtmedian "Median of age of urban female population (years)"
label var urban_female_percentile25 "25 percentile of age of urban female population (years)"
label var urban_female_percentile75 "75 percentile of age of urban female population (years)"
label var urban_female_wtmean "Mean of age of urban female population (years)"
save "Census11Age.dta", replace










/*==============================================================================
				CENSUS 2011 Data(shared by Robert)
				  
				  
				  ******  Informality data ***********
===============================================================================*/

clear all
cd "$datasets\Informality"
use "India_Census_2011_select.dta", clear
*rename L2_name district

//I have to merge this data using district name. So, matching these names with main data.
replace district="Ahmedabad" if district=="Ahmadabad"
replace district="Ahmednagar" if district=="Ahmadnagar"
replace district="Prayagraj" if district=="Allahabad"
replace district="Amroha" if district=="Jyotiba Phule Nagar"
replace district="Angul" if district=="Anugul"
replace district="AurangabadBH" if district=="Aurangabad" & L1_name=="Bihar"
replace district="AurangabadMH" if district=="Aurangabad" & L1_name=="Maharashtra"
replace district="Ayodhya" if district=="Faizabad"
replace district="Bagalkote" if district=="Bagalkot"
replace district="Balasore" if district=="Baleshwar"
replace district="BalrampurUP" if district=="Balrampur" & L1_name=="Uttar Pradesh"
replace district="Banaskantha" if district=="Banas Kantha"
replace district="Ahmednagar" if district=="Ahmadnagar"
replace district="Bandipora" if district=="Bandipore"
replace district="Bengaluru Urban" if district=="Bangalore"
replace district="Bengaluru Rural" if district=="Bangalore Rural"
replace district="Barabanki" if district=="Bara Banki"
replace district="Baramulla" if district=="Baramula"
replace district="Beed" if district=="Bid"
replace district="Belagavi" if district=="Belgaum"
replace district="Ballari" if district=="Bellary"
replace district="Baramulla" if district=="Baramula"
replace district="Beed" if district=="Bid"
replace district="Budgam" if district=="Badgam"
replace district="Boudh" if district=="Baudh"
replace district="Buldhana" if district=="Buldana"
replace district="Maharajganj" if district=="Mahrajganj"
replace district="Mehsana" if district=="Mahesana"
replace district="Narsinghpur" if district=="Narsimhapur"
replace district="South Sikkim" if district=="South District"
replace district="South Delhi" if district=="South"
replace district="Vijayapura" if district=="Bijapur" & L1_name=="Karnataka"
replace district="BilaspurCH" if district=="Bilaspur" & L1_name=="Chhattisgarh"
replace district="BilaspurHP" if district=="Bilaspur" & L1_name=="Himachal Pradesh"
replace district="Central Delhi" if district=="Central" & L1_name=="NCT Of Delhi"
replace district="Chamarajanagara" if district=="Chamarajanagar"
replace district="Chikkamagaluru" if district=="Chikmagalur"
replace district="Chittorgarh" if district=="Chittaurgarh"
replace district="Dadra and Nagar Haveli" if district=="Dadra & Nagar Haveli"
replace district="Darjeeling" if district=="Darjiling"
replace district="Deogarh" if district=="Debagarh"
replace district="Dholpur" if district=="Dhaulpur"
replace district="Dahod" if district=="Dohad"
replace district="East Delhi" if district=="East" & L1_name=="NCT Of Delhi"
replace district="East Sikkim" if district=="East District"
replace district="Ferozepur" if district=="Firozpur"
replace district="Pauri Garhwal" if district=="Garhwal"
replace district="Gondia" if district=="Gondiya"
replace district="Gurugram" if district=="Gurgaon"
replace district="HamirpurHP" if district=="Hamirpur" & L1_name=="Himachal Pradesh"
replace district="HamirpurUP" if district=="Hamirpur" & L1_name=="Uttar Pradesh"
replace district="Howrah" if district=="Haora"
replace district="Haridwar" if district=="Hardwar"
replace district="Hooghly" if district=="Hugli"
replace district="Jagatsinghpur" if district=="Jagatsinghapur"
replace district="West Jaintia Hills" if district=="Jaintia Hills"
replace district="Jajpur" if district=="Jajapur"
replace district="Jalore" if district=="Jalor"
replace district="Janjgir Champa" if district=="Janjgir - Champa"
replace district="Jhunjhunu" if district=="Jhunjhunun"
replace district="Kutch" if district=="Kachchh"
replace district="Kaimur" if district=="Kaimur (Bhabua)"
replace district="Kanyakumari" if district=="Kanniyakumari"
replace district="Kasganj" if district=="Kanshiram Nagar"
replace district="Khandwa" if district=="Khandwa (East Nimar)"
replace district="Khargone" if district=="Khargone (West Nimar)"
replace district="Lakhimpur Kheri" if district=="Kheri"
replace district="Kaimur" if district=="Kaimur (Bhabua)"
replace district="Cooch Behar" if district=="Koch Bihar"
replace district="Koderma" if district=="Kodarma"
replace district="Lahaul And Spiti" if district=="Lahul & Spiti"
replace district="Leh" if district=="Leh(Ladakh)"
replace district="Hathras" if district=="Mahamaya Nagar"
replace district="Mahabubnagar" if district=="Mahbubnagar"
replace district="Malda" if district=="Maldah"
replace district="Nuh" if district=="Mewat"
replace district="Sri Muktsar Sahib" if district=="Muktsar"
replace district="Mysuru" if district=="Mysore"
replace district="North Delhi" if district=="North" & L1_name=="NCT Of Delhi"
replace district="North and Middle Andaman" if district=="North  & Middle Andaman"
replace district="North Sikkim" if district=="North  District"
replace district="North East Delhi" if district=="North East"
replace district="North 24 Parganas" if district=="North Twenty Four Parganas"
replace district="North West Delhi" if district=="North West"
replace district="Panchmahal" if district=="Panch Mahals"
replace district="West Champaran" if district=="Pashchim Champaran"
replace district="West Singhbhum" if district=="Pashchimi Singhbhum"
replace district="PratapgarhRJ" if district=="Pratapgarh" & L1_name=="Rajasthan"
replace district="PratapgarhUP" if district=="Pratapgarh" & L1_name=="Uttar Pradesh"
replace district="East Champaran" if district=="Purba Champaran"
replace district="East Singhbhum" if district=="Purbi Singhbhum"
replace district="Purulia" if district=="Puruliya"
replace district="Raigad" if district=="Raigarh" & L1_name=="Maharashtra"
replace district="Ranga Reddy" if district=="Rangareddy"
replace district="Sabarkantha" if district=="Sabar Kantha"
replace district="S.A.S. Nagar" if district=="Sahibzada Ajit Singh Nagar"
replace district="Bhadohi" if district=="Sant Ravidas Nagar (Bhadohi)"
replace district="Shivamogga" if district=="Shimoga"
replace district="Shopiyan" if district=="Shupiyan"
replace district="South 24 Parganas" if district=="South Twenty Four Parganas"
replace district="South West Delhi" if district=="South West"
replace district="S.P.S. Nellore" if district=="Sri Potti Sriramulu Nellore"
replace district="Dang" if district=="The Dangs"
replace district="Nilgiris" if district=="The Nilgiris"
replace district="Tumakuru" if district=="Tumkur"
replace district="West Delhi" if district=="West"
replace district="West Sikkim" if district=="West District"
replace district="Y.S.R. Kadapa" if district=="Y.S.R."

save  "India_Census_2011_select.dta", replace






/*==============================================================================
				Mobility Data
===============================================================================*/

clear all

//Change the directory for the folder having all csv file. The below loop 
//change all csv file into dta file and then we can append it easily.
cd "$datasets\Mobility\drive-download-20200812T141752Z-001"

local myfilelist : dir . files"*.csv"
foreach file of local myfilelist {
drop _all
insheet using `file'
local outfile = subinstr("`file'",".csv","",.)
save "`outfile'", replace
}

clear all
cd "$datasets\Mobility\drive-download-20200812T141752Z-001"

//Appending all the dta files.
append using "2020mar01.dta" "2020mar02.dta" "2020mar02.dta" "2020mar02.dta" "2020mar03.dta" ///
"2020mar04.dta" "2020mar05.dta" "2020mar06.dta" "2020mar07.dta" "2020mar08.dta" "2020mar09.dta" ///
"2020mar10.dta" "2020mar11.dta" "2020mar12.dta" "2020mar13.dta" "2020mar14.dta" "2020mar15.dta" ///
"2020mar16.dta" "2020mar17.dta" "2020mar18.dta" "2020mar19.dta" "2020mar20.dta" "2020mar21.dta" "2020mar22.dta" ///
"2020mar23.dta" "2020mar24.dta" "2020mar25.dta" "2020mar26.dta" "2020mar27.dta" "2020mar28.dta" "2020mar29.dta" ///
"2020mar30.dta" "2020mar31.dta" "2020apr01.dta" "2020apr02.dta" "2020apr03.dta" "2020apr04.dta" "2020apr05.dta" ///
"2020apr06.dta" "2020apr07.dta" "2020apr08.dta" "2020apr09.dta" "2020apr10.dta" "2020apr11.dta" "2020apr12.dta" ///
"2020apr13.dta" "2020apr14.dta" "2020apr15.dta" "2020apr16.dta" "2020apr17.dta" "2020apr18.dta" "2020apr19.dta" ///
"2020apr20.dta" "2020apr21.dta" "2020apr22.dta" "2020apr23.dta" "2020apr24.dta" "2020apr25.dta" "2020apr26.dta" ///
"2020apr27.dta" "2020apr28.dta" "2020apr29.dta" "2020apr30.dta" "2020may01.dta" "2020may02.dta" "2020may03.dta" ///
"2020may25.dta" "2020may26.dta" "2020may27.dta" "2020may28.dta" "2020may29.dta" "2020may30.dta" "2020may31.dta" ///
"2020jun01.dta" "2020jun02.dta" "2020jun03.dta" "2020jun04.dta" "2020jun05.dta" "2020jun06.dta" "2020jun07.dta" ///
"2020jun08.dta" "2020jun09.dta" "2020jun10.dta" "2020jun11.dta" "2020jun12.dta" "2020jun13.dta" "2020jun14.dta" ///
"2020jun15.dta" "2020jun16.dta" "2020jun17.dta" "2020jun18.dta" "2020jun19.dta" "2020jun20.dta" "2020jun21.dta" ///
"2020jun22.dta" "2020jun23.dta" "2020jun24.dta" "2020jun25.dta" "2020jun26.dta" "2020jun27.dta" "2020jun28.dta" ///
"2020jun29.dta" "2020jun30.dta" "2020july01.dta" "2020july02.dta" "2020july03.dta" "2020july04.dta" "2020july05.dta" ///
"2020july06.dta" "2020july07.dta" "2020july08.dta" "2020july09.dta" "2020july10.dta" "2020july11.dta" "2020july12.dta" ///
"2020july13.dta" "2020july14.dta" "2020july15.dta" "2020july16.dta" "2020july17.dta" "2020july18.dta" "2020july19.dta" ///
"2020july20.dta" "2020july21.dta" "2020july22.dta" "2020july23.dta" "2020july24.dta" "2020july25.dta" "2020july26.dta" ///
"2020july27.dta" "2020july28.dta" 


/*The date in this dataset is in the string format. Converting this into date format 
so that STATA can perform date function properly */
generate date = date(ds, "YMD")   //date() is a function   
format date %td    //convert date into 03mar2020 like this format

//Generate month
gen month = month(date) //month() is a function

drop ds crisis_name age_bracket gender baseline_name baseline_type external_polygon_id external_polygon_id_type date //not required

//more than one statistics
//collapse (mean) all_day_bing_tiles_visited_relat all_day_ratio_single_tile_users (sd) sd_v1=all_day_bing_tiles_visited_relat sd_v2=all_day_ratio_single_tile_users, by( polygon_name polygon_id month)

// district-wise monthly data
collapse (mean) all_day_bing_tiles_visited_relat all_day_ratio_single_tile_users, by( polygon_name polygon_id month)

rename polygon_name district
replace district="Ahmedabad" if district=="Ahmadabad"
replace district="Ahmednagar" if district=="Ahmadnagar"
replace district="Prayagraj" if district=="Allahabad"
replace district="Angul" if district=="Anugul"
replace district="Ayodhya" if district=="Faizabad"
replace district="Bagalkote" if district=="Bagalkot"
replace district="Balasore" if district=="Baleshwar"
replace district="Banaskantha" if district=="Banas Kantha"
replace district="Bandipora" if district=="Bandipore"
replace district="Bengaluru Urban" if district=="Bangalore"
replace district="Bengaluru Rural" if district=="Bangalore Rural"
replace district="Beed" if district=="Bid"
replace district="Belagavi" if district=="Belgaum"
replace district="Ballari" if district=="Bellary"
replace district="Baramulla" if district=="Baramula"
replace district="Budgam" if district=="Badgam"
replace district="Boudh" if district=="Baudh"
replace district="Buldhana" if district=="Buldana"
replace district="Mehsana" if district=="Mahesana"
replace district="Narsinghpur" if district=="Narsimhapur"
replace district="South Sikkim" if district=="South District"
replace district="South Delhi" if district=="South"
replace district="Chamarajanagara" if district=="Chamrajnagar"
replace district="Chikkamagaluru" if district=="Chikmagalur"
replace district="Chittorgarh" if district=="Chittaurgarh"
replace district="Dadra and Nagar Haveli" if district=="Dadra & Nagar Haveli"
replace district="Darjeeling" if district=="Darjiling"
replace district="Deogarh" if district=="Debagarh"
replace district="Dholpur" if district=="Dhaulpur"
replace district="Dahod" if district=="Dohad"
replace district="East Delhi" if district=="East" 
replace district="East Sikkim" if district=="East District"
replace district="Ferozepur" if district=="Firozpur"
replace district="Pauri Garhwal" if district=="Garhwal"
replace district="Gondia" if district=="Gondiya"
replace district="Gurugram" if district=="Gurgaon"
replace district="Howrah" if district=="Haora"
replace district="Haridwar" if district=="Hardwar"
replace district="Hooghly" if district=="Hugli"
replace district="Jagatsinghpur" if district=="Jagatsinghapur"
replace district="West Jaintia Hills" if district=="Jaintia Hills"
replace district="Jajpur" if district=="Jajapur"
replace district="Jalore" if district=="Jalor"
replace district="Janjgir Champa" if district=="Janjgir-Champa"
replace district="Jhunjhunu" if district=="Jhunjhunun"
replace district="Kutch" if district=="Kachchh"
replace district="Kaimur" if district=="Kaimur (Bhabua)"
replace district="Kanyakumari" if district=="Kanniyakumari"
replace district="Kasganj" if district=="Kanshiram Nagar"
replace district="Khandwa" if district=="East Nimar"
replace district="Khargone" if district=="West Nimar"
replace district="Lakhimpur Kheri" if district=="Kheri"
replace district="Kaimur" if district=="Kaimur (Bhabua)"
replace district="Cooch Behar" if district=="Koch Bihar"
replace district="Koderma" if district=="Kodarma"
replace district="Lahaul And Spiti" if district=="Lahul & Spiti"
replace district="Leh" if district=="Leh (Ladakh)"
replace district="Hathras" if district=="Mahamaya Nagar"
replace district="Mahabubnagar" if district=="Mahbubnagar"
replace district="Malda" if district=="Maldah"
replace district="Nuh" if district=="Mewat"
replace district="Sri Muktsar Sahib" if district=="Muktsar"
replace district="Mysuru" if district=="Mysore"
replace district="North and Middle Andaman" if district=="North  & Middle Andaman"
replace district="North Sikkim" if district=="North  District"
replace district="North East Delhi" if district=="North East"
replace district="North 24 Parganas" if district=="North Twenty Four Parganas"
replace district="North West Delhi" if district=="North West"
replace district="Panchmahal" if district=="Panch Mahals"
replace district="West Champaran" if district=="Pashchim Champaran"
replace district="West Singhbhum" if district=="Pashchimi Singhbhum"
replace district="East Champaran" if district=="Purba Champaran"
replace district="East Singhbhum" if district=="Purbi Singhbhum"
replace district="Purulia" if district=="Puruliya"
replace district="Ranga Reddy" if district=="Rangareddy"
replace district="Sabarkantha" if district=="Sabar Kantha"
replace district="S.A.S. Nagar" if district=="Sahibzada Ajit Singh Nagar"
replace district="Bhadohi" if district=="Sant Ravi Das Nagar"
replace district="Shivamogga" if district=="Shimoga"
replace district="Shopiyan" if district=="Shupiyan"
replace district="South 24 Parganas" if district=="South Twenty Four Parganas"
replace district="South West Delhi" if district=="South West"
replace district="S.P.S. Nellore" if district=="Nellore"
replace district="Dang" if district=="The Dangs"
replace district="Nilgiris" if district=="The Nilgiris"
replace district="Tumakuru" if district=="Tumkur"
replace district="West Delhi" if district=="West"
replace district="Y.S.R. Kadapa" if district=="Y.S.R."
replace district="AurangabadBH" if district=="Aurangabad" & polygon_id==17903
replace district="AurangabadMH" if district=="Aurangabad" & polygon_id==17526
replace district="BalrampurUP" if district=="Balrampur" & polygon_id==17743
replace district="BalrampurCh" if district=="Balrampur" & polygon_id==17939
replace district="BilaspurCH" if district=="Bilaspur" & polygon_id==17943
replace district="BilaspurHP" if district=="Bilaspur" & polygon_id==17343
replace district="HamirpurHP" if district=="Hamirpur" & polygon_id==17347 
replace district="HamirpurUP" if district=="Hamirpur" & polygon_id==17767
replace district="Raigad" if district=="Raigarh" & & polygon_id==17515
replace district="PratapgarhRJ" if district=="Pratapgarh" & polygon_id==17659
replace district="PratapgarhUP" if district=="Pratapgarh" & polygon_id==17795
replace district="Boudh" if district=="Bauda"
replace district="Bametara" if district=="Bemetara"
replace district="Chikkaballapura" if district=="Chikballapura"
replace district="Dakshin Bastar Dantewada" if district=="Dantewada"
replace district="Gadchiroli" if district=="Garhchiroli"
replace district="Lawngtlai" if district=="Lawangtlai"
replace district="Mumbai" if district=="Mumbai City"
replace district="Paschim Medinipur" if district=="Pashchim Medinipur"
replace district="Punch" if district=="Poonch"
replace district="Ribhoi" if district=="Ri Bhoi"
replace district="Saraikela-Kharsawan" if district=="Saraikela-kharsawan"
replace district="Shrawasti" if district=="Shravasti"
replace district="Siddharthnagar" if district=="Siddharth Nagar"
replace district="Virudhunagar" if district=="Virudunagar"
drop if district=="Bijapur" & polygon_id ==17427

gen year=2020 //Because the data is from year 2020

save "$datasets\Mobility\mobility.dta", replace








                           /*==========================================================================

		                                   MERGING of the datasets

                           =========================================================================== */

/*-----------------------------------------------------------------------
           Merging COVID-19 API with Night Light data
------------------------------------------------------------------------*/		
  
/* 
Merging Night light data from 2012-2020 to the Night Light Controls 
Night Light controls are the previous years night light data.
*/  

clear all

cd "$datasets\Merging" //This Merging folder contains all the merged files

use "$datasets\Night Light Data\VIIRS_NightLight.dta", clear //Night light data from 2012-2020 from the World Bank

merge m:m district using "$datasets\Night Light Data\NightLight_wide.dta" //merge with to the Night Light Controls 
		   
drop if inlist( district, "Muzaffarabad", "Mirpur")		//Not in classification		
drop _merge
drop ntl_s_n_cl2020Apr ntl_s_n_cl_a2020Apr ntl_s_n_cl2020Aug ntl_s_n_cl_a2020Aug ntl_s_n_cl2020July ntl_s_n_cl_a2020July ///
ntl_s_n_cl2020June ntl_s_n_cl_a2020June ntl_s_n_cl2020Mar ntl_s_n_cl_a2020Mar ntl_s_n_cl2020May ntl_s_n_cl_a2020May

save "$datasets\Merging\NightLight.dta", replace						   

*****************************************************************

clear all
cd "$datasets\Merging"  //Change the directory

use "NightLight.dta", clear  //This is the above data

merge m:m district year month using "$datasets\COVID19-India.API\district_monthlypanel.dta" // merge with covid data
drop _merge
drop if district=="Capf Personnel" 

// for years 2012-2019 infections were zero
replace infected=0 if infected==.
replace recovered=0 if recovered==.
replace deceased=0 if deceased==.
replace active=0 if active==.
replace infection=0 if infection==.
replace current_active=0 if current_active==.

/*
Merging with zone classification
Zone Classification data contains information about district containment policy
*/
merge m:m district using "$datasets\Zone classification\zone_classification.dta" 	//Merge using district names
drop _merge	

//Creating binary variable
gen red=0
replace red=1 if classification=="Red"

gen orange=0
replace orange=1 if classification=="Orange"

gen green=0
replace green=1 if classification=="Green"				   

/*
Merging with 30th April infections
30th April infections is the control variable--> number of infections on 30th April
*/
merge m:m district classification using "$datasets\Merging\Apr30.dta"
drop _merge	


/*   
Merging COVID-19 API- ZONE classification with border-district data 
Border district data contains the information about the district sharing border with same color and different color
in which 1 if the district is sharing the border with different color or otherwise */

merge m:m district using "$datasets\Merging\border_district.dta"
drop _merge state
drop if district=="Delhi"
//Ordering 
order State district classification SHRUG_id red orange green year month infected recovered deceased active ///
infection current_active infections_30Apr ntl_s_n_cl ntl_s_n_cl_a boundary_district

sort State district	year month	

save "covid_zoneclassification.dta", replace

/*************************************************************************
           Merging COVID-19 API- ZONE classification with SHRUG data
**************************************************************************/
clear all
cd "$datasets\Merging"

//COVID and Zone Classification merged file
use "covid_zoneclassification.dta", clear

sort dist_code  //Here I am using SHRUG_id to merge the datasets

//Merging COVID and Zone Classification with SHRUG data
merge m:m dist_code using "$datasets\SHRUG\districtshrug.dta"
drop if _merge==2
  
//Cross check if merging is done properly
*br district pc11_district_name  //It's all correct. I checked manually.

drop pc11_state_id pc11_state_name pc11_district_id pc11_district_id _merge //Variables not required.

//Puting population values for the districts where I am getting missing values.
//sources are wikipedias
replace tot_population_in_thousands=1709346/1000 if district=="East Delhi"
replace tot_population_in_thousands=582320/1000 if district=="Central Delhi"
replace tot_population_in_thousands=887978/1000 if district=="North Delhi"
replace tot_population_in_thousands=2241624/1000 if district=="North East Delhi"
replace tot_population_in_thousands=2731929/1000 if district=="South Delhi"
replace tot_population_in_thousands=2731929/1000 if district=="South East Delhi"
replace tot_population_in_thousands=2292958/1000 if district=="South West Delhi"
replace tot_population_in_thousands=2543243/1000 if district=="West Delhi"
replace tot_population_in_thousands=2543243/1000 if district=="Shahdara"
replace tot_population_in_thousands=807022/1000 if district=="Tapi"

/*Population Density */
gen area= ntl_s_n_cl/ntl_s_n_cl_a
gen pop_density=tot_population_in_thousands/area

*-----Label
label var pop_density "Population density (thousands per sq. km)"

//Arrange data
sort State district year month
order State district classification SHRUG_id red orange green year month infected

save "COVID_ZC_SHRUG.dta", replace

/*************************************************************************
       Merging COVID-19 API- ZONE classification - SHRUG data-  RBI data
**************************************************************************/

clear all
cd "$datasets\Merging"

//COVID-19 - Zone Classificatio - SHRUG data
use "COVID_ZC_SHRUG.dta", clear

//Merge with RBI data using "district" variable
merge m:m district using "$datasets\RBI\RBI.dta"

drop if _merge==2 
drop state _merge

*generate variable for Rs.Billion
gen Q4_deposit_billion= Q4_deposit/100
gen Q4_credit_billion= Q4_credit/100
gen Q3_deposit_billion= Q3_deposit/100
gen Q3_credit_billion= Q3_credit/100
gen Q2_deposit_billion= Q2_deposit/100
gen Q2_credit_billion= Q2_credit/100
gen Q1_deposit_billion= Q1_deposit/100
gen Q1_credit_billion= Q1_credit/100

*droping the variables in Rs.Crore 
drop Q4_deposit Q4_credit Q3_deposit Q3_credit Q2_deposit Q2_credit Q1_deposit Q1_credit

*renaming
rename Q4_deposit_billion Q4_deposit
rename Q4_credit_billion Q4_credit
rename Q3_deposit_billion Q3_deposit
rename Q3_credit_billion Q3_credit
rename Q2_deposit_billion Q2_deposit
rename Q2_credit_billion Q2_credit
rename Q1_deposit_billion Q1_deposit
rename Q1_credit_billion Q1_credit

*------------Lables
label var red "1 if district is in red zone otherwise 0"
label var orange "1 if district is in the orange zone otherwise 0"
label var green "1 if district is in green zone otherwise 0"
label var month "Month of data"
label var year "Year of data"
label var infected "Number of infection per month"
label var deceased "Number of patients deceased per month"
label var recovered "Number of patients recovered per month"
label var active "Number of active patients per month"
label var infection "Cumulative infection"
label var current_active "Active number of patient"
label var ntl_s_n_cl "Sum of lights (nanowatts)"
label var ntl_s_n_cl_a "Sum of lights per sq. km (nanowatts)"
label var Q4_deposit "2019Q4 bank deposit (Rs. Billions)"
label var Q4_credit "2019Q4 bank credit (Rs. Billions)"
label var Q3_deposit "2019Q3 bank deposit (Rs. Billions)"
label var Q3_credit "2019Q3 bank credit (Rs. Billions)"
label var Q2_deposit "2019Q2 bank deposit (Rs. Billions)"
label var Q2_credit "2019Q2 bank credit (Rs. Billions)"
label var Q1_deposit "2019Q1 bank deposit (Rs. Billions)"
label var Q1_credit "2019Q1 bank credit (Rs. Billions)"

//Arrange data
sort State district year month
order State district classification SHRUG_id red orange green year month infected

save "COVID_ZC_SHRUG_RBI.dta", replace



/*************************************************************************
  Merging COVID-19 API- ZONE classification-SHRUG-RBI and  Night Lights
  with Age data
		   
**************************************************************************/ 

clear all
cd "$datasets\Merging"

use "COVID_ZC_SHRUG_RBI.dta", clear

gen Distt_code= SHRUG_id     //Distt_code is similar to SHRUG_id

//Assigning Distt_code to the new district same as their parent district.
/*
Since, this is the 2011 census data contains data only for 640 districts. 
So, I am assigning ID’s to new districts same as parent districts. 
Because we are using the average district variable for our analysis, so, the average district age might be same as parent district.*/

replace Distt_code=628  if district=="Tenkasi" //Separated from Tirunelveli
replace Distt_code=605  if district=="Ranipet" //Formed by trifurcating the Vellore district
replace Distt_code=604  if district=="Chengalpattu" // carved from kanchipuram
replace Distt_code=605  if district=="Tirupathur" //separated from vellore
replace Distt_code=583  if district=="Bengaluru Urban"
replace Distt_code=43  if district=="Fazilka" //partition of Firozpur district
replace Distt_code=94 if district=="Shahdara" //
replace Distt_code=98 if district=="South East Delhi"
replace Distt_code=286 if district=="Hnahthial" // carved out from Lunglei district
replace Distt_code=133  if district=="Shamli" //carved out from muzaffarnagar
replace Distt_code=138  if district=="Hapur" // Meerut
replace Distt_code=177  if district=="Amethi" //Faizabad divison
replace Distt_code=289  if district=="Sipahijala" //West Tripura
replace Distt_code=289  if district=="Khowai" //carved out from West Tripura
replace Distt_code=289  if district=="Gomati"
replace Distt_code=283 if district=="Khawzawl" //Aizawl
replace Distt_code=284 if district=="Saitual" //Champhai
replace Distt_code=535 if district=="Medak" 
replace Distt_code=292  if district=="Unokoti" //part of north tripura
replace Distt_code=293  if district=="South West Garo Hills"
replace Distt_code=294  if district=="North Garo Hills"  //carved out from east Garo Hills
replace Distt_code=296  if district=="South West Khasi Hills" //carved out from West Khasi Hills
replace Distt_code=296  if district=="East Jaintia Hills" //
replace Distt_code=572  if district=="Surajpur" //Banglore urban
replace Distt_code=401 if district=="BalrampurCh" //part of Surguja district
replace Distt_code=406  if district=="Mungeli" //separation of bilaspur
replace Distt_code=409 if district=="Bametara" //
replace Distt_code=409  if district=="Balod" //Durg divison
replace Distt_code=410  if district=="Gariaband" //carved out of Raipur
replace Distt_code=410  if district=="Baloda Bazar" //carved out of Raipur
replace Distt_code=414  if district=="Kondagaon" //Separated from Bastar
replace Distt_code=414  if district=="Sukma" // Bastar
replace Distt_code=436  if district=="Agar Malwa" //carved outof Shahajpur
replace Distt_code=472  if district=="Aravalli" //carved out from Sabarkantha
replace Distt_code=481  if district=="Botad" // Bhavnagar district
replace Distt_code=475  if district=="Morbi" //
replace Distt_code=477  if district=="Devbhumi Dwarka" //Jamnagar 
replace Distt_code=479  if district=="Gir Somnath" //Junagadh
replace Distt_code=606 if district=="Kallakurichi" //Tiruvannamalai
replace Distt_code=484  if district=="Mahisagar" //
replace Distt_code=486  if district=="Chhota Udaipur" //Panchamahal and Kheda
replace Distt_code=517  if district=="Palghar" //Thane
replace Distt_code=535  if district=="Siddipet"
replace Distt_code=95  if district=="Central Delhi"
replace Distt_code=93  if district=="East Delhi"
replace Distt_code=94  if district=="New Delhi"
replace Distt_code=91  if district=="North Delhi"
replace Distt_code=92  if district=="North East Delhi"
replace Distt_code=90  if district=="North West Delhi"
replace Distt_code=98  if district=="South Delhi"
replace Distt_code=97  if district=="South West Delhi"
replace Distt_code=96  if district=="West Delhi"
replace Distt_code=518  if district=="Mumbai"
replace Distt_code=519  if district=="Mumbai Suburban"
replace Distt_code=474  if district=="Ahmedabad"
replace Distt_code=536  if district=="Hyderabad"
replace Distt_code=492  if district=="Surat"
replace Distt_code=492  if district=="Tapi" //surat
replace Distt_code=532  if district=="Komaram Bheem" //Adilabad
replace Distt_code=532  if district=="Nirmal" //Adilabad
replace Distt_code=532  if district=="Mancherial" //
replace Distt_code=533  if district=="Kamareddy" // Nizamabad
replace Distt_code=534  if district=="Jagtial" //Karimnagar
replace Distt_code=534  if district=="Peddapalli" //Karimnagar
replace Distt_code=534  if district=="Rajanna Sircilla" //Karimnagr
replace Distt_code=535  if district=="Sangareddy" //Medak
replace Distt_code=537  if district=="Medchal Malkajgiri" //Ranga reddy
replace Distt_code=537  if district=="Vikarabad" //Ranga Reddy
replace Distt_code=538  if district=="Jogulamba Gadwal" //Mahbubnagar
replace Distt_code=538  if district=="Wanaparthy" //Mahbubnagar
replace Distt_code=538  if district=="Nagarkurnool" //Mahbubnagar
replace Distt_code=539  if district=="Yadadri Bhuvanagiri" //nalgonda
replace Distt_code=539  if district=="Suryapet" //nalgonda
replace Distt_code=538  if district=="Warangal Rural" //Mahbubnagar
replace Distt_code=540  if district=="Jayashankar Bhupalapally" //Warangal
replace Distt_code=540  if district=="Mahabubabad" //Warangal
replace Distt_code=540  if district=="Jangaon" //Warangal
replace Distt_code=540  if district=="Bhadradri Kothagudem" //Khammam
replace Distt_code=135  if district=="Sambhal" //Bhimnagar //Morabad
replace Distt_code=311  if district=="Charaideo" //Sivasagar
replace Distt_code=306  if district=="Biswanath" //Sonitpur
replace Distt_code=305  if district=="Hojai" //Nagaon
replace Distt_code=301  if district=="South Salmara Mankachar" //Dhubri
replace Distt_code=314  if district=="West Karbi Anglong" //Anglong
replace Distt_code=312  if district=="Majuli" //jorhat
replace Distt_code=254  if district=="Longding" //Tirap
replace Distt_code=259  if district=="Namsai" //Lohit
replace Distt_code=256  if district=="Kradaadi" //Kurung Kumey
replace Distt_code=550  if district=="Siang" 
replace Distt_code=81  if district=="Charkhi Dadri" //Bhiwani
replace Distt_code=278  if district=="Jiribam" //Imphal east
replace Distt_code=272  if district=="Kangpokpi" //Senapati
replace Distt_code=276  if district=="Kakching" //Thoubal
replace Distt_code=280  if district=="Tengnoupal" //Chandel
replace Distt_code=279  if district=="Kamjong" //Urkhul
replace Distt_code=273  if district=="Noney" //Tamenglong
replace Distt_code=274  if district=="Pherzawl" //
replace Distt_code=35  if district=="Pathankot" //Gurdaspur
replace Distt_code=328  if district=="Alipurduar" //Jalpaiguri
replace Distt_code=327  if district=="Kalimpong" //Darjeeling

replace Distt_code=344  if district=="Jhargram" //Paschim Mendipur district
replace Distt_code=335  if district=="Paschim Bardhaman" //bardhaman
replace Distt_code=246 if district=="Kamle" //
replace Distt_code=246  if district=="Lower Siang" //west and east siang
replace Distt_code=540  if district=="Mulugu" //Jayashnakar bhupalpalli
replace Distt_code=538 if district=="Narayanpet" //Mhbubnagar
replace Distt_code=424  if district=="Niwari" //Tikamgarh
replace Distt_code=247  if district=="Pakke Kessang" //East kameng
replace Distt_code=250  if district=="Lepa Rada" //west siang
replace Distt_code=250  if district=="Shi Yomi" //west siang
replace Distt_code=492  if district=="Delhi" 
replace Distt_code=536  if district=="Ranga Reddy" // Hyderabad

merge m:m Distt_code using "$datasets\Census 2011\Census11Age.dta"

sort State district year month
order State district classification red orange green month year infected recovered deceased active infection current_active ntl_s_n_cl ntl_s_n_cl_a boundary_district
drop _merge areaname Distt_code
drop if district==""
save "COVID_ZC_SHRUG_RBI_NL_Age",replace

/*************************************************************************
  Merging COVID-19 API- ZONE classification-SHRUG-RBI and  Night Lights
  with Age data with Census11 data	   (This is the Informality data)
**************************************************************************/

clear all
cd "$datasets\Merging"
use "COVID_ZC_SHRUG_RBI_NL_Age", clear
merge m:m district using "$datasets\Informality\India_Census_2011_select.dta"
sort State district year month
order State district classification red orange green month year infected recovered deceased active infection current_active ntl_s_n_cl ntl_s_n_cl_a boundary_district
drop _merge
drop if State==""
save "COVID_ZC_SHRUG_RBI_NL_Jan.census11.dta", replace


/*************************************************************************
  Merging COVID-19 API- ZONE classification-SHRUG-RBI and  Night Lights
  with Age data with Census11 data	and Mobility   
**************************************************************************/

clear all
cd "$datasets\Merging"
use "COVID_ZC_SHRUG_RBI_NL_Jan.census11.dta", clear
merge m:m district year month using "$datasets\Mobility\mobility.dta"

sort State district year month
order State district classification red orange green  year month infected recovered deceased active infection current_active ntl_s_n_cl ntl_s_n_cl_a boundary_district
drop _merge L1_name L1_code L2_code
drop if State==""
save "COVID_ZC_SHRUG_RBI_NL_Jan.census11_mobility.dta", replace



/*=======================================================================================
    Set as panel data
========================================================================================*/	
	
encode district, gen( districtid )
encode State, gen(stateid)
// gen zeroes="0000"
egen dist_state_month_year=concat(districtid stateid month year)
destring dist_state_month_year, replace force
xtset dist_state_month_year month
distinct districtid


*********************************************************************************************************************************************
******======  GRAPH   =======**************
clear all
use "C:\Users\rosha\Desktop\IIMA\Merging\COVID_ZC_SHRUG_RBI_NL_Jan.census11_mobility.dta", clear

keep if year==2020
drop if month==8


bysort classification month: egen NightLights=mean( ntl_s_n_cl)
bysort classification month: egen NL_A=mean( ntl_s_n_cl_a)
duplicates drop classification month NightLights NL_A, force

/* parallel Trend graph Sum of lights (outlier treated, top 3 clusters), nanowatts  */
twoway (qfitci NightLights month if classification=="Red", nofit ciplot(rarea)) ///
(qfitci NightLights month if classification=="Orange", nofit ciplot(rarea)) ///
(qfitci NightLights month if classification=="Green", nofit ciplot(rarea)) ///
(line NightLights month if classification=="Red", color(red)) ///
(line NightLights month if classification=="Orange",color(orange)) ///
(line NightLights month if classification=="Green",color(green)), ///
title("Sum of lights(outlier treated, top 3 clusters)") ///
ytitle("nanowatts") xtitle("Year 2020") ///
legend(label(2 "Red zone night lights") label(3 "Orange zone night lights") label(4 "Green zone night lights")) ///
xlabel(1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul") saving(NL_month.gph, replace)
 
  
 
/* parallel Trend graph Sum of lights per sqaure meter(outlier treated, top 3 clusters), nanowatts  */
twoway (qfitci NL_A month if classification=="Red", nofit ciplot(rarea)) ///
(qfitci NL_A month if classification=="Orange", nofit ciplot(rarea)) ///
(qfitci NL_A month if classification=="Green", nofit ciplot(rarea)) ///
(line NL_A month if classification=="Red", color(red)) ///
(line NL_A month if classification=="Orange",color(orange)) ///
(line NL_A month if classification=="Green",color(green)), ///
title("Sum of lights per sqaure meter(outlier treated, top 3 clusters)") ///
ytitle("nanowatts") xtitle("Year 2020") ///
legend(label(1 "CI")label(2 "Red zone night lights") label(3 "Orange zone night lights") label(4 "Green zone night lights")) ///
xlabel(2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul") saving(NLpersqm_month.gph, replace)







/* parallel Trend graph Sum of lights (outlier treated, top 3 clusters), nanowatts  */
twoway (qfitci NightLights month if classification=="Red", nofit ciplot(rline)) ///
(qfitci NightLights month if classification=="Orange", nofit ciplot(rline)) ///
(qfitci NightLights month if classification=="Green", nofit ciplot(rline)) ///
(line NightLights month if classification=="Red", color(red)) ///
(line NightLights month if classification=="Orange",color(orange)) ///
(line NightLights month if classification=="Green",color(green))

, ///
title("Sum of lights(outlier treated, top 3 clusters)") ///
ytitle("nanowatts") xtitle("Year 2020") ///
legend(label(2 "Red zone Night Lights") label(3 "Orange zone classification") label(4 "Green zone classification")) ///
xlabel(2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul") saving(graph1, replace)
 
 








********************************Infection chart*****************************

clear all
use "C:\Users\rosha\Desktop\IIMA\Merging\COVID_ZC_SHRUG_RBI_NL_Jan.census11_mobility.dta", clear

keep if year==2020
drop if month==8

collapse(sum) infected, by( classification month)

twoway (line infected month if classification=="Red", color(red)) (line infected month if classification=="Orange", color(orange)) (line infected month if classification=="Green", color(green)), ///
ytitle("Infections")  ///
legend(label(1 "Red zone infections") label(2 "Orange zone infections") label(3 "Green zone infections")) ///
xlabel(1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul") saving(infections, replace)










/*===============================================================================
                  SUMMARY STATISTICS
================================================================================*/				  
clear
cap log close

cd "$datasets\pre_analysis_text"
use "C:\Users\rosha\Desktop\IIMA\Merging\Final.dta", clear
gen all=1
keep if year==2020
drop if inlist(month, 1, 2, 8)
label var all_day_ratio_single_tile_users "Mobility"
label var wtmean "Average district age (years)"

*-------SUMMARY STATISTICS BY ZONE CONTAINMENT
cap file  close sumstat
local     file "./sumstat.tex"
file      open sumstat using `file', write replace
file      write sumstat " &(1) & (2) & (3) & (4)  \\ \midrule   " _n
file      write sumstat " & Red & Orange & Green & All \\   \addlinespace[3pt] " _n
file      write sumstat " Classification & `st' & `st0' & `st1' & `st2' \\ \midrule " _n

local    tablevar  ntl_s_n_cl_a infected tot_population_in_thousands pop_density ///
Q4_deposit Q3_deposit Q2_deposit Q1_deposit wtmean urbanpop_in_thousand emp_sev ///
all_day_ratio_single_tile_users TOTAL_EXPENDITURE_thousands TOTAL_INCOME_thousands


foreach   x of varlist `tablevar'{ 
          local varlab: variable label `x'
		  qui sum `x' if classification=="Red"
          local mean0 : di %12.2f r(mean) 
          local md0   : di %12.2f r(sd)
		  local sd0   : di `md0'
          qui sum `x' if classification=="Orange"
          local mean1 : di %12.2f r(mean)
          local md1   : di %12.2f r(sd)
		  local sd1   : di `md1'
	      qui sum `x' if classification=="Green"
          local mean2 : di %12.2f r(mean) 
          local md2   : di %12.2f r(sd) 	
	      local sd2   : di `md2'
		  qui sum `x' 
          local mean3 : di %12.2f r(mean) 
          local md3   : di %12.2f r(sd) 	
	      local sd3   : di `md3'
     
file      write sumstat "`varlab' & `mean0' & `mean1' & `mean2' & `mean3' \\ " _n
file      write sumstat " &\multicolumn{1}{c}{(`sd0')} &\multicolumn{1}{c}{(`sd1')} &\multicolumn{1}{c}{(`sd2')} &\multicolumn{1}{c}{(`sd3')}  \\ \addlinespace[3pt] " _n
}
file write sumstat "\\ \midrule " _n
qui sum red if classification=="Red"
local n0 : di r(N)
qui sum orange if classification=="Orange"
local n1 : di r(N)
qui sum green if classification=="Green"
local n2 : di r(N)
qui sum all
local n3 : di r(N)
file      write sumstat " No. of observations &`n0' &`n1' &`n2' &`n3' \\ \addlinespace[3pt] " _n

file      close sumstat


*----------------SUMMARY STATISTICS BY MONTH
cap file  close sumstatmonth
local     file "./sumstatmonth.tex"
file      open sumstatmonth using `file', write replace
file      write sumstatmonth " &(1) & (2) & (3) & (4) & (5)   \\ \midrule   " _n
file      write sumstatmonth " & February & March & April & May & June \\   \addlinespace[3pt] " _n
file      write sumstatmonth " Month & `st' & `st0' & `st1' & `st2' & `st3'  \\ \midrule " _n

local     tablevar  infected recovered deceased active infection current_active ntl_s_n_cl ntl_s_n_cl_a 
foreach   x of varlist `tablevar'{ 
          local varlab: variable label `x'
		  qui sum `x' if month==2
          local mean0 :  di %9.2f r(mean) 
          local md0   :  di %9.2f r(sd) 
		  local sd0   :  di `md0'
          qui sum `x' if month==3
          local mean1 :  di %9.2f r(mean) 
          local md1   :  di %9.2f r(sd) 
		  local sd1   :  di `md1'
	      qui sum `x' if month==4
          local mean2 :  di %9.2f r(mean) 
          local md2   :  di %9.2f r(sd) 
		  local sd2   :  di `md2'
	      qui sum `x' if month==5
          local mean3 :  di %9.2f r(mean) 
          local md3   :  di %9.2f r(sd) 
		  local sd3   :  di `md3'
	      qui sum `x' if month==6
          local mean4 :  di %9.2f r(mean) 
          local md4   :  di %9.2f r(sd) 	
          local sd4   :  di `md4'
file      write sumstatmonth "`varlab' & `mean0' & `mean1' & `mean2' & `mean3' & `mean4'  \\ " _n
file      write sumstatmonth "  & \multicolumn{1}{c}{(`sd0')} & \multicolumn{1}{c}{(`sd1')} & \multicolumn{1}{c}{(`sd2')} & \multicolumn{1}{c}{(`sd3')} & \multicolumn{1}{c}{(`sd4')}  \\ \addlinespace[3pt] " _n
}
file write sumstatmonth "\\ \midrule " _n
qui sum month if month==2
local n0 : di r(N)
qui sum month if month==3
local n1 : di r(N)
qui sum month if month==4
local n2 : di r(N)
qui sum month if month==5
local n3 : di r(N)
qui sum month if month==6
local n4 : di r(N)
file      write sumstatmonth " No. of observations &`n0' &`n1' &`n2' &`n3' &`n4' \\ \addlinespace[3pt] " _n

file      close sumstatmonth





































































	   
