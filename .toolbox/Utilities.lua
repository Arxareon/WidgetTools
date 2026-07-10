--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--| Shortcuts

local cr = C_ColorUtil.WrapTextInColor
local crc = C_ColorUtil.WrapTextInColorCode

---@type widgetToolsResources
local rs = WidgetTools.resources

---@type widgetToolsUtilities
local us = WidgetTools.utilities

---@type widgetToolsDebugging
local ds = WidgetTools.debugging


--[[ RESOURCES ]]

wt.addon = ...
wt.title = C_AddOns.GetAddOnMetadata(..., "Title")
wt.root = "Interface/AddOns/" .. wt.addon .. "/"
wt.classic = select(4, GetBuildInfo()) < 100000

--[ Textures ]

wt.textures = {
	alphaBG = wt.root .. "Textures/AlphaBG.tga",
	gradientBG = wt.root .. "Textures/GradientBG.tga",
}

--[ Strings ]

--| Fill static & internal localization references

wt.strings.backup.box.tooltip[3] = wt.strings.backup.box.tooltip[3]:gsub("#LOAD", wt.strings.backup.load.label)
wt.strings.position.keepInPlace.tooltip = wt.strings.position.keepInPlace.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.position.offsetX.tooltip = wt.strings.position.offsetX.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.position.offsetY.tooltip = wt.strings.position.offsetY.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.position.relativePoint.tooltip = wt.strings.position.relativePoint.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.layer.keepOnTop.tooltip = wt.strings.layer.keepOnTop.tooltip:gsub("#STRATA", wt.strings.layer.strata.label)
wt.strings.layer.level.tooltip = wt.strings.layer.level.tooltip:gsub("#STRATA", wt.strings.layer.strata.label)
wt.strings.about.changelog.tooltip = wt.strings.about.changelog.tooltip .. "\n\nThe changelog is only available in English for now."
wt.strings.about.fullChangelog.tooltip = wt.strings.about.fullChangelog.tooltip .. "\n\nThe changelog is only available in English for now."


--[[ TABLE MANAGEMENT ]]

function wt.HarmonizeData(targetTable, tableToSample)
	if type(targetTable) ~= "table" then return tableToSample end

	return us.Pull(us.Filter(us.Prune(targetTable), tableToSample), tableToSample) --REPLACE with combined code
end


--[[ DATA MANAGEMENT ]]

--[ Position ]

--| Verification

--ADD position data type verification utilities

--| Conversion

function wt.PackPosition(anchor, relativeTo, relativePoint, offsetX, offsetY)
	return {
		anchor = type(anchor) == "string" and anchor or "TOPLEFT",
		relativeTo = us.IsFrame(relativeTo) and relativeTo or nil,
		relativePoint = type(relativePoint) == "string" and relativePoint or nil,
		offset = offsetX and offsetY and { x = type(offsetX) == "number" and offsetX or 0, y = type(offsetY) == "number" and offsetY or 0 } or nil
	}
end

function wt.UnpackPosition(t)
	if type(t) ~= "table" then return "TOPLEFT" end

	t.anchor = type(t.anchor) == "string" and t.anchor or "TOPLEFT"

	if t.relativeTo ~= "nil" then
		if type(t.relativeTo) == "string" then t.relativeTo = us.ToFrame(t.relativeTo) end
		if not us.IsFrame(t.relativeTo) or not (t.relativeTo or {}).GetPoint then t.relativeTo = nil end
	end

	if type(t.offset) ~= "table" then t.offset = {} else
		t.offset.x = type(t.offset.x) == "number" and t.offset.x or 0
		t.offset.y = type(t.offset.y) == "number" and t.offset.y or 0
	end

	return t.anchor, t.relativeTo, t.relativePoint, t.offset.x, t.offset.y
end

--[ Color ]

--| Verification

function wt.IsColor(t)
	if type(t) ~= "table" then
		ds.Log(function() return "Not a color: " ..  us.TableToString(t), "IsColor" end)

		return false
	elseif type(t.r) ~= "number" or t.r < 0 or t.r > 1 then
		ds.Log(function() return "Invalid red color value: " .. tostring(t.r) end)

		return false
	elseif type(t.g) ~= "number" or t.g < 0 or t.g > 1 then
		ds.Log(function() return "Invalid green color value: " .. tostring(t.g) end)

		return false
	elseif type(t.b) ~= "number" or t.b < 0 or t.b > 1 then
		ds.Log(function() return "Invalid blue color value: " .. tostring(t.b) end)

		return false
	elseif t.a ~= nil and (type(t.a) ~= "number" or t.a < 0 or t.a > 1) then
		ds.Log(function() return "Invalid alpha color value: " .. tostring(t.a) end)

		return false
	end

	return t
end

function wt.VerifyColor(color)
	if type(color) ~= "table" then return { r = 1, g = 1, b = 1, a = 1 } end

	color.r = type(color.r) == "number" and Clamp(color.r, 0, 1) or 1
	color.g = type(color.g) == "number" and Clamp(color.g, 0, 1) or 1
	color.b = type(color.b) == "number" and Clamp(color.b, 0, 1) or 1
	color.a = type(color.a) == "number" and Clamp(color.a, 0, 1) or color.a ~= nil and 1 or nil

	return color
end

--| Conversion

function wt.PackColor(red, green, blue, alpha)
	return {
		r = type(red) == "number" and Clamp(red, 0, 1) or 1,
		g = type(green) == "number" and Clamp(green, 0, 1) or 1,
		b = type(blue) == "number" and Clamp(blue, 0, 1) or 1,
		a = type(alpha) == "number" and Clamp(alpha, 0, 1) or 1
	}
end

function wt.UnpackColor(color, alpha)
	if type(color) ~= "table" then return 1, 1, 1, 1 end

	local r = type(color.r) == "number" and Clamp(color.r, 0, 1) or 1
	local g = type(color.g) == "number" and Clamp(color.g, 0, 1) or 1
	local b = type(color.b) == "number" and Clamp(color.b, 0, 1) or 1
	local a = type(color.a) == "number" and Clamp(color.a, 0, 1) or 1

	if alpha ~= false then return r, g, b, a else return r, g, b end
end

function wt.ColorToHex(color, alphaFirst, hashtag)
	local hex = hashtag ~= false and "#" or ""

	if type(color) ~= "table" then return hex .. "FFFFFFFF" end

	local r = type(color.r) == "number" and string.format("%02x", math.ceil(color.r * 255)) or "FF"
	local g = type(color.g) == "number" and string.format("%02x", math.ceil(color.g * 255)) or "FF"
	local b = type(color.b) == "number" and string.format("%02x", math.ceil(color.b * 255)) or "FF"
	local a = type(color.a) == "number" and string.format("%02x", math.ceil(color.a * 255)) or "FF"

	if alphaFirst then hex = hex .. a end
	hex = hex .. r .. g .. b
	if not alphaFirst then hex = hex .. a end

	return hex:upper()
end

function wt.HexToColor(hex)
	if type(hex) ~= "string" then return 1, 1, 1 else hex = hex:gsub("#", "") end

	local r = tonumber(hex:sub(1, 2), 16) / 255
	local g = tonumber(hex:sub(3, 4), 16) / 255
	local b = tonumber(hex:sub(5, 6), 16) / 255

	if hex:len() == 8 then return r, g, b, tonumber(hex:sub(7, 8), 16) / 255 else return r, g, b end
end

function wt.AdjustGamma(color, exponent)
	if type(color) ~= "table" then return color end

	exponent = type(exponent) == "number" and exponent or 0.55

	if type(color.r) == "number" then color.r = color.r ^ exponent end
	if type(color.g) == "number" then color.g = color.g ^ exponent end
	if type(color.b) == "number" then color.b = color.b ^ exponent end

	return color
end

function wt.CreateColor(color) return CreateColor(wt.UnpackColor(color)) end


--[[ FORMATTING ]]

--[ Escape Sequences ]

