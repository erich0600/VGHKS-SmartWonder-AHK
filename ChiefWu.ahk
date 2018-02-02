; Group Control For SmartWonder
GroupAdd, SmartWonder, VGHKS-
GroupAdd, SmartWonder, vghks-
GroupAdd, SmartWonder, tedpc-

; Global Variables
#Include MyScripts\vars.ahk

; Settings
;#Hotstring EndChars `t
;#Hotstring O

; External Libraries
#Include <WBGet>
#Include <Paste>

;; My Own Lib
#Include MyScripts\lib\frame-wait.ahk
#Include MyScripts\lib\date.ahk
#Include MyScripts\lib\supported-exam-patterns.ahk

;;; HotStrings
#IfWinActive ahk_group SmartWonder

::IC0::
StringWithPrevExamDateDelete("NO interval change from the latest exam")
Return

::OIC0::
StringWithPrevExamDateDelete("Other than above findings, there is NO Other imaging interval CHANGES from the latest study")
Return

::IC1::
StringWithPrevExamDateDelete("mild PROGRESSIVE change from the prior exam")
Return

::IC2::
StringWithPrevExamDateDelete("moderate PROGRESSIVE change from the prior exam")
Return

::IC3::
StringWithPrevExamDateDelete("remarkable PROGRESSIVE change from prior exam")
Return

::IC-0::
StringWithPrevExamDateDelete("NO FURTHER improvement from the latest exam")
Return

::IC-1::
StringWithPrevExamDateDelete("mild IMPROVEMENT as compared with the latest examination")
Return

::IC-2::
StringWithPrevExamDateDelete("moderate IMPROVEMENT but considerable residual change still noted as compared with the latest examination")
Return

::IC-3::
StringWithPrevExamDateDelete("remarkable IMPROVEMENT as compared with the latest examination")
Return

::ic+-::
StringWithPrevExamDateDelete("SOME lesions improved and SOME progressed; as a whole, NO remarkable change")
Return

;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

coordmode,mouse,screen
^q::
click 680, 72
return

^o::
click 680, 72
return
; for zoom

^x::
winactivate TEDPC-SmartWonder
click 345, 72
return

; send, 3 lines
^s::
winactivate TEDPC-SmartWonder
;click 1460,340
;return
;click 500, 500
  send ^k
return

; send for Pinton VH
^f::
winactivate TEDPC-SmartWonder
click 1225,272
return


^F1::
send {F8}
send {f1}
send {f7}
return

::FSG::Guidelines for Management of Small Pulmonary Nodules Detected on CT Scans: A Statement from the Fleischner Society 2005 Radiology
return

;coordmode,mouse,relative

::pcu::
send No evident lung nodule > 1 cm. No evident parenchymal lesion of mixed-alveolar pattern. The size and shape of heart and mediastinum are not unusual for age{enter}
sleep 1000
send no interval change from prior exam{enter}
sleep 1000
click 859, 112
sleep 500
send ^s
return



::pcu0::
send No evident lung nodule > 1 cm. No evident parenchymal lesion of mixed-alveolar pattern. The size and shape of heart and mediastinum are not unusual for age{enter}
sleep 1000
click 776,174
sleep 500
send ^d
return

#IfWinActive

; HotKeys
#Include MyScripts\hotkey\get-previous-report.ahk
#Include MyScripts\hotkey\get-previous-report-with-images.ahk
#Include MyScripts\hotkey\get-previous-exam-date.ahk
#Include MyScripts\hotkey\change-font.ahk
#Include MyScripts\hotkey\copy-order.ahk
#Include MyScripts\hotkey\renumber-selected-text.ahk
#Include MyScripts\hotkey\click-none-tb-none-ot.ahk

; Define hotkeys
#IfWinActive ahk_group SmartWonder

; 複製最近相關報告並開啟最近兩張及三個月前影像
^z::
  GetPreviousReportWithImages(true, true, 1, true, false)
Return

; CopyIndication
$^i::
  MyOrderDiag := CopyOrder()
  Paste(MyOrderDiag)
Return

; Renumber Seleted Text
$^!n::
  RenumberSeletedText()
Return

; Click TB(-)Ot(-)
^t::
  ClickNoneTBNoneOt()
Return

#IfWinActive
