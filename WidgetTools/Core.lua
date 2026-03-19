--[[ NAMESPACE ]]

---@class addonNamespace
local ns = select(2, ...)


--[[ UTILITIES ]]

---@type widgetToolsUtilities
ns.us = {}

--[ General ]


---@param t table Table to be sorted (in an ascending order and/or alphabetically, based on the `<` operator)
---@return function iterator Function returning the key, value pairs of the table in order
function ns.us.SortedPairs(t)
	local s = {}

	for k in pairs(t) do table.insert(s, k) end
	table.sort(s, function(x, y) if type(x) == "number" and type(y) == "number" then return x < y else return tostring(x) < tostring(y) end end)

	local i = 0
	local iterator = function ()
		i = i + 1
		if s[i] == nil then return nil else return s[i], t[s[i]] end
	end

	return iterator
end

--Modifier key down checking function lookup table
local modifierKeyDownCheckers = {
	CTRL = IsControlKeyDown,
	SHIFT = IsShiftKeyDown,
	ALT = IsAltKeyDown,
	LCTRL = IsLeftControlKeyDown,
	RCTRL = IsRightControlKeyDown,
	LSHIFT = IsLeftShiftKeyDown,
	RSHIFT = IsRightShiftKeyDown,
	LALT = IsLeftAltKeyDown,
	RALT = IsRightAltKeyDown,
}

ns.us.isKeyDown = setmetatable({}, {
	__index = function (_, k) return modifierKeyDownCheckers[k] or IsModifierKeyDown end,
	__newindex = function() end,
	__metatable = "protected",
})

--[ Math ]

---@param number? number A fractional number value to round | ***Default:*** 0
---@param decimals? integer Specify the number of decimal places to round the number to | ***Default:*** 0
function ns.us.Round(number, decimals)
	if type(number) ~= "number" then number = 0 end
	if type(decimals) ~= "number" then decimals = 0 end

	local multiplier = 10 ^ (decimals or 0)

	return math.floor(number * multiplier + 0.5) / multiplier
end

--[ Validation ]

---@return boolean|string # If **t** is recognized as a [FrameScriptObject](https://warcraft.wiki.gg/wiki/UIOBJECT_FrameScriptObject), return true, or, return the frame name if named or the debug name if unnamed but recognized as a UI [Object](https://warcraft.wiki.gg/wiki/UIOBJECT_Object) with a parent, otherwise, return false
function ns.us.IsFrame(t)
	if type(t) ~= "table" then return false end

	return t.GetObjectType and t.IsObjectType and (t.GetName and t:GetName() or t.GetParent and t:GetParent() and t.GetDebugName and t:GetDebugName() or true) or false
end

---@param s string Name of the frame to find (and the key of its child region appended to it after a period character)
---@return AnyFrameObject|nil frame Reference to the object
function ns.us.ToFrame(s)
	local frame = nil

	--Find the global reference
	if type(s) == "string" then for name in s:gmatch("[^.]+") do frame = frame and frame[name] or _G[name] end end

	return ns.us.IsFrame(frame) and frame or nil
end

--[ Formatting ]

---@param value number Number value to turn into a string with thousand separation
---@param decimals? number Specify the number of decimal places to display if the number is a fractional value | ***Default:*** 0
---@param round? boolean Round the number value to the specified number of decimal places | ***Default:*** true
---@param trim? boolean Trim trailing zeros in decimal places | ***Default:*** true
---@return string # ***Default:*** ""
function ns.us.Thousands(value, decimals, round, trim)
	if type(value) ~= "number" then return "" end

	value = round == false and value or ns.us.Round(value, decimals)
	local sign = value < 0 and "-" or ""
	local fraction = math.abs(value) % 1
	local integer = tostring(math.abs(value) - fraction)
	local decimalText = tostring(fraction):sub(3, (decimals or 0) + 2)
	local leftover

	while true do
		integer, leftover = string.gsub(integer, "^(-?%d+)(%d%d%d)", '%1' .. ns.rs.strings.separator .. '%2')
		if leftover == 0 then break end
	end
	if trim == false then for i = 1, (decimals or 0) - #decimalText do decimalText = decimalText .. "0" end end

	return sign .. integer .. (((decimals or 0) > 0 and (fraction ~= 0 or trim == false)) and ns.rs.strings.decimal .. decimalText or "")
