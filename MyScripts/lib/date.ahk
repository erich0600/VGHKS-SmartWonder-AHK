; Date Lib
SplitDate(dateStr) {
  Return RegExReplace(dateStr, "(\d{4})(\d{2})(\d{2})", "$1-$2-$3")
}

StringWithPrevExamDate(strTemplate) {
  global prevExamDate
  global currAccNo

  wb := WBGet()
  tabIframe2 := wb.document.parentWindow.frames["frameWork"].document.parentWindow.frames["tabIframe2"]
  AccNo := tabIframe2.document.getElementsByName("OldAccNo")[0].value

  output := strTemplate
  If (currAccNo = AccNo && StrLen(prevExamDate)) {
    output .= " on " . splitDate(prevExamDate)
  }
  output .= "."

  Paste(output, 0)
}


StringWithPrevExamDateDelete(strTemplate) {
  global prevExamDate
  global currAccNo

  wb := WBGet()
  tabIframe2 := wb.document.parentWindow.frames["frameWork"].document.parentWindow.frames["tabIframe2"]
  AccNo := tabIframe2.document.getElementsByName("OldAccNo")[0].value

  FrameWait(tabIframe2)
  ReportContent := tabIframe2.document.getElementsByName("ReportContent")[0]
  ; Msgbox, % ReportContent.innerText
  FoundPos := RegExMatch(ReportContent.innerText, "i)(mild |moderate |severe |remarkable |)(progressive|no.*? interval|regressive|improvement) (change|.*?)(as compared|change from) (with|).*", Match)
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