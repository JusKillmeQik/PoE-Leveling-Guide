# AHK Leveling Guide

![Cavern of Wrath](previews/LevelingGuidePreview1.png?raw=true "Leveling Guide in The Cavern of Wrath")

![Coast](previews/LevelingGuidePreview2.png?raw=true "Leveling Guide in The Coast Act 2")

![Ravaged Square](previews/LevelingGuidePreview3.png?raw=true "Leveling Guide in The Ravaged Square Part 2")

![Passive Tree](previews/LevelingGuidePreview4.png?raw=true "Will now show PoESkillTree image")

![Gem Setup](previews/LevelingGuidePreview5.png?raw=true "Will now show desired links at given levels")

### Requirements

You will need AutoHotkey to run this script, with a minimum version of 1.1.32.00 https://www.autohotkey.com/

Make sure to run it with PoE in windowed fullscreen or windowed mode.

>NOTE: Some users will need to run this script with right-click 'Run as Administrator' in order for the automatic detection to work. Please try without this first.

### Description

As you go through the leveling zones this script will check your Client.txt file to see the last place you entered. Only the zone name is logged so it will guess the correct act and zone based on the Part you are in. If you go backwards, you may have to manually update the Part which will cause it to recheck the location.

Based on the zone you're in, notes and diagrams from this document will be shown in an overlay to make it so you don't have to leave Path of Exile while leveling: https://docs.google.com/document/d/1sExA-AnTbroJ-HN2neZiij5G4X9u2ENlC7m_zf1tqP8/edit

>NOTE: Some of these zones are outdated, there is a separate effort to update them, but if you get lost just explore.

Be sure to familiarize yourself with the above document before using this tool.

Based on the act you're in, your own notes on gems, quests and socket colors can be shown in the notes section. Each zone in the Overlays folder has a text file named after it, where you can edit the zone specific information you would like available. Each Act has a guide.txt file that you can also edit for information you would like available during the whole Act. Some placeholder notes are there for an example. You can add your own [Quest Rewards](https://pathofexile.gamepedia.com/Quest_Rewards) so you save time while leveling.

The text on any line in the guide or notes files can now be changed to some basic colors. Just start the line with one of the 2 character codes in the table below. I have added color to the first 3 Acts in the "Overlays" folder as an example. The "ShortNotes" folder is completely colorized. You can change which guide to use in the config.json file by setting the "overlayFolder" value. This can be very helpful for setting up your own guides as well so you can switch between gems and trees for different characters.

| 2 character code | color generated |
|:----------------:|:---------------:|
|   "< " or "R,"   |       Red       |
|   "+ " or "G,"   |      Green      |
|   "> " or "B,"   |       Blue      |
|  "W," or nothing |      White      |

The config.json file can be used to change the transparency, width and location of the overlay. I do not recommend changing these settings, but I have left notes at the bottom of the file on how to change them if you desire.

### Gem Setup

As you level it can be hard to remember which gems to choose for rewards and which to buy. The original intention was that the Act guide would be used for this information. However it still became difficult sometimes to remember what links to look for and where to socket the new gems. This league you can now add your desired gem setup in the gems.json file based on the levels you want to remember. The first entry must be level 2, but after that you can either set up every reward level or just the ones you make major changes at. The best part is you can color the text by putting an R/B/G/W in front of it. For myself I have included the gems I pickup in [brackets] with the name of the reward giver, and the gems I buy in (paranthesis) with the cost. This will auto update as you level, but does not show up automatically. It must be viewed/hidden with the hotkey (**Alt+G**). As always an example is included.

### Passive Tree

A full passive tree can now be shown when you are picking where to place your points. This requires some work, but I will outline the steps here.  
1) Download PoESkillTree: https://github.com/PoESkillTree/PoESkillTree/releases  
2) Make or Import your tree. Path of Building (and other tools) can export just the skill tree in the form "https://www.pathofexile.com/passive-skill-tree/v/#=="  
3) Go to Tools, Take Screenshot of Skilled Nodes...  
4) Export the image as *tree.jpg*  
5) Place the file in your "overlayFolder" (By default "Overlays")

Any image can go there, including a screen shot of poe.ninja's heatmap or any other picture you want to look at while building your tree. The steps above are simply what I used to get a clean looking tree. If you don't want a tree to show up, simply delete or rename that *tree.jpg* file.

### Experience Tracker

The guide now shows your level and percent experience gain in the current zone at the bottom left near the experience bar. This can be toggled off, but not moved at the moment. It picks up any level information logged to the client.txt right now so you may need to manually change it if you're leveling with friends of a much different level. You will also need to set it every time you restart the guide unless you want to wait until you level up again for it to pick up. It also shows how many levels over the OPTIMAL level you are for a given zone. So you may be getting 100% experience, but that experience is less than what you could get in a higher zone your character is ready for. Try to keep this number at 1 or 0 to improve your speed while leveling, but do not let it stay negative.

You can also set the "expOrPen" in the config.json file to show you penalty percentage instead of experience percentage if you would like.

### Hotkeys

>These can be changed directly in the script under the HOTKEYS section if you'd like different bindings.

##### Display/Hide the whole Leveling Guide overlay
**Alt+F1** (May need to change default NVidia screenshot bindings)

This guide auto hides after a few seconds (this can be increased or removed in config.json). Changing zones will show the guide again, or if you move your mouse to the top/right of the screen. Using **Alt+F1** while it is hidden will show it again, but if you use **Alt+F1** while it is shown it will stay off until manually called back.

##### Display/Hide the zone layout images
**Alt+F2**

>NOTE: Since they are outdated they may just get in the way for some people, they are hidden by default now

##### Display/Hide the experience overlay
**Alt+F3**

##### Display/Hide the Gem setup
**Alt+G**

##### Display/Hide the tree
**Alt+F**

##### Increment/Decrement the zone dropdown menu
**Shift+F1** and **Ctrl+F1**

Changing acts and zones happens automatically now but you can use the hotkeys to override it for a given map.

If you find any bugs please feel free to log an issue on GitHub or send me a message on Reddit u/JusKillmeQik. All of this is based off of a post by u/Poland144 who borrowed code from many other people to make this happen. I completely re-wrote all of the functions and cleaned up the code to make it more readable and removed some unnecessary bloat. I also added in more of Engineering Eternity's notes to the overlay for beginners. The script automatically reads in up to 6 images, so feel free to delete or add images you want in the overlay. Just make sure they are 110 pixels wide by 60 pixels tall. It also took quite a bit to add the automation, but I think I got all of the bugs worked out. I'm hoping the community uses the source or uploads pull requests to make it even better.

*Cheers!*

Credits:
Rebslack - provided ShortNotes as an alternative guide  
josemaia - pointed out minimum autohotkey level  
dsnvwlmnt - many logged issues and testing  
rioreiser - original script framework  
Eruyome87 - updates to the library scripts  
Biggoron144 - contributions to the script  
_Treb/ Engineering Eternity - zone layout images  
