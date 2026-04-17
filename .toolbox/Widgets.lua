--[[ REFERENCES ]]

--[ Toolbox ]

---@class widgetToolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "X-WidgetTools-ToolboxVersion")]

--[ Shortcuts ]

---@type widgetToolsUtilities
local us = WidgetTools.utilities

---@type widgetToolsDebugging
local ds = WidgetTools.debugging

local cr = WrapTextInColor
local crc = WrapTextInColorCode


--[[ CLIPBOARD ]]

--| Value clipboard

---@class clipboard
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


--[[ CONSTRUCTORS ]]

--[ Action ]

function wt.CreateAction(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@class action
	local action = {}

	--[ Properties ]

	--| State

	local enabled = t.disabled ~= true

	--[ Getters & Setters ]

	function action.getType() return "Action" end
	function action.isType(type) return type == "Action" end

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	action.invoke.enabled = function() callListeners(action, listeners, "enabled", enabled) end
	action.invoke.trigger = function(user) callListeners(action, listeners, "trigger", user) end
	action.invoke._ = function(event, ...) callListeners(action, listeners, event, ...) end

	action.setListener.enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	action.setListener.trigger = function(listener, callIndex) addListener(listeners, "trigger", listener, callIndex) end
	action.setListener._ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

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

--[ Toggle ]

function wt.CreateToggle(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@class toggle
	local toggle = {}

	--[ Properties ]

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

	---@type table<string, function[]>
	local listeners = {}

	toggle.invoke.enabled = function() callListeners(toggle, listeners, "enabled", enabled) end
	toggle.invoke.loaded = function(success) callListeners(toggle, listeners, "loaded", success) end
	toggle.invoke.saved = function(success) callListeners(toggle, listeners, "saved", success) end
	toggle.invoke.toggled = function(user) callListeners(toggle, listeners, "toggled", value, user) end
	toggle.invoke._ = function(event, ...) callListeners(toggle, listeners, event, ...) end

	toggle.setListener.enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end
	toggle.setListener.loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end
	toggle.setListener.saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end
	toggle.setListener.toggled = function(listener, callIndex) addListener(listeners, "toggled", listener, callIndex) end
	toggle.setListener._ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end

	--| Options data management

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

function wt.CreateSelector(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@class selector
	local selector = {}

	--[ Properties ]

	local clearable = t.clearable

	--| Toggle items

	---@type (toggle|selectorToggle)[]
	selector.toggles = {}

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

	---Returns the type of this object
	---***
	---@return "Selector"
	---<p></p>
	function selector.getType() return "Selector" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function selector.isType(type) return type == "Selector" end

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	selector.invoke = {
		enabled = function() callListeners(selector, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(selector, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(selector, listeners, "saved", success) end,

		---@param user boolean
		selected = function(user) callListeners(selector, listeners, "selected", value, user) end,

		updated = function() callListeners(selector, listeners, "updated") end,

		added = function(toggle) callListeners(selector, listeners, "added", toggle) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(selector, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	selector.setListener = {
		---@param listener SelectorEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener SelectorEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener SelectorEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener SelectorEventHandler_selected Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		selected = function(listener, callIndex) addListener(listeners, "selected", listener, callIndex) end,

		---@param listener SelectorEventHandler_updated Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		updated = function(listener, callIndex) addListener(listeners, "updated", listener, callIndex) end,

		---@param listener SelectorEventHandler_added Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		added = function(listener, callIndex) addListener(listeners, "added", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener SelectorEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

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

	---Update the list of items currently set for the selector widget, updating its parameters and toggle widgets
	--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
	--- - ***Note:*** The currently selected item may not be the same after an item was removed. In that case, the item at the same index will be selected instead. If one or more items from the last indexes were removed, the new last item at the reduced count index will be selected. Make sure to use **selector.setSelected(...)** to correct the selection if needed!
	---***
	---@param newItems (selectorItem|toggle|selectorToggle)[] Table containing subtables with data used to update the toggle widgets, or already existing toggle widgets
	---@param silent? boolean If false, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
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

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
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

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param data? wrappedInteger If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function selector.saveData(data, silent)
		if type(t.saveData) == "function" then
			t.saveData(type(data) == "table" and verify(data.index) or value)

			if not silent then selector.invoke.saved(true) end
		elseif not silent then selector.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return integer|nil
	function selector.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param data? wrappedInteger If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.setData(data, handleChanges, silent)
		selector.saveData(data, silent)
		selector.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return integer|nil default
	function selector.getDefault() return default end

	---Set the default value
	---@param index integer|nil | ***Default:*** *no change*
	function selector.setDefault(index) default = verify(index) end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.resetData(handleChanges, silent) selector.setData({ index = default }, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function selector.snapshotData(stored) snapshot = stored and selector.getData() or value end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.revertData(handleChanges, silent) selector.setData({ index = snapshot }, handleChanges, silent) end

	---Returns the index of the currently selected item or nil if there is no selection
	---@return integer|nil index
	function selector.getSelected() return value end

	---Verify and set the specified item as selected
	---***
	---@param index? integer ***Default:*** nil *(no selection)*
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "selected" event and call registered listeners | ***Default:*** `false`
	function selector.setSelected(index, user, silent)
		value = verify(index)

		for i = 1, #selector.toggles do selector.toggles[i].setState(i == value, user, silent) end

		if user and t.instantSave ~= false then selector.saveData(nil, silent) end

		if not silent then selector.invoke.selected(user == true) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function selector.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
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

	---@class specialSelector
	local selector = {}

	--[ Properties ]

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
	selector.toggles = {}

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

	---Returns the type of this object
	---***
	---@return "SpecialSelector"
	---<p></p>
	function selector.getType() return "SpecialSelector" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function selector.isType(type) return type == "SpecialSelector" end

	---Return the itemset type specified for this special selector on creation
	---@return SpecialSelectorItemset itemset
	function selector.getItemset() return itemset end

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	selector.invoke = {
		enabled = function() callListeners(selector, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(selector, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(selector, listeners, "saved", success) end,

		---@param user boolean
		selected = function(user) callListeners(selector, listeners, "selected", value, user) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(selector, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	selector.setListener = {
		---@param listener SpecialSelectorEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener SpecialSelectorEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener SpecialSelectorEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener SpecialSelectorEventHandler_selected Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		selected = function(listener, callIndex) addListener(listeners, "selected", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener SpecialSelectorEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
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

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function selector.saveData(data, silent)
		if type(t.saveData) == "function" then
			t.saveData(itemsets[itemset][verify(data or value)].value)

			if not silent then selector.invoke.saved(true) end
		elseif not silent then selector.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return specialSelectorValueTypes|nil
	function selector.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.setData(data, handleChanges, silent)
		selector.saveData(data, silent)
		selector.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return specialSelectorValueTypes|nil default
	function selector.getDefault() return itemsets[itemset][default] and itemsets[itemset][default].value or nil end

	---Set the default value
	---***
	---@param selected integer|specialSelectorValueTypes|nil | ***Default:*** *no change*
	---<p></p>
	function selector.setDefault(selected) default = verify(selected) end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.resetData(handleChanges, silent) selector.setData(default, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
	---***
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function selector.snapshotData(stored) snapshot = stored and selector.getData() or value end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.revertData(handleChanges, silent) selector.setData(snapshot, handleChanges, silent) end

	---Returns the value of the currently selected item or nil if there is no selection
	---@return specialSelectorValueTypes|nil selected
	---<p></p>
	function selector.getSelected() return itemsets[itemset][value] and itemsets[itemset][value].value or nil end

	---Set the specified item as selected
	---***
	---@param selected integer|specialSelectorValueTypes|nil The index or the value of the item to be set as selected | ***Default:*** *no selection:* `nil`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "selected" event and call registered listeners | ***Default:*** `false`
	---<p></p>
	function selector.setSelected(selected, user, silent)
		value = verify(selected)

		for i = 1, #selector.toggles do selector.toggles[i].setState(i == value, user, silent) end

		if user and t.instantSave ~= false then selector.saveData(nil, silent) end

		if not silent then selector.invoke.selected(user == true) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function selector.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
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
	for i = 1, #t.items do if type(t.items[i]) == "table" then
		if t.items[i].isType and t.items[i].isType("Toggle") then
			--| Register the already defined toggle widget

			selector.toggles[i] = t.items[i]
		elseif #inactive > 0 then
			--| Reenable an inactive toggle widget

			selector.toggles[i] = inactive[#inactive]
			table.remove(inactive, #inactive)
		else
			--| Create a new toggle widget

			selector.toggles[i] = wt.CreateToggle({ listeners = { toggled = { { handler = function (_, state, user)
				if type(t.items[selector.toggles[i].index].onSelect) == "function" and user and state then t.items[selector.toggles[i].index].onSelect() end
			end, }, }, }, })
		end

		selector.toggles[i].index = i
	end end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(selector, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, selector.setEnabled) end

	--Set starting value
	selector.setSelected(value, false, true)

	return selector
end

function wt.CreateMultiselector(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@class multiselector
	local selector = {}

	--[ Properties ]

	--| Toggle items

	t.items = type(t.items) == "table" and us.Clone(t.items) or {}
	t.limits = t.limits or {}
	t.limits.min = t.limits.min or 1
	t.limits.max = t.limits.max or #t.items

	---@type (toggle|selectorToggle)[]
	selector.toggles = {}

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

	---Returns the type of this object
	---***
	---@return "Multiselector"
	---<p></p>
	function selector.getType() return "Multiselector" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function selector.isType(type) return type == "Multiselector" end

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	selector.invoke = {
		enabled = function() callListeners(selector, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(selector, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(selector, listeners, "saved", success) end,

		---@param user boolean
		selected = function(user) callListeners(selector, listeners, "selected", value, user) end,

		updated = function() callListeners(selector, listeners, "updated") end,

		added = function(toggle) callListeners(selector, listeners, "added", toggle) end,

		---@param count integer
		limited = function(count) callListeners(selector, listeners, "limited", count <= t.limits.min, count < t.limits.min) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(selector, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	selector.setListener = {
		---@param listener MultiselectorEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener MultiselectorEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener MultiselectorEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener MultiselectorEventHandler_selected Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		selected = function(listener, callIndex) addListener(listeners, "selected", listener, callIndex) end,

		---@param listener MultiselectorEventHandler_updated Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		updated = function(listener, callIndex) addListener(listeners, "updated", listener, callIndex) end,

		---@param listener SelectorEventHandler_added Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		added = function(listener, callIndex) addListener(listeners, "added", listener, callIndex) end,

		---@param listener MultiselectorEventHandler_limited Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		limited = function(listener, callIndex) addListener(listeners, "limited", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener SelectorEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Toggle items

	---Register, update or set up a new toggle widget item
	---***
	---@param item toggle|selectorToggle
	---@param index integer
	---@param silent? boolean ***Default:*** `false`
	local function setToggle(item, index, silent)
		if type(item) ~= "table" then return end

		local new = false

		if item.isType and item.isType("Toggle") then
			--| Register the already defined toggle widget

			new = true
			selector.toggles[index] = item
		elseif #inactive > 0 then
			--| Reenable an inactive toggle widget

			selector.toggles[index] = inactive[#inactive]
			table.remove(inactive, #inactive)
		else
			--| Create a new toggle widget

			new = true
			selector.toggles[index] = wt.CreateToggle({ listeners = { toggled = { { handler = function (_, state, user)
				if type(t.items[selector.toggles[index].index].onSelect) == "function" and user and state then t.items[selector.toggles[index].index].onSelect() end
			end, }, }, }, })
		end

		selector.toggles[index].index = index

		if new and not silent then selector.invoke.added(selector.toggles[index]) end
	end

	---Update the list of items currently set for the selector widget, updating its parameters and toggle widgets
	--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
	--- - ***Note:*** The currently selected item may not be the same after item were removed. In that case, the new item at the same index will be selected instead. If one or more items from the last indexes were removed, the new last item at the reduced count index will be selected. Make sure to use **selector.setSelected(...)** to correct the selection if needed!
	---***
	---@param newItems (selectorItem|toggle|selectorToggle)[] Table containing subtables with data used to update the toggle widgets, or already existing toggle widgets
	---@param silent? boolean If false, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
	function selector.updateItems(newItems, silent)
		t.items = newItems

		--Update the toggle widgets
		for i = 1, #newItems do
			setToggle(newItems[i], i, silent)

			if not silent then selector.toggles[i].invoke._("activated", true) end
		end

		--Deactivate extra toggle widgets
		while #newItems < #selector.toggles do
			selector.toggles[#selector.toggles].setState(nil, nil, silent)

			if not silent then selector.toggles[#selector.toggles].invoke._("activated", false) end

			table.insert(inactive, selector.toggles[#selector.toggles])
			table.remove(selector.toggles, #selector.toggles)
		end

		if not silent then selector.invoke.updated() end

		--Update limits
		if t.limits.min > #t.items then t.limits.min = #t.items end
		if t.limits.max > #t.items then t.limits.max = #t.items end

		selector.setSelections(value, nil, silent)
	end

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function selector.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			selector.setSelections(t.getData(), handleChanges)

			if not silent then selector.invoke.loaded(true) end
		else
			if handleChanges then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then selector.invoke.loaded(false) end
		end
	end

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param data? wrappedBooleanArray If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function selector.saveData(data, silent)
		if type(t.saveData) == "function" then
			t.saveData(type(data) == "table" and verify(data.states) or value)

			if not silent then selector.invoke.saved(true) end
		elseif not silent then selector.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return boolean[]|nil
	function selector.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param data? wrappedBooleanArray If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.setData(data, handleChanges, silent)
		selector.saveData(data, silent)
		selector.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return boolean[] default
	function selector.getDefault() return default end

	---Set the default value
	---@param selections? boolean[] | ***Default:*** *no selected items: `false[]`*
	function selector.setDefault(selections) default = verify(selections) end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.revertData(handleChanges, silent) selector.setData({ states = us.Clone(snapshot) }, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function selector.snapshotData(stored) us.CopyValues(snapshot, stored and selector.getData() or value) end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.resetData(handleChanges, silent) selector.setData({ states = us.Clone(default) }, handleChanges, silent) end

	---Returns the list of all items and their current states
	---***
	---@return boolean[] selections Indexed list of item states
	function selector.getSelections() return us.Clone(value) end

	---Set the specified items as selected
	---***
	---@param selections? boolean[] Indexed list of item states | ***Default:*** *no selected items: `false[]`*
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke "selected" and "limited" events and call registered listeners | ***Default:*** `false`
	function selector.setSelections(selections, user, silent)
		value = verify(selections)

		for i = 1, #selector.toggles do selector.toggles[i].setState(value and value[i], user, silent) end

		if user and t.instantSave ~= false then selector.saveData(nil, silent) end

		if not silent then
			selector.invoke.selected(user == true)

			--| Check limits

			local count = 0

			for _, v in pairs(value) do if v then count = count + 1 end end

			selector.invoke.limited(count)
		end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	---Set the specified item as selected
	---***
	---@param index integer Index of the item | ***Range:*** (1, #selector.toggles)
	---@param selected? boolean If true, set the item at this index as selected | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke "selected" and "limited" events and call registered listeners | ***Default:*** `false`
	function selector.setSelected(index, selected, user, silent)
		if not selector.toggles[index] then return end

		value[index] = selected == true

		selector.toggles[index].setState(selected, user, silent)

		if user and t.instantSave ~= false then selector.saveData(nil, silent) end

		if not silent then
			selector.invoke.selected(user == true)

			--| Check limits

			local count = 0

			for _, v in pairs(value) do if v then count = count + 1 end end

			selector.invoke.limited(count)
		end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function selector.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
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
	for i = 1, #t.items do setToggle(t.items[i], i) end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(selector, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, selector.setEnabled) end

	--Set starting value
	selector.setSelections(value, false, true)

	return selector
end

--[ Textbox ]

function wt.CreateTextbox(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@class textbox
	local textbox = {}

	--[ Properties ]

	--| Data

	t.default = type(t.default) == "string" and t.default or ""
	local default = t.default
	local value = type(t.value) == "string" and t.value or type(t.getData) == "function" and t.getData() or nil
	value = type(value) == "string" and value or default
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "Textbox"
	---<p></p>
	function textbox.getType() return "Textbox" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function textbox.isType(type) return type == "Textbox" end

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	textbox.invoke = {
		enabled = function() callListeners(textbox, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(textbox, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(textbox, listeners, "saved", success) end,

		---@param user boolean
		changed = function(user) callListeners(textbox, listeners, "changed", value, user) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(textbox, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	textbox.setListener = {
		---@param listener TextboxEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener TextboxEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener TextboxEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener TextboxEventHandler_changed Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		changed = function(listener, callIndex) addListener(listeners, "changed", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener TextboxEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
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

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param text? string Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
	function textbox.saveData(text, silent)
		if type(t.saveData) == "function" then
			t.saveData(type(text) == "string" and text or value)

			if not silent then textbox.invoke.saved(true) end
		elseif not silent then textbox.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return string|nil
	function textbox.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param text? string Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function textbox.setData(text, handleChanges, silent)
		textbox.saveData(text, silent)
		textbox.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return string default
	function textbox.getDefault() return default end

	---Set the default value
	---@param text string | ***Default:*** `""`
	function textbox.setDefault(text) default = type(text) == "string" and text or "" end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **textbox.snapshotData()**
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function textbox.revertData(handleChanges, silent) textbox.setData(snapshot, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **textbox.revertData()**
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function textbox.snapshotData(stored) snapshot = stored and textbox.getData() or value end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function textbox.resetData(handleChanges, silent) textbox.setData(default, handleChanges, silent) end

	---Returns the current text value of the widget
	---@return string
	function textbox.getText() return value end

	---Set the text value of the widget
	---***
	---@param text? string ***Default:*** ""
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
	function textbox.setText(text, user, silent)
		value = type(text) == "string" and text or ""

		if not silent then textbox.invoke.changed(user == true) end

		if user and t.instantSave ~= false then textbox.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function textbox.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
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

--[ Numeric ]

function wt.CreateNumeric(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@class numeric
	local numeric = {}

	--[ Properties ]

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

	---Returns the type of this object
	---***
	---@return "Numeric"
	---<p></p>
	function numeric.getType() return "Numeric" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function numeric.isType(type) return type == "Numeric" end

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	numeric.invoke = {
		enabled = function() callListeners(numeric, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(numeric, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(numeric, listeners, "saved", success) end,

		---@param user boolean
		changed = function(user) callListeners(numeric, listeners, "changed", value, user) end,

		min = function() callListeners(numeric, listeners, "min", limitMin) end,

		max = function() callListeners(numeric, listeners, "max", limitMax) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(numeric, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	numeric.setListener = {
		---@param listener NumericEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener NumericEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener NumericEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener NumericEventHandler_changed Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		changed = function(listener, callIndex) addListener(listeners, "changed", listener, callIndex) end,

		---@param listener NumericEventHandler_min Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		min = function(listener, callIndex) addListener(listeners, "min", listener, callIndex) end,

		---@param listener NumericEventHandler_max Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		max = function(listener, callIndex) addListener(listeners, "max", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener NumericEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
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

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param number? number Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
	function numeric.saveData(number, silent)
		if type(t.saveData) == "function" then
			t.saveData(number and verify(number) or value)

			if not silent then numeric.invoke.saved(true) end
		elseif not silent then numeric.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return number|nil
	function numeric.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param number? number Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function numeric.setData(number, handleChanges, silent)
		numeric.saveData(number, silent)
		numeric.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return number default
	function numeric.getDefault() return default end

	---Set the default value
	---@param number number | ***Default:*** *no change*
	function numeric.setDefault(number) default = verify(number) end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **numeric.snapshotData()**
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function numeric.revertData(handleChanges, silent) numeric.setData(snapshot, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **numeric.revertData()**
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function numeric.snapshotData(stored) snapshot = stored and numeric.getData() or value end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function numeric.resetData(handleChanges, silent) numeric.setData(default, handleChanges, silent) end

	---Returns the current value of the widget
	---@return number
	function numeric.getNumber() return value end

	---Set the value of the widget
	---***
	---@param number? number A valid number value within the specified **t.min**, **t.max** range | ***Default:*** **t.min**
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	function numeric.setNumber(number, user, silent)
		value = verify(number)

		if not silent then numeric.invoke.changed(user == true) end

		if user and t.instantSave ~= false then numeric.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	---Decrease the value of the widget by the specified step or alt step amount
	---@param alt? boolean If true, use alt step instead of step to decrease the value by | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
	function numeric.decrease(alt, user, silent) numeric.setNumber(value - (alt and altStep or step), user, silent) end

	---Increase the value of the widget by the specified step or alt step amount
	---@param alt? boolean If true, use alt step instead of step to increase the value by | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
	function numeric.increase(alt, user, silent) numeric.setNumber(value + (alt and altStep or step), user, silent) end

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function numeric.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
	function numeric.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then numeric.invoke.enabled() end
	end

	--| Value limits

	---Return the current lower value limit of the widget
	---@return number
	function numeric.getMin() return limitMin end

	---Set the lower value limit of the widget
	---***
	---@param number number Updates the lower limit value | ***Range:*** (any, *current upper limit*) *capped automatically*
	---@param silent? boolean If false, invoke a "min" event and call registered listeners | ***Default:*** `false`
	function numeric.setMin(number, silent)
		limitMin = min(number, limitMax)

		if not silent then numeric.invoke.min() end
	end

	---Return the current upper value limit of the widget
	---@return number
	function numeric.getMax() return limitMax end

	---Set the upper value limit of the widget
	---***
	---@param number number Updates the upper limit value | ***Range:*** (*current lower limit*, any) *floored automatically*
	---@param silent? boolean If false, invoke a "max" event and call registered listeners | ***Default:*** `false`
	function numeric.setMax(number, silent)
		limitMax = max(limitMin, number)

		if not silent then numeric.invoke.max() end
	end

	--| Value step

	---Return the current value step of the widget
	---@return number
	function numeric.getStep() return step end

	---Return the current alternative value step of the widget
	---@return number|nil
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

--[ Color Data ]

function wt.CreateColormanager(t)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	---@class colormanager
	local colormanager = {}

	--[ Properties ]

	local active = false

	--| Data

	local default = wt.PackColor(wt.UnpackColor(t.default))
	local value = t.value or type(t.getData) == "function" and t.getData() or nil
	value = wt.PackColor(wt.UnpackColor(value))
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "Colormanager"
	---<p></p>
	function colormanager.getType() return "Colormanager" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function colormanager.isType(type) return type == "Colormanager" end

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--Call all registered listeners for a custom widget event
	colormanager.invoke = {
		enabled = function() callListeners(colormanager, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(colormanager, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(colormanager, listeners, "saved", success) end,

		---@param user boolean
		colored = function(user) callListeners(colormanager, listeners, "colored", value, user) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(colormanager, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	colormanager.setListener = {
		---@param listener ColorpickerEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener ColorpickerEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener ColorpickerEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener ColorpickerEventHandler_colored Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		colored = function(listener, callIndex) addListener(listeners, "colored", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener ColorpickerEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
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

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param color? colorData|colorRGBA Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
	function colormanager.saveData(color, silent)
		if type(t.saveData) == "function" then
			t.saveData(color and wt.PackColor(wt.UnpackColor(color)) or value)

			if not silent then colormanager.invoke.saved(true) end
		elseif not silent then colormanager.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return colorData|nil
	function colormanager.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param color? colorData|colorRGBA Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function colormanager.setData(color, handleChanges, silent)
		colormanager.saveData(color, silent)
		colormanager.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return colorData default
	function colormanager.getDefault() return us.Clone(default) end

	---Set the default value
	---@param color? colorData | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
	function colormanager.setDefault(color) default = wt.PackColor(wt.UnpackColor(color)) end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **colormanager.snapshotData()**
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function colormanager.revertData(handleChanges, silent) colormanager.setData(snapshot, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **colormanager.revertData()**
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function colormanager.snapshotData(stored) us.CopyValues(snapshot, stored and colormanager.getData() or value) end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function colormanager.resetData(handleChanges, silent) colormanager.setData(default, handleChanges, silent) end

	---Returns the currently set channel values wrapped in a color table
	---@return colorData
	function colormanager.getColor() return us.Clone(value) end

	---Set the managed color values
	---***
	---@param color? colorData|colorRGBA ***Default:*** { r = 1, g = 1, b = 1, a = 1 } *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "colored" event and call registered listeners | ***Default:*** `false`
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

	---Open the the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) for this color picker
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

	---Return the active status of this color picker, whether the main color wheel window was opened for and is currently updating the color of this widget
	---@return boolean active True, if the color wheel has been opened for this color picker widget
	function colormanager.isActive() return active end

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function colormanager.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
	function colormanager.setEnabled(state, silent)
		enabled = state ~= false

		--Update the color when re-enabled
		if active then colorUpdate() end

		if not silent then colormanager.invoke.enabled() end
	end

	--[ Color Wheel Toggle ]

	--Button to open the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) on action with
	colormanager.button = wt.CreateAction({ action = colormanager.openColorPicker, })

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

--[ Profile Data ]

function wt.CreateProfilemanager(accountData, characterData, defaultData, t)
	if type(accountData) ~= "table" or type(characterData) ~= "table" or type(defaultData) ~= "table" then return end

	t = type(t) == "table" and t or {}
	t.category = type(t.category) == "string" and t.category or ""

	--[ Widget ]

	---@class profilemanager
	---@field data table Reference to live data table of the currently active profile
	---@field firstLoad boolean True, if the `accountData.profiles` table did not exist yet
	---@field newCharacter boolean True, if the `characterData.activeProfile` integer did not exist yet
	local profilemanager = {
		firstLoad = type(accountData.profiles) ~= "table",
		newCharacter = type(characterData.activeProfile) ~= "number"
	}

	--[ Properties ]

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

	---Returns the type of this object
	---***
	---@return "Profilemanager"
	---<p></p>
	function profilemanager.getType() return "Profilemanager" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function profilemanager.isType(type) return type == "Profilemanager" end

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	profilemanager.invoke = {
		---@param user boolean
		loaded = function(user) callListeners(profilemanager, listeners, "loaded", user) end,

		---@param success boolean
		---@param user boolean
		activated = function(success, user) callListeners(profilemanager, listeners, "activated", activeIndex, accountData.profiles[activeIndex].title, success, user) end,

		---@param index integer
		---@param title string
		---@param user boolean
		created = function(index, title, user) callListeners(profilemanager, listeners, "created", index, title, user) end,

		---@param success boolean
		---@param user boolean
		---@param index any
		---@param title? string
		renamed = function(success, user, index, title) callListeners(profilemanager, listeners, "renamed", success, index, title, user) end,

		---@param success boolean
		---@param user boolean
		---@param index any
		---@param title? string
		deleted = function(success, user, index, title) callListeners(profilemanager, listeners, "deleted", success, index, title, user) end,

		---@param success boolean
		---@param user boolean
		---@param index any
		---@param title? string
		reset = function(success, user, index, title) callListeners(profilemanager, listeners, "reset", success, index, title, user) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(profilemanager, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	profilemanager.setListener = {
		---@param listener ProfilemanagerEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener ProfilemanagerEventHandler_activated Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		activated = function(listener, callIndex) addListener(listeners, "activated", listener, callIndex) end,

		---@param listener ProfilemanagerEventHandler_created Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		created = function(listener, callIndex) addListener(listeners, "created", listener, callIndex) end,

		---@param listener ProfilemanagerEventHandler_renamed Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		renamed = function(listener, callIndex) addListener(listeners, "created", listener, callIndex) end,

		---@param listener ProfilemanagerEventHandler_deleted Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		deleted = function(listener, callIndex) addListener(listeners, "deleted", listener, callIndex) end,

		---@param listener ProfilemanagerEventHandler_reset Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		reset = function(listener, callIndex) addListener(listeners, "reset", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener ProfilemanagerEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

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

	---Activate the specified settings profile
	---***
	---@param index? integer Index of the profile to set as the currently active settings profile | ***Default:*** *currently active profile index* or `1`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "applied" event and call registered listeners | ***Default:*** `false`
	---***
	---@return integer? index The index of the active profile | ***Default:*** `nil`
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

	---Find a profile by its display title and return its index
	---***
	---@param title string Name of the profile to find
	---@param skipFirst? boolean Set to `true` to find duplicate `title` | ***Default:*** `false`
	---@return integer? index
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

	---Create a new settings profile
	---***
	---@param name? string Name tag to use when setting the display title of the new profile | ***Default:*** `duplicate` and **accountData.profiles[duplicate].title** or "Profile"
	---@param number? integer Starting value for the incremented number appended to `name` if it's used | ***Default:*** 2
	---@param duplicate? integer Index of the profile to create the new profile as a duplicate of instead of using default data values
	---@param apply? boolean Whether to immediately set the new profile as the active profile or not | ***Default:*** `true`
	---@param index? integer Place the new profile under this specified index in **accountData.profile** instead of the end of the list | ***Range:*** (1, #**accountData.profiles** + 1)
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "created" event and call registered listeners | ***Default:*** `false`
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

	---Rename the specified profile
	---@param index? integer Index of the profile to rename | ***Default:*** *currently active profile index*
	---@param name? string The new title of the profile to set | ***Default:*** "Profile"
	---@param number? integer Starting value for the incremented number appended to `name` if it's used | ***Default:*** 2
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "renamed" event and call registered listeners | ***Default:*** `false`
	---***
	---@return boolean # True on success, false if the operation failed
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

	---Delete the specified profile
	---***
	---@param index? integer Index of the profile to delete | ***Default:*** *currently active profile index*
	---@param unsafe? boolean If false, show a popup confirmation before attempting to delete the specified profile | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "deleted" event and call registered listeners | ***Default:*** `false`
	---***
	---@return boolean # True on success, false if the operation failed
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

	---Reset the specified profile data to default values
	---***
	---@param index? integer Index of the profile to restore to defaults | ***Default:*** *currently active profile index*
	---@param unsafe? boolean If false, show a popup confirmation before attempting to reset the specified profile | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "reset" event and call registered listeners | ***Default:*** `false`
	---***
	---@return boolean # True on success, false if the operation failed
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

	---Check & fix a profile data table based on the specified sample profile
	---***
	---@param profileData table Profile data table to check
	---@param compareWith? table  Profile data table to sample | ***Default:*** `defaultData`
	---***
	---@return table profileData Reference to `profileData` (it was already updated during the operation, no need for setting it again)
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

	---Load profiles data
	---***
	---@param p? profileStorage Table holding the list of profiles to store | ***Default:*** *validate* **accountData** *(if the data is missing or invalid, set up a default profile)*
	---@param activeProfile? integer Index of the active profile to set | ***Default:*** *currently active profile index*
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "loaded" event and call registered listeners | ***Default:*** `false`
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

			ds.Log("Recovered misplaced data:" .. us.TableToString(recovered), "Profilemanager (" .. category .. ") loadProfiles")
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