function wt.Texture(path, width, height, offsetX, offsetY, t)
	if type(path) ~= "string" then return "" end

	if type(width) ~= "number" or type(height) ~= "number" or type(offsetX) ~= "number" or type(offsetY) ~= "number" then width = nil end

	if type(t) == "table" then
		return CreateSimpleTextureMarkup(path, height, width, offsetX, offsetY) --REPLACE with [CreateTextureMarkup](https://warcraft.wiki.gg/wiki/FrameXML_functions#:~:text=(role)-,CreateTextureMarkup,-(file%2C%20fileWidth)
	else return CreateSimpleTextureMarkup(path, height, width, offsetX, offsetY) end
end

function wt.Clear(s)
	if type(s) ~= "string" then return s end

	s = s:gsub(
		"|c%x%x%x%x%x%x%x%x", ""
	):gsub(
		"|r", ""
	):gsub(
		"|H.-|h(.-)|h", "%1"
	):gsub(
		"|H.-|h", ""
	):gsub(
		"|T.-|t", ""
	):gsub(
		"|n", "\n"
	):gsub(
		"||", "|"
	):gsub(
		"{%a+}", ""
	):gsub(
		"{rt%d}", ""
	)

	return s
end

--[ Hyperlinks ]

function wt.Hyperlink(linkType, content, text)
	if not linkType or not content or not text then return "" else return "\124H" .. linkType .. ":" .. (content or "") .. "\124h" .. text .. "\124h" end
end

function wt.CustomHyperlink(addon, linkType, content, text)
	if not addon then return "" else return wt.Hyperlink("addon", addon .. ":" .. (linkType or "-") .. ":" .. (content or ""), text) end
end

--Hyperlink handler script registry
local hyperlinkHandlers = {}

function wt.SetHyperlinkHandler(addon, linkType, handler)
	if type(addon) ~= "string" or type(handler) ~= "function" then return end

	---Call the handler function if it has been registered
	---@param addonID string
	---@param handlerID string
	---@param payload string
	local function callHandler(addonID, handlerID, payload)
		local handlerFunction = us.FindValue(us.FindValue(hyperlinkHandlers, addonID), handlerID)

		if handlerFunction then handlerFunction(strsplit(":", payload)) end
	end

	--Hook the hyperlink handler caller
	if not next(hyperlinkHandlers) then
		if wt.classic then hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(_, ...)
			local _, addonID, handlerID, payload = strsplit(":", ..., 4)

			callHandler(addonID, handlerID, payload)
		end) else EventRegistry:RegisterCallback("SetItemRef", function(_, ...)
			local type, addonID, handlerID, payload = strsplit(":", ..., 4)

			if type == "addon" then callHandler(addonID, handlerID, payload) end
		end) end
	end

	--Add the hyperlink handler function to the registry
	if not hyperlinkHandlers[addon] then hyperlinkHandlers[addon] = {} end
	hyperlinkHandlers[addon][linkType or "-"] = handler
end


--[[ WIDGET MANAGEMENT ]]

function wt.IsWidget(t)
	return type(t) == "table" and t.isType and t.getType and t.getType() or false
end


--[[ FRAME MANAGEMENT ]]

--[ Constructors ]

