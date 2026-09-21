local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")] ---@type toolbox

if not wt then return end

local rs = WidgetTools.resources
local us = WidgetTools.utilities
local ds = WidgetTools.debugging

local cr = C_ColorUtil.WrapTextInColor
local crc = C_ColorUtil.WrapTextInColorCode


--[[ WIDGET ]]

local widget_base ---@type widget

local widget_types ---@type table<widget, table<typename_widget, true>>

local widget_handlers ---@type table<widget, table<string, fun(self: widget, ...: any)[]>>

local widget_parent ---@type table<widget, widget>
local widget_children ---@type table<widget, widget[]>
local widget_isIndependent ---@type table<widget, table<widget, boolean>>

local widget_enabled ---@type table<widget, boolean>

local widget_invoke_enabled ---@type fun(self: widget, user: boolean)
local widget_handlers_enabled ---@type table<widget, widget_handler_enabled[]>

local widget_dependencies ---@type table<widget, dependencyType[]>
local widget_dataDependency ---@type table<widget, table<dependencyType, true|function>>
local widget_dependencyEvaluator ---@type table<widget, table<dependencyType, dependencyEvaluator>>

local dataObjectScriptType = {
	CheckButton = "OnClick",
	EditBox = "OnTextChanged",
	Slider = "OnValueChanged",
}

local dataObjectValueGetterKeys = {
	CheckButton = "GetChecked",
	EditBox = "GetText",
	Slider = "GetValue",
}

