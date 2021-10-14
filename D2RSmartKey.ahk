SetWorkingDir %A_ScriptDir%

IniRead, LeftClick, setting.ini, setting, LeftClick
IniRead, LeftShift, setting.ini, setting, LeftShift
IniRead, RightClick, setting.ini, setting, RightClick
IniRead, RightShift, setting.ini, setting, RightShift
IniRead, BuffKey, setting.ini, setting, BuffKey
IniRead, SwapKey, setting.ini, setting, SwapKey
IniRead, CallToKey, setting.ini, setting, CallToKey

Gui, Add, Button, x10 y10 w70 h20 vRunBtn gRunFunc , 실행
Gui, Add, Button, x90 y10 w70 h20 Disabled vPauseBtn gPauseFunc  , 정지
Gui, Add, Button, x220 y10 w70 h20 gSave, 설정 저장

Gui, Add, Text, x10 y40 w100 h20 0x200 +Center, LClick
Gui, Add, Edit, x110 y40 w180 h20 Uppercase vLeftClickE, %LeftClick%

Gui, Add, Text, x10 y70 w100 h20 0x200 +Center, LClick+Shift
Gui, Add, Edit, x110 y70 w180 h20 Uppercase vLeftShiftE, %LeftShift%

Gui, Add, Text, x10 y100 w100 h20 0x200 +Center, RClick
Gui, Add, Edit, x110 y100 w180 h20 Uppercase vRightClickE, %RightClick%

Gui, Add, Text, x10 y130 w100 h20 0x200 +Center, RClick+Shift
Gui, Add, Edit, x110 y130 w180 h20 Uppercase vRightShiftE, %RightShift%


Gui, Add, Text, x10 y160 w280 h20 0x200 +Center, Key Setting

Gui, Add, Text, x10 y190 w50 h20 0x200 +Center, Buff
Gui, Add, Edit, x70 y190 w75 h20 Uppercase vBuffE, %BuffKey%

Gui, Add, Text, x10 y220 w50 h20 0x200 +Center, Swap
Gui, Add, Edit, x70 y220 w75 h20 Uppercase vSwapE, %SwapKey%

Gui, Add, Text, x155 y220 w50 h20 0x200 +Center, CallTo
Gui, Add, Edit, x215 y220 w75 h20 Uppercase vCallToE, %CallToKey%

Gui, Show, w300 h250, D2R SmartKey

Suspend, on

Hotkey, Pause, PauseFunc
; Esc::ExitApp

Return

PauseFunc:
Suspend,Toggle

if (A_IsSuspended) {
    GuiControl, Disabled, PauseBtn
    GuiControl, Enabled, RunBtn
    GuiControl, Enabled, LeftClickE
    GuiControl, Enabled, LeftShiftE
    GuiControl, Enabled, RightClickE
    GuiControl, Enabled, RightShiftE
    GuiControl, Enabled, BuffE
    GuiControl, Enabled, SwapE
    GuiControl, Enabled, CallToE
}
else {
    Goto RunFunc
}
    
Return


RunFunc:
ExistKey := []
Loop, parse, LeftClickE, `,
    Hotkey, %A_LoopField%, Off, UseErrorLevel

Loop, parse, LeftShiftE, `,
    Hotkey, %A_LoopField%, Off, UseErrorLevel

Loop, parse, RightClickE, `,
    Hotkey, %A_LoopField%, Off, UseErrorLevel

Loop, parse, RightShiftE, `,
    Hotkey, %A_LoopField%, Off, UseErrorLevel

Hotkey, %BuffE% , Off, UseErrorLevel

Gui, Submit, NoHide

SetHotkey(LeftClickE, func("LClick"), ExistKey)
SetHotkey(LeftShiftE, func("ShiftLClick"), ExistKey )
SetHotkey(RightClickE, func("RClick"), ExistKey )
SetHotkey(RightShiftE, func("ShiftRClick"), ExistKey)

checkUsed(BuffE, ExistKey)
checkUsed(swapE, ExistKey)
checkUsed(CallToE, ExistKey)

buffFunc := Func("Buff").Bind(swapE, CallToE)


