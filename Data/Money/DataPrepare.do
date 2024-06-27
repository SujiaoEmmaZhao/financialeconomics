
* yahoo finance
* investing.com

set more off
cap log close


global path "F:/Financial Economics/LectureNotes/Data/Money/"

*foreach file in M2SL_index2009 GDPDEF_index2009 M2SL_Growth_monthly GS10_monthly M1 M2 BOGMBASEW CURRCIR TCDNS EXCSRESNS{

foreach file in TB3MS{

	import delimited "${path}/`file'.csv", varnames(1) clear
	gen year=substr(date,1,4)
	gen month=substr(date,6,2)
	gen day=substr(date,9,2)
	destring year month day, replace
	drop date
	gen date=mdy( month, day, year)
	format date %td
	drop day
	order date

	if "`file'"=="M2SL_index2009" {
		gen Name="M2 Money Supply"
		drop if m2sl_nbd20090101==.
		rename m2sl_nbd20090101 m2sl
		drop month
	}
	
	else if "`file'"=="GDPDEF_index2009" {
		gen Name="GDP Defaltor"
		drop if gdpdef_nbd20090101==.
		rename gdpdef_nbd20090101 gdpdef
		drop month
	}
	
	else if "`file'"=="M2SL_Growth_monthly" {
		gen Name="Money Growth Rate"
		drop if m2sl_pc1==.
		rename m2sl_pc1 m2sl_growth
		drop month
	}
	
	else if "`file'"=="GS10_monthly" {
		gen Name="10-Year Treasury Bond"
		drop if gs10==.
		rename gs10 gs10
		drop month
	}
	
	else if "`file'"=="M1" {
		gen Name="M1"
		drop if m1==.
		egen max=max(date), by(year month)
		keep if max==date
		drop max date
		gen date=mdy(month,1, year)
		format date %td
		drop month 
		order date
		rename m1 amount
	}
	
	else if "`file'"=="M2" {
		gen Name="M2"
		drop if m2==.
		egen max=max(date), by(year month)
		keep if max==date
		drop max date
		gen date=mdy(month,1, year)
		format date %td
		drop month 
		order date
		rename m2 amount
	}
	
	else if "`file'"=="BOGMBASEW" {
		gen Name="Monetary Base"
		drop if bogmbasew==.
		replace bogmbasew= bogmbasew/1000
		egen max=max(date), by(year month)
		keep if max==date
		drop max date
		gen date=mdy(month,1, year)
		format date %td
		drop month 
		order date
		rename bogmbasew amount
	}
		
		
	else if "`file'"=="CURRCIR" {
		gen Name="Currency in Circulation"
		drop if currcir==.
		rename currcir amount
		drop month
	}
	
	else if "`file'"=="TCDNS" {
		gen Name="Checkable Deposits"
		drop if tcdns==.
	}
	
	else if "`file'"=="EXCSRESNS" {
		gen Name="Excess Reserves"
		drop if excsresns==.
		replace excsresns= excsresns/1000
		rename excsresns amount
		drop month
	}
	
	else if "`file'"=="TB3MS" {
		gen Name="3-Month Treasury Bill"
		drop if tb3ms==.
		drop month
	}
	
	
	save "${path}/`file'.dta", replace
}



use "${path}/GDPDEF_index2009.dta", clear
rename gdpdef index
rename Name Instrument
save "${path}/money_inflation.dta", replace

use "${path}/M2SL_index2009.dta", clear
rename m2sl index
rename Name Instrument
append using "${path}/money_inflation.dta"
save "${path}/money_inflation.dta", replace

use "${path}/M1.dta", clear
append using "${path}/BOGMBASEW.dta"
rename Name Instrument
save "${path}/MonetaryBase_Supply.dta", replace

use "${path}/CURRCIR.dta", clear
append using "${path}/EXCSRESNS.dta"
rename Name Instrument
merge m:1 date using "${path}/TCDNS.dta"
keep if _m==3
drop Name _m
replace amount=amount/tcdns
save "${path}/ExcessReserve_Currency.dta", replace



