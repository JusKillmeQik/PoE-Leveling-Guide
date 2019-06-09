# AHK Leveling Guide

![Cavern of Wrath](previews/LevelingGuidePreview1.png?raw=true "Leveling Guide in The Cavern of Wrath")

![Coast](previews/LevelingGuidePreview2.png?raw=true "Leveling Guide in The Coast Act 2")

![Ravaged Square](previews/LevelingGuidePreview3.png?raw=true "Leveling Guide in The Ravaged Square Part 2")

![Passive Tree](previews/LevelingGuidePreview4.png?raw=true "Will now show PoESkillTree image")

### Requirements

You will need AutoHotkey to run this script. https://www.autohotkey.com/

Make sure to run it with PoE in windowed fullscreen or windowed mode.

>NOTE: Some users will need to run this script with right-click 'Run as Administrator' in order for the automatic detection to work. Please try without this first.

### Description

As you go through the levels this script will check your Client.txt file to see the last place you entered. Only the zone name is logged so it will guess the correct act and zone based on the Part you are in. If you go backwards, you may have to manually update the Part which will cause it to recheck the location. If the UI is hidden because you are in the wrong Part, you can press Alt+F1 show it again.

Based on the zone you're in, notes and diagrams from this document will be shown in an overlay to make it so you don't have to leave Path of Exile while leveling: https://docs.google.com/document/d/1sExA-AnTbroJ-HN2neZiij5G4X9u2ENlC7m_zf1tqP8/edit

>NOTE: Some of these zones are outdated, there is a separate effort to update them, but if you get lost just explore.

Be sure to familiarize yourself with the above document before using this tool.

Based on the act you're in, your own notes on gems, quests and socket colors can be shown in the notes section. Edit the data.json file to display whatever notes you need for leveling your character. Some placeholder notes are there for an example.

The config.json file can be used to change the transparency, width and location of the overlay. I do not recommend changing these settngs, but I have left notes on how to change them if you desire.

A full passive tree can now be shown when you are picking where to place your points. This requires some work, but I will outline the steps here.  
1) Download PoESkillTree: https://github.com/PoESkillTree/PoESkillTree/releases  
2) Make or Import your tree. Path of Building (and other tools) can export just the skill tree in the form "https://www.pathofexile.com/passive-skill-tree/v/#=="  
3) Go to Tools, Take Screenshot of Skilled Nodes...  
4) Export the image as *tree.jpg*  
5) Place the file in the "Overlays/Tree" folder  

Any image can go there, including a screen shot of poe.ninja's heatmap or any other picture you want to look at while building your tree. The steps above are simply what I used to get a clean looking tree. If you don't want a tree to show up, simply delete or rename that *tree.jpg* file.

### Hotkeys

>These can be changed directly in the script under the HOTKEYS section if you'd like different bindings.

##### Display/Hide the whole Leveling Guide overlay
Alt+F1 (May need to change default NVidia screenshot binding)

##### Display/Hide the zone layout overlay
Alt+F2

##### Display/Hide the notes overlay
Alt+F3

##### Display/Hide the tree
P (This will open your tree and show the image)
If you get stuck with the tree overlay showing when you are not looking at the tree, press Spacebar.

##### Increment/Decrement the zone dropdown menu
Shift+F1 and Ctrl+F1

Changing acts and zones happens automatically now but you can use the hotkeys to override it for a given map. If you find any bugs please feel free to log an issue on GitHub or send me a message on Reddit u/JusKillmeQik. All of this is based off of a post by u/Poland144 who borrowed code from many other people to make this happen. I completely re-wrote all of the functions and cleaned up the code to make it more readable and removed some unnecessary bloat. I also added in more of Engineering Eternity's notes to the overlay for beginners. The script automatically reads in up to 6 images, so feel free to delete or add images you want in the overlay. Just make sure they are 110 pixels wide by 60 pixels tall. It also took quite a bit to add the automation, but I think I got all of the bugs worked out. I'm hoping the community uses the source or uploads pull requests to make it even better.

*Cheers!*

Credits:  
rioreiser - original script framework  
Eruyome87 - updates to the library scripts  
Biggoron144 - contributions to the script  
_Treb/ Engineering Eternity - zone layout images  
