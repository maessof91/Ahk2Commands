#Requires AutoHotkey v2.0

Template(&template1234,templateArea,value)
{
    template1234 := StrReplace(template1234 ,"{" . templateArea . "}", value)
}

SortArrayByAscendingLength(arrayi) 
{
    x := 0
    Loop 
    {
        x++
        swapped := false
        y := 0
        Loop 
        {
            y++
            if (y + 1 > arrayi.Length)
                break
            if (StrLen(arrayi[y + 1].name) < StrLen(arrayi[y].name))   ; Error: P
            {
                ; Swap the elements
                temp := arrayi[y]
                arrayi[y] := arrayi[y + 1]
                arrayi[y + 1] := temp
                swapped := true
            }
        } Until y + 1 > arrayi.Length
        if (!swapped)
            break
    } Until x > arrayi.Length
    return arrayi
}

; TestTempalte()
; {
;     Folder := "Temp"
;     clipboard := "C:/Temp"
;     templatev := "
;     (
;     AddCommand("e{Folder}","e{Folder}")
;     e{Folder}()
;     {
;         Run(explore "{clipboard}")  
;     }
;     )"
    
;     Template(&templatev,"Folder",Folder)
;     Template(&templatev,"clipboard",clipboard)
    
;     MsgBox templatev
; }
; TestTempalte()