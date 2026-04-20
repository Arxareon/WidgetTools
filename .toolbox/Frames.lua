--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--| References

local cr = WrapTextInColor
local crc = WrapTextInColorCode

---@type widgetToolsResources
local rs = WidgetTools.resources

---@type widgetToolsUtilities
local us = WidgetTools.utilities

---@type widgetToolsDebugging
local ds = WidgetTools.debugging


--[[ TOOLTIP ]]

function wt.CreateGameTooltip(name)
	local tooltip = CreateFrame("GameTooltip", name .. "GameTooltip", nil, "GameTooltipTemplate")

	--| Visibility

	tooltip:SetFrameStrata("TOOLTIP")
	tooltip:SetScale(UIParent:GetScale())

	--| Title

	_G[tooltip:GetName() .. "TextLeft" .. 1]:SetFontObject("GameFontNormalMed1")
	_G[tooltip:GetName() .. "TextRight" .. 1]:SetFontObject("GameFontNormalMed1")

	return tooltip
end


--[[ POPUP ]]

--| Input Box

local customPopupInputBoxFrame

function wt.CreatePopupInputBox(t)
	t = type(t) == "table" and t or {}
	t.position = type(t.position) == "table" and t.position or {
		anchor = "TOP",
		offset = { y = -320 }
	}
	t.text = type(t.text) == "string" and t.text or ""
	t.title = type(t.title) == "string" and t.title or nil

	--[ Frame Setup ]

	customPopupInputBoxFrame = customPopupInputBoxFrame or { accept = t.accept, cancel = t.cancel }

	if customPopupInputBoxFrame.panel then
		wt.SetPosition(customPopupInputBoxFrame.panel, t.position)

		--Update textbox
		customPopupInputBoxFrame.textbox.setText(t.text)
		if t.title then
			if customPopupInputBoxFrame.textbox.label then customPopupInputBoxFrame.textbox.label:SetText(t.title) else
				customPopupInputBoxFrame.textbox.label = wt.CreateTitle(customPopupInputBoxFrame.textbox.frame, {
					offset = { x = -1, },
					text = t.title,
				})
			end
		end

		--Update arrangement
		if (t.title ~= nil) ~= (customPopupInputBoxFrame.textbox.label ~= nil) then wt.ArrangeContent(customPopupInputBoxFrame.panel) end

		customPopupInputBoxFrame.panel:Show()

		return
	end

	--| Utilities

	local function accept()
		if type(customPopupInputBoxFrame.accept) == "function" then customPopupInputBoxFrame.accept(customPopupInputBoxFrame.textbox.getText()) end

		customPopupInputBoxFrame.panel:Hide()
	end

	local function cancel()
		if type(customPopupInputBoxFrame.cancel) == "function" then customPopupInputBoxFrame.cancel() end

		customPopupInputBoxFrame.panel:Hide()
	end

	--| Main panel

	customPopupInputBoxFrame.panel = wt.CreatePanel({
		parent = UIParent,
		name = "WidgetToolsPopupInputBox",
		label = false,
		position = t.position,
		keepInBounds = true,
		size = { w = 240, h = 90 },
		visible = false,
		frameStrata = "DIALOG",
		keepOnTop = true,
		background = { color = { a = 0.9 }, },
		arrangement = {},
		initialize = function(panel)

			--[ Textbox ]

			---@type customEditbox|textbox
			customPopupInputBoxFrame.textbox = wt.CreateEditbox({
				parent = panel,
				name = "TextInputBox",
				title = t.title,
				label = t.title ~= nil,
				tooltip = { title = wt.strings.popupInput.title, lines = { { text = wt.strings.popupInput.tooltip }, } },
				size = { w = panel:GetWidth() - 24, },
				focusOnShow = true,
				events = {
					OnEnterPressed = accept,
					OnEscapePressed = cancel,
				},
				arrange = {},
				value = t.text,
				showDefault = false,
				utilityMenu = false,
			})

			--[ Buttons ]

			wt.CreateButton({
				parent = panel,
				name = "AcceptButton",
				title = ACCEPT ,
				arrange = {},
				size = { w = 110, },
				action = accept,
			})

			wt.CreateButton({
				parent = panel,
				name = "CancelButton",
				title = CANCEL,
				position = {
					anchor = "BOTTOMRIGHT",
					offset = { x = -12, y = 12 }
				},
				size = { w = 90, },
				action = cancel,
			})
		end,
	})

	--| Position & dimensions

	wt.SetMovability(customPopupInputBoxFrame.panel, true)

	--| Visibility

	customPopupInputBoxFrame.panel:Show()
end

--| Reload Notice

local reloadFrame

function wt.CreateReloadNotice(t)
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
	if t.font then font:SetFont(t.font.path, t.font.size, t.font.style) end

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

--| Create custom fonts for Classic

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

		if t.atlas then texture:SetAtlas(t.atlas, true) else
			texture:SetTexture(data.path or t.path, data.wrap.h or t.wrap.h, data.wrap.v or t.wrap.v, data.filterMode or t.filterMode)
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


--[[ CONTAINER FRAME ]]

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

--[ Base Frame ]

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

--[ Scrollframe ]

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
	scrollframe.ScrollBar.SetPanExtentPercentage = function() --WATCH: Change when Blizzard provides a better way to overriding the built-in update function
		local height = scrollframe:GetHeight()
		scrollframe.ScrollBar.panExtentPercentage = height * t.scrollSpeed / math.abs(scrollChild:GetHeight() - height)
	end

	return scrollChild, scrollframe
end

--[ Panel ]

function wt.CreatePanel(t)
	t = type(t) == "table" and t or {}

	if WidgetToolsDB.lite and t.lite ~= false then return wt.CreateFrame(t) end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Panel")

	---@type panel
	local panel = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

	--| Position & dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or t.parent and t.parent:GetWidth() - 20 or 0
	t.size.h = t.size.h or 0
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(panel, t.position) end
	wt.SetArrangementDirective(panel, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	if t.keepInBounds then panel:SetClampedToScreen(true) end

	panel:SetSize(t.size.w, t.size.h)

	--| Visibility

	wt.SetVisibility(panel, t.visible ~= false)

	if t.frameStrata then panel:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then panel:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then panel:SetToplevel(t.keepOnTop) end

	--| Title & description

	panel.title = t.label ~= false and wt.CreateTitle(panel, {
		offset = { x = 7, y = 27 },
		text = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Panel",
		font = "GameFontHighlightLarge",
	}) or nil

	if type(t.description) == "string" then panel.description = wt.CreateDescription(panel.title, {
		widthOffset = -22,
		text = t.description,
	}) end

	--| Backdrop

	wt.SetBackdrop(panel, {
		background = us.Fill(t.background, {
			texture = {
				size = 5,
				insets = { l = 4, r = 4, t = 4, b = 4 },
			},
			color = { r = 0.175, g = 0.175, b = 0.175, a = 0.65 }
		}),
		border = us.Fill(t.border, {
			texture = { width = 16, },
			color = { r = 0.75, g = 0.75, b = 0.75, a = 0.5 }
		})
	})

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then panel:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else panel:HookScript(key, value) end
	end end

	--[ Initialization ]

	--Add content, performs tasks
	if type(t.initialize) == "function" then
		t.initialize(panel, t.size.w, t.size.h, t.name or "Panel")

		--Arrange content
		if t.arrangement then wt.ArrangeContent(panel, t.arrangement) end
	end

	return panel
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

	local buttonFrame = wt.CreateCustomFrame({
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
			frame = buttonFrame,
			leftClick = true,
			rightClick = false,
		}, },
		initialize = t.initialize,
	})

	return buttonFrame, menu
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


--[[ SETTINGS PAGE ]]

function wt.CreateSettingsPage(addon, t)
	if type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) then return nil end

	t = type(t) == "table" and t or {}
	t.name = t.name and t.name:gsub("%s+", "")
	if type(t.dataManagement) == "table" then
		t.dataManagement.category = t.dataManagement.category or addon
		t.dataManagement.keys = type((t.dataManagement.keys or {})[1]) == "string" and t.dataManagement.keys or { t.name or addon }
	end
	local width, height = 0, 0

	---@type string, actionButton, actionButton, FontString
	local resetWarning, resetButton, revertButton, saveNotice

	---@type settingsPage
	---@diagnostic disable-next-line: missing-fields --NOTE: Added later
	local page = {}

	--[ Getters & Setters ]

	function page.getType() return "SettingsPage" end
	function page.isType(type) return type == "SettingsPage" end

	function page.setStatic(state)
		state = state == false

		resetButton.setEnabled(state)
		revertButton.setEnabled(state)

		if state then saveNotice:Show() else saveNotice:Hide() end
	end

	function page.getResetPopupKey() return resetWarning end

	--| Utilities

	function page.open()
		if WidgetToolsDB.lite or not page.category then
			print(cr(wt.Texture(rs.textures.logo, 9) .. " " .. rs.title, rs.colors.gold[1]) .. " " .. cr(rs.strings.chat.lite.reminder:gsub(
				"#HINT", cr(rs.strings.chat.lite.hint:gsub(
					"#COMMAND", cr("/" .. rs.chat.keyword .. " " .. rs.chat.commands.lite, { r = 1, g = 1, b = 1, })
				), rs.colors.grey[1])
			), rs.colors.gold[2]))

			return
		end

		Settings.OpenToCategory(page.category:GetID())
	end

	--| Batched settings data management

	function page.load(handleChanges, user)
		--Update settings widgets
		if t.autoLoad ~= false and type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do
			wt.LoadSettingsData(t.dataManagement.category, t.dataManagement.keys[i], handleChanges)
			wt.SnapshotSettingsData(t.dataManagement.category, t.dataManagement.keys[i])
		end end

		--Call listener
		if type(t.onLoad) == "function" then t.onLoad(user == true) end
	end

	function page.save(user)
		--Retrieve data from settings widgets and commit to storage
		if t.autoSave ~= false and type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do
			wt.SaveSettingsData(t.dataManagement.category, t.dataManagement.keys[i])
		end end

		--Call listener
		if type(t.onSave) == "function" then t.onSave(user == true) end
	end

	function page.apply(user)
		if type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do wt.ApplySettingsData(t.dataManagement.category, t.dataManagement.keys[i]) end end

		--Call listener
		if type(t.onApply) == "function" then t.onApply(user == true) end
	end

	function page.revert(user)
		--Update settings widgets
		if type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do wt.RevertSettingsData(t.dataManagement.category, t.dataManagement.keys[i]) end end

		--Call listener
		if type(t.onCancel) == "function" then t.onCancel(user == true) end
	end

	function page.reset(user)
		--Update with default values
		if type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do wt.ResetSettingsData(t.dataManagement.category, t.dataManagement.keys[i]) end end

		--Call listener
		if type(t.onDefault) == "function" then t.onDefault(user == true, false) end
	end

	--[ Settings Page ]

	if not WidgetToolsDB.lite or t.lite == false then

		--[ Canvas Frame ]

		width, height = SettingsPanel.Container.SettingsCanvas:GetSize()

		page.canvas = wt.CreateFrame({
			name = (t.append ~= false and t.name and addon or "") .. (t.name or addon) .. "Page",
			size = { w = width, h = height },
			visible = false,
		})

		page.content = t.scroll and wt.CreateScrollframe({
			parent = page.canvas,
			name = "Content",
			size = { w = width - 8, h = height - 51 },
			position = { offset = { y = -52 }, },
			scrollSize = { w = width - 24, h = t.scroll.height, },
			scrollSpeed = t.scroll.speed,
		}) or wt.CreateFrame({
			parent = page.canvas,
			name = "Content",
			size = { w = width - 12, h = height - 52 },
			position = { offset = { y = -52 }, },
		})

		--| Title & description

		local title = type(t.title) == "string" and t.title or C_AddOns.GetAddOnMetadata(addon, "title")

		page.title = wt.CreateTitle(page.canvas, {
			name = "Title",
			offset = { x = 7, y = -22 },
			text = title,
			font = "GameFontHighlightHuge",
		})

		if type(t.description) == "string" then page.description = wt.CreateDescription(page.title, {
			widthOffset = -161,
			spacer = 7,
			text = t.description,
		}) end

		--| Icon texture

		page.iconTexture = type(t.icon) == "string" and t.icon or C_AddOns.GetAddOnMetadata(addon, "IconTexture")

		page.icon = wt.CreateTexture(page.canvas, {
			name = "Icon",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = SettingsPanel.Container,
				relativePoint = "TOPLEFT",
				offset = { x = 8, }
			},
			size = { w = 42, h = 42 },
			path = page.iconTexture,
		})

		--| Divider texture

		wt.CreateTexture(page.canvas, {
			atlas = "Options_HorizontalDivider",
			position = { anchor = "TOP", offset = { y = -50 } },
		})

		--[ Utility Widgets ]

		--| Defaults button

		resetWarning = wt.RegisterPopupDialog(addon .. "_" .. (t.name or "") .. "DEFAULT", {
			text = wt.strings.settings.warningSingle:gsub("#PAGE", cr(title, NORMAL_FONT_COLOR)),
			accept = ACCEPT,
			onAccept = function() page.reset(true) end,
		})

		---@type actionButton
		resetButton = wt.CreateButton({
			parent = page.canvas,
			name = "Defaults",
			title = DEFAULTS,
			tooltip = { lines = { { text = wt.strings.settings.defaults.tooltip, }, } },
			position = {
				anchor = "TOPRIGHT",
				offset = { x = -36, y = -16 }
			},
			size = { w = 96, },
			action = function() StaticPopup_Show(resetWarning) end,
			disabled = t.static,
		})

		--| Revert Changes button

		revertButton = wt.CreateButton({
			parent = page.canvas,
			name = "Cancel",
			title = wt.strings.settings.cancel.label,
			tooltip = { lines = { { text = wt.strings.settings.cancel.tooltip, }, } },
			position = {
				anchor = "BOTTOMLEFT",
				offset = { x = -18, y = -31 }
			},
			size = { w = 140, },
			action = function() page.revert(true) end,
			disabled = t.static,
		})

		--Add save notice text
		saveNotice = wt.CreateText({
			parent = page.canvas,
			name = "SaveNotice",
			position = {
				anchor = "BOTTOMRIGHT",
				offset = { x = -96, y = -26.75 }
			},
			text = wt.strings.settings.save,
			justify = { h = "RIGHT", },
		})

		if t.static then saveNotice:Hide() end
	end

	--[ Category Resources ]

	---@diagnostic disable-next-line: inject-field --REMOVE when replaced
	page.categorySyncer = { onDefault = t.onDefault, dataManagement = t.dataManagement, titleIcon = t.titleIcon } --REPLACE temporary solution

	--[ Initialization ]

	--Register to the Settings panel
	if t.register then
		local parent = type(t.register) == "table" and type(t.register.isType) == "function" and t.register.isType("SettingsPage") and t.register or nil

		wt.RegisterSettingsPage(page, parent, t.titleIcon)
	end

	--Add content, performs tasks
	if type(t.initialize) == "function" then
		t.initialize(page.content, width, height, (t.dataManagement or {}).category, (t.dataManagement or {}).keys, t.name or addon)

		--Arrange content
		if t.arrangement and page.content then wt.ArrangeContent(page.content, us.Fill(t.arrangement, {
			margins = { l = 10, r = 10, t = 54, b = 10 },
			gaps = 54,
			resize = t.scroll ~= nil
		})) end
	end

	return page
end

function wt.CreateSettingsCategory(addon, parent, pages, t)
	if not addon or not C_AddOns.IsAddOnLoaded(addon) or wt.IsWidget(parent) ~= "SettingsPage" and not parent.category then return nil end

	t = type(t) == "table" and t or {}

	---@type settingsCategory
	local category = { pages = {} }

	--[ Getters & Setters ]

	function category.getType() return "SettingsCategory" end
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
			---@diagnostic disable-next-line: undefined-field --REMOVE when replaced
			local dataManagement = category.pages[i].categorySyncer.dataManagement --REPLACE
			---@diagnostic disable-next-line: undefined-field --REMOVE when replaced
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
		if type(pages[i].isType) ~= "function" and not pages[i].isType("SettingsPage") then pages[i] = wt.CreateSettingsPage(addon, pages[i]) end

		table.insert(category.pages, pages[i])

		---@diagnostic disable-next-line: undefined-field --REMOVE when replaced
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


--[[ BUTTON ]]

