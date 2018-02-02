; HotKey
;; Renumbering the selected text
;; for SmartWonder

#IfWinActive ahk_group SmartWonder
AutoCheck(){

  wb := WBGet()
  frmWork := wb.document.parentWindow.frames["frameWork"]
  firstTab := frmWork.document.getElementById("tab000").innerText


  ; MsgBox, % firstTab
  ; If (firstTab = "檢查步驟編輯") {
  ; MsgBox, % firstTab
  continueLoop = true
  
  ; frmTabIframe2 := frmWork.document.parentWindow.frames["tabIframe2"]
  ; FrameWait(frmTabIframe2)

  While (continueLoop)
  {
    Sleep, 2500
    frmTabIframe2 := frmWork.document.parentWindow.frames["tabIframe2"]   
    FrameWait(frmTabIframe2)
    examCat := frmTabIframe2.document.getElementById("tabQuery").children[0].children[0].children[2].children[1].children[0].children[0].children[1].children[1].innerText
    currExam := frmTabIframe2.document.getElementById("tabQuery").children[0].children[0].children[2].children[1].children[0].children[2].children[1].innerText
    examInd := frmTabIframe2.document.getElementById("idDiag").innerText
    if (examInd = "")
      continueLoop := false

    firstLevel := Protocol(examCat, currExam, examInd)
    ; firstLevel := Protocol(hellow, examInd)

    if (firstLevel = "Skip" or firstLevel = ""){
      breakLoop := NextPatient()
      if (breakLoop = "1")
        continueLoop := false

    }
    else if (firstLevel = "CheckInd"){
      breakLoop := NextPatient()
      if (breakLoop = "1")
        continueLoop := false
    }
    else {

      frameProcess := wb.document.parentWindow.frames["frameProcess"]
      frameCode := frameProcess.document.parentWindow.frames["frameCode"]
      FrameWait(frameCode)
      getInput := frameCode.document.getElementsByName("txtCodeID")
      getInput[0].focus()

      Send {Text}%firstLevel%
      Sleep,400

      getCode := frameCode.document.getElementsByName("getCode")[0]
      getCode.click()

      Msgbox, 3,, %examInd%
      IfMsgBox Yes
      {
        Save := frameProcess.document.getElementById("Save")
        Save.click()
      }
      IfMsgBox No 
      {
        breakLoop := NextPatient()
        if (breakLoop = "1")
          continueLoop := false
      }
      IfMsgBox Cancel
        continueLoop := false

      

      ; if (breakLoop = "1")
      ;   continueLoop := false
      ; }
    }
  



  }
  ; 



}

NextPatient(){
  wb := WBGet()
  frmWorkList := wb.document.parentWindow.frames["frameWrkList"]
  tempWorklist := frmWorkList.document.getElementById("lstBdy")
  ; Msgbox, % tempWorklist.innerHTML
  compare := "stLineBarClk"" clickOn=.* clickRowIndex=""(\d*)"" oldCls"
  text := RegExMatch(tempWorklist.innerHTML, compare, Match)
  ; Msgbox, % Match1

  
  tempWorklist.children[Match1+1].click()
  ; Msgbox, % tempWorklist.children.innerHTML
  ; for child in tempWorklist
    ; Msgbox, child.innerHTML

  ; return frameCode.document.getElementsByName("txtCodeID")
  if (tempWorklist.children.length=Match1 +1)
    Return 1
  Return 0

}

#IfWinActive

Protocol(examCat, examType, examInd){


  protocolMap := {  "CT brain with/no contrast":              "Brain s+c"
                  , "CT brain no contrast":                   "Brain s"
                  , "CT brain with contrast":                 "Brain s+c"
                  , "CT neck & larynx with/no contras":       "CheckInd"
                  , "CT face & neck with contrast":           "CheckInd"
                  , "CT face + neck with/no contrast":        "CheckInd"
                  , "CT Nasopharynx with/no contrast":        "CheckInd"
                  , "CT paranasal sinus no contrast":         "CPS routine"
                  , "CT sella with/no contrast":              "Sellar micro"
                  , "CT innear petrous pyramids no":          "Temporal routine"
                  , "3D CT-Neuro":                            "CheckInd"
                  , "CTA, brain":                             "CheckInd"
                  , "CTA, Neck":                              "CTA_neck"   }
                  ; , "UGI + Small intestine":                  "UGI"
                  ; , "Antegrade pyelography, RT":              "SPE"
                  ; , "Antegrade pyelography, LT":              "SPE"
                  ; , "T-tube cholangiography":                 "SPE"
                  ; , "MRI (no contrast), Knee joint":          "MSK"
                  ; , "MRI (no/with contra), Knee join":        "MSK"
                  ; , "MRI (no/with), Shoulder joint":          "MSK"
                  ; , "MRI no contrast, Shoulder joint":        "MSK"
                  ; , "MRI (N/Y), Other musculoskeleta":        "MSK"
                  ; , "MRI (no/with const.), Lower lim":        "MSK"
                  ; , "MRI (no contrast), Wrist joint":         "MSK"
                  ; , "MRI (N/Y), Ankle joint":                 "MSK"
                  ; , "CT whole abdomen no contrast":           "ACT"
                  ; , "CT whole abdomen with/no contras":       "ACT"
                  ; , "CT Stomach with/no contrast":            "ACT"
                  ; , "CT Pan or Liver with/no contrast":       "ACT"
                  ; , "CTA,Abdomen":                            "ACT"
                  ; , "CT Kid & Adr with/no contrast":          "ACT"
                  ; , "CTA, Chest-Aorta, PE":                   "CCT"
                  ; , "GSICT-AngiogramofCoronaryArt LDC":       "CCT"
                  ; , "CT chest with/no contrast":              "CCT"
                  ; , "CT chest no contrast":                   "CCT" }
  ; Msgbox % protocolMap[examType]
  if (protocolMap[examType] = "Skip")
    return "Skip"
  else if (protocolMap[examType] = "CheckInd")
    return checkIndication(examCat, examType, examInd)
  else
    return protocolMap[examType]

}

checkIndication(examCat, examType, examInd){
  if (RegExMatch(examCat, "NEURO")){
    Msgbox, Check NEURO
    if (examType = "CTA, brain"){
      RegExMatch(examInd, "aneur", MatchNeuro)
    }
    
  }

  Msgbox, Check
  return "CheckInd"
}




