#SingleInstance, force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include, %A_ScriptDir%\lib\JSON.ahk
#Include, %A_ScriptDir%\lib\Gdip.ahk

Menu, Tray, Icon, %A_ScriptDir%\lvlG.ico
Menu, Tray, Tip, Leveling Guide - PoE

GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_KG.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExileSteam.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64Steam.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64_KG.exe


;
; ========= Settings =========
;

global data := {}
Try {
    FileRead, JSONFile, %A_ScriptDir%\data.json
    data := JSON.Load(JSONFile)
    If (not data.p1acts.Length()) {
        MsgBox, 16, , Error reading zone data! `n`nExiting script.
        ExitApp
    }
} Catch e {
    MsgBox, 16, , % e "`n`nExiting script."
    ExitApp
}

global overlayFolder := "Overlays"
global points := 9
global maxNotesWidth := 30
global maxGuideWidth := 30
global offset := .8
global treeSide := "right"
global treeName := "tree.jpg"
global opacity := 200
global displayTimeout := 5
global persistText := 0

global zone_toggle := 0
global level_toggle := 0
global tree_toggle := 0
global LG_toggle := 0
global activeCount := 0
global active_toggle := 1

global config := {}
Try {
    FileRead, JSONFile, %A_ScriptDir%\config.json
    config := JSON.Load(JSONFile)
} Catch e {
    MsgBox, 16, , % e "`n`nExiting script."
    ExitApp
}
If (config.overlayFolder != "") {
	overlayFolder := config.overlayFolder
}
If (config.points != "") {
	points := config.points
}
If (config.maxNotesWidth != "") {
	maxNotesWidth := config.maxNotesWidth
}
If (config.maxGuideWidth != "") {
	maxGuideWidth := config.maxGuideWidth
}
If (config.offset != "") {
	offset := config.offset
}
If (config.treeSide != "") {
	treeSide := config.treeSide
}
If (config.treeName != "") {
	treeName := config.treeName
}
If (config.opacity != "") {
	opacity := config.opacity
}
If (config.startHidden != "") {
	LG_toggle := config.startHidden
}
If (config.displayTimeout != "") {
	displayTimeout := config.displayTimeout
}
If (config.persistText != "") {
	persistText := config.persistText
}

;Default value - this is autodetected now too
global client := "C:\Program Files (x86)\Grinding Gear Games\Path of Exile\logs\Client.txt"

;default
global pixels := 12
global spacing := 3

;calculated
RegRead, localDPI, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
If (errorlevel) {
    localDPI := 96
}
pixels := Ceil( points * (localDPI / 72) )
pixels := pixels + spacing

maxNotesWidth := maxNotesWidth < 30 ? 30 : maxNotesWidth
maxGuideWidth := maxGuideWidth < 22 ? 22 : maxGuideWidth
global notes_width := Ceil( (maxNotesWidth) * (pixels/2) )
global guide_width := Ceil( (maxGuideWidth) * (pixels/2) )
global nav_width := Ceil( (guide_width-5)/2 )
global level_width := Ceil( 7 * (pixels/2) )
global exp_width := Ceil( 19 * (pixels/2) )
global control_height := pixels + 7
global exp_height := control_height

global maxImages := 6
global xPosLayoutParent := Round( (A_ScreenWidth * offset) - (maxImages * 115) - guide_width - notes_width - 10 )
global yPosNotes := 5 + control_height + 5
global xPosNotes := xPosLayoutParent + (maxImages * 115)
global xPosGuide := xPosLayoutParent + (maxImages * 115) + notes_width + 5

global xPosLevel := Round( (A_ScreenWidth * .287) )
global yPosLevel := Round( (A_ScreenHeight * .955) )
global xPosExp := xPosLevel + level_width + 5
global yPosExp := yPosLevel

global PoEWindowHwnd := ""
WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp

global old_log := ""
global trigger := false

global numPart := 1
global CurrentPart = "Part I"
global CurrentAct = "Act I"
global CurrentZone = "01 Twilight Strand"
global CurrentLevel = "01"

global onStartup := 1

Gosub, DrawZone
Gosub, DrawTree
Gosub, DrawNotes
Gosub, DrawGuide
GoSub, DrawExp

