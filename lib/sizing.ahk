;not configurable yet
global maxImages := 6

global pixels := Ceil( points * (A_ScreenDPI / 72) )

maxNotesWidth := maxNotesWidth < 30 ? 30 : maxNotesWidth
maxGuideWidth := maxGuideWidth < 22 ? 22 : maxGuideWidth

global controlSpace := Ceil(5 * (A_ScreenDPI / 96))
global images_width := Ceil(imageSizeMultiplier * 482 * (A_ScreenDPI / 96))
global images_height := Ceil(imageSizeMultiplier * 261 * (A_ScreenDPI / 96))

global textMargin := 5
global notes_width := maxNotesWidth
global guide_width := maxGuideWidth
global atlas_width := maxGuideWidth
global part_width := MeasureTextWidth("Part 2 WWW", "s" . points . "  w" . boldness, font)
global nav_width := MeasureTextWidth("0 Watchstones WWW", "s" . points . "  w" . boldness, font)
global act_width := MeasureTextWidth("39 Belly of the Beast Level 2 WW", "s" . points . "  w" . boldness, font)
;global nav_width := Ceil( (guide_width-controlSpace)/2 )
global gems_width := MeasureTextWidth("02 WWW", "s" . points . "  w" . boldness, font)
global level_width := MeasureTextWidth("100 WWW", "s" . points . "  w" . boldness, font)
global exp_width := MeasureTextWidth("Exp: 100.0%   Over: +10", "s" . points . "  w" . boldness, font)
global links_width := maxLinksWidth
global control_height := 2 * (points+1) * (A_ScreenDPI / 96)
;global exp_height := control_height + textMargin ;Ceil(2 * (A_ScreenDPI / 96))


;global xPosLayoutParent := Round( (A_ScreenWidth * guideXoffset) - (maxImages * (images_width+controlSpace)) - guide_width - notes_width - (controlSpace*2) )
global xPosImages := Round( (A_ScreenWidth * imagesXoffset) )
global yPosImages := controlSpace + control_height + controlSpace + (A_ScreenHeight * imagesYoffset)
global yPosNotes := controlSpace + control_height + controlSpace + (A_ScreenHeight * guideYoffset)
global xPosNotes := Round( (A_ScreenWidth * guideXoffset) ) ; this value should not be used
global xPosGuide := Round( (A_ScreenWidth * guideXoffset) - guide_width ) ; this value should not be used

global xPosLevel := Round( (A_ScreenWidth * levelXoffset) )
global yPosLevel := Round( (A_ScreenHeight * levelYoffset) )
global xPosExp := xPosLevel + level_width + controlSpace
global yPosExp := yPosLevel

global xPosGems := Round( (A_ScreenWidth * gemsXoffset) )
global yPosGems := Round( (A_ScreenHeight * gemsYoffset) )
global xPosLinks := xPosGems
global yPosLinks := yPosGems + control_height + controlSpace