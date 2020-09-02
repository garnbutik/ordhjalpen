
::<nu::
	;Hämtar dagen
	FormatTime, Day,, dd
	Day := FormatDay(Day)
	
	;Hämtar månaden
	FormatTime, Month,, MM
	monthString := GetMonth(Month)

	;Hämtar dagen
	FormatTime, Year,, yyyy
	SendInput %Day% %monthString% %Year%
	return

::<komp::
	newDate := %A_Now%
	IniRead, DAYS_TO_ADD, %A_ScriptDir%\data\ahk_config.ini, DaysToAdd, numberOfDays
	EnvAdd, newDate, %DAYS_TO_ADD%, days

	kompYear := SubStr(newDate, 1, 4) ;Get year
	kompMonth := SubStr(newDate, 5, 2) ;Get month
	kompMonthString := GetMonth(kompMonth)
	kompDay := SubStr(newDate, 7, 2)
	kompDay := FormatDay(kompDay)
	SendInput %kompDay% %kompMonthString% %kompYear%
	return

FormatDay(day){
	if (SubStr(day, 1, 1) = 0){
		return SubStr(day, 2, 1)
	} else {
		return %day%
	}
}

GetMonth(month)
{
	Switch month
	{
	Case 01: 
		return "januari"
	Case 02:
		return "februari"
	Case 03: 
		return "mars"
	Case 04:
		return "april"
	Case 05:
		return "maj"
	Case 06:
		return "juni"
	Case 07:
		return "juli"
	Case 08:
		return "augusti"
	Case 09:
		return "september"
	Case 10:
		return "oktober"
	Case 11:
		return "november"
	Case 12:
		return "december"
	default:
		return "error!"
	}
}