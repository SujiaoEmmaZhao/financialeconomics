
* yahoo finance
* investing.com

set more off
cap log close


global path "F:/Financial Economics/LectureNotes/Data/Treasury/"


foreach file in DTB3 DTB6 DGS1 DGS2 DGS3 DGS5 DGS10 DAAA DBAA T10Y2Y T10Y3M AAA10Y{

import delimited "${path}/`file'.csv", varnames(1) clear
gen year=substr(date,1,4)
gen month=substr(date,6,2)
gen day=substr(date,9,2)
destring year month day, replace
drop date
gen date=mdy( month, day, year)
format date %td
drop month day
order date

	if "`file'"=="DTB3" {
		gen Name="3-Month Treasury Bill"
		rename dtb3 yield
		drop if yield==.
	}
	
	else if "`file'"=="DTB6" {
		gen Name="6-Month Treasury Bill"
		rename dtb6 yield
		drop if yield==.
	}
	
	else if "`file'"=="DGS1" {
		gen Name="1-Year Treasury Bond"
		rename dgs1 yield
		drop if yield==.
	}
	
	else if "`file'"=="DGS2" {
		gen Name="2-Year Treasury Bond"
		rename dgs2 yield
		drop if yield==.
	}
	
	else if "`file'"=="DGS3" {
		gen Name="3-Year Treasury Bond"
		rename dgs3 yield
		drop if yield==.
	}
	
	else if "`file'"=="DGS5" {
		gen Name="5-Year Treasury Bond"
		rename dgs5 yield
		drop if yield==.
	}
	
	else if "`file'"=="DGS10" {
		gen Name="10-Year Treasury Bond"
		rename dgs10 yield
		drop if yield==.
	}

	else if "`file'"=="DAAA" {
		gen Name="Moody's Seasoned Aaa Corporate Bond"
		rename daaa yield
		drop if yield==.
	}
	
	else if "`file'"=="DBAA" {
		gen Name="Moody's Seasoned Baa Corporate Bond"
		rename dbaa yield
		drop if yield==.
	}
	
	else if "`file'"=="T10Y2Y" {
		gen Name="10-Year Treasury Bond Minus 2-Year Treasury Bond"
		rename t10y2y yield
		drop if yield==.
	}

	else if "`file'"=="T10Y3M" {
		gen Name="10-Year Treasury Bond Minus 3-Month Treasury Bill"
		rename t10y3m yield
		drop if yield==.
	}
	
	else if "`file'"=="AAA10Y" {
		gen Name="Moody's Seasoned Aaa Corporate Bond Minus 10-Year Treasury Bond"
		rename aaa10y yield
		drop if yield==.
	}
	
	save "${path}/`file'.dta", replace
}


* Treasury
use "${path}/DTB3.dta", clear
append using "${path}/DTB6.dta"
append using "${path}/DGS1.dta"
append using "${path}/DGS2.dta"
append using "${path}/DGS3.dta"
append using "${path}/DGS5.dta"
append using "${path}/DGS10.dta"
append using "${path}/DAAA.dta"
append using "${path}/DBAA.dta"
append using "${path}/T10Y2Y.dta"
append using "${path}/T10Y3M.dta"
append using "${path}/AAA10Y.dta"
save "${path}/Treasury.dta", replace

* To draw in the slides
use "F:\Financial Economics\LectureNotes\Data\Treasury\Treasury.dta", clear
drop if regex( Name, "Minus")
keep if inlist(Name, "3-Month Treasury Bill", "6-Month Treasury Bill", "1-Year Treasury Bond", "5-Year Treasury Bond", "10-Year Treasury Bond")
rename Name Instrument
save "F:\Financial Economics\LectureNotes\Data\Treasury\Treasury2.dta", replace