---Set the parameters of a GUI button widget frame
---@param button actionButton|customButton
---@param t actionButtonCreationData|customButtonCreationData
---@param name string
---@param title string
---@param useHighlight boolean
local function setUpButtonFrame(button, t, name, title, useHighlight)

	--[ Frame Setup ]

	--| Position & dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or 80
	t.size.h = t.size.h or 22
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(button.widget, t.position) end
	wt.SetArrangementDirective(button.widget, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	button.widget:SetSize(t.size.w, t.size.h)

	--| Visibility

	wt.SetVisibility(button.widget, t.visible ~= false)

	if t.frameStrata then button.widget:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then button.widget:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then button.widget:SetToplevel(t.keepOnTop) end

	--| Hover target

	button.frame = CreateFrame("Frame", name .. "HoverTarget", button.widget)
	button.frame:SetPoint("TOPLEFT")
	button.frame:SetSize(button.widget:GetSize())

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then button.widget:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else button.widget:HookScript(key, value) end
	end end

	--| UX

	button.widget:HookScript("OnClick", function(_, mouseButton)
		if mouseButton ~= "LeftButton" or not button.widget:IsEnabled() then return end

		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

		button.trigger(true)
	end)

	--Linked mouse interactions
	button.frame:HookScript("OnEnter", function() if button.widget:IsEnabled() then
		button.widget:LockHighlight()
		if IsMouseButtonDown("LeftButton") then button.widget:SetButtonState("PUSHED") end
		if button.label and useHighlight then button.label:SetFontObject(t.font.highlight) end
	end end)
	button.frame:HookScript("OnLeave", function() if button.widget:IsEnabled() then
		button.widget:UnlockHighlight()
		button.widget:SetButtonState("NORMAL")
		if button.label and useHighlight then button.label:SetFontObject(t.font.normal) end
	end end)
	button.frame:HookScript("OnMouseDown", function(_, b) if button.widget:IsEnabled() and b == "LeftButton" then
		button.widget:SetButtonState("PUSHED")
	end end)
	button.frame:HookScript("OnMouseUp", function(_, b, isInside) if button.widget:IsEnabled() then
		button.widget:SetButtonState("NORMAL")

		if isInside and b == "LeftButton" then button.widget:Click(b) end
	end end)

	--| Tooltip

	if type(t.tooltip) == "table" then wt.AddTooltip(button.frame, {
		title = t.tooltip.title or title,
		lines = t.tooltip.lines,
		anchor = "ANCHOR_TOPLEFT",
		offset = { x = 20, },
	}, { triggers = { button.frame, }, }) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ actionButton
	---@param state boolean
	local function updateState(_, state)
		button.widget:SetEnabled(state)

		if button.label then if state then
			if useHighlight and button.widget:IsMouseOver() then button.label:SetFontObject(t.font.highlight) else button.label:SetFontObject(t.font.normal) end
		else button.label:SetFontObject(t.font.disabled) end end
	end

	--Set up starting state
	updateState(button, button.isEnabled())

	--Handle widget updates
	button.setListener.enabled(updateState, 1)
end

function wt.CreateButton(t, action)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	action = action and action.isType and action.isType("Action") and action or wt.CreateAction(t)

	if WidgetToolsDB.lite and t.lite ~= false then return action end

	---@type actionButton|action
	local button = action

	--[ Getters & Setters ]

	function button.getType() return "Action", "Button" end
	function button.isType(type) return type == "Action" or type == "Button" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Button")

	button.widget = CreateFrame("Button", name, t.parent, "UIPanelButtonTemplate")

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Button"
	local customFonts = t.font ~= nil
	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontNormal"
	t.font.highlight = t.font.highlight or "GameFontHighlight"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	if t.label ~= false then
		if customFonts then
			button.label = wt.CreateText({
				parent = button.widget,
				name = "Label",
				position = { anchor = "CENTER", },
				width = t.size.w,
				font = t.font.normal,
			})

			--Hide the built-in template label
			_G[name .. "Text"]:Hide()
		else button.label = _G[name .. "Text"] end

		if t.titleOffset then button.label:SetPoint("CENTER", t.titleOffset.x or 0, t.titleOffset.y or 0) end

		button.label:SetText(title)
	else _G[name .. "Text"]:Hide() end

	--| Shared setup

	setUpButtonFrame(button, t, name, title, t.font.highlight ~= nil)

	return button
end

function wt.CreateCustomButton(t, action)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	action = action and action.isType and action.isType("Action") and action or wt.CreateAction(t)

	if WidgetToolsDB.lite and t.lite ~= false then return action end

	---@type customButton|action
	local button = action

	--[ Getters & Setters ]

	function button.getType() return "Action", "CustomButton" end
	function button.isType(type) return type == "Action" or type == "CustomButton" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Button")

	button.widget = CreateFrame("Button", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Button"
	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontNormal"
	t.font.highlight = t.font.highlight or "GameFontHighlight"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	if t.label ~= false then
		button.label = wt.CreateText({
			parent = button.widget,
			name = "Label",
			position = { anchor = "CENTER", },
			width = t.size.w,
			font = t.font.normal,
		})

		if t.titleOffset then button.label:SetPoint("CENTER", t.titleOffset.x or 0, t.titleOffset.y or 0) end

		button.label:SetText(title)
	end

	--| Shared setup

	setUpButtonFrame(button, t, name, title, true)

	--| Backdrop

	if type(t.backdropUpdates) == "table" then for i = 1, #t.backdropUpdates do
		if type(t.backdropUpdates[i].triggers) ~= "table" then t.backdropUpdates[i].triggers = {} end
		table.insert(t.backdropUpdates[i].triggers, button.frame)
	end end

	wt.SetBackdrop(button.widget, t.backdrop, t.backdropUpdates)

	return button
end


--[[ TOGGLE ]]

function wt.CreateCheckbox(t, toggle)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	toggle = toggle and toggle.isType and toggle.isType("Toggle") and toggle or wt.CreateToggle(t)

	if WidgetToolsDB.lite and t.lite ~= false then return toggle end

	---@type checkbox|toggle
	local checkbox = toggle

	--[ Getters & Setters ]

	function checkbox.getType() return "Toggle", "Checkbox" end
	function checkbox.isType(type) return type == "Toggle" or type == "Checkbox" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")

	checkbox.frame = CreateFrame("Frame", name, t.parent)
	checkbox.widget = CreateFrame("CheckButton", name .. "Checkbox", checkbox.frame, "SettingsCheckboxTemplate")

	--| Position & dimensions

	t.size = t.size or {}
	t.size.h = t.size.h or checkbox.widget:GetHeight()
	t.size.w = t.label == false and t.size.h * (30 / 29) or t.size.w or 190
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(checkbox.frame, t.position) end
	wt.SetArrangementDirective(checkbox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	checkbox.widget:SetPoint("LEFT")
	wt.SetPosition(checkbox.widget.HoverBackground, {
		anchor = "LEFT",
		offset = { x = -2, },
	})

	checkbox.frame:SetSize(t.size.w, t.size.h)
	checkbox.widget:SetSize(t.size.h * (30 / 29), t.size.h)
	checkbox.widget.HoverBackground:SetSize(t.size.w + 2, t.size.h)

	--| Visibility

	wt.SetVisibility(checkbox.frame, t.visible ~= false)

	if t.frameStrata then checkbox.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then checkbox.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then checkbox.frame:SetToplevel(t.keepOnTop) end

	--| Label

	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontNormal"
	t.font.highlight = t.font.highlight or "GameFontHighlight"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle"

	checkbox.label = t.label ~= false and wt.CreateTitle(checkbox.frame, {
		offset = { x = t.size.h * (30 / 29) + 6, },
		text = title,
		anchor = "LEFT",
		font = t.font.normal,
	}) or nil

	--| Texture

	checkbox.widget:GetPushedTexture():SetVertexColor(.6, .6, .6, 1)

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then checkbox.widget:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnClick" then checkbox.widget:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
		else checkbox.widget:HookScript(key, value) end
	end end

	--| UX

	---Update the widget UI based on the toggle state
	---@param _ any
	---@param state boolean
	local function updateToggleState(_, state) checkbox.widget:SetChecked(state) end

	--Handle widget updates
	checkbox.setListener.toggled(updateToggleState, 1)

	checkbox.widget:HookScript("OnClick", function(self)
		local state = self:GetChecked()

		PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

		checkbox.setState(state, true)
	end)

	--Linked mouse interactions
	checkbox.frame:HookScript("OnEnter", function() if checkbox.isEnabled() then
		checkbox.widget.HoverBackground:Show()
		if IsMouseButtonDown("LeftButton") then checkbox.widget:SetButtonState("PUSHED") end
	end end)
	checkbox.frame:HookScript("OnLeave", function() if checkbox.isEnabled() then
		checkbox.widget.HoverBackground:Hide()
		checkbox.widget:SetButtonState("NORMAL")
	end end)
	checkbox.frame:HookScript("OnMouseDown", function(_, button) if checkbox.isEnabled() and button == "LeftButton" or (button == "RightButton") then
		checkbox.widget:SetButtonState("PUSHED")
	end end)
	checkbox.frame:HookScript("OnMouseUp", function(_, button, isInside) if checkbox.isEnabled() then
		checkbox.widget:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" then checkbox.widget:Click(button) end
	end end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(checkbox.widget, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_NONE",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = checkbox.widget,
				relativePoint = "TOPRIGHT",
			},
		}, { triggers = { checkbox.frame, }, })

		wt.AddWidgetTooltipLines({ checkbox.widget }, t.showDefault ~= false and checkbox.formatValue(checkbox.getDefault()), t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = checkbox.frame,
				condition = checkbox.isEnabled,
			},
			{
				frame = checkbox.widget,
				condition = checkbox.isEnabled,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.toggle = checkbox.getState() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				checkbox.setState(wt.clipboard.toggle, true)
			end }):SetEnabled(wt.clipboard.toggle ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() checkbox.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() checkbox.resetData() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		checkbox.widget:SetEnabled(state)
		checkbox.widget:EnableMouse(state)

		if checkbox.label then checkbox.label:SetFontObject(state and t.font.normal or t.font.disabled) end
	end

	--Handle widget updates
	checkbox.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set starting toggle state
	updateToggleState(nil, checkbox.getState())

	--Set up starting state
	updateState(nil, checkbox.isEnabled())

	return checkbox
end

---Set the parameters of a GUI toggle frame
---@param toggle checkbox|customCheckbox|radiobutton
---@param title string
---@param t checkboxCreationData
local function setUpToggleFrame(toggle, title, t)

	--[ Frame Setup ]

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(toggle.frame, t.position) end
	wt.SetArrangementDirective(toggle.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	toggle.widget:SetPoint("LEFT", (t.size.h - 16) / 2, 0)

	toggle.frame:SetSize(t.size.w, t.size.h)
	toggle.widget:SetSize(16, 16)

	--| Visibility

	wt.SetVisibility(toggle.frame, t.visible ~= false)

	if t.frameStrata then toggle.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then toggle.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then toggle.frame:SetToplevel(t.keepOnTop) end

	--Update the frame order
	toggle.frame:SetFrameLevel(toggle.frame:GetFrameLevel() + 1)
	toggle.widget:SetFrameLevel(toggle.widget:GetFrameLevel() - 2)

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then toggle.widget:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnClick" then toggle.widget:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
		else toggle.widget:HookScript(key, value) end
	end end

	--| UX

	---Update the widget UI based on the toggle state
	---@param _ any
	---@param state boolean
	local function updateToggleState(_, state) toggle.widget:SetChecked(state) end

	--Handle widget updates
	toggle.setListener.toggled(updateToggleState, 1)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(toggle.frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_NONE",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = toggle.widget,
				relativePoint = "TOPRIGHT",
			},
		}, { triggers = { toggle.widget, }, })

		wt.AddWidgetTooltipLines({ toggle.frame }, t.showDefault ~= false and toggle.formatValue(toggle.getDefault()), t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = toggle.frame,
				condition = toggle.isEnabled,
			},
			{
				frame = toggle.widget,
				condition = toggle.isEnabled,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.toggle = toggle.getState() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				toggle.setState(wt.clipboard.toggle, true)
			end }):SetEnabled(wt.clipboard.toggle ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() toggle.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() toggle.resetData() end }) end
		end
	}) end

	--[ Initialization ]

	--Set starting toggle state
	updateToggleState(nil, toggle.getState())
end

function wt.CreateClassicCheckbox(t, toggle)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	toggle = toggle and toggle.isType and toggle.isType("Toggle") and toggle or wt.CreateToggle(t)

	if WidgetToolsDB.lite and t.lite ~= false then return toggle end

	---@type customCheckbox|toggle
	local checkbox = toggle

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Toggle"
	---@return "ClassicCheckbox"
	---<p></p>
	function checkbox.getType() return "Toggle", "ClassicCheckbox" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function checkbox.isType(type) return type == "Toggle" or type == "ClassicCheckbox" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")

	checkbox.frame = CreateFrame("Frame", name, t.parent)
	checkbox.widget = CreateFrame("CheckButton", name .. "Checkbox", checkbox.frame, "InterfaceOptionsCheckButtonTemplate")

	--| Label

	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontHighlight"
	t.font.highlight = t.font.highlight or "GameFontNormal"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle"

	if t.label ~= false then
		checkbox.label = _G[name .. "CheckboxText"]

		checkbox.label:SetPoint("LEFT", checkbox.widget, "RIGHT", 2, 0)
		checkbox.label:SetFontObject(t.font.normal)

		checkbox.label:SetText(title)
	else _G[name .. "CheckboxText"]:Hide() end

	--| Shared setup

	t.size = t.size or {}
	t.size.h = t.size.h or 26
	t.size.w = t.label == false and t.size.h or t.size.w or 180

	setUpToggleFrame(checkbox, title, t)

	--[ Events ]

	--| UX

	checkbox.widget:HookScript("OnClick", function(self)
		local state = self:GetChecked()

		PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

		checkbox.setState(state, true)
	end)

	--Linked mouse interactions
	checkbox.frame:HookScript("OnEnter", function() if checkbox.isEnabled() then
		checkbox.widget:LockHighlight()
		if IsMouseButtonDown("LeftButton") or (IsMouseButtonDown("RightButton")) then checkbox.widget:SetButtonState("PUSHED") end
	end end)
	checkbox.frame:HookScript("OnLeave", function() if checkbox.isEnabled() then
		checkbox.widget:UnlockHighlight()
		checkbox.widget:SetButtonState("NORMAL")
	end end)
	checkbox.frame:HookScript("OnMouseDown", function(_, button) if checkbox.isEnabled() and button == "LeftButton" or (button == "RightButton") then
		checkbox.widget:SetButtonState("PUSHED")
	end end)
	checkbox.frame:HookScript("OnMouseUp", function(_, button, isInside) if checkbox.isEnabled() then
		checkbox.widget:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" or (button == "RightButton") then checkbox.widget:Click(button) end
	end end)

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		checkbox.widget:SetEnabled(state)

		if checkbox.label then checkbox.label:SetFontObject(state and t.font.normal or t.font.disabled) end
	end

	--Handle widget updates
	checkbox.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, checkbox.isEnabled())

	return checkbox
end

function wt.CreateRadiobutton(t, toggle)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	toggle = toggle and toggle.isType and toggle.isType("Toggle") and toggle or wt.CreateToggle(t)

	if WidgetToolsDB.lite and t.lite ~= false then return toggle end

	---@type radiobutton|toggle
	local radiobutton = toggle

	--[ Getters & Setters ]

	function radiobutton.getType() return "Toggle", "Radiobutton" end
	function radiobutton.isType(type) return type == "Toggle" or type == "Radiobutton" end

	--[ Properties ]

	local clearable = t.clearable

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")

	radiobutton.frame = CreateFrame("Frame", name, t.parent)
	radiobutton.widget = CreateFrame("CheckButton", name .. "RadioButton", radiobutton.frame, "UIRadioButtonTemplate")

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle"

	if t.label ~= false then
		radiobutton.label = _G[name .. "RadioButtonText"]

		radiobutton.label:SetPoint("LEFT", radiobutton.widget, "RIGHT", 3, 0)
		radiobutton.label:SetFontObject("GameFontNormal")

		radiobutton.label:SetText(title)
	else _G[name .. "RadioButtonText"]:Hide() end

	--| Shared setup

	t.size = t.size or {}
	t.size.h = t.size.h or 18
	t.size.w = t.label == false and t.size.h or t.size.w or 180

	setUpToggleFrame(radiobutton, title, t)

	--[ Events ]

	--| UX

	radiobutton.widget:HookScript("OnClick", function(_, button)
		if button == "LeftButton" then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

			radiobutton.setState(true, true)
		elseif clearable and button == "RightButton" then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

			radiobutton.setState(false, true)
		end
	end)

	--Linked mouse interactions
	radiobutton.frame:HookScript("OnEnter", function() if radiobutton.widget:IsEnabled() then
		radiobutton.widget:LockHighlight()
		if IsMouseButtonDown("LeftButton") or (clearable and IsMouseButtonDown("RightButton")) then radiobutton.widget:SetButtonState("PUSHED") end
	end end)
	radiobutton.frame:HookScript("OnLeave", function() if radiobutton.widget:IsEnabled() then
		radiobutton.widget:UnlockHighlight()
		radiobutton.widget:SetButtonState("NORMAL")
	end end)
	radiobutton.frame:HookScript("OnMouseDown", function(_, button) if radiobutton.widget:IsEnabled() and button == "LeftButton" or (clearable and button == "RightButton") then
		radiobutton.widget:SetButtonState("PUSHED")
	end end)
	radiobutton.frame:HookScript("OnMouseUp", function(_, button, isInside) if radiobutton.widget:IsEnabled() then
		radiobutton.widget:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" or (clearable and button == "RightButton") then radiobutton.widget:Click(button) end
	end end)

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		radiobutton.widget:SetEnabled(state)

		if radiobutton.label then radiobutton.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
	end

	--Handle widget updates
	radiobutton.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, radiobutton.isEnabled())

	return radiobutton
end


--[[ SELECTOR ]]

---Item naming utility
---@param parentName string
---@param index integer
---@return string name
local function findName(parentName, index)
	local name = "Item" .. index

	while _G[parentName .. name] do name = name .. "_" .. index end

	return name
end

