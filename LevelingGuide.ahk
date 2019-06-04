#SingleInstance, force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include, %A_ScriptDir%\lib\JSON.ahk

Menu, Tray, Icon, %A_ScriptDir%\lvlG.ico
Menu, Tray, Tip, Leveling Guide - PoE

GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExileSteam.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64Steam.exe

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

global maxNotesLength := 40
global offset := .8
global opacity := 200

global config := {}
Try {
    FileRead, JSONFile, %A_ScriptDir%\config.json
    config := JSON.Load(JSONFile)
} Catch e {
    MsgBox, 16, , % e "`n`nExiting script."
    ExitApp
}
If (config.maxNotesLength != "") {
	maxNotesLength := config.maxNotesLength
}
If (config.offset != "") {
	offset := config.offset
}
If (config.opacity != "") {
	opacity := config.opacity
}

;Default value - this is autodetected now too
global client := "C:\Program Files (x86)\Grinding Gear Games\Path of Exile\logs\Client.txt"

global zone_toggle := 0
global notes_toggle := 0

global points := 9

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


global notes_width := Floor( (maxNotesLength-1) * (pixels/2) )

global maxImages := 6
global xPosLayoutParent := Round( (A_ScreenWidth * offset) - (maxImages * 115) - notes_width )
global xPosNotes := xPosLayoutParent + (maxImages * 115)

global PoEWindowHwnd := ""
WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp

global old_log := ""
global trigger := false
global knownZone := 1

global numPart := 1
global CurrentPart = "Part I"
global CurrentAct = "Act I"
global CurrentZone = "Twilight Strand"

Gosub, DrawNotes
Gosub, DrawZone
GoSub, ShowAllWindows
SetTimer, ShowGuiTimer, 250

Return


;
; ========= MAIN / GUI =========
;
 

;========== Zone Layouts =======
#IfWinActive, ahk_group PoEWindowGrp
!F1:: ; Display/Hide zone layout window hotkey
    if (zone_toggle = 0 or knownZone = 0)
    {
        Gosub, DrawZone
	GoSub, UpdateImages
	GoSub, ActivatePOE
    }
    else
    {
        Gui, Zone:Destroy
        Gui, Controls:Destroy
        Loop, % maxImages {
            Gui, Image%A_Index%:Destroy
        }        
        zone_toggle := 0
    }
return

;========== Reward Notes =======
#IfWinActive, ahk_group PoEWindowGrp
!F2:: ; Display/Hide notes window hotkey
    if (notes_toggle = 0)
    {
        Gosub, DrawNotes
	GoSub, ActivatePOE
    }
    else
    {
        Gui, Notes:Destroy
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

 
;========== Subs and Functions =======

ActivatePOE:
	;Changing the GUI causes the game to lose focus
	;I put it back and resend the major mouse buttons
	;This prevents movement from stopping for the refresh

	WinActivate, ahk_id %PoEWindowHwnd%
	GetKeyState, state, LButton
	If (state = "D")
	{
	    Click, up
	    Click, down
	}
	GetKeyState, state, RButton
	If (state = "D")
	{
	    Click, up, right
	    Click, down, right
	}
return
 
 
DrawNotes:
    Gui, Notes:+E0x20 -DPIScale -Caption +LastFound +ToolWindow +AlwaysOnTop +hwndNotesWindow
    Gui, Notes:font, cFFFFFF s%points% w800, Consolas
    Gui, Notes:Color, gray
    WinSet, Transparent, %opacity%
	
    notesText := ""
    numLines := 0
    For key, zoneGroup in data.zones {
        If (zoneGroup.act = CurrentAct) {
            For k, val in zoneGroup.notes {
		beginString := val
		;Wrap notes longer than maxNotesLength
		while true
		{
		    StringLen, stringLength, val
		    If (stringLength > maxNotesLength) {
			StringLeft, beginString, val, maxNotesLength
			StringTrimLeft, val, val, maxNotesLength
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

    numLines := numLines = "" ? 1 : numLines
    notesText := notesText = "" ? "Add leveling and rewards notes to data.json!" : notesText 

    Gui, Notes:Add, Text, x5 y+5, % notesText

    notes_height := (numLines * pixels) + spacing
    
    Gui, Notes:Show, x%xPosNotes% y5 w%notes_width% h%notes_height%, Gui Notes
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
        Gui, Image%A_Index%:Show, w110 h60 x%xPos% y32, Image%A_Index%
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
    Gui, Controls:Show, h%control_height% w455 x%xPos% y5, Controls

    zone_toggle := 1
    knownZone := 1
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
    Gui, Notes:Destroy
    GoSub, DrawNotes
return

zoneSelectUI:
    Gui, Controls:Submit, NoHide
    
    Loop, % maxImages {
        Gui, Image%A_Index%:Submit, NoHide
    }
    
    GoSub, UpdateImages
return

cycleZoneUp:
    knownZone := 1

    Gui, Controls:Submit, NoHide
    newZone := RotateZone("next", data.zones, CurrentAct, CurrentZone)
    GuiControl, Controls:Choose, CurrentZone, % "|" newZone
    
    GoSub, UpdateImages
    GoSub, ActivatePOE
return

cycleZoneDown:
    knownZone := 1

    Gui, Controls:Submit, NoHide
    newZone := RotateZone("previous", data.zones, CurrentAct, CurrentZone)
    GuiControl, Controls:Choose, CurrentZone, % "|" newZone
    
    GoSub, UpdateImages
    GoSub, ActivatePOE
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
        Gui, Image%A_Index%:Show
        Gui, Image%A_Index%:+OwnerParent
    }
return

;========== Auto Magic Zone Changing =======

SearchAct:
    ;You can check more than one line to make this more robust,
    ;but then sometimes voice logs will trigger the wrong map update
    log := Tail(1, client)
    ;Only bother checking if the log has changed
    If (log != oldLog or trigger)
    {
	trigger := false
	oldLog := log
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

	    knownZone := 0
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
				knownZone := 1
				If (notes_toggle){
				    GoSub, setNotes
    				}
				GoSub, ActivatePOE
				break 3
			    }
			}
			actData := numPart = 1 ? data.p1acts : data.p2acts
			newAct := RotateAct("next", actData, newAct)
			break
		    }        
		}
	    }
	    If (knownZone = "0") {
		GoSub, HideAllWindows
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

	if (closed = 4){
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
    If (zone_toggle and knownZone) {
        If (not layout_active) {
            Gui, Parent:Show, NoActivate
        }
        If (not controls_active) {
            Gui, Controls:Show, NoActivate
            Gui, Controls:+OwnerParent
        }
        
        If (not image_active) {
            Loop, % maxImages {
                Gui, Image%A_Index%:Show, NoActivate
                Gui, Image%A_Index%:+OwnerParent
            }
        }
    }
    
    If (not notes_active and notes_toggle) {
        Gui, Notes:Show, NoActivate
    }
return

HideAllWindows:
    Gui, Parent:Cancel
    Gui, Controls:Cancel
    
    Loop, % maxImages {
        Gui, Image%A_Index%:Cancel
    }
    
    Gui, Zone:Cancel
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
