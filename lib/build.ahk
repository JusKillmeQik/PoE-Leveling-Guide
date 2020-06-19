global groupWidth := 100
global gemWidth := 100
global colorWidth := 45
global npcWidth := 55
global noteWidth := 50
global charWidth := colorWidth + npcWidth + noteWidth + (10)
global lineWidth := groupWidth + gemWidth + colorWidth + npcWidth + noteWidth + (40)
global buildWidth := lineWidth * 3
global listHeight := 200
;This variable is in the settings.ahk
optionHeight := 21

global gemLevel := "02"
global charClass := "Duelist"
global charName := ""
global gemFilter1 := " None"
global gemFilter2 := " None"
global controlList := ["MH1", "MH2", "MH3", "MH4", "MH5", "MH6", "", "BA1", "BA2", "BA3", "BA4", "BA5", "BA6", "", "OH1", "OH2", "OH3", "", "HT1", "HT2", "HT3", "HT4", "", "GL1", "GL2", "GL3", "GL4", "", "BT1", "BT2", "BT3", "BT4", "", "RG1", "", "RG2"]
global levelList := ["02", "04", "08", "12", "16", "24", "28", "31", "34", "38", "55", "72", "90"]
global classList := ["Duelist", "Marauder", "Ranger", "Scion", "Shadow", "Templar", "Witch"]
global filterList := [" None"]

global gemList := Object()

global unsaved := 0

