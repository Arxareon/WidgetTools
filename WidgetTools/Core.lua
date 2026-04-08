--[[ REFERENCES ]]

--[ Namespace ]

---@class addonNamespace
local ns = select(2, ...)

--[ Shortcuts ]

local crc = WrapTextInColorCode


--[[ UTILITIES ]]

---@type widgetToolsUtilities
ns.us = {}

--[ General ]

function ns.us.SortedPairs(t)
	local s = {}

	for k in pairs(t) do table.insert(s, k) end
	table.sort(s, function(x, y) if type(x) == "number" and type(y) == "number" then return x < y else return tostring(x) < tostring(y) end end)

	local i = 0
	local iterator = function()
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

function ns.us.Round(number, decimals)
	if type(number) ~= "number" then number = 0 end
	if type(decimals) ~= "number" then decimals = 0 end

	local multiplier = 10 ^ (decimals or 0)

	return math.floor(number * multiplier + 0.5) / multiplier
end

--[ Validation ]

function ns.us.IsFrame(t)
	if type(t) ~= "table" then return false end

	return t.GetObjectType and t.IsObjectType and (t.GetName and t:GetName() or t.GetParent and t:GetParent() and t.GetDebugName and t:GetDebugName() or true) or false
end

function ns.us.ToFrame(s)
	local frame = nil

	--Find the global reference
	if type(s) == "string" then for name in s:gmatch("[^.]+") do frame = frame and frame[name] or _G[name] end end

	return ns.us.IsFrame(frame) and frame or nil
end

--[ Formatting ]

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

function ns.us.ToString(object)
	local t = type(object)

	if t == "table" then
		local s = ns.us.IsFrame(object)

		if s then
			if type(s) == "string" then return crc(s, "FFDD99FF"), "Frame" end --Frame reference (purple)
			return crc(tostring(object), "FFFF4444"), "FrameScriptObject" --Unidentifiable UI object reference (red)
		end

		return crc(tostring(object), "FFFF9999"), t --table reference (pink)
	end
	if t == "boolean" then return crc(tostring(object), object and "FFAAAAFF" or "FFFFAA66"), t end --boolean value (true: blue, false: orange)
	if t == "number" then return crc(tostring(object), "FFDDDD55"), t end --number value (yellow)
	if t == "string" then return crc("\"" .. object .. "\"", "FF55DD55"), t end --string value (green)

	return crc(tostring(object), "FFFF4444"), "any" --Miscellaneous value (red)
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
				key:match("^%a%w*$") and crc(key, "FFFFFFFF") or "[" .. crc("\"" .. key .. "\"", "FFFFFFFF") .. "]"
			) or "[" .. crc(tostring(key), "FFFFFFFF") .. "]"
		) .. space .. "="

		--Value
		local valueString, valueType = ns.us.ToString(value)
		if valueType == "table" then valueString = formatTableString(value, compact, space, newLine, indentation .. (compact and "" or "    ")) end

		tableString = tableString .. space .. valueString

		--Add separator
		tableString = tableString .. ","
	end

	return crc((tableString:sub(1, -2)) .. newLine .. indentation:sub(1, -5) .. "}", "FF999999") --base color (grey)
end

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

local function infect(t, p) for k, v in pairs(t) do if type(v) == "table" then infect(v, p[k]) else return end end end

function ns.us.Protect(t)
	local metatable = getmetatable(t)

	if type(t) ~= "table" or metatable == "protected" or metatable == "public" or ns.us.IsFrame(t) then return t end

	local proxy = protectionProxies[t]

	if not proxy then
		proxy = setmetatable({}, {
			__index = function(_, k)
				local v = t[k]

				if type(v) ~= "table" or getmetatable(v) == "public" or ns.us.IsFrame(v) then return v end

				local subproxy = protectionProxies[v]

				if not subproxy then
					subproxy = ns.us.Protect(v)

					protectionProxies[v] = subproxy
				end

				return subproxy
			end,
			__newindex = function(_, k, v)
				ns.ds.Log("Prevented setting a value in the protected " .. tostring(t) .. " at key: [ " .. tostring(k) .. " ] to ( " .. tostring(v) .. " ).", "Read-only protection")
			end,
			__metatable = "protected",
		})

		protectionProxies[t] = proxy

		--Trigger the protection on subtables recursively by indexing them
		infect(t, proxy)
	end

	return proxy
end

--| Search

function ns.us.FindIndex(array, value)
	array = ns.expose(array)

	if type(array) ~= "table" then return nil end

	for i = 1, #array do if array[i] == value then return i end end
	for i = 1, #array do if ns.us.FindKey(array[i], value) ~= nil then return i end end

	return nil
end

function ns.us.FindKey(t, value)
	t = ns.expose(t)

	if type(t) ~= "table" then return nil end

	for k, v in pairs(t) do
		if v == value then return protectionProxies[k] or k end

		local match = ns.us.FindKey(v, value)

		if match ~= nil then return protectionProxies[match] or match end
	end

	return nil
end

function ns.us.FindValue(t, key)
	t = ns.expose(t)

	if type(t) ~= "table" then return nil end

	for k, v in pairs(t) do
		if k == key then return protectionProxies[v] or v end

		local match = ns.us.FindValue(v, key)

		if match ~= nil then return protectionProxies[match] or match end
	end

	return nil
end