Hotkey, % BuffE, % buffFunc, UseErrorLevel
if not(ErrorLevel = 0){
    GuiControl, , BuffE,
}
else{
    Hotkey, %BuffE% , On
}


GuiControl, Enabled, PauseBtn
GuiControl, Disabled, RunBtn
GuiControl, Disabled, LeftClickE
GuiControl, Disabled, LeftShiftE
GuiControl, Disabled, RightClickE
GuiControl, Disabled, RightShiftE
GuiControl, Disabled, BuffE
GuiControl, Disabled, SwapE
GuiControl, Disabled, CallToE

Suspend, Off

Return

Save:
Gui, Submit, NoHide

IniWrite, %LeftClickE%, setting.ini, setting, LeftClick
IniWrite, %LeftShiftE%, setting.ini, setting, LeftShift
IniWrite, %RightClickE%, setting.ini, setting, RightClick
IniWrite, %RightShiftE%, setting.ini, setting, RightShift
IniWrite, %BuffE%, setting.ini, setting, BuffKey
IniWrite, %SwapE%, setting.ini, setting, SwapKey
IniWrite, %CallToE%, setting.ini, setting, CallToKey

GuiControl, , LeftClickE, %LeftClickE%
GuiControl, , LeftShiftE, %LeftShiftE%
GuiControl, , RightClickE, %RightClickE%
GuiControl, , RightShiftE, %RightShiftE%
GuiControl, , BuffE, %BuffE%
GuiControl, , SwapE, %SwapE%
GuiControl, , CallToE, %CallToE%


MsgBox, 저장됨.

Return

Buff(swap, callTo) {
    Send {%swap%}
    Loop, parse, callTo, `, 
    {
        Sleep, 100
        Send {%A_LoopField%}
        MouseClick, Right
    }
    Sleep, 400
    Send {%swap%}
}

LClick(){
    Send, {%A_ThisHotkey%}
    MouseClick, Left
}

ShiftLClick(){
    Send, {%A_ThisHotkey%}
    send, {ShiftDown}
    MouseClick, Left
    send, {ShiftUp}
}

RClick(){
    Send, {%A_ThisHotkey%}
    MouseClick, Right
}

ShiftRClick(){
    Send, {%A_ThisHotkey%}
    send, {ShiftDown}
    MouseClick, Right
    send, {ShiftUp}
}

SetHotkey(ByRef editer, func, ExistKey){
    tempEdit := editer
    Loop, parse, editer, `,
    {
        if not (hasValue(ExistKey, A_LoopField)){
            Hotkey, IfWinActive, ahk_exe D2R.exe
            Hotkey, % A_LoopField, %func%, UseErrorLevel
            if ErrorLevel in 2
                StringReplace, tempEdit, tempEdit, %A_LoopField%, , All
            else if ErrorLevel in 0
                Hotkey, %A_LoopField%, On
            ExistKey.Push(A_LoopField)
        }
        else{
            StringReplace, tempEdit, tempEdit, %A_LoopField%, , All
        }
    }
    GuiControl, , editer, % StringFormat(tempEdit)
}

StringFormat(string){
    while InStr(string, ",,"){
        StringReplace, string, string, `,`,, `,, All
    }

    if(inStr(SubStr(string, 0), ",")){
        string := SubStr(string, 1, StrLen(string)-1)
    }

    if(inStr(SubStr(string, 1,1), ",")){
        string := SubStr(string, 2, StrLen(string)-1)
    }

    return string
}

checkUsed(ByRef editer, ExistKey){
    tempEdit := editer
    Loop, parse, editer, `,
    {
        if not (hasValue(ExistKey, A_LoopField)){
            ExistKey.Push(A_LoopField)
        }
        else{
            StringReplace, tempEdit, tempEdit, %A_LoopField%, , All
        }
    }
    GuiControl, , editer, % StringFormat(tempEdit)
}

hasValue(array, value) {
    if(!isObject(array))
        return false
    if(array.Length()==0)
        return false
    for k,v in array
        if(v==value)
            return true
    return false
}

GuiClose:
ExitApp