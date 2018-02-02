; Group Control For SmartWonder
GroupAdd, SmartWonder, VGHKS-
GroupAdd, SmartWonder, vghks-
GroupAdd, SmartWonder, tedpc-

; Global Variables

; Settings
#Hotstring EndChars `t
#Hotstring O

; External Libraries
#Include <WBGet>
#Include <Paste>

;; My Own Lib
#Include MyScripts\lib\frame-wait.ahk
#Include MyScripts\lib\date.ahk
#Include MyScripts\lib\supported-exam-patterns.ahk

#IfWinActive ahk_group SmartWonder
  ;;; HotStrings
#Include MyScripts\neuro.ahk
#IfWinActive

; HotKeys
#Include MyScripts\hotkey\Click.ahk
#Include MyScripts\hotkey\change-font.ahk
#Include MyScripts\hotkey\copy-order.ahk
#Include MyScripts\hotkey\insert-patient-exam-info.ahk
#Include MyScripts\hotkey\renumber-selected-text.ahk
#Include MyScripts\hotkey\toggle-hanging-protocol.ahk
#Include MyScripts\hotkey\get-previous-report-with-images.ahk

; Define hotkeys
#IfWinActive ahk_group SmartWonder

; CopyIndication
$^i::
  MyOrderDiag := CopyOrder()
  Paste(MyOrderDiag, 0)
Return

!q::
InputBox, UserInput, Calculate Volume, Input Dimensions,, 50,120
StringSplit, Dimension, UserInput, %A_Space%`,
SetFormat, float, 0.1
Volume := Dimension1*Dimension2*Dimension3/2
VolumeString = %Dimension1%x%Dimension2%x%Dimension3%cm(%Volume%mL) 
Paste(VolumeString, 0)
Return

; Renumber Seleted Text
$^!n::
  RenumberSeletedText()
Return

!a::
  ;GetPreviousReport(true, true)
  GetPreviousReportWithImages(true, true, 1, false, true)
  ;GetPreviousReportWithImages(true, false, 1, false, false)
Return

!s::
  Click()
Return

#IfWinActive

; Insert Patient Exam Info
;; This hotkey cannot be included in SmartWonder window group
$^h::
  InsertPatientExamInfo()


Return