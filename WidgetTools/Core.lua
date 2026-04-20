--| Namespace

---@class addonNamespace
local ns = select(2, ...)

--| References

local cr = WrapTextInColor
local crc = WrapTextInColorCode

--| Locals

local eventFrame = CreateFrame("Frame")

---@type widgetToolsDebugging
local ds = { history = {} --[[ --ADD an option to save logs across sessions ]] }

---@type widgetToolsToolboxes
local ts = { initialization = {} }


--[[ UTILITIES ]]

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

---@type widgetToolsUtilities
local us = { isKeyDown = setmetatable({}, {
	__index = function (_, k) return modifierKeyDownCheckers[k] or IsModifierKeyDown end,
	__newindex = function() end,
	__metatable = "protected",
}), }

--[ General ]

function us.SortedPairs(t)
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

--[ Math ]

function us.Round(number, decimals)
	if type(number) ~= "number" then number = 0 end
	if type(decimals) ~= "number" then decimals = 0 end

	local multiplier = 10 ^ (decimals or 0)

	return math.floor(number * multiplier + 0.5) / multiplier
end

--[ Validation ]

function us.IsFrame(t)
	if type(t) ~= "table" then return false end

	return t.GetObjectType and t.IsObjectType and (t.GetName and t:GetName() or t.GetParent and t:GetParent() and t.GetDebugName and t:GetDebugName() or true) or false
end

function us.ToFrame(s)
	local frame = nil

	--Find the global reference
	if type(s) == "string" then for name in s:gmatch("[^.]+") do frame = frame and frame[name] or _G[name] end end

	return us.IsFrame(frame) and frame or nil
end

--[ Formatting ]

function us.Thousands(value, decimals, round, trim)
	if type(value) ~= "number" then return "" end

	value = round == false and value or us.Round(value, decimals)
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

function us.ToString(object)
	local t = type(object)

	if t == "table" then
		local s = us.IsFrame(object)

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
	if us.IsFrame(table) then return (us.ToString(table)) end

	local tableString = "{"

	for key, value in us.SortedPairs(table) do
		--Key
		tableString = tableString .. newLine .. (compact and "" or indentation) .. (
			type(key) == "string" and (
				key:match("^%a%w*$") and crc(key, "FFFFFFFF") or "[" .. crc("\"" .. key .. "\"", "FFFFFFFF") .. "]"
			) or "[" .. crc(tostring(key), "FFFFFFFF") .. "]"
		) .. space .. "="

		--Value
		local valueString, valueType = us.ToString(value)
		if valueType == "table" then valueString = formatTableString(value, compact, space, newLine, indentation .. (compact and "" or "    ")) end

		tableString = tableString .. space .. valueString

		--Add separator
		tableString = tableString .. ","
	end

	return crc((tableString:sub(1, -2)) .. newLine .. indentation:sub(1, -5) .. "}", "FF999999") --base color (grey)
end

function us.TableToString(table, compact)
	if type(table) ~= "table" then return (us.ToString(table)) end

	return formatTableString(table, compact, compact and "" or " ", compact and "" or "\n", "    ")
end

local highlightColor, newColor, fixColor, changeColor, noteColor = "FFFFFFFF", "FF66EE66", "FFEE4444", "FF8888EE", "FFEEEE66"

function us.FormatChangelog(changelog, latest)
	local c = ""
	if type(changelog) ~= "table" then return c end

	for i = 1, #changelog do
		local firstLine = latest and 2 or 1
		local version = changelog[i]

		if type(version) ~= "table" then return c end

		for j = firstLine, #version do if type(version[j]) == "string" then
			c = c .. (j > firstLine and "\n\n" or "") .. version[j]:gsub(
				"#V_(.-)_#", (i > 1 and "\n\n\n" or "") .. "|c" .. highlightColor .. "• %1|r"
			):gsub(
				"#N_(.-)_#", "|c".. newColor .. "%1|r"
			):gsub(
				"#F_(.-)_#", "|c".. fixColor .. "%1|r"
			):gsub(
				"#C_(.-)_#", "|c".. changeColor .. "%1|r"
			):gsub(
				"#O_(.-)_#", "|c".. noteColor .. "%1|r"
			):gsub(
				"#H_(.-)_#", "|c".. highlightColor .. "%1|r"
			)
		end end

		if latest then break end
	end

	return c
