# PoE Leveling Guide 4.0 [![](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=Y4PJCG5N4DMTN&source=url)


### Video Overview (click to open YouTube):

[![Click to Watch](previews/Overview_for_Path_of_Exile_Leveling_Guide_Overlay.gif)](https://youtu.be/4ttGGXBfxxQ "Click to Watch")

### Preview Images:

![Cavern of Wrath](previews/LevelingGuidePreview1.png?raw=true "Leveling Guide in The Cavern of Wrath")

![Coast](previews/LevelingGuidePreview2.png?raw=true "Leveling Guide in The Coast Act 6")

![Ravaged Square](previews/LevelingGuidePreview3.png?raw=true "Leveling Guide in The Ravaged Square Part 2")

![Passive Tree](previews/LevelingGuidePreview4.png?raw=true "Can show PoESkillTree images while allocating points")

![Settings Menu](previews/LevelingGuidePreview5.png?raw=true "Complete Settings menu for tweaking any variables or hotkeys")

![Build Creator](previews/LevelingGuidePreview6.png?raw=true "Visual guide for planning builds and gems")

### Requirements

>WARNING: This update is not compatible with previous versions, you will need to put this project in its own folder and import any custom changes you made in previous versions

You will need AutoHotkey to run this script, https://www.autohotkey.com/

Make sure to run it with PoE in windowed fullscreen or windowed mode. It is highly recommended to turn off text scaling for high resolution monitors.

>Display Settings -> Scale and layout -> Change the size of text, apps, and other items -> 100% (Recommended)

>NOTE: Some users will need to run this script with right-click 'Run as Administrator' in order for the automatic detection to work. Please try without this first.

### Description

As you go through the leveling zones this script will check your Client.txt file to see the last place you entered. Only the zone name is logged so it will guess the correct act and zone based on the Part you are in. If you go backwards, you may have to manually update the Part which will cause it to recheck the location.

Based on the zone you're in, notes and diagrams from this document will be shown in an overlay to make it so you don't have to leave Path of Exile while leveling: https://docs.google.com/document/d/1sExA-AnTbroJ-HN2neZiij5G4X9u2ENlC7m_zf1tqP8/edit

>NOTE: Some of these zones are outdated, there is a separate effort to update them, but if you get lost just explore.

Be sure to familiarize yourself with the above document before using this tool.

Based on the act you're in, your own notes on gems, quests and socket colors can be shown in the notes section. In the Build folder for each Act is a notes.txt file with all of the zones for that Act where you can edit the zone specific information you would like available. Each Act has a guide.txt file that you can also edit for information you would like available during the whole Act. Some placeholder notes are there for an example. You can add your own [Quest Rewards](https://pathofexile.gamepedia.com/Quest_Rewards) so you save time while leveling.

The text on any line in the guide or notes files can now be changed to different colors. Just start the line with one of the 2 character codes in the table below. I have added color to the Acts in the "Default" notes as an example. You can change which guide to use in the settings menu or config.ini file by setting the "overlayFolder" value. This can be very helpful for setting up your own guides as well so you can switch between gems and trees for different characters.

| 2 character code | color generated |
|:----------------:|:---------------:|
|   "< " or "R,"   |       Red       |
|   "+ " or "G,"   |      Green      |
|   "> " or "B,"   |       Blue      |
|   "- " or "Y,"   |      Yellow     |
|  "W," or nothing |      White      |

The config.ini file, which is generated on first run to avoid overwritten changes you make in future updates, can be used to change any of the many settings. You can also use the settings menu from the sytemt tray or by pressing F10 in PoE by default. I recommend using the defaults, but almost anything can be customized with this tool.

### Gem Setup

As you level it can be hard to remember which gems to choose for rewards and which to buy. The original intention was that the Act guide would be used for this information. However it still became difficult sometimes to remember what links to look for and where to socket the new gems. You can add your desired gem setup to the build using build editor, or by modifying the ini files in the gems folder of your build. The first entry must be level 2, but after that you can either set up every reward level or just the ones you make major changes at. The best part is you can color the text to make it easier to visualize the links you need. The npc that gives you the gem is listed in [brackets] or the npc that sells you the gem is listed with a price in (parentheses). This will auto update as you level, but does not show up automatically. It must be viewed/hidden with the hotkey (**Alt+G**). As always an example is included with the provided builds.

### Passive Tree

A full passive tree can now be shown when you are picking where to place your points. This requires some work, but I will outline the steps here.  
1) Download PoESkillTree: https://github.com/PoESkillTree/PoESkillTree/releases  
2) Make or Import your tree. Path of Building (and other tools) can export just the skill tree in the form "https://www.pathofexile.com/passive-skill-tree/v/#=="  
3) Go to Tools, Take Screenshot of Skilled Nodes...  
4) Export the image as *tree.jpg*  
5) Place the file in an Act folder of your Build
6) Repeat for each Act you want a different tree, if an Act has no tree it will use the last one

