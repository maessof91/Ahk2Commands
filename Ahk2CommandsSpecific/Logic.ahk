#Requires AutoHotkey v2.0


global allCommands
SortArrayByAscendingLength(allCommands)

global MyGui := Gui("+Resize")
MyGui.SetFont("q4 s14", "Arial")
MyGui.Add("Text", , "Search:")

global EditGui
EditGui := MyGui.Add("Edit", "vSearchInput w600", "")
EditGui.OnEvent("Change", (*) => UpdateList(EditGui))

global listView
listView := MyGui.Add("ListView", "r5 w600 h350", ["Name"])
listView.OnEvent("DoubleClick", OnListViewItemDoubleClick)
listView.OnEvent("ItemSelect", onCommandSelected)
listView.Opt("+BackgroundA0A0F0 +Grid +NoSort")

for command in allCommands {
    listView.Add("", command)
}

MyGui.Hide()

MyGui.OnEvent("Close", (*) => MyGui.Hide())
MyGui.OnEvent("Escape", (*) => MyGui.Hide())


HideGui() {
    MyGui.Hide()
}

ShowGui() {
    global EditGui
    MyGui.Show()
    EditGui.Value := "" 
    EditGui.Focus()    
}

UpdateList(Edit) {
    global allCommands, listView, filteredCommands
    searchValue := Edit.Value
    
    listView.Delete()  ; Clear the ListView
    for command in allCommands {
        if (searchValue == "" || InStr(command, searchValue, false)) 
        {    
            listView.Add("", command)
        }
    }
    
    listView.Modify(1, "+Select")
    global selectedIndex
    selectedIndex := 1
}

ExecuteSelectedCommand()
{       
    CallSelectedCommand()
}

global selectedIndex:= 1
onCommandSelected(GuiCtrlObj, Item, Selected)
{
    global selectedIndex
    selectedIndex := Item
    command := listView.GetText(selectedIndex)
    ToolTip(command)
    SetTimer () => ToolTip(), -500

}

CallSelectedCommand() 
{
    global selectedIndex
    global listView
    
    if (listView.GetCount() > 0) 
    {
        MyGui.Hide()
        selectedCommand := listView.GetText(selectedIndex)
        ToolTip("Executing " . selectedCommand)
        SetTimer () => ToolTip(), -2000
        %selectedCommand%()
    } 
    else 
    {
        ; Do nothing if list is empty
    }
}

OnListViewItemDoubleClick(listview, rowNumber)
{
    MyGui.Hide()
    rowText := listview.GetText(rowNumber)    
    ToolTip("Executing " . rowText)
    SetTimer () => ToolTip(), -2000
    %rowText%()
}

Add(function)
{
    global allCommands
    allCommands.Push(function.Name)
}

AddCommand(function,description)
{
    global allCommands
    allCommands.Push(function)
}

;using the ` key when their is a bug message will open the line of code where the error is, and paste the error message
#hotif WinActive("Ahk2Commands.ahk") && WinActive("ahk_class #32770") && WinActive("ahk_exe AutoHotkey64.exe")
`::
{
    ControlFocus("RichEdit20W1", "ahk_class #32770")
    Send("^a")
    Send("^c")
    Sleep 300
    clipboard := A_Clipboard

    errorMessage := RegExReplace(clipboard,"^(.*?)\r?\n[\s\S]*","$1")
    ; MsgBox errorMessage

    file := RegExReplace(clipboard,"[\s\S]*----\s*(.*?)\r?\n[\s\S]*","$1")
    ; MsgBox file

    lineNo := RegExReplace(clipboard,"[\s\S]*\r?\n\S[ \t]+(\d+)[\s\S]*","$1")
     ;MsgBox lineNo


    If InStr(clipboard, "----")
    {
        WinActivate("ahk_exe Code.exe")

            Send("^o")
            A_Clipboard := file
            Sleep 800
            Send("^v")
            Send("{enter}")
            Sleep 800
            Send("^g")
            Sleep 800
            Send(lineNo)
            Sleep 800
            Send("{enter}")
            Sleep 800

            Send("{End}")
            Send("{End}")

            Send("  `; " . errorMessage)
    }  
}
#hotif