#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Initialize AHK settings.
SetKeyDelay, 0

; Initialize program variables.
Keys         := ["q", "w", "e", "r", "t"]
SleepDuration  = 275 ; Should be no more than 275-PressDuration

; Start reading Settings.ini.
SettingsFile = settings.ini

IniRead, SettingsKeys,          %SettingsFile%, Settings, Keys,          Error
IniRead, SettingsSleepDuration,  %SettingsFile%, Settings, SleepDuration,  Error

if (SettingsKeys = "Error" or SettingsPressDuration = "Error" or SettingsWaitDuration = "Error")
{
	; Write default Settings.ini.
	SettingsKeys := []
	
	for index, element in Keys
	{
		SettingsKeys .= element ","
	}
	SettingsPressDuration = %PressDuration%
	SettingsSleepDuration  = %SleepDuration%
	
	IniWrite, % RTrim(SettingsKeys, ","), %SettingsFile%, Settings, Keys
	IniWrite, %SettingsSleepDuration%,     %SettingsFile%, Settings, SleepDuration
}
else
{
	Keys         := StrSplit(SettingsKeys, ",")
	SleepDuration  = %SettingsSleepDuration%
}

; Set hotkeys.
for index, element in Keys
{
	Hotkey, $%element%, Macro, Off
	Hotkey, $+%element%, Macro, Off
}

Active = 0

; Main loop.
Loop
	if WinActive("Path of Exile")
	{
		if Active = 0
		{
			for index, element in Keys
			{
				Hotkey, $%element%, On
				Hotkey, $+%element%, On
			}
			
			Active = 1
		}
		
	}
	Else
	{
		if Active = 1
		{
			for index, element in Keys
			{
				Hotkey, $%element%, Off
				Hotkey, $+%element%, Off
			}

			Active = 0
		}
	}
Return

; Hotkey function.
Macro:
	; Prepare key for sending
	StringReplace, ThisHotkey, A_ThisHotkey, $
	
	; Press key
	Send %ThisHotkey%
	
	; Sleep for duration
	Sleep %SleepDuration%	
Return
