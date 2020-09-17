DrawZone() {
  global

  gemFiles := []
	Loop %A_ScriptDir%\builds\%overlayFolder%\gems\*.ini
	{
    tempFileName = %A_LoopFileName%
    StringTrimRight, tempFileName, tempFileName, 4
    If (tempFileName != "meta") {
      gemFiles.Push(tempFileName)
    }
	}
  If (gemFiles.length() = 0){ ;If the file didnt exist it just got created, probably empty
    gemFiles := ["02"]
  }

  Gui, Controls:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndControls
  Gui, Controls:Color, %backgroundColor%
  Gui, Controls:Font, s%points%, %font%
  Gui, Controls:Add, DropDownList, VCurrentZone GzoneSelectUI x0 y0 w%notes_width% h300 , % GetDelimitedZoneListString(data.zones, CurrentAct)
  Gui, Controls:Add, DropDownList, VCurrentAct GactSelectUI x+%controlSpace% y0 w%nav_width% h200 , % GetDelimitedActListString(data.zones, CurrentAct, CurrentPart)
  Gui, Controls:Add, DropDownList, VCurrentPart GpartSelectUI x+%controlSpace% y0 w%nav_width% h200 , % GetDelimitedPartListString(data.parts, CurrentPart)
  xPos := xPosLayoutParent + (maxImages * (images_width+controlSpace))
  control_width := (nav_width*2) + notes_width + (controlSpace*2)
  yPos := controlSpace + (A_ScreenHeight * guideYoffset)
  Gui, Controls:Show, h%control_height% w%control_width% x%xPos% y%yPos% NA, Controls

  Gui, Gems:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndGems
  Gui, Gems:Color, %backgroundColor%
  Gui, Gems:Font, s%points%, %font%
  Gui, Gems:Add, DropDownList, Sort VCurrentGem GgemSelectUI x0 y0 w%gems_width% h300 , % GetDelimitedPartListString(gemFiles, CurrentGem)
  Gui, Gems:Show, h%control_height% w%gems_width% x%xPosGems% y%yPosGems% NA, Gems

  Gui, Level:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndLevel
  Gui, Level:Color, %backgroundColor%
  Gui, Level:Font, s%points%, %font%
  Gui, Level:Add, Edit, x0 y0 h%control_height% w%level_width% r1 GlevelSelectUI, Level
  Gui, Level:Add, UpDown, x%controlSpace% vCurrentLevel GlevelSelectUI Range1-100, %CurrentLevel%
  Gui, Level:Show, h%exp_height% w%level_width% x%xPosLevel% y%yPosLevel% NA, Level

  ;The names of the images have to be created now so that ShowAllWindows doesn't make empty ones that show up in the Alt Tab bar
  Loop, % maxImages {
    Gui, Image%A_index%:+E0x20 +E0x80 -DPIScale -resize -SysMenu -Caption +ToolWindow +AlwaysOnTop +hwndImage%newIndex%Window
  }
}



DrawTree() {
  global

  image_file := "" A_ScriptDir "\builds\" overlayFolder "\" CurrentAct "\" treeName ""
  If (FileExist(image_file))
  {
    GDIPToken := Gdip_Startup()

    pBM := Gdip_CreateBitmapFromFile( image_file )
    original_treeW:= Gdip_GetImageWidth( pBM )
    original_treeH:= Gdip_GetImageHeight( pBM )

    Gdip_DisposeImage( pBM )
    Gdip_Shutdown( GDIPToken )

    ;Only build the tree if the file is a valid size picture
    If (original_treeW and original_treeH)
    {
      If (original_treeW > original_treeH) {
        treeW := Round( A_ScreenWidth / 2 )
        treeRatio := treeW / original_treeW
        treeH := original_treeH * treeRatio
      } else {
        treeH := Round( A_ScreenHeight * 4 / 5 )
        treeRatio := treeH / original_treeH
        treeW := original_treeW * treeRatio
      }

	    If (treeSide = "Right") {
		    xTree := A_ScreenWidth - treeW
	    } else {
		    xTree := 0
	    }
	    yTree := A_ScreenHeight - treeH

	    Gui, Tree:+E0x20 +E0x80 -Caption +ToolWindow +LastFound +AlwaysOnTop -Resize -DPIScale +hwndTreeWindow
	    Gui, Tree:Add, Picture, x0 y0 w%treeW% h%treeH%, %image_file%

	    Gui, Tree:Show, x%xTree% y%yTree% w%treeW% h%treeH% NA, Gui Tree
	    WinSet, Transparent, 240, ahk_id %TreeWindow%
	  }
  }
}



