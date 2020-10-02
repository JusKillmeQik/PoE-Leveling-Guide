global nameWidth := 110
global optionWidth := 70
global offsetWidth := 40
global optionHeight := 21
global dropDownHeight := 100
global toolTimeout := 3

global newBuildName := "My Build"
#Include, %A_ScriptDir%\lib\build.ahk

LaunchSettings() {
  global
  Critical

  Gui, Settings:New, -E0x20 -E0x80 +AlwaysOnTop -SysMenu +hwndSettingsWindow, PoE Leveling Guide Settings

  ;Options
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% x10 y10, Options

  ;First Column Option Names
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% x10 y40, Text Size
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Font
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Opacity
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Display Timeout
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Start Hidden
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Persist Text
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Hide Act Guide
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Exp or Penalty

  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+15, Zone Notes Width
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Act Guide Width
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Gem Setup Width

  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+15, Tree Side
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Tree File Name


  ;Second Column Option Edits
  Gui, Settings:Add, Edit, vpoints w%optionWidth% h%optionHeight% x+5 y36, %points%
  Gui, Settings:Add, ComboBox, vfont w%optionWidth% h%dropDownHeight% y+5, % GetFont(font)
  Gui, Settings:Add, Edit, vopacity w%optionWidth% h%optionHeight% y+5, %opacity%
  Gui, Settings:Add, Edit, vdisplayTimeout w%optionWidth% h%optionHeight% y+5, %displayTimeout%
  Gui, Settings:Add, DropDownList, vstartHidden w%optionWidth% h%dropDownHeight% y+5, % GetTrueOrFalse(startHidden)
  Gui, Settings:Add, DropDownList, vpersistText w%optionWidth% h%dropDownHeight% y+5, % GetTrueOrFalse(persistText)
  Gui, Settings:Add, DropDownList, vhideGuide w%optionWidth% h%dropDownHeight% y+5, % GetTrueOrFalse(hideGuide)
  Gui, Settings:Add, DropDownList, vexpOrPen w%optionWidth% h%dropDownHeight% y+5, % GetExpOrPen(expOrPen)

  Gui, Settings:Add, Edit, vmaxNotesWidth w%optionWidth% h%optionHeight% y+15, %maxNotesWidth%
  Gui, Settings:Add, Edit, vmaxGuideWidth w%optionWidth% h%optionHeight% y+5, %maxGuideWidth%
  Gui, Settings:Add, Edit, vmaxLinksWidth w%optionWidth% h%optionHeight% y+5, %maxLinksWidth%

  Gui, Settings:Add, DropDownList, vtreeSide w%optionWidth% h%dropDownHeight% y+15, % GetRightOrLeft(treeSide)
  Gui, Settings:Add, Edit, vtreeName w%optionWidth% h%optionHeight% y+5, %treeName%



  ;HotKeys
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% x230 y10, Hotkeys

  ;Third Column Hotkey Names
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% x230 y40, Show Settings
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Hide Notes and Guide
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Hide Zone Images
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Hide Level Tracker
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Show Skill Tree
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Hide Gem Setup
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Show Betrayal Help
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Show Incursion Help
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Show Heist Help
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Press On Death

  ;Third Column Offset
  Gui, Settings:Add, Text, w%offsetWidth% h%optionHeight% x230 y310, Offsets

  Gui, Settings:Add, Text, w%offsetWidth% h%optionHeight% x230 y340, Notes X
  Gui, Settings:Add, Text, w%offsetWidth% h%optionHeight% y+5, Level X
  Gui, Settings:Add, Text, w%offsetWidth% h%optionHeight% y+5, Gems X

  Gui, Settings:Add, Text, w%offsetWidth% h%optionHeight% x345 y340, Notes Y
  Gui, Settings:Add, Text, w%offsetWidth% h%optionHeight% y+5, Level Y
  Gui, Settings:Add, Text, w%offsetWidth% h%optionHeight% y+5, Gems Y


  ;Fourth Column Hotkey Key
  Gui, Settings:Add, Hotkey, vKeySettings w%nameWidth% h%optionHeight% x345 y36, %KeySettings%
  Gui, Settings:Add, Hotkey, vKeyHideLayout w%nameWidth% h%optionHeight% y+5, %KeyHideLayout%
  Gui, Settings:Add, Hotkey, vKeyHideZones w%nameWidth% h%optionHeight% y+5, %KeyHideZones%
  Gui, Settings:Add, Hotkey, vKeyHideExp w%nameWidth% h%optionHeight% y+5, %KeyHideExp%
  Gui, Settings:Add, Hotkey, vKeyHideTree w%nameWidth% h%optionHeight% y+5, %KeyHideTree%
  Gui, Settings:Add, Hotkey, vKeyHideGems w%nameWidth% h%optionHeight% y+5, %KeyHideGems%
  Gui, Settings:Add, Hotkey, vKeyShowSyndicate w%nameWidth% h%optionHeight% y+5, %KeyShowSyndicate%
  Gui, Settings:Add, Hotkey, vKeyShowTemple w%nameWidth% h%optionHeight% y+5, %KeyShowTemple%
  Gui, Settings:Add, Hotkey, vKeyShowHeist w%nameWidth% h%optionHeight% y+5, %KeyShowHeist%
  Gui, Settings:Add, Edit, vKeyOnDeath w%nameWidth% h%optionHeight% y+5, %KeyOnDeath%

  ;Fourth Column Offset
  Gui, Settings:Add, Edit, vguideXoffset w%offsetWidth% h%optionHeight% x287 y336, %guideXoffset%
  Gui, Settings:Add, Edit, vlevelXoffset w%offsetWidth% h%optionHeight% y+5, %levelXoffset%
  Gui, Settings:Add, Edit, vgemsXoffset w%offsetWidth% h%optionHeight% y+5, %gemsXoffset%

  Gui, Settings:Add, Edit, vguideYoffset w%offsetWidth% h%optionHeight% x402 y336, %guideYoffset%
  Gui, Settings:Add, Edit, vlevelYoffset w%offsetWidth% h%optionHeight% y+5, %levelYoffset%
  Gui, Settings:Add, Edit, vgemsYoffset w%offsetWidth% h%optionHeight% y+5, %gemsYoffset%


  ;Build
  Gui, Settings:Add, Text, w80 h%optionHeight% x490 y10, Build

  ;Fifth Column Build Options
  Gui, Settings:Add, Text, w%optionWidth% h%optionHeight% x490 y40, Build Folder
  Gui, Settings:Add, Text, w%optionWidth% h%optionHeight% y+5, 
  Gui, Settings:Add, Text, w%optionWidth% h%optionHeight% y+5, 
  Gui, Settings:Add, Text, w%optionWidth% h%optionHeight% y+5, New Build

  ;Sixth Column Build Edits
  Gui, Settings:Add, Edit, voverlayFolder w%nameWidth% h%optionHeight% x+5 y36, %overlayFolder%
  Gui, Settings:Add, Button, gBrowse w%nameWidth% h%optionHeight% y+5, &Browse
  Gui, Settings:Add, Button, gEditBuild w%nameWidth% h%optionHeight% y+5, &Edit Build
  Gui, Settings:Add, Edit, vnewBuildName w%nameWidth% h%optionHeight% y+5, %newBuildName%
  Gui, Settings:Add, Button, gNewBuild w%nameWidth% h%optionHeight% y+5, &New Build



  ;Colors
  Gui, Settings:Add, Text, w80 h%optionHeight% x490 y192, Colors

  Gui, Settings:Add, Text, w%optionWidth% h%optionHeight% y+9, Background
  Gui, Settings:Add, Text, w%optionWidth% h%optionHeight% y+5, Red        <
  Gui, Settings:Add, Text, w%optionWidth% h%optionHeight% y+5, Green     +
  Gui, Settings:Add, Text, w%optionWidth% h%optionHeight% y+5, Blue        >
  Gui, Settings:Add, Text, w%optionWidth% h%optionHeight% y+5, White

  Gui, Settings:Add, Edit, vbackgroundColor w%nameWidth% h%optionHeight% x+5 y217, %backgroundColor%
  Gui, Settings:Add, Edit, vredColor w%nameWidth% h%optionHeight% y+5, %redColor%
  Gui, Settings:Add, Edit, vgreenColor w%nameWidth% h%optionHeight% y+5, %greenColor%
  Gui, Settings:Add, Edit, vblueColor w%nameWidth% h%optionHeight% y+5, %blueColor%
  Gui, Settings:Add, Edit, vwhiteColor w%nameWidth% h%optionHeight% y+5, %whiteColor%

  ;Cancel Button
  Gui, Settings:Add, Button, gCancelAndClose w%nameWidth% x445 y428, &Cancel
  ;Save Button
  Gui, Settings:Add, Button, gSaveAndClose w%nameWidth% x565 y428, &Save

  Gui, Settings:Show, w685 h461 NA
  WinSet, AlwaysOnTop, Off, ahk_id %SettingsWindow% ;Turn off always on top, I only set it to bring it to the front in the first place

  toolTime := 0
  SetTimer, ToolTip, 1000
}

