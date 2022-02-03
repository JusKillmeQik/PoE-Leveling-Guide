RotateAct(direction, acts, current) {
  global
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

SearchLog() {
  global
  ;Only bother checking if the newLogLines has changed or someone manually changed Part
  newLogLines := client_txt_file.Read()
  If (trigger) {
    trigger := 0
    newLogLines := LastLogLines
  }
  If (newLogLines) {
    levelUp := charName ;check character name is present first
    IfInString, newLogLines, %levelUp%
    {
      levelUp := "is now level"

      IfInString, newLogLines, %levelUp%
      {
        levelPos := InStr(newLogLines, levelUp, false)
        newLevel := Trim(SubStr(newLogLines, levelPos+13, 2))
        newLevel += 0 ; force the string to be an int, clearing any space
        nextLevel := newLevel + 1
        ;So levels stay in order
        If (newLevel < 10)
        {
          newLevel := "0" . newLevel
        }
        If (nextLevel < 10)
        {
          nextLevel := "0" . nextLevel
        }
        GuiControl,Level:,CurrentLevel, %newLevel%
        Sleep, 100
        gemFiles := []
        Loop %A_ScriptDir%\builds\%overlayFolder%\gems\*.ini
        {
          tempFileName = %A_LoopFileName%
          StringTrimRight, tempFileName, tempFileName, 4
          If (tempFileName != "meta" and tempFileName != "class") 
          {
            gemFiles.Push(tempFileName)
          }
        }
        For index, someLevel in gemFiles
        {
          If ( InStr(someLevel,newLevel) || InStr(someLevel,nextLevel) ) 
          {
            GuiControl,Gems:,CurrentGem, % "|" test := GetDelimitedPartListString(gemFiles, someLevel)
            Sleep, 100
            Gui, Gems:Submit, NoHide
            If (gems_toggle) 
            {
              SetGems()
            }
            break
          }
        }
        SaveState()
      }
      beenSlain := "has been slain"
      IfInString, newLogLines, %beenSlain%
      {
        Sleep, 5000
        Send, %KeyOnDeath%
      }
    } ;end level up logic

    travel := "You have entered" ; deprecated by the following line but leaving in for a league to make sure it doesn't break for people
    ;travel := "Generating level" ;  (Delete this line if zones are not auto updating) Generating level now shows more detail than you have entered
    generated := "Generating level"
    If ( InStr(newLogLines,travel) || InStr(newLogLines,generated) ) ;remove the travel search if no one complains
    {
      If ( autoToggleZoneImages = "True" )
      {
        zone_toggle := 1
        places_disabled_zones :=  ["Hideout","Rogue Harbour", "Oriath", "Lioneye's Watch", "The Forest Encampment", "The Sarn Encampment", "Highgate", "Overseer's Tower", "The Bridge Encampment", "Oriath Docks"]
        For _, zone in places_disabled_zones
          IfInString, newLogLines, %zone% 
          {
            zone_toggle := 0
            break
          }
      }
      activeCount := 0
      active_toggle := 1

      If(InStr(newLogLines,generated)){
        generatedHappened := 1
        levelPos := InStr(newLogLines, generated, false)
        lastMonsterLevel := monsterLevel
        monsterLevel := SubStr(newLogLines, levelPos+17, 2)
      } Else {
        If(generatedHappened != 1){
          monsterLevel := -1
        }
        generatedHappened := 0
        If(InStr(newLogLines,"Hideout")) ;reset exp if traveling to hideout
        {
          monsterLevel := lastMonsterLevel
        }
      }

      newPartTest := "Lioneye's Watch"
      IfInString, newLogLines, %newPartTest%
      {
        act5LastZone := "45 Cathedral Rooftop"
        If (CurrentZone = act5LastZone)
        {
          numPart := 2
          CurrentPart := "Part 2"
          GuiControl, Controls:Choose, CurrentPart, % "|" CurrentPart
        }
      }

      ;Update this once we know the new Kirac Questline
      ; newPartTest := "Oriath"
      ; IfInString, newLogLines, %newPartTest%
      ; {
      ;   act10LastZone := "67 Feeding Trough"
      ;   If (CurrentZone = act10LastZone)
      ;   {
      ;     GuiControl, Controls:Choose, CurrentAct, % "|Act 11"
      ;     GuiControl, Controls:Choose, CurrentZone, % "|68 The Templar Laboratory"
      ;   }
      ; }

      ; newPartTest := "Hideout"
      ; IfInString, newLogLines, %newPartTest%
      ; {
      ;   act11LastZone := "68 The Haunted Reliquary"
      ;   If (CurrentZone = act11LastZone)
      ;   {
      ;     numPart := 3
      ;     CurrentPart := "Maps"
      ;     GuiControl, Controls:Choose, CurrentPart, % "|" CurrentPart
      ;   }
      ; }

      newPartTest := "Aspirants' Plaza"
      IfInString, newLogLines, %newPartTest%
      {
        CurrentZone := "00 Aspirants' Plaza"
        ; GuiControl, Controls:Choose, CurrentZone, % "|" CurrentZone
        SetNotes()
        return
      }

      newAct := CurrentAct
      If (numPart != 3) 
      {
        ;loop through all of the acts in the current part
        Loop, 6 
        {
          For key, zoneGroup in data.zones 
          {
            If (zoneGroup.act = newAct) 
            {
              For k, newZone in zoneGroup.list 
              {
                StringTrimLeft, zoneSearch, newZone, 3
                IfInString, newLogLines, %zoneSearch%
                {
                  If (newAct != CurrentAct) 
                  {
                    GuiControl, Controls:Choose, CurrentAct, % "|" newAct
                    CurrentAct := newAct
                    Sleep 100
                  }
                  LastLogLines := StrReplace(newLogLines, "`r`n")
                  GuiControl, Controls:Choose, CurrentZone, % "|" newZone
                  CurrentZone := newZone
                  Sleep 100
                  UpdateImages()
                  break 3
                }
              }
              If (numPart = 1)
              {
                actData := data.p1acts
              } Else If (numPart = 2) 
              {
                actData := data.p2acts
              }
              newAct := RotateAct("next", actData, newAct)
              break
            }
          }
        }
      } Else ;This can stay for now but maps will be disabled in this version for now
      {
        ;loop through all of the Maps
        For key, value in Maps 
        {
          zoneSearch := "entered " . key . "."
          IfInString, newLogLines, %zoneSearch%
          {
            conqFound := 0
            GuiControl, Controls:Choose, CurrentZone, % "|" key
            CurrentZone := key
            Sleep 100
            UpdateImages()
            break
          }
        }
      }
    } ;end travel logic

    ;Conquerer Logic goes here!
    ;Conquerers are no longer part of the main progression
    ; If (!conqFound)
    ; {
    ;   conqueror := "Veritania, the Redeemer"
    ;   IfInString, newLogLines, %conqueror%
    ;   {
    ;     conqFound := 1
    ;     Conquerors["Veritania"].Region := Maps[CurrentZone].Region
    ;     Conquerors["Veritania"].Appearances := Conquerors["Veritania"].Appearances + 1
    ;     If (Conquerors["Veritania"].Appearances = 5)
    ;     {
    ;       Conquerors["Veritania"].Appearances = 4
    ;     } Else If (Conquerors["Veritania"].Appearances = 4)
    ;     {
    ;       ;Conquerors["Veritania"].Region := ""
    ;       ;Conquerors["Veritania"].Appearances := 0
    ;       numWatchstones := SubStr(CurrentAct, 1, 2)
    ;       numWatchstones++
    ;       GuiControl, Controls:Choose, CurrentAct, % "|" numWatchstones + 1
    ;     } Else {
    ;       GuiControl, Controls:Choose, CurrentAct, % "|" CurrentAct
    ;     }
    ;     ClearConquerors("Veritania")
    ;   }

    ;   conqueror := "Drox, the Warlord"
    ;   IfInString, newLogLines, %conqueror%
    ;   {
    ;     conqFound := 1
    ;     Conquerors["Drox"].Region := Maps[CurrentZone].Region
    ;     Conquerors["Drox"].Appearances := Conquerors["Drox"].Appearances + 1
    ;     If (Conquerors["Drox"].Appearances = 5)
    ;     {
    ;       Conquerors["Drox"].Appearances = 4
    ;     } Else If (Conquerors["Drox"].Appearances = 4)
    ;     {
    ;       ;Conquerors["Drox"].Region := ""
    ;       ;Conquerors["Drox"].Appearances := 0
    ;       numWatchstones := SubStr(CurrentAct, 1, 2)
    ;       numWatchstones++
    ;       GuiControl, Controls:Choose, CurrentAct, % "|" numWatchstones + 1
    ;     } Else {
    ;       GuiControl, Controls:Choose, CurrentAct, % "|" CurrentAct
    ;     }
    ;     ClearConquerors("Drox")
    ;   }

    ;   conqueror := "Baran, the Crusader"
    ;   IfInString, newLogLines, %conqueror%
    ;   {
    ;     conqFound := 1
    ;     Conquerors["Baran"].Region := Maps[CurrentZone].Region
    ;     Conquerors["Baran"].Appearances := Conquerors["Baran"].Appearances + 1
    ;     If (Conquerors["Baran"].Appearances = 5)
    ;     {
    ;       Conquerors["Baran"].Appearances = 4
    ;     } Else If (Conquerors["Baran"].Appearances = 4)
    ;     {
    ;       ;Conquerors["Baran"].Region := ""
    ;       ;Conquerors["Baran"].Appearances := 0
    ;       numWatchstones := SubStr(CurrentAct, 1, 2)
    ;       numWatchstones++
    ;       GuiControl, Controls:Choose, CurrentAct, % "|" numWatchstones + 1
    ;     } Else
    ;     {
    ;       GuiControl, Controls:Choose, CurrentAct, % "|" CurrentAct
    ;     }
    ;     ClearConquerors("Baran")
    ;   }

    ;   conqueror := "Al-Hezmin, the Hunter"
    ;   IfInString, newLogLines, %conqueror%
    ;   {
    ;     conqFound := 1
    ;     Conquerors["Al-Hezmin"].Region := Maps[CurrentZone].Region
    ;     Conquerors["Al-Hezmin"].Appearances := Conquerors["Al-Hezmin"].Appearances + 1
    ;     If (Conquerors["Al-Hezmin"].Appearances = 5)
    ;     {
    ;       Conquerors["Al-Hezmin"].Appearances = 4
    ;     } Else If (Conquerors["Al-Hezmin"].Appearances = 4)
    ;     {
    ;       ;Conquerors["Al-Hezmin"].Region := ""
    ;       ;Conquerors["Al-Hezmin"].Appearances := 0
    ;       numWatchstones := SubStr(CurrentAct, 1, 2)
    ;       numWatchstones++
    ;       GuiControl, Controls:Choose, CurrentAct, % "|" numWatchstones + 1
    ;     } Else
    ;     {
    ;       GuiControl, Controls:Choose, CurrentAct, % "|" CurrentAct
    ;     }
    ;     ClearConquerors("Al-Hezmin")
    ;   }
    ; } ;end conqueror logic

    If (level_toggle) 
    {
      SetExp()
    }
  }
}

; ClearConquerors(currentConqueror) {
;   For key, value in Conquerors {
;     ;If we get a new Conqueror and an old one finished, clear it
;     If ( key!=currentConqueror and value.Appearances>=4){
;       value.Appearances := 0
;       value.Region := ""
;       GuiControl, Controls:Choose, CurrentAct, % "|" CurrentAct
;     }
;   }
; }