Gosub, HideAllWindows
GoSub, ToggleLevelingGuide

Sleep 1000
Loop, % maxImages {
    Gui, Image%A_Index%:Cancel
}
zone_toggle := 0

SetTimer, ShowGuiTimer, 250
Return


;
; ========= HOTKEYS =========
;

;========== Toggle Everything =======
#IfWinActive, ahk_group PoEWindowGrp
!F1:: ; Display/Hide all GUIs
    GoSub, ToggleLevelingGuide
return

;========== Zone Layouts =======
#IfWinActive, ahk_group PoEWindowGrp
!F2:: ; Display/Hide zone layout images hotkey
    if (zone_toggle = 0 and LG_toggle)
    {
	GoSub, UpdateImages
	Loop, % maxImages {
            Gui, Image%A_Index%:Show, NA
        }
        zone_toggle := 1
    }
    else
    {
        Loop, % maxImages {
            Gui, Image%A_Index%:Cancel
        }
        zone_toggle := 0
    }
return

;========== Experience Tracker =======
#IfWinActive, ahk_group PoEWindowGrp
!F3:: ; Display/Hide experience hotkey
  if (level_toggle = 0)
  {
    Gui, Level:Show, NA
    Gui, Exp:Show, NA
    level_toggle := 1
  }
  else
  {
    Gui, Level:Cancel
    Gui, Exp:Cancel
    level_toggle := 0
  }
return

;========== Skill Tree =======
#IfWinActive, ahk_group PoEWindowGrp
!p:: ; Display/Hide passive tree when it's open
  if (tree_toggle = 0)
  {
    Gui, Tree:Show, NA
    tree_toggle := 1
  }
  else
  {
    Gui, Tree:Cancel
    tree_toggle := 0
  }
return

;========== Clear extra overlays =======
#IfWinActive, ahk_group PoEWindowGrp
~Space:: ; Display/Hide extra overlays
  if (tree_toggle = 1)
  {
    Gui, Tree:Cancel
    tree_toggle := 0
  }
return


;========== Switching Dropdowns =======

#IfWinActive, ahk_group PoEWindowGrp
^F1::
GoSub, cycleZoneDown
return

#IfWinActive, ahk_group PoEWindowGrp
+F1::
GoSub, cycleZoneUp
return


;
; ========= MAIN =========
;


;========== Subs and Functions =======

ToggleLevelingGuide:
  if (LG_toggle = 0 or active_toggle = 0)
  {
    GoSub, ShowAllWindows
    LG_toggle = 1
    level_toggle = 1
    activeCount := 0
    active_toggle := 1
  } else {
    GoSub, HideAllWindows
    tree_toggle := 0
    LG_toggle = 0
  }
return

DrawTree:

    image_file := "" A_ScriptDir "\" overlayFolder "\Tree\" treeName ""
    If (FileExist(image_file)) {
	GDIPToken := Gdip_Startup()

	pBM := Gdip_CreateBitmapFromFile( image_file )
	original_treeW:= Gdip_GetImageWidth( pBM )
	original_treeH:= Gdip_GetImageHeight( pBM )

	Gdip_DisposeImage( pBM )
	Gdip_Shutdown( GDIPToken )

	;Only build the tree if the file is a valid size picture
	If (original_treeW and original_treeH) {
	    treeW := Round( A_ScreenWidth / 3 )
	    treeRatio := treeW / original_treeW
	    treeH := original_treeH * treeRatio

	    If (treeSide = "right") {
		xTree := A_ScreenWidth - treeW
	    } else {
		xTree := 0
	    }
	    yTree := A_ScreenHeight - treeH

	    Gui, Tree:+E0x20 -Caption +ToolWindow +LastFound +AlwaysOnTop -Resize +DPIScale +hwndTreeWindow
	    Gui, Tree:Add, Picture, x0 y0 w%treeW% h%treeH%, %image_file%

	    Gui, Tree:Show, x%xTree% y%yTree% w%treeW% h%treeH% NA, Gui Tree
	    WinSet, Transparent, 240, ahk_id %TreeWindow%
	}
    }

return

