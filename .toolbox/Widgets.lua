local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")] ---@type toolbox

if not wt then return end

local us = WidgetTools.utilities
local ds = WidgetTools.debugging

local cr = C_ColorUtil.WrapTextInColor
local crc = C_ColorUtil.WrapTextInColorCode

--[[ WIDGET ]]

local widget_base ---@type widget

local types ---@type table<anyWidget, table<typename_widget, true>>

local handlers ---@type table<anyWidget, table<string, fun(self: anyWidget, ...: any)[]>>

local invoke_enabled ---@type fun(self: anyWidget, user: boolean)
local handlers_enabled ---@type table<anyWidget, widget_handler_enabled[]>

local parent ---@type table<anyWidget, anyWidget>
local children ---@type table<anyWidget, anyWidget[]>
local isIndependent ---@type table<anyWidget, table<widget, boolean>>

local enabled ---@type table<anyWidget, boolean>

local dependencies ---@type table<anyWidget, dependencyType[]>
local isData ---@type table<anyWidget, table<dependencyType, true|function>>
local evaluate ---@type table<anyWidget, table<dependencyType, dependencyEvaluator>>

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
	local widget = { __metatable = "Base" }
	widget.__index = widget ---@cast widget widget

	--[ Type ]

	if not types then types = {} end

	local typename = "Widget" ---@type typename_widget

	types[widget] = { [typename] = true }

	function widget:getTypes() return us.Clone(types[widget]) end
	function widget:isType(s) return types[widget][s] or false end

	--[ Events ]

	if not handlers then handlers = {} end

	function widget:addEvent(event)
		if not handlers[self] then handlers[self] = {} end
		if not handlers[self][event] then handlers[self][event] = {} end
	end

	function widget:invoke(event, ...)
		local h = handlers[self][event]

		for i = 1, #h do h[i](self, ...) end
	end

	function widget:addListener(event, handler, callIndex)
		local h = handlers[self][event]

		if not h or type(handler) ~= "function" then return end

		if type(callIndex) ~= "number" then table.insert(h, handler) else table.insert(h, Clamp(math.floor(callIndex), 1, #h + 1), handler) end
	end

	--[ Hierarchy ]

	--| Parent

	if not parent then parent = {} end

	function widget:getParent() return parent[self] end
	function widget:setParent(newParent, independent, childIndex)
		if newParent == widget or newParent == parent[self] then return false end

		if newParent == nil then
			local pastParent = parent[self]
			parent[self] = nil

			if pastParent and pastParent.hasChild(widget) then pastParent:removeChild(widget) end

			return true
		end

		if wt.IsWidget(newParent) then
			local pastParent = parent[self]
			parent[self] = newParent

			if pastParent and pastParent:hasChild(widget) then pastParent:removeChild(widget) end
			if not newParent:hasChild(widget) then newParent:addChild(widget, independent, childIndex) end

			return true
		end

		return false
	end

	--| Children

	if not children then children = {} end
	if not isIndependent then isIndependent = {} end

	function widget:hasChild(child) return isIndependent[self][child] ~= nil end
	function widget:getChild(index) return children[self][index] end
	function widget:getChildren()
		local c = {}

		for i = 1, #children[self] do c[i] = children[self][i] end

		return c
	end

	function widget:addChild(child, independent, index)
		if child == widget or not wt.IsWidget(child) or isIndependent[self][child] ~= nil then return nil end

		index = type(index) ~= "number" and #children[self] + 1 or Clamp(math.floor(index), 1, #children[self] + 1)

		table.insert(children[self], index, child)
		isIndependent[self][child] = independent == true

		if child:getParent() ~= widget then child:setParent(widget) end

		return index
	end

	function widget:removeChild(child)
		if isIndependent[self][child] == nil then return false end

		for i = 1, #children[self] do if children[self][i] == child then table.remove(children[self], i) break end end
		isIndependent[self][child] = nil

		if child:getParent() == widget then child:setParent(nil) end

		return true
	end

	function widget:isIndependent(child) return isIndependent[self][child] end
	function widget:setIndependent(child, independent) if isIndependent[self][child] == nil then return false else isIndependent[self][child] = independent ~= false return true end end

	--[ State ]

	if not enabled then enabled = {} end

	function widget:isEnabled() return enabled[self] end
	function widget:setEnabled(state, ignoreParent, ignoreDependencies, user, silent)
		if ignoreParent ~= true and parent[self] and not parent[self]:isIndependent(widget) then state = parent[self]:isEnabled() end

		if ignoreDependencies then enabled[self] = state ~= false else enabled[self] = state ~= false and widget:checkDependencies() end

		for i = 1, #children[self] do if not isIndependent[self][children[self][i]] then children[self][i]:setEnabled(state, true, false, user, silent) break end end

		if not silent then invoke_enabled(self, user) end
	end

	--| Event

	if not handlers_enabled then handlers_enabled = {} end

	function widget:addListener_enabled(handler, callIndex)
		if type(handler) ~= "function" then return end

		if not handlers_enabled[self] then handlers_enabled[self] = {} end

		local h = handlers_enabled[self]

		if type(callIndex) ~= "number" then table.insert(h, handler) else table.insert(h, Clamp(math.floor(callIndex), 1, #h + 1), handler) end
	end

	if not invoke_enabled then invoke_enabled = function(self, user)
		local h = handlers_enabled[self]

		for i = 1, #h do h[i](self, enabled[self], user == true) end
	end end

	--| Dependencies

	if not dependencies then dependencies = {} end
	if not isData then isData = {} end
	if not evaluate then evaluate = {} end

	function widget:addDependency(rule)
		if type(rule) ~= "table" then return false end

		local dependency = rule.dependency
		local index = type(rule.index) ~= "number" and #dependencies[self] + 1 or Clamp(math.floor(rule.index), 1, #dependencies[self] + 1)
		local data = rule.isData
		local evaluator = type(rule.evaluate) == "function" and rule.evaluate
		local setter = function() widget:setEnabled() end

		if wt.IsWidget(dependency) then
			if data then if wt.IsWidget(dependency, "Datamanager") and (wt.IsWidget(dependency, "Binary") or evaluator) then
				dependency:addListener_loaded(function(_, success) if success then widget:setEnabled() end end)
				dependency:addListener_changed(setter)

				table.insert(dependencies[self], index, dependency)
				isData[self][dependency] = true
				if evaluator then evaluate[self][dependency] = evaluator end

				return true
			end else
				dependency:addListener_enabled(setter)

				table.insert(dependencies[self], index, dependency)
				if evaluator then evaluate[self][dependency] = evaluator end

				return true
			end
		elseif us.IsFrame(dependency) then
			if data then
				local objectType = dependency:GetObjectType()
				local scriptType = dataObjectScriptType[objectType]

				if scriptType then
					dependency:HookScript(scriptType, widget.setEnabled)

					table.insert(dependencies[self], index, dependency)
					isData[self][dependency] = dependency[dataObjectValueGetterKeys[objectType]]
					if evaluator then evaluate[self][dependency] = evaluator end

					return true
				end
			elseif type(dependency.IsEnabled) == "function" and dependency:HasScript("OnEnable") and dependency:HasScript("OnDisable") then
				dependency:HookScript("OnEnable", widget.setEnabled)
				dependency:HookScript("OnDisable", widget.setEnabled)

				table.insert(dependencies[self], index, dependency)
				if evaluator then evaluate[self][dependency] = evaluator end

				return true
			end
		end

		return false
	end

	function widget:setDependencies(rules)
		dependencies[self] = {}
		isData[self] = {}
		evaluate[self] = {}

		for i = 1, #rules do widget:addDependency(rules[i]) end
	end

	function widget:checkDependencies()
		local state = true

		for i = 1, #dependencies[self] do
			local dependency = dependencies[self][i]
			local data = isData[self][dependency]

			if data then
				local value

				if wt.IsWidget(dependency, "Datamanager") then value = dependency.getValue() elseif type(data) == "function" then value = data(dependency) end

				if evaluate[self][dependency] then state = evaluate[self][dependency](value) else state = value end
			else
				if wt.IsWidget(dependency) then state = dependency:isEnabled() else state = dependency:IsEnabled() end

				if evaluate[self][dependency] then state = evaluate[self][dependency](state) end
			end

			if not state then break end
		end

		return state
	end

	return widget
end

function wt.CreateWidget(t)
	t = type(t) == "table" and t or {} ---@type widget_options

	if not widget_base then widget_base = buildWidget() end

	local widget = setmetatable({}, widget_base) ---@cast widget widget

	--Register event handlers
	if type(t.listeners) == "table" then if type(t.listeners.enabled) == "table" then for i = 1, #t.listeners.enabled do
		if type(t.listeners.enabled[i]) == "table" then widget:addListener_enabled(t.listeners.enabled[i].handler, t.listeners.enabled[i].callIndex) end
	end end end

	--Add custom events
	if type(t.customEvents) == "table" then for k, v in pairs(t.customEvents) do
		widget:addEvent(k)

		if type(v) == "table" then for i = 1, #v do widget:addListener(k, v[i].handler, v[i].callIndex) end
	end end end

	--Assign to parent
	if t.parent then widget:setParent(t.parent, t.independent, t.childIndex) end

	--Assign dependencies
	widget:setDependencies(t.dependencies)

	--Set starting state
	widget:setEnabled(t.disabled ~= true)

	return widget
end

--[ Action ]

local action_base ---@type action

local callAction ---@type table<action, fun(self: action, user?: boolean)>

local invoke_triggered ---@type fun(self: action, user: boolean)
local handlers_triggered ---@type table<action, action_handler_triggered[]>

local function buildAction()
	local action = buildWidget() ---@cast action action

	--[ Type ]

	local typename = "Action" ---@type typename_action

	types[action][typename] = true

	--[ Action ]

	if not callAction then callAction = {} end

	function action:trigger(user, silent)
		local call = callAction[self]

		if enabled[action] and call then call(action, user) end

		if not silent then invoke_triggered(self, user) end
	end

	function action:setAction(call) if type(call) == "function" then callAction = call end end

	--| Event

	if not invoke_triggered then invoke_triggered = function()

	end end

	return action
end

function wt.CreateAction(t, widget)
	t = type(t) == "table" and t or {}

	if not action_base then action_base = buildAction() end

	local typename = "Action" ---@type typename_action
	local typenameBase = "Widget" ---@type typename_widget

	widget = wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t)
	local action = widget ---@cast action action


	--[ Action ]

	local callAction = nil

	function action.trigger(user, silent)
		if action.isEnabled() and callAction then callAction(action, user) end

		if not silent then action.invoke.triggered(user) end
	end

	function action.setAction(call) if type(call) == "function" then callAction = call end end

	--Create event
	action.addEvent("triggered")

	action.setAction(t.action)

	return action
end


--[[ DATAMANAGER ]]

wt.clipboard = {}

function wt.CreateDatamanager(t, widget)
	t = type(t) == "table" and t or {}

	local typename = "Datamanager" ---@type typename_datamanager
	local typenameBase = "Widget" ---@type typename_widget

	widget = wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t)
	local datamanager = widget ---@cast datamanager datamanager

	datamanager.addType(typename)

	--[ Data ]

	local default, value, snapshot

	--| Datamanagement

	local datamanagement = t.dataManagement or nil

	--Register for datamanagement
	if datamanagement then wt.AddSettingsDataManagementEntry(datamanager, datamanagement) end

	--| Utilities

	function datamanager.verify(v) return us.Clone(v) end
	function datamanager.format(v) return v == nil and us.ToString(value) or us.ToString(v) end

	--| Storage

	local read = type(t.getData) == "function" and t.getData or nil
	local save = type(t.saveData) == "function" and t.saveData or nil

	if read then
		function datamanager.getData() return read() end
		function datamanager.loadData(handleChanges, silent)
			datamanager.setValue(read(), handleChanges ~= false, silent)

			if not silent then datamanager.invoke.loaded(true) end
		end
	else
		function datamanager.getData() return value end
		function datamanager.loadData(_, silent) if not silent then datamanager.invoke.loaded(false) end end
	end

	if save then function datamanager.saveData(data, silent)
		save(datamanager.verify(data))

		if not silent then datamanager.invoke.saved(true) end
	end else function datamanager.saveData(_, silent) if not silent then datamanager.invoke.saved(false) end end end

	function datamanager.setData(data, handleChanges, silent)
		datamanager.saveData(data, silent)
		datamanager.loadData(handleChanges, silent)
	end

	--Create events
	datamanager.addEvent("loaded")
	datamanager.addEvent("saved")

	--| Default

	function datamanager.getDefault() return default end
	function datamanager.setDefault(newDefault) default = datamanager.verify(newDefault) end
	function datamanager.resetData(handleChanges, silent) datamanager.setData(default, handleChanges, silent) end

	datamanager.setDefault(t.default)

	--| Value

	function datamanager.getValue() return value end
	function datamanager.setValue(newValue, user, silent)
		value = datamanager.verify(newValue)

		if value == nil and read then value = read() end
		if value == nil then value = default end

		if user then
			if t.instantSave ~= false then datamanager.saveData(nil, silent) end

			if datamanagement then wt.HandleWidgetChanges(datamanagement.index, datamanagement.category, datamanagement.key) end
		end

		if not silent then datamanager.invoke.changed(user == true) end
	end

	--Create event
	addEvent(datamanager, "changed", function(handlers) return function(user) for i = 1, #handlers do handlers[i](user, value) end end end)

	datamanager.setValue(t.value)

	--| Snapshot

	function datamanager.snapshotData(stored) if stored == true then snapshot = datamanager.getData() else snapshot = value end end
	function datamanager.revertData(handleChanges, silent) datamanager.setData(snapshot, handleChanges, silent) end

	datamanager.snapshotData()

	return datamanager
end

--[ Binary ]

function wt.CreateBinary(t, datamanager)
	t = type(t) == "table" and t or {}

	local typename = "Binary" ---@type typename_binary
	local typenameBase = "Datamanager" ---@type typename_datamanager

	datamanager = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t)
	local binary = datamanager ---@cast binary binary

	binary.addType(typename)

	--[ Data ]

	function binary.verify(value) return value == true end
	function binary.format(state)
		if type(state) ~= "boolean" then state = binary.getValue() end

		return crc((state and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), state and "FFAAAAFF" or "FFFFAA66")
	end

	function binary.flip(user, silent) binary.setValue(not binary.getValue(), user, silent) end

	binary.setDefault(t.default)
	binary.setValue(t.value, false, true)
	binary.snapshotData()

	return binary
end

--[ Selector ]

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

function wt.CreateSelector(t, datamanager)
	t = type(t) == "table" and t or {}

	local typename = "Selector" ---@type typename_selector
	local typenameBase = "Datamanager" ---@type typename_datamanager
	local typenameItem = "Binary" ---@type typename_binary

	datamanager = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t)
	local selector = datamanager ---@cast selector selector

	selector.addType(typename)

	--[ Items ]

	selector.items = {}
	local items = t.items or {}
	local inactive = {} ---@type selectorBinary[]

	---Register, update or set up a new binary widget item
	---***
	---@param index integer
	---@param silent? boolean ***Default:*** `false`
	local function setItem(index, silent)
		local item = items[index]
		local new = true

		if wt.IsWidget(items[index], typenameItem) then item.setParent(selector)
		elseif index > #selector.items then
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

		item.index = index
		item.addEvent("activated")
		selector.items[index] = item

		if new and not silent then selector.invoke.added(selector.items[index]) end
	end

	function selector.updateItems(newItems, silent)
		items = newItems

		--Update the binary widgets
		for i = 1, #newItems do
			setItem(i, silent)

			if not silent then selector.items[i].invoke.activated(true) end
		end

		--Deactivate extra binary widgets
		while #newItems < #selector.items do
			selector.items[#selector.items].setValue(false)

			if not silent then selector.items[#selector.items].invoke.activated(false) end

			table.insert(inactive, selector.items[#selector.items])
			table.remove(selector.items, #selector.items)
		end

		if not silent then selector.invoke.updated() end

		selector.setValue(selector.getValue(), nil, silent)
	end

	--Create events
	selector.addEvent("updated")
	selector.addEvent("added")

	--Register starting items
	for i = 1, #items do setItem(i) end

	--[ Data ]

	local clearable = t.clearable

	function selector.verify(value)
		value = type(value) == "number" and Clamp(math.floor(value), 1, #items) or nil

		return value and value or not clearable and value or nil
	end

	selector.setDefault(t.default)
	selector.setValue(t.value, false, true)
	selector.snapshotData()

	function selector.setValue(index, user, silent)
		value = selector.verify(index)

		for i = 1, #selector.items do selector.items[i].setValue(i == value, user, silent) end

		if user and t.instantSave ~= false then selector.saveData(nil, silent) end

		if not silent then selector.invoke.changed(user == true) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--Set starting value
	selector.setValue(value, false, true)

	return selector
end

function wt.CreateSpecialSelector(itemset, t, datamanager)
	t = type(t) == "table" and t or {}

	local typename = "SpecialSelector" ---@type typename_specialSelector
	local typenameBase = "Datamanager" ---@type typename_datamanager

	datamanager = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t)
	local specialSelector = datamanager ---@cast specialSelector specialSelector

	specialSelector.addType(typename)

	--[ Items ]

	specialSelector.items = {}
	local items = {} ---@type selectorItemData[]

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

	function specialSelector.loadData(handleChanges, silent)
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
		specialSelector.loadData(handleChanges, silent)
	end

	function specialSelector.getDefault() return itemsets[itemset][default] and itemsets[itemset][default].value or nil end
	function specialSelector.setDefault(selected) default = verify(selected) end
	function specialSelector.resetData(handleChanges, silent) specialSelector.setData(default, handleChanges, silent) end

	function specialSelector.snapshotData(stored) snapshot = stored and specialSelector.getData() or value end
	function specialSelector.revertData(handleChanges, silent) specialSelector.setData(snapshot, handleChanges, silent) end

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

	local typename = "Multiselector" ---@type typename_multiselector
	local typenameBase = "Datamanager" ---@type typename_datamanager
	local typenameItem = "Binary" ---@type typename_binary

	datamanager = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t)
	local multiselector = datamanager ---@cast multiselector multiselector

	multiselector.addType(typename)

	--[ Data ]

	--[ Items ]

	multiselector.items = {}
	local inactive = {} ---@type selectorBinary[]

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

	function multiselector.loadData(handleChanges, silent)
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
		multiselector.loadData(handleChanges, silent)
	end

	function multiselector.getDefault() return default end
	function multiselector.setDefault(selections) default = verify(selections) end
	function multiselector.revertData(handleChanges, silent) multiselector.setData({ states = us.Clone(snapshot) }, handleChanges, silent) end

	function multiselector.snapshotData(stored) us.CopyValues(snapshot, stored and multiselector.getData() or value) end
	function multiselector.resetData(handleChanges, silent) multiselector.setData({ states = us.Clone(default) }, handleChanges, silent) end

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

--[ Text ]

function wt.CreateTextual(t, datamanager)
	t = type(t) == "table" and t or {}

	local typename = "Textual" ---@type typename_textual
	local typenameBase = "Datamanager" ---@type typename_datamanager

	datamanager = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t)
	local textual = datamanager ---@cast textual textual

	textual.addType(typename)

	--[ Data ]

	local default = type(t.default) == "string" and t.default or ""
	local value = type(t.value) == "string" and t.value or type(t.getData) == "function" and t.getData() or nil
	value = type(value) == "string" and value or default
	local snapshot = value

	function textual.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			textual.setValue(t.getData(), handleChanges, silent)

			if not silent then textual.invoke.loaded(true) end
		else
			if handleChanges and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then textual.invoke.loaded(false) end
		end
	end

	function textual.saveData(text, silent)
		if type(t.saveData) == "function" then
			t.saveData(type(text) == "string" and text or value)

			if not silent then textual.invoke.saved(true) end
		elseif not silent then textual.invoke.saved(false) end
	end

	function textual.getData() return type(t.getData) == "function" and t.getData() or nil end
	function textual.setData(text, handleChanges, silent)
		textual.saveData(text, silent)
		textual.loadData(handleChanges, silent)
	end

	function textual.getDefault() return default end
	function textual.setDefault(text) default = type(text) == "string" and text or "" end
	function textual.resetData(handleChanges, silent) textual.setData(default, handleChanges, silent) end

	function textual.snapshotData(stored) snapshot = stored and textual.getData() or value end
	function textual.revertData(handleChanges, silent) textual.setData(snapshot, handleChanges, silent) end

	function textual.getValue() return value end
	function textual.setValue(text, user, silent)
		value = type(text) == "string" and text or ""

		if not silent then textual.invoke.changed(user == true) end

		if user and t.instantSave ~= false then textual.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--Set starting value
	textual.setValue(t.color and cr(value, t.color) or value, false, true)

	return textual
end

--[ Numeric ]

function wt.CreateNumeric(t, datamanager)
	t = type(t) == "table" and t or {}

	local typename = "Numeric" ---@type typename_numeric
	local typenameBase = "Datamanager" ---@type typename_datamanager

	datamanager = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t)
	local numeric = datamanager ---@cast numeric numeric

	numeric.addType(typename)

	--[ Data ]

	local limitMin = type(t.min) == "number" and t.min or 0
	local limitMax = type(t.max) == "number" and t.max or 100
	local step = max(type(t.step) == "number" and t.step or ((limitMin - limitMax) / 10), 0)
	local altStep = type(t.altStep) == "number" and max(t.altStep, 0) or nil
	local hardStep = t.hardStep ~= false

	local default = limitMin

	---Data verification utility
	---@param v any
	---@return number
	local function verify(v)
		v = type(v) == "number" and v or default

		if hardStep then v = limitMin + floor((v - limitMin) / step + 0.5) * step end

		return Clamp(v, limitMin, limitMax)
	end

	default = verify(t.default)
	local value = verify(t.value or type(t.getData) == "function" and t.getData() or nil)
	local snapshot = value

	function numeric.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			numeric.setValue(t.getData(), handleChanges, silent)

			if not silent then numeric.invoke.loaded(true) end
		else
			if handleChanges and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then numeric.invoke.loaded(false) end
		end
	end

	function numeric.saveData(number, silent)
		if type(t.saveData) == "function" then
			t.saveData(number and verify(number) or value)

			if not silent then numeric.invoke.saved(true) end
		elseif not silent then numeric.invoke.saved(false) end
	end

	function numeric.getData() return type(t.getData) == "function" and t.getData() or nil end
	function numeric.setData(number, handleChanges, silent)
		numeric.saveData(number, silent)
		numeric.loadData(handleChanges, silent)
	end

	function numeric.getDefault() return default end
	function numeric.setDefault(number) default = verify(number) end
	function numeric.resetData(handleChanges, silent) numeric.setData(default, handleChanges, silent) end

	function numeric.snapshotData(stored) snapshot = stored and numeric.getData() or value end
	function numeric.revertData(handleChanges, silent) numeric.setData(snapshot, handleChanges, silent) end

	function numeric.getValue() return value end
	function numeric.setValue(number, user, silent)
		value = verify(number)

		if not silent then numeric.invoke.changed(user == true) end

		if user and t.instantSave ~= false then numeric.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	function numeric.decrease(alt, user, silent) numeric.setValue(value - (alt and altStep or step), user, silent) end
	function numeric.increase(alt, user, silent) numeric.setValue(value + (alt and altStep or step), user, silent) end

	--Set starting value
	numeric.setValue(value, false, true)

	--| Value limits

	function numeric.getMin() return limitMin end
	function numeric.setMin(number, silent)
		limitMin = min(number, limitMax)

		if not silent then numeric.invoke.min() end
	end

	function numeric.getMax() return limitMax end
	function numeric.setMax(number, silent)
		limitMax = max(limitMin, number)

		if not silent then numeric.invoke.max() end
	end

	--Create events
	addEvent(numeric, "min", function(handlers) return function() for i = 1, #handlers do handlers[i](numeric, limitMin) end end end)
	addEvent(numeric, "max", function(handlers) return function() for i = 1, #handlers do handlers[i](numeric, limitMax) end end end)

	--| Value step

	function numeric.getStep() return step end
	function numeric.getAltStep() return altStep end

	return numeric
end

--[ Color ]

function wt.CreateColormanager(t, datamanager)
	t = type(t) == "table" and t or {}

	local typename = "Colormanager" ---@type typename_colormanager
	local typenameBase = "Datamanager" ---@type typename_datamanager

	datamanager = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t)
	local colormanager = datamanager ---@cast colormanager colormanager

	colormanager.addType(typename)

	--[ Data ]

	local default = wt.PackColor(wt.UnpackColor(t.default))
	local value = t.value or type(t.getData) == "function" and t.getData() or nil
	value = wt.PackColor(wt.UnpackColor(value))
	local snapshot = value

	function colormanager.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			colormanager.setValue(t.getData(), handleChanges, silent)

			if not silent then colormanager.invoke.loaded(true) end
		else
			if handleChanges and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then colormanager.invoke.loaded(false) end
		end
	end

	function colormanager.saveData(color, silent)
		if type(t.saveData) == "function" then
			t.saveData(color and wt.PackColor(wt.UnpackColor(color)) or value)

			if not silent then colormanager.invoke.saved(true) end
		elseif not silent then colormanager.invoke.saved(false) end
	end

	function colormanager.getData() return type(t.getData) == "function" and t.getData() or nil end
	function colormanager.setData(color, handleChanges, silent)
		colormanager.saveData(color, silent)
		colormanager.loadData(handleChanges, silent)
	end

	function colormanager.getDefault() return us.Clone(default) end
	function colormanager.setDefault(color) default = wt.PackColor(wt.UnpackColor(color)) end
	function colormanager.resetData(handleChanges, silent) colormanager.setData(default, handleChanges, silent) end

	function colormanager.snapshotData(stored) us.CopyValues(snapshot, stored and colormanager.getData() or value) end
	function colormanager.revertData(handleChanges, silent) colormanager.setData(snapshot, handleChanges, silent) end

	function colormanager.getValue() return us.Clone(value) end
	function colormanager.setValue(color, user, silent)
		value = wt.PackColor(wt.UnpackColor(color))

		if not silent then colormanager.invoke.changed(user == true) end

		if user and t.instantSave ~= false then colormanager.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--Set starting value
	colormanager.setValue(value, false, true)

	--[ Color Wheel ]

	local active = false
	local onCancel = t.onCancel

	--Color wheel value update utility
	local function colorUpdate()
		if not colormanager.isEnabled() then return end

		local r, g, b = ColorPickerFrame:GetColorRGB()

		colormanager.setValue(wt.PackColor(r, g, b, ColorPickerFrame:GetColorAlpha()), true)
	end

	function colormanager.openColorPicker()
		local r, g, b, a = wt.UnpackColor(value)

		--Set this color picker as the active one
		active = true

		ColorPickerFrame:SetupColorPickerAndShow({
			r = r,
			g = g,
			b = b,
			opacity = a,
			hasOpacity = true,
			swatchFunc = colorUpdate,
			opacityFunc = colorUpdate,
			cancelFunc = function()
				colormanager.setValue(wt.PackColor(r, g, b, a), true)

				if onCancel then onCancel() end
			end
		})
	end

	function colormanager.isActive() return active end

	--Update the color when re-enabled
	colormanager.addListener.enabled(function() if active then colorUpdate() end end, 1)

	--Deactivate on close
	ColorPickerFrame:HookScript("OnHide", function() active = false end)

	return colormanager
end

--[ Position ]



--[ Font ]




--[[ SETTINGS ]]

function wt.CreateSettingsmanager(t, widget)
	t = type(t) == "table" and t or {}

	local typename = "Settingsmanager" ---@type typename_settingsmanager
	local typenameBase = "Widget" ---@type typename_widget

	widget = wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t)
	local settingsmanager = widget ---@cast settingsmanager settingsmanager

	settingsmanager.addType(typename)

	--[ Batched Datamanagement ]

	local data, autoLoad, autoSave

	if type(t.dataManagement) == "table" then
		data, autoLoad, autoSave = t.dataManagement or {}, t.autoLoad ~= false, t.autoSave ~= false
		data.category = type(data.category) == "string" and data.category or type(t.name) == "string" and t.name:gsub("%s+", "") or tostring(data)
		data.keys = type((data.keys or {})[1]) == "string" and data.keys or { data.category }
	end

	function settingsmanager.load(handleChanges, user, silent)
		if autoLoad then for i = 1, #data.keys do
			wt.LoadSettingsData(data.category, data.keys[i], handleChanges)
			wt.SnapshotSettingsData(data.category, data.keys[i])
		end end

		--Call listeners
		if not silent then settingsmanager.invoke.loaded(user == true) end
	end

	function settingsmanager.save(user, silent)
		if autoSave then for i = 1, #data.keys do wt.SaveSettingsData(data.category, data.keys[i]) end end

		--Call listeners
		if not silent then settingsmanager.invoke.saved(user == true) end
	end

	function settingsmanager.apply(user, silent)
		if data then for i = 1, #data.keys do wt.ApplySettingsData(data.category, data.keys[i]) end end

		--Call listeners
		if not silent then settingsmanager.invoke.applied(user == true) end
	end

	function settingsmanager.revert(user, silent)
		if data then for i = 1, #data.keys do wt.RevertSettingsData(data.category, data.keys[i]) end end

		--Call listeners
		if not silent then settingsmanager.invoke.reverted(user == true) end
	end

	function settingsmanager.reset(user, silent)
		if data then for i = 1, #data.keys do wt.ResetSettingsData(data.category, data.keys[i]) end end

		--Call listeners
		if not silent then settingsmanager.invoke.reset(user == true) end
	end

	--Create events
	settingsmanager.addEvent("loaded")
	settingsmanager.addEvent("saved")
	settingsmanager.addEvent("applied")
	settingsmanager.addEvent("reverted")
	settingsmanager.addEvent("reset")

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

		--Call listener
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

			--Call listeners
			if type(onDefault) == "function" then onDefault(user == true, true) end
		end

		--Call listener
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

--[ Profiles ]

function wt.CreateProfilemanager(accountData, characterData, defaultData, t, widget)
	if type(accountData) ~= "table" or type(characterData) ~= "table" or type(defaultData) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	local typename = "Profilemanager" ---@type typename_profilemanager
	local typenameBase = "Widget" ---@type typename_widget

	widget = wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t)
	local profilemanager = widget ---@cast profilemanager profilemanager

	profilemanager.addType(typename)

	--[ Data ]

	profilemanager.data = {}
	profilemanager.firstLoad = type(accountData.profiles) ~= "table"
	profilemanager.newCharacter = type(characterData.activeProfile) ~= "number"

	t.category = type(t.category) == "string" and t.category or ""
	local category = t.category:len() > 0 and t.category or "Addon"
	local valueChecker = t.valueChecker
	local onRecovery = t.onRecovery
	local recoveryMap = t.recoveryMap

	local activeIndex = 1

	--Profile delete confirmation
	local deleteProfilePopup = wt.RegisterPopupDialog(category .. "_DELETE_PROFILE", { accept = DELETE, })

	--Profile reset confirmation
	local resetProfilePopup = wt.RegisterPopupDialog(category .. "RESET_PROFILE")

	---Set the active profile
	---@param index? integer ***Default:*** `activeIndex` or `1`
	local function setActiveProfile(index)
		index = Clamp(type(index) == "number" and type(accountData.profiles[index]) == "table" and math.floor(index) or activeIndex, 1, #accountData.profiles)

		activeIndex = index
		profilemanager.data = accountData.profiles[index].data

		--Update selected profile in the character-specific data
		characterData.activeProfile = index
	end

	function profilemanager.activate(index, user, silent)
		if type(index) ~= "number" then
			--Call listeners
			if not silent then profilemanager.invoke.activated(false, user == true) end

			return nil
		end

		setActiveProfile(index)

		--Call listeners
		if not silent then profilemanager.invoke.activated(true, user == true) end

		return activeIndex
	end

	function profilemanager.findIndex(title, skipFirst)
		for i = 1, #accountData.profiles do if accountData.profiles[i].title == title then if skipFirst then skipFirst = false else return i end end end
	end

	---Find an unused profile name to be able to use it as an identifying display title
	---***
	---@param name? string ***Default:*** `"Profile"`
	---@param number? integer ***Default:*** `2`
	---@param skipFirst? boolean ***Default:*** `false`
	---@return string title
	local function checkName(name, number, skipFirst)
		name = name or wt.strings.profiles.select.profile
		local title = name .. (number and (" " .. number) or "")

		--Find an unused name for the new profile
		if profilemanager.findIndex(title, skipFirst) then
			number = (number and number or 2)
			title = name .. " " .. number

			while profilemanager.findIndex(title) do
				number = number + 1
				title = name .. " " .. number
			end
		end

		return title
	end

	function profilemanager.create(name, number, duplicate, index, apply, user, silent)
		index = Clamp(type(index) == "number" and math.floor(index) or #accountData.profiles + 1, 1, #accountData.profiles + 1)
		local d = type(accountData.profiles[duplicate]) == "table" and accountData.profiles[duplicate] or nil

		--Create profile data
		table.insert(accountData.profiles, index, {
			title = checkName(d and d.title or name, number),
			data = us.Clone(d and d.data or defaultData)
		})

		--Call listeners
		if not silent then profilemanager.invoke.created(user == true, index, accountData.profiles[index].title) end

		--Activate the new profile
		if apply ~= false then profilemanager.activate(index, user, silent) end
	end

	function profilemanager.rename(index, name, number, user, silent)
		if index and not accountData.profiles[index] then
			--Call listeners
			if not silent then profilemanager.invoke.renamed(false, user == true, index) end

			return false
		end

		index = index or activeIndex
		local title = checkName(name, number)

		accountData.profiles[index].title = title

		--Call listeners
		if not silent then profilemanager.invoke.renamed(true, user == true, index, title) end

		return true
	end

	function profilemanager.delete(index, unsafe, user, silent)
		if index and not accountData.profiles[index] then
			--Call listeners
			if not silent then profilemanager.invoke.deleted(false, user == true, index) end

			return false
		end

		index = index or activeIndex
		local title = accountData.profiles[index].title

		local delete = function()
			--Delete profile data
			table.remove(accountData.profiles, index)

			--Call listeners
			if not silent then profilemanager.invoke.deleted(true, user == true, index, title) end

			--Activate the replacement profile
			if activeIndex == index then profilemanager.activate(index, user, silent) end
		end

		if unsafe then delete() else StaticPopup_Show(wt.UpdatePopupDialog(deleteProfilePopup, {
			text = wt.strings.profiles.delete.warning:gsub("#PROFILE", cr(accountData.profiles[index].title, NORMAL_FONT_COLOR)):gsub("#ADDON", category),
			onAccept = delete,
		})) end

		return true
	end

	function profilemanager.reset(index, unsafe, user, silent)
		if index and not accountData.profiles[index] then
			--Call listeners
			if not silent then profilemanager.invoke.reset(false, user == true, index) end

			return false
		end

		index = index or activeIndex

		local function reset()
			--Update the profile in storage (without breaking table references)
			us.CopyValues(accountData.profiles[index].data, defaultData)

			--Call listeners
			if not silent then profilemanager.invoke.reset(true, user == true, index, accountData.profiles[index].title) end
		end

		if unsafe then reset() else StaticPopup_Show(wt.UpdatePopupDialog(resetProfilePopup, {
			text = wt.strings.profiles.reset.warning:gsub("#PROFILE", cr(accountData.profiles[index].title, NORMAL_FONT_COLOR)):gsub("#ADDON", category),
			onAccept = reset,
		}))end

		return true
	end

	function profilemanager.validate(profileData, compareWith)
		if type(profileData) ~= "table" then return profileData end

		compareWith = type(compareWith) == "table" and compareWith or defaultData

		us.Prune(profileData, valueChecker)
		us.Fill(profileData, compareWith)
		us.Filter(profileData, compareWith, recoveryMap, onRecovery)

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
				if type(list[index].data) == "table" then profilemanager.validate(list[index].data) else list[index].data = us.Clone(defaultData) end
			else
				--Remove invalid entry
				list[key] = nil
			end

			index = index + 1
		end

		--Fill with default profile
		if not list[1] then list[1] = { title = wt.strings.profiles.select.main, data = us.Clone(defaultData) } end

		--Check profile names
		for i = 1, #list do list[i].title = checkName(list[i].title, nil, true) end
	end

	function profilemanager.load(p, activeProfile, user, silent)

		--| Profile list

		if type(p) == "table" then
			p.profiles = type(p.profiles) == "table" and p.profiles or {}

			validateProfiles(p.profiles)

			--Update the profile list in storage (without breaking table references)
			for i = 1, #p.profiles do
				accountData.profiles[i].title = p.profiles[i].title
				us.CopyValues(accountData.profiles[i].data, p.profiles[i].data)
			end
		else
			accountData.profiles = type(accountData.profiles) == "table" and accountData.profiles or {}

			validateProfiles(accountData.profiles)
		end

		--| Activate profile

		setActiveProfile(activeProfile or activeIndex)

		--| Recover misplaced data

		local recovered = {}

		--Remove & save misplaced possibly valuable data
		for key, value in pairs(accountData) do if key ~= "profiles" then
			recovered[key] = value
			accountData[key] = nil
		end end

		if next(recovered) then
			--Pack recovered data into the active profile data table (to be removed later if found irrelevant or invalid during validation)
			us.Pull(profilemanager.data, recovered)

			--Validate active profile data
			profilemanager.validate(profilemanager.data)

			ds.Log(function() return "Recovered misplaced data:" .. us.TableToString(recovered), "Profilemanager (" .. category .. ") loadProfiles" end)
		end

		--| Call listeners

		if not silent then
			user = user == true

			profilemanager.invoke.loaded(user)
			profilemanager.invoke.activated(true, user)
		end
	end

	--Create events
	profilemanager.addEvent("loaded")
	addEvent(profilemanager, "activated", function(handlers) return function(success, user) for i = 1, #handlers do
		handlers[i](profilemanager, success, user, activeIndex, accountData.profiles[activeIndex].title)
	end end end)
	profilemanager.addEvent("created")
	profilemanager.addEvent("renamed")
	profilemanager.addEvent("deleted")
	profilemanager.addEvent("reset")

	--Load starting data
	profilemanager.load(nil, nil, false, true)

	return profilemanager
end

--[ Addon ]

function wt.CreateAddonmanager(t, widget)
	t = type(t) == "table" and t or {}

	local typename = "Addonmanager" ---@type typename_addonmanager
	local typenameBase = "Widget" ---@type typename_widget

	widget = wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t)
	local addonmanager = widget ---@cast addonmanager addonmanager

	addonmanager.addType(typename)

	--[ Metadata ]

	local addon, title = "", ""
	local version, date, day, month, year, category, notes, author, license, curse, wago, repo, issues, sponsors, logo, changelogLatest, changelog

	function addonmanager.getAddon() return addon end
	function addonmanager.getTitle() return title end
	function addonmanager.getVersion() return version end
	function addonmanager.getDate() return date, day, month, year end
	function addonmanager.getCategory() return category end
	function addonmanager.getNotes() return notes end
	function addonmanager.getAuthor() return author end
	function addonmanager.getLicense() return license end
	function addonmanager.getCurseForgeLink() return curse end
	function addonmanager.getWagoLink() return wago end
	function addonmanager.getRepositoryLink() return repo end
	function addonmanager.getIssuesLink() return issues end
	function addonmanager.getSponsors() return sponsors end
	function addonmanager.getLogo() return logo end
	function addonmanager.getChangelog() return changelogLatest, changelog end

	--| Rebind

	function addonmanager.setAddon(newAddon, newChangelog, user, silent)
		if newAddon == addon then return true end

		local addon_type = type(newAddon)

		if (addon_type ~= "string" or addon_type ~= "number") or not C_AddOns.IsAddOnLoaded(newAddon) then return false end

		addon = addon_type ~= "string" and C_AddOns.GetAddOnName(newAddon) or newAddon
		title = C_AddOns.GetAddOnTitle(addon)
		version = C_AddOns.GetAddOnMetadata(addon, "Version")
		day = tonumber(C_AddOns.GetAddOnMetadata(addon, "X-Day"))
		month = tonumber(C_AddOns.GetAddOnMetadata(addon, "X-Month"))
		year = tonumber(C_AddOns.GetAddOnMetadata(addon, "X-Year"))
		date = day and month and year and wt.strings.date:gsub("#DAY", day):gsub("#MONTH", month):gsub("#YEAR", year) or nil
		category = C_AddOns.GetAddOnMetadata(addon, "Category")
		notes = C_AddOns.GetAddOnNotes(addon)
		author = C_AddOns.GetAddOnMetadata(addon, "Author")
		license = C_AddOns.GetAddOnMetadata(addon, "X-License")
		curse = C_AddOns.GetAddOnMetadata(addon, "X-CurseForge")
		wago = C_AddOns.GetAddOnMetadata(addon, "X-Wago")
		repo = C_AddOns.GetAddOnMetadata(addon, "X-Repository")
		issues = C_AddOns.GetAddOnMetadata(addon, "X-Issues")
		sponsors = C_AddOns.GetAddOnMetadata(addon, "X-Sponsors")
		logo = C_AddOns.GetAddOnMetadata(addon, "IconTexture")
		changelogLatest, changelog = nil, nil

		if newChangelog then changelogLatest, changelog = us.FormatChangelog(newChangelog, true), us.FormatChangelog(newChangelog) end

		--Call listeners
		if not silent then addonmanager.invoke.changed(addon, user == true) end

		return true
	end

	--Create event
	addonmanager.addEvent("changed")

	--Load metadata
	addonmanager.setAddon(t.addon, t.changelog)

	return addonmanager
end

--🦊