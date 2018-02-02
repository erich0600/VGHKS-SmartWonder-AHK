#IfWinActive ahk_class IEFrame
AddCaseInfo(){
  SmartWonderWinID := WinExist("ahk_group SmartWonder")
  wb := WBGet("ahk_id" SmartWonderWinID)
  If (wb) {

    ReportContentList := wb.document.parentWindow.frames["frameWork"].document.parentWindow.frames["tabIframe2"].document.getElementsByName("ReportContent")

    If (ReportContentList.length > 0) {
      AccNo := wb.document.parentWindow.frames["frameWork"].document.parentWindow.frames["tabIframe2"].document.getElementsByName("OldAccNo")[0].value
      PatID := wb.document.parentWindow.frames["frameWork"].document.parentWindow.frames["tabIframe2"].document.getElementsByName("PatID")[0].value
      ExamDate := wb.document.parentWindow.frames["frameWork"].document.parentWindow.frames["tabIframe2"].document.getElementById("tabOrder").children[0].children[2].children[1].innerText
      tmpStr := wb.document.parentWindow.frames["frameWork"].document.parentWindow.frames["tabIframe2"].document.getElementById("tabOrder").children[0].children[0].children[2].children[0].children[0].innerText
      RegExMatch(tmpStr, "(.+) : (.+)", splittedTmpStr)
      currExamName := splittedTmpStr2
      Run autohotkey.exe Add-Case-GUI.ahk %PatID% %AccNo% %ExamDate% "%currExamName%
    }
    Else
      Run autohotkey.exe Add-Case-GUI.ahk
  }
  Else
    Run autohotkey.exe Add-Case-GUI.ahk
}
#IfWinActive