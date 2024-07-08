#Requires AutoHotkey v2.0


global allCommands
SortArrayByAscendingLength(allCommands)

global MyGui := Gui("+Resize +AlwaysOnTop")
MyGui.SetFont("q4 s14", "Arial")
MyGui.Add("Text", , "Search:")

global EditGui
EditGui := MyGui.Add("Edit", "vSearchInput w600", "")
EditGui.OnEvent("Change", (*) => onSearchEdit(EditGui))

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
    UpdateList("")
    EditGui.Focus()    
}

onSearchEdit(Edit)
{
    UpdateList(Edit.Value)
}

UpdateList(searchValue) {
    global allCommands, listView, filteredCommands    

    listView.Delete()  ; Clear the ListView
    for command in allCommands {
        if (searchValue == "" || InStr(command.name, searchValue, false))   
        {    
            listView.Add("", command.name)
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
    if(Selected)
    {
        global selectedIndex
        selectedIndex := Item
        command := listView.GetText(selectedIndex)

        foundCommand := findCommand(command)
        
        description := foundCommand.description

        ToolTip(description)
        SetTimer () => ToolTip(), -500
    }
}

SelectNext()
{
    global selectedIndex
    if(selectedIndex<listView.GetCount())
    {
        listView.Modify(selectedIndex, "-Select")
        listView.Modify(selectedIndex+1, "+Select")
        selectedIndex++
    }
}

SelectPrevious()
{
    global selectedIndex
    if(selectedIndex>1)
    {
        listView.Modify(selectedIndex, "-Select")
        listView.Modify(selectedIndex-1, "+Select")        
        selectedIndex--
    }
}

CallSelectedCommand() 
{
    global selectedIndex
    global listView
    
    if (listView.GetCount() > 0) 
    {
        MyGui.Hide()
        selectedCommand := listView.GetText(selectedIndex)

        foundCommand := findCommand(selectedCommand)
        description := foundCommand.description
        ToolTip("Executing " . description) 
        SetTimer () => ToolTip(), -2000        
        foundCommand.Execute()
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
    foundCommand := findCommand(rowText)   
    description := foundCommand.description
    ToolTip("Executing " . description)
    SetTimer () => ToolTip(), -2000
    
    foundCommand.Execute()
}


Add(function)
{
    global allCommands

    command := CommandClass(function.Name,function.Name,function.Name)

    allCommands.Push(command)
}

AddCommand(function,description)
{
    global allCommands

    command := CommandClass(function,function,description)

    allCommands.Push(command)
}


AddCommandWithParam("SayHello","Say","Will say word","Hello") 
AddCommandWithParam("SayBye","Say","Will say word","Bye")
AddCommandWithParam(commandName, functionName,description,parameter)
{
    global allCommands
    command := CommandClass(commandName, functionName, description, [parameter])
    allCommands.Push(command)
}

AddCommandWithTwoParams(commandName, functionName,description,parameter1,parameter2)
{
    global allCommands
    command := CommandClass(commandName, functionName, description, [parameter1,parameter2])
    allCommands.Push(command)
}

AddCommandWithThreeParams(commandName, functionName,description,parameter1,parameter2,parameter3)
{
    global allCommands
    command := CommandClass(commandName, functionName, description, [parameter1,parameter2,parameter3])
    allCommands.Push(command)
}

AddCommandWithParameters(commandName, functionName, description := "",parameters := [])
{
    if(description == "")
    {
        description := commandName
    }

    global allCommands
    command := CommandClass(commandName, functionName, description, parameters)
    allCommands.Push(command)
}

Say(param)
{
    MsgBox param
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

findCommand(commandName)
{
    global allCommands
    
    i := 1
    Loop 
        {
            if(allCommands[i].name == commandName)
            {
                return allCommands[i]
            }
            i++           
        } Until i > allCommands.Length
}


class CommandClass {
    ; Constructor
    __New(name:="", functionName:="", description:="", parameters := [])
    {
        this.name := name
        this.functionName := functionName
        this.description := description
        this.parameters := parameters
    }

    Execute()
    {
        if(this.parameters.Length == 0)
        {
            %this.functionName%()
        }
        else
        if(this.parameters.Length == 1)
        {
            %this.functionName%(this.parameters[1])
        }
        else
        if(this.parameters.Length == 2)
        {
            %this.functionName%(this.parameters[1],this.parameters[2])
        }
        else
        if(this.parameters.Length == 3)
        {
            %this.functionName%(this.parameters[1],this.parameters[2],this.parameters[3])
        }
    }
}