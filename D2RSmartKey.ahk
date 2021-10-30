#NoTrayIcon 
#SingleInstance Off
#KeyHistory 0 
#NoEnv
#MaxHotkeysPerInterval, 2000

LOCAL_VERSION = 1.9

ListLines, Off 
SETCONTROLDELAY, -1
SetDefaultMouseSpeed, 1
SETWINDELAY, -1
SETKEYDELAY, -1
SETMOUSEDELAY, -1
SETBATCHLINES, -1

SetWorkingDir %A_ScriptDir%

IniRead, LeftClick, setting.ini, setting, LeftClick
IniRead, LeftShift, setting.ini, setting, LeftShift
IniRead, RightClick, setting.ini, setting, RightClick
IniRead, RightShift, setting.ini, setting, RightShift
IniRead, ShiftKey, setting.ini, setting, ShiftKey
IniRead, BuffKey, setting.ini, setting, BuffKey
IniRead, SwapKey, setting.ini, setting, SwapKey
IniRead, CallToKey, setting.ini, setting, CallToKey
IniRead, DelayTime, setting.ini, setting, DelayTime
IniRead, StartKey, setting.ini, setting, StartKey
IniRead, StopKey, setting.ini, setting, StopKey
IniRead, BindKey, setting.ini, setting, BindKey

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

Gui, Add, Text, x10 y160 w100 h20 0x200 +Center, Shift
Gui, Add, Edit, x110 y160 w180 h20 Uppercase vShiftE, %ShiftKey%

Gui, Add, Text, x10 y190 w100 h20 0x200 +Center, Bind
Gui, Add, Edit, x110 y190 w180 h20 Uppercase vBindE, %BindKey%

Gui, Add, Text, x10 y220 w280 h20 0x200 +Center, Buff Setting (Delay ms)

Gui, Add, Text, x10 y250 w50 h20 0x200 +Center, Buff
Gui, Add, Edit, x70 y250 w75 h20 Uppercase vBuffE, %BuffKey%

Gui, Add, Text, x155 y250 w50 h20 0x200 +Center, Delay
Gui, Add, Edit, x215 y250 w75 h20 Number vDelayE, %DelayTime%

Gui, Add, Text, x10 y280 w50 h20 0x200 +Center, Swap
Gui, Add, Edit, x70 y280 w75 h20 Uppercase vSwapE, %SwapKey%

Gui, Add, Text, x155 y280 w50 h20 0x200 +Center, CallTo
Gui, Add, Edit, x215 y280 w75 h20 Uppercase vCallToE, %CallToKey%

Gui, Add, Text, x10 y310 w280 h20 0x200 +Center, Global Setting

Gui, Add, Text, x10 y340 w50 h20 0x200 +Center, Start
Gui, Add, Edit, x70 y340 w75 h20 Uppercase vStartE, %StartKey%

Gui, Add, Text, x155 y340 w50 h20 0x200 +Center, Stop
Gui, Add, Edit, x215 y340 w75 h20 Uppercase vStopE, %StopKey%

Gui, Show, w300 h370, D2RSK %LOCAL_VERSION% by YouCha

Suspend, on

Hotkey, Pause, PauseFunc

Return

StartFunc:
Suspend, Off
Goto RunFunc
Return

PauseFunc:
Suspend,Toggle

if (A_IsSuspended) {
    PauseTool()
}
else {
    Goto RunFunc
}
    
Return


RunFunc:
for index, key in ExistKey
{
    Hotkey, IfWinActive, ahk_exe D2R.exe
    Hotkey, %key%, Off, UseErrorLevel

    Hotkey, IfWinActive
    Hotkey, %key%, Off, UseErrorLevel
}

ExistKey := []

Gui, Submit, NoHide

; checkUsed(LeftClickE, ExistKey)
; checkUsed(LeftShiftE, ExistKey)
; checkUsed(RightClickE, ExistKey)
; checkUsed(RightShiftE, ExistKey)

SetHotkey(ShiftE, func("Shift"), ExistKey)

SetCombineKey(BindE, ExistKey)

checkUsed(BuffE, ExistKey)
checkUsed(swapE, ExistKey)
; checkUsed(CallToE, ExistKey)
checkUsed(StartE, ExistKey)
checkUsed(StopE, ExistKey)

buffFunc := Func("Buff").Bind(swapE, CallToE, DelayE)

Hotkey, IfWinActive, ahk_exe D2R.exe
Hotkey, % BuffE, % buffFunc, UseErrorLevel
if not(ErrorLevel = 0){
    GuiControl, , BuffE,
}
else{
    Hotkey, %BuffE% , On
    ExistKey.Push(BuffE)

}

ResumeTool()

Sleep, 500

Loop
{
    DoKeyState(LeftClickE, func("LClick"))
    DoKeyState(LeftShiftE, func("ShiftLClick") )
    DoKeyState(RightClickE, func("RClick") )
    DoKeyState(RightShiftE, func("ShiftRClick"))

    if GetKeyState(StopE, "P") {
        PauseTool()
        break
    }

    if GetKeyState("PAUSE", "P") {
        PauseTool()
        break
    }

    if A_IsSuspended {
        PauseTool()
        break
    }

    Sleep, 10
}

Return

Save:
Gui, Submit, NoHide