DrawExp(){
  global

  Gui, Exp:+E0x20 +E0x80 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndExp
  Gui, Exp:font, cFFFFFF s%points% w%level_width%, %font%
  Gui, Exp:Color, %backgroundColor%
  WinSet, Transparent, %opacity%

  calcExp := "Exp: 100.0%   Over: +10"

  CurrentExp = ""
  Gui, Exp:Add, Text, vCurrentExp x3 y3, % calcExp

  Gui, Exp:Show, x%xPosExp% y%yPosExp% w%exp_width% h%exp_height% NA, Gui Exp
}



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



partSelectUI() {
  global
  Gui, Controls:Submit, NoHide

  If (CurrentPart = "Part I") {
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
  If (numPart != 3) {
    SetNotes()
    SetGuide()
  }
  If (zone_toggle = 1) {
    UpdateImages()
  }
  trigger := true
  WinActivate, ahk_id %PoEWindowHwnd%

  SaveState()
}



actSelectUI() {
  global
  Gui, Controls:Submit, NoHide

  CurrentZone := GetDefaultZone(data.zones, CurrentAct)
  GuiControl,,CurrentZone, % "|" test := GetDelimitedZoneListString(data.zones, CurrentAct)
  Sleep 100
  If (numPart != 3) {
    SetNotes()
    SetGuide()
  }
  If (zone_toggle = 1) {
    UpdateImages()
  }
  WinActivate, ahk_id %PoEWindowHwnd%
  SaveState()
}



zoneSelectUI() {
  global
  Gui, Controls:Submit, NoHide
  Sleep 100
  If (numPart != 3) {
    SetNotes()
  }
  If (zone_toggle = 1) {
    UpdateImages()
  }
  WinActivate, ahk_id %PoEWindowHwnd%
  SaveState()
}



levelSelectUI() {
  global
  Gui, Level:Submit, NoHide
  SetExp()
  SaveState()
}



gemSelectUI() {
  global
  Gui, Gems:Submit, NoHide
  SetGems()
  WinActivate, ahk_id %PoEWindowHwnd%
  SaveState()
}



GetDefaultZone(zones, act) {
  For key, zoneGroup in zones {
    If (zoneGroup.act = act) {
      Return zoneGroup.default
    }
  }
}



UpdateImages()
{
  global
  emptySpaces := 0
  Loop, % maxImages {
	  imageIndex := (maxImages - A_Index) + 1
    filepath := "" A_ScriptDir "\images\" CurrentAct "\" CurrentZone "_Seed_" imageIndex ".jpg" ""

	  newIndex := A_index - emptySpaces
	  ;This shouldn't happen anymore but if this method gets called twice quickly newIndex goes below 0
	  If (newIndex < 1) {
	    newIndex := 1
	  }
    
    If (FileExist(filepath)) {
      xPos := xPosLayoutParent + ((maxImages - (newIndex + 0)) * (images_width+controlSpace))
      Gui, Image%newIndex%:+E0x20 +E0x80 -DPIScale -resize -SysMenu -Caption +ToolWindow +AlwaysOnTop +hwndImage%newIndex%Window
      Gui, Image%newIndex%:Add, Picture, x0 y0 w%images_width% h%images_height%, %filepath%
      Gui, Image%newIndex%:Show, w%images_width% h%images_height% x%xPos% y%yPosNotes% NA, Image%newIndex%
      id := Image%newIndex%Window
      WinSet, Transparent, %opacity%, ahk_id %id%
      Gui, Image%newIndex%:Cancel
    }
    Else {
	    emptySpaces++
      ;Have to show the image to make it invisible (in case zone_toggle is off)
      Gui, Image%imageIndex%:Show, NA
      hideId := Image%imageIndex%Window
      WinSet, Transparent, 0, ahk_id %hideId%
      Gui, Image%imageIndex%:Cancel
    }
  }
}