SaveAndClose() {
  global
  Gui, Settings:Submit, NoHide

  WriteAll()

  Gui, Settings:Cancel
  SetTimer, ToolTip, Off
  WinActivate, ahk_id %PoEWindowHwnd%
  Reload
}

CancelAndClose() {
  global
  Gui, Settings:Cancel
  SetTimer, ToolTip, Off
  WinActivate, ahk_id %PoEWindowHwnd%
}

Browse() {
  global
  Thread, NoTimers
  FileSelectFolder, overlayFolder, %A_ScriptDir%\builds
  FolderLength := StrLen(A_ScriptDir) + 8
  StringTrimLeft, overlayFolder, overlayFolder, FolderLength
  Thread, NoTimers, false
  GuiControl,,overlayFolder,%overlayFolder%
}

NewBuild() {
  global
  Gui, Settings:Submit, NoHide
  MsgBox, 1,, This will create a new build folder "%newBuildName%" based off of your current build "%overlayFolder%", you can change the current build or new build name in the settings before running this. Please wait a few seconds after creating the build before trying to edit it.
  IfMsgBox Ok
  {
    Thread, NoTimers
    FileCopyDir, %A_ScriptDir%\builds\%overlayFolder%, %A_ScriptDir%\builds\%newBuildName%
    ;Remove the gems folder so a new one can be created
    FileRemoveDir, %A_ScriptDir%\builds\%newBuildName%\gems, 1
    Thread, NoTimers, false
    if ErrorLevel {
      MsgBox, 4096,, The build could not be created, perhaps because a folder of that name already exists.
    } Else {
      gemLevel := "02"
      overlayFolder := newBuildName
      GuiControl,,overlayFolder,%overlayFolder%
    }
  }
}

