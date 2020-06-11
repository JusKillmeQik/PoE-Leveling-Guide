;not configurable yet
global maxImages := 6

global pixels := Ceil( points * (A_ScreenDPI / 72) )

maxNotesWidth := maxNotesWidth < 30 ? 30 : maxNotesWidth
maxGuideWidth := maxGuideWidth < 22 ? 22 : maxGuideWidth

global controlSpace := Ceil(5 * (A_ScreenDPI / 96))
global images_width := Ceil(110 * (A_ScreenDPI / 96))
global images_height := Ceil(60 * (A_ScreenDPI / 96))

global notes_width := Ceil( (maxNotesWidth) * ((pixels+spacingWidth)/2) )
global guide_width := Ceil( (maxGuideWidth) * ((pixels+spacingWidth)/2) )
global nav_width := Ceil( (guide_width-controlSpace)/2 )
global gems_width := Ceil( 4 * (pixels+spacingWidth/2) )
global level_width := Ceil( 4 * (pixels+spacingWidth/2) )
global exp_width := Ceil( 20 * ((pixels+spacingWidth)/2) )
global links_width := Ceil( (maxLinksWidth) * ((pixels+spacingWidth)/2) )
global control_height := 2 * (points+1) * (A_ScreenDPI / 96)
global exp_height := control_height + Ceil(2 * (A_ScreenDPI / 96))


global xPosLayoutParent := Round( (A_ScreenWidth * guideXoffset) - (maxImages * (images_width+controlSpace)) - guide_width - notes_width - (controlSpace*2) )
global yPosNotes := controlSpace + control_height + controlSpace + (A_ScreenHeight * guideYoffset)
global xPosNotes := xPosLayoutParent + (maxImages * (images_width+controlSpace))
global xPosGuide := xPosLayoutParent + (maxImages * (images_width+controlSpace)) + notes_width + controlSpace

global xPosLevel := Round( (A_ScreenWidth * levelXoffset) )
global yPosLevel := Round( (A_ScreenHeight * levelYoffset) )
global xPosExp := xPosLevel + level_width + controlSpace
global yPosExp := yPosLevel

global xPosGems := Round( (A_ScreenWidth * gemsXoffset) )
global yPosGems := Round( (A_ScreenHeight * gemsYoffset) )
global xPosLinks := xPosGems
global yPosLinks := yPosGems + control_height + controlSpace