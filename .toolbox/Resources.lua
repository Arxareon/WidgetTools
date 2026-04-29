--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

wt.name = C_AddOns.GetAddOnMetadata(..., "Title")


--[[ STRINGS ]]

wt.changelog = {
	{
		"#V_Version 3.0_# #H_(23/4/2026)_#",
		"#F_Hotfix (Version 3.0.1):_#",
		"Added safeguards in several places to prevent missing or invalid asset file paths (fonts or textures) to cause critical errors.",
		"#N_New:_#",
		"Added Midnight 12.0.5 support.",
		"The previously added right-click menus for settings have been further enhanced with copy & paste functionality to be able to easily move values across similar types of settings.",
		"Added a new advanced settings template for managing Font options (more Font customization options are coming in future updates).",
		"#C_Changes:_#",
		"The look of settings number sliders have been updated to match the new Blizzard sliders but keeping every enhanced functionality as usual for addons built with Widget Tools Toolboxes.",
		"The Toolbox loading structure has been overhauled, older versions are no longer supported.",
		"Many basic utility functions have been handed over to Widget Tools (and are no longer Toolbox-specific), accessible in code globally via the WidgetTools.utilities collection.",
		"Toolbox-specific data will no longer be injected into frame tables but housed in a Toolbox-specific tables (including tooltip or container content arrangement data).",
		"Updated the event handling backend system managing Blizzard global OnEvent (and custom event) handlers for Frames with new utilities accessible globally via the WidgetTools.utilities collection.",
		"Customizable Frames, Buttons and other widgets must now be created via new constructors, the customizable flags have been removed from their base counterparts.",
		"Most annotations that offer development-only benefits have been moved outside of installed addon files to greatly reduce install size.",
		"Separated the logic of data management settings page construction (now called profiles page) into a profilemanager widget and a GUI mutation on top to allow for further development flexibility and more customization.",
		"Several other under the hood changes & improvements.",
		"#F_Hotfixs:_#",
		"Numerous other smaller fixes.",
		"#H_Thank you all for the help, suggestions & bug reports!_# If you encounter any issues, do not hesitate to report them! Try including when & how they occur, and which other addons are you using (when relevant) to give me the best chance of being able to reproduce & fix them. Try proving any Lua script error messages and taint logs (if you know how).",
	}
}

--[ Localizations ]

--| Fill static & internal references

wt.strings.backup.box.tooltip[3] = wt.strings.backup.box.tooltip[3]:gsub("#LOAD", wt.strings.backup.load.label)
wt.strings.position.keepInPlace.tooltip = wt.strings.position.keepInPlace.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.position.offsetX.tooltip = wt.strings.position.offsetX.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.position.offsetY.tooltip = wt.strings.position.offsetY.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.position.relativePoint.tooltip = wt.strings.position.relativePoint.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.layer.keepOnTop.tooltip = wt.strings.layer.keepOnTop.tooltip:gsub("#STRATA", wt.strings.layer.strata.label)
wt.strings.layer.level.tooltip = wt.strings.layer.level.tooltip:gsub("#STRATA", wt.strings.layer.strata.label)
wt.strings.about.changelog.tooltip = wt.strings.about.changelog.tooltip .. "\n\nThe changelog is only available in English for now."
wt.strings.about.fullChangelog.tooltip = wt.strings.about.fullChangelog.tooltip .. "\n\nThe changelog is only available in English for now."