Any image can go there, including a screen shot of poe.ninja's heatmap or any other picture you want to look at while building your tree. The steps above are simply what I used to get a clean looking tree. If you don't want a tree to show up, simply delete or rename that *tree.jpg* file. The name of the file can be changed in the settigs if you want to use a png instead, but tree.jpg is the default from PoESkillTree so that's what this tool uses.

### Experience Tracker

The guide shows your level and percent experience gain in the current zone at the bottom right near the experience bar. This can be toggled off, or switched to experience penalty instead of gain. It picks up any level information logged to the client.txt right now so you need to add your character name to the build editor if you are playing with friends so you don't pick up their level information. You will also need to set the level every time you restart the guide unless you want to wait until you level up again for it to pick up. It also shows how many levels over the OPTIMAL level you are for a given zone. So you may be getting 100% experience, but that experience is less than what you could get in a higher zone your character is ready for. Try to keep this number at 1 or 0 to improve your speed while leveling, but do not let it stay negative.

### Hotkeys

>These can now all be changed in the settings menu if you'd like different bindings.

##### Display/Hide the whole Leveling Guide overlay
**Alt+F1** (May need to change default NVidia screenshot bindings)

This guide auto hides after a few seconds (this "Display Timeout" can be increased or removed in settings). Changing zones will show the guide again. Using **Alt+F1** while it is hidden will show it again, but if you use **Alt+F1** while it is shown it will stay off until manually called back.

##### Display/Hide the zone layout images
**Alt+F2**

>NOTE: Since they are outdated they may just get in the way for some people.

##### Display/Hide the experience overlay
**Alt+F3**

##### Display/Hide the Gem setup
**Alt+G**

##### Display/Hide the tree
**Alt+F**

##### Show Syndicate Betrayal Cheatsheet
**F5**

##### Show Alva Temple Cheatsheet
**F6**

##### Show Hiest Cheatsheet
**F7**

##### Manually toggle Zone
**Control+PgDown**

Any of the hotkeys can also be disabled by deleting their value in the settings menu.

### Discord

If you find any bugs please feel free to log an issue on GitHub or send me a message on Reddit u/JusKillmeQik.

We also now have a Discord channel where you can ask questions or share builds: https://discord.gg/fzHj3BT


This tool is based off of a lot of effort from the community. I did most of the coding, but all of the information came from others way smarter than me. I'm hoping the community uses the source or uploads pull requests to make it even better. If you'd like to donate to my efforts there is a link at the top of this page.

*Cheers!*

[![](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=Y4PJCG5N4DMTN&source=url)

Credits:  
VermiLLIon - Added multiple amazing build guides  
kylewill0725 - Added Heist Cheatsheet  
Brody and BrayFlex -  Added the first community Build Guides  
Rebslack - provided Abbreviated as alternative notes  
dsnvwlmnt - many logged issues and testing  
rioreiser - original script framework  
Eruyome87 - updates to the library scripts  
Biggoron144 - contributions to the script  
_Treb/ Engineering Eternity - zone layout images  
