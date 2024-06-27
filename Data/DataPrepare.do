
* yahoo finance
* investing.com

set more off
cap log close


global path "F:/Financial Economics/LectureNotes/Data/"

*foreach file in GSPC_SP500 DJI_Dow30 CPIAUCSL AAPL Nasdaq Nikkei225 HSI Bond10Y{

foreach file in Bill13W Bond5Y Bond30Y{

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

	if "`file'"=="CPIAUCSL" {
		gen date_m=mofd(date)
		format date_m %tm
		drop date
		order date_m
		save "${path}/CPI.dta", replace
	}
	
	else if "`file'"=="GSPC_SP500" {
		gen Name="SP500"
		save "${path}/GSPC_SP500.dta", replace
	}

	else if "`file'"=="DJI_Dow30" {
		gen Name="DOW30"
		save "${path}/DJI_Dow30.dta", replace
	}

	else {
		gen Name="`file'"
		save "${path}/`file'.dta", replace
	}
	
}

*foreach file in GSPC_SP500 DJI_Dow30 AAPL Nasdaq Nikkei225 HSI Bond10Y{

foreach file in Bill13W Bond5Y Bond30Y{

use "${path}/`file'.dta", clear
gen date_m=mofd(date)
format date_m %tm	
merge m:1 date_m using "${path}/CPI.dta"
keep if _m==3
drop _m
destring open high low close adjclose volume, replace force
save "${path}/`file'.dta", replace

}

* Equity
use "${path}/GSPC_SP500.dta", clear
append using "${path}/DJI_Dow30.dta"
append using "${path}/Nasdaq.dta"
append using "${path}/Nikkei225.dta"
append using "${path}/HSI.dta"
append using "${path}/AAPL.dta"
save "${path}/Stock.dta", replace

* Add compustat
use "${path}/Stock.dta", clear
keep date adjclose cpiaucsl Name
save "${path}/Stock.dta", replace

use "${path}/Compustat.dta", clear
keep Name datadate close
rename datadate date
rename close adjclose
append using "${path}/Stock.dta"
save "${path}/Stock.dta", replace

* Debt
use "${path}/Bill13W.dta", clear
append using "${path}/Bond5Y.dta"
append using "${path}/Bond10Y.dta"
append using "${path}/Bond30Y.dta"
drop if adjclose==.
save "${path}/Debt.dta", replace