---Set the parameters of a GUI selector widget frame
---@param selector radiogroup|checkgroup
---@param t radiogroupCreationData|checkgroupCreationData
---@param name string
---@param title string
local function setUpSelectorFrame(selector, t, name, title)

	--[ Frame Setup ]

	selector.frame = CreateFrame("Frame", name, t.parent)

	--| Position & dimensions

	t.columns = t.columns or 1
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(selector.frame, t.position) end
	wt.SetArrangementDirective(selector.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	selector.frame:SetWidth(t.width or max(t.label ~= false and 160 or 0, (t.labels ~= false and 160 or 16) * t.columns))
	selector.frame:SetHeight(math.ceil((#t.items) / t.columns) * 16 + (t.label ~= false and 14 or 0))

	--| Visibility

	wt.SetVisibility(selector.frame, t.visible ~= false)

	if t.frameStrata then selector.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then selector.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then selector.frame:SetToplevel(t.keepOnTop) end

	--| Label

	selector.label = t.label ~= false and wt.CreateTitle(selector.frame, {
		offset = { x = 4, },
		text = title,
	}) or nil

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then selector.frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else selector.frame:HookScript(key, value) end
	end end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state) if selector.label then selector.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end end

	--Handle widget updates
	selector.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, selector.isEnabled())
end

function wt.CreateRadiogroup(t, selector)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	local selectorType = wt.IsWidget(selector)
	selector = (selectorType == "Selector" or selectorType == "SpecialSelector") and selector or wt.CreateSelector(t)

	if WidgetToolsDB.lite and t.lite ~= false then return selector end

	local radiogroup
	if selectorType == "Selector" then --WATCH replace branching with a better solution to assign the right annotations
		---@type radiogroup
		radiogroup = selector
	else
		---@type specialRadiogroup
		radiogroup = selector
	end

	--[ Getters & Setters ]

	function radiogroup.getType() return "Selector", "Radiogroup" end
	function radiogroup.isType(type) return type == "Selector" or type == "Radiogroup" end

	--[ Properties ]

	local clearable = t.clearable

	--[ Frame Setup ]

	--| Shared setup

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Selector")
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Selector"

	setUpSelectorFrame(radiogroup, t, name, title)

	--| Radio button items

	---Set up or create new radio button item
	---@param item selectorToggle|selectorRadiobutton|checkbox|radiobutton|toggle
	---@param active boolean
	local function setRadioButton(item, active)
		if active and not us.IsFrame(item.frame) then
			local sameRow = (item.index - 1) % t.columns > 0

			wt.CreateRadiobutton({
				parent = radiogroup.frame,
				name = findName(name, item.index),
				title = t.items[item.index].title,
				label = t.labels,
				tooltip = t.items[item.index].tooltip,
				position = {
					relativeTo = item.index ~= 1 and radiogroup.toggles[sameRow and item.index - 1 or item.index - t.columns].frame or radiogroup.label,
					relativePoint = item.index > 1 and (sameRow and "TOPRIGHT" or "BOTTOMLEFT") or (radiogroup.label and "BOTTOMLEFT" or nil),
					offset = { x = radiogroup.label and item.index == 1 and -4 or 0, y = radiogroup.label and item.index == 1 and -2 or 0}
				},
				size = { w = (t.width and t.columns == 1) and t.width or nil, },
				clearable = clearable,
				events = { OnClick = function(_, _, button)
					if button == "LeftButton" then radiogroup.setSelected(item.index, true)
					elseif clearable and button == "RightButton" and not radiogroup.getSelected() then radiogroup.setSelected(nil, true) end
				end, },
				showDefault = false,
				utilityMenu = false,
			}, item)
		elseif active then
			--Update label
			if item.label then item.label:SetText(t.items[item.index].title) end

			--Update tooltip
			if type(t.items[item.index].tooltip) == "table" then wt.AddTooltip(item.frame, {
				title = type(t.items[item.index].tooltip.title) == "string" and t.items[item.index].tooltip.title or type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle",
				lines = t.items[item.index].tooltip.lines,
				anchor = "ANCHOR_NONE",
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = item.widget,
					relativePoint = "TOPRIGHT",
				},
			}, { triggers = { item.widget, }, }) end

			wt.SetVisibility(item.frame, true)
		else wt.SetVisibility(item.frame, false) end
	end

	--Set up current items
	for i = 1, #radiogroup.toggles do
		setRadioButton(radiogroup.toggles[i], true)

		--Handle item updates
		radiogroup.toggles[i].setListener._("activated", function(self, active) setRadioButton(self, active) end)
	end

	--Handle item list updates
	if radiogroup.setListener.updated and radiogroup.setListener.added then
		radiogroup.setListener.updated(function() radiogroup.frame:SetHeight(math.ceil((#radiogroup.toggles) / t.columns) * 18 + (t.label ~= false and 14 or 0)) end, 1)
		radiogroup.setListener.added(function (_, toggle)
			setRadioButton(toggle, true)

			--Handle item updates
			toggle.setListener._("activated", function(self, active) setRadioButton(self, active) end)
		end)
	end

	--[ Events ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(radiogroup.frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			local default = radiogroup.getDefault()
			defaultValue = crc(default and t.items[default].title or tostring(default), "FFFFFFFF")
		end

		local frames = { radiogroup.frame }
		for i = 1, #radiogroup.toggles do table.insert(frames, radiogroup.toggles[i].frame) end

		wt.AddWidgetTooltipLines(frames, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	local openTriggers = { {
		frame = radiogroup.frame,
		condition = radiogroup.isEnabled,
	}, }

	for i = 1, #radiogroup.toggles do table.insert(openTriggers, {
		frame = radiogroup.toggles[i].frame,
		condition = radiogroup.isEnabled,
	}) end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = openTriggers,
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.selection = { index = radiogroup.getSelected() } end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				radiogroup.setSelected(wt.clipboard.selection.index, true)
			end }):SetEnabled(wt.clipboard.selection ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() radiogroup.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() radiogroup.resetData() end }) end
		end
	}) end

	return radiogroup
end

function wt.CreateDropdownRadiogroup(t, selector)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	selector = wt.IsWidget(selector) == "Selector" and selector or wt.CreateSelector(t)

	if WidgetToolsDB.lite and t.lite ~= false then return selector end

	--[ Properties ]

	local clearable = t.clearable

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Drorpdown")

	local holderFrame = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

	--| Position & dimensions

	t.width = t.width or 180
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(holderFrame, t.position) end
	wt.SetArrangementDirective(holderFrame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	holderFrame:SetSize(t.width + 4, 44)

	--| Visibility

	wt.SetVisibility(holderFrame, t.visible ~= false)

	if t.frameStrata then holderFrame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then holderFrame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then holderFrame:SetToplevel(t.keepOnTop) end

	--| Scroll

	t.scrollThreshold = t.scrollThreshold or 15

	--[ Dropdown Menu ]

	---@type dropdownRadiogroup|radiogroup
	local dropdown = wt.CreateRadiogroup({
		name = name,
		append = false,
		label = false,
		width = t.width - (#t.items > t.scrollThreshold and 28 or 12),
		items = t.items,
		clearable = clearable,
		listeners = t.listeners,
		dependencies = t.dependencies,
		getData = t.getData,
		saveData = t.saveData,
		default = t.default,
		instantSave = t.instantSave,
		dataManagement = t.dataManagement,
		utilityMenu = false,
	}, selector)

	dropdown.holderFrame = holderFrame

	dropdown.menu = wt.CreatePanel({
		parent = UIParent,
		name = dropdown.frame:GetName() .. "Menu",
		label = false,
		position = {
			anchor = "TOP",
			relativeTo = dropdown.holderFrame,
			relativePoint = "BOTTOM",
			offset = { y = 3 }
		},
		visible = false,
		frameStrata = "DIALOG",
		keepInBound = true,
		background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
		border =  { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } },
		size = { w = t.width, h = 12 + min(#t.items, t.scrollThreshold) * dropdown.toggles[1].frame:GetHeight() },
	})

	dropdown.menu:SetClampedToScreen(true)

	dropdown.content = #t.items > t.scrollThreshold and wt.CreateScrollframe({
		parent = dropdown.menu,
		position = { anchor = "CENTER", },
		size = { w = dropdown.menu:GetWidth() - 12, h = dropdown.menu:GetHeight() - 12 },
		scrollSize = { h = dropdown.frame:GetHeight() },
		scrollSpeed = 0.38,
	}) or dropdown.menu

	dropdown.frame:SetParent(dropdown.content)
	wt.SetPosition(dropdown.frame, {
		relativeTo = dropdown.content,
		offset = #t.items <= t.scrollThreshold and { x = 6, y = -6 } or nil
	})

	--| Label

	local title = t.title or name or "Dropdown"

	dropdown.label = t.label ~= false and wt.CreateTitle(dropdown.holderFrame, {
		anchor = "TOP",
		offset = { y = -1, },
		text = title,
		font = "GameFontNormal",
	}) or nil

	--| Toggle button

	local open = false

	dropdown.toggle = wt.CreateCustomButton({
		parent = dropdown.holderFrame,
		name = "Toggle",
		append = t.append,
		title = "…",
		tooltip = { lines = {
			{ text = wt.strings.dropdown.selected, },
			{ text = "\n" .. wt.strings.dropdown.open, },
		} },
		position = { anchor = "BOTTOM", offset = { y = 2 }, },
		size = { w = t.width - (t.cycleButtons ~= false and 46 or 0), h = 24 },
		font = {
			normal = "GameFontNormal",
			highlight = "GameFontHighlight",
			disabled = "GameFontDisable",
		},
		backdrop = {
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
		backdropUpdates = {
			{ rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or (open and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					})
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					if open then return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.6, g = 0.6, b = 0.6, a = 0.9 } }
					} end
					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, _, button)
					if not frame:IsEnabled() or button == "LeftButton" then return {} end

					return (open and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					})
				end,
			}, },
			{
				triggers = { dropdown.holderFrame },
				rules = { OnAttributeChanged = function(frame, _, attribute, state)
					if not frame:IsEnabled() or attribute ~= "open" then return {} end

					if dropdown.toggle.widget:IsMouseOver() then return state and {
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} end
					return {}, true
				end, },
			},
		},
		events = clearable and t.utilityMenu == false and { OnMouseUp = function(_, button, isInside)
			if button == "RightButton" and isInside and dropdown.toggle.widget:IsEnabled() then dropdown.setText(nil, true) end
		end, } or nil,
		dependencies = t.dependencies
	})

	--| Cycle buttons

	local previousDependencies, nextDependencies

	if t.cycleButtons ~= false then

		--| Create a custom fonts

		wt.CreateFont("ChatFontGold", {
			template = "ChatFontNormal",
			color = wt.PackColor(GameFontNormal:GetTextColor()),
		})

		wt.CreateFont("ChatFontDisable", {
			template = "ChatFontNormal",
			color = wt.PackColor(GameFontDisable:GetTextColor()),
		})

		--| Previous item

		previousDependencies = { { frame = dropdown, evaluate = function(value)
			if not value then return true end
			return value > 1
		end }, }

		dropdown.previous = wt.CreateCustomButton({
			parent = dropdown.holderFrame,
			name = "SelectPrevious",
			title = "◄",
			titleOffset = { x = -1, },
			tooltip = {
				title = wt.strings.dropdown.previous.label,
				lines = { { text = wt.strings.dropdown.previous.tooltip, }, },
			},
			position = { anchor = "BOTTOMLEFT", offset = { x = 2, y = 2 }, },
			size = { w = 24, h = 24 },
			font = {
				normal = "ChatFontGold",
				highlight = "ChatFontNormal",
				disabled = "ChatFontDisable",
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function()
				local selected = dropdown.getSelected()

				dropdown.setSelected(selected and selected - 1 or #dropdown.toggles, true)
			end,
			dependencies = previousDependencies
		})

		--| Next item

		nextDependencies = { { frame = dropdown, evaluate = function(value)
			if not value then return true end
			return value < #t.items
		end }, }

		dropdown.next = wt.CreateCustomButton({
			parent = dropdown.holderFrame,
			name = "SelectNext",
			title = "►",
			titleOffset = { x = 1, },
			tooltip = {
				title = wt.strings.dropdown.next.label,
				lines = { { text = wt.strings.dropdown.next.tooltip, }, }
			},
			position = { anchor = "BOTTOMRIGHT", offset = { x = -2, y = 2 }, },
			size = { w = 24, h = 24 },
			font = {
				normal = "ChatFontGold",
				highlight = "ChatFontNormal",
				disabled = "ChatFontDisable",
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function()
				local selected = dropdown.getSelected()

				dropdown.setSelected(selected and selected + 1 or 1, true)
			end,
			dependencies = nextDependencies
		})
	end

	--[ Getters & Setters ]

	function dropdown.getType() return "Selector", "Radiogroup", "DropdownRadiogroup" end
	function dropdown.isType(type) return type == "Selector" or type == "Radiogroup" or type == "DropdownRadiogroup" end

	function dropdown.setText(text, silent)
		local index = dropdown.getSelected()
		local item = t.items[index] or {}
		text = type(text) == "string" and text or item.title or "…"

		dropdown.toggle.label:SetText(text)
		wt.UpdateTooltipData(dropdown.toggle.frame, { title = text, })

		if not silent then dropdown.invoke._("labeled", text) end
	end

	function dropdown.toggleMenu(state)
		if state == nil then open = not dropdown.menu:IsVisible() else open = state end

		wt.SetVisibility(dropdown.menu, open)

		if open then dropdown.menu:RegisterEvent("GLOBAL_MOUSE_DOWN") else dropdown.menu:UnregisterEvent("GLOBAL_MOUSE_UP") end

		dropdown.invoke._("open", open)
	end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then dropdown.holderFrame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else dropdown.holderFrame:HookScript(key, value) end
	end end

	--| UX

	us.SetListener(dropdown.menu, "GLOBAL_MOUSE_DOWN", function(f)
		if dropdown.toggle.widget:IsMouseOver() then return end

		f:UnregisterEvent("GLOBAL_MOUSE_DOWN")
		f:RegisterEvent("GLOBAL_MOUSE_UP")
	end)

	us.SetListener(dropdown.menu, "GLOBAL_MOUSE_UP", function(f, button)
		if (button ~= "LeftButton" and button ~= "RightButton") or f:IsMouseOver() then return end

		dropdown.toggleMenu(false)
	end, false)

	--Handle widget updates
	dropdown.toggle.setListener.triggered(function() dropdown.toggleMenu() end)
	dropdown.setListener.selected(function()
		dropdown.setText()

		if t.autoClose then dropdown.toggleMenu(false) end
	end, 1)
	dropdown.setListener._("open", function(state)
		dropdown.holderFrame:SetAttribute("open", state)
		if not state then PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF) end
	end)
	dropdown.setListener.updated(function(self) self.menu:SetHeight(#self.toggles * 18 + 12) end, 1) --TODO add size & scroll update

	--| Backdrop

	wt.SetBackdrop(dropdown.holderFrame, { background = {
		texture = { size = 5, },
		color = { r = 1, g = 1, b = 1, a = 0 }
	}, }, { {
		triggers = { dropdown.holderFrame, dropdown.toggle.frame, dropdown.previous.frame, dropdown.next.frame, },
		rules = {
			OnEnter = function() return dropdown.isEnabled() and { background = { color = { a = 0.1 } } } or {} end,
			OnLeave = "",
		},
	}, })

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(dropdown.holderFrame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			local default = dropdown.getDefault()
			defaultValue = crc(default and t.items[default].title or tostring(default), "FFFFFFFF")
		end

		wt.AddWidgetTooltipLines({ dropdown.holderFrame, dropdown.toggle.widget, dropdown.previous.widget, dropdown.next.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = dropdown.holderFrame,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.toggle.frame,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.previous.frame,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.next.frame,
				condition = dropdown.isEnabled,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.selection = { index = dropdown.getSelected() } end })
			if clearable then wt.CreateMenuButton(menu, { title = wt.strings.dropdown.clear, action = function() dropdown.setText(nil, true) end }) end
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				dropdown.setSelected(wt.clipboard.selection.index, true)
			end }):SetEnabled(wt.clipboard.selection ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() dropdown.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() dropdown.resetData() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		if dropdown.label then dropdown.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

		dropdown.toggle.setEnabled(state)

		if t.cycleButtons ~= false then
			dropdown.previous.setEnabled(state and wt.CheckDependencies(previousDependencies))
			dropdown.next.setEnabled(state and wt.CheckDependencies(nextDependencies))
		end

		dropdown.menu:Hide()
	end

	dropdown.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, dropdown.isEnabled())

	--Set up starting selection
	dropdown.setText(t.text, true)

	return dropdown
end

function wt.CreateSpecialRadiogroup(itemset, t, selector)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	selector = wt.IsWidget(selector) == "SpecialSelector" and selector or wt.CreateSpecialSelector(itemset, t)

	if WidgetToolsDB.lite and t.lite ~= false then return selector end

	--[ Properties ]

	local showDefault = t.showDefault ~= false
	local utilityMenu = t.utilityMenu ~= false

	---@type specialRadiogroupCreationData|radiogroupCreationData
	t = us.Pull(t or {}, {
		labels = false,
		columns = itemset == "strata" and 8 or 3,
		showDefault = false,
		utilityMenu = false,
	})

	--[ Frame Setup ]

	---@type specialRadiogroup
	local radiogroup = wt.CreateRadiogroup(t, selector)

	--| Tooltip

	if type(t.tooltip) == "table" then
		local defaultValue
		if showDefault then defaultValue = crc(radiogroup.getDefault(), "FFFFFFFF") end

		local frames = { radiogroup.frame }
		for i = 1, #radiogroup.toggles do table.insert(frames, radiogroup.toggles[i].frame) end

		wt.AddWidgetTooltipLines(frames, defaultValue, utilityMenu)
	end

	--| Utility menu

	if utilityMenu then wt.CreateContextMenu({
		triggers = { {
			frame = radiogroup.frame,
			condition = radiogroup.isEnabled,
		}, },
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Selector" })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard[radiogroup.getItemset()] = { value = radiogroup.getSelected() } end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				radiogroup.setSelected(wt.clipboard[radiogroup.getItemset()].value, true)
			end }):SetEnabled(wt.clipboard[radiogroup.getItemset()] ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() radiogroup.revertData() end })
			if showDefault then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() radiogroup.resetData() end }) end
		end
	}) end

	--[ Getters & Setters ]

	function radiogroup.getType() return "SpecialSelector", "SpecialRadiogroup" end
	function radiogroup.isType(type) return type == "SpecialSelector" or type == "SpecialRadiogroup" end

	return radiogroup
end