LaunchBuild() {
  global
  Critical

  ClearControls() ;This has to happen here even though it happens in ReadGemFile to make sure new builds are fresh

  ReadGemFile(gemLevel)

  Gui, Build:New, -E0x20 -E0x80 +AlwaysOnTop -SysMenu +hwndBuildWindow, PoE Leveling Guide Build Creator

  ;Main Hand
  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x10 y10, 1. Main Hand

  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x10 y+5, Group
  Gui, Build:Add, Text, w%gemWidth% h%optionHeight% x+5, Gem
  Gui, Build:Add, Text, w%colorWidth% h%optionHeight% x+5, Color
  Gui, Build:Add, Text, w%npcWidth% h%optionHeight% x+5, NPC
  Gui, Build:Add, Text, w%noteWidth% h%optionHeight% x+5, Note

  Loop, 6 {
    Gui, Build:Add, DropDownList, vMH%A_Index%group gUpdateGroup w%groupWidth% h%listHeight% x10 y+5, % GetGroupList(MH%A_Index%group)
    Gui, Build:Add, ComboBox, vMH%A_Index%gem gUpdateElements w%gemWidth% h%listHeight% x+5, % GetGemList(MH%A_Index%group, MH%A_Index%gem)
    Gui, Build:Add, Edit, vMH%A_Index%color gUpdateEdit w%colorWidth% h%optionHeight% x+5, % MH%A_Index%color
    Gui, Build:Add, Edit, vMH%A_Index%npc gUpdateEdit w%npcWidth% h%optionHeight% x+5, % groupList[GroupIndex(MH%A_Index%group)][2]
    Gui, Build:Add, Edit, vMH%A_Index%note gUpdateEdit w%noteWidth% h%optionHeight% x+5, % MH%A_Index%note
  }

  ;Body Armour
  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x10 y+20, 2. Body Armour

  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x10 y+5, Group
  Gui, Build:Add, Text, w%gemWidth% h%optionHeight% x+5, Gem
  Gui, Build:Add, Text, w%colorWidth% h%optionHeight% x+5, Color
  Gui, Build:Add, Text, w%npcWidth% h%optionHeight% x+5, NPC
  Gui, Build:Add, Text, w%noteWidth% h%optionHeight% x+5, Note

  Loop, 6 {
    Gui, Build:Add, DropDownList, vBA%A_Index%group gUpdateGroup w%groupWidth% h%listHeight% x10 y+5, % GetGroupList(BA%A_Index%group)
    Gui, Build:Add, ComboBox, vBA%A_Index%gem gUpdateElements w%gemWidth% h%listHeight% x+5, % GetGemList(BA%A_Index%group, BA%A_Index%gem)
    Gui, Build:Add, Edit, vBA%A_Index%color gUpdateEdit w%colorWidth% h%optionHeight% x+5, % BA%A_Index%color
    Gui, Build:Add, Edit, vBA%A_Index%npc gUpdateEdit w%npcWidth% h%optionHeight% x+5, % groupList[GroupIndex(BA%A_Index%group)][2]
    Gui, Build:Add, Edit, vBA%A_Index%note gUpdateEdit w%noteWidth% h%optionHeight% x+5, % BA%A_Index%note
  }

  ;Spacing
  columnTwoX := lineWidth + 10

  ;Off Hand
  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x%columnTwoX% y10, 3. Off Hand

  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x%columnTwoX% y+5, Group
  Gui, Build:Add, Text, w%gemWidth% h%optionHeight% x+5, Gem
  Gui, Build:Add, Text, w%colorWidth% h%optionHeight% x+5, Color
  Gui, Build:Add, Text, w%npcWidth% h%optionHeight% x+5, NPC
  Gui, Build:Add, Text, w%noteWidth% h%optionHeight% x+5, Note

  Loop, 3 {
    Gui, Build:Add, DropDownList, vOH%A_Index%group gUpdateGroup w%groupWidth% h%listHeight% x%columnTwoX% y+5, % GetGroupList(OH%A_Index%group)
    Gui, Build:Add, ComboBox, vOH%A_Index%gem gUpdateElements w%gemWidth% h%listHeight% x+5, % GetGemList(OH%A_Index%group, OH%A_Index%gem)
    Gui, Build:Add, Edit, vOH%A_Index%color gUpdateEdit w%colorWidth% h%optionHeight% x+5, % OH%A_Index%color
    Gui, Build:Add, Edit, vOH%A_Index%npc gUpdateEdit w%npcWidth% h%optionHeight% x+5, % groupList[GroupIndex(OH%A_Index%group)][2]
    Gui, Build:Add, Edit, vOH%A_Index%note gUpdateEdit w%noteWidth% h%optionHeight% x+5, % OH%A_Index%note
  }

  ;Helmet
  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x%columnTwoX% y+20, 4. Helmet

  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x%columnTwoX% y+5, Group
  Gui, Build:Add, Text, w%gemWidth% h%optionHeight% x+5, Gem
  Gui, Build:Add, Text, w%colorWidth% h%optionHeight% x+5, Color
  Gui, Build:Add, Text, w%npcWidth% h%optionHeight% x+5, NPC
  Gui, Build:Add, Text, w%noteWidth% h%optionHeight% x+5, Note

  Loop, 4 {
    Gui, Build:Add, DropDownList, vHT%A_Index%group gUpdateGroup w%groupWidth% h%listHeight% x%columnTwoX% y+5, % GetGroupList(HT%A_Index%group)
    Gui, Build:Add, ComboBox, vHT%A_Index%gem gUpdateElements w%gemWidth% h%listHeight% x+5, % GetGemList(HT%A_Index%group, HT%A_Index%gem)
    Gui, Build:Add, Edit, vHT%A_Index%color gUpdateEdit w%colorWidth% h%optionHeight% x+5, % HT%A_Index%color
    Gui, Build:Add, Edit, vHT%A_Index%npc gUpdateEdit w%npcWidth% h%optionHeight% x+5, % groupList[GroupIndex(HT%A_Index%group)][2]
    Gui, Build:Add, Edit, vHT%A_Index%note gUpdateEdit w%noteWidth% h%optionHeight% x+5, % HT%A_Index%note
  }

  ;Controls
  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x%columnTwoX% y+30, Controls

  Gui, Build:Add, Text, w%charWidth% h%optionHeight% x%columnTwoX% y+5, Filter Gems by Tag:
  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x+5, Class
  Gui, Build:Add, Text, w%gemWidth% h%optionHeight% x+5, Level

  filterWidth := (charWidth - 5) / 2
  Gui, Build:Add, DropDownList, vgemFilter1 gUpdateFilter Sort w%filterWidth% h%listHeight% x%columnTwoX% y+5, % GetFilters(gemFilter1)
  Gui, Build:Add, DropDownList, vgemFilter2 gUpdateFilter Sort w%filterWidth% h%listHeight% x+5, % GetFilters(gemFilter2)
  Gui, Build:Add, DropDownList, vcharClass gUpdateControl w%groupWidth% h%listHeight% x+5, % GetClasses(charClass)
  Gui, Build:Add, DropDownList, vgemLevel gUpdateControl w%gemWidth% h%listHeight% x+5, % GetLevels(gemLevel)
  
  Gui, Build:Add, Text, w%charWidth% h%optionHeight% x%columnTwoX% y+5, Character Name:

  Gui, Build:Add, Button, gClearBuild w%groupWidth% h%optionHeight% x+5, &Clear
  Gui, Build:Add, Button, gLoadBuild w%groupWidth% h%optionHeight% x+5, &Load

  Gui, Build:Add, Edit, vcharName gUpdateEdit w%charWidth% h%optionHeight% x%columnTwoX% y+5, %charName%
  Gui, Build:Add, Button, gSaveBuild w%groupWidth% h%optionHeight% x+5, &Save
  Gui, Build:Add, Button, gCloseBuild w%groupWidth% h%optionHeight% x+5, &Close

  ;Spacing
  columnThreeX := (lineWidth*2) + 10

  ;Gloves
  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x%columnThreeX% y10, 5. Gloves

  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x%columnThreeX% y+5, Group
  Gui, Build:Add, Text, w%gemWidth% h%optionHeight% x+5, Gem
  Gui, Build:Add, Text, w%colorWidth% h%optionHeight% x+5, Color
  Gui, Build:Add, Text, w%npcWidth% h%optionHeight% x+5, NPC
  Gui, Build:Add, Text, w%noteWidth% h%optionHeight% x+5, Note

  Loop, 4 {
    Gui, Build:Add, DropDownList, vGL%A_Index%group gUpdateGroup w%groupWidth% h%listHeight% x%columnThreeX% y+5, % GetGroupList(GL%A_Index%group)
    Gui, Build:Add, ComboBox, vGL%A_Index%gem gUpdateElements w%gemWidth% h%listHeight% x+5, % GetGemList(GL%A_Index%group, GL%A_Index%gem)
    Gui, Build:Add, Edit, vGL%A_Index%color gUpdateEdit w%colorWidth% h%optionHeight% x+5, % GL%A_Index%color
    Gui, Build:Add, Edit, vGL%A_Index%npc gUpdateEdit w%npcWidth% h%optionHeight% x+5, % groupList[GroupIndex(GL%A_Index%group)][2]
    Gui, Build:Add, Edit, vGL%A_Index%note gUpdateEdit w%noteWidth% h%optionHeight% x+5, % GL%A_Index%note
  }

  ;Boots
  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x%columnThreeX% y+20, 6. Boots

  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x%columnThreeX% y+5, Group
  Gui, Build:Add, Text, w%gemWidth% h%optionHeight% x+5, Gem
  Gui, Build:Add, Text, w%colorWidth% h%optionHeight% x+5, Color
  Gui, Build:Add, Text, w%npcWidth% h%optionHeight% x+5, NPC
  Gui, Build:Add, Text, w%noteWidth% h%optionHeight% x+5, Note

  Loop, 4 {
    Gui, Build:Add, DropDownList, vBT%A_Index%group gUpdateGroup w%groupWidth% h%listHeight% x%columnThreeX% y+5, % GetGroupList(BT%A_Index%group)
    Gui, Build:Add, ComboBox, vBT%A_Index%gem gUpdateElements w%gemWidth% h%listHeight% x+5, % GetGemList(BT%A_Index%group, BT%A_Index%gem)
    Gui, Build:Add, Edit, vBT%A_Index%color gUpdateEdit w%colorWidth% h%optionHeight% x+5, % BT%A_Index%color
    Gui, Build:Add, Edit, vBT%A_Index%npc gUpdateEdit w%npcWidth% h%optionHeight% x+5, % groupList[GroupIndex(BT%A_Index%group)][2]
    Gui, Build:Add, Edit, vBT%A_Index%note gUpdateEdit w%noteWidth% h%optionHeight% x+5, % BT%A_Index%note
  }

  ;Rings
  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x%columnThreeX% y+20, 7. Rings

  Gui, Build:Add, Text, w%groupWidth% h%optionHeight% x%columnThreeX% y+5, Group
  Gui, Build:Add, Text, w%gemWidth% h%optionHeight% x+5, Gem
  Gui, Build:Add, Text, w%colorWidth% h%optionHeight% x+5, Color
  Gui, Build:Add, Text, w%npcWidth% h%optionHeight% x+5, NPC
  Gui, Build:Add, Text, w%noteWidth% h%optionHeight% x+5, Note

  Loop, 2 {
    Gui, Build:Add, DropDownList, vRG%A_Index%group gUpdateGroup w%groupWidth% h%listHeight% x%columnThreeX% y+5, % GetGroupList(RG%A_Index%group)
    Gui, Build:Add, ComboBox, vRG%A_Index%gem gUpdateElements w%gemWidth% h%listHeight% x+5, % GetGemList(RG%A_Index%group, RG%A_Index%gem)
    Gui, Build:Add, Edit, vRG%A_Index%color gUpdateEdit w%colorWidth% h%optionHeight% x+5, % RG%A_Index%color
    Gui, Build:Add, Edit, vRG%A_Index%npc gUpdateEdit w%npcWidth% h%optionHeight% x+5, % groupList[GroupIndex(RG%A_Index%group)][2]
    Gui, Build:Add, Edit, vRG%A_Index%note gUpdateEdit w%noteWidth% h%optionHeight% x+5, % RG%A_Index%note
  }

  Gui, Build:Show, w%buildWidth% h475 NA
  WinSet, AlwaysOnTop, Off, ahk_id %BuildWindow%
  WinActivate, ahk_id %BuildWindow%

}





