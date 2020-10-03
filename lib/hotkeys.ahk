Hotkey, IfWinActive, ahk_group PoEWindowGrp

If (KeySettings != "") {
  Hotkey % KeySettings, LaunchSettings
}

If (KeyHideLayout != "") {
  Hotkey % KeyHideLayout, ToggleLevelingGuide
}

ToggleLevelingGuide()
{
  if (LG_toggle = 0 or active_toggle = 0)
  {
    LG_toggle = 1
    activeCount := 0
    active_toggle := 1
    Gui, Controls:Show, NA
    Gui, Notes:Show, NA
    Gui, Guide:Show, NA
    GoSub, ShowAllWindows
  } else {
    Gui, Controls:Cancel
    Gui, Notes:Cancel
    Gui, Guide:Cancel
    LG_toggle = 0
  }
}

If (KeyHideZones != "") {
  Hotkey % KeyHideZones, ToggleZones
}

ToggleZones() {
  global
  if (zone_toggle = 0)
  {
    UpdateImages()
    zone_toggle := 1
  }
  else
  {
    ;These lines aren't needed but make it look faster
    Loop, % maxImages {
      Gui, Image%A_Index%:Hide
    }
    zone_toggle := 0
  }
  SaveState()
}

If (KeyHideExp != "") {
  Hotkey % KeyHideExp, ToggleExp
}

ToggleExp() {
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
  SaveState()
}

If (KeyHideTree != "") {
  Hotkey % KeyHideTree, ToggleTree
}

ToggleTree() {
  if (tree_toggle = 0)
  {
    DrawTree()
    Gui, Tree:Show, NA
    tree_toggle := 1
  }
  else
  {
    Gui, Tree:Cancel
    tree_toggle := 0
  }
}

If (KeyHideGems != "") {
  Hotkey % KeyHideGems, ToggleGems
}

ToggleGems() {
  if (gems_toggle = 0)
  {
    Gui, Gems:Show, NA
    Gui, Links:Show, NA
    gems_toggle := 1
  }
  else
  {
    Gui, Gems:Cancel
    Gui, Links:Cancel
    gems_toggle := 0
  }
  SaveState()
}

If (KeyShowSyndicate != "") {
  Hotkey % KeyShowSyndicate, ToggleSyndicate
}

ToggleSyndicate() {
  Gui, Syndicate:+AlwaysOnTop +ToolWindow +Resize +hwndSyndicate
  syndicate_active := WinExist("Betrayal")
  If (syndicate_active) {
    Gui, Syndicate:Hide
  } Else {
    image_file := "" A_ScriptDir "\images\cheatsheets\Betrayal.png" ""
    Gui, Syndicate:Add, Picture, , %image_file%
    Gui, Syndicate:Show, NoActivate, Betrayal
  }
}

If (KeyShowTemple != "") {
  Hotkey % KeyShowTemple, ToggleTemple
}

ToggleTemple() {
  Gui, Temple:+AlwaysOnTop +ToolWindow +Resize +hwndTemple
  temple_active := WinExist("Incursion")
  If (temple_active){
    Gui, Temple:Hide
  } Else {
    image_file := "" A_ScriptDir "\images\cheatsheets\Incursion.png" ""
    Gui, Temple:Add, Picture, , %image_file%
    Gui, Temple:Show, NoActivate, Incursion
  }
}

If (KeyShowHeist != "") {
  Hotkey % KeyShowHeist, ToggleHeist
}

ToggleHeist() {
  Gui, Heist:+AlwaysOnTop +ToolWindow +Resize +hwndHeist
  heist_active := WinExist("Heist")
  If (heist_active){
    Gui, Heist:Hide
  } Else {
    image_file := "" A_ScriptDir "\images\cheatsheets\Heist.png" ""
    Gui, Heist:Add, Picture, , %image_file%
    Gui, Heist:Show, NoActivate, Heist
  }
}
