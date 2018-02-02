; Copy Order After "Purpose"
;; for SmartWonder
#IfWinActive ahk_group SmartWonder

CopyOrder(toLower = 0)
{
  wb := WBGet()

  tabIframe2 := wb.document.parentWindow.frames["frameWork"].document.parentWindow.frames["tabIframe2"]
  AccNo := tabIframe2.document.getElementsByName("OldAccNo")[0].value
  OrderId = OrderDiag_%accNo%
  OrderDiag := tabIframe2.document.getElementById(OrderId).value
  ; Msgbox, %OrderDiag%
  ; Msgbox, %OrderId%
  ; 只取 "Purpose :" 以後的字串, 把 "History & Data:" 拿掉
  FoundPos := RegExMatch(OrderDiag, "^.*?Purpose\s?:\s*(.*?)\s*History & Data\s*:(.*?)\s*?$", OrderMatch)
  FoundPosNew := RegExMatch(OrderDiag, "^.*?Indication:\s*(.*?)\s*Key history & Special comments*:(.*?)\s?Site.*\s*?$", OrderMatchNew)
  

  if (FoundPos > 0) {

    ; 如果沒有句點則加上句點
    StringRight, strEndChar, OrderMatch1, 1
    strPurpose := (strEndChar = ".") ? OrderMatch1 : OrderMatch1 . "."
    StringRight, strEndChar, OrderMatch2, 1
    strHistory := (strEndChar = ".") ? OrderMatch2 : OrderMatch2 . "."

    ; 有時  purpose 和 history 部份內容會重複，留下比較長的就好
    if (InStr(OrderMatch1, OrderMatch2, true)) {
      MyOrderDiag := strPurpose
    } else if (InStr(OrderMatch1, OrderMatch2, true)) {
      MyOrderDiag := strHistory
    } else {
      MyOrderDiag := strPurpose . " " . strHistory
      ; MyOrderDiag := strPurpose
    }
  } else if (FoundPosNew > 0) {
    ; 如果沒有句點則加上句點
    StringRight, strEndChar, OrderMatchNew1, 1
    strPurpose := (strEndChar = ".") ? OrderMatchNew1 : OrderMatchNew1 . "."
    StringRight, strEndChar, OrderMatchNew2, 1
    strHistory := (strEndChar = ".") ? OrderMatchNew2 : OrderMatchNew2 . "."

    ; 有時  purpose 和 history 部份內容會重複，留下比較長的就好
    if (InStr(OrderMatchNew1, OrderMatchNew2, true)) {
      MyOrderDiag := strPurpose
    } else if (InStr(OrderMatchNew1, OrderMatchNew2, true)) {
      MyOrderDiag := strHistory
    } else {
      MyOrderDiag := strPurpose . " " . strHistory
      ; MyOrderDiag := strPurpose
    }
  } else {
    MyOrderDiag := OrderDiag
  }

  ; 有些人會打很多 ..., 刪掉
  MyOrderDiag := RegExReplace(MyOrderDiag, "\.{2,}", ". ")

  if (toLower) {
    StringLower, MyOrderDiag, MyOrderDiag
  }
  
  return MyOrderDiag
}

#IfWinActive
