--| Toolbox

---@type widgetToolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "X-WidgetTools-ToolboxVersion")]

--| References

---@type widgetToolsUtilities
local us = WidgetTools.utilities

---@type widgetToolsDebugging
local ds = WidgetTools.debugging

local cr = WrapTextInColor
local crc = WrapTextInColorCode


--[ Clipboard ]

wt.clipboard = {}


--[[ UTILITIES ]]

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
---@param widget AnyWidgetType
---@param listeners table<string, function[]>
---@param event string
---@param ... any
local function callListeners(widget, listeners, event, ...)
	local l = listeners[event]

	if not l then return end

	for i = 1, #l do l[i](widget, ...) end
end


--[[ ACTION ]]

function wt.CreateAction(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@type action
	local action = { invoke = {}, setListener = {}, }

	--[ Properties ]

	---@type table<string, function[]>
	local listeners = {}

	--| State

	local enabled = t.disabled ~= true

	--[ Getters & Setters ]

	function action.getType() return "Action" end
	function action.isType(type) return type == "Action" end

	--| Events

	function action.invoke.enabled() callListeners(action, listeners, "enabled", enabled) end
	function action.invoke.trigger(user) callListeners(action, listeners, "trigger", user) end
	function action.invoke._(event, ...) callListeners(action, listeners, event, ...) end

	function action.setListener.enabled(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	function action.setListener.trigger(listener, callIndex) addListener(listeners, "trigger", listener, callIndex) end
	function action.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| State

	function action.isEnabled() return enabled end
	function action.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then action.invoke.enabled() end
	end

	--| Action

	function action.trigger(user, silent)
		if enabled and t.action then t.action(action, user) end

		if not silent then action.invoke.trigger(user) end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then action.setListener._(v[i].event, v[i].handler, v[i].callIndex) else action.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, action.setEnabled) end

	return action
end


--[[ TOGGLE ]]

function wt.CreateToggle(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@type toggle
	local toggle = { invoke = {}, setListener = {}, }

	--[ Properties ]

	---@type table<string, function[]>
	local listeners = {}

	--| Data

	local default = t.default == true
	local value = t.value
	if type(value) ~= "boolean" then if type(t.getData) == "function" then value = t.getData() else value = default end end
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--[ Getters & Setters ]

	function toggle.getType() return "Toggle" end
	function toggle.isType(type) return type == "Toggle" end

	--| Events

	function toggle.invoke.enabled() callListeners(toggle, listeners, "enabled", enabled) end
	function toggle.invoke.loaded(success) callListeners(toggle, listeners, "loaded", success) end
	function toggle.invoke.saved(success) callListeners(toggle, listeners, "saved", success) end
	function toggle.invoke.toggled(user) callListeners(toggle, listeners, "toggled", value, user) end
	function toggle.invoke._(event, ...) callListeners(toggle, listeners, event, ...) end

	function toggle.setListener.enabled(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	function toggle.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function toggle.setListener.saved(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	function toggle.setListener.toggled(listener, callIndex) addListener(listeners, "toggled", listener, callIndex) end
	function toggle.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Data management

	function toggle.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			toggle.setState(t.getData(), handleChanges, silent)

			if not silent then toggle.invoke.loaded(true) end
		else
			if handleChanges and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then toggle.invoke.loaded(false) end
		end
	end

	function toggle.saveData(state, silent)
		if type(t.saveData) == "function" then
			if state == nil then state = value end

			t.saveData(state == true)

			if not silent then toggle.invoke.saved(true) end
		elseif not silent then toggle.invoke.saved(false) end
	end

	function toggle.getData() return type(t.getData) == "function" and t.getData() or nil end
	function toggle.setData(state, handleChanges, silent)
		toggle.saveData(state, silent)
		toggle.loadData(handleChanges, silent)
	end

	function toggle.getDefault() return default end
	function toggle.setDefault(state) default = state == true end
	function toggle.resetData(handleChanges, silent) toggle.setData(default, handleChanges, silent) end

	function toggle.snapshotData(stored) if stored == true then snapshot = toggle.getData() else snapshot = value end end
	function toggle.revertData(handleChanges, silent) toggle.setData(snapshot, handleChanges, silent) end

	function toggle.getState() return value end
	function toggle.setState(state, user, silent)
		value = state == true

		if not silent then toggle.invoke.toggled(user == true) end

		if user and t.instantSave ~= false then toggle.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	function toggle.toggleState(user, silent) toggle.setState(not value, user, silent) end

	function toggle.formatValue(state)
		if type(state) ~= "boolean" then state = value end

		return crc((state and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), state and "FFAAAAFF" or "FFFFAA66")
	end

	--| State

	function toggle.isEnabled() return enabled end
	function toggle.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then toggle.invoke.enabled() end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then toggle.setListener._(v[i].event, v[i].handler, v[i].callIndex) else toggle.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(toggle, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, toggle.setEnabled) end

	--Set starting value
	toggle.setState(value, false, true)

	return toggle
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

function wt.CreateSelector(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@type selector
	local selector = { invoke = {}, setListener = {}, toggles = {} }

	--[ Properties ]

	---@type table<string, function[]>
	local listeners = {}

	local clearable = t.clearable

	--| Toggle items

	---@type (toggle|selectorToggle)[]
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

	--[ Getters & Setters ]

	function selector.getType() return "Selector" end
	function selector.isType(type) return type == "Selector" end

	--| Events

	function selector.invoke.enabled() callListeners(selector, listeners, "enabled", enabled) end
	function selector.invoke.loaded(success) callListeners(selector, listeners, "loaded", success) end
	function selector.invoke.saved(success) callListeners(selector, listeners, "saved", success) end
	function selector.invoke.selected(user) callListeners(selector, listeners, "selected", value, user) end
	function selector.invoke.updated() callListeners(selector, listeners, "updated") end
	function selector.invoke.added(toggle) callListeners(selector, listeners, "added", toggle) end
	function selector.invoke._(event, ...) callListeners(selector, listeners, event, ...) end

	function selector.setListener.enabled(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	function selector.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function selector.setListener.saved(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	function selector.setListener.selected(listener, callIndex) addListener(listeners, "selected", listener, callIndex) end
	function selector.setListener.updated(listener, callIndex) addListener(listeners, "updated", listener, callIndex) end
	function selector.setListener.added(listener, callIndex) addListener(listeners, "added", listener, callIndex) end
	function selector.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Toggle items

	---Register, update or set up a new toggle widget item
	---***
	---@param index integer
	---@param silent? boolean ***Default:*** `false`
	local function setToggle(index, silent)
		local new = false

		if wt.IsWidget(t.items[index]) == "Toggle" then
			--| Register the already defined toggle widget

			new = true
			selector.toggles[index] = t.items[index]
		elseif index > #selector.toggles then
			if #inactive > 0 then
				--| Reenable an inactive toggle widget

				selector.toggles[index] = inactive[#inactive]
				table.remove(inactive, #inactive)
			else
				--| Create a new toggle widget

				new = true
				selector.toggles[index] = wt.CreateToggle({ listeners = { toggled = { { handler = function (_, state, user)
					if state and user and type(t.items[selector.toggles[index].index].onSelect) == "function" then t.items[selector.toggles[index].index].onSelect() end
				end, }, }, },  })
			end
		end

		selector.toggles[index].index = index

		if new and not silent then selector.invoke.added(selector.toggles[index]) end
	end

	function selector.updateItems(newItems, silent)
		t.items = newItems

		--Update the toggle widgets
		for i = 1, #newItems do
			setToggle(i, silent)

			if not silent then selector.toggles[i].invoke._("activated", true) end
		end

		--Deactivate extra toggle widgets
		while #newItems < #selector.toggles do
			selector.toggles[#selector.toggles].setState(false)

			if not silent then selector.toggles[#selector.toggles].invoke._("activated", false) end

			table.insert(inactive, selector.toggles[#selector.toggles])
			table.remove(selector.toggles, #selector.toggles)
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

		for i = 1, #selector.toggles do selector.toggles[i].setState(i == value, user, silent) end

		if user and t.instantSave ~= false then selector.saveData(nil, silent) end

		if not silent then selector.invoke.selected(user == true) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	function selector.isEnabled() return enabled end
	function selector.setEnabled(state, silent)
		enabled = state ~= false

		--Update toggle items
		for i = 1, #selector.toggles do selector.toggles[i].setEnabled(state, silent) end

		if not silent then selector.invoke.enabled() end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then selector.setListener._(v[i].event, v[i].handler, v[i].callIndex) else selector.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register starting items
	for i = 1, #t.items do setToggle(i) end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(selector, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, selector.setEnabled) end

	--Set starting value
	selector.setSelected(value, false, true)

	return selector
end

function wt.CreateSpecialSelector(itemset, t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@type specialSelector
	local specialSelector = { invoke = {}, setListener = {}, toggles = {} }

	--[ Properties ]

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

	---@type (toggle|selectorToggle)[]
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

	--[ Getters & Setters ]

	function specialSelector.getType() return "SpecialSelector" end
	function specialSelector.isType(type) return type == "SpecialSelector" end

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

		for i = 1, #specialSelector.toggles do specialSelector.toggles[i].setState(i == value, user, silent) end

		if user and t.instantSave ~= false then specialSelector.saveData(nil, silent) end

		if not silent then specialSelector.invoke.selected(user == true) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	function specialSelector.isEnabled() return enabled end
	function specialSelector.setEnabled(state, silent)
		enabled = state ~= false

		--Update toggle items
		for i = 1, #specialSelector.toggles do specialSelector.toggles[i].setEnabled(state, silent) end

		if not silent then specialSelector.invoke.enabled() end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then specialSelector.setListener._(v[i].event, v[i].handler, v[i].callIndex) else specialSelector.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register starting items
	for i = 1, #t.items do if type(t.items[i]) == "table" then
		if t.items[i].isType and t.items[i].isType("Toggle") then
			--| Register the already defined toggle widget

			specialSelector.toggles[i] = t.items[i]
		elseif #inactive > 0 then
			--| Reenable an inactive toggle widget

			specialSelector.toggles[i] = inactive[#inactive]
			table.remove(inactive, #inactive)
		else
			--| Create a new toggle widget

			specialSelector.toggles[i] = wt.CreateToggle({ listeners = { toggled = { { handler = function (_, state, user)
				if type(t.items[specialSelector.toggles[i].index].onSelect) == "function" and user and state then t.items[specialSelector.toggles[i].index].onSelect() end
			end, }, }, }, })
		end

		specialSelector.toggles[i].index = i
	end end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(specialSelector, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, specialSelector.setEnabled) end

	--Set starting value
	specialSelector.setSelected(value, false, true)

	return specialSelector
end

function wt.CreateMultiselector(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@type multiselector
	local multiselector = { invoke = {}, setListener = {}, toggles = {} }

	--[ Properties ]

	---@type table<string, function[]>
	local listeners = {}

	--| Toggle items

	t.items = type(t.items) == "table" and us.Clone(t.items) or {}
	t.limits = t.limits or {}
	t.limits.min = t.limits.min or 1
	t.limits.max = t.limits.max or #t.items

	---@type (toggle|selectorToggle)[]
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

	--[ Getters & Setters ]

	function multiselector.getType() return "Multiselector" end
	function multiselector.isType(type) return type == "Multiselector" end

	--| Events

	function multiselector.invoke.enabled() callListeners(multiselector, listeners, "enabled", enabled) end
	function multiselector.invoke.loaded(success) callListeners(multiselector, listeners, "loaded", success) end
	function multiselector.invoke.saved(success) callListeners(multiselector, listeners, "saved", success) end
	function multiselector.invoke.selected(user) callListeners(multiselector, listeners, "selected", value, user) end
	function multiselector.invoke.updated() callListeners(multiselector, listeners, "updated") end
	function multiselector.invoke.added(toggle) callListeners(multiselector, listeners, "added", toggle) end
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

		if item.isType and item.isType("Toggle") then
			--| Register the already defined toggle widget

			new = true
			multiselector.toggles[index] = item
		elseif #inactive > 0 then
			--| Reenable an inactive toggle widget

			multiselector.toggles[index] = inactive[#inactive]
			table.remove(inactive, #inactive)
		else
			--| Create a new toggle widget

			new = true
			multiselector.toggles[index] = wt.CreateToggle({ listeners = { toggled = { { handler = function (_, state, user)
				if type(t.items[multiselector.toggles[index].index].onSelect) == "function" and user and state then t.items[multiselector.toggles[index].index].onSelect() end
			end, }, }, }, })
		end

		multiselector.toggles[index].index = index

		if new and not silent then multiselector.invoke.added(multiselector.toggles[index]) end
	end

	function multiselector.updateItems(newItems, silent)
		t.items = newItems

		--Update the toggle widgets
		for i = 1, #newItems do
			setToggle(newItems[i], i, silent)

			if not silent then multiselector.toggles[i].invoke._("activated", true) end
		end

		--Deactivate extra toggle widgets
		while #newItems < #multiselector.toggles do
			multiselector.toggles[#multiselector.toggles].setState(nil, nil, silent)

			if not silent then multiselector.toggles[#multiselector.toggles].invoke._("activated", false) end

			table.insert(inactive, multiselector.toggles[#multiselector.toggles])
			table.remove(multiselector.toggles, #multiselector.toggles)
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

		for i = 1, #multiselector.toggles do multiselector.toggles[i].setState(value and value[i], user, silent) end

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
		if not multiselector.toggles[index] then return end

		value[index] = selected == true

		multiselector.toggles[index].setState(selected, user, silent)

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

		--Update toggle items
		for i = 1, #multiselector.toggles do multiselector.toggles[i].setEnabled(state, silent) end

		if not silent then multiselector.invoke.enabled() end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then multiselector.setListener._(v[i].event, v[i].handler, v[i].callIndex) else multiselector.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register starting items
	for i = 1, #t.items do setToggle(t.items[i], i) end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(multiselector, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, multiselector.setEnabled) end

	--Set starting value
	multiselector.setSelections(value, false, true)

	return multiselector
end


--[[ TEXTBOX ]]

function wt.CreateTextbox(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@type textbox
	local textbox = { invoke = {}, setListener = {}, }

	--[ Properties ]

	---@type table<string, function[]>
	local listeners = {}

	--| Data

	t.default = type(t.default) == "string" and t.default or ""
	local default = t.default
	local value = type(t.value) == "string" and t.value or type(t.getData) == "function" and t.getData() or nil
	value = type(value) == "string" and value or default
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--[ Getters & Setters ]

	function textbox.getType() return "Textbox" end
	function textbox.isType(type) return type == "Textbox" end

	--| Events

	function textbox.invoke.enabled() callListeners(textbox, listeners, "enabled", enabled) end
	function textbox.invoke.loaded(success) callListeners(textbox, listeners, "loaded", success) end
	function textbox.invoke.saved(success) callListeners(textbox, listeners, "saved", success) end
	function textbox.invoke.changed(user) callListeners(textbox, listeners, "changed", value, user) end
	function textbox.invoke._(event, ...) callListeners(textbox, listeners, event, ...) end

	function textbox.setListener.enabled(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	function textbox.setListener.loaded(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	function textbox.setListener.saved(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	function textbox.setListener.changed(listener, callIndex) addListener(listeners, "changed", listener, callIndex) end
	function textbox.setListener._(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Data management

	function textbox.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			textbox.setText(t.getData(), handleChanges, silent)

			if not silent then textbox.invoke.loaded(true) end
		else
			if handleChanges and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then textbox.invoke.loaded(false) end
		end
	end

	function textbox.saveData(text, silent)
		if type(t.saveData) == "function" then
			t.saveData(type(text) == "string" and text or value)

			if not silent then textbox.invoke.saved(true) end
		elseif not silent then textbox.invoke.saved(false) end
	end

	function textbox.getData() return type(t.getData) == "function" and t.getData() or nil end
	function textbox.setData(text, handleChanges, silent)
		textbox.saveData(text, silent)
		textbox.loadData(handleChanges, silent)
	end

	function textbox.getDefault() return default end
	function textbox.setDefault(text) default = type(text) == "string" and text or "" end
	function textbox.resetData(handleChanges, silent) textbox.setData(default, handleChanges, silent) end

	function textbox.snapshotData(stored) snapshot = stored and textbox.getData() or value end
	function textbox.revertData(handleChanges, silent) textbox.setData(snapshot, handleChanges, silent) end

	function textbox.getText() return value end
	function textbox.setText(text, user, silent)
		value = type(text) == "string" and text or ""

		if not silent then textbox.invoke.changed(user == true) end

		if user and t.instantSave ~= false then textbox.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	function textbox.isEnabled() return enabled end
	function textbox.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then textbox.invoke.enabled() end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then textbox.setListener._(v[i].event, v[i].handler, v[i].callIndex) else textbox.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(textbox, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, textbox.setEnabled) end

	--Set starting value
	textbox.setText(t.color and cr(value, t.color) or value, false, true)

	return textbox
end


--[[ NUMERIC ]]

function wt.CreateNumeric(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@type numeric
	local numeric = { invoke = {}, setListener = {}, }

	--[ Properties ]

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

	--[ Getters & Setters ]

	function numeric.getType() return "Numeric" end
	function numeric.isType(type) return type == "Numeric" end

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

	--| State

	function numeric.isEnabled() return enabled end
	function numeric.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then numeric.invoke.enabled() end
	end

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

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then numeric.setListener._(v[i].event, v[i].handler, v[i].callIndex) else numeric.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(numeric, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, numeric.setEnabled) end

	--Set starting value
	numeric.setNumber(value, false, true)

	return numeric
end


--[[ COLOR DATA ]]

function wt.CreateColormanager(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@type colormanager
	local colormanager = { invoke = {}, setListener = {}, }

	--[ Properties ]

	---@type table<string, function[]>
	local listeners = {}

	local active = false

	--| Data

	local default = wt.PackColor(wt.UnpackColor(t.default))
	local value = t.value or type(t.getData) == "function" and t.getData() or nil
	value = wt.PackColor(wt.UnpackColor(value))
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--[ Getters & Setters ]

	function colormanager.getType() return "Colormanager" end
	function colormanager.isType(type) return type == "Colormanager" end

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

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then colormanager.setListener._(v[i].event, v[i].handler, v[i].callIndex) else colormanager.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(colormanager, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, colormanager.setEnabled) end

	--Set starting value
	colormanager.setColor(value, false, true)

	return colormanager
end


--[[ PROFILE DATA ]]

function wt.CreateProfilemanager(accountData, characterData, defaultData, t)
	if type(accountData) ~= "table" or type(characterData) ~= "table" or type(defaultData) ~= "table" then return end

	t = type(t) == "table" and t or {}
	t.category = type(t.category) == "string" and t.category or ""

	--[ Widget ]

	---@type profilemanager
	local profilemanager = {
		data = {},
		firstLoad = type(accountData.profiles) ~= "table",
		newCharacter = type(characterData.activeProfile) ~= "number",
		invoke = {},
		setListener = {},
	}

	--[ Properties ]

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

	--[ Getters & Setters ]

	function profilemanager.getType() return "Profilemanager" end
	function profilemanager.isType(type) return type == "Profilemanager" end

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
	---@param name? string ***Default:*** "Profile"
	---@param number? integer ***Default:*** 2
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

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then profilemanager.setListener._(v[i].event, v[i].handler, v[i].callIndex) else profilemanager.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Load starting data
	profilemanager.load(nil, nil, false, true)

	return profilemanager
end