LoadGemFile(fileName) {
  global
  ;Read fileLevel.INI
  ;*** INI really should exist since they selected it
  INIGem:=fileName
  ifnotexist,%INIGem%
  {
    return
  }
  For k, someControl in controlList {
    IniRead, gemName, %INIGem%, %someControl%, gem
    IniRead, groupName, %INIGem%, %someControl%, group
    ;Replace Siosa with Lilly after he unlocks
    If (groupName = "Siosa" and gemLevel > 31) {
      groupName := "Lilly"
    }
    If (groupName != "All") {
      groupIndex := GroupIndex(groupName)
      gemExists := 0
      For j, someGem in groupList[groupIndex] { ;See if the gem is in the group
        If (someGem = gemName and j>2) {
          gemExists := 1
          break
        } Else {
          gemExists := 0
        }
      }
      If (gemExists = 0) { ;If the group doesn't exist, check the inventory
        groupName := "Inventory"
        groupIndex := GroupIndex(groupName)
        groupName := "All" ;If the gem isn't in Inventory set it to all
        For j, someGem in groupList[groupIndex] { ;See if the gem is in the Inventory
          If (someGem = gemName and j>2) {
            groupName := "Inventory"
            break
          }
        }
      }
    }
    %someControl%group := groupName
    %someControl%gem := gemName
    IniRead, %someControl%color, %INIGem%, %someControl%, color
    IniRead, %someControl%npc, %INIGem%, %someControl%, npc
    IniRead, %someControl%note, %INIGem%, %someControl%, note
  }
}


