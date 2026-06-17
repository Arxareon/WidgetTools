--| Dependency

if not C_AddOns.IsAddOnLoaded("WidgetTools") then return end

--| Namespace

local addon, ns = ...

--| Metadata

local version = C_AddOns.GetAddOnMetadata(addon, "X-WidgetTools-ToolboxVersion")
local nsKey = C_AddOns.GetAddOnMetadata(addon, "X-WidgetTools-AddToNamespace")

if not version then return end


--[[ REGISTRATION ]]

local insert = nsKey and function(toolbox)
	ns[nsKey] = toolbox

	WidgetTools.debugging.Log(function()
		local ts = WidgetTools.utilities.ToString

		return "Added Toolbox version " .. ts(version) .. " to the " .. ts(addon) .. " namespace " .. ts(ns) .. " under key " .. ts(nsKey) .. ".", "Widget Toolbox loaded"
	end)
end

local toolbox = WidgetTools.toolboxes.Register(addon, version, insert)

if toolbox and insert then insert(toolbox) end