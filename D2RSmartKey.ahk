SetWorkingDir %A_ScriptDir%

IniRead, LeftClick, setting.ini, setting, LeftClick
IniRead, LeftShift, setting.ini, setting, LeftShift
IniRead, RightClick, setting.ini, setting, RightClick
IniRead, RightShift, setting.ini, setting, RightShift

Gui, Add, Button, x10 y10 w70 h20 vRunBtn gRunFunc , 실행
Gui, Add, Button, x90 y10 w70 h20 Disabled vPauseBtn gPauseFunc  , 정지
Gui, Add, Button, x220 y10 w70 h20 gSave, 설정 저장

Gui, Add, Text, x10 y40 w100 h20 0x200 +Center, LClick
Gui, Add, Edit, x110 y40 w180 h20 vLeftClickE, %LeftClick%

Gui, Add, Text, x10 y70 w100 h20 0x200 +Center, LClick+Shift
Gui, Add, Edit, x110 y70 w180 h20 vLeftShiftE, %LeftShift%

Gui, Add, Text, x10 y100 w100 h20 0x200 +Center, RClick
Gui, Add, Edit, x110 y100 w180 h20 vRightClickE, %RightClick%

Gui, Add, Text, x10 y130 w100 h20 0x200 +Center, RClick+Shift
Gui, Add, Edit, x110 y130 w180 h20 vRightShiftE, %RightShift%


Gui, Show, w300 h160, D2R SmartKey

Suspend, on

Hotkey, Pause, PauseFunc
; Esc::ExitApp

Return

PauseFunc:
Suspend,Toggle

if (A_IsSuspended) {
    GuiControl, Disabled, PauseBtn
    GuiControl, Enabled, RunBtn
}
else {
    Goto RunFunc
}
    
Return


RunFunc:
Loop, parse, LeftClickE, `,
    Hotkey, %A_LoopField%, Off, UseErrorLevel

Loop, parse, LeftShiftE, `,
    Hotkey, %A_LoopField%, Off, UseErrorLevel

Loop, parse, RightClickE, `,
    Hotkey, %A_LoopField%, Off, UseErrorLevel

Loop, parse, RightShiftE, `,
    Hotkey, %A_LoopField%, Off, UseErrorLevel

Gui, Submit, NoHide

tempEdit := LeftClickE
Loop, parse, LeftClickE, `,
{
    Hotkey, % A_LoopField, LClick, UseErrorLevel
    if ErrorLevel in 2
        StringReplace, tempEdit, tempEdit, %A_LoopField%, , All
    else if ErrorLevel in 0
        Hotkey, %A_LoopField%, On
}
GuiControl, , LeftClickE, %tempEdit%

tempEdit := LeftShiftE
Loop, parse, LeftShiftE, `,
{
    Hotkey, % A_LoopField, ShiftLClick, UseErrorLevel
    if ErrorLevel in 2
        StringReplace, tempEdit, tempEdit, %A_LoopField%, , All
    else if ErrorLevel in 0
        Hotkey, %A_LoopField%, On
}
GuiControl, , LeftShiftE, %tempEdit%


tempEdit := RightClickE
Loop, parse, RightClickE, `,
{
    Hotkey, % A_LoopField, RClick, UseErrorLevel
    if ErrorLevel in 2
        StringReplace, tempEdit, tempEdit, %A_LoopField%, , All
    else if ErrorLevel in 0
        Hotkey, %A_LoopField%, On
}
GuiControl, , RightClickE, %tempEdit%


tempEdit := RightShiftE
Loop, parse, RightShiftE, `,
{
    Hotkey, % A_LoopField, ShiftRClick, UseErrorLevel
    if ErrorLevel in 2
        StringReplace, tempEdit, tempEdit, %A_LoopField%, , All
    else if ErrorLevel in 0
        Hotkey, %A_LoopField%, On
}
GuiControl, , RightShiftE, %tempEdit%



GuiControl, Enabled, PauseBtn
GuiControl, Disabled, RunBtn

Suspend, Off

Return

Save:
Gui, Submit, NoHide

IniWrite, %LeftClickE%, setting.ini, setting, LeftClick
IniWrite, %LeftShiftE%, setting.ini, setting, LeftShift
IniWrite, %RightClickE%, setting.ini, setting, RightClick
IniWrite, %RightShiftE%, setting.ini, setting, RightShift

MsgBox, 저장됨.

Return

LClick(){
    Send, {%A_ThisHotkey%}
    If WinActive("Diablo II: Resurrected"){
        MouseClick, Left
    }
}

ShiftLClick(){
    Send, {%A_ThisHotkey%}
    If WinActive("Diablo II: Resurrected"){
        send, {ShiftDown}
        MouseClick, Left
        send, {ShiftUp}
    }
}

RClick(){
    Send, {%A_ThisHotkey%}
    If WinActive("Diablo II: Resurrected"){
        MouseClick, Right
    }
}

ShiftRClick(){
    Send, {%A_ThisHotkey%}
    If WinActive("Diablo II: Resurrected"){
        send, {ShiftDown}
        MouseClick, Right
        send, {ShiftUp}
    }
}

GuiClose:
ExitApp