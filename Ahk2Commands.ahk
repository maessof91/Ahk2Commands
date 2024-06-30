#Requires AutoHotkey v2.0
#SingleInstance
Persistent

global allCommands :=  [] ;The list of commands will be added to here using the Add functions

#Include %A_ScriptDir%\Ahk2CommandsSpecific\Utility.ahk

#Include %A_ScriptDir%\Included\Includes.ahk

#Include %A_ScriptDir%\Ahk2CommandsSpecific\Logic.ahk

; keycombo to trigger gui is currently ctrl+capslock
^CapsLock:: 
{
    ShowGui()
}

; keycombo to except selected command is either enter,alt+2 or F16+2 (Mouse extra keys can often be configured to F13-F24 keys)
#hotif WinActive("Ahk2Commands.ahk") && WinActive("ahk_exe AutoHotkey64.exe")
    Enter::
    NumpadEnter::
    !2::
    F16 & 2::
    {
        ExecuteSelectedCommand()
    }
#hotif

#hotif WinActive("Ahk2Commands.ahk") && WinActive("ahk_exe AutoHotkey64.exe")
    Escape::
    {
        HideGui()
    }
#hotif