---Widget class builder
---@return widget
local function buildWidget()
	local widget = {}

	--[ Type ]

	if not widget_types then widget_types = {} end

	local typename = "Widget" ---@type typename_widget

	widget_types[widget] = { [typename] = true }

	function widget:getTypes() return us.Clone(widget_types[self]) end
	function widget:isType(s) return widget_types[self][s] or false end

	--[ Meta ]

	widget.__metatable = "Protected base class"
	widget.__index = widget ---@cast widget widget

	--[ Events ]

	if not widget_handlers then widget_handlers = {} end

	function widget:addEvent(event)
		if not widget_handlers[self] then widget_handlers[self] = {} end
		if not widget_handlers[self][event] then widget_handlers[self][event] = {} end
	end

	function widget:invoke(event, ...)
		local handlers = widget_handlers[self][event]

		for i = 1, #handlers do handlers[i](self, ...) end
	end

	function widget:addListener(event, handler, callIndex)
		local handlers = widget_handlers[self][event]

		if not handlers or type(handler) ~= "function" then return end

		if type(callIndex) ~= "number" then table.insert(handlers, handler) else table.insert(handlers, Clamp(math.floor(callIndex), 1, #handlers + 1), handler) end
	end

	--[ Hierarchy ]

	--| Parent

	if not widget_parent then widget_parent = {} end

	function widget:getParent() return widget_parent[self] end
	function widget:setParent(newParent, independent, childIndex)
		local parent = widget_parent[self]

		if newParent == widget or newParent == parent then return false end

		if newParent == nil then
			widget_parent[self] = nil

			if parent and parent.hasChild(widget) then parent:removeChild(widget) end

			return true
		elseif wt.IsWidget(newParent) then
			widget_parent[self] = newParent

			if parent and parent:hasChild(widget) then parent:removeChild(widget) end
			if not newParent:hasChild(widget) then newParent:addChild(widget, independent, childIndex) end

			return true
		end

		return false
	end

	--| Children

	if not widget_children then widget_children = {} end
	if not widget_isIndependent then widget_isIndependent = {} end

	function widget:hasChild(child) return widget_isIndependent[self][child] ~= nil end
	function widget:getChild(index) return widget_children[self][index] end
	function widget:getChildren()
		local children = widget_children[self]
		local c = {}

		for i = 1, #children do c[i] = children[i] end

		return c
	end

	function widget:addChild(child, independent, index)
		if child == widget or not wt.IsWidget(child) or widget_isIndependent[self][child] ~= nil then return nil end

		local children = widget_children[self]

		index = type(index) ~= "number" and #children + 1 or Clamp(math.floor(index), 1, #children + 1)

		table.insert(children, index, child)
		widget_isIndependent[self][child] = independent == true

		if child:getParent() ~= widget then child:setParent(widget) end

		return index
	end

	function widget:removeChild(child)
		if widget_isIndependent[self][child] == nil then return end

		local children = widget_children[self]

		for i = 1, #children do if children[i] == child then table.remove(children, i) break end end
		widget_isIndependent[self][child] = nil

		if child:getParent() == widget then child:setParent(nil) end
	end

	function widget:isIndependent(child) return widget_isIndependent[self][child] end
	function widget:setIndependent(child, independent) if widget_isIndependent[self][child] ~= nil then widget_isIndependent[self][child] = independent ~= false end end

	--[ State ]

	if not widget_enabled then widget_enabled = {} end

	function widget:isEnabled() return widget_enabled[self] end
	function widget:setEnabled(state, ignoreParent, ignoreDependencies, user, silent)
		local parent = widget_parent[self]
		local children = widget_children[self]

		if ignoreParent ~= true and parent and not parent:isIndependent(widget) then state = parent:isEnabled() end

		if ignoreDependencies then widget_enabled[self] = state ~= false else widget_enabled[self] = state ~= false and widget:checkDependencies() end

		for i = 1, #children do if not widget_isIndependent[self][children[i]] then children[i]:setEnabled(state, true, false, user, silent) break end end

		if not silent then widget_invoke_enabled(self, user) end
	end

	--| Event

	if not widget_handlers_enabled then widget_handlers_enabled = {} end

	function widget:addListener_enabled(handler, callIndex)
		if type(handler) ~= "function" then return end

		local handlers = widget_handlers_enabled[self]

		if not handlers then
			handlers = {}
			widget_handlers_enabled[self] = handlers
		end

		if type(callIndex) ~= "number" then table.insert(handlers, handler) else table.insert(handlers, Clamp(math.floor(callIndex), 1, #handlers + 1), handler) end
	end

	if not widget_invoke_enabled then widget_invoke_enabled = function(self, user)
		local handlers = widget_handlers_enabled[self]

		if not handlers then return end

		local enabled = widget_enabled[self]
		user = user == true

		for i = 1, #handlers do handlers[i](self, enabled, user) end
	end end

	--| Dependencies

	if not widget_dependencies then widget_dependencies = {} end
	if not widget_dataDependency then widget_dataDependency = {} end
	if not widget_dependencyEvaluator then widget_dependencyEvaluator = {} end

	function widget:addDependency(rule)
		if type(rule) ~= "table" then return false end

		local dependencies = widget_dependencies[self]
		local data = widget_dataDependency[self]
		local evaluate = widget_dependencyEvaluator[self]

		if not dependencies then
			dependencies = {}
			widget_dependencies[self] = dependencies
		end

		if not data then
			data = {}
			widget_dataDependency[self] = data
		end

		if not evaluate then
			evaluate = {}
			widget_dependencyEvaluator[self] = evaluate
		end

		local dependency = rule.dependency
		local index = type(rule.index) ~= "number" and #dependencies + 1 or Clamp(math.floor(rule.index), 1, #dependencies + 1)
		local isData = rule.isData
		local evaluator = type(rule.evaluate) == "function" and rule.evaluate
		local setter = function() widget:setEnabled() end

		if wt.IsWidget(dependency) then
			if isData then if wt.IsWidget(dependency, "Datamanager") and (wt.IsWidget(dependency, "Binary") or evaluator) then
				dependency:addListener_loaded(function(_, success) if success then widget:setEnabled() end end)
				dependency:addListener_changed(setter)

				table.insert(dependencies, index, dependency)
				data[dependency] = true
				if evaluator then evaluate[dependency] = evaluator end

				return true
			end else
				dependency:addListener_enabled(setter)

				table.insert(dependencies, index, dependency)
				if evaluator then evaluate[dependency] = evaluator end

				return true
			end
		elseif us.IsFrame(dependency) then
			if isData then
				local objectType = dependency:GetObjectType()
				local scriptType = dataObjectScriptType[objectType]

				if scriptType then
					dependency:HookScript(scriptType, widget.setEnabled)

					table.insert(dependencies, index, dependency)
					data[dependency] = dependency[dataObjectValueGetterKeys[objectType]]
					if evaluator then evaluate[dependency] = evaluator end

					return true
				end
			elseif type(dependency.IsEnabled) == "function" and dependency:HasScript("OnEnable") and dependency:HasScript("OnDisable") then
				dependency:HookScript("OnEnable", widget.setEnabled)
				dependency:HookScript("OnDisable", widget.setEnabled)

				table.insert(dependencies, index, dependency)
				if evaluator then evaluate[dependency] = evaluator end

				return true
			end
		end

		return false
	end

	function widget:setDependencies(rules)
		widget_dependencies[self] = {}
		widget_dataDependency[self] = {}
		widget_dependencyEvaluator[self] = {}

		for i = 1, #rules do widget:addDependency(rules[i]) end
	end

	function widget:checkDependencies()
		local dependencies = widget_dependencies[self]

		if not dependencies then return true end

		local state = true

		for i = 1, #dependencies do
			local dependency = dependencies[i]
			local data = widget_dataDependency[self][dependency]
			local evaluate = widget_dependencyEvaluator[self][dependency]

			if data then
				local value

				if type(data) == "function" then value = data(dependency) else value = dependency:getValue() end

				if evaluate then state = evaluate(value) else state = value end
			else
				if wt.IsWidget(dependency) then state = dependency:isEnabled() else state = dependency:IsEnabled() end

				if evaluate then state = evaluate(state) end
			end

			if not state then break end
		end

		return state
	end

	ds.Log(function() return "Widget base constructed: " .. us.ToString(widget), wt.title .. ".buildWidget" end)

	return widget
end

--[ Constructors ]

function wt.CreateWidget(t)
	if not widget_base then widget_base = buildWidget() end

	local widget = setmetatable({}, widget_base) ---@cast widget widget

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	local listeners = t.listeners

	if type(listeners) == "table" then
		local enabled = listeners.enabled

		if type(enabled) == "table" then for i = 1, #enabled do
			local listener = enabled[i]

			if type(listener) == "table" then widget:addListener_enabled(listener.handler, listener.callIndex) end
		end end

		--Add custom events
		if type(listeners[1]) == "table" then for k, v in pairs(listeners[1]) do
			widget:addEvent(k)

			if type(v) == "table" then for i = 1, #v do if type(v[i]) == "table" then widget:addListener(k, v[i].handler, v[i].callIndex) end end end
		end end
	end

	if t.parent then widget:setParent(t.parent, t.independent, t.childIndex) end

	widget:setDependencies(t.dependencies)
	widget:setEnabled(t.disabled ~= true)

	ds.Log(function() return "Widget instance constructed: " .. us.ToString(widget) .. " with base: " .. us.ToString(widget_base), wt.title .. ".CreateWidget" end)

	return widget
end


--[[ CONTAINER ]]

--[ Constructors ]

---Set the parameters of a GUI container frame
---@param container container|customContainer
---@param frame Frame
---@param t container_options|customContainer_options
local function setUpContainer(container, frame, t)

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

	--| Events & attributes

	wt.RegisterScriptEvents(frame, t.events)
	wt.RegisterGlobalEvents(frame, t.onEvent)
	wt.RegisterAttributes(frame, t.attributes)

	--[ Initialization ]

	--Add content, performs tasks
	if type(t.initialize) == "function" then
		t.initialize(container, frame, t.size.w, t.size.h, t.name or "Panel")

		--Arrange content
		if t.arrangement then wt.ArrangeContent(frame, t.arrangement) end
	end
end

function wt.CreateContainer(t, widget) --Lite GUI
	t = type(t) == "table" and t or {}

	local typenameBase = "Widget" ---@type typename_widget

	widget = wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t)

	if WidgetToolsDB.lite and t.lite ~= false then return widget end

	local container = widget ---@cast container container

	--[ Type ]

	local typename = "Container" ---@type typename_container

	widget_types[container][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	local frame = CreateFrame("Frame", name, t.parentFrame)

	container.frame = frame

	--| Shared setup

	setUpContainer(container, frame, t)

	ds.Log(function() return "Widget instance mutated into Container GUI instance: " .. us.ToString(container), wt.title .. ".CreateContainer" end)

	return container
end

function wt.CreateCustomContainer(t, widget) --Lite GUI
	t = type(t) == "table" and t or {}

	local typenameBase = "Widget" ---@type typename_widget

	widget = wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t)

	if WidgetToolsDB.lite and t.lite ~= false then return widget end

	local container = widget ---@cast container customContainer

	--[ Type ]

	local typename = "CustomContainer" ---@type typename_customContainer

	widget_types[container][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	local frame = CreateFrame("Frame", name, t.parentFrame, BackdropTemplateMixin and "BackdropTemplate")

	container.frame = frame

	--| Shared setup

	setUpContainer(container, frame, t)

	ds.Log(function() return "Widget instance mutated into CustomContainer GUI instance: " .. us.ToString(container), wt.title .. ".CreateCustomContainer" end)

	return container
end

--| Panel

function wt.CreatePanel(t, container) --Lite GUI
	t = type(t) == "table" and t or {}

	local typenameBase = "CustomContainer" ---@type typename_customContainer

	container = wt.IsWidget(container, typenameBase) and container or wt.CreateCustomContainer(t)

	if WidgetToolsDB.lite and t.lite ~= false then return container end

	local panel = container ---@cast panel panel

	--[ Type ]

	local typename = "Panel" ---@type typename_panel

	widget_types[panel][typename] = true

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

	ds.Log(function() return "CustomContainer GUI instance mutated into Panel GUI instance: " .. us.ToString(panel), wt.title .. ".CreatePanel" end)

	return panel
end


--[[ ACTION ]]

local action_base ---@type action

local action_call ---@type table<action, fun(self: action, user?: boolean)>

local action_invoke_triggered ---@type fun(self: action, user: boolean)
local action_handlers_triggered ---@type table<action, action_handler_triggered[]>

local function buildAction()
	local action = buildWidget() ---@cast action action

	--[ Type ]

	local typename = "Action" ---@type typename_action

	widget_types[action][typename] = true

	--[ Action ]

	if not action_call then action_call = {} end

	function action:trigger(user, silent)
		local call = action_call[self]

		if call and widget_enabled[self] then call(action, user) end

		if not silent then action_invoke_triggered(self, user) end
	end

	function action:setAction(call) if type(call) == "function" then action_call[self] = call end end

	--| Event

	if not action_handlers_triggered then action_handlers_triggered = {} end

	function action:addListener_triggered(handler, callIndex)
		if type(handler) ~= "function" then return end

		local handlers = action_handlers_triggered[self]

		if not handlers then
			handlers = {}
			action_handlers_triggered[self] = handlers
		end

		if type(callIndex) ~= "number" then table.insert(handlers, handler) else table.insert(handlers, Clamp(math.floor(callIndex), 1, #handlers + 1), handler) end
	end

	if not action_invoke_triggered then action_invoke_triggered = function(self, user)
		local handlers = action_handlers_triggered[self]

		if not handlers then return end

		user = user == true

		for i = 1, #handlers do handlers[i](self, user) end
	end end

	ds.Log(function() return "Widget base mutated into Action base: " .. us.ToString(action), wt.title .. ".buildAction" end)

	return action
end

--[ Constructors ]

function wt.CreateAction(t, widget)
	if not action_base then action_base = buildAction() end

	local typenameBase = "Widget" ---@type typename_widget

	local action = setmetatable(wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t), action_base) ---@cast action action

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	local listeners = t.listeners

	if type(listeners) == "table" then
		local triggered = listeners.triggered

		if type(triggered) == "table" then for i = 1, #triggered do
			local listener = triggered[i]

			if type(listener) == "table" then action:addListener_triggered(listener.handler, listener.callIndex) end
		end end
	end

	action:setAction(t.action)

	ds.Log(function() return "Widget instance mutated into Action instance: " .. us.ToString(action) .. " with base: " .. action_base, wt.title .. ".CreateAction" end)

	return action
end

--| Button

---Set the parameters of a GUI button widget frame
---@param button actionButton|customButton
---@param t actionButton_options|customButton_options
---@param name string
---@param title string
---@param useHighlight boolean
local function setUpButton(button, frame, t, name, title, useHighlight)
	local label = button.label
	local fontNormal, fontDisabled, fontHighlight = t.font.normal, t.font.disabled, t.font.highlight

	--| Position & dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or 80
	t.size.h = t.size.h or 22
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(frame, t.position) end
	wt.SetArrangementDirective(frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	frame:SetSize(t.size.w, t.size.h)

	--| Visibility

	wt.SetVisibility(frame, t.visible ~= false)

	if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

	--| Highlight

	local highlight = CreateFrame("Frame", name .. "Highlight", frame)

	button.highlight = highlight

	highlight:SetPoint("TOPLEFT")
	highlight:SetSize(frame:GetSize())

	--[ Events ] --REPLACE script events

	--Register script event handlers
	if t.events then for event, listener in pairs(t.events) do
		if event == "attribute" then frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == listener.name then listener.handler(...) end end)
		else frame:HookScript(event, listener) end
	end end

	--[ UX ]

	frame:HookScript("OnClick", function(_, mouseButton)
		if mouseButton ~= "LeftButton" or not frame:IsEnabled() then return end

		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

		button:trigger(true)
	end)

	--| Link mouse interactions

	highlight:HookScript("OnEnter", function() if frame:IsEnabled() then
		frame:LockHighlight()
		if IsMouseButtonDown("LeftButton") then frame:SetButtonState("PUSHED") end
		if label and useHighlight then label:SetFontObject(fontHighlight) end
	end end)

	highlight:HookScript("OnLeave", function() if frame:IsEnabled() then
		frame:UnlockHighlight()
		frame:SetButtonState("NORMAL")
		if label and useHighlight then label:SetFontObject(fontNormal) end
	end end)

	highlight:HookScript("OnMouseDown", function(_, b) if frame:IsEnabled() and b == "LeftButton" then
		frame:SetButtonState("PUSHED")
	end end)

	highlight:HookScript("OnMouseUp", function(_, b, isInside) if frame:IsEnabled() then
		frame:SetButtonState("NORMAL")

		if isInside and b == "LeftButton" then frame:Click(b) end
	end end)

	--| Tooltip

	if type(t.tooltip) == "table" then wt.AddTooltip(highlight, {
		title = t.tooltip.title or title,
		lines = t.tooltip.lines,
		anchor = "ANCHOR_TOPLEFT",
		offset = { x = 20, },
	}, { triggers = { highlight, }, }) end

	--[ State Update ]

	---Update the widget UI based on its enabled state
	---@param _ actionButton
	---@param state boolean
	local function updateState(_, state)
		frame:SetEnabled(state)

		if label then if state then
			if useHighlight and frame:IsMouseOver() then label:SetFontObject(fontHighlight) else label:SetFontObject(fontNormal) end
		else label:SetFontObject(fontDisabled) end end
	end

	updateState(button, widget_enabled[button])

	button:addListener_enabled(updateState, 1)
end

function wt.CreateButton(t, action) --Lite GUI
	t = type(t) == "table" and t or {}

	local typenameBase = "Action" ---@type typename_action

	action = wt.IsWidget(action, typenameBase) and action or wt.CreateAction(t)

	if WidgetToolsDB.lite and t.lite ~= false then return action end

	local button = action ---@cast button actionButton

	--[ Type ]

	local typename = "Button" ---@type typename_button

	widget_types[button][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	local frame = CreateFrame("Button", name, t.parentFrame, "UIPanelButtonTemplate")

	button.frame = frame

	--| Label

	local customFonts = t.font ~= nil
	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontNormal"
	t.font.highlight = t.font.highlight or "GameFontHighlight"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	if t.label ~= false then
		if customFonts then
			button.label = wt.CreateText({
				parentFrame = frame,
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

	setUpButton(button, frame, t, name, title, t.font.highlight ~= nil)

	ds.Log(function() return "Action instance mutated into Button GUI instance: " .. us.ToString(button), wt.title .. ".CreateButton" end)

	return button
end

function wt.CreateCustomButton(t, action) --Lite GUI
	t = type(t) == "table" and t or {}

	local typenameBase = "Action" ---@type typename_action

	action = wt.IsWidget(action, typenameBase) and action or wt.CreateAction(t)

	if WidgetToolsDB.lite and t.lite ~= false then return action end

	local button = action ---@cast button customButton

	--[ Type ]

	local typename = "CustomButton" ---@type typename_customButton

	widget_types[button][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	local frame = CreateFrame("Button", name, t.parentFrame, BackdropTemplateMixin and "BackdropTemplate")

	button.frame = frame

	--| Label

	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontNormal"
	t.font.highlight = t.font.highlight or "GameFontHighlight"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	if t.label ~= false then
		button.label = wt.CreateText({
			parentFrame = button.frame,
			name = "Label",
			position = { anchor = "CENTER", },
			width = t.size.w,
			font = t.font.normal,
		})

		if t.titleOffset then button.label:SetPoint("CENTER", t.titleOffset.x or 0, t.titleOffset.y or 0) end

		button.label:SetText(title)
	end

	--| Shared setup

	setUpButton(button, frame, t, name, title, true)

	--| Backdrop

	if type(t.backdropUpdates) == "table" then for i = 1, #t.backdropUpdates do
		if type(t.backdropUpdates[i].triggers) ~= "table" then t.backdropUpdates[i].triggers = {} end
		table.insert(t.backdropUpdates[i].triggers, button.highlight)
	end end

	wt.SetBackdrop(button.frame, t.backdrop, t.backdropUpdates)

	ds.Log(function() return "Action instance mutated into CustomButton GUI instance: " .. us.ToString(button), wt.title .. ".CreateCustomButton" end)

	return button
end


--[[ DATAMANAGER ]]

wt.clipboard = {}

local datamanager_base ---@type datamanager

local data_default ---@type table<datamanager, any>
local data_value ---@type table<datamanager, any>
local data_snapshot ---@type table<datamanager, any>

local datamanager_read ---@type table<datamanager, fun(): data: any>
local datamanager_write ---@type table<datamanager, fun(data: any)>
local datamanager_instantSave ---@type table<datamanager, boolean?>

local datamanagement ---@type table<datamanager, settingsData>

local datamanager_invoke_loaded ---@type fun(self: datamanager, user: boolean)
local datamanager_invoke_saved ---@type fun(self: datamanager, user: boolean)
local datamanager_invoke_changed ---@type fun(self: datamanager, user: boolean)
local datamanager_handlers_loaded ---@type table<datamanager, datamanager_handler_loaded[]>
local datamanager_handlers_saved ---@type table<datamanager, datamanager_handler_saved[]>
local datamanager_handlers_changed ---@type table<datamanager, datamanager_handler_changed[]>

local function buildDatamanager()
	local datamanager = buildWidget() ---@cast datamanager datamanager

	--[ Type ]

	local typename = "Datamanager" ---@type typename_datamanager

	widget_types[datamanager][typename] = true

	--[ Data ]

	if not datamanagement then datamanagement = {} end

	if not data_value then data_value = {} end

	function datamanager:verify(value) if value == nil then return us.Clone(data_value[self]) else return us.Clone(value) end end
	function datamanager:format(value) return us.ToString(datamanager:verify(value)) end

	function datamanager:getValue() return data_value[self] end
	function datamanager:setValue(value, user, silent)
		data_value[self] = datamanager:verify(value)

		if data_value[self] == nil and datamanager_read[self] then data_value[self] = datamanager_read[self]() end
		if data_value[self] == nil then data_value[self] = data_default[self] end

		if user then
			if datamanager_instantSave[self] then datamanager:save(silent) end

			local management = datamanagement[self]

			if management then wt.HandleWidgetChanges(management.index, management.category, management.key) end
		end

		if not silent then datamanager_invoke_changed(self, user) end
	end

	if not datamanager_invoke_changed then datamanager_invoke_changed = function(self, user)
		local handlers = datamanager_handlers_changed[self]

		if not handlers then return end

		local value = data_value[self]
		user = user == true

		for i = 1, #handlers do handlers[i](self, value, user) end
	end end

	--| Storage

	if not datamanager_read then datamanager_read = {} end
	if not datamanager_write then datamanager_write = {} end

	function datamanager:setReader(read)
		datamanager_read[self] = type(read) == "function" and read or nil

		datamanager:load()
	end
	function datamanager:setWriter(write)
		datamanager_write[self] = type(write) == "function" and write or nil

		datamanager:load()
	end

	function datamanager:load(handleChanges, silent)
		local read = datamanager_read[self]

		if read then
			datamanager:setValue(read(), handleChanges ~= false, silent)

			if not silent then datamanager_invoke_loaded(self, true) end
		elseif not silent then datamanager_invoke_loaded(self, false) end
	end
	function datamanager:save(silent)
		local write = datamanager_write[self]

		if write then
			write(data_value[self])

			if not silent then datamanager_invoke_saved(self, true) end
		elseif not silent then datamanager_invoke_saved(self, false) end
	end

	function datamanager:getData()
		local read = datamanager_read[self]

		if read then return read[self]() end
	end
	function datamanager:setData(data, handleChanges, silent)
		local write = datamanager_write[self]

		if write then
			write(datamanager:verify(data))

			if not silent then datamanager_invoke_saved(self, true) end
		elseif not silent then datamanager_invoke_saved(self, false) end

		datamanager:load(handleChanges, silent)
	end

	function datamanager:setInstantSave(instantSave) datamanager_instantSave[self] = instantSave ~= false and true or nil end

	if not datamanager_invoke_loaded then datamanager_invoke_loaded = function(self, success)
		local handlers = datamanager_handlers_loaded[self]

		if not handlers then return end

		success = success == true

		for i = 1, #handlers do handlers[i](self, success) end
	end end

	if not datamanager_invoke_saved then datamanager_invoke_saved = function(self, success)
		local handlers = datamanager_handlers_saved[self]

		if not handlers then return end

		success = success == true

		for i = 1, #handlers do handlers[i](self, success) end
	end end

	--| Default

	if not data_default then data_default = {} end

	function datamanager:getDefault() return data_default[self] end
	function datamanager:setDefault(newDefault) data_default[self] = datamanager:verify(newDefault) end
	function datamanager:reset(handleChanges, silent) datamanager:setData(data_default[self], handleChanges, silent) end

	--| Snapshot

	if not data_snapshot then data_snapshot = {} end

	function datamanager:snapshot(stored) if stored == true then data_snapshot[self] = datamanager:getData() else data_snapshot[self] = data_value[self] end end
	function datamanager:revert(handleChanges, silent) datamanager:setData(data_snapshot[self], handleChanges, silent) end

	ds.Log(function() return "Widget base mutated into Datamanager base: " .. us.ToString(datamanager), wt.title .. ".buildDatamanager" end)

	return datamanager
end

--[ Constructors ]

function wt.CreateDatamanager(t, widget)
	if not datamanager_base then datamanager_base = buildDatamanager() end

	local typenameBase = "Widget" ---@type typename_widget

	local datamanager = setmetatable(wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t), datamanager_base) ---@cast datamanager datamanager

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	local data = type(t.data) == "table" and t.data or {}

	datamanager:setReader(data.read)
	datamanager:setWriter(data.write)

	datamanager:setInstantSave(data.instantSave)

	datamanager:setDefault(t.default)
	datamanager:setValue(t.value)
	datamanager:snapshot()

	--| Datamanagement

	datamanagement[datamanager] = t.dataManagement or nil

	if datamanagement[datamanager] then wt.AddSettingsDataManagementEntry(datamanager, datamanagement[datamanager]) end --TODO update

	ds.Log(function() return
		"Widget instance mutated into Datamanager instance: " .. us.ToString(datamanager) .. " with base: " .. us.ToString(datamanager_base),
		wt.title .. ".CreateDatamanager"
	end)

	return datamanager
end


--[[ BINARY ]]

local binary_base ---@type binary

local function buildBinary()
	local binary = buildDatamanager() ---@cast binary binary

	--[ Type ]

	local typename = "Binary" ---@type typename_binary

	widget_types[binary][typename] = true

	--[ Data ]

	function binary:verify(value) return value == true end
	function binary:format(state)
		if type(state) ~= "boolean" then state = binary:getValue() end

		return crc((state and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), state and "FFAAAAFF" or "FFFFAA66")
	end

	function binary:flip(user, silent) binary:setValue(not binary:getValue(), user, silent) end

	return binary
end

--[ Constructors ]

function wt.CreateBinary(t, datamanager)
	if not binary_base then binary_base = buildBinary() end

	local typenameBase = "Datamanager" ---@type typename_datamanager

	local binary = setmetatable(wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t), binary_base) ---@cast binary binary

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	local data = type(t.data) == "table" and t.data or {}

	binary:setReader(data.read)
	binary:setWriter(data.write)

	binary:setDefault(t.default)
	binary:setValue(t.value)
	binary:snapshot()

	ds.Log(function() return
		"Datamanager instance mutated into Binary instance:" .. us.ToString(binary) .. " with base: " .. us.ToString(binary_base),
		wt.title .. ".CreateBinary"
	end)

	return binary
end

--| Toggle button

function wt.CreateCheckbox(t, binary) --Lite GUI
	t = type(t) == "table" and t or {}

	local typenameBase = "Binary" ---@type typename_binary

	binary = wt.IsWidget(binary, typenameBase) and binary or wt.CreateBinary(t)

	if WidgetToolsDB.lite and t.lite ~= false then return binary end

	local checkbox = binary ---@cast checkbox checkbox

	--[ Type ]

	local typename = "Checkbox" ---@type typename_checkbox

	widget_types[checkbox][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	local frame = CreateFrame("Frame", name, t.parentFrame)
	local template = CreateFrame("CheckButton", name .. typename, frame, "SettingsCheckboxTemplate")

	checkbox.frame = frame
	checkbox.template = template

	--| Position & dimensions

	t.size = t.size or {}
	t.size.h = t.size.h or template:GetHeight()
	t.size.w = t.label == false and t.size.h * (30 / 29) or t.size.w or 190

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(frame, t.position) end
	wt.SetArrangementDirective(frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	template:SetPoint("LEFT")
	wt.SetPosition(template.HoverBackground, {
		anchor = "LEFT",
		offset = { x = -2, },
	})

	frame:SetSize(t.size.w, t.size.h)
	template:SetSize(t.size.h * (30 / 29), t.size.h)
	template.HoverBackground:SetSize(t.size.w + 2, t.size.h)

	--| Visibility

	wt.SetVisibility(frame, t.visible ~= false)

	if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

	--| Label

	t.font = t.font or {}
	local fontNormal = t.font.normal or "GameFontNormal"
	local fontHighlight = t.font.highlight or "GameFontHighlight"
	local fontDisabled = t.font.disabled or "GameFontDisable"

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	checkbox.label = t.label ~= false and wt.CreateTitle(frame, {
		offset = { x = t.size.h * (30 / 29) + 6, },
		text = title,
		anchor = "LEFT",
		font = fontNormal,
	}) or nil

	--| Texture

	template:GetPushedTexture():SetVertexColor(.6, .6, .6, 1)

	--[ Events ] --REPLACE script events

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then template:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnClick" then template:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
		else template:HookScript(key, value) end
	end end

	--[ Value Update ]

	---Update the widget UI based on the logical state
	---@param _ any
	---@param state boolean
	local function updateBinaryState(_, state) template:SetChecked(state) end

	updateBinaryState(nil, data_value[checkbox])

	checkbox:addListener_changed(updateBinaryState, 1)

	--[ UX ]

	template:HookScript("OnClick", function(self)
		local state = self:GetChecked()

		PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

		checkbox:setValue(state, true)
	end)

	--| Link mouse interactions

	frame:HookScript("OnEnter", function() if template:IsEnabled() then
		template.HoverBackground:Show()
		if IsMouseButtonDown("LeftButton") then template:SetButtonState("PUSHED") end
	end end)

	frame:HookScript("OnLeave", function() if template:IsEnabled() then
		template.HoverBackground:Hide()
		template:SetButtonState("NORMAL")
	end end)

	frame:HookScript("OnMouseDown", function(_, button) if template:IsEnabled() and button == "LeftButton" or (button == "RightButton") then
		template:SetButtonState("PUSHED")
	end end)

	frame:HookScript("OnMouseUp", function(_, button, isInside) if template:IsEnabled() then
		template:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" then template:Click(button) end
	end end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(template, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_NONE",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = template,
				relativePoint = "TOPRIGHT",
			},
		}, { triggers = { frame, }, })

		wt.AddWidgetTooltipLines({ template }, t.showDefault ~= false and checkbox:format(data_default[checkbox]), t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = frame,
				condition = checkbox.isEnabled,
			},
			{
				frame = template,
				condition = checkbox.isEnabled,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.binary = checkbox:getValue() end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() checkbox:setValue(wt.clipboard.binary, true) end
			}):SetEnabled(wt.clipboard.binary ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() checkbox:revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() checkbox:reset() end }) end
		end
	}) end

	--[ State Update ]

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		template:SetEnabled(state)
		template:EnableMouse(state)

		if checkbox.label then checkbox.label:SetFontObject(state and fontNormal or fontDisabled) end
	end

	updateState(nil, widget_enabled[checkbox])

	checkbox:addListener_enabled(updateState, 1)

	return checkbox
end

---Set the parameters of a classic GUI binary widget frame
---@param binary checkbox|classicCheckbox|radiobutton
---@param template CheckButton|SettingsCheckbox
---@param frame Frame
---@param title string
---@param t checkbox_options
local function setUpClassicToggle(binary, template, frame, title, t)

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(frame, t.position) end
	wt.SetArrangementDirective(frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	template:SetPoint("LEFT", (t.size.h - 16) / 2, 0)

	frame:SetSize(t.size.w, t.size.h)
	template:SetSize(16, 16)

	--| Visibility

	wt.SetVisibility(frame, t.visible ~= false)

	if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

	--Update the frame order
	frame:SetFrameLevel(frame:GetFrameLevel() + 1)
	template:SetFrameLevel(template:GetFrameLevel() - 2)

	--[ Events ] --REPLACE script events

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then template:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnClick" then template:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
		else template:HookScript(key, value) end
	end end

	--[ Value Update ]

	---Update the widget UI based on the logical state
	---@param _ any
	---@param state boolean
	local function updateBinaryState(_, state) template:SetChecked(state) end

	updateBinaryState(nil, data_value[binary])

	binary:addListener_changed(updateBinaryState, 1)

	--[ UX ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_NONE",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = template,
				relativePoint = "TOPRIGHT",
			},
		}, { triggers = { template, }, })

		wt.AddWidgetTooltipLines({ frame }, t.showDefault ~= false and binary.format(binary.getDefault()), t.utilityMenu)
	end

	--| Utility menu

	local function isEnabled() return widget_enabled[binary] end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = frame,
				condition = isEnabled,
			},
			{
				frame = template,
				condition = isEnabled,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.binary = binary.getValue() end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() binary.setValue(wt.clipboard.binary, true) end
			}):SetEnabled(wt.clipboard.binary ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() binary:revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() binary:reset() end }) end
		end
	}) end
end