end

---@param object any Object to convert to a formatted text
---@return string s Formatted output string
---@return "Frame"|"FrameScriptObject"|"table"|"boolean"|"number"|"string"|"any" t Recognized object type
function ns.us.ToString(object)
	local t = type(object)

	if t == "table" then
		local s = ns.us.IsFrame(object)

		if s then
			if type(s) == "string" then return WrapTextInColorCode(s, "FFDD99FF"), "Frame" end --Frame reference (purple)
			return WrapTextInColorCode(tostring(object), "FFFF4444"), "FrameScriptObject" --Unidentifiable UI object reference (red)
		end

		return WrapTextInColorCode(tostring(object), "FFFF9999"), t --table reference (pink)
	end
	if t == "boolean" then return WrapTextInColorCode(tostring(object), object and "FFAAAAFF" or "FFFFAA66"), t end --boolean value (true: blue, false: orange)
	if t == "number" then return WrapTextInColorCode(tostring(object), "FFDDDD55"), t end --number value (yellow)
	if t == "string" then return WrapTextInColorCode("\"" .. object .. "\"", "FF55DD55"), t end --string value (green)

	return WrapTextInColorCode(tostring(object), "FFFF4444"), "any" --Miscellaneous value (red)
end

---Format a table as a string with colored values appropriate to their type
---***
---@param table table Reference to the table to convert
---@param compact? boolean Whether spaces and indentations should be trimmed or not | ***Default:*** false
---@param space string Character(s) to add for additional spacing between non-atomic elements
---@param newLine string Character(s) to add for breaking lines (or not)
---@param indentation string Chain of characters to use as the indentation for subtables
---@return string
local function formatTableString(table, compact, space, newLine, indentation)
	if ns.us.IsFrame(table) then return (ns.us.ToString(table)) end

	local tableString = "{"

	for key, value in ns.us.SortedPairs(table) do
		--Key
		tableString = tableString .. newLine .. (compact and "" or indentation) .. (
			type(key) == "string" and (
				key:match("^%a%w*$") and WrapTextInColorCode(key, "FFFFFFFF") or "[" .. WrapTextInColorCode("\"" .. key .. "\"", "FFFFFFFF") .. "]"
			) or "[" .. WrapTextInColorCode(tostring(key), "FFFFFFFF") .. "]"
		) .. space .. "="

		--Value
		local valueString, valueType = ns.us.ToString(value)
		if valueType == "table" then valueString = formatTableString(value, compact, space, newLine, indentation .. (compact and "" or "    ")) end

		tableString = tableString .. space .. valueString

		--Add separator
		tableString = tableString .. ","
	end

	return WrapTextInColorCode((tableString:sub(1, -2)) .. newLine .. indentation:sub(1, -5) .. "}", "FF999999") --base color (grey)
end

---@param table table Reference to the table to convert
---@param compact? boolean Whether spaces and indentations should be trimmed or not | ***Default:*** false
function ns.us.TableToString(table, compact)
	if type(table) ~= "table" then return (ns.us.ToString(table)) end

	return formatTableString(table, compact, compact and "" or " ", compact and "" or "\n", "    ")
end

--[ Table Management ]

local protectionProxies = {}

function ns.expose(proxy)
	if getmetatable(proxy) == "protected" then for key, value in pairs(protectionProxies) do if value == proxy then return key end end end

	return proxy
end

---@param t any Reference to the table to create the proxy for
---@return any # Reference to the new proxy table or **t** itself
function ns.us.Protect(t)
	local metatable = getmetatable(t)

	if type(t) ~= "table" or metatable == "protected" or metatable == "public" or ns.us.IsFrame(t) then return t end

	local proxy = setmetatable({}, {
		__index = function(_, k)
			local v = t[k]

			if type(v) ~= "table" or getmetatable(v) == true or ns.us.IsFrame(v) then return v end

			local subproxy = protectionProxies[v]

			if not subproxy then
				subproxy = ns.us.Protect(v)

				protectionProxies[v] = subproxy
			end

			return subproxy
		end,
		__newindex = function(_, k, v) ns.ds.Log("Prevented setting " .. tostring(k) .. " to " .. tostring(v) .. " in a protected table.", t) end,
		__metatable = "protected",
	})

	protectionProxies[t] = proxy

	return proxy
