;not configurable yet
global maxImages := 6

;calculated
RegRead, localDPI, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
If (errorlevel) {
    localDPI := 96
}
global pixels := Ceil( points * (localDPI / 72) )

maxNotesWidth := maxNotesWidth < 30 ? 30 : maxNotesWidth
maxGuideWidth := maxGuideWidth < 22 ? 22 : maxGuideWidth
global notes_width := Ceil( (maxNotesWidth) * ((pixels+spacingWidth)/2) ) 
global guide_width := Ceil( (maxGuideWidth) * ((pixels+spacingWidth)/2) )
global nav_width := Ceil( (guide_width-5)/2 )
global gems_width := Ceil( 7 * (pixels/2) )
global level_width := Ceil( 7 * (pixels/2) )
global exp_width := Ceil( 20 * ((pixels+spacingWidth)/2) )
global links_width := Ceil( (maxLinksWidth) * ((pixels+spacingWidth)/2) )
global control_height := 2 * (points+2)
global exp_height := control_height


global xPosLayoutParent := Round( (A_ScreenWidth * guideXoffset) - (maxImages * 115) - guide_width - notes_width - 10 )
global yPosNotes := 5 + control_height + 5 + (A_ScreenHeight * guideYoffset)
global xPosNotes := xPosLayoutParent + (maxImages * 115)
global xPosGuide := xPosLayoutParent + (maxImages * 115) + notes_width + 5

global xPosLevel := Round( (A_ScreenWidth * levelXoffset) )
global yPosLevel := Round( (A_ScreenHeight * levelYoffset) )
global xPosExp := xPosLevel + level_width + 5
global yPosExp := yPosLevel

global xPosGems := Round( (A_ScreenWidth * gemsXoffset) )
global yPosGems := Round( (A_ScreenHeight * gemsYoffset) )
global xPosLinks := xPosGems
global yPosLinks := yPosGems + control_height + 5