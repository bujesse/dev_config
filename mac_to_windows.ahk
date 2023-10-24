; Profile stuff
Profile := 1 ; default
Count := 2

^Tab:: ; Ctrl+Tab to cycle through the profiles
	Profile := Profile = Count ? 1 : Profile + 1
	ToolTip, % "Profile " Profile
	SetTimer, ToolTipOff, -1000
return

ToolTipOff:
	ToolTip
return



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

; UK Specific
SC056::LShift


; === Universal shotcuts ===

Alt::Return

$!x::Send ^x
$!c::Send ^c
$!v::Send ^v
$!s::Send ^s
$!a::Send ^a
$!z::Send ^z
$!+z::Send ^y
$!w::Send ^w
$!f::Send ^f
$!n::Send ^n
$!q::Send !{f4}
$!r::Send ^{f5}
$!m::Send {LWin Down}{Down}{LWin Up}
$!`::Send {Alt Down}{Shift Down}{Tab}{Shift Up}

; === Quick Switch Tab shortcuts ===

$!1::Send ^1
$!2::Send ^2
$!3::Send ^3
$!4::Send ^4
$!5::Send ^5
$!6::Send ^6
$!7::Send ^7
$!8::Send ^8
$!9::Send ^9
$!0::Send ^0

; === Chrome shorttcuts ===

$!t::Send ^t
$!+t::Send ^+t
$!+]::Send {Ctrl Down}{Tab Down}{Tab Up}{Ctrl Up}
$!+[::Send {Ctrl Down}{Shift Down}{Tab Down}{Tab Up}{Shift Up}{Ctrl Up}
$!l::Send ^l
$![::Send {XButton1}
$!]::Send {XButton2}

; === navigation, selection, delete a word/till end ===

$!Left::Send {Home}
$!Right::Send {End}
$!Up::Send {Lctrl down}{Home}{Lctrl up}
$!Down::Send {Lctrl down}{End}{Lctrl up}

;$#Left::Send {ctrl down}{Left}{ctrl up}
;$#Right::Send {ctrl down}{Right}{ctrl up}
;$#+Left::Send {ctrl down}{shift down}{Left}{shift up}{ctrl up}
;$#+Right::Send {ctrl down}{shift down}{Right}{shift up}{ctrl up}

$!+Left::Send {shift down}{Home}{shift up}
$!+Right::Send {shift down}{End}{shift up}
$!+Up::Send {Ctrl Down}{shift down}{Home}{shift up}{Ctrl Up}
$!+Down::Send {Ctrl Down}{shift down}{End}{shift up}{Ctrl Up}

!BS::Send {LShift down}{Home}{LShift Up}{Del}
;#BS::Send {LCtrl down}{BS}{LCtrl up}
$^w::Send {Ctrl Down}{BS}{Ctrl Up}

$#Space::Send {Ctrl Down}{LWin Down}{Space}{LWin Up}{Ctrl Up}

; === Misc ===

; Send £ with RAlt+3
$>!3::Send {U+00A3}

/*
; Noop for LAlt by itself
$LAlt Up::
if (A_PriorKey = "LAlt") {
	return
}
return

; Noop for RAlt by itself
$RAlt Up::
if (A_PriorKey = "RAlt") {
	return
}
return
*/

; Search google for highlighted text (Usage:ctrl+shift+S)
^+s::
{
   Send, ^c
   Sleep 15
   Run, http://www.google.com/search?q=%Clipboard%
Return

}

/*
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

; === hhkb end ===
*/


; === App specific ===

#IfWinActive ahk_exe WindowsTerminal.exe
$!w::Send ^+w
$!t::Send ^+t
$!Down::Send !{Down}
$!Up::Send !{Up}
$!Right::Send !{Right}
$!Left::Send !{Left}
$!v::Send ^+v
$^v::Send ^v
$!f::Send ^+f
$^w::Send ^w
$!s::Send !s
$!c::Send !c
#BS::Send #BS
$!n::Send !n
$!x::Send !x

#IfWinActive ahk_exe chrome.exe
; Get mac-like behavior for cmd+shft+arrow for moving tabs
$!+Left::Send ^+{Left}
$!+Right::Send ^+{Right}
$!+Up::Send ^+{Up}
$!+Down::Send ^+{Down}

#IfWinActive ahk_exe alacritty.exe
$!w::Send ^+w
$!t::Send ^+t
$!Down::Send !{Down}
$!Up::Send !{Up}
$!Right::Send !{Right}
$!Left::Send !{Left}
$!c::Send ^+c
$!v::Send ^+v
$!f::Send ^+f

#IfWinActive ahk_exe Update.exe
$!Up::Send !{Up}
$!Right::Send !{Right}

; Reset settings for pycharm
#If WinActive("ahk_exe pycharm64.exe") || WinActive("ahk_exe webstorm64.exe") || WinActive("ahk_exe phpstorm64.exe")
$!w::Send !w
$!t::Send !t
$!Down::Send !{Down}
$!Up::Send !{Up}
$!Right::Send !{Right}
$!Left::Send !{Left}
$!r::Send !r
$!c::Send !c
$!v::Send !v
$!f::Send !f
$!n::Send !n
$!+z::Send !+z
$!+]::Send !+]
$!+[::Send !+[
$!1::Send !1
$!2::Send !2
$!3::Send !3
$!4::Send !4
$!5::Send !5
$!6::Send !6
$!7::Send !7
$!8::Send !8
$!9::Send !9
$!0::Send !0
$^w::Send ^w


#If Profile = 2
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

