﻿; Generated by AutoGUI 1.3.3a
#SingleInstance Force


; Loop, %0% { ; For each parameter:
; 	Msgbox, %0%
;     param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
;     MsgBox, 4,, Parameter number %A_Index% is %param%.  Continue?
;     IfMsgBox, No
;         break
; }

; SetWorkingDir %A_ScriptDir%
WorkBookPath := A_Desktop "\Database.xlsx"                 ; change this line to your workbook path
xlDown := -4121

E1 :=1
M := 1
params = %0%
if params = 4
{
	Gui, Add, Edit, vE2 w70 hwndPID, %1%
	SetEditCueBanner(PID, "Patient ID")
	Gui, Add, Edit, YS vE3 w70 hwndAccN,  %2%
	SetEditCueBanner(AccN, "Accesion No.") 
	Gui, Add, Edit, YS vE4 w70 hwndDate,  %3%
	SetEditCueBanner(Date, "Exam Date")
	Gui, Add, Edit, YS vE5 w70 hwndType r1, %4%
	SetEditCueBanner(Type, "Exam Type") 
	; Gui, Add, Edit, YS vE5 w70 hwndTime,  %4%
	; SetEditCueBanner(Time, "Exam Time")
}
else
{
	Gui, Add, Edit, vE2 w70 hwndPID
	SetEditCueBanner(PID, "Patient ID") 
	Gui, Add, Edit, YS vE3 w70 hwndAccN
	SetEditCueBanner(AccN, "Accesion No.") 
	Gui, Add, Edit, YS vE4 w70 hwndDate
	SetEditCueBanner(Date, "Exam Date") 
	Gui, Add, Edit, YS vE5 w70 hwndType
	SetEditCueBanner(Type, "Exam Type") 
}

; Gui Add, Button, YS w50, &Paste

Gui Add, GroupBox, XS Section x10 w225 h80
Gui, Add, Radio, vModality xs+5 ys+10  h20 Checked , Abdomen
Gui, Add, Radio, xs+90 ys+10  h20, Chest
Gui, Add, Radio, xs+160 ys+10 h20, Neuro
Gui, Add, Radio, xs+5 ys+30  h20, MSK
Gui, Add, Radio, xs+90 ys+30 h20, Sono
Gui, Add, Radio, xs+160 ys+30 h20, Angio
Gui, Add, Radio, xs+5 ys+50 h20, Breast
Gui, Add, Radio, xs+90 ys+50 h20, Others
Gui, Add, Checkbox, YS+10 w40 vDownload, Download?
Gui, Add, Checkbox, w70 vFollow, Follow up?
Gui Add, GroupBox, XS Section w200 h100 
Gui, Add, Edit, xs+5 ys+10 vE6 w190 h50 
;Gui Add, GroupBox, YS w20 h70, GroupBox
Gui, Add, Edit, xs+5 ys+70 vE7 w190 h20 hwndMISC
SetEditCueBanner(MISC, "Others") 
Gui Add, GroupBox, YS Section w80 h100 
Gui, Add, Radio, xs+5 ys+10 vC1 h20, Interesting
Gui, Add, Radio, xs+5 ys+30 vC2 h20 Checked, Typical
Gui, Add, Radio, xs+5 ys+50 vC3 h20, Follow Up
Gui, Add, Radio, xs+5 ys+70 vC4 h20, Pitfalls


Gui Add, Button, XS Section x10 Default, &Submit
; return 

Gui Show
Return


GuiEscape:
GuiClose:
    ExitApp

ButtonSubmit:
Gui, Submit
objExcel := ComObjCreate("Excel.Application")           ; create a handle to a new excel application
objWorkBook := objExcel.Workbooks.Open(WorkBookPath)    ; opens the existing excel table


If (Follow){
	lastCell := xlFindLastCell(objExcel, 9+0)

	Row := lastCell.row + 1
	E1 := objExcel.Worksheets(9+0).Cells(Row-1, 1).Value +1
	Loop, 7
	    objExcel.Worksheets(9+0).Cells(Row, A_Index).Value := E%A_Index%
}
Else{
	lastCell := xlFindLastCell(objExcel, Modality+0)

	Row := lastCell.row + 1
	E1 := objExcel.Worksheets(Modality+0).Cells(Row-1, 1).Value +1
	Loop, 7
	    objExcel.Worksheets(Modality+0).Cells(Row, A_Index).Value := E%A_Index%

	IfEqual,C1,1
	{
		objExcel.Worksheets(Modality+0).Cells(Row, 8).Value := "Interesting"
	}
	IfEqual,C2,1
	{
		objExcel.Worksheets(Modality+0).Cells(Row, 8).Value := "Typical"
	}
	IfEqual,C3,1
	{
		objExcel.Worksheets(Modality+0).Cells(Row, 8).Value := "Follow up"
	}
	IfEqual,C4,1
	{
		objExcel.Worksheets(Modality+0).Cells(Row, 8).Value := "Pitfalls"
	}	
}

If (Download) {
	SetWorkingDir, %A_WorkingDir%\MyScripts\dicom\
	; stringDownload = python %A_WorkingDir%\MyScripts\dicom\Query.py 192.168.220.1 4568 92109962
	; Msgbox, %stringDownload%	
	; Run, %comspec% /k python %A_WorkingDir%\MyScripts\dicom\Query.py 192.168.220.1 4568 %2%, , Max
	; Run, %comspec% /k python Query.py 192.168.220.1 4568 %2%, , Max	
	Run, %comspec% /k python Query3.py %2%, , Hide	

}

objWorkBook.Save
objExcel.Quit
objExcel := ""
ExitApp
return

SetEditCueBanner(HWND, Cue)
{
	Static EM_SETCUEBANNER := (0x1500 + 1)
	Return DllCall("User32.dll\SendMessageW", "Ptr", HWND, "Uint", EM_SETCUEBANNER, "Ptr", True, "WStr", Cue)
}

xlFindLastCell(objExcel, sheet := 1) {
	Gui, Submit, NoHide
	static xlByRows    := 1
	     , xlByColumns := 2
	     , xlPrevious  := 2

	lastRow := objExcel.Sheets(sheet).Cells.Find("*", , , , xlByRows   , xlPrevious).Row
	lastCol := objExcel.Sheets(sheet).Cells.Find("*", , , , xlByColumns, xlPrevious).Column

	return {row: lastRow, column: lastCol}
}
; Do not edit above this line
; Do not edit above this line