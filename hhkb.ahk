#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Docs:
; https://autohotkey.com/docs/Hotkeys.htm
; # = win
; ! = alt
; ^ = ctrl
; + = shift
; https://autohotkey.com/docs/KeyList.htm
; Ref https://autohotkey.com/board/topic/60675-osx-style-command-keys-in-windows/

; You need to disable "Between input languages" shotcut from Control Panel\Clock, Language, and Region\Language\Advanced settings > Change lanugage bar hot keys

; === hhkb start ===

; === Ctrl/Esc ===
~*LControl::
if !State {
  State := (GetKeyState("Alt", "P") || GetKeyState("Shift", "P") || GetKeyState("LWin", "P") || GetKeyState("RWin", "P"))
  ; For some reason, this code block gets called repeatedly when LControl is kept pressed.
  ; Hence, we need a guard around StartTime to ensure that it doesn't keep getting reset.
  ; Upon startup, StartTime does not exist thus this if-condition is also satisfied when StartTime doesn't exist.
  if (StartTime = "") {
    StartTime := A_TickCount
  }
}
return

$~LControl Up::
elapsedTime := A_TickCount - StartTime
if (  !State
   && (A_PriorKey = "LControl")
   && (elapsedTime <= 200)) {
  Send {Esc}
}
State     := 0
; We can reset StartTime to 0. However, setting it to an empty string allows it to be used right after first run
StartTime := ""
return

$`::Send {Delete}
$^`::Send {Ctrl Down}{Delete}{Ctrl Up}
$Esc::`
$!Esc::Send {Alt Down}{Shift Down}{Tab}{Shift Up}

; RAlt hjkl
$>!h::Send, {Left}
$>!j::Send, {Down}
$>!k::Send, {Up}
$>!l::Send, {Right}
$^>!h::Send, {Ctrl Down}{Left}{Ctrl Up}
$^>!j::Send, {Ctrl Down}{Down}{Ctrl Up}
$^>!k::Send, {Ctrl Down}{Up}{Ctrl Up}
$^>!l::Send, {Ctrl Down}{Right}{Ctrl Up}
$<!>!h::Send, {Home}
$<!>!j::Send, {Lctrl down}{End}{Lctrl up}
$<!>!k::Send, {Lctrl down}{Home}{Lctrl up}
$<!>!l::Send, {End}
$^+>!h::Send, {Ctrl Down}{Shift Down}{Left}{Ctrl Up}{Shift Up}
$^+>!j::Send, {Ctrl Down}{Shift Down}{Down}{Ctrl Up}{Shift Up}
$^+>!k::Send, {Ctrl Down}{Shift Down}{Up}{Ctrl Up}{Shift Up}
$^+>!l::Send, {Ctrl Down}{Shift Down}{Right}{Ctrl Up}{Shift Up}
$+>!l::Send, {Shift Down}{Right}{Shift Up}
$+>!h::Send, {Shift Down}{Left}{Shift Up}
$+>!j::Send, {Shift Down}{Down}{Shift Up}
$+>!k::Send, {Shift Down}{Up}{Shift Up}

; === macros ===
$>!p::Send, A4oharuftms{!}

; === hhkb end ===


; === App specific ===

#IfWinActive ahk_exe chrome.exe
; Get mac-like behavior for cmd+shft+arrow for moving tabs
$!+Left::Send ^+{Left}
$!+Right::Send ^+{Right}
$!+Up::Send ^+{Up}
$!+Down::Send ^+{Down}

; Reset settings for pycharm
; #If WinActive("ahk_exe pycharm64.exe") || WinActive("ahk_exe webstorm64.exe") || WinActive("ahk_exe phpstorm64.exe")