end

---@param t table Reference to the table to get the ID of
---@return string # Return empty string of t is not a table | ***Default:*** ""
function ns.us.GetID(t)
	if type(t) ~= "table" then return "" else return tostring(t):sub(8) end
end

--| Search

---@param array any[] Array to search
---@param value any The value to find
function ns.us.FindIndex(array, value)
	array = ns.expose(array)

	if type(array) ~= "table" then return nil end

	for i = 1, #array do if array[i] == value then return i end end
	for i = 1, #array do if ns.us.FindKey(array[i], value) ~= nil then return i end end

	return nil
end

---@param t table Reference to the table to find a value at a certain key in
---@param value any Value to look for in **tableToCheck** (including all subtables, recursively)
---@return any|nil match The first match of the key of the found **valueToFind**, or nil if no match was found
function ns.us.FindKey(t, value)
	t = ns.expose(t)

	if type(t) ~= "table" then return nil end

	for k, v in pairs(t) do
		if v == value then return k end

		local match = ns.us.FindKey(v, value)

		if match ~= nil then return match end
	end

	return nil
end

---@param t table Reference to the table to find a value at a certain key in
---@param key any Key to look for in **tableToCheck** (including all subtables, recursively)
---@return any|nil match The first match of the value found at **keyToFind**, or nil if no match was found
function ns.us.FindValue(t, key)
	t = ns.expose(t)

	if type(t) ~= "table" then return nil end

	for k, v in pairs(t) do
		if k == key then return v end

		local match = ns.us.FindValue(v, key)

		if match ~= nil then return match end
	end

	return nil
end

--| Data management

---@param object any Reference to the object to create a copy of
---@return any copy Returns **object** itself if it's a frame or not a table
function ns.us.Clone(object)
	object = ns.expose(object)

	if type(object) ~= "table" or ns.us.IsFrame(object) then return object end

	local copy = {}

	for k, v in pairs(object) do copy[k] = ns.us.Clone(v) end

	return copy
end

---@param target table Table to add the values to
---@param source table Table to copy all values from
---@return any target Reference to **target** (it was already overwritten during the operation, no need for setting it again)
function ns.us.Merge(target, source)
	if type(target) ~= "table" and type(source) ~= "table" then return target end

	for _, v in pairs(source) do target.insert(target, ns.us.Clone(v)) end

	return target
end

---@param target table Reference to the table to copy the values to
---@param source table Reference to the table to copy the values from
---@return any target Reference to **target** (the values were already overwritten during the operation, no need to set it again)
function ns.us.CopyValues(target, source)
	if type(source) ~= "table" or type(target) ~= "table" or ns.us.IsFrame(source) or ns.us.IsFrame(target) then return target end
	if next(target) == nil then return target end

	for k, v in pairs(target) do
		if source[k] == nil then return target end

		if type(v) == "table" then ns.us.CopyValues(v, source[k]) else target[k] = source[k] end
	end

	return target
end

---@param target table Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already "table")
---@param source table Reference to the table to sample data from
---@return any target Reference to **target** (it was already updated during the operation, no need for setting it again)
function ns.us.Fill(target, source)
	if not (type(source) == "table" and next(source) ~= nil) then return target end

	if ns.us.IsFrame(source) then target = source else
		for k, v in pairs(source) do
			target = type(target) == "table" and target or {}

			--Add the missing item if the value is not empty or nil
			if target[k] == nil and v ~= nil and v ~= "" then target[k] = ns.us.Clone(v) else ns.us.Fill(target[k], source[k]) end
		end
	end

	return target
end

---@param target table Reference to the table to copy the values to
---@param source table Reference to the table to sample data from
---@return any target Reference to **target** (it was already overwritten during the operation, no need for setting it again)
function ns.us.Pull(target, source)
	if type(target) ~= "table" then return source end

	return ns.us.CopyValues(ns.us.Fill(target, source), source) --REPLACE with combined code
