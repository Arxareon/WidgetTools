--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--| Shortcuts

local cr = C_ColorUtil.WrapTextInColor
local crc = C_ColorUtil.WrapTextInColorCode

---@type widgetToolsUtilities
local us = WidgetTools.utilities

---@type widgetToolsDebugging
local ds = WidgetTools.debugging

--[ Clipboard ]

wt.clipboard = {}

--[ Utilities ]

---Register a handler as a listener for `event`
---@param listeners table<string, function[]>
---@param event string
---@param listener function
---@param callIndex integer
local function addListener(listeners, event, listener, callIndex)
	if not listeners[event] then listeners[event] = {} end

	local l = listeners[event]

	if type(callIndex) ~= "number" then table.insert(l, listener) else table.insert(l, Clamp(math.floor(callIndex), 1, #l + 1), listener) end
end

---Call registered listeners for `event`
---@param widget table
---@param listeners table<string, function[]>
---@param event string
---@param ... any
local function callListeners(widget, listeners, event, ...)
	local l = listeners[event]

	if not l then return end

	for i = 1, #l do l[i](widget, ...) end
end


--[[ CONSTRUCTORS ]]

function wt.CreateWidget(t)

	--[ Parameters  ]

	t = type(t) == "table" and t or {}

	--| Type

	---@type typename_widget
	local typename = "Widget"

	---@type table<typename_widget, true>
	local types = {}

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--| State

	local enabled = t.disabled ~= true

	--[ Widget ]

	---@type widget
	local widget = { invoke = {}, setListener = {}, }

	--[ Getters & Setters ]

	--| Type

	function widget.getTypes() us.Clone(types) end
	function widget.isType(s) return types[s] or false end
	function widget.addType(s) types[s] = true end

	--| Events

	function widget.invoke.enabled() callListeners(widget, listeners, "enabled", enabled) end
	function widget.invoke._(event, ...) callListeners(widget, listeners, event, ...) end

	function widget.setListener.enabled(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	function widget.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| State

	function widget.isEnabled() return enabled end
	function widget.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then widget.invoke.enabled() end
	end

	--[ Initialization ]

	--Add type
	widget.addType(typename)

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then widget.setListener._(v[i].event, v[i].handler, v[i].callIndex) else widget.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, widget.setEnabled) end

	return widget
end

--| Action

function wt.CreateAction(t, widget)

	--[ Parameters  ]

	t = type(t) == "table" and t or {}

	local callAction = nil

	--| Type

	---@type typename_action
	local typename = "Action"

	---@type typename_widget
	local typenameBase = "Widget"

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--[ Widget ]

	---@type action|widget
	local action = wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t)

	--[ Getters & Setters ]

	function action.trigger(user, silent)
		if action.isEnabled() and callAction then callAction(action, user) end

		if not silent then action.invoke.triggered(user) end
	end

	function action.setAction(call) if type(call) == "function" then callAction = call end end

	--| Events

	function action.invoke.triggered(user) callListeners(action, listeners, "triggered", user) end

	function action.setListener.triggered(listener, callIndex) addListener(listeners, "triggered", listener, callIndex) end

	--[ Initialization ]

	--Add type
	action.addType(typename)

	--Set action
	action.setAction(t.action)

	return action
end

--[ Data Managers ]

function wt.CreateDatamanager(t, widget)

	--[ Parameters  ]

	t = type(t) == "table" and t or {}

	--| Type

	---@type typename_datamanager
	local typename = "Datamanager"

	---@type typename_widget
	local typenameBase = "Widget"

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--| Data

	local default = t.default
	local value = t.value
	local snapshot = value

	--[ Widget ]

	---@type datamanager|widget
	local datamanager = wt.IsWidget(widget, typenameBase) and widget or wt.CreateWidget(t)

	--[ Getters & Setters ]

	function datamanager.verify(v) if type(v) == "nil" then return value else return v end end
	function datamanager.format(v) return us.ToString(v) end

	function datamanager.getValue() return value end
	function datamanager.setValue(v, user, silent)
		value = datamanager.verify(v)

		if not silent then datamanager.invoke.changed(user == true) end

		if user and t.instantSave ~= false then datamanager.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	function datamanager.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			datamanager.setValue(t.getData(), handleChanges, silent)

			if not silent then datamanager.invoke.loaded(true) end
		else
			if handleChanges and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then datamanager.invoke.loaded(false) end
		end
	end

	function datamanager.saveData(data, silent)
		if type(t.saveData) == "function" then
			t.saveData(datamanager.verify(data))

			if not silent then datamanager.invoke.saved(true) end
		elseif not silent then datamanager.invoke.saved(false) end
	end

	function datamanager.getData() return type(t.getData) == "function" and t.getData() or nil end
	function datamanager.setData(data, handleChanges, silent)
		datamanager.saveData(data, silent)
		datamanager.loadData(handleChanges, silent)
	end

	function datamanager.getDefault() return default end
	function datamanager.setDefault(v) default = v end
	function datamanager.resetData(handleChanges, silent) datamanager.setData(default, handleChanges, silent) end

	function datamanager.snapshotData(stored) if stored == true then snapshot = datamanager.getData() else snapshot = value end end
	function datamanager.revertData(handleChanges, silent) datamanager.setData(snapshot, handleChanges, silent) end

	--| Events

	function datamanager.invoke.loaded(success) callListeners(datamanager, listeners, "loaded", success) end
	function datamanager.invoke.saved(success) callListeners(datamanager, listeners, "saved", success) end
	function datamanager.invoke.changed(user) callListeners(datamanager, listeners, "changed", value, user) end

	function datamanager.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function datamanager.setListener.saved(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	function datamanager.setListener.changed(listener, callIndex) addListener(listeners, "changed", listener, callIndex) end

	--[ Initialization ]

	--Add type
	datamanager.addType(typename)

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(datamanager, t.dataManagement) end

	return datamanager
end

--| Binary

function wt.CreateBinary(t, datamanager)

	--[ Parameters  ]

	t = type(t) == "table" and t or {}

	--| Type

	---@type typename_binary
	local typename = "Binary"

	---@type typename_datamanager
	local typenameBase = "Datamanager"

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--| Data

	local default = t.default == true
	local value = t.value
	if type(value) ~= "boolean" then if type(t.getData) == "function" then value = t.getData() else value = default end end
	local snapshot = value

	--[ Widget ]

	---@type binary|datamanager
	local binary = wt.IsWidget(datamanager, typenameBase) and datamanager or wt.CreateDatamanager(t)

	--[ Getters & Setters ]

	--| Events

	function binary.invoke.flipped(user) callListeners(binary, listeners, "flipped", value, user) end

	function binary.setListener.flipped(listener, callIndex) addListener(listeners, "flipped", listener, callIndex) end

	--| Data management

	function binary.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			binary.setState(t.getData(), handleChanges, silent)

			if not silent then binary.invoke.loaded(true) end
		else
			if handleChanges and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then binary.invoke.loaded(false) end
		end
	end

	function binary.saveData(state, silent)
		if type(t.saveData) == "function" then
			if state == nil then state = value end

			t.saveData(state == true)

			if not silent then binary.invoke.saved(true) end
		elseif not silent then binary.invoke.saved(false) end
	end

	function binary.getData() return type(t.getData) == "function" and t.getData() or nil end
	function binary.setData(state, handleChanges, silent)
		binary.saveData(state, silent)
		binary.loadData(handleChanges, silent)
	end

	function binary.getDefault() return default end
	function binary.setDefault(state) default = state == true end
	function binary.resetData(handleChanges, silent) binary.setData(default, handleChanges, silent) end

	function binary.snapshotData(stored) if stored == true then snapshot = binary.getData() else snapshot = value end end
	function binary.revertData(handleChanges, silent) binary.setData(snapshot, handleChanges, silent) end

	function binary.getState() return value end
	function binary.setState(state, user, silent)
		value = state == true

		if not silent then binary.invoke.flipped(user == true) end

		if user and t.instantSave ~= false then binary.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	function binary.flipState(user, silent) binary.setState(not value, user, silent) end

	function binary.formatValue(state)
		if type(state) ~= "boolean" then state = value end

		return crc((state and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), state and "FFAAAAFF" or "FFFFAA66")
	end

	--[ Initialization ]

	--Add type
	binary.addType(typename)

	--Set starting value
	binary.setState(value, false, true)

	return binary
end

--| Selector

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

function wt.CreateSelector(t)
	t = type(t) == "table" and t or {}

	---@type typename_selector
	local typename = "Selector"

	---@type typename_binary
	local typenameItem = "Binary"

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	local clearable = t.clearable

	--| Toggle items

	---@type (binary|selectorBinary)[]
	local inactive = {}

	--| Data

	local default = 1

	---Data verification utility
	---@param v any
	---@return integer|nil
	local function verify(v)
		v = type(v) == "number" and Clamp(math.floor(v), 1, #t.items) or nil

		return v and v or not clearable and default or nil
	end

	default = verify(t.default)
	local value = verify(t.value or type(t.getData) == "function" and t.getData() or nil)
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--[ Widget ]

	---@type selector
	local selector = { invoke = {}, setListener = {}, binaries = {} }

	--[ Getters & Setters ]

	--| Events

	function selector.invoke.enabled() callListeners(selector, listeners, "enabled", enabled) end
	function selector.invoke.loaded(success) callListeners(selector, listeners, "loaded", success) end
	function selector.invoke.saved(success) callListeners(selector, listeners, "saved", success) end
	function selector.invoke.selected(user) callListeners(selector, listeners, "selected", value, user) end
	function selector.invoke.updated() callListeners(selector, listeners, "updated") end
	function selector.invoke.added(binary) callListeners(selector, listeners, "added", binary) end
	function selector.invoke._(event, ...) callListeners(selector, listeners, event, ...) end

	function selector.setListener.enabled(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	function selector.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function selector.setListener.saved(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	function selector.setListener.selected(listener, callIndex) addListener(listeners, "selected", listener, callIndex) end
	function selector.setListener.updated(listener, callIndex) addListener(listeners, "updated", listener, callIndex) end
	function selector.setListener.added(listener, callIndex) addListener(listeners, "added", listener, callIndex) end
	function selector.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Toggle items

	---Register, update or set up a new binary widget item
	---***
	---@param index integer
	---@param silent? boolean ***Default:*** `false`
	local function setToggle(index, silent)
		local new = false

		if wt.IsWidget(t.items[index]) == typenameItem then
			--| Register the already defined binary widget

			new = true
			selector.binaries[index] = t.items[index]
		elseif index > #selector.binaries then
			if #inactive > 0 then
				--| Reenable an inactive binary widget

				selector.binaries[index] = inactive[#inactive]
				table.remove(inactive, #inactive)
			else
				--| Create a new binary widget

				new = true
				selector.binaries[index] = wt.CreateBinary({ listeners = { flipped = { { handler = function (_, state, user)
					if state and user and type(t.items[selector.binaries[index].index].onSelect) == "function" then t.items[selector.binaries[index].index].onSelect() end
				end, }, }, },  })
			end
		end

		selector.binaries[index].index = index

		if new and not silent then selector.invoke.added(selector.binaries[index]) end
	end

	function selector.updateItems(newItems, silent)
		t.items = newItems

		--Update the binary widgets
		for i = 1, #newItems do
			setToggle(i, silent)

			if not silent then selector.binaries[i].invoke._("activated", true) end
		end

		--Deactivate extra binary widgets
		while #newItems < #selector.binaries do
			selector.binaries[#selector.binaries].setState(false)

			if not silent then selector.binaries[#selector.binaries].invoke._("activated", false) end

			table.insert(inactive, selector.binaries[#selector.binaries])
			table.remove(selector.binaries, #selector.binaries)
		end

		if not silent then selector.invoke.updated() end

		selector.setSelected(value, nil, silent)
	end

	--| Data management

	function selector.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			selector.setSelected(t.getData(), handleChanges)

			if not silent then selector.invoke.loaded(true) end
		else
			if handleChanges then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then selector.invoke.loaded(false) end
		end
	end

	function selector.saveData(data, silent)
		if type(t.saveData) == "function" then
			t.saveData(type(data) == "table" and verify(data.index) or value)

			if not silent then selector.invoke.saved(true) end
		elseif not silent then selector.invoke.saved(false) end
	end

	function selector.getData() return type(t.getData) == "function" and t.getData() or nil end
	function selector.setData(data, handleChanges, silent)
		selector.saveData(data, silent)
		selector.loadData(handleChanges, silent)
	end

	function selector.getDefault() return default end
	function selector.setDefault(index) default = verify(index) end
	function selector.resetData(handleChanges, silent) selector.setData({ index = default }, handleChanges, silent) end

	function selector.snapshotData(stored) snapshot = stored and selector.getData() or value end
	function selector.revertData(handleChanges, silent) selector.setData({ index = snapshot }, handleChanges, silent) end

	function selector.getSelected() return value end
	function selector.setSelected(index, user, silent)
		value = verify(index)

		for i = 1, #selector.binaries do selector.binaries[i].setState(i == value, user, silent) end

		if user and t.instantSave ~= false then selector.saveData(nil, silent) end

		if not silent then selector.invoke.selected(user == true) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	function selector.isEnabled() return enabled end
	function selector.setEnabled(state, silent)
		enabled = state ~= false

		--Update binary widget items
		for i = 1, #selector.binaries do selector.binaries[i].setEnabled(state, silent) end

		if not silent then selector.invoke.enabled() end
	end

	--[ Initialization ]

	--Add type
	selector.addType(typename)

	--Register starting items
	for i = 1, #t.items do setToggle(i) end

	--Set starting value
	selector.setSelected(value, false, true)

	return selector
end

function wt.CreateSpecialSelector(itemset, t)
	t = type(t) == "table" and t or {}

	---@type typename_specialSelector
	local typename = "SpecialSelector"

	---@type typename_binary
	local typenameItem = "Binary"

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	local clearable = t.clearable

	--| Toggle items

	---@diagnostic disable-next-line: inject-field --REPLACE when changing t references to locals
	t.items = {}
	for i = 1, #itemsets[itemset] do
		t.items[i] = {}
		t.items[i].title = itemsets[itemset][i].name
		t.items[i].tooltip = { lines = { { text = "(" .. itemsets[itemset][i].value .. ")", }, } }
	end

	---@type (binary|selectorBinary)[]
	local inactive = {}

	--| Data

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

	--| State

	local enabled = t.disabled ~= true

	--[ Widget ]

	---@type specialSelector
	local specialSelector = { invoke = {}, setListener = {}, binaries = {} }

	--[ Getters & Setters ]

	function specialSelector.getItemset() return itemset end

	--| Events

	function specialSelector.invoke.enabled() callListeners(specialSelector, listeners, "enabled", enabled) end
	function specialSelector.invoke.loaded(success) callListeners(specialSelector, listeners, "loaded", success) end
	function specialSelector.invoke.saved(success) callListeners(specialSelector, listeners, "saved", success) end
	function specialSelector.invoke.selected(user) callListeners(specialSelector, listeners, "selected", value, user) end
	function specialSelector.invoke._(event, ...) callListeners(specialSelector, listeners, event, ...) end

	function specialSelector.setListener.enabled(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	function specialSelector.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function specialSelector.setListener.saved(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	function specialSelector.setListener.selected(listener, callIndex) addListener(listeners, "selected", listener, callIndex) end
	function specialSelector.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Data management

	function specialSelector.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			specialSelector.setSelected(t.getData(), handleChanges)

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

	function specialSelector.getSelected() return itemsets[itemset][value] and itemsets[itemset][value].value or nil end
	function specialSelector.setSelected(selected, user, silent)
		value = verify(selected)

		for i = 1, #specialSelector.binaries do specialSelector.binaries[i].setState(i == value, user, silent) end

		if user and t.instantSave ~= false then specialSelector.saveData(nil, silent) end

		if not silent then specialSelector.invoke.selected(user == true) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	function specialSelector.isEnabled() return enabled end
	function specialSelector.setEnabled(state, silent)
		enabled = state ~= false

		--Update binary widget items
		for i = 1, #specialSelector.binaries do specialSelector.binaries[i].setEnabled(state, silent) end

		if not silent then specialSelector.invoke.enabled() end
	end

	--[ Initialization ]

	--Add type
	specialSelector.addType(typename)

	--Register starting items
	for i = 1, #t.items do if type(t.items[i]) == "table" then
		if wt.IsWidget(t.items[i]) == typenameItem then
			--| Register the already defined binary widget

			specialSelector.binaries[i] = t.items[i]
		elseif #inactive > 0 then
			--| Reenable an inactive binary widget

			specialSelector.binaries[i] = inactive[#inactive]
			table.remove(inactive, #inactive)
		else
			--| Create a new binary widget

			specialSelector.binaries[i] = wt.CreateBinary({ listeners = { flipped = { { handler = function (_, state, user)
				if type(t.items[specialSelector.binaries[i].index].onSelect) == "function" and user and state then t.items[specialSelector.binaries[i].index].onSelect() end
			end, }, }, }, })
		end

		specialSelector.binaries[i].index = i
	end end

	--Set starting value
	specialSelector.setSelected(value, false, true)

	return specialSelector
end

function wt.CreateMultiselector(t)
	t = type(t) == "table" and t or {}

	---@type typename_multiselector
	local typename = "Multiselector"

	---@type typename_binary
	local typenameItem = "Binary"

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--| Toggle items

	t.items = type(t.items) == "table" and us.Clone(t.items) or {}
	t.limits = t.limits or {}
	t.limits.min = t.limits.min or 1
	t.limits.max = t.limits.max or #t.items

	---@type (binary|selectorBinary)[]
	local inactive = {}

	--| Data

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

	--| State

	local enabled = t.disabled ~= true

	--[ Widget ]

	---@type multiselector
	local multiselector = { invoke = {}, setListener = {}, binaries = {} }

	--[ Getters & Setters ]

	--| Events

	function multiselector.invoke.enabled() callListeners(multiselector, listeners, "enabled", enabled) end
	function multiselector.invoke.loaded(success) callListeners(multiselector, listeners, "loaded", success) end
	function multiselector.invoke.saved(success) callListeners(multiselector, listeners, "saved", success) end
	function multiselector.invoke.selected(user) callListeners(multiselector, listeners, "selected", value, user) end
	function multiselector.invoke.updated() callListeners(multiselector, listeners, "updated") end
	function multiselector.invoke.added(binary) callListeners(multiselector, listeners, "added", binary) end
	function multiselector.invoke.limited(count) callListeners(multiselector, listeners, "limited", count <= t.limits.min, count < t.limits.min) end
	function multiselector.invoke._(event, ...) callListeners(multiselector, listeners, event, ...) end

	function multiselector.setListener.enabled(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	function multiselector.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function multiselector.setListener.saved(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	function multiselector.setListener.selected(listener, callIndex) addListener(listeners, "selected", listener, callIndex) end
	function multiselector.setListener.updated(listener, callIndex) addListener(listeners, "updated", listener, callIndex) end
	function multiselector.setListener.added(listener, callIndex) addListener(listeners, "added", listener, callIndex) end
	function multiselector.setListener.limited(listener, callIndex) addListener(listeners, "limited", listener, callIndex) end
	function multiselector.setListener._ (event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Toggle items

	local function setToggle(item, index, silent)
		if type(item) ~= "table" then return end

		local new = false

		if wt.IsWidget(item) == typenameItem then
			--| Register the already defined binary widget

			new = true
			multiselector.binaries[index] = item
		elseif #inactive > 0 then
			--| Reenable an inactive binary widget

			multiselector.binaries[index] = inactive[#inactive]
			table.remove(inactive, #inactive)
		else
			--| Create a new binary widget

			new = true
			multiselector.binaries[index] = wt.CreateBinary({ listeners = { flipped = { { handler = function (_, state, user)
				if type(t.items[multiselector.binaries[index].index].onSelect) == "function" and user and state then t.items[multiselector.binaries[index].index].onSelect() end
			end, }, }, }, })
		end

		multiselector.binaries[index].index = index

		if new and not silent then multiselector.invoke.added(multiselector.binaries[index]) end
	end

	function multiselector.updateItems(newItems, silent)
		t.items = newItems

		--Update the binary widgets
		for i = 1, #newItems do
			setToggle(newItems[i], i, silent)

			if not silent then multiselector.binaries[i].invoke._("activated", true) end
		end

		--Deactivate extra binary widgets
		while #newItems < #multiselector.binaries do
			multiselector.binaries[#multiselector.binaries].setState(nil, nil, silent)

			if not silent then multiselector.binaries[#multiselector.binaries].invoke._("activated", false) end

			table.insert(inactive, multiselector.binaries[#multiselector.binaries])
			table.remove(multiselector.binaries, #multiselector.binaries)
		end

		if not silent then multiselector.invoke.updated() end

		--Update limits
		if t.limits.min > #t.items then t.limits.min = #t.items end
		if t.limits.max > #t.items then t.limits.max = #t.items end

		multiselector.setSelections(value, nil, silent)
	end

	--| Data management

	function multiselector.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			multiselector.setSelections(t.getData(), handleChanges)

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

	function multiselector.getSelections() return us.Clone(value) end
	function multiselector.setSelections(selections, user, silent)
		value = verify(selections)

		for i = 1, #multiselector.binaries do multiselector.binaries[i].setState(value and value[i], user, silent) end

		if user and t.instantSave ~= false then multiselector.saveData(nil, silent) end

		if not silent then
			multiselector.invoke.selected(user == true)

			--| Check limits

			local count = 0

			for _, v in pairs(value) do if v then count = count + 1 end end

			multiselector.invoke.limited(count)
		end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	function multiselector.setSelected(index, selected, user, silent)
		if not multiselector.binaries[index] then return end

		value[index] = selected == true

		multiselector.binaries[index].setState(selected, user, silent)

		if user and t.instantSave ~= false then multiselector.saveData(nil, silent) end

		if not silent then
			multiselector.invoke.selected(user == true)

			--| Check limits

			local count = 0

			for _, v in pairs(value) do if v then count = count + 1 end end

			multiselector.invoke.limited(count)
		end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	function multiselector.isEnabled() return enabled end
	function multiselector.setEnabled(state, silent)
		enabled = state ~= false

		--Update binary widget items
		for i = 1, #multiselector.binaries do multiselector.binaries[i].setEnabled(state, silent) end

		if not silent then multiselector.invoke.enabled() end
	end

	--[ Initialization ]

	--Add type
	multiselector.addType(typename)

	--Register starting items
	for i = 1, #t.items do setToggle(t.items[i], i) end

	--Set starting value
	multiselector.setSelections(value, false, true)

	return multiselector
end

--| Textual

function wt.CreateTextual(t)
	t = type(t) == "table" and t or {}

	---@type typename_textual
	local typename = "Textual"

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--| Data

	local default = type(t.default) == "string" and t.default or ""
	local value = type(t.value) == "string" and t.value or type(t.getData) == "function" and t.getData() or nil
	value = type(value) == "string" and value or default
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--[ Widget ]

	---@type textual
	local textual = { invoke = {}, setListener = {}, }

	--[ Getters & Setters ]

	--| Events

	function textual.invoke.enabled() callListeners(textual, listeners, "enabled", enabled) end
	function textual.invoke.loaded(success) callListeners(textual, listeners, "loaded", success) end
	function textual.invoke.saved(success) callListeners(textual, listeners, "saved", success) end
	function textual.invoke.changed(user) callListeners(textual, listeners, "changed", value, user) end
	function textual.invoke._(event, ...) callListeners(textual, listeners, event, ...) end

	function textual.setListener.enabled(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	function textual.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function textual.setListener.saved(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	function textual.setListener.changed(listener, callIndex) addListener(listeners, "changed", listener, callIndex) end
	function textual.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Data management

	function textual.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			textual.setText(t.getData(), handleChanges, silent)

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

	function textual.getText() return value end
	function textual.setText(text, user, silent)
		value = type(text) == "string" and text or ""

		if not silent then textual.invoke.changed(user == true) end

		if user and t.instantSave ~= false then textual.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	function textual.isEnabled() return enabled end
	function textual.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then textual.invoke.enabled() end
	end

	--[ Initialization ]

	--Add type
	textual.addType(typename)

	--Set starting value
	textual.setText(t.color and cr(value, t.color) or value, false, true)

	return textual
end

--| Numeric

function wt.CreateNumeric(t)
	t = type(t) == "table" and t or {}

	---@type typename_numeric
	local typename = "Numeric"

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	local limitMin = type(t.min) == "number" and t.min or 0
	local limitMax = type(t.max) == "number" and t.max or 100
	local step = max(type(t.step) == "number" and t.step or ((limitMin - limitMax) / 10), 0)
	local altStep = type(t.altStep) == "number" and max(t.altStep, 0) or nil
	local hardStep = t.hardStep ~= false

	--| Data

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

	--| State

	local enabled = t.disabled ~= true

	--[ Widget ]

	---@type numeric
	local numeric = { invoke = {}, setListener = {}, }

	--[ Getters & Setters ]

	--| Events

	function numeric.invoke.enabled() callListeners(numeric, listeners, "enabled", enabled) end
	function numeric.invoke.loaded(success) callListeners(numeric, listeners, "loaded", success) end
	function numeric.invoke.saved(success) callListeners(numeric, listeners, "saved", success) end
	function numeric.invoke.changed(user) callListeners(numeric, listeners, "changed", value, user) end
	function numeric.invoke.min() callListeners(numeric, listeners, "min", limitMin) end
	function numeric.invoke.max() callListeners(numeric, listeners, "max", limitMax) end
	function numeric.invoke._(event, ...) callListeners(numeric, listeners, event, ...) end

	function numeric.setListener.enabled(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	function numeric.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function numeric.setListener.saved(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	function numeric.setListener.changed(listener, callIndex) addListener(listeners, "changed", listener, callIndex) end
	function numeric.setListener.min(listener, callIndex) addListener(listeners, "min", listener, callIndex) end
	function numeric.setListener.max(listener, callIndex) addListener(listeners, "max", listener, callIndex) end
	function numeric.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Data management

	function numeric.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			numeric.setNumber(t.getData(), handleChanges, silent)

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

	function numeric.getNumber() return value end
	function numeric.setNumber(number, user, silent)
		value = verify(number)

		if not silent then numeric.invoke.changed(user == true) end

		if user and t.instantSave ~= false then numeric.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	function numeric.decrease(alt, user, silent) numeric.setNumber(value - (alt and altStep or step), user, silent) end
	function numeric.increase(alt, user, silent) numeric.setNumber(value + (alt and altStep or step), user, silent) end

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

	--| Value step

	function numeric.getStep() return step end
	function numeric.getAltStep() return altStep end

	--| State

	function numeric.isEnabled() return enabled end
	function numeric.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then numeric.invoke.enabled() end
	end

	--[ Initialization ]

	--Add type
	numeric.addType(typename)

	--Set starting value
	numeric.setNumber(value, false, true)

	return numeric
end

--| Color

function wt.CreateColormanager(t)
	t = type(t) == "table" and t or {}

	---@type typename_colormanager
	local typename = "Colormanager"

	local active = false

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--| Data

	local default = wt.PackColor(wt.UnpackColor(t.default))
	local value = t.value or type(t.getData) == "function" and t.getData() or nil
	value = wt.PackColor(wt.UnpackColor(value))
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--[ Widget ]

	---@type colormanager
	local colormanager = { invoke = {}, setListener = {}, }

	--[ Getters & Setters ]

	--| Events

	function colormanager.invoke.enabled() callListeners(colormanager, listeners, "enabled", enabled) end
	function colormanager.invoke.loaded(success) callListeners(colormanager, listeners, "loaded", success) end
	function colormanager.invoke.saved(success) callListeners(colormanager, listeners, "saved", success) end
	function colormanager.invoke.colored(user) callListeners(colormanager, listeners, "colored", value, user) end
	function colormanager.invoke._(event, ...) callListeners(colormanager, listeners, event, ...) end

	function colormanager.setListener.enabled(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	function colormanager.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function colormanager.setListener.saved(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	function colormanager.setListener.colored(listener, callIndex) addListener(listeners, "colored", listener, callIndex) end
	function colormanager.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Data management

	function colormanager.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			colormanager.setColor(t.getData(), handleChanges, silent)

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

	function colormanager.getColor() return us.Clone(value) end
	function colormanager.setColor(color, user, silent)
		value = wt.PackColor(wt.UnpackColor(color))

		if not silent then colormanager.invoke.colored(user == true) end

		if user and t.instantSave ~= false then colormanager.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| Color wheel

	--Color wheel value update utility
	local function colorUpdate()
		if not enabled then return end

		local r, g, b = ColorPickerFrame:GetColorRGB()

		colormanager.setColor(wt.PackColor(r, g, b, ColorPickerFrame:GetColorAlpha()), true)
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
				colormanager.setColor(wt.PackColor(r, g, b, a), true)

				if t.onCancel then t.onCancel() end
			end
		})
	end

	function colormanager.isActive() return active end

	--| State

	function colormanager.isEnabled() return enabled end
	function colormanager.setEnabled(state, silent)
		enabled = state ~= false

		--Update the color when re-enabled
		if active then colorUpdate() end

		if not silent then colormanager.invoke.enabled() end
	end

	--[ Color Wheel Toggle ]

	--Deactivate on close
	ColorPickerFrame:HookScript("OnHide", function() active = false end)

	--[ Initialization ]

	--Add type
	colormanager.addType(typename)

	--Set starting value
	colormanager.setColor(value, false, true)

	return colormanager
end

--| Position



--| Font



--| Settings

function wt.CreateSettingsmanager(t)
	t = type(t) == "table" and t or {}

	---@type typename_settingsmanager
	local typename = "Settingsmanager"

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--| Data management

	local data, autoLoad, autoSave

	if type(t.dataManagement) == "table" then
		data, autoLoad, autoSave = t.dataManagement or {}, t.autoLoad ~= false, t.autoSave ~= false
		data.category = type(data.category) == "string" and data.category or type(t.name) == "string" and t.name:gsub("%s+", "") or tostring(data)
		data.keys = type((data.keys or {})[1]) == "string" and data.keys or { data.category }
	end

	--| State

	local enabled = t.disabled ~= true

	--[ Widget ]

	---@type settingsmanager
	local settingsmanager = { invoke = {}, setListener = {}, }

	--[ Getters & Setters ]

	--| Events

	function settingsmanager.invoke.enabled() callListeners(settingsmanager, listeners, "enabled", enabled) end
	function settingsmanager.invoke.loaded(user) callListeners(settingsmanager, listeners, "loaded", user) end
	function settingsmanager.invoke.saved(user) callListeners(settingsmanager, listeners, "saved", user) end
	function settingsmanager.invoke.applied(user) callListeners(settingsmanager, listeners, "applied", user) end
	function settingsmanager.invoke.reverted(user) callListeners(settingsmanager, listeners, "reverted", user) end
	function settingsmanager.invoke.reset(user) callListeners(settingsmanager, listeners, "reset", user) end
	function settingsmanager.invoke._(event, ...) callListeners(settingsmanager, listeners, event, ...) end

	function settingsmanager.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function settingsmanager.setListener.saved(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	function settingsmanager.setListener.applied(listener, callIndex) addListener(listeners, "applied", listener, callIndex) end
	function settingsmanager.setListener.reverted(listener, callIndex) addListener(listeners, "reverted", listener, callIndex) end
	function settingsmanager.setListener.reset(listener, callIndex) addListener(listeners, "reset", listener, callIndex) end
	function settingsmanager.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Batched data management

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

	--| State

	function settingsmanager.isEnabled() return enabled end
	function settingsmanager.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then settingsmanager.invoke.enabled() end
	end

	--[ Initialization ]

	--Add type
	settingsmanager.addType(typename)

	return settingsmanager
end

function wt.CreateSettingsCategory(addon, parent, pages, t) --FIX lite
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

--| Profile

function wt.CreateProfilemanager(accountData, characterData, defaultData, t)
	if type(accountData) ~= "table" or type(characterData) ~= "table" or type(defaultData) ~= "table" then return nil end

	--[ Parameters  ]

	t = type(t) == "table" and t or {}

	t.category = type(t.category) == "string" and t.category or ""

	---@type typename_profilemanager
	local typename = "Profilemanager"

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	local category = t.category:len() > 0 and t.category or "Addon"
	local valueChecker = t.valueChecker
	local onRecovery = t.onRecovery
	local recoveryMap = t.recoveryMap

	--| Data

	local activeIndex = 1

	--| Utilities

	--Profile delete confirmation
	local deleteProfilePopup = wt.RegisterPopupDialog(category .. "_DELETE_PROFILE", { accept = DELETE, })

	--Profile reset confirmation
	local resetProfilePopup = wt.RegisterPopupDialog(category .. "RESET_PROFILE")

	--[ Widget ]

	---@type profilemanager
	local profilemanager = {
		data = {},
		firstLoad = type(accountData.profiles) ~= "table",
		newCharacter = type(characterData.activeProfile) ~= "number",
		invoke = {},
		setListener = {},
	}

	--[ Getters & Setters ]

	--| Events

	function profilemanager.invoke.loaded(user) callListeners(profilemanager, listeners, "loaded", user) end
	function profilemanager.invoke.activated(success, user) callListeners(profilemanager, listeners, "activated", activeIndex, accountData.profiles[activeIndex].title, success, user) end
	function profilemanager.invoke.created(index, title, user) callListeners(profilemanager, listeners, "created", index, title, user) end
	function profilemanager.invoke.renamed(success, user, index, title) callListeners(profilemanager, listeners, "renamed", success, index, title, user) end
	function profilemanager.invoke.deleted(success, user, index, title) callListeners(profilemanager, listeners, "deleted", success, index, title, user) end
	function profilemanager.invoke.reset(success, user, index, title) callListeners(profilemanager, listeners, "reset", success, index, title, user) end
	function profilemanager.invoke._(event, ...) callListeners(profilemanager, listeners, event, ...) end

	function profilemanager.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function profilemanager.setListener.activated(listener, callIndex) addListener(listeners, "activated", listener, callIndex) end
	function profilemanager.setListener.created(listener, callIndex) addListener(listeners, "created", listener, callIndex) end
	function profilemanager.setListener.renamed(listener, callIndex) addListener(listeners, "created", listener, callIndex) end
	function profilemanager.setListener.deleted(listener, callIndex) addListener(listeners, "deleted", listener, callIndex) end
	function profilemanager.setListener.reset(listener, callIndex) addListener(listeners, "reset", listener, callIndex) end
	function profilemanager.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Utilities

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
		if not silent then profilemanager.invoke.created(index, accountData.profiles[index].title, user == true) end

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

	--[ Initialization ]

	--Add type
	profilemanager.addType(typename)

	--Load starting data
	profilemanager.load(nil, nil, false, true)

	return profilemanager
end

--| Addon

function wt.CreateAddonmanager(addon, t)
	local addon_type = type(addon)

	if (addon_type ~= "string" or addon_type ~= "number") or not C_AddOns.IsAddOnLoaded(addon) then return nil end

	t = type(t) == "table" and t or {}

	---@type typename_addonmanager
	local typename = "Addonmanager"

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--| Metadata

	local title, version, date, day, month, year, category, notes, author, license, curse, wago, repo, issues, sponsors, logo, changelogLatest, changelog

	--[ Widget ]

	---@type addonmanager
	local addonmanager = {
		invoke = {},
		setListener = {},
	}

	--[ Getters & Setters ]

	--| Events

	function addonmanager.invoke.changed(user) callListeners(addonmanager, listeners, "managed", user) end
	function addonmanager.invoke._(event, ...) callListeners(addonmanager, listeners, event, ...) end

	function addonmanager.setListener.changed(listener, callIndex) addListener(listeners, "managed", listener, callIndex) end
	function addonmanager.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Metadata

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

		local a_type = type(newAddon)

		if (a_type ~= "string" or a_type ~= "number") or not C_AddOns.IsAddOnLoaded(newAddon) then return false end

		addon = a_type ~= "string" and C_AddOns.GetAddOnName(newAddon) or newAddon
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

	--[ Initialization ]

	--Add type
	addonmanager.addType(typename)

	--Load metadata
	addonmanager.setAddon(addon, t.changelog)

	return addonmanager
end