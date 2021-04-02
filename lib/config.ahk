global overlayFolder := "3.13 Gladiator Bleed Bow"
global notesFolder := "Default"

global points := 9
global font := "Consolas"
global lineSpacing := 1.2
global gemSpacing := 2
global boldness := 0
global imageSizeMultiplier := .5
global maxNotesWidth := 40
global maxGuideWidth := 60
global maxLinksWidth := 40

global guideXoffset := .78
global guideYoffset := 0
global levelXoffset := .589
global levelYoffset := .955
global gemsXoffset := .005
global gemsYoffset := .180
global imagesXoffset := 0
global imagesYoffset := 0

global treeSide := "Right"
global treeName := "tree.jpg"
global opacity := 180
global startHidden := "False"
global displayTimeout := 5
global persistText := "False"
global hideGuide := "False"
global hideNotes := "False"
global expOrPen := "Exp"

global backgroundColor := "black"
global redColor := "FF4040"
global greenColor := "2ECC40"
global blueColor := "0080FF"
global yellowColor := "F0E130"
global whiteColor := "white"

global KeyHideLayout := "!F1"
global KeyHideZones := "!F2"
global KeyCycleZones := "^PgDn"
global KeyHideExp := "!F3"
global KeyHideTree := "!f"
global KeyHideGems := "!g"

global KeyShowSyndicate := "F5"
global KeyShowTemple := "F6"
global KeyShowHeist := "F7"

global KeyOnDeath := ""

global KeySettings := "F10"

global tree_toggle := 0

global zone_toggle := 1
global level_toggle := 1
global gems_toggle := 1
global LG_toggle := 0

global activeCount := 0
global active_toggle := 1

;State
global numPart := 1
global CurrentPart = "Part 1"
global CurrentAct = "Act 1"
global CurrentZone = "01 Twilight Strand"
global CurrentLevel = "01"
global CurrentGem = "02"

;*** Create INI if not exist
ININame=%A_scriptdir%\config.ini
ifnotexist,%ININame%
{
  WriteAll()
}

;*** Load
;IniRead, OutputVar, Filename, Section, Key , Default

IniRead, overlayFolder, %ININame%, Build, overlayFolder, %overlayFolder%
IniRead, notesFolder, %ININame%, Build, notesFolder, %notesFolder%

IniRead, points, %ININame%, Size, points, %points%
IniRead, font, %ININame%, Size, font, %font%
IniRead, boldness, %ININame%, Size, boldness, %boldness%
IniRead, imageSizeMultiplier, %ININame%, Size, imageSizeMultiplier, %imageSizeMultiplier%
IniRead, lineSpacing, %ININame%, Size, lineSpacing, %lineSpacing%
IniRead, gemSpacing, %ININame%, Size, gemSpacing, %gemSpacing%

IniRead, maxNotesWidth, %ININame%, Size, maxNotesWidth, %maxNotesWidth%
IniRead, maxGuideWidth, %ININame%, Size, maxGuideWidth, %maxGuideWidth%
IniRead, maxLinksWidth, %ININame%, Size, maxLinksWidth, %maxLinksWidth%

IniRead, guideXoffset, %ININame%, Offset, guideXoffset, %guideXoffset%
IniRead, guideYoffset, %ININame%, Offset, guideYoffset, %guideYoffset%
IniRead, levelXoffset, %ININame%, Offset, levelXoffset, %levelXoffset%
IniRead, levelYoffset, %ININame%, Offset, levelYoffset, %levelYoffset%
IniRead, gemsXoffset, %ININame%, Offset, gemsXoffset, %gemsXoffset%
IniRead, gemsYoffset, %ININame%, Offset, gemsYoffset, %gemsYoffset%
IniRead, imagesXoffset, %ININame%, Offset, imagesXoffset, %imagesXoffset%
IniRead, imagesYoffset, %ININame%, Offset, imagesYoffset, %imagesYoffset%

IniRead, treeSide, %ININame%, Options, treeSide, %treeSide%
IniRead, treeName, %ININame%, Options, treeName, %treeName%
IniRead, opacity, %ININame%, Options, opacity, %opacity%
IniRead, startHidden, %ININame%, Options, startHidden, %startHidden%
IniRead, displayTimeout, %ININame%, Options, displayTimeout, %displayTimeout%
IniRead, persistText, %ININame%, Options, persistText, %persistText%
IniRead, hideGuide, %ININame%, Options, hideGuide, %hideGuide%
IniRead, hideNotes, %ININame%, Options, hideNotes, %hideNotes%
IniRead, expOrPen, %ININame%, Options, expOrPen, %expOrPen%

