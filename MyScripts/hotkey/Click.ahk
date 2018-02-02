; HotKey
;; Renumbering the selected text
;; for SmartWonder

#IfWinActive ahk_group SmartWonder
Click(){
  wb := WBGet()
  frmWork := wb.document.parentWindow.frames["frameWork"]
  firstTab := frmWork.document.getElementById("tab000").innerText

  If (firstTab = "報告編輯") {
    tabIframe2 := frmWork.document.parentWindow.frames["tabIframe2"]
    ConfirmReport := tabIframe2.document.getElementsByName("ConfirmReport")[0]
    ConfirmReport.click()
    ;MsgBox % ConfirmReport.value
  } Else If (firstTab = "檢查步驟編輯") {
    frameProcess := wb.document.parentWindow.frames["frameProcess"]
    Save := frameProcess.document.getElementById("Save")
    Save.click()
    ;MsgBox % Left_4.value
  }
}
#IfWinActive

