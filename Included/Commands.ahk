#Requires AutoHotkey v2.0

AddCommand("Reload","Reload")
Reload_ahk2Commands()
{
  Reload ; Reload so that any changes can be loaded in
}

AddCommand("Grab_My_ComputerName","Grab_My_ComputerName")
Grab_My_ComputerName()
{
   MsgBox A_ComputerName . " " . "coppied to clipboard"
   A_Clipboard := A_ComputerName ; Put it in clipboard ready to paste
}

AddCommand("Grab_My_UserName","explore_Startup_Folder")
Grab_My_UserName()
{
   MsgBox A_UserName . " " . "coppied to clipboard"
   A_Clipboard := A_UserName ; Put it in clipboard ready to paste
}

AddCommand("Explore_Startup_Folder","Explore_Startup_Folder")
Explore_Startup_Folder()
{
   Run("shell:Startup")
}