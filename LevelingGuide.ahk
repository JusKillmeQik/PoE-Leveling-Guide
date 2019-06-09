#SingleInstance, force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include, %A_ScriptDir%\lib\JSON.ahk

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

global points := 9
global maxNotesWidth := 40
global offset := .8
global opacity := 200

global zone_toggle := 0
global notes_toggle := 0
global LG_toggle := 0

global config := {}
Try {
    FileRead, JSONFile, %A_ScriptDir%\config.json
    config := JSON.Load(JSONFile)
} Catch e {
    MsgBox, 16, , % e "`n`nExiting script."
    ExitApp
}
If (config.points != "") {
	points := config.points
}
If (config.maxNotesWidth != "") {
	maxNotesWidth := config.maxNotesWidth
}
If (config.offset != "") {
	offset := config.offset
}
If (config.opacity != "") {
	opacity := config.opacity
}
If (config.startHidden != "") {
	LG_toggle := config.startHidden
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
pixels := Round( points * (localDPI / 72) )
spacing := Round( pixels/4 )
pixels := pixels + spacing

global notes_width := Floor( (maxNotesWidth-1) * (pixels/2) )

global maxImages := 6
global xPosLayoutParent := Round( (A_ScreenWidth * offset) - (maxImages * 115) - notes_width )
global xPosNotes := xPosLayoutParent + (maxImages * 115)

global PoEWindowHwnd := ""
WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp

global old_log := ""
global trigger := false

global numPart := 1
global CurrentPart = "Part I"
global CurrentAct = "Act I"
global CurrentZone = "Twilight Strand"

Gosub, DrawZone
Gosub, DrawNotes
GoSub, ToggleLevelingGuide

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
!F2:: ; Display/Hide zone layout window hotkey
    if (zone_toggle = 0)
    {
	Gui, Parent:Show, NA
        Gui, Controls:Show, NA
	GoSub, UpdateImages
	Loop, % maxImages {
            Gui, Image%A_Index%:Show, NA
        }
        zone_toggle := 1
    }
    else
    {
        Gui, Parent:Cancel
        Gui, Controls:Cancel
        Loop, % maxImages {
            Gui, Image%A_Index%:Cancel
        }
        zone_toggle := 0
    }
return

;========== Reward Notes =======
#IfWinActive, ahk_group PoEWindowGrp
!F3:: ; Display/Hide notes window hotkey
    if (notes_toggle = 0)
    {
        Gosub, setNotes
    }
    else
    {
        Gui, Notes:Cancel
        notes_toggle := 0
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
    if (LG_toggle = 0)
    {
        zone_toggle := 1
	notes_toggle := 1
	GoSub, ShowAllWindows
	LG_toggle = 1
    }
    else
    {
	GoSub, HideAllWindows
        zone_toggle := 0
        notes_toggle := 0
	LG_toggle = 0
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


    Gui, Notes:Add, Text, vActNotes x5 y+5 -Wrap, % notesText

    notes_height := (numLines * pixels) + spacing
    
    Gui, Notes:Show, x%xPosNotes% y5 w%notes_width% h%notes_height% NA, Gui Notes
    notes_toggle := 1
return


DrawZone:
    Gui, Parent:New, +AlwaysOnTop +ToolWindow +hwndParentWindow
    Gui, Parent:Color, brown
    Gui, Parent:Show, w110 h60 x%xPosLayoutParent% y5
    WinSet, TransColor, brown, A
    
    WinSet, ExStyle, +0x20, ahk_id %ParentWindow% ; 0x20 = WS_EX_CLICKTHROUGH
    WinSet, Style, -0xC00000, ahk_id %ParentWindow%

    Loop, % maxImages {
        filepath := "" A_ScriptDir "\Overlays\" CurrentAct "\" CurrentZone "_Seed_" A_Index ".jpg" ""
        xPos := xPosLayoutParent + ((maxImages - A_Index) * 115)

        Gui, Image%A_Index%:New, +E0x20 -DPIScale -resize -SysMenu -Caption +AlwaysOnTop +hwndImage%A_Index%Window
        Gui, Image%A_Index%:Add, Picture, VPic%A_Index% x0 y0 w110 h60, %filepath%
        Gui, Image%A_Index%:Show, w110 h60 x%xPos% y32 NA, Image%A_Index%
        Gui, Image%A_Index%:+OwnerParent

	id := Image%A_Index%Window
        If (not FileExist(filepath)) {
            WinSet, Transparent, 0, ahk_id %id%
        } Else {
            WinSet, Transparent, %opacity%, ahk_id %id%
        }
    }
    
    Gui, Controls:+E0x20 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndControls
    Gui, Controls:Color, gray
    Gui, Controls:Font, s%points%, Consolas
    Gui, Controls:Add, DropDownList, VCurrentPart GpartSelectUI x0 y0 w110 h200 , % GetDelimitedPartListString(data.parts, CurrentPart)
    Gui, Controls:Add, DropDownList, VCurrentAct GactSelectUI x+5 y0 w110 h200 , % GetDelimitedActListString(data.zones, CurrentAct, CurrentPart)
    Gui, Controls:Add, DropDownList, VCurrentZone GzoneSelectUI x+5 y0 w225 h300 , % GetDelimitedZoneListString(data.zones, CurrentAct)
    Gui, Controls:+OwnerParent
    xPos := xPosLayoutParent + ((maxImages - 4) * 115)
    control_height := 22
    Gui, Controls:Show, h%control_height% w455 x%xPos% y5 NA, Controls

    zone_toggle := 1
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

    partTest := "Part I"
    If (CurrentPart = partTest){
	CurrentAct := "Act I"
	numPart := 1
    } else {
	CurrentAct := "Act VI"
	numPart := 2
    }
    GuiControl,,CurrentAct, % "|" test := GetDelimitedActListString(data.zones, CurrentAct, CurrentPart)

    CurrentZone := GetDefaultZone(data.zones, CurrentAct)
    GuiControl,,CurrentZone, % "|" test := GetDelimitedZoneListString(data.zones, CurrentAct)

    If (notes_toggle){
	GoSub, setNotes
    }
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
        
    If (notes_toggle){
	GoSub, setNotes
    }
    GoSub, UpdateImages
return

setNotes:

    notesText := ""
    numLines := 0
    For key, zoneGroup in data.zones {
        If (zoneGroup.act = CurrentAct) {
            For k, val in zoneGroup.notes {
		beginString := val
		;Wrap notes longer than maxNotesWidth
		while true
		{
		    StringLen, stringLength, val
		    If (stringLength > maxNotesWidth) {
			StringLeft, beginString, val, maxNotesWidth
			StringTrimLeft, val, val, maxNotesWidth
			notesText .= beginString "`n"
			numLines++
		    } else {
			notesText .= val "`n"
			numLines++
			break
		    }
		} 
            }
	    break
        }        
    }

    notesText := notesText = "" ? "Add leveling and rewards notes to data.json!" : notesText 

    GuiControl,Notes:,ActNotes, %notesText%

    numLines := numLines = "" ? 1 : numLines
    notes_height := (numLines * pixels) + spacing
    
    Gui, Notes:Show, x%xPosNotes% y5 w%notes_width% h%notes_height% NA, Gui Notes
    notes_toggle := 1
return

zoneSelectUI:
    Gui, Controls:Submit, NoHide
    
    Loop, % maxImages {
        Gui, Image%A_Index%:Submit, NoHide
    }
    
    GoSub, UpdateImages
return

cycleZoneUp:
    Gui, Controls:Submit, NoHide
    newZone := RotateZone("next", data.zones, CurrentAct, CurrentZone)
    GuiControl, Controls:Choose, CurrentZone, % "|" newZone
    
    GoSub, UpdateImages
return

cycleZoneDown:
    Gui, Controls:Submit, NoHide
    newZone := RotateZone("previous", data.zones, CurrentAct, CurrentZone)
    GuiControl, Controls:Choose, CurrentZone, % "|" newZone
    
    GoSub, UpdateImages
return

UpdateImages:
    emptySpaces := 0
    Loop, % maxImages {
	imageIndex := (maxImages - A_Index) + 1
        filepath := "" A_ScriptDir "\Overlays\" CurrentAct "\" CurrentZone "_Seed_" imageIndex ".jpg" ""

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
    log := Tail(3, client)
    ;Only bother checking if the log has changed or someone manually changed Part
    If (log != oldLog or trigger)
    {
	oldLog := log
	trigger := false
	travel := "You have entered"
	IfInString, log, %travel%
	{
	    newPart := "Lioneye's Watch"
	    IfInString, log, %newPart%
	    {
		act5LastZone := "Cathedral Rooftop"
		If (CurrentZone = act5LastZone)
		{
		    numPart := 2
		    CurrentPart := "Part II"
		    GuiControl, Controls:Choose, CurrentPart, % "|" CurrentPart
		}
	    }

	    newAct := CurrentAct
	    ;loop through all of the acts in the current part
	    Loop, 5 {
		For key, zoneGroup in data.zones {
		    If (zoneGroup.act = newAct and zoneGroup.part = CurrentPart) {
			For k, newZone in zoneGroup.list {
			    IfInString, log, %newZone%
			    {
				If (newAct != CurrentAct) {
				    GuiControl, Controls:Choose, CurrentAct, % "|" newAct
				    CurrentAct := newAct
				    Sleep 1000
				}
				GuiControl, Controls:Choose, CurrentZone, % "|" newZone
				CurrentZone := newZone
				If (notes_toggle){
				    GoSub, setNotes
    				}
				break 3
			    }
			}
			actData := numPart = 1 ? data.p1acts : data.p2acts
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
    notes_active := WinActive("ahk_id" NotesWindow)
    layout_active := WinActive("ahk_id" ParentWindow)
    controls_active := WinActive("ahk_id" Controls)
    
    image_active := false
    Loop, % maxImages {
        iid := Image%A_Index%Window
        If (WinActive("ahk_id" iid)) {
            image_active := true
        }       
    }
    
    If (poe_active or (notes_active or layout_active or controls_active or image_active)) {
        ; show all gui windows
        GoSub, ShowAllWindows
    } Else {
        GoSub, HideAllWindows
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
	} else {
	    WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
	    break
	}
    }

    ;Magic
    GoSub, SearchAct

return

ShowAllWindows:
    If (zone_toggle) {
        Gui, Parent:Show, NoActivate
        Gui, Controls:Show, NoActivate

        Loop, % maxImages {
            Gui, Image%A_Index%:Show, NoActivate
        }
    }
    
    If (notes_toggle) {
	GoSub, setNotes
    }
return

HideAllWindows:
    Gui, Parent:Cancel
    Gui, Controls:Cancel
    
    Loop, % maxImages {
        Gui, Image%A_Index%:Cancel
    }
    
    Gui, Notes:Cancel
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
