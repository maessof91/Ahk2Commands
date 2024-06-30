#Requires AutoHotkey v2.0

; This file is for defining your computer specific paths.
; If you have multiple computers youd likely want to have a section for each.

; See Commands Grab_My_UserName and Grab_My_ComputerName

; Paths


global _nppPath := "C:\Program Files (x86)\Notepad++\notepad++.exe"
global _explorePath := "explorer.exe"

if(A_ComputerName == "DESKTOP-1234")
{
    global _nppPath := "C:\Program Files (x86)\Notepad++\notepad++.exe"
    global _explorePath := "explorer.exe"
}