IniWrite, %LeftClickE%, setting.ini, setting, LeftClick
IniWrite, %LeftShiftE%, setting.ini, setting, LeftShift
IniWrite, %RightClickE%, setting.ini, setting, RightClick
IniWrite, %RightShiftE%, setting.ini, setting, RightShift
IniWrite, %ShiftE%, setting.ini, setting, ShiftKey
IniWrite, %BuffE%, setting.ini, setting, BuffKey
IniWrite, %SwapE%, setting.ini, setting, SwapKey
IniWrite, %CallToE%, setting.ini, setting, CallToKey
IniWrite, %DelayE%, setting.ini, setting, DelayTime
IniWrite, %StartE%, setting.ini, setting, StartKey
IniWrite, %StopE%, setting.ini, setting, StopKey
IniWrite, %BindE%, setting.ini, setting, BindKey


GuiControl, , LeftClickE, %LeftClickE%
GuiControl, , LeftShiftE, %LeftShiftE%
GuiControl, , RightClickE, %RightClickE%
GuiControl, , RightShiftE, %RightShiftE%
GuiControl, , ShiftE, %ShiftE%
GuiControl, , BuffE, %BuffE%
GuiControl, , SwapE, %SwapE%
GuiControl, , CallToE, %CallToE%
GuiControl, , DelayE, %DelayE%
GuiControl, , StartE, %StartE%
GuiControl, , StopE, %StopE%
GuiControl, , BindE, %BindE%

MsgBox, 0x1000, , 저장됨.

Return

PauseTool() {
    global
    GuiControl, Disabled, PauseBtn
    GuiControl, Enabled, RunBtn
    GuiControl, Enabled, LeftClickE
    GuiControl, Enabled, LeftShiftE
    GuiControl, Enabled, RightClickE
    GuiControl, Enabled, RightShiftE
    GuiControl, Enabled, ShiftE
    GuiControl, Enabled, BuffE
    GuiControl, Enabled, SwapE
    GuiControl, Enabled, CallToE
    GuiControl, Enabled, DelayE
    GuiControl, Enabled, StartE
    GuiControl, Enabled, StopE
    GuiControl, Enabled, BindE

    Hotkey, IfWinActive
    Hotkey, %StartE%, StartFunc, UseErrorLevel
    if not(ErrorLevel = 0){
        GuiControl, , StartE,
    }
    else{
        Hotkey, %StartE% , On
        ExistKey.Push(StartE)
    }

    Suspend, On
}

SetCombineKey(ByRef editer, ExistKey) {
    tempEdit := editer
    Loop, parse, editer, `/
    {
        chunk := StrSplit(A_LoopField, ",")
        keyButton := chunk[1]

        func := func("SendKeys").bind(chunk)
        if not (hasValue(ExistKey, keyButton)){
            Hotkey, IfWinActive, ahk_exe D2R.exe
            Hotkey, % keyButton, %func%, UseErrorLevel
            if ErrorLevel in 2
                StringReplace, tempEdit, tempEdit, %A_LoopField%, , All
            else if ErrorLevel in 0
                Hotkey, %keyButton%, On
                ExistKey.Push(keyButton)
        }
        else{
            StringReplace, tempEdit, tempEdit, %A_LoopField%, , All
        }
    }

    GuiControl, , editer, % StringFormat(tempEdit)
}

SendKeys(chunk) {
    for index, key in chunk
        Send, {%key%}
}

ResumeTool() {
    global
    GuiControl, Enabled, PauseBtn
    GuiControl, Disabled, RunBtn
    GuiControl, Disabled, LeftClickE
    GuiControl, Disabled, LeftShiftE
    GuiControl, Disabled, RightClickE
    GuiControl, Disabled, RightShiftE
    GuiControl, Disabled, ShiftE
    GuiControl, Disabled, BuffE
    GuiControl, Disabled, SwapE
    GuiControl, Disabled, CallToE
    GuiControl, Disabled, DelayE
    GuiControl, Disabled, StartE
    GuiControl, Disabled, StopE
    GuiControl, Disabled, BindE

    Suspend, Off
}

Buff(swap, callTo, Delay) {
    Send, {%swap%}
    Loop, parse, callTo, `, 
    {
        Sleep, Delay
        Send, {%A_LoopField%}
        Send, {RButton down}
        Send, {RButton up}
    }
    Sleep, Delay
    Send, {%swap%}
}

LClick(){
    MOUSECLICK , LEFT,
}

ShiftLClick(){
    Send, {Shift down}
    MOUSECLICK , LEFT,
    Send, {Shift up}
}

RClick(){
    MOUSECLICK , RIGHT,
}

ShiftRClick(){
    Send, {Shift down}
    MOUSECLICK , RIGHT,
    Send, {Shift up}
}

Shift(){
    Send, {Shift down}
    Send, {%A_ThisHotkey%}
    Send, {Shift up}
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

DoKeyState(ByRef editer, func) {
    Loop, parse, editer, `,
    {
        IfWinActive ahk_exe D2R.exe
        if GetKeyState(A_LoopField, "P"){
            %func%()
        }
    }
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

    if(inStr(SubStr(string, 0), "/")){
        string := SubStr(string, 1, StrLen(string)-1)
    }

    if(inStr(SubStr(string, 1,1), "/")){
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