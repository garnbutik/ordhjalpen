#Include %A_ScriptDir%\libs\JSON.ahk
PREFIX_FOR_HOTSTRING_WITH_DOT := "::."
PREFIX_FOR_HOTSTRING_WITHOUT_DOT := "::"

FileRead jsonString, %A_AppData%\Ordhjalpen\data\wordData.json

IniRead, USE_DOT, %A_AppData%\Ordhjalpen\data\ahk_config.ini, UseDotForAbbreviation, useDot


Data := JSON.Load(jsonString)

If % USE_DOT = true {
	For key, value in Data {
		keyWithPrefix := PREFIX_FOR_HOTSTRING_WITH_DOT key
		Hotstring(keyWithPrefix, value, 1)
	}
}

else {
	For key, value in Data {
		keyWithPrefix := PREFIX_FOR_HOTSTRING_WITHOUT_DOT key
		Hotstring(keyWithPrefix, value, 1)
	}
}