--| Sort

function ns.us.Reorder(t, directives)
	if type(t) ~= "table" or #t < 2 or type(directives) ~= "table" then return t end

	local d = {}

	for i = #t, 1, -1 do if directives[t[i]] then
		local p = 1

		for j = 1, #d do if directives[d[j]] < directives[t[i]] then p = p + 1 else break end end

		table.insert(d, p, t[i])
		table.remove(t, i)
	end end

	for i = 1, #d do table.insert(t, Clamp(directives[d[i]], 1, #t + 1), d[i]) end

	return  t
end

--| Data management

function ns.us.Clone(object)
	if type(object) ~= "table" or ns.us.IsFrame(object) then return object end

	local copy = {}

	for k, v in pairs(ns.expose(object)) do copy[k] = ns.us.Clone(v) end

	return copy
end

function ns.us.Merge(target, source)
	if type(target) ~= "table" or type(source) ~= "table" then return target end

	for _, v in pairs(source) do table.insert(target, ns.us.Clone(v)) end

	return target
end

---Deep traverse two tables in parallel and copy values at matching keys from one to the other
---@param target table
---@param source table
---@return table target
local function copy(target, source)
	for k, v in pairs(target) do
		local sv = source[k]

		if sv ~= nil then if type(v) ~= "table" or ns.us.IsFrame(v) or type(sv) ~= "table" or ns.us.IsFrame(sv) then target[k] = sv else copy(v, sv) end end
	end

	return target
end

function ns.us.CopyValues(target, source)
	return type(target) ~= "table" or ns.us.IsFrame(target) or type(source) ~= "table" or ns.us.IsFrame(source) and target or copy(target, source)
end

function ns.us.Fill(target, source)
	if type(source) ~= "table" or next(source) == nil or ns.us.IsFrame(source) then return target end

	target = type(target) == "table" and target or {}

	for k, v in pairs(source) do
		local tv = target[k]

		if tv == nil then if v ~= nil and v ~= "" then target[k] = ns.us.Clone(v) end
		elseif type(tv) == "table" and not ns.us.IsFrame(tv) and type(v) == "table" then ns.us.Fill(tv, v) end
	end

	return target
end

function ns.us.Pull(target, source)
	if type(target) ~= "table" or ns.us.IsFrame(target) or type(source) ~= "table" or ns.us.IsFrame(source) then return source end

	for k, v in pairs(source) do
		local tv = target[k]

		if tv == nil then if v ~= nil and v ~= "" then target[k] = ns.us.Clone(v) end
		elseif type(tv) == "table" and type(v) == "table" then ns.us.Pull(tv, v) else target[k] = ns.us.Clone(v) end
	end

	return target
end

function ns.us.Prune(target, validate)
	if type(target) ~= "table" or ns.us.IsFrame(target) then return target end

	validate = type(validate) == "function" and validate or nil

	for k, v in pairs(target) do
		if type(v) == "table" then
			if next(v) == nil then target[k] = nil else ns.us.Prune(v, validate) end
		else
			local remove = v == nil or v == ""

			if validate and not remove then remove = not validate(k, v) end
			if remove then target[k] = nil end
		end
	end

	return target
end

---Go deeper to fully map out recoverable keys
---@param t table
---@param rKey string
---@param recoveredData table
local function purgeDeeper(t, rKey, recoveredData)
	if type(t) ~= "table" then return end

	for k, v in pairs(t) do
		if type(v) == "table" then purgeDeeper(v, rKey .. (type(k) == "number" and ("[" .. k .. "]") or ("." .. k)), recoveredData)
		else recoveredData[(rKey .. (type(k) == "number" and ("[" .. k .. "]") or ("." .. k))):sub(2)] = v end
	end
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

	--| Compare types

	if targetType ~= sampleType then
		local rKey = (recoveredKey or "") .. (type(recoveredKey) == "number" and ("[" .. recoveredKey .. "]") or ("." .. recoveredKey))

		--Save the old item to the recovered data container
		if targetType ~= "table" then recoveredData[rKey:sub(2)] = target else purgeDeeper(target, rKey, recoveredData) end

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
			if type(value) ~= "table" then recoveredData[rKey:sub(2)] = value else purgeDeeper(value, rKey, recoveredData) end

			--Remove the unneeded item
			target[key] = nil
		else recoveredData = purge(target[key], sample[key], recoveredData, rKey) end
	end

	return recoveredData
end

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

function ns.us.VerifyData(target, source)
	if type(target) ~= "table" or type(source) ~= "table" then return target end

	for k, v in pairs(source) do
		local tv = target[k]

		if type(v) ~= type(tv) then target[k] = ns.us.Clone(v) elseif type(tv) == "table" and type(v) == "table" then ns.us.VerifyData(tv, v) end
	end

	for k in pairs(target) do if source[k] == nil then target[k] = nil end end

	return target
end


--[[ DEBUGGING TOOLS ]]

---@type widgetToolsDebugging
ns.ds = {}

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
	name = name and "|cFF69A6F8" .. tostring(name) .. "|r" or ns.us.ToString(protectionProxies[object] or object)

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
		local line = (currentKey and currentKey .. " = " or "Dump " .. name .. " value: ") .. (skip and "…" or ns.us.ToString(protectionProxies[object] or object))

		table.insert(outputTable, line)

		return
	end
end

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