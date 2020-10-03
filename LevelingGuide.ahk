#SingleInstance, force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Check version and download if OK
requiredVer := "1.1.30.03", unicodeOrAnsi := A_IsUnicode?"Unicode":"ANSI", 32or64bits := A_PtrSize=4?"32bits":"64bits"
if (!A_IsUnicode) {
  MsgBox, 1,, "This application isn't compatible with ANSI versions of AutoHotKey.`nYou are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bit ".`nPlease download the latest version of Autohotkey 1.1"
  IfMsgBox, OK
    Run, https://www.autohotkey.com/download/ahk-install.exe
  ExitApp
}
if (A_AhkVersion < "1.1") ; Smaller than 1.1.00.00
|| (A_AhkVersion < "1.1.00.00")
|| (A_AhkVersion < requiredVer) { ; Smaller than required
  MsgBox, 1,, "This application requires AutoHotKey v" requiredVer " or higher.`nYou are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bit ".`nPlease download the latest version of Autohotkey 1.1"
  IfMsgBox, OK
    Run, https://www.autohotkey.com/download/ahk-install.exe
  ExitApp
}
if (A_AhkVersion >= "2.0")
|| (A_AhkVersion >= "2.0.00.00") { ; Higher or equal to 2.0.00.00
  MsgBox, 1,, "This application isn't compatible with AutoHotKey v2.`nYou are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bit ".`nPlease download the latest version of Autohotkey 1.1"
  IfMsgBox, OK
    Run, https://www.autohotkey.com/download/ahk-install.exe
  ExitApp
}

#Include, %A_ScriptDir%\lib\JSON.ahk
#Include, %A_ScriptDir%\lib\Gdip.ahk

;Menu
Menu, Tray, NoStandard

Menu, Tray, Tip, PoE Leveling Guide
Menu, Tray, Add, Settings, LaunchSettings
Menu, Tray, Add, Edit Build, LaunchBuild
Menu, Tray, Add
Menu, Tray, Add, Reload, PLGReload
Menu, Tray, Add, Close, PLGClose

; Icons
Menu, Tray, Icon, %A_ScriptDir%\icons\lvlG.ico
Menu, Tray, Icon, Settings, %A_ScriptDir%\icons\gear.ico
Menu, Tray, Icon, Reload, %A_ScriptDir%\icons\refresh.ico
Menu, Tray, Icon, Close, %A_ScriptDir%\icons\x.ico

global PoEWindowGrp
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_KG.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExileSteam.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64_KG.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64Steam.exe

global data := {}
Try {
    FileRead, JSONFile, %A_ScriptDir%\lib\data.json
    data := JSON.Load(JSONFile)
    If (not data.p1acts.Length()) {
        MsgBox, 16, , Error reading zone data! `n`nExiting script.
        ExitApp
    }
} Catch e {
    MsgBox, 16, , % e "`n`nCould not read data file: Exiting script."
    ExitApp
}

#Include, %A_ScriptDir%\lib\config.ahk
#Include, %A_ScriptDir%\lib\settings.ahk
#Include, %A_ScriptDir%\lib\sizing.ahk

global PoEWindowHwnd := ""
WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp

global old_log := ""
global trigger := false

global onStartup := 1

#Include, %A_ScriptDir%\lib\draw.ahk
DrawZone()
DrawTree()
DrawExp()

#Include, %A_ScriptDir%\lib\set.ahk
SetNotes()
SetGuide()
SetGems()

#Include, %A_ScriptDir%\lib\hotkeys.ahk

Gosub, HideAllWindows
ToggleLevelingGuide()

SetTimer, ShowGuiTimer, 200, -100
Return

;========== Subs and Functions =======

#Include, %A_ScriptDir%\lib\search.ahk

ShowGuiTimer:
  poe_active := WinActive("ahk_id" PoEWindowHwnd)
  controls_active := WinActive("ahk_id" . Controls) ; Wow that dot is important!
  level_active := WinActive("ahk_id" . Level)
  gems_active := WinActive("ahk_id" . Gems)

  If (activeCount <= displayTimeout) {
    active_toggle := 1
    If (!controls_active) {
      activeCount++
    }
  } Else if (activeCount = displayTimeout + 1) {
    GoSub, HideAllWindows
    active_toggle := 0
    activeCount++
  }

  If (controls_active or displayTimeout=0) {
    activeCount := 0
    active_toggle := 1
  }

  ;This shows the guide if you put your mouse in the top right corner, it triggers too often and isn't helpful
  ; MouseGetPos, xposMouse, yposMouse
  ; If (yposMouse < 10 and xposMouse > A_ScreenWidth-Round(A_ScreenWidth/4)) {
  ;   activeCount := 0
  ;   active_toggle := 1
  ; }

  If (poe_active or controls_active or level_active or gems_active) {
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

    If (closed = 6){
      GoSub, HideAllWindows
      ;Sleep 10 seconds, no need to keep checking this
      Sleep 10000
      ;Reset activity upon return
      activeCount := 0
      active_toggle := 1
    } Else {
      If (onStartup) {
        ;Delete Client.txt on startup so we don't have to read a HUGE file!
        FileGetSize, clientSize, %client%, K  ; Retrieve the size in Kbytes.
        If(clientSize > 100000){
          MsgBox, 1,, Your %client% is over 100Mb and will be deleted to speed up this script. Feel free to Cancel and rename the file if you want to keep it, but deletion will not affect the game at all.
          IfMsgBox Ok
          {
            file := FileOpen(client, "w")
            If IsObject(file) {
              file.Close()
            }
          }
        }
        onStartup := 0
      }
      WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp
      break
    }
  } ;End While

  ;Magic
  SearchLog()

return

ShowAllWindows:
  If (LG_toggle and active_toggle) {
    Gui, Controls:Show, NoActivate
  }
  controls_active := WinActive("ahk_id" Controls)
  If (LG_toggle and !controls_active and (active_toggle or persistText = "True") and numPart != 3) {
    Gui, Notes:Show, NoActivate
    Gui, Guide:Show, NoActivate
  } Else If (!controls_active) {
    Gui, Notes:Cancel
    Gui, Guide:Cancel
  }

  If (zone_toggle) {
    ;UpdateImages()
    Loop, % maxImages {
      Gui, Image%A_Index%:Show, NoActivate
    }
  } else {
    Loop, % maxImages {
      Gui, Image%A_Index%:Cancel
    }
  }

  If (tree_toggle) {
    Gui, Tree:Show, NoActivate
  } Else If (level_toggle) {
    Gui, Level:Show, NoActivate
    SetExp()
  }

  If (gems_toggle) {
    Gui, Gems:Show, NoActivate
    Gui, Links:Show, NoActivate
  }
return

HideAllWindows:
  Gui, Controls:Cancel
  Gui, Level:Cancel
  Gui, Exp:Cancel

  Loop, % maxImages {
      Gui, Image%A_Index%:Cancel
  }

  Gui, Notes:Cancel
  Gui, Guide:Cancel

  Gui, Tree:Cancel
  Gui, Gems:Cancel
  Gui, Links:Cancel
return

Tail(k,file) {  ; Return the last k lines of file
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

PLGReload:
Reload

PLGClose:
ExitApp
