local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")] ---@type toolbox

if not wt then return end

local rs = WidgetTools.resources
local us = WidgetTools.utilities
local ds = WidgetTools.debugging

local cr = C_ColorUtil.WrapTextInColor
local crc = C_ColorUtil.WrapTextInColorCode

--[ Lite Mode ]

if WidgetToolsDB.lite then
	wt.CreatePanel = wt.CreateCustomContainer
	wt.CreateButton = wt.CreateAction
	wt.CreateCustomButton = wt.CreateAction
	wt.CreateCheckbox = wt.CreateBinary
	wt.CreateClassicCheckbox = wt.CreateBinary
	wt.CreateRadiobutton = wt.CreateBinary
	wt.CreateRadiogroup = wt.CreateSelector
	wt.CreateDropdownRadiogroup = wt.CreateSelector
	wt.CreateSpecialRadiogroup = wt.CreateSpecialSelector
	wt.CreateCheckgroup = wt.CreateMultiselector
	wt.CreateEditbox = wt.CreateTextual
	wt.CreateCustomEditbox = wt.CreateTextual
	wt.CreateMultilineEditbox = wt.CreateTextual
	wt.CreateCopybox = function() return {} end --FIX lite
	wt.CreateSlider = wt.CreateNumeric
	wt.CreateClassicSlider = wt.CreateNumeric
	wt.CreateColorpicker = wt.CreateColormanager

	return
end

--[[ WIDGET ]]

--[ Container ]

---Set the parameters of a GUI container widget frame
---@param container container|customContainer
---@param t container_options|customContainer_options
local function setUpContainer(container, t)
	local frame = container.frame

	--| Position & dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or t.parentFrame and t.parentFrame:GetWidth() - 20 or 0
	t.size.h = t.size.h or 0
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(frame, t.position) end
	wt.SetArrangementDirective(frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	if t.keepInBounds then frame:SetClampedToScreen(true) end

	frame:SetSize(t.size.w, t.size.h)

	--| Visibility

	wt.SetVisibility(frame, t.visible ~= false)

	if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else frame:HookScript(key, value) end
	end end

	--[ Initialization ]

	--Add content, performs tasks
	if type(t.initialize) == "function" then
		t.initialize(container, frame, t.size.w, t.size.h, t.name or "Panel")

		--Arrange content
		if t.arrangement then wt.ArrangeContent(frame, t.arrangement) end
	end
end

function wt.CreateContainer(t, widget)
	t = type(t) == "table" and t or {}

	local typename = "Container" ---@type typename_container
	local typenameBase = "Widget" ---@type typename_widget

	widget = wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t)
	local container = widget ---@cast container container

	container.addType(typename)

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local frame = CreateFrame("Frame", name, t.parentFrame)
	container.frame = frame

	--| Shared setup

	setUpContainer(container, t)

	return container
end

function wt.CreateCustomContainer(t, widget)
	t = type(t) == "table" and t or {}

	local typename = "CustomContainer" ---@type typename_customContainer
	local typenameBase = "Widget" ---@type typename_widget

	widget = wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t)
	local container = widget ---@cast container customContainer

	container.addType(typename)

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local frame = CreateFrame("Frame", name, t.parentFrame, BackdropTemplateMixin and "BackdropTemplate")
	container.frame = frame

	--| Shared setup

	setUpContainer(container, t)

	return container
end

--| Panel

function wt.CreatePanel(t, container)
	t = type(t) == "table" and t or {}

	local typename = "Panel" ---@type typename_panel
	local typenameBase = "CustomContainer" ---@type typename_customContainer

	container = wt.IsWidget(container, typenameBase) and container or wt.CreateCustomContainer(t)
	local panel = container ---@cast panel panel

	panel.addType(typename)

	--[ Frame ]

	--| Title & description

	panel.title = t.label ~= false and wt.CreateTitle(panel.frame, {
		offset = { x = 7, y = 27 },
		text = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Panel",
		font = "GameFontHighlightLarge",
	}) or nil

	if type(t.description) == "string" then panel.description = wt.CreateDescription(panel.title, {
		widthOffset = -22,
		text = t.description,
	}) end

	--| Backdrop

	wt.SetBackdrop(panel.frame, {
		background = us.Fill(t.background, {
			texture = {
				size = 5,
				insets = { l = 4, r = 4, t = 4, b = 4 },
			},
			color = { r = 0.175, g = 0.175, b = 0.175, a = 0.65 }
		}),
		border = us.Fill(t.border, {
			texture = { width = 16, },
			color = { r = 0.75, g = 0.75, b = 0.75, a = 0.5 }
		})
	})

	return panel
end

--[ Action ]

---Set the parameters of a GUI button widget frame
---@param button actionButton|customButton
---@param t actionButton_options|customButton_options
---@param name string
---@param title string
---@param useHighlight boolean
local function setUpButton(button, t, name, title, useHighlight)
	t.size = t.size or {}
	t.size.w = t.size.w or 80
	t.size.h = t.size.h or 22
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	local fontNormal, fontDisabled, fontHighlight = t.font.normal, t.font.disabled, t.font.highlight

	--| Position & dimensions

	if not t.arrange and t.position then wt.SetPosition(button.widget, t.position) end
	wt.SetArrangementDirective(button.widget, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	button.widget:SetSize(t.size.w, t.size.h)

	--| Visibility

	wt.SetVisibility(button.widget, t.visible ~= false)

	if t.frameStrata then button.widget:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then button.widget:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then button.widget:SetToplevel(t.keepOnTop) end

	--| Hover target

	button.frame = CreateFrame("Frame", name .. "HoverTarget", button.widget)
	button.frame:SetPoint("TOPLEFT")
	button.frame:SetSize(button.widget:GetSize())

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then button.widget:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else button.widget:HookScript(key, value) end
	end end

	--| UX

	button.widget:HookScript("OnClick", function(_, mouseButton)
		if mouseButton ~= "LeftButton" or not button.widget:IsEnabled() then return end

		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

		button.trigger(true)
	end)

	--Linked mouse interactions
	button.frame:HookScript("OnEnter", function() if button.widget:IsEnabled() then
		button.widget:LockHighlight()
		if IsMouseButtonDown("LeftButton") then button.widget:SetButtonState("PUSHED") end
		if button.label and useHighlight then button.label:SetFontObject(fontHighlight) end
	end end)
	button.frame:HookScript("OnLeave", function() if button.widget:IsEnabled() then
		button.widget:UnlockHighlight()
		button.widget:SetButtonState("NORMAL")
		if button.label and useHighlight then button.label:SetFontObject(fontNormal) end
	end end)
	button.frame:HookScript("OnMouseDown", function(_, b) if button.widget:IsEnabled() and b == "LeftButton" then
		button.widget:SetButtonState("PUSHED")
	end end)
	button.frame:HookScript("OnMouseUp", function(_, b, isInside) if button.widget:IsEnabled() then
		button.widget:SetButtonState("NORMAL")

		if isInside and b == "LeftButton" then button.widget:Click(b) end
	end end)

	--| Tooltip

	if type(t.tooltip) == "table" then wt.AddTooltip(button.frame, {
		title = t.tooltip.title or title,
		lines = t.tooltip.lines,
		anchor = "ANCHOR_TOPLEFT",
		offset = { x = 20, },
	}, { triggers = { button.frame, }, }) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ actionButton
	---@param state boolean
	local function updateState(_, state)
		button.widget:SetEnabled(state)

		if button.label then if state then
			if useHighlight and button.widget:IsMouseOver() then button.label:SetFontObject(fontHighlight) else button.label:SetFontObject(fontNormal) end
		else button.label:SetFontObject(fontDisabled) end end
	end

	--Set up starting state
	updateState(button, button.isEnabled())

	--Handle widget updates
	button.addListener.enabled(updateState, 1)
end

function wt.CreateButton(t, action)
	t = type(t) == "table" and t or {}

	local typename = "Button" ---@type typename_button
	local typenameBase = "Action" ---@type typename_action

	action = wt.IsWidget(action, typenameBase) and action or wt.CreateAction(t)
	local button = action ---@cast button actionButton

	local name = (t.append ~= false and t.parentFrame and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	button.widget = CreateFrame("Button", name, t.parentFrame, "UIPanelButtonTemplate")

	local customFonts = t.font ~= nil
	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontNormal"
	t.font.highlight = t.font.highlight or "GameFontHighlight"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	--| Label

	if t.label ~= false then
		if customFonts then
			button.label = wt.CreateText({
				parentFrame = button.widget,
				name = "Label",
				position = { anchor = "CENTER", },
				width = t.size.w,
				font = t.font.normal,
			})

			--Hide the built-in template label
			_G[name .. "Text"]:Hide()
		else button.label = _G[name .. "Text"] end

		if t.titleOffset then button.label:SetPoint("CENTER", t.titleOffset.x or 0, t.titleOffset.y or 0) end

		button.label:SetText(title)
	else _G[name .. "Text"]:Hide() end

	--| Shared setup

	setUpButton(button, t, name, title, t.font.highlight ~= nil)

	--[ Initialization ]

	button.addType(typename)

	return button
end

function wt.CreateCustomButton(t, action)
	t = type(t) == "table" and t or {}

	local typename = "CustomButton" ---@type typename_customButton
	local typenameBase = "Action" ---@type typename_action

	action = wt.IsWidget(action, typenameBase) and action or wt.CreateAction(t)
	local button = action ---@cast button customButton

	local name = (t.append ~= false and t.parentFrame and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	button.widget = CreateFrame("Button", name, t.parentFrame, BackdropTemplateMixin and "BackdropTemplate")

	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontNormal"
	t.font.highlight = t.font.highlight or "GameFontHighlight"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	--| Label

	if t.label ~= false then
		button.label = wt.CreateText({
			parentFrame = button.widget,
			name = "Label",
			position = { anchor = "CENTER", },
			width = t.size.w,
			font = t.font.normal,
		})

		if t.titleOffset then button.label:SetPoint("CENTER", t.titleOffset.x or 0, t.titleOffset.y or 0) end

		button.label:SetText(title)
	end

	--| Shared setup

	setUpButton(button, t, name, title, true)

	--| Backdrop

	if type(t.backdropUpdates) == "table" then for i = 1, #t.backdropUpdates do
		if type(t.backdropUpdates[i].triggers) ~= "table" then t.backdropUpdates[i].triggers = {} end
		table.insert(t.backdropUpdates[i].triggers, button.frame)
	end end

	wt.SetBackdrop(button.widget, t.backdrop, t.backdropUpdates)

	--[ Initialization ]

	button.addType(typename)

	return button
end


--[[ DATAMANAGER ]]

--[ Binary ]

function wt.CreateCheckbox(t, binary)
	t = type(t) == "table" and t or {}

	local typename = "Checkbox" ---@type typename_checkbox
	local typenameBase = "Binary" ---@type typename_binary

	binary = wt.IsWidget(binary, typenameBase) and binary or wt.CreateBinary(t)
	local checkbox = binary ---@cast checkbox checkbox

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	local holder = CreateFrame("Frame", name, t.parentFrame)
	local frame = CreateFrame("CheckButton", name .. typename, holder, "SettingsCheckboxTemplate")
	checkbox.holder = holder
	checkbox.frame = frame

	--| Position & dimensions

	t.size = t.size or {}
	t.size.h = t.size.h or frame:GetHeight()
	t.size.w = t.label == false and t.size.h * (30 / 29) or t.size.w or 190

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(holder, t.position) end
	wt.SetArrangementDirective(holder, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	frame:SetPoint("LEFT")
	wt.SetPosition(frame.HoverBackground, {
		anchor = "LEFT",
		offset = { x = -2, },
	})

	holder:SetSize(t.size.w, t.size.h)
	frame:SetSize(t.size.h * (30 / 29), t.size.h)
	frame.HoverBackground:SetSize(t.size.w + 2, t.size.h)

	--| Visibility

	wt.SetVisibility(holder, t.visible ~= false)

	if t.frameStrata then holder:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then holder:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then holder:SetToplevel(t.keepOnTop) end

	--| Label

	t.font = t.font or {}
	local fontNormal = t.font.normal or "GameFontNormal"
	local fontHighlight = t.font.highlight or "GameFontHighlight"
	local fontDisabled = t.font.disabled or "GameFontDisable"

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	checkbox.label = t.label ~= false and wt.CreateTitle(holder, {
		offset = { x = t.size.h * (30 / 29) + 6, },
		text = title,
		anchor = "LEFT",
		font = fontNormal,
	}) or nil

	--| Texture

	frame:GetPushedTexture():SetVertexColor(.6, .6, .6, 1)

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnClick" then frame:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
		else frame:HookScript(key, value) end
	end end

	--| UX

	---Update the widget UI based on the logical state
	---@param _ any
	---@param state boolean
	local function updateBinaryState(_, state) frame:SetChecked(state) end

	--Handle widget updates
	checkbox.addListener.changed(updateBinaryState, 1)

	frame:HookScript("OnClick", function(self)
		local state = self:GetChecked()

		PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

		checkbox.setValue(state, true)
	end)

	--Linked mouse interactions
	holder:HookScript("OnEnter", function() if checkbox.isEnabled() then
		frame.HoverBackground:Show()
		if IsMouseButtonDown("LeftButton") then frame:SetButtonState("PUSHED") end
	end end)
	holder:HookScript("OnLeave", function() if checkbox.isEnabled() then
		frame.HoverBackground:Hide()
		frame:SetButtonState("NORMAL")
	end end)
	holder:HookScript("OnMouseDown", function(_, button) if checkbox.isEnabled() and button == "LeftButton" or (button == "RightButton") then
		frame:SetButtonState("PUSHED")
	end end)
	holder:HookScript("OnMouseUp", function(_, button, isInside) if checkbox.isEnabled() then
		frame:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" then frame:Click(button) end
	end end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_NONE",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = frame,
				relativePoint = "TOPRIGHT",
			},
		}, { triggers = { holder, }, })

		wt.AddWidgetTooltipLines({ frame }, t.showDefault ~= false and checkbox.format(checkbox.getDefault()), t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = holder,
				condition = checkbox.isEnabled,
			},
			{
				frame = frame,
				condition = checkbox.isEnabled,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.binary = checkbox.getValue() end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() checkbox.setValue(wt.clipboard.binary, true) end
			}):SetEnabled(wt.clipboard.binary ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() checkbox.revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() checkbox.reset() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		frame:SetEnabled(state)
		frame:EnableMouse(state)

		if checkbox.label then checkbox.label:SetFontObject(state and fontNormal or fontDisabled) end
	end

	--Handle widget updates
	checkbox.addListener.enabled(updateState, 1)

	--[ Initialization ]

	checkbox.addType(typename)

	--Set starting logical state
	updateBinaryState(nil, checkbox.getValue())

	--Set up starting state
	updateState(nil, checkbox.isEnabled())

	return checkbox
end

---Set the parameters of a classic GUI binary widget frame
---@param binary checkbox|classicCheckbox|radiobutton
---@param holder Frame
---@param frame CheckButton|SettingsCheckbox
---@param title string
---@param t checkbox_options
local function setUpClassicToggle(binary, holder, frame, title, t)

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(holder, t.position) end
	wt.SetArrangementDirective(holder, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	frame:SetPoint("LEFT", (t.size.h - 16) / 2, 0)

	holder:SetSize(t.size.w, t.size.h)
	frame:SetSize(16, 16)

	--| Visibility

	wt.SetVisibility(holder, t.visible ~= false)

	if t.frameStrata then holder:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then holder:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then holder:SetToplevel(t.keepOnTop) end

	--Update the frame order
	holder:SetFrameLevel(holder:GetFrameLevel() + 1)
	frame:SetFrameLevel(frame:GetFrameLevel() - 2)

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnClick" then frame:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
		else frame:HookScript(key, value) end
	end end

	--| UX

	---Update the widget UI based on the logical state
	---@param _ any
	---@param state boolean
	local function updateBinaryState(_, state) frame:SetChecked(state) end

	--Handle widget updates
	binary.addListener.changed(updateBinaryState, 1)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(holder, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_NONE",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = frame,
				relativePoint = "TOPRIGHT",
			},
		}, { triggers = { frame, }, })

		wt.AddWidgetTooltipLines({ holder }, t.showDefault ~= false and binary.format(binary.getDefault()), t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = holder,
				condition = binary.isEnabled,
			},
			{
				frame = frame,
				condition = binary.isEnabled,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.binary = binary.getValue() end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() binary.setValue(wt.clipboard.binary, true) end
			}):SetEnabled(wt.clipboard.binary ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() binary.revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() binary.reset() end }) end
		end
	}) end

	--[ Initialization ]

	--Set starting logical state
	updateBinaryState(nil, binary.getValue())
end

function wt.CreateClassicCheckbox(t, binary)
	t = type(t) == "table" and t or {}

	local typename = "ClassicCheckbox" ---@type typename_classicCheckbox
	local typenameBase = "Binary" ---@type typename_binary

	binary = wt.IsWidget(binary, typenameBase) and binary or wt.CreateBinary(t)
	local checkbox = binary ---@cast checkbox classicCheckbox

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	local holder = CreateFrame("Frame", name, t.parentFrame)
	local frame = CreateFrame("CheckButton", name .. typename, holder, "InterfaceOptionsCheckButtonTemplate")
	checkbox.holder = holder
	checkbox.frame = frame

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	if t.label ~= false then
		checkbox.label = _G[name .. "CheckboxText"]

		checkbox.label:SetPoint("LEFT", frame, "RIGHT", 2, 0)
		checkbox.label:SetFontObject("GameFontHighlight")

		checkbox.label:SetText(title)
	else _G[name .. "CheckboxText"]:Hide() end

	--| Shared setup

	t.size = t.size or {}
	t.size.h = t.size.h or 26
	t.size.w = t.label == false and t.size.h or t.size.w or 180

	setUpClassicToggle(checkbox, holder, frame, title, t)

	--[ Events ]

	--| UX

	frame:HookScript("OnClick", function(self)
		local state = self:GetChecked()

		PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

		checkbox.setValue(state, true)
	end)

	--Linked mouse interactions
	holder:HookScript("OnEnter", function() if checkbox.isEnabled() then
		frame:LockHighlight()
		if IsMouseButtonDown("LeftButton") or (IsMouseButtonDown("RightButton")) then frame:SetButtonState("PUSHED") end
	end end)
	holder:HookScript("OnLeave", function() if checkbox.isEnabled() then
		frame:UnlockHighlight()
		frame:SetButtonState("NORMAL")
	end end)
	holder:HookScript("OnMouseDown", function(_, button) if checkbox.isEnabled() and button == "LeftButton" or (button == "RightButton") then
		frame:SetButtonState("PUSHED")
	end end)
	holder:HookScript("OnMouseUp", function(_, button, isInside) if checkbox.isEnabled() then
		frame:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" or (button == "RightButton") then frame:Click(button) end
	end end)

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		frame:SetEnabled(state)

		if checkbox.label then checkbox.label:SetFontObject(state and "GameFontHighlight" or "GameFontDisable") end
	end

	--Handle widget updates
	checkbox.addListener.enabled(updateState, 1)

	--[ Initialization ]

	checkbox.addType(typename)

	--Set up starting state
	updateState(nil, checkbox.isEnabled())

	return checkbox
