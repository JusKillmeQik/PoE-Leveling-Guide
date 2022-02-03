#SingleInstance, force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

requiredVer := "1.1.30.03", unicodeOrAnsi := A_IsUnicode?"Unicode":"ANSI", 32or64bits := A_PtrSize=4?"32bits":"64bits"
If (!A_IsUnicode) {
  Run,% "https://www.autohotkey.com/"
  MsgBox,4096+48,"PoE Leveling Guide - Wrong AutoHotKey Version"
  , "/!\ PLEASE READ CAREFULLY /!\"
  . "`n"
  . "`n" "This application isn't compatible with ANSI versions of AutoHotKey."
  . "`n" "You are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bits
  . "`n" "Please download and install AutoHotKey Unicode 32/64"
  . "`n"
  ExitApp
}
If (A_AhkVersion < "1.1") ; Smaller than 1.1.00.00
|| (A_AhkVersion < "1.1.00.00")
|| (A_AhkVersion < requiredVer) { ; Smaller than required
  Run,% "https://www.autohotkey.com/"
  MsgBox,4096+48, "PoE Leveling Guide - AutoHotKey Version Too Low"
  , "/!\ PLEASE READ CAREFULLY /!\"
  . "`n"
  . "`n" "This application requires AutoHotKey v" requiredVer " or higher."
  . "`n" "You are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bits
  . "`n" "AutoHotKey website has been opened, please update to the latest version."
  . "`n"
  ExitApp
}
If (A_AhkVersion >= "2.0")
|| (A_AhkVersion >= "2.0.00.00") { ; Higher or equal to 2.0.00.00
  Run,% "https://www.autohotkey.com/"
  MsgBox,4096+48, "PoE Leveling Guide - Wrong AutoHotKey Version"
  , "/!\ PLEASE READ CAREFULLY /!\"
  . "`n"
  . "`n" "This application isn't compatible with AutoHotKey v2."
  . "`n" "You are using v" A_AhkVersion " " unicodeOrAnsi " " 32or64bits
  . "`n" "AutoHotKey v" requiredVer " or higher is required."
  . "`n" "AutoHotKey website has been opened, please download the latest v1 version."
  . "`n"
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
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_EGS.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExileEGS.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExileSteam.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64_KG.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64EGS.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExilex64EGS.exe
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

global monsterLevel := "01"
#Include, %A_ScriptDir%\lib\config.ahk
#Include, %A_ScriptDir%\lib\settings.ahk
#Include, %A_ScriptDir%\lib\sizing.ahk

If (skipUpdates = "False") {
  versionFile = %A_ScriptDir%\filelist.txt
  If (!FileExist(versionFile)) {
    updatePLG := "True"
    oldVersion := "4.0.3"
    UrlDownloadToFile, https://raw.githubusercontent.com/JusKillmeQik/PoE-Leveling-Guide/main/filelist.txt, %A_ScriptDir%\filelist.txt
  } Else {
    FileReadLine, oldVersion, %A_ScriptDir%\filelist.txt, 1
    UrlDownloadToFile, https://raw.githubusercontent.com/JusKillmeQik/PoE-Leveling-Guide/main/filelist.txt, %A_ScriptDir%\filelist.txt
    FileReadLine, newVersion, %A_ScriptDir%\filelist.txt, 1
    If (oldVersion != newVersion) {
      updatePLG := "True"
    } Else {
      updatePLG := "False"
    }
    If (newVersion = "404: Not Found") {
      updatePLG := "False"
    }
  }
  If (updatePLG = "True") {
    MsgBox, 3,, % "You are running version " oldVersion " of the PoE Leveling Guide,`nversion " newVersion " is available, would you like to download it?`n`nTHIS COULD TAKE A FEW MINUTES!"
    IfMsgBox Yes
    {
      progressWidth := 200
      ignoreBuilds := "builds/"
      ignoreSeeds := "Seed_"
      Loop, read, %A_ScriptDir%\filelist.txt
      {
        If (A_Index = 1){
          ;Do nothing
        } Else If (A_Index = 2){
          progressWidth := A_LoopReadLine
          If progressWidth is not integer
            Break
          Progress, b w200, Please don't stop the download until complete, Updating Script
        } Else {
          flippedSlashes := StrReplace(A_LoopReadLine, "/", "\")
          updateFile = %A_ScriptDir%\%flippedSlashes%
          lastSlashPos := InStr(updateFile,"\",0,0)
          downloadDirName := SubStr(updateFile,1,lastSlashPos-1)
          If ( InStr(A_LoopReadLine,ignoreBuilds) || InStr(A_LoopReadLine,ignoreSeeds) ){
            If (!FileExist(updateFile)) { ; Only download builds and seed images if they don't already exist
              FileCreateDir, %downloadDirName%
              UrlDownloadToFile, https://raw.githubusercontent.com/JusKillmeQik/PoE-Leveling-Guide/main/%A_LoopReadLine%, %updateFile%
            }
          } Else {
            If (!FileExist(updateFile)) { ; If the file doesn't exist make sure to create the directory
              FileCreateDir, %downloadDirName%
            }
            UrlDownloadToFile, https://raw.githubusercontent.com/JusKillmeQik/PoE-Leveling-Guide/main/%A_LoopReadLine%, %updateFile%
          }
          progressPercent := 100 * (A_Index/progressWidth)
          Progress, %progressPercent%
        }
      }
    } Else IfMsgBox No
    {
      ;Do nothing
    } Else {
      ExitApp
    }
  }
  Progress, Off
}

global gem_data := {}
Try {
    FileRead, JSONFile, %A_ScriptDir%\lib\gems.json
    gem_data := JSON.Load(JSONFile)
    If (not gem_data.Length()) {
        MsgBox, 16, , Error reading gem data! `n`nExiting script.
        ExitApp
    }
} Catch e {
    MsgBox, 16, , % e "`n`nNo Gem data in \lib\gems.json"
    ExitApp
}

global gemList := Object()
global filterList := [" None"]
If (skipGemImages = "False") {
  downloadApproved := "None"
} Else {
  downloadApproved := "False"
}
progressWidth := gem_data.length()

For key, someGem in gem_data {
  gemList[gemList.length()+1] := Object()
  gemList[gemList.length()].name := someGem.name
  tempColor := someGem.color
  gemList[gemList.length()].color := %tempColor%Color ;Use the settings color
  gemList[gemList.length()].cost := someGem.cost
  gemList[gemList.length()].vendor := someGem.vendor
  gemList[gemList.length()].lvl := someGem.required_lvl
  gemList[gemList.length()].url := "" "\images\gems\" someGem.name ".png"  ""
  
  image_file := "" A_ScriptDir "\images\gems\" someGem.name ".png"  ""
  icon_url := someGem.iconPath
  If (!FileExist(image_file) and icon_url!="") {
    If (downloadApproved = "True") {
      UrlDownloadToFile, %icon_url%, %image_file%
      progressPercent := 100 * (A_Index/progressWidth)
      Progress, %progressPercent%
    } Else If (downloadApproved = "False") {
      ;do nothing
    } Else {
      MsgBox, 3,, You are missing some gem image files,`nwould you like to download them?`n`nTHIS COULD TAKE A FEW MINUTES!
      IfMsgBox Yes
      {
        downloadApproved := "True"
        UrlDownloadToFile, %icon_url%, %image_file%
        Progress, b w%progressWidth%, Please don't stop the download until complete, Downloading Gem Images
        progressPercent := 100 * (A_Index/progressWidth)
        Progress, %progressPercent%
      } Else IfMsgBox No
      {
        downloadApproved := "False"
      } Else {
        ExitApp
      }
    }
  }

  ;Only populate tags the first time too
  For j, someFilter in someGem.gemTags {
    filterExists := 0
    For k, existingFilter in filterList {
      If (existingFilter = someFilter) {
        filterExists := 1
        break
      }
    }
    If (filterExists = 0) {
      filterList.Push(someFilter)
    }
  }
}
Progress, Off

global PoEWindowHwnd := ""
WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp

global onStartup := 1

;#Include, %A_ScriptDir%\lib\maps.ahk
#Include, %A_ScriptDir%\lib\draw.ahk
DrawZone()
DrawTree()
DrawExp()

#Include, %A_ScriptDir%\lib\set.ahk
If (numPart != 3) {
  SetGuide()
  SetNotes()
} Else {
  ;SetMapGuide()
  ;SetMapNotes()
}
SetGems()

SetExp()

#Include, %A_ScriptDir%\lib\hotkeys.ahk

Gosub, HideAllWindows
ToggleLevelingGuide()

global conqFound := 0
#Include, %A_ScriptDir%\lib\search.ahk

SetTimer, ShowGuiTimer, 200, -100
Return

;========== Subs and Functions =======

InitLogFile(filepath){
    global client_txt_file := FileOpen(filepath,"r")
    client_txt_file.Seek(0,2) ;skip file pointer to end (Origin = 2 -> end of file, distance 0 => end)
    global log := client_txt_file.Read() ; should be empty now and redundant
}


ShowGuiTimer:
  poe_active := WinActive("ahk_id" PoEWindowHwnd)
  controls_active := WinActive("ahk_id" . Controls) ; Wow that dot is important!
  level_active := WinActive("ahk_id" . Level)
  gems_active := WinActive("ahk_id" . Gems)

  If (activeCount <= displayTimeout) {
    If (activeCount = 0) {
      activeTime := A_Now
    }
    active_toggle := 1
    If (!controls_active) {
      activeCount := A_Now - activeTime
      If (activeCount = 0) {
        activeCount := 1
      }
    }
  } Else if (activeCount > displayTimeout and active_toggle) {
    GoSub, HideAllWindows
    active_toggle := 0
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
      client .= "logs\KakaoClient.txt"
    }

    Process, Exist, PathOfExile_EGS.exe
    If(!errorlevel) {
      closed++
    } Else {
      client := GetProcessPath( "PathOfExile_EGS.exe" )
      StringTrimRight, client, client, 19
      client .= "logs\Client.txt"
    }

    Process, Exist, PathOfExileEGS.exe
    If(!errorlevel) {
      closed++
    } Else {
      client := GetProcessPath( "PathOfExileEGS.exe" )
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
      client .= "logs\KakaoClient.txt"
    }

    Process, Exist, PathOfExile_x64EGS.exe
    If(!errorlevel) {
      closed++
    } Else {
      client := GetProcessPath( "PathOfExile_x64EGS.exe" )
      StringTrimRight, client, client, 22
      client .= "logs\Client.txt"
    }

    Process, Exist, PathOfExilex64EGS.exe
    If(!errorlevel) {
      closed++
    } Else {
      client := GetProcessPath( "PathOfExilex64EGS.exe" )
      StringTrimRight, client, client, 21
      client .= "logs\Client.txt"
    }

    If (closed = 10){
      GoSub, HideAllWindows
      ;Sleep 10 seconds, no need to keep checking this
      Sleep 10000
      ;Reset activity upon return
      activeCount := 0
      active_toggle := 1
    } Else {
      If (onStartup) {
        ;save client variable to compare in the future if the client.exe changed and thus the client.txt needs to be reread
        old_client_txt_path := client
        InitLogFile(client)
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
      ;after startup check if new client_txt_path is different from old_client_txt_path (changed launcher)
      if ((old_client_txt_path != client) and (closed != 8)){
        old_client_txt_path := client
        InitLogFile(client)
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
  If (LG_toggle and !controls_active and (active_toggle or persistText = "True")) {
    Gui, Guide:Show, NoActivate
    If (numPart = 3) {
      Gui, Atlas:Show, NoActivate
    } Else {
      Gui, Atlas:Cancel
    }
    Gui, Notes:Show, NoActivate
  } Else If (!controls_active) {
    Gui, Notes:Cancel
    Gui, Atlas:Cancel
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

  If (tree_toggle or atlas_toggle) {
    Gui, Tree:Show, NoActivate
  } Else If (level_toggle) {
    Gui, Level:Show, NoActivate
    Gui, Exp:Show, NoActivate
    ;SetExp()
  }

  If (gems_toggle) {
    Gui, Gems:Show, NoActivate
    Gui, Links:Show, NoActivate

    For k, someControl in controlList {
      If (%someControl%image){
        Gui, Image%someControl%:Show, NoActivate
      }
    }
  }
return

HideAllWindows:
  Gui, Controls:Cancel
  Gui, Level:Cancel
  Gui, Exp:Cancel

  Loop, % maxImages {
      Gui, Image%A_Index%:Cancel
  }

  For k, someControl in controlList {
    Gui, Image%someControl%:Cancel
  }

  Gui, Notes:Cancel
  Gui, Atlas:Cancel
  Gui, Guide:Cancel

  Gui, Tree:Cancel
  Gui, Gems:Cancel
  Gui, Links:Cancel
return


GetProcessPath(exe) {
  for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where name ='" exe "'")
    return process.ExecutablePath
}

PLGReload:
Reload

PLGClose:
ExitApp
