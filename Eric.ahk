; Group Control For SmartWonder

#SingleInstance, force
GroupAdd, SmartWonder, VGHKS-
GroupAdd, SmartWonder, vghks-
GroupAdd, SmartWonder, tedpc-

; Global Variables
#Include MyScripts\vars.ahk

; Settings
;#Hotstring EndChars `t
#Hotstring O

; External Libraries
#Include <WBGet>
#Include <Paste>
#Include Lib\varExist.ahk

; Options
ENABLE_KEY_COUNTER := 1
PRESERVE_CLIPBOARD := 0

;; My Own Lib
#Include MyScripts\lib\frame-wait.ahk
#Include MyScripts\lib\supported-exam-patterns.ahk
#Include MyScripts\lib\date.ahk


; HotKeys
#Include MyScripts\hotkey\Click.ahk
#Include MyScripts\hotkey\click-confirm.ahk
#Include MyScripts\hotkey\AutoCheck.ahk
#Include MyScripts\hotkey\change-font.ahk
#Include MyScripts\hotkey\renumber-selected-text.ahk
#Include MyScripts\hotkey\detect-non-ascii-chars.ahk
#Include MyScripts\hotkey\set-predefined-exam-flow.ahk
#Include MyScripts\hotkey\get-previous-report.ahk
#Include MyScripts\hotkey\get-previous-report-with-images.ahk
#Include MyScripts\hotkey\get-previous-exam-date.ahk
#Include MyScripts\hotkey\delete-current-line.ahk
#Include MyScripts\hotkey\copy-order.ahk
#Include MyScripts\hotkey\click-none-tb-none-ot.ahk

#Include MyScripts\hotkey\AddCase.ahk
#Include MyScripts\hotkey\toggle-hanging-protocol.ahk



; #Include Add-Case.ahk

; Define hotkeys
#IfWinActive ahk_group SmartWonder

; 複製最近相關報告並開啟影像
^#!+space::
  ClickConfirm()
Return

#w:: 
  Click()
Return

!a::
  ;GetPreviousReport(true, true)
  GetPreviousReportWithImages(true, true, 1, false, false)
  ;GetPreviousReportWithImages(true, false, 1, false, false)
Return

+!a::
  GetPreviousReportWithImages(true, false, 1, false, false)
Return

!s::
  ClickConfirm()
Return

!d::
  Reload
  ;Click()
Return

!f::
  AutoCheck()
  ; Send {LCtrl down}{End}{LCtrl up}
  ; SetPredefinedExamFlow()
Return

::nic::
  StringWithPrevExamDateDelete("No obvious interval change as compared with previous study")
Return

; ::nid::
;   StringWithPrevExamDateDelete("No obvious interval change as compared with previous study")
; Return

::pc::
  StringWithPrevExamDateDelete("Progressive change as compared with previous study")
Return

::rc::
  StringWithPrevExamDateDelete("Regressive change as compared with previous study")
Return

!n::
  RenumberSeletedText()
Return

$^i::
  MyOrderDiag := CopyOrder()
  Paste(MyOrderDiag, 0)
Return
$^Del::
  DeleteCurrentLine()
Return



!t::
  ClickNoneTBNoneOt()	
Return

!v::
  MyOrderDiag := CopyOrder()
  Paste(MyOrderDiag, 0)
Return

!b::
  DeleteCurrentLine()
Return

#IfWinActive


!q::
; Send {Lalt}
send 4787
send {TAB}
sleep, 300
send qwe123123
sleep, 100
send {ENTER}
return

<^Left::Send, ^c
<^Right::Send, ^
#m:: Send, ^v


!w::
  AddCaseInfo()
Return