ReadGemFile(fileLevel) {
  global
  ;Read fileLevel.INI
  ;*** Create INI if not exist
  INIGem=%A_scriptdir%\builds\%overlayFolder%\gems\%fileLevel%.ini
  INIMeta=%A_scriptdir%\builds\%overlayFolder%\gems\meta.ini
  newFileCreated := 0
  ifnotexist,%INIGem%
  {
    SaveGemFile(fileLevel)
    ;This allows the IniReads later to work
    newFileCreated := 1
  }
  IniRead, charClass, %INIMeta%, Build, class
  ;If there is no class in the file, pick one
  If (charClass = "ERROR" or charClass = "") {
    charClass := "Duelist"
  }
  GuiControl,,charClass, % "|" test := GetClasses(charClass)
  IniRead, charName, %INIMeta%, Build, name
  If (charName = "ERROR") {
    charName := ""
  }
  GuiControl,,charName, %charName%
  ;Use the group for the current character class and level
  LoadGroup(fileLevel, charClass)
  For k, someControl in controlList {
    IniRead, gemName, %INIGem%, %someControl%, gem
    IniRead, groupName, %INIGem%, %someControl%, group
    originalGroupName := groupName
    ;Replace Siosa with Lilly after he unlocks
    If (groupName = "Siosa" and fileLevel > 31) {
      groupName := "Lilly"
    }
    If (groupName != "All") {
      groupIndex := GroupIndex(groupName)
      gemExists := 0
      For j, someGem in groupList[groupIndex] { ;See if the gem is in the group
        If (someGem = gemName and j>2) {
          gemExists := 1
          break
        } Else {
          gemExists := 0
        }
      }
      If (gemExists = 0) { ;If the gem doesn't exist in the group, check the inventory
        groupName := "Inventory"
        groupIndex := GroupIndex(groupName)
        groupName := "All" ;If the gem isn't in Inventory set it to all
        For j, someGem in groupList[groupIndex] { ;See if the gem is in the Inventory
          If (someGem = gemName and j>2) {
            groupName := "Inventory"
            break
          }
        }
      }
    }
    %someControl%group := groupName
    %someControl%gem := gemName
    IniRead, %someControl%color, %INIGem%, %someControl%, color
    If (groupName = "Inventory" and originalGroupName != "Inventory") { ;clear meta data for gems moved to inventory
      %someControl%npc := ""
      %someControl%note := ""
    } Else {
      IniRead, %someControl%npc, %INIGem%, %someControl%, npc
      IniRead, %someControl%note, %INIGem%, %someControl%, note
    }

    If (newFileCreated) {
      For k, someGem in gemList {
        If (someGem.name = gemName) {
          If ( someGem.lvl > fileLevel + 2 ) { ;If the gem cannot be purchased yet, show its level instead of cost
            %someControl%note := someGem.lvl
          }
          break
        }
      }
    }

  }
  ;Save any minor edits we made
  SaveGemFile(fileLevel)
}

