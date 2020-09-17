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

SearchLog() {
  global
  log := Tail(1, client)
  ;Only bother checking if the log has changed or someone manually changed Part
  If (log != oldLog or trigger) {
    oldLog := log
    trigger := false
    levelUp := charName ;check character name is present first
    IfInString, log, %levelUp%
    {
      levelUp := "is now level"
      IfInString, log, %levelUp%
      {
        levelPos := InStr(log, levelUp, false)
        newLevel := SubStr(log, levelPos+13, 2)
        ;So levels stay in order
        If (StrLen(newLevel) = 1){
          newLevel := "0" . newLevel
        }
        GuiControl,Level:,CurrentLevel, %newLevel%
        Sleep, 100
        If (level_toggle) {
          SetExp()
        }
        gemFiles := []
        Loop %A_ScriptDir%\builds\%overlayFolder%\gems\*.ini
        {
          tempFileName = %A_LoopFileName%
          StringTrimRight, tempFileName, tempFileName, 4
          If (tempFileName != "meta") {
            gemFiles.Push(tempFileName)
          }
        }
        For index, someLevel in gemFiles
        {
          If ((someLevel = newLevel) || (someLevel = newLevel+1)) {
            GuiControl,Gems:,CurrentGem, % "|" test := GetDelimitedPartListString(gemFiles, someLevel)
            Sleep, 100
            Gui, Gems:Submit, NoHide
            If (gems_toggle) {
              SetGems()
            }
            break
          }
        }
        SaveState()
      }
      beenSlain := "has been slain"
      IfInString, log, %beenSlain%
      {
        Sleep, 100
        Send, %KeyOnDeath%
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
        If (CurrentZone = act5LastZone) {
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
                UpdateImages()
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
    }
  }
}