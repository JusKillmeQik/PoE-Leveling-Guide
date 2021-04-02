setNotes()
{
  Gui, Notes:Destroy
  If (hideNotes != "True") {
    Gui, Notes:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndNotesWindow
    Gui, Notes:font, c%whiteColor% s%points% w%boldness%, %font%
    Gui, Notes:Color, %backgroundColor%
    WinSet, Transparent, %opacity%
    Gui, Notes:Margin, %textMargin%, %textMargin%

    notes_width := 0
    filepath := "" A_ScriptDir "\builds\" overlayFolder "\" CurrentAct "\notes.txt" ""
    If (CurrentZone = "00 Aspirants' Plaza"){
      filepath := "" A_ScriptDir "\builds\" overlayFolder "\ascendancy.txt" ""
    }
    If (!FileExist(filepath)){
      filepath := "" A_ScriptDir "\builds\Notes\" notesFolder "\" CurrentAct "\notes.txt" ""
    }
    StringTrimLeft, ZoneName, CurrentZone, 3
    ZoneName := "zone:" + ZoneName
    ReadLines := "False"
    ZoneLine := []
    Loop, read, %filepath%
    {
      val := A_LoopReadLine
      If (val = ZoneName) {
        ReadLines := "True"
      } Else If ( InStr(val,"zone:") ) {
        ReadLines := "False"
      } Else {
        If (ReadLines = "True" and val != ""){
          ZoneLine.Push(val)
        }
      }
    }

    numLines := 0
    For index, val in ZoneLine
    {
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
      } Else If (colorTest = "Y,") {
        Gui, Notes:Font, c%yellowColor%
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "- ") {
        Gui, Notes:Font, c%yellowColor%
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

          ;expand width if too small to fit all characters
          W := MeasureTextWidth(beginString, "s" . points . "  w" . boldness, font)
          If ( W > notes_width ){
            notes_width := W
          }

          yPosNoteLine := (numLines * Ceil(pixels*lineSpacing)) + textMargin
          Gui, Notes:Add, Text, xm y%yPosNoteLine%, % beginString

          numLines++
        } Else {
          ;expand width if too small to fit all characters
          W := MeasureTextWidth(val, "s" . points . "  w" . boldness, font)
          If ( W > notes_width ){
            notes_width := W
          }

          yPosNoteLine := (numLines * Ceil(pixels*lineSpacing)) + textMargin
          Gui, Notes:Add, Text, xm y%yPosNoteLine%, % val

          numLines++
          break
        }
      }
    }

    If (numLines = 0) {
      shortpath := "" "Add """ ZoneName """ to notes.txt in`n\builds\" overlayFolder "\" CurrentAct "\" ""
      If (CurrentZone = "Aspirants' Plaza"){
        shortpath := "" "Add ascendancy.txt in`n\builds\" overlayFolder "\" ""
      }
      W := MeasureTextWidth(shortpath, "s" . points . "  w" . boldness, font)
      notes_width := W
      Gui, Notes:Add, Text, xm ym, % shortpath
      numLines := 2
    }

    notes_height := (numLines * Ceil(pixels*lineSpacing)) + (2 * textMargin)

    notes_width := notes_width + (2 * textMargin)

    If (hideGuide != "True") {
      xPosNotes := Round( (A_ScreenWidth * guideXoffset) - guide_width - controlSpace - notes_width )
    } Else {
      xPosNotes := Round( (A_ScreenWidth * guideXoffset) - notes_width )
    }
    Gui, Notes:Show, x%xPosNotes% y%yPosNotes% w%notes_width% h%notes_height% NA, Gui Notes
    Gui, Notes:Cancel
  }
}

setGuide()
{
  Gui, Guide:Destroy
  If (hideGuide != "True") {
    Gui, Guide:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndGuideWindow
    Gui, Guide:Font, c%whiteColor% s%points% w%boldness%, %font%
    Gui, Guide:Color, %backgroundColor%
    WinSet, Transparent, %opacity%
    Gui, Guide:Margin, %textMargin%, %textMargin%

    guide_width := 0
    filepath := "" A_ScriptDir "\builds\" overlayFolder "\" CurrentAct "\guide.txt" ""
    If (!FileExist(filepath)){
      filepath := "" A_ScriptDir "\builds\Notes\" notesFolder "\" CurrentAct "\guide.txt" ""
    }

    numLines := 0
    Loop, read, %filepath%
    {
      val := A_LoopReadLine

      colorTest := SubStr(val, 1, 2)
      If (colorTest = "R,") {
        Gui, Guide:Font, c%redColor%
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "< ") {
        Gui, Guide:Font, c%redColor%
      } Else If (colorTest = "G,") {
        Gui, Guide:Font, c%greenColor%
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "+ ") {
        Gui, Guide:Font, c%greenColor%
      } Else If (colorTest = "B,") {
        Gui, Guide:Font, c%blueColor%
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "> ") {
        Gui, Guide:Font, c%blueColor%
      } Else If (colorTest = "Y,") {
        Gui, Guide:Font, c%yellowColor%
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "- ") {
        Gui, Guide:Font, c%yellowColor%
      } Else If (colorTest = "W,") {
        Gui, Guide:Font, c%whiteColor%
        StringTrimLeft, val, val, 2
      } Else {
        Gui, Guide:Font, c%whiteColor%
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

          W := MeasureTextWidth(beginString, "s" . points . "  w" . boldness, font)
          If ( W > guide_width ){
            guide_width := W
          }

          yPosGuideLine := (numLines * Ceil(pixels*lineSpacing)) + textMargin
          Gui, Guide:Add, Text, xm y%yPosGuideLine%, % beginString

          numLines++
        } Else {
          ;expand width if too small to fit all characters
          W := MeasureTextWidth(val, "s" . points . "  w" . boldness, font)
          If ( W > guide_width ){
            guide_width := W
          }

          yPosGuideLine := (numLines * Ceil(pixels*lineSpacing)) + textMargin
          Gui, Guide:Add, Text, xm y%yPosGuideLine%, % val

          numLines++
          break
        }
      }
    }

    If (numLines = 0) {
      shortpath := "" "Add guide.txt in \builds\`n" overlayFolder "\" CurrentAct "\" ""
      W := MeasureTextWidth(shortpath, "s" . points . "  w" . boldness, font)
      guide_width := W
      Gui, Guide:Add, Text, xm ym, % shortpath
      numLines := 2
    }

    guide_height := (numLines * Ceil(pixels*lineSpacing)) + (2 * textMargin)

    guide_width := guide_width + (2 * textMargin)
    xPosGuide := Round( (A_ScreenWidth * guideXoffset) - guide_width )
    Gui, Guide:Show, x%xPosGuide% y%yPosNotes% w%guide_width% h%guide_height% NA, Gui Guide
    Gui, Guide:Cancel
  }
}

SetExp()
{
  safeZone := Floor(3 + (CurrentLevel/16) )
  If (numPart != 3){
    monsterLevel := SubStr(CurrentZone, 1, 2)
  } Else {
    monsterLevel := Maps[CurrentZone].Tier[Regions[Maps[CurrentZone].Region].SocketedStones + 1] + 67
  }
  

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

  effectiveDiff := Abs(CurrentLevel - monsterLevel) - safeZone
  If (effectiveDiff < 0) {
    effectiveDiff := 0
  }
  expPenalty := (CurrentLevel+5)/(CurrentLevel+5+Sqrt(effectiveDiff*effectiveDiff*effectiveDiff*effectiveDiff*effectiveDiff))
  expMulti := Sqrt(expPenalty*expPenalty*expPenalty)
  If (CurrentLevel >= 95) {
    expMulti := expMulti * (1/(1+(0.1*(CurrentLevel-94))))
  }

  If (expMulti < 0.01) {
    expMulti := 0.01
  }

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

  Gui, Exp:Show, x%xPosExp% y%yPosExp% w%exp_width% h%control_height% NA, Gui Exp
}


SetGems()
{
  Gui, Links:Destroy
  Gui, Links:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndLinksWindow
  Gui, Links:font, c%whiteColor% s%points% w%boldness%, %font%
  Gui, Links:Color, %backgroundColor%
  WinSet, Transparent, %opacity%
  Gui, Links:Margin, %textMargin%, %textMargin%
  numLines := 0

  fileName := CurrentGem
  Loop %A_ScriptDir%\builds\%overlayFolder%\gems\*.ini
	{
    tempFileName = %A_LoopFileName%
    StringTrimRight, tempFileName, tempFileName, 4
    If ( InStr(tempFileName,CurrentGem) ) {
      fileName := tempFileName
      break
    }
	}

  fileName=%A_scriptdir%\builds\%overlayFolder%\gems\%fileName%.ini
  LoadGemFile(fileName)

  gem_images_width := Ceil(pixels*gemSpacing)
  gem_images_height := Ceil(pixels*gemSpacing)
  
  links_width := 0
  For k, someControl in controlList {
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
    W := MeasureTextWidth(gemText, "s" . points . "  w" . boldness, font)
    If ( W > links_width ){
      links_width := W
    }
  }
  links_width := links_width + (2 * textMargin)
  xPosGemImage := xPosLinks + links_width + textMargin
  ;links_width := links_width + (2 * textMargin) + gem_images_width

  For k, someControl in controlList {
    Gui, Image%someControl%:Destroy
    numLines++
    gemColor := %someControl%color
    If (gemColor = ""){
      gemColor := whiteColor
    }
    Gui, Links:font, c%gemColor%
    If (someControl = ""){
      gemText := " "
    } Else {
      ;filepath := "" A_ScriptDir "\images\gems\" %someControl%gem ".png" ""
      filepath := "" A_ScriptDir "\" %someControl%url ""
      showGem := %someControl%image
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
      yPosGemImage := ((numLines-1) * Ceil(pixels*gemSpacing)) + textMargin
      Gui, Links:Add, Text, xm y%yPosGemImage%, % gemText
      If ( gemText != " " and showGem and FileExist(filepath) ){
        yPosGemImage := yPosLinks + yPosGemImage
        Gui, Image%someControl%:Color, 000000
        Gui, Image%someControl%:+E0x20 +E0x80 -DPIScale -resize -SysMenu -Caption +ToolWindow +AlwaysOnTop +hwndImage%someControl%Window
        Gui, Image%someControl%:Add, Picture, x0 y0 w%gem_images_width% h%gem_images_height% BackgroundTrans, %filepath%
        Gui, Image%someControl%:Show, w%gem_images_width% h%gem_images_height% x%xPosGemImage% y%yPosGemImage% NA, Image%someControl%
        id := Image%someControl%Window
        WinSet, TransColor, 000000, ahk_id %id%
      }
    } Else {
      yPosGemImage := ((numLines-1) * Ceil(pixels*gemSpacing)) + textMargin
      Gui, Links:Add, Text, xm y%yPosGemImage%, % gemText
      If ( gemText != " " and showGem and FileExist(filepath) ){
        yPosGemImage := yPosLinks + yPosGemImage
        Gui, Image%someControl%:Color, 000000
        Gui, Image%someControl%:+E0x20 +E0x80 -DPIScale -resize -SysMenu -Caption +ToolWindow +AlwaysOnTop +hwndImage%someControl%Window
        Gui, Image%someControl%:Add, Picture, x0 y0 w%gem_images_width% h%gem_images_height% BackgroundTrans, %filepath%
        Gui, Image%someControl%:Show, w%gem_images_width% h%gem_images_height% x%xPosGemImage% y%yPosGemImage% NA, Image%someControl%
        id := Image%someControl%Window
        WinSet, TransColor, 000000, ahk_id %id%
      }
    }
    lastGemText := gemText
  }

  If (lastGemText = " "){
    numLines--
  }

  links_height := (numLines * Ceil(pixels*gemSpacing)) + (2 * textMargin)

  Gui, Links:Show, x%xPosLinks% y%yPosLinks% w%links_width% h%links_height% NA, Gui Exp

}

MeasureTextWidth(Str, FontOpts = "", FontName = "") {
   Gui, New
   If (FontOpts <> "") || (FontName <> "")
      Gui, Font, %FontOpts%, %FontName%
   Gui, Add, Text, hwndHWND, %Str%
   WinGetPos, , ,Width, , ahk_id %HWND%
   Gui, Destroy
   Return Width
}