SaveGemFile(fileLevel) {
  global
  folderName := A_scriptdir . "\builds\" . overlayFolder . "\gems"
  If (InStr(FileExist(folderName), "D")) {
    ;Exists, do nothing
  } Else {
    ;Doesn't exist, make the folder
    FileCreateDir, %folderName%
  }
  INIGem=%A_scriptdir%\builds\%overlayFolder%\gems\%fileLevel%.ini
  INIMeta=%A_scriptdir%\builds\%overlayFolder%\gems\meta.ini
  IniWrite, %charClass%, %INIMeta%, Build, class
  IniWrite, %charName%, %INIMeta%, Build, name
  For k, someControl in controlList {
    If (someControl != "") {
      IniWrite, % %someControl%group, %INIGem%, %someControl%, group
      IniWrite, % %someControl%gem, %INIGem%, %someControl%, gem
      IniWrite, % %someControl%color, %INIGem%, %someControl%, color
      IniWrite, % %someControl%npc, %INIGem%, %someControl%, npc
      IniWrite, % %someControl%note, %INIGem%, %someControl%, note
    }
  }
}

LoadGroup(loadLevel, loadChar) {
  global
  gem_data := {}
  Try {
      FileRead, JSONFile, %A_ScriptDir%\lib\gems.json
      gem_data := JSON.Load(JSONFile)
      If (not gem_data.Length()) {
          MsgBox, 16, , Error reading gem data! `n`nExiting script.
          ExitApp
      }
  } Catch e {
      MsgBox, 16, , % e "`n`nNo Gem data in \lib\gems.json"
      ;ExitApp
  }

  groupList := Object()
  groupList[1] := [] ;One All group for free form editing
  groupList[1].Push("All")
  groupList[1].Push("")

  ;gemList := Object()
  For key, someGem in gem_data {
    
    If (gemList.length() < key) { ; Only populate gemList the first time
      gemList[gemList.length()+1] := Object()
      gemList[gemList.length()].name := someGem.name
      tempColor := someGem.color
      gemList[gemList.length()].color := %tempColor%Color ;Use the settings color
      gemList[gemList.length()].cost := someGem.cost
      gemList[gemList.length()].vendor := someGem.vendor
      gemList[gemList.length()].lvl := someGem.required_lvl

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

    addGem1 := 0 ;only add gems that match the filter
    If (gemFilter1 = " None") {
      addGem1 := 1
    } Else {
      For k, someFilter in someGem.gemTags {
        If (someFilter = gemFilter1) {
          addGem1 := 1
          break
        }
      }
    }

    addGem2 := 0 ;only add gems that match the filter
    If (gemFilter2 = " None") {
      addGem2 := 1
    } Else {
      For k, someFilter in someGem.gemTags {
        If (someFilter = gemFilter2) {
          addGem2 := 1
          break
        }
      }
    }

    If (addGem1 and addGem2) {
      groupList[1].Push(someGem.name) ; Push every gem to All
    }

    If (someGem.level <= loadLevel) {

      ;This is a small hack
      If (loadChar = "Duelist") {
        thisGroup := someGem.Duelist
      } Else If (loadChar = "Marauder") {
        thisGroup := someGem.Marauder
      } Else If (loadChar = "Ranger") {
        thisGroup := someGem.Ranger
      } Else If (loadChar = "Scion") {
        thisGroup := someGem.Scion
      } Else If (loadChar = "Shadow") {
        thisGroup := someGem.Shadow
      } Else If (loadChar = "Templar") {
        thisGroup := someGem.Templar
      } Else If (loadChar = "Witch") {
        thisGroup := someGem.Witch
      }

      ;Some vendors don't sell gems even though they are rewards, WTF?!
      addVendor := 1
      If (SubStr(thisGroup, 1 , 1) = "!") {
        addVendor :=0
        StringTrimLeft, thisGroup, thisGroup, 1
      }

      ;Mercy Mission has gems at different levels so put them all in one
      ;without breaking vendors
      If (thisGroup = "Mercy Mission") { 
        someGem.level := 4
        If (loadLevel = 2) { ;Don't show Mercy Mission for level 2
          continue
        }
      }

      If (thisGroup = "") {
        thisGroup := "Drop-Only"
      } Else If (someGem.level < loadLevel) { ;Add to Inventory
        If (thisGroup = "Siosa") {
          ;Siosa gems need to stick around until after Lilly is unlocked
          If (loadLevel > 34) { ;At 38 everything that is purchasable is done through Lilly
            thisGroup := "Lilly"
          }
        } Else If (thisGroup = "Lilly") {
          ;Lilly gems are only available from her no matter the level
        } Else {
          thisGroup := "Inventory" ;All other lower gems should be considered purchased
        }
      }

      groupIndex := GroupIndex(thisGroup)

      If (groupIndex) { ;Already exists (common)
        If (addGem1 and addGem2) {
          groupList[groupIndex].Push(someGem.name)
        }
        If InStr(thisGroup, A_Space) and addVendor { ;For quests also push to the vendor
          groupIndex := GroupIndex(someGem.vendor)
          If (groupIndex) { ;Vendor exists (common)
            If (addGem1 and addGem2) {
              groupList[groupIndex].Push(someGem.name)
            }
          } Else { ;Make Vendor (once)
            groupList[groupList.length()+1] := []
            groupList[groupList.length()].Push(someGem.vendor)
            groupList[groupList.length()].Push(someGem.vendor)
            If (addGem1 and addGem2) {
              groupList[groupList.length()].Push(someGem.name)
            }
          }
        } Else If ((thisGroup = "Siosa" and loadLevel >= 26) or (thisGroup = "Lilly" and loadLevel >= 38)) { ;Also push to Inventory
          If (someGem.level < loadLevel) {
            groupIndex := GroupIndex("Inventory")
            If (groupIndex) { ;Inventory exists (common)
              If (addGem1 and addGem2) {
                groupList[groupIndex].Push(someGem.name)
              }
            } Else { ;Make Inventory (once)
              groupList[groupList.length()+1] := []
              groupList[groupList.length()].Push("Inventory")
              groupList[groupList.length()].Push("")
              If (addGem1 and addGem2) {
                groupList[groupList.length()].Push(someGem.name)
              }
            }
          }
        }
      } Else { ;Doesn't exist (rare)
        groupList[groupList.length()+1] := []
        If (thisGroup = "Drop-Only") {
          groupList[groupList.length()].Push("Drop-Only")
          groupList[groupList.length()].Push("Trade")
          If (addGem1 and addGem2) {
            groupList[groupList.length()].Push(someGem.name)
          }
        } Else If InStr(thisGroup, A_Space) { 
          ;Make quest first (once)
          groupList[groupList.length()].Push(thisGroup)
          groupList[groupList.length()].Push(someGem.quest)
          If (addGem1 and addGem2) {
            groupList[groupList.length()].Push(someGem.name)
          }
          If (addVendor) {
            ;For quests also push to vendor
            groupIndex := GroupIndex(someGem.vendor)
            If (groupIndex) { ;Vendor exists (common)
              If (addGem1 and addGem2) {
                groupList[groupIndex].Push(someGem.name)
              }
            } Else { ;Make Vendor (once)
              groupList[groupList.length()+1] := []
              groupList[groupList.length()].Push(someGem.vendor)
              groupList[groupList.length()].Push(someGem.vendor)
              If (addGem1 and addGem2) {
                groupList[groupList.length()].Push(someGem.name)
              }
            }
          }
        } Else If (thisGroup = "Siosa" or thisGroup = "Lilly") {
          ;Push to group first (once)
          groupList[groupList.length()].Push(thisGroup)
          groupList[groupList.length()].Push(thisGroup)
          If (addGem1 and addGem2) {
            groupList[groupList.length()].Push(someGem.name)
          }
          If ((thisGroup = "Siosa" and loadLevel >= 26) or (thisGroup = "Lilly" and loadLevel >= 38)) {
            ;Also push to Inventory
            If (someGem.level < loadLevel) {
              groupIndex := GroupIndex("Inventory")
              If (groupIndex) { ;Inventory exists (common)
                If (addGem1 and addGem2) {
                  groupList[groupIndex].Push(someGem.name)
                }
              } Else { ;Make Inventory (once)
                groupList[groupList.length()+1] := []
                groupList[groupList.length()].Push("Inventory")
                groupList[groupList.length()].Push("")
                If (addGem1 and addGem2) {
                  groupList[groupList.length()].Push(someGem.name)
                }
              }
            }
          }
        } Else If (thisGroup = "Inventory") {
          groupList[groupList.length()].Push("Inventory")
          groupList[groupList.length()].Push("")
          If (addGem1 and addGem2) {
            groupList[groupList.length()].Push(someGem.name)
          }
        } Else { ;Just a Vendor
          groupList[groupList.length()].Push(thisGroup)
          groupList[groupList.length()].Push(thisGroup)
          If (addGem1 and addGem2) {
            groupList[groupList.length()].Push(someGem.name)
          }
        }
      }
    }
  }
}



GroupIndex(checkGroup) {
  global
  For i, existingGroup in groupList {
    If (existingGroup[1] = checkGroup) {
      return i
    }
  }
  return 0
}


CheckSave(varLevel) {
  global
  If (unsaved) {
    MsgBox, 3,, You have unsaved changes, would you like to save?
    IfMsgBox Yes
    {
      Gui, Build:Submit, NoHide
      SaveGemFile(varLevel)
      unsaved := 0
      return 1
    } Else IfMsgBox No
    {
      return 1
    } Else {
      return 0
    }
  } Else {
    return 1
  }
}


SaveBuild() {
  global
  Gui, Build:Submit, NoHide

  SaveGemFile(gemLevel)
  unsaved := 0

  ;Gui, Build:Cancel
  ;WinActivate, ahk_id %PoEWindowHwnd%
  ;Reload
}

CloseBuild() {
  global
  If (CheckSave(gemLevel)) {
    Gui, Build:Cancel
    ;WinActivate, ahk_id %PoEWindowHwnd%
  }
}

ClearBuild() {
  global
  For k, someControl in controlList {
    GuiControl,,%someControl%group, % "|" test := GetGroupList("All")
    GuiControl,Text,%someControl%gem,
    ;Also clear color, npc and notes
    GuiControl,,%someControl%color,
    GuiControl,,%someControl%note,
    GuiControl,,%someControl%npc,
  }

  unsaved := 1
}

ClearControls() {
  global
  For k, someControl in controlList {
    %someControl%group := ""
    %someControl%gem := ""
    %someControl%color := ""
    %someControl%npc := ""
    %someControl%note := ""
  }
}

UpdateFilter() {
  global
  Gui, Build:Submit, NoHide
  LoadGroup(gemLevel, charClass)
  For k, someControl in controlList {
    GuiControl,,%someControl%group, % "|" test := GetGroupList(%someControl%group)
    ;Update all gems
    gemName := %someControl%gem
    GuiControl,,%someControl%gem, % "|" test := GetGemList(%someControl%group, %someControl%gem)
    GuiControl,Text,%someControl%gem, %gemName%
  }

  unsaved := 1
}

LoadBuild() {
  global
  FileSelectFile, SelectedFile, 3, %A_ScriptDir%\builds\%overlayFolder%\gems\%gemLevel%.ini, Load a Gem File, Gem File (*.ini;)
  LoadGemFile(SelectedFile)
  For k, someControl in controlList {
    GuiControl,,%someControl%group, % "|" test := GetGroupList(%someControl%group)
    gemName := %someControl%gem
    GuiControl,,%someControl%gem, % "|" test := GetGemList(%someControl%group, %someControl%gem)
    GuiControl,Text,%someControl%gem, %gemName%
    ;Also load color, npc and notes
    GuiControl,,%someControl%color, % %someControl%color
    GuiControl,,%someControl%note, % %someControl%note
    GuiControl,,%someControl%npc, % %someControl%npc
  }

  unsaved := 1
}

GetGroupList(groupName) {
  global
  dList := ""
  For k, someGroup in groupList {
    dList .= someGroup[1] . "|"
    If (someGroup[1] = groupName) {
      dList .= "|"
    }
  }
  Return dList
}

GetGemList(groupName, selectedGem) {
  global
  dList := ""
  For k, someGem in groupList[GroupIndex(groupName)] {
    If (k > 2) {
      dList .= someGem . "|"
    }
    If (someGem = selectedGem) {
      dList .= "|"
    }
  }
  Return dList
}

GetNPC(groupIndex) {
  global
  dList := ""
  For k, someNPC in npcList {
    dList .= someNPC . "|"
    If (someNPC = npcName) {
      dList .= "|"
    }
  }
  Return dList
}

GetClasses(controlClass) {
  global
  dList := ""
  For k, someClass in classList {
    dList .= someClass . "|"
    If (someClass = controlClass) {
      dList .= "|"
    }
  }
  Return dList
}

GetLevels(controlLevel) {
  global
  dList := ""
  For k, someLevel in levelList {
    dList .= someLevel . "|"
    If (someLevel = controlLevel) {
      dList .= "|"
    }
  }
  Return dList
}

GetFilters(controlFilter) {
  global
  dList := ""
  For k, someFilter in filterList {
    dList .= someFilter . "|"
    If (someFilter = controlFilter) {
      dList .= "|"
    }
  }
  Return dList
}

UpdateEdit() {
  global
  unsaved := 1
}

UpdateControl() {
  global
  oldGemLevel := gemLevel

  If (CheckSave(oldGemLevel)) {
    Gui, Build:Submit, NoHide ;this gets the newly selected gem level

    ;incase nothing else changed, save the build class change
    INIMeta=%A_scriptdir%\builds\%overlayFolder%\gems\meta.ini
    IniWrite, %charClass%, %INIMeta%, Build, class

    ReadGemFile(gemLevel)

    For k, someControl in controlList {

      GuiControl,,%someControl%group, % "|" test := GetGroupList(%someControl%group)
      gemName := %someControl%gem
      GuiControl,,%someControl%gem, % "|" test := GetGemList(%someControl%group, %someControl%gem)
      GuiControl,Text,%someControl%gem, %gemName%

      ;This can all happen every time now since we set it different based on level
      GuiControl,,%someControl%color, % %someControl%color
      GuiControl,,%someControl%note, % %someControl%note
      GuiControl,,%someControl%npc, % %someControl%npc

    }

    ;Have to sleep otherwise the GuiControls finishing above this reset the unsaved value
    Sleep 100
    ;Don't set this to unsaved since we just saved when reading the new gem file
    unsaved := 0
  } Else {
    ;gemLevel := oldGemLevel
    GuiControl,,gemLevel, % "|" test := GetLevels(oldGemLevel)
    Gui, Build:Submit, NoHide
  }

}

UpdateGroup() {
  global
  element := SubStr(A_GuiControl, 1 , 3)
  Gui, Build:Submit, NoHide
  gemName := %element%gem
  GuiControl,,%element%gem, % "|" test := GetGemList(%element%group, %element%gem)
  GuiControl,Text,%element%gem, %gemName%
  npcUpdate := groupList[GroupIndex(%element%group)][2]
  GuiControl,,%element%npc,%npcUpdate%
  UpdateElements()
}

UpdateElements() {
  global
  element := SubStr(A_GuiControl, 1 , 3)
  Gui, Build:Submit, NoHide

  If (%element%gem = "") { ;If there is no text, remove the metadata
    colorUpdate := ""
    noteUpdate := ""
    npcUpdate := groupList[GroupIndex(%element%group)][2]
  } Else {
    colorUpdate := %element%color
    noteUpdate := %element%note
    npcUpdate := %element%npc
  }
  
  For k, someGem in gemList {
    thisGroup := %element%group
    If (someGem.name = %element%gem) {
      colorUpdate := someGem.color
      If ( InStr(thisGroup, A_Space) or thisGroup = "Inventory" or thisGroup = "Drop-Only") { ;I want cost for All since Inventory should be used for no cost Gems
        ;It's a quest reward or already purchased or Drop-Only so leave out cost
        noteUpdate := ""
      } Else {
        noteUpdate := someGem.cost
        If ( someGem.lvl > gemLevel + 2 ) { ;If the gem cannot be purchased yet, show its level instead of cost
          noteUpdate := someGem.lvl
        }
      }
      If (thisGroup = "All") {
        npcUpdate := someGem.vendor
      }
      break
    }
  }
  GuiControl,,%element%color,%colorUpdate%
  GuiControl,,%element%note,%noteUpdate%
  GuiControl,,%element%npc,%npcUpdate%

  unsaved := 1
}