DrawNotes:
    Gui, Notes:+E0x20 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndNotesWindow
    Gui, Notes:font, cFFFFFF s%points% w800, Consolas
    Gui, Notes:Color, gray
    WinSet, Transparent, %opacity%

    ;empty space must be initialized at set length
    ;so that text area can be edited with custom notes
    numLines := 60
    notesText := ""
    Loop, % numLines {
        Loop, % maxNotesWidth {
	    notesText .= " "
        }
	notesText .= "`n"
    }


    Gui, Notes:Add, Text, vActNotes x5 y+3 -Wrap, % notesText

    notes_height := (numLines * pixels) + spacing

    Gui, Notes:Show, x%xPosNotes% y%yPosNotes% w%notes_width% h%notes_height% NA, Gui Notes
return

DrawGuide:
    Gui, Guide:+E0x20 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndGuideWindow
    Gui, Guide:font, cFFFFFF s%points% w800, Consolas
    Gui, Guide:Color, gray
    WinSet, Transparent, %opacity%

    ;empty space must be initialized at set length
    ;so that text area can be edited with custom notes
    numLines := 60
    guideText := ""
    Loop, % numLines {
        Loop, % maxNotesWidth {
	    guideText .= " "
        }
	guideText .= "`n"
    }


    Gui, Guide:Add, Text, vActGuide x5 y+3 -Wrap, % guideText

    guide_height := (numLines * pixels) + spacing

    Gui, Guide:Show, x%xPosGuide% y%yPosNotes% w%guide_width% h%guide_height% NA, Gui Guide
    guide_toggle := 1
return


DrawZone:
    Gui, Parent:New, +AlwaysOnTop +ToolWindow +hwndParentWindow
    Gui, Parent:Color, brown
    Gui, Parent:Show, w110 h60 x%xPosLayoutParent% y5
    WinSet, TransColor, brown, A

    WinSet, ExStyle, +0x20, ahk_id %ParentWindow% ; 0x20 = WS_EX_CLICKTHROUGH
    WinSet, Style, -0xC00000, ahk_id %ParentWindow%x

    Loop, % maxImages {
        filepath := "" A_ScriptDir "\" overlayFolder "\" CurrentAct "\" CurrentZone "_Seed_" A_Index ".jpg" ""
        xPos := xPosLayoutParent + ((maxImages - (A_Index + 0)) * 115)

        Gui, Image%A_Index%:New, +E0x20 -DPIScale -resize -SysMenu -Caption +AlwaysOnTop +hwndImage%A_Index%Window
        Gui, Image%A_Index%:Add, Picture, VPic%A_Index% x0 y0 w110 h60, %filepath%
        Gui, Image%A_Index%:Show, w110 h60 x%xPos% y5 NA, Image%A_Index%
        Gui, Image%A_Index%:+OwnerParent

	id := Image%A_Index%Window
        If (not FileExist(filepath)) {
            WinSet, Transparent, 0, ahk_id %id%
        } Else {
            WinSet, Transparent, %opacity%, ahk_id %id%
        }
    }
    zone_toggle := 1

    Gui, Controls:+E0x20 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndControls
    Gui, Controls:Color, gray
    Gui, Controls:Font, s%points%, Consolas
    Gui, Controls:Add, DropDownList, VCurrentZone GzoneSelectUI x0 y0 w%notes_width% h300 , % GetDelimitedZoneListString(data.zones, CurrentAct)
    Gui, Controls:Add, DropDownList, VCurrentAct GactSelectUI x+5 y0 w%nav_width% h200 , % GetDelimitedActListString(data.zones, CurrentAct, CurrentPart)
    Gui, Controls:Add, DropDownList, VCurrentPart GpartSelectUI x+5 y0 w%nav_width% h200 , % GetDelimitedPartListString(data.parts, CurrentPart)
    Gui, Controls:+OwnerParent
    xPos := xPosLayoutParent + (maxImages * 115)
    control_width := (nav_width*2) + notes_width + 10
    Gui, Controls:Show, h%control_height% w%control_width% x%xPos% y5 NA, Controls

    Gui, Level:+E0x20 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndlevel
    Gui, Level:Color, gray
    Gui, Level:Font, s%points%, Consolas
    Gui, Level:Add, Edit, x0 y0 h%control_height% w%level_width% r1 GlevelSelectUI, Level
    Gui, Level:Add, UpDown, x5 vCurrentLevel GlevelSelectUI Range1-100, 1
    Gui, Level:+OwnerParent
    Gui, Level:Show, h%control_height% w%level_width% x%xPosLevel% y%yPosLevel% NA, Level
