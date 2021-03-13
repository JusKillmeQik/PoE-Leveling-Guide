global Maps := []
global Regions := []
global Conquerors := []
Conquerors["Baran"] := {}
Conquerors["Baran"].Color := redColor
Conquerors["Veritania"] := {}
Conquerors["Veritania"].Color := blueColor
Conquerors["Al-Hezmin"] := {}
Conquerors["Al-Hezmin"].Color := greenColor
Conquerors["Drox"] := {}
Conquerors["Drox"].Color := yellowColor

mappath := "" A_ScriptDir "\maps\maps.csv" ""
Loop, read, %mappath%
{
  map_array := StrSplit(A_LoopReadLine, ",", """")
  Maps[map_array[1]] := {}
  ;Maps[A_Index].Name := map_array[1]
  Maps[map_array[1]].Region := map_array[7]

  Regions[map_array[7]] := {}
  Regions[map_array[7]].SocketedStones := 0

  Maps[map_array[1]].Tier := [ map_array[2] . ".0", map_array[3] . ".0", map_array[4] . ".0", map_array[5] . ".0", map_array[6] . ".0" ]

  Maps[map_array[1]].LayoutRating := map_array[8]
  Maps[map_array[1]].Tileset := map_array[10]
  Maps[map_array[1]].BossRating := map_array[9]
  Maps[map_array[1]].Boss := map_array[11]

}

watchones := "" A_ScriptDir "\watchstones.ini" ""
For key, value in Conquerors {
  IniRead, output, %watchones%, %key%, region
  value.Region := output
  IniRead, output, %watchones%, %key%, appearances
  value.Appearances := output
}
If (numPart = 3) {
  IniRead, output, %watchones%, Watchstones, collected
  GuiControl, Controls:Choose, CurrentAct, % "|" output
}
ifnotexist,%watchones%
{
  For key, value in Conquerors {
    IniWrite, "", %watchones%, %key%, region
    IniWrite, 0, %watchones%, %key%, appearances
  }
  IniWrite, 00 Watchstones, %watchones%, Watchstones, collected
}

;MsgBox, % Conquerors["Al-Hezmin"].Appearances

;MsgBox, % Maps["Necropolis Map"].Tier[1]

;MsgBox, % Maps["Necropolis Map"].Tier[Regions[Maps["Necropolis Map"].Region].SocketedStones + 1] + 67

setMapNotes()
{
 Gui, Notes:Destroy
  If (hideNotes != "True") {
    Gui, Notes:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndNotesWindow
    Gui, Notes:font, c%whiteColor% s%points% w%boldness%, %font%
    Gui, Notes:Color, %backgroundColor%
    WinSet, Transparent, %opacity%
    Gui, Notes:Margin, %textMargin%, %textMargin%

    notes_width := 0
    numLines := 0

    ;Region
    val := "Region: " . Maps[CurrentZone].Region

    For key, value in Conquerors {
      If (value.Region = Maps[CurrentZone].Region) {
        color := value.Color
        Gui, Notes:font, c%color%
        break
      }
    }

    W := MeasureTextWidth(val, "s" . points . "  w" . boldness, font)
    If ( W > notes_width ){
      notes_width := W
    }

    yPosNoteLine := (numLines * Ceil(pixels*lineSpacing)) + textMargin
    Gui, Notes:Add, Text, xm y%yPosNoteLine%, % val
    numLines++


    ;Layout Rating
    val := "Layout Rating: " . Maps[CurrentZone].LayoutRating

    If (Maps[CurrentZone].LayoutRating = "A") {
      Gui, Notes:font, c%greenColor%
    } Else If (Maps[CurrentZone].LayoutRating = "B") {
      Gui, Notes:font, c%blueColor%
    } Else If (Maps[CurrentZone].LayoutRating = "C") {
      Gui, Notes:font, c%redColor%
    } Else {
      Gui, Notes:font, c%whiteColor%
    }

    W := MeasureTextWidth(val, "s" . points . "  w" . boldness, font)
    If ( W > notes_width ){
      notes_width := W
    }

    yPosNoteLine := (numLines * Ceil(pixels*lineSpacing)) + textMargin
    Gui, Notes:Add, Text, xm y%yPosNoteLine%, % val
    numLines++


    ;Tileset
    val := "Tileset: " . Maps[CurrentZone].Tileset
    Gui, Notes:font, c%whiteColor%

    W := MeasureTextWidth(val, "s" . points . "  w" . boldness, font)
    If ( W > notes_width ){
      notes_width := W
    }

    yPosNoteLine := (numLines * Ceil(pixels*lineSpacing)) + textMargin
    Gui, Notes:Add, Text, xm y%yPosNoteLine%, % val
    numLines++


    ;Boss Rating
    val := "Boss Rating: " . Maps[CurrentZone].BossRating

    If (Maps[CurrentZone].BossRating = "1") {
      Gui, Notes:font, c%greenColor%
    } Else If (Maps[CurrentZone].BossRating = "2") {
      Gui, Notes:font, c%blueColor%
    } Else If (Maps[CurrentZone].BossRating = "3") {
      Gui, Notes:font, c%yellowColor%
    } Else {
      Gui, Notes:font, c%redColor%
    }

    W := MeasureTextWidth(val, "s" . points . "  w" . boldness, font)
    If ( W > notes_width ){
      notes_width := W
    }

    yPosNoteLine := (numLines * Ceil(pixels*lineSpacing)) + textMargin
    Gui, Notes:Add, Text, xm y%yPosNoteLine%, % val
    numLines++


    ;Boss
    val := "Boss: " . Maps[CurrentZone].Boss
    Gui, Notes:font, c%whiteColor%

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

    notes_height := (numLines * Ceil(pixels*lineSpacing)) + (2 * textMargin)

    notes_width := notes_width + (2 * textMargin)

    If (hideGuide != "True") {
      xPosNotes := Round( (A_ScreenWidth * guideXoffset) - guide_width - controlSpace - atlas_width - controlSpace - notes_width )
    } Else {
      xPosNotes := Round( (A_ScreenWidth * guideXoffset) - notes_width )
    }
    Gui, Notes:Show, x%xPosNotes% y%yPosNotes% w%notes_width% h%notes_height% NA, Gui Notes
    Gui, Notes:Cancel
  }
}


setMapGuide()
{
 Gui, Guide:Destroy
 Gui, Atlas:Destroy
  If (hideGuide != "True") {
    Gui, Guide:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndGuideWindow
    Gui, Guide:Font, c%whiteColor% s%points% w%boldness%, %font%
    Gui, Guide:Color, %backgroundColor%
    WinSet, Transparent, %opacity%
    Gui, Guide:Margin, %textMargin%, %textMargin%

    guide_width := 0
    filepath := "" A_ScriptDir "\maps\guide.txt" ""
    numWatchstones := SubStr(CurrentAct, 1, 2)
    ;numWatchstones := "watchstones:" + numWatchstones
    ReadLines := "False"
    AtlasLine := []
    Loop, read, %filepath%
    {
      val := A_LoopReadLine
      searchWatchstones := SubStr(val, 13, 2)
      searchString := SubStr(val, 1, 12)
      If (searchWatchstones <= numWatchstones and searchString = "watchstones:") {
        ReadLines := "True"
        AtlasLine := []
      } Else If ( searchString = "watchstones:" ) {
        ReadLines := "False"
        break
      } Else {
        If (ReadLines = "True" and val != ""){
          AtlasLine.Push(val)
        }
      }
    }

    For index, val in AtlasLine
    {

      colorTest := SubStr(val, 1, 2)
      If (colorTest = "R,") {
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "G,") {
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "B,") {
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "Y,") {
        StringTrimLeft, val, val, 2
      } Else If (colorTest = "W,") {
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

          ;expand width if too small to fit all characters
          W := MeasureTextWidth(beginString, "s" . points . "  w" . boldness, font)
          If ( W > guide_width ){
            guide_width := W
          }

        } Else {

          ;expand width if too small to fit all characters
          W := MeasureTextWidth(val, "s" . points . "  w" . boldness, font)
          If ( W > guide_width ){
            guide_width := W
          }

          break
        }
      }
    }

    numLines := 0
    For index, val in AtlasLine
    {
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
          yPosGuideLine := (numLines * Ceil(pixels*lineSpacing)) + textMargin
          Gui, Guide:Add, Text, xm y%yPosGuideLine%, % beginString

          numLines++
        } Else {
          yPosGuideLine := (numLines * Ceil(pixels*lineSpacing)) + textMargin
          Gui, Guide:Add, Text, xm y%yPosGuideLine%, % val

          numLines++
          break
        }
      }
    }

    If (numLines = 0) {
      shortpath := "" "No text for " . CurrentAct . "`nin \maps\guide.txt" ""
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

    Gui, Atlas:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndAtlasWindow
    Gui, Atlas:Font, c%whiteColor% s%points% w%boldness%, %font%
    Gui, Atlas:Color, %backgroundColor%
    WinSet, Transparent, %opacity%
    Gui, Atlas:Margin, %textMargin%, %textMargin%

    numLines := 0
    atlas_width := 0

    For region, stones in Regions {
      Gui, Atlas:Font, c%whiteColor%
      atlasText := region . " [" . stones.SocketedStones . "] "
      For key, value in Conquerors {
        If (value.Region = region){
          atlasText := atlasText . "(" . value.Appearances . ")"
          color := value.Color
          Gui, Atlas:Font, c%color%
          break
        }
      }
      yPosGuideLine := (numLines * Ceil(pixels*lineSpacing)) + textMargin
      Gui, Atlas:Add, Text, xm y%yPosGuideLine%, % atlasText
      numLines++
      W := MeasureTextWidth(atlasText, "s" . points . "  w" . boldness, font)
      If ( W > atlas_width ){
        atlas_width := W
      }
    }


    atlas_height := (numLines * Ceil(pixels*lineSpacing)) + (2 * textMargin)
    atlas_width := atlas_width + (2 * textMargin)
    xPosGuide := Round( (A_ScreenWidth * guideXoffset) - guide_width - controlSpace - atlas_width)
    Gui, Atlas:Show, x%xPosGuide% y%yPosNotes% w%atlas_width% h%atlas_height% NA, Gui Atlas
    Gui, Atlas:Cancel
  }
}

UpdateMapImages() {
  ;For now just clear all the images
  zone_toggle := 0
  Loop, % maxImages {
      Gui, Image%A_Index%:Cancel
    }
}