#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Initialize AHK settings.
SetKeyDelay, 0

; Initialize program variables.
Keys         := ["q", "w", "e", "r", "t"]
PressDuration = 125 ; Should be between 1-125
WaitDuration  = 150 ; Should be no more than 275-PressDuration

; Start reading Settings.ini.
SettingsFile = settings.ini

IniRead, SettingsKeys,          %SettingsFile%, Settings, Keys,          Error
IniRead, SettingsPressDuration, %SettingsFile%, Settings, PressDuration, Error
IniRead, SettingsWaitDuration,  %SettingsFile%, Settings, WaitDuration,  Error

if (SettingsKeys = "Error" or SettingsPressDuration = "Error" or SettingsWaitDuration = "Error")
{
	; Write default Settings.ini.
	SettingsKeys := []
	
	for index, element in Keys
	{
		SettingsKeys .= element ","
	}
	SettingsPressDuration = %PressDuration%
	SettingsWaitDuration  = %WaitDuration%
	
	IniWrite, % RTrim(SettingsKeys, ","), %SettingsFile%, Settings, Keys
	IniWrite, %SettingsPressDuration%,    %SettingsFile%, Settings, PressDuration
	IniWrite, %SettingsWaitDuration%,     %SettingsFile%, Settings, WaitDuration
}
else
{
	Keys         := StrSplit(SettingsKeys, ",")
	PressDuration = %SettingsPressDuration%
	WaitDuration  = %SettingsWaitDuration%
}

; Set hotkeys.
for index, element in Keys ; Enumeration is the recommended approach in most cases.
{
	Hotkey, $%element%, Macro, Off
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
			}

			Active = 0
		}
	}
Return

; Hotkey function.
Macro:
	StringReplace, ThisHotkey, A_ThisHotkey, $
	Send {%ThisHotkey% DOWN}
	Sleep %PressDuration%
	Send {%ThisHotkey% UP}
	Sleep %WaitDuration%
Return