return

;never called, moved to draw zone, may use again in the future
DrawLevel:
    Gui, Level:+E0x20 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndlevel
    Gui, Level:Color, gray
    Gui, Level:Font, s%points%, Consolas
    Gui, Level:Add, Edit, x0 y0 h%control_height% w%level_width% r1 GlevelSelectUI, Level
    Gui, Level:Add, UpDown, x5 vCurrentLevel GlevelSelectUI Range1-100, 1
    Gui, Level:Show, h%control_height% w%level_width% x%xPosLevel% y%yPosLevel% NA, Level
    level_toggle := 1
return

DrawExp:
  Gui, Exp:+E0x20 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndExpWindow
  Gui, Exp:font, cFFFFFF s%points% w%level_width%, Consolas
  Gui, Exp:Color, gray
  WinSet, Transparent, %opacity%

  calcExp := "Exp: 100.0%   Over: +10"

  Gui, Exp:Add, Text, vCurrentExp x3 y3, % calcExp

  Gui, Exp:Show, x%xPosExp% y%yPosExp% w%exp_width% h%exp_height% NA, Gui Exp
return

GetDelimitedPartListString(data, part) {
  dList := ""
  For key, partItem in data {
    dList .= partItem . "|"
    If (partItem = part) {
      dList .= "|"
    }
  }
  Return dList
}

GetDelimitedActListString(data, act, part) {
  dList := ""
  For key, zoneGroup in data {
    If (zoneGroup.part = part) {
      dList .= zoneGroup.act . "|"
    }
    If (zoneGroup.act = act) {
      dList .= "|"
    }
  }
  Return dList
}

GetDelimitedZoneListString(data, act) {
  dList := ""
  For key, zoneGroup in data {
    If (zoneGroup.act = act) {
      For k, val in zoneGroup.list {
        dList .= val . "|"
        If (val = CurrentZone) {
          dList .= "|"
        }
      }
      break
    }
  }
  Return dList
}

GetDefaultZone(zones, act) {
  For key, zoneGroup in zones {
    If (zoneGroup.act = act) {
      Return zoneGroup.default
    }
  }
}

RotateZone(direction, zones, act, current) {
  newZone := ""
  indexShift := direction = "next" ? 1 : -1
  first := ""
  last := ""

  For key, zone in zones {
    If (zone.act = act) {
      Loop, % zone["list"].Length()
      {
        If (A_Index = 1) {
          first := zone.list[A_Index]
        }
        If (A_Index = zone.list.MaxIndex()) {
          last := zone.list[A_Index]
        }
        If (zone.list[A_Index] = current) {
          newZone := zone.list[A_Index + indexShift]
        }
      }
      break
    }
  }

  If (not StrLen(newZone)) {
    newZone := direction = "next" ? first : last
  }
  Return newZone
}

RotateAct(direction, acts, current) {
  newAct := ""
  indexShift := direction = "next" ? 1 : -1
  first := ""
  last := ""

  Loop, % acts.Length()
  {
    If (A_Index = 1) {
      first := acts[A_Index]
    }
    If (A_Index = acts.MaxIndex()) {
      last := acts[A_Index]
    }

    If (acts[A_Index] = current) {
      newAct := acts[A_Index + indexShift]
    }
  }

  If (not StrLen(newAct)) {
    newAct := direction = "next" ? first : last
  }

  Return newAct
}

partSelectUI:
  Gui, Controls:Submit, NoHide

  If (CurrentPart = "Part I"){
    CurrentAct := "Act I"
    numPart := 1
  } Else If (CurrentPart = "Part II") {
    CurrentAct := "Act VI"
    numPart := 2
  } Else {
    CurrentAct := "Tier 1"
    numPart := 3
    Gui, Notes:Cancel
    Gui, Guide:Cancel
  }

  GuiControl,,CurrentAct, % "|" test := GetDelimitedActListString(data.zones, CurrentAct, CurrentPart)
  Sleep 100

  CurrentZone := GetDefaultZone(data.zones, CurrentAct)
  GuiControl,,CurrentZone, % "|" test := GetDelimitedZoneListString(data.zones, CurrentAct)
  Sleep 100
  GoSub, UpdateImages
  trigger := true
