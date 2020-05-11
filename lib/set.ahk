setNotes()
{
  Gui, Notes:Destroy
  Gui, Notes:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndNotesWindow
  Gui, Notes:font, c%whiteColor% s%points% w%notes_width%, %font%
  Gui, Notes:Color, %backgroundColor%
  WinSet, Transparent, %opacity%
  Gui, Notes:Margin, 5, 5

  numLines := 0
  filepath := "" A_ScriptDir "\builds\" overlayFolder "\" CurrentAct "\" CurrentZone ".txt" ""
  Loop, read, %filepath%
  {
    val := A_LoopReadLine

    colorTest := SubStr(val, 1, 2)
    If (colorTest = "R,") {
      Gui, Notes:font, c%redColor%
      StringTrimLeft, val, val, 2
    } Else If (colorTest = "< ") {
      Gui, Notes:font, c%redColor%
    } Else If (colorTest = "G,") {
      Gui, Notes:font, c%greenColor%
      StringTrimLeft, val, val, 2
    } Else If (colorTest = "+ ") {
      Gui, Notes:font, c%greenColor%
    } Else If (colorTest = "B,") {
      Gui, Notes:font, c%blueColor%
      StringTrimLeft, val, val, 2
    } Else If (colorTest = "> ") {
      Gui, Notes:font, c%blueColor%
    } Else If (colorTest = "W,") {
      Gui, Notes:font, c%whiteColor%
      StringTrimLeft, val, val, 2
    } Else {
      Gui, Notes:font, c%whiteColor%
    }

    ;Wrap notes longer than maxNotesWidth
    while true
    {
      StringLen, stringLength, val
      If (stringLength > maxNotesWidth) {
        StringGetPos, lastCharPos, val, %A_Space%, R1, stringLength-maxNotesWidth
        If (lastCharPos = -1) {
          lastCharPos := maxNotesWidth-1
        }

        StringLeft, beginString, val, lastCharPos+1
        StringTrimLeft, val, val, lastCharPos+1
        If(numLines = 0){
          Gui, Notes:Add, Text, xm ym, % beginString
        } Else {
          Gui, Notes:Add, Text, xm y+0, % beginString
        }
        numLines++
      } Else {
        If(numLines = 0){
          Gui, Notes:Add, Text, xm ym, % val
        } Else {
          Gui, Notes:Add, Text, xm y+0, % val
        }
        numLines++
        break
      }
    }
  }

  shortpath := "" "Add notes to \builds\" overlayFolder "\`n" CurrentAct "\" CurrentZone ".txt" ""
  If (numLines = 0) {
    Gui, Notes:Add, Text, xm ym, % shortpath
  }

  numLines := numLines = 0 ? 2 : numLines
  notes_height := (numLines * Ceil(pixels*spacingHeight)) + 10

  Gui, Notes:Show, x%xPosNotes% y%yPosNotes% w%notes_width% h%notes_height% NA, Gui Notes
  Gui, Notes:Cancel
}

setGuide()
{
  Gui, Guide:Destroy
  If (hideGuide != "True") {
    Gui, Guide:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndGuideWindow
    Gui, Guide:font, c%whiteColor% s%points% w%guide_width%, %font%
    Gui, Guide:Color, %backgroundColor%
    WinSet, Transparent, %opacity%
    Gui, Guide:Margin, 5, 5

    numLines := 0
    filepath := "" A_ScriptDir "\builds\" overlayFolder "\" CurrentAct "\" "guide.txt" ""
    Loop, read, %filepath%
    {
      val := A_LoopReadLine

      colorTest := SubStr(val, 1, 2)
      If (colorTest = "R,") {
        Gui, Guide:font, c%redColor%
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "< ") {
        Gui, Guide:font, c%redColor%
      } Else If (colorTest = "G,") {
        Gui, Guide:font, c%greenColor%
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "+ ") {
        Gui, Guide:font, c%greenColor%
      } Else If (colorTest = "B,") {
        Gui, Guide:font, c%blueColor%
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "> ") {
        Gui, Guide:font, c%blueColor%
      } Else If (colorTest = "W,") {
        Gui, Guide:font, c%whiteColor%
        StringTrimLeft, val, val, 2
      } Else {
        Gui, Guide:font, c%whiteColor%
      }

      ;Wrap lines longer than maxGuideWidth
      while true
      {
        StringLen, stringLength, val
        If (stringLength > maxGuideWidth) {
          StringGetPos, lastCharPos, val, %A_Space%, R1, stringLength-maxGuideWidth
          If (lastCharPos = -1) {
            lastCharPos := maxGuideWidth-1
          }

          StringLeft, beginString, val, lastCharPos+1
          StringTrimLeft, val, val, lastCharPos+1
          If(numLines = 0){
            Gui, Guide:Add, Text, xm ym, % beginString
          } Else {
            Gui, Guide:Add, Text, xm y+0, % beginString
          }
          numLines++
        } Else {
          If(numLines = 0){
            Gui, Guide:Add, Text, xm ym, % val
          } Else {
            Gui, Guide:Add, Text, xm y+0, % val
          }
          numLines++
          break
        }
      }
    }

    shortpath := "" "Add guide to \builds\" overlayFolder "\`n" CurrentAct "\" "guide.txt" ""
    If (numLines = 0) {
      Gui, Guide:Add, Text, xm ym, % shortpath
    }

    numLines := numLines = 0 ? 2 : numLines
    guide_height := (numLines * Ceil(pixels*spacingHeight)) + 10

    Gui, Guide:Show, x%xPosGuide% y%yPosNotes% w%guide_width% h%guide_height% NA, Gui Guide
    Gui, Guide:Cancel
  }
}

SetExp()
{
  safeZone := Floor(3 + (CurrentLevel/16) )
  monsterLevel := SubStr(CurrentZone, 1, 2)

  If (monsterLevel = 71) {
    monsterLevel = 70.94
  } Else If (monsterLevel = 72) {
    monsterLevel = 71.82
  } Else If (monsterLevel = 73) {
    monsterLevel = 72.64
  } Else If (monsterLevel = 74) {
    monsterLevel = 73.40
  } Else If (monsterLevel = 75) {
    monsterLevel = 74.10
  } Else If (monsterLevel = 76) {
    monsterLevel = 74.74
  } Else If (monsterLevel = 77) {
    monsterLevel = 75.32
  } Else If (monsterLevel = 78) {
    monsterLevel = 75.84
  } Else If (monsterLevel = 79) {
    monsterLevel = 76.30
  } Else If (monsterLevel = 80) {
    monsterLevel = 76.70
  } Else If (monsterLevel = 81) {
    monsterLevel = 77.04
  } Else If (monsterLevel = 82) {
    monsterLevel = 77.32
  } Else If (monsterLevel = 83) {
    monsterLevel = 77.54
  } Else If (monsterLevel = 84) {
    monsterLevel = 77.70
  }

  effectiveDiff := Max( Abs(CurrentLevel - monsterLevel) - safeZone, 0 )
  expPenalty := (CurrentLevel+5)/(CurrentLevel+5+Sqrt(effectiveDiff*effectiveDiff*effectiveDiff*effectiveDiff*effectiveDiff))
  expMulti := Sqrt(expPenalty*expPenalty*expPenalty)
  If (CurrentLevel >= 95) {
    expMulti := expMulti * (1/(1+(0.1*(CurrentLevel-94))))
  }

  expMulti := Max( expMulti, 0.01 )

  If (expOrPen = "Exp"){
    calcExp := "Exp: "
    If (expMulti = 1){
      calcExp .= "100"
    } Else {
      calcExp .= Round((expMulti * 100), 1)
    }
  } Else {
    calcExp := "Pen: "
    calcExp .= Round((1-expMulti) * 100, 1)
  }
  calcExp .= "%  "

  calcExp .= "Over: "
  calcExp .= CurrentLevel - (Floor(monsterLevel) - safeZone)

  GuiControl,Exp:,CurrentExp, %calcExp%

  Gui, Exp:Show, x%xPosExp% y%yPosExp% w%exp_width% h%exp_height% NA, Gui Exp
}


SetGems()
{
  Gui, Links:Destroy
  Gui, Links:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndLinksWindow
  Gui, Links:font, c%whiteColor% s%points% w%links_width%, %font%
  Gui, Links:Color, %backgroundColor%
  WinSet, Transparent, %opacity%
  Gui, Links:Margin, 5, 5

  numLines := 0

  ReadGemFile(CurrentGem)

  For k, someControl in controlList {
    numLines++
    gemColor := %someControl%color
    If (gemColor = ""){
      gemColor := whiteColor
    }
    Gui, Links:font, c%gemColor%
    If (someControl = ""){
      gemText := " "
    } Else {
      gemText := %someControl%gem . " "
      If (%someControl%npc != "") {
        gemText .= "[" . %someControl%npc . "]"
      }
      If (%someControl%note != "") {
        gemText .= "(" . %someControl%note . ")"
      }
    }
    If (lastGemText = " " and gemText = " ") {
      numLines--
    } Else If (A_Index = 1) {
      Gui, Links:Add, Text, xm ym, % gemText
    } Else {
      Gui, Links:Add, Text, xm y+0, % gemText
    }
    lastGemText := gemText
  }

  links_height := (numLines * Ceil(pixels*spacingHeight)) + 10

  Gui, Links:Show, x%xPosLinks% y%yPosLinks% w%links_width% h%links_height% NA, Gui Exp
}