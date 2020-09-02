/*
Applikation för att automatiskt klistra in en kommentar med datum och namn.
Skapad av Fredrik Harnevik i Auto Hot Key.
*/

;^+K:: ;kortkommando

;::mittnamn:: ;hotstring

::<namn:: ;hotstring

;Hämtar dagen
FormatTime, Day,, dd
	
;Hämtar månaden
FormatTime, Month,, MM

;Hämtar dagen
FormatTime, Year,, yyyy
	
;Hämtar namnet
IniRead, Name, %A_ScriptDir%\data\ahk_config.ini, CaseWorker, text
	
;Formaterar strängen som ska klistras in
CompleteString = %Year%-%Month%-%Day%:  /%Name% `n
IndexOfColon := (InStr(CompleteString, ":")) + 1

;Flyttar markören
SendInput, %CompleteString%
SendInput, {Home}
SendInput, {Up 1}
SendInput, {Right %IndexOfColon%}
return