function wt.CreateClassicCheckbox(t, binary) --Lite GUI
	t = type(t) == "table" and t or {}

	local typenameBase = "Binary" ---@type typename_binary

	binary = wt.IsWidget(binary, typenameBase) and binary or wt.CreateBinary(t)

	if WidgetToolsDB.lite and t.lite ~= false then return binary end

	local checkbox = binary ---@cast checkbox classicCheckbox

	--[ Type ]

	local typename = "ClassicCheckbox" ---@type typename_classicCheckbox

	widget_types[checkbox][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	local frame = CreateFrame("Frame", name, t.parentFrame)
	local template = CreateFrame("CheckButton", name .. typename, frame, "InterfaceOptionsCheckButtonTemplate")

	checkbox.frame = frame
	checkbox.template = template

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	if t.label ~= false then
		checkbox.label = _G[name .. "CheckboxText"]

		checkbox.label:SetPoint("LEFT", template, "RIGHT", 2, 0)
		checkbox.label:SetFontObject("GameFontHighlight")

		checkbox.label:SetText(title)
	else _G[name .. "CheckboxText"]:Hide() end

	--| Shared setup

	t.size = t.size or {}
	t.size.h = t.size.h or 26
	t.size.w = t.label == false and t.size.h or t.size.w or 180

	setUpClassicToggle(checkbox, template, frame, title, t)

	--[ UX ]

	template:HookScript("OnClick", function(self)
		local state = self:GetChecked()

		PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

		checkbox.setValue(state, true)
	end)

	--| Link mouse interactions

	frame:HookScript("OnEnter", function() if template:IsEnabled() then
		template:LockHighlight()
		if IsMouseButtonDown("LeftButton") or (IsMouseButtonDown("RightButton")) then template:SetButtonState("PUSHED") end
	end end)

	frame:HookScript("OnLeave", function() if template:IsEnabled() then
		template:UnlockHighlight()
		template:SetButtonState("NORMAL")
	end end)

	frame:HookScript("OnMouseDown", function(_, button) if template:IsEnabled() and button == "LeftButton" or (button == "RightButton") then
		template:SetButtonState("PUSHED")
	end end)

	frame:HookScript("OnMouseUp", function(_, button, isInside) if template:IsEnabled() then
		template:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" or (button == "RightButton") then template:Click(button) end
	end end)

	--[ State Update ]

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		template:SetEnabled(state)

		if checkbox.label then checkbox.label:SetFontObject(state and "GameFontHighlight" or "GameFontDisable") end
	end

	updateState(nil, widget_enabled[checkbox])

	checkbox:addListener_enabled(updateState, 1)

	return checkbox
end

function wt.CreateRadiobutton(t, binary) --Lite GUI
	t = type(t) == "table" and t or {}

	local typenameBase = "Binary" ---@type typename_binary

	binary = wt.IsWidget(binary, typenameBase) and binary or wt.CreateBinary(t)

	if WidgetToolsDB.lite and t.lite ~= false then return binary end

	local radiobutton = binary ---@cast radiobutton radiobutton

	--[ Type ]

	local typename = "Radiobutton" ---@type typename_radiobutton

	widget_types[radiobutton][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	local frame = CreateFrame("Frame", name, t.parentFrame)
	local template = CreateFrame("CheckButton", name .. typename, frame, "UIRadioButtonTemplate")

	radiobutton.frame = frame
	radiobutton.template = template

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	if t.label ~= false then
		radiobutton.label = _G[name .. "RadioButtonText"]

		radiobutton.label:SetPoint("LEFT", template, "RIGHT", 3, 0)
		radiobutton.label:SetFontObject("GameFontNormal")

		radiobutton.label:SetText(title)
	else _G[name .. "RadioButtonText"]:Hide() end

	--| Shared setup

	t.size = t.size or {}
	t.size.h = t.size.h or 18
	t.size.w = t.label == false and t.size.h or t.size.w or 180

	setUpClassicToggle(radiobutton, template, frame, title, t)

	--[ UX ]

	local clearable = t.clearable

	template:HookScript("OnClick", function(_, button)
		if button == "LeftButton" then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

			radiobutton.setValue(true, true)
		elseif clearable and button == "RightButton" then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

			radiobutton.setValue(false, true)
		end
	end)

	--| Link mouse interactions

	frame:HookScript("OnEnter", function() if template:IsEnabled() then
		template:LockHighlight()
		if IsMouseButtonDown("LeftButton") or (clearable and IsMouseButtonDown("RightButton")) then template:SetButtonState("PUSHED") end
	end end)

	frame:HookScript("OnLeave", function() if template:IsEnabled() then
		template:UnlockHighlight()
		template:SetButtonState("NORMAL")
	end end)

	frame:HookScript("OnMouseDown", function(_, button) if template:IsEnabled() and button == "LeftButton" or (clearable and button == "RightButton") then
		template:SetButtonState("PUSHED")
	end end)

	frame:HookScript("OnMouseUp", function(_, button, isInside) if template:IsEnabled() then
		template:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" or (clearable and button == "RightButton") then template:Click(button) end
	end end)

	--[ State Update ]

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		template:SetEnabled(state)

		if radiobutton.label then radiobutton.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
	end

	updateState(nil, widget_enabled[radiobutton])

	radiobutton:addListener_enabled(updateState, 1)

	return radiobutton
end


--[[ SELECTOR ]]

local itemsets = {
	anchor = {
		{ name = wt.strings.points.top.left, value = "TOPLEFT" },
		{ name = wt.strings.points.top.center, value = "TOP" },
		{ name = wt.strings.points.top.right, value = "TOPRIGHT" },
		{ name = wt.strings.points.left, value = "LEFT" },
		{ name = wt.strings.points.center, value = "CENTER" },
		{ name = wt.strings.points.right, value = "RIGHT" },
		{ name = wt.strings.points.bottom.left, value = "BOTTOMLEFT" },
		{ name = wt.strings.points.bottom.center, value = "BOTTOM" },
		{ name = wt.strings.points.bottom.right, value = "BOTTOMRIGHT" },
	},
	justifyH = {
		{ name = wt.strings.points.left, value = "LEFT" },
		{ name = wt.strings.points.center, value = "CENTER" },
		{ name = wt.strings.points.right, value = "RIGHT" },
	},
	justifyV = {
		{ name = wt.strings.points.top.center, value = "TOP" },
		{ name = wt.strings.points.center, value = "MIDDLE" },
		{ name = wt.strings.points.bottom.center, value = "BOTTOM" },
	},
	strata = {
		{ name = wt.strings.strata.lowest, value = "BACKGROUND" },
		{ name = wt.strings.strata.lower, value = "LOW" },
		{ name = wt.strings.strata.low, value = "MEDIUM" },
		{ name = wt.strings.strata.lowMid, value = "HIGH" },
		{ name = wt.strings.strata.highMid, value = "DIALOG" },
		{ name = wt.strings.strata.high, value = "FULLSCREEN" },
		{ name = wt.strings.strata.higher, value = "FULLSCREEN_DIALOG" },
		{ name = wt.strings.strata.highest, value = "TOOLTIP" },
	}
}

local selector_base ---@type selector

local selector_clearable ---@type table<selector, boolean>

local selector_invoke_updated ---@type fun(self: selector)
local selector_invoke_activated ---@type fun(item: selectorBinary, state: boolean)
local selector_invoke_added ---@type fun(self: selector, item: selectorBinary)
local selector_handlers_updated ---@type table<selector, selector_handler_updated[]>
local selector_handlers_activated ---@type table<selector, function[]>
local selector_handlers_added ---@type table<selector, selector_handler_added[]>

local function buildSelector()
	local selector = buildDatamanager() ---@cast selector selector

	--[ Type ]

	local typename = "Selector" ---@type typename_selector

	widget_types[selector][typename] = true

	--[ Items ]

	selector.items = {}
	local inactive = {} ---@type selectorBinary[]
	local typenameItem = "Binary" ---@type typename_binary

	function selector:updateItems(items, silent)
		--Update the items
		for i = 1, #items do
			local item = items[i]
			local new = true

			if wt.IsWidget(items[i], typenameItem) then item:setParent(selector)
			elseif i > #selector.items then
				if #inactive > 0 then
					item = inactive[#inactive]
					table.remove(inactive, #inactive)

					new = false
				else item = wt.CreateBinary({
					parent = selector,
					listeners = { changed = { { handler = function (_, state, user)
						if state and user and type(items[item.index].onSelect) == "function" then items[item.index].onSelect() end
					end, }, }, },
				}) end
			end

			item.index = i
			selector.items[i] = item

			item:addEvent("activated")

			if not silent then
				if new then selector_invoke_added(self, selector.items[i]) end
				selector.items[i]:invoke("activated", true)
			end
		end

		--Deactivate extra items
		while #items < #selector.items do
			local item = selector.items[#selector.items]

			item:setValue(false)

			if not silent then item:invoke("activated", false) end

			table.insert(inactive, item)
			table.remove(selector.items, #selector.items)
		end

		if not silent then selector_invoke_updated(self) end

		selector.setValue(data_value[self], nil, silent)
	end

	if not selector_invoke_updated then selector_invoke_updated = function(self)
		local handlers = selector_handlers_updated[self]

		if not handlers then return end

		for i = 1, #handlers do handlers[i](self) end
	end end

	if not selector_invoke_added then selector_invoke_added = function(self, item)
		local handlers = selector_handlers_added[self]

		if not handlers then return end

		for i = 1, #handlers do handlers[i](self, item) end
	end end

	--[ Data ]

	if not selector_clearable then selector_clearable = {} end

	function selector:verify(value)
		value = type(value) == "number" and Clamp(math.floor(value), 1, #selector.items) or nil

		return value and value or not selector_clearable[self] and value or nil
	end
	function selector:format(state)
		if type(state) ~= "boolean" then state = selector:getValue() end

		return crc((state and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), state and "FFAAAAFF" or "FFFFAA66")
	end

	function selector:setValue(index, user, silent)
		data_value[self] = selector:verify(index)

		for i = 1, #selector.items do selector.items[i]:setValue(i == data_value[self], user, silent) end

		if user and datamanager_instantSave[self] ~= false then selector:saveData(nil, silent) end

		if not silent then datamanager_invoke_changed(self, user == true) end

		local management = datamanagement[self]

		if management then wt.HandleWidgetChanges(management.index, management.category, management.key) end
	end

	return selector
end

--[ Constructors ]

function wt.CreateSelector(t, datamanager)
	if not selector_base then selector_base = buildSelector() end

	local typenameBase = "Datamanager" ---@type typename_datamanager

	local selector = setmetatable(wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t), selector_base) ---@cast selector selector

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	selector:updateItems(t.items)

	local data = type(t.data) == "table" and t.data or {}

	selector:setReader(data.read)
	selector:setWriter(data.write)

	selector:setDefault(t.default)
	selector:setValue(t.value)
	selector:snapshot()

	selector_clearable[selector] = t.clearable

	ds.Log(function() return
		"Datamanager instance mutated into Selector instance:" .. us.ToString(selector) .. " with base: " .. us.ToString(selector_base),
		wt.title .. ".CreateSelector"
	end)

	return selector
end

function wt.CreateSpecialSelector(itemset, t, datamanager)
	t = type(t) == "table" and t or {}

	local typename = "SpecialSelector" ---@type typename_specialSelector
	local typenameBase = "Datamanager" ---@type typename_datamanager

	datamanager = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t)
	local specialSelector = datamanager ---@cast specialSelector specialSelector

	widget_types[specialSelector][typename] = true

	--[ Items ]

	local items = {} ---@type selectorItemData[]

	specialSelector.items = {}

	for i = 1, #itemsets[itemset] do
		items[i] = {}
		items[i].title = itemsets[itemset][i].name
		items[i].tooltip = { lines = { { text = "(" .. itemsets[itemset][i].value .. ")", }, } }
	end

	function specialSelector.getItemset() return itemset end

	--Register starting items
	for i = 1, #items do if type(items[i]) == "table" then
		local item = wt.CreateBinary({
			parent = specialSelector,
			listeners = { changed = { { handler = function (_, state, user)
				if type(items[specialSelector.items[i].index].onSelect) == "function" and user and state then items[specialSelector.items[i].index].onSelect() end
			end,}, }, },
		}) ---@cast item selectorBinary

		item.index = i

		specialSelector.items[i] = item
	end end

	--[ Data ]

	local clearable = t.clearable

	local default = 1

	---Data verification utility
	---@param v any
	---@return integer|nil
	local function verify(v)
		if type(v) == "number" then return Clamp(math.floor(v), 1, #itemsets[itemset]) end

		if type(v) == "table" and type(v.value) == "string" then v = v.value end
		if type(v) == "string" then for i = 1, #itemsets[itemset] do if itemsets[itemset][i].value == v then return i end end end

		return not clearable and default or nil
	end

	default = verify(t.default)
	local value = verify(t.value or type(t.getData) == "function" and t.getData() or nil)
	local snapshot = value

	function specialSelector.load(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			specialSelector.setValue(t.getData(), handleChanges)

			if not silent then specialSelector.invoke.loaded(true) end
		else
			if handleChanges then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then specialSelector.invoke.loaded(false) end
		end
	end

	function specialSelector.saveData(data, silent)
		if type(t.saveData) == "function" then
			t.saveData(itemsets[itemset][verify(data or value)].value)

			if not silent then specialSelector.invoke.saved(true) end
		elseif not silent then specialSelector.invoke.saved(false) end
	end

	function specialSelector.getData() return type(t.getData) == "function" and t.getData() or nil end
	function specialSelector.setData(data, handleChanges, silent)
		specialSelector.saveData(data, silent)
		specialSelector.load(handleChanges, silent)
	end

	function specialSelector.getDefault() return itemsets[itemset][default] and itemsets[itemset][default].value or nil end
	function specialSelector.setDefault(selected) default = verify(selected) end
	function specialSelector.reset(handleChanges, silent) specialSelector.setData(default, handleChanges, silent) end

	function specialSelector.snapshot(stored) snapshot = stored and specialSelector.getData() or value end
	function specialSelector.revert(handleChanges, silent) specialSelector.setData(snapshot, handleChanges, silent) end

	function specialSelector.getValue() return itemsets[itemset][value] and itemsets[itemset][value].value or nil end
	function specialSelector.setValue(selected, user, silent)
		value = verify(selected)

		for i = 1, #specialSelector.items do specialSelector.items[i].setValue(i == value, user, silent) end

		if user and t.instantSave ~= false then specialSelector.saveData(nil, silent) end

		if not silent then specialSelector.invoke.changed(user == true) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--Set starting value
	specialSelector.setValue(value, false, true)

	return specialSelector
end

function wt.CreateMultiselector(t, datamanager)
	t = type(t) == "table" and t or {}

	local typenameBase = "Datamanager" ---@type typename_datamanager

	datamanager = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t)
	local multiselector = datamanager ---@cast multiselector multiselector

	--[ Type ]

	local typename = "Multiselector" ---@type typename_multiselector

	widget_types[multiselector][typename] = true

	--[ Items ]

	local typenameItem = "Binary" ---@type typename_binary

	local inactive = {} ---@type selectorBinary[]

	multiselector.items = {}

	t.items = type(t.items) == "table" and us.Clone(t.items) or {}
	t.limits = t.limits or {}
	local limitMin = t.limits.min or 1
	local limitMax = t.limits.max or #t.items

	---Set up a binary widget item
	---@param item binary|selectorBinary|selectorItemData
	---@param index integer
	---@param silent? boolean ***Default:*** `false`
	local function setItem(item, index, silent)
		if type(item) ~= "table" then return end

		local new = true

		if wt.IsWidget(item, typenameItem) then item.setParent(multiselector)
		elseif #inactive > 0 then
			item = inactive[#inactive]
			table.remove(inactive, #inactive)

			new = false
		else item = wt.CreateBinary({
			parent = multiselector,
			listeners = { changed = { { handler = function (_, state, user)
				if type(t.items[item.index].onSelect) == "function" and user and state then t.items[item.index].onSelect() end
			end, }, }, },
		}) end

		item.index = index
		item.addEvent("activated")

		multiselector.items[index] = item

		if new and not silent then multiselector.invoke.added(item) end
	end

	function multiselector.updateItems(newItems, silent)
		t.items = newItems

		--Update the binary widgets
		for i = 1, #newItems do
			setItem(newItems[i], i, silent)

			if not silent then multiselector.items[i].invoke.activated(true) end
		end

		--Deactivate extra binary widgets
		while #newItems < #multiselector.items do
			multiselector.items[#multiselector.items].setValue(nil, nil, silent)

			if not silent then multiselector.items[#multiselector.items].invoke.activated(false) end

			table.insert(inactive, multiselector.items[#multiselector.items])
			table.remove(multiselector.items, #multiselector.items)
		end

		if not silent then multiselector.invoke.updated() end

		--Update limits
		if limitMin > #t.items then limitMin = #t.items end
		if limitMax > #t.items then limitMax = #t.items end

		multiselector.setValue(multiselector.getValue(), nil, silent)
	end

	--Create events
	multiselector.addEvent("updated")
	multiselector.addEvent("added")

	--Register starting items
	for i = 1, #t.items do setItem(t.items[i], i) end

	--[ Data ]

	local default = {}

	for i = 1, #t.items do default[i] = false end

	---Data verification utility
	---@param v any
	---@return boolean[]
	local function verify(v)
		return us.Fill(us.Prune(type(v) == "table" and us.Clone(v) or {}, function(_, itemValue) return type(itemValue) == "boolean" end), default)
	end

	default = verify(t.default)
	local value = verify(t.value or type(t.getData) == "function" and t.getData() or nil)

	---@type boolean[]
	local snapshot = us.Clone(value)

	function multiselector.load(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			multiselector.setValue(t.getData(), handleChanges)

			if not silent then multiselector.invoke.loaded(true) end
		else
			if handleChanges then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then multiselector.invoke.loaded(false) end
		end
	end

	function multiselector.saveData(data, silent)
		if type(t.saveData) == "function" then
			t.saveData(type(data) == "table" and verify(data.states) or value)

			if not silent then multiselector.invoke.saved(true) end
		elseif not silent then multiselector.invoke.saved(false) end
	end

	function multiselector.getData() return type(t.getData) == "function" and t.getData() or nil end
	function multiselector.setData(data, handleChanges, silent)
		multiselector.saveData(data, silent)
		multiselector.load(handleChanges, silent)
	end

	function multiselector.getDefault() return default end
	function multiselector.setDefault(selections) default = verify(selections) end
	function multiselector.revert(handleChanges, silent) multiselector.setData({ states = us.Clone(snapshot) }, handleChanges, silent) end

	function multiselector.snapshot(stored) us.CopyValues(snapshot, stored and multiselector.getData() or value) end
	function multiselector.reset(handleChanges, silent) multiselector.setData({ states = us.Clone(default) }, handleChanges, silent) end

	function multiselector.getValue() return us.Clone(value) end
	function multiselector.setValue(selections, user, silent)
		value = verify(selections)

		for i = 1, #multiselector.items do multiselector.items[i].setValue(value and value[i], user, silent) end

		if user and t.instantSave ~= false then multiselector.saveData(nil, silent) end

		if not silent then
			multiselector.invoke.changed(user == true)

			--| Check limits

			local count = 0

			for _, v in pairs(value) do if v then count = count + 1 end end

			multiselector.invoke.limited(count)
		end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	function multiselector.setSelected(index, selected, user, silent)
		if not multiselector.items[index] then return end

		value[index] = selected == true

		multiselector.items[index].setValue(selected, user, silent)

		if user and t.instantSave ~= false then multiselector.saveData(nil, silent) end

		if not silent then
			multiselector.invoke.changed(user == true)

			--| Check limits

			local count = 0

			for _, v in pairs(value) do if v then count = count + 1 end end

			multiselector.invoke.limited(count)
		end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--Create event
	addEvent(multiselector, "limited", function(handlers) return function(count) for i = 1, #handlers do
		handlers[i](multiselector, count <= limitMin, count >= limitMax)
	end end end)

	--Set starting value
	multiselector.setValue(value, false, true)

	return multiselector
end

--| Toggle button group

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

	--| Events & attributes

	wt.RegisterScriptEvents(frame, t.events)
	wt.RegisterGlobalEvents(frame, t.onEvent)
	wt.RegisterAttributes(frame, t.attributes)

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state) if selector.label then selector.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end end

	selector:addListener_enabled(updateState, 1)

	updateState(nil, widget_enabled[selector])
end

function wt.CreateRadiogroup(t, selector)
	t = type(t) == "table" and t or {}

	local typename = "Radiogroup" ---@type typename_radiogroup
	local typenameBase = "Selector" ---@type typename_selector
	local typenameBaseAlternate = "SpecialSelector" ---@type typename_specialSelector

	selector = (wt.IsWidget(selector, typenameBase) or wt.IsWidget(selector, typenameBaseAlternate)) and selector or wt.CreateSelector(t)
	local radiogroup = selector ---@cast radiogroup radiogroup|specialRadiogroup

	widget_types[radiogroup][typename] = true

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

		if not active then wt.SetVisibility(item.template, false) elseif wt.IsWidget(item, "Radiobutton") then
			--Update label
			if item.label then item.label:SetText(title) end

			--Update tooltip
			if type(itemTooltip) == "table" then wt.AddTooltip(item.template, {
				title = type(title) == "string" and itemTooltip.title or type(title) == "string" and title or type(nametag) == "string" and nametag or "Toggle",
				lines = itemTooltip.lines,
				anchor = "ANCHOR_NONE",
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = item.template,
					relativePoint = "TOPRIGHT",
				},
			}, { triggers = { item.template, }, }) end

			wt.SetVisibility(item.template, true)
		else
			local sameRow = (index - 1) % columns > 0

			wt.CreateRadiobutton({
				parentFrame = radiogroup.frame,
				name = findName(name, index),
				title = itemData.title,
				label = labels,
				tooltip = itemTooltip,
				position = {
					relativeTo = index ~= 1 and radiogroup.items[sameRow and index - 1 or index - columns].frame or radiogroup.label,
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

	--[ UX ]

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
		for i = 1, #radiogroup.items do table.insert(frames, radiogroup.items[i].frame) end

		wt.AddWidgetTooltipLines(frames, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	local openTriggers = { {
		frame = radiogroup.frame,
		condition = radiogroup.isEnabled,
	}, }

	for i = 1, #radiogroup.items do table.insert(openTriggers, {
		frame = radiogroup.items[i].frame,
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

	widget_types[dropdown][typename] = true

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

	--| Events & attributes

	wt.RegisterScriptEvents(holder, t.events)
	wt.RegisterGlobalEvents(holder, t.onEvent)
	wt.RegisterAttributes(holder, t.attributes)

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
		size = { w = t.width, h = 12 + min(#t.items, t.scrollThreshold) * dropdown.items[1].frame:GetHeight() },
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

	--[ Toggle Button ]

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

					if dropdown.toggle.frame:IsMouseOver() then return state and {
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
			if button == "RightButton" and isInside and dropdown.toggle.frame:IsEnabled() then dropdown.setText(nil, true) end
		end, } or nil,
		dependencies = t.dependencies
	})

	function dropdown.setText(text, silent)
		local index = dropdown.getValue()
		local item = t.items[index] or {}
		text = type(text) == "string" and text or item.title or "…"

		dropdown.toggle.label:SetText(text)
		wt.UpdateTooltipData(dropdown.toggle.highlight, { title = text, })

		if not silent then dropdown:invoke_labeled(text) end
	end

	--Create event
	dropdown.addEvent("labeled")

	--Set starting selection
	dropdown.setText(t.text, true)

	--[ Cycle Buttons ]

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

		dropdown:invoke_open(open)
	end

	--Create event
	dropdown.addEvent("open")

	--[ UX ]

	us.SetListener(dropdown.menu, "GLOBAL_MOUSE_DOWN", function(f)
		if dropdown.toggle.frame:IsMouseOver() then return end

		f:UnregisterEvent("GLOBAL_MOUSE_DOWN")
		f:RegisterEvent("GLOBAL_MOUSE_UP")
	end)

	us.SetListener(dropdown.menu, "GLOBAL_MOUSE_UP", function(f, button)
		if (button ~= "LeftButton" and button ~= "RightButton") or f:IsMouseOver() then return end

		dropdown.toggleMenu(false)
	end, false)

	--Handle widget updates
	dropdown.toggle:addListener_triggered(function() dropdown.toggleMenu() end)
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
		triggers = { holder, dropdown.toggle.highlight, dropdown.previous.highlight, dropdown.next.highlight, },
		rules = {
			OnEnter = function() return widget_enabled[dropdown] and { background = { color = { a = 0.1 } } } or {} end,
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

		wt.AddWidgetTooltipLines({ holder, dropdown.toggle.frame, dropdown.previous.frame, dropdown.next.frame }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = holder,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.toggle.highlight,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.previous.highlight,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.next.highlight,
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
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() dropdown:revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() dropdown:reset() end }) end
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
	updateState(nil, widget_enabled[dropdown])

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

	widget_types[specialRadiogroup][typename] = true

	--[ UX ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		local defaultValue
		if showDefault then defaultValue = crc(specialRadiogroup.getDefault(), "FFFFFFFF") end

		local frames = { specialRadiogroup.frame }
		for i = 1, #specialRadiogroup.items do table.insert(frames, specialRadiogroup.items[i].frame) end

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

	widget_types[checkgroup][typename] = true

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
			item.template:SetAlpha(0.4)
		elseif checkgroup.isEnabled() then
			item.setEnabled(true, true)
			item.template:SetAlpha(1)
		end
	end

	---Set up or create new checkbox item
	---@param item selectorBinary|selectorCheckbox|checkbox|radiobutton|binary
	---@param active boolean
	local function setCheckbox(item, active)

		if not active then wt.SetVisibility(item.template, false) elseif item.template then
			--Update label
			if item.label then item.label:SetText(t.items[item.index].title) end

			--Update tooltip
			if type(t.items[item.index].tooltip) == "table" then wt.AddTooltip(item.template, {
				title = type(t.items[item.index].tooltip.title) == "string" and t.items[item.index].tooltip.title or type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle",
				lines = t.items[item.index].tooltip.lines,
				anchor = "ANCHOR_NONE",
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = item.template,
					relativePoint = "TOPRIGHT",
				},
			}, { triggers = { item.template, }, }) end
		else
			local sameRow = (item.index - 1) % t.columns > 0

			wt.CreateClassicCheckbox({
				parentFrame = checkgroup.frame,
				name = findName(name, item.index),
				title = t.items[item.index].title,
				label = t.labels,
				tooltip = t.items[item.index].tooltip,
				position = {
					relativeTo = item.index ~= 1 and checkgroup.items[sameRow and item.index - 1 or item.index - t.columns].frame or checkgroup.label,
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

	--[ UX ]

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
		for i = 1, #checkgroup.items do table.insert(frames, checkgroup.items[i].frame) end

		wt.AddWidgetTooltipLines(frames, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	local openTriggers = { {
		frame = checkgroup.frame,
		condition = checkgroup.isEnabled,
	}, }

	for i = 1, #checkgroup.items do table.insert(openTriggers, {
		frame = checkgroup.items[i].template,
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


--[[ TEXT ]]

local textual_base ---@type textual

local textual_color ---@type table<textual, color>

local function buildTextual()
	local textual = buildDatamanager() ---@cast textual textual

	--[ Type ]

	local typename = "Textual" ---@type typename_textual

	widget_types[textual][typename] = true

	--[ Data ]

	function textual:verify(value) return type(value) == "string" and value or "" end
	function textual:format(value)
		value = value and textual:verify(value) or data_value[self]
		local color = textual_color[self]

		return color and cr(value, color) or value
	end

	return textual
end

--[ Constructors ]

function wt.CreateTextual(t, datamanager)
	if not textual_base then textual_base = buildTextual() end

	local typenameBase = "Datamanager" ---@type typename_datamanager

	local textual = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t) ---@cast textual textual

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	local data = type(t.data) == "table" and t.data or {}

	textual:setReader(data.read)
	textual:setWriter(data.write)

	textual:setDefault(t.default)
	textual:setValue(t.value)
	textual:snapshot()

	if wt.IsColor(t.color) then textual_color = t.color end

	return textual
end

--| Editbox

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

	editbox.template:SetTextInsets(t.insets.l, t.insets.r, t.insets.t, t.insets.b)

	if t.font.normal then editbox.template:SetFontObject(t.font.normal) end

	if t.justify then
		if t.justify.h then editbox.template:SetJustifyH(t.justify.h) end
		if t.justify.v then editbox.template:SetJustifyV(t.justify.v) end
	end

	if t.charLimit then editbox.template:SetMaxLetters(t.charLimit) end

	--[ Events ] --REPLACE script events

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then editbox.template:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnChar" then editbox.template:SetScript("OnChar", function(self, char) value(self, char, self:GetText()) end)
		elseif key == "OnTextChanged" then editbox.template:SetScript("OnTextChanged", function(self, user) value(self, self:GetText(), user) end)
		elseif key == "OnEnterPressed" then editbox.template:SetScript("OnEnterPressed", function(self) value(self, self:GetText()) end)
		else editbox.template:HookScript(key, value) end
	end end

	--[ Text Update ]

	local scriptEvent = false

	---Update the widget UI based on the text value
	---@param _ any
	---@param text string
	local function updateText(_, text) if not scriptEvent then
		editbox.template:SetText(text)

		if t.resetCursor ~= false then editbox.template:SetCursorPosition(0) end
	else scriptEvent = false end end

	updateText(nil, editbox.getValue())

	editbox:addListener_changed(updateText, 1)

	--Link value changes
	editbox.template:HookScript("OnTextChanged", function(self, user)
		scriptEvent = true

		editbox.setValue(self:GetText(), user)
	end)

	--[ UX ]

	editbox.template:SetAutoFocus(t.keepFocused)

	if t.focusOnShow then editbox.template:HookScript("OnShow", function(self) self:SetFocus() end) end

	if t.unfocusOnEnter ~= false then editbox.template:HookScript("OnEnterPressed", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

		self:ClearFocus()
	end) end

	editbox.template:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)

	editbox.template:HookScript("OnEnter", function(self) if widget_enabled[editbox] and t.font.highlight then self:SetFontObject(t.font.highlight) end end)
	editbox.template:HookScript("OnLeave", function(self) if widget_enabled[editbox] and t.font.normal then self:SetFontObject(t.font.normal) end end)

	--[ State Update ]

	--Inherit setter
	-- editbox.widget.setEnabled = editbox.setEnabled --CHECK if needed

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		if t.readOnly then editbox.template:Disable() else editbox.template:SetEnabled(state) end

		if state then
			if editbox.template:IsMouseOver() and t.font.highlight then editbox.template:SetFontObject(t.font.highlight)
			elseif t.font.normal then editbox.template:SetFontObject(t.font.normal) end
		elseif t.font.disabled then editbox.template:SetFontObject(t.font.disabled) end

		if editbox.label then editbox.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
	end

	updateState(nil, widget_enabled[editbox])

	editbox:addListener_enabled(updateState, 1)
end

---Set the parameters of a single-line GUI textual widget frame
---@param editbox textualEditbox|customEditbox
---@param title string
---@param t editbox_options
local function setUpSinglelineEditbox(editbox, title, t)
	editbox.template:SetMultiLine(false)

	--| Position

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(editbox.frame, t.position) end
	wt.SetArrangementDirective(editbox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	editbox.template:SetPoint("BOTTOMRIGHT")

	--| Shared setup

	setUpEditbox(editbox, t)

	--[ UX ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(editbox.template, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(editbox.getDefault(), "FF55DD55") end

		wt.AddWidgetTooltipLines({ editbox.frame, editbox.template }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = { {
			frame = editbox.template,
			condition = function() return widget_enabled[editbox] and not t.readOnly end,
		}, },
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.textual = editbox.getValue() end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() editbox.setValue(wt.clipboard.textual, true) end
			}):SetEnabled(wt.clipboard.textual ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() editbox:revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() editbox:reset() end }) end
		end
	}) end
end

function wt.CreateEditbox(t, textual)
	t = type(t) == "table" and t or {}

	local typenameBase = "Textual" ---@type typename_textual

	textual = wt.IsWidget(textual, typenameBase) and textual or wt.CreateTextual(t)

	if WidgetToolsDB.lite and t.lite ~= false then return textual end

	local editbox = textual ---@cast editbox textualEditbox

	--[ Type ]

	local typename = "Editbox" ---@type typename_editbox

	widget_types[editbox][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	editbox.frame = CreateFrame("Frame", name, t.parentFrame)
	editbox.template = CreateFrame("EditBox", name .. "EditBox", editbox.frame, "InputBoxTemplate")

	--| Dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 18

	editbox.frame:SetSize(t.size.w, t.size.h + (t.label ~= false and 18 or 0))
	editbox.template:SetSize(t.size.w - 6, t.size.h - 1)

	--| Label

	editbox.label = t.label ~= false and wt.CreateTitle(editbox.frame, {
		offset = { x = -1, },
		text = title,
	}) or nil

	--| Shared setup

	setUpSinglelineEditbox(editbox, title, t)

	return editbox
end

function wt.CreateCustomEditbox(t, textual)
	t = type(t) == "table" and t or {}


	local typenameBase = "Textual" ---@type typename_textual

	textual = wt.IsWidget(textual, typenameBase) and textual or wt.CreateTextual(t)

	if WidgetToolsDB.lite and t.lite ~= false then return textual end

	local editbox = textual ---@cast editbox customEditbox

	--[ Type ]

	local typename = "CustomEditbox" ---@type typename_customEditbox

	widget_types[editbox][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	editbox.frame = CreateFrame("Frame", name, t.parentFrame)
	editbox.template = CreateFrame("EditBox", name .. "EditBox", editbox.frame, BackdropTemplateMixin and "BackdropTemplate")

	--| Dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 18

	editbox.frame:SetSize(t.size.w, t.size.h - (t.label ~= false and -18 or 0))
	editbox.template:SetSize(t.size.w, t.size.h)

	--| Label

	editbox.label = t.label ~= false and wt.CreateTitle(editbox.frame, {
		offset = { x = -1, },
		text = title,
	}) or nil

	--| Backdrop

	wt.SetBackdrop(editbox.template, t.backdrop, t.backdropUpdates)

	--| Shared setup

	setUpSinglelineEditbox(editbox, title, t)

	--[ UX ]

	editbox.template:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
	editbox.template:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)

	return editbox
end

function wt.CreateMultilineEditbox(t, textual)
	t = type(t) == "table" and t or {}

	local typenameBase = "Textual" ---@type typename_textual

	textual = wt.IsWidget(textual, typenameBase) and textual or wt.CreateTextual(t)

	if WidgetToolsDB.lite and t.lite ~= false then return textual end

	local editbox = textual ---@cast editbox multilineEditbox

	--[ Type ]

	---@type typename_multilineEditbox
	local typename = "MultilineEditbox"

	widget_types[editbox][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	editbox.frame = CreateFrame("Frame", name, t.parentFrame)
	editbox.scrollframe = CreateFrame("ScrollFrame", name .. "ScrollFrame", editbox.frame, ScrollControllerMixin and "InputScrollFrameTemplate")
	editbox.template = editbox.scrollframe.EditBox

	editbox.template:SetMultiLine(true)

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

	local scrollSpeed = t.scrollSpeed or 0.25

	editbox.scrollframe.ScrollBar.SetPanExtentPercentage = function() --WATCH: Change when Blizzard provides a better way to overriding the built-in update function
		local height = editbox.scrollframe:GetHeight()

		editbox.scrollframe.ScrollBar.panExtentPercentage = height * scrollSpeed / math.abs(editbox.template:GetHeight() - height)
	end

	--| Character counter

	editbox.scrollframe.CharCount:SetFontObject("GameFontDisableTiny2")
	if t.charCount == false or (t.charLimit or 0) == 0 then editbox.scrollframe.CharCount:Hide() end

	---@diagnostic disable-next-line: inject-field
	editbox.template.cursorOffset = 0 --WATCH: Remove when the character counter gets fixed..

	--| Shared setup

	setUpEditbox(editbox, t)

	--[ UX ]

	editbox.template:HookScript("OnTextChanged", function(_, _, user) if not user and t.scrollToTop then editbox.scrollframe:SetVerticalScroll(0) end end)
	editbox.template:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
	editbox.template:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)

	---Update the width of the editbox
	---@param scrolling boolean
	local function resizeEditbox(scrolling)
		local scrollBarOffset = scrolling and (wt.classic and 32 or 16) or 0
		local charCountWidth = t.charCount ~= false and (t.charLimit or 0) > 0 and tostring(t.charLimit - editbox.getValue():len()):len() * 6 + 3 or 0

		editbox.template:SetWidth(editbox.scrollframe:GetWidth() - scrollBarOffset - charCountWidth)

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
		}, { triggers = { editbox.frame, editbox.template }, })

		if t.readOnly ~= true then
			local defaultValue
			if t.showDefault ~= false then defaultValue = crc(editbox.getDefault(), "FF55DD55") end

			wt.AddWidgetTooltipLines({ editbox.scrollframe, editbox.template }, defaultValue, t.utilityMenu)
		end
	end

	--| Utility menu

	---Utility menu opening condition checker
	---@return boolean
	local function openCondition() return widget_enabled[editbox] and not t.readOnly end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = editbox.frame,
				condition = openCondition,
			},
			{
				frame = editbox.template,
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
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() editbox:revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() editbox:reset() end }) end
		end
	}) end

	return editbox
end

--| Copybox

function wt.CreateCopybox(t) --FIX lite
	t = type(t) == "table" and t or {}

	local typename = "Copybox" ---@type typename_copybox

	local text = type(t.value) == "string" and t.value or ""

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	local frame = CreateFrame("Frame", name, t.parentFrame)

	local copybox = { frame = frame, } ---@type copybox

	--| Position & dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 18

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(frame, t.position) end
	wt.SetArrangementDirective(frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	frame:SetSize(t.size.w, t.size.h + (t.label ~= false and 12 or 0))

	--| Visibility

	wt.SetVisibility(frame, t.visible ~= false)

	if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

	--| Label

	t.font = t.font or "GameFontNormalSmall"
	t.color = t.color or { r = 0.6, g = 0.8, b = 1, a = 1 }
	t.colorOnMouse = t.colorOnMouse or { r = 0.8, g = 0.95, b = 1, a = 1 }

	copybox.label = t.label ~= false and wt.CreateTitle(frame, {
		offset = { x = -1, },
		width = t.size.w,
		text = title,
		font = "GameFontNormal",
	}) or nil

	--| Textbox

	copybox.textual = wt.CreateCustomEditbox({
		parentFrame = frame,
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


--[[ NUMERIC ]]

local numeric_base ---@type numeric

local numeric_limitMin ---@type table<numeric, number>
local numeric_limitMax ---@type table<numeric, number>
local numeric_step ---@type table<numeric, number>
local numeric_altStep ---@type table<numeric, number>
local numeric_hardStep ---@type table<numeric, boolean>

local numeric_invoke_min ---@type fun(self: numeric)
local numeric_invoke_max ---@type fun(self: numeric)
local numeric_handlers_min ---@type table<numeric, numeric_handler_min[]>
local numeric_handlers_max ---@type table<numeric, numeric_handler_max[]>

local function buildNumeric()
	local numeric = buildDatamanager() ---@cast numeric numeric

	--[ Type ]

	local typename = "Numeric" ---@type typename_numeric

	widget_types[numeric][typename] = true

	--[ Data ]

	if not numeric_limitMin then numeric_limitMin = {} end
	if not numeric_limitMax then numeric_limitMax = {} end
	if not numeric_step then numeric_step = {} end
	if not numeric_altStep then numeric_altStep = {} end
	if not numeric_hardStep then numeric_hardStep = {} end

	function numeric:verify(value)
		if type(value) ~= "number" then return data_default[self] end

		local limitMin = numeric_limitMin[self]
		local step = numeric_step[self]

		if numeric_hardStep[self] then value = limitMin + floor((value - limitMin) / step + 0.5) * step end

		return Clamp(value, limitMin, numeric_limitMax[self])
	end
	function numeric:format(value) return crc(tostring(value), "FFDDDD55") end

	function numeric:decrease(alt, user, silent) self:setValue(data_value[self] - (alt and numeric_altStep[self] or numeric_step[self]), user, silent) end
	function numeric:increase(alt, user, silent) self:setValue(data_value[self] + (alt and numeric_altStep[self] or numeric_step[self]), user, silent) end

	--| Value limits

	function numeric:getMin() return numeric_limitMin[self] end
	function numeric:setMin(number, silent)
		numeric_limitMin[self] = min(number, numeric_limitMax[self])

		if not silent then numeric_invoke_min(self) end
	end

	function numeric:getMax() return numeric_limitMax[self] end
	function numeric:setMax(number, silent)
		numeric_limitMax[self] = max(numeric_limitMin[self], number)

		if not silent then numeric_invoke_max(self) end
	end

	if not numeric_invoke_min then numeric_invoke_min = function(self)
		local handlers = numeric_handlers_min[self]

		if not handlers then return end

		for i = 1, #handlers do handlers[i](self, numeric_limitMin[self]) end
	end end

	if not numeric_invoke_max then numeric_invoke_max = function(self)
		local handlers = numeric_handlers_max[self]

		if not handlers then return end

		for i = 1, #handlers do handlers[i](self, numeric_limitMax[self]) end
	end end

	--| Value step

	function numeric:getStep() return numeric_step[self] end
	function numeric:getAltStep() return numeric_altStep[self] end

	return numeric
end

--[ Constructors ]

function wt.CreateNumeric(t, datamanager)
	if not numeric_base then numeric_base = buildNumeric() end

	local typenameBase = "Datamanager" ---@type typename_datamanager

	local numeric = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t) ---@cast numeric numeric

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	numeric_limitMin[numeric] = type(t.min) == "number" and t.min or 0
	numeric_limitMax[numeric] = type(t.max) == "number" and t.max or 100
	numeric_step[numeric] = max(type(t.step) == "number" and t.step or ((numeric_limitMin[numeric] - numeric_limitMax[numeric]) / 10), 0)
	numeric_altStep[numeric] = type(t.altStep) == "number" and max(t.altStep, 0) or nil
	numeric_hardStep[numeric] = t.hardStep ~= false

	local data = type(t.data) == "table" and t.data or {}

	numeric:setReader(data.read)
	numeric:setWriter(data.write)

	data_default[numeric] = numeric_limitMin[numeric] --CHECK if needed -> robust replacement
	numeric:setDefault(t.default)
	numeric:setValue(t.value)
	numeric:snapshot()

	return numeric
end

--| Slider

function wt.CreateSlider(t, numeric)
	t = type(t) == "table" and t or {}

	local typenameBase = "Numeric" ---@type typename_numeric

	numeric = wt.IsWidget(numeric, typenameBase) and numeric or wt.CreateNumeric(t)

	if WidgetToolsDB.lite and t.lite ~= false then return numeric end

	local slider = numeric ---@cast slider numericSlider

	--[ Type ]

	local typename = "Slider" ---@type typename_slider

	widget_types[slider][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	local frame = CreateFrame("Frame", name, t.parentFrame, BackdropTemplateMixin and "BackdropTemplate")
	local template = CreateFrame("Slider", name .. "Frame", frame, "MinimalSliderWithSteppersTemplate")

	slider.frame = frame
	slider.template = template

	--| Position & dimensions

	t.width = t.width or 180

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(frame, t.position) end
	wt.SetArrangementDirective(frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	template:SetPoint("TOP", 0, -8)

	frame:SetSize(t.width, t.valuebox ~= false and 64 or 52)
	template:SetWidth(t.width)

	--| Visibility

	wt.SetVisibility(frame, t.visible ~= false)

	if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

	--| Label

	if t.label ~= false then
		template.TopText:SetPoint("TOP", frame, "TOP", 0, 4)
		template.TopText:SetText(title)
		template.TopText:Show()
	end

	--| Limits

	local limitMin, limitMax = numeric_limitMin[slider], numeric_limitMax[slider]

	template.MinText:Show()
	template.MaxText:Show()

	---Update the min/max limits of the slider
	---@param lMin? number
	---@param lMax? number
	local function updateLimits(lMin, lMax)
		if lMin then template.MinText:SetText(tostring(lMin)) else lMin = numeric_limitMin[slider] end
		if lMax then template.MaxText:SetText(tostring(lMax)) else lMax = numeric_limitMax[slider] end

		template.Slider:SetMinMaxValues(lMin, lMax)
	end

	updateLimits(limitMin, limitMax)

	slider:addListener_min(function(_, lMin) updateLimits(lMin) end, 1)
	slider:addListener_max(function(_, lMax) updateLimits(nil, lMax) end, 1)

	--| Value step

	local step = numeric_step[slider]
	local altStep = numeric_altStep[slider]

	if numeric_hardStep[slider] ~= false then
		template.Slider:SetValueStep(numeric_step[slider])
		template.Slider:SetObeyStepOnDrag(true)
	end

	--| Decrease button

	wt.AddTooltip(template.Back, {
		title = wt.strings.slider.decrease.label,
		lines = {
			{ text = wt.strings.slider.decrease.tooltip[1]:gsub("#VALUE", step), },
			altStep and { text = wt.strings.slider.decrease.tooltip[2]:gsub("#VALUE", altStep), } or nil,
		},
		anchor = "ANCHOR_TOPLEFT",
	})

	template.Back:HookScript("OnClick", function() slider:decrease(IsAltKeyDown(), true) end)

	--| Increase button

	wt.AddTooltip(template.Forward, {
		title = wt.strings.slider.increase.label,
		lines = {
			{ text = wt.strings.slider.increase.tooltip[1]:gsub("#VALUE", step), },
			altStep and { text = wt.strings.slider.increase.tooltip[2]:gsub("#VALUE", altStep), } or nil,
		},
		anchor = "ANCHOR_TOPLEFT",
	})

	template.Forward:HookScript("OnClick", function() slider:increase(IsAltKeyDown(), true) end)

	--[ Valuebox ]

	if t.valuebox ~= false then
		local decimals = type(t.fractional) == "number" and floor(t.fractional + 0.5) or max(
			(tostring(limitMin):match("%.(%d+)") or ""):len(),
			(tostring(limitMax):match("%.(%d+)") or ""):len(),
			(tostring(step):match("%.(%d+)") or ""):len()
		)

		local decimalPattern = ""
		for _ = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end

		local matchPattern = "(" .. (limitMin < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
		local replacePattern = "%1" .. (decimals > 0 and "%2" or "")

		slider.valuebox = wt.CreateCustomEditbox({
			parentFrame = frame,
			name = "Valuebox",
			label = false,
			tooltip = {
				title = wt.strings.slider.value.label,
				lines = { { text = wt.strings.slider.value.tooltip, }, }
			},
			position = {
				anchor = "TOP",
				offset = { y = 6 },
				relativeTo = template.Slider,
				relativePoint = "BOTTOM",
			},
			size = { w = 80, h = 20 },
			font = {
				normal = "GameFontNormalSmall2",
				highlight = "GameFontHighlightSmall2",
				disabled = "GameFontDisableSmall2",
			},
			justify = { h = "CENTER", },
			charLimit = max(tostring(math.floor(step)):len(), tostring(math.floor(limitMin)):len(), tostring(math.floor(limitMax)):len()) + (decimals > 0 and decimals + 1 or 0),
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
				OnEnter = function(valuebox) return valuebox:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end,
				OnLeave = "",
			}, }, },
			events = {
				OnChar = function(valuebox, _, text) valuebox:SetText(text:gsub(matchPattern, replacePattern)) end,
				OnEnterPressed = function(valuebox) slider:setValue(valuebox:GetNumber(), true) end,
				OnEscapePressed = function(valuebox) valuebox:SetText(tostring(us.Round(template.Slider:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
			},
			value = tostring(data_value[slider]):gsub(matchPattern, replacePattern),
			showDefault = false,
			utilityMenu = false,
		})

		slider:addListener_changed(function(_, number) slider.valuebox:setValue(tostring(us.Round(number, decimals)):gsub(matchPattern, replacePattern)) end)
	end

	--[ Events ] --REPLACE script events

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then template.Slider:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else template.Slider:HookScript(key, value) end
	end end

	--[ Value Update ]

	local scriptEvent = false

	---Update the widget UI based on the number value
	---@param _ any
	---@param number number
	---@param user? boolean ***Default:*** `false`
	local function updateNumber(_, number, user) if not scriptEvent then template.Slider:SetValue(number, user) else scriptEvent = false end end

	updateNumber(nil, data_value[slider], false)

	slider:addListener_changed(updateNumber, 1)

	--Link value changes
	template.Slider:HookScript("OnValueChanged", function(_, number, user)
		if not IsMouseButtonDown("LeftButton") then template.Slider:SetValue(data_value[slider]) return end

		scriptEvent = true

		slider:setValue(number, user)
	end)

	--[ UX ]

	--| Backdrop

	wt.SetBackdrop(frame, { background = {
		texture = { size = 5, },
		color = { r = 1, g = 1, b = 1, a = 0 }
	}, }, { {
		triggers = { frame, template.Slider, template.Forward, template.Back, t.valuebox ~= false and slider.valuebox.template or nil },
		rules = {
			OnEnter = function() return widget_enabled[slider] and { background = { color = { a = 0.1 } } } or {} end,
			OnLeave = "",
		},
	}, })

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(template.Slider, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { frame } })

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(tostring(data_default[slider]), "FFDDDD55") end

		wt.AddWidgetTooltipLines({ frame, template.Slider, template.Back, template.Forward, slider.valuebox.template }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = frame,
				condition = slider.isEnabled,
			},
			{
				frame = template.Slider,
				condition = slider.isEnabled,
			},
			{
				frame = template.Back,
				condition = slider.isEnabled,
			},
			{
				frame = template.Forward,
				condition = slider.isEnabled,
			},
			t.valuebox ~= false and {
				frame = slider.valuebox.template,
				condition = slider.isEnabled,
			} or nil,
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.numeric = data_value[slider] end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() slider:setValue(wt.clipboard.numeric, true) end
			}):SetEnabled(wt.clipboard.numeric ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() slider:revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() slider:reset() end }) end
		end
	}) end

	--[ State Update ]

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		template.Slider:SetEnabled(state)

		template.TopText:SetFontObject(state and "GameFontNormal" or "GameFontDisable")
		template.MinText:SetFontObject(state and "GameFontNormalSmall" or "GameFontDisableSmall")
		template.MaxText:SetFontObject(state and "GameFontNormalSmall" or "GameFontDisableSmall")

		if t.valuebox ~= false then slider.valuebox:setEnabled(state) end

		template.Back:SetEnabled(state and wt.CheckDependencies({ {
			dependency = template.Slider,
			evaluate = function(value) return value > numeric_limitMin[slider] end,
		}, }))
		template.Forward:SetEnabled(state and wt.CheckDependencies({ {
			dependency = template.Slider,
			evaluate = function(value) return value < numeric_limitMax[slider] end,
		}, }))
	end

	updateState(nil, widget_enabled[slider])

	slider:addListener_enabled(updateState, 1)

	return slider
end

function wt.CreateClassicSlider(t, numeric)
	t = type(t) == "table" and t or {}

	local typenameBase = "Numeric" ---@type typename_numeric

	numeric = wt.IsWidget(numeric, typenameBase) and numeric or wt.CreateNumeric(t)

	if WidgetToolsDB.lite and t.lite ~= false then return numeric end

	local slider = numeric ---@cast slider classicSlider

	--[ Type ]

	local typename = "ClassicSlider" ---@type typename_classicSlider

	widget_types[slider][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or typename

	local frame = CreateFrame("Frame", name, t.parentFrame)
	local template = CreateFrame("Slider", name .. "Frame", frame, "OptionsSliderTemplate")

	slider.frame = frame
	slider.template = template

	--| Position & dimensions

	t.width = t.width or 160

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(frame, t.position) end
	wt.SetArrangementDirective(frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	template:SetPoint("TOP", 0, -15)
	slider.min:SetPoint("TOPLEFT", template, "BOTTOMLEFT")
	slider.max:SetPoint("TOPRIGHT", template, "BOTTOMRIGHT")

	frame:SetSize(t.width, t.valuebox ~= false and 48 or 31)
	template:SetWidth(t.width - (t.sideButtons ~= false and 40 or 0))

	--| Visibility

	wt.SetVisibility(frame, t.visible ~= false)

	if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

	--| Label

	if t.label ~= false then
		slider.label = _G[name .. "FrameText"]

		slider.label:SetPoint("TOP", frame, "TOP", 0, 2)
		slider.label:SetFontObject("GameFontNormal")

		slider.label:SetText(title)
	else _G[name .. "FrameText"]:Hide() end

	--| Limits

	local limitMin, limitMax = numeric_limitMin[slider], numeric_limitMax[slider]

	slider.min = _G[name .. "FrameLow"]
	slider.max = _G[name .. "FrameHigh"]

	---Update the min/max limits of the slider
	---@param lMin? number
	---@param lMax? number
	local function updateLimits(lMin, lMax)
		if lMin then slider.min:SetText(tostring(lMin)) else lMin = numeric_limitMin[slider] end
		if lMax then slider.max:SetText(tostring(lMax)) else lMax = numeric_limitMax[slider] end

		template:SetMinMaxValues(lMin, lMax)
	end

	updateLimits(limitMin, limitMax)

	slider:addListener_min(function(_, lMin) updateLimits(lMin) end, 1)
	slider:addListener_max(function(_, lMax) updateLimits(nil, lMax) end, 1)

	--| Value step

	local step = numeric_step[slider]
	local altStep = numeric_altStep[slider]

	if numeric_hardStep[slider] ~= false then
		template:SetValueStep(step)
		template:SetObeyStepOnDrag(true)
	end

	--[ Side Buttons ]

	if t.sideButtons ~= false then

		--| Decrease

		slider.decreaseButton = wt.CreateCustomButton({
			parentFrame = frame,
			name = "SelectPrevious",
			title = "-",
			tooltip = {
				title = wt.strings.slider.decrease.label,
				lines = {
					{ text = wt.strings.slider.decrease.tooltip[1]:gsub("#VALUE", step), },
					altStep and { text = wt.strings.slider.decrease.tooltip[2]:gsub("#VALUE", altStep), } or nil,
				}
			},
			position = {
				anchor = "LEFT",
				relativeTo = template,
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
				OnEnter = function(button)
					if not button:IsEnabled() then return {} end

					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(button)
					if not button:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(button)
					if not button:IsEnabled() then return {} end

					return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					}
				end,
				OnMouseUp = function(button, self)
					if not button:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function() slider:decrease(IsAltKeyDown(), true) end,
			dependencies = { { dependency = template, evaluate = function(value) return value > numeric_limitMin[slider] end, }, }
		})

		--| Increase

		slider.increaseButton = wt.CreateCustomButton({
			parentFrame = frame,
			name = "SelectNext",
			title = "+",
			tooltip = {
				title = wt.strings.slider.increase.label,
				lines = {
					{ text = wt.strings.slider.increase.tooltip[1]:gsub("#VALUE", step), },
					altStep and { text = wt.strings.slider.increase.tooltip[2]:gsub("#VALUE", altStep), } or nil,
				}
			},
			position = {
				anchor = "RIGHT",
				relativeTo = template,
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
				OnEnter = function(button)
					if not button:IsEnabled() then return {} end

					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(button)
					if not button:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(button)
					if not button:IsEnabled() then return {} end

					return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(button, self)
					if not button:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function() slider:increase(IsAltKeyDown(), true) end,
			dependencies = { { dependency = template, evaluate = function(value) return value < numeric_limitMax[slider] end }, }
		})
	end

	--[ Valuebox ]

	if t.valuebox ~= false then
		local decimals = type(t.fractional) == "number" and floor(t.fractional + 0.5) or max(
			(tostring(limitMin):match("%.(%d+)") or ""):len(),
			(tostring(limitMax):match("%.(%d+)") or ""):len(),
			(tostring(step):match("%.(%d+)") or ""):len()
		)

		local decimalPattern = ""
		for _ = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end

		local matchPattern = "(" .. (limitMin < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
		local replacePattern = "%1" .. (decimals > 0 and "%2" or "")

		slider.valuebox = wt.CreateCustomEditbox({
			parentFrame = frame,
			name = "Valuebox",
			label = false,
			tooltip = {
				title = wt.strings.slider.value.label,
				lines = { { text = wt.strings.slider.value.tooltip, }, }
			},
			position = {
				anchor = "TOP",
				relativeTo = template,
				relativePoint = "BOTTOM",
			},
			size = { w = 64, },
			font = {
				normal = "GameFontHighlightSmall",
				disabled = "GameFontDisableSmall",
			},
			justify = { h = "CENTER", },
			charLimit = max(tostring(math.floor(step)):len(), tostring(math.floor(limitMin)):len(), tostring(math.floor(limitMax)):len()) + (decimals > 0 and decimals + 1 or 0),
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
				OnEnter = function(valuebox) return valuebox:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end,
				OnLeave = "",
			}, }, },
			events = {
				OnChar = function(valuebox, _, text) valuebox:SetText(text:gsub(matchPattern, replacePattern)) end,
				OnEnterPressed = function(valuebox) slider:setValue(valuebox:GetNumber(), true) end,
				OnEscapePressed = function(valuebox) valuebox:SetText(tostring(us.Round(template:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
			},
			value = tostring(data_value[slider]):gsub(matchPattern, replacePattern),
			showDefault = false,
			utilityMenu = false,
		})

		--| UX

		slider:addListener_changed(function(_, number) slider.valuebox:setValue(tostring(us.Round(number, decimals)):gsub(matchPattern, replacePattern)) end)
	end

	--[ Events ] --REPLACE script events

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then template:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else template:HookScript(key, value) end
	end end

	--[ Value Update ]

	local scriptEvent = false

	---Update the widget UI based on the number value
	---@param _ any
	---@param number number
	---@param user? boolean ***Default:*** `false`
	local function updateNumber(_, number, user) if not scriptEvent then template:SetValue(number, user) else scriptEvent = false end end

	updateNumber(nil, data_value[slider], false)

	slider:addListener_changed(updateNumber, 1)

	--Link value changes
	template:HookScript("OnValueChanged", function(_, number, user)
		scriptEvent = true

		slider:setValue(number, user)

		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end)

	--[ UX ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(template, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { frame } })

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(tostring(data_default[slider]), "FFDDDD55") end

		wt.AddWidgetTooltipLines({ template }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = { {
			frame = frame,
			condition = slider.isEnabled,
		}, },
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.numeric = data_value[slider] end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() slider:setValue(wt.clipboard.numeric, true) end
			}):SetEnabled(wt.clipboard.numeric ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() slider:revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() slider:reset() end }) end
		end
	}) end

	--[ State Update ]

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		template:SetEnabled(state)

		if slider.label then slider.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

		if t.valuebox ~= false then slider.valuebox:setEnabled(state) end

		if t.sideButtons ~= false then
			slider.decreaseButton:setEnabled(state and wt.CheckDependencies({ {
				dependency = template,
				evaluate = function(value) return value > numeric_limitMin[slider] end,
			}, }))
			slider.increaseButton:setEnabled(state and wt.CheckDependencies({ {
				dependency = template,
				evaluate = function(value) return value < numeric_limitMax[slider] end,
			}, }))
		end
	end

	updateState(nil, widget_enabled[slider])

	slider:addListener_enabled(updateState, 1)

	return slider
end


--[[ COLOR ]]

local colormanager_base ---@type colormanager

local colormanager_active ---@type table<colormanager, boolean>
local colormanager_onCancel ---@type table<colormanager, function>

local function buildColormanager()
	local colormanager = buildDatamanager() ---@cast colormanager colormanager

	--[ Type ]

	local typename = "Colormanager" ---@type typename_colormanager

	widget_types[colormanager][typename] = true

	--[ Data ]

	function colormanager:verify(color) wt.PackColor(wt.UnpackColor(color)) end

	function colormanager:getValue() return us.Clone(data_value[self]) end

	--| Default

	function colormanager:getDefault() return us.Clone(data_default[self]) end
	function colormanager:setDefault(color) data_default[self] = us.Clone(color) end

	--| Snapshot

	function colormanager:snapshot(stored) us.CopyValues(data_snapshot[self], stored and colormanager:getData() or data_value[self]) end

	--[ Color Wheel ]

	if not colormanager_active then colormanager_active = {} end

	local function colorUpdate(self)
		if not widget_enabled[self] then return end

		local r, g, b = ColorPickerFrame:GetColorRGB()

		colormanager:setValue(wt.PackColor(r, g, b, ColorPickerFrame:GetColorAlpha()), true)
	end

	function colormanager:openColorPicker()
		local r, g, b, a = wt.UnpackColor(data_value[self])

		colormanager_active[self] = true

		ColorPickerFrame:SetupColorPickerAndShow({
			r = r,
			g = g,
			b = b,
			opacity = a,
			hasOpacity = true,
			swatchFunc = colorUpdate,
			opacityFunc = colorUpdate,
			cancelFunc = function()
				colormanager:setValue(wt.PackColor(r, g, b, a), true)

				local onCancel = colormanager_onCancel[self]

				if onCancel then onCancel() end
			end
		})
	end

	function colormanager:isActive() return colormanager_active[self] end

	colormanager:addListener_enabled(function(self) if colormanager_active[self] then colorUpdate() end end, 1)

	return colormanager
end

--[ Constructors ]

function wt.CreateColormanager(t, datamanager)
	if not colormanager_base then colormanager_base = buildColormanager() end

	local typenameBase = "Datamanager" ---@type typename_datamanager

	local colormanager = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t) ---@cast colormanager colormanager

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	local data = type(t.data) == "table" and t.data or {}

	colormanager:setReader(data.read)
	colormanager:setWriter(data.write)

	colormanager:setDefault(t.default)
	colormanager:setValue(t.value)
	colormanager:snapshot()

	colormanager_active[colormanager] = false

	ColorPickerFrame:HookScript("OnHide", function() colormanager_active[colormanager] = false end)

	return colormanager
end

--| Colorpicker

function wt.CreateColorpicker(t, colormanager)
	t = type(t) == "table" and t or {}

	local typenameBase = "Colormanager" ---@type typename_colormanager

	colormanager = wt.IsWidget(colormanager, typenameBase) and colormanager or wt.CreateColormanager(t)

	if WidgetToolsDB.lite and t.lite ~= false then return colormanager end

	local colorpicker = colormanager ---@cast colorpicker colorpicker

	--[ Type ]

	local typename = "Colorpicker" ---@type typename_colorpicker

	widget_types[colorpicker][typename] = true

	--[ Frame ]

	local name = (t.append ~= false and t.parentFrame and t.parentFrame ~= UIParent and t.parentFrame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or typename)

	local frame = CreateFrame("Frame", name, t.parentFrame)

	colorpicker.frame = frame

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	t.width = t.width or 120

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

	--| Events & attributes

	wt.RegisterScriptEvents(frame, t.events)
	wt.RegisterGlobalEvents(frame, t.onEvent)
	wt.RegisterAttributes(frame, t.attributes)

	--| Color wheel toggle button

	---Toggle the interactability of the color picker elements when [ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame) is opened
	---@param unlocked boolean
	local function setLock(unlocked)
		colorpicker.button.frame:EnableMouse(unlocked)
		colorpicker.hexBox.template:EnableMouse(unlocked)

		--| Fade inactive color pickers

		local opacity = (unlocked or colormanager_active[colorpicker]) and 1 or 0.4

		colorpicker.label:SetAlpha(opacity)
		colorpicker.hexBox.template:SetAlpha(opacity)
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

	colorpicker.button.gradient = wt.CreateTexture(colorpicker.button.frame, {
		name = "ColorGradient",
		position = { offset = { x = 2.5, y = -2.5 } },
		size = { w = 17, h = 17 },
		path = wt.textures.gradientBG,
		layer = "BACKGROUND",
		level = -7,
	})

	colorpicker.button.checker = wt.CreateTexture(colorpicker.button.frame, {
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
			relativeTo = colorpicker.button.frame,
			relativePoint = "TOPRIGHT",
		},
		size = { w = t.width - colorpicker.button.frame:GetWidth(), h = colorpicker.button.frame:GetHeight() },
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
			OnEnterPressed = function(_, text) colorpicker:setValue(wt.PackColor(wt.HexToColor(text)), true) end,
			OnEscapePressed = function(self) self.setText(wt.ColorToHex(data_value[colorpicker])) end,
		},
		showDefault = false,
		utilityMenu = false,
	})

	--| RGBA textboxes

	--ADD textboxes

	--[ UX ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			local default = data_default[colorpicker]
			local r, g, b = wt.UnpackColor(default)

			local texture = "|TInterface/ChatFrame/ChatFrameBackground:12:12:0:0:16:16:0:16:0:16:" .. (r * 255) .. ":" .. (g * 255) .. ":" .. (b * 255) .. "|t "
			defaultValue = texture .. crc(wt.ColorToHex(default), "FFFFFFFF")
		end

		wt.AddWidgetTooltipLines({ frame, colorpicker.button.frame, colorpicker.hexBox.template }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	---Utility menu opening condition checker
	---@return boolean
	local function openCondition() return widget_enabled[colorpicker] and not ColorPickerFrame:IsVisible() end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = frame,
				condition = openCondition,
			},
			{
				frame = colorpicker.button.highlight,
				condition = openCondition,
			},
			{
				frame = colorpicker.hexBox.template,
				condition = openCondition,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.color = data_value[colorpicker] end })
			wt.CreateMenuButton(menu, {
				title = wt.strings.value.paste,
				action = function() colorpicker:setValue(wt.clipboard.color, true) end
			}):SetEnabled(wt.clipboard.color ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() colorpicker:revert() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() colorpicker:reset() end }) end
		end
	}) end

	--[ Color Update ]

	---Update the widget UI based on the color value
	---@param color color|colorRGBA
	local function updateColor(color)
		colorpicker.button.frame:SetBackdropColor(color.r, color.g, color.b, color.a)
		colorpicker.button.gradient:SetVertexColor(color.r, color.g, color.b, 1)
		colorpicker.hexBox:setValue(wt.ColorToHex(color))
	end

	updateColor(data_value[colorpicker])

	colorpicker:addListener_colored(function(_, color) updateColor(color) end)

	--Color wheel toggle updates
	ColorPickerFrame:HookScript("OnShow", function() setLock(false) end)
	ColorPickerFrame:HookScript("OnHide", function() setLock(true) end)

	--[ State Update ]

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		colorpicker.button:setEnabled(state)
		colorpicker.hexBox:setEnabled(state)

		if colorpicker.label then colorpicker.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

		if ColorPickerFrame:IsVisible() then setLock(false) end
	end

	updateState(nil, widget_enabled[colorpicker])

	colorpicker:addListener_enabled(updateState, 1)

	return colorpicker
end



--[[ POSITION ]]



--[ Constructors ]



--| Panel

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
						panel.widgets.position.anchor.load(false)
						panel.widgets.position.relativePoint.load(false)
						-- panel.widgets.position.relativeTo.loadData(false)
						panel.widgets.position.offset.x.load(false)
						panel.widgets.position.offset.y.load(false)
					end

					--Keep in bounds
					if panel.presets[i].data.keepInBounds ~= nil then
						frame:SetClampedToScreen(panel.presets[i].data.keepInBounds) --Update the frame
						getData().keepInBounds = panel.presets[i].data.keepInBounds --Update the storage
						if panel.widgets.position.keepInBounds then panel.widgets.position.keepInBounds.load(false) end --Update the settings widget
					end

					--Screen Layer
					if type(panel.presets[i].data.layer) == "table" then
						--Frame strata
						if panel.presets[i].data.layer.strata then
							frame:SetFrameStrata(panel.presets[i].data.layer.strata) --Update the frame
							getData().layer.strata = panel.presets[i].data.layer.strata --Update the storage
							if panel.widgets.layer.strata then panel.widgets.layer.strata.load(false) end --Update the settings widget
						end

						--Keep on top
						if panel.presets[i].data.layer.keepOnTop ~= nil then
							frame:SetToplevel(panel.presets[i].data.layer.keepOnTop) --Update the frame
							getData().layer.keepOnTop = panel.presets[i].data.layer.keepOnTop --Update the storage
							if panel.widgets.layer.keepOnTop then panel.widgets.layer.keepOnTop.load(false) end --Update the settings widget
						end

						--Frame level
						if panel.presets[i].data.layer.level then
							frame:SetFrameLevel(panel.presets[i].data.layer.level) --Update the frame
							getData().layer.level = panel.presets[i].data.layer.level --Update the storage
							if panel.widgets.layer.level then panel.widgets.layer.level.load(false) end --Update the settings widget
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
					panel.widgets.position.anchor.load(false)
					panel.widgets.position.relativePoint.load(false)
					-- panel.widgets.position.relativeTo.loadData(false)
					panel.widgets.position.offset.x.load(false)
					panel.widgets.position.offset.y.load(false)

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


--[[ FONT ]]



--[ Constructors ]



--| Panel

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

local settingsmanager_base ---@type settingsmanager

local datamanagementEntry ---
local autoLoad ---@type table<settingsmanager, true>
local autoSave ---@type table<settingsmanager, true>

local function buildSettingsmanager()
	local settingsmanager = buildWidget() ---@cast settingsmanager settingsmanager

	--[ Type ]

	local typename = "Settingsmanager" ---@type typename_settingsmanager

	widget_types[settingsmanager][typename] = true

	--[ Batched Datamanagement ]

	function settingsmanager:load(handleChanges, user, silent)
		if autoLoad[self] then for i = 1, #datamanagementEntry[self].keys do
			wt.LoadSettingsData(datamanagementEntry[self].category, datamanagementEntry[self].keys[i], handleChanges)
			wt.SnapshotSettingsData(datamanagementEntry[self].category, datamanagementEntry[self].keys[i])
		end end

		if not silent then settingsmanager.invoke.loaded(user == true) end
	end

	function settingsmanager:save(user, silent)
		if autoSave[self] then for i = 1, #datamanagementEntry[self].keys do wt.SaveSettingsData(datamanagementEntry[self].category, datamanagementEntry[self].keys[i]) end end

		if not silent then settingsmanager.invoke.saved(user == true) end
	end

	function settingsmanager:apply(user, silent)
		if datamanagementEntry[self] then for i = 1, #datamanagementEntry[self].keys do wt.ApplySettingsData(datamanagementEntry[self].category, datamanagementEntry[self].keys[i]) end end

		if not silent then settingsmanager.invoke.applied(user == true) end
	end

	function settingsmanager:revert(user, silent)
		if datamanagementEntry[self] then for i = 1, #datamanagementEntry[self].keys do wt.RevertSettingsData(datamanagementEntry[self].category, datamanagementEntry[self].keys[i]) end end

		if not silent then settingsmanager.invoke.reverted(user == true) end
	end

	function settingsmanager:reset(user, silent)
		if datamanagementEntry[self] then for i = 1, #datamanagementEntry[self].keys do wt.ResetSettingsData(datamanagementEntry[self].category, datamanagementEntry[self].keys[i]) end end

		if not silent then settingsmanager.invoke.reset(user == true) end
	end

	ds.Log(function() return "Widget base mutated into Settingsmanager base: " .. us.ToString(settingsmanager), wt.title .. ".buildSettingsmanager" end)

	return settingsmanager
end

--[ Constructors ]

function wt.CreateSettingsmanager(t, widget)
	if not settingsmanager_base then settingsmanager_base = buildSettingsmanager() end

	local typenameBase = "Widget" ---@type typename_widget

	local settingsmanager = setmetatable(wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t), settingsmanager_base) ---@cast settingsmanager settingsmanager

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	if type(t.dataManagement) == "table" then
		datamanagementEntry[settingsmanager] = t.dataManagement
		autoLoad[settingsmanager] = t.autoLoad ~= false
		autoSave[settingsmanager] = t.autoSave ~= false

		if type(datamanagementEntry[settingsmanager].category) ~= "string" then
			datamanagementEntry[settingsmanager].category = type(t.name) == "string" and t.name:gsub("%s+", "") or tostring(datamanagementEntry[settingsmanager])
		end

		if type(datamanagementEntry[settingsmanager].keys) == "table" and type(datamanagementEntry[settingsmanager].keys[1]) ~= "string" then
			datamanagementEntry[settingsmanager].keys = { datamanagementEntry[settingsmanager].category }
		end
	end

	ds.Log(function() return
		"Widget instance mutated into Settingsmanager instance: " .. us.ToString(settingsmanager) .. " with base: " .. action_base,
		wt.title .. ".CreateSettingsmanager"
	end)

	return settingsmanager
end

function wt.CreateSettingsCategory(addon, parent, pages, t, settingsmanager) --FIX lite
	if not addon or not C_AddOns.IsAddOnLoaded(addon) or wt.IsWidget(parent) ~= "SettingsPage" and not parent.category then return nil end

	t = type(t) == "table" and t or {}

	---@type settingsCategory
	local category = { pages = {} }

	--[ Getters & Setters ]

	function category.getTypes() return "SettingsCategory" end
	function category.isType(type) return type == "SettingsCategory" end

	--[ Utilities ]

	--| Batched settings data management

	function category.load(handleChanges, user)
		for i = 1, #category.pages do category.pages[i].load(handleChanges, user) end

		if t.onLoad then t.onLoad(user == true) end
	end

	function category.defaults(user, callListeners)
		for i = 1, #category.pages do
			local dataManagement = category.pages[i].categorySyncer.dataManagement --REPLACE
			local onDefault = callListeners ~= false and category.pages[i].categorySyncer.onDefault or nil --REPLACE

			--Update with default values
			if type(dataManagement) == "table" and type(dataManagement.keys) == "table" then for j = 1, #dataManagement.keys do
				wt.ResetSettingsData(dataManagement.category, dataManagement.keys[j])
			end end

			if type(onDefault) == "function" then onDefault(user == true, true) end
		end

		if type(t.onDefaults) == "function" then t.onDefaults(user == true) end
	end

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

--| Settings page

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

	if not WidgetToolsDB.lite or t.ignoreLite == false then

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

	widget_types[page][typename] = true

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


--[[ PROFILES ]]

local profilemanager_base ---@type profilemanager

local profiles_accountData ---@type table<profilemanager, profileStorage>
local profiles_characterData ---@type table<profilemanager, characterProfileData>
local profiles_defaultData ---@type table<profilemanager, table>

local profiles_deletePopup ---@type table<profilemanager, string>
local profiles_resetPopup ---@type table<profilemanager, string>

local profiles_activeIndex ---@type table<profilemanager, integer>

local profiles_category ---@type table<profilemanager, string>
local profiles_valueChecker ---@type table<profilemanager, function>
local profiles_onRecovery ---@type table<profilemanager, function>
local profiles_recoveryMap ---@type table<profilemanager, table>

local invoke_profileLoaded ---@type fun(self: profilemanager, user?: boolean)
local handlers_profileLoaded ---@type table<profilemanager, profilemanager_handler_loaded[]>

local invoke_profileActivated ---@type fun(self: profilemanager, success: boolean, user?: boolean)
local handlers_profileActivated ---@type table<profilemanager, profilemanager_handler_activated[]>

local invoke_profileCreated ---@type fun(self: profilemanager, user?: boolean, index: integer, title: string)
local handlers_profileCreated ---@type table<profilemanager, profilemanager_handler_created[]>

local invoke_profileRenamed ---@type fun(self: profilemanager, success: boolean, user?: boolean, index: any, title?: string)
local handlers_profileRenamed ---@type table<profilemanager, profilemanager_handler_renamed[]>

local invoke_profileDeleted ---@type fun(self: profilemanager, success: boolean, user?: boolean, index: any, title?: string)
local handlers_profileDeleted ---@type table<profilemanager, profilemanager_handler_deleted[]>

local invoke_profileReset ---@type fun(self: profilemanager, profilemanager, success: boolean, user?: boolean, index: any, title?: string)
local handlers_profileReset ---@type table<profilemanager, profilemanager_handler_reset[]>

local function buildProfilemanager()
	local profilemanager = buildWidget() ---@cast profilemanager profilemanager

	--[ Type ]

	local typename = "Profilemanager" ---@type typename_profilemanager

	widget_types[profilemanager][typename] = true

	--[ Profile ]

	---Set the active profile
	---@param index? integer ***Default:*** `activeIndex` or `1`
	local function setActiveProfile(self, index)
		local profiles = profiles_accountData[self].profiles
		local profile = profiles[index]
		index = Clamp(type(index) == "number" and type(profile) == "table" and math.floor(index) or profiles_activeIndex[self], 1, #profiles)

		profiles_activeIndex[self] = index
		profilemanager.data = profile.data

		--Update selected profile in the character-specific data
		profiles_characterData[self].activeProfile = index

		return index
	end

	function profilemanager:activate(index, user, silent)
		if type(index) ~= "number" then
			if not silent then invoke_profileActivated(self, false, user) end

			return nil
		end

		index = setActiveProfile(self, index)

		if not silent then invoke_profileActivated(self, true, user) end

		return index
	end

	if not invoke_profileActivated then invoke_profileActivated = function(self, success, user)
		local handlers = handlers_profileActivated[self]
		local activeTitle = profiles_accountData[self].profiles[profiles_activeIndex[self]].title
		user = user == true

		for i = 1, #handlers do	handlers[i](profilemanager, success, user, profiles_activeIndex[self], activeTitle) end
	end end

	function profilemanager:findIndex(title, skipFirst)
		local profiles = profiles_accountData[self]

		for i = 1, #profiles do if profiles[i].title == title then if skipFirst then skipFirst = false else return i end end end
	end

	---Find an unused profile name to be able to use it as an identifying display title
	---@param name? string ***Default:*** `"Profile"`
	---@param number? integer ***Default:*** `2`
	---@param skipFirst? boolean ***Default:*** `false`
	---@return string title
	local function checkName(name, number, skipFirst)
		name = name or wt.strings.profiles.select.profile
		local title = name .. (number and (" " .. number) or "")

		--Find an unused name for the new profile
		if profilemanager:findIndex(title, skipFirst) then
			number = (number and number or 2)
			title = name .. " " .. number

			while profilemanager:findIndex(title) do
				number = number + 1
				title = name .. " " .. number
			end
		end

		return title
	end

	function profilemanager:create(name, number, duplicate, index, apply, user, silent)
		index = Clamp(type(index) == "number" and math.floor(index) or #profiles_accountData[self].profiles + 1, 1, #profiles_accountData[self].profiles + 1)
		local d = type(profiles_accountData[self].profiles[duplicate]) == "table" and profiles_accountData[self].profiles[duplicate] or nil

		--Create profile data
		table.insert(profiles_accountData[self].profiles, index, {
			title = checkName(d and d.title or name, number),
			data = us.Clone(d and d.data or profiles_defaultData[self])
		})

		if not silent then invoke_profileCreated(self, user, index, profiles_accountData[self].profiles[index].title) end

		--Activate the new profile
		if apply ~= false then profilemanager:activate(index, user, silent) end
	end

	if not invoke_profileCreated then invoke_profileCreated = function(self, success, user)
		local handlers = handlers_profileCreated[self]
		local activeTitle = profiles_accountData[self].profiles[profiles_activeIndex[self]].title
		user = user == true

		for i = 1, #handlers do	handlers[i](profilemanager, user, profiles_activeIndex[self], activeTitle) end
	end end

	function profilemanager:rename(index, name, number, user, silent)
		if index and not profiles_accountData[self].profiles[index] then
			if not silent then invoke_profileRenamed(self, false, user, index) end

			return false
		end

		index = index or profiles_activeIndex[self]
		local title = checkName(name, number)

		profiles_accountData[self].profiles[index].title = title

		if not silent then invoke_profileRenamed(self, true, user, index, title) end

		return true
	end

	if not invoke_profileRenamed then invoke_profileRenamed = function(self, success, user)
		local handlers = handlers_profileRenamed[self]
		local activeTitle = profiles_accountData[self].profiles[profiles_activeIndex[self]].title
		user = user == true

		for i = 1, #handlers do	handlers[i](profilemanager, success, user, profiles_activeIndex[self], activeTitle) end
	end end

	function profilemanager:delete(index, unsafe, user, silent)
		if index and not profiles_accountData[self].profiles[index] then
			if not silent then profilemanager.invoke.deleted(false, user == true, index) end

			return false
		end

		index = index or profiles_activeIndex[self]
		local title = profiles_accountData[self].profiles[index].title

		local function delete(s)
			table.remove(profiles_accountData[s].profiles, index)

			if not silent then profilemanager.invoke.deleted(true, user == true, index, title) end

			--Activate the replacement profile
			if profiles_activeIndex[s] == index then profilemanager.activate(index, user, silent) end
		end

		if unsafe then delete(self) else StaticPopup_Show(wt.UpdatePopupDialog(profiles_deletePopup[self], {
			text = wt.strings.profiles.delete.warning:gsub("#PROFILE", cr(profiles_accountData[self].profiles[index].title, NORMAL_FONT_COLOR)):gsub("#ADDON", profiles_category[self]),
			onAccept = function() delete(self) end,
		})) end

		return true
	end

	if not invoke_profileDeleted then invoke_profileDeleted = function(self, success, user)
		local handlers = handlers_profileDeleted[self]
		local activeTitle = profiles_accountData[self].profiles[profiles_activeIndex[self]].title
		user = user == true

		for i = 1, #handlers do	handlers[i](profilemanager, success, user, profiles_activeIndex[self], activeTitle) end
	end end

	function profilemanager:reset(index, unsafe, user, silent)
		if index and not profiles_accountData[self].profiles[index] then
			if not silent then invoke_profileReset(self, false, user, index) end

			return false
		end

		index = index or profiles_activeIndex[self]

		local function reset()
			--Update the profile in storage (without breaking table references)
			us.CopyValues(profiles_accountData[self].profiles[index].data, profiles_defaultData[self])

			if not silent then invoke_profileReset(self, true, user, index, profiles_accountData[self].profiles[index].title) end
		end

		if unsafe then reset() else StaticPopup_Show(wt.UpdatePopupDialog(resetProfilePopup, {
			text = wt.strings.profiles.reset.warning:gsub("#PROFILE", cr(profiles_accountData[self].profiles[index].title, NORMAL_FONT_COLOR)):gsub("#ADDON", profiles_category[self]),
			onAccept = reset,
		}))end

		return true
	end

	if not invoke_profileReset then invoke_profileReset = function(self, success, user)
		local handlers = handlers_profileReset[self]
		local activeTitle = profiles_accountData[self].profiles[profiles_activeIndex[self]].title
		user = user == true

		for i = 1, #handlers do	handlers[i](profilemanager, success, user, profiles_activeIndex[self], activeTitle) end
	end end

	function profilemanager:validate(profileData, compareWith)
		if type(profileData) ~= "table" then return profileData end

		compareWith = type(compareWith) == "table" and compareWith or profiles_defaultData[self]

		us.Prune(profileData, profiles_valueChecker[self])
		us.Fill(profileData, compareWith)
		us.Filter(profileData, compareWith, profiles_recoveryMap[self], profiles_onRecovery[self])

		return profileData
	end

	---Clean up a profile list table
	---@param list profile[]
	local function validateProfiles(list)
		local index = 1

		--Check profile list
		for key, value in us.SortedPairs(list) do
			if key == index and type(value) == "table" then
				--Check profile data
				if type(list[index].data) == "table" then profilemanager:validate(list[index].data) else list[index].data = us.Clone(profiles_defaultData[self]) end
			else
				--Remove invalid entry
				list[key] = nil
			end

			index = index + 1
		end

		--Fill with default profile
		if not list[1] then list[1] = { title = wt.strings.profiles.select.main, data = us.Clone(profiles_defaultData[self]) } end

		--Check profile names
		for i = 1, #list do list[i].title = checkName(list[i].title, nil, true) end
	end

	function profilemanager:load(p, activeProfile, user, silent)

		--| Profile list

		if type(p) == "table" then
			p.profiles = type(p.profiles) == "table" and p.profiles or {}

			validateProfiles(p.profiles)

			--Update the profile list in storage (without breaking table references)
			for i = 1, #p.profiles do
				profiles_accountData[self].profiles[i].title = p.profiles[i].title
				us.CopyValues(profiles_accountData[self].profiles[i].data, p.profiles[i].data)
			end
		else
			profiles_accountData[self].profiles = type(profiles_accountData[self].profiles) == "table" and profiles_accountData[self].profiles or {}

			validateProfiles(profiles_accountData[self].profiles)
		end

		--| Activate profile

		activeProfile = setActiveProfile(self, activeProfile or profiles_activeIndex[self])

		--| Recover misplaced data

		local recovered = {}

		--Remove & save misplaced possibly valuable data
		for key, value in pairs(profiles_accountData[self]) do if key ~= "profiles" then
			recovered[key] = value
			profiles_accountData[self][key] = nil
		end end

		if next(recovered) then
			--Pack recovered data into the active profile data table (to be removed later if found irrelevant or invalid during validation)
			us.Pull(profilemanager.data, recovered)

			--Validate active profile data
			profilemanager:validate(profilemanager.data)

			ds.Log(function() return "Recovered misplaced data:" .. us.TableToString(recovered), wt.title .. " • Profilemanager (" .. profiles_category[self] .. "):load" end)
		end

		--| Call listeners

		if not silent then
			user = user == true

			invoke_profileLoaded(self, user)
			invoke_profileActivated(self, true, user)
		end
	end

	if not invoke_profileLoaded then invoke_profileLoaded = function(self, success, user)
		local handlers = handlers_profileLoaded[self]
		local activeTitle = profiles_accountData[self].profiles[profiles_activeIndex[self]].title
		user = user == true

		for i = 1, #handlers do	handlers[i](profilemanager, success, user, profiles_activeIndex[self], activeTitle) end
	end end

	ds.Log(function() return "Widget base mutated into Profilemanager base: " .. us.ToString(profilemanager), wt.title .. ".buildProfilemanager" end)

	return profilemanager
end

--[ Constructors ]

function wt.CreateProfilemanager(accountData, characterData, defaultData, t, widget)
	if type(accountData) ~= "table" or type(characterData) ~= "table" or type(defaultData) ~= "table" then return nil end

	if not profilemanager_base then profilemanager_base = buildProfilemanager() end

	local typenameBase = "Widget" ---@type typename_widget

	local profilemanager = setmetatable(wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t), profilemanager_base) ---@cast profilemanager profilemanager

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	profilemanager.data = {}
	profilemanager.firstLoad = type(accountData.profiles) ~= "table"
	profilemanager.newCharacter = type(characterData.activeProfile) ~= "number"

	profiles_valueChecker[profilemanager] = t.valueChecker
	profiles_onRecovery[profilemanager] = t.onRecovery
	profiles_recoveryMap[profilemanager] = t.recoveryMap

	t.category = type(t.category) == "string" and t.category or ""
	local category = t.category:len() > 0 and t.category or "Addon"
	profiles_category[profilemanager] = category

	profiles_deletePopup[profilemanager] = wt.RegisterPopupDialog(category .. "_DELETE_PROFILE", { accept = DELETE, })
	profiles_resetPopup[profilemanager] = wt.RegisterPopupDialog(category .. "RESET_PROFILE")

	profiles_activeIndex[profilemanager] = 1

	profilemanager:load(nil, nil, false, true)

	ds.Log(function() return
		"Widget instance mutated into Profilemanager instance: " .. us.ToString(profilemanager) .. " with base: " .. action_base,
		wt.title .. ".CreateProfilemanager"
	end)

	return profilemanager
end

--| Settings page

function wt.CreateProfilesPage(accountData, characterData, defaultData, settingsData, t, profilemanager)
	if type(settingsData) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	local typenameBase = "Profilemanager" ---@type typename_profilemanager

	profilemanager = wt.IsWidget(profilemanager, typenameBase) and profilemanager or wt.CreateProfilemanager(accountData, characterData, defaultData, t)

	if not profilemanager then return nil elseif WidgetToolsDB.lite and t.lite ~= false then return profilemanager end

	local profilesPage = profilemanager ---@cast profilesPage profilesPage

	--[ Type ]

	local typename = "ProfilesPage" ---@type typename_profilesPage

	widget_types[profilesPage][typename] = true

	--[ Settings Page ]

	local onDefault = type(t.onDefault) == "function" and t.onDefault or nil

	profilesPage.settings = wt.CreateSettingsPage({
		register = t.register,
		name = t.name or "DataManagement",
		title = t.title or wt.strings.profilesPage.title,
		description = t.description or wt.strings.profilesPage.description:gsub("#ADDON", addonTitle),
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
		initialize = function(canvas, _, _, category, keys) if not WidgetToolsDB.lite or t.ignoreLite == false then

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
							listeners = { loaded = { { handler = function() profilesPage.backupAll.compact.template:SetChecked(settingsData.compactBackup) end, }, }, },
							events = { OnClick = function(_, state) profilesPage.backupAll.compact.template:SetChecked(state) end },
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
								relativeTo = load.frame,
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
										relativeTo = loadAll.frame,
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

	return profilesPage
end


--[[ ADDON ]]

local addonmanager_base ---@type addonmanager

local addonmanager_addonData ---@type table<addonmanager, addonInfo>

local invoke_addonChanged ---@type fun(self: addonmanager, user: boolean)
local handlers_addonChanged ---@type table<addonmanager, addonmanager_handler_changed[]>

local function buildAddonmanager()
	local addonmanager = buildWidget() ---@cast addonmanager addonmanager

	--[ Type ]

	local typename = "Addonmanager" ---@type typename_addonmanager

	widget_types[addonmanager][typename] = true

	--[ Metadata ]

	if not addonmanager_addonData then addonmanager_addonData = {} end

	function addonmanager:getName() return addonmanager_addonData[self].name end
	function addonmanager:getTitle() return addonmanager_addonData[self].title end
	function addonmanager:getNotes() return addonmanager_addonData[self].notes end
	function addonmanager:getLogo() return addonmanager_addonData[self].logo end
	function addonmanager:getCategory() return addonmanager_addonData[self].category end
	function addonmanager:getAuthor() return addonmanager_addonData[self].author end
	function addonmanager:getVersion() return addonmanager_addonData[self].version end
	function addonmanager:getDate()
		local data = addonmanager_addonData[self]

		return data.date, data.day, data.month, data.year
	end
	function addonmanager:getLicense() return addonmanager_addonData[self].license end
	function addonmanager:getCurseForgeLink() return addonmanager_addonData[self].curse end
	function addonmanager:getWagoLink() return addonmanager_addonData[self].wago end
	function addonmanager:getRepositoryLink() return addonmanager_addonData[self].repo end
	function addonmanager:getIssuesLink() return addonmanager_addonData[self].issues end
	function addonmanager:getSponsors() return addonmanager_addonData[self].sponsors end
	function addonmanager:getChangelog()
		local data = addonmanager_addonData[self]

		return data.changelog_latest, data.changelog_full
	end

	--| Rebind

	if not invoke_addonChanged then invoke_addonChanged = function(self, user)
		local handlers = handlers_addonChanged[self]

		if not handlers then return end

		local name = addonmanager_addonData[self].name
		user = user == true

		for i = 1, #handlers do handlers[i](self, name, user) end
	end end

	function addonmanager:setAddon(newAddon, newChangelog, user, silent)
		if newAddon == addonmanager_addonData then return true end

		local addon_type = type(newAddon)

		if addon_type ~= "string" then
			if not C_AddOns.IsAddOnLoaded(newAddon) then return false end
			if addon_type ~= "number" then return false else newAddon = C_AddOns.GetAddOnName(newAddon) end
		end

		local data = addonmanager_addonData[self]

		if not data then
			data = {
				name = newAddon,
				title = C_AddOns.GetAddOnTitle(newAddon),
				notes = C_AddOns.GetAddOnNotes(newAddon),
				logo = C_AddOns.GetAddOnMetadata(newAddon, "IconTexture"),
				category = C_AddOns.GetAddOnMetadata(newAddon, "Category"),
				author = C_AddOns.GetAddOnMetadata(newAddon, "Author"),
				version = C_AddOns.GetAddOnMetadata(newAddon, "Version"),
				day = tonumber(C_AddOns.GetAddOnMetadata(newAddon, "X-Day")),
				month = tonumber(C_AddOns.GetAddOnMetadata(newAddon, "X-Month")),
				year = tonumber(C_AddOns.GetAddOnMetadata(newAddon, "X-Year")),
				license = C_AddOns.GetAddOnMetadata(newAddon, "X-License"),
				curse = C_AddOns.GetAddOnMetadata(newAddon, "X-CurseForge"),
				wago = C_AddOns.GetAddOnMetadata(newAddon, "X-Wago"),
				repo = C_AddOns.GetAddOnMetadata(newAddon, "X-Repository"),
				issues = C_AddOns.GetAddOnMetadata(newAddon, "X-Issues"),
				sponsors = C_AddOns.GetAddOnMetadata(newAddon, "X-Sponsors"),
			}

			data.date = data.day and data.month and data.year and wt.strings.date:gsub("#DAY", data.day):gsub("#MONTH", data.month):gsub("#YEAR", data.year) or nil

			if newChangelog then data.changelog_latest, data.changelog_full = us.FormatChangelog(newChangelog, true), us.FormatChangelog(newChangelog) end

			addonmanager_addonData[self] = data
		end

		if not silent then invoke_addonChanged(self, user) end

		return true
	end

	ds.Log(function() return "Widget base mutated into Addonmanager base: " .. us.ToString(addonmanager), wt.title .. ".buildAddonmanager" end)

	return addonmanager
end

--[ Constructors ]

function wt.CreateAddonmanager(t, widget)
	if not addonmanager_base then addonmanager_base = buildAddonmanager() end

	local typenameBase = "Widget" ---@type typename_widget

	local addonmanager = setmetatable(wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t), addonmanager_base) ---@cast addonmanager addonmanager

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	addonmanager:setAddon(t.addon, t.changelog)

	ds.Log(function() return
		"Widget instance mutated into Addonmanager instance: " .. us.ToString(addonmanager) .. " with base: " .. action_base,
		wt.title .. ".CreateAddonmanager"
	end)

	return addonmanager
end

--| Settings page

function wt.CreateAddonPage(t, addonmanager)
	t = type(t) == "table" and t or {}

	local typenameBase = "Addonmanager" ---@type typename_addonmanager

	local addonPage = wt.IsWidget(addonmanager, typenameBase) and addonmanager or wt.CreateAddonmanager(t) ---@cast addonPage addonPage

	local data = addonmanager_addonData[addonPage]

	if not data then return nil end

	--Make read-only
	addonPage.setAddon = nil

	--[ Type ]

	local typename = "AddonPage" ---@type typename_addonPage

	widget_types[addonPage][typename] = true

	--[ Settings Page ]

	addonPage.settings = wt.CreateSettingsPage({
		register = t.register,
		name = t.name or "About",
		title = t.title or data.title,
		description = t.description or data.notes,
		static = t.static ~= false,
		arrangement = {},
		initialize = function(canvas)

			--[ About ]

			wt.CreatePanel({
				parentFrame = canvas,
				name = "About",
				title = wt.strings.about.title,
				description = wt.strings.about.description:gsub("#ADDON", data.title),
				arrange = {},
				size = { h = 240 },
				arrangement = {
					flip = true,
					resize = false
				},
				initialize = function(_, panel, _, _, name)

					--[ Information ]

					local position = { offset = { x = 16, y = -14 } }

					if data.version then
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
							text = data.version .. data.date and (crc(" ( " .. wt.strings.about.date .. ": " .. cr(data.date, NORMAL_FONT_COLOR) .. ")", "FFFFFFFF") or ""),
							font = "GameFontNormalSmall",
							justify = { h = "LEFT", },
							wrap = false,
						})

						position.relativeTo = versionLabel
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -6
					end

					if data.category then
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
							text = data.category,
							font = "GameFontNormalSmall",
							justify = { h = "LEFT", },
						})

						position.relativeTo = categoryLabel
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -6
					end

					if data.author then
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
							text = data.author,
							font = "GameFontNormalSmall",
							justify = { h = "LEFT", },
							wrap = false,
						})

						position.relativeTo = authorLabel
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -6
					end

					if data.license then
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
							text = data.license,
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

					if data.curse then
						local curseLink = wt.CreateCopybox({
							parentFrame = panel,
							name = "CurseForge",
							title = wt.strings.about.curseForge,
							position = position,
							size = { w = 190, },
							value = data.curse,
						})

						position.relativeTo = curseLink.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if data.wago then
						local wagoLink = wt.CreateCopybox({
							parentFrame = panel,
							name = "Wago",
							title = wt.strings.about.wago,
							position = position,
							size = { w = 190, },
							value = data.wago,
						})

						position.relativeTo = wagoLink.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if data.repo then
						local repoLink = wt.CreateCopybox({
							parentFrame = panel,
							name = "Repository",
							title = wt.strings.about.repository,
							position = position,
							size = { w = 190, },
							value = data.repo,
						})

						position.relativeTo = repoLink.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if data.issues then wt.CreateCopybox({
						parentFrame = panel,
						name = "Issues",
						title = wt.strings.about.issues,
						position = position,
						size = { w = 190, },
						value = data.issues,
					}) end

					--[ Changelog ]

					if not data.changelog_latest then return end

					local changelogTextbox = wt.CreateMultilineEditbox({
						parentFrame = panel,
						name = "ChangelogBox",
						title = wt.strings.about.changelog.label,
						tooltip = { lines = { { text = wt.strings.about.changelog.tooltip:gsub("#VERSION", crc(data.version or "?", "FFFFFFFF")), }, } },
						arrange = {},
						size = { w = panel:GetWidth() - 225, h = panel:GetHeight() - 25 },
						font = { normal = "GameFontDisableSmall", },
						color = rs.colors.grey[1],
						value = data.changelog_latest,
						readOnly = true,
					})

					if not data.changelog_full then return end

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
							title = wt.strings.about.fullChangelog.label:gsub("#ADDON", data.title),
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
									title = wt.strings.about.fullChangelog.label:gsub("#ADDON", data.title),
									label = false,
									tooltip = { lines = { { text = wt.strings.about.fullChangelog.tooltip, }, } },
									arrange = {},
									size = { w = windowPanel:GetWidth() - 32, h = windowPanel:GetHeight() - 58 },
									font = { normal = "GameFontDisable", },
									color = rs.colors.grey[1],
									value = data.changelog_full,
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

			local sponsors, topSponsors = data.sponsors:split("; ")

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

	ds.Log(function() return "Addonmanager instance mutated into AddonPage GUI instance: " .. us.ToString(addonPage), wt.title .. ".CreateAddonPage" end)

	return addonPage
end


--[[ CHAT COMMANDS ]]

local chatmanager_base ---@type chatmanager

local chatmanager_keywords ---@type table<chatmanager, string[]>
local chatmanager_commands ---@type table<chatmanager, chatCommandData[]>
local chatmanager_colors ---@type table<chatmanager, table>

local chatmanager_onWelcome ---@type table<chatmanager, function>

local function buildChatmanager()
	local chatmanager = buildWidget() ---@cast chatmanager chatmanager

	--[ Type ]

	local typename = "Chatmanager" ---@type typename_chatmanager

	widget_types[chatmanager][typename] = true

	--[ Print ]

	function chatmanager:print(message, title, titleColor, contentColor)
		local colors = chatmanager_colors[chatmanager]

		title = type(title) == "string" and title or branding
		titleColor = wt.IsColor(titleColor) or colors[type(titleColor) == "string" and titleColor or "title"]
		contentColor = wt.IsColor(contentColor) or colors[type(contentColor) == "string" and contentColor or "content"]

		if type(message) == "string" then print(cr(title, titleColor) .. cr(message, contentColor)) end
	end

	function chatmanager:welcome()
		local keywords = chatmanager_keywords[chatmanager]
		local colors = chatmanager_colors[chatmanager]

		local keyword = cr(keywords[1], colors.command)
		if #keywords > 1 then
			if #keywords > 2 then for i = 2, #keywords - 1 do keyword = " " .. keyword .. "," .. cr(keywords[i], colors.command) end end
			keyword = wt.strings.chat.welcome.keywords:gsub("#KEYWORD_ALTERNATE", cr(keywords[#keywords], colors.command)):gsub("#KEYWORD", keyword)
		end

		print(cr(icon .. wt.strings.chat.welcome.thanks:gsub("#ADDON", cr(addonTitle, colors.title)), colors.content))
		print(cr(wt.strings.chat.welcome.hint:gsub("#KEYWORD", keyword), colors.description))

		if chatmanager_onWelcome[chatmanager] then chatmanager_onWelcome[chatmanager]() end
	end

	--| Commands

	function chatmanager:help()
		local commands = chatmanager_commands[chatmanager]
		local keywords = chatmanager_keywords[chatmanager]
		local colors = chatmanager_colors[chatmanager]

		print(cr(wt.strings.chat.help.list:gsub("#ADDON", cr(icon .. addonTitle, colors.title)), colors.content))

		for i = 1, #commands do
			if not commands[i].hidden then
				local description = type(commands[i].description) == "function" and commands[i].description() or commands[i].description

				print(cr("    " .. keywords[1] .. " ".. commands[i].command, colors.command) .. (
					type(description) == "string" and cr(" • " .. description, colors.description) or ""
				))
			end

			if type(commands[i].onHelp) == "function" then commands[i].onHelp() end
		end
	end

	function chatmanager:trigger(commandName, ...)
		local commands = chatmanager_commands[chatmanager]

		for i = 1, #commands do
			local command = commands[i]

			if commandName == command.command then
				if type(command.handler) == "function" then
					local results = { command.handler(chatmanager, ...) }

					if results[1] == true then
						local message = type(command.success) == "function" and command.success(unpack(results, 2)) or command.success

						if type(message) == "string" then chatmanager:print(message) end

						if type(command.onSuccess) == "function" then command.onSuccess(chatmanager, unpack(results, 2)) end
					elseif results[1] == false then
						local message = type(command.error) == "function" and command.error(unpack(results, 2)) or command.error

						if type(message) == "string" then chatmanager:print(message) end

						if type(command.onError) == "function" then command.onError(chatmanager, unpack(results, 2)) end
					end
				end

				if commands[i].help then chatmanager:help() end

				return true
			end
		end

		return false
	end

	ds.Log(function() return "Widget base mutated into Addonmanager base: " .. us.ToString(chatmanager), wt.title .. ".buildAddonmanager" end)

	return chatmanager
end

function wt.CreateChatmanager(keywords, t, widget)
	if not chatmanager_base then chatmanager_base = buildChatmanager() end

	local typenameBase = "Widget" ---@type typename_widget

	local chatmanager = setmetatable(wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t), chatmanager_base) ---@cast chatmanager chatmanager

	--[ Initialization ]

	t = type(t) == "table" and t or {}

	--| Color palette

	t.colors = t.colors or {}

	chatmanager_colors[chatmanager] = {
		title = wt.IsColor(t.colors.title) or YELLOW_FONT_COLOR,
		content = wt.IsColor(t.colors.content) or WHITE_FONT_COLOR,
		command = wt.IsColor(t.colors.command) or LIGHTBLUE_FONT_COLOR,
		description = wt.IsColor(t.colors.description) or LIGHTGRAY_FONT_COLOR,
	}

	chatmanager_commands[chatmanager] = type(t.commands) == "table" and t.commands or {}

	if type(chatmanager_onWelcome[chatmanager]) == "function" then chatmanager_onWelcome[chatmanager] = t.onWelcome end

	--| Addon branding

	local addon, title, icon

	if wt.IsWidget(t.addon, "Addonmanager") then
		addon = t.addon:getName()
		title = t.addon:getTitle()
		icon = t.addon:getLogo()
	else
		local addon_type = type(addon)

		if (addon_type == "string" or addon_type == "number") and C_AddOns.IsAddOnLoaded(addon) then
			addon = (addon_type ~= "string" and C_AddOns.GetAddOnName(addon) or addon):upper()
			title = wt.Clear(select(2, C_AddOns.GetAddOnInfo(addon))):gsub("^%s*(.-)%s*$", "%1")
			icon = C_AddOns.GetAddOnMetadata(addon, "IconTexture")
		end
	end

	icon = icon and (wt.Texture(icon, 11, 11) .. " ") or ""
	local branding = icon .. title .. ": "

	--| Keywords

	if type(keywords) == "table" then
		--Register the keywords
		for i = 1, #keywords do
			keywords[i] = "/" .. keywords[i]
			_G["SLASH_" .. addon .. i] = keywords[i]
		end

		local defaultHandler = type(t.defaultHandler) == "function" and t.defaultHandler or nil

		--Set global keyword handler
		SlashCmdList[addon] = function(line)
			local payload = { strsplit(" ", line) }
			local command = payload[1]

			if not chatmanager:trigger(command, unpack(payload, 2)) then
				if defaultHandler then defaultHandler(chatmanager, command, unpack(payload, 2)) end

				chatmanager:help()
			end
		end
	end

	return chatmanager
end