end

---@param target table Reference to the table to verify
---@param source table Reference to the table to sample
---@return any target Reference to **target** (it was already mutated during the operation)
function ns.us.VerifyData(target, source)
	if type(target) ~= "table" or type(source) ~= "table" then return target end

	for k, v in pairs(target) do
		if source[k] == nil then target[k] = nil
		elseif type(v) ~= type(source[k]) then target[k] = source[k]
		else ns.us.VerifyData(v, source[k]) end
	end

	return target
end

---@param target table Reference to the table to prune
---@param validate? fun(k: number|string, v: any): boolean Helper function for validating values, returning true if the value is to be accepted as valid
---@return any table Reference to **table** (it was already overwritten during the operation, no need for setting it again)
function ns.us.Prune(target, validate)
	if type(target) ~= "table" or ns.us.IsFrame(target) then return target end

	for k, v in pairs(target) do
		if type(v) == "table" then
			if next(v) == nil then target[k] = nil else ns.us.Prune(v, validate) end --Remove the subtable if it's empty
		else
			local remove = v == nil or v == "" --The value is empty or doesn't exist

			if type(validate) == "function" and not remove then remove = not validate(k, v) end --Check if the value is invalid
			if remove then target[k] = nil end --Remove the value
		end
	end

	return target
end

---Remove unused or outdated data from a table while comparing it to another table and assemble the list of removed keys
---***
---@param target table|nil
---@param sample table|nil
---@param recoveredData? table
---@param recoveredKey? string
---***
---@return table recoveredData Table containing the removed key, value pairs (nested keys chained together with period characters in-between)
local function purge(target, sample, recoveredData, recoveredKey)
	recoveredData = recoveredData or {}
	local targetType, sampleType = type(target), type(sample)

	--| Utilities

	---Go deeper to fully map out recoverable keys
	---@param t table
	---@param rKey string
	local function goDeeper(t, rKey)
		if type(t) ~= "table" then return end

		for k, v in pairs(t) do
			if type(v) == "table" then goDeeper(v, rKey .. (type(k) == "number" and ("[" .. k .. "]") or ("." .. k)))
			else recoveredData[(rKey .. (type(k) == "number" and ("[" .. k .. "]") or ("." .. k))):sub(2)] = v end
		end
	end

	--| Compare types

	if targetType ~= sampleType then
		local rKey = (recoveredKey or "") .. (type(recoveredKey) == "number" and ("[" .. recoveredKey .. "]") or ("." .. recoveredKey))

		--Save the old item to the recovered data container
		if targetType ~= "table" then recoveredData[rKey:sub(2)] = target else goDeeper(target, rKey) end

		--Remove the unneeded item
		target = nil

		return recoveredData
	end

	--| Check subtables

	if targetType ~= "table" or sampleType ~= "table" or ns.us.IsFrame(target) or ns.us.IsFrame(sample) then return recoveredData end
	if next(target) == nil then return recoveredData end

	for key, value in pairs(target) do
		local rKey = (recoveredKey or "") .. (type(key) == "number" and ("[" .. key .. "]") or ("." .. key))

		if sample[key] == nil then
			--Save the old item to the recovered data container
			if type(value) ~= "table" then recoveredData[rKey:sub(2)] = value else goDeeper(value, rKey) end

			--Remove the unneeded item
			target[key] = nil
		else recoveredData = purge(target[key], sample[key], recoveredData, rKey) end
	end

	return recoveredData
end

