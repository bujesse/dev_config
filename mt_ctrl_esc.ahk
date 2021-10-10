; This will allow you to
;  * Use CapsLock as Escape if it's the only key that is pressed and released within 300ms (this can be changed below)
;  * Use CapsLock as LControl when used in conjunction with some other key or if it's held longer than 300ms

~*LControl::
if !State {
  State := (GetKeyState("Alt", "P") || GetKeyState("Shift", "P") || GetKeyState("LWin", "P") || GetKeyState("RWin", "P"))
  if (StartTime = "") {
    StartTime := A_TickCount
  }
}
return

$~LControl Up::
elapsedTime := A_TickCount - StartTime
if (  !State
   && (A_PriorKey = "LControl")
   && (elapsedTime <= 300)) {
  Send {Esc}
}
State     := 0
StartTime := ""
return