If (startHidden = "True"){
  LG_toggle := 1
} Else If (startHidden = "False"){
  LG_toggle := 0
}

IniRead, backgroundColor, %ININame%, Color, backgroundColor, %backgroundColor%
IniRead, redColor, %ININame%, Color, redColor, %redColor%
IniRead, greenColor, %ININame%, Color, greenColor, %greenColor%
IniRead, blueColor, %ININame%, Color, blueColor, %blueColor%
IniRead, yellowColor, %ININame%, Color, yellowColor, %yellowColor%
IniRead, whiteColor, %ININame%, Color, whiteColor, %whiteColor%

IniRead, KeySettings, %ININame%, ToggleKey, KeySettings, %KeySettings%
IniRead, KeyHideLayout, %ININame%, ToggleKey, KeyHideLayout, %KeyHideLayout%
IniRead, KeyHideZones, %ININame%, ToggleKey, KeyHideZones, %KeyHideZones%
IniRead, KeyCycleZones, %ININame%, ToggleKey, KeyCycleZones, %KeyCycleZones%
IniRead, KeyHideExp, %ININame%, ToggleKey, KeyHideExp, %KeyHideExp%
IniRead, KeyHideTree, %ININame%, ToggleKey, KeyHideTree, %KeyHideTree%
IniRead, KeyHideGems, %ININame%, ToggleKey, KeyHideGems, %KeyHideGems%
IniRead, KeyShowSyndicate, %ININame%, ToggleKey, KeyShowSyndicate, %KeyShowSyndicate%
IniRead, KeyShowTemple, %ININame%, ToggleKey, KeyShowTemple, %KeyShowTemple%
IniRead, KeyShowHeist, %ININame%, ToggleKey, KeyShowHeist, %KeyShowHeist%
IniRead, KeyOnDeath, %ININame%, ToggleKey, KeyOnDeath, %KeyOnDeath%

INIMeta=%A_scriptdir%\builds\%overlayFolder%\gems\meta.ini
IniRead, numPart, %INIMeta%, State, numPart, %numPart%
IniRead, CurrentPart, %INIMeta%, State, CurrentPart, %CurrentPart%

;Backwards compatibility
If (CurrentPart = "Part I") {
  CurrentPart := "Part 1"
}
If (CurrentPart = "Part II") {
  CurrentPart := "Part 2"
}

IniRead, CurrentAct, %INIMeta%, State, CurrentAct, %CurrentAct%

;Backwards compatibility
If (CurrentAct = "Act I") {
  CurrentAct := "Act 1"
}
If (CurrentAct = "Act II") {
  CurrentAct := "Act 2"
}
If (CurrentAct = "Act III") {
  CurrentAct := "Act 3"
}
If (CurrentAct = "Act IV") {
  CurrentAct := "Act 4"
}
If (CurrentAct = "Act V") {
  CurrentAct := "Act 5"
}
If (CurrentAct = "Act VI") {
  CurrentAct := "Act 6"
}
If (CurrentAct = "Act VII") {
  CurrentAct := "Act 7"
}
If (CurrentAct = "Act VIII") {
  CurrentAct := "Act 8"
}
If (CurrentAct = "Act IX") {
  CurrentAct := "Act 9"
}
If (CurrentAct = "Act X") {
  CurrentAct := "Act 10"
}

IniRead, CurrentZone, %INIMeta%, State, CurrentZone, %CurrentZone%
IniRead, CurrentLevel, %INIMeta%, State, CurrentLevel, %CurrentLevel%
IniRead, CurrentGem, %INIMeta%, State, CurrentGem, %CurrentGem%
IniRead, zone_toggle, %INIMeta%, State, zone_toggle, %zone_toggle%
IniRead, level_toggle, %INIMeta%, State, level_toggle, %level_toggle%
IniRead, gems_toggle, %INIMeta%, State, gems_toggle, %gems_toggle%

