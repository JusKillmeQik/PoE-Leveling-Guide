# Leveling Guide

![Cavern of Wrath](previews/LevelingGuidePreview1.png?raw=true "Leveling Guide in The Cavern of Wrath")

![Coast](previews/LevelingGuidePreview2.png?raw=true "Leveling Guide in The Coast Act 2")

![Ravaged Square](previews/LevelingGuidePreview3.png?raw=true "Leveling Guide in The Ravaged Square Part 2")

### Requirements

You will need AutoHotkey to run this script. Make sure to run it with PoE in windowed fullscreen or windowed mode.

### Description

As you go through the levels this script will check your Client.txt file to see the last place you entered. Only the zone name is logged so it will guess the correct act and zone based on the Part you are in. If you go backwards, you may have to manually update the Part which will cause it to recheck the location. If the UI is hidden because you are in the wrong Part, you can press Alt+F1 show it again.

Based on the zone you're in, notes and diagrams from this document will be shown in an overlay to make it so you don't have to leave Path of Exile while leveling: https://docs.google.com/document/d/1sExA-AnTbroJ-HN2neZiij5G4X9u2ENlC7m_zf1tqP8/edit

Be sure to familiarize yourself with the above document before using this tool.

Based on the act you're in, your own notes on gems, quests and socket colors can be shown in the notes section. Edit the data.json file to display whatever notes you need for leveling your character. Some placeholder notes are there for an example.

The config.json file can be used to change the transparency, width and location of the overlay. I do not recommend changing these settngs, but I have left notes on how to change them if you desire.

### Hotkeys

##### Display/Hide the zone layout overlay
Alt+F1 (May need to change default NVidia screenshot binding)

##### Display/Hide the notes overlay
Alt+F2

##### Increment/Decrement the act and zone dropdown menus
Shift+F1/F2 and Ctrl+F1/F2

Changing acts and zones happens automatically now but you can use the hotkeys to override it for a given map. If you find any bugs please feel free to log an issue on GitHub or send me a message on Reddit u/JusKillmeQik. All of this is based off of a post by u/Poland144 who borrowed code from many other people to make this happen. I completely re-wrote all of the functions and cleaned up the code to make it more readable and removed some unnecessary bloat. I also added in more of Engineering Eternity's notes to the overlay for beginners. The script automatically reads in up to 6 images, so feel free to delete or add images you want in the overlay. Just make sure they are 110 pixels wide by 60 pixels tall. It also took quite a bit to add the automation, but I think I got all of the bugs worked out. I'm hoping the community uses the source or uploads pull requests to make it even better.

*Cheers!*

Credits:  
rioreiser - original script framework  
Eruyome87 - updates to the library scripts  
Biggoron144 - contributions to the script  
_Treb/ Engineering Eternity - zone layout images  