function wt.CreateCheckgroup(t, selector)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	selector = wt.IsWidget(selector) == "Multiselector" and selector or wt.CreateMultiselector(t)

	if WidgetToolsDB.lite and t.lite ~= false then return selector end

	---@type checkgroup|multiselector
	local checkgroup = selector

	--[ Getters & Setters ]

	function checkgroup.getType() return "Multiselector", "Checkgroup" end
	function checkgroup.isType(type) return type == "Multiselector" or type == "Checkgroup" end

	--[ Frame Setup ]

	--| Shared setup

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Selector")
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Selector"

	setUpSelectorFrame(checkgroup, t, name, title)

	--| Checkbox items

	---Update the lock state of a checkbox item
	---@param item selectorCheckbox
	---@param limited boolean
	local function setLock(item, limited)
		if limited then
			item.setEnabled(false, true)
			item.widget:SetAlpha(0.4)
		elseif checkgroup.isEnabled() then
			item.setEnabled(true, true)
			item.widget:SetAlpha(1)
		end
	end

	---Set up or create new checkbox item
	---@param item selectorToggle|selectorCheckbox|checkbox|radiobutton|toggle
	---@param active boolean
	local function setCheckbox(item, active)
		if active and not item.frame then
			local sameRow = (item.index - 1) % t.columns > 0

			wt.CreateClassicCheckbox({
				parent = checkgroup.frame,
				name = findName(name, item.index),
				title = t.items[item.index].title,
				label = t.labels,
				tooltip = t.items[item.index].tooltip,
				position = {
					relativeTo = item.index ~= 1 and checkgroup.toggles[sameRow and item.index - 1 or item.index - t.columns].frame or checkgroup.label,
					relativePoint = sameRow and "TOPRIGHT" or "BOTTOMLEFT",
					offset = { x = checkgroup.label and item.index == 1 and -4 or 0, y = checkgroup.label and item.index == 1 and -2 or 0}
				},
				size = { w = (t.width and t.columns == 1) and t.width or 160, h = 16 },
				events = { OnClick = function(self) checkgroup.setSelected(item.index, self:GetChecked(), true) end, },
				showDefault = false,
				utilityMenu = false,
			}, item)

			if item.label then item.label:SetIgnoreParentAlpha(true) end

			--Handle limit updates
			checkgroup.setListener.limited(function(_, min, max)
				local state = item.getState()

				setLock(item, (min and state) or (max and not state))
			end, item.index)
		elseif active then
			--Update label
			if item.label then item.label:SetText(t.items[item.index].title) end

			--Update tooltip
			if type(t.items[item.index].tooltip) == "table" then wt.AddTooltip(item.frame, {
				title = type(t.items[item.index].tooltip.title) == "string" and t.items[item.index].tooltip.title or type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle",
				lines = t.items[item.index].tooltip.lines,
				anchor = "ANCHOR_NONE",
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = item.widget,
					relativePoint = "TOPRIGHT",
				},
			}, { triggers = { item.widget, }, }) end
		else wt.SetVisibility(item.frame, false) end
	end

	--Set up starting items
	for i = 1, #checkgroup.toggles do
		setCheckbox(checkgroup.toggles[i], true)

		--Handle item updates
		checkgroup.toggles[i].setListener._("activated", function(self, active) setCheckbox(self, active) end)
	end

	--Handle item list updates
	checkgroup.setListener.updated(function() checkgroup.frame:SetHeight(math.ceil((#checkgroup.toggles) / t.columns) * 16 + (t.label ~= false and 14 or 0)) end, 1)
	checkgroup.setListener.added(function (_, toggle)
		setCheckbox(toggle, true)

		--Handle item updates
		toggle.setListener._("activated", function(self, active) setCheckbox(self, active) end)
	end)

	--[ Events ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(checkgroup.frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			defaultValue = ""
			local default = checkgroup.getDefault()

			for i = 1, #t.items do
				defaultValue = defaultValue .. "\n" .. crc(t.items[i].title, "FFFFFFFF") .. crc(": ", "FF999999") .. crc(
					(default[i] and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), default[i] and "FFAAAAFF" or "FFFFAA66"
				)
			end
		end

		local frames = { checkgroup.frame }
		for i = 1, #checkgroup.toggles do table.insert(frames, checkgroup.toggles[i].frame) end

		wt.AddWidgetTooltipLines(frames, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	local openTriggers = { {
		frame = checkgroup.frame,
		condition = checkgroup.isEnabled,
	}, }

	for i = 1, #checkgroup.toggles do table.insert(openTriggers, {
		frame = checkgroup.toggles[i].widget,
		condition = checkgroup.isEnabled,
	}) end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = openTriggers,
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.selections = { states = checkgroup.getSelections() } end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				checkgroup.setSelections(wt.clipboard.selections.states, true)
			end }):SetEnabled(wt.clipboard.selections ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() checkgroup.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() checkgroup.resetData() end }) end
		end
	}) end

	return checkgroup
end


--[[ TEXTBOX ]]

---Set the parameters of a GUI textbox widget frame
---@param editbox singlelineEditbox|customEditbox|multilineEditbox
---@param t editboxCreationData
local function setUpEditboxFrame(editbox, t)

	--[ Frame Setup ]

	--| Visibility

	wt.SetVisibility(editbox.frame, t.visible ~= false)

	if t.frameStrata then editbox.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then editbox.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then editbox.frame:SetToplevel(t.keepOnTop) end

	--[ Font & Text ]

	t.font = t.font or {}
	t.insets = t.insets or {}
	t.insets = { l = t.insets.l or 0, r = t.insets.r or 0, t = t.insets.t or 0, b = t.insets.b or 0 }

	editbox.widget:SetTextInsets(t.insets.l, t.insets.r, t.insets.t, t.insets.b)

	if t.font.normal then editbox.widget:SetFontObject(t.font.normal) end

	if t.justify then
		if t.justify.h then editbox.widget:SetJustifyH(t.justify.h) end
		if t.justify.v then editbox.widget:SetJustifyV(t.justify.v) end
	end

	if t.charLimit then editbox.widget:SetMaxLetters(t.charLimit) end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then editbox.widget:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnChar" then editbox.widget:SetScript("OnChar", function(self, char) value(self, char, self:GetText()) end)
		elseif key == "OnTextChanged" then editbox.widget:SetScript("OnTextChanged", function(self, user) value(self, self:GetText(), user) end)
		elseif key == "OnEnterPressed" then editbox.widget:SetScript("OnEnterPressed", function(self) value(self, self:GetText()) end)
		else editbox.widget:HookScript(key, value) end
	end end

	--| UX

	local scriptEvent = false

	---Update the widget UI based on the text value
	---@param _ any
	---@param text string
	local function updateText(_, text) if not scriptEvent then
		editbox.widget:SetText(text)

		if t.resetCursor ~= false then editbox.widget:SetCursorPosition(0) end
	else scriptEvent = false end end

	--Handle widget updates
	editbox.setListener.changed(updateText, 1)

	--Link value changes
	editbox.widget:HookScript("OnTextChanged", function(self, user)
		scriptEvent = true

		editbox.setText(self:GetText(), user)
	end)

	editbox.widget:SetAutoFocus(t.keepFocused)

	if t.focusOnShow then editbox.widget:HookScript("OnShow", function(self) self:SetFocus() end) end

	if t.unfocusOnEnter ~= false then editbox.widget:HookScript("OnEnterPressed", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

		self:ClearFocus()
	end) end

	editbox.widget:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)

	editbox.widget:HookScript("OnEnter", function(self) if editbox.isEnabled() and t.font.highlight then self:SetFontObject(t.font.highlight) end end)
	editbox.widget:HookScript("OnLeave", function(self) if editbox.isEnabled() and t.font.normal then self:SetFontObject(t.font.normal) end end)

	--| State

	--Inherit setter
	-- editbox.widget.setEnabled = editbox.setEnabled --CHECK if needed

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		if t.readOnly then editbox.widget:Disable() else editbox.widget:SetEnabled(state) end

		if state then
			if editbox.widget:IsMouseOver() and t.font.highlight then editbox.widget:SetFontObject(t.font.highlight)
			elseif t.font.normal then editbox.widget:SetFontObject(t.font.normal) end
		elseif t.font.disabled then editbox.widget:SetFontObject(t.font.disabled) end

		if editbox.label then editbox.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
	end

	--Handle widget updates
	editbox.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, editbox.isEnabled())

	--Set up starting text
	updateText(nil, editbox.getText())
end

---Set the parameters of a single-line GUI textbox widget frame
---@param editbox singlelineEditbox|customEditbox
---@param title string
---@param t editboxCreationData
local function setUpEditbox(editbox, title, t)
	editbox.widget:SetMultiLine(false)

	--| Position

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(editbox.frame, t.position) end
	wt.SetArrangementDirective(editbox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	editbox.widget:SetPoint("BOTTOMRIGHT")

	--| Shared setup

	setUpEditboxFrame(editbox, t)

	--[ Events ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(editbox.widget, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(editbox.getDefault(), "FF55DD55") end

		wt.AddWidgetTooltipLines({ editbox.frame, editbox.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = { {
			frame = editbox.widget,
			condition = function() return editbox.isEnabled() and not t.readOnly end,
		}, },
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.text = editbox.getText() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				editbox.setText(wt.clipboard.text, true)
			end }):SetEnabled(wt.clipboard.text ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() editbox.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() editbox.resetData() end }) end
		end
	}) end
end

function wt.CreateEditbox(t, textbox)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	textbox = wt.IsWidget(textbox) == "Textbox" and textbox or wt.CreateTextbox(t)

	if WidgetToolsDB.lite and t.lite ~= false then return textbox end

	---@type singlelineEditbox|textbox
	local editbox = textbox

	--[ Getters & Setters ]

	function editbox.getType() return "Textbox", "Editbox" end
	function editbox.isType(type) return type == "Textbox" or type == "Editbox" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Textbox")

	editbox.frame = CreateFrame("Frame", name, t.parent)
	editbox.widget = CreateFrame("EditBox", name .. "EditBox", editbox.frame, "InputBoxTemplate")

	--| Dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 18

	editbox.frame:SetSize(t.size.w, t.size.h + (t.label ~= false and 18 or 0))
	editbox.widget:SetSize(t.size.w - 6, t.size.h - 1)

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Textbox"

	editbox.label = t.label ~= false and wt.CreateTitle(editbox.frame, {
		offset = { x = -1, },
		text = title,
	}) or nil

	--| Shared setup

	setUpEditbox(editbox, title, t)

	return editbox
end

function wt.CreateCustomEditbox(t, textbox)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	textbox = wt.IsWidget(textbox) == "Textbox" and textbox or wt.CreateTextbox(t)

	if WidgetToolsDB.lite and t.lite ~= false then return textbox end

	---@type customEditbox|textbox
	local editbox = textbox

	--[ Getters & Setters ]

	function editbox.getType() return "Textbox", "CustomEditbox" end
	function editbox.isType(type) return type == "Textbox" or type == "CustomEditbox" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Textbox")

	editbox.frame = CreateFrame("Frame", name, t.parent)
	editbox.widget = CreateFrame("EditBox", name .. "EditBox", editbox.frame, BackdropTemplateMixin and "BackdropTemplate")

	--| Dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 18

	editbox.frame:SetSize(t.size.w, t.size.h - (t.label ~= false and -18 or 0))
	editbox.widget:SetSize(t.size.w, t.size.h)

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Textbox"

	editbox.label = t.label ~= false and wt.CreateTitle(editbox.frame, {
		offset = { x = -1, },
		text = title,
	}) or nil

	--| Backdrop

	wt.SetBackdrop(editbox.widget, t.backdrop, t.backdropUpdates)

	--| Shared setup

	setUpEditbox(editbox, title, t)

	--[ Events ]

	--| UX

	editbox.widget:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
	editbox.widget:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)

	return editbox
end

function wt.CreateMultilineEditbox(t, textbox)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	textbox = wt.IsWidget(textbox) == "Textbox" and textbox or wt.CreateTextbox(t)

	if WidgetToolsDB.lite and t.lite ~= false then return textbox end

	---@type multilineEditbox|textbox
	local editbox = textbox

	--[ Getters & Setters ]

	function editbox.getType() return "Textbox", "MultilineEditbox" end
	function editbox.isType(type) return type == "Textbox" or type == "MultilineEditbox" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Textbox")

	editbox.frame = CreateFrame("Frame", name, t.parent)
	editbox.scrollframe = CreateFrame("ScrollFrame", name .. "ScrollFrame", editbox.frame, ScrollControllerMixin and "InputScrollFrameTemplate")
	editbox.widget = editbox.scrollframe.EditBox

	--Set as multiline
	editbox.widget:SetMultiLine(true)

	--| Position & dimensions

	local scrollframeHeight = t.size.h - (t.label ~= false and 28 or 10)
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(editbox.frame, t.position) end
	wt.SetArrangementDirective(editbox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	editbox.scrollframe:SetPoint("BOTTOM", 0, 5)
	wt.SetPosition(editbox.scrollframe.ScrollBar, {
		anchor = "RIGHT",
		relativeTo = editbox.scrollframe,
		relativePoint = "RIGHT",
		offset = { x = -4, y = 0 }
	})

	editbox.frame:SetSize(t.size.w, t.size.h)
	editbox.scrollframe:SetSize(t.size.w - 10, scrollframeHeight)
	editbox.scrollframe.ScrollBar:SetHeight(scrollframeHeight - 4)
	editbox.scrollframe.EditBox:SetWidth(editbox.scrollframe:GetWidth())

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Textbox"

	editbox.label = t.label ~= false and wt.CreateTitle(editbox.frame, {
		offset = { x = 3, },
		text = title,
	}) or nil

	--| Scroll speed

	t.scrollSpeed = t.scrollSpeed or 0.25

	editbox.scrollframe.ScrollBar.SetPanExtentPercentage = function() --WATCH: Change when Blizzard provides a better way to overriding the built-in update function
		local height = editbox.scrollframe:GetHeight()

		editbox.scrollframe.ScrollBar.panExtentPercentage = height * t.scrollSpeed / math.abs(editbox.widget:GetHeight() - height)
	end

	--| Character counter

	editbox.scrollframe.CharCount:SetFontObject("GameFontDisableTiny2")
	if t.charCount == false or (t.charLimit or 0) == 0 then editbox.scrollframe.CharCount:Hide() end

	---@diagnostic disable-next-line: inject-field
	editbox.widget.cursorOffset = 0 --WATCH: Remove when the character counter gets fixed..

	--| Shared setup

	setUpEditboxFrame(editbox, t)

	--[ Events ]

	--| UX

	editbox.widget:HookScript("OnTextChanged", function(_, _, user) if not user and t.scrollToTop then editbox.scrollframe:SetVerticalScroll(0) end end)
	editbox.widget:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
	editbox.widget:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)

	---Update the width of the editbox
	---@param scrolling boolean
	local function resizeEditbox(scrolling)
		local scrollBarOffset = scrolling and (wt.classic and 32 or 16) or 0
		local charCountWidth = t.charCount ~= false and (t.charLimit or 0) > 0 and tostring(t.charLimit - editbox.getText():len()):len() * 6 + 3 or 0

		editbox.widget:SetWidth(editbox.scrollframe:GetWidth() - scrollBarOffset - charCountWidth)

		--Update the character counter
		if editbox.scrollframe.CharCount:IsVisible() and t.charLimit then --WATCH: Remove when the character counter gets fixed..
			editbox.scrollframe.CharCount:SetWidth(charCountWidth)
			editbox.scrollframe.CharCount:SetText(tostring(t.charLimit - editbox.getText():len()))
			editbox.scrollframe.CharCount:SetPoint("BOTTOMRIGHT", editbox.scrollframe, "BOTTOMRIGHT", -scrollBarOffset + 1, 0)
		end
	end

	--Resize updates
	editbox.scrollframe.ScrollBar:HookScript("OnShow", function() resizeEditbox(true) end)
	editbox.scrollframe.ScrollBar:HookScript("OnHide", function() resizeEditbox(false) end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(editbox.scrollframe, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { editbox.frame, editbox.widget }, })

		if t.readOnly ~= true then
			local defaultValue
			if t.showDefault ~= false then defaultValue = crc(editbox.getDefault(), "FF55DD55") end

			wt.AddWidgetTooltipLines({ editbox.scrollframe, editbox.widget }, defaultValue, t.utilityMenu)
		end
	end

	--| Utility menu

	---Utility menu opening condition checker
	---@return boolean
	local function openCondition() return editbox.isEnabled() and not t.readOnly end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = editbox.frame,
				condition = openCondition,
			},
			{
				frame = editbox.widget,
				condition = openCondition,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.text = editbox.getText() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				editbox.setText(wt.clipboard.text, true)
			end }):SetEnabled(wt.clipboard.text ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() editbox.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() editbox.resetData() end }) end
		end
	}) end

	return editbox
end