SaveState() {
  global
  IniWrite, %numPart%, %INIMeta%, State, numPart
  IniWrite, %CurrentPart%, %INIMeta%, State, CurrentPart
  IniWrite, %CurrentAct%, %INIMeta%, State, CurrentAct
  IniWrite, %CurrentZone%, %INIMeta%, State, CurrentZone
  IniWrite, %CurrentLevel%, %INIMeta%, State, CurrentLevel
  IniWrite, %CurrentGem%, %INIMeta%, State, CurrentGem
  IniWrite, %zone_toggle%, %INIMeta%, State, zone_toggle
  IniWrite, %level_toggle%, %INIMeta%, State, level_toggle
  IniWrite, %gems_toggle%, %INIMeta%, State, gems_toggle
}

WriteAll() {
  global
	;IniWrite, Value, Filename, Section, Key
  IniWrite, %overlayFolder%, %ININame%, Build, overlayFolder
  IniWrite, %notesFolder%, %ININame%, Build, notesFolder

  IniWrite, %points%, %ININame%, Size, points
  IniWrite, %font%, %ININame%, Size, font
  IniWrite, %boldness%, %ININame%, Size, boldness
  IniWrite, %imageSizeMultiplier%, %ININame%, Size, imageSizeMultiplier
  IniWrite, %lineSpacing%, %ININame%, Size, lineSpacing
  IniWrite, %gemSpacing%, %ININame%, Size, gemSpacing
  IniWrite, %maxNotesWidth%, %ININame%, Size, maxNotesWidth
  IniWrite, %maxGuideWidth%, %ININame%, Size, maxGuideWidth
  IniWrite, %maxLinksWidth%, %ININame%, Size, maxLinksWidth

  IniWrite, %guideXoffset%, %ININame%, Offset, guideXoffset
  IniWrite, %guideYoffset%, %ININame%, Offset, guideYoffset
  IniWrite, %levelXoffset%, %ININame%, Offset, levelXoffset
  IniWrite, %levelYoffset%, %ININame%, Offset, levelYoffset
  IniWrite, %gemsXoffset%, %ININame%, Offset, gemsXoffset
  IniWrite, %gemsYoffset%, %ININame%, Offset, gemsYoffset
  IniWrite, %imagesXoffset%, %ININame%, Offset, imagesXoffset
  IniWrite, %imagesYoffset%, %ININame%, Offset, imagesoffset

  IniWrite, %treeSide%, %ININame%, Options, treeSide
  IniWrite, %treeName%, %ININame%, Options, treeName
  IniWrite, %opacity%, %ININame%, Options, opacity
  IniWrite, %startHidden%, %ININame%, Options, startHidden
  IniWrite, %displayTimeout%, %ININame%, Options, displayTimeout
  IniWrite, %persistText%, %ININame%, Options, persistText
  IniWrite, %hideGuide%, %ININame%, Options, hideGuide
  IniWrite, %hideNotes%, %ININame%, Options, hideNotes
  IniWrite, %expOrPen%, %ININame%, Options, expOrPen

  IniWrite, %backgroundColor%, %ININame%, Color, backgroundColor
  IniWrite, %redColor%, %ININame%, Color, redColor
  IniWrite, %greenColor%, %ININame%, Color, greenColor
  IniWrite, %blueColor%, %ININame%, Color, blueColor
  IniWrite, %yellowColor%, %ININame%, Color, yellowColor
  IniWrite, %whiteColor%, %ININame%, Color, whiteColor
  
  IniWrite, %KeySettings%, %ININame%, ToggleKey, KeySettings
  IniWrite, %KeyHideLayout%, %ININame%, ToggleKey, KeyHideLayout
  IniWrite, %KeyHideZones%, %ININame%, ToggleKey, KeyHideZones
  IniWrite, %KeyCycleZones%, %ININame%, ToggleKey, KeyCycleZones
  IniWrite, %KeyHideExp%, %ININame%, ToggleKey, KeyHideExp
  IniWrite, %KeyHideTree%, %ININame%, ToggleKey, KeyHideTree
  IniWrite, %KeyHideGems%, %ININame%, ToggleKey, KeyHideGems
  IniWrite, %KeyShowSyndicate%, %ININame%, ToggleKey, KeyShowSyndicate
  IniWrite, %KeyShowTemple%, %ININame%, ToggleKey, KeyShowTemple
  IniWrite, %KeyShowHeist%, %ININame%, ToggleKey, KeyShowHeist
  IniWrite, %KeyOnDeath%, %ININame%, ToggleKey, KeyOnDeath
}
