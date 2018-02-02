; for debug
^8::
  wb := WBGet()
  frmWork := wb.document.frames["frameWork"]
  frmTabIframe2 := frmWork.document.frames["tabIframe2"]

  AgLabelCom := frmTabIframe2.document.getElementById("divTemplateTree").children[1].children[1].children[1].children[0].children[0]
  AgScoreCom := frmTabIframe2.document.getElementById("divTemplateTree").children[1].children[1].children[1].children[0].children[1]

  ;AgScoreCom.value := "abc"

  MesaLabelCom := frmTabIframe2.document.getElementById("divTemplateTree").children[1].children[1].children[1].children[1].children[0]
  MesaScoreCom := frmTabIframe2.document.getElementById("divTemplateTree").children[1].children[1].children[1].children[2]

  MesaScoreRadioOutRangeCom := MesaScoreCom.children[0].children[0]
  MesaScoreRadioLess25Com := MesaScoreCom.children[1].children[0]
  MesaScoreRadioMore25Com := MesaScoreCom.children[2].children[0]
  ;MsgBox % MesaLabelCom.innerText
Return

;; to get bone density report by ajax.
$^!z::
  wb := WBGet()

  myL =
  ( %
    var compareArrays = function(a, b) {
      if (a === b)
        return true;
      if (a.length !== b.length)
        return false;
      for (var i = 0; i < a.length; i++){
        if(!(a[i] == b[i])) return false;
      };
      return true;
    };

    acc_no = $('iframe[name=frameWork]').contents().find('#tabIframe2').contents().find('input[name=OldAccNo]').val();
    report_area = $('iframe[name=frameWork]').contents().find('#tabIframe2').contents().find('textarea[name=ReportContent]');

    //alert(acc_no);

    $.support.cors = true;
    $.ajax({
      dataType: "json",
      url: "//vghks.tsai.it/dicom/sr/" + acc_no + "/report",
      crossDomain: true
    }).done(function(data){
//      alert(data.report);
      my_p = $.map(data.report.match(/(\d+\s*%)/g), function(x){ return x.match(/(\d+)/)[1] });
      re_p = $.map(report_area.val().match(/(\d+\s*%)/g), function(x){ return x.match(/(\d+)/)[1] });
      my_s = $.map(data.report.match(/\([TZ]-score\s*=\s*-?[\d\.]+\)/g), function(x){ return x.match(/=\s*(-?[\d\.]+)/)[1] });
      re_s = $.map(report_area.val().match(/\([TZ]-score\s*=\s*-?[\d\.]+\)/g), function(x){ return x.match(/=\s*(-?[\d\.]+)/)[1] });
      my_c = data.report.match(/normal limit|low bone mass|osteoporosis|within the expected|below the expected/);
      re_c = data.report.match(/normal limit|low bone mass|osteoporosis|within the expected|below the expected/);

      if (!compareArrays(my_p, re_p) || !compareArrays(my_s, re_s) || !compareArrays(my_c, re_c)) {
        alert(data.report);
        //alert(my_p);
        //alert(re_p);
      }
      else {
        lst_bdy_lst_wrk = $('iframe[name=frameWrkList]').contents().find('#lstBdyfromWorklist');
        lst_length = lst_bdy_lst_wrk.children().length;

//        alert(lst_length);
        next_patient_index = -1;

        if (lst_length) {
          lst_bdy_lst_wrk.children().each(function(i){
            lst_acc_no = $(this).children().eq(3).children().eq(1).text();
            if (lst_acc_no == acc_no) {
              //if (i + 1 < lst_length){
                next_patient_index = i + 1;
              //}

              return false;
            }
          });
          //alert(next_patient_index);
        }

        if (next_patient_index > 0) {
          if (next_patient_index == lst_length)
            alert("ok");
          else
            lst_bdy_lst_wrk.children().eq(next_patient_index).click();
        }
      }
    }).fail(function(jqXHr, textStatus, errorThrown) {
        alert("ajax failed: " + textStatus);
    });
  )

  window := wb.document.parentWindow
  window.execScript(myL)

Return

; Ctrl + Alt + Win + L
; Login to SmartWonder
;#IfWinActive ahk_class tedpc
^!#l::
  wb := WBGet()

  WonderID := wb.document.getElementsByName("WonderID")[0]
  WonderID.value := "4320"
  WonderPassword := wb.document.getElementsByName("WonderPassword")[0]
  WonderPassword.value := "RD4320"
  LoginImg := wb.document.getElementsByName("login")[0]
  LoginImg.click()
Return
;#IfWinActive