function wt.CreateCopybox(t)
	t = type(t) == "table" and t or {}
	local text = type(t.value) == "string" and t.value or ""

	--[ Widget ]

	---@class copybox
	local copybox = {}

	--[ GUI ]

	if not WidgetToolsDB.lite or t.lite == false then

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Copybox")

		copybox.frame = CreateFrame("Frame", name, t.parent)

		--| Position & dimensions

		t.size = t.size or {}
		t.size.w = t.size.w or 180
		t.size.h = t.size.h or 18
		local arrange = type(t.arrange) == "table" and t.arrange or {}

		if not t.arrange and t.position then wt.SetPosition(copybox.frame, t.position) end
		wt.SetArrangementDirective(copybox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

		copybox.frame:SetSize(t.size.w, t.size.h + (t.label ~= false and 12 or 0))

		--| Visibility

		wt.SetVisibility(copybox.frame, t.visible ~= false)

		if t.frameStrata then copybox.frame:SetFrameStrata(t.frameStrata) end
		if t.frameLevel then copybox.frame:SetFrameLevel(t.frameLevel) end
		if t.keepOnTop then copybox.frame:SetToplevel(t.keepOnTop) end

		--| Label

		local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Copybox"

		copybox.label = t.label ~= false and wt.CreateTitle(copybox.frame, {
			offset = { x = -1, },
			width = t.size.w,
			text = title,
			font = "GameFontNormal",
		}) or nil

		--| Textbox

		t.font = t.font or "GameFontNormalSmall"
		t.color = t.color or { r = 0.6, g = 0.8, b = 1, a = 1 }
		t.colorOnMouse = t.colorOnMouse or { r = 0.8, g = 0.95, b = 1, a = 1 }

		copybox.textbox = wt.CreateCustomEditbox({
			parent = copybox.frame,
			name = "Textline",
			title = title,
			label = false,
			tooltip = { lines = { { text = wt.strings.copyBox, }, } },
			position = { anchor = "BOTTOMLEFT", },
			size = t.size,
			font = { normal = t.font, disabled = t.font },
			color = t.color,
			justify = { h = t.justify, },
			events = {
				OnTextChanged = function(self, _, user)
					if not user then return end

					self:SetText(cr(text, t.colorOnMouse))
					self:SetCursorPosition(0)
					self:HighlightText()
				end,
				OnEnter = function(self)
					self:SetText(cr(text, t.colorOnMouse))
					self:SetCursorPosition(0)
					self:HighlightText()
					self:SetFocus()
				end,
				OnLeave = function(self)
					self:SetText(cr(text, t.color))
					self:SetCursorPosition(0)
					self:ClearHighlightText()
					self:ClearFocus()
				end,
				OnMouseUp = function(self)
					self:SetCursorPosition(0)
					self:HighlightText()
				end,
			},
			value = text,
			showDefault = false,
			utilityMenu = false,
		})
	end

	return copybox
end


--[[ NUMERIC ]]

function wt.CreateSlider(t, numeric)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	numeric = wt.IsWidget(numeric) == "Numeric" and numeric or wt.CreateNumeric(t)

	if WidgetToolsDB.lite and t.lite ~= false then return numeric end

	---@type customSlider|numeric
	local slider = numeric

	--[ Getters & Setters ]

	function slider.getType() return "Numeric", "Slider" end
	function slider.isType(type) return type == "Numeric" or type == "Slider" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Slider")

	slider.frame = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")
	slider.widget = CreateFrame("Slider", name .. "Frame", slider.frame, "MinimalSliderWithSteppersTemplate")

	--| Position & dimensions

	t.width = t.width or 180
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(slider.frame, t.position) end
	wt.SetArrangementDirective(slider.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	slider.widget:SetPoint("TOP", 0, -8)

	slider.frame:SetSize(t.width, t.valuebox ~= false and 64 or 52)
	slider.widget:SetWidth(t.width)

	--| Visibility

	wt.SetVisibility(slider.frame, t.visible ~= false)

	if t.frameStrata then slider.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then slider.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then slider.frame:SetToplevel(t.keepOnTop) end

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Slider"

	if t.label ~= false then
		slider.widget.TopText:SetPoint("TOP", slider.frame, "TOP", 0, 4)
		slider.widget.TopText:SetText(title)
		slider.widget.TopText:Show()
	end

	slider.widget.MinText:Show()
	slider.widget.MaxText:Show()

	--| Value step

	if t.hardStep ~= false then
		slider.widget.Slider:SetValueStep(slider.getStep())
		slider.widget.Slider:SetObeyStepOnDrag(true)
	end

	--| Decrease button

	wt.AddTooltip(slider.widget.Back, {
		title = wt.strings.slider.decrease.label,
		lines = {
			{ text = wt.strings.slider.decrease.tooltip[1]:gsub("#VALUE", slider.getStep()), },
			slider.getAltStep() and { text = wt.strings.slider.decrease.tooltip[2]:gsub("#VALUE", slider.getAltStep()), } or nil,
		},
		anchor = "ANCHOR_TOPLEFT",
	})

	slider.widget.Back:HookScript("OnClick", function() slider.decrease(IsAltKeyDown(), true) end)

	--| Increase button

	wt.AddTooltip(slider.widget.Forward, {
		title = wt.strings.slider.increase.label,
		lines = {
			{ text = wt.strings.slider.increase.tooltip[1]:gsub("#VALUE", slider.getStep()), },
			slider.getAltStep() and { text = wt.strings.slider.increase.tooltip[2]:gsub("#VALUE", slider.getAltStep()), } or nil,
		},
		anchor = "ANCHOR_TOPLEFT",
	})

	slider.widget.Forward:HookScript("OnClick", function() slider.increase(IsAltKeyDown(), true) end)

	--| Valuebox

	local minValue, maxValue = slider.getMin(), slider.getMax()

	if t.valuebox ~= false then

		--| Calculate the required number of fractal digits, assemble string patterns for value validation

		local decimals = type(t.fractional) == "number" and floor(t.fractional + 0.5) or max(
			(tostring(minValue):match("%.(%d+)") or ""):len(),
			(tostring(maxValue):match("%.(%d+)") or ""):len(),
			(tostring(slider.getStep()):match("%.(%d+)") or ""):len()
		)
		local decimalPattern = ""
		for _ = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end
		local matchPattern = "(" .. (minValue < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
		local replacePattern = "%1" .. (decimals > 0 and "%2" or "")

		--| Frame setup

		slider.valuebox = wt.CreateCustomEditbox({
			parent = slider.frame,
			name = "Valuebox",
			label = false,
			tooltip = {
				title = wt.strings.slider.value.label,
				lines = { { text = wt.strings.slider.value.tooltip, }, }
			},
			position = {
				anchor = "TOP",
				offset = { y = 6 },
				relativeTo = slider.widget.Slider,
				relativePoint = "BOTTOM",
			},
			size = { w = 80, h = 20 },
			font = {
				normal = "GameFontNormalSmall2",
				highlight = "GameFontHighlightSmall2",
				disabled = "GameFontDisableSmall2",
			},
			justify = { h = "CENTER", },
			charLimit = max(tostring(math.floor(slider.getStep())):len(), tostring(math.floor(minValue)):len(), tostring(math.floor(maxValue)):len()) + (decimals > 0 and decimals + 1 or 0),
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 }
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame) return frame:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end,
				OnLeave = "",
			}, }, },
			events = {
				OnChar = function(frame, _, text) frame:SetText(text:gsub(matchPattern, replacePattern)) end,
				OnEnterPressed = function(frame) slider.setNumber(frame:GetNumber(), true) end,
				OnEscapePressed = function(frame) frame:SetText(tostring(us.Round(slider.widget.Slider:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
			},
			value = tostring(slider.getNumber()):gsub(matchPattern, replacePattern),
			showDefault = false,
			utilityMenu = false,
		})

		--| UX

		--Handle widget updates
		slider.setListener.changed(function(_, number) slider.valuebox.setText(tostring(us.Round(number, decimals)):gsub(matchPattern, replacePattern)) end)
	end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then slider.widget.Slider:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else slider.widget.Slider:HookScript(key, value) end
	end end

	--| UX

	local scriptEvent = false

	---Update the widget UI based on the number value
	---***
	---@param _ any
	---@param number number
	---@param user? boolean ***Default:*** `false`
	local function updateNumber(_, number, user) if not scriptEvent then slider.widget.Slider:SetValue(number, user) else scriptEvent = false end end

	---Update the min/max limits of the slider
	---@param limitMin? number
	---@param limitMax? number
	local function updateLimits(limitMin, limitMax)
		if limitMin then slider.widget.MinText:SetText(tostring(limitMin)) else limitMin = slider.getMin() end
		if limitMax then slider.widget.MaxText:SetText(tostring(limitMax)) else limitMax = slider.getMax() end

		slider.widget.Slider:SetMinMaxValues(limitMin, limitMax)
	end

	--Handle widget updates
	slider.setListener.changed(updateNumber, 1)
	slider.setListener.min(function(_, limitMin) updateLimits(limitMin) end, 1)
	slider.setListener.max(function(_, limitMax) updateLimits(nil, limitMax) end, 1)

	--Link value changes
	slider.widget.Slider:HookScript("OnValueChanged", function(_, number, user)
		if not IsMouseButtonDown("LeftButton") then slider.widget.Slider:SetValue(slider.getNumber()) return end

		scriptEvent = true

		slider.setNumber(number, user)
	end)

	--| Backdrop

	wt.SetBackdrop(slider.frame, { background = {
		texture = { size = 5, },
		color = { r = 1, g = 1, b = 1, a = 0 }
	}, }, { {
		triggers = { slider.frame, slider.widget.Slider, slider.widget.Forward, slider.widget.Back, t.valuebox ~= false and slider.valuebox.widget or nil },
		rules = {
			OnEnter = function() return slider.isEnabled() and { background = { color = { a = 0.1 } } } or {} end,
			OnLeave = "",
		},
	}, })

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(slider.widget.Slider, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { slider.frame } })

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(tostring(slider.getDefault()), "FFDDDD55") end

		wt.AddWidgetTooltipLines({ slider.frame, slider.widget.Slider, slider.widget.Back, slider.widget.Forward, slider.valuebox.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = slider.frame,
				condition = slider.isEnabled,
			},
			{
				frame = slider.widget.Slider,
				condition = slider.isEnabled,
			},
			{
				frame = slider.widget.Back,
				condition = slider.isEnabled,
			},
			{
				frame = slider.widget.Forward,
				condition = slider.isEnabled,
			},
			t.valuebox ~= false and {
				frame = slider.valuebox.widget,
				condition = slider.isEnabled,
			} or nil,
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.numeric = slider.getNumber() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				slider.setNumber(wt.clipboard.numeric, true)
			end }):SetEnabled(wt.clipboard.numeric ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() slider.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() slider.resetData() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		slider.widget.Slider:SetEnabled(state)

		slider.widget.TopText:SetFontObject(state and "GameFontNormal" or "GameFontDisable")
		slider.widget.MinText:SetFontObject(state and "GameFontNormalSmall" or "GameFontDisableSmall")
		slider.widget.MaxText:SetFontObject(state and "GameFontNormalSmall" or "GameFontDisableSmall")

		if t.valuebox ~= false then slider.valuebox.setEnabled(state) end

		slider.widget.Back:SetEnabled(state and wt.CheckDependencies({ { frame = slider.widget.Slider, evaluate = function(value) return value > slider.getMin() end }, }))
		slider.widget.Forward:SetEnabled(state and wt.CheckDependencies({ { frame = slider.widget.Slider, evaluate = function(value) return value < slider.getMax() end }, }))
	end

	slider.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, slider.isEnabled())

	--Set up the limits
	updateLimits(minValue, maxValue)

	-- Set up slider value
	updateNumber(nil, slider.getNumber(), false)

	return slider
end