---@param target table Reference to the table to remove unused key, value pairs from
---@param sample table Reference to the table to sample data from
---@param recoveryMap? table<string, recoveryData>|fun(tableToCheck: table, recoveredData: recoveredData): recoveryMap: table<string, recoveryData>|nil Static map or function returning a dynamically creatable map for removed but recoverable data
---@param onRecovery? fun(tableToCheck: table) Function called after the data has been has been recovered via the **recoveryMap**
---@return any target Reference to **target** (it was already overwritten during the operation, no need for setting it again)
function ns.us.Filter(target, sample, recoveryMap, onRecovery)
	if type(target) ~= "table" or ns.us.IsFrame(target) then return target end

	local recoveredData = purge(target, sample)

	if next(recoveredData) then
		if type(recoveryMap) == "function" then recoveryMap = recoveryMap(target, recoveredData) end

		if type(recoveryMap) == "table" then for key, value in pairs(recoveredData) do
			if recoveryMap[key] then for i = 1, #recoveryMap[key].saveTo do
				recoveryMap[key].saveTo[i][recoveryMap[key].saveKey] = recoveryMap[key].convertSave and recoveryMap[key].convertSave(value) or value
			end end
		end end

		if type(onRecovery) == "function" then onRecovery(target) end
	end

	return target
end


--[[ DEBUGGING TOOLS ]]

---@type widgetToolsDebugging
ns.ds = {}

---@param message any Included in the log entry as a string
---@param trace? any Custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** "(source not traced)"
function ns.ds.Log(message, trace)
	if not WidgetToolsDB.debugging then return end

	trace = (trace == nil and "(source not traced)" or tostring(trace))
	message = tostring(message)

	table.insert(ns.logHistory, trace .. date("\t%Y.%m.%d. %H:%M:%S\t", time()) .. message)

	print("|T" .. ns.rs.textures.logo .. ":11|t |cFFFFAA00Debug Log:|r |cFFFFFF00" .. trace .. date(" • %H:%M:%S • ", time()) .. "|r" .. message)
end

---Convert and format an input object to string to be dumped to the in-game chat
---***
---@param object any Object to dump out
---@param outputTable table Table to put the formatted output lines in
---@param name? any Value to print out as name string | ***Default:*** **object** as string
---@param blockrule? fun(key: integer|string): boolean Manually filter further exploring subtables under specific keys, skipping it if the value returned is true
---@param depth? integer How many levels of subtables to print out (root level: 0) | ***Default:*** *full depth*
---@param digTables? boolean ***Default:*** true
---@param digFrames? boolean ***Default:*** false
---@param currentKey? string
---@param currentLevel? integer
local function getDumpOutput(object, outputTable, name, blockrule, depth, digTables, digFrames, currentKey, currentLevel)
	--Check whether the current key is to be skipped
	local skip = false
	if currentKey and type(blockrule) == "function" then skip = blockrule(currentKey) end

	--Calculate indentation based on the current depth level
	currentLevel = currentLevel or 0
	local indentation = ""
	for i = 1, currentLevel do indentation = indentation .. "    " end

	--Format the name and key
	currentKey = currentKey and indentation .. "|cFFACD1EC" .. currentKey .. "|r" or nil
	name = name and "|cFF69A6F8" .. tostring(name) .. "|r" or ns.us.ToString(object)

	--Add the line to the output
	if type(object) == "table" and (digFrames or not ns.us.IsFrame(object)) then
		local s = (currentKey and (currentKey .. " (") or "Dump (") .. name .. "):"

		--Stop at the max depth or if the key is skipped
		if skip or currentLevel >= (depth or currentLevel + 1) then
			table.insert(outputTable, s .. " {…}")

			return
		end

		table.insert(outputTable, s .. (digTables == false and " {…}" or ""))

		--Convert & format the subtable
		for k, v in ns.us.SortedPairs(object) do getDumpOutput(v, outputTable, nil, blockrule, depth, digTables, digFrames, k, currentLevel + 1) end
	elseif digTables == false then return else
		local line = (currentKey and currentKey .. " = " or "Dump " .. name .. " value: ") .. (skip and "…" or ns.us.ToString(object))

		table.insert(outputTable, line)

		return
	end
end

