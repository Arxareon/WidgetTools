--[[ NAMESPACE ]]

---@class addonNamespace
local ns = select(2, ...)


--[[ DATA ]]

--WidgetTools main database table
WidgetToolsDB = ns.us.VerifyData(type(WidgetToolsDB) == "table" and WidgetToolsDB or {}, {
	lite = false,
	positioningAids = true,
	debugging = true,
	frameAttributes = {
		enabled = false,
		width = 620,
	},
})


--[[ EVENTS ]]

ns.eventFrame:RegisterEvent("PLAYER_LOGIN")
ns.eventFrame:HookScript("OnEvent", function(_, event)
	if event ~= "PLAYER_LOGIN" then return end

	ns.eventFrame:UnregisterEvent("PLAYER_LOGIN")

	ns.ds.Log("Widget Tools initialization started.", "Player login")


	--[[ REFERENCES ]]

	local chatCommands

	--| Data snapshots

	local loadedLite = WidgetToolsDB.lite
	local loadedPositioningAids = WidgetToolsDB.positioningAids
	local loadedDebugging = WidgetToolsDB.debugging


	--[[ SETTINGS ]]

	--| Main Page

	---@type settingsPage
	local mainPage = ns.wt.CreateAboutPage(ns.rs.name, {
		register = true,
		name = "About",
		changelog = ns.changelog
	})

	--| Specifications Page

	---@type checkbox
	local liteToggle

	---@type settingsPage
	local specificationsPage = ns.wt.CreateSettingsPage(ns.rs.name, {
		register = mainPage,
		name = "Specifications",
		title = ns.rs.strings.specifications.title,
		description = ns.rs.strings.specifications.description,
		dataManagement = {},
		arrangement = {},
		initialize = function(canvas, _, _, category, keys)
			ns.wt.CreatePanel({
				parent = canvas,
				name = "General",
				title = ns.rs.strings.specifications.general.title,
				description = ns.rs.strings.specifications.general.description,
				arrange = {},
				arrangement = {},
				initialize = function(panel)
					local silentSave = false

					local enableLitePopup = ns.wt.RegisterPopupDialog(ns.rs.name, "ENABLE_LITE_MODE", {
						text = ns.rs.strings.lite.enable.warning:gsub("#ADDON", ns.rs.title),
						accept = ns.rs.strings.lite.enable.accept,
						onAccept = function()
							liteToggle.setState(true)
							liteToggle.saveData(nil, silentSave)

							chatCommands.print(ns.rs.strings.chat.lite.response:gsub("#STATE", VIDEO_OPTIONS_ENABLED:lower()))
						end,
					})
					local disableLitePopup = ns.wt.RegisterPopupDialog(ns.rs.name, "DISABLE_LITE_MODE", {
						text = ns.rs.strings.lite.disable.warning:gsub("#ADDON", ns.rs.title),
						accept = ns.rs.strings.lite.disable.accept,
						onAccept = function()
							liteToggle.setState(false)
							liteToggle.saveData(nil, silentSave)

							chatCommands.print(ns.rs.strings.chat.lite.response:gsub("#STATE", VIDEO_OPTIONS_DISABLED:lower()))
						end,
					})

					liteToggle = ns.wt.CreateCheckbox({
						parent = panel,
						name = "LiteMode",
						title = ns.rs.strings.specifications.general.lite.label,
						tooltip = { lines = { { text = ns.rs.strings.specifications.general.lite.tooltip:gsub("#COMMAND", WrapTextInColorCode("/wt lite", "FFFFFFFF")), }, } },
						arrange = {},
						getData = function() return WidgetToolsDB.lite end,
						saveData = function(state) WidgetToolsDB.lite = state end,
						default = false,
						instantSave = false,
						listeners = {
							saved = { { handler = function()
								silentSave = false

								if loadedLite ~= WidgetToolsDB.lite then ns.wt.CreateReloadNotice() end end,
							}, },
							toggled = { { handler = function(_, state, user)
								if not user then return end

								if state then StaticPopup_Show(enableLitePopup) else StaticPopup_Show(disableLitePopup) end

								liteToggle.setState(not state, false) --Wait for popup response
							end }, },
						},
						events = { OnClick = function() silentSave = true end, },
						dataManagement = {
							category = category,
							key = keys[1],
						},
					})

					ns.wt.CreateCheckbox({
						parent = panel,
						name = "PositioningAids",
						title = ns.rs.strings.specifications.general.positioningAids.label,
						tooltip = { lines = { { text = ns.rs.strings.specifications.general.positioningAids.tooltip, }, } },
						arrange = {},
						getData = function() return WidgetToolsDB.positioningAids end,
						saveData = function(state) WidgetToolsDB.positioningAids = state end,
						listeners = { saved = { { handler = function() if loadedPositioningAids ~= WidgetToolsDB.positioningAids then ns.wt.CreateReloadNotice() end end, }, }, },
						instantSave = false,
						default = true,
						dataManagement = {
							category = category,
							key = keys[1],
						},
					})
				end,
			})

			ns.wt.CreatePanel({
				parent = canvas,
				name = "DevTools",
				title = ns.rs.strings.specifications.dev.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel)
					ns.wt.CreateCheckbox({
						parent = panel,
						name = "ToggleDebugging",
						title = ns.rs.strings.specifications.dev.debugging.enabled.label,
						tooltip = { lines = { { text = ns.rs.strings.specifications.dev.debugging.enabled.tooltip, }, } },
						arrange = {},
						getData = function() return WidgetToolsDB.debugging end,
						saveData = function(state) WidgetToolsDB.debugging = state end,
						listeners = { saved = { { handler = function() if loadedDebugging ~= WidgetToolsDB.debugging then ns.wt.CreateReloadNotice() end end, }, }, },
						instantSave = false,
						default = false,
						dataManagement = {
							category = category,
							key = keys[1],
						},
					})

					local toggle = ns.wt.CreateCheckbox({
						parent = panel,
						name = "ToggleWideFrameAttributes",
						title = ns.rs.strings.specifications.dev.frameAttributes.enabled.label,
						tooltip = { lines = { { text = ns.rs.strings.specifications.dev.frameAttributes.enabled.tooltip, }, } },
						arrange = {},
						getData = function() return WidgetToolsDB.frameAttributes.enabled end,
						saveData = function(state) WidgetToolsDB.frameAttributes.enabled = state end,
						default = false,
						dataManagement = {
							category = category,
							key = keys[1],
							onChange = { ToggleWideFrameAttributes = function()
								if WidgetToolsDB.frameAttributes.enabled then
									if _G["TableAttributeDisplay"] then
										TableAttributeDisplay:SetWidth(WidgetToolsDB.frameAttributes.width + 70)
										TableAttributeDisplay.LinesScrollFrame:SetWidth(WidgetToolsDB.frameAttributes.width)
									end

									ns.eventFrame:RegisterEvent("FRAMESTACK_VISIBILITY_UPDATED")
								else
									if _G["TableAttributeDisplay"] then
										TableAttributeDisplay:SetWidth(500)
										TableAttributeDisplay.LinesScrollFrame:SetWidth(430)
									end

									ns.eventFrame:UnregisterEvent("FRAMESTACK_VISIBILITY_UPDATED")
								end
							end, },
						},
					})

					ns.wt.CreateSlider({
						parent = panel,
						name = "FrameAttributesWidth",
						title = ns.rs.strings.specifications.dev.frameAttributes.width.label,
						tooltip = { lines = { { text = ns.rs.strings.specifications.dev.frameAttributes.width.tooltip, }, } },
						arrange = { newRow = false, },
						min = 200,
						max = 1400,
						step = 20,
						altStep = 1,
						dependencies = { { frame = toggle, } },
						getData = function() return WidgetToolsDB.frameAttributes.width end,
						saveData = function(value) WidgetToolsDB.frameAttributes.width = value end,
						default = 620,
						dataManagement = {
							category = category,
							key = keys[1],
							onChange = { ResizeWideFrameAttributes = function() if _G["TableAttributeDisplay"] then
								TableAttributeDisplay:SetWidth(WidgetToolsDB.frameAttributes.width + 70)
								TableAttributeDisplay.LinesScrollFrame:SetWidth(WidgetToolsDB.frameAttributes.width)
							end end, },
						},
					})
				end,
			})
		end,
	})

	--| Addons Page

	---@type settingsPage
	local addonsPage = ns.wt.CreateSettingsPage(ns.rs.name, {
		register = mainPage,
		name = "Addons",
		title = ns.rs.strings.addons.title,
		description = ns.rs.strings.addons.description:gsub("#ADDON", ns.rs.title),
		scroll = { speed = 0.2 },
		static = true,
		dataManagement = {},
		arrangement = {},
		initialize = function(canvas, _, _, category, keys)

			--[ List Toolbox Versions ]

			for version, entry in WidgetTools.utilities.SortedPairs(ns.protectedToolboxRegistry) do ns.wt.CreatePanel({
				parent = canvas,
				name = "Toolbox" .. version,
				title = ns.rs.strings.addons.toolbox:gsub("#VERSION", ns.rs.strings.about.version:gsub("#VERSION", WrapTextInColorCode(version, "FFFFFFFF"))),
				arrange = {},
				size = { h = 32 },
				arrangement = {
					margins = { l = 30, },
					gaps = 10,
				},
				initialize = function(toolboxPanel, width)

					--[ List Reliant Addons ]

					for i = 1, #entry.addons do if C_AddOns.IsAddOnLoaded(entry.addons[i]) then
						local data = {
							title = C_AddOns.GetAddOnMetadata(entry.addons[i], "Title"),
							version = C_AddOns.GetAddOnMetadata(entry.addons[i], "Version"),
							day = C_AddOns.GetAddOnMetadata(entry.addons[i], "X-Day"),
							month = C_AddOns.GetAddOnMetadata(entry.addons[i], "X-Month"),
							year = C_AddOns.GetAddOnMetadata(entry.addons[i], "X-Year"),
							category = C_AddOns.GetAddOnMetadata(entry.addons[i], "Category"),
							notes = C_AddOns.GetAddOnMetadata(entry.addons[i], "Notes"),
							author = C_AddOns.GetAddOnMetadata(entry.addons[i], "Author"),
							license = C_AddOns.GetAddOnMetadata(entry.addons[i], "X-License"),
							curse = C_AddOns.GetAddOnMetadata(entry.addons[i], "X-CurseForge"),
							wago = C_AddOns.GetAddOnMetadata(entry.addons[i], "X-Wago"),
							repo = C_AddOns.GetAddOnMetadata(entry.addons[i], "X-Repository"),
							issues = C_AddOns.GetAddOnMetadata(entry.addons[i], "X-Issues"),
							sponsors = C_AddOns.GetAddOnMetadata(entry.addons[i], "X-Sponsors"),
							topSponsors = C_AddOns.GetAddOnMetadata(entry.addons[i], "X-TopSponsors"),
							logo = C_AddOns.GetAddOnMetadata(entry.addons[i], "IconTexture"),
						}

						ns.wt.CreatePanel({
							parent = toolboxPanel,
							name = entry.addons[i],
							label = false,
							arrange = {},
							size = { w = width - 42, h = 84 },
							background = { color = { r = 0.1, g = 0.1, b = 0.1, a = 0.6 } },
							arrangement = {
								margins = { l = 34, },
								resize = false,
							},
							initialize = function(addonPanel)
								ns.wt.CreateTexture(addonPanel, {
									name = "Logo",
									position = {
										anchor = "TOP",
										relativeTo = addonPanel,
										relativePoint = "TOPLEFT",
										offset = { x = 3, y = -3 }
									},
									size = { w = 38, h = 38 },
									path = data.logo or ns.rs.textures.missing,
								})

								--| Toggle

								local function toggleAddon(state)
									if state then
										C_AddOns.EnableAddOn(entry.addons[i])
										addonPanel:SetAlpha(1)
									else
										C_AddOns.DisableAddOn(entry.addons[i])
										addonPanel:SetAlpha(0.5)
									end
								end

								local toggle = ns.wt.CreateCheckbox({
									parent = addonPanel,
									name = "Toggle",
									title = WrapTextInColor(C_AddOns.GetAddOnMetadata(entry.addons[i], "Title"), HIGHLIGHT_FONT_COLOR) .. " (" .. ns.rs.strings.about.toggle.label .. ")",
									tooltip = { lines = { { text = ns.rs.strings.about.toggle.tooltip, }, } },
									arrange = {},
									size = { w = 300, },
									font = { normal = "GameFontNormalMed1", },
									getData = function() return C_AddOns.GetAddOnEnableState(entry.addons[i]) > 0 end,
									saveData = function(state) toggleAddon(state) end,
									instantSave = false,
									listeners = { saved = { { handler = function(self) if not self.getState() then ns.wt.CreateReloadNotice() end end, }, }, },
									events = { OnClick = function(_, state) toggleAddon(state) end, },
									showDefault = false,
									utilityMenu = false,
									dataManagement = {
										category = category,
										key = keys[1],
									},
								})

								if toggle.frame then toggle.frame:SetIgnoreParentAlpha(true) end

								--| Description

								if data.notes then ns.wt.CreateText({
									parent = addonPanel,
									name = "Notes",
									position = { offset = { x = 16, y = -49 } },
									width = 318,
									height = 20,
									text = data.notes,
									font = "GameFontHighlightSmall",
									justify = { h = "LEFT", v = "TOP" },
								}) end

								--| Information

								local position = { offset = { x = 344, y = -13 } }

								if data.version then
									local version = ns.wt.CreateText({
										parent = addonPanel,
										name = "VersionTitle",
										position = position,
										width = 48,
										text = ns.wt.strings.about.version,
										font = "GameFontHighlightSmall",
										justify = { h = "RIGHT", },
									})

									ns.wt.CreateText({
										parent = addonPanel,
										name = "Version",
										position = {
											relativeTo = version,
											relativePoint = "TOPRIGHT",
											offset = { x = 5 }
										},
										width = 140,
										text = data.version .. (data.day and data.month and data.year and WrapTextInColorCode(" ( " .. ns.wt.strings.about.date .. ": " .. WrapTextInColor(ns.wt.strings.date:gsub(
											"#DAY", data.day
										):gsub(
											"#MONTH", data.month
										):gsub(
											"#YEAR", data.year
										), NORMAL_FONT_COLOR) .. ")", "FFFFFFFF") or ""),
										font = "GameFontNormalSmall",
										justify = { h = "LEFT", },
									})

									position.relativeTo = version
									position.relativePoint = "BOTTOMLEFT"
									position.offset.x = 0
									position.offset.y = -6
								end

								if data.category then
									local category = ns.wt.CreateText({
										parent = addonPanel,
										name = "Category",
										position = position,
										width = 48,
										text = CATEGORY,
										font = "GameFontHighlightSmall",
										justify = { h = "RIGHT", },
										wrap = false,
									})

									ns.wt.CreateText({
										parent = addonPanel,
										name = "Category",
										position = {
											relativeTo = category,
											relativePoint = "TOPRIGHT",
											offset = { x = 5 }
										},
										width = 140,
										text = data.category,
										font = "GameFontNormalSmall",
										justify = { h = "LEFT", },
									})

									position.relativeTo = category
									position.relativePoint = "BOTTOMLEFT"
									position.offset.x = 0
									position.offset.y = -6
								end

								if data.author then
									local author = ns.wt.CreateText({
										parent = addonPanel,
										name = "AuthorTitle",
										position = position,
										width = 48,
										text = ns.wt.strings.about.author,
										font = "GameFontHighlightSmall",
										justify = { h = "RIGHT", },
									})

									ns.wt.CreateText({
										parent = addonPanel,
										name = "Author",
										position = {
											relativeTo = author,
											relativePoint = "TOPRIGHT",
											offset = { x = 5 }
										},
										width = 140,
										text = data.author,
										font = "GameFontNormalSmall",
										justify = { h = "LEFT", },
									})

									position.relativeTo = author
									position.relativePoint = "BOTTOMLEFT"
									position.offset.x = 0
									position.offset.y = -6
								end

								if data.license then
									local license = ns.wt.CreateText({
										parent = addonPanel,
										name = "LicenseTitle",
										position = position,
										width = 48,
										text = ns.wt.strings.about.license,
										font = "GameFontHighlightSmall",
										justify = { h = "RIGHT", },
									})

									ns.wt.CreateText({
										parent = addonPanel,
										name = "License",
										position = {
											relativeTo = license,
											relativePoint = "TOPRIGHT",
											offset = { x = 5 }
										},
										width = 140,
										text = data.license,
										font = "GameFontNormalSmall",
										justify = { h = "LEFT", },
									})
								end
							end,
						})
					end end
				end,
			}) end
		end,
	})


	--[[ CHAT CONTROL ]]

	---@type chatCommandManager
	chatCommands = ns.wt.RegisterChatCommands(ns.rs.name, { ns.rs.chat.keyword }, {
		commands = {
			{
				command = ns.rs.chat.commands.about,
				description = ns.rs.strings.chat.about.description,
				handler = mainPage.open,
			},
			{
				command = ns.rs.chat.commands.lite,
				description = ns.rs.strings.chat.lite.description,
				handler = function() liteToggle.setState(not WidgetToolsDB.lite, true) end,
			},
		},
		colors = {
			title = ns.rs.colors.gold[1],
			content = ns.rs.colors.gold[2],
			command = { r = 1, g = 1, b = 1, },
			description = ns.rs.colors.grey[1]
		},
	})


	--[[ ADDON COMPARTMENT ]]

	ns.wt.SetUpAddonCompartment(ns.rs.name, {
		onClick = function() if WidgetToolsDB.lite then liteToggle.setState(false, true) else ns.wt.CreateContextMenu({
			initialize = function(menu)
				ns.wt.CreateMenuTextline(menu, { text = ns.rs.title, })
				ns.wt.CreateMenuButton(menu, {
					title = ns.wt.strings.about.title,
					action = mainPage.open
				})
				ns.wt.CreateMenuButton(menu, {
					title = ns.rs.strings.specifications.title,
					action = specificationsPage.open
				})
				ns.wt.CreateMenuButton(menu, {
					title = ns.rs.strings.addons.title,
					action = addonsPage.open
				})
			end,
			rightClickMenu = false,
		}).open() end end,
	}, { lines = {
		{ text = ns.rs.strings.about.version:gsub("#VERSION", WrapTextInColorCode(C_AddOns.GetAddOnMetadata(ns.rs.name, "Version") or "?", "FFFFFFFF")), },
		{ text = ns.rs.strings.about.date:gsub(
			"#DATE", WrapTextInColorCode(ns.wt.strings.date:gsub(
				"#DAY", C_AddOns.GetAddOnMetadata(ns.rs.name, "X-Day") or "?"
			):gsub(
				"#MONTH", C_AddOns.GetAddOnMetadata(ns.rs.name, "X-Month") or "?"
			):gsub(
				"#YEAR", C_AddOns.GetAddOnMetadata(ns.rs.name, "X-Year") or "?"
			), "FFFFFFFF")
		), },
		{ text = ns.rs.strings.about.author:gsub("#AUTHOR", WrapTextInColorCode(C_AddOns.GetAddOnMetadata(ns.rs.name, "Author") or "?", "FFFFFFFF")), },
		{ text = ns.rs.strings.about.license:gsub("#LICENSE", WrapTextInColorCode(C_AddOns.GetAddOnMetadata(ns.rs.name, "X-License") or "?", "FFFFFFFF")), },
		{ text = " ", },
		{
			text = (WidgetToolsDB.lite and ns.rs.strings.compartment.lite or ns.rs.strings.compartment.open),
			font = GameFontNormalSmall,
			color = ns.rs.colors.grey[1],
		},
	} })
end)

if WidgetToolsDB.frameAttributes.enabled then ns.eventFrame:RegisterEvent("FRAMESTACK_VISIBILITY_UPDATED") end
ns.eventFrame:HookScript("OnEvent", function(_, event)
	if event ~= "FRAMESTACK_VISIBILITY_UPDATED" then return end

	ns.eventFrame:UnregisterEvent("FRAMESTACK_VISIBILITY_UPDATED")

	if _G["TableAttributeDisplay"] then
		TableAttributeDisplay:SetWidth(WidgetToolsDB.frameAttributes.width + 70)
		TableAttributeDisplay.LinesScrollFrame:SetWidth(WidgetToolsDB.frameAttributes.width)
	end
end)


--[[ DEBUGGING ]]

if WidgetToolsDB.debugging then
	ns.logHistory = {} --ADD an option to save logs across sessions

	ns.ds.Log("Debug logging is enabled.", "Widget Tools initialization")
end