function wt.CreateClassicSlider(t, numeric)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	numeric = wt.IsWidget(numeric) == "Numeric" and numeric or wt.CreateNumeric(t)

	if WidgetToolsDB.lite and t.lite ~= false then return numeric end

	---@type classicSlider|numeric
	local slider = numeric

	--[ Getters & Setters ]

	function slider.getType() return "Numeric", "ClassicSlider" end
	function slider.isType(type) return type == "Numeric" or type == "ClassicSlider" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Slider")

	slider.frame = CreateFrame("Frame", name, t.parent)
	slider.widget = CreateFrame("Slider", name .. "Frame", slider.frame, "OptionsSliderTemplate")

	slider.min = _G[name .. "FrameLow"]
	slider.max = _G[name .. "FrameHigh"]

	--| Position & dimensions

	t.width = t.width or 160
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(slider.frame, t.position) end
	wt.SetArrangementDirective(slider.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	slider.widget:SetPoint("TOP", 0, -15)
	slider.min:SetPoint("TOPLEFT", slider.widget, "BOTTOMLEFT")
	slider.max:SetPoint("TOPRIGHT", slider.widget, "BOTTOMRIGHT")

	slider.frame:SetSize(t.width, t.valuebox ~= false and 48 or 31)
	slider.widget:SetWidth(t.width - (t.sideButtons ~= false and 40 or 0))

	--| Visibility

	wt.SetVisibility(slider.frame, t.visible ~= false)

	if t.frameStrata then slider.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then slider.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then slider.frame:SetToplevel(t.keepOnTop) end

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Slider"

	if t.label ~= false then
		slider.label = _G[name .. "FrameText"]

		slider.label:SetPoint("TOP", slider.frame, "TOP", 0, 2)
		slider.label:SetFontObject("GameFontNormal")

		slider.label:SetText(title)
	else _G[name .. "FrameText"]:Hide() end

	--| Value step

	if t.hardStep ~= false then
		slider.widget:SetValueStep(slider.getStep())
		slider.widget:SetObeyStepOnDrag(true)
	end

	--| Valuebox

	local minValue, maxValue = slider.getMin(), slider.getMax()

	if t.valuebox ~= false then

		--| Calculate the required number of fractal digits, assemble string patterns for value validation
		local decimals = type(t.fractional) == "number" and floor(t.fractional + 0.5) or max(
			(tostring(minValue):match("%.(%d+)") or ""):len(),
			(tostring(maxValue):match("%.(%d+)") or ""):len(),
			(tostring(slider.getStep()):match("%.(%d+)") or ""):len()
		)
		local decimalPattern = ""
		for _ = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end
		local matchPattern = "(" .. (minValue < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
		local replacePattern = "%1" .. (decimals > 0 and "%2" or "")

		--| Frame setup

		slider.valuebox = wt.CreateCustomEditbox({
			parent = slider.frame,
			name = "Valuebox",
			label = false,
			tooltip = {
				title = wt.strings.slider.value.label,
				lines = { { text = wt.strings.slider.value.tooltip, }, }
			},
			position = {
				anchor = "TOP",
				relativeTo = slider.widget,
				relativePoint = "BOTTOM",
			},
			size = { w = 64, },
			font = {
				normal = "GameFontHighlightSmall",
				disabled = "GameFontDisableSmall",
			},
			justify = { h = "CENTER", },
			charLimit = max(tostring(math.floor(slider.getStep())):len(), tostring(math.floor(minValue)):len(), tostring(math.floor(maxValue)):len()) + (decimals > 0 and decimals + 1 or 0),
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 }
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame) return frame:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end,
				OnLeave = "",
			}, }, },
			events = {
				OnChar = function(frame, _, text) frame:SetText(text:gsub(matchPattern, replacePattern)) end,
				OnEnterPressed = function(frame) slider.setNumber(frame:GetNumber(), true) end,
				OnEscapePressed = function(frame) frame:SetText(tostring(us.Round(slider.widget:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
			},
			value = tostring(slider.getNumber()):gsub(matchPattern, replacePattern),
			showDefault = false,
			utilityMenu = false,
		})

		--| UX

		--Handle widget updates
		slider.setListener.changed(function(_, number) slider.valuebox.setText(tostring(us.Round(number, decimals)):gsub(matchPattern, replacePattern)) end)
	end

	--| Side buttons

	if t.sideButtons ~= false then

		--| Decrease

		slider.decreaseButton = wt.CreateCustomButton({
			parent = slider.frame,
			name = "SelectPrevious",
			title = "-",
			tooltip = {
				title = wt.strings.slider.decrease.label,
				lines = {
					{ text = wt.strings.slider.decrease.tooltip[1]:gsub("#VALUE", slider.getStep()), },
					slider.getAltStep() and { text = wt.strings.slider.decrease.tooltip[2]:gsub("#VALUE", slider.getAltStep()), } or nil,
				}
			},
			position = {
				anchor = "LEFT",
				relativeTo = slider.widget,
				relativePoint = "LEFT",
				offset = { x = -21, }
			},
			size = { w = 20, h = 20 },
			font = {
				normal = "GameFontHighlightMedium",
				highlight = "GameFontHighlightMedium",
				disabled = "GameFontDisableMed2"
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function() slider.decrease(IsAltKeyDown(), true) end,
			dependencies = { { frame = slider.widget, evaluate = function(value) return value > slider.getMin() end }, }
		})

		--| Increase

		slider.increaseButton = wt.CreateCustomButton({
			parent = slider.frame,
			name = "SelectNext",
			title = "+",
			tooltip = {
				title = wt.strings.slider.increase.label,
				lines = {
					{ text = wt.strings.slider.increase.tooltip[1]:gsub("#VALUE", slider.getStep()), },
					slider.getAltStep() and { text = wt.strings.slider.increase.tooltip[2]:gsub("#VALUE", slider.getAltStep()), } or nil,
				}
			},
			position = {
				anchor = "RIGHT",
				relativeTo = slider.widget,
				relativePoint = "RIGHT",
				offset = { x = 21, }
			},
			size = { w = 20, h = 20 },
			font = {
				normal = "GameFontHighlightMedium",
				highlight = "GameFontHighlightMedium",
				disabled = "GameFontDisableMed2",
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function() slider.increase(IsAltKeyDown(), true) end,
			dependencies = { { frame = slider.widget, evaluate = function(value) return value < slider.getMax() end }, }
		})
	end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then slider.widget:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else slider.widget:HookScript(key, value) end
	end end

	--| UX

	local scriptEvent = false

	---Update the widget UI based on the number value
	---***
	---@param _ any
	---@param number number
	---@param user? boolean ***Default:*** `false`
	local function updateNumber(_, number, user) if not scriptEvent then slider.widget:SetValue(number, user) else scriptEvent = false end end

	---Update the min/max limits of the slider
	---@param limitMin? number
	---@param limitMax? number
	local function updateLimits(limitMin, limitMax)
		if limitMin then slider.min:SetText(tostring(limitMin)) else limitMin = slider.getMin() end
		if limitMax then slider.max:SetText(tostring(limitMax)) else limitMax = slider.getMax() end

		slider.widget:SetMinMaxValues(limitMin, limitMax)
	end

	--Handle widget updates
	slider.setListener.changed(updateNumber, 1)
	slider.setListener.min(function(_, limitMin) updateLimits(limitMin) end, 1)
	slider.setListener.max(function(_, limitMax) updateLimits(nil, limitMax) end, 1)

	--Link value changes
	slider.widget:HookScript("OnValueChanged", function(_, number, user)
		scriptEvent = true

		slider.setNumber(number, user)

		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(slider.widget, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { slider.frame } })

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(tostring(slider.getDefault()), "FFDDDD55") end

		wt.AddWidgetTooltipLines({ slider.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = { {
			frame = slider.frame,
			condition = slider.isEnabled,
		}, },
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.numeric = slider.getNumber() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				slider.setNumber(wt.clipboard.numeric, true)
			end }):SetEnabled(wt.clipboard.numeric ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() slider.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() slider.resetData() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		slider.widget:SetEnabled(state)

		if slider.label then slider.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

		if t.valuebox ~= false then slider.valuebox.setEnabled(state) end

		if t.sideButtons ~= false then
			slider.decreaseButton.setEnabled(state and wt.CheckDependencies({ { frame = slider.widget, evaluate = function(value) return value > slider.getMin() end }, }))
			slider.increaseButton.setEnabled(state and wt.CheckDependencies({ { frame = slider.widget, evaluate = function(value) return value < slider.getMax() end }, }))
		end
	end

	slider.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, slider.isEnabled())

	--Set up the limits
	updateLimits(minValue, maxValue)

	--Set up slider value
	updateNumber(nil, slider.getNumber(), false)

	return slider
end


--[[ COLOR DATA ]]

function wt.CreateColorpicker(t, colormanager)
	t = type(t) == "table" and t or {}

	--[ Widget ]

	colormanager = wt.IsWidget(colormanager) == "Colorpicker" and colormanager or wt.CreateColormanager(t)

	if WidgetToolsDB.lite and t.lite ~= false then return colormanager end

	---@type colorpicker|colormanager
	local colorpicker = colormanager

	--[ Getters & Setters ]

	function colorpicker.getType() return "Colormanager", "Colorpicker" end
	function colorpicker.isType(type) return type == "Colormanager" or type == "Colorpicker" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Colorpicker")

	colorpicker.frame = CreateFrame("Frame", name, t.parent)

	--| Position & dimensions

	t.width = t.width or 120
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(colorpicker.frame, t.position) end
	wt.SetArrangementDirective(colorpicker.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	colorpicker.frame:SetSize(t.width, 36)

	--| Visibility

	wt.SetVisibility(colorpicker.frame, t.visible ~= false)

	if t.frameStrata then colorpicker.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then colorpicker.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then colorpicker.frame:SetToplevel(t.keepOnTop) end

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Colorpicker"

	colorpicker.label = t.label ~= false and wt.CreateTitle(colorpicker.frame, {
		offset = { x = 4, },
		text = title,
	}) or nil

	--| Color wheel toggle button

	---Toggle the interactability of the color picker elements when [ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame) is opened
	---@param unlocked boolean
	local function setLock(unlocked)
		colorpicker.button.widget:EnableMouse(unlocked)
		colorpicker.hexBox.widget:EnableMouse(unlocked)

		--| Fade inactive color pickers

		local opacity = (unlocked or colorpicker.isActive()) and 1 or 0.4

		colorpicker.label:SetAlpha(opacity)
		colorpicker.hexBox.widget:SetAlpha(opacity)
	end

	if not t.value and t.getData then t.value = us.Clone(t.getData()) else t.value = {} end

	colorpicker.button = wt.CreateCustomButton({
		parent = colorpicker.frame,
		name = "PickerButton",
		label = false,
		tooltip = {
			title = wt.strings.color.picker.label,
			lines = { { text = wt.strings.color.picker.tooltip:gsub("#ALPHA", t.value.a and wt.strings.color.picker.alpha or ""), }, }
		},
		position = { offset = { y = -14 } },
		size = { w = 34, h = 22 },
		action = colormanager.openColorPicker,
		backdrop = {
			background = {
				texture = {
					size = 5,
					insets = { l = 2.5, r = 2.5, t = 2.5, b = 2.5 },
				},
				color = { r = t.value.r or 1, g = t.value.g or 1, b = t.value.b or 1, a = t.value.a or 1 }
			},
			border = {
				texture = { width = 11, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
			}
		},
		backdropUpdates = { { rules = {
			OnEnter = function(frame)
				if not frame:IsEnabled() then return {} end

				return IsMouseButtonDown() and {
					border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
				} or {
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				}
			end,
			OnLeave = function(frame)
				if not frame:IsEnabled() then return {} end

				return { border = { color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 } } }
			end,
			OnMouseDown = function(frame)
				if not frame:IsEnabled() then return {} end

				return { border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } } }
			end,
			OnMouseUp = function(frame, self)
				if not frame:IsEnabled() then return {} end

				return self:IsMouseOver() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {}
			end,
		}, }, },
	})

	colorpicker.button.gradient = wt.CreateTexture(colorpicker.button.widget, {
		name = "ColorGradient",
		position = { offset = { x = 2.5, y = -2.5 } },
		size = { w = 17, h = 17 },
		path = rs.textures.gradientBG,
		layer = "BACKGROUND",
		level = -7,
	})

	colorpicker.button.checker = wt.CreateTexture(colorpicker.button.widget, {
		name = "AlphaBG",
		position = { offset = { x = 2.5, y = -2.5 } },
		size = { w = 29, h = 17 },
		path = rs.textures.alphaBG,
		layer = "BACKGROUND",
		level = -8,
		tile = { h = true, v = true },
		wrap = { h = true, v = true },
	})

	--| HEX textbox

	colorpicker.hexBox = wt.CreateCustomEditbox({
		parent = colorpicker.frame,
		name = "HEXBox",
		title = wt.strings.color.hex.label,
		label = false,
		tooltip = { lines = { {
			text = wt.strings.color.hex.tooltip .. "\n\n" .. crc(wt.strings.example .. ": ", "FF66FF66") .. crc(
				"#2266BB" .. (t.value.a and "AA" or ""), "FFFFFFFF"
			),
		}, } },
		position = {
			relativeTo = colorpicker.button.widget,
			relativePoint = "TOPRIGHT",
		},
		size = { w = t.width - colorpicker.button.widget:GetWidth(), h = colorpicker.button.widget:GetHeight() },
		insets = { l = 6, },
		font = {
			normal = "GameFontNormalSmall2",
			highlight = "GameFontHighlightSmall2",
			disabled = "GameFontDisableSmall2",
		},
		charLimit = 7 + (t.value.a and 2 or 0),
		backdrop = {
			background = {
				texture = {
					size = 5,
					insets = { l = 3, r = 3, t = 3, b = 3 },
				},
				color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 }
			},
			border = {
				texture = { width = 12, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
			}
		},
		backdropUpdates = { { rules = {
			OnEnter = function(frame) return frame:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end,
			OnLeave = "",
		}, }, },
		events = {
			OnChar = function(frame, _, text) frame:SetText(text:gsub("^(#?)([%x]*).*", "%1%2"), false) end,
			OnEnterPressed = function(_, text) colorpicker.setColor(wt.PackColor(wt.HexToColor(text)), true) end,
			OnEscapePressed = function(self) self.setText(wt.ColorToHex(colorpicker.getColor())) end,
		},
		showDefault = false,
		utilityMenu = false,
	})

	--| RGBA textboxes

	--ADD textboxes

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then colorpicker.frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else colorpicker.frame:HookScript(key, value) end
	end end

	--| UX

	---Update the widget UI based on the color value
	---@param color color|colorRGBA
	local function updateColor(color)
		colorpicker.button.widget:SetBackdropColor(color.r, color.g, color.b, color.a)
		colorpicker.button.gradient:SetVertexColor(color.r, color.g, color.b, 1)
		colorpicker.hexBox.setText(wt.ColorToHex(color))
	end

	--Handle widget updates
	colorpicker.setListener.colored(function(_, color) updateColor(color) end)

	--Color wheel toggle updates
	ColorPickerFrame:HookScript("OnShow", function() setLock(false) end)
	ColorPickerFrame:HookScript("OnHide", function() setLock(true) end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(colorpicker.frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			local default = colorpicker.getDefault()
			local r, g, b = wt.UnpackColor(default)

			local texture = "|TInterface/ChatFrame/ChatFrameBackground:12:12:0:0:16:16:0:16:0:16:" .. (r * 255) .. ":" .. (g * 255) .. ":" .. (b * 255) .. "|t "
			defaultValue = texture .. crc(wt.ColorToHex(default), "FFFFFFFF")
		end

		wt.AddWidgetTooltipLines({ colorpicker.frame, colorpicker.button.widget, colorpicker.hexBox.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	---Utility menu opening condition checker
	---@return boolean
	local function openCondition() return colorpicker.isEnabled() and not ColorPickerFrame:IsVisible() end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = colorpicker.frame,
				condition = openCondition,
			},
			{
				frame = colorpicker.button.frame,
				condition = openCondition,
			},
			{
				frame = colorpicker.hexBox.widget,
				condition = openCondition,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.color = colorpicker.getColor() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				colorpicker.setColor(wt.clipboard.color, true)
			end }):SetEnabled(wt.clipboard.color ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() colorpicker.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() colorpicker.resetData() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		colorpicker.button.setEnabled(state)
		colorpicker.hexBox.setEnabled(state)

		if colorpicker.label then colorpicker.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

		if ColorPickerFrame:IsVisible() then setLock(false) end
	end

	colorpicker.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, colorpicker.isEnabled())

	--Set up coloring
	updateColor(colorpicker.getColor())

	return colorpicker
end


--[[ POSITION DATA ]]

local positioningVisualAids = {}

function wt.CreatePositionOptions(addon, frame, getData, defaultData, settingsData, t)
	if not addon or not C_AddOns.IsAddOnLoaded(addon) or not us.IsFrame(frame) or type(t) ~= "table" then return end

	if type(t.name) ~= "string" then t.name = frame:GetName() end
	t.dataManagement = t.dataManagement or {}
	t.dataManagement.category = t.dataManagement.category or addon
	t.dataManagement.key = t.dataManagement.key or "Position"

	--[ Widget ] --TODO separate logical core

	---@type positionPanel
	---@diagnostic disable-next-line: missing-fields --NOTE: Added later --REMOVE after the logical core is separated
	local panel = { widgets = {}, }

	--[ Getters & Setters ]

	function panel.getType() return "PositionOptions" end
	function panel.isType(type) return type == "PositionOptions" end

	--[ Visual Aids ]

	if WidgetToolsDB.positioningAids then
		positioningVisualAids.frame = positioningVisualAids.frame or wt.CreateFrame({
			name = "WidgetToolsPositioningVisualAids",
			position = { anchor = "CENTER", },
			size = { w = GetScreenWidth() - 14, h = GetScreenHeight() - 14 },
			visible = false,
			frameStrata = "BACKGROUND",
			initialize = function(container)

				--[ Textures ]

				positioningVisualAids.anchor = positioningVisualAids.anchor or wt.CreateTexture(container, {
					name = "Anchor",
					size = { w = 14, h = 14 },
					path = wt.classic and "Interface/CharacterFrame/TempPortraitAlphaMask" or "Interface/Common/common-mask-diamond",
				})

				positioningVisualAids.relativePoint = positioningVisualAids.relativePoint or wt.CreateTexture(container, {
					name = "RelativePoint",
					size = { w = 14, h = 14 },
					path = not wt.classic and "Interface/Common/common-iconmask" or nil,
				})

				positioningVisualAids.line = positioningVisualAids.line or wt.CreateLine(container, {
					name = "Line",
					startPosition = {
						relativeTo = positioningVisualAids.anchor,
						relativePoint = "CENTER"
					},
					endPosition = {
						relativeTo = positioningVisualAids.relativePoint,
						relativePoint = "CENTER"
					},
					thickness = 2,
					color = { r = 1, g = 1, b = 1, a = 1 }
				})

				--[ Utilities ]

				---Update the visual aid positions
				---@param target AnyFrameObject
				---@param position positionData_base
				function positioningVisualAids.update(target, position)
					--Anchor
					wt.SetPosition(positioningVisualAids.anchor, {
						anchor = "CENTER",
						relativeTo = target,
						relativePoint = position.anchor,
					})

					--Relative Point
					wt.SetPosition(positioningVisualAids.relativePoint, {
						anchor = "CENTER",
						relativeTo = positioningVisualAids.frame,
						relativePoint = position.relativePoint,
					})
				end

				---Show the positioning visual aids for the specified target frame
				---@param target AnyFrameObject
				---@param position positionData_base
				function positioningVisualAids.show(target, position)
					positioningVisualAids.frame:Show()

					--Dimensions
					positioningVisualAids.frame:SetSize(GetScreenWidth() - 14, GetScreenHeight() - 14)
					positioningVisualAids.frame:SetScale(UIParent:GetScale())

					--Points
					positioningVisualAids.update(target, position)
				end
			end
		})

		--[ Toggle ]

		if not WidgetToolsDB.lite then
			t.canvas:HookScript("OnShow", function() positioningVisualAids.show(frame, getData().position) end)
			t.canvas:HookScript("OnHide", function() positioningVisualAids.frame:Hide() end)
		end

		--[ Update Size ]

		us.SetListener(positioningVisualAids.frame, "UI_SCALE_CHANGED", function(f)
			f:SetSize(GetScreenWidth() - 14, GetScreenHeight() - 14)
			f:SetScale(UIParent:GetScale())
		end)
	end

	--[ Options Panel ]

	panel.frame = wt.CreatePanel({
		parent = t.canvas,
		name = "Position",
		title = wt.strings.position.title,
		description = wt.strings.position.description[t.setMovable and "movable" or "static"]:gsub("#FRAME", t.name),
		arrange = {},
		arrangement = {},
		initialize = function(panelFrame)

			--[ Presets ]

			if t.presets then
				panel.widgets.presets = {}
				panel.presets = t.presets.items

				--| Utilities

				local applyPreset = function(_, i)
					if type(panel.presets[i]) ~= "table" or type(panel.presets[i].data) ~= "table" then
						--Call the specified handler
						if type(t.presets.onPreset) == "function" then t.presets.onPreset(panel.presets[i], i) end

						return
					end

					--Position
					if type(panel.presets[i].data.position) == "table" then
						--Update the frame
						wt.SetPosition(frame, panel.presets[i].data.position, true)

						--Update the storage
						us.CopyValues(getData().position, wt.PackPosition(frame:GetPoint()))

						--Update the settings widgets
						panel.widgets.position.anchor.loadData(false)
						panel.widgets.position.relativePoint.loadData(false)
						-- panel.widgets.position.relativeTo.loadData(false)
						panel.widgets.position.offset.x.loadData(false)
						panel.widgets.position.offset.y.loadData(false)
					end

					--Keep in bounds
					if panel.presets[i].data.keepInBounds ~= nil then
						frame:SetClampedToScreen(panel.presets[i].data.keepInBounds) --Update the frame
						getData().keepInBounds = panel.presets[i].data.keepInBounds --Update the storage
						if panel.widgets.position.keepInBounds then panel.widgets.position.keepInBounds.loadData(false) end --Update the settings widget
					end

					--Screen Layer
					if type(panel.presets[i].data.layer) == "table" then
						--Frame strata
						if panel.presets[i].data.layer.strata then
							frame:SetFrameStrata(panel.presets[i].data.layer.strata) --Update the frame
							getData().layer.strata = panel.presets[i].data.layer.strata --Update the storage
							if panel.widgets.layer.strata then panel.widgets.layer.strata.loadData(false) end --Update the settings widget
						end

						--Keep on top
						if panel.presets[i].data.layer.keepOnTop ~= nil then
							frame:SetToplevel(panel.presets[i].data.layer.keepOnTop) --Update the frame
							getData().layer.keepOnTop = panel.presets[i].data.layer.keepOnTop --Update the storage
							if panel.widgets.layer.keepOnTop then panel.widgets.layer.keepOnTop.loadData(false) end --Update the settings widget
						end

						--Frame level
						if panel.presets[i].data.layer.level then
							frame:SetFrameLevel(panel.presets[i].data.layer.level) --Update the frame
							getData().layer.level = panel.presets[i].data.layer.level --Update the storage
							if panel.widgets.layer.level then panel.widgets.layer.level.loadData(false) end --Update the settings widget
						end
					end

					--Update the positioning visual aids
					if WidgetToolsDB.positioningAids then positioningVisualAids.update(frame, getData().position) end

					--Call the specified handler
					if type(t.presets.onPreset) == "function" then t.presets.onPreset(panel.presets[i], i) end
				end

				function panel.applyPreset(i)
					if not i or i < 1 or i > #panel.presets then return false end

					--Apply the preset data to the frame & update the settings widgets
					applyPreset(nil, i)

					return true
				end

				--| Options widgets

				panel.widgets.presets.applyButton, panel.widgets.presets.applyMenu = wt.CreatePopupMenu({
					parent = panelFrame,
					name = "ApplyPreset",
					title = wt.strings.presets.apply.label,
					tooltip = { lines = { { text = wt.strings.presets.apply.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = {},
					initialize = function(menu)
						wt.CreateMenuTextline(menu, { text = wt.strings.presets.apply.select, })

						for i = 1, #panel.presets do wt.CreateMenuButton(menu, {
							title = panel.presets[i].title,
							action = function() panel.applyPreset(i) end,
						}) end
					end,
				})

				--[ Custom Preset ]

				if t.presets.custom then
					t.presets.custom.index = t.presets.custom.index or 1
					t.presets.items[t.presets.custom.index].data = t.presets.custom.getData()

					--| Utilities

					function panel.saveCustomPreset()
						--Update the custom preset
						panel.presets[t.presets.custom.index].data.position = wt.PackPosition(frame:GetPoint())
						if panel.presets[t.presets.custom.index].data.keepInBounds then
							panel.presets[t.presets.custom.index].data.keepInBounds = frame:IsClampedToScreen()
						end
						if (panel.presets[t.presets.custom.index].data.layer or {}).strata then
							panel.presets[t.presets.custom.index].data.layer.strata = frame:GetFrameStrata()
						end
						if (panel.presets[t.presets.custom.index].data.layer or {}).keepOnTop then
							panel.presets[t.presets.custom.index].data.layer.keepOnTop = frame:IsToplevel()
						end
						if (panel.presets[t.presets.custom.index].data.layer or {}).level then
							panel.presets[t.presets.custom.index].data.layer.level = frame:GetFrameLevel()
						end

						--Save the custom preset
						us.CopyValues(t.presets.custom.getData(), panel.presets[t.presets.custom.index].data)
						if t.presets.custom.getData() then us.CopyValues(t.presets.custom.getData(), t.presets.custom.getData()) end

						--Call the specified handler
						if t.presets.custom.onSave then t.presets.custom.onSave() end
					end

					function panel.resetCustomPreset()
						--Reset the custom preset
						panel.presets[t.presets.custom.index].data = us.Clone(t.presets.custom.defaultsTable)

						--Save the custom preset
						us.CopyValues(t.presets.custom.getData(), panel.presets[t.presets.custom.index].data)
						if t.presets.custom.getData() then us.CopyValues(t.presets.custom.getData(), t.presets.custom.getData()) end

						--Call the specified handler
						if t.presets.custom.onReset then t.presets.custom.onReset() end

						--Apply the custom preset
						panel.applyPreset(t.presets.custom.index)
					end

					--| Options Widgets

					local savePopup = wt.RegisterPopupDialog(addon .. "_SAVE_PRESET", {
						text = wt.strings.presets.save.warning:gsub("#CUSTOM", cr(panel.presets[t.presets.custom.index].title, NORMAL_FONT_COLOR)),
						accept = wt.strings.override,
						onAccept = panel.saveCustomPreset,
					})

					panel.widgets.presets.save = wt.CreateButton({
						parent = panelFrame,
						name = "SavePreset",
						title = wt.strings.presets.save.label:gsub("#CUSTOM", panel.presets[t.presets.custom.index].title),
						tooltip = { lines = {
							{ text = wt.strings.presets.save.tooltip:gsub("#FRAME", t.name):gsub("#CUSTOM", panel.presets[t.presets.custom.index].title), },
						} },
						arrange = { wrap = false, },
						size = { w = 170, h = 26 },
						action = function() StaticPopup_Show(savePopup) end,
						dependencies = t.dependencies
					})

					local resetPopup = wt.RegisterPopupDialog(addon .. "_RESET_PRESET_" .. panelFrame:GetName(), {
						text = wt.strings.presets.reset.warning:gsub("#CUSTOM", cr(panel.presets[t.presets.custom.index].title, NORMAL_FONT_COLOR)),
						accept = wt.strings.override,
						onAccept = panel.resetCustomPreset,
					})

					panel.widgets.presets.reset = wt.CreateButton({
						parent = panelFrame,
						name = "ResetPreset",
						title = wt.strings.presets.reset.label:gsub("#CUSTOM", panel.presets[t.presets.custom.index].title),
						tooltip = { lines = { { text = wt.strings.presets.reset.tooltip:gsub("#CUSTOM", panel.presets[t.presets.custom.index].title), }, } },
						arrange = { wrap = false, },
						size = { w = 170, h = 26 },
						action = function() StaticPopup_Show(resetPopup) end,
					})
				end
			end

			--[ Position ]

			panel.widgets.position = { offset = {}, }

			--| Options widgets

			panel.widgets.position.relativePoint = wt.CreateSpecialRadiogroup("anchor", {
				parent = panelFrame,
				name = "RelativePoint",
				title = wt.strings.position.relativePoint.label,
				tooltip = { lines = { { text = wt.strings.position.relativePoint.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = {},
				width = 140,
				dependencies = t.dependencies,
				getData = function() return getData().position.relativePoint end,
				saveData = function(value) getData().position.relativePoint = value end,
				default = defaultData.position.relativePoint,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					onChange = {
						CustomPositionChangeHandler = function() if type(t.onChangePosition) == "function" then t.onChangePosition() end end,
						UpdateFramePosition = function() wt.SetPosition(frame, getData().position, true) end,
						UpdatePositioningVisualAids = function() if WidgetToolsDB.positioningAids then positioningVisualAids.update(frame, getData().position) end end,
					},
				},
			})

			panel.widgets.position.anchor = wt.CreateSpecialRadiogroup("anchor", {
				parent = panelFrame,
				name = "AnchorPoint",
				title = wt.strings.position.anchor.label,
				tooltip = { lines = { { text = wt.strings.position.anchor.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = { wrap = false, },
				width = 140,
				dependencies = t.dependencies,
				getData = function() return getData().position.anchor end,
				saveData = function(value) getData().position.anchor = value end,
				default = defaultData.position.anchor,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					index = 1,
					onChange = {
						"CustomPositionChangeHandler",
						UpdateFrameOffsetsAndPosition = function() if not settingsData.keepInPlace then wt.SetPosition(frame, getData().position, true) else
							local x, y = wt.SetAnchor(frame, getData().position.anchor)

							--Update offsets
							panel.widgets.position.offset.x.setData(x, false)
							panel.widgets.position.offset.y.setData(y, false)
						end end,
						"UpdatePositioningVisualAids"
					},
				},
			})

			panel.widgets.position.keepInPlace = wt.CreateCheckbox({
				parent = panelFrame,
				name = "KeepInPlace",
				title = wt.strings.position.keepInPlace.label,
				tooltip = { lines = { { text = wt.strings.position.keepInPlace.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = { wrap = false, },
				dependencies = t.dependencies,
				getData = function() return settingsData.keepInPlace end,
				saveData = function(state) settingsData.keepInPlace = state end,
				default = true,
				showDefault = false,
				utilityMenu = false,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
				},
			})

			panel.widgets.position.offset.x = wt.CreateSlider({
				parent = panelFrame,
				name = "OffsetX",
				title = wt.strings.position.offsetX.label,
				tooltip = { lines = { { text = wt.strings.position.offsetX.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = {},
				min = -500,
				max = 500,
				fractional = 2,
				step = 1,
				altStep = 25,
				hardStep = false,
				dependencies = t.dependencies,
				getData = function() return getData().position.offset.x end,
				saveData = function(value) getData().position.offset.x = value end,
				default = defaultData.position.offset.x,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					index = 3,
					onChange = {
						"CustomPositionChangeHandler",
						"UpdateFramePosition",
					},
				},
			})

			panel.widgets.position.offset.y = wt.CreateSlider({
				parent = panelFrame,
				name = "OffsetY",
				title = wt.strings.position.offsetY.label,
				tooltip = { lines = { { text = wt.strings.position.offsetY.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = { wrap = false, },
				min = -500,
				max = 500,
				fractional = 2,
				step = 1,
				altStep = 25,
				hardStep = false,
				dependencies = t.dependencies,
				getData = function() return getData().position.offset.y end,
				saveData = function(value) getData().position.offset.y = value end,
				default = defaultData.position.offset.y,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					index = 4,
					onChange = {
						"CustomPositionChangeHandler",
						"UpdateFramePosition",
					},
				},
			})

			if getData().keepInBounds ~= nil then panel.widgets.position.keepInBounds = wt.CreateCheckbox({
				parent = panelFrame,
				name = "KeepInBounds",
				title = wt.strings.position.keepInBounds.label,
				tooltip = { lines = { { text = wt.strings.position.keepInBounds.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = { wrap = false, },
				dependencies = t.dependencies,
				getData = function() return getData().keepInBounds end,
				saveData = function(state) getData().keepInBounds = state end,
				default = defaultData.keepInBounds,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					onChange = {
						CustomKeepInBoundsChangeHandler = function() if type(t.onChangeKeepInBounds) == "function" then t.onChangeKeepInBounds() end end,
						UpdateScreenClamp = function() frame:SetClampedToScreen(getData().keepInBounds) end,
					},
				},
			}) end

			--[ Screen Layer ]

			if getData().layer and next(getData().layer) then
				panel.widgets.layer = {}

				--| Options widgets

				if getData().layer.strata then panel.widgets.layer.strata = wt.CreateSpecialRadiogroup("strata", {
					parent = panelFrame,
					name = "FrameStrata",
					title = wt.strings.layer.strata.label,
					tooltip = { lines = { { text = wt.strings.layer.strata.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = {},
					width = 140,
					dependencies = t.dependencies,
					getData = function() return getData().layer.strata end,
					saveData = function(value) getData().layer.strata = value end,
					default = defaultData.layer.strata,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomStrataChangeHandler = function() if type(t.onChangeStrata) == "function" then t.onChangeStrata() end end,
							UpdateFrameStrata = function() frame:SetFrameStrata(getData().layer.strata) end,
						},
					},
				}) end

				if getData().layer.keepOnTop ~= nil then panel.widgets.layer.keepOnTop = wt.CreateCheckbox({
					parent = panelFrame,
					name = "KeepOnTop",
					title = wt.strings.layer.keepOnTop.label,
					tooltip = { lines = { { text = wt.strings.layer.keepOnTop.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = { wrap = false, },
					dependencies = t.dependencies,
					getData = function() return getData().layer.keepOnTop end,
					saveData = function(state) getData().layer.keepOnTop = state end,
					default = defaultData.layer.keepOnTop,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomKeepOnTopChangeHandler = function() if type(t.onChangeKeepOnTop) == "function" then t.onChangeKeepOnTop() end end,
							UpdateTopLevel = function() frame:SetToplevel(getData().layer.keepOnTop) end,
						},
					},
				}) end

				if getData().layer.level then panel.widgets.layer.level = wt.CreateSlider({
					parent = panelFrame,
					name = "FrameLevel",
					title = wt.strings.layer.level.label,
					tooltip = { lines = { { text = wt.strings.layer.level.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = { wrap = false, },
					min = 0,
					max = 10000,
					step = 1,
					altStep = 100,
					dependencies = t.dependencies,
					getData = function() return getData().layer.level end,
					saveData = function(value) getData().layer.level = value end,
					default = defaultData.layer.level,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomLevelChangeHandler = function() if type(t.onChangeLevel) == "function" then t.onChangeLevel() end end,
							UpdateFrameLevel = function() frame:SetFrameLevel(getData().layer.level) end,
						},
					},
				}) end
			end
		end,
	})

	--[ Movability ]

	if t.setMovable and type(t.setMovable) == "table" then
		t.setMovable.events = t.setMovable.events or {}

		wt.SetMovability(frame, true, {
			modifier = t.setMovable.modifier or "SHIFT",
			triggers = t.setMovable.triggers,
			events = {
				onStart = t.setMovable.events.onStart,
				onMove = t.setMovable.events.onMove,
				onStop = function()
					--Update the storage
					us.CopyValues(getData().position, wt.PackPosition(frame:GetPoint()))

					--Update the settings widgets
					panel.widgets.position.anchor.loadData(false)
					panel.widgets.position.relativePoint.loadData(false)
					-- panel.widgets.position.relativeTo.loadData(false)
					panel.widgets.position.offset.x.loadData(false)
					panel.widgets.position.offset.y.loadData(false)

					--Update the positioning visual aids
					if WidgetToolsDB.positioningAids then positioningVisualAids.update(frame, getData().position) end

					--Call the specified handler
					if t.setMovable.events.onStop then t.setMovable.events.onStop() end
				end,
				onCancel = function()
					--Reset the position
					wt.SetPosition(frame, getData().position, true)

					--Call the specified handler
					if t.setMovable.events.onCancel then t.setMovable.events.onCancel() end
				end
			}
		})
	end

	return panel
end


--[[ FONT DATA ]]

local fonts, fontItems

function wt.CreateFontOptions(addon, textline, getData, defaultData, t)
	if not addon or not C_AddOns.IsAddOnLoaded(addon) or type(textline) ~= "table" or type(textline.GetFont) ~= "function" or type(t) ~= "table" then return end

	if type(t.name) ~= "string" then t.name = textline:GetName() end
	t.dataManagement = t.dataManagement or {}
	t.dataManagement.category = t.dataManagement.category or addon
	t.dataManagement.key = t.dataManagement.key or "Font"

	--[ Widget ] --TODO separate logical core

	---@type fontPanel
	---@diagnostic disable-next-line: missing-fields --NOTE: Added later --REMOVE after the logical core is separated
	local panel = { widgets = {}, }

	--[ Getters & Setters ]

	function panel.getType() return "FontOptions" end
	function panel.isType(type) return type == "FontOptions" end

	--[ Options Panel ]

	panel.frame = wt.CreatePanel({
		parent = t.canvas,
		name = "Font",
		title = wt.strings.font.title,
		arrange = {},
		arrangement = {},
		initialize = function(panelFrame)
			local widgetCount = 0

			--| Font family

			if not fonts or not fontItems then
				fontItems = {}

				--| Add base fonts

				fonts = us.Clone(rs.fonts)

				table.insert(fonts, 1, {
					name = wt.strings.font.path.default.label,
					path = STANDARD_TEXT_FONT:gsub("\\", "/"),
				})

				for i = 1, #fonts do
					fontItems[i] = {}
					fontItems[i].title = fonts[i].name
					fontItems[i].tooltip = {
						title = fonts[i].name,
						lines = {
							{ text = fonts[i].path:match(rs.addon) and wt.strings.font.path.otf or wt.strings.font.path.base },
							{ text = "\n" .. wt.strings.font.path.file:gsub("#PATH", crc(fonts[i].path, "FFFFFFFF")), color = { r = 0.4, g = 1, b = 0.4 }, },
						}
					}
				end
				fontItems[1].tooltip.lines[1] = { text = wt.strings.font.path.default.tooltip, }

				--| Add custom fonts

				if type(WidgetToolsDB.customFonts) == "table" then
					for i = 1, #WidgetToolsDB.customFonts do table.insert(fonts, {
						name = WidgetToolsDB.customFonts[i],
						path = "Fonts/" .. WidgetToolsDB.customFonts[i] .. ".ttf",
					}) end

					for i = #fonts - #WidgetToolsDB.customFonts + 1, #fonts do
						fontItems[i] = {}
						fontItems[i].title = fonts[i].name
						fontItems[i].tooltip = {
							title = fonts[i].name,
							lines = {
								{ text = wt.strings.font.path.custom, },
								{ text = "\n" .. wt.strings.font.path.replace:gsub( --TODO update the tooltip when full custom font management support is added
									"#FONTS_DIRECTORY", cr("[WoW]\\Fonts\\", { r = 0.185, g = 0.72, b = 0.84 })
								):gsub("#FILE_CUSTOM", "CUSTOM.ttf") },
								{ text = "\n" .. wt.strings.font.path.reminder, color = { r = 0.89, g = 0.65, b = 0.40 }, }, --TODO update the tooltip when full custom font management support is added
								{ text = "\n" .. wt.strings.font.path.file:gsub("#PATH", crc(fonts[i].path, "FFFFFFFF")), color = { r = 0.4, g = 1, b = 0.4 }, },
							}
						}
					end
				end
			end

			panel.widgets.path = wt.CreateDropdownRadiogroup({
				parent = panelFrame,
				name = "Path",
				title = wt.strings.font.path.label,
				tooltip = { lines = { { text = wt.strings.font.path.tooltip, }, } },
				width = 184,
				arrange = {},
				items = fontItems,
				dependencies = t.dependencies,
				getData = function() return us.FindIndex(fonts, getData().path) end,
				saveData = function(value) getData().path = fonts[value].path end,
				default = us.FindIndex(fonts, defaultData.path),
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					onChange = {
						CustomFontChangeHandler = function() if type(t.onChangeFont) == "function" then t.onChangeFont() end end,
						UpdateTextFont = function() textline:SetFont(getData().path, getData().size, "OUTLINE") end,
						UpdateFontDropdownText = not WidgetToolsDB.lite and function()
							local _, size, flags = panel.widgets.path.toggle.label:GetFont()

							panel.widgets.path.toggle.label:SetFont(fonts[panel.widgets.path.getSelected() or 1].path, size, flags)
						end or nil,
					},
				},
				events = { OnShow = function()
					local _, size, flags = panel.widgets.path.toggle.label:GetFont()

					panel.widgets.path.toggle.label:SetFont(fonts[panel.widgets.path.getSelected() or 1].path, size, flags)
				end },
			})

			--Update the font of the dropdown items
			if panel.widgets.path.frame then
				for i = 1, #panel.widgets.path.toggles do if panel.widgets.path.toggles[i].label then
					local _, size, flags = panel.widgets.path.toggles[i].label:GetFont()
					panel.widgets.path.toggles[i].label:SetFont(fonts[i].path, size, flags)
				end end

				if panel.widgets.path.toggles[1].label then panel.widgets.path.toggles[1].label:SetTextColor(0.4, 1, 0.4) end

				if type(WidgetToolsDB.customFonts) == "table" then for i = #fonts - #WidgetToolsDB.customFonts + 1, #fonts do
					if panel.widgets.path.toggles[i].label then panel.widgets.path.toggles[i].label:SetTextColor(1, 0.4, 0.4) end
				end end
			end

			widgetCount = widgetCount + 1

			--| Size

			panel.widgets.size = wt.CreateSlider({
				parent = panelFrame,
				name = "Size",
				title = wt.strings.font.size.label,
				tooltip = { lines = { { text = wt.strings.font.size.tooltip, }, } },
				arrange = { wrap = false, },
				min = 8,
				max = 64,
				step = 1,
				altStep = 3,
				dependencies = t.dependencies,
				getData = function() return getData().size end,
				saveData = function(value) getData().size = value end,
				default = defaultData.size,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					onChange = {
						CustomSizeChangeHandler = function() if type(t.onChangeSize) == "function" then t.onChangeSize() end end,
						"UpdateTextFont",
					},
				},
			})

			widgetCount = widgetCount + 1

			--| Alignment

			---@diagnostic disable-next-line: missing-fields --NOTE: Added later
			panel.widgets.alignment = {}

			panel.widgets.alignment = wt.CreateSpecialRadiogroup("justifyH", {
				parent = panelFrame,
				name = "Alignment",
				title = wt.strings.font.alignment.label,
				tooltip = { lines = { { text = wt.strings.font.alignment.tooltip, }, } },
				arrange = { wrap = false, },
				width = 140,
				dependencies = t.dependencies,
				getData = function() return getData().alignment end,
				saveData = function(value) getData().alignment = value end,
				default = defaultData.alignment,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					onChange = {
						CustomAlignmentChangeHandler = function() if type(t.onChangeAlignment) == "function" then t.onChangeAlignment() end end,
						UpdateTextAlignment = function() textline:SetJustifyH(getData().alignment) end,
					},
				},
			})

			widgetCount = widgetCount + 1

			--| Font color

			if type(t.colors) ~= "table" then t.colors = {} end
			local wrapper
			for k, v in pairs(t.colors) do if v.index == 1 then wrapper = k break end end

			---@type (colormanager|colorpicker)[]
			panel.widgets.colors = {}

			for key in pairs(getData().colors) do
				if type(t.colors[key]) ~= "table" then t.colors[key] = {} end

				local name = t.colors[key].name == "string" and t.colors[key].name or (key:sub(1,1):upper() .. key:sub(2))
				local index = type(t.colors[key].index) == "number" and t.colors[key].index + widgetCount or not next(panel.widgets.colors)

				panel.widgets.colors[key] = wt.CreateColorpicker({
					parent = panelFrame,
					name = name .. "Colorpicker",
					title = wt.strings.font.color.label:gsub("#COLOR_TYPE", name),
					tooltip = { lines = { { text = wt.strings.font.color.tooltip:gsub("#COLOR_TYPE", name), }, } },
					arrange = { wrap = wrapper == nil and not next(panel.widgets.colors) or key == wrapper , index = index },
					dependencies = t.dependencies,
					getData = function() return getData().colors[key] end,
					saveData = function(value) getData().colors[key] = value end,
					default = defaultData.colors[key],
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomColorChangeHandler = function() if type(t.onChangeColor) == "function" then t.onChangeColor(key) end end,
							UpdateTextColor = function() textline:SetTextColor(wt.UnpackColor(getData().colors[key])) end,
						},
					},
				})
			end
		end,
	})

	return panel
end


--[[ PROFILE DATA ]]

function wt.CreateProfilesPage(addon, accountData, characterData, defaultData, settingsData, t, profilemanager)

	--[ Widget ]

	profilemanager = wt.IsWidget(profilemanager) == "Profilemanager" and profilemanager or wt.CreateProfilemanager(accountData, characterData, defaultData, t)

	if not profilemanager or type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) or type(settingsData) ~= "table" then return profilemanager end

	---@type profilesPage|profilemanager
	local profiles = profilemanager

	--[ Getters & Setters ]

	function profiles.getType() return "Profilemanager", "ProfilesPage" end
	function profiles.isType(type) return type == "Profilemanager" or type == "ProfilesPage" end

	--[ Properties ]

	t = type(t) == "table" and t or {}

	local addonTitle = C_AddOns.GetAddOnMetadata(addon, "Title")
	local onDefault = type(t.onDefault) == "function" and t.onDefault or nil

	--[ Settings Page ]

	profiles.settings = wt.CreateSettingsPage(addon, {
		register = t.register,
		name = t.name or "DataManagement",
		title = t.title or wt.strings.dataManagement.title,
		description = t.description or wt.strings.dataManagement.description:gsub("#ADDON", addonTitle),
		dataManagement = {
			category = addon,
			keys = { "Backup" },
		},
		onSave = t.onSave,
		onLoad = t.onLoad,
		onCancel = t.onCancel,
		onDefault = onDefault and function(user, category)
			if not category then profiles.reset() end
			onDefault(user, category)
		end or function(_, category) if not category then profiles.reset() end end,
		arrangement = {},
		initialize = function(canvas, _, _, category, keys) if not WidgetToolsDB.lite or t.lite == false then

			--[ Profiles ]

			profiles.widgets = {}

			local profilesPanel = wt.CreatePanel({
				parent = canvas,
				name = "Profiles",
				title = wt.strings.profiles.title,
				description = wt.strings.profiles.description:gsub("#ADDON", addonTitle),
				arrange = {},
				arrangement = {},
				initialize = function(panel)

					--[ Frame Setup ]

					profiles.widgets.activate = wt.CreateDropdownRadiogroup({
						parent = panel,
						title = wt.strings.profiles.select.label,
						tooltip = { lines = { { text = wt.strings.profiles.select.tooltip, }, } },
						arrange = {},
						width = 180,
						items = accountData.profiles,
						value = characterData.activeProfile,
						listeners = { selected = { { handler = function(_, index, user) profiles.activate(index, user) end, }, }, },
					})

					profiles.widgets.create = wt.CreateButton({
						parent = panel,
						name = "New",
						title = wt.strings.profiles.new.label,
						tooltip = { lines = { { text = wt.strings.profiles.new.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							offset = { x = -312, y = -21 }
						},
						size = { w = 112, h = 26 },
						action = function() profiles.create(nil, #accountData.profiles + 1, nil, nil, nil, true) end,
					})

					profiles.widgets.duplicate = wt.CreateButton({
						parent = panel,
						name = "Duplicate",
						title = wt.strings.profiles.duplicate.label,
						tooltip = { lines = { { text = wt.strings.profiles.duplicate.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							offset = { x = -192, y = -21 }
						},
						size = { w = 112, h = 26 },
						action = function() profiles.create(nil, nil, characterData.activeProfile, nil, nil, true) end,
					})

					profiles.widgets.rename = wt.CreateButton({
						parent = panel,
						name = "Rename",
						title = wt.strings.profiles.rename.label,
						tooltip = { lines = { { text = wt.strings.profiles.rename.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							offset = { x = -92, y = -21 }
						},
						size = { w = 92, h = 26 },
						action = function()
							local title = accountData.profiles[characterData.activeProfile].title

							wt.CreatePopupInputBox({
								title = wt.strings.profiles.rename.description:gsub("#PROFILE", crc(title, "FFFFFFFF")),
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -92, y = -21 },
									relativeTo = panel,
								},
								text = title,
								accept = function(text) profiles.rename(nil, text, nil, true) end,
							})
						end,
					})

					profiles.widgets.delete = wt.CreateButton({
						parent = panel,
						name = "Delete",
						title = DELETE,
						tooltip = { lines = { { text = wt.strings.profiles.delete.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							offset = { x = -12, y = -21 }
						},
						size = { w = 72, h = 26 },
						action = function() profiles.delete(nil, nil, true) end,
						dependencies = { { frame = profiles.widgets.activate, evaluate = function() return #accountData.profiles > 1 end }, }
					})

					--[ Events ]

					--| UX

					--Update the activation widget UI based on profile data changes
					profiles.setListener.activated(function(_, index) profiles.widgets.activate.setSelected(index, false, true) end)
					profiles.setListener.created(function() profiles.widgets.activate.updateItems(accountData.profiles) end)
					profiles.setListener.renamed(function() profiles.widgets.activate.updateItems(accountData.profiles) end)
					profiles.setListener.deleted(function() profiles.widgets.activate.updateItems(accountData.profiles) end)
					profiles.setListener.reset(function() profiles.widgets.activate.updateItems(accountData.profiles) end)
					profiles.setListener.loaded(function() profiles.widgets.activate.updateItems(accountData.profiles) end)
				end,
			})

			--[ Backup ]

			profiles.backup = {}
			profiles.backupAll = {}

			wt.CreatePanel({
				parent = canvas,
				name = keys[1],
				title = wt.strings.backup.title,
				description = wt.strings.backup.description:gsub("#ADDON", addonTitle),
				arrange = {},
				size = { h = canvas:GetHeight() - profilesPanel:GetHeight() - 118 },
				arrangement = { resize = false, },
				initialize = function(panel)

					--[ Utilities ]

					--Update the backup box and load the current profile data of the selected scope to the backup string, formatted based on the compact setting
					function profiles.backup.refresh()
						profiles.backup.box.setText(us.TableToString(profiles.data, settingsData.compactBackup))

						--Set focus after text change to set the scroll to the top and refresh the position character counter
						profiles.backup.box.scrollframe.EditBox:SetFocus()
						profiles.backup.box.scrollframe.EditBox:ClearFocus()
					end

					--Update the backup box and load all addon profile data of the selected scope to the backup string, formatted based on the compact setting
					function profiles.backupAll.refresh()
						profiles.backupAll.box.setText(us.TableToString({
							activeProfile = characterData.activeProfile,
							profiles = accountData.profiles
						}, settingsData.compactBackup))

						--Set focus after text change to set the scroll to the top and refresh the position character counter
						profiles.backupAll.box.scrollframe.EditBox:SetFocus()
						profiles.backupAll.box.scrollframe.EditBox:ClearFocus()
					end

					--[ Active Profile ]

					profiles.backup.box = wt.CreateMultilineEditbox({
						parent = panel,
						name = "ImportExport",
						title = wt.strings.backup.box.label,
						tooltip = { lines = {
							{ text = wt.strings.backup.box.tooltip[1], },
							{ text = "\n" .. wt.strings.backup.box.tooltip[2], },
							{ text = "\n" .. wt.strings.backup.box.tooltip[3], },
							{ text = wt.strings.backup.box.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 }, },
							{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
						}, },
						arrange = {},
						size = { w = panel:GetWidth() - 24, h = panel:GetHeight() - 60 },
						font = { normal = "GameFontWhiteSmall", },
						scrollSpeed = 0.2,
						scrollToTop = false,
						unfocusOnEnter = false,
						dataManagement = {
							category = category,
							key = keys[1],
						},
						listeners = { loaded = { { handler = profiles.backup.refresh, }, }, },
						showDefault = false,
					})

					profiles.backup.compact = wt.CreateCheckbox({
						parent = panel,
						name = "Compact",
						title = wt.strings.backup.compact.label,
						tooltip = { lines = { { text = wt.strings.backup.compact.tooltip, }, } },
						arrange = {},
						getData = function() return settingsData.compactBackup end,
						saveData = function(state) settingsData.compactBackup = state end,
						dataManagement = {
							category = addon,
							key = keys[1],
							onChange = { RefreshBackupBox = profiles.backup.refresh },
						},
						listeners = { loaded = { { handler = function() profiles.backupAll.compact.widget:SetChecked(settingsData.compactBackup) end, }, }, },
						events = { OnClick = function(_, state) profiles.backupAll.compact.widget:SetChecked(state) end },
						showDefault = false,
						utilityMenu = false,
					})

					local importPopup = wt.RegisterPopupDialog(addon .. "_IMPORT", {
						text = wt.strings.backup.warning,
						accept = wt.strings.backup.import,
						onAccept = function()
							local success, load = pcall(loadstring("return " .. wt.Clear(profiles.backup.box.getText())))
							success = success and type(load) == "table"

							if success then
								profiles.validate(load, profiles.data)
								us.CopyValues(profiles.data, load)
							end

							t.onImport(success, load)
						end,
					})

					profiles.backup.load = wt.CreateButton({
						parent = panel,
						name = "Load",
						title = wt.strings.backup.load.label,
						tooltip = { lines = {
							{ text = wt.strings.backup.load.tooltip, },
							{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
						} },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = profiles.backup.box.frame,
							relativePoint = "BOTTOMRIGHT",
							offset = { y = -8 }
						},
						size = { h = 26 },
						action = function() StaticPopup_Show(importPopup) end,
					})

					profiles.backup.reset = wt.CreateButton({
						parent = panel,
						name = "Reset",
						title = RESET,
						tooltip = { lines = { { text = wt.strings.backup.reset.tooltip, }, } },
						position = {
							anchor = "RIGHT",
							relativeTo = profiles.backup.load.widget,
							relativePoint = "LEFT",
							offset = { x = -8, }
						},
						size = { h = 26 },
						action = profiles.backup.refresh,
					})

					--[ All Profiles ]

					local allProfilesBackupFrame = wt.CreatePanel({
						parent = canvas:GetParent(),
						name = addon .. "AllProfilesBackup",
						append = false,
						title = wt.strings.backup.allProfiles.label,
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
							profiles.backupAll.box = wt.CreateMultilineEditbox({
								parent = windowPanel,
								name = "ImportExportAllProfiles",
								title = wt.strings.backup.allProfiles.label,
								label = false,
								tooltip = { lines = {
									{ text = wt.strings.backup.allProfiles.tooltipLine, },
									{ text = "\n" .. wt.strings.backup.box.tooltip[2], },
									{ text = "\n" .. wt.strings.backup.box.tooltip[3], },
									{ text = wt.strings.backup.box.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 }, },
									{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
								}, },
								arrange = {},
								size = { w = windowPanel:GetWidth() - 32, h = windowPanel:GetHeight() - 92 },
								font = { normal = "GameFontWhiteSmall", },
								scrollSpeed = 0.2,
								scrollToTop = false,
								unfocusOnEnter = false,
								dataManagement = {
									category = category,
									key = keys[1],
								},
								listeners = { loaded = { { handler = profiles.backupAll.refresh, }, }, },
								showDefault = false,
							})

							profiles.backupAll.compact = wt.CreateCheckbox({
								parent = windowPanel,
								name = "Compact",
								title = wt.strings.backup.compact.label,
								tooltip = { lines = { { text = wt.strings.backup.compact.tooltip, }, } },
								arrange = {},
								events = { OnClick = function()
									profiles.backup.compact.toggleState(true)
									profiles.backupAll.refresh()
								end },
								showDefault = false,
								utilityMenu = false,
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
							windowPanel:Hide()
						end,
					})

					wt.CreateButton({
						parent = panel,
						name = "AllProfilesButton",
						title = wt.strings.backup.allProfiles.open.label,
						tooltip = { lines = { { text = wt.strings.backup.allProfiles.open.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = profiles.backup.box.frame,
							relativePoint = "TOPRIGHT",
							offset = { x = -1, y = 2 }
						},
						size = { w = 100, h = 17 },
						frameLevel = profiles.backup.box.frame:GetFrameLevel() + 1, --Make sure it's on top to be clickable
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
						},
						action = function()
							allProfilesBackupFrame:Show()

							profiles.backupAll.compact.setState(settingsData.compactBackup, nil, true)

							profiles.backupAll.refresh()
						end,
					})

					local allProfilesImportPopup = wt.RegisterPopupDialog(addon .. "_IMPORT_ALL", {
						text = wt.strings.backup.warning,
						accept = wt.strings.backup.import,
						onAccept = function()
							local success, data = pcall(loadstring("return " .. wt.Clear(profiles.backupAll.box.getText())))
							data = type(data) == "table" and data or {}

							if success then profiles.load(data.profiles, data.activeProfile, true) end

							t.onImportAllProfiles(success and type(data) == "table", data)
						end,
					})

					profiles.backupAll.load = wt.CreateButton({
						parent = allProfilesBackupFrame,
						name = "Load",
						title = wt.strings.backup.load.label,
						tooltip = { lines = {
							{ text = wt.strings.backup.load.tooltip, },
							{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
						} },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = profiles.backupAll.box.frame,
							relativePoint = "BOTTOMRIGHT",
							offset = { y = -8 }
						},
						size = { h = 26 },
						action = function() StaticPopup_Show(allProfilesImportPopup) end,
					})

					profiles.backupAll.reset = wt.CreateButton({
						parent = allProfilesBackupFrame,
						name = "Reset",
						title = RESET,
						tooltip = { lines = { { text = wt.strings.backup.reset.tooltip, }, } },
						position = {
							anchor = "RIGHT",
							relativeTo = profiles.backupAll.load.widget,
							relativePoint = "LEFT",
							offset = { x = -8, }
						},
						size = { h = 26 },
						action = profiles.backupAll.refresh,
					})
				end,
			})
		end end,
	})

	return profiles
end


--[[ ADDON INFO ]]

function wt.CreateAboutPage(addon, t)
	if type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) then return nil end

	t = type(t) == "table" and t or {}

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

	--[ Settings Page ] --TODO create utility logical core, add addon-wide preset management capability

	return wt.CreateSettingsPage(addon, not WidgetToolsDB.lite and next(data) and {
		register = t.register,
		name = t.name or "About",
		title = t.title or data.title,
		description = t.description or data.notes,
		static = t.static ~= false,
		arrangement = {},
		initialize = function(canvas)

			--[ About ]

			wt.CreatePanel({
				parent = canvas,
				name = "About",
				title = wt.strings.about.title,
				description = wt.strings.about.description:gsub("#ADDON", data.title),
				arrange = {},
				size = { h = 240 },
				arrangement = {
					flip = true,
					resize = false
				},
				initialize = function(panel)

					--[ Information ]

					local position = { offset = { x = 16, y = -14 } }

					if data.version then
						local versionLabel = wt.CreateText({
							parent = panel,
							name = "VersionTitle",
							position = position,
							width = 48,
							text = wt.strings.about.version,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
							wrap = false,
						})

						wt.CreateText({
							parent = panel,
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
							wrap = false,
						})

						position.relativeTo = versionLabel
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -6
					end

					if data.category then
						local categoryLabel = wt.CreateText({
							parent = panel,
							name = "CategoryTitle",
							position = position,
							width = 48,
							text = CATEGORY,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
							wrap = false,
						})

						wt.CreateText({
							parent = panel,
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
							parent = panel,
							name = "AuthorTitle",
							position = position,
							width = 48,
							text = wt.strings.about.author,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
						})

						wt.CreateText({
							parent = panel,
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
							wrap = false,
						})

						position.relativeTo = authorLabel
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -6
					end

					if data.license then
						local licenseLabel = wt.CreateText({
							parent = panel,
							name = "LicenseTitle",
							position = position,
							width = 48,
							text = wt.strings.about.license,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
							wrap = false,
						})

						wt.CreateText({
							parent = panel,
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
							wrap = false,
						})

						position.relativeTo = licenseLabel
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
					end

					--[ Links ]

					if position.relativeTo then position.offset.y = -14 end

					if data.curse then
						local curseLink = wt.CreateCopybox({
							parent = panel,
							name = "CurseForge",
							title = wt.strings.about.curseForge,
							position = position,
							size = { w = 190, },
							value = data.curse,
						})

						position.relativeTo = curseLink.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if data.wago then
						local wagoLink = wt.CreateCopybox({
							parent = panel,
							name = "Wago",
							title = wt.strings.about.wago,
							position = position,
							size = { w = 190, },
							value = data.wago,
						})

						position.relativeTo = wagoLink.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if data.repo then
						local repoLink = wt.CreateCopybox({
							parent = panel,
							name = "Repository",
							title = wt.strings.about.repository,
							position = position,
							size = { w = 190, },
							value = data.repo,
						})

						position.relativeTo = repoLink.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if data.issues then wt.CreateCopybox({
						parent = panel,
						name = "Issues",
						title = wt.strings.about.issues,
						position = position,
						size = { w = 190, },
						value = data.issues,
					}) end

					--[ Changelog ]

					if not t.changelog then return end

					local changelogTextbox = wt.CreateMultilineEditbox({
						parent = panel,
						name = "Changelog",
						title = wt.strings.about.changelog.label,
						tooltip = { lines = { { text = wt.strings.about.changelog.tooltip:gsub("#VERSION", crc(data.version, "FFFFFFFF")), }, } },
						arrange = {},
						size = { w = panel:GetWidth() - 225, h = panel:GetHeight() - 25 },
						font = { normal = "GameFontDisableSmall", },
						color = rs.colors.grey[2],
						value = us.FormatChangelog(t.changelog, true),
						readOnly = true,
					})

					local fullChangelogFrame

					wt.CreateButton({
						parent = panel,
						name = "ChangelogButton",
						title = wt.strings.about.fullChangelog.open.label,
						tooltip = { lines = { { text = wt.strings.about.fullChangelog.open.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = changelogTextbox.frame,
							relativePoint = "TOPRIGHT",
							offset = { x = -1, y = 2 }
						},
						size = { w = 100, h = 17 },
						frameLevel = changelogTextbox.frame:GetFrameLevel() + 1, --Make sure it's on top to be clickable
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
						},
						action = function() if fullChangelogFrame then fullChangelogFrame:Show() else fullChangelogFrame = wt.CreatePanel({
							parent = canvas:GetParent(),
							name = addon .. "Changelog",
							append = false,
							title = wt.strings.about.fullChangelog.label:gsub("#ADDON", data.title),
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
									title = wt.strings.about.fullChangelog.label:gsub("#ADDON", data.title),
									label = false,
									tooltip = { lines = { { text = wt.strings.about.fullChangelog.tooltip, }, } },
									arrange = {},
									size = { w = windowPanel:GetWidth() - 32, h = windowPanel:GetHeight() - 58 },
									font = { normal = "GameFontDisable", },
									color = rs.colors.grey[2],
									value = us.FormatChangelog(t.changelog),
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
				end,
			})

			--[ Sponsors ]

			if data.topSponsors or data.sponsors then
				local sponsorsPanel = wt.CreatePanel({
					parent = canvas,
					name = "Sponsors",
					title = wt.strings.sponsors.title,
					description = wt.strings.sponsors.description,
					arrange = {},
					size = { h = 46 + (data.topSponsors and data.sponsors and 24 or 0) },
					initialize = function(panel)
						if data.topSponsors then wt.CreateText({
							parent = panel,
							name = "Top",
							position = { offset = { x = 16, y = -12 } },
							width = panel:GetWidth() - 46,
							text = data.topSponsors:gsub("|", " • "),
							font = "GameFontNormalLarge",
							justify = { h = "LEFT", },
						}) end

						if data.sponsors then wt.CreateText({
							parent = panel,
							name = "Normal",
							position = { offset = { x = 16, y = -16 -(data.topSponsors and 24 or 0) } },
							width = panel:GetWidth() - 46,
							text = data.sponsors:gsub("|", " • "),
							font = "GameFontNormalMed1",
							justify = { h = "LEFT", },
						}) end
					end,
				})

				wt.CreateText({
					parent = sponsorsPanel,
					name = "DescriptionHeart",
					position = {
						anchor = "TOPRIGHT",
						offset = { x = -14, y = -12 }
					},
					text = "♥",
					font = "NumberFont_Shadow_Large",
					color = { r = 1, g = 0.4, b = 0.4, }, 
					justify = { h = "LEFT", },
				})
			end
		end,
	})
end