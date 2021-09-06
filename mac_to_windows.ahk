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

; === Universal shotcuts ===

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

$#Left::Send {ctrl down}{Left}{ctrl up}
$#Right::Send {ctrl down}{Right}{ctrl up}
$#+Left::Send {ctrl down}{shift down}{Left}{shift up}{ctrl up}
$#+Right::Send {ctrl down}{shift down}{Right}{shift up}{ctrl up}

$!+Left::Send {shift down}{Home}{shift up}
$!+Right::Send {shift down}{End}{shift up}
$!+Up::Send {Ctrl Down}{shift down}{Home}{shift up}{Ctrl Up}
$!+Down::Send {Ctrl Down}{shift down}{End}{shift up}{Ctrl Up}

!BS::Send {LShift down}{Home}{LShift Up}{Del}
#BS::Send {LCtrl down}{BS}{LCtrl up}

$#Space::Send {Ctrl Down}{LWin Down}{Space}{LWin Up}{Ctrl Up}

; === Misc ===

; Send £ with RAlt+3
$>!3::Send {U+00A3}

; === App specific ===

#IfWinActive ahk_exe WindowsTerminal.exe
$!w::Send ^+w
$!t::Send ^+t
$!Down::Send !{Down}
$!Up::Send !{Up}
$!Right::Send !{Right}
$!Left::Send !{Left}
$!c::Send ^+c
$!v::Send ^+v
$!f::Send ^+f

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
