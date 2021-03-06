; HotKey
;; Renumbering the selected text
;; for SmartWonder

#IfWinActive ahk_group SmartWonder
DownloadCheck(){
    WorkBookPath := A_Desktop "\Check.xlsx"     

    wb := WBGet()
    frmWork := wb.document.parentWindow.frames["frameWork"]
    firstTab := frmWork.document.getElementById("tab000").innerText

    continueLoop = true
    index = 2

    
    objExcel := ComObjCreate("Excel.Application")           ; create a handle to a new excel application
	objWorkBook := objExcel.Workbooks.Open(WorkBookPath)    ; opens the existing excel table

    While (continueLoop)
    {
        Sleep, 2500
        frmTabIframe2 := frmWork.document.parentWindow.frames["tabIframe2"]   
        FrameWait(frmTabIframe2)
        ; examCat := frmTabIframe2.document.getElementById("tabQuery").children[0].children[0].children[2].children[1].children[0].children[0].children[1].children[1].innerText
        currExam := frmTabIframe2.document.getElementById("tabQuery").children[0].children[0].children[2].children[1].children[0].children[2].children[1].innerText
        examInd := frmTabIframe2.document.getElementById("idDiag").innerText
        Sleep, 1000
        frameProcess := wb.document.parentWindow.frames["frameProcess"]
        RecommContent := frameProcess.document.getElementsByName("Recommendation")[0].innerText
        examInd := RegExReplace(examInd, "\W", " ") 
        examInd := RegExReplace(examInd, "\s+", " ") 
        examInd := RegExReplace(examInd, "i)Key history|Indication|Special comments|Site Range .* (No history of impaired renal function|Impaired renal function No contrast agent)|Purpose|([0-9]{2}|) eGFR.*Site Range.*Purpose|History Data|Thanks", " ")
        examInd := RegExReplace(examInd, "i)(No history of |)impaired renal function.*Site Range |(No history of |)impaired renal function.* Reason", " ")
        examInd := RegExReplace(examInd, "\s+", " ") 
        
        if (examInd = "")
        continueLoop := false

        objExcel.Worksheets(1).Cells(index+0, 1).Value := currExam
        objExcel.Worksheets(1).Cells(index+0, 2).Value := RegExReplace(examInd, "\W", " ") 
        objExcel.Worksheets(1).Cells(index+0, 3).Value := RegExReplace(RecommContent, "\W", " ") 
        index := index + 1

        breakLoop := NextPatient()
        if (breakLoop = "1")
            continueLoop := false
            
        If (Mod(index, 20) = 0){
            objWorkBook.Save
            Sleep, 1000
        }
                
    }

    	objWorkBook.Save
	    objExcel.Quit
	    objExcel := ""


}

; NextPatient(){
;     wb := WBGet()
;     frmWorkList := wb.document.parentWindow.frames["frameWrkList"]
;     tempWorklist := frmWorkList.document.getElementById("lstBdy")
; ;    Msgbox, % tempWorklist.innerHTML

;     compare := "stLineBarClk"" clickOn=.* clickRowIndex=""(\d*)"" oldCls"
;     text := RegExMatch(tempWorklist.innerHTML, compare, Match)
;     ; Msgbox, % Match1


;     tempWorklist.children[Match1+1].click()
;     ; Msgbox, % tempWorklist.children.innerHTML
;     ; for child in tempWorklist
;         ; Msgbox, child.innerHTML

;     ; return frameCode.document.getElementsByName("txtCodeID")
;     if (tempWorklist.children.length=Match1 +1)
;         Return 1
;     Return 0
; }

    #IfWinActive