end

function wt.CreateRadiobutton(t, binary)
	t = type(t) == "table" and t or {}

	local typename = "Radiobutton" ---@type typename_radiobutton
	local typenameBase = "Binary" ---@type typename_binary

	binary = wt.IsWidget(binary, typenameBase) and binary or wt.CreateBinary(t)
	local radiobutton = wt.IsWidget(binary, typenameBase) and binary or wt.CreateBinary(t) ---@cast radiobutton radiobutton

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	local holder = CreateFrame("Frame", name, t.parentFrame)
	local frame = CreateFrame("CheckButton", name .. typename, holder, "UIRadioButtonTemplate")
	radiobutton.holder = holder
	radiobutton.frame = frame

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	if t.label ~= false then
		radiobutton.label = _G[name .. "RadioButtonText"]

		radiobutton.label:SetPoint("LEFT", frame, "RIGHT", 3, 0)
		radiobutton.label:SetFontObject("GameFontNormal")

		radiobutton.label:SetText(title)
	else _G[name .. "RadioButtonText"]:Hide() end

	--| Shared setup

	t.size = t.size or {}
	t.size.h = t.size.h or 18
	t.size.w = t.label == false and t.size.h or t.size.w or 180

	setUpClassicToggle(radiobutton, holder, frame, title, t)

	--[ Events ]

	--| UX

	local clearable = t.clearable

	frame:HookScript("OnClick", function(_, button)
		if button == "LeftButton" then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

			radiobutton.setValue(true, true)
		elseif clearable and button == "RightButton" then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

			radiobutton.setValue(false, true)
		end
	end)

	--Linked mouse interactions
	holder:HookScript("OnEnter", function() if frame:IsEnabled() then
		frame:LockHighlight()
		if IsMouseButtonDown("LeftButton") or (clearable and IsMouseButtonDown("RightButton")) then frame:SetButtonState("PUSHED") end
	end end)
	holder:HookScript("OnLeave", function() if frame:IsEnabled() then
		frame:UnlockHighlight()
		frame:SetButtonState("NORMAL")
	end end)
	holder:HookScript("OnMouseDown", function(_, button) if frame:IsEnabled() and button == "LeftButton" or (clearable and button == "RightButton") then
		frame:SetButtonState("PUSHED")
	end end)
	holder:HookScript("OnMouseUp", function(_, button, isInside) if frame:IsEnabled() then
		frame:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" or (clearable and button == "RightButton") then frame:Click(button) end
	end end)

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		frame:SetEnabled(state)

		if radiobutton.label then radiobutton.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
	end

	--Handle widget updates
	radiobutton.addListener.enabled(updateState, 1)

	--[ Initialization ]

	radiobutton.addType(typename)

	--Set up starting state
	updateState(nil, radiobutton.isEnabled())

	return radiobutton
end

--[ Selector ]

---Item naming utility
---@param parentName string
---@param index integer
---@return string name
local function findName(parentName, index)
	local name = "Item" .. index

	while _G[parentName .. name] do name = name .. "_" .. index end

	return name
end

---Set the parameters of a GUI selector widget frame
---@param selector radiogroup|specialRadiogroup|checkgroup
---@param t radiogroup_options|checkgroup_options
---@param name string
---@param title string
local function setUpSelector(selector, t, name, title)
	local frame = CreateFrame("Frame", name, t.parentFrame)
	selector.frame = frame

	--| Position & dimensions

	t.columns = t.columns or 1
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(frame, t.position) end
	wt.SetArrangementDirective(frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	frame:SetWidth(t.width or max(t.label ~= false and 160 or 0, (t.labels ~= false and 160 or 16) * t.columns))
	frame:SetHeight(math.ceil((#t.items) / t.columns) * 16 + (t.label ~= false and 14 or 0))

	--| Visibility

	wt.SetVisibility(frame, t.visible ~= false)

	if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

	--| Label

	selector.label = t.label ~= false and wt.CreateTitle(frame, {
		offset = { x = 4, },
		text = title,
	}) or nil

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else frame:HookScript(key, value) end
	end end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state) if selector.label then selector.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end end

	--Handle widget updates
	selector.addListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, selector.isEnabled())
end

function wt.CreateRadiogroup(t, selector)
	t = type(t) == "table" and t or {}

	local typename = "Radiogroup" ---@type typename_radiogroup
	local typenameBase = "Selector" ---@type typename_selector
	local typenameBaseAlternate = "SpecialSelector" ---@type typename_specialSelector

	selector = (wt.IsWidget(selector, typenameBase) or wt.IsWidget(selector, typenameBaseAlternate)) and selector or wt.CreateSelector(t)
	local radiogroup = selector ---@cast radiogroup radiogroup|specialRadiogroup

	radiogroup.addType(typename)

	--| Shared setup

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	setUpSelector(radiogroup, t, name, title)

	--| Radio button items

	local nametag = t.name
	local columns = t.columns
	local labels = t.labels
	local items = t.items or {}
	local width = t.width
	local clearable = t.clearable

	---Set up or create new radio button item
	---@param item selectorBinary|selectorRadiobutton|checkbox|radiobutton|binary
	---@param active boolean
	local function setRadioButton(item, active)
		local index = item.index
		local itemData = items[index]
		local itemTooltip = itemData.tooltip

		if not active then wt.SetVisibility(item.holder, false) elseif wt.IsWidget(item, "Radiobutton") then
			--Update label
			if item.label then item.label:SetText(title) end

			--Update tooltip
			if type(itemTooltip) == "table" then wt.AddTooltip(item.holder, {
				title = type(title) == "string" and itemTooltip.title or type(title) == "string" and title or type(nametag) == "string" and nametag or "Toggle",
				lines = itemTooltip.lines,
				anchor = "ANCHOR_NONE",
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = item.holder,
					relativePoint = "TOPRIGHT",
				},
			}, { triggers = { item.holder, }, }) end

			wt.SetVisibility(item.holder, true)
		else
			local sameRow = (index - 1) % columns > 0

			wt.CreateRadiobutton({
				parentFrame = radiogroup.frame,
				name = findName(name, index),
				title = itemData.title,
				label = labels,
				tooltip = itemTooltip,
				position = {
					relativeTo = index ~= 1 and radiogroup.items[sameRow and index - 1 or index - columns].holder or radiogroup.label,
					relativePoint = index > 1 and (sameRow and "TOPRIGHT" or "BOTTOMLEFT") or (radiogroup.label and "BOTTOMLEFT" or nil),
					offset = { x = radiogroup.label and index == 1 and -4 or 0, y = radiogroup.label and index == 1 and -2 or 0}
				},
				size = { w = (width and columns == 1) and width or nil, },
				clearable = clearable,
				events = { OnClick = function(_, _, button)
					if button == "LeftButton" then radiogroup.setValue(index, true)
					elseif clearable and button == "RightButton" and not radiogroup.getValue() then radiogroup.setValue(nil, true) end
				end, },
				showDefault = false,
				utilityMenu = false,
			}, item)
		end
	end

	--Set up current items
	for i = 1, #radiogroup.items do
		setRadioButton(radiogroup.items[i], true)

		--Handle item updates
		radiogroup.items[i].addListener.activated(function(self, active) setRadioButton(self, active) end)
	end

	--Handle item list updates
	if radiogroup.addListener.updated and radiogroup.addListener.added then
		radiogroup.addListener.updated(function() radiogroup.frame:SetHeight(math.ceil((#radiogroup.items) / t.columns) * 18 + (t.label ~= false and 14 or 0)) end, 1)
		radiogroup.addListener.added(function (_, binary)
			setRadioButton(binary, true)

			--Handle item updates
			binary.addListener.activated(function(self, active) setRadioButton(self, active) end)
		end)
	end

	--[ Events ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(radiogroup.frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			local default = radiogroup.getDefault()
			defaultValue = crc(default and t.items[default].title or tostring(default), "FFFFFFFF")
		end

		local frames = { radiogroup.frame }
		for i = 1, #radiogroup.items do table.insert(frames, radiogroup.items[i].holder) end

		wt.AddWidgetTooltipLines(frames, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	local openTriggers = { {
		frame = radiogroup.frame,
		condition = radiogroup.isEnabled,
	}, }

	for i = 1, #radiogroup.items do table.insert(openTriggers, {
		frame = radiogroup.items[i].holder,
		condition = radiogroup.isEnabled,
	}) end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = openTriggers,
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.selection = { index = radiogroup.getValue() } end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() radiogroup.setValue(wt.clipboard.selection.index, true) end
			}):SetEnabled(wt.clipboard.selection ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() radiogroup.revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() radiogroup.reset() end }) end
		end
	}) end

	return radiogroup
end

function wt.CreateDropdownRadiogroup(t, selector)
	t = type(t) == "table" and t or {}

	local typename = "DropdownRadiogroup" ---@type typename_dropdownRadiogroup
	local typenameBase = "Selector" ---@type typename_selector

	t.width = t.width or 180
	t.scrollThreshold = t.scrollThreshold or 15
	local clearable = t.clearable

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	local dropdown = wt.CreateRadiogroup({
		name = name,
		append = false,
		label = false,
		width = t.width - (#t.items > t.scrollThreshold and 28 or 12),
		items = t.items,
		clearable = clearable,
		listeners = t.listeners,
		dependencies = t.dependencies,
		getData = t.getData,
		saveData = t.saveData,
		default = t.default,
		instantSave = t.instantSave,
		dataManagement = t.dataManagement,
		utilityMenu = false,
	}, wt.IsWidget(selector, typenameBase) and selector or wt.CreateSelector(t)) ---@cast dropdown dropdownRadiogroup

	dropdown.addType(typename)

	--[ Frame ]

	local holder = CreateFrame("Frame", name, t.parentFrame, BackdropTemplateMixin and "BackdropTemplate")
	dropdown.holder = holder

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(holder, t.position) end
	wt.SetArrangementDirective(holder, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	holder:SetSize(t.width + 4, 44)

	--| Visibility

	wt.SetVisibility(holder, t.visible ~= false)

	if t.frameStrata then holder:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then holder:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then holder:SetToplevel(t.keepOnTop) end

	--[ Dropdown Menu ]

	dropdown.menu = wt.CreatePanel({
		parentFrame = UIParent,
		name = dropdown.frame:GetName() .. "Menu",
		label = false,
		position = {
			anchor = "TOP",
			relativeTo = holder,
			relativePoint = "BOTTOM",
			offset = { y = 3 }
		},
		visible = false,
		frameStrata = "DIALOG",
		keepInBound = true,
		background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
		border =  { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } },
		size = { w = t.width, h = 12 + min(#t.items, t.scrollThreshold) * dropdown.items[1].holder:GetHeight() },
	})

	local menuFrame = dropdown.menu.frame

	menuFrame:SetClampedToScreen(true)

	dropdown.content = #t.items > t.scrollThreshold and wt.CreateScrollframe({
		parentFrame = menuFrame,
		position = { anchor = "CENTER", },
		size = { w = menuFrame:GetWidth() - 12, h = menuFrame:GetHeight() - 12 },
		scrollSize = { h = dropdown.frame:GetHeight() },
		scrollSpeed = 0.38,
	}) or menuFrame

	local content = dropdown.content

	dropdown.frame:SetParent(content)
	wt.SetPosition(dropdown.frame, {
		relativeTo = content,
		offset = #t.items <= t.scrollThreshold and { x = 6, y = -6 } or nil
	})

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	dropdown.label = t.label ~= false and wt.CreateTitle(holder, {
		anchor = "TOP",
		offset = { y = -1, },
		text = title,
		font = "GameFontNormal",
	}) or nil

	--| Toggle button

	local open = false

	dropdown.toggle = wt.CreateCustomButton({
		parentFrame = holder,
		name = "Toggle",
		append = t.append,
		title = "…",
		tooltip = { lines = {
			{ text = wt.strings.dropdown.selected, },
			{ text = "\n" .. wt.strings.dropdown.open, },
		} },
		position = { anchor = "BOTTOM", offset = { y = 2 }, },
		size = { w = t.width - (t.cycleButtons ~= false and 46 or 0), h = 24 },
		font = {
			normal = "GameFontNormal",
			highlight = "GameFontHighlight",
			disabled = "GameFontDisable",
		},
		backdrop = {
			background = {
				texture = {
					size = 5,
					insets = { l = 3, r = 3, t = 3, b = 3 },
				},
				color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
			},
			border = {
				texture = { width = 14, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
			}
		},
		backdropUpdates = {
			{ rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or (open and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					})
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					if open then return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.6, g = 0.6, b = 0.6, a = 0.9 } }
					} end
					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, _, button)
					if not frame:IsEnabled() or button == "LeftButton" then return {} end

					return (open and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					})
				end,
			}, },
			{
				triggers = { holder },
				rules = { OnAttributeChanged = function(frame, _, attribute, state)
					if not frame:IsEnabled() or attribute ~= "open" then return {} end

					if dropdown.toggle.widget:IsMouseOver() then return state and {
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} end
					return {}, true
				end, },
			},
		},
		events = clearable and t.utilityMenu == false and { OnMouseUp = function(_, button, isInside)
			if button == "RightButton" and isInside and dropdown.toggle.widget:IsEnabled() then dropdown.setText(nil, true) end
		end, } or nil,
		dependencies = t.dependencies
	})

	function dropdown.setText(text, silent)
		local index = dropdown.getValue()
		local item = t.items[index] or {}
		text = type(text) == "string" and text or item.title or "…"

		dropdown.toggle.label:SetText(text)
		wt.UpdateTooltipData(dropdown.toggle.frame, { title = text, })

		if not silent then dropdown.invoke.labeled(text) end
	end

	--Create event
	dropdown.addEvent("labeled")

	--Set starting selection
	dropdown.setText(t.text, true)

	--| Cycle buttons

	local previousDependencies, nextDependencies

	if t.cycleButtons ~= false then

		--| Create a custom fonts

		wt.CreateFont("ChatFontGold", {
			template = "ChatFontNormal",
			color = wt.PackColor(GameFontNormal:GetTextColor()),
		})

		wt.CreateFont("ChatFontDisable", {
			template = "ChatFontNormal",
			color = wt.PackColor(GameFontDisable:GetTextColor()),
		})

		--| Previous item

		previousDependencies = { { frame = dropdown, evaluate = function(value)
			if not value then return true end
			return value > 1
		end }, }

		dropdown.previous = wt.CreateCustomButton({
			parentFrame = holder,
			name = "SelectPrevious",
			title = "◄",
			titleOffset = { x = -1, },
			tooltip = {
				title = wt.strings.dropdown.previous.label,
				lines = { { text = wt.strings.dropdown.previous.tooltip, }, },
			},
			position = { anchor = "BOTTOMLEFT", offset = { x = 2, y = 2 }, },
			size = { w = 24, h = 24 },
			font = {
				normal = "ChatFontGold",
				highlight = "ChatFontNormal",
				disabled = "ChatFontDisable",
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function()
				local selected = dropdown.getValue()

				dropdown.setValue(selected and selected - 1 or #dropdown.items, true)
			end,
			dependencies = previousDependencies
		})

		--| Next item

		nextDependencies = { { frame = dropdown, evaluate = function(value)
			if not value then return true end
			return value < #t.items
		end }, }

		dropdown.next = wt.CreateCustomButton({
			parentFrame = holder,
			name = "SelectNext",
			title = "►",
			titleOffset = { x = 1, },
			tooltip = {
				title = wt.strings.dropdown.next.label,
				lines = { { text = wt.strings.dropdown.next.tooltip, }, }
			},
			position = { anchor = "BOTTOMRIGHT", offset = { x = -2, y = 2 }, },
			size = { w = 24, h = 24 },
			font = {
				normal = "ChatFontGold",
				highlight = "ChatFontNormal",
				disabled = "ChatFontDisable",
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function()
				local selected = dropdown.getValue()

				dropdown.setValue(selected and selected + 1 or 1, true)
			end,
			dependencies = nextDependencies
		})
	end

	--[ Getters & Setters ]

	function dropdown.toggleMenu(state)
		if state == nil then open = not menuFrame:IsVisible() else open = state end

		wt.SetVisibility(menuFrame, open)

		if open then menuFrame:RegisterEvent("GLOBAL_MOUSE_DOWN") else menuFrame:UnregisterEvent("GLOBAL_MOUSE_UP") end

		dropdown.invoke.open(open)
	end

	--Create event
	dropdown.addEvent("open")

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then holder:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else holder:HookScript(key, value) end
	end end

	--| UX

	us.SetListener(dropdown.menu, "GLOBAL_MOUSE_DOWN", function(f)
		if dropdown.toggle.widget:IsMouseOver() then return end

		f:UnregisterEvent("GLOBAL_MOUSE_DOWN")
		f:RegisterEvent("GLOBAL_MOUSE_UP")
	end)

	us.SetListener(dropdown.menu, "GLOBAL_MOUSE_UP", function(f, button)
		if (button ~= "LeftButton" and button ~= "RightButton") or f:IsMouseOver() then return end

		dropdown.toggleMenu(false)
	end, false)

	--Handle widget updates
	dropdown.toggle.addListener.triggered(function() dropdown.toggleMenu() end)
	dropdown.addListener.changed(function()
		dropdown.setText()

		if t.autoClose then dropdown.toggleMenu(false) end
	end, 1)
	dropdown.addListener.open(function(state)
		holder:SetAttribute("open", state)
		if not state then PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF) end
	end)
	dropdown.addListener.updated(function(self) self.menu.frame:SetHeight(#self.items * 18 + 12) end, 1) --TODO add size & scroll update

	--| Backdrop

	wt.SetBackdrop(holder, { background = {
		texture = { size = 5, },
		color = { r = 1, g = 1, b = 1, a = 0 }
	}, }, { {
		triggers = { holder, dropdown.toggle.frame, dropdown.previous.frame, dropdown.next.frame, },
		rules = {
			OnEnter = function() return dropdown.isEnabled() and { background = { color = { a = 0.1 } } } or {} end,
			OnLeave = "",
		},
	}, })

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(holder, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			local default = dropdown.getDefault()
			defaultValue = crc(default and t.items[default].title or tostring(default), "FFFFFFFF")
		end

		wt.AddWidgetTooltipLines({ holder, dropdown.toggle.widget, dropdown.previous.widget, dropdown.next.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = holder,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.toggle.frame,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.previous.frame,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.next.frame,
				condition = dropdown.isEnabled,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.selection = { index = dropdown.getValue() } end })
			if clearable then wt.CreateMenuButton(menu, { title = wt.strings.dropdown.clear, action = function() dropdown.setText(nil, true) end }) end
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() dropdown.setValue(wt.clipboard.selection.index, true) end
			}):SetEnabled(wt.clipboard.selection ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() dropdown.revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() dropdown.reset() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		if dropdown.label then dropdown.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

		dropdown.toggle.setEnabled(state)

		if t.cycleButtons ~= false then
			dropdown.previous.setEnabled(state and wt.CheckDependencies(previousDependencies))
			dropdown.next.setEnabled(state and wt.CheckDependencies(nextDependencies))
		end

		menuFrame:Hide()
	end

	dropdown.addListener.enabled(updateState, 1)

	--Set starting state
	updateState(nil, dropdown.isEnabled())

	return dropdown
end

function wt.CreateSpecialRadiogroup(itemset, t, selector)
	t = type(t) == "table" and t or {}

	local typename = "SpecialRadiogroup" ---@type typename_specialRadiogroup
	local typenameBase = "SpecialSelector" ---@type typename_specialSelector

	if wt.IsWidget(selector, typenameBase) then itemset = selector.getItemset() else selector = wt.CreateSpecialSelector(itemset, t) end

	local showDefault = t.showDefault ~= false
	local utilityMenu = t.utilityMenu ~= false

	t = us.Pull(t, {
		labels = false,
		columns = itemset == "strata" and 8 or 3,
		showDefault = false,
		utilityMenu = false,
	}) ---@cast t radiogroup_options

	---@type specialRadiogroup|radiogroup
	local specialRadiogroup = wt.CreateRadiogroup(t, selector) ---@cast specialRadiogroup -radiogroup

	specialRadiogroup.addType(typename)

	--| Tooltip

	if type(t.tooltip) == "table" then
		local defaultValue
		if showDefault then defaultValue = crc(specialRadiogroup.getDefault(), "FFFFFFFF") end

		local frames = { specialRadiogroup.frame }
		for i = 1, #specialRadiogroup.items do table.insert(frames, specialRadiogroup.items[i].holder) end

		wt.AddWidgetTooltipLines(frames, defaultValue, utilityMenu)
	end

	--| Utility menu

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	if utilityMenu then wt.CreateContextMenu({
		triggers = { {
			frame = specialRadiogroup.frame,
			condition = specialRadiogroup.isEnabled,
		}, },
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.copy,
				action = function() wt.clipboard[specialRadiogroup.getItemset()] = { value = specialRadiogroup.getValue() } end
			})
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() specialRadiogroup.setValue(wt.clipboard[specialRadiogroup.getItemset()].value, true) end
			}):SetEnabled(wt.clipboard[specialRadiogroup.getItemset()] ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() specialRadiogroup.revert() end })
			if showDefault then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() specialRadiogroup.reset() end }) end
		end
	}) end

	return specialRadiogroup
