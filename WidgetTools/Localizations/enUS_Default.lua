--| Namespace

---@class addonNamespace
local ns = select(2, ...)

--[ Strings ]

if ns.rs.strings then return end

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---English
---@class widgetToolsStrings_enUS
ns.rs.strings = {
	about = {
		version = "Version: #VERSION",
		date = "Date: #DATE",
		author = "Author: #AUTHOR",
		license = "License: #LICENSE",
		toggle = {
			label = "Enabled",
			tooltip = "Uncheck to disable this addon.\n\nThis change will only take effect after the interface is reloaded. Once it has been disabled, this addon will not show up in this list until it's reenabled within the main AddOns menu.",
		},
	},
	specifications = {
		title = "Specifications",
		description = "Tune & toggle select optional features. Type /wt in chat to use chat commands.",
		general = {
			title = "General",
			description = "Options affecting all reliant addons.",
			lite = {
				label = "Lite Mode",
				tooltip = "Disable the settings of ALL addons using Widget Toolboxes to conserve resources and make the interface load faster.\nAddon settings data will still be saved & loaded in the background, and chat control will remain available for addons that use it.\n\nTo turn Lite Mode off and settings back on, use the #COMMAND chat command, or click on Widget Tools within the AddOns list under the calendar button in the header of the Minimap (not available in Classic)",
			},
			positioningAids = {
				label = "Positioning Visual Aids",
				tooltip = "Display visual aids when positioning frames wia settings widgets of addons which use Widget Toolboxes under the hood.",
			},
		},
		dev = {
			title = "Development Tools",
			debugging = {
				enabled = {
					label = "Debugging Mode",
					tooltip = "Toggle to create, save and print debugging log entries to the chat window.",
				},
			},
			frameAttributes = {
				enabled = {
					label = "Resize Frame Attributes",
					tooltip = "Customize the width of the table inside the Frame Attributes window (TableAttributeDisplay Frame).",
				},
				width = {
					label = "Frame Attributes Width",
					tooltip = "Specify the width of the scrollable content table in the Frame Attributes window.",
				},
			},
		},
	},
	toolboxes = {
		title = "Toolboxes & Addons",
		description = "The list of currently loaded addons using specific versions of registered #ADDON toolboxes.",
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Click to open specific settings.",
		lite = "Lite mode is enabled. Click to disable.",
	},
	lite = {
		enable = {
			warning = "When #ADDON is in Lite Mode, the settings UI for dependant addons will not be loaded.\n\nAre you sure you want to turn on Lite Mode and disable full settings functionality?",
			accept = "Enable Lite Mode",
		},
		disable = {
			warning = "#ADDON is in Lite Mode, the settings UI for dependant addons have not been loaded.\n\nDo you wish to turn off Lite Mode to reenable settings with full functionality?",
			accept = "Disable Lite Mode",
		},
	},
	chat = {
		about = {
			description = "Open the Widget Tools about page",
		},
		lite = {
			description = "Toggle Lite Mode: to load dependant addon settings or not",
			response = "Lite Mode will be #STATE after the interface is reloaded.",
			reminder = "Lite Mode is enabled, settings for dependant addons have not been loaded.\n#HINT",
			hint = "Type #COMMAND to disable Lite Mode.",
		},
		debug = {
			description = "Toggle Debugging Mode: save and display debug logs in chat",
			response = "Debugging will be #STATE after the interface is reloaded.",
			hint = "Type #COMMAND to disable Debugging Mode.",
		},
	},
	separator = ",", --Thousand separator character
	decimal = ".", --Decimal character
}