---@param object any Object to dump out
---@param name? string A name to print out | ***Default:*** *the dumped object will not be named* | ***Default:*** true
---@param depth? integer How many levels of subtables to print out (root level: 0) | ***Default:*** *full depth*
---@param blockrule? fun(key: integer|string): boolean Manually filter further exploring subtables under specific keys, skipping it if the value returned is true<ul><li>***Note:*** *The code examples below are only visible in the full function annotations, not the parameter annotations.*</li></ul>
---@param digTables? boolean If true, explore and dump the non-subtable values of table objects | ***Default:*** true
---@param digFrames? boolean If true, explore and dump the insides of objects recognized as frames | ***Default:*** false
---@param linesPerMessage? integer Print the specified number of output lines in a single chat message to be able to display more message history and allow faster scrolling | ***Default:*** 2<ul><li>***Note:*** Set to 0 to print all lines in a single message.</li></ul>
function ns.ds.Dump(object, name, blockrule, depth, digTables, digFrames, linesPerMessage)
	object = ns.expose(object)
	local output = {}

	getDumpOutput(object, output, name, blockrule, depth, digTables, digFrames)

	--| Print the output

	local lineCount = 0
	local message = ""

	for i = 1, #output do
		lineCount = lineCount + 1
		message = message .. ((lineCount > 1 and i > 1) and "\n" .. output[i]:sub(5) or output[i])

		if lineCount == (linesPerMessage or 2) or i == #output then
			print(message)

			lineCount = 0
			message = ""
		end
	end
end


--[[ TOOLBOX REGISTRY ]]

---Read-only list of toolboxes registered under unique version keys with the list of addons registered for using each
---@type table<string, widgetToolboxEntry>
ns.protectedToolboxRegistry = {}

--| Registration

---@type widgetToolsToolboxes
ns.ts = { initialization = {} }

---@param addon string Addon namespace (the name of the addon's folder, not its display title) to register for WidgetTools usage
---@param version string|number Version key the **toolbox** should be registered under (always converted to string)
---@param callback? fun(toolbox: widgetToolbox|table?) Function to be called after a new toolbox initialization has finished when **addon** loaded, returning a read-only reference to the new toolbox table
---@param toolbox? table Reference to an existing toolbox table to register
---@return widgetToolbox|table? toolbox Read-only reference to the registered toolbox table | ***Default:*** nil
function ns.ts.Register(addon, version, callback, toolbox)
	if type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) or not version then return end

	--| Existing entry

	--Register addon for use
	if ns.protectedToolboxRegistry[version] then
		table.insert(ns.protectedToolboxRegistry[version].addons, addon)

		ns.ds.Log("Registered " .. addon .. " for using Toolbox version " .. version .. ".", "Widget Toolbox registration")

		return ns.protectedToolboxRegistry[version].toolbox
	end

	--| Registering existing toolbox

	--Protected and add the toolbox to registry and register addon for use
	if type(toolbox) == "table" then
		ns.protectedToolboxRegistry[version] = { toolbox = ns.us.Protect(toolbox), addons = { addon } }

		ns.ds.Log("Added Toolbox version " .. version .. " to the registry and registered " .. addon .. " for use.", "Widget Toolbox registration")

		return ns.protectedToolboxRegistry[version].toolbox
	end

	--| Initializing new toolbox

	version = tostring(version)

	ns.ts.initialization[version] = setmetatable({}, { __metatable = "public" })

	ns.ds.Log("New toolbox version " .. version .. " initialization started by " .. addon .. ".", "Widget Toolbox registration")

	ns.eventFrame:RegisterEvent("ADDON_LOADED")
	ns.eventFrame:HookScript("OnEvent", function(_, e, a)
		if e ~= "ADDON_LOADED" or a ~= addon then return end

		ns.eventFrame:UnregisterEvent("ADDON_LOADED")

		ns.protectedToolboxRegistry[version] = { toolbox = ns.us.Protect(ns.us.Clone(ns.ts.initialization[version])), addons = { addon } }
		ns.ts.initialization[version] = nil

		ns.ds.Log("New toolbox version " .. version .. " initialization finished for " .. addon .. ".", addon .. " loaded")


		if type(callback) == "function" then callback(ns.protectedToolboxRegistry[version].toolbox) end
	end)
end


--[[ GLOBAL TOOLS ]]

local widgetToolsWrapper = { resources = ns.rs, utilities = ns.us, debugging = ns.ds, toolboxes = ns.ts }

---@type widgetTools
WidgetTools = ns.us.Protect(widgetToolsWrapper)


--[[ EVENT FRAME ]]

ns.eventFrame = CreateFrame("Frame")