#SingleInstance force
#Include %A_ScriptDir%\libs\JSON.ahk

MIN_CHARS_IN_ABBR := 2 ; minimum number of characters in the abbrevation for hotstrings
MIN_CHARS_IN_WORD := 3 ; minimum number of characters in the replacement word for hotstrings
SCRIPT_EXE_FILE := "wordUtils.exe"

Gui, MainScreen:New
Gui, MainScreen:Default

/*
Gui section for starting and stopping script 
*/
Gui, Font, w700 s10 ; Setting new font size
Gui, MainScreen:Add, Text,, Starta/stoppa
Gui, Font, ; resetting font to default
Gui, MainScreen:Add, Button, gReloadScript, Starta/ladda om skript
Gui, MainScreen:Add, Button, gExitScript , Avsluta skript

Gui, MainScreen:Add, Text,, ;Spacer between controls

/*
Gui section for handling name for comments
*/
Gui, Font, w700 s10 ; Setting new font size
Gui, MainScreen:Add, Text,, Hantera namn
Gui, Font, ; resetting font to default
Gui, MainScreen:Add, Text,, Text till namn
Gui, MainScreen:Add, Edit, vCommentName
Gui, MainScreen:Add, Button, gSaveNameButtonAction, Spara text

/*
Gui section for wordlist
*/
Gui, Font, w700 s10 ; Setting new font size
Gui, MainScreen:Add, Text, ym Section, Ordlista ;New column
Gui, Font, ; resetting font to default
Gui, MainScreen:Add, ListView, r15 w325 0x4 0x10 -LV0x10 Grid, Förkortning|Ord
Gui, MainScreen:Add, Button, gDeleteButtonAction, Radera

/*
Gui section for adding new words
*/
Gui, MainScreen:Add, Text, ym Section, 
Gui, Font, w600 ; Setting new font size
Gui, MainScreen:Add, Text,, Lägg till nytt ord
Gui, Font, ; resetting font to default
Gui, MainScreen:Add, Text,, Förkortning
Gui, MainScreen:Add, Edit, vInputAbbrevation, ;input field for abbrevation for hotstrings
Gui, MainScreen:Add, Text,, Ord
Gui, MainScreen:Add, Edit, vInputWord, ;input field for word for hotstrings
Gui, MainScreen:Add, Button, gAddButtonAction, Lägg till ord

Gui, MainScreen:Add, Text,, ;Spacer between controls

/*
Gui section for changing value for using dot before abbrevation
*/
Gui, Font, w600 ; Setting new font size
Gui, MainScreen:Add, Text,, Använd punkt?
Gui, Font, ; resetting font to default
IniRead, USE_DOT, %A_ScriptDir%\data\ahk_config.ini, UseDotForAbbreviation, useDot
If % USE_DOT = true {
	Gui, Add, CheckBox, vUseDotVariable Checked gUseDotFunction,  Vill du använda punkt före `n förkortningen?
}
else {
	Gui, Add, CheckBox, vUseDotVariable gUseDotFunction,  Vill du använda punkt före `n förkortningen?
}

/*
Menubar 
*/
Menu, FileMenu, Add, &Starta/Ladda om skript, ReloadScript
Menu, FileMenu, Add, &Avsluta skript, ExitScript
Menu, FileMenu, Add
Menu, FileMenu, Add, &Avsluta program, ExitApplication
Menu, HelpMenu, Add, &Hjälp, HelpAbout

; Create the menu bar by attaching the sub-menus to it:
Menu, MyMenuBar, Add, &Arkiv, :FileMenu
Menu, MyMenuBar, Add, &Om, :HelpMenu

; Attach the menu bar to the window:
Gui, Menu, MyMenuBar


/*
Inits the list of hostrings
*/
Data := LoadData()
For key, value in Data{
	LV_Add("", key, value)
}

/*
Inits field for case worker
*/
IniRead, name, %A_ScriptDir%\data\ahk_config.ini, CaseWorker, text 
GuiControl, Text, CommentName, %name%

Gui, MainScreen:Show, , Ordhjälpen - Inställningar

return

/*
Handling the save new hotstring button
*/
AddButtonAction:
	Gui, Submit, NoHide
	if ( StrLen(InputAbbrevation) < MIN_CHARS_IN_ABBR ) {
		MsgBox, 8208, Fel!, Du måste ange minst två bokstäver i förkortningen.
		GuiControl, Focus, InputAbbrevation
	} else if ( StrLen(InputWord) < MIN_CHARS_IN_WORD ) {
		MsgBox, 8208, Fel!, Du måste ange minst tre bokstäver i ordet.
		GuiControl, Focus, InputWord
	} else {
	AddToListView(InputAbbrevation, InputWord)
	SaveData(InputAbbrevation, InputWord)
	GuiControl, Focus, InputAbbrevation
	Run, % SCRIPT_EXE_FILE
	}
	return

/*
Adding new hotstring to list view
*/
AddToListView(newKey, newValue){
	LV_Add("", newKey, newValue)
	GuiControl, , InputAbbrevation
	GuiControl, , InputWord
	return
}

/*
Saving new hotstring to data file. 
Loads the data, inserts the new hotstring, deletes the file and saves a new version of the file.
*/
SaveData(newKey, newValue){
	Data := LoadData()
	Data.Insert(newKey, newValue)
	newJsonString := JSON.Dump(Data)
	FileDelete, %A_ScriptDir%\data\wordData.json
	FileAppend, %newJsonString%, %A_ScriptDir%\data\wordData.json, UTF-8
	return
}

/*
Deletes hotstring from data file. 
Loads the data, deletes the hotstring, deletes the file and saves a new version of the file.
*/
DeleteData(keyToDelete){
	Data := LoadData()
	Data.Delete(keyToDelete)
	newJsonString := JSON.Dump(Data)
	FileDelete, %A_ScriptDir%\data\wordData.json
	FileAppend, %newJsonString%, %A_ScriptDir%\data\wordData.json, UTF-8
	return
}

DeleteButtonAction:
	rowNumber := LV_GetNext()
	LV_GetText(keyFromRow, rowNumber)
	DeleteData(keyFromRow)
	LV_Delete(rowNumber)
	Run, % SCRIPT_EXE_FILE
	return

SaveNameButtonAction:
	Gui, Submit, NoHide
	IniWrite, %CommentName%, %A_ScriptDir%\data\ahk_config.ini, CaseWorker, text
	MsgBox, 8256, Information, Du sparade %CommentName% som text.
			GuiControl, Focus, CommentName

	return

LoadData(){
	FileRead jsonString, %A_ScriptDir%\data\wordData.json
	LoadedData := JSON.Load(jsonString)
	return LoadedData
}

UseDotFunction:
	Gui, Submit, NoHide
	if % UseDotVariable = 1 {	
		IsChecked := true
	}
	else {
		IsChecked := false

	}
	IniWrite, %IsChecked%, %A_ScriptDir%\data\ahk_config.ini, UseDotForAbbreviation, useDot
	Run, % SCRIPT_EXE_FILE

ExitScript:
	Process, Close, % SCRIPT_EXE_FILE
	return

ExitApplication:
	ExitApp

ReloadScript:
	Run, % SCRIPT_EXE_FILE
	return
	
HelpAbout:
	Run, %A_ScriptDir%\data\Ordhjälpen_V2.pdf
	return

MainScreenGuiClose:
ExitApp