; HotKey
;; Renumbering the selected text
;; for SmartWonder

#IfWinActive ahk_group SmartWonder
ClickConfirm(){
  wb := WBGet()
  frmWork := wb.document.parentWindow.frames["frameWork"]
  firstTab := frmWork.document.getElementById("tab000").innerText
  If (firstTab = "報告編輯") {
    tabIframe2 := frmWork.document.parentWindow.frames["tabIframe2"]
    ConfirmReport := tabIframe2.document.getElementsByName("ConfirmReport")[0]
    ConfirmReport.click()
    
    Sleep, 2000
  	WinActivate, ahk_class IEFrame, vghks
    ;MsgBox % ConfirmReport.value
  } Else If (firstTab = "檢查步驟編輯") {
  	frameProcess := wb.document.parentWindow.frames["frameProcess"]
  	 
  	RecommContent := frameProcess.document.getElementsByName("Recommendation")[0]
  	; MsgBox, % RecommContent.innerText
  	If (RecommContent) {
      
  		frameCode := frameProcess.document.parentWindow.frames["frameCode"]
    	getCode := frameCode.document.getElementsByName("getCode")[0]
    	getCode.click()
  	}

    Save := frameProcess.document.getElementById("Save")
    Save.click()
  }

}
#IfWinActive
