--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--| References

---@type widgetToolsResources
local rs = WidgetTools.resources

---@type widgetToolsUtilities
local us = WidgetTools.utilities

---@type widgetToolsDebugging
local ds = WidgetTools.debugging

local cr = WrapTextInColor
local crc = WrapTextInColorCode


--[[ GAME VERSION ]]

wt.classic = select(4, GetBuildInfo()) < 100000


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


--[[ FORMATTING ]]

--[ Escape Sequences ]

function wt.Texture(path, width, height, offsetX, offsetY, t)
	if type(path) ~= "string" then return "" end

	if type(width) ~= "number" then width = nil end
	if type(height) ~= "number" then width = nil end
	if type(offsetX) ~= "number" then width = nil end
	if type(offsetY) ~= "number" then width = nil end

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

function wt.CustomHyperlink(addon, type, content, text)
	if not addon then return "" else return wt.Hyperlink("addon", addon .. ":" .. (type or "-") .. ":" .. (content or ""), text) end
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

		if next(t.background.texture) or next(t.border.texture) then frame:SetBackdrop({
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

	--Update utility
	local setter = function() setState(wt.CheckDependencies(rules)) end

	--Set listeners
	for i = 1, #rules do if rules[i].frame then
		local t

		if us.IsFrame(rules[i].frame) then t = rules[i].frame:GetObjectType() else
			t = wt.IsWidget(rules[i].frame)

			--Watch value load events
			if t then rules[i].frame.setListener.loaded(function(_, success) if success then setter() end end) end
		end

		--Watch value change events
		if t == "CheckButton" then rules[i].frame:HookScript("OnClick", setter)
		elseif t == "EditBox" then rules[i].frame:HookScript("OnTextChanged", setter)
		elseif t == "Slider" then rules[i].frame:HookScript("OnValueChanged", setter)
		elseif t == "Toggle" then rules[i].frame.setListener.toggled(setter)
		elseif t == "Selector" or t == "Multiselector" or t == "SpecialSelector" then rules[i].frame.setListener.selected(setter)
		elseif t == "Textbox" or t == "Numeric" then rules[i].frame.setListener.changed(setter) end
	end end

	--Initialize state
	setter()
end

function wt.CheckDependencies(rules)
	if type(rules) ~= "table" then return end

	local state = true

	for i = 1, #rules do
		if us.IsFrame(rules[i].frame) then --Base Blizzard frame objects
			if rules[i].frame:IsObjectType("CheckButton") then state = rules[i].evaluate and rules[i].evaluate(rules[i].frame:GetChecked()) or rules[i].frame:GetChecked()
			elseif rules[i].frame:IsObjectType("EditBox") then state = rules[i].evaluate(rules[i].frame:GetText())
			elseif rules[i].frame:IsObjectType("Slider") then state = rules[i].evaluate(rules[i].frame:GetValue())
			end
		elseif rules[i].frame.isType then --Custom WidgetTools widgets
			if rules[i].frame.isType("Toggle") then if rules[i].evaluate then state = rules[i].evaluate(rules[i].frame.getState()) else state = rules[i].frame.getState() end
			elseif rules[i].frame.isType("Selector") then state = rules[i].evaluate(rules[i].frame.getSelected())
			elseif rules[i].frame.isType("SpecialSelector") then state = rules[i].evaluate(rules[i].frame.getSelected())
			elseif rules[i].frame.isType("Multiselector") then state = rules[i].evaluate(rules[i].frame.getSelections())
			elseif rules[i].frame.isType("Textbox") then state = rules[i].evaluate(rules[i].frame.getText())
			elseif rules[i].frame.isType("Numeric") then state = rules[i].evaluate(rules[i].frame.getNumber())
			end
		end

		if not state then break end
	end

	return state
end


--[[ TOOLTIP MANAGEMENT ]]

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


--[[ POPUP MANAGEMENT ]]

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


--[[ ADDON COMPARTMENT ]]

function wt.SetUpAddonCompartment(addon, calls, tooltip)
	if type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) then return end

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
	if type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) or type(keywords) ~= "table" then return end

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

	addon = addon:upper()

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


--[[ SETTINGS MANAGEMENT ]]

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

--| Settings data

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