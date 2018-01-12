#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Initialize program variables.
Keys         := ["q", "w", "e", "r", "t"]
Delay         = 250 ; Should be no more than 1/4 of the breakpoint
PressDuration := (1000 / 60) ; Should be at least 1 frame in MS

; Start reading settings.ini.
SettingsFile = settings.ini

IniRead, SettingsKeys,          %SettingsFile%, Settings, Keys,          Error
IniRead, SettingsDelay,         %SettingsFile%, Settings, Delay,         Error
IniRead, SettingsPressDuration, %SettingsFile%, Settings, PressDuration, Error

if (SettingsKeys = "Error" or SettingsDelay = "Error" or SettingsPressDuration = "Error")
{
	; Write default settings.ini.
	SettingsKeys := []
	
	for index, element in Keys
	{
		SettingsKeys .= element ","
	}
	SettingsDelay         = %Delay%
	SettingsPressDuration = %PressDuration%
	
	IniWrite, % RTrim(SettingsKeys, ","), %SettingsFile%, Settings, Keys
	IniWrite, %SettingsDelay%,            %SettingsFile%, Settings, Delay
	IniWrite, %SettingsPressDuration%,    %SettingsFile%, Settings, PressDuration
}
else
{
	Keys         := StrSplit(SettingsKeys, ",")
	Delay         = %SettingsDelay%
	PressDuration = %SettingsPressDuration%
}

; Initialize AHK settings.
SetKeyDelay, %Delay%, %PressDuration%

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
	StringReplace, ThisHotkey, A_ThisHotkey, $
	
	; Press key
	;Send %ThisHotkey%
	Send {%ThisHotkey% DOWN}
	Sleep %A_KeyDuration%
	Send {%ThisHotkey% UP}
	Sleep (%A_KeyDelay% - %A_KeyDuration%)
Return