end

function wt.CreateCheckgroup(t, selector)
	t = type(t) == "table" and t or {}

	local typename = "Checkgroup" ---@type typename_checkgroup
	local typenameBase = "Multiselector" ---@type typename_multiselector

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	selector = wt.IsWidget(selector, typenameBase) and selector or wt.CreateMultiselector(t)
	local checkgroup = selector ---@cast checkgroup checkgroup

	checkgroup.addType(typename)

	--[ Frame ]

	--| Shared setup

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	setUpSelector(checkgroup, t, name, title)

	--| Checkbox items

	---Update the lock state of a checkbox item
	---@param item selectorCheckbox
	---@param limited boolean
	local function setLock(item, limited)
		if limited then
			item.setEnabled(false, true)
			item.frame:SetAlpha(0.4)
		elseif checkgroup.isEnabled() then
			item.setEnabled(true, true)
			item.frame:SetAlpha(1)
		end
	end

	---Set up or create new checkbox item
	---@param item selectorBinary|selectorCheckbox|checkbox|radiobutton|binary
	---@param active boolean
	local function setCheckbox(item, active)

		if not active then wt.SetVisibility(item.holder, false) elseif item.holder then
			--Update label
			if item.label then item.label:SetText(t.items[item.index].title) end

			--Update tooltip
			if type(t.items[item.index].tooltip) == "table" then wt.AddTooltip(item.holder, {
				title = type(t.items[item.index].tooltip.title) == "string" and t.items[item.index].tooltip.title or type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle",
				lines = t.items[item.index].tooltip.lines,
				anchor = "ANCHOR_NONE",
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = item.holder,
					relativePoint = "TOPRIGHT",
				},
			}, { triggers = { item.holder, }, }) end
		else
			local sameRow = (item.index - 1) % t.columns > 0

			wt.CreateClassicCheckbox({
				parentFrame = checkgroup.frame,
				name = findName(name, item.index),
				title = t.items[item.index].title,
				label = t.labels,
				tooltip = t.items[item.index].tooltip,
				position = {
					relativeTo = item.index ~= 1 and checkgroup.items[sameRow and item.index - 1 or item.index - t.columns].holder or checkgroup.label,
					relativePoint = sameRow and "TOPRIGHT" or "BOTTOMLEFT",
					offset = { x = checkgroup.label and item.index == 1 and -4 or 0, y = checkgroup.label and item.index == 1 and -2 or 0}
				},
				size = { w = (t.width and t.columns == 1) and t.width or 160, h = 16 },
				events = { OnClick = function(self) checkgroup.setSelected(item.index, self:GetChecked(), true) end, },
				showDefault = false,
				utilityMenu = false,
			}, item)

			if item.label then item.label:SetIgnoreParentAlpha(true) end

			--Handle limit updates
			checkgroup.addListener.limited(function(_, min, max)
				local state = item.getValue()

				setLock(item, (min and state) or (max and not state))
			end, item.index)
		end
	end

	--Set up starting items
	for i = 1, #checkgroup.items do
		setCheckbox(checkgroup.items[i], true)

		--Handle item updates
		checkgroup.items[i].addListener.activated(function(self, active) setCheckbox(self, active) end)
	end

	--Handle item list updates
	checkgroup.addListener.updated(function() checkgroup.frame:SetHeight(math.ceil((#checkgroup.items) / t.columns) * 16 + (t.label ~= false and 14 or 0)) end, 1)
	checkgroup.addListener.added(function (_, binary)
		setCheckbox(binary, true)

		--Handle item updates
		binary.addListener.activated(function(self, active) setCheckbox(self, active) end)
	end)

	--[ Events ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(checkgroup.frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			defaultValue = ""
			local default = checkgroup.getDefault()

			for i = 1, #t.items do
				defaultValue = defaultValue .. "\n" .. crc(t.items[i].title, "FFFFFFFF") .. crc(": ", "FF999999") .. crc(
					(default[i] and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), default[i] and "FFAAAAFF" or "FFFFAA66"
				)
			end
		end

		local frames = { checkgroup.frame }
		for i = 1, #checkgroup.items do table.insert(frames, checkgroup.items[i].holder) end

		wt.AddWidgetTooltipLines(frames, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	local openTriggers = { {
		frame = checkgroup.frame,
		condition = checkgroup.isEnabled,
	}, }

	for i = 1, #checkgroup.items do table.insert(openTriggers, {
		frame = checkgroup.items[i].frame,
		condition = checkgroup.isEnabled,
	}) end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = openTriggers,
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.selections = { states = checkgroup.getValue() } end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() checkgroup.setValue(wt.clipboard.selections.states, true) end
			}):SetEnabled(wt.clipboard.selections ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() checkgroup.revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() checkgroup.reset() end }) end
		end
	}) end

	return checkgroup
end

--[ Text ]

---Set the parameters of a GUI textual widget frame
---@param editbox textualEditbox|customEditbox|multilineEditbox
---@param t editbox_options
local function setUpEditbox(editbox, t)

	--[ Frame ]

	--| Visibility

	wt.SetVisibility(editbox.frame, t.visible ~= false)

	if t.frameStrata then editbox.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then editbox.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then editbox.frame:SetToplevel(t.keepOnTop) end

	--[ Font & Text ]

	t.font = t.font or {}
	t.insets = t.insets or {}
	t.insets = { l = t.insets.l or 0, r = t.insets.r or 0, t = t.insets.t or 0, b = t.insets.b or 0 }

	editbox.widget:SetTextInsets(t.insets.l, t.insets.r, t.insets.t, t.insets.b)

	if t.font.normal then editbox.widget:SetFontObject(t.font.normal) end

	if t.justify then
		if t.justify.h then editbox.widget:SetJustifyH(t.justify.h) end
		if t.justify.v then editbox.widget:SetJustifyV(t.justify.v) end
	end

	if t.charLimit then editbox.widget:SetMaxLetters(t.charLimit) end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then editbox.widget:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnChar" then editbox.widget:SetScript("OnChar", function(self, char) value(self, char, self:GetText()) end)
		elseif key == "OnTextChanged" then editbox.widget:SetScript("OnTextChanged", function(self, user) value(self, self:GetText(), user) end)
		elseif key == "OnEnterPressed" then editbox.widget:SetScript("OnEnterPressed", function(self) value(self, self:GetText()) end)
		else editbox.widget:HookScript(key, value) end
	end end

	--| UX

	local scriptEvent = false

	---Update the widget UI based on the text value
	---@param _ any
	---@param text string
	local function updateText(_, text) if not scriptEvent then
		editbox.widget:SetText(text)

		if t.resetCursor ~= false then editbox.widget:SetCursorPosition(0) end
	else scriptEvent = false end end

	--Handle widget updates
	editbox.addListener.changed(updateText, 1)

	--Link value changes
	editbox.widget:HookScript("OnTextChanged", function(self, user)
		scriptEvent = true

		editbox.setValue(self:GetText(), user)
	end)

	editbox.widget:SetAutoFocus(t.keepFocused)

	if t.focusOnShow then editbox.widget:HookScript("OnShow", function(self) self:SetFocus() end) end

	if t.unfocusOnEnter ~= false then editbox.widget:HookScript("OnEnterPressed", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

		self:ClearFocus()
	end) end

	editbox.widget:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)

	editbox.widget:HookScript("OnEnter", function(self) if editbox.isEnabled() and t.font.highlight then self:SetFontObject(t.font.highlight) end end)
	editbox.widget:HookScript("OnLeave", function(self) if editbox.isEnabled() and t.font.normal then self:SetFontObject(t.font.normal) end end)

	--| State

	--Inherit setter
	-- editbox.widget.setEnabled = editbox.setEnabled --CHECK if needed

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		if t.readOnly then editbox.widget:Disable() else editbox.widget:SetEnabled(state) end

		if state then
			if editbox.widget:IsMouseOver() and t.font.highlight then editbox.widget:SetFontObject(t.font.highlight)
			elseif t.font.normal then editbox.widget:SetFontObject(t.font.normal) end
		elseif t.font.disabled then editbox.widget:SetFontObject(t.font.disabled) end

		if editbox.label then editbox.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
	end

	--Handle widget updates
	editbox.addListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, editbox.isEnabled())

	--Set up starting text
	updateText(nil, editbox.getValue())
end

---Set the parameters of a single-line GUI textual widget frame
---@param editbox textualEditbox|customEditbox
---@param title string
---@param t editbox_options
local function setUpSinglelineEditbox(editbox, title, t)
	editbox.widget:SetMultiLine(false)

	--| Position

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(editbox.frame, t.position) end
	wt.SetArrangementDirective(editbox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	editbox.widget:SetPoint("BOTTOMRIGHT")

	--| Shared setup

	setUpEditbox(editbox, t)

	--[ Events ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(editbox.widget, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(editbox.getDefault(), "FF55DD55") end

		wt.AddWidgetTooltipLines({ editbox.frame, editbox.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = { {
			frame = editbox.widget,
			condition = function() return editbox.isEnabled() and not t.readOnly end,
		}, },
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.textual = editbox.getValue() end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() editbox.setValue(wt.clipboard.textual, true) end
			}):SetEnabled(wt.clipboard.textual ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() editbox.revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() editbox.reset() end }) end
		end
	}) end
end

function wt.CreateEditbox(t, textual)
	t = type(t) == "table" and t or {}

	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 18

	---@type typename_editbox
	local typename = "Editbox"

	---@type typename_textual
	local typenameBase = "Textual"

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	--[ Widget ]

	---@type textualEditbox|textual
	local editbox = wt.IsWidget(textual, typenameBase) and textual or wt.CreateTextual(t)

	--[ Frame ]

	editbox.frame = CreateFrame("Frame", name, t.parentFrame)
	editbox.widget = CreateFrame("EditBox", name .. "EditBox", editbox.frame, "InputBoxTemplate")

	--| Dimensions

	editbox.frame:SetSize(t.size.w, t.size.h + (t.label ~= false and 18 or 0))
	editbox.widget:SetSize(t.size.w - 6, t.size.h - 1)

	--| Label

	editbox.label = t.label ~= false and wt.CreateTitle(editbox.frame, {
		offset = { x = -1, },
		text = title,
	}) or nil

	--| Shared setup

	setUpSinglelineEditbox(editbox, title, t)

	--[ Initialization ]

	editbox.addType(typename)

	return editbox
end

function wt.CreateCustomEditbox(t, textual)
	t = type(t) == "table" and t or {}

	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 18

	---@type typename_customEditbox
	local typename = "CustomEditbox"

	---@type typename_textual
	local typenameBase = "Textual"

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	--[ Widget ]

	---@type customEditbox|textual
	local editbox = wt.IsWidget(textual, typenameBase) and textual or wt.CreateTextual(t)

	--[ Frame ]

	editbox.frame = CreateFrame("Frame", name, t.parentFrame)
	editbox.widget = CreateFrame("EditBox", name .. "EditBox", editbox.frame, BackdropTemplateMixin and "BackdropTemplate")

	--| Dimensions

	editbox.frame:SetSize(t.size.w, t.size.h - (t.label ~= false and -18 or 0))
	editbox.widget:SetSize(t.size.w, t.size.h)

	--| Label

	editbox.label = t.label ~= false and wt.CreateTitle(editbox.frame, {
		offset = { x = -1, },
		text = title,
	}) or nil

	--| Backdrop

	wt.SetBackdrop(editbox.widget, t.backdrop, t.backdropUpdates)

	--| Shared setup

	setUpSinglelineEditbox(editbox, title, t)

	--[ Events ]

	--| UX

	editbox.widget:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
	editbox.widget:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)

	--[ Initialization ]

	editbox.addType(typename)

	return editbox
end

function wt.CreateMultilineEditbox(t, textual)
	t = type(t) == "table" and t or {}

	t.scrollSpeed = t.scrollSpeed or 0.25

	---@type typename_multilineEditbox
	local typename = "MultilineEditbox"

	---@type typename_textual
	local typenameBase = "Textual"

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	--[ Widget ]

	---@type multilineEditbox|textual
	local editbox = wt.IsWidget(textual, typenameBase) and textual or wt.CreateTextual(t)

	--[ Frame ]

	editbox.frame = CreateFrame("Frame", name, t.parentFrame)
	editbox.scrollframe = CreateFrame("ScrollFrame", name .. "ScrollFrame", editbox.frame, ScrollControllerMixin and "InputScrollFrameTemplate")
	editbox.widget = editbox.scrollframe.EditBox

	--Set as multiline
	editbox.widget:SetMultiLine(true)

	--| Position & dimensions

	local scrollframeHeight = t.size.h - (t.label ~= false and 28 or 10)
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(editbox.frame, t.position) end
	wt.SetArrangementDirective(editbox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	editbox.scrollframe:SetPoint("BOTTOM", 0, 5)
	wt.SetPosition(editbox.scrollframe.ScrollBar, {
		anchor = "RIGHT",
		relativeTo = editbox.scrollframe,
		relativePoint = "RIGHT",
		offset = { x = -4, y = 0 }
	})

	editbox.frame:SetSize(t.size.w, t.size.h)
	editbox.scrollframe:SetSize(t.size.w - 10, scrollframeHeight)
	editbox.scrollframe.ScrollBar:SetHeight(scrollframeHeight - 4)
	editbox.scrollframe.EditBox:SetWidth(editbox.scrollframe:GetWidth())

	--| Label

	editbox.label = t.label ~= false and wt.CreateTitle(editbox.frame, {
		offset = { x = 3, },
		text = title,
	}) or nil

	--| Scroll speed

	editbox.scrollframe.ScrollBar.SetPanExtentPercentage = function() --WATCH: Change when Blizzard provides a better way to overriding the built-in update function
		local height = editbox.scrollframe:GetHeight()

		editbox.scrollframe.ScrollBar.panExtentPercentage = height * t.scrollSpeed / math.abs(editbox.widget:GetHeight() - height)
	end

	--| Character counter

	editbox.scrollframe.CharCount:SetFontObject("GameFontDisableTiny2")
	if t.charCount == false or (t.charLimit or 0) == 0 then editbox.scrollframe.CharCount:Hide() end

	---@diagnostic disable-next-line: inject-field
	editbox.widget.cursorOffset = 0 --WATCH: Remove when the character counter gets fixed..

	--| Shared setup

	setUpEditbox(editbox, t)

	--[ Events ]

	--| UX

	editbox.widget:HookScript("OnTextChanged", function(_, _, user) if not user and t.scrollToTop then editbox.scrollframe:SetVerticalScroll(0) end end)
	editbox.widget:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
	editbox.widget:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)

	---Update the width of the editbox
	---@param scrolling boolean
	local function resizeEditbox(scrolling)
		local scrollBarOffset = scrolling and (wt.classic and 32 or 16) or 0
		local charCountWidth = t.charCount ~= false and (t.charLimit or 0) > 0 and tostring(t.charLimit - editbox.getValue():len()):len() * 6 + 3 or 0

		editbox.widget:SetWidth(editbox.scrollframe:GetWidth() - scrollBarOffset - charCountWidth)

		--Update the character counter
		if editbox.scrollframe.CharCount:IsVisible() and t.charLimit then --WATCH: Remove when the character counter gets fixed..
			editbox.scrollframe.CharCount:SetWidth(charCountWidth)
			editbox.scrollframe.CharCount:SetText(tostring(t.charLimit - editbox.getValue():len()))
			editbox.scrollframe.CharCount:SetPoint("BOTTOMRIGHT", editbox.scrollframe, "BOTTOMRIGHT", -scrollBarOffset + 1, 0)
		end
	end

	--Resize updates
	editbox.scrollframe.ScrollBar:HookScript("OnShow", function() resizeEditbox(true) end)
	editbox.scrollframe.ScrollBar:HookScript("OnHide", function() resizeEditbox(false) end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(editbox.scrollframe, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { editbox.frame, editbox.widget }, })

		if t.readOnly ~= true then
			local defaultValue
			if t.showDefault ~= false then defaultValue = crc(editbox.getDefault(), "FF55DD55") end

			wt.AddWidgetTooltipLines({ editbox.scrollframe, editbox.widget }, defaultValue, t.utilityMenu)
		end
	end

	--| Utility menu

	---Utility menu opening condition checker
	---@return boolean
	local function openCondition() return editbox.isEnabled() and not t.readOnly end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = editbox.frame,
				condition = openCondition,
			},
			{
				frame = editbox.widget,
				condition = openCondition,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.textual = editbox.getValue() end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() editbox.setValue(wt.clipboard.textual, true) end
			}):SetEnabled(wt.clipboard.textual ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() editbox.revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() editbox.reset() end }) end
		end
	}) end

	--[ Initialization ]

	editbox.addType(typename)

	return editbox
