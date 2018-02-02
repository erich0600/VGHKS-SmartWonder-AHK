; Date Lib
; SplitDate(dateStr) {
;   Return RegExReplace(dateStr, "(\d{4})(\d{2})(\d{2})", "$1-$2-$3")
; }

StringWithPrevExamDateDelete(strTemplate) {
  global prevExamDate
  global currAccNo

  wb := WBGet()
  tabIframe2 := wb.document.parentWindow.frames["frameWork"].document.parentWindow.frames["tabIframe2"]
  AccNo := tabIframe2.document.getElementsByName("OldAccNo")[0].value

  FrameWait(tabIframe2)
  ReportContent := tabIframe2.document.getElementsByName("ReportContent")[0]
  ; Msgbox, % ReportContent.innerText
  FoundPos := RegExMatch(ReportContent.innerText, "([mM]ild |[mM]oderate |[sS]evere |)([pP]rogressive|[nN]o obvious interval|[rR]egressive) change as compared with previous study.*", Match)
  If (FoundPos > 0) {
    textRange := ReportContent.createTextRange()
    textRange.findText(Match)
    textRange.select()
  }

  output := strTemplate
  If (currAccNo = AccNo && StrLen(prevExamDate)) {
    output .= " on " . splitDate(prevExamDate)
  }
  output .= "."

  Paste(output, 0)
}

; .*?change as compared with previous study on.*