end


--[ Table Management ]

local protectionProxies = {}

local function expose(proxy)
	if getmetatable(proxy) == "protected" then for key, value in pairs(protectionProxies) do if value == proxy then return key end end end

	return proxy
end

local function infect(t, p) for k, v in pairs(t) do if type(v) == "table" then infect(v, p[k]) else return end end end

function us.Protect(t)
	local metatable = getmetatable(t)

	if type(t) ~= "table" or metatable == "protected" or metatable == "public" or us.IsFrame(t) then return t end

	local proxy = protectionProxies[t]

	if not proxy then
		proxy = setmetatable({}, {
			__index = function(_, k)
				local v = t[k]

				if type(v) ~= "table" or getmetatable(v) == "public" or us.IsFrame(v) then return v end

				local subproxy = protectionProxies[v]

				if not subproxy then
					subproxy = us.Protect(v)

					protectionProxies[v] = subproxy
				end

				return subproxy
			end,
			__newindex = function(_, k, v)
				ds.Log(function() return
					"Prevented setting a value in the protected " .. tostring(t) .. " at key: [ " .. tostring(k) .. " ] to ( " .. tostring(v) .. " ).",
					"Read-only protection"
				end)
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

function us.FindIndex(array, value)
	array = expose(array)

	if type(array) ~= "table" then return nil end

	for i = 1, #array do if array[i] == value then return i end end
	for i = 1, #array do if us.FindKey(array[i], value) ~= nil then return i end end

	return nil
end

function us.FindKey(t, value)
	t = expose(t)

	if type(t) ~= "table" then return nil end

	for k, v in pairs(t) do
		if v == value then return protectionProxies[k] or k end

		local match = us.FindKey(v, value)

		if match ~= nil then return protectionProxies[match] or match end
	end

	return nil
end

function us.FindValue(t, key)
	t = expose(t)

	if type(t) ~= "table" then return nil end

	for k, v in pairs(t) do
		if k == key then return protectionProxies[v] or v end

		local match = us.FindValue(v, key)

		if match ~= nil then return protectionProxies[match] or match end
	end

	return nil
end

--| Sort

function us.Reorder(t, directives)
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

function us.Clone(object)
	if type(object) ~= "table" or us.IsFrame(object) then return object end

	local copy = {}

	for k, v in pairs(expose(object)) do copy[k] = us.Clone(v) end

	return copy
end

function us.Merge(target, source)
	if type(target) ~= "table" or type(source) ~= "table" then return target end

	for _, v in pairs(source) do table.insert(target, us.Clone(v)) end

	return target
end

---Deep traverse two tables in parallel and copy values at matching keys from one to the other
---@param target table
---@param source table
---@return table target
local function copy(target, source)
	for k, v in pairs(target) do
		local sv = source[k]

		if sv ~= nil then if type(v) ~= "table" or us.IsFrame(v) or type(sv) ~= "table" or us.IsFrame(sv) then target[k] = sv else copy(v, sv) end end
	end

	return target
end

function us.CopyValues(target, source)
	return type(target) ~= "table" or us.IsFrame(target) or type(source) ~= "table" or us.IsFrame(source) and target or copy(target, source)
end

function us.Fill(target, source)
	if type(source) ~= "table" or next(source) == nil or us.IsFrame(source) then return target end

	target = type(target) == "table" and target or {}

	for k, v in pairs(source) do
		local tv = target[k]

		if tv == nil then if v ~= nil and v ~= "" then target[k] = us.Clone(v) end
		elseif type(tv) == "table" and not us.IsFrame(tv) and type(v) == "table" then us.Fill(tv, v) end
	end

	return target
end

function us.Pull(target, source)
	if type(target) ~= "table" or us.IsFrame(target) or type(source) ~= "table" or us.IsFrame(source) then return source end

	for k, v in pairs(source) do
		local tv = target[k]

		if tv == nil then if v ~= nil and v ~= "" then target[k] = us.Clone(v) end
		elseif type(tv) == "table" and type(v) == "table" then us.Pull(tv, v) else target[k] = us.Clone(v) end
	end

	return target
end

function us.Prune(target, validate)
	if type(target) ~= "table" or us.IsFrame(target) then return target end

	validate = type(validate) == "function" and validate or nil

	for k, v in pairs(target) do
		if type(v) == "table" then
			if next(v) == nil then target[k] = nil else us.Prune(v, validate) end
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

	if targetType ~= "table" or sampleType ~= "table" or us.IsFrame(target) or us.IsFrame(sample) then return recoveredData end
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

function us.Filter(target, sample, recoveryMap, onRecovery)
	if type(target) ~= "table" or us.IsFrame(target) then return target end

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

function us.VerifyData(target, source)
	if type(target) ~= "table" or type(source) ~= "table" then return target end

	for k, v in pairs(source) do
		local tv = target[k]

		if type(v) ~= type(tv) then target[k] = us.Clone(v) elseif type(tv) == "table" and type(v) == "table" then us.VerifyData(tv, v) end
	end

	for k in pairs(target) do if source[k] == nil then target[k] = nil end end

	return target
end

--[ Events ]

local eventHandlers = {}

function us.SetListener(parent, event, handler, registration)
	if handler ~= nil and type(handler) ~= "function" then return end

	if not eventHandlers[parent] then eventHandlers[parent] = {} end

	eventHandlers[parent][event] = handler

	if registration ~= false and us.IsFrame(parent) and C_EventUtils.IsEventValid(event) then if handler then
		if parent:GetScript("OnEvent") ~= us.CallListener then parent:SetScript("OnEvent", us.CallListener) end

		parent:RegisterEvent(event)
	else parent:UnregisterEvent(event) end end
end

function us.CallListener(parent, event, ...)
	local f = eventHandlers[parent]

	if not f then return end

	local h = f[event]

	return h and h(parent, ...)
end


--[[ DATA ]]

---@type widgetToolsData
WidgetToolsDB = us.VerifyData(type(WidgetToolsDB) == "table" and WidgetToolsDB or {}, {
	lite = false,
	positioningAids = true,
	customFonts = { "CUSTOM", }, --REPLACE with custom font management
	debugging = false,
	frameAttributes = {
		enabled = false,
		width = 620,
	},
})

--| Snapshots

local loadedLite = WidgetToolsDB.lite
local loadedPositioningAids = WidgetToolsDB.positioningAids
local loadedDebugging = WidgetToolsDB.debugging


--[[ DEBUGGING TOOLS ]]

if WidgetToolsDB.debugging then
	function ds.LogRaw(message, trace)
		message = tostring(message)
		trace = (trace == nil and "(source not traced)" or tostring(trace))

		table.insert(ds.history, date("%Y.%m.%d. %H:%M:%S\t", time()) .. trace .. "\t" ..message)

		print("|T" .. ns.rs.textures.logo .. ":11|t |cFFFFAA00Debug Log:|r |cFFFFFF00" .. trace .. " • |r" .. message)
	end

	function ds.Log(passer) if type(passer) ~= "function" then return else ds.LogRaw(passer()) end end

	ds.LogRaw("Debug logging enabled.", "Widget Tools initialization")
else
	ds.LogRaw = function() end
	ds.Log = function() end
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
	name = name and "|cFF69A6F8" .. tostring(name) .. "|r" or us.ToString(protectionProxies[object] or object)

	--Add the line to the output
	if type(object) == "table" and (digFrames or not us.IsFrame(object)) then
		local s = (currentKey and (currentKey .. " (") or "Dump (") .. name .. "):"

		--Stop at the max depth or if the key is skipped
		if skip or currentLevel >= (depth or currentLevel + 1) then
			table.insert(outputTable, s .. " {…}")

			return
		end

		table.insert(outputTable, s .. (digTables == false and " {…}" or ""))

		--Convert & format the subtable
		for k, v in us.SortedPairs(object) do getDumpOutput(v, outputTable, nil, blockrule, depth, digTables, digFrames, k, currentLevel + 1) end
	elseif digTables == false then return else
		local line = (currentKey and currentKey .. " = " or "Dump " .. name .. " value: ") .. (skip and "…" or us.ToString(protectionProxies[object] or object))

		table.insert(outputTable, line)

		return
	end
end

function ds.Dump(object, name, blockrule, depth, digTables, digFrames, linesPerMessage)
	object = expose(object)
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

--| Resize Frame Attributes

if WidgetToolsDB.frameAttributes.enabled then us.SetListener(eventFrame, "FRAMESTACK_VISIBILITY_UPDATED", function()
	eventFrame:UnregisterEvent("FRAMESTACK_VISIBILITY_UPDATED")

	if _G["TableAttributeDisplay"] then
		TableAttributeDisplay:SetWidth(WidgetToolsDB.frameAttributes.width + 70)
		TableAttributeDisplay.LinesScrollFrame:SetWidth(WidgetToolsDB.frameAttributes.width)
	end
end) end


--[[ TOOLBOX REGISTRY ]]

---Read-only list of toolboxes registered under unique version keys with the list of addons registered for using each
---@type table<string, widgetToolboxEntry>
local protectedToolboxRegistry = {}

--| Registration

function ts.Register(addon, version, callback, toolboxAddon, toolbox)
	if type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) or not version then return end

	version = tostring(version)

	--[ Supply Toolbox ]

	--Register addon for use
	if protectedToolboxRegistry[version] then
		table.insert(protectedToolboxRegistry[version].addons, addon)

		ds.Log(function() return
			"Registered " .. cr(addon, LIGHTBLUE_FONT_COLOR) .. " for using Toolbox version " .. us.ToString(version) .. ".",
			"Widget Toolbox registration"
		end)

		return protectedToolboxRegistry[version].toolbox
	end

	--[ Register Toolbox ]

	--Protect and add the toolbox to the registry and register addon for use
	if type(toolbox) == "table" then
		protectedToolboxRegistry[version] = { toolbox = us.Protect(toolbox), addons = { addon } }

		ds.Log(function() return
			"Added Toolbox version " .. us.ToString(version) .. " to the registry and registered " .. cr(addon, LIGHTBLUE_FONT_COLOR) .. " for use.",
			"Widget Toolbox registration"
		end)

		return protectedToolboxRegistry[version].toolbox
	end

	--[ Initialize Toolbox ]

	--| Load the Toolbox addon

	if type(toolboxAddon) ~= "string" then toolboxAddon = "WidgetToolbox_" .. version end

	if not C_AddOns.DoesAddOnExist(toolboxAddon) then
		ds.Log(function() return "Toolbox initializer " .. cr(toolboxAddon, LIGHTBLUE_FONT_COLOR) .. " addon does not exist.", "Widget Toolbox registration" end)

		return false
	end

	--| Register callback

	us.SetListener(eventFrame, "ADDON_LOADED", function(_, a)
		if a ~= toolboxAddon then return end

		eventFrame:UnregisterEvent("ADDON_LOADED")

		protectedToolboxRegistry[version] = { toolbox = us.Protect(us.Clone(ts.initialization[version])), addons = { addon } }
		ts.initialization[version] = nil

		ds.Log(function() return
			"New Toolbox version " .. us.ToString(version) .. " initialization finished by " .. cr(toolboxAddon, LIGHTBLUE_FONT_COLOR) .. ".",
			toolboxAddon .. " ADDON_LOADED"
		end)

		if type(callback) == "function" then callback(protectedToolboxRegistry[version].toolbox) end
	end)

	--| Initialization

	ts.initialization[version] = setmetatable({}, { __metatable = "public" })

	ds.Log(function() return
		"New Toolbox version " .. us.ToString(version) .. " initialization started by " .. cr(addon, LIGHTBLUE_FONT_COLOR) .. ".",
		"Widget Toolbox registration"
	end)
	ds.Log(function() return "Loading " .. cr(toolboxAddon, LIGHTBLUE_FONT_COLOR) .. " addon.", "Widget Toolbox registration" end)

	C_AddOns.LoadAddOn(toolboxAddon)
end


--[[ GLOBAL TOOLS ]]

local widgetToolsWrapper = { resources = ns.rs, utilities = us, debugging = ds, toolboxes = ts }

---@type widgetTools
WidgetTools = us.Protect(widgetToolsWrapper)


--[[ INITIALIZATION ]]

us.SetListener(eventFrame, "PLAYER_LOGIN", function()
	eventFrame:UnregisterEvent("PLAYER_LOGIN")

	ds.LogRaw("Started loading UI.", "WidgetTools PLAYER_LOGIN")

	--[[ REFERENCES ]]

	--[ Shortcuts ]

	---@type toolbox
	local wt = ns[C_AddOns.GetAddOnMetadata(ns.rs.addon, "X-WidgetTools-AddToNamespace")]

	--[ Locals ]

	local chatCommands


	--[[ SETTINGS ]]

	--[ Main Page ]

	---@type settingsPage
	local mainPage = wt.CreateAboutPage(ns.rs.addon, {
		register = true,
		name = "About",
		changelog = ns.changelog
	})

	--[ Specifications Page ]

	---@type checkbox
	local liteToggle

	---@type checkbox
	local debugToggle

	---@type settingsPage
	local specificationsPage = wt.CreateSettingsPage(ns.rs.addon, {
		register = mainPage,
		name = "Specifications",
		title = ns.rs.strings.specifications.title,
		description = ns.rs.strings.specifications.description,
		dataManagement = {},
		arrangement = {},
		initialize = function(canvas, _, _, category, keys)
			wt.CreatePanel({
				parent = canvas,
				name = "General",
				title = ns.rs.strings.specifications.general.title,
				description = ns.rs.strings.specifications.general.description,
				arrange = {},
				arrangement = {},
				initialize = function(panel)
					local silentSave = false

					local enableLitePopup = wt.RegisterPopupDialog(ns.rs.addon .. "_ENABLE_LITE_MODE", {
						text = ns.rs.strings.lite.enable.warning:gsub("#ADDON", ns.rs.title),
						accept = ns.rs.strings.lite.enable.accept,
						onAccept = function()
							liteToggle.setState(true)
							liteToggle.saveData(nil, silentSave)

							chatCommands.print(ns.rs.strings.chat.lite.response:gsub("#STATE", VIDEO_OPTIONS_ENABLED:lower()))
						end,
					})
					local disableLitePopup = wt.RegisterPopupDialog(ns.rs.addon .. "_DISABLE_LITE_MODE", {
						text = ns.rs.strings.lite.disable.warning:gsub("#ADDON", ns.rs.title),
						accept = ns.rs.strings.lite.disable.accept,
						onAccept = function()
							liteToggle.setState(false)
							liteToggle.saveData(nil, silentSave)

							chatCommands.print(ns.rs.strings.chat.lite.response:gsub("#STATE", VIDEO_OPTIONS_DISABLED:lower()))
						end,
					})

					liteToggle = wt.CreateCheckbox({
						parent = panel,
						name = "LiteMode",
						title = ns.rs.strings.specifications.general.lite.label,
						tooltip = { lines = { { text = ns.rs.strings.specifications.general.lite.tooltip:gsub("#COMMAND", crc("/wt lite", "FFFFFFFF")), }, } },
						arrange = {},
						getData = function() return WidgetToolsDB.lite end,
						saveData = function(state) WidgetToolsDB.lite = state end,
						default = false,
						instantSave = false,
						listeners = {
							saved = { { handler = function()
								silentSave = false

								if loadedLite ~= WidgetToolsDB.lite then wt.CreateReloadNotice() end end,
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

					wt.CreateCheckbox({
						parent = panel,
						name = "PositioningAids",
						title = ns.rs.strings.specifications.general.positioningAids.label,
						tooltip = { lines = { { text = ns.rs.strings.specifications.general.positioningAids.tooltip, }, } },
						arrange = {},
						getData = function() return WidgetToolsDB.positioningAids end,
						saveData = function(state) WidgetToolsDB.positioningAids = state end,
						listeners = { saved = { { handler = function() if loadedPositioningAids ~= WidgetToolsDB.positioningAids then wt.CreateReloadNotice() end end, }, }, },
						instantSave = false,
						default = true,
						dataManagement = {
							category = category,
							key = keys[1],
						},
					})
				end,
			})

			wt.CreatePanel({
				parent = canvas,
				name = "DevTools",
				title = ns.rs.strings.specifications.dev.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel)
					debugToggle = wt.CreateCheckbox({
						parent = panel,
						name = "ToggleDebugging",
						title = ns.rs.strings.specifications.dev.debugging.enabled.label,
						tooltip = { lines = { { text = ns.rs.strings.specifications.dev.debugging.enabled.tooltip, }, } },
						arrange = {},
						getData = function() return WidgetToolsDB.debugging end,
						saveData = function(state) WidgetToolsDB.debugging = state end,
						listeners = {
							saved = { { handler = function() if loadedDebugging ~= WidgetToolsDB.debugging then wt.CreateReloadNotice() end end, }, },
							toggled = { { handler = function (self, state, user)
								if not user then return end

								chatCommands.print(ns.rs.strings.chat.debug.response:gsub("#STATE", (state and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower()))
							end, }, },
						},
						instantSave = false,
						default = false,
						dataManagement = {
							category = category,
							key = keys[1],
						},
					})

					local toggle = wt.CreateCheckbox({
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

									us.SetListener(eventFrame, "FRAMESTACK_VISIBILITY_UPDATED", function()
										eventFrame:UnregisterEvent("FRAMESTACK_VISIBILITY_UPDATED")

										if _G["TableAttributeDisplay"] then
											TableAttributeDisplay:SetWidth(WidgetToolsDB.frameAttributes.width + 70)
											TableAttributeDisplay.LinesScrollFrame:SetWidth(WidgetToolsDB.frameAttributes.width)
										end
									end)
								else
									if _G["TableAttributeDisplay"] then
										TableAttributeDisplay:SetWidth(500)
										TableAttributeDisplay.LinesScrollFrame:SetWidth(430)
									end

									us.SetListener(eventFrame, "FRAMESTACK_VISIBILITY_UPDATED", nil)
								end
							end, },
						},
					})

					wt.CreateSlider({
						parent = panel,
						name = "FrameAttributesWidth",
						title = ns.rs.strings.specifications.dev.frameAttributes.width.label,
						tooltip = { lines = { { text = ns.rs.strings.specifications.dev.frameAttributes.width.tooltip, }, } },
						arrange = { wrap = false, },
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

	--[ Addons Page ]

	---@type settingsPage
	local addonsPage = wt.CreateSettingsPage(ns.rs.addon, {
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

			for version, entry in WidgetTools.utilities.SortedPairs(protectedToolboxRegistry) do
				local title = entry.toolbox.name
				if type(title) ~= "string" then title = ns.rs.strings.addons.toolbox:gsub("#VERSION", ns.rs.strings.about.version:gsub("#VERSION", version)) end

				wt.CreatePanel({
					parent = canvas,
					name = "Toolbox" .. version:gsub("[^%w]", "_"),
					title = title,
					arrange = {},
					size = { h = 32 },
					arrangement = {
						margins = { l = 30, },
						gaps = 10,
					},
					initialize = function(toolboxPanel, width, _, name)

						--[ Toolbox Info ]

						if entry.toolbox.changelog then
							local changelogFrame

							wt.CreateButton({
								parent = toolboxPanel,
								name = "ChangelogButton",
								title = wt.strings.about.fullChangelog.open.label,
								tooltip = { lines = { { text = wt.strings.about.fullChangelog.open.tooltip, }, } },
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -6, y = 30 }
								},
								size = { w = 120, },
								action = function() if changelogFrame then changelogFrame:Show() else changelogFrame = wt.CreatePanel({
									parent = canvas:GetParent():GetParent(),
									name = name .. "Changelog",
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
									initialize = function(windowPanel)
										wt.CreateMultilineEditbox({
											parent = windowPanel,
											name = "FullChangelog",
											title = wt.strings.about.fullChangelog.label:gsub("#ADDON", title),
											label = false,
											tooltip = { lines = { { text = wt.strings.about.fullChangelog.tooltip, }, } },
											arrange = {},
											size = { w = windowPanel:GetWidth() - 32, h = windowPanel:GetHeight() - 58 },
											font = { normal = "GameFontDisable", },
											color = ns.rs.colors.grey[2],
											value = us.FormatChangelog(expose(entry.toolbox.changelog)),
											readOnly = true,
											scrollSpeed = 0.2,
										})

										wt.CreateButton({
											parent = windowPanel,
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
						end

						--[ List Reliant Addons ]

						for i = 1, #entry.addons do
							local addon = entry.addons[i]

							if C_AddOns.IsAddOnLoaded(addon) then
								local data = {
									title = C_AddOns.GetAddOnMetadata(addon, "Title"),
									version = C_AddOns.GetAddOnMetadata(addon, "Version"),
									day = C_AddOns.GetAddOnMetadata(addon, "X-Day"),
									month = C_AddOns.GetAddOnMetadata(addon, "X-Month"),
									year = C_AddOns.GetAddOnMetadata(addon, "X-Year"),
									category = C_AddOns.GetAddOnMetadata(addon, "Category"),
									notes = C_AddOns.GetAddOnMetadata(addon, "Notes"),
									author = C_AddOns.GetAddOnMetadata(addon, "Author"),
									license = C_AddOns.GetAddOnMetadata(addon, "X-License"),
									curse = C_AddOns.GetAddOnMetadata(addon, "X-CurseForge"),
									wago = C_AddOns.GetAddOnMetadata(addon, "X-Wago"),
									repo = C_AddOns.GetAddOnMetadata(addon, "X-Repository"),
									issues = C_AddOns.GetAddOnMetadata(addon, "X-Issues"),
									sponsors = C_AddOns.GetAddOnMetadata(addon, "X-Sponsors"),
									topSponsors = C_AddOns.GetAddOnMetadata(addon, "X-TopSponsors"),
									logo = C_AddOns.GetAddOnMetadata(addon, "IconTexture"),
								}

								wt.CreatePanel({
									parent = toolboxPanel,
									name = addon,
									label = false,
									arrange = {},
									size = { w = width - 42, h = 84 },
									background = { color = { r = 0.1, g = 0.1, b = 0.1, a = 0.6 } },
									arrangement = {
										margins = { l = 34, },
										resize = false,
									},
									initialize = function(addonPanel)
										wt.CreateTexture(addonPanel, {
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
												C_AddOns.EnableAddOn(addon)
												addonPanel:SetAlpha(1)
											else
												C_AddOns.DisableAddOn(addon)
												addonPanel:SetAlpha(0.5)
											end
										end

										local toggle = wt.CreateCheckbox({
											parent = addonPanel,
											name = "Toggle",
											title = cr(C_AddOns.GetAddOnMetadata(addon, "Title"), HIGHLIGHT_FONT_COLOR) .. " (" .. ns.rs.strings.about.toggle.label .. ")",
											tooltip = { lines = { { text = ns.rs.strings.about.toggle.tooltip, }, } },
											arrange = {},
											size = { w = 300, },
											font = { normal = "GameFontNormalMed1", },
											getData = function() return C_AddOns.GetAddOnEnableState(addon) > 0 end,
											saveData = function(state) toggleAddon(state) end,
											instantSave = false,
											listeners = { saved = { { handler = function(self) if not self.getState() then wt.CreateReloadNotice() end end, }, }, },
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

										if data.notes then wt.CreateText({
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
											local versionLabel = wt.CreateText({
												parent = addonPanel,
												name = "VersionTitle",
												position = position,
												width = 48,
												text = wt.strings.about.version,
												font = "GameFontHighlightSmall",
												justify = { h = "RIGHT", },
											})

											wt.CreateText({
												parent = addonPanel,
												name = "Version",
												position = {
													relativeTo = versionLabel,
													relativePoint = "TOPRIGHT",
													offset = { x = 5 }
												},
												width = 140,
												text = data.version .. (data.day and data.month and data.year and crc(" ( " .. wt.strings.about.date .. ": " .. cr(wt.strings.date:gsub(
													"#DAY", data.day
												):gsub(
													"#MONTH", data.month
												):gsub(
													"#YEAR", data.year
												), NORMAL_FONT_COLOR) .. ")", "FFFFFFFF") or ""),
												font = "GameFontNormalSmall",
												justify = { h = "LEFT", },
											})

											position.relativeTo = versionLabel
											position.relativePoint = "BOTTOMLEFT"
											position.offset.x = 0
											position.offset.y = -6
										end

										if data.category then
											local categoryLabel = wt.CreateText({
												parent = addonPanel,
												name = "Category",
												position = position,
												width = 48,
												text = CATEGORY,
												font = "GameFontHighlightSmall",
												justify = { h = "RIGHT", },
												wrap = false,
											})

											wt.CreateText({
												parent = addonPanel,
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
												parent = addonPanel,
												name = "AuthorTitle",
												position = position,
												width = 48,
												text = wt.strings.about.author,
												font = "GameFontHighlightSmall",
												justify = { h = "RIGHT", },
											})

											wt.CreateText({
												parent = addonPanel,
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
											})

											position.relativeTo = authorLabel
											position.relativePoint = "BOTTOMLEFT"
											position.offset.x = 0
											position.offset.y = -6
										end

										if data.license then
											local licenseLabel = wt.CreateText({
												parent = addonPanel,
												name = "LicenseTitle",
												position = position,
												width = 48,
												text = wt.strings.about.license,
												font = "GameFontHighlightSmall",
												justify = { h = "RIGHT", },
											})

											wt.CreateText({
												parent = addonPanel,
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
											})
										end
									end,
								})
							end
						end
					end,
				})
			end
		end,
	})


	--[[ CHAT CONTROL ]]

	---@type chatCommandManager
	chatCommands = wt.RegisterChatCommands(ns.rs.addon, { ns.rs.chat.keyword }, {
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
			{
				command = ns.rs.chat.commands.debug,
				description = ns.rs.strings.chat.debug.description,
				handler = function()
					debugToggle.setState(not WidgetToolsDB.debugging, true)

					wt.CreateReloadNotice()
				end,
			}
		},
		colors = {
			title = ns.rs.colors.gold[1],
			content = ns.rs.colors.gold[2],
			command = { r = 1, g = 1, b = 1, },
			description = ns.rs.colors.grey[1]
		},
	})


	--[[ ADDON COMPARTMENT ]]

	wt.SetUpAddonCompartment(ns.rs.addon, {
		onClick = function() if WidgetToolsDB.lite then liteToggle.setState(false, true) else wt.CreateContextMenu({
			initialize = function(menu)
				wt.CreateMenuTextline(menu, { text = ns.rs.title, })
				wt.CreateMenuButton(menu, {
					title = wt.strings.about.title,
					action = mainPage.open
				})
				wt.CreateMenuButton(menu, {
					title = ns.rs.strings.specifications.title,
					action = specificationsPage.open
				})
				wt.CreateMenuButton(menu, {
					title = ns.rs.strings.addons.title,
					action = addonsPage.open
				})
			end,
			rightClickMenu = false,
		}).open() end end,
	}, { lines = {
		{ text = ns.rs.strings.about.version:gsub("#VERSION", crc(C_AddOns.GetAddOnMetadata(ns.rs.addon, "Version") or "?", "FFFFFFFF")), },
		{ text = ns.rs.strings.about.date:gsub(
			"#DATE", crc(wt.strings.date:gsub(
				"#DAY", C_AddOns.GetAddOnMetadata(ns.rs.addon, "X-Day") or "?"
			):gsub(
				"#MONTH", C_AddOns.GetAddOnMetadata(ns.rs.addon, "X-Month") or "?"
			):gsub(
				"#YEAR", C_AddOns.GetAddOnMetadata(ns.rs.addon, "X-Year") or "?"
			), "FFFFFFFF")
		), },
		{ text = ns.rs.strings.about.author:gsub("#AUTHOR", crc(C_AddOns.GetAddOnMetadata(ns.rs.addon, "Author") or "?", "FFFFFFFF")), },
		{ text = ns.rs.strings.about.license:gsub("#LICENSE", crc(C_AddOns.GetAddOnMetadata(ns.rs.addon, "X-License") or "?", "FFFFFFFF")), },
		{ text = " ", },
		{
			text = (WidgetToolsDB.lite and ns.rs.strings.compartment.lite or ns.rs.strings.compartment.open),
			font = GameFontNormalSmall,
			color = ns.rs.colors.grey[1],
		},
	} })

	ds.LogRaw("Job's done.", "Widget Tools initialization")
end)