end

--| Copybox

function wt.CreateCopybox(t) --FIX lite
	t = type(t) == "table" and t or {}

	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 18

	t.font = t.font or "GameFontNormalSmall"
	t.color = t.color or { r = 0.6, g = 0.8, b = 1, a = 1 }
	t.colorOnMouse = t.colorOnMouse or { r = 0.8, g = 0.95, b = 1, a = 1 }

	---@type typename_copybox
	local typename = "Copybox"

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	local text = type(t.value) == "string" and t.value or ""

	--[ Widget ]

	---@type copybox
	local copybox = {}

	--[ Frame ]

	copybox.frame = CreateFrame("Frame", name, t.parentFrame)

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(copybox.frame, t.position) end
	wt.SetArrangementDirective(copybox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	copybox.frame:SetSize(t.size.w, t.size.h + (t.label ~= false and 12 or 0))

	--| Visibility

	wt.SetVisibility(copybox.frame, t.visible ~= false)

	if t.frameStrata then copybox.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then copybox.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then copybox.frame:SetToplevel(t.keepOnTop) end

	--| Label

	copybox.label = t.label ~= false and wt.CreateTitle(copybox.frame, {
		offset = { x = -1, },
		width = t.size.w,
		text = title,
		font = "GameFontNormal",
	}) or nil

	--| Textbox

	copybox.textual = wt.CreateCustomEditbox({
		parentFrame = copybox.frame,
		name = "Textline",
		title = title,
		label = false,
		tooltip = { lines = { { text = wt.strings.copyBox, }, } },
		position = { anchor = "BOTTOMLEFT", },
		size = t.size,
		font = { normal = t.font, disabled = t.font },
		color = t.color,
		justify = { h = t.justify, },
		events = {
			OnTextChanged = function(self, _, user)
				if not user then return end

				self:SetText(cr(text, t.colorOnMouse))
				self:SetCursorPosition(0)
				self:HighlightText()
			end,
			OnEnter = function(self)
				self:SetText(cr(text, t.colorOnMouse))
				self:SetCursorPosition(0)
				self:HighlightText()
				self:SetFocus()
			end,
			OnLeave = function(self)
				self:SetText(cr(text, t.color))
				self:SetCursorPosition(0)
				self:ClearHighlightText()
				self:ClearFocus()
			end,
			OnMouseUp = function(self)
				self:SetCursorPosition(0)
				self:HighlightText()
			end,
		},
		value = text,
		showDefault = false,
		utilityMenu = false,
	})

	return copybox
end

--| Popup Inputbox

local customPopupInputBoxFrame

function wt.CreatePopupInputbox(t) --FIX lite
	t = type(t) == "table" and t or {}

	t.position = type(t.position) == "table" and t.position or {
		anchor = "TOP",
		offset = { y = -320 }
	}

	t.text = type(t.text) == "string" and t.text or ""
	t.title = type(t.title) == "string" and t.title or nil

	--[ Frame ]

	customPopupInputBoxFrame = customPopupInputBoxFrame or { accept = t.accept, cancel = t.cancel }

	if customPopupInputBoxFrame.panel then
		wt.SetPosition(customPopupInputBoxFrame.panel.frame, t.position)

		--Update the textual data manager
		customPopupInputBoxFrame.textual.setValue(t.text)
		if t.title then
			if customPopupInputBoxFrame.textual.label then customPopupInputBoxFrame.textual.label:SetText(t.title) else
				customPopupInputBoxFrame.textual.label = wt.CreateTitle(customPopupInputBoxFrame.textual.frame, {
					offset = { x = -1, },
					text = t.title,
				})
			end
		end

		--Update the arrangement
		if (t.title ~= nil) ~= (customPopupInputBoxFrame.textual.label ~= nil) then wt.ArrangeContent(customPopupInputBoxFrame.panel.frame) end

		customPopupInputBoxFrame.panel.frame:Show()

		return
	end

	--| Utilities

	local function accept()
		if type(customPopupInputBoxFrame.accept) == "function" then customPopupInputBoxFrame.accept(customPopupInputBoxFrame.textual.getValue()) end

		customPopupInputBoxFrame.panel.frame:Hide()
	end

	local function cancel()
		if type(customPopupInputBoxFrame.cancel) == "function" then customPopupInputBoxFrame.cancel() end

		customPopupInputBoxFrame.panel.frame:Hide()
	end

	--| Main panel

	customPopupInputBoxFrame.panel = wt.CreatePanel({
		parentFrame = UIParent,
		name = "WidgetToolsPopupInputBox",
		label = false,
		position = t.position,
		keepInBounds = true,
		size = { w = 240, h = 90 },
		visible = false,
		frameStrata = "DIALOG",
		keepOnTop = true,
		background = { color = { a = 0.9 }, },
		arrangement = {},
		initialize = function(_, panel)

			--[ Textbox ]

			---@type customEditbox|textual
			customPopupInputBoxFrame.textual = wt.CreateEditbox({
				parentFrame = panel,
				name = "TextInputBox",
				title = t.title,
				label = t.title ~= nil,
				tooltip = { title = wt.strings.popupInput.title, lines = { { text = wt.strings.popupInput.tooltip }, } },
				size = { w = panel:GetWidth() - 24, },
				focusOnShow = true,
				events = {
					OnEnterPressed = accept,
					OnEscapePressed = cancel,
				},
				arrange = {},
				value = t.text,
				showDefault = false,
				utilityMenu = false,
			})

			--[ Buttons ]

			wt.CreateButton({
				parentFrame = panel,
				name = "AcceptButton",
				title = ACCEPT ,
				arrange = {},
				size = { w = 110, },
				action = accept,
			})

			wt.CreateButton({
				parentFrame = panel,
				name = "CancelButton",
				title = CANCEL,
				position = {
					anchor = "BOTTOMRIGHT",
					offset = { x = -12, y = 12 }
				},
				size = { w = 90, },
				action = cancel,
			})
		end,
	})

	--| Position & dimensions

	wt.SetMovability(customPopupInputBoxFrame.panel.frame, true)

	--| Visibility

	customPopupInputBoxFrame.panel.frame:Show()
end

--[ Numeric ]

function wt.CreateSlider(t, numeric)
	t = type(t) == "table" and t or {}

	t.width = t.width or 180

	---@type typename_slider
	local typename = "Slider"

	---@type typename_numeric
	local typenameBase = "Numeric"

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	local minValue, maxValue = numeric.getMin(), numeric.getMax()

	--[ Widget ]

	---@type numericSlider|numeric
	local slider = wt.IsWidget(numeric, typenameBase) and numeric or wt.CreateNumeric(t)

	--[ Frame ]

	slider.frame = CreateFrame("Frame", name, t.parentFrame, BackdropTemplateMixin and "BackdropTemplate")
	slider.widget = CreateFrame("Slider", name .. "Frame", slider.frame, "MinimalSliderWithSteppersTemplate")

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(slider.frame, t.position) end
	wt.SetArrangementDirective(slider.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	slider.widget:SetPoint("TOP", 0, -8)

	slider.frame:SetSize(t.width, t.valuebox ~= false and 64 or 52)
	slider.widget:SetWidth(t.width)

	--| Visibility

	wt.SetVisibility(slider.frame, t.visible ~= false)

	if t.frameStrata then slider.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then slider.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then slider.frame:SetToplevel(t.keepOnTop) end

	--| Label

	if t.label ~= false then
		slider.widget.TopText:SetPoint("TOP", slider.frame, "TOP", 0, 4)
		slider.widget.TopText:SetText(title)
		slider.widget.TopText:Show()
	end

	slider.widget.MinText:Show()
	slider.widget.MaxText:Show()

	--| Value step

	if t.hardStep ~= false then
		slider.widget.Slider:SetValueStep(slider.getStep())
		slider.widget.Slider:SetObeyStepOnDrag(true)
	end

	--| Decrease button

	wt.AddTooltip(slider.widget.Back, {
		title = wt.strings.slider.decrease.label,
		lines = {
			{ text = wt.strings.slider.decrease.tooltip[1]:gsub("#VALUE", slider.getStep()), },
			slider.getAltStep() and { text = wt.strings.slider.decrease.tooltip[2]:gsub("#VALUE", slider.getAltStep()), } or nil,
		},
		anchor = "ANCHOR_TOPLEFT",
	})

	slider.widget.Back:HookScript("OnClick", function() slider.decrease(IsAltKeyDown(), true) end)

	--| Increase button

	wt.AddTooltip(slider.widget.Forward, {
		title = wt.strings.slider.increase.label,
		lines = {
			{ text = wt.strings.slider.increase.tooltip[1]:gsub("#VALUE", slider.getStep()), },
			slider.getAltStep() and { text = wt.strings.slider.increase.tooltip[2]:gsub("#VALUE", slider.getAltStep()), } or nil,
		},
		anchor = "ANCHOR_TOPLEFT",
	})

	slider.widget.Forward:HookScript("OnClick", function() slider.increase(IsAltKeyDown(), true) end)

	--| Valuebox

	if t.valuebox ~= false then

		--| Calculate the required number of fractal digits, assemble string patterns for value validation

		local decimals = type(t.fractional) == "number" and floor(t.fractional + 0.5) or max(
			(tostring(minValue):match("%.(%d+)") or ""):len(),
			(tostring(maxValue):match("%.(%d+)") or ""):len(),
			(tostring(slider.getStep()):match("%.(%d+)") or ""):len()
		)
		local decimalPattern = ""
		for _ = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end
		local matchPattern = "(" .. (minValue < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
		local replacePattern = "%1" .. (decimals > 0 and "%2" or "")

		--| Frame setup

		slider.valuebox = wt.CreateCustomEditbox({
			parentFrame = slider.frame,
			name = "Valuebox",
			label = false,
			tooltip = {
				title = wt.strings.slider.value.label,
				lines = { { text = wt.strings.slider.value.tooltip, }, }
			},
			position = {
				anchor = "TOP",
				offset = { y = 6 },
				relativeTo = slider.widget.Slider,
				relativePoint = "BOTTOM",
			},
			size = { w = 80, h = 20 },
			font = {
				normal = "GameFontNormalSmall2",
				highlight = "GameFontHighlightSmall2",
				disabled = "GameFontDisableSmall2",
			},
			justify = { h = "CENTER", },
			charLimit = max(tostring(math.floor(slider.getStep())):len(), tostring(math.floor(minValue)):len(), tostring(math.floor(maxValue)):len()) + (decimals > 0 and decimals + 1 or 0),
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 }
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame) return frame:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end,
				OnLeave = "",
			}, }, },
			events = {
				OnChar = function(frame, _, text) frame:SetText(text:gsub(matchPattern, replacePattern)) end,
				OnEnterPressed = function(frame) slider.setValue(frame:GetNumber(), true) end,
				OnEscapePressed = function(frame) frame:SetText(tostring(us.Round(slider.widget.Slider:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
			},
			value = tostring(slider.getValue()):gsub(matchPattern, replacePattern),
			showDefault = false,
			utilityMenu = false,
		})

		--| UX

		--Handle widget updates
		slider.addListener.changed(function(_, number) slider.valuebox.setValue(tostring(us.Round(number, decimals)):gsub(matchPattern, replacePattern)) end)
	end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then slider.widget.Slider:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else slider.widget.Slider:HookScript(key, value) end
	end end

	--| UX

	local scriptEvent = false

	---Update the widget UI based on the number value
	---***
	---@param _ any
	---@param number number
	---@param user? boolean ***Default:*** `false`
	local function updateNumber(_, number, user) if not scriptEvent then slider.widget.Slider:SetValue(number, user) else scriptEvent = false end end

	---Update the min/max limits of the slider
	---@param limitMin? number
	---@param limitMax? number
	local function updateLimits(limitMin, limitMax)
		if limitMin then slider.widget.MinText:SetText(tostring(limitMin)) else limitMin = slider.getMin() end
		if limitMax then slider.widget.MaxText:SetText(tostring(limitMax)) else limitMax = slider.getMax() end

		slider.widget.Slider:SetMinMaxValues(limitMin, limitMax)
	end

	--Handle widget updates
	slider.addListener.changed(updateNumber, 1)
	slider.addListener.min(function(_, limitMin) updateLimits(limitMin) end, 1)
	slider.addListener.max(function(_, limitMax) updateLimits(nil, limitMax) end, 1)

	--Link value changes
	slider.widget.Slider:HookScript("OnValueChanged", function(_, number, user)
		if not IsMouseButtonDown("LeftButton") then slider.widget.Slider:SetValue(slider.getValue()) return end

		scriptEvent = true

		slider.setValue(number, user)
	end)

	--| Backdrop

	wt.SetBackdrop(slider.frame, { background = {
		texture = { size = 5, },
		color = { r = 1, g = 1, b = 1, a = 0 }
	}, }, { {
		triggers = { slider.frame, slider.widget.Slider, slider.widget.Forward, slider.widget.Back, t.valuebox ~= false and slider.valuebox.widget or nil },
		rules = {
			OnEnter = function() return slider.isEnabled() and { background = { color = { a = 0.1 } } } or {} end,
			OnLeave = "",
		},
	}, })

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(slider.widget.Slider, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { slider.frame } })

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(tostring(slider.getDefault()), "FFDDDD55") end

		wt.AddWidgetTooltipLines({ slider.frame, slider.widget.Slider, slider.widget.Back, slider.widget.Forward, slider.valuebox.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = slider.frame,
				condition = slider.isEnabled,
			},
			{
				frame = slider.widget.Slider,
				condition = slider.isEnabled,
			},
			{
				frame = slider.widget.Back,
				condition = slider.isEnabled,
			},
			{
				frame = slider.widget.Forward,
				condition = slider.isEnabled,
			},
			t.valuebox ~= false and {
				frame = slider.valuebox.widget,
				condition = slider.isEnabled,
			} or nil,
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.numeric = slider.getValue() end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() slider.setValue(wt.clipboard.numeric, true) end
			}):SetEnabled(wt.clipboard.numeric ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() slider.revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() slider.reset() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		slider.widget.Slider:SetEnabled(state)

		slider.widget.TopText:SetFontObject(state and "GameFontNormal" or "GameFontDisable")
		slider.widget.MinText:SetFontObject(state and "GameFontNormalSmall" or "GameFontDisableSmall")
		slider.widget.MaxText:SetFontObject(state and "GameFontNormalSmall" or "GameFontDisableSmall")

		if t.valuebox ~= false then slider.valuebox.setEnabled(state) end

		slider.widget.Back:SetEnabled(state and wt.CheckDependencies({ {
			dependency = slider.widget.Slider,
			evaluate = function(value) return value > slider.getMin() end,
		}, }))
		slider.widget.Forward:SetEnabled(state and wt.CheckDependencies({ {
			dependency = slider.widget.Slider,
			evaluate = function(value) return value < slider.getMax() end,
		}, }))
	end

	slider.addListener.enabled(updateState, 1)

	--[ Initialization ]

	slider.addType(typename)

	--Set up starting state
	updateState(nil, slider.isEnabled())

	--Set up the limits
	updateLimits(minValue, maxValue)

	-- Set up slider value
	updateNumber(nil, slider.getValue(), false)

	return slider
end

function wt.CreateClassicSlider(t, numeric)
	t = type(t) == "table" and t or {}

	t.width = t.width or 160

	---@type typename_classicSlider
	local typename = "ClassicSlider"

	---@type typename_numeric
	local typenameBase = "Numeric"

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	local minValue, maxValue = numeric.getMin(), numeric.getMax()

	--[ Widget ]

	---@type classicSlider|numeric
	local classicSlider = wt.IsWidget(numeric, typenameBase) and numeric or wt.CreateNumeric(t)

	--[ Frame ]

	classicSlider.frame = CreateFrame("Frame", name, t.parentFrame)
	classicSlider.widget = CreateFrame("Slider", name .. "Frame", classicSlider.frame, "OptionsSliderTemplate")

	classicSlider.min = _G[name .. "FrameLow"]
	classicSlider.max = _G[name .. "FrameHigh"]

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(classicSlider.frame, t.position) end
	wt.SetArrangementDirective(classicSlider.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	classicSlider.widget:SetPoint("TOP", 0, -15)
	classicSlider.min:SetPoint("TOPLEFT", classicSlider.widget, "BOTTOMLEFT")
	classicSlider.max:SetPoint("TOPRIGHT", classicSlider.widget, "BOTTOMRIGHT")

	classicSlider.frame:SetSize(t.width, t.valuebox ~= false and 48 or 31)
	classicSlider.widget:SetWidth(t.width - (t.sideButtons ~= false and 40 or 0))

	--| Visibility

	wt.SetVisibility(classicSlider.frame, t.visible ~= false)

	if t.frameStrata then classicSlider.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then classicSlider.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then classicSlider.frame:SetToplevel(t.keepOnTop) end

	--| Label

	if t.label ~= false then
		classicSlider.label = _G[name .. "FrameText"]

		classicSlider.label:SetPoint("TOP", classicSlider.frame, "TOP", 0, 2)
		classicSlider.label:SetFontObject("GameFontNormal")

		classicSlider.label:SetText(title)
	else _G[name .. "FrameText"]:Hide() end

	--| Value step

	if t.hardStep ~= false then
		classicSlider.widget:SetValueStep(classicSlider.getStep())
		classicSlider.widget:SetObeyStepOnDrag(true)
	end

	--| Valuebox

	if t.valuebox ~= false then

		--| Calculate the required number of fractal digits, assemble string patterns for value validation
		local decimals = type(t.fractional) == "number" and floor(t.fractional + 0.5) or max(
			(tostring(minValue):match("%.(%d+)") or ""):len(),
			(tostring(maxValue):match("%.(%d+)") or ""):len(),
			(tostring(classicSlider.getStep()):match("%.(%d+)") or ""):len()
		)
		local decimalPattern = ""
		for _ = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end
		local matchPattern = "(" .. (minValue < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
		local replacePattern = "%1" .. (decimals > 0 and "%2" or "")

		--| Frame setup

		classicSlider.valuebox = wt.CreateCustomEditbox({
			parentFrame = classicSlider.frame,
			name = "Valuebox",
			label = false,
			tooltip = {
				title = wt.strings.slider.value.label,
				lines = { { text = wt.strings.slider.value.tooltip, }, }
			},
			position = {
				anchor = "TOP",
				relativeTo = classicSlider.widget,
				relativePoint = "BOTTOM",
			},
			size = { w = 64, },
			font = {
				normal = "GameFontHighlightSmall",
				disabled = "GameFontDisableSmall",
			},
			justify = { h = "CENTER", },
			charLimit = max(tostring(math.floor(classicSlider.getStep())):len(), tostring(math.floor(minValue)):len(), tostring(math.floor(maxValue)):len()) + (decimals > 0 and decimals + 1 or 0),
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 }
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame) return frame:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end,
				OnLeave = "",
			}, }, },
			events = {
				OnChar = function(frame, _, text) frame:SetText(text:gsub(matchPattern, replacePattern)) end,
				OnEnterPressed = function(frame) classicSlider.setValue(frame:GetNumber(), true) end,
				OnEscapePressed = function(frame) frame:SetText(tostring(us.Round(classicSlider.widget:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
			},
			value = tostring(classicSlider.getValue()):gsub(matchPattern, replacePattern),
			showDefault = false,
			utilityMenu = false,
		})

		--| UX

		--Handle widget updates
		classicSlider.addListener.changed(function(_, number) classicSlider.valuebox.setValue(tostring(us.Round(number, decimals)):gsub(matchPattern, replacePattern)) end)
	end

	--| Side buttons

	if t.sideButtons ~= false then

		--| Decrease

		classicSlider.decreaseButton = wt.CreateCustomButton({
			parentFrame = classicSlider.frame,
			name = "SelectPrevious",
			title = "-",
			tooltip = {
				title = wt.strings.slider.decrease.label,
				lines = {
					{ text = wt.strings.slider.decrease.tooltip[1]:gsub("#VALUE", classicSlider.getStep()), },
					classicSlider.getAltStep() and { text = wt.strings.slider.decrease.tooltip[2]:gsub("#VALUE", classicSlider.getAltStep()), } or nil,
				}
			},
			position = {
				anchor = "LEFT",
				relativeTo = classicSlider.widget,
				relativePoint = "LEFT",
				offset = { x = -21, }
			},
			size = { w = 20, h = 20 },
			font = {
				normal = "GameFontHighlightMedium",
				highlight = "GameFontHighlightMedium",
				disabled = "GameFontDisableMed2"
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function() classicSlider.decrease(IsAltKeyDown(), true) end,
			dependencies = { { dependency = classicSlider.widget, evaluate = function(value) return value > classicSlider.getMin() end, }, }
		})

		--| Increase

		classicSlider.increaseButton = wt.CreateCustomButton({
			parentFrame = classicSlider.frame,
			name = "SelectNext",
			title = "+",
			tooltip = {
				title = wt.strings.slider.increase.label,
				lines = {
					{ text = wt.strings.slider.increase.tooltip[1]:gsub("#VALUE", classicSlider.getStep()), },
					classicSlider.getAltStep() and { text = wt.strings.slider.increase.tooltip[2]:gsub("#VALUE", classicSlider.getAltStep()), } or nil,
				}
			},
			position = {
				anchor = "RIGHT",
				relativeTo = classicSlider.widget,
				relativePoint = "RIGHT",
				offset = { x = 21, }
			},
			size = { w = 20, h = 20 },
			font = {
				normal = "GameFontHighlightMedium",
				highlight = "GameFontHighlightMedium",
				disabled = "GameFontDisableMed2",
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function() classicSlider.increase(IsAltKeyDown(), true) end,
			dependencies = { { dependency = classicSlider.widget, evaluate = function(value) return value < classicSlider.getMax() end }, }
		})
	end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then classicSlider.widget:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else classicSlider.widget:HookScript(key, value) end
	end end

	--| UX

	local scriptEvent = false

	---Update the widget UI based on the number value
	---***
	---@param _ any
	---@param number number
	---@param user? boolean ***Default:*** `false`
	local function updateNumber(_, number, user) if not scriptEvent then classicSlider.widget:SetValue(number, user) else scriptEvent = false end end

	---Update the min/max limits of the slider
	---@param limitMin? number
	---@param limitMax? number
	local function updateLimits(limitMin, limitMax)
		if limitMin then classicSlider.min:SetText(tostring(limitMin)) else limitMin = classicSlider.getMin() end
		if limitMax then classicSlider.max:SetText(tostring(limitMax)) else limitMax = classicSlider.getMax() end

		classicSlider.widget:SetMinMaxValues(limitMin, limitMax)
	end

	--Handle widget updates
	classicSlider.addListener.changed(updateNumber, 1)
	classicSlider.addListener.min(function(_, limitMin) updateLimits(limitMin) end, 1)
	classicSlider.addListener.max(function(_, limitMax) updateLimits(nil, limitMax) end, 1)

	--Link value changes
	classicSlider.widget:HookScript("OnValueChanged", function(_, number, user)
		scriptEvent = true

		classicSlider.setValue(number, user)

		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(classicSlider.widget, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { classicSlider.frame } })

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(tostring(classicSlider.getDefault()), "FFDDDD55") end

		wt.AddWidgetTooltipLines({ classicSlider.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = { {
			frame = classicSlider.frame,
			condition = classicSlider.isEnabled,
		}, },
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.numeric = classicSlider.getValue() end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() classicSlider.setValue(wt.clipboard.numeric, true) end
			}):SetEnabled(wt.clipboard.numeric ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() classicSlider.revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() classicSlider.reset() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		classicSlider.widget:SetEnabled(state)

		if classicSlider.label then classicSlider.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

		if t.valuebox ~= false then classicSlider.valuebox.setEnabled(state) end

		if t.sideButtons ~= false then
			classicSlider.decreaseButton.setEnabled(state and wt.CheckDependencies({ {
				dependency = classicSlider.widget,
				evaluate = function(value) return value > classicSlider.getMin() end,
			}, }))
			classicSlider.increaseButton.setEnabled(state and wt.CheckDependencies({ {
				dependency = classicSlider.widget,
				evaluate = function(value) return value < classicSlider.getMax() end,
			}, }))
		end
	end

	classicSlider.addListener.enabled(updateState, 1)

	--[ Initialization ]

	classicSlider.addType(typename)

	--Set up starting state
	updateState(nil, classicSlider.isEnabled())

	--Set up the limits
	updateLimits(minValue, maxValue)

	--Set up slider value
	updateNumber(nil, classicSlider.getValue(), false)

	return classicSlider
end

--[ Color ]

function wt.CreateColorpicker(t, colormanager)
	t = type(t) == "table" and t or {}

	t.width = t.width or 120

	---@type typename_colorpicker
	local typename = "Colorpicker"

	---@type typename_colormanager
	local typenameBase = "Colormanager"

	colormanager = wt.IsWidget(colormanager, typenameBase) and colormanager or wt.CreateColormanager(t)
	local colorpicker = colormanager ---@cast colorpicker colorpicker

	colorpicker.addType(typename)

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	local frame = CreateFrame("Frame", name, t.parentFrame)
	colorpicker.frame = frame

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(frame, t.position) end
	wt.SetArrangementDirective(frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	frame:SetSize(t.width, 36)

	--| Visibility

	wt.SetVisibility(frame, t.visible ~= false)

	if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	colorpicker.label = t.label ~= false and wt.CreateTitle(frame, {
		offset = { x = 4, },
		text = title,
	}) or nil

	--| Color wheel toggle button

	---Toggle the interactability of the color picker elements when [ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame) is opened
	---@param unlocked boolean
	local function setLock(unlocked)
		colorpicker.button.widget:EnableMouse(unlocked)
		colorpicker.hexBox.widget:EnableMouse(unlocked)

		--| Fade inactive color pickers

		local opacity = (unlocked or colorpicker.isActive()) and 1 or 0.4

		colorpicker.label:SetAlpha(opacity)
		colorpicker.hexBox.widget:SetAlpha(opacity)
	end

	if not t.value and t.getData then t.value = us.Clone(t.getData()) else t.value = {} end

	colorpicker.button = wt.CreateCustomButton({
		parentFrame = frame,
		name = "PickerButton",
		label = false,
		tooltip = {
			title = wt.strings.color.picker.label,
			lines = { { text = wt.strings.color.picker.tooltip:gsub("#ALPHA", t.value.a and wt.strings.color.picker.alpha or ""), }, }
		},
		position = { offset = { y = -14 } },
		size = { w = 34, h = 22 },
		action = colormanager.openColorPicker,
		backdrop = {
			background = {
				texture = {
					size = 5,
					insets = { l = 2.5, r = 2.5, t = 2.5, b = 2.5 },
				},
				color = { r = t.value.r or 1, g = t.value.g or 1, b = t.value.b or 1, a = t.value.a or 1 }
			},
			border = {
				texture = { width = 11, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
			}
		},
		backdropUpdates = { { rules = {
			OnEnter = function(f)
				if not f:IsEnabled() then return {} end

				return IsMouseButtonDown() and {
					border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
				} or {
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				}
			end,
			OnLeave = function(f)
				if not f:IsEnabled() then return {} end

				return { border = { color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 } } }
			end,
			OnMouseDown = function(f)
				if not f:IsEnabled() then return {} end

				return { border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } } }
			end,
			OnMouseUp = function(f, self)
				if not f:IsEnabled() then return {} end

				return self:IsMouseOver() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {}
			end,
		}, }, },
	})

	colorpicker.button.gradient = wt.CreateTexture(colorpicker.button.widget, {
		name = "ColorGradient",
		position = { offset = { x = 2.5, y = -2.5 } },
		size = { w = 17, h = 17 },
		path = wt.textures.gradientBG,
		layer = "BACKGROUND",
		level = -7,
	})

	colorpicker.button.checker = wt.CreateTexture(colorpicker.button.widget, {
		name = "AlphaBG",
		position = { offset = { x = 2.5, y = -2.5 } },
		size = { w = 29, h = 17 },
		path = wt.textures.alphaBG,
		layer = "BACKGROUND",
		level = -8,
		tile = { h = true, v = true },
		wrap = { h = true, v = true },
	})

	--| HEX textbox

	colorpicker.hexBox = wt.CreateCustomEditbox({
		parentFrame = frame,
		name = "HEXBox",
		title = wt.strings.color.hex.label,
		label = false,
		tooltip = { lines = { {
			text = wt.strings.color.hex.tooltip .. "\n\n" .. crc(wt.strings.example .. ": ", "FF66FF66") .. crc(
				"#2266BB" .. (t.value.a and "AA" or ""), "FFFFFFFF"
			),
		}, } },
		position = {
			relativeTo = colorpicker.button.widget,
			relativePoint = "TOPRIGHT",
		},
		size = { w = t.width - colorpicker.button.widget:GetWidth(), h = colorpicker.button.widget:GetHeight() },
		insets = { l = 6, },
		font = {
			normal = "GameFontNormalSmall2",
			highlight = "GameFontHighlightSmall2",
			disabled = "GameFontDisableSmall2",
		},
		charLimit = 7 + (t.value.a and 2 or 0),
		backdrop = {
			background = {
				texture = {
					size = 5,
					insets = { l = 3, r = 3, t = 3, b = 3 },
				},
				color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 }
			},
			border = {
				texture = { width = 12, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
			}
		},
		backdropUpdates = { { rules = {
			OnEnter = function(f) return f:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end,
			OnLeave = "",
		}, }, },
		events = {
			OnChar = function(f, _, text) f:SetText(text:gsub("^(#?)([%x]*).*", "%1%2"), false) end,
			OnEnterPressed = function(_, text) colorpicker.setValue(wt.PackColor(wt.HexToColor(text)), true) end,
			OnEscapePressed = function(self) self.setText(wt.ColorToHex(colorpicker.getValue())) end,
		},
		showDefault = false,
		utilityMenu = false,
	})

	--| RGBA textboxes

	--ADD textboxes

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else frame:HookScript(key, value) end
	end end

	--| UX

	---Update the widget UI based on the color value
	---@param color color|colorRGBA
	local function updateColor(color)
		colorpicker.button.widget:SetBackdropColor(color.r, color.g, color.b, color.a)
		colorpicker.button.gradient:SetVertexColor(color.r, color.g, color.b, 1)
		colorpicker.hexBox.setValue(wt.ColorToHex(color))
	end

	--Handle widget updates
	colorpicker.addListener.colored(function(_, color) updateColor(color) end)

	--Color wheel toggle updates
	ColorPickerFrame:HookScript("OnShow", function() setLock(false) end)
	ColorPickerFrame:HookScript("OnHide", function() setLock(true) end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			local default = colorpicker.getDefault()
			local r, g, b = wt.UnpackColor(default)

			local texture = "|TInterface/ChatFrame/ChatFrameBackground:12:12:0:0:16:16:0:16:0:16:" .. (r * 255) .. ":" .. (g * 255) .. ":" .. (b * 255) .. "|t "
			defaultValue = texture .. crc(wt.ColorToHex(default), "FFFFFFFF")
		end

		wt.AddWidgetTooltipLines({ frame, colorpicker.button.widget, colorpicker.hexBox.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	---Utility menu opening condition checker
	---@return boolean
	local function openCondition() return colorpicker.isEnabled() and not ColorPickerFrame:IsVisible() end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = frame,
				condition = openCondition,
			},
			{
				frame = colorpicker.button.frame,
				condition = openCondition,
			},
			{
				frame = colorpicker.hexBox.widget,
				condition = openCondition,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.color = colorpicker.getValue() end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() colorpicker.setValue(wt.clipboard.color, true) end
			}):SetEnabled(wt.clipboard.color ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() colorpicker.revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() colorpicker.reset() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		colorpicker.button.setEnabled(state)
		colorpicker.hexBox.setEnabled(state)

		if colorpicker.label then colorpicker.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

		if ColorPickerFrame:IsVisible() then setLock(false) end
	end

	colorpicker.addListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, colorpicker.isEnabled())

	--Set up coloring
	updateColor(colorpicker.getValue())

	return colorpicker
end

--[ Position ]

local positioningVisualAids = {}

function wt.CreatePositionOptions(addon, frame, getData, defaultData, settingsData, t) --FIX lite
	if not addon or not C_AddOns.IsAddOnLoaded(addon) or not us.IsFrame(frame) or type(t) ~= "table" then return end

	---@type typename_positionPanel
	local typename = "PositionOptions"

	---@type typename_positionmanager
	local typenameBase = "Positionmanager"

	if type(t.name) ~= "string" then t.name = frame:GetName() end
	t.dataManagement = t.dataManagement or {}
	t.dataManagement.category = t.dataManagement.category or addon
	t.dataManagement.key = t.dataManagement.key or "Position"

	--[ Widget ] --TODO separate logical core

	---@type positionPanel
	---@diagnostic disable-next-line: missing-fields --NOTE: Added later --REMOVE after the logical core is separated
	local panel = { widgets = {}, }

	--[ Visual Aids ]

	if WidgetToolsDB.positioningAids then
		positioningVisualAids.frame = positioningVisualAids.frame or wt.CreateFrame({
			name = "WidgetToolsPositioningVisualAids",
			position = { anchor = "CENTER", },
			size = { w = GetScreenWidth() - 14, h = GetScreenHeight() - 14 },
			visible = false,
			frameStrata = "BACKGROUND",
			initialize = function(container)

				--[ Textures ]

				positioningVisualAids.anchor = positioningVisualAids.anchor or wt.CreateTexture(container, {
					name = "Anchor",
					size = { w = 14, h = 14 },
					path = wt.classic and "Interface/CharacterFrame/TempPortraitAlphaMask" or "Interface/Common/common-mask-diamond",
				})

				positioningVisualAids.relativePoint = positioningVisualAids.relativePoint or wt.CreateTexture(container, {
					name = "RelativePoint",
					size = { w = 14, h = 14 },
					path = not wt.classic and "Interface/Common/common-iconmask" or nil,
				})

				positioningVisualAids.line = positioningVisualAids.line or wt.CreateLine(container, {
					name = "Line",
					startPosition = {
						relativeTo = positioningVisualAids.anchor,
						relativePoint = "CENTER"
					},
					endPosition = {
						relativeTo = positioningVisualAids.relativePoint,
						relativePoint = "CENTER"
					},
					thickness = 2,
					color = { r = 1, g = 1, b = 1, a = 1 }
				})

				--[ Utilities ]

				---Update the visual aid positions
				---@param target AnyFrameObject
				---@param position positionData_base
				function positioningVisualAids.update(target, position)
					--Anchor
					wt.SetPosition(positioningVisualAids.anchor, {
						anchor = "CENTER",
						relativeTo = target,
						relativePoint = position.anchor,
					})

					--Relative Point
					wt.SetPosition(positioningVisualAids.relativePoint, {
						anchor = "CENTER",
						relativeTo = positioningVisualAids.frame,
						relativePoint = position.relativePoint,
					})
				end

				---Show the positioning visual aids for the specified target frame
				---@param target AnyFrameObject
				---@param position positionData_base
				function positioningVisualAids.show(target, position)
					positioningVisualAids.frame:Show()

					--Dimensions
					positioningVisualAids.frame:SetSize(GetScreenWidth() - 14, GetScreenHeight() - 14)
					positioningVisualAids.frame:SetScale(UIParent:GetScale())

					--Points
					positioningVisualAids.update(target, position)
				end
			end
		})

		--[ Toggle ]

		if not WidgetToolsDB.lite then
			t.canvas:HookScript("OnShow", function() positioningVisualAids.show(frame, getData().position) end)
			t.canvas:HookScript("OnHide", function() positioningVisualAids.frame:Hide() end)
		end

		--[ Update Size ]

		us.SetListener(positioningVisualAids.frame, "UI_SCALE_CHANGED", function(f)
			f:SetSize(GetScreenWidth() - 14, GetScreenHeight() - 14)
			f:SetScale(UIParent:GetScale())
		end)
	end

	--[ Options Panel ]

	panel.panel = wt.CreatePanel({
		parentFrame = t.canvas,
		name = "Position",
		title = wt.strings.position.title,
		description = wt.strings.position.description[t.setMovable and "movable" or "static"]:gsub("#FRAME", t.name),
		arrange = {},
		arrangement = {},
		initialize = function(_, panelFrame)

			--[ Presets ]

			if t.presets then
				panel.presets = us.Clone(t.presets.items)

				--| Utilities

				local applyPreset = function(_, i)
					if type(panel.presets[i]) ~= "table" or type(panel.presets[i].data) ~= "table" then
						--Call listener
						if type(t.presets.onPreset) == "function" then t.presets.onPreset(panel.presets[i], i) end

						return
					end

					--Position
					if type(panel.presets[i].data.position) == "table" then
						--Update the frame
						wt.SetPosition(frame, panel.presets[i].data.position, true)

						--Update the storage
						us.CopyValues(getData().position, wt.PackPosition(frame:GetPoint()))

						--Update the settings widgets
						panel.widgets.position.anchor.loadData(false)
						panel.widgets.position.relativePoint.loadData(false)
						-- panel.widgets.position.relativeTo.loadData(false)
						panel.widgets.position.offset.x.loadData(false)
						panel.widgets.position.offset.y.loadData(false)
					end

					--Keep in bounds
					if panel.presets[i].data.keepInBounds ~= nil then
						frame:SetClampedToScreen(panel.presets[i].data.keepInBounds) --Update the frame
						getData().keepInBounds = panel.presets[i].data.keepInBounds --Update the storage
						if panel.widgets.position.keepInBounds then panel.widgets.position.keepInBounds.loadData(false) end --Update the settings widget
					end

					--Screen Layer
					if type(panel.presets[i].data.layer) == "table" then
						--Frame strata
						if panel.presets[i].data.layer.strata then
							frame:SetFrameStrata(panel.presets[i].data.layer.strata) --Update the frame
							getData().layer.strata = panel.presets[i].data.layer.strata --Update the storage
							if panel.widgets.layer.strata then panel.widgets.layer.strata.loadData(false) end --Update the settings widget
						end

						--Keep on top
						if panel.presets[i].data.layer.keepOnTop ~= nil then
							frame:SetToplevel(panel.presets[i].data.layer.keepOnTop) --Update the frame
							getData().layer.keepOnTop = panel.presets[i].data.layer.keepOnTop --Update the storage
							if panel.widgets.layer.keepOnTop then panel.widgets.layer.keepOnTop.loadData(false) end --Update the settings widget
						end

						--Frame level
						if panel.presets[i].data.layer.level then
							frame:SetFrameLevel(panel.presets[i].data.layer.level) --Update the frame
							getData().layer.level = panel.presets[i].data.layer.level --Update the storage
							if panel.widgets.layer.level then panel.widgets.layer.level.loadData(false) end --Update the settings widget
						end
					end

					--Update the positioning visual aids
					if WidgetToolsDB.positioningAids then positioningVisualAids.update(frame, getData().position) end

					--Call listener
					if type(t.presets.onPreset) == "function" then t.presets.onPreset(panel.presets[i], i) end
				end

				function panel.applyPreset(i)
					if not i or i < 1 or i > #panel.presets then return false end

					--Apply the preset data to the frame & update the settings widgets
					applyPreset(nil, i)

					return true
				end

				--| Widgets

				local applyButton, applyMenu = wt.CreatePopupMenu({
					parentFrame = panelFrame,
					name = "ApplyPreset",
					title = wt.strings.presets.apply.label,
					tooltip = { lines = { { text = wt.strings.presets.apply.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = {},
					initialize = function(menu)
						wt.CreateMenuTextline(menu, { text = wt.strings.presets.apply.select, })

						for i = 1, #panel.presets do wt.CreateMenuButton(menu, {
							title = panel.presets[i].title,
							action = function() panel.applyPreset(i) end,
						}) end
					end,
				})

				panel.widgets.presets = { applyButton = applyButton, applyMenu = applyMenu, }

				--[ Custom Preset ]

				if t.presets.custom then
					t.presets.custom.index = t.presets.custom.index or 1
					panel.presets[t.presets.custom.index].data = t.presets.custom.getData()

					--| Utilities

					function panel.saveCustomPreset()
						--Update the custom preset
						panel.presets[t.presets.custom.index].data.position = wt.PackPosition(frame:GetPoint())
						if panel.presets[t.presets.custom.index].data.keepInBounds then
							panel.presets[t.presets.custom.index].data.keepInBounds = frame:IsClampedToScreen()
						end
						if (panel.presets[t.presets.custom.index].data.layer or {}).strata then
							panel.presets[t.presets.custom.index].data.layer.strata = frame:GetFrameStrata()
						end
						if (panel.presets[t.presets.custom.index].data.layer or {}).keepOnTop then
							panel.presets[t.presets.custom.index].data.layer.keepOnTop = frame:IsToplevel()
						end
						if (panel.presets[t.presets.custom.index].data.layer or {}).level then
							panel.presets[t.presets.custom.index].data.layer.level = frame:GetFrameLevel()
						end

						--Save the custom preset
						us.CopyValues(t.presets.custom.getData(), panel.presets[t.presets.custom.index].data)
						if t.presets.custom.getData() then us.CopyValues(t.presets.custom.getData(), t.presets.custom.getData()) end

						--Call the specified handler
						if t.presets.custom.onSave then t.presets.custom.onSave() end
					end

					function panel.resetCustomPreset()
						--Reset the custom preset
						panel.presets[t.presets.custom.index].data = us.Clone(t.presets.custom.defaultsTable)

						--Save the custom preset
						us.CopyValues(t.presets.custom.getData(), panel.presets[t.presets.custom.index].data)
						if t.presets.custom.getData() then us.CopyValues(t.presets.custom.getData(), t.presets.custom.getData()) end

						--Call the specified handler
						if t.presets.custom.onReset then t.presets.custom.onReset() end

						--Apply the custom preset
						panel.applyPreset(t.presets.custom.index)
					end

					--| Widgets

					local savePopup = wt.RegisterPopupDialog(addon .. "_SAVE_PRESET", {
						text = wt.strings.presets.save.warning:gsub("#CUSTOM", cr(panel.presets[t.presets.custom.index].title, NORMAL_FONT_COLOR)),
						accept = wt.strings.override,
						onAccept = panel.saveCustomPreset,
					})

					panel.widgets.presets.save = wt.CreateButton({
						parentFrame = panelFrame,
						name = "SavePreset",
						title = wt.strings.presets.save.label:gsub("#CUSTOM", panel.presets[t.presets.custom.index].title),
						tooltip = { lines = {
							{ text = wt.strings.presets.save.tooltip:gsub("#FRAME", t.name):gsub("#CUSTOM", panel.presets[t.presets.custom.index].title), },
						} },
						arrange = { wrap = false, },
						size = { w = 170, h = 26 },
						action = function() StaticPopup_Show(savePopup) end,
						dependencies = t.dependencies
					})

					local resetPopup = wt.RegisterPopupDialog(addon .. "_RESET_PRESET_" .. panelFrame:GetName(), {
						text = wt.strings.presets.reset.warning:gsub("#CUSTOM", cr(panel.presets[t.presets.custom.index].title, NORMAL_FONT_COLOR)),
						accept = wt.strings.override,
						onAccept = panel.resetCustomPreset,
					})

					panel.widgets.presets.reset = wt.CreateButton({
						parentFrame = panelFrame,
						name = "ResetPreset",
						title = wt.strings.presets.reset.label:gsub("#CUSTOM", panel.presets[t.presets.custom.index].title),
						tooltip = { lines = { { text = wt.strings.presets.reset.tooltip:gsub("#CUSTOM", panel.presets[t.presets.custom.index].title), }, } },
						arrange = { wrap = false, },
						size = { w = 170, h = 26 },
						action = function() StaticPopup_Show(resetPopup) end,
					})
				end
			end

			--[ Position ]

			panel.widgets.position = {
				relativePoint = wt.CreateSpecialRadiogroup("anchor", {
					parentFrame = panelFrame,
					name = "RelativePoint",
					title = wt.strings.position.relativePoint.label,
					tooltip = { lines = { { text = wt.strings.position.relativePoint.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = {},
					width = 140,
					dependencies = t.dependencies,
					getData = function() return getData().position.relativePoint end,
					saveData = function(value) getData().position.relativePoint = value end,
					default = defaultData.position.relativePoint,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomPositionChangeHandler = function() if type(t.onChangePosition) == "function" then t.onChangePosition() end end,
							UpdateFramePosition = function() wt.SetPosition(frame, getData().position, true) end,
							UpdatePositioningVisualAids = function() if WidgetToolsDB.positioningAids then positioningVisualAids.update(frame, getData().position) end end,
						},
					},
				}),
				anchor = wt.CreateSpecialRadiogroup("anchor", {
					parentFrame = panelFrame,
					name = "AnchorPoint",
					title = wt.strings.position.anchor.label,
					tooltip = { lines = { { text = wt.strings.position.anchor.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = { wrap = false, },
					width = 140,
					dependencies = t.dependencies,
					getData = function() return getData().position.anchor end,
					saveData = function(value) getData().position.anchor = value end,
					default = defaultData.position.anchor,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						index = 1,
						onChange = {
							"CustomPositionChangeHandler",
							UpdateFrameOffsetsAndPosition = function() if not settingsData.keepInPlace then wt.SetPosition(frame, getData().position, true) else
								local x, y = wt.SetAnchor(frame, getData().position.anchor)

								--Update offsets
								panel.widgets.position.offset.x.setData(x, false)
								panel.widgets.position.offset.y.setData(y, false)
							end end,
							"UpdatePositioningVisualAids"
						},
					},
				}),
				keepInPlace = wt.CreateCheckbox({
					parentFrame = panelFrame,
					name = "KeepInPlace",
					title = wt.strings.position.keepInPlace.label,
					tooltip = { lines = { { text = wt.strings.position.keepInPlace.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = { wrap = false, },
					dependencies = t.dependencies,
					getData = function() return settingsData.keepInPlace end,
					saveData = function(state) settingsData.keepInPlace = state end,
					default = true,
					showDefault = false,
					utilityMenu = false,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
					},
				}),
				offset = {
					x = wt.CreateSlider({
						parentFrame = panelFrame,
						name = "OffsetX",
						title = wt.strings.position.offsetX.label,
						tooltip = { lines = { { text = wt.strings.position.offsetX.tooltip:gsub("#FRAME", t.name), }, } },
						arrange = {},
						min = -500,
						max = 500,
						fractional = 2,
						step = 1,
						altStep = 25,
						hardStep = false,
						dependencies = t.dependencies,
						getData = function() return getData().position.offset.x end,
						saveData = function(value) getData().position.offset.x = value end,
						default = defaultData.position.offset.x,
						dataManagement = {
							category = t.dataManagement.category,
							key = t.dataManagement.key,
							index = 3,
							onChange = {
								"CustomPositionChangeHandler",
								"UpdateFramePosition",
							},
						},
					}),
					y = wt.CreateSlider({
						parentFrame = panelFrame,
						name = "OffsetY",
						title = wt.strings.position.offsetY.label,
						tooltip = { lines = { { text = wt.strings.position.offsetY.tooltip:gsub("#FRAME", t.name), }, } },
						arrange = { wrap = false, },
						min = -500,
						max = 500,
						fractional = 2,
						step = 1,
						altStep = 25,
						hardStep = false,
						dependencies = t.dependencies,
						getData = function() return getData().position.offset.y end,
						saveData = function(value) getData().position.offset.y = value end,
						default = defaultData.position.offset.y,
						dataManagement = {
							category = t.dataManagement.category,
							key = t.dataManagement.key,
							index = 4,
							onChange = {
								"CustomPositionChangeHandler",
								"UpdateFramePosition",
							},
						},
					}),
				},
				keepInBounds = getData().keepInBounds ~= nil and wt.CreateCheckbox({
					parentFrame = panelFrame,
					name = "KeepInBounds",
					title = wt.strings.position.keepInBounds.label,
					tooltip = { lines = { { text = wt.strings.position.keepInBounds.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = { wrap = false, },
					dependencies = t.dependencies,
					getData = function() return getData().keepInBounds end,
					saveData = function(state) getData().keepInBounds = state end,
					default = defaultData.keepInBounds,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomKeepInBoundsChangeHandler = function() if type(t.onChangeKeepInBounds) == "function" then t.onChangeKeepInBounds() end end,
							UpdateScreenClamp = function() frame:SetClampedToScreen(getData().keepInBounds) end,
						},
					},
				}) or nil,
			}

			--[ Screen Layer ]

			if getData().layer and next(getData().layer) then panel.widgets.layer = {
				strata = getData().layer.strata and wt.CreateSpecialRadiogroup("strata", {
					parentFrame = panelFrame,
					name = "FrameStrata",
					title = wt.strings.layer.strata.label,
					tooltip = { lines = { { text = wt.strings.layer.strata.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = {},
					width = 140,
					dependencies = t.dependencies,
					getData = function() return getData().layer.strata end,
					saveData = function(value) getData().layer.strata = value end,
					default = defaultData.layer.strata,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomStrataChangeHandler = function() if type(t.onChangeStrata) == "function" then t.onChangeStrata() end end,
							UpdateFrameStrata = function() frame:SetFrameStrata(getData().layer.strata) end,
						},
					},
				}) or nil,
				keepOnTop = getData().layer.keepOnTop ~= nil and wt.CreateCheckbox({
					parentFrame = panelFrame,
					name = "KeepOnTop",
					title = wt.strings.layer.keepOnTop.label,
					tooltip = { lines = { { text = wt.strings.layer.keepOnTop.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = { wrap = false, },
					dependencies = t.dependencies,
					getData = function() return getData().layer.keepOnTop end,
					saveData = function(state) getData().layer.keepOnTop = state end,
					default = defaultData.layer.keepOnTop,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomKeepOnTopChangeHandler = function() if type(t.onChangeKeepOnTop) == "function" then t.onChangeKeepOnTop() end end,
							UpdateTopLevel = function() frame:SetToplevel(getData().layer.keepOnTop) end,
						},
					},
				}) or nil,
				level = getData().layer.level and wt.CreateSlider({
					parentFrame = panelFrame,
					name = "FrameLevel",
					title = wt.strings.layer.level.label,
					tooltip = { lines = { { text = wt.strings.layer.level.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = { wrap = false, },
					min = 0,
					max = 10000,
					step = 1,
					altStep = 100,
					dependencies = t.dependencies,
					getData = function() return getData().layer.level end,
					saveData = function(value) getData().layer.level = value end,
					default = defaultData.layer.level,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomLevelChangeHandler = function() if type(t.onChangeLevel) == "function" then t.onChangeLevel() end end,
							UpdateFrameLevel = function() frame:SetFrameLevel(getData().layer.level) end,
						},
					},
				}) or nil,
			} end
		end,
	})

	--[ Movability ]

	if t.setMovable and type(t.setMovable) == "table" then
		t.setMovable.events = t.setMovable.events or {}

		wt.SetMovability(frame, true, {
			modifier = t.setMovable.modifier or "SHIFT",
			triggers = t.setMovable.triggers,
			events = {
				onStart = t.setMovable.events.onStart,
				onMove = t.setMovable.events.onMove,
				onStop = function()
					--Update the storage
					us.CopyValues(getData().position, wt.PackPosition(frame:GetPoint()))

					--Update the settings widgets
					panel.widgets.position.anchor.loadData(false)
					panel.widgets.position.relativePoint.loadData(false)
					-- panel.widgets.position.relativeTo.loadData(false)
					panel.widgets.position.offset.x.loadData(false)
					panel.widgets.position.offset.y.loadData(false)

					--Update the positioning visual aids
					if WidgetToolsDB.positioningAids then positioningVisualAids.update(frame, getData().position) end

					--Call the specified handler
					if t.setMovable.events.onStop then t.setMovable.events.onStop() end
				end,
				onCancel = function()
					--Reset the position
					wt.SetPosition(frame, getData().position, true)

					--Call the specified handler
					if t.setMovable.events.onCancel then t.setMovable.events.onCancel() end
				end
			}
		})
	end

	return panel
end

--[ Font ]

local fonts ---@type fontFileData[]|nil
local fontItems ---@type selectorItemData[]|nil

function wt.CreateFontOptions(addon, textline, getData, defaultData, t) --FIX lite
	if not addon or not C_AddOns.IsAddOnLoaded(addon) or type(textline) ~= "table" or type(textline.GetFont) ~= "function" or type(t) ~= "table" then return end

	---@type typename_fontPanel
	local typename = "FontOptions"

	---@type typename_fontmanager
	local typenameBase = "Fontmanager"

	if type(t.name) ~= "string" then t.name = textline:GetName() end

	t.dataManagement = t.dataManagement or {}
	t.dataManagement.category = t.dataManagement.category or addon
	t.dataManagement.key = t.dataManagement.key or "Font"

	--[ Widget ] --TODO separate logical core

	---@type fontPanel
	---@diagnostic disable-next-line: missing-fields --NOTE: Added later --REMOVE after the logical core is separated
	local fontPanel = {}

	--[ Options Panel ]

	fontPanel.panel = wt.CreatePanel({
		parentFrame = t.canvas,
		name = "Font",
		title = wt.strings.font.title,
		arrange = {},
		arrangement = {},
		initialize = function(_, panelFrame)

			--| Font family

			if not fonts or not fontItems then
				fontItems = {}

				--| Add base fonts

				fonts = us.Clone(rs.fonts)

				table.insert(fonts, 1, {
					name = wt.strings.font.path.default.label,
					path = STANDARD_TEXT_FONT:gsub("\\", "/"),
				})

				for i = 1, #fonts do
					fontItems[i] = {}
					fontItems[i].title = fonts[i].name
					fontItems[i].tooltip = {
						title = fonts[i].name,
						lines = {
							{ text = fonts[i].path:match(rs.addon) and wt.strings.font.path.otf or wt.strings.font.path.base },
							{ text = "\n" .. wt.strings.font.path.file:gsub("#PATH", crc(fonts[i].path, "FFFFFFFF")), color = { r = 0.4, g = 1, b = 0.4 }, },
						}
					}
				end
				fontItems[1].tooltip.lines[1] = { text = wt.strings.font.path.default.tooltip, }

				--| Add custom fonts

				if type(WidgetToolsDB.customFonts) == "table" then
					for i = 1, #WidgetToolsDB.customFonts do table.insert(fonts, {
						name = WidgetToolsDB.customFonts[i],
						path = "Fonts/" .. WidgetToolsDB.customFonts[i] .. ".ttf",
					}) end

					for i = #fonts - #WidgetToolsDB.customFonts + 1, #fonts do
						fontItems[i] = {}
						fontItems[i].title = fonts[i].name
						fontItems[i].tooltip = {
							title = fonts[i].name,
							lines = {
								{ text = wt.strings.font.path.custom, },
								{ text = "\n" .. wt.strings.font.path.replace:gsub( --TODO update the tooltip when full custom font management support is added
									"#FONTS_DIRECTORY", cr("[WoW]\\Fonts\\", { r = 0.185, g = 0.72, b = 0.84 })
								):gsub("#FILE_CUSTOM", "CUSTOM.ttf") },
								{ text = "\n" .. wt.strings.font.path.reminder, color = { r = 0.89, g = 0.65, b = 0.40 }, }, --TODO update the tooltip when full custom font management support is added
								{ text = "\n" .. wt.strings.font.path.file:gsub("#PATH", crc(fonts[i].path, "FFFFFFFF")), color = { r = 0.4, g = 1, b = 0.4 }, },
							}
						}
					end
				end
			end

			--| Widgets

			fontPanel.widgets = {
				path = wt.CreateDropdownRadiogroup({
					parentFrame = panelFrame,
					name = "Path",
					title = wt.strings.font.path.label,
					tooltip = { lines = { { text = wt.strings.font.path.tooltip, }, } },
					width = 184,
					arrange = {},
					items = fontItems,
					dependencies = t.dependencies,
					getData = function() return us.FindIndex(fonts, getData().path) end,
					saveData = function(value) getData().path = fonts[value].path end,
					default = us.FindIndex(fonts, defaultData.path),
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomFontChangeHandler = function() if type(t.onChangeFont) == "function" then t.onChangeFont() end end,
							UpdateTextFont = function() pcall(textline.SetFont, textline, getData().path, getData().size, "OUTLINE") end,
							UpdateFontDropdownText = not WidgetToolsDB.lite and function()
								---@type FontString
								local label = fontPanel.widgets.path.toggle.label
								local _, size, flags = label:GetFont()

								pcall(label.SetFont, label, fonts[fontPanel.widgets.path.getValue() or 1].path, size, flags)
							end or nil,
						},
					},
					events = { OnShow = function()
						---@type FontString
						local label = fontPanel.widgets.path.toggle.label
						local _, size, flags = label:GetFont()

						pcall(label.SetFont, label, fonts[fontPanel.widgets.path.getValue() or 1].path, size, flags)
					end },
				}),
				size = wt.CreateSlider({
					parentFrame = panelFrame,
					name = "Size",
					title = wt.strings.font.size.label,
					tooltip = { lines = { { text = wt.strings.font.size.tooltip, }, } },
					arrange = { wrap = false, },
					min = 8,
					max = 64,
					step = 1,
					altStep = 3,
					dependencies = t.dependencies,
					getData = function() return getData().size end,
					saveData = function(value) getData().size = value end,
					default = defaultData.size,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomSizeChangeHandler = function() if type(t.onChangeSize) == "function" then t.onChangeSize() end end,
							"UpdateTextFont",
						},
					},
				}),
				alignment = wt.CreateSpecialRadiogroup("justifyH", {
					parentFrame = panelFrame,
					name = "Alignment",
					title = wt.strings.font.alignment.label,
					tooltip = { lines = { { text = wt.strings.font.alignment.tooltip, }, } },
					arrange = { wrap = false, },
					width = 140,
					dependencies = t.dependencies,
					getData = function() return getData().alignment end,
					saveData = function(value) getData().alignment = value end,
					default = defaultData.alignment,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomAlignmentChangeHandler = function() if type(t.onChangeAlignment) == "function" then t.onChangeAlignment() end end,
							UpdateTextAlignment = function() textline:SetJustifyH(getData().alignment) end,
						},
					},
				}),
			}

			--Update the font of the font selection dropdown items
			if fontPanel.widgets.path.frame then

				--| Font paths

				for i = 1, #fontPanel.widgets.path.items do
					local label = fontPanel.widgets.path.items[i].label

					if label then
						local _, size, flags = label:GetFont()

						pcall(label.SetFont, label, fonts[i].path, size, flags)
					end
				end

				--| Colors

				local labelDefault = fontPanel.widgets.path.items[1].label

				if labelDefault then labelDefault:SetTextColor(0.4, 1, 0.4) end

				if type(WidgetToolsDB.customFonts) == "table" then for i = #fonts - #WidgetToolsDB.customFonts + 1, #fonts do
					local label = fontPanel.widgets.path.items[i].label

					if label then label:SetTextColor(1, 0.4, 0.4) end
				end end
			end

			--| Font color

			if type(t.colors) == "table" then
				if type(t.colors.base) ~= "table" then t.colors.base = {} end
				if type(getData().colors) ~= "table" then
					getData().colors = {}
					wt.VerifyColor(getData().colors.base)
				end

				--| Widgets

				fontPanel.widgets.colors = {}

				for k, v in pairs(t.colors) do if type(v) == "table" then
					local name = type(v.name) == "string" and v.name or (k:sub(1,1):upper() .. k:sub(2))
					local index = type(v.index) == "number" and math.floor(v.index) + 3 or nil

					fontPanel.widgets.colors[k] = wt.CreateColorpicker({
						parentFrame = panelFrame,
						name = name .. "Colorpicker",
						title = wt.strings.font.color.label:gsub("#COLOR_TYPE", name),
						tooltip = { lines = { { text = wt.strings.font.color.tooltip:gsub("#COLOR_TYPE", name), }, } },
						arrange = { wrap = v.wrap or v.index == 1, index = index },
						dependencies = t.dependencies,
						getData = function() return getData().colors[k] end,
						saveData = function(value) getData().colors[k] = value end,
						default = defaultData.colors[k],
						dataManagement = {
							category = t.dataManagement.category,
							key = t.dataManagement.key,
							onChange = {
								CustomColorChangeHandler = function() if type(t.onChangeColor) == "function" then t.onChangeColor(k) end end,
								UpdateTextColor = function() textline:SetTextColor(wt.UnpackColor(getData().colors.base)) end,
							},
						},
					})
				end end
			end
		end,
	})

	return fontPanel
end


--[[ SETTINGS ]]

function wt.CreateSettingsPage(t, settingsmanager)
	t = type(t) == "table" and t or {}

	t.name = t.name and t.name:gsub("%s+", "")

	---@type typename_settingsPage
	local typename = "SettingsPage"

	---@type typename_settingsmanager
	local typenameBase = "Settingsmanager"

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	local width, height = 0, 0

	if type(t.dataManagement) == "table" then
		t.dataManagement.category = t.dataManagement.category or addon
		t.dataManagement.keys = type((t.dataManagement.keys or {})[1]) == "string" and t.dataManagement.keys or { t.name or addon }
	end

	---@type string, actionButton, actionButton, FontString
	local resetWarning, resetButton, revertButton, saveNotice

	--[ Widget ]

	---@type settingsPage|settingsmanager
	local page = wt.IsWidget(settingsmanager, typenameBase) and settingsmanager or wt.CreateSettingsmanager(t)

	--[ Getters & Setters ]

	function page.setStatic(state)
		state = state == false

		resetButton.setEnabled(state)
		revertButton.setEnabled(state)

		if state then saveNotice:Show() else saveNotice:Hide() end
	end

	function page.getResetPopupKey() return resetWarning end

	--| Utilities

	function page.open()
		if WidgetToolsDB.lite or not page.category then
			print(cr(wt.Texture(rs.textures.logo, 9) .. " " .. rs.title, rs.colors.gold[1]) .. " " .. cr(rs.strings.chat.lite.reminder:gsub(
				"#HINT", cr(rs.strings.chat.lite.hint:gsub(
					"#COMMAND", cr("/" .. rs.chat.keyword .. " " .. rs.chat.commands.lite, { r = 1, g = 1, b = 1, })
				), rs.colors.grey[1])
			), rs.colors.gold[2]))

			return
		end

		Settings.OpenToCategory(page.category:GetID())
	end

	--[ Settings Page ]

	if not WidgetToolsDB.lite or t.lite == false then

		--[ Canvas Frame ]

		width, height = SettingsPanel.Container.SettingsCanvas:GetSize()

		page.canvas = wt.CreateFrame({
			name = (t.append ~= false and t.name and addon or "") .. (t.name or addon) .. "Page",
			size = { w = width, h = height },
			visible = false,
		})

		page.content = t.scroll and wt.CreateScrollframe({
			parentFrame = page.canvas,
			name = "Content",
			size = { w = width - 8, h = height - 51 },
			position = { offset = { y = -52 }, },
			scrollSize = { w = width - 24, h = t.scroll.height, },
			scrollSpeed = t.scroll.speed,
		}) or wt.CreateFrame({
			parentFrame = page.canvas,
			name = "Content",
			size = { w = width - 12, h = height - 52 },
			position = { offset = { y = -52 }, },
		})

		--| Title & description

		page.title = wt.CreateTitle(page.canvas, {
			name = "Title",
			offset = { x = 7, y = -22 },
			text = title,
			font = "GameFontHighlightHuge",
		})

		if type(t.description) == "string" then page.description = wt.CreateDescription(page.title, {
			widthOffset = -161,
			spacer = 7,
			text = t.description,
		}) end

		--| Icon texture

		page.iconTexture = type(t.icon) == "string" and t.icon or C_AddOns.GetAddOnMetadata(addon, "IconTexture")

		page.icon = wt.CreateTexture(page.canvas, {
			name = "Icon",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = SettingsPanel.Container,
				relativePoint = "TOPLEFT",
				offset = { x = 8, }
			},
			size = { w = 42, h = 42 },
			path = page.iconTexture,
		})

		--| Divider texture

		wt.CreateTexture(page.canvas, {
			atlas = "Options_HorizontalDivider",
			position = { anchor = "TOP", offset = { y = -50 } },
		})

		--[ Utility Widgets ]

		--| Defaults button

		resetWarning = wt.RegisterPopupDialog(addon .. "_" .. (t.name or "") .. "DEFAULT", {
			text = wt.strings.settings.warningSingle:gsub("#PAGE", cr(title, NORMAL_FONT_COLOR)),
			accept = ACCEPT,
			onAccept = function() page.reset(true) end,
		})

		---@type actionButton
		resetButton = wt.CreateButton({
			parentFrame = page.canvas,
			name = "Defaults",
			title = DEFAULTS,
			tooltip = { lines = { { text = wt.strings.settings.defaults.tooltip, }, } },
			position = {
				anchor = "TOPRIGHT",
				offset = { x = -36, y = -16 }
			},
			size = { w = 96, },
			action = function() StaticPopup_Show(resetWarning) end,
			disabled = t.static,
		})

		--| Revert Changes button

		revertButton = wt.CreateButton({
			parentFrame = page.canvas,
			name = "Cancel",
			title = wt.strings.settings.cancel.label,
			tooltip = { lines = { { text = wt.strings.settings.cancel.tooltip, }, } },
			position = {
				anchor = "BOTTOMLEFT",
				offset = { x = -18, y = -31 }
			},
			size = { w = 140, },
			action = function() page.revert(true) end,
			disabled = t.static,
		})

		--Add save notice text
		saveNotice = wt.CreateText({
			parentFrame = page.canvas,
			name = "SaveNotice",
			position = {
				anchor = "BOTTOMRIGHT",
				offset = { x = -96, y = -26.75 }
			},
			text = wt.strings.settings.save,
			justify = { h = "RIGHT", },
		})

		if t.static then saveNotice:Hide() end
	end

	--[ Category Resources ]

	---@diagnostic disable-next-line: inject-field --REMOVE when replaced
	page.categorySyncer = { onDefault = t.onDefault, dataManagement = t.dataManagement, titleIcon = t.titleIcon } --REPLACE temporary solution

	--[ Initialization ]

	page.addType(typename)

	--Register to the Settings panel
	if t.register then wt.RegisterSettingsPage(page, wt.IsWidget(t.register) == "SettingsPage" and t.register or nil, t.titleIcon) end

	--Add content, performs tasks
	if type(t.initialize) == "function" then
		t.initialize(page.content, width, height, (t.dataManagement or {}).category, (t.dataManagement or {}).keys, t.name or addon)

		--Arrange content
		if t.arrangement and page.content then wt.ArrangeContent(page.content, us.Fill(t.arrangement, {
			margins = { l = 10, r = 10, t = 54, b = 10 },
			gaps = 54,
			resize = t.scroll ~= nil
		})) end
	end

	return page
end

function wt.CreateSettingsCategory(addon, parent, pages, t) --FIX lite
	if not addon or not C_AddOns.IsAddOnLoaded(addon) or wt.IsWidget(parent) ~= "SettingsPage" and not parent.category then return nil end

	t = type(t) == "table" and t or {}

	---@type settingsCategory
	local category = { pages = {} }

	--[ Category Pages ]

	--| Parent

	local parentTitle = parent.title and parent.title:GetText() or ""

	table.insert(category.pages, parent)

	wt.RegisterSettingsPage(parent)

	--Override defaults warning and add all defaults option to dialog
	wt.UpdatePopupDialog(parent.getResetPopupKey(), {
		text = wt.strings.settings.warning:gsub("#CATEGORY", cr(parentTitle, NORMAL_FONT_COLOR)):gsub("#PAGE", cr(parentTitle, NORMAL_FONT_COLOR)),
		accept = ALL_SETTINGS,
		alt = CURRENT_SETTINGS,
		onAccept = function() category.defaults(true) end,
		onAlt = function() parent.reset(true) end,
	})

	--| Subcategories

	if type(pages) == "table" then for i = 1, #pages do if type(pages[i]) == "table" and not pages[i].category then
		if wt.IsWidget(pages[i]) ~= "SettingsPage" then pages[i] = wt.CreateSettingsPage(addon, pages[i]) end

		table.insert(category.pages, pages[i])

		---@diagnostic disable-next-line: undefined-field --REMOVE when replaced
		wt.RegisterSettingsPage(pages[i], parent, pages[i].categorySyncer.titleIcon) --REPLACE

		--Override defaults warning and add all defaults option to dialog
		wt.UpdatePopupDialog(pages[i].getResetPopupKey(), {
			text = wt.strings.settings.warning:gsub("#CATEGORY", cr(parentTitle, NORMAL_FONT_COLOR)):gsub(
				"#PAGE", cr(pages[i].title and pages[i].title:GetText() or "", NORMAL_FONT_COLOR)
			),
			accept = ALL_SETTINGS,
			alt = CURRENT_SETTINGS,
			onAccept = function() category.defaults(true) end,
			onAlt = function() pages[i].reset(true) end,
		})
	end end end

	return category
end

--[ Profiles ]

function wt.CreateProfilesPage(accountData, characterData, defaultData, settingsData, t, profilemanager)
	if type(settingsData) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	---@type typename_profilesPage
	local typename = "ProfilesPage"

	---@type typename_profilemanager
	local typenameBase = "Profilemanager"

	--[ Widget ]

	profilemanager = wt.IsWidget(profilemanager, typenameBase) and profilemanager or wt.CreateProfilemanager(accountData, characterData, defaultData, t)

	if not profilemanager then return nil end

	---@type profilesPage|profilemanager
	local profilesPage = profilemanager

	--[ Settings Page ]

	local onDefault = type(t.onDefault) == "function" and t.onDefault or nil

	profilesPage.settings = wt.CreateSettingsPage({
		register = t.register,
		name = t.name or "DataManagement",
		title = t.title or wt.strings.dataManagement.title,
		description = t.description or wt.strings.dataManagement.description:gsub("#ADDON", addonTitle),
		dataManagement = {
			category = addon,
			keys = { "Backup" },
		},
		onSave = t.onSave,
		onLoad = t.onLoad,
		onCancel = t.onCancel,
		onDefault = onDefault and function(user, category)
			if not category then profilesPage.reset() end

			onDefault(user, category)
		end or function(_, category) if not category then profilesPage.reset() end end,
		arrangement = {},
		initialize = function(canvas, _, _, category, keys) if not WidgetToolsDB.lite or t.lite == false then

			--[ Profiles ]

			local profilesPanel = wt.CreatePanel({
				parentFrame = canvas,
				name = "Profiles",
				title = wt.strings.profiles.title,
				description = wt.strings.profiles.description:gsub("#ADDON", addonTitle),
				arrange = {},
				arrangement = {},
				initialize = function(_, panel)
					local activate = wt.CreateDropdownRadiogroup({
						parentFrame = panel,
						title = wt.strings.profiles.select.label,
						tooltip = { lines = { { text = wt.strings.profiles.select.tooltip, }, } },
						arrange = {},
						width = 180,
						items = accountData.profiles,
						value = characterData.activeProfile,
						listeners = { changed = { { handler = function(_, index, user) profilesPage.activate(index, user) end, }, }, },
					})

					profilesPage.widgets = {
						activate = activate,
						create = wt.CreateButton({
							parentFrame = panel,
							name = "New",
							title = wt.strings.profiles.new.label,
							tooltip = { lines = { { text = wt.strings.profiles.new.tooltip, }, } },
							position = {
								anchor = "TOPRIGHT",
								offset = { x = -312, y = -21 }
							},
							size = { w = 112, h = 26 },
							action = function() profilesPage.create(nil, #accountData.profiles + 1, nil, nil, nil, true) end,
						}),
						duplicate = wt.CreateButton({
							parentFrame = panel,
							name = "Duplicate",
							title = wt.strings.profiles.duplicate.label,
							tooltip = { lines = { { text = wt.strings.profiles.duplicate.tooltip, }, } },
							position = {
								anchor = "TOPRIGHT",
								offset = { x = -192, y = -21 }
							},
							size = { w = 112, h = 26 },
							action = function() profilesPage.create(nil, nil, characterData.activeProfile, nil, nil, true) end,
						}),
						rename = wt.CreateButton({
							parentFrame = panel,
							name = "Rename",
							title = wt.strings.profiles.rename.label,
							tooltip = { lines = { { text = wt.strings.profiles.rename.tooltip, }, } },
							position = {
								anchor = "TOPRIGHT",
								offset = { x = -92, y = -21 }
							},
							size = { w = 92, h = 26 },
							action = function()
								local title = accountData.profiles[characterData.activeProfile].title

								wt.CreatePopupInputbox({
									title = wt.strings.profiles.rename.description:gsub("#PROFILE", crc(title, "FFFFFFFF")),
									position = {
										anchor = "TOPRIGHT",
										offset = { x = -92, y = -21 },
										relativeTo = panel,
									},
									text = title,
									accept = function(text) profilesPage.rename(nil, text, nil, true) end,
								})
							end,
						}),
						delete = wt.CreateButton({
							parentFrame = panel,
							name = "Delete",
							title = DELETE,
							tooltip = { lines = { { text = wt.strings.profiles.delete.tooltip, }, } },
							position = {
								anchor = "TOPRIGHT",
								offset = { x = -12, y = -21 }
							},
							size = { w = 72, h = 26 },
							action = function() profilesPage.delete(nil, nil, true) end,
							dependencies = { { dependency = activate, evaluate = function() return #accountData.profiles > 1 end }, }
						}),
					}

					--| UX

					--Update the activation widget UI based on profile data changes
					profilesPage.addListener.activated(function(_, index) profilesPage.widgets.activate.setValue(index, false, true) end)
					profilesPage.addListener.created(function() profilesPage.widgets.activate.updateItems(accountData.profiles) end)
					profilesPage.addListener.renamed(function() profilesPage.widgets.activate.updateItems(accountData.profiles) end)
					profilesPage.addListener.deleted(function() profilesPage.widgets.activate.updateItems(accountData.profiles) end)
					profilesPage.addListener.reset(function() profilesPage.widgets.activate.updateItems(accountData.profiles) end)
					profilesPage.addListener.loaded(function() profilesPage.widgets.activate.updateItems(accountData.profiles) end)
				end,
			})

			--[ Backup ]

			wt.CreatePanel({
				parentFrame = canvas,
				name = keys[1],
				title = wt.strings.backup.title,
				description = wt.strings.backup.description:gsub("#ADDON", addonTitle),
				arrange = {},
				size = { h = canvas:GetHeight() - profilesPanel.frame:GetHeight() - 118 },
				arrangement = { resize = false, },
				initialize = function(_, panel)

					--[ Active Profile ]

					local function refresh()
						profilesPage.backup.box.setValue(us.TableToString(profilesPage.data, settingsData.compactBackup))

						--Set focus after text change to set the scroll to the top and refresh the position character counter
						profilesPage.backup.box.scrollframe.EditBox:SetFocus()
						profilesPage.backup.box.scrollframe.EditBox:ClearFocus()
					end

					local box = wt.CreateMultilineEditbox({
						parentFrame = panel,
						name = "ImportExport",
						title = wt.strings.backup.box.label,
						tooltip = { lines = {
							{ text = wt.strings.backup.box.tooltip[1], },
							{ text = "\n" .. wt.strings.backup.box.tooltip[2], },
							{ text = "\n" .. wt.strings.backup.box.tooltip[3], },
							{ text = wt.strings.backup.box.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 }, },
							{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
						}, },
						arrange = {},
						size = { w = panel:GetWidth() - 24, h = panel:GetHeight() - 60 },
						font = { normal = "GameFontWhiteSmall", },
						scrollSpeed = 0.2,
						scrollToTop = false,
						unfocusOnEnter = false,
						dataManagement = {
							category = category,
							key = keys[1],
						},
						listeners = { loaded = { { handler = refresh, }, }, },
						showDefault = false,
					})

					local importPopup = wt.RegisterPopupDialog(addon .. "_IMPORT", {
						text = wt.strings.backup.warning,
						accept = wt.strings.backup.import,
						onAccept = function()
							local success, load = pcall(loadstring("return " .. wt.Clear(profilesPage.backup.box.getValue())))
							success = success and type(load) == "table"

							if success then
								profilesPage.validate(load, profilesPage.data)
								us.CopyValues(profilesPage.data, load)
							end

							t.onImport(success, load)
						end,
					})

					local load = wt.CreateButton({
						parentFrame = panel,
						name = "Load",
						title = wt.strings.backup.load.label,
						tooltip = { lines = {
							{ text = wt.strings.backup.load.tooltip, },
							{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
						} },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = box.frame,
							relativePoint = "BOTTOMRIGHT",
							offset = { y = -8 }
						},
						size = { h = 26 },
						action = function() StaticPopup_Show(importPopup) end,
					})

					profilesPage.backup = {
						refresh = refresh,
						box = box,
						compact = wt.CreateCheckbox({
							parentFrame = panel,
							name = "Compact",
							title = wt.strings.backup.compact.label,
							tooltip = { lines = { { text = wt.strings.backup.compact.tooltip, }, } },
							arrange = {},
							getData = function() return settingsData.compactBackup end,
							saveData = function(state) settingsData.compactBackup = state end,
							dataManagement = {
								category = addon,
								key = keys[1],
								onChange = { RefreshBackupBox = refresh },
							},
							listeners = { loaded = { { handler = function() profilesPage.backupAll.compact.frame:SetChecked(settingsData.compactBackup) end, }, }, },
							events = { OnClick = function(_, state) profilesPage.backupAll.compact.frame:SetChecked(state) end },
							showDefault = false,
							utilityMenu = false,
						}),
						load = load,
						reset = wt.CreateButton({
							parentFrame = panel,
							name = "Reset",
							title = RESET,
							tooltip = { lines = { { text = wt.strings.backup.reset.tooltip, }, } },
							position = {
								anchor = "RIGHT",
								relativeTo = load.widget,
								relativePoint = "LEFT",
								offset = { x = -8, }
							},
							size = { h = 26 },
							action = refresh,
						}),
					}

					--[ All Profiles ]

					local allProfilesBackupFrame = wt.CreatePanel({
						parentFrame = canvas:GetParent(),
						name = addon .. "AllProfilesBackup",
						append = false,
						title = wt.strings.backup.allProfiles.label,
						position = { anchor = "BOTTOMRIGHT", offset = { x = 4, y = -3 } },
						keepInBounds = true,
						size = { w = 685, h = 615 },
						frameStrata = "DIALOG",
						keepOnTop = true,
						background = { color = { a = 0.94 }, },
						arrangement = {
							margins = { l = 16, r = 16, t = 42, b = 16 },
							resize = false,
						},
						initialize = function(_, windowPanel)
							local function refreshAll()
								profilesPage.backupAll.box.setValue(us.TableToString({
									activeProfile = characterData.activeProfile,
									profiles = accountData.profiles
								}, settingsData.compactBackup))

								--Set focus after text change to set the scroll to the top and refresh the position character counter
								profilesPage.backupAll.box.scrollframe.EditBox:SetFocus()
								profilesPage.backupAll.box.scrollframe.EditBox:ClearFocus()
							end

							local boxAll = wt.CreateMultilineEditbox({
								parentFrame = windowPanel,
								name = "ImportExportAllProfiles",
								title = wt.strings.backup.allProfiles.label,
								label = false,
								tooltip = { lines = {
									{ text = wt.strings.backup.allProfiles.tooltipLine, },
									{ text = "\n" .. wt.strings.backup.box.tooltip[2], },
									{ text = "\n" .. wt.strings.backup.box.tooltip[3], },
									{ text = wt.strings.backup.box.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 }, },
									{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
								}, },
								arrange = {},
								size = { w = windowPanel:GetWidth() - 32, h = windowPanel:GetHeight() - 92 },
								font = { normal = "GameFontWhiteSmall", },
								scrollSpeed = 0.2,
								scrollToTop = false,
								unfocusOnEnter = false,
								dataManagement = {
									category = category,
									key = keys[1],
								},
								listeners = { loaded = { { handler = refreshAll, }, }, },
								showDefault = false,
							})

							local importPopupAll = wt.RegisterPopupDialog(addon .. "_IMPORT_ALL", {
								text = wt.strings.backup.warning,
								accept = wt.strings.backup.import,
								onAccept = function()
									local success, data = pcall(loadstring("return " .. wt.Clear(profilesPage.backupAll.box.getValue())))
									data = type(data) == "table" and data or {}

									if success then profilesPage.load(data.profiles, data.activeProfile, true) end

									t.onImportAllProfiles(success and type(data) == "table", data)
								end,
							})

							local loadAll = wt.CreateButton({
								parentFrame = windowPanel,
								name = "Load",
								title = wt.strings.backup.load.label,
								tooltip = { lines = {
									{ text = wt.strings.backup.load.tooltip, },
									{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
								} },
								position = {
									anchor = "TOPRIGHT",
									relativeTo = boxAll.frame,
									relativePoint = "BOTTOMRIGHT",
									offset = { y = -8 }
								},
								size = { h = 26 },
								action = function() StaticPopup_Show(importPopupAll) end,
							})

							profilesPage.backupAll = {
								refresh = refreshAll,
								box = boxAll,
								compact = wt.CreateCheckbox({
									parentFrame = windowPanel,
									name = "Compact",
									title = wt.strings.backup.compact.label,
									tooltip = { lines = { { text = wt.strings.backup.compact.tooltip, }, } },
									arrange = {},
									events = { OnClick = function()
										profilesPage.backup.compact.flip(true)
										refreshAll()
									end },
									showDefault = false,
									utilityMenu = false,
								}),
								load = loadAll,
								reset = wt.CreateButton({
									parentFrame = windowPanel,
									name = "Reset",
									title = RESET,
									tooltip = { lines = { { text = wt.strings.backup.reset.tooltip, }, } },
									position = {
										anchor = "RIGHT",
										relativeTo = loadAll.widget,
										relativePoint = "LEFT",
										offset = { x = -8, }
									},
									size = { h = 26 },
									action = refreshAll,
								})
							}

							wt.CreateButton({
								parentFrame = windowPanel,
								name = "CloseButton",
								title = CLOSE,
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -12, y = -12 },
								},
								size = { w = 96, },
								action = function() windowPanel:Hide() end,
							})

							_G[windowPanel:GetName() .. "Title"]:SetPoint("TOPLEFT", 18, -18)

							windowPanel:EnableMouse(true)
							windowPanel:Hide()
						end,
					})

					wt.CreateButton({
						parentFrame = panel,
						name = "AllProfilesButton",
						title = wt.strings.backup.allProfiles.open.label,
						tooltip = { lines = { { text = wt.strings.backup.allProfiles.open.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = profilesPage.backup.box.frame,
							relativePoint = "TOPRIGHT",
							offset = { x = -1, y = 2 }
						},
						size = { w = 100, h = 17 },
						frameLevel = profilesPage.backup.box.frame:GetFrameLevel() + 1, --Make sure it's on top to be clickable
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
						},
						action = function()
							allProfilesBackupFrame:Show()

							profilesPage.backupAll.compact.setValue(settingsData.compactBackup, nil, true)

							profilesPage.backupAll.refresh()
						end,
					})
				end,
			})
		end end,
	})

	--[ Initialization ]

	profilesPage.addType(typename)

	return profilesPage
end

--[ Addon ]

function wt.CreateAddonPage(t, addonmanager)
	t = type(t) == "table" and t or {}

	---@type typename_addonPage
	local typename = "AddonPage"

	---@type typename_addonmanager
	local typenameBase = "Addonmanager"

	--[ Widget ]

	---@type addonPage|addonmanager
	local addonPage = wt.IsWidget(addonmanager, typenameBase) and addonmanager or wt.CreateAddonmanager(t)

	if not addonPage then return nil end

	--[ Getters & Setters ]

	--Make unrebindable
	addonPage.setAddon = nil

	--[ Settings Page ]

	local title = addonPage.getTitle()

	addonPage.settings = wt.CreateSettingsPage({
		register = t.register,
		name = t.name or "About",
		title = t.title or title,
		description = t.description or addonPage.getNotes(),
		static = t.static ~= false,
		arrangement = {},
		initialize = function(canvas)

			--[ About ]

			wt.CreatePanel({
				parentFrame = canvas,
				name = "About",
				title = wt.strings.about.title,
				description = wt.strings.about.description:gsub("#ADDON", title),
				arrange = {},
				size = { h = 240 },
				arrangement = {
					flip = true,
					resize = false
				},
				initialize = function(_, panel, _, _, name)

					--[ Information ]

					local position = { offset = { x = 16, y = -14 } }

					local version = addonPage.getVersion()
					local date = addonPage.getDate()
					local category = addonPage.getCategory()
					local author = addonPage.getAuthor()
					local license = addonPage.getLicense()
					local curse = addonPage.getCurseForgeLink()
					local wago = addonPage.getWagoLink()
					local repo = addonPage.getRepositoryLink()
					local issues = addonPage.getIssuesLink()

					if version then
						local versionLabel = wt.CreateText({
							parentFrame = panel,
							name = "VersionTitle",
							position = position,
							width = 48,
							text = wt.strings.about.version,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
							wrap = false,
						})

						wt.CreateText({
							parentFrame = panel,
							name = "Version",
							position = {
								relativeTo = versionLabel,
								relativePoint = "TOPRIGHT",
								offset = { x = 5 }
							},
							width = 140,
							text = version .. date and (crc(" ( " .. wt.strings.about.date .. ": " .. cr(date, NORMAL_FONT_COLOR) .. ")", "FFFFFFFF") or ""),
							font = "GameFontNormalSmall",
							justify = { h = "LEFT", },
							wrap = false,
						})

						position.relativeTo = versionLabel
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -6
					end

					if category then
						local categoryLabel = wt.CreateText({
							parentFrame = panel,
							name = "CategoryTitle",
							position = position,
							width = 48,
							text = CATEGORY,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
							wrap = false,
						})

						wt.CreateText({
							parentFrame = panel,
							name = "Category",
							position = {
								relativeTo = categoryLabel,
								relativePoint = "TOPRIGHT",
								offset = { x = 5 }
							},
							width = 140,
							text = category,
							font = "GameFontNormalSmall",
							justify = { h = "LEFT", },
						})

						position.relativeTo = categoryLabel
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -6
					end

					if author then
						local authorLabel = wt.CreateText({
							parentFrame = panel,
							name = "AuthorTitle",
							position = position,
							width = 48,
							text = wt.strings.about.author,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
						})

						wt.CreateText({
							parentFrame = panel,
							name = "Author",
							position = {
								relativeTo = authorLabel,
								relativePoint = "TOPRIGHT",
								offset = { x = 5 }
							},
							width = 140,
							text = author,
							font = "GameFontNormalSmall",
							justify = { h = "LEFT", },
							wrap = false,
						})

						position.relativeTo = authorLabel
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -6
					end

					if license then
						local licenseLabel = wt.CreateText({
							parentFrame = panel,
							name = "LicenseTitle",
							position = position,
							width = 48,
							text = wt.strings.about.license,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
							wrap = false,
						})

						wt.CreateText({
							parentFrame = panel,
							name = "License",
							position = {
								relativeTo = licenseLabel,
								relativePoint = "TOPRIGHT",
								offset = { x = 5 }
							},
							width = 140,
							text = license,
							font = "GameFontNormalSmall",
							justify = { h = "LEFT", },
							wrap = false,
						})

						position.relativeTo = licenseLabel
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
					end

					--[ Links ]

					if position.relativeTo then position.offset.y = -14 end

					if curse then
						local curseLink = wt.CreateCopybox({
							parentFrame = panel,
							name = "CurseForge",
							title = wt.strings.about.curseForge,
							position = position,
							size = { w = 190, },
							value = curse,
						})

						position.relativeTo = curseLink.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if wago then
						local wagoLink = wt.CreateCopybox({
							parentFrame = panel,
							name = "Wago",
							title = wt.strings.about.wago,
							position = position,
							size = { w = 190, },
							value = wago,
						})

						position.relativeTo = wagoLink.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if repo then
						local repoLink = wt.CreateCopybox({
							parentFrame = panel,
							name = "Repository",
							title = wt.strings.about.repository,
							position = position,
							size = { w = 190, },
							value = repo,
						})

						position.relativeTo = repoLink.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if issues then wt.CreateCopybox({
						parentFrame = panel,
						name = "Issues",
						title = wt.strings.about.issues,
						position = position,
						size = { w = 190, },
						value = issues,
					}) end

					--[ Changelog ]

					local changelog, fullChangelog = addonPage.getChangelog()

					if not changelog then return end

					local changelogTextbox = wt.CreateMultilineEditbox({
						parentFrame = panel,
						name = "ChangelogBox",
						title = wt.strings.about.changelog.label,
						tooltip = { lines = { { text = wt.strings.about.changelog.tooltip:gsub("#VERSION", crc(version or "?", "FFFFFFFF")), }, } },
						arrange = {},
						size = { w = panel:GetWidth() - 225, h = panel:GetHeight() - 25 },
						font = { normal = "GameFontDisableSmall", },
						color = rs.colors.grey[1],
						value = changelog,
						readOnly = true,
					})

					if not fullChangelog then return end

					local fullChangelogFrame

					wt.CreateButton({
						parentFrame = panel,
						name = "ChangelogButton",
						title = wt.strings.about.fullChangelog.open.label,
						tooltip = { lines = { { text = wt.strings.about.fullChangelog.open.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = changelogTextbox.frame,
							relativePoint = "TOPRIGHT",
							offset = { x = -1, y = 2 }
						},
						size = { w = 100, h = 17 },
						frameLevel = changelogTextbox.frame:GetFrameLevel() + 1, --Make sure it's on top to be clickable
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
						},
						action = function() if fullChangelogFrame then fullChangelogFrame:Show() else fullChangelogFrame = wt.CreatePanel({
							parentFrame = canvas:GetParent(),
							name = name .. "FullChangelog",
							append = false,
							title = wt.strings.about.fullChangelog.label:gsub("#ADDON", title),
							position = { anchor = "BOTTOMRIGHT", offset = { x = 4, y = -3 } },
							keepInBounds = true,
							size = { w = 685, h = 615 },
							frameStrata = "DIALOG",
							keepOnTop = true,
							background = { color = { a = 0.94 }, },
							arrangement = {
								margins = { l = 16, r = 16, t = 42, b = 16 },
								resize = false,
							},
							initialize = function(_, windowPanel)
								wt.CreateMultilineEditbox({
									parentFrame = windowPanel,
									name = "Box",
									title = wt.strings.about.fullChangelog.label:gsub("#ADDON", title),
									label = false,
									tooltip = { lines = { { text = wt.strings.about.fullChangelog.tooltip, }, } },
									arrange = {},
									size = { w = windowPanel:GetWidth() - 32, h = windowPanel:GetHeight() - 58 },
									font = { normal = "GameFontDisable", },
									color = rs.colors.grey[1],
									value = fullChangelog,
									readOnly = true,
									scrollSpeed = 0.2,
								})

								wt.CreateButton({
									parentFrame = windowPanel,
									name = "CloseButton",
									title = CLOSE,
									position = {
										anchor = "TOPRIGHT",
										offset = { x = -12, y = -12 },
									},
									size = { w = 96, },
									action = function() windowPanel:Hide() end,
								})

								_G[windowPanel:GetName() .. "Title"]:SetPoint("TOPLEFT", 18, -18)

								windowPanel:EnableMouse(true)
							end,
						}) end end,
					})
				end,
			})

			--[ Sponsors ]

			local sponsors, topSponsors = addonPage.getSponsors():split("; ")

			if sponsors then
				local sponsorsPanel = wt.CreatePanel({
					parentFrame = canvas,
					name = "Sponsors",
					title = wt.strings.sponsors.title,
					description = wt.strings.sponsors.description,
					arrange = {},
					size = { h = 46 + (topSponsors and sponsors and 24 or 0) },
					initialize = function(_, panel)
						if topSponsors then wt.CreateText({
							parentFrame = panel,
							name = "Top",
							position = { offset = { x = 16, y = -12 } },
							width = panel:GetWidth() - 46,
							text = topSponsors,
							font = "GameFontNormalLarge",
							justify = { h = "LEFT", },
						}) end

						if sponsors then wt.CreateText({
							parentFrame = panel,
							name = "Normal",
							position = { offset = { x = 16, y = -16 -(topSponsors and 24 or 0) } },
							width = panel:GetWidth() - 46,
							text = sponsors,
							font = "GameFontNormalMed1",
							justify = { h = "LEFT", },
						}) end
					end,
				}).frame

				wt.CreateText({
					parentFrame = sponsorsPanel,
					name = "DescriptionHeart",
					position = {
						anchor = "TOPRIGHT",
						offset = { x = -14, y = -12 }
					},
					text = "♥",
					font = "NumberFont_Shadow_Large",
					color = { r = 1, g = 0.4, b = 0.4, }, 
					justify = { h = "LEFT", },
				})
			end
		end,
	})

	--[ Initialization ]

	addonPage.addType(typename)

	return addonPage
end