return

actSelectUI:
  Gui, Controls:Submit, NoHide

  Loop, % maxImages {
    Gui, Image%A_Index%:Submit, NoHide
  }

  CurrentZone := GetDefaultZone(data.zones, CurrentAct)
  GuiControl,,CurrentZone, % "|" test := GetDelimitedZoneListString(data.zones, CurrentAct)
  Sleep 100
  GoSub, UpdateImages
return

levelSelectUI:
  Gui, Level:Submit, NoHide
  GoSub, setExp
return

setNotes:
  notesText := ""
  numLines := 0
  filepath := "" A_ScriptDir "\" overlayFolder "\" CurrentAct "\" CurrentZone ".txt" ""
  Loop, read, %filepath%
  {
    val:= A_LoopReadLine
    beginString := A_LoopReadLine
    ;Wrap notes longer than maxNotesWidth
    while true
    {
      StringLen, stringLength, val
      If (stringLength > maxNotesWidth) {
        StringGetPos, lastCharPos, val, %A_Space%, R1, stringLength-maxNotesWidth

        StringLeft, beginString, val, lastCharPos+1
        StringTrimLeft, val, val, lastCharPos+1
        notesText .= beginString "`n"
        numLines++
      } Else {
        notesText .= val "`n"
        numLines++
        break
      }
    }
  }

  shortpath := "" "Add notes to \" overlayFolder "\" CurrentAct "\`n" CurrentZone ".txt" ""
  numLines := notesText = "" ? 2 : numLines
  notesText := notesText = "" ? shortpath : notesText

  GuiControl,Notes:,ActNotes, %notesText%

  numLines := numLines = 0 ? 1 : numLines
  notes_height := (numLines * pixels) + spacing

  Gui, Notes:Show, x%xPosNotes% y%yPosNotes% w%notes_width% h%notes_height% NA, Gui Notes
return

setGuide:
  guideText := ""
  numLines := 0
  filepath := "" A_ScriptDir "\" overlayFolder "\" CurrentAct "\" "guide.txt" ""
  Loop, read, %filepath%
  {
    val:= A_LoopReadLine
    beginString := A_LoopReadLine
    ;Wrap lines longer than maxGuideWidth
    while true
    {
      StringLen, stringLength, val
      If (stringLength > maxGuideWidth) {
        StringGetPos, lastCharPos, val, %A_Space%, R1, stringLength-maxGuideWidth

        StringLeft, beginString, val, lastCharPos+1
        StringTrimLeft, val, val, lastCharPos+1
        guideText .= beginString "`n"
        numLines++
      } Else {
        guideText .= val "`n"
        numLines++
        break
      }
    }
  }

  shortpath := "" "Add guide to \" overlayFolder "\" CurrentAct "\`n" "guide.txt" ""
  numLines := guideText = "" ? 2 : numLines
  guideText := guideText = "" ? shortpath : guideText

  GuiControl,Guide:,ActGuide, %guideText%

  numLines := numLines = "" ? 1 : numLines
  guide_height := (numLines * pixels) + spacing

  Gui, Guide:Show, x%xPosGuide% y%yPosNotes% w%guide_width% h%guide_height% NA, Gui Guide
  guide_toggle := 1
return

SetExp:
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

  calcExp := "Exp: "

  calcExp .= Round(expMulti * 100)
  calcExp .= "%   "

  calcExp .= "Over: "
  calcExp .= CurrentLevel - (Floor(monsterLevel) - safeZone)

  GuiControl,Exp:,CurrentExp, %calcExp%

  Gui, Exp:Show, x%xPosExp% y%yPosExp% w%exp_width% h%exp_height% NA, Gui Exp
return

zoneSelectUI:
  Gui, Controls:Submit, NoHide

  GoSub, UpdateImages
return

cycleZoneUp:
  Gui, Controls:Submit, NoHide
  newZone := RotateZone("next", data.zones, CurrentAct, CurrentZone)
  GuiControl, Controls:Choose, CurrentZone, % "|" newZone
  Sleep 100
  GoSub, UpdateImages
  activeCount := 0
return

cycleZoneDown:
  Gui, Controls:Submit, NoHide
  newZone := RotateZone("previous", data.zones, CurrentAct, CurrentZone)
  GuiControl, Controls:Choose, CurrentZone, % "|" newZone
  Sleep 100
  GoSub, UpdateImages
  activeCount := 0
return

UpdateImages:
    emptySpaces := 0
    Loop, % maxImages {
	imageIndex := (maxImages - A_Index) + 1
        filepath := "" A_ScriptDir "\" overlayFolder "\" CurrentAct "\" CurrentZone "_Seed_" imageIndex ".jpg" ""

	newIndex := A_index - emptySpaces
	;This shouldn't happen anymore but if this method gets called twice quickly emptySpaces goes below 0
	If (newIndex < 1) {
	    newIndex := 1
	}
        id := Image%newIndex%Window

        If (FileExist(filepath)) {
            GuiControl,Image%newIndex%:,Pic%newIndex%, *w110 *h60 %filepath%
            WinSet, Transparent, %opacity%, ahk_id %id%
        }
        Else {
	    emptySpaces++
	    largeId := Image%imageIndex%Window
            WinSet, Transparent, 0, ahk_id %largeId%
        }
    }
return

;========== Auto Magic Zone Changing =======

SearchAct:
  ;You can check more than one line to make this more robust,
  ;but then sometimes voice logs will trigger the wrong map update
  log := Tail(1, client)
  ;Only bother checking if the log has changed or someone manually changed Part
  If (log != oldLog or trigger)
  {
    oldLog := log
    trigger := false
    levelUp := "is now level"
    IfInString, log, %levelUp%
    {
      levelPos := InStr(log, levelUp, false)
      newLevel := SubStr(log, levelPos+13, 2)
      GuiControl,Level:,CurrentLevel, %newLevel%
      If(level_toggle){
        GoSub, setExp
      }
    }
    travel := "You have entered"
    IfInString, log, %travel%
    {
      activeCount := 0
      active_toggle := 1

      newPartTest := "Lioneye's Watch"
      IfInString, log, %newPartTest%
      {
        act5LastZone := "45 Cathedral Rooftop"
        If (CurrentZone = act5LastZone)
        {
          numPart := 2
          CurrentPart := "Part II"
          GuiControl, Controls:Choose, CurrentPart, % "|" CurrentPart
        }
      }

      newAct := CurrentAct
      ;loop through all of the acts in the current part
      Loop, 17 {
        For key, zoneGroup in data.zones {
        If (zoneGroup.act = newAct) {
          For k, newZone in zoneGroup.list {
            StringTrimLeft, zoneSearch, newZone, 3
            ;add "The" to all the zones so this works everywhere
            If (numPart = 3) {
              zoneSearch := "entered " + zoneSearch
            }
            IfInString, log, %zoneSearch%
            {
              If (newAct != CurrentAct) {
                GuiControl, Controls:Choose, CurrentAct, % "|" newAct
                CurrentAct := newAct
                Sleep 100
              }
              GuiControl, Controls:Choose, CurrentZone, % "|" newZone
              CurrentZone := newZone
              Sleep 100
              break 3
            }
          }
          If (numPart = 1){
            actData := data.p1acts
          } Else If (numPart = 2) {
            actData := data.p2acts
          } Else {
            actData := data.maps
          }
          newAct := RotateAct("next", actData, newAct)
          break
        }
      }
    }
    return
  }
  return
}
return

ShowGuiTimer:
  poe_active := WinActive("ahk_id" PoEWindowHwnd)
  controls_active := WinActive("ahk_id" Controls)
  level_active := WinActive("ahk_id" Level)

  If (activeCount <= 2*displayTimeout) {
    active_toggle := 1
    If (!controls_active) {
      activeCount++
    }
  } Else if (activeCount = 2*displayTimeout + 1) {
    GoSub, HideAllWindows
    active_toggle := 0
    activeCount++
  }

  If (controls_active or displayTimeout=0) {
    activeCount := 0
    active_toggle := 1
  }

  MouseGetPos, xposMouse, yposMouse
  If (yposMouse < 10 and xposMouse > A_ScreenWidth-Round(A_ScreenWidth/4)) {
    activeCount := 0
    active_toggle := 1
  }

  If (poe_active or (controls_active or level_active)) {
    ; show all gui windows
    GoSub, ShowAllWindows
    Sleep 500
  } Else {
    GoSub, HideAllWindows
    ;Reset activity upon return
    activeCount := 0
    active_toggle := 1
  }

  While true
  {
    ;The PoEWindow doesn't stay active through a restart, so must wait for it to be open
    closed := 0

    Process, Exist, PathOfExile.exe
    If(!errorlevel) {
      closed++
    } Else {
      client := GetProcessPath( "PathOfExile.exe" )
      StringTrimRight, client, client, 15
      client .= "logs\Client.txt"
    }

    Process, Exist, PathOfExileSteam.exe
    If(!errorlevel) {
      closed++
    } Else {
      client := GetProcessPath( "PathOfExileSteam.exe" )
      StringTrimRight, client, client, 20
      client .= "logs\Client.txt"
    }

    Process, Exist, PathOfExile_KG.exe
    If(!errorlevel) {
      closed++
    } Else {
      client := GetProcessPath( "PathOfExile_KG.exe" )
      StringTrimRight, client, client, 18
      client .= "logs\Client.txt"
    }

    Process, Exist, PathOfExile_x64.exe
    If(!errorlevel) {
      closed++
    } Else {
      client := GetProcessPath( "PathOfExile_x64.exe" )
      StringTrimRight, client, client, 19
      client .= "logs\Client.txt"
    }

    Process, Exist, PathOfExile_x64Steam.exe
    If(!errorlevel) {
      closed++
    } Else {
      client := GetProcessPath( "PathOfExile_x64Steam.exe" )
      StringTrimRight, client, client, 24
      client .= "logs\Client.txt"
    }

    Process, Exist, PathOfExile_x64_KG.exe
    If(!errorlevel) {
      closed++
    } Else {
      client := GetProcessPath( "PathOfExile_x64_KG.exe" )
      StringTrimRight, client, client, 22
      client .= "logs\Client.txt"
    }

    if (closed = 6){
      GoSub, HideAllWindows
      ;Sleep 10 seconds, no need to keep checking this
      Sleep 10000
      ;Reset activity upon return
      activeCount := 0
      active_toggle := 1
    } else {
      if (onStartup) {
        ;delete Client.txt on startup so we don't have to read a HUGE file
        file := FileOpen(client, "w")
        if IsObject(file) {
          file.Close()
        }
        onStartup := 0
      }
      WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
      break
    }
  } ;End While

  ;Magic
  GoSub, SearchAct

return

ShowAllWindows:
  ;Gui, Parent:Show, NoActivate
  If (LG_toggle and active_toggle) {
    Gui, Controls:Show, NoActivate
  }
  controls_active := WinActive("ahk_id" Controls)
  If (LG_toggle and !controls_active and (active_toggle or persistText) and numPart != 3) {
    GoSub, setNotes
    GoSub, setGuide
  }

  If (LG_toggle and zone_toggle) {
    Loop, % maxImages {
      Gui, Image%A_Index%:Show, NoActivate
    }
  }

  If (level_toggle) {
    Gui, Level:Show, NoActivate
    GoSub, setExp
  }

  If (tree_toggle) {
    Gui, Tree:Show, NoActivate
  }
return

HideAllWindows:
    Gui, Parent:Cancel
    Gui, Controls:Cancel
    Gui, Level:Cancel
    Gui, Exp:Cancel

    Loop, % maxImages {
        Gui, Image%A_Index%:Cancel
    }

    Gui, Notes:Cancel
    Gui, Guide:Cancel

    Gui, Tree:Cancel
return

Tail(k,file)   ; Return the last k lines of file
{
   Loop Read, %file%
   {
      i := Mod(A_Index,k)
      L%i% = %A_LoopReadLine%
   }
   L := L%i%
   Loop % k-1
   {
      IfLess i,1, SetEnv i,%k%
      i--      ; Mod does not work here
      L := L%i% "`n" L
   }
   Return L
}

GetProcessPath(exe) {
    for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where name ='" exe "'")
        return process.ExecutablePath
}

GuiClose:
ExitApp
