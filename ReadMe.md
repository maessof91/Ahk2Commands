A simple command picker for ahk v2.

![24-06-30 12-57-22-362](https://github.com/maessof91/Ahk2Commands/assets/16782617/45a71d19-e46e-4594-a906-9f144040024b)

The idea is for this to serve as a template for your ahk hotkeys and commands.


-----------------
Installation
-----------------
1. Download ahk v2 at https://autohotkey.com/download/

2. Clone repo (or hit Code button > Download as zip)

---------------------
Usage
---------------------

1. double click ak2Commands.ahk 

2. Ctrl+Capslock to show gui

3. Type to filter commands

4. Enter or double click to execute selected command

----------------
Setup to run at startup
----------------
1. Create a shortcut to the ak2Commands.ahk script
2. open gui
3. search startup
4. execute the command to open the startup folder
5. move the shortcut to this folder
6. (Optional) right click shortcut > Properties > Advanced > Run As Admin > ok > Apply > ok

-----------------------
Best Practices
-----------------------
-Using this repo as a submodule to your own repo with your own ahk scripts is a better way to use it. See the submodule branch 

    #Include %A_ScriptDir%\..\Ahk2CommandsIncludes.ahk

 is used to include a script in a parent folder to the repo 


-But when using as a template Best to keep your ahk code seperate from the base folder. Keep them in  "%A_ScriptDir%\Included" as improvements and updates will happen to the base folder