EditBuild() {
  global
  ;Tooltips won't work when you come back to settings
  ;but it's better than having them show up while editing a build
  SetTimer, ToolTip, Off
  LaunchBuild()
}

GetTrueOrFalse(someBool) {
  If (someBool = "True") {
    Return "True||False"
  } Else {
    Return "True|False||"
  }
}

GetExpOrPen(expOrPen) {
  If (expOrPen = "Exp") {
    Return "Exp||Penalty"
  } Else {
    Return "Exp|Penalty||"
  }
}

GetRightOrLeft(direction) {
  If (direction = "Right") {
    Return "Right||Left"
  } Else {
    Return "Right|Left||"
  }
}

GetFont(font) {
  dList := ""
  fontList := ["Arial", "Corbel", "Comic Sans MS", "Consolas", "Georgia", "Segoe UI", "Times New Roman", "Verdana"]
  For k, someFont in fontList {
    dList .= someFont . "|"
    If (someFont = font) {
      dList .= "|"
    }
  }
  Return dList
}

ToolTip() {
  global
  MouseGetPos,,,,control
  ;Very hacked together
  ;Once I figure out how to name the elements this will be a lot cleaner
  If (control = "static4") ;Opacity
  {
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      Tooltip, Lower this number to see through the images and notes more. `n200 makes the text crisp but can be hard to see through. `n150 is still readable but some backgrounds make it hard to see clearly.
    }
  } Else If (control = "static5") { ;Display Timeout
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, By default the controls hide after the Display Timeout. `nYou can make this longer to see the guide longer in each zone. `nOr set it to 0 if you never want it to hide.
    }
  } Else If (control = "static7") { ;Persist Text
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, By default the controls hide after the Display Timeout. `nThe text also hides so you can see the screen. `nSet this to True if you'd like the text to always be visible. `nSet Display Timeout to 0 if you never want anything to hide.
    }
  } Else If (control = "static9") { ;Exp or Pen
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, By default the percent of Experience you are gaining is shown "Exp". `nIf you prefer to see the percentage of a penalty you are recieving you can switch this to "Penalty".
    }
  } Else If (control = "static13") { ;Tree Side
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, Do you want the Skill Tree so cover your Life "Left" or Inventory "Right" when shown.
    }
  } Else If (control = "static14") { ;Tree Name
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, This is the name of the image that will be shown for the skill tree. `nSome people prefer to save the image as a png or give it a different name entirely. `nThis file must be in each Act Folder of your Build or it will not appear.
    }
  } Else If (control = "static25") { ;Press on Death
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, You must use AutoHotKey Syntax here. `nThis is useful for triggering recording software to save after you die. `nCan be used to rage quit too :-)
    }
  } Else If (control = "static27") { ;Notes X Offset
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, How much space to leave on the right side of the screen for the overlay. `n1 = All the way to right (covers the map/info). `nThis is a good setting if you're going to hide the notes anyway. `n.855 = As far right as you can go without covering the Mini-Map. `nGreat setting if you don't use the overlay map. `n.78 = Default setting and as far right as you can go without covering anything.
    }
  } Else If (control = "static30") { ;Notes Y Offset
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, How far down to place the overlay. `n0 = At the top of the screen (Default). `n1 = At the top of a second monitor below your primary. `n-1 = at the top of a second monitor above your primary. `n You can adjust this to place the overlay anywhere you would like on your screen.
    }
  } Else If (control = "static28") { ;Level X Offset
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, How far to the right of the screen to put the Experience tracker. `n.287 = As far to the left as you can go without covering the flasks. `n.589 = As far to the right as you can go without covering the skill bar on my resolution and font size. `nThis is the default and a great option for 1080 screen resolutions and size 9 Consolas. `nExperiment with other numbers if you want to move the Experience tracker around.
    }
  } Else If (control = "static31") { ;Level Y Offset
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, How far down the screen to put the Experience tracker. `n.955 = As low as you can go without covering the experience bar on my resolution and font size. `nThis is the default and a great option for 1080 screen resolutions and size 9 Consolas. `nExperiment with other numbers if you want to move the Experience tracker around.
    }
  } Else If (control = "static29") { ;Gems X Offset
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, How far to the right to put the Gem Setup. `n.005 = Is the default and places the setup on the left side of the primary screen. `n1.005 = This should put the setup on the left side of a secondary monitor that is to the right of the primary. `n-.995 = This should put the setup on the left side of a secondary monitor that is to the left of the primary. `n None of this has been tested so please experiement with good values and let me know what to put here.
    }
  } Else If (control = "static32") { ;Gems Y Offset
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, How far down you want the Gem Setup. `n0 = All the way at top of the screen. `nIt will cover your buffs and debuffs. `n.180 = Just below your buffs and debuffs. `nThis is the default and a great option for normal screen resolutions.
    }
  } Else If (control = "static37") { ;Colors
    If (oldControl = control){
      toolTime .= 1
    } Else {
      oldControl := control
      toolTime = 0
      Tooltip
    }
    If (toolTime > toolTimeout) {
      ToolTip, For the colors you can put names such as "red" or "blue" or "green". `nHex values can also be used like "FF4040" or "2ECC40" or "0080FF".
    }
  } Else {
    oldControl := control
    toolTime = 0
    Tooltip
  }
}