---Set the parameters of a frame
---@param frame Frame
---@param t frameCreationData
local function setUpFrame(frame, t)
	t.size = t.size or {}
	t.size.w = t.size.w or 0
	t.size.h = t.size.h or 0

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(frame, t.position) end
	wt.SetArrangementDirective(frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	if t.keepInBounds then frame:SetClampedToScreen(true) end

	if t.size then frame:SetSize(t.size.w, t.size.h) end

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

	--| Global events

	if type(t.onEvent) == "table" then for event, handler in pairs(t.onEvent) do if type(handler) == "function" then us.SetListener(frame, event, handler) end end end

	--[ Initialization ]

	--Add content, performs tasks
	if type(t.initialize) == "function" then
		t.initialize(frame, t.size.w, t.size.h, t.name)

		--Arrange content
		if t.arrangement and frame then wt.ArrangeContent(frame, t.arrangement) end
	end
end

--| Base frame

function wt.CreateFrame(t)
	t = type(t) == "table" and t or {}

	--[ Frame Setup ]

	local name = t.name and ((t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. t.name:gsub("%s+", "")) or nil
	local frame = CreateFrame("Frame", name, t.parent)

	--| Shared setup

	setUpFrame(frame, t)

	return frame
end

function wt.CreateCustomFrame(t)
	t = type(t) == "table" and t or {}

	--[ Frame Setup ]

	local name = t.name and ((t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. t.name:gsub("%s+", "")) or nil
	local frame = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

	--| Shared setup

	setUpFrame(frame, t)

	return frame
end

--| Scrollframe

function wt.CreateScrollframe(t)
	t = type(t) == "table" and t or {}
	t.scrollSize = type(t.scrollSize) == "table" and t.scrollSize or {}

	--[ Frame Setup ]

	local parentName = t.parent and t.parent:GetName() or ""
	local name = t.name and t.name:gsub("%s+", "")

	local scrollframe = CreateFrame("ScrollFrame", parentName .. (name or "") .. "ScrollParent", t.parent, ScrollControllerMixin and "ScrollFrameTemplate")

	--| Position & dimensions

	t.size = t.size or t.parent and { w = t.parent:GetWidth(), h = t.parent:GetHeight() } or { w = 0, h = 0 }

	wt.SetPosition(scrollframe, t.position)

	scrollframe:SetSize(t.size.w, t.size.h)

	--Scrollbar
	wt.SetPosition(scrollframe.ScrollBar, {
		anchor = "RIGHT",
		relativeTo = scrollframe,
		relativePoint = "RIGHT",
		offset = { x = -4, y = 1 }
	})
	scrollframe.ScrollBar:SetHeight(t.size.h - 10)

	--[ Scroll Child ]

	--Create scrollable child frame
	local scrollChild = wt.CreateFrame({
		parent = scrollframe,
		name = parentName .. (name or "Scroller"),
		append = false,
		size = { w = t.scrollSize.w or scrollframe:GetWidth() - (wt.classic and 32 or 16), h = t.scrollSize.h },
		initialize = t.initialize,
		arrangement = t.arrangement
	})

	--Register for scroll
	scrollframe:SetScrollChild(scrollChild)

	--Update scroll speed
	t.scrollSpeed = (t.scrollSpeed or 0.25)

	--Override the built-in update function
	scrollframe.ScrollBar.SetPanExtentPercentage = function() --WATCH to change when Blizzard provides a better way to overriding the built-in update function
		local height = scrollframe:GetHeight()
		scrollframe.ScrollBar.panExtentPercentage = height * t.scrollSpeed / math.abs(scrollChild:GetHeight() - height)
	end

	return scrollChild, scrollframe
end

--[ Position ]

--Used for a transitional step to avoid anchor family connections during safe frame positioning
local positioningAid

function wt.SetPosition(frame, position, unlink, userPlaced)
	if not us.IsFrame(frame) or not frame.SetPoint then return end

	local anchor, relativeTo, relativePoint, offsetX, offsetY = wt.UnpackPosition(position)
	relativeTo = relativeTo ~= "nil" and relativeTo or nil

	--Set the position
	if relativeTo and unlink then
		if not positioningAid then
			positioningAid = CreateFrame("Frame", rs.addon .. "PositioningAid", UIParent)

			positioningAid:Hide()
		end

		positioningAid:SetSize(frame:GetSize())

		--[ Position the Aid ]

		positioningAid:ClearAllPoints()

		if (not relativeTo and not relativePoint) and (not offsetX and not offsetY) then positioningAid:SetPoint(anchor)
		elseif not relativeTo and not relativePoint then positioningAid:SetPoint(anchor, offsetX, offsetY)
		elseif not offsetX and not offsetY then positioningAid:SetPoint(anchor, relativeTo, relativePoint or anchor)
		else positioningAid:SetPoint(anchor, relativeTo, relativePoint or anchor, offsetX, offsetY) end

		wt.ConvertToAbsolutePosition(positioningAid, true)

		--[ Position the Frame ]

		frame:ClearAllPoints()

		frame:SetPoint(positioningAid:GetPoint())
	else
		frame:ClearAllPoints()

		if (not relativeTo and not relativePoint) and (not offsetX and not offsetY) then frame:SetPoint(anchor)
		elseif not relativeTo and not relativePoint then frame:SetPoint(anchor, offsetX, offsetY)
		elseif not offsetX and not offsetY then frame:SetPoint(anchor, relativeTo, relativePoint or anchor)
		else frame:SetPoint(anchor, relativeTo, relativePoint or anchor, offsetX, offsetY) end
	end

	--Set user placed
	if frame.IsMovable and frame:IsMovable() then frame:SetUserPlaced(userPlaced ~= false) end
end

function wt.SetAnchor(frame, anchor)
	if not us.IsFrame(frame) or type(anchor) ~= "string" then return end

	local oldAnchor, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
	local x, y = 0, 0

	if oldAnchor:find("LEFT") then
		if anchor:find("RIGHT") then x = -frame:GetWidth() elseif anchor == "CENTER" or anchor == "TOP" or anchor == "BOTTOM" then x = -frame:GetWidth() / 2 end
	elseif oldAnchor:find("RIGHT") then
		if anchor:find("LEFT") then x = frame:GetWidth() elseif anchor == "CENTER" or anchor == "TOP" or anchor == "BOTTOM" then x = frame:GetWidth() / 2 end
	elseif oldAnchor == "CENTER" or oldAnchor == "TOP" or oldAnchor == "BOTTOM" then
		if anchor:find("LEFT") then x = frame:GetWidth() / 2 elseif anchor:find("RIGHT") then x = -frame:GetWidth() / 2 end
	end
	if oldAnchor:find("TOP") then
		if anchor:find("BOTTOM") then y = frame:GetHeight() elseif anchor == "CENTER" or anchor == "LEFT" or anchor == "RIGHT" then y = frame:GetHeight() / 2 end
	elseif oldAnchor:find("BOTTOM") then
		if anchor:find("TOP") then y = -frame:GetHeight() elseif anchor == "CENTER" or anchor == "LEFT" or anchor == "RIGHT" then y = -frame:GetHeight() / 2 end
	elseif oldAnchor == "CENTER" or oldAnchor == "LEFT" or oldAnchor == "RIGHT" then
		if anchor:find("TOP") then y = -frame:GetHeight() / 2 elseif anchor:find("BOTTOM") then y = frame:GetHeight() / 2 end
	end

	offsetX = offsetX - x
	offsetY = offsetY - y

	frame:SetPoint(anchor, relativeTo, relativePoint, offsetX, offsetY)

	return offsetX, offsetY
end

function wt.ConvertToAbsolutePosition(frame, keepAnchor)
	if not us.IsFrame(frame) or not frame.IsMovable then return end

	local movable = frame:IsMovable()
	local oldAnchor = frame:GetPoint()

	--Unlink relative anchoring
	frame:SetMovable(true)
	frame:StartMoving()
	frame:StopMovingOrSizing()

	--Restore movability
	frame:SetMovable(movable)

	if keepAnchor == false then return end

	--Restore frame anchoring
	wt.SetAnchor(frame, oldAnchor)
end

--| Arrangement

---List of container content element positioning arrangement ordering directives
---@type table<AnyFrameObject, integer>
local arrangementOrdering = {}

---List of container content element positioning arrangement wrapping directives
---@type table<AnyFrameObject, boolean>
local arrangementWrapping = {}

---List of child frame references to skip when arranging the children of their parents
---@type table<AnyFrameObject[], boolean>
local arrangementSkipping = {}

function wt.SetArrangementDirective(frame, index, wrap, skip)
	if not us.IsFrame(frame) or not frame:GetParent() then return end

	arrangementOrdering[frame] = type(index) == "number" and us.Round(index) or nil
	if wrap == nil then arrangementWrapping[frame] = nil else arrangementWrapping[frame] = wrap == true end
	if skip == nil then arrangementSkipping[frame] = nil else arrangementSkipping[frame] = skip == true end
end

function wt.ArrangeContent(container, t)
	if not us.IsFrame(container) then return end

	t = type(t) == "table" and t or {}
	t.margins = t.margins or {}
	t.margins = { l = t.margins.l or 12, r = t.margins.r or 12, t = t.margins.t or 12, b = t.margins.b or 12 }
	if t.flip then
		local temp = t.margins.l
		t.margins.l = t.margins.r
		t.margins.r = temp
	end
	t.gaps = t.gaps or 8
	local flipper = t.flip and -1 or 1
	local height = t.margins.t

	--| Scaffold the arrangement based on the directives set

	---@type Frame[]
	local frames = us.Reorder({ container:GetChildren() }, arrangementOrdering)
	local arrangement = { {} }

	for i = 1, #frames do if not arrangementSkipping[frames[i]] then
		--Start a new row
		if #arrangement[#arrangement] >= 1 and arrangementWrapping[frames[i]] then table.insert(arrangement, {}) end

		--Add the child frame to the currently filling row
		table.insert(arrangement[#arrangement], frames[i])
	end end

	--Remove last rows that got left empty
	if #arrangement[#arrangement] < 1 then arrangement[#arrangement] = nil end

	--| Arrange the child frames & resize the parent

	for i = 1, #arrangement do
		local rowHeight = 0

		--Find the tallest frame
		for j = 1, #arrangement[i] do
			local frameHeight = arrangement[i][j]:GetHeight()
			if frameHeight > rowHeight then rowHeight = frameHeight end

			--Clear positions
			arrangement[i][j]:ClearAllPoints()
		end

		--Increase the content height by the space between rows
		height = height + (i > 1 and t.gaps or 0)

		--First frame goes to the top left (or right if flipped)
		arrangement[i][1]:SetPoint(t.flip and "TOPRIGHT" or "TOPLEFT", t.margins.l * flipper, -height)

		--Place the rest of the frames
		if #arrangement[i] > 1 then
			local odd = #arrangement[i] % 2 ~= 0

			--Middle frame goes to the top center
			local two = #arrangement[i] == 2
			if odd or two then arrangement[i][two and 2 or math.ceil(#arrangement[i] / 2)]:SetPoint("TOP", container, "TOP", 0, -height) end

			if #arrangement[i] > 2 then
				--Last frame goes to the top right (or left if flipped)
				arrangement[i][#arrangement[i]]:SetPoint(t.flip and "TOPLEFT" or "TOPRIGHT", -t.margins.r * flipper, -height)

				--Fill the space between the main anchor points with the remaining frames
				if #arrangement[i] > 3 then
					local shift = odd and 0 or 0.5
					local w = container:GetWidth() / 2
					local n = (#arrangement[i] - (odd and 1 or 0)) / 2 - shift
					local leftFillWidth = (w - arrangement[i][1]:GetWidth() / 2 - t.margins.l) / -n * flipper
					local rightFillWidth = (w - arrangement[i][#arrangement[i]]:GetWidth() / 2 - t.margins.r) / n * flipper

					--Fill the left half
					local last = math.floor(#arrangement[i] / 2)
					for j = 2, last do arrangement[i][j]:SetPoint("TOP", leftFillWidth * (math.abs(last - j) + (1 - shift)), -height) end

					--Fill the right half
					local first = math.ceil(#arrangement[i] / 2) + 1
					for j = first, #arrangement[i] - 1 do arrangement[i][j]:SetPoint("TOP", rightFillWidth * (math.abs(first - j) + (1 - shift)), -height) end
				end
			end
		end

		--Increase the content height by the row height
		height = height + rowHeight
	end

	--Set the height of the container frame
	if t.resize ~= false then container:SetHeight(height + t.margins.b) end
end

--| Movability

function wt.SetMovability(frame, movable, t)
	if not us.IsFrame(frame) or not frame.SetMovable then return end

	movable = movable == true
	t = type(t) == "table" and t or {}
	local triggers = type(t.triggers) == "table" and t.triggers or { frame }
	local events = type(t.events) == "table" and t.events or {}
	local modifier = type(t.modifier) == "string" and t.modifier or nil
	local cursor = t.cursor
	if type(cursor) ~= "boolean" then cursor = t.modifier ~= nil end
	local position

	frame:SetMovable(movable)

	if movable then
		local hadEvent, isMoving

		position = wt.PackPosition(frame:GetPoint())

		--Toggle movement cursor
		if modifier then
			hadEvent = frame:IsEventRegistered("MODIFIER_STATE_CHANGED")

			frame:HookScript("OnEvent", function(_, event, key, down) if event == "MODIFIER_STATE_CHANGED" and key:find(modifier) then
				if down > 0 then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") else SetCursor(nil) end
			end end)
		end

		for i = 1, #triggers do
			triggers[i]:EnableMouse(true)

			--| Cursor

			--Set movement cursor
			triggers[i]:HookScript("OnEnter", function()
				if not cursor or not frame:IsMovable() then return end

				if not modifier then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") else
					if us.isKeyDown[modifier]() then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") end

					frame:RegisterEvent("MODIFIER_STATE_CHANGED")
				end
			end)

			--Reset cursor
			triggers[i]:HookScript("OnLeave", function()
				if not cursor or not frame:IsMovable() then return end

				SetCursor(nil)

				if modifier and not hadEvent then frame:UnregisterEvent("MODIFIER_STATE_CHANGED") end
			end)


			--| Movement

			triggers[i]:HookScript("OnMouseDown", function()
				if not frame:IsMovable() or isMoving then return end
				if modifier and not us.isKeyDown[modifier]() then return end

				--Store position
				position = wt.PackPosition(frame:GetPoint())

				--Start moving
				frame:StartMoving()
				isMoving = true
				if type(events.onStart) == "function" then events.onStart() end

				--| Start the movement updates

				if triggers[i]:HasScript("OnUpdate") then triggers[i]:SetScript("OnUpdate", function()
					if type(events.onMove) == "function" then events.onMove() end

					--Check if the modifier key is pressed
					if modifier then
						if us.isKeyDown[modifier]() then return end

						--Cancel when the modifier key is released
						frame:StopMovingOrSizing()
						isMoving = false
						if type(events.onCancel) == "function" then events.onCancel() end

						--Reset the position
						wt.SetPosition(frame, position)

						--Stop checking if the modifier key is pressed
						triggers[i]:SetScript("OnUpdate", nil)
					end
				end) end
			end)

			triggers[i]:HookScript("OnMouseUp", function()
				if not frame:IsMovable() or not isMoving then return end

				--Stop moving
				frame:StopMovingOrSizing()
				isMoving = false
				if type(events.onStop) == "function" then events.onStop() end

				--Stop the movement updates
				if triggers[i]:HasScript("OnUpdate") then triggers[i]:SetScript("OnUpdate", nil) end
			end)

			triggers[i]:HookScript("OnHide", function()
				if not frame:IsMovable() or not isMoving then return end

				--Cancel moving
				frame:StopMovingOrSizing()
				isMoving = false
				if type(events.onCancel) == "function" then events.onCancel() end

				--Reset the position
				wt.SetPosition(frame, position)

				--Stop the movement updates
				if triggers[i]:HasScript("OnUpdate") then triggers[i]:SetScript("OnUpdate", nil) end
			end)
		end
	else for i = 1, #triggers do triggers[i]:EnableMouse(false) end end
end

--[ Visibility ]

function wt.SetVisibility(frame, visible)
	if not us.IsFrame(frame) then return end

	if visible then frame:Show() else frame:Hide() end
end

--[ Backdrop ]

function wt.SetBackdrop(frame, backdrop, updates)
	if not us.IsFrame(frame) or not frame.SetBackdrop then return end

	--[ Set Backdrop ]

	---@param t? backdropData
	local function setBackdrop(t)
		if type(t) ~= "table" then
			frame:ClearBackdrop()

			return
		end

		t.background = type(t.background) == "table" and t.background or {}
		t.border = type(t.border) == "table" and t.border or {}
		t.background.texture = type(t.background.texture) == "table" and t.background.texture or {}
		t.background.texture.insets = type(t.background.texture.insets) == "table" and t.background.texture.insets or {}
		t.border.texture = type(t.border.texture) == "table" and t.border.texture or {}

		if next(t.background.texture) or next(t.border.texture) then pcall(frame.SetBackdrop, frame, {
			bgFile = next(t.background.texture) and (t.background.texture.path or "Interface/ChatFrame/ChatFrameBackground") or nil,
			tile = t.background.texture.tile ~= false,
			tileSize = t.background.texture.size,
			insets = {
				left = t.background.texture.insets.l or 0,
				right = t.background.texture.insets.r or 0,
				top = t.background.texture.insets.t or 0,
				bottom = t.background.texture.insets.b or 0
			},
			edgeFile = next(t.border.texture) and (t.border.texture.path or "Interface/Tooltips/UI-Tooltip-Border") or nil,
			edgeSize = t.border.texture.width
		}) end
		if t.background.color then frame:SetBackdropColor(wt.UnpackColor(t.background.color)) end
		if t.border.color then frame:SetBackdropBorderColor(wt.UnpackColor(t.border.color)) end
	end

	--Set the base backdrop
	setBackdrop(backdrop)

	--[ Backdrop Updates ]

	if type(updates) == "table" then for i = 1, #updates do
		if type(updates[i].triggers) ~= "table" or not next(updates[i].triggers) then updates[i].triggers = { frame } end

		for key, value in pairs(updates[i].rules) do
			local function updater(self, ...)
				--Unconditional: Restore the base backdrop on event trigger
				if type(value) ~= "function" then
					setBackdrop(backdrop)

					return
				end

				--Conditional: Evaluate the rule
				local backdropUpdate, fill = value(frame, self, ...)

				--Remove the backdrop
				if type(backdropUpdate) ~= "table" then
					setBackdrop(nil)

					return
				end

				--Restore the base backdrop or do nothing on evaluation
				if not next(backdropUpdate) then if fill then
					setBackdrop(backdrop)

					return
				else return end end

				--Fill defaults
				if fill then
					--Fill backdrop update table with the base backdrop values
					backdropUpdate = backdrop and us.Fill(backdropUpdate, backdrop) or nil
				else
					--Fill backdrop update table with the current values
					if frame.backdropInfo then
						--Background
						backdropUpdate.background = backdropUpdate.background or {}
						backdropUpdate.background.texture = backdropUpdate.background.texture or us.Fill(backdropUpdate.background.texture, {
							path = frame.backdropInfo.bgFile,
							size = frame.backdropInfo.tileSize,
							tile = frame.backdropInfo.tile,
							insets = {
								l = frame.backdropInfo.insets.left,
								r = frame.backdropInfo.insets.right,
								t = frame.backdropInfo.insets.top,
								b = frame.backdropInfo.insets.bottom
							}
						})
						backdropUpdate.background.color = backdropUpdate.background.color or wt.PackColor(frame:GetBackdropColor())

						--Border
						backdropUpdate.border = backdropUpdate.border or {}
						backdropUpdate.border.texture = backdropUpdate.border.texture or us.Fill(backdropUpdate.border.texture, {
							path = frame.backdropInfo.edgeFile,
							width = frame.backdropInfo.edgeSize,
						})
						backdropUpdate.border.color = backdropUpdate.border.color or wt.PackColor(frame:GetBackdropColor())
					else backdropUpdate = nil end
				end

				--Update the backdrop
				setBackdrop(backdropUpdate)
			end

			for j = 1, #updates[i].triggers do if updates[i].triggers[j]:HasScript(key) then updates[i].triggers[j]:HookScript(key, updater) end end
		end
	end end
end

--[ Dependencies ]

function wt.AddDependencies(rules, setState)
	if type(rules) ~= "table" or type(setState) ~= "function" then return end

	local setter = function() setState(wt.CheckDependencies(rules)) end

	for i = 1, #rules do
		local f = rules[i].frame
		local t = wt.IsWidget(f)

		if t then
			f.setListener.loaded(function(_, success) if success then setter() end end)

			if t == "Toggle" then f.setListener.flipped(setter)
			elseif t == "Selector" or t == "Multiselector" or t == "SpecialSelector" then f.setListener.selected(setter)
			elseif t == "Textbox" or t == "Numeric" then f.setListener.changed(setter) end
		elseif us.IsFrame(f) then
			t = f:GetObjectType()

			if t == "CheckButton" then f:HookScript("OnClick", setter)
			elseif t == "EditBox" then f:HookScript("OnTextChanged", setter)
			elseif t == "Slider" then f:HookScript("OnValueChanged", setter) end
		end
	end

	--Initialize state
	setter()
end

function wt.CheckDependencies(rules)
	if type(rules) ~= "table" then return end

	local state = true

	for i = 1, #rules do
		local f = rules[i].frame
		local e = type(rules[i].evaluate) == "function" and rules[i].evaluate or nil
		local t = wt.IsWidget(f)

		if t then
			if t == "Toggle" then if e then state = e(f.getState()) else state = f.getState() end
			elseif e then
				if t == "Selector" then state = e(f.getSelected())
				elseif t == "SpecialSelector" then state = e(f.getSelected())
				elseif t == "Multiselector" then state = e(f.getSelections())
				elseif t == "Textbox" then state = e(f.getText())
				elseif t == "Numeric" then state = e(f.getNumber()) end
			end
		elseif us.IsFrame(f) then
			t = f:GetObjectType()

			if t == "CheckButton" then if e then state = e(f:GetChecked()) else state = f:GetChecked() end
			elseif e then
				if t == "EditBox" then state = e(f:GetText())
				elseif t == "Slider" then state = e(f:GetValue()) end
			end
		end

		if not state then break end
	end

	return state
end


--[[ TEXT ]]

--[ Font ]

function wt.CreateFont(name, t)
	t = type(t) == "table" and t or {}

	if type(name) ~= "string" or name == "" then return "GameFontNormal", GameFontNormal end
	if _G[name] then return name, _G[name] end

	--[ Font Setup ]

	local font = CreateFont(name)
	if type(t.template) == "string" then font:CopyFontObject(t.template) end

	--Set display font
	if type(t.font) == "table" then pcall(font.SetFont, font, t.font.path, t.font.size, t.font.style) end

	--Set appearance
	if type(t.color) == "table" then font:SetTextColor(wt.UnpackColor(us.Fill(t.color, { r = 1, g = 1, b = 1 }))) end
	if type(t.spacing) == "number" then font:SetSpacing(t.spacing) end
	if type(t.shadow) == "table" then
		font:SetShadowOffset(t.shadow.offset.x or 1, t.shadow.offset.y)
		font:SetShadowColor(wt.UnpackColor(us.Fill(t.shadow.color, { r = 0, g = 0, b = 0 })))
	end

	--Set text positioning
	if  type(t.justify) == "table" then
		if t.justify.h then font:SetJustifyH(t.justify.h) end
		if t.justify.v then font:SetJustifyV(t.justify.v) end
	end
	if t.wrap == true then font:SetIndentedWordWrap(true) elseif t.wrap == false then font:SetIndentedWordWrap(false) end

	return name, font
end

--Create missing fonts for Classic
if wt.classic then
	wt.CreateFont("GameFontDisableMed2", {
		template = "GameFontHighlightMedium",
		color = wt.PackColor(GameFontDisable:GetTextColor()),
	})

	wt.CreateFont("NumberFont_Shadow_Large", { font = { path = "Fonts/ARIALN.TTF", size = 20, style = "OUTLINE" }, })
end

--[ Textline ]

function wt.CreateText(t)
	t = type(t) == "table" and t or {}
	t.parent = us.IsFrame(t.parent) and t.parent or UIParent

	local text = t.parent:CreateFontString((t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Text"), t.layer, t.font and t.font or "GameFontNormal")

	--| Position & dimensions

	wt.SetPosition(text, t.position)

	if type(t.width) == "number" then text:SetWidth(t.width) end
	if type(t.height) == "number" then text:SetHeight(t.height) end

	--| Font & text

	if t.color then text:SetTextColor(wt.UnpackColor(t.color)) end
	if t.justify then
		if t.justify.h then text:SetJustifyH(t.justify.h) end
		if t.justify.v then text:SetJustifyV(t.justify.v) end
	end
	if t.wrap == false then text:SetWordWrap(false) end
	if t.text then text:SetText(t.text) end

	return text
end

function wt.CreateTitle(frame, t)
	t = type(t) == "table" and t or {}

	if not us.IsFrame(frame) then return end

	return wt.CreateText({
		parent = frame,
		name = "Title",
		position = {
			anchor = t.anchor,
			offset = t.offset,
		},
		width = t.width,
		layer = "ARTWORK",
		text = t.text,
		font = t.font or "GameFontHighlight",
		color = t.color,
		justify = { h = t.justify or "LEFT", },
	})
end

function wt.CreateDescription(title, t)
	t = type(t) == "table" and t or {}

	if type(title) ~= "table" or type(title.GetFont) ~= "function" then return end

	local parent = title:GetParent()

	if not us.IsFrame(parent) then return end

	t.justify = type(t.justify) == "string" and t.justify or "LEFT"
	local anchor = t.justify ~= "RIGHT" and "LEFT" or "RIGHT"
	local relativePoint = t.justify ~= "RIGHT" and "RIGHT" or "LEFT"
	t.offset = type(t.offset) == "table" and t.offset or {}
	t.offset.x = type(t.offset.x) == "number" and t.offset.x or 0
	t.offset.y = type(t.offset.y) == "number" and t.offset.y or 1
	t.spacer = (type(t.spacer) == "number" and t.spacer or 5) * (t.justify ~= "LEFT" and -1 or 1)
	t.color = type(t.color) == "table" and t.color or us.Fill({ a = 0.55 }, HIGHLIGHT_FONT_COLOR)

	local separator = wt.CreateText({
		parent = parent,
		name = "Separator",
		position = {
			anchor = anchor,
			relativeTo = title,
			relativePoint = relativePoint,
			offset = { x = t.spacer, }
		},
		layer = "ARTWORK",
		text = "•",
		font = title:GetFontObject():GetName(),
		color = t.color,
	})

	return wt.CreateText({
		parent = parent,
		name = "Description",
		position = {
			anchor = anchor,
			relativeTo = separator,
			relativePoint = relativePoint,
			offset = { x = t.offset.x + t.spacer + 4, y = t.offset.y }
		},
		width = t.width or parent:GetWidth() - title:GetWidth() - separator:GetWidth() - t.spacer * 2 + (t.widthOffset or 0),
		layer = "ARTWORK",
		text = t.text,
		font = t.font or "GameFontHighlightSmall2",
		color = t.color,
		justify = { h = t.justify, v = "MIDDLE", },
	})
end


--[[ TEXTURE ]]

function wt.CreateTexture(frame, t, updates)
	if not us.IsFrame(frame) then return end

	t = type(t) == "table" and t or {}

	local texture = frame:CreateTexture((frame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Texture"))

	--[ Set Texture Utility ]

	---@param data textureUpdateData|textureCreationData
	local function setTexture(data)

		--| Position & dimensions

		wt.SetPosition(texture, data.position)

		texture:SetSize(data.size.w or t.size.w or frame:GetWidth(), data.size.h or t.size.h or frame:GetHeight())

		--| Asset & color

		if t.atlas then pcall(texture.SetAtlas, texture, t.atlas, true) else
			pcall(texture.SetTexture, texture, data.path or t.path, data.wrap.h or t.wrap.h, data.wrap.v or t.wrap.v, data.filterMode or t.filterMode)
		end
		if data.layer then if data.level then texture:SetDrawLayer(data.layer, data.level) else texture:SetDrawLayer(data.layer) end end
		if data.flip then texture:SetTexCoord(t.flip.h and 1 or 0, t.flip.h and 0 or 1, t.flip.v and 1 or 0, t.flip.v and 0 or 1) end
		if data.color then texture:SetVertexColor(wt.UnpackColor(data.color)) end
		if data.tile then
			texture:SetHorizTile(data.tile.h ~= nil and data.tile.h)
			texture:SetVertTile(data.tile.v ~= nil and data.tile.v)
		end
		if data.edges then
			texture:SetTexCoord(data.edges.l or 0, data.edges.r or 1, data.edges.t or 0, data.edges.b or 1)
		elseif data.vertices then
			data.vertices.topLeft = data.vertices.topLeft or {}
			data.vertices.topRight = data.vertices.topRight or {}
			data.vertices.bottomLeft = data.vertices.bottomLeft or {}
			data.vertices.bottomRight = data.vertices.bottomRight or {}

			texture:SetTexCoord(
				data.vertices.topLeft.x or 0,
				data.vertices.topLeft.y or 0,
				data.vertices.topRight.x or 1,
				data.vertices.topRight.y or 0,
				data.vertices.bottomLeft.x or 0,
				data.vertices.bottomLeft.y or 1,
				data.vertices.bottomRight.x or 1,
				data.vertices.bottomRight.y or 1
			)
		end
	end

	--| Set the base texture

	t.path = type(t.path) == "string" and t.path or "Interface/ChatFrame/ChatFrameBackground"
	t.size = type(t.size) == "table" and t.size or {}
	t.wrap = type(t.wrap) == "table" and t.wrap or {}
	t.tile = type(t.tile) == "table" and t.tile or {}

	setTexture(t)

	--[ Events ]

	--Register script event handlers
	if type(t.events) == "table" then for key, value in pairs(t.events) do
		if key == "attribute" then texture:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else texture:HookScript(key, value) end
	end end

	--[ Texture Updates ]

	if updates then for key, value in pairs(updates) do
		value.frame = value.frame or frame

		--Set the script
		if value.frame:HasScript(key) then value.frame:HookScript(key, function(self, ...)
			--Unconditional: Restore the base backdrop on trigger
			if not value.rule then
				setTexture(t)

				return
			end

			--Conditional: Evaluate the rule & fill texture update date with the base values
			local data = us.Fill(value.rule(self, ...), t)

			--Update the texture
			setTexture(data)
		end) end
	end end

	return texture
end

function wt.CreateLine(frame, t)
	t = type(t) == "table" and t or {}

	if not us.IsFrame(frame) then return end

	t.startPosition.offset = t.startPosition.offset or {}
	t.endPosition.offset = t.endPosition.offset or {}

	local line = frame:CreateLine((frame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Line"), t.layer, nil, t.level)

	--Positions
	line:ClearAllPoints()
	line:SetStartPoint(t.startPosition.relativePoint, t.startPosition.relativeTo, t.startPosition.offset.x, t.startPosition.offset.y)
	line:SetEndPoint(t.endPosition.relativePoint, t.endPosition.relativeTo, t.endPosition.offset.x, t.endPosition.offset.y)

	--Color & thickness
	if t.thickness then line:SetThickness(t.thickness) end
	if t.color then line:SetColorTexture(wt.UnpackColor(t.color)) end

	return line
end


--[[ TOOLTIP ]]

--[ Game Tooltip ]

function wt.CreateTooltip(name)
	local tooltip = CreateFrame("GameTooltip", name .. "GameTooltip", nil, "GameTooltipTemplate")

	--| Visibility

	tooltip:SetFrameStrata("TOOLTIP")
	tooltip:SetScale(UIParent:GetScale())

	--| Title

	_G[tooltip:GetName() .. "TextLeft" .. 1]:SetFontObject("GameFontNormalMed1")
	_G[tooltip:GetName() .. "TextRight" .. 1]:SetFontObject("GameFontNormalMed1")

	return tooltip
end

--[ Management ]

--Default reusable tooltip frame
local defaultTooltip

---Tooltip data registry
---@type AnyTooltipData[]
local tooltipData = {}

function wt.AddTooltip(frame, t, toggle, duplicate)
	if not us.IsFrame(frame) then return nil end

	--| Register tooltip data

	if duplicate ~= true and type(tooltipData[frame]) == "table" then return wt.UpdateTooltipData(frame, t) end

	tooltipData[frame] = type(t) == "table" and t or {}

	wt.UpdateTooltipData(frame)

	--| Toggle events

	toggle = type(toggle) == "table" and toggle or {}
	toggle.triggers = type(toggle.triggers) == "table" and toggle.triggers or {}

	table.insert(toggle.triggers, frame)

	for i = 1, #toggle.triggers do
		--Show tooltip
		if toggle.triggers[i] ~= frame and toggle.replace == false then
			toggle.triggers[i]:HookScript("OnEnter", function()
				if type(tooltipData[frame]) == "table" then if not tooltipData[frame].tooltip:IsVisible() then wt.UpdateTooltip(frame) end end
			end)
		else toggle.triggers[i]:HookScript("OnEnter", function() wt.UpdateTooltip(frame) end) end

		--Hide tooltip
		if toggle.triggers[i] ~= frame and toggle.checkParent ~= false then
			toggle.triggers[i]:HookScript("OnLeave", function()
				if not frame:IsMouseOver() then if type(tooltipData[frame]) == "table" then tooltipData[frame].tooltip:Hide() end end
			end)
		else toggle.triggers[i]:HookScript("OnLeave", function() if type(tooltipData[frame]) == "table" then tooltipData[frame].tooltip:Hide() end end) end
	end

	--| Hide with owner

	frame:HookScript("OnHide", function() if type(tooltipData[frame]) == "table" then tooltipData[frame].tooltip:Hide() end end)

	return tooltipData[frame]
end

function wt.UpdateTooltip(frame, t)
	if not us.IsFrame(frame) then return end

	--| Verify the tooltip data

	if type(tooltipData[frame]) ~= "table" then return end

	if type(t) ~= "table" then t = tooltipData[frame] else us.Pull(t, tooltipData[frame]) end

	--| Position

	if t.anchor == "ANCHOR_NONE" then
		t.tooltip:SetOwner(frame, t.anchor)
		wt.SetPosition(t.tooltip, t.position)
	else t.tooltip:SetOwner(frame, t.anchor, t.position.offset.x or 0, t.position.offset.y or 0) end

	--| Title

	local titleColor = t.flipColors and NORMAL_FONT_COLOR or HIGHLIGHT_FONT_COLOR

	t.tooltip:AddLine(t.title, titleColor.r, titleColor.g, titleColor.b, true)

	--| Textlines

	if type(t.lines) == "table" then
		for i = 1, #t.lines do

			--| Set FontString

			local left = t.tooltip:GetName() .. "TextLeft" .. i + 1
			local right = t.tooltip:GetName() .. "TextRight" .. i + 1
			local font = t.lines[i].font or "GameTooltipText"

			if not _G[left] or not _G[right] then
				t.tooltip:AddFontStrings(t.tooltip:CreateFontString(left, nil, font), t.tooltip:CreateFontString(right, nil, font))
			end

			_G[left]:SetFontObject(font)
			_G[left]:SetJustifyH("LEFT")
			_G[right]:SetFontObject(font)
			_G[right]:SetJustifyH("RIGHT")

			--| Add textline

			local color = t.lines[i].color or (t.flipColors and HIGHLIGHT_FONT_COLOR or NORMAL_FONT_COLOR)

			t.tooltip:AddLine(t.lines[i].text, color.r, color.g, color.b, t.lines[i].wrap ~= false)
		end
	end

	--| Display the tooltip

	t.tooltip:Show()
	t.tooltip:SetScale(UIParent:GetScale())
end

function wt.UpdateTooltipData(frame, t, linesUpdate)
	if not us.IsFrame(frame) then return nil end

	t = type(t) == "table" and t or {}

	--| Verify & update the tooltip data

	if type(tooltipData[frame]) ~= "table" then return nil end

	--Tooltip frame
	if us.IsFrame(t.tooltip) and t.tooltip:IsObjectType("GameTooltip") then tooltipData[frame].tooltip = t.tooltip
	elseif not tooltipData[frame].tooltip or not (us.IsFrame(tooltipData[frame].tooltip) and tooltipData[frame].tooltip:IsObjectType("GameTooltip")) then
		--Create the default reusable tooltip
		if not defaultTooltip then
			local name = "WidgetToolbox" .. C_AddOns.GetAddOnMetadata(rs.addon, "X-WidgetTools-ToolboxVersion"):gsub("[^%w]", "_") .. "GameTooltip"

			defaultTooltip = CreateFrame("GameTooltip", name, nil, "GameTooltipTemplate")

			--| Visibility

			defaultTooltip:SetFrameStrata("TOOLTIP")
			defaultTooltip:SetScale(UIParent:GetScale())

			--| Title

			_G[defaultTooltip:GetName() .. "TextLeft" .. 1]:SetFontObject("GameFontNormalMed1")
			_G[defaultTooltip:GetName() .. "TextRight" .. 1]:SetFontObject("GameFontNormalMed1")
		end

		tooltipData[frame].tooltip = defaultTooltip
	end
	t.tooltip = nil

	--Update textlines
	if linesUpdate == true then us.Filter(tooltipData[frame].lines, t.lines)
	elseif linesUpdate == false and type(t.lines) == "table" then
		if type(tooltipData[frame].lines) ~= "table" then tooltipData[frame].lines = {} end

		for i = 1, #t.lines do table.insert(tooltipData[frame].lines, t.lines[i]) end

		t.lines = nil
	end

	tooltipData[frame] = us.Pull(tooltipData[frame], t)

	--Position
	tooltipData[frame].position = tooltipData[frame].position or {}
	tooltipData[frame].position.offset = tooltipData[frame].offset or {}
	if not tooltipData[frame].anchor then tooltipData[frame].anchor = "ANCHOR_CURSOR" end

	--Title
	if type(tooltipData[frame].title) ~= "string" then tooltipData[frame].title = frame:GetName() or tostring(frame) end

	return tooltipData[frame]
end

function wt.AddWidgetTooltipLines(frames, default, utilityNote)
	if type(default) ~= "string" or utilityNote == false then return end

	---@type tooltipData
	local tooltip = { lines = { { text = " ", }, } }

	if type(default) == "string" then table.insert(tooltip.lines, { text = crc(DEFAULT .. ": ", "FF66FF66") .. default, } ) end
	if utilityNote ~= false then table.insert(tooltip.lines, { text = wt.strings.value.note, font = GameFontNormalSmall, color = rs.colors.grey[1], }) end

	for i = 1, #frames do wt.UpdateTooltipData(frames[i], tooltip, false) end
end


--[[ POPUP ]]

--[ Dialog ]

function wt.RegisterPopupDialog(key, t)
	key = type(key) == "string" and key:len() > 0 and key:upper() or nil
	t = type(t) == "table" and t or {}

	if not key or StaticPopupDialogs[key] then key = tostring(t):sub(8):upper() end

	StaticPopupDialogs[key] = {
		text = t.text or "",
		button1 = t.accept or ACCEPT,
		button2 = t.cancel or CANCEL,
		button3 = t.alt,
		OnAccept = t.onAccept,
		OnCancel = t.onCancel,
		OnAlt = t.onAlt,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = STATICPOPUPS_NUMDIALOGS
	}

	return key
end

function wt.UpdatePopupDialog(key, t)
	if not StaticPopupDialogs[key] then return end

	t = type(t) == "table" and t or {}

	if t.text then StaticPopupDialogs[key].text = t.text end
	if t.accept then StaticPopupDialogs[key].button1 = t.accept end
	if t.cancel then StaticPopupDialogs[key].button2 = t.cancel end
	if t.alt then StaticPopupDialogs[key].button3 = t.alt end
	if t.onAccept then StaticPopupDialogs[key].OnAccept = t.onAccept end
	if t.onCancel then StaticPopupDialogs[key].OnCancel = t.onCancel end
	if t.onAlt then StaticPopupDialogs[key].OnAlt = t.onAlt end

	return key
end

--[ Reload Notice ]

local reloadFrame

function wt.CreateReloadNotice(t) --FIX lite
	t = type(t) == "table" and t or {}

	if reloadFrame then
		wt.SetPosition(reloadFrame, type(t.position) == "table" and t.position or {
			anchor = "TOPRIGHT",
			offset = { x = -300, y = -100 }
		})
		reloadFrame:Show()

		return reloadFrame
	end

	--[ Frame Setup ]

	reloadFrame = wt.CreatePanel({
		parent = UIParent,
		name = "WidgetToolsReloadNotice",
		title = t.title or wt.strings.reload.title,
		position = t.position or {
			anchor = "TOPRIGHT",
			offset = { x = -300, y = -100 }
		},
		keepInBounds = true,
		size = { w = 240, h = 102 },
		frameStrata = "DIALOG",
		keepOnTop = true,
		background = { color = { a = 0.9 }, },
		lite = false,
	})

	--| Position & dimensions

	wt.SetMovability(reloadFrame, true)

	--| Title & description

	reloadFrame.title:SetPoint("TOPLEFT", 14, -14)

	wt.CreateText({
		parent = reloadFrame,
		name = "Description",
		position = {
			anchor = "TOPLEFT",
			offset = { x = 14, y = -38 }
		},
		width = 214,
		justify = { h = "LEFT", },
		text = t.message or wt.strings.reload.description,
	})

	--| Buttons

	wt.CreateButton({
		parent = reloadFrame,
		name = "ReloadButton",
		title = wt.strings.reload.accept.label,
		tooltip = { lines = { { text = wt.strings.reload.accept.tooltip, }, } },
		position = {
			anchor = "BOTTOMLEFT",
			offset = { x = 12, y = 12 }
		},
		size = { w = 120, },
		action = function() ReloadUI() end,
		lite = false,
	})

	wt.CreateButton({
		parent = reloadFrame,
		name = "CancelButton",
		title = wt.strings.reload.cancel.label,
		tooltip = { lines = { { text = wt.strings.reload.cancel.tooltip, }, } },
		position = {
			anchor = "BOTTOMRIGHT",
			offset = { x = -12, y = 12 }
		},
		action = function() reloadFrame:Hide() end,
		lite = false,
	})

	return reloadFrame
end


--[[ CONTEXT MENU ]]

function wt.CreateContextMenu(t)
	t = type(t) == "table" and t or {}

	--[ Menu Setup ]

	---@type contextMenu
	local menu = {}

	--| Utilities

	function menu.open(trigger, action)
		trigger = type(trigger) == "number" and Clamp(trigger, 1, #t.triggers) or 1

		if type(t.triggers[trigger].condition) == "function" and not t.triggers[trigger].condition(action) then return end

		MenuUtil.CreateContextMenu(t.triggers[trigger].frame, function(_, rootDescription)
			menu.rootDescription = rootDescription

			--Adding items
			if type(t.initialize) == "function" then t.initialize(menu) end
		end)
	end

	--| Trigger events

	if type(t.triggers) ~= "table" then t.triggers = { { frame = UIParent, }, } else for i = 1, #t.triggers do
		if not us.IsFrame(t.triggers[i].frame) then t.triggers[i].frame = UIParent end

		if t.triggers[i].rightClick ~= false or t.triggers[i].leftClick then t.triggers[i].frame:HookScript("OnMouseUp", function(_, button, isInside)
			if not isInside or (button == "RightButton" and t.triggers[i].rightClick == false) or (button == "LeftButton" and not t.triggers[i].leftClick) then return end

			menu.open(i, "click")
		end) end

		if t.triggers[i].hover then t.triggers[i].frame:HookScript("OnEnter", function() menu.open(i, "hover") end) end
	end end

	return menu
end

function wt.CreatePopupMenu(t)
	t = type(t) == "table" and t or {}
	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 26

	local trigger = wt.CreateCustomFrame({
		parent = t.parent,
		name = t.name or "PopupMenu",
		position = t.position,
		arrange = t.arrange,
		size = t.size,
		events = t.events,
		onEvent = t.onEvent,
		initialize = function(frame)
			local label = wt.CreateText({
				parent = frame,
				name = "Label",
				text = t.title,
				position = { anchor = "LEFT", offset = { x = 12, }, },
				justify = { h = "LEFT", },
				width = t.size.w - 48,
				font = "GameFontNormal",
			})

			local arrow = wt.CreateText({
				parent = frame,
				name = "Arrow",
				text = "►",
				position = { anchor = "RIGHT", offset = { x = -12, }, },
				justify = { h = "RIGHT", },
				width = 16,
				font = "ChatFontNormal",
				color = NORMAL_FONT_COLOR,
			})

			if type(t.tooltip) == "table" then wt.AddTooltip(frame, {
				title = t.tooltip.title or t.title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			}) end

			wt.SetBackdrop(frame, {
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
			{ { rules = {
				OnEnter = function()
					local r, g, b = HIGHLIGHT_FONT_COLOR:GetRGB()

					label:SetTextColor(r, g, b)
					arrow:SetTextColor(r, g, b)

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function()
					local r, g, b = NORMAL_FONT_COLOR:GetRGB()

					label:SetTextColor(r, g, b)
					arrow:SetTextColor(r, g, b)

					return {}, true
				end,
				OnMouseDown = function() return IsMouseButtonDown("LeftButton") and {
					background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
					border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
				} or {} end,
			}, }, })
		end
	})

	local menu = wt.CreateContextMenu({
		triggers = { {
			frame = trigger,
			leftClick = true,
			rightClick = false,
		}, },
		initialize = t.initialize,
	})

	return trigger, menu
end

function wt.CreateSubmenu(menu, t)
	if type(menu) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	--[ Menu Setup ]

	---@type contextSubmenu
	---@diagnostic disable-next-line: missing-parameter --REMOVE when the annotations get fixed
	local submenu = { rootDescription = menu.rootDescription:CreateButton(t.title or "Submenu") }

	--Adding items
	if type(t.initialize) == "function" then t.initialize(submenu) end

	return submenu
end

--[ Elements ]

function wt.CreateMenuTextline(menu, t)
	if type(menu) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	return t.queue ~= true and menu.rootDescription:CreateTitle(t.text or "Title") or menu.rootDescription:QueueTitle(t.text or "Title")
end

function wt.CreateMenuDivider(menu, t)
	if type(menu) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	return t.queue ~= true and menu.rootDescription:CreateDivider() or menu.rootDescription:QueueDivider()
end

function wt.CreateMenuSpacer(menu, t)
	if type(menu) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	return t.queue ~= true and menu.rootDescription:CreateSpacer() or menu.rootDescription:QueueSpacer()
end

function wt.CreateMenuButton(menu, t)
	if type(menu) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	return menu.rootDescription:CreateButton(t.title or "Button", t.action)
end


--[[ ADDON COMPARTMENT ]]

function wt.SetUpAddonCompartment(addon, calls, tooltip)
	local addon_type = type(addon)

	if (addon_type ~= "string" or addon_type ~= "number") or not C_AddOns.IsAddOnLoaded(addon) then return end

	calls = type(calls) == "table" and calls or {}

	local onClickName = C_AddOns.GetAddOnMetadata(addon, "AddonCompartmentFunc")
	local onEnterName = C_AddOns.GetAddOnMetadata(addon, "AddonCompartmentFuncOnEnter")
	local onLeaveName = C_AddOns.GetAddOnMetadata(addon, "AddonCompartmentFuncOnLeave")

	if onClickName and type(calls.onClick) == "function" then _G[onClickName] = calls.onClick end

	if type(tooltip) == "table" and onEnterName and onLeaveName then
		if not tooltip.tooltip then tooltip.tooltip = defaultTooltip end
		tooltip.title = tooltip.title or C_AddOns.GetAddOnMetadata(addon, "Title")
		tooltip.anchor = "ANCHOR_BOTTOMRIGHT"

		_G[onEnterName] = function(addonNamespace, frame)
			--Set tooltip
			if type(tooltipData[frame]) ~= "table" then tooltipData[frame] = tooltip end
			wt.UpdateTooltipData(frame)

			--Call handler
			if type(calls.onEnter) == "function" then calls.onEnter(addonNamespace, frame) end

			--Show tooltip
			wt.UpdateTooltip(frame)
		end

		_G[onLeaveName] = function(addonNamespace, frame)
			--Call handler
			if type(calls.onLeave) == "function" then calls.onLeave(addonNamespace, frame) end

			--Hide tooltip
			if type(tooltipData[frame]) == "table" and tooltipData[frame].tooltip then tooltipData[frame].tooltip:Hide() end
		end
	else
		if onEnterName and type(calls.onEnter) == "function" then _G[onEnterName] = calls.onEnter end
		if onLeaveName and type(calls.onLeave) == "function" then _G[onLeaveName] = calls.onLeave end
	end
end


--[[ CHAT CONTROL ]]

function wt.RegisterChatCommands(addon, keywords, t)
	local addon_type = type(addon)

	if (addon_type ~= "string" or addon_type ~= "number") or not C_AddOns.IsAddOnLoaded(addon) or type(keywords) ~= "table" then return end

	t = type(t) == "table" and t or {}

	local logo = C_AddOns.GetAddOnMetadata(addon, "IconTexture")
	logo = logo and (wt.Texture(logo, 11, 11) .. " ") or ""
	local addonTitle = wt.Clear(select(2, C_AddOns.GetAddOnInfo(addon))):gsub("^%s*(.-)%s*$", "%1")
	local branding = logo .. addonTitle .. ": "
	local commands = type(t.commands) == "table" and t.commands or {}
	t.colors = t.colors or {}
	local colors = {
		title = wt.IsColor(t.colors.title) or YELLOW_FONT_COLOR,
		content = wt.IsColor(t.colors.content) or WHITE_FONT_COLOR,
		command = wt.IsColor(t.colors.command) or LIGHTBLUE_FONT_COLOR,
		description = wt.IsColor(t.colors.description) or LIGHTGRAY_FONT_COLOR,
	}
	local onWelcome = type(t.onWelcome) == "function" and t.onWelcome or nil
	local defaultHandler = type(t.defaultHandler) == "function" and t.defaultHandler or nil

	---@type chatCommandManager
	local manager = {}

	addon = (addon_type ~= "string" and C_AddOns.GetAddOnName(addon) or addon):upper()

	--Register the keywords
	for i = 1, #keywords do
		keywords[i] = "/" .. keywords[i]
		_G["SLASH_" .. addon .. i] = keywords[i]
	end

	--| Utilities

	function manager.print(message, title, titleColor, contentColor)
		title = type(title) == "string" and title or branding
		titleColor = wt.IsColor(titleColor) or colors[type(titleColor) == "string" and titleColor or "title"]
		contentColor = wt.IsColor(contentColor) or colors[type(contentColor) == "string" and contentColor or "content"]

		if type(message) == "string" then print(cr(title, titleColor) .. cr(message, contentColor)) end
	end

	function manager.welcome()
		local keyword = cr(keywords[1], colors.command)
		if #keywords > 1 then
			if #keywords > 2 then for i = 2, #keywords - 1 do keyword = " " .. keyword .. "," .. cr(keywords[i], colors.command) end end
			keyword = wt.strings.chat.welcome.keywords:gsub("#KEYWORD_ALTERNATE", cr(keywords[#keywords], colors.command)):gsub("#KEYWORD", keyword)
		end

		print(cr(logo .. wt.strings.chat.welcome.thanks:gsub("#ADDON", cr(addonTitle, colors.title)), colors.content))
		print(cr(wt.strings.chat.welcome.hint:gsub("#KEYWORD", keyword), colors.description))

		if onWelcome then onWelcome() end
	end

	function manager.help()
		print(cr(wt.strings.chat.help.list:gsub("#ADDON", cr(logo .. addonTitle, colors.title)), colors.content))

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

	function manager.handleCommand(command, ...)
		for i = 1, #commands do if command == commands[i].command then
			if commands[i].handler then
				local results = { commands[i].handler(manager, ...) }

				--Response
				if results[1] == true then
					local message = type(commands[i].success) == "function" and commands[i].success(unpack(results, 2)) or commands[i].success

					--Print response message
					if type(message) == "string" then manager.print(message) end

					--Call handler
					if type(commands[i].onSuccess) == "function" then commands[i].onSuccess(manager, unpack(results, 2)) end
				elseif results[1] == false then
					local message = type(commands[i].error) == "function" and commands[i].error(unpack(results, 2)) or commands[i].error

					--Print response message
					if type(message) == "string" then manager.print(message) end

					--Call handler
					if type(commands[i].onError) == "function" then commands[i].onError(manager, unpack(results, 2)) end
				end
			end

			if commands[i].help then manager.help() end

			return true
		end end

		return false
	end

	--| Set global keyword handler

	SlashCmdList[addon] = function(line)
		local payload = { strsplit(" ", line) }
		local command = payload[1]

		--Find and handle the specific command or call the default handler script
		if not manager.handleCommand(command, unpack(payload, 2)) then
			if defaultHandler then defaultHandler(manager, command, unpack(payload, 2)) end

			--List (non-hidden) commands
			manager.help()
		end
	end

	return manager
end


--[[ SETTINGS ]]

function wt.RegisterSettingsPage(page, parent, icon)
	if WidgetToolsDB.lite or wt.IsWidget(page) ~= "SettingsPage" or page.category then return end

	parent = wt.IsWidget(parent) == "SettingsPage" and parent or nil
	if icon == nil then icon = parent == nil end

	local iconTexture = (icon and type(page.iconTexture) == "string" and (" |T" .. page.iconTexture .. ":14:14:3:-1|t") or "")
	local title = (type(page.title) == "table" and type(page.title.GetText) == "function" and page.title:GetText() or "") .. iconTexture

	page.canvas.OnCommit = function() page.save(true) end
	page.canvas.OnRefresh = function() page.load(nil, true) end
	page.canvas.OnDefault = function() page.reset(true) end

	if parent and type(parent.category) == "table" then page.category = Settings.RegisterCanvasLayoutSubcategory(parent.category, page.canvas, title)
	else page.category = Settings.RegisterCanvasLayoutCategory(page.canvas, title) end

	Settings.RegisterAddOnCategory(page.category)
end

--[ Data Management ]

---@type settingsRegistry
local settingsData = { rules = {}, changeHandlers = {} }

function wt.AddSettingsDataManagementEntry(widget, t)
	if not wt.IsWidget(widget) or type(t) ~= "table" then return nil end

	t.category = type(t.category) == "string" and t.category or "WidgetTools"
	local key = t.category .. (type(t.key) == "string" and t.key or "")

	settingsData.rules[key] = settingsData.rules[key] or {}

	--Add onChange handlers
	if type(t.onChange) == "table" then
		local newKeys = {}

		--Store functions and set caller keys
		for k, v in pairs(t.onChange) do if type(k) == "string" and type(v) == "function" then
			--Store the function
			settingsData.changeHandlers[t.category .. k] = v

			--Remove the function definitions, save their keys
			t.onChange[k] = nil
			table.insert(newKeys, k)
		end end

		--Add saved new keys
		for i = 1, #newKeys do table.insert(t.onChange, newKeys[i]) end
	end

	t.index = type(t.index) == "number" and Clamp(math.floor(t.index), 1, #settingsData.rules[key] + 1) or #settingsData.rules[key] + 1

	--Add to the registry
	table.insert(settingsData.rules[key], t.index, { widget = widget, onChange = t.onChange })

	return t.index
end

function wt.LoadSettingsData(category, key, handleChanges)
	category = type(category) == "string" and category or "WidgetTools"
	key = category .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	local changeHandlers = handleChanges == true and {} or nil

	for i = 1, #settingsData.rules[key] do
		settingsData.rules[key][i].widget.loadData(false)

		--Register onChange handlers for call
		if changeHandlers and type(settingsData.rules[key][i].onChange) == "table" then
			for j = 1, #settingsData.rules[key][i].onChange do changeHandlers[category .. settingsData.rules[key][i].onChange[j]] = true end
		end
	end

	--Call registered onChange handlers
	if changeHandlers then for k in pairs(changeHandlers) do settingsData.changeHandlers[k]() end end
end

function wt.SaveSettingsData(category, key)
	key = (type(category) == "string" and category or "WidgetTools") .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	for i = 1, #settingsData.rules[key] do settingsData.rules[key][i].widget.saveData() end
end

function wt.ApplySettingsData(category, key)
	category = type(category) == "string" and category or "WidgetTools"
	key = category .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	local handlers = {}

	--Register onChange handlers for call
	for i = 1, #settingsData.rules[key] do if type(settingsData.rules[key][i].onChange) == "table" then
		for j = 1, #settingsData.rules[key][i].onChange do handlers[category .. settingsData.rules[key][i].onChange[j]] = true end
	end end

	--Call registered onChange handlers
	if handlers then for k in pairs(handlers) do settingsData.changeHandlers[k]() end end
end

function wt.SnapshotSettingsData(category, key)
	key = (type(category) == "string" and category or "WidgetTools") .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	for i = 1, #settingsData.rules[key] do settingsData.rules[key][i].widget.snapshotData() end
end

function wt.RevertSettingsData(category, key)
	category = type(category) == "string" and category or "WidgetTools"
	key = category .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	local applyChanges = {}

	for i = 1, #settingsData.rules[key] do
		settingsData.rules[key][i].widget.revertData(false)

		--Register onChange handlers for call
		if type(settingsData.rules[key][i].onChange) == "table" then
			for j = 1, #settingsData.rules[key][i].onChange do applyChanges[category .. settingsData.rules[key][i].onChange[j]] = true end
		end
	end

	--Call registered onChange handlers
	if applyChanges then for k in pairs(applyChanges) do settingsData.changeHandlers[k]() end end
end

function wt.ResetSettingsData(category, key)
	category = type(category) == "string" and category or "WidgetTools"
	key = category .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	local applyChanges = {}

	for i = 1, #settingsData.rules[key] do
		settingsData.rules[key][i].widget.resetData(false)

		--Register onChange handlers for call
		if type(settingsData.rules[key][i].onChange) == "table" then
			for j = 1, #settingsData.rules[key][i].onChange do applyChanges[category .. settingsData.rules[key][i].onChange[j]] = true end
		end
	end

	--Call registered onChange handlers
	if applyChanges then for k in pairs(applyChanges) do settingsData.changeHandlers[k]() end end
end

function wt.HandleWidgetChanges(index, category, key)
	category = type(category) == "string" and category or "WidgetTools"
	key = category .. (type(key) == "string" and key or "")

	if type(settingsData.rules[key]) ~= "table" or type(settingsData.rules[key][index]) ~= "table" or type(settingsData.rules[key][index].onChange) ~= "table" then return end

	--Call registered onChange handlers
	for i = 1, #settingsData.rules[key][index].onChange do
		local handler = settingsData.changeHandlers[category .. settingsData.rules[key][index].onChange[i]]

		if type(handler) == "function" then handler()
		else ds.Log(function() return
			"Cannot call invalid or unset " .. key .. " handler of " .. us.ToString(settingsData.rules[key][index].onChange[i]),
			"HandleWidgetChanges"
		end) end
	end
end