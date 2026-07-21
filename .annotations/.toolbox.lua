--NOTE: Annotations are for development purposes only, providing live documentation via Lua Language Server. This file does not need to be loaded by the game client.

----@meta toolbox


--[[ TOOLBOX ]]

---Widget Toolbox table
---@class toolbox : widgetToolbox
---@field addon string Toolbox sub-addon namespace name
---@field title string Toolbox sub-addon display title
---@field root string Toolbox sub-addon root folder path
---@field classic boolean Classic vs modern UI code separation
---@field textures { alphaBG: string,  gradientBG: string }
---@field strings toolboxStrings
---@field changelog string[][]
---@field clipboard toolboxClipboard
local wt = {}

	---Localized strings
	--- - ***Note:*** `#FLAGS` will be replaced by text or number values via code; `\n` represents the newline character.
	---@alias toolboxStrings
	---| toolboxStrings_enUS
	---| toolboxStrings_ptBR
	---| toolboxStrings_deDE
	---| toolboxStrings_frFR
	---| toolboxStrings_esES
	---| toolboxStrings_esMX
	---| toolboxStrings_itIT
	---| toolboxStrings_koKR
	---| toolboxStrings_zhTW
	---| toolboxStrings_zhCN
	---| toolboxStrings_ruRU

	---Widget data clipboard
	---@class toolboxClipboard
	---@field binary boolean|nil Logical value
	---@field numeric number|nil Number value
	---@field textual string|nil Text value
	---@field selection wrappedInteger|nil Selector index
	---@field selections wrappedBooleanArray|nil Multiselector data
	---@field anchor wrappedAnchor|nil Frame Anchor Point
	---@field justifyH wrappedJustifyH|nil Horizontal text alignment value
	---@field justifyV wrappedJustifyV|nil Vertical text alignment value
	---@field strata wrappedStrata|nil Frame Strata value
	---@field color color|nil RGB(A) color value
	---@field position positionData|nil Position data
	---@field font fontData|nil Font data


--[[ TABLE MANAGEMENT ]]

---Align all keys in a table to a reference table, filling missing values and removing mismatched or invalid pairs
---***
---@param targetTable table Reference to the table to get into alignment with the sample
---@param tableToSample table Reference to the table to sample keys & data from
---***
---@return table|any targetTable Reference to `targetTable` (it was already overwritten during the operation, no need for setting it again)
function wt.HarmonizeData(targetTable, tableToSample) end


--[[ DATA MANAGEMENT ]]

--| Conversion

---Return a position table used by WidgetTools assembled from the provided values which are returned by [Region:GetPoint(...)](https://warcraft.wiki.gg/wiki/API_Region_GetPoint)
---***
---@param anchor? FramePoint Base anchor point | ***Default:*** `"TOPLEFT"`
---@param relativeTo? Frame Relative to this Frame or Region
---@param relativePoint? FramePoint Relative anchor point
---@param offsetX? number | ***Default:*** `0`
---@param offsetY? number | ***Default:*** `0`
---***
---@return positionData # Table containing the position values as used by WidgetTools
---<p></p>
function wt.PackPosition(anchor, relativeTo, relativePoint, offsetX, offsetY) return {} end

---Extract, verify and return the position values used by [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) from a position table used by WidgetTools
---***
---@param t? positionData Table containing parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with
---***
---@return FramePoint anchor ***Default:*** `"TOPLEFT"`
---@return AnyFrameObject|nil relativeTo ***Default:*** `"nil"` *(anchor relative to screen dimensions)*<ul><li>***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).</li></ul>
---@return FramePoint? relativePoint
---@return number|nil offsetX ***Default:*** `0`
---@return number|nil offsetY ***Default:*** `0`
---<hr><p></p>
function wt.UnpackPosition(t) return "TOPLEFT" end

--[ Color ]

--| Verification

---Check if a variable is a valid color table
---@param t any
---@return boolean|color
function wt.IsColor(t)
	return false

	--| Returns

	---@alias color
	---| rgbData
	---| colorData
	---| colorRGBA
	---| colorRGB

		---@class colorData : rgbData, alpha_opaqueDefault

			---@class rgbData
			---@field r number Red | ***Range:*** (`0`, `1`)
			---@field g number Green | ***Range:*** (`0`, `1`)
			---@field b number Blue | ***Range:*** (`0`, `1`)

			---@class alpha_opaqueDefault
			---@field a? number Opacity | ***Range:*** (`0`, `1`) | ***Default:*** `1`
end

---Check & silently repair a color data table
---@param color any
---@return boolean|color ***Default:*** `{ r = 1, g = 1, b = 1, a = 1 }`
function wt.VerifyColor(color)

	---@class rgbData_optional
	---@field r? number Red | ***Range:*** (`0`, `1`) | ***Default:*** `1`
	---@field g? number Green | ***Range:*** (`0`, `1`) | ***Default:*** `1`
	---@field b? number Blue | ***Range:*** (`0`, `1`) | ***Default:*** `1`

	return false
end

--| Conversion

---Return a table constructed from color values
---***
---@param red? number Red | ***Range:*** (`0`, `1`) | ***Default:*** `1`
---@param green? number Green | ***Range:*** (`0`, `1`) | ***Default:*** `1`
---@param blue? number Blue | ***Range:*** (`0`, `1`) | ***Default:*** `1`
---@param alpha? number Opacity | ***Range:*** (`0`, `1`) | ***Default:*** `1`
---***
---@return color # Table containing the color values
function wt.PackColor(red, green, blue, alpha) return {} end

---Extract, verify and return the color values found in a table
---***
---@param color? color Table containing the color values | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
---@param alpha? boolean Specify whether to return the full RGBA set or just the RGB values | ***Default:*** `true`
---***
---@return number r Red | ***Range:*** (`0`, `1`) | ***Default:*** `1`
---@return number g Green | ***Range:*** (`0`, `1`) | ***Default:*** `1`
---@return number b Blue | ***Range:*** (`0`, `1`) | ***Default:*** `1`
---@return number? a Opacity | ***Range:*** (`0`, `1`)
function wt.UnpackColor(color, alpha) return 1, 1, 1 end

---Convert RGB(A) color values in Range: (0, 1) to HEX color code
---***
---@param color? color The RGB(A) color data with all channels in Range: (0, 1) | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
---@param alphaFirst? boolean Put the alpha value first: ARGB output instead of RGBA | ***Default:*** `false`
---@param hashtag? boolean Whether to add a "#" to the beginning of the color description | ***Default:*** `true`
---***
---@return string hex Color code in HEX format<ul><li>***Examples:***<ul><li>**RGB:** "#2266BB"</li><li>**RGBA:** "#2266BBAA"</li></ul></li></ul>
function wt.ColorToHex(color, alphaFirst, hashtag) return "" end

---Convert a HEX color code into RGB or RGBA in Range: (0, 1)
---***
---@param hex string String in HEX color code format<ul><li>***Examples:***<ul><li>**RGB:** "#2266BB" (where the "#" is optional)</li><li>**RGBA:** "#2266BBAA" (where the "#" is optional)</li></ul></li></ul>
---***
---@return number r Red | ***Range:*** (`0`, `1`) | ***Default:*** `1`
---@return number g Green  | ***Range:*** (`0`, `1`) | ***Default:*** `1`
---@return number b Blue | ***Range:*** (`0`, `1`) | ***Default:*** `1`
---@return number? a Alpha | ***Range:*** (`0`, `1`)
function wt.HexToColor(hex) return 1, 1, 1 end

---Brighten or darken the RGB values of a color by an exponent
---***
---@param color color Table containing the color values
---@param exponent? number ***Default:*** `0.55`<ul><li>***Note:*** Values greater than 1 darken, smaller than 1 brighten the color.</li></ul>
---***
---@return any color Reference to `color` (it was already updated during the operation, no need for setting it again)
function wt.AdjustGamma(color, exponent) end

---Turn a color data table into a Blizzard color manager object
---***
---@param color color Table containing the color values
---***
---@return colorRGB|colorRGBA
function wt.CreateColor(color) return {} end


--[[ FORMATTING ]]

--[ Escape Sequences ]

---Create a markup texture string snippet via escape sequences based on the specified values
---***
---@param path Texture_param1 Path to the specific texture file relative to the root directory of the specific WoW client
--- - ***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.
--- - ***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.
--- - ***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.
---@param width? Texture_param2 ***Default:*** *width of the texture file*
---@param height? Texture_param3 ***Default:*** `width`
---@param offsetX? Texture_param4-5 ***Default:*** `0`
---@param offsetY? Texture_param4-5 ***Default:*** `0`
---@param t? table Optional parameters
---***
---@return string # ***Default:*** `""`
function wt.Texture(path, width, height, offsetX, offsetY, t)

	--| Parameters

	---Path to the specific texture file relative to the root directory of the specific WoW client
	--- - ***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.
	--- - ***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.
	--- - ***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.
	---@alias Texture_param1 # path
	---| string

	---***Default:*** *width of the texture file*
	---@alias Texture_param2 # width
	---| number
	---| nil

	---***Default:*** `width`
	---@alias Texture_param3 # height
	---| number
	---| nil

	---***Default:*** `0`
	---@alias Texture_param4-5 # offsetX
	---| number
	---| nil

	return ""
end

---Remove most visual formatting (like coloring) & other (like hyperlink) [escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences) from a string
--- - ***Note:*** *Grammar* escape sequences are not yet supported, and will not be removed.
---@param s string
---@return string s
function wt.Clear(s) return "" end

--[ Hyperlinks ]

---Format a clickable hyperlink text via escape sequences
---***
---@param linkType Hyperlink_param1 [Type of the hyperlink](https://warcraft.wiki.gg/wiki/Hyperlinks#Types) determining how it's being handled and what payload it carries
---@param content? string A colon-separated chain of parameters determined by `linkType` (Example: "content1:content2:content3") | ***Default:*** `""`
---@param text string Clickable text to be displayed as the hyperlink
---***
---@return string # ***Default:*** `""`
---<p></p>
function wt.Hyperlink(linkType, content, text)

	--| Parameters

	---[Type of the hyperlink](https://warcraft.wiki.gg/wiki/Hyperlinks#Types) determining how it's being handled and what payload it carries
	---@alias Hyperlink_param1 # linkType
	---| HyperlinkType
	---| "addon"
	---| "mawpower"

	---A colon-separated chain of parameters determined by `linkType` (Example: "content1:content2:content3") | ***Default:*** `""`
	---@alias Hyperlink_param2 # content
	---| string
	---| nil

	---Clickable text to be displayed as the hyperlink
	---@alias Hyperlink_param3 # text
	---| string

	return ""
end

---Format a custom clickable addon hyperlink text via escape sequences
---***
---@param addon CustomHyperlink_param1 The name of the addon's folder (the addon namespace, not its displayed title)
---@param linkType? CustomHyperlink_param2 A unique key signifying the type of the hyperlink specific to the addon (if the addon handles multiple different custom types of hyperlinks) in order to be able to set unique hyperlink click handlers via <code><i>WidgetToolbox</i>.SetHyperlinkHandler(...)</code> | ***Default:*** `"-"`
---@param content? CustomHyperlink_param3 A colon-separated chain of data strings carried by the hyperlink to be provided to the handler function (Example: "content1:content2:content3") | ***Default:*** `""`
---@param text Hyperlink_param3 Clickable text to be displayed as the hyperlink
---***
---@return string # ***Default:*** `""`
function wt.CustomHyperlink(addon, linkType, content, text)

	--| Parameters

	---The name of the addon's folder (the addon namespace, not its displayed title)
	---@alias CustomHyperlink_param1 # addon
	---| string

	---A unique key signifying the type of the hyperlink specific to the addon (if the addon handles multiple different custom types of hyperlinks) in order to be able to set unique hyperlink click handlers via <code><i>WidgetToolbox</i>.SetHyperlinkHandler(...)</code> | ***Default:*** `"-"`
	---@alias CustomHyperlink_param2 # linkType
	---| string
	---| nil

	---A colon-separated chain of data strings carried by the hyperlink to be provided to the handler function (Example: "content1:content2:content3") | ***Default:*** `""`
	---@alias CustomHyperlink_param3 # content
	---| string
	---| nil

	return ""
end

---Register a function to handle custom hyperlink clicks
---***
---@param addon SetHyperlinkHandler_param1 The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index<ul><li>***Note:*** Duplicate addon key that already had rules registered under will be overwritten.</li></ul>
---@param linkType? SetHyperlinkHandler_param2 Unique custom hyperlink type key used to identify the specific handler function | ***Default:*** `"-"`
---@param handler SetHyperlinkHandler_param3 Function to be called with the list of content data strings carried by the hyperlink returned one by one when clicking on a hyperlink text created via <code><i>WidgetToolbox</i>.CustomHyperlink(...)</code>
function wt.SetHyperlinkHandler(addon, linkType, handler)

	--| Parameters

	---The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index<ul><li>***Note:*** Duplicate addon key that already had rules registered under will be overwritten.</li></ul>
	---@alias SetHyperlinkHandler_param1 # addon
	---| string

	---Unique custom hyperlink type key used to identify the specific handler function | ***Default:*** `"-"`
	---@alias SetHyperlinkHandler_param2 # linkType
	---| string
	---| nil

	---Function to be called with the list of content data strings carried by the hyperlink returned one by one when clicking on a hyperlink text created via <code><i>WidgetToolbox</i>.CustomHyperlink(...)</code>
	---@alias SetHyperlinkHandler_param3 # handler
	---| fun(...)
end


--[[ WIDGET MANAGEMENT ]]

---Check if an object is a recognizable widget table and is optionally of a specific type
---@param o IsWidget_param1 Reference to the object to check
---@param typename? IsWidget_param2 Custom typename to not only check if `o` is a WidgetTools widget table or if it is also of the specific type | ***Default:*** *don't check type*
---***
---@return boolean # Return the true if the object is a widget (and optionally also of `typename`)
---<p></p>
function wt.IsWidget(o, typename)

	--| Parameters

	---Reference to the object to check
	---@alias IsWidget_param1 # o
	---| any

	---Custom typename to not only check if `o` is a WidgetTools widget table or if it is also of the specific type | ***Default:*** *don't check type*
	---@alias IsWidget_param2 # typename
	---| typename
	---| string
	---| nil

		---@alias typename
		---| typename_widget
		---| typename_action
		---| typename_button
		---| typename_customButton
		---| typename_binary
		---| typename_radiobutton
		---| typename_checkbox
		---| typename_classicCheckbox
		---| typename_selector
		---| typename_radiogroup
		---| typename_dropdownRadiogroup
		---| typename_specialSelector
		---| typename_specialRadiogroup
		---| typename_multiselector
		---| typename_checkgroup
		---| typename_textual
		---| typename_editbox
		---| typename_customEditbox
		---| typename_multilineEditbox
		---| typename_numeric
		---| typename_slider
		---| typename_classicSlider
		---| typename_colormanager
		---| typename_colorpicker
		---| typename_positionmanager
		---| typename_positionPanel
		---| typename_fontmanager
		---| typename_fontPanel
		---| typename_settingsmanager
		---| typename_settingsPage
		---| typename_profilemanager
		---| typename_profilesPage
		---| typename_addonmanager
		---| typename_addonPage
		---| typename_settingsCategory

	return false
end


--[[ FRAME MANAGEMENT ]]

--[ Constructors ]

--| Base frame

---Create & set up a new base frame
---***
---@param t? frameCreationData Optional parameters
---@return Frame frame
function wt.CreateFrame(t)

	--| Parameters

	---@class frameCreationData : positionableScreenObject, arrangeableObject, visibleObject_base, initializableContainer # t
	---@field parent? AnyFrameObject Reference to the frame to set as the parent of the new frame | ***Default:*** `nil` *(parentless frame)*<ul><li>***Note:*** You may use [Region:SetParent(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegion_SetParent) to set the parent frame later.</li></ul>
	---@field name? string Unique string used to set the name of the new frame | ***Default:*** `nil` *(anonymous frame)*<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field append? boolean When setting the name, append `t.name` to the name of `t.parent` instead | ***Default:*** `true` if `t.name` ~= nil and `t.parent` ~= nil and `t.parent` ~= UIParent
	---@field size? sizeData_zeroDefault|sizeData ***Default:*** *no size*<ul><li>***Note:*** Omitting or setting either value to 0 will result in the frame being invisible and not getting placed on the screen.</li></ul>
	---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnEvent](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent)" handlers specified here will not be set. Handler functions for specific global events should be specified in the `t.onEvent` table.</li></ul>
	---@field onEvent? table<WowEvent, fun(self: Frame, ...: any)> Table of key, value pairs that holds global event tags & their corresponding event handlers to be registered for the frame<ul><li>***Note:*** You may want to include [Frame:UnregisterEvent(...)](https://warcraft.wiki.gg/wiki/API_Frame_UnregisterEvent) to prevent the handler function to be executed again.</li><li>***Example:*** "[ADDON_LOADED](https://warcraft.wiki.gg/wiki/ADDON_LOADED)" is fired repeatedly after each addon. To call the handler only after one specified addon is loaded, you may check the parameter the handler is called with. It's a good idea to unregister the event to prevent repeated calling for every other addon after the specified one has been loaded already.<pre>```function(self, addon)```<br>&#9;```if addon ~= "AddonNameSpace" then return end --Replace "AddonNameSpace" with the namespace of the specific addon to watch```<br>&#9;```self:UnregisterEvent("ADDON_LOADED")```<br>&#9;```--Do something```<br>```end```</pre></li></ul>

		---@class positionableScreenObject : positionableObject
		---@field keepInBounds? boolean Whether to keep the frame within screen bounds whenever it's moved | ***Default:*** `false`

			---@class positionableObject
			---@field position? positionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** `"TOPLEFT"`

				---@class positionData : positionData_base
				---@field offset? offsetData

					---@class positionData_base
					---@field anchor? FramePoint ***Default:*** `"TOPLEFT"`
					---@field relativeTo? AnyFrameObject|string Frame reference or name, or "nil" to anchor relative to screen dimensions | ***Default:*** `"nil"`<ul><li>***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).</li><li>***Note:*** Default to "nil" when an invalid frame name is provided.</li></ul>
					---@field relativePoint? FramePoint ***Default:*** `anchor`

					---@class offsetData
					---@field x? number Horizontal offset value | ***Default:*** `0`
					---@field y? number Vertical offset value | ***Default:*** `0`

		---@class arrangeableObject
		---@field arrange? arrangementDirective When set, automatically position the frame in a columns within rows arrangement in its parent container via <code><i>WidgetToolbox</i>.ArrangeContent(t.parent, ...)</code>

			---@class arrangementDirective
			---@field wrap? boolean Place the frame into a new row within its container instead of adding it to the current row being filled | ***Default:*** `true`<ul><li>***Note:*** If the item would not fit in the row with other items in there, it will automatically be placed in a new row.</li></ul>
			---@field index? integer The ordering index of the frame by which to be placed during arrangement | ***Default:*** *use the ordering of the children of the parent container frame*

		---@class visibleObject_base
		---@field visible? boolean Whether to make the frame visible during initialization or not | ***Default:*** `true`
		---@field frameStrata? FrameStrata Pin the frame to the specified strata
		---@field frameLevel? integer The ordering level of the frame within its strata to set
		---@field keepOnTop? boolean Whether to raise the frame level on mouse interaction | ***Default:*** `false`

		---@class initializableContainer
		---@field arrangement? arrangementRules If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table
		---@field initialize? fun(container?: Frame, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? AnyFrameObject ― Reference to the frame to be set as the parent for child objects created during initialization (nil if `WidgetToolsDB.lite` is true)</p><p>@*param* `width` number The current width of the container frame (0 if `WidgetToolsDB.lite` is true)</p><p>@*param* `height` number The current height of the container frame (0 if `WidgetToolsDB.lite` is true)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

			---@class arrangementRules
			---@field margins? spacingData Inset the content inside the container frame by the specified amount on each side
			---@field gaps? number The amount of space to leave between rows and items within rows | ***Default:*** 8
			---@field flip? boolean Fill the rows from right to left instead of left to right | ***Default:*** `false`
			---@field resize? boolean Set the height of the container frame to match the space taken up by the arranged content (including margins) | ***Default:*** `true`

				---@class spacingData
				---@field l? number Space to leave on the left side | ***Default:*** 12
				---@field r? number Space to leave on the right side (doesn't need to be negated) | ***Default:*** 12
				---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** 12
				---@field b? number Space to leave at the bottom | ***Default:*** 12

		---@class sizeData_zeroDefault
		---@field w? number Width | ***Default:*** `0`
		---@field h? number Height | ***Default:*** `0`

	return {}
end

---Create & set up a new customizable frame with BackdropTemplate
---***
---@param t? frameCreationData Optional parameters
---@return Frame|BackdropTemplate frame
function wt.CreateCustomFrame(t) return {} end

--| Scrollframe

---Create an empty vertically scrollable frame
---***
---@param t? scrollframeCreationData Optional parameters
---@return Frame scrollChild
---@return ScrollFrame scrollframe
function wt.CreateScrollframe(t)

	--| Parameters

	---@class scrollframeCreationData : childObject, positionableObject, initializableContainer, scrollSpeedData # t
	---@field name? string Unique string used to append to the name of `t.parent` when setting the names of the name of the scroll parent and its scrollable child frame | ***Default:*** `"Scroller"` *(for the scrollable child frame)*<ul><li>***Note:*** Space characters will be removed when used for setting the frame names.</li></ul>
	---@field size? sizeData_parentDefault|sizeData ***Default:*** `t.parent` and *size of the parent frame* or *no size*
	---@field scrollSize? sizeData_scroll|sizeData ***Default:*** *size of the parent frame*

		---@class scrollSpeedData
		---@field scrollSpeed? number Percentage of one page of content to scroll at a time | ***Range:*** (`0`, `1`) | ***Default:*** `0.25`

		---@class sizeData_parentDefault
		---@field w? number Width | ***Default:*** *width of the parent frame*
		---@field h? number Height | ***Default:*** *height of the parent frame*

		---@class sizeData_scroll
		---@field w? number Horizontal size of the scrollable child frame | ***Default:*** `t.size.width - 16`
		---@field h? number Vertical size of the scrollable child frame | ***Default:*** `0` *(no height)*

	return {}, {}
end

--[ Position ]

---Set the position and anchoring of a frame when it is unknown which parameters will be nil
---***
---@param frame AnyFrameObject Reference to the frame to be moved
---@param position? positionData Table of parameters to call `frame`:[SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** `"TOPLEFT"`
---@param unlink? boolean If true, unlink the position of `frame` from `position.relativeTo` (preventing anchor family connections) by moving a positioning aid frame to `position` first, convert its position to absolute, breaking relative links (making it relative to screen points instead), then move `frame` to the position of the aid | ***Default:*** `false`
---@param userPlaced? boolean Remember the position if `frame`:[IsMovable()](https://warcraft.wiki.gg/wiki/API_Frame_IsMovable) | ***Default:*** `true`
function wt.SetPosition(frame, position, unlink, userPlaced) end

---Set the anchor of a frame while keeping its positioning by updating its relative offsets
---***
---@param frame AnyFrameObject Reference to the frame to be update
---@param anchor FramePoint New anchor point to set
---***
---@return number? offsetX The new horizontal offset value | ***Default:*** `nil`
---@return number? offsetY The new vertical offset value | ***Default:*** `nil`
---<p></p>
function wt.SetAnchor(frame, anchor) end

---Convert the position of a frame positioned relative to another to absolute position (making it relative to screen points, the UIParent instead)
---***
---@param frame AnyFrameObject Reference to the frame the position of which to be converted to absolute position
---@param keepAnchor? boolean If true, restore the original anchor of `frame` (as its closest anchor to the nearest screen point will be chosen after conversion) | ***Default:*** `true`
function wt.ConvertToAbsolutePosition(frame, keepAnchor) end

--| Arrangement

---Set the arrangement ordering description of a child frame by which to automatically position it in a columns within rows arrangement in its parent container via <code><i>WidgetToolbox</i>.ArrangeContent(...)</code>
---@param frame AnyFrameObject Reference to the child frame to set the arrangement ordering description for
---@param index integer|nil If set, use this ordering index for `frame` by which to schedule placing it during arrangement (instead of relying on its child index), or if nil, delete the ordering directive set for `frame`
---@param wrap boolean|nil If true, place `frame` into a new row within its container instead of adding it to the current row being filled, or if nil, delete the wrapping directive set for `frame`<ul><li>***Note:*** If the item would not fit in the row with other items in there, it will automatically be placed in a new row.</li></ul>
---@param skip boolean|nil If true, ignore all other directives and don't include `frame` in the arrangement when positioning the children of the parent frame, or if nil, delete the skipping directive set for `frame`
function wt.SetArrangementDirective(frame, index, wrap, skip) end

---Arrange the child frames of a container frame into stacked rows based on the parameters provided
--- - ***Note:*** The frames will be arranged into columns based on the the number of child frames assigned to a given row, anchored to "TOPLEFT", "TOP" and "TOPRIGHT" in order (by default) up to 3 frames. Columns in rows with more frames will be attempted to be spaced out evenly between the frames placed at the main 3 anchors.
---***
---@param container Frame Reference to the parent container frame the child frames of which are to be arranged based on their arrangement descriptions
---@param t? arrangementRules Arrange the child frames of `container` based on the specifications provided in this table
function wt.ArrangeContent(container, t) end

--| Movability

---Set the movability of a frame based in the specified values
---***
---@param frame AnyFrameObject Reference to the frame to make movable/unmovable
---@param movable? boolean Whether to make the frame movable or unmovable | ***Default:*** `false`
---@param t? movabilityData When specified, set `frame` as movable, dynamically updating the position settings widgets when it's moved by the user
function wt.SetMovability(frame, movable, t)

	--| Parameters

	---@class movabilityData # t
	---@field modifier? ModifierKey|any The specific (or any) modifier key required to be pressed down to move `t.frame` (if `t.frame` has the "OnUpdate" script defined) | ***Default:*** `nil` *(no modifier)*<ul><li>***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://warcraft.wiki.gg/wiki/API_IsModifierKeyDown) is used.</li></ul>
	---@field triggers? Frame[] List of frames that should handle inputs to initiate or stop the movement when interacted with | ***Default:*** `t.frame`
	---@field events? movementEvents Table containing functions to call when certain movement events occur
	---@field cursor? boolean If true, change the cursor to a movement cross when mousing over `t.frame` and `t.modifier` is pressed down if set | ***Default:*** `t.modifier ~= nil`

		---@class movementEvents
		---@field onStart? function Function to call when `frame` starts moving
		---@field onMove? function Function to call every with frame update while `frame` is moving (if `frame` has the "OnUpdate" script defined)
		---@field onStop? function Function to call when the movement of `frame` is stopped and the it was moved successfully
		---@field onCancel? function Function to call when the movement of `frame` is cancelled (because the modifier key was released early as an example)
end

--[ Visibility ]

---Set the visibility of a frame based on the value provided
---***
---@param frame AnyFrameObject Reference to the frame to hide or show
---@param visible? boolean If false, hide the frame, show it if true | ***Default:*** `false`
function wt.SetVisibility(frame, visible) end

--[ Backdrop ]

---Set the backdrop of a frame with BackdropTemplate with the specified parameters safely
---***
---@param frame backdropFrame|BackdropTemplate|AnyFrameObject Reference to the frame to set the backdrop of<ul><li>***Note:*** The template of `frame` must have been set as: `BackdropTemplateMixin and "BackdropTemplate"`.</li></ul>
---@param backdrop? backdropData Parameters to set the custom backdrop with | ***Default:*** `nil` *(remove the backdrop)*
---@param updates? backdropUpdateRule[] Table of backdrop update rules, modifying the specified parameters on trigger<ul><li>***Note:*** All update rules are additive, calling <code><i>WidgetToolbox</i>.SetBackdrop(...)` multiple times with `updates` specified *will not* override previously set update rules. The base `backdrop` values used for these old rules *will not* change by setting a new backdrop via <code><i>WidgetToolbox</i>.SetBackdrop(...)</code> either!</li></ul>
function wt.SetBackdrop(frame, backdrop, updates)

	--| Parameters

	---@class backdropFrame # frame
	---@field backdropInfo backdropInfo

	---@class backdropData # backdrop
	---@field background? backdropBackgroundData Table containing the parameters used for the background
	---@field border? backdropBorderData Table containing the parameters used for the border

		---@class backdropBackgroundData
		---@field texture? backdropBackgroundTextureData Parameters used for setting the background texture
		---@field color? color Apply the specified color to the background texture

		---@class backdropBorderData
		---@field texture? backdropBorderTextureData Parameters used for setting the border texture
		---@field color? color Apply the specified color to the border texture

	---@class backdropUpdateRule # updates
	---@field triggers? AnyFrameObject[] References to the frames to add the listener script to | ***Default:*** `{ frame }`
	---@field rules table<AnyScriptType, string|fun(frame: AnyFrameObject, self: AnyFrameObject, ...: any): backdropUpdate: backdropUpdateData|nil, fill: boolean|nil> List of events and update actions returning backdrop values to update the backdrop with, or, if they are set but not valid functions to call, restore the base `backdrop` unconditionally on event trigger<ul><li>***Note:*** Return an empty table `{}` for `backdropUpdate` and true for `fill` in order to restore the base `backdrop` after evaluation.</li><li>***Note:*** Return an empty table `{}` for `backdropUpdate` and `false` or `nil` for `fill` to do nothing (keep the current backdrop).</li></ul><hr><p>@*param* `frame` AnyFrameObject ― Reference to backdrop frame</p><p>@*param* `self` AnyFrameObject ― Reference to the specific trigger frame</p><p>@*param* `...` any ― Any leftover arguments will be passed from the handler script to <code>updates[<i>key</i>].rule</code></p><hr><p>@*return* `backdropUpdate`? backdropUpdateData|nil ― Parameters to update the backdrop with | ***Default:*** `nil` *(remove the backdrop)*</p><p>@*return* `fill`? boolean|nil ― If true, fill the specified defaults for the unset values in `backdropUpdate` with the values provided in `backdrop` at matching keys, if `false`, fill them with their corresponding values from the currently set values of `frame`.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure), `frame`:[GetBackdropColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods) and `frame`:[GetBackdropBorderColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods) | ***Default:*** `false`</p>

		---@alias AnyScriptType
		---| "OnLoad"
		---| "OnShow"
		---| "OnHide"
		---| "OnEnter"
		---| "OnLeave"
		---| "OnMouseDown"
		---| "OnMouseUp"
		---| "OnMouseWheel"
		---| "OnAttributeChanged"
		---| "OnSizeChanged"
		---| "OnEvent"
		---| "OnUpdate"
		---| "OnDragStart"
		---| "OnDragStop"
		---| "OnReceiveDrag"
		---| "PreClick"
		---| "OnClick"
		---| "PostClick"
		---| "OnDoubleClick"
		---| "OnValueChanged"
		---| "OnMinMaxChanged"
		---| "OnUpdateModel"
		---| "OnModelCleared"
		---| "OnModelLoaded"
		---| "OnAnimStarted"
		---| "OnAnimFinished"
		---| "OnEnterPressed"
		---| "OnEscapePressed"
		---| "OnSpacePressed"
		---| "OnTabPressed"
		---| "OnTextChanged"
		---| "OnTextSet"
		---| "OnCursorChanged"
		---| "OnInputLanguageChanged"
		---| "OnEditFocusGained"
		---| "OnEditFocusLost"
		---| "OnHorizontalScroll"
		---| "OnVerticalScroll"
		---| "OnScrollRangeChanged"
		---| "OnCharComposition"
		---| "OnChar"
		---| "OnKeyDown"
		---| "OnKeyUp"
		---| "OnGamePadButtonDown"
		---| "OnGamePadButtonUp"
		---| "OnGamePadStick"
		---| "OnColorSelect"
		---| "OnHyperlinkEnter"
		---| "OnHyperlinkLeave"
		---| "OnHyperlinkClick"
		---| "OnMessageScrollChanged"
		---| "OnMovieFinished"
		---| "OnMovieShowSubtitle"
		---| "OnMovieHideSubtitle"
		---| "OnTooltipSetDefaultAnchor"
		---| "OnTooltipCleared"
		---| "OnTooltipAddMoney"
		---| "OnTooltipSetUnit"
		---| "OnTooltipSetItem"
		---| "OnTooltipSetSpell"
		---| "OnTooltipSetQuest"
		---| "OnTooltipSetAchievement"
		---| "OnTooltipSetFramestack"
		---| "OnTooltipSetEquipmentSet"
		---| "OnEnable"
		---| "OnDisable"
		---| "OnArrowPressed"
		---| "OnExternalLink"
		---| "OnButtonUpdate"
		---| "OnError"
		---| "OnDressModel"
		---| "OnCooldownDone"
		---| "OnPanFinished"
		---| "OnUiMapChanged"
		---| "OnRequestNewSize"

		---@class backdropUpdateData
		---@field background? backdropUpdateBackgroundData Table containing the parameters used for the background | ***Default:*** `backdrop.background` if `fill == true` *(if it's false, keep the currently set values of `frame`.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure) and `frame`:[GetBackdropColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*
		---@field border? backdropUpdateBorderData Table containing the parameters used for the border | ***Default:*** `backdrop` if `fill == true` *(if it's `false`, keep the currently set values of `frame`.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure) and `frame`:[GetBackdropBorderColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

			---@class backdropUpdateBackgroundData
			---@field texture? backdropBackgroundTextureData Parameters used for setting the background texture | ***Default:*** `backdrop.background.texture` if `fill == true` *(if it's false, keep the currently set values of `frame`.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure))*
			---@field color? color Apply the specified color to the background texture | ***Default:*** `backdrop.background.color` if `fill == true` *(if it's false, keep the currently set values of `frame`:[GetBackdropColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

				---@class backdropBackgroundTextureData : pathData_ChatFrameDefault
				---@field size number Size of a single background tile square
				---@field tile? boolean Whether to repeat the texture to fill the entire size of the frame | ***Default:*** `true`
				---@field insets? insetData Offset the position of the background texture from the edges of the frame inward

					---@class insetData
					---@field l? number Left side | ***Default:*** `0`
					---@field r? number Right side | ***Default:*** `0`
					---@field t? number Top | ***Default:*** `0`
					---@field b? number Bottom | ***Default:*** `0`

			---@class backdropUpdateBorderData
			---@field texture? backdropBorderTextureData Parameters used for setting the border texture | ***Default:*** `backdrop.border.texture` if `fill == true` *(if it's false, keep the currently set values of `frame`.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure))*
			---@field color? color Apply the specified color to the border texture | ***Default:*** `backdrop.border.color` if `fill == true` *(if it's false, keep the currently set values of `frame`:[GetBackdropBorderColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

				---@class backdropBorderTextureData
				---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** `"Interface/Tooltips/UI-Tooltip-Border"`<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
				---@field width number Width of the backdrop edge
end

--[ Dependencies ]

---Assign dependency rule listeners from a defined a ruleset
---***
---@param rules dependencyRule[] Indexed table containing the dependency rules to add
---@param setState fun(state: boolean) Function to call to set the state of the frame, enabling it on a true, or disabling it on a false input
function wt.AddDependencies(rules, setState) end

---Check and evaluate all dependencies in a ruleset
---***
---@param rules dependencyRule[] Indexed table containing the dependency rules to check
---@return boolean? state
function wt.CheckDependencies(rules) end


--[[ TEXT ]]

--[ Font ]

---Create a new [Font](https://warcraft.wiki.gg/wiki/UIOBJECT_Font) object to be used when setting the look of a [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) using a [FontInstance](https://warcraft.wiki.gg/wiki/UIOBJECT_FontInstance)
---***
---@param name string A unique identifier name to set for the hew font object to be accessed by and referred to later<ul><li>***Note:*** If a font object with that name already exists, it will *not* be overwritten and its reference key will be returned.</li><li>***Example:*** Access the reference to the font object created via the globals table: `local customFont = _G["CustomFontName"]`.</li></ul>
---@param t? fontCreationData Optional parameters
---***
---@return string name, Font font ***Default*** `"GameFontNormal"`, `GameFontNormal`
function wt.CreateFont(name, t)

	--| Parameters

	---@class fontCreationData
	---@field template? FontObject An existing [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to copy as a baseline
	---@field font? fontData Table containing font properties used for [FontInstance:SetFont(...)](https://warcraft.wiki.gg/wiki/API_FontInstance_SetFont) (overriding `t.template`)
	---@field color? colorData_whiteDefault|color Apply the specified color to the font (overriding `t.template`)
	---@field spacing? number Set the character spacing of the text using this font (overriding `t.template`)
	---@field shadow? { offset: offsetData, color: colorData_blackDefault|color } Set a text shadow with the following parameters (overriding `t.template`)
	---@field justify? justifyData_centered Set the justification of the text using font (overriding `t.template`)
	---@field wrap? boolean Whether or not to allow the text lines using this font to wrap (overriding `t.template`)

		---@class fontData
		---@field path string Path to the font file relative to the WoW client directory<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Fonts/Font.ttf), otherwise use `\\`.</li><li>***Note:*** **File format:** Font files must be in TTF or OTF format.</li></ul>
		---@field size number The default display size of the new font object
		---@field style TBFFlags Comma separated string of font styling flags

		---@class colorData_whiteDefault : colorData
		---@field r? number Red | ***Range:*** (`0`, `1`) | ***Default:*** `0`
		---@field g? number Green | ***Range:*** (`0`, `1`) | ***Default:*** `1`
		---@field b? number Blue | ***Range:*** (`0`, `1`) | ***Default:*** `1`

		---@class colorData_blackDefault : colorData
		---@field r? number Red | ***Range:*** (`0`, `1`) | ***Default:*** `1`
		---@field g? number Green | ***Range:*** (`0`, `1`) | ***Default:*** `1`
		---@field b? number Blue | ***Range:*** (`0`, `1`) | ***Default:*** `1`

		---@class justifyData_centered : justifyData_left
		---@field h? JustifyHorizontal Horizontal text alignment| ***Default:*** `"CENTER"`

	return "", {}
end

--[ Textline ]

---Create a rendered text object ([FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString)) with the specified parameters
---***
---@param t? textCreationData Optional parameters
---@return FontString text
function wt.CreateText(t)

	--| Parameters

	---@class textCreationData : positionableObject # t
	---@field parent? AnyFrameObject Reference to parent frame to create and assign the text to | ***Default:*** UIParent
	---@field name? string String appended to the name of `t.parent` used to set the name of the new [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** `"Text"`
	---@field width? number
	---@field height? number
	---@field layer? DrawLayer
	---@field text? string Text to be shown
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used | ***Default:*** `"GameFontNormal"`<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via <code><i>WidgetToolbox</i>.CreateFont(...)</code> (even within this table definition).</li></ul>
	---@field color? color Apply the specified color to the text (overriding `t.font`)
	---@field justify? justifyData Set the justification of the text (overriding `t.font`)
	---@field wrap? boolean Whether or not to allow the text lines to wrap (overriding `t.font`) | ***Default:*** `true`

		---@class justifyData
		---@field h? JustifyHorizontal Horizontal text alignment
		---@field v? JustifyVertical Vertical text alignment

	return {}
end

---Add a title to a frame
---***
---@param frame AnyFrameObject Reference to the frame to add the title textline to
---@param t? titleCreationData Optional parameters
---***
---@return FontString? # ***Default:*** `nil`
function wt.CreateTitle(frame, t)

	--| Parameters

	---@class titleCreationData # t
	---@field anchor? FramePoint ***Default:*** `"TOPLEFT"`
	---@field offset? offsetData The offset from the anchor point relative to the specified frame
	---@field width? number ***Default:*** *width of the text*
	---@field text? string Text to be shown as the main title of the frame
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** `"GameFontHighlight"`
	---@field color? color Apply the specified color to the title (overriding `t.font`)
	---@field justify? JustifyHorizontal Set the horizontal text alignment (overriding `t.font`) | ***Default:*** `"LEFT"`
end

---Add a description to a titled frame
---***
---@param title FontString Reference to the already existing title textline to place the description next to
---@param t? descriptionCreationData Optional parameters
---***
---@return FontString? # ***Default:*** `nil`
function wt.CreateDescription(title, t)

	--| Parameters

	---@class descriptionCreationData # t
	---@field offset? offsetData The offset from the default position (right side of the separator to the right of `t.title`)
	---@field width? number ***Default:*** *width of the parent frame of `t.title` - width of `t.title` (& separator, offsets)*
	---@field widthOffset? number Increase the calculated with by this amount | ***Default:*** `0`
	---@field spacer? number Space to leave between `t.title` & the separator and the separator & the description | ***Default:*** 5
	---@field text? string Text to be shown as the description of the frame
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** `"GameFontHighlightSmall2"`
	---@field color? descriptionColorData|color Apply the specified color to the description (overriding `t.font`)
	---@field justify? JustifyHorizontal Set the horizontal text alignment (overriding `t.font`) | ***Default:*** `"LEFT"`

		---@class descriptionColorData
		---@field r? number Red | ***Range:*** (`0`, `1`) | ***Default:*** HIGHLIGHT_FONT_COLOR.r
		---@field g? number Green | ***Range:*** (`0`, `1`) | ***Default:*** HIGHLIGHT_FONT_COLOR.g
		---@field b? number Blue | ***Range:*** (`0`, `1`) | ***Default:*** HIGHLIGHT_FONT_COLOR.b
		---@field a? number Opacity | ***Range:*** (`0`, `1`) | ***Default:*** 0.55
end


--[[ TEXTURE ]]

---Create a [Texture](https://warcraft.wiki.gg/wiki/UIOBJECT_Texture) image [TextureBase](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) object
---***
---@param frame AnyFrameObject Reference to the frame to set as the parent of the new texture
---@param t textureCreationData Optional parameters
---@param updates? table<AnyScriptType, textureUpdateRule> Table of key, value pairs containing the list of events to link texture changes to, and what parameters to change
---***
---@return Texture? texture ***Default:*** `nil`
function wt.CreateTexture(frame, t, updates)

	--| Parameters

	---@class textureCreationData : positionableObject, pathData_ChatFrameDefault # t
	---@field name? string String appended to the name of `t.parent` used to set the name of the new texture | ***Default:*** `"Texture"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData ***Default:*** *size of* `parent`
	---@field atlas? string Name of the texture atlas to use instead of creating a texture based on `t.path`<ul><li>***Note:*** Settings this will override whatever `t.path` is set to.</li></ul>
	---@field layer? DrawLayer
	---@field level? integer Sublevel to set within the specified draw layer | ***Range:*** (`-8`, `7`)
	---@field tile? tileData Set the tiling behaviour of the texture | ***Default:*** *no tiling*
	---@field wrap? wrapData Set the warp mode for each axis
	---@field filterMode? FilterMode | ***Default:*** `"LINEAR"`
	---@field flip? axisData Mirror the texture on the horizontal and/or vertical axis
	---@field color? color Apply the specified color to the texture
	---@field edges? edgeCoordinates Edge coordinate offsets
	---@field vertices? vertexCoordinates Vertex coordinate offsets<ul><li>***Note:*** Setting texture coordinate offsets is exclusive between edges and vertices. If set, `t.edges` will be used first ignoring `t.vertices`.</li></ul>
	---@field events? table<ScriptType, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the texture object and the functions to assign as event handlers called when they trigger

		---@class pathData_ChatFrameDefault
		---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** `"Interface/ChatFrame/ChatFrameBackground"`<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>

		---@class sizeData
		---@field w number Width
		---@field h number Height

		---@class tileData
		---@field h? boolean Horizontal | ***Default:*** `false`
		---@field v? boolean Vertical | ***Default:*** `false`

		---@class wrapData
		---@field h? WrapMode|boolean Horizontal | ***Value:*** true = "REPEAT" |***Default:*** `"CLAMP"`
		---@field v? WrapMode|boolean Vertical | ***Value:*** true = "REPEAT" |***Default:*** `"CLAMP"`

		---@class axisData
		---@field h? boolean Horizontal x axis | ***Default:*** `false`
		---@field v? boolean Vertical y axis | ***Default:*** `false`

		---@class edgeCoordinates
		---@field l number Left | ***Reference Range:*** (0, 1) | ***Default:*** `0`
		---@field r number Right | ***Reference Range:*** (0, 1) | ***Default:*** `1`
		---@field t number Top | ***Value:*** *using canvas coordinates (inverted y axis)* | | ***Reference Range:*** (0, 1) | ***Default:*** `0`
		---@field b number Bottom | ***Value:*** *using canvas coordinates (inverted y axis)* | | ***Reference Range:*** (0, 1) | ***Default:*** `1`

		---@class vertexCoordinates
		---@field topLeft vertexCoordinates_topLeft
		---@field topRight vertexCoordinates_topRight
		---@field bottomLeft vertexCoordinates_bottomLeft
		---@field bottomRight vertexCoordinates_bottomRight

				---@class vertexCoordinates_topLeft
				---@field x number ***Reference Range:*** (0, 1) | ***Default:*** `0`
				---@field y number ***Value:*** *using canvas coordinates (inverted y axis)* | ***Reference Range:*** (0, 1) | ***Default:*** `0`

				---@class vertexCoordinates_topRight
				---@field x number ***Reference Range:*** (0, 1) | ***Default:*** `1`
				---@field y number ***Value:*** *using canvas coordinates (inverted y axis)* | ***Reference Range:*** (0, 1) | ***Default:*** `0`

				---@class vertexCoordinates_bottomLeft
				---@field x number ***Reference Range:*** (0, 1) | ***Default:*** `0`
				---@field y number ***Value:*** *using canvas coordinates (inverted y axis)* | ***Reference Range:*** (0, 1) | ***Default:*** `1`

				---@class vertexCoordinates_bottomRight
				---@field x number ***Reference Range:*** (0, 1) | ***Default:*** `1`
				---@field y number ***Value:*** *using canvas coordinates (inverted y axis)* | ***Reference Range:*** (0, 1) | ***Default:*** `1`

		---@class attributeEventData
		---@field name string
		---@field handler fun(...: any)

	---@class textureUpdateRule # updates
	---@field frame? AnyFrameObject Reference to the frame to add the listener script to | ***Default:*** `t.parent`
	---@field rule? fun(self: Frame, ...: any): data: textureUpdateData|nil Evaluate the event and specify the texture updates to set, or, if nil, restore the base values unconditionally on event trigger<hr><p>@*param* `self` AnyFrameObject — Reference to <code>updates[<i>key</i>].frame</code></p><p>@*param* `...` any — Any leftover arguments will be passed from the handler script to <code>updates[<i>key</i>].rule</code></p><hr><p>@*return* `data` textureUpdateData|nil — Parameters to update the texture with | ***Default:*** `t`<p>

		---@class textureUpdateData
		---@field position? positionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** `t.position`
		---@field size? sizeData | ***Default:*** `t.size`
		---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** `t.path`<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
		---@field layer? DrawLayer | ***Default:*** `t.layer`
		---@field level? integer Sublevel to set within the specified draw layer | ***Range:*** (`-8`, `7`) | ***Default:*** `t.level`
		---@field tile? tileData Set the tiling behaviour of the texture | ***Default:*** `t.tile`
		---@field wrap? wrapData Set the warp mode for each axis | ***Default:*** `t.wrap`
		---@field filterMode? FilterMode | ***Default:*** `t.filterMode`
		---@field flip? axisData Mirror the texture on the horizontal and/or vertical axis | ***Default:*** `t.flip`
		---@field color? color Apply the specified color to the texture | ***Default:*** `t.color`
		---@field edges? edgeCoordinates Edge coordinate offsets ***Default:*** `t.edges`
		---@field vertices? vertexCoordinates Vertex coordinate offsets ***Default:*** `t.vertices`<ul><li>***Note:*** Setting texture coordinate offsets is exclusive between edges and vertices. If set, `t.edges` will be used first ignoring `t.vertices`.</li></ul>
end

---Create a [Line](https://warcraft.wiki.gg/wiki/UIOBJECT_Line) [TextureBase](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) object
---***
---@param frame AnyFrameObject Reference to the frame to set as the parent of the new line
---@param t lineCreationData Optional parameters
---***
---@return Line? line ***Default:*** `nil`
function wt.CreateLine(frame, t)

	--| Parameters

	---@class lineCreationData # t
	---@field name? string String appended to the name of `t.parent` used to set the name of the new line | ***Default:*** `"Line"`
	---@field startPosition? pointData Parameters to call [Line:SetStartPoint(...)](https://warcraft.wiki.gg/wiki/API_Line_SetStartPoint) with | ***Default:*** `"TOPLEFT"`
	---@field endPosition? pointData Parameters to call [Line:SetEndPoint(...)](https://warcraft.wiki.gg/wiki/API_Line_SetEndPoint) with | ***Default:*** `"TOPLEFT"`
	---@field thickness? number ***Default:*** 4
	---@field layer? DrawLayer 
	---@field level? integer Sublevel to set within the draw layer specified with `t.layer` | ***Range:*** (`-8`, `7`)
	---@field color? color Apply the specified color to the line

		---@class pointData
		---@field relativeTo AnyFrameObject
		---@field relativePoint FramePoint
		---@field offset? offsetData
end


--[[ TOOLTIP ]]

--[ Game Tooltip ]

---Create and set up a new custom GameTooltip frame
---***
---@param name string Unique string piece to place in the name of the the tooltip to distinguish it from other tooltips (use the addon namespace string as an example)
---@return GameTooltip tooltip
function wt.CreateTooltip(name) return {} end

--[ Management ]

---@alias AnyTooltipData
---| tooltipData
---| widgetTooltipTextData
---| itemTooltipTextData
---| addonCompartmentTooltipData

---Register tooltip data and set up a GameTooltip for a frame to be toggled on hover
---***
---@param frame AnyFrameObject Owner frame the tooltip to be registered for<ul><li>***Note:*** If tooltip data for `owner` has already been added to the registry, it will be fully overwritten with `t`.</li><ul><li>***Note:*** Duplicate triggers may still be added if `duplicate` is set to true.</li></ul></li></ul>
---@param t? tooltipData The tooltip parameters are to be provided in this table
---@param toggle? tooltipToggleData Additional toggle rule parameters are to be provided in this table
---@param duplicate? boolean If true, execute even if tooltip data has already been registered for `owner`, potentially adding duplicate toggle triggers, or, automatically call <code><i>WidgetToolbox</i>.UpdateTooltipData(...)</code> instead to avoid this | ***Default:*** `false`
---***
---@return tooltipData|nil # Reference to the tooltip data table registered for `owner` to display the tooltip info by | ***Default:*** `nil`
function wt.AddTooltip(frame, t, toggle, duplicate)

	--| Parameters

	---@class tooltipData : tooltipFrameData, tooltipTextData # t
	---@field anchor? TooltipAnchor ***Default:*** `"ANCHOR_CURSOR"`
	---@field offset? offsetData Values to offset the position of <code><i>tooltipData</i>.tooltip</code> by
	---@field position? positionData_base|positionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via `t.anchor` | ***Default:*** `"TOPLEFT"` if <code><i>tooltipData</i>.anchor</code> == "ANCHOR_NONE"<ul><li>***Note:*** `t.offset` will be used when calling [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) as well.</li></ul>
	---@field flipColors? boolean Flip the default color values of the title and the text lines | ***Default:*** `false`

		---@class tooltipFrameData
		---@field tooltip? GameTooltip Reference to the tooltip frame to set up | ***Default:*** *default WidgetTools custom tooltip*

		---@class tooltipTextData
		---@field title? string String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR) | ***Default:*** `owner:GetName() or tostring(owner)`
		---@field lines? tooltipLineData[] Table containing the lists of parameters for the text lines after the title

			---@class tooltipLineData
			---@field text string Text to be displayed in the line
			---@field font? string|FontObject The [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to set for this line | ***Default:*** GameTooltipTextSmall
			---@field color? rgbData Table containing the RGB values to color this line with (overriding `font`)
			---@field wrap? boolean Allow the text in this line to be wrapped | ***Default:*** `true`

	---@class tooltipToggleData # toggle
	---@field triggers? Frame[] List of references to additional frames to add hover events to to toggle <code><i>tooltipData</i>.tooltip</code> for `owner` besides `owner` itself
	---@field checkParent? boolean Whether to check if `owner` is being hovered before hiding <code><i>tooltipData</i>.tooltip</code> when triggers stop being hovered | ***Default:*** `true`
	---@field replace? boolean If false, while <code><i>tooltipData</i>.tooltip</code> is already visible for a different owner, don't change it | ***Default:*** `true`<ul><li>***Note:*** If <code><i>tooltipData</i>.tooltip</code> is already shown for `owner`, <code><i>WidgetToolbox</i>.UpdateTooltip(...)</code> will be called anyway.</li></ul>
end

---Update and show a GameTooltip already set up to be toggled for a frame
---***
---@param frame AnyFrameObject Owner frame the tooltip to be updated for<ul><li>***Note:*** If no entry has been registered for `owner` in the tooltip data registry via <code><i>WidgetToolbox</i>.AddTooltip(...)</code> yet, no tooltip will be shown.</li></ul>
---@param t? tooltipUpdateData|tooltipData Use this set of parameters to update the tooltip for `owner` with | ***Default:*** *(fill values from the data in the registry)*
function wt.UpdateTooltip(frame, t)

	--| Parameters

	---@class tooltipUpdateData # t
	---@field title? string String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR) | ***Default:*** `owner.tooltipData.title`
	---@field lines? tooltipLineData[] Table containing the lists of parameters for the text lines after the title | ***Default:*** `owner.tooltipData.lines`
	---@field tooltip? GameTooltip Reference to the tooltip frame to set up | ***Default:*** `owner.tooltipData.tooltip`
	---@field offset? offsetData Values to offset the position of <code><i>tooltipData</i>.tooltip</code> by | ***Default:*** `owner.tooltipData.offset`
	---@field position? positionData_base|positionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via `t.anchor` | ***Default:*** `owner.tooltipData.position`
	---@field flipColors? boolean Flip the default color values of the title and the text lines | ***Default:*** `owner.tooltipData.flipColors`
	---@field anchor? TooltipAnchor [GameTooltip anchor](https://warcraft.wiki.gg/wiki/API_GameTooltip_SetOwner) | ***Default:*** `owner.tooltipData.anchor`
 end

---Verify and update the tooltip data values stored in the registry for a frame
---***
---@param frame AnyFrameObject Owner frame the tooltip data to be updated for<ul><li>***Note:*** If no entry has been registered for `owner` in the tooltip data registry via <code><i>WidgetToolbox</i>.AddTooltip(...)</code> yet, no data will be changed.</li></ul>
---@param t? tooltipUpdateData|tooltipData The parameters to update the tooltip with are to be provided in this table | ***Default:*** *(fill values from the data in the registry or use default values for required values missing from the registry)*
---@param linesUpdate boolean|nil If true, replace the full set of lines in the registry with `t.lines`, or if explicitly false, append the lines to the current list of lines, or if nil or something else, adjust the values of existing lines at matching indexes instead without adding or removing lines | ***Default:*** `nil`
---***
---@return tooltipData|nil # Reference to the tooltip data table registered for `owner` to display the tooltip info by | ***Default:*** `nil`
function wt.UpdateTooltipData(frame, t, linesUpdate) end

---Add default value and utility menu hint tooltip lines to widget tooltip tables
---***
---@param frames AnyFrameObject[] List of reference to the frames to add the tooltip lines to<ul><li>***Note:*** If no entry has been registered for a frame in the list in the tooltip data registry via <code><i>WidgetToolbox</i>.AddTooltip(...)</code> yet, no changes will be made for that frame.</li></ul>
---@param default? string Default value, formatted | ***Default:*** *(don't show default value)*
---@param utilityNote? boolean Is true, add a note for the utility context menu | ***Default:*** `true`
function wt.AddWidgetTooltipLines(frames, default, utilityNote) end


--[[ POPUP ]]

--[ Dialog ]

---Register the data for a Blizzard popup dialog for use
---***
---@param key? string Unique string to be used as the identifier key in the global `StaticPopupDialogs` table | ***Default:*** *table id of `t` or a random ID string*<ul><li>***Note:*** the default value will be appended to `key` even if its set and a valid string if that key already exist in the global `StaticPopupDialogs` table.
---@param t? popupDialogData Optional parameters
---***
---@return string key The unique identifier key the popup data was created under in the global `StaticPopupDialogs` table used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
function wt.RegisterPopupDialog(key, t)

	--| Parameters

	---@class popupDialogData # t
	---@field text? string The text to display as the message in the popup window
	---@field accept? string The text to display on the label of the accept button | ***Default:*** <code><i>WidgetToolbox</i>.strings.misc.accept</code>
	---@field cancel? string The text to display on the label of the cancel button | ***Default:*** <code><i>WidgetToolbox</i>.strings.misc.cancel</code>
	---@field alt? string The text to display on the label of the third alternative button
	---@field onAccept? function Called when the accept button is pressed and an OnAccept event happens
	---@field onCancel? function Called when the cancel button is pressed, the popup is overwritten (by another popup for instance) or the popup expires and an OnCancel event happens
	---@field onAlt? function Called when the alternative button is pressed and an OnAlt event happens

	return ""
end

---Update already existing popup dialog data
---***
---@param key string The unique identifier key representing the defaults warning popup dialog in the global `StaticPopupDialogs` table, and used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
---@param t? popupDialogData Optional parameters
---***
---@return string? key The unique identifier key created for this popup in the global `StaticPopupDialogs` table used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide) | ***Default:*** `nil`
function wt.UpdatePopupDialog(key, t) end

--[ Reload Notice ]

---Show a movable reload notice window on screen with a reload now and cancel button
---***
---@param t? reloadNoticeData Optional parameters
---***
---@return Frame reload Reference to the reload notice panel frame
function wt.CreateReloadNotice(t)

	--| Parameters

	---@class reloadNoticeData # t
	---@field title? string Text to be shown as the title of the reload notice | ***Default:*** `"Pending Changes"` *(when the language is set to English)*
	---@field message? string Text to be shown as the message of the reload notice | ***Default:*** `"Reload the interface to apply the pending changes."` *(when the language is set to English)*
	---@field position? reloadFramePositionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** `"TOPRIGHT"`, `-300`, `-80`

		---@class reloadFramePositionData : positionData_base
		---@field anchor? FramePoint ***Default:*** `"TOPRIGHT"`
		---@field offset? reloadFrameOffsetData

			---@class reloadFrameOffsetData
			---@field x? number Horizontal offset value | ***Default:*** -300
			---@field y? number Vertical offset value | ***Default:*** -80

	return {}
end


--[[ ADDON COMPARTMENT ]]

---Set up the [Addon Compartment](https://warcraft.wiki.gg/wiki/Addon_compartment#Automatic_registration) functionality by registering global functions for call
---***
---@param addon uiAddon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
---@param calls? addonCompartmentFunctions Functions to call wrapped in a table<ul><li>***Note:*** `AddonCompartmentFunc`, `AddonCompartmentFuncOnEnter` and/or `AddonCompartmentFuncOnLeave` must be set in the specified `addon`'s TOC file to enable this functionality, defining the names of the global functions to be set for call.</li></ul>
---@param tooltip? addonCompartmentTooltipData|tooltipData List of text lines to be added to the tooltip of the addon compartment button displayed when mousing over it<ul><li>***Note:*** Both `AddonCompartmentFuncOnEnter` and `AddonCompartmentFuncOnLeave` must be set in the specified `addon`'s TOC file to enable this functionality, defining the names of the global functions to be overloaded.</li></ul>
function wt.SetUpAddonCompartment(addon, calls, tooltip)

	--| Parameters

	---@class addonCompartmentFunctions # calls
	---@field onClick? fun(addon: string, button: string, frame: Button) Called when the `addon`'s compartment button is clicked<ul><li>***Note:*** `AddonCompartmentFunc`, must be set in the specified `addon`'s TOC file, defining the name of the global function to be set for call.</li></ul>
	---@field onEnter? fun(addon: string, frame: Button|Frame) Called when the `addon`'s compartment button is being hovered before the tooltip (if set) is shown<ul><li>***Note:*** `AddonCompartmentFuncOnEnter`, must be set in the specified `addon`'s TOC file, defining the name of the global function to be set for call.</li></ul>
	---@field onLeave? fun(addon: string, frame: Button|Frame) Called when the `addon`'s compartment button is stopped being hovered before the tooltip (if set) is hidden<ul><li>***Note:*** `AddonCompartmentFuncOnLeave`, must be set in the specified `addon`'s TOC file, defining the name of the global function to be set for call.</li></ul>

	---@class addonCompartmentTooltipData : tooltipFrameData, tooltipTextData # tooltip
	---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** [GetAddOnMetadata(`addon`, "title")](https://warcraft.wiki.gg/wiki/API_GetAddOnMetadata)
end


--[[ CHAT CONTROL ]]

---Register a list of chat keywords and related commands for use
---***
---@param addon uiAddon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
---@param keywords string[] List of addon-specific keywords to register to listen to when typed as slash commands<ul><li>***Note:*** A slash character (`/`) will appended before each keyword specified here during registration, it doesn't need to be included.</li></ul>
---@param t chatCommandManagerCreationData Optional parameters
---***
---@return chatCommandManager? manager Table containing command handler functions | ***Default:*** `nil`
function wt.RegisterChatCommands(addon, keywords, t)

	--| Parameters

	---@class chatCommandManagerCreationData # t
	---@field commands? chatCommandData[] Indexed table with the list of commands to register under the specified `keywords`
	---@field colors? chatCommandColors Color palette used when printing out default-formatted chat messages
	---@field defaultHandler? fun(commandManager: chatCommandManager, command: string, ...: string) Default handler function to call when an unrecognized command is typed, executed before a help command is triggered, listing all registered commands<hr><p>@*param* `commandManager` commandManager ― Reference to the command manager</p><p>@*param* `command` string ― The unrecognized command typed after the keyword (separated by a space character)</p><p>@*param* `...` string Payload of the command typed, any words following the command name separated by spaces (split, returned unpacked)</p>
	---@field onWelcome? function Called when the welcome message with keyword hints is printed out

		---@class chatCommandData
		---@field command string Name of the slash command word (no spaces) to recognize after the keyword (separated by a space character)
		---@field description? string|fun(): string Note to append to the first specified keyword and `command` in this command's line in the list printed out via the help command(s)
		---@field handler? fun(manager: chatCommandManager, ...: string): result: boolean|nil, ...: any Function to be called when the specific command was recognized after being typed into chat<hr><p>@*param* `...` string ― Payload of the command typed, any words following the command name separated by spaces split and returned one by one</p><hr><p>@*return* `result`? boolean|nil ― Call <code>[<i>value</i>].onSuccess</code> if true or <code>[<i>value</i>].onError</code> if false (not nil) after the operation | ***Default:*** `nil` *(no response)*</p><p>@*return* `...` any ― Leftover arguments to be passed over to response handler scripts</p>
		---@field success? string|fun(...: any): string Response message (or a function returning the message string) to print out on success after<code>commands[<i>value</i>].handler</code> returns with true<p>@*param* `...` any ― Leftover arguments passed over by the handler script</p>
		---@field error? string|fun(...: any): string Response message (or a function returning the message string) to print out on error after<code>commands[<i>value</i>].handler</code> returns with false (not nil)<hr><p>@*param* `...` any ― Any leftover arguments passed over by the handler script</p>
		---@field onSuccess? fun(manager: chatCommandManager, ...: any) Function to call after<code>commands[<i>value</i>].handler</code> returns with true to handle a successful result (after `success` is printed)<hr><p>@*param* `manager` chatCommandManager ― Reference to this chat command manager</p><p>@*param* `...` any ― Any leftover arguments returned by the handler script will be passed over</p>
		---@field onError? fun(manager: chatCommandManager, ...: any) Function to call after<code>commands[<i>value</i>].handler</code> returns with false (not nil) to handle a failed result (after `error` is printed)<hr><p>@*param* `manager` chatCommandManager ― Reference to this chat command manager</p><p>@*param* `...` any ― Any leftover arguments returned by the handler script will be passed over</p>
		---@field hidden? boolean Skip printing this command when listing out chat commands on help | ***Default:*** `false`<ul><li>***Note:*** If `onHelp` is specified, it will still be called even if the command is hidden.</li></ul>
		---@field help? boolean If true, call `chatCommandManager.help()` on trigger | ***Default:*** `false`
		---@field onHelp? function Function to call after a specified help command has been triggered or an invalid command is typed with the specified keywords

		---@class chatCommandColors
		---@field title? color Color for the addon title used for branding chat messages | ***Default:*** `YELLOW_FONT_COLOR`
		---@field content? color Color for chat message contents appended after the title (used for success & error responses) | ***Default:*** `WHITE_FONT_COLOR`
		---@field command? color Used to color the registered chat commands when they are being listed | ***Default:*** `LIGHTBLUE_FONT_COLOR`
		---@field description? color Used to color the description of registered chat commands when they are being listed | ***Default:*** `LIGHTGRAY_FONT_COLOR`

	--| Returns

	---@class chatCommandManager
	local _ = {}

		---Print out a formatted chat message
		---@param message string Message content
		---@param title? string Title to start the message with | ***Default:*** *(addon title)*<ul><li>***Note:*** If "IconTexture" is specified in the TOC file of `addon`, a logo will also be included at the start of the message.</li></ul>
		---@param contentColor? chatCommandColorNames|color ***Default:*** `"content"`
		---@param titleColor? chatCommandColorNames|color ***Default:*** `"title"`
		function _.print(message, title, titleColor, contentColor) end

			---@alias chatCommandColorNames
			---| "title"
			---| "content"
			---| "command"
			---| "description"

		--Print a welcome message with a hint about chat keywords
		function _.welcome() end

		--Trigger a help command, listing all registered chat commands with their specified descriptions, calling their onHelp handlers
		function _.help() end

		---Find and a specific command by its name and call its handler script
		---***
		---@param command string Name of the slash command word (no spaces)
		---@param ... any Any further arguments are used as the payload of the command, passed over to its handler
		---***
		---@return boolean # Whether the command was found and the handler called successfully
		function _.handleCommand(command, ...) return false end
end


--[[ SETTINGS ]]

---Settings datamanagement rule registry
---@class settingsRegistry
---@field rules table<string, settingsRule[]> Collection of rules describing where to save/load settings data to/from, and what change handlers to call in the process linked to each specific settings category under an addon
---@field changeHandlers table<string, function> List of pairs of addon-specific unique keys and change handler scripts

	---@class settingsRule
	---@field widget DataWidgetType Reference to the widget to be saved & loaded data to/from with defined `loadData` and `saveData` functions
	---@field onChange? string[] List of keys referencing functions to be called after the value of `widget` was changed by the user or via settings datamanagement

		---@alias DataWidgetType
		---| datamanager
		---| binary
		---| checkbox
		---| radiobutton
		---| selector
		---| radiogroup
		---| dropdownRadiogroup
		---| specialSelector
		---| specialRadiogroup
		---| multiselector
		---| checkgroup
		---| textual
		---| textualEditbox
		---| customEditbox
		---| multilineEditbox
		---| numeric
		---| numericSlider
		---| colormanager
		---| colorpicker
		---| positionmanager
		---| positionPanel
		---| fontmanager
		---| fontPanel

---Register the settings page to the Settings window if it wasn't already
--- - ***Note:*** No settings page will be registered if `WidgetToolsDB.lite` is true.
---@param page settingsPage Reference to the settings page to register to Settings
---@param parent? settingsPage Reference to the parent settings page to set `page` as a child category page of | ***Default:*** *set as a parent category page*
---@param icon? boolean If true, append the icon set for the settings page to its button title in the AddOns list of the Settings window as well | ***Default:*** `true` if `parent == nil`
function wt.RegisterSettingsPage(page, parent, icon) end

--[ Data Management ]

---Register a settings datamanagement entry for a settings widget to the settings datamanagement registry for batched data handling
---***
---@param widget DataWidgetType Reference to the widget to be saved & loaded data to/from with defined `widget.loadData()` & `widget.saveData()` functions
---@param t settingsData Optional parameters
---***
---@return integer|nil index The index for the new entry for `widget` where it ended up in the settings datamanagement registry | ***Default:*** `nil`
function wt.AddSettingsDataManagementEntry(widget, t) end

---Load all data from storage to the widgets specified in the settings datamanagement registry in the specified `category` under the specified `key` by calling `datamanager.loadData(...)` for each
---***
---@param category? string A unique string used for categorizing settings datamanagement rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
---@param handleChanges? boolean If true, also call all registered change handlers | ***Default:*** `false`
function wt.LoadSettingsData(category, key, handleChanges) end

---Save all data from the widgets to storage specified in the settings datamanagement registry in the specified `category` under the specified `key` by calling `datamanager.saveData(...)` for each
---***
---@param category? string A unique string used for categorizing settings datamanagement rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.SaveSettingsData(category, key) end

---Call all `onChange` handlers registered in the settings datamanagement registry in the specified `category` under the specified `key`
---@param category? string A unique string used for categorizing settings datamanagement rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.ApplySettingsData(category, key) end

---Set a data snapshot for each widget specified in the settings datamanagement registry in the specified `category` under the specified `key` calling `datamanager.revertData()` for each
---***
---@param category? string A unique string used for categorizing settings datamanagement rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.SnapshotSettingsData(category, key) end

---Set & load the stored data managed by each widget specified in the settings datamanagement registry in the specified `category` under the specified `key` by calling `datamanager.revertData()` for each
---***
---@param category? string A unique string used for categorizing settings datamanagement rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.RevertSettingsData(category, key) end

---Set & load the default data managed by each widget specified in the settings datamanagement registry in the specified `category` under the specified `key` by calling `datamanager.resetData()` for each
---***
---@param category? string A unique string used for categorizing settings datamanagement rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.ResetSettingsData(category, key) end

---Handle changes for widgets in the settings datamanagement registry in the specified `category` under the specified `key` by calling registered `onChange` handlers for each
---@param index integer Filter the call of change handlers to only include the list under the specified index not each list in the specified `category` under the specified `key`
---@param category? string A unique string used for categorizing settings datamanagement rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.HandleWidgetChanges(index, category, key) end


--[[ CONTAINER ]]

--[ Panel ]

---Create a new simple panel frame
---***
---@param t? panelCreationData Optional parameters
---***
---@return panel|Frame panel Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame) overloaded with custom fields or none if `WidgetToolsDB.lite == true`
function wt.CreatePanel(t)

	--| Parameters

	---@class panelCreationData : labeledChildObject, describableObject, positionableScreenObject, arrangeableObject, visibleObject_base, backdropData, liteObject # t
	---@field name? string Unique string used to set the frame name | ***Default:*** `"Panel"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_panel|sizeData
	---@field background? backdropBackgroundData_panel Table containing the parameters used for the background
	---@field border? backdropBorderData_panel Table containing the parameters used for the border
	---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the panel and the functions to assign as event handlers called when they trigger
	---@field arrangement? arrangementRules_panel If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table
	---@field initialize? fun(container?: panel, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? panel ― Reference to the frame to be set as the parent for child objects created during initialization (nil if `WidgetToolsDB.lite` is true)</p><p>@*param* `width` number The current width of the container frame (0 if `WidgetToolsDB.lite` is true)</p><p>@*param* `height` number The current height of the container frame (0 if `WidgetToolsDB.lite` is true)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

		---@class labeledChildObject : titledChildObject, labeledObject_base

			---@class titledChildObject : namedChildObject, titledObject_base

				---@class namedChildObject : childObject, namedObject_base
				---@field append? boolean Instead of setting the specified name by itself, append it to the name of the specified parent frame | ***Default:*** `true` if t.parent ~= UIParent

					---@class childObject
					---@field parent? AnyFrameObject Reference to the frame to set as the parent

					---@class namedObject_base
					---@field name? string Unique string used to set the frame name | ***Default:*** `"Frame"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>

				---@class titledObject_base
				---@field title? string Text to be displayed as the title | ***Default:*** `t.name`

			---@class labeledObject_base
			---@field label? boolean Whether to show the title textline or not | ***Default:*** `true`

		---@class describableObject
		---@field description? string Text to be displayed as the subtitle or description | ***Default:*** *no description textline shown*

		---@class liteObject
		---@field lite? boolean If false, overrule `WidgetToolsDB.lite` and use full GUI functionality | ***Default:*** `true`

		---@class sizeData_panel
		---@field w? number Width | ***Default:*** `t.parent` and *width of the parent frame* - 20 or 0
		---@field h? number Height | ***Default:*** 0<ul><li>***Note:*** If content is added, arranged and `t.arrangeContent.resize` is true, the height will be set dynamically based on the calculated height of the content.</li></ul>

		---@class backdropBackgroundData_panel
		---@field texture? backdropBackgroundTextureData_panel Parameters used for setting the background texture
		---@field color? backgroundColorData_panel Apply the specified color to the background texture

			---@class backdropBackgroundTextureData_panel : backdropBackgroundTextureData
			---@field size? number Size of a single background tile square | ***Default:*** 5
			---@field insets? insetData_panel Offset the position of the background texture from the edges of the frame inward

				---@class insetData_panel
				---@field l? number Left side | ***Default:*** 4
				---@field r? number Right side | ***Default:*** 4
				---@field t? number Top | ***Default:*** 4
				---@field b? number Bottom | ***Default:*** 4

			---@class backgroundColorData_panel
			---@field r? number Red | ***Range:*** (`0`, `1`) | ***Default:*** 0.175
			---@field g? number Green | ***Range:*** (`0`, `1`) | ***Default:*** 0.175
			---@field b? number Blue | ***Range:*** (`0`, `1`) | ***Default:*** 0.175
			---@field a? number Opacity | ***Range:*** (`0`, `1`) | ***Default:*** 0.65

		---@class backdropBorderData_panel
		---@field texture? backdropBorderTextureData_panel Parameters used for setting the border texture
		---@field color? borderColorData_panel Apply the specified color to the border texture

			---@class backdropBorderTextureData_panel : backdropBorderTextureData
			---@field width? number Width of the backdrop edge | ***Default:*** 16

			---@class borderColorData_panel
			---@field r? number Red | ***Range:*** (`0`, `1`) | ***Default:*** `0.75`
			---@field g? number Green | ***Range:*** (`0`, `1`) | ***Default:*** `0.75`
			---@field b? number Blue | ***Range:*** (`0`, `1`) | ***Default:*** `0.75`
			---@field a? number Opacity | ***Range:*** (`0`, `1`) | ***Default:*** 0.5

		---@class arrangementRules_panel : arrangementRules
		---@field margins? spacingData_panel Inset the content inside the container frame by the specified amount on each side
		---@field gaps? number The amount of space to leave between rows and items within rows | ***Default:*** 8
		---@field flip? boolean Fill the rows from right to left instead of left to right | ***Default:*** `false`
		---@field resize? boolean Set the height of the container frame to match the space taken up by the arranged content (including margins) | ***Default:*** `true`

			---@class spacingData_panel : spacingData
			---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** `t.description` and 30 or 12

	--| Returns

	---@class panel : Frame
	---@field title? FontString Reference to the title textline appearing above the panel
	---@field description? FontString Reference to the description textline appearing in the panel

	return {}
end


--[[ CONTEXT MENU ]]

---Create a Blizzard context menu
---***
---@param t? contextMenuCreationData Optional parameters
---***
---@return contextMenu menu Table containing a reference to the root description of the context menu
function wt.CreateContextMenu(t)

	--| Parameters

	---@class contextMenuCreationData : contextMenuCreationData_base # t
	---@field triggers? contextMenuTriggerData[] List of trigger frames and behavior to link to toggle the context menu | ***Default:*** *(no triggers)*

		---@class contextMenuCreationData_base
		---@field initialize? fun(menu: contextMenu|contextSubmenu) This function will be called while setting up the menu to perform specific tasks like creating menu content items right away<hr><p>@*param* `menu` contextMenu|contextSubmenu ― Reference to the container of menu elements (such as titles, widgets, dividers or other frames) for menu items to be added to during initialization</p>

		---@class contextMenuTriggerData
		---@field frame AnyFrameObject? Reference to the frame to set as a trigger | ***Default:*** UIParent *(opened at cursor position)*
		---@field rightClick? boolean If true, create and open the context menu via a right-click mouse click event on `frame` | ***Default:*** `true`
		---@field leftClick? boolean If true, create and open the context menu via a left-click mouse click event on `frame` | ***Default:*** `false`
		---@field hover? boolean If true, create and open the context menu via a mouse hover event on `frame` | ***Default:*** `false`
		---@field condition? fun(action: "click"|"hover"|nil): boolean Function to call and evaluate before creating and opening the menu: if the returned value is not true, don't open the menu

	--| Returns

	---@class contextMenu
	---@field rootDescription? RootMenuDescriptionProxy Container of menu elements (such as titles, widgets, dividers or other frames)
	local _ = {}

		---Open the context menu
		---***
		---@param trigger? integer Index of the trigger to activate to have the menu opened defined in `t.triggers` | ***Default:*** `1`
		---@param action "click"|"hover"|nil The action that prompted the menu to be opened | ***Default:*** *no action:* `nil`
		function _.open(trigger, action) end

	return _
end

---Create a Blizzard context menu attached to a custom button frame to open it
---***
---@param t? popupMenuCreationData Optional parameters
---***
---@return Frame|BackdropTemplate trigger Reference to the custom frame used as a menu opener trigger button
---@return contextMenu menu Table containing a reference to the root description of the context menu
function wt.CreatePopupMenu(t)

	--| Parameters

	---@class popupMenuCreationData : labeledChildObject, tooltipDescribableWidget, positionableScreenObject, arrangeableObject, visibleObject_base, contextMenuCreationData_base # t
	---@field parent? AnyFrameObject Reference to the frame to set as the parent of the new frame | ***Default:*** `nil` *(parentless frame)*<ul><li>***Note:*** You may use [Region:SetParent(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegion_SetParent) to set the parent frame later.</li></ul>
	---@field name? string Unique string used to set the frame name | ***Default:*** `"PopupMenu"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_menuButton|sizeData
	---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnEvent](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent)" handlers specified here will not be set. Handler functions for specific global events should be specified in the `t.onEvent` table.</li></ul>
	---@field onEvent? table<WowEvent, fun(self: Frame, ...: any)> Table of key, value pairs that holds global event tags & their corresponding event handlers to be registered for the frame<ul><li>***Note:*** You may want to include [Frame:UnregisterEvent(...)](https://warcraft.wiki.gg/wiki/API_Frame_UnregisterEvent) to prevent the handler function to be executed again.</li><li>***Example:*** "[ADDON_LOADED](https://warcraft.wiki.gg/wiki/ADDON_LOADED)" is fired repeatedly after each addon. To call the handler only after one specified addon is loaded, you may check the parameter the handler is called with. It's a good idea to unregister the event to prevent repeated calling for every other addon after the specified one has been loaded already.<pre>```function(self, addon)```<br>&#9;```if addon ~= "AddonNameSpace" then return end --Replace "AddonNameSpace" with the namespace of the specific addon to watch```<br>&#9;```self:UnregisterEvent("ADDON_LOADED")```<br>&#9;```--Do something```<br>```end```</pre></li></ul>

		---@class sizeData_menuButton
		---@field w? number Width | ***Default:*** `18`0
		---@field h? number Height | ***Default:*** `26`

	return {}, {}
end

--[ Elements ]

---Create a submenu item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new submenu to
---@param t? contextSubmenuCreationData Optional parameters
---***
---@return contextSubmenu|nil menu Table containing a reference to the root description of the context menu
function wt.CreateSubmenu(menu, t)

	--| Parameters

	---@class contextSubmenu # menu
	---@field rootDescription ElementMenuDescriptionProxy Container of menu elements (such as titles, widgets, dividers or other frames)

	---@class contextSubmenuCreationData : contextMenuCreationData_base # t
	---@field title? string Text to be shown on the opener button item representing the submenu within the parent menu | ***Default:*** `"Submenu"`
end

---Create a textline item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? menuTextlineCreationData Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil textline Reference to the context textline UI object
function wt.CreateMenuTextline(menu, t)

	--| Parameters

	---@class menuTextlineCreationData : queuedMenuItem # t
	---@field text? string Text to be shown on the textline item within the parent menu | ***Default:*** `"Title"`

		---Optional parameters
		---@class queuedMenuItem
		---@field queue? boolean If true, the item will only appear when additional items are added to the menu | ***Default:*** `false`
end

---Create a divider item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? queuedMenuItem Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil divider Reference to the context divider UI object
function wt.CreateMenuDivider(menu, t) end

---Create a spacer item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? queuedMenuItem Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil spacer Reference to the context spacer UI object
function wt.CreateMenuSpacer(menu, t) end

---Create a button item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? menuButtonCreationData Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil button Reference to the context button UI object
function wt.CreateMenuButton(menu, t)

	--| Parameters

	---@class menuButtonCreationData # t
	---@field title? string Text to be shown on the button item within the parent menu | ***Default:*** `"Button"`
	---@field action? fun(...: any) Function to call when the button is clicked in the menu<hr><p>@*param* `...` any</p>
end


--[[ WIDGET ]]

---Create a non-GUI base widget
---***
---@param t? widgetCreationData Optional parameters
---***
---@return widget widget Reference to the new widget, utility functions and more wrapped in a table
function wt.CreateWidget(t)

	--| Parameters

	---@class widgetCreationData : togglableObject # t
	---@field listeners? widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class togglableObject
		---@field disabled? boolean If true, set the state of this widget to be disabled during initialization | ***Default:*** `false`<ul><li>***Note:*** Dependency rule evaluations may re-enable the widget after initialization.</li></ul>
		---@field dependencies? dependencyRule[] Automatically enable or disable the widget based on the set of rules described in subtables

			---@class dependencyRule
			---@field frame AnyFrameObject|binary|selector|multiselector|specialSelector|textual|numeric Tie the state of the widget to the evaluation of the current value of the frame specified here
			---@field evaluate? fun(value?: any): evaluation: boolean Call this function to evaluate the current value of the specified frame, enabling the dependant widget when true, or disabling it when false is returned | ***Default:*** *no evaluation, only for checkboxes*<ul><li>***Note:*** `evaluate` must be defined if the [FrameType](https://warcraft.wiki.gg/wiki/API_CreateFrame#Frame_types) if `frame` is not "CheckButton".</li><li>***Overloads:***</li><ul><li>function(`value`: boolean) -> `evaluation`: boolean — If `frame` is recognized as a checkbox</li><li>function(`value`: string) -> `evaluation`: boolean — If `frame` is recognized as an editbox</li><li>function(`value`: number) -> `evaluation`: boolean — If `frame` is recognized as a slider</li><li>function(`value`: integer) -> `evaluation`: boolean — If `frame` is recognized as a dropdown or selector</li><li>function(`value`: boolean[]) -> `evaluation`: boolean — If `frame` is recognized as multiselector</li><li>function(`value`: AnchorPoint|JustifyH|JustifyV|FrameStrata) -> `evaluation`: boolean — If `frame` is recognized as a special selector</li><li>function(`value`: nil) -> `evaluation`: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*</li></ul></ul>

		---@class widget_listeners
		---@field enabled? widget_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `widget.setEnabled(...)` was called
		---@field [string]? widget_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class widget_listener_enabled : eventHandlerIndex
			---@field handler widget_handler_enabled Handler function to register for call

				---@class eventHandlerIndex
				---@field callIndex? integer Set when to call the handler function in the execution order | ***Default:*** *placed at the end of the current list*

				---@alias widget_handler_enabled
				---| fun(self: widget, state: boolean) Called when an "enabled" event is invoked after `widget.setEnabled(...)` was called<hr><p>@*param* `self` widget ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class widget_listener_any : eventHandlerIndex
			---@field handler widget_handler_any Handler function to register for call

				---Handler function to call on trigger
				---@alias widget_handler_any
				---| fun(self: widget, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` widget ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class widget
	---@field invoke widget_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener widget_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, }
		function _.getTypes() return {} end

			---@alias typename_widget
			---| "Widget"

		---Checks and returns if the type of this widget matches the string provided
		---***
		---@param s typename|string
		---@return boolean
		---<p></p>
		function _.isType(s) return false end

		---Assign an additional type to this widget
		--- - ***Note:*** Be careful when adding types the widget does not implement to prevent potential expectation misalignment issues.
		---***
		---@param s typename|string
		---<p></p>
		function _.addType(s) end

		--| Events

		---Add a new custom widget event tag (not yet assigned to this widget) to be to assign and call listeners for by invoking
		---***
		---@param event string Unique custom event tag
		function _.addEvent(event) end

		---@class widget_invoke
		---@field enabled function Invoke an "enabled" event to notify registered listeners and call handlers
		---@field [string] fun(...) Invoke a custom event to notify registered listeners and call handlers, passing arguments along

		---@class widget_setListener
		---@field [string] fun(handler: widget_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "enabled" widget event
			---@param handler widget_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

--[ Action ]

---Create a non-GUI action widget base
---***
---@param t? actionCreationData Optional parameters
---@param widget? widget Reference to an already existing base widget to mutate into an action instead of creating a new one
---***
---@return action action Reference to the new action widget, utility functions and more wrapped in a table
function wt.CreateAction(t, widget)

	--| Parameters

	---@class actionCreationData : widgetCreationData # t
	---@field action? fun(self: action, user?: boolean) Function to call when the action is triggered<p>@*param* `self` action — Reference to the widget table</p><p>@*param* `user`? boolean — Marking whether the call is due to a user interaction or not | ***Default:*** `false`</p>
	---@field listeners? action_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class action_listeners : widget_listeners
		---@field trigger? action_listener_triggered[] Ordered list of functions to call when a "triggered" event is invoked after `action.trigger(...)` was called
		---@field enabled? action_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `action.setEnabled(...)` was called
		---@field _? action_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class action_listener_triggered : eventHandlerIndex
			---@field handler action_handler_triggered Handler function to register for call

				---@alias action_handler_triggered
			---| fun(self: action) Called when a "triggered" event is invoked after `action.trigger(...)` was called<hr><p>@*param* `self` action ― Reference to the widget table</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class action_listener_enabled : eventHandlerIndex
			---@field handler action_handler_enabled Handler function to register for call

				---@alias action_handler_enabled
			---| fun(self: action, state: boolean) Called when an "enabled" event is invoked after `action.setEnabled(...)` was called<hr><p>@*param* `self` action ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class action_listener_any : eventHandlerIndex
			---@field handler action_handler_any Handler function to register for call

				---@alias action_handler_any
			---| fun(self: action, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` action ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class action : widget
	---@field invoke action_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener action_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---Trigger the action registered for the action (if it is enabled)
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "trigger" event and call registered listeners | ***Default:*** `false`
		function _.trigger(user, silent) end

		---Set the function to call on trigger
		---@param call action_setAction_param1
		function _.setAction(call)

			--| Parameters

			---Function to call when the action is triggered
			---***
			---<p>@<i>param</i> <code>self</code> action — Reference to the widget table</p>
			---<p>@<i>param</i> <code>user</code>? boolean — Marking whether the call is due to a user interaction or not | <b><i>Default:</i></b> <code>false</code></p>
			---@alias action_setAction_param1 # call
			---| fun(self: action, user?: boolean)
		end

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_action]: true, }
		function _.getTypes() return {} end

			---@alias typename_action
			---| "Action"

		--| Events

		---@class action_invoke : widget_invoke
		---@field triggered fun(user: boolean) Invoke a "triggered" event to notify registered listeners and call handlers

		---@class action_setListener : widget_setListener
		---@field [string] fun(handler: action_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "triggered" widget event
			---@param handler action_handler_triggered Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.triggered(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler action_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

--| Button

---Create a Blizzard button GUI frame with enhanced widget functionality
---***
---@param t? actionButtonCreationData Optional parameters
---@param action? action Reference to an already existing action to mutate into a button instead of creating a new base widget
---***
---@return actionButton|action # References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table
function wt.CreateButton(t, action)

	--| Parameters

	---@class actionButtonCreationData : actionCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject # t
	---@field name? string Unique string used to set the frame name | ***Default:*** `"Button"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field titleOffset? offsetData Offset the position of the label of the button
	---@field size? sizeData_button|sizeData
	---@field font? labelFontOptions_highlight List of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label | ***Default:*** *normal sized default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via <code><i>WidgetToolbox</i>.CreateFont(...)</code> (even within this table definition).</li></ul>
	---@field listeners? button_listeners|action_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field events? table<ScriptButton, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the button and the functions to assign as event handlers called when they trigger<ul><li>***Example:*** "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" when the button is clicked.</li><li>***Note:*** `t.action` will automatically be called when an "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" widget events, there is no need to register it here as well.</li></ul>

		---@class sizeData_button
	---@field w? number Width | ***Default:*** 80
	---@field h? number Height | ***Default:*** `22`

		---@class labelFontOptions_highlight
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** `"GameFontNormal"`
		---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is being hovered | ***Default:*** `"GameFontHighlight"`
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** `"GameFontDisable"`

		---@class button_listeners : action_listeners
		---@field trigger? button_listener_triggered[] Ordered list of functions to call when a "triggered" event is invoked after `button.trigger(...)` was called
		---@field enabled? button_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `button.setEnabled(...)` was called
		---@field _? button_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class button_listener_triggered : eventHandlerIndex
			---@field handler button_handler_triggered Handler function to register for call

				---@alias button_handler_triggered
			---| fun(self: button) Called when a "triggered" event is invoked after `button.trigger(...)` was called<hr><p>@*param* `self` button ― Reference to the widget table</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an button taken by the user</p>

			---@class button_listener_enabled : eventHandlerIndex
			---@field handler button_handler_enabled Handler function to register for call

				---@alias button_handler_enabled
			---| fun(self: button, state: boolean) Called when an "enabled" event is invoked after `button.setEnabled(...)` was called<hr><p>@*param* `self` button ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class button_listener_any : eventHandlerIndex
			---@field handler button_handler_any Handler function to register for call

				---@alias button_handler_any
			---| fun(self: button, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` button ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class actionButton : action
	---@field label FontString|nil
	---@field frame Frame Frame to catch mouse interactions and serve as a hover trigger to be able to show the tooltip or when the button is disabled
	---@field widget Button
	---@field setListener button_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_action]: true, [typename_button]: true, }
		function _.getTypes() return {} end

			---@alias typename_button
			---| "Button"

		--| Events

		---@class button_setListener : action_setListener
		---@field [string] fun(handler: button_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "triggered" widget event
			---@param handler button_handler_triggered Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.triggered(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler button_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

---Create a Blizzard button GUI frame with customizable backdrop and enhanced widget functionality
---***
---@param t? customButtonCreationData Optional parameters
---@param action? action Reference to an already existing action to mutate into a custom button instead of creating a new base widget
---***
---@return customButton|action # References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button) (inheriting [BackdropTemplate](https://warcraft.wiki.gg/wiki/BackdropTemplate)), utility functions and more wrapped in a table
function wt.CreateCustomButton(t, action)

	--| Parameters

	---@class customButtonCreationData : actionButtonCreationData, customizableObject # t
	---@field font? labelFontOptions_small_highlight Table of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label | ***Default:*** *small default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via <code><i>WidgetToolbox</i>.CreateFont(...)</code> (even within this table definition).</li></ul>
	---@field listeners? customButton_listeners|action_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class customizableObject
		---@field backdrop? backdropData Parameters to set the custom backdrop with
		---@field backdropUpdates? backdropUpdateRule[] Table of key, value pairs containing the list of events to set listeners for assigned to <code>t.backdropUpdates[<i>key</i>].frame</code>, linking backdrop changes to it, modifying the specified parameters on trigger
		--- - ***Note:*** All update rules are additive, calling <code><i>WidgetToolbox</i>.SetBackdrop(...)</code> multiple times with `t.backdropUpdates` specified *will not* override previously set update rules. The base `backdrop` values used for these old rules *will not* change by setting a new backdrop via <code><i>WidgetToolbox</i>.SetBackdrop(...)</code> either!

		---@class labelFontOptions_small_highlight
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** `"GameFontNormalSmall"`
		---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is being hovered | ***Default:*** `"GameFontHighlightSmall"`
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** `"GameFontDisableSmall"`

		---@class customButton_listeners : action_listeners
		---@field trigger? customButton_listener_triggered[] Ordered list of functions to call when a "triggered" event is invoked after `customButton.trigger(...)` was called
		---@field enabled? customButton_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `customButton.setEnabled(...)` was called
		---@field _? customButton_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class customButton_listener_triggered : eventHandlerIndex
			---@field handler customButton_handler_triggered Handler function to register for call

				---@alias customButton_handler_triggered
			---| fun(self: customButton) Called when a "triggered" event is invoked after `customButton.trigger(...)` was called<hr><p>@*param* `self` customButton ― Reference to the widget table</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an customButton taken by the user</p>

			---@class customButton_listener_enabled : eventHandlerIndex
			---@field handler customButton_handler_enabled Handler function to register for call

				---@alias customButton_handler_enabled
			---| fun(self: customButton, state: boolean) Called when an "enabled" event is invoked after `customButton.setEnabled(...)` was called<hr><p>@*param* `self` customButton ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class customButton_listener_any : eventHandlerIndex
			---@field handler customButton_handler_any Handler function to register for call

				---@alias customButton_handler_any
			---| fun(self: customButton, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` customButton ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class customButton : actionButton
	---@field widget Button|BackdropTemplate
	---@field setListener customButton_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_action]: true, [typename_button]: true, [typename_customButton]: true, }
		function _.getTypes() return {} end

			---@alias typename_customButton
			---| "CustomButton"

		--| Events

		---@class customButton_setListener : action_setListener
		---@field [string] fun(handler: customButton_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "triggered" widget event
			---@param handler customButton_handler_triggered Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.triggered(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler customButton_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end


--[[ DATAMANAGER ]]

---Create a non-GUI base widget with generic datamanagement logic
---***
---@param t? datamanagerCreationData Optional parameters
---@param widget? widget Reference to an already existing base widget to mutate into a datamanager instead of creating a new one
---***
---@return datamanager datamanager Reference to the new datamanager widget, utility functions and more wrapped in a table
function wt.CreateDatamanager(t, widget)

	--| Parameters

		---Called to (if needed, modify and) load the widget data from storage
		---***
		---@return any? data ***Default:*** `nil`
		---@return boolean? success ***Default:*** `true`
		local function getData() end ---@cast getData +nil

		---Called to (if needed, modify and) save the widget data to storage
		---***
		---@param data? any ***Default:*** `nil`
		---***
		---@return boolean? success ***Default:*** `true`
		local function saveData(data) end ---@cast saveData +nil

	---Optional parameters
	---@class datamanagerCreationData : widgetCreationData
	---@field listeners? datamanager_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field dataManagement? settingsData If set, register this widget to settings datamanagement for batched data saving & loading and handling data changes
	---@field instantSave? boolean Immediately commit the data to storage whenever it's changed via the widget | ***Default:*** `true`<ul><li>***Note:*** Any unsaved data will be saved when <code><i>WidgetToolbox</i>.SaveOptionsData(...)</code> is executed.</li></ul>
	---@field value? any The starting state of the widget to set during initialization | ***Default:*** `t.getData()` or `t.default` if invalid
	---@field default? any Default value of the widget | ***Default:*** `nil`
	t = { getData = getData, saveData = saveData, }

		---@class settingsData
		---@field category? string A unique string used for categorizing settings datamanagement rules & change handler scripts | ***Default:*** `"WidgetTools"` *(register as a global rule)*
		---@field key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
		---@field index? integer Set when to place this widget in the execution order when saving or loading batched settings data | ***Default:*** *placed at the end of the current list*
		---@field onChange? table<string|integer, function|string> table<string|integer, function|string> List of new or already defined functions to call after the value of the widget was changed by the user or via settings datamanagement<ul><li><code>[<i>key</i>]</code>? string|integer ― A unique string appended to `category` to point to a newly defined function to be added to settings datamanagement or just the index of the next function name | ***Default:*** *next assigned index*</li><li><code>[<i>value</i>]</code> function|string ― The new function to register under its unique key, or the key of an already existing function</li><ul><li>***Note:*** Function definitions will be replaced by key references when they are registered to settings datamanagement. Functions registered under duplicate keys are overwritten.</li></ul></ul>

		---@class datamanager_listeners : widget_listeners
		---@field loaded? datamanager_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? datamanager_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? datamanager_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `datamanager.setValue(...)` was called
		---@field enabled? datamanager_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `datamanager.setEnabled(...)` was called
		---@field _? datamanager_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class datamanager_listener_loaded : eventHandlerIndex
			---@field handler datamanager_handler_loaded Handler function to register for call

				---@alias datamanager_handler_loaded
				---| fun(self: datamanager, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` datamanager ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class datamanager_listener_saved : eventHandlerIndex
			---@field handler datamanager_handler_saved Handler function to register for call

				---@alias datamanager_handler_saved
				---| fun(self: datamanager, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` datamanager ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class datamanager_listener_changed : eventHandlerIndex
			---@field handler datamanager_handler_changed Handler function to register for call

				---@alias datamanager_handler_changed
				---| fun(self: datamanager, state: boolean, user: boolean) Called when a "changed" event is invoked after `datamanager.setValue(...)` was called<hr><p>@*param* `self` datamanager ― Reference to the binary widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class datamanager_listener_enabled : eventHandlerIndex
			---@field handler datamanager_handler_enabled Handler function to register for call

				---@alias datamanager_handler_enabled
				---| fun(self: datamanager, state: boolean) Called when an "enabled" event is invoked after `datamanager.setEnabled(...)` was called<hr><p>@*param* `self` datamanager ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class datamanager_listener_any : eventHandlerIndex
			---@field handler datamanager_handler_any Handler function to register for call

				---@alias datamanager_handler_any
			---| fun(self: datamanager, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` datamanager ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class datamanager : widget
	---@field invoke datamanager_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener datamanager_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---Validate a value to be accepted by the widget
		---@param value? any
		---***
		---@return any # ***Default:*** `nil`
		function _.verify(value) end

		---Turn a value into a formatted string
		---***
		---@param value? any ***Default:*** *current value*
		---@return string
		function _.format(value) return "" end

		---Returns the current value of the widget
		---@return any
		function _.getValue() end

		---Verify and set the value of the widget
		---***
		---@param value? any
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _.setValue(value, user, silent) end

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via `t.saveData(...)`
		---***
		---@param data? any Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _.saveData(data, silent) end

		---Get the currently stored data via `t.getData()`
		---@return any
		function _.getData() end

		---Verify and save the provided data to storage via `t.saveData(...)` then load it to the widget via `t.loadData()`
		---***
		---@param data? any Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return any
		function _.getDefault() end

		---Set the default value
		---@param value? boolean ***Default:*** *current default value*
		function _.setDefault(value) end

		---Set and load the stored data managed by the widget to the default value specified via `t.default` at construction
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via `datamanager.revertData()`
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current value of the widget | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via `datamanager.snapshotData()`
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, }
		function _.getTypes() return {} end

			---@alias typename_datamanager
			---| "Datamanager"

		--| Events

		---@class datamanager_invoke : widget_invoke
		---@field loaded  fun(success: boolean) Invoke a "loaded" event to notify registered listeners and call handlers
		---@field saved  fun(success: boolean) Invoke a "saved" event to notify registered listeners and call handlers
		---@field changed fun(user: boolean) Invoke a "changed" event to notify registered listeners and call handlers

		---@class datamanager_setListener : widget_setListener
		---@field [string] fun(handler: datamanager_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler datamanager_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler datamanager_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler datamanager_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler datamanager_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

--[ Binary ]

---Create a non-GUI binary base widget with boolean datamanagement logic
---***
---@param t? binaryCreationData Optional parameters
---@param datamanager? datamanager Reference to an already existing datamanager to mutate into binary instead of creating a new base widget
---***
---@return binary binary Reference to the new binary widget, utility functions and more wrapped in a table
function wt.CreateBinary(t, datamanager)

	--| Parameters

	---@class binaryCreationData : datamanagerCreationData # t
	---@field listeners? binary_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): state: boolean|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `state` boolean|nil | ***Default:*** `false`</p>
	---@field saveData? fun(state: boolean) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `state` boolean</p>
	---@field value? boolean The starting state of the widget to set during initialization | ***Default:*** `t.getData()` or `t.default` if invalid
	---@field default? boolean Default value of the widget | ***Default:*** `false`

		---@class binary_listeners : datamanager_listeners
		---@field loaded? binary_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? binary_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? binary_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `binary.setState(...)` was called
		---@field enabled? binary_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `binary.setEnabled(...)` was called
		---@field _? binary_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class binary_listener_loaded : eventHandlerIndex
			---@field handler binary_handler_loaded Handler function to register for call

				---@alias binary_handler_loaded
				---| fun(self: binary, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` binary ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class binary_listener_saved : eventHandlerIndex
			---@field handler binary_handler_saved Handler function to register for call

				---@alias binary_handler_saved
				---| fun(self: binary, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` binary ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class binary_listener_changed : eventHandlerIndex
			---@field handler binary_handler_changed Handler function to register for call

				---@alias binary_handler_changed
				---| fun(self: binary, state: boolean, user: boolean) Called when a "changed" event is invoked after `binary.setState(...)` was called<hr><p>@*param* `self` binary ― Reference to the binary widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class binary_listener_enabled : eventHandlerIndex
			---@field handler binary_handler_enabled Handler function to register for call

				---@alias binary_handler_enabled
			---| fun(self: binary, state: boolean) Called when an "enabled" event is invoked after `binary.setEnabled(...)` was called<hr><p>@*param* `self` binary ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class binary_listener_any : eventHandlerIndex
			---@field handler binary_handler_any Handler function to register for call

				---@alias binary_handler_any
			---| fun(self: binary, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` binary ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class binary : datamanager
	---@field invoke datamanager_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener binary_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_binary]: true, }
		function _.getTypes() return {} end

			---@alias typename_binary
			---| "Binary"

		--| Events

		---@class binary_setListener : datamanager_setListener
		---@field [string] fun(handler: binary_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler binary_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler binary_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler binary_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler binary_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| Data management

		---Validate a value to be accepted by the widget
		---@param value? any
		---***
		---@return boolean # ***Default:*** `false`
		function _.verify(value) end

		---Turn a logical state into formatted string
		---***
		---@param state? boolean ***Default:*** *current value*
		---@return string
		function _.format(state) return "" end

		---Returns the current logical state of the widget
		---@return boolean
		function _.getValue() return false end

		---Verify and set the logical state of the widget to the provided state
		---***
		---@param state? boolean ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "flipped" event and call registered listeners | ***Default:*** `false`
		function _.setValue(state, user, silent) end

		---Flip the current logical state of the widget
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "flipped" event and call registered listeners | ***Default:*** `false`
		function _.flip(user, silent) end

		---Verify and save the provided data or the current value of the widget to storage via `t.saveData(...)`
		---***
		---@param state? boolean Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _.saveData(state, silent) end

		---Get the currently stored data via `t.getData()`
		---@return boolean|nil
		function _.getData() end

		---Verify and save the provided data to storage via `t.saveData(...)` then load it to the widget via `t.loadData()`
		---***
		---@param state? boolean Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(state, handleChanges, silent) end

		---Get the currently set default value
		---@return boolean
		function _.getDefault() return false end

		---Set the default value
		---@param state? boolean ***Default:*** `false`
		function _.setDefault(state) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via `binary.revertData()`
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via `binary.snapshotData()`
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

	return _
end

--| Checkbox

---Create a Blizzard checkbox GUI frame with enhanced widget functionality
---***
---@param t? checkboxCreationData Optional parameters
---@param binary? binary Reference to an already existing binary datamanager to mutate into a checkbox instead of creating a new base widget
---***
---@return checkbox|binary # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateCheckbox(t, binary)

	--| Parameters

	---@class checkboxCreationData : binaryCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject, tooltipDescribableSettingsWidget # t
	---@field name? string Unique string used to set the frame name | ***Default:*** `"Checkbox"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_checkbox|sizeData
	---@field font? labelFontOptions List of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label | ***Default:*** *normal sized default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via <code><i>WidgetToolbox</i>.CreateFont(...)</code> (even within this table definition).</li></ul>
	---@field listeners? checkbox_listeners|binary_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field events? table<ScriptButton, fun(self: checkbox, state: boolean, button?: string, down?: boolean)|fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the checkbox and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" will be called with custom parameters:<hr><p>@*param* `self` AnyFrameObject ― Reference to the checkbox widget</p><p>@*param* `state` boolean ― The checked state of the checkbox widget</p><p>@*param* `button`? string — Which button caused the click | ***Default:*** `"LeftButton"`</p><p>@*param* `down`? boolean — Whether the event happened on button press (down) or release (up) | ***Default:*** `false`</p></li></ul>

		---@class tooltipDescribableSettingsWidget
		---@field showDefault? boolean If true, show the default value of the widget in its tooltip and display the reset button its the utility menu | ***Default:*** `true`
		---@field utilityMenu? boolean If true, assign a context menu to the settings widget frame to allow for quickly resetting changes or the default value | ***Default:*** `true`

		---@class sizeData_checkbox
	---@field w? number Width | ***Default:*** `t.label and 180 or t.size.h`
	---@field h? number Height | ***Default:*** `26`

		---@class labelFontOptions
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** `"GameFontHighlight"`
		---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in a highlighted state | ***Default:*** `"GameFontNormal"`
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** `"GameFontDisable"`

		---@class checkbox_listeners : binary_listeners
		---@field loaded? binary_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? binary_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? checkbox_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `checkbox.setState(...)` was called
		---@field enabled? checkbox_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `checkbox.setEnabled(...)` was called
		---@field _? checkbox_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class checkbox_listener_loaded : eventHandlerIndex
			---@field handler checkbox_handler_loaded Handler function to register for call

				---@alias checkbox_handler_loaded
				---| fun(self: checkbox, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` checkbox ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class checkbox_listener_saved : eventHandlerIndex
			---@field handler checkbox_handler_saved Handler function to register for call

				---@alias checkbox_handler_saved
				---| fun(self: checkbox, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` checkbox ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class checkbox_listener_changed : eventHandlerIndex
			---@field handler checkbox_handler_changed Handler function to register for call

				---@alias checkbox_handler_changed
				---| fun(self: checkbox, state: boolean, user: boolean) Called when a "changed" event is invoked after `checkbox.setState(...)` was called<hr><p>@*param* `self` checkbox ― Reference to the checkbox widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class checkbox_listener_enabled : eventHandlerIndex
			---@field handler checkbox_handler_enabled Handler function to register for call

				---@alias checkbox_handler_enabled
			---| fun(self: checkbox, state: boolean) Called when an "enabled" event is invoked after `checkbox.setEnabled(...)` was called<hr><p>@*param* `self` checkbox ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class checkbox_listener_any : eventHandlerIndex
			---@field handler checkbox_handler_any Handler function to register for call

				---@alias checkbox_handler_any
			---| fun(self: checkbox, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` checkbox ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class checkbox: binary
	---@field frame Frame Click target
	---@field widget SettingsCheckbox Checkbox
	---@field label FontString|nil
	---@field setListener checkbox_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---NOTE: Incomplete Toolbox-relevant definition for a Frame of `"SettingsCheckboxTemplate"`
		---@class SettingsCheckbox : CheckButton
		---@field HoverBackground Frame

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_binary]: true, [typename_checkbox]: true, }
		function _.getTypes() return {} end

			---@alias typename_checkbox
			---| "Checkbox"

		--| Events

		---@class checkbox_setListener : binary_setListener
		---@field [string] fun(handler: checkbox_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler checkbox_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler checkbox_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler checkbox_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler checkbox_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

---Create a classic Blizzard checkbox GUI frame with enhanced widget functionality
---***
---@param t? classicCheckboxCreationData Optional parameters
---@param binary? binary Reference to an already existing binary datamanager to mutate into a checkbox instead of creating a new base widget
---***
---@return classicCheckbox|binary # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateClassicCheckbox(t, binary)

	--| Parameters

	---@class classicCheckboxCreationData : checkboxCreationData
	---@field listeners? classicCheckbox_listeners|binary_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field font nil

	---@class classicCheckbox_listeners : binary_listeners
	---@field loaded? classicCheckbox_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
	---@field saved? classicCheckbox_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
	---@field changed? classicCheckbox_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `classicCheckbox.setState(...)` was called
	---@field enabled? classicCheckbox_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `classicCheckbox.setEnabled(...)` was called
	---@field _? classicCheckbox_listener_any[] Ordered list of functions to call when a custom event is invoked

		---@class classicCheckbox_listener_loaded : eventHandlerIndex
		---@field handler classicCheckbox_handler_loaded Handler function to register for call

			---@alias classicCheckbox_handler_loaded
			---| fun(self: classicCheckbox, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` classicCheckbox ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

		---@class classicCheckbox_listener_saved : eventHandlerIndex
		---@field handler classicCheckbox_handler_saved Handler function to register for call

			---@alias classicCheckbox_handler_saved
			---| fun(self: classicCheckbox, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` classicCheckbox ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

		---@class classicCheckbox_listener_changed : eventHandlerIndex
		---@field handler classicCheckbox_handler_changed Handler function to register for call

			---@alias classicCheckbox_handler_changed
			---| fun(self: classicCheckbox, state: boolean, user: boolean) Called when a "changed" event is invoked after `classicCheckbox.setState(...)` was called<hr><p>@*param* `self` classicCheckbox ― Reference to the classicCheckbox widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

		---@class classicCheckbox_listener_enabled : eventHandlerIndex
		---@field handler classicCheckbox_handler_enabled Handler function to register for call

			---@alias classicCheckbox_handler_enabled
		---| fun(self: classicCheckbox, state: boolean) Called when an "enabled" event is invoked after `classicCheckbox.setEnabled(...)` was called<hr><p>@*param* `self` classicCheckbox ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

		---@class classicCheckbox_listener_any : eventHandlerIndex
		---@field handler classicCheckbox_handler_any Handler function to register for call

			---@alias classicCheckbox_handler_any
		---| fun(self: classicCheckbox, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` classicCheckbox ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class classicCheckbox : binary
	---@field frame Frame Click target
	---@field widget CheckButton|BackdropTemplate Checkbox
	---@field label FontString|nil
	---@field setListener classicCheckbox_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_binary]: true, [typename_classicCheckbox]: true, }
		function _.getTypes() return {} end

			---@alias typename_classicCheckbox
			---| "ClassicCheckbox"

		--| Events

		---@class classicCheckbox_setListener : binary_setListener
		---@field [string] fun(handler: classicCheckbox_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler classicCheckbox_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler classicCheckbox_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler classicCheckbox_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler classicCheckbox_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

--| Radiobutton

---Create a Blizzard radio button GUI frame with enhanced widget functionality
---***
---@param t? radiobuttonCreationData Optional parameters
---@param binary? binary Reference to an already existing binary datamanager to mutate into a radio button instead of creating a new base widget
---***
---@return radiobutton|binary # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateRadiobutton(t, binary)

	--| Parameters

	---@class radiobuttonCreationData : checkboxCreationData # t
	---@field size? sizeData_radiobutton|sizeData
	---@field clearable? boolean Whether this radio button should be clearable by right clicking on it or not | ***Default:*** `false`<ul><li>***Note:*** The radio button will be registered for `"RightButtonUp"` triggers to call "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" events with `button = "RightButton"`.</li></ul>
	---@field listeners? radiobutton_listeners|binary_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field events? table<ScriptButton, fun(self: radiobutton, state: boolean, button?: string, down?: boolean)|fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the radio button and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" will be called with custom parameters:<hr><p>@*param* `self` AnyFrameObject ― Reference to the radiobutton widget</p><p>@*param* `state` boolean ― The checked state of the radiobutton widget</p><p>@*param* `button`? string — Which button caused the click | ***Default:*** `"LeftButton"`</p><p>@*param* `down`? boolean — Whether the event happened on button press (down) or release (up) | ***Default:*** `false`</p></li></ul>

		---@class sizeData_radiobutton
	---@field w? number Width | ***Default:***  `t.label` and 180 or `t.size.h`
	---@field h? number Height | ***Default:*** `18`

		---@class labelFontOptions_small
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** `"GameFontHighlightSmall"`
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** `"GameFontDisableSmall"`

		---@class radiobutton_listeners : binary_listeners
		---@field loaded? radiobutton_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? radiobutton_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? radiobutton_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `radiobutton.setState(...)` was called
		---@field enabled? radiobutton_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `radiobutton.setEnabled(...)` was called
		---@field _? radiobutton_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class radiobutton_listener_loaded : eventHandlerIndex
			---@field handler radiobutton_handler_loaded Handler function to register for call

				---@alias radiobutton_handler_loaded
				---| fun(self: radiobutton, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` radiobutton ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class radiobutton_listener_saved : eventHandlerIndex
			---@field handler radiobutton_handler_saved Handler function to register for call

				---@alias radiobutton_handler_saved
				---| fun(self: radiobutton, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` radiobutton ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class radiobutton_listener_changed : eventHandlerIndex
			---@field handler radiobutton_handler_changed Handler function to register for call

				---@alias radiobutton_handler_changed
				---| fun(self: radiobutton, state: boolean, user: boolean) Called when a "changed" event is invoked after `radiobutton.setState(...)` was called<hr><p>@*param* `self` radiobutton ― Reference to the radiobutton widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class radiobutton_listener_enabled : eventHandlerIndex
			---@field handler radiobutton_handler_enabled Handler function to register for call

				---@alias radiobutton_handler_enabled
			---| fun(self: radiobutton, state: boolean) Called when an "enabled" event is invoked after `radiobutton.setEnabled(...)` was called<hr><p>@*param* `self` radiobutton ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class radiobutton_listener_any : eventHandlerIndex
			---@field handler radiobutton_handler_any Handler function to register for call

				---@alias radiobutton_handler_any
			---| fun(self: radiobutton, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` radiobutton ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class radiobutton: binary
	---@field frame Frame Click target
	---@field widget CheckButton Radio button
	---@field label FontString|nil
	---@field setListener radiobutton_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_binary]: true, [typename_radiobutton]: true, }
		function _.getTypes() return {} end

			---@alias typename_radiobutton
			---| "Radiobutton"

		--| Events

		---@class radiobutton_setListener : binary_setListener
		---@field [string] fun(handler: radiobutton_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler radiobutton_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler radiobutton_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler radiobutton_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler radiobutton_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

--[ Selector ]

---Create a non-GUI selector base widget (managing a set of binary widgets) with integer (selection index) datamanagement logic
---***
---@param t? selectorCreationData Optional parameters
---@param datamanager? datamanager Reference to an already existing datamanager to mutate into a selector instead of creating a new base widget
---***
---@return selector selector Reference to the new selector widget, utility functions and more wrapped in a table
function wt.CreateSelector(t, datamanager)

	--| Parameters

	---@class selectorCreationData : datamanagerCreationData, selectorCreationData_base # t
	---@field items? (selectorItem|selectorBinary|binary)[] Table containing subtables with data used to create item widgets, or already existing binary datamanagers
	---@field listeners? selector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): selected: integer|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `selected` integer|nil | ***Default:*** `nil` *(no selection)*</p>
	---@field saveData? fun(selected?: integer) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `selected`? integer</p>
	---@field value? integer The index of the item to be set as selected during initialization | ***Default:*** `t.getData()` or `t.default` if invalid or 1 if `t.clearable` is false
	---@field default? integer Default value of the widget | ***Default:*** `1 or nil` *(no selection)* if `t.clearable` is true

		---@class selectorCreationData_base
		---@field clearable? boolean If true, the value of the selector input should be clearable and allowed to be set to nil | ***Default:*** `false`

		---@class selectorItem
		---@field title? string Text to be shown on the right of the item to represent the item within the selector frame (if `t.labels` is true)
		---@field tooltip? itemTooltipTextData|widgetTooltipTextData List of text lines to be added to the tooltip of the item displayed when mousing over the frame
		---@field onSelect? function The function to be called when the item is selected by the user

			---@class itemTooltipTextData : tooltipTextData
			---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** <code>t.items[<i>index</i>].title</code>

			---@class widgetTooltipTextData : tooltipTextData
			---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** `t.title`

		---@class selectorBinary : binary
		---@field index integer The index of this binary item inside a selector widget

		---@class selector_listeners : datamanager_listeners
		---@field loaded? selector_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? selector_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? selector_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `selector.setSelected(...)` was called or an option was clicked or cleared
		---@field updated? selector_listener_updated[] Ordered list of functions to call when an "updated" event is invoked after `selector.updatedItems(...)` was called
		---@field added? selector_listener_added[] Ordered list of functions to call when an "added" event is invoked when a new binary item is added to the selector via `selector.updatedItems(...)`
		---@field enabled? selector_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `selector.setEnabled(...)` was called
		---@field _? selector_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class selector_listener_loaded : eventHandlerIndex
			---@field handler selector_handler_loaded Handler function to register for call

				---@alias selector_handler_loaded
				---| fun(self: selector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` selector ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class selector_listener_saved : eventHandlerIndex
			---@field handler selector_handler_saved Handler function to register for call

				---@alias selector_handler_saved
				---| fun(self: selector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` selector ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class selector_listener_changed : eventHandlerIndex
			---@field handler selector_handler_changed Handler function to register for call

				---@alias selector_handler_changed
				---| fun(self: selector, selected?: integer, user: boolean) Called when an "changed" event is invoked after `selector.setSelected(...)` was called or an option was clicked or cleared<hr><p>@*param* `self` selector ― Reference to the selector widget</p><p>@*param* `selected` integer ― The index of the currently selected item</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class selector_listener_updated : eventHandlerIndex
			---@field handler selector_handler_updated Handler function to register for call

				---@alias selector_handler_updated
				---| fun(self: selector) Called when an "updated" event is invoked after `selector.updatedItems(...)` was called<hr><p>@*param* `self` selector ― Reference to the selector widget</p>

			---@class selector_listener_added : eventHandlerIndex
			---@field handler selector_handler_updated Handler function to register for call

				---@alias selector_handler_added
				---| fun(self: selector, binary: binary|selectorBinary) Called when a new binary item is added to the selector via `selector.updatedItems(...)`<hr><p>@*param* `self` selector ― Reference to the selector widget</p><p>@*param* `binary` binary|selectorBinary ― Reference to the binary widget added to the selector</p>

			---@class selector_listener_enabled : eventHandlerIndex
			---@field handler selector_handler_enabled Handler function to register for call

				---@alias selector_handler_enabled
				---| fun(self: selector, state: boolean) Called when an "enabled" event is invoked after `selector.setEnabled(...)` was called<hr><p>@*param* `self` selector ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class selector_listener_any : eventHandlerIndex
			---@field handler selector_handler_any Handler function to register for call

				---@alias selector_handler_any
				---| fun(self: selector, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` selector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class selector : datamanager
	---@field items (binary|selectorBinary)[]
	---@field invoke selector_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener selector_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_selector]: true, }
		function _.getTypes() return {} end

			---@alias typename_selector
			---| "Selector"

		--| Events

		---@class selector_invoke : datamanager_invoke
		---@field updated function Invoke a "updated" event to notify registered listeners and call handlers
		---@field added fun(binary: binary|selectorBinary) Invoke an "added" event to notify registered listeners and call handlers

		---@class selector_setListener : datamanager_setListener
		---@field [string] fun(handler: selector_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler selector_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler selector_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler selector_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "updated" widget event
			---@param handler selector_handler_updated Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.updated(handler, callIndex) end

			---Register a listener for a "added" widget event
			---@param handler selector_handler_added Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.added(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler selector_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| Toggle items

		---Update the list of items currently set for the selector widget, updating its parameters and binary widgets
		--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
		--- - ***Note:*** The currently selected item may not be the same after an item was removed. In that case, the item at the same index will be selected instead. If one or more items from the last indexes were removed, the new last item at the reduced count index will be selected. Make sure to use `selector.setSelected(...)` to correct the selection if needed!
		---***
		---@param newItems (selectorItem|binary|selectorBinary)[] Table containing subtables with data used to update the binary widgets, or already existing binary widgets
		---@param silent? boolean If false, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
		function _.updateItems(newItems, silent) end

		--| Data management

		---Validate a value to be accepted by the widget
		---@param value any
		---***
		---@return integer|nil ***Default:*** *current value*
		function _.verify(value) end

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via `t.saveData(...)`
		---***
		---@param data? wrappedInteger If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.saveData(data, silent) end

			---@class wrappedInteger
			---@field index? integer ***Default:*** `nil` *(no selection)*

		---Get the currently stored data via `t.getData()`
		---@return integer|nil
		function _.getData() end

		---Verify and save the provided data to storage via `t.saveData(...)` then load it to the widget via `t.loadData()`
		---***
		---@param data? wrappedInteger If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return integer|nil default
		function _.getDefault() end

		---Set the default value
		---@param index integer|nil | ***Default:*** *no change*
		function _.setDefault(index) end

		---Set and load the stored data managed by the widget to the default value specified via `t.default` at construction
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via `selector.revertData()`
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via `selector.snapshotData()`
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Returns the index of the currently selected item or nil if there is no selection
		---@return integer|nil index
		function _.getSelected() end

		---Verify and set the specified item as selected
		---***
		---@param index? integer ***Default:*** `nil` *(no selection)*
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "selected" event and call registered listeners | ***Default:*** `false`
		function _.setSelected(index, user, silent) end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

---Create a non-GUI special selector base widget (managing a set of binary widgets) with datamanagement logic specific to the specified `itemset`
---***
---@param itemset CreateSpecialSelector_param1 Specify what type of selector should be created
---@param t? specialSelectorCreationData Optional parameters
---@param datamanager? datamanager Reference to an already existing datamanager to mutate into a special selector instead of creating a new base widget
---***
---@return specialSelector specialSelector Reference to the new selector widget, utility functions and more wrapped in a table
function wt.CreateSpecialSelector(itemset, t, datamanager)

	--| Parameters

	--Specify what type of selector should be created
	---@alias CreateSpecialSelector_param1 # itemset
	---| SpecialSelectorItemset

		---@alias SpecialSelectorItemset
		---| "anchor" Using the set of [AnchorPoint](https://warcraft.wiki.gg/wiki/Anchors) items
		---| "justifyH" Using the set of horizontal text alignment items (JustifyH)
		---| "justifyV" Using the set of vertical text alignment items (JustifyV)
		---| "strata" Using the set of [FrameStrata](https://warcraft.wiki.gg/wiki/Frame_Strata) items (excluding "WORLD")

	---@class specialSelectorCreationData : datamanagerCreationData, selectorCreationData_base # t
	---@field listeners? specialSelector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): value: integer|specialSelectorValueTypes|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `value` integer|AnchorPoint|JustifyH|JustifyV|FrameStrata|nil — The index or the value of the item to be set as selected ***Default:*** `nil` *(no selection)*</p>
	---@field saveData? fun(value?: specialSelectorValueTypes) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `value`? AnchorPoint|JustifyH|JustifyV|FrameStrata</p>
	---@field value? integer|specialSelectorValueTypes The item to be set as selected during initialization | ***Default:*** `t.getData()` or `t.default` if invalid or *option 1* if `t.clearable` is false
	---@field default? integer|specialSelectorValueTypes Default value of the widget | ***Default:*** *option 1* or nil *(no selection)* if `t.clearable` is true

		---@alias specialSelectorValueTypes
		---| FramePoint
		---| JustifyHorizontal
		---| JustifyVertical
		---| FrameStrata

		---@class specialSelector_listeners : datamanager_listeners
		---@field loaded? specialSelector_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? specialSelector_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? specialSelector_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `specialSelector.setSelected(...)` was called or an option was clicked or cleared
		---@field enabled? specialSelector_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `specialSelector.setEnabled(...)` was called
		---@field _? specialSelector_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class specialSelector_listener_loaded : eventHandlerIndex
			---@field handler specialSelector_handler_loaded Handler function to register for call

				---@alias specialSelector_handler_loaded
				---| fun(self: specialSelector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class specialSelector_listener_saved : eventHandlerIndex
			---@field handler specialSelector_handler_saved Handler function to register for call

				---@alias specialSelector_handler_saved
				---| fun(self: specialSelector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class specialSelector_listener_changed : eventHandlerIndex
			---@field handler specialSelector_handler_changed Handler function to register for call

				---@alias specialSelector_handler_changed
				---| fun(self: specialSelector, selected?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata, user: boolean) Called when an "changed" event is invoked after `specialSelector.setSelected(...)` was called or an option was clicked or cleared<hr><p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `selected` AnchorPoint|JustifyH|JustifyV|FrameStrata ― The currently selected value</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class specialSelector_listener_enabled : eventHandlerIndex
			---@field handler specialSelector_handler_enabled Handler function to register for call

				---@alias specialSelector_handler_enabled
				---| fun(self: specialSelector, state: boolean) Called when an "enabled" event is invoked after `specialSelector.setEnabled(...)` was called<hr><p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class specialSelector_listener_any : eventHandlerIndex
			---@field handler specialSelector_handler_any Handler function to register for call

				---@alias specialSelector_handler_any
				---| fun(self: specialSelector, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` specialSelector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class specialSelector : datamanager
	---@field items (binary|selectorBinary)[]
	---@field invoke datamanager_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener specialSelector_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---Return the itemset type specified for this special selector on creation
		---@return SpecialSelectorItemset itemset
		function _.getItemset() return "anchor" end

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_specialSelector]: true, }
		function _.getTypes() return {} end

			---@alias typename_specialSelector
			---| "SpecialSelector"

		--| Events

		---@class specialSelector_setListener : datamanager_setListener
		---@field [string] fun(handler: specialSelector_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler specialSelector_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler specialSelector_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler specialSelector_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler specialSelector_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| Data management

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via `t.saveData(...)`
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.saveData(data, silent) end

			---@class wrappedAnchor
			---@field value? FramePoint ***Default:*** `nil` *(no selection)*

			---@class wrappedJustifyH
			---@field value? JustifyHorizontal ***Default:*** `nil` *(no selection)*

			---@class wrappedJustifyV
			---@field value? JustifyVertical ***Default:*** `nil` *(no selection)*

			---@class wrappedStrata
			---@field value? FrameStrata ***Default:*** `nil` *(no selection)*

		---Get the currently stored data via `t.getData()`
		---@return specialSelectorValueTypes|nil
		function _.getData() end

		---Verify and save the provided data to storage via `t.saveData(...)` then load it to the widget via `t.loadData()`
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return specialSelectorValueTypes|nil default
		function _.getDefault() end

		---Set the default value
		---***
		---@param selected integer|specialSelectorValueTypes|nil | ***Default:*** *no change*
		---<p></p>
		function _.setDefault(selected) end

		---Set and load the stored data managed by the widget to the default value specified via `t.default` at construction
		---***
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via `selector.revertData()`
		---***
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via `selector.snapshotData()`
		---***
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Returns the value of the currently selected item or nil if there is no selection
		---@return specialSelectorValueTypes|nil selected
		---<p></p>
		function _.getSelected() end

		---Set the specified item as selected
		---***
		---@param selected integer|specialSelectorValueTypes|nil The index or the value of the item to be set as selected | ***Default:*** *no selection:* `nil`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "selected" event and call registered listeners | ***Default:*** `false`
		---<p></p>
		function _.setSelected(selected, user, silent) end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

---Create a non-GUI multiselector base widget (managing a set of binary widgets) with boolean mask datamanagement logic
---***
---@param t? multiselectorCreationData Optional parameters
---@param datamanager? datamanager Reference to an already existing datamanager to mutate into a multiselector instead of creating a new base widget
---***
---@return multiselector multiselector Reference to the new multiselector widget, utility functions and more wrapped in a table
function wt.CreateMultiselector(t, datamanager)

	--| Parameters

	---@class multiselectorCreationData : datamanagerCreationData # t
	---@field items? (selectorItem|binary)[] Table containing subtables with data used to create item widgets, or already existing binary datamanagers
	---@field limits? limitValues Parameters to specify the limits of the number of selectable items
	---@field listeners? multiselector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): selections: boolean[] Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `selections` boolean[] | ***Default:*** *no selected items: `false[]`*</p>
	---@field saveData? fun(selections?: boolean[]) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `selections`? boolean[] | ***Default:*** *no selected items: `false[]`*</p>
	---@field value? boolean[] Ordered list of item states to set during initialization | ***Default:*** `t.getData()` or `t.default` if invalid
	---@field default? boolean[] Default value of the widget | ***Default:*** *no selected items: `false[]`*

		---@class limitValues
		---@field min? integer The minimal number of items that need to be selected at all times | ***Default:*** `1`
		---@field max? integer The maximal number of items that can be selected at once | ***Default:*** `#t.items` *(all items)*

		---@class multiselector_listeners : datamanager_listeners
		---@field loaded? multiselector_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? multiselector_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? multiselector_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `multiselector.setSelected(...)` was called or an option was clicked or cleared
		---@field updated? multiselector_listener_updated[] Ordered list of functions to call when an "updated" event is invoked after `multiselector.updatedItems(...)` was called
		---@field added? multiselector_listener_added[] Ordered list of functions to call when an "added" event is invoked when a new binary item is added to the selector via `multiselector.updatedItems(...)`
		---@field min? multiselector_listener_limited[] Ordered list of functions to call when a "limited" event is invoked after a lower limit update occurs
		---@field enabled? multiselector_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `multiselector.setEnabled(...)` was called
		---@field _? multiselector_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class multiselector_listener_loaded : eventHandlerIndex
			---@field handler multiselector_handler_loaded Handler function to register for call

				---@alias multiselector_handler_loaded
				---| fun(self: multiselector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class multiselector_listener_saved : eventHandlerIndex
			---@field handler multiselector_handler_saved Handler function to register for call

				---@alias multiselector_handler_saved
				---| fun(self: multiselector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class multiselector_listener_changed : eventHandlerIndex
			---@field handler multiselector_handler_changed Handler function to register for call

				---@alias multiselector_handler_changed
				---| fun(self: multiselector, selections: boolean[], user: boolean) Called when an "changed" event is invoked after `multiselector.setSelected(...)` was called or an option was clicked or cleared<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `selections` boolean[] ― Indexed list of the current item states</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class multiselector_listener_updated : eventHandlerIndex
			---@field handler multiselector_handler_updated Handler function to register for call

				---@alias multiselector_handler_updated
				---| fun(self: multiselector) Called when an "updated" event is invoked after `multiselector.updatedItems(...)` was called<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p>

			---@class multiselector_listener_added : eventHandlerIndex
			---@field handler multiselector_handler_added Handler function to register for call

				---@alias multiselector_handler_added
				---| fun(self: multiselector, binary: binary|selectorBinary) Called when a new binary item is added to the selector via `multiselector.updatedItems(...)`<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `binary` binary|selectorBinary ― Reference to the binary widget added to the selector</p>

			---@class multiselector_listener_limited : eventHandlerIndex
			---@field handler multiselector_handler_limited Handler function to register for call

				---@alias multiselector_handler_limited
				---| fun(self: multiselector, min: boolean, max: boolean, passed: boolean) Called when a "limited" event is invoked after a limit update occurs<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `min` boolean ― True, if the number of selected items is equal to lower than the specified lower limit</p><p>@*param* `max` boolean ― True, if the number of selected items is equal to higher than the specified upper limit</p><p>@*param* `passed` boolean ― True, if the number of selected items is below or over the specified lower or upper limit</p>

			---@class multiselector_listener_enabled : eventHandlerIndex
			---@field handler multiselector_handler_enabled Handler function to register for call

				---@alias multiselector_handler_enabled
				---| fun(self: multiselector, state: boolean) Called when an "enabled" event is invoked after `multiselector.setEnabled(...)` was called<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class multiselector_listener_any : eventHandlerIndex
	---@field handler multiselector_handler_any Handler function to register for call

				---@alias multiselector_handler_any
				---| fun(self: multiselector, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` multiselector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class multiselector : datamanager
	---@field items (binary|selectorBinary)[]
	---@field invoke multiselector_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener multiselector_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_multiselector]: true, }
		function _.getTypes() return {} end

			---@alias typename_multiselector
			---| "Multiselector"

		--| Events

		---@class multiselector_invoke : datamanager_invoke
		---@field updated function Invoke a "updated" event to notify registered listeners and call handlers
		---@field added fun(binary: binary|selectorBinary) Invoke an "added" event to notify registered listeners and call handlers
		---@field limited fun(count: integer) Invoke a "limited" event to notify registered listeners and call handlers

		---@class multiselector_setListener : datamanager_setListener
		---@field [string] fun(handler: multiselector_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler multiselector_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler multiselector_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler multiselector_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "updated" widget event
			---@param handler multiselector_handler_updated Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.updated(handler, callIndex) end

			---Register a listener for a "added" widget event
			---@param handler multiselector_handler_added Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.added(handler, callIndex) end

			---Register a listener for a "limited" widget event
			---@param handler multiselector_handler_limited Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.limited(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler multiselector_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| Toggle items

		---Update the list of items currently set for the selector widget, updating its parameters and binary widgets
		--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
		--- - ***Note:*** The currently selected item may not be the same after item were removed. In that case, the new item at the same index will be selected instead. If one or more items from the last indexes were removed, the new last item at the reduced count index will be selected. Make sure to use `selector.setSelected(...)` to correct the selection if needed!
		---***
		---@param newItems (selectorItem|binary|selectorBinary)[] Table containing subtables with data used to update the binary widgets, or already existing binary widgets
		---@param silent? boolean If false, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
		function _.updateItems(newItems, silent) end

		--| Data management

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via `t.saveData(...)`
		---***
		---@param data? wrappedBooleanArray If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.saveData(data, silent) end

			---@class wrappedBooleanArray
			---@field states? boolean[] Indexed list of current item states in order | ***Default:*** `false`[] *(no selected items)*

		---Get the currently stored data via `t.getData()`
		---@return boolean[]|nil
		function _.getData() end

		---Verify and save the provided data to storage via `t.saveData(...)` then load it to the widget via `t.loadData()`
		---***
		---@param data? wrappedBooleanArray If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return boolean[] default
		function _.getDefault() return {} end

		---Set the default value
		---@param selections? boolean[] | ***Default:*** *no selected items: `false[]`*
		function _.setDefault(selections) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via `selector.snapshotData()`
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via `selector.revertData()`
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the default value specified via `t.default` at construction
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Returns the list of all items and their current states
		---***
		---@return boolean[] selections Indexed list of item states
		function _.getSelections() return {} end

		---Set the specified items as selected
		---***
		---@param selections? boolean[] Indexed list of item states | ***Default:*** *no selected items: `false[]`*
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke "selected" and "limited" events and call registered listeners | ***Default:*** `false`
		function _.setSelections(selections, user, silent) end

		---Set the specified item as selected
		---***
		---@param index integer Index of the item | ***Range:*** (`1`, `#selector.items`)
		---@param selected? boolean If true, set the item at this index as selected | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke "selected" and "limited" events and call registered listeners | ***Default:*** `false`
		function _.setSelected(index, selected, user, silent) end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

--| Selector frames

---Create a radio button selector GUI frame to pick one out of multiple options with enhanced widget functionality
---***
---@param t? radiogroupCreationData Optional parameters
---@param selector? CreateRadiogroup_param2 Reference to an already existing selector to mutate into a radio selector instead of creating a new base widget
---***
---@return radiogroup|selector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
function wt.CreateRadiogroup(t, selector)

	--| Parameters

	---@class radiogroupCreationData : selectorCreationData, selectorFrameCreationData, radiogroupCreationData_base # t
	---@field width? number The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or `t.label` and 180 or 0 *(whichever is greater)*<ul><li>***Note:*** The width of each individual item will be set to `t.width` if `t.columns` is 1 and `t.width` is specified.</li></ul>
	---@field items? (selectorItem|selectorRadiobutton)[] Table containing subtables with data used to create item widgets, or already existing radio buttons
	---@field columns? integer Arrange the newly created widget items in a grid with the specified number of columns instead of a vertical list | ***Default:*** `1`
	---@field labels? boolean Whether or not to add the labels to the right of each newly created widget item | ***Default:*** `true`
	---@field listeners? radiogroup_listeners|selector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class selectorFrameCreationData : labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject
		---@field name? string Unique string used to set the frame name | ***Default:*** `"Selector"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
		---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the selector frame and the functions to assign as event handlers called when they trigger

		---@class radiogroupCreationData_base : tooltipDescribableSettingsWidget
		---@field clearable? boolean If true, the selector input should be clearable by right clicking on its radio buttons, setting the selected value to nil | ***Default:*** `false`

		---@class radiogroup_listeners : selector_listeners
		---@field loaded? radiogroup_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? radiogroup_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? radiogroup_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `radiogroup.setSelected(...)` was called or an option was clicked or cleared
		---@field updated? radiogroup_listener_updated[] Ordered list of functions to call when an "updated" event is invoked after `radiogroup.updatedItems(...)` was called
		---@field added? radiogroup_listener_added[] Ordered list of functions to call when an "added" event is invoked when a new binary item is added to the radiogroup via `radiogroup.updatedItems(...)`
		---@field enabled? radiogroup_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `radiogroup.setEnabled(...)` was called
		---@field _? radiogroup_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class radiogroup_listener_loaded : eventHandlerIndex
			---@field handler radiogroup_handler_loaded Handler function to register for call

				---@alias radiogroup_handler_loaded
				---| fun(self: radiogroup, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class radiogroup_listener_saved : eventHandlerIndex
			---@field handler radiogroup_handler_saved Handler function to register for call

				---@alias radiogroup_handler_saved
				---| fun(self: radiogroup, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class radiogroup_listener_changed : eventHandlerIndex
			---@field handler radiogroup_handler_changed Handler function to register for call

				---@alias radiogroup_handler_changed
				---| fun(self: radiogroup, selected?: integer, user: boolean) Called when an "changed" event is invoked after `radiogroup.setSelected(...)` was called or an option was clicked or cleared<hr><p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p><p>@*param* `selected` integer ― The index of the currently selected item</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class radiogroup_listener_updated : eventHandlerIndex
			---@field handler radiogroup_handler_updated Handler function to register for call

				---@alias radiogroup_handler_updated
				---| fun(self: radiogroup) Called when an "updated" event is invoked after `radiogroup.updatedItems(...)` was called<hr><p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p>

			---@class radiogroup_listener_added : eventHandlerIndex
			---@field handler radiogroup_handler_updated Handler function to register for call

				---@alias radiogroup_handler_added
				---| fun(self: radiogroup, binary: binary|selectorBinary) Called when a new binary item is added to the radiogroup via `radiogroup.updatedItems(...)`<hr><p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p><p>@*param* `binary` binary|selectorBinary ― Reference to the binary widget added to the radiogroup</p>

			---@class radiogroup_listener_enabled : eventHandlerIndex
			---@field handler radiogroup_handler_enabled Handler function to register for call

				---@alias radiogroup_handler_enabled
				---| fun(self: radiogroup, state: boolean) Called when an "enabled" event is invoked after `radiogroup.setEnabled(...)` was called<hr><p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class radiogroup_listener_any : eventHandlerIndex
			---@field handler radiogroup_handler_any Handler function to register for call

				---@alias radiogroup_handler_any
				---| fun(self: radiogroup, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` radiogroup ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	---Reference to an already existing selector to mutate into a radio selector instead of creating a new base widget
	---@alias CreateRadiogroup_param2
	---| selector
	---| specialSelector
	---| nil

	--| Returns

	---@class radiogroup : selector
	---@field frame Frame|table
	---@field label FontString|nil
	---@field binaries? selectorRadiobutton[] The list of radio button widgets linked together in this selector
	---@field setListener radiogroup_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---@class selectorRadiobutton : selectorBinary, radiobutton

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_selector]: true, [typename_radiogroup]: true, }
		function _.getTypes() return {} end

			---@alias typename_radiogroup
			---| "Radiogroup"

		--| Events

		---@class radiogroup_setListener : selector_setListener
		---@field [string] fun(handler: radiogroup_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler radiogroup_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler radiogroup_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler radiogroup_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "updated" widget event
			---@param handler radiogroup_handler_updated Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.updated(handler, callIndex) end

			---Register a listener for a "added" widget event
			---@param handler radiogroup_handler_added Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.added(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler radiogroup_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

---Create a dropdown radio button selector GUI frame to pick one out of multiple options with enhanced widget functionality
---***
---@param t? dropdownRadiogroupCreationData Optional parameters
---@param selector? selector Reference to an already existing selector to mutate into a radio selector instead of creating a new base widget
---***
---@return dropdownRadiogroup|selector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, a toggle [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table
function wt.CreateDropdownRadiogroup(t, selector)

	--| Parameters

	---@class dropdownRadiogroupCreationData : radiogroupCreationData, widgetWidthValue, tooltipDescribableSettingsWidget # t
	---@field name? string Unique string used to set the frame name | ***Default:*** `"Dropdown"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field width? number The width of the dropdown frame containing the toggle and (optionally) cycle buttons and the label (if `t.label` is true) | ***Default:*** `18`0
	---@field scrollThreshold? integer Number of items to show before changing the dropdown menu to be scrollable | ***Default:*** 15<ul><li>***Note:*** Scrollability does not change when the number of items change after the initial setup.</li></ul>
	---@field text? string The default text to display on the dropdown when no item is selected | ***Default:*** `""`
	---@field clearable? boolean If true, the selector input should be clearable by right clicking on its radio buttons, or, if `t.utilityMenu` is false, the dropdown toggle button itself (if true, a clear selection option is added to the utility menu instead), setting the selected value to nil | ***Default:*** `false`
	---@field autoClose? boolean Close the dropdown menu after an item is selected by the user | ***Default:*** `true`
	---@field cycleButtons? boolean Add previous & next item buttons next to the dropdown | ***Default:*** `true`
	---@field listeners? dropdownRadiogroup_listeners|radiogroup_listeners|selector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class widgetWidthValue
		---@field width? number ***Default:*** `18`0

		---@class dropdownRadiogroup_listeners : radiogroup_listeners
		---@field loaded? dropdownRadiogroup_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? dropdownRadiogroup_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? dropdownRadiogroup_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `dropdownRadiogroup.setSelected(...)` was called or an option was clicked or cleared
		---@field updated? dropdownRadiogroup_listener_updated[] Ordered list of functions to call when an "updated" event is invoked after `dropdownRadiogroup.updatedItems(...)` was called
		---@field added? dropdownRadiogroup_listener_added[] Ordered list of functions to call when an "added" event is invoked when a new binary item is added to the dropdownRadiogroup via `dropdownRadiogroup.updatedItems(...)`
		---@field enabled? dropdownRadiogroup_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `dropdownRadiogroup.setEnabled(...)` was called
		---@field _? dropdownRadiogroup_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class dropdownRadiogroup_listener_loaded : eventHandlerIndex
			---@field handler dropdownRadiogroup_handler_loaded Handler function to register for call

				---@alias dropdownRadiogroup_handler_loaded
				---| fun(self: dropdownRadiogroup, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class dropdownRadiogroup_listener_saved : eventHandlerIndex
			---@field handler dropdownRadiogroup_handler_saved Handler function to register for call

				---@alias dropdownRadiogroup_handler_saved
				---| fun(self: dropdownRadiogroup, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class dropdownRadiogroup_listener_changed : eventHandlerIndex
			---@field handler dropdownRadiogroup_handler_changed Handler function to register for call

				---@alias dropdownRadiogroup_handler_changed
				---| fun(self: dropdownRadiogroup, selected?: integer, user: boolean) Called when an "selected" event is invoked after `dropdownRadiogroup.setSelected(...)` was called or an option was clicked or cleared<hr><p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p><p>@*param* `selected` integer ― The index of the currently selected item</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class dropdownRadiogroup_listener_updated : eventHandlerIndex
			---@field handler dropdownRadiogroup_handler_updated Handler function to register for call

				---@alias dropdownRadiogroup_handler_updated
				---| fun(self: dropdownRadiogroup) Called when an "updated" event is invoked after `dropdownRadiogroup.updatedItems(...)` was called<hr><p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p>

			---@class dropdownRadiogroup_listener_added : eventHandlerIndex
			---@field handler dropdownRadiogroup_handler_updated Handler function to register for call

				---@alias dropdownRadiogroup_handler_added
				---| fun(self: dropdownRadiogroup, binary: binary|selectorBinary) Called when a new binary item is added to the dropdownRadiogroup via `dropdownRadiogroup.updatedItems(...)`<hr><p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p><p>@*param* `binary` binary|selectorBinary ― Reference to the binary widget added to the dropdownRadiogroup</p>

			---@class dropdownRadiogroup_listener_enabled : eventHandlerIndex
			---@field handler dropdownRadiogroup_handler_enabled Handler function to register for call

				---@alias dropdownRadiogroup_handler_enabled
				---| fun(self: dropdownRadiogroup, state: boolean) Called when an "enabled" event is invoked after `dropdownRadiogroup.setEnabled(...)` was called<hr><p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class dropdownRadiogroup_listener_any : eventHandlerIndex
			---@field handler dropdownRadiogroup_handler_any Handler function to register for call

				---@alias dropdownRadiogroup_handler_any
				---| fun(self: dropdownRadiogroup, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` dropdownRadiogroup ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class dropdownRadiogroup : radiogroup
	---@field holderFrame Frame Main holder frame for the dropdown toggle, buttons and title
	---@field menu panel Panel frame holding the dropdown selector widget
	---@field content panel
	---@field toggle customButton
	---@field previous customButton
	---@field next customButton
	---@field setListener dropdownRadiogroup_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---Set the text displayed on the label of the toggle button
		---***
		---@param text? string ***Default:*** <code>t.items[<i>index</i>].title</code> *(the title of the currently selected item)* or "…" *(if there is no selection)*
		---@param silent? boolean If false, invoke a "labeled" event and call registered listeners | ***Default:*** `false`
		function _.setText(text, silent) end

		---Toggle the dropdown menu
		---@param state? boolean ***Default:*** `not selector.list:IsVisible()`
		function _.toggleMenu(state) end

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_selector]: true, [typename_radiogroup]: true, [typename_dropdownRadiogroup]: true, }
		function _.getTypes() return {} end

			---@alias typename_dropdownRadiogroup
			---| "DropdownRadiogroup"

		--| Events

		---@class dropdownRadiogroup_setListener : radiogroup_setListener
		---@field [string] fun(handler: dropdownRadiogroup_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler dropdownRadiogroup_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler dropdownRadiogroup_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler dropdownRadiogroup_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "updated" widget event
			---@param handler dropdownRadiogroup_handler_updated Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.updated(handler, callIndex) end

			---Register a listener for a "added" widget event
			---@param handler dropdownRadiogroup_handler_added Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.added(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler dropdownRadiogroup_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

---Create a special radio button selector GUI frame to pick an Anchor Point, a horizontal or vertical text alignment or Frame Strata value with enhanced widget functionality
---***
---@param itemset CreateSpecialRadiogroup_param1 Specify what type of selector should be created
--- - ***Note:*** Value is overwritten by `selector.getItemset()` if a valid `selector` is provided.
---@param t? specialRadiogroupCreationData Optional parameters
---@param selector? specialSelector|selector Reference to an already existing special selector widget to mutate into a special selector frame instead of creating a new base widget
---***
---@return specialSelector|specialRadiogroup # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
function wt.CreateSpecialRadiogroup(itemset, t, selector)

	--| Parameters

	---Specify what type of selector should be created
	--- - ***Note:*** Value is overwritten by `selector.getItemset()` if a valid `selector` is provided.
	---@alias CreateSpecialRadiogroup_param1 # itemset
	---| SpecialSelectorItemset
	---| nil

	---@class specialRadiogroupCreationData : specialSelectorCreationData, selectorFrameCreationData, radiogroupCreationData_base # t
	---@field listeners? specialRadiogroup_listeners|specialSelector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class specialRadiogroup_listeners : specialSelector_listeners
		---@field loaded? specialRadiogroup_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? specialRadiogroup_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? specialRadiogroup_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `specialRadiogroup.setSelected(...)` was called or an option was clicked or cleared
		---@field enabled? specialRadiogroup_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `specialRadiogroup.setEnabled(...)` was called
		---@field _? specialRadiogroup_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class specialRadiogroup_listener_loaded : eventHandlerIndex
			---@field handler specialRadiogroup_handler_loaded Handler function to register for call

				---@alias specialRadiogroup_handler_loaded
				---| fun(self: specialSelector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class specialRadiogroup_listener_saved : eventHandlerIndex
			---@field handler specialRadiogroup_handler_saved Handler function to register for call

				---@alias specialRadiogroup_handler_saved
				---| fun(self: specialSelector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class specialRadiogroup_listener_changed : eventHandlerIndex
			---@field handler specialRadiogroup_handler_changed Handler function to register for call

				---@alias specialRadiogroup_handler_changed
				---| fun(self: specialSelector, selected?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata, user: boolean) Called when an "changed" event is invoked after `specialRadiogroup.setSelected(...)` was called or an option was clicked or cleared<hr><p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `selected` AnchorPoint|JustifyH|JustifyV|FrameStrata ― The currently selected value</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class specialRadiogroup_listener_enabled : eventHandlerIndex
			---@field handler specialRadiogroup_handler_enabled Handler function to register for call

				---@alias specialRadiogroup_handler_enabled
				---| fun(self: specialSelector, state: boolean) Called when an "enabled" event is invoked after `specialRadiogroup.setEnabled(...)` was called<hr><p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class specialRadiogroup_listener_any : eventHandlerIndex
			---@field handler specialRadiogroup_handler_any Handler function to register for call

				---@alias specialRadiogroup_handler_any
				---| fun(self: specialSelector, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` specialSelector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class specialRadiogroup : specialSelector
	---@field frame Frame|table
	---@field label FontString|nil
	---@field binaries? selectorRadiobutton[] The list of radio button widgets linked together in this selector
	---@field setListener specialRadiogroup_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_specialSelector]: true, [typename_specialRadiogroup]: true, }
		function _.getTypes() return {} end

			---@alias typename_specialRadiogroup
			---| "SpecialRadiogroup"

		--| Events

		---@class specialRadiogroup_setListener : specialSelector_setListener
		---@field [string] fun(handler: specialRadiogroup_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler specialRadiogroup_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler specialRadiogroup_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler specialRadiogroup_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler specialRadiogroup_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

---Create a checkbox selector GUI frame to pick multiple options out of a list with enhanced widget functionality
---***
---@param t? checkgroupCreationData Optional parameters
---@param selector? multiselector Reference to an already existing selector to mutate into a multiple selector instead of creating a new base widget
---***
---@return checkgroup|multiselector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
function wt.CreateCheckgroup(t, selector)

	--| Parameters

	---@class checkgroupCreationData : multiselectorCreationData, selectorFrameCreationData, tooltipDescribableSettingsWidget # t
	---@field width? number The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or `t.label` and 160 or 0 *(whichever is greater)*<ul><li>***Note:*** The width of each individual item will be set to `t.width` if `t.columns` is 1 and `t.width` is specified.</li></ul>
	---@field items? (selectorItem|selectorCheckbox)[] Table containing subtables with data used to create item widgets, or already existing checkboxes
	---@field labels? boolean Whether or not to add the labels to the right of each newly created widget item | ***Default:*** `true`
	---@field columns? integer Arrange the newly created widget items in a grid with the specified number of columns instead of a vertical list | ***Default:*** `1`
	---@field listeners? checkgroup_listeners|multiselector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class checkgroup_listeners : multiselector_listeners
		---@field loaded? checkgroup_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? checkgroup_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? checkgroup_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `checkgroup.setSelected(...)` was called or an option was clicked or cleared
		---@field updated? checkgroup_listener_updated[] Ordered list of functions to call when an "updated" event is invoked after `checkgroup.updatedItems(...)` was called
		---@field added? checkgroup_listener_added[] Ordered list of functions to call when an "added" event is invoked when a new binary item is added to the selector via `checkgroup.updatedItems(...)`
		---@field min? checkgroup_listener_limited[] Ordered list of functions to call when a "limited" event is invoked after a lower limit update occurs
		---@field enabled? checkgroup_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `checkgroup.setEnabled(...)` was called
		---@field _? checkgroup_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class checkgroup_listener_loaded : eventHandlerIndex
			---@field handler checkgroup_handler_loaded Handler function to register for call

				---@alias checkgroup_handler_loaded
				---| fun(self: multiselector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class checkgroup_listener_saved : eventHandlerIndex
			---@field handler checkgroup_handler_saved Handler function to register for call

				---@alias checkgroup_handler_saved
				---| fun(self: multiselector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class checkgroup_listener_changed : eventHandlerIndex
			---@field handler checkgroup_handler_changed Handler function to register for call

				---@alias checkgroup_handler_changed
				---| fun(self: multiselector, selections: boolean[], user: boolean) Called when an "changed" event is invoked after `checkgroup.setSelected(...)` was called or an option was clicked or cleared<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `selections` boolean[] ― Indexed list of the current item states</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class checkgroup_listener_updated : eventHandlerIndex
			---@field handler checkgroup_handler_updated Handler function to register for call

				---@alias checkgroup_handler_updated
				---| fun(self: multiselector) Called when an "updated" event is invoked after `checkgroup.updatedItems(...)` was called<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p>

			---@class checkgroup_listener_added : eventHandlerIndex
			---@field handler checkgroup_handler_added Handler function to register for call

				---@alias checkgroup_handler_added
				---| fun(self: multiselector, binary: binary|selectorBinary) Called when a new binary item is added to the selector via `checkgroup.updatedItems(...)`<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `binary` binary|selectorBinary ― Reference to the binary widget added to the selector</p>

			---@class checkgroup_listener_limited : eventHandlerIndex
			---@field handler checkgroup_handler_limited Handler function to register for call

				---@alias checkgroup_handler_limited
				---| fun(self: multiselector, min: boolean, max: boolean, passed: boolean) Called when a "limited" event is invoked after a limit update occurs<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `min` boolean ― True, if the number of selected items is equal to lower than the specified lower limit</p><p>@*param* `max` boolean ― True, if the number of selected items is equal to higher than the specified upper limit</p><p>@*param* `passed` boolean ― True, if the number of selected items is below or over the specified lower or upper limit</p>

			---@class checkgroup_listener_enabled : eventHandlerIndex
			---@field handler checkgroup_handler_enabled Handler function to register for call

				---@alias checkgroup_handler_enabled
				---| fun(self: multiselector, state: boolean) Called when an "enabled" event is invoked after `checkgroup.setEnabled(...)` was called<hr><p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class checkgroup_listener_any : eventHandlerIndex
			---@field handler checkgroup_handler_any Handler function to register for call

				---@alias checkgroup_handler_any
				---| fun(self: multiselector, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` multiselector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class checkgroup : multiselector
	---@field frame Frame|table
	---@field label FontString|nil
	---@field binaries? selectorCheckbox[] The list of checkbox widgets linked together in this selector
	---@field setListener checkgroup_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---@class selectorCheckbox : selectorBinary, checkbox

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_multiselector]: true, [typename_checkgroup]: true, }
		function _.getTypes() return {} end

			---@alias typename_checkgroup
			---| "Checkgroup"

		--| Events

		---@class checkgroup_setListener : multiselector_setListener
		---@field [string] fun(handler: checkgroup_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler checkgroup_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler checkgroup_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler checkgroup_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "updated" widget event
			---@param handler checkgroup_handler_updated Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.updated(handler, callIndex) end

			---Register a listener for a "added" widget event
			---@param handler checkgroup_handler_added Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.added(handler, callIndex) end

			---Register a listener for a "limited" widget event
			---@param handler checkgroup_handler_limited Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.limited(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler checkgroup_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

--[ Text ]

---Create a non-GUI textual base widget with string datamanagement logic
---***
---@param t? textualCreationData Optional parameters
---@param datamanager? datamanager Reference to an already existing datamanager to mutate into textual instead of creating a new base widget
---***
---@return textual textual Reference to the new textual datamanager, utility functions and more wrapped in a table
function wt.CreateTextual(t, datamanager)

	--| Parameters

	---@class textualCreationData : datamanagerCreationData # t
	---@field color? color Apply the specified color to all text in the editbox (overriding all font objects set in `t.font`)
	---@field listeners? textual_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): text: string|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `text` string|nil | ***Default:*** `""` *(empty string)*</p>
	---@field saveData? fun(text: string) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `text` string</p>
	---@field value? string The starting text to be set during initialization | ***Default:*** `t.getData()` or `t.default` if invalid
	---@field default? string Default value of the widget | ***Default:*** `""` *(empty string)*

		---@class textual_listeners : datamanager_listeners
		---@field loaded? textual_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? textual_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? textual_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `textual.setText(...)` was called
		---@field enabled? textual_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `textual.setEnabled(...)` was called
		---@field _? textual_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class textual_listener_loaded : eventHandlerIndex
			---@field handler textual_handler_loaded Handler function to register for call

				---@alias textual_handler_loaded
				---| fun(self: textual, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class textual_listener_saved : eventHandlerIndex
			---@field handler textual_handler_saved Handler function to register for call

				---@alias textual_handler_saved
				---| fun(self: textual, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class textual_listener_changed : eventHandlerIndex
			---@field handler textual_handler_changed Handler function to register for call

				---@alias textual_handler_changed
				---| fun(self: textual, text: string, user: boolean) Called when an "changed" event is invoked after `textual.setText(...)` was called<hr><p>@*param* `self` textual ― Reference to the binary widget</p><p>@*param* `text` string ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class textual_listener_enabled : eventHandlerIndex
			---@field handler textual_handler_enabled Handler function to register for call

				---@alias textual_handler_enabled
				---| fun(self: textual, state: boolean) Called when an "enabled" event is invoked after `textual.setEnabled(...)` was called<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class textual_listener_any : eventHandlerIndex
			---@field handler textual_handler_any Handler function to register for call

				---@alias textual_handler_any
				---| fun(self: textual, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class textual : datamanager
	---@field invoke datamanager_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener textual_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_textual]: true, }
		function _.getTypes() return {} end

			---@alias typename_textual
			---| "Textual"

		--| Events

		---@class textual_setListener : datamanager_listeners
		---@field [string] fun(handler: textual_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler textual_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler textual_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler textual_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler textual_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| Data management

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via `t.saveData(...)`
		---***
		---@param text? string Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _.saveData(text, silent) end

		---Get the currently stored data via `t.getData()`
		---@return string|nil
		function _.getData() end

		---Verify and save the provided data to storage via `t.saveData(...)` then load it to the widget via `t.loadData()`
		---***
		---@param text? string Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(text, handleChanges, silent) end

		---Get the currently set default value
		---@return string default
		function _.getDefault() return "" end

		---Set the default value
		---@param text string | ***Default:*** `""`
		function _.setDefault(text) end

		---Set and load the stored data managed by the widget to the default value specified via `t.default` at construction
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via `textual.revertData()`
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via `textual.snapshotData()`
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Returns the current text value of the widget
		---@return string
		function _.getText() return "" end

		---Set the text value of the widget
		---***
		---@param text? string ***Default:*** `""`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _.setText(text, user, silent) end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

--| Editbox

---Create a default single-line Blizzard editbox GUI frame with enhanced widget functionality
---***
---@param t? editboxCreationData Optional parameters
---@param textual? textual Reference to an already existing textual datamanager to mutate into an editbox instead of creating a new base widget
---***
---@return textualEditbox|textual # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateEditbox(t, textual)

	--| Properties

	---@class editboxCreationData : textualCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject, tooltipDescribableSettingsWidget # t
	---@field name? string Unique string used to set the frame name | ***Default:*** `"Textbox"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_editbox|sizeData
	---@field insets? insetData Table containing padding values by which to offset the position of the text in the editbox
	---@field font? labelFontOptions_editbox List of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via <code><i>WidgetToolbox</i>.CreateFont(...)</code> (even within this table definition).</li></ul>
	---@field justify? justifyData_left Set the justification of the text (overriding all font objects set in `t.font`)
	---@field charLimit? number The value to limit the character count by | ***Default:*** `0` *(no limit)*
	---@field readOnly? boolean The text will be uneditable if true | ***Default:*** `false`
	---@field focusOnShow? boolean Focus the editbox when its shown and highlight the text | ***Default:*** `false`
	---@field keepFocused? boolean Keep the editbox focused while its being shown | ***Default:*** `false`
	---@field unfocusOnEnter? boolean Whether to automatically clear the focus from the editbox when the ENTER key is pressed | ***Default:*** `true`
	---@field resetCursor? boolean If true, set the cursor position to the beginning of the string after setting the text via `textual.setText(...)` | ***Default:*** `true`
	---@field listeners? editbox_listeners|textual_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field events? table<ScriptEditBox, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the editbox frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnChar](https://warcraft.wiki.gg/wiki/UIHANDLER_OnChar)" will be called with custom parameters:<p>@*param* `self` AnyFrameObject ― Reference to the editbox frame</p><p>@*param* `char` string ― The UTF-8 character that was typed</p><p>@*param* `text` string ― The text typed into the editbox</p></li><li>***Note:*** "[OnTextChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnTextChanged)" will be called with custom parameters:<p>@*param* `self` AnyFrameObject ― Reference to the editbox frame</p><p>@*param* `text` string ― The text typed into the editbox</p><p>@*param* `user` string ― True if the value was changed by the user, false if it was done programmatically</p></li><li>***Note:*** "[OnEnterPressed](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEnterPressed)" will be called with custom parameters:<p>@*param* `self` AnyFrameObject ― Reference to the editbox frame</p><p>@*param* `text` string ― The text typed into the editbox</p></li></ul>

		---@class sizeData_editbox
		---@field w? number Width | ***Default:***  180
		---@field h? number Height | ***Default:*** `18`

		---@class labelFontOptions_editbox
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** *default font based on the frame template*
		---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is being hovered | ***Default:*** *default font based on the frame template*
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** *default font based on the frame template*

		---@class justifyData_left
		---@field h? JustifyHorizontal Horizontal text alignment| ***Default:*** `"LEFT"`
		---@field v? JustifyVertical Vertical text alignment | ***Default:*** `"MIDDLE"`

		---@class editbox_listeners : textual_listeners
		---@field loaded? editbox_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? editbox_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? editbox_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `editbox.setText(...)` was called
		---@field enabled? editbox_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `editbox.setEnabled(...)` was called
		---@field _? editbox_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class editbox_listener_loaded : eventHandlerIndex
			---@field handler editbox_handler_loaded Handler function to register for call

				---@alias editbox_handler_loaded
				---| fun(self: textual, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class editbox_listener_saved : eventHandlerIndex
			---@field handler editbox_handler_saved Handler function to register for call

				---@alias editbox_handler_saved
				---| fun(self: textual, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class editbox_listener_changed : eventHandlerIndex
			---@field handler editbox_handler_changed Handler function to register for call

				---@alias editbox_handler_changed
				---| fun(self: textual, text: string, user: boolean) Called when an "changed" event is invoked after `editbox.setText(...)` was called<hr><p>@*param* `self` textual ― Reference to the binary widget</p><p>@*param* `text` string ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class editbox_listener_enabled : eventHandlerIndex
			---@field handler editbox_handler_enabled Handler function to register for call

				---@alias editbox_handler_enabled
				---| fun(self: textual, state: boolean) Called when an "enabled" event is invoked after `editbox.setEnabled(...)` was called<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class editbox_listener_any : eventHandlerIndex
			---@field handler editbox_handler_any Handler function to register for call

				---@alias editbox_handler_any
				---| fun(self: textual, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class textualEditbox : textual
	---@field frame Frame
	---@field widget EditBox
	---@field label FontString|nil
	---@field setListener editbox_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_textual]: true, [typename_editbox]: true, }
		function _.getTypes() return {} end

			---@alias typename_editbox
			---| "Editbox"

		--| Events

		---@class editbox_setListener : textual_listeners
		---@field [string] fun(handler: editbox_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler editbox_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler editbox_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler editbox_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler editbox_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

---Create a single-line Blizzard editbox frame with custom GUI and enhanced widget functionality
---***
---@param t? customEditboxCreationData Optional parameters
---@param textual? textual Reference to an already existing textual datamanager to mutate into a customizable editbox instead of creating a new base widget
---***
---@return customEditbox|textual # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateCustomEditbox(t, textual)

	--| Properties

	---@class customEditboxCreationData : editboxCreationData, customizableObject # t
	---@field listeners? customEditbox_listeners|textual_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class customEditbox_listeners : textual_listeners
		---@field loaded? customEditbox_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? customEditbox_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? customEditbox_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `customEditbox.setText(...)` was called
		---@field enabled? customEditbox_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `customEditbox.setEnabled(...)` was called
		---@field _? customEditbox_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class customEditbox_listener_loaded : eventHandlerIndex
			---@field handler customEditbox_handler_loaded Handler function to register for call

				---@alias customEditbox_handler_loaded
				---| fun(self: textual, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class customEditbox_listener_saved : eventHandlerIndex
			---@field handler customEditbox_handler_saved Handler function to register for call

				---@alias customEditbox_handler_saved
				---| fun(self: textual, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class customEditbox_listener_changed : eventHandlerIndex
			---@field handler customEditbox_handler_changed Handler function to register for call

				---@alias customEditbox_handler_changed
				---| fun(self: textual, text: string, user: boolean) Called when an "changed" event is invoked after `customEditbox.setText(...)` was called<hr><p>@*param* `self` textual ― Reference to the binary widget</p><p>@*param* `text` string ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class customEditbox_listener_enabled : eventHandlerIndex
			---@field handler customEditbox_handler_enabled Handler function to register for call

				---@alias customEditbox_handler_enabled
				---| fun(self: textual, state: boolean) Called when an "enabled" event is invoked after `customEditbox.setEnabled(...)` was called<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class customEditbox_listener_any : eventHandlerIndex
			---@field handler customEditbox_handler_any Handler function to register for call

				---@alias customEditbox_handler_any
				---| fun(self: textual, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class customEditbox : textual
	---@field frame Frame
	---@field widget EditBox|BackdropTemplate
	---@field label FontString|nil
	---@field setListener customEditbox_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_textual]: true, [typename_customEditbox]: true, }
		function _.getTypes() return {} end

			---@alias typename_customEditbox
			---| "CustomEditbox"

		--| Events

		---@class customEditbox_setListener : textual_setListener
		---@field [string] fun(handler: customEditbox_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler customEditbox_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler customEditbox_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler customEditbox_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler customEditbox_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

---Create a default multiline Blizzard editbox GUI frame with enhanced widget functionality
---***
---@param t? multilineEditboxCreationData Optional parameters
---@param textual? textual Reference to an already existing textual datamanager to mutate into a multiline editbox instead of creating a new base widget
---***
---@return multilineEditbox|textual # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateMultilineEditbox(t, textual)

	--| Parameters

	---@class multilineEditboxCreationData : editboxCreationData, scrollSpeedData # t
	---@field size? sizeData
	---@field charCount? boolean Show or hide the remaining number of characters | ***Default:*** `t.charLimit` > 0
	---@field scrollToTop? boolean Automatically scroll to the top when the text is loaded or changed while not being actively edited | ***Default:*** `false`
	---@field scrollEvents? table<ScriptScrollFrame, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the scroll frame of the editbox and the functions to assign as event handlers called when they trigger
	---@field listeners? multilineEditbox_listeners|textual_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class multilineEditbox_listeners : textual_listeners
		---@field loaded? multilineEditbox_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? multilineEditbox_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? multilineEditbox_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `multilineEditbox.setText(...)` was called
		---@field enabled? multilineEditbox_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `multilineEditbox.setEnabled(...)` was called
		---@field _? multilineEditbox_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class multilineEditbox_listener_loaded : eventHandlerIndex
			---@field handler multilineEditbox_handler_loaded Handler function to register for call

				---@alias multilineEditbox_handler_loaded
				---| fun(self: multilineEditbox, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` multilineEditbox ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class multilineEditbox_listener_saved : eventHandlerIndex
			---@field handler multilineEditbox_handler_saved Handler function to register for call

				---@alias multilineEditbox_handler_saved
				---| fun(self: multilineEditbox, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` multilineEditbox ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class multilineEditbox_listener_changed : eventHandlerIndex
			---@field handler multilineEditbox_handler_changed Handler function to register for call

				---@alias multilineEditbox_handler_changed
				---| fun(self: multilineEditbox, text: string, user: boolean) Called when an "changed" event is invoked after `multilineEditbox.setText(...)` was called<hr><p>@*param* `self` multilineEditbox ― Reference to the binary widget</p><p>@*param* `text` string ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class multilineEditbox_listener_enabled : eventHandlerIndex
			---@field handler multilineEditbox_handler_enabled Handler function to register for call

				---@alias multilineEditbox_handler_enabled
				---| fun(self: multilineEditbox, state: boolean) Called when an "enabled" event is invoked after `multilineEditbox.setEnabled(...)` was called<hr><p>@*param* `self` multilineEditbox ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class multilineEditbox_listener_any : eventHandlerIndex
			---@field handler multilineEditbox_handler_any Handler function to register for call

				---@alias multilineEditbox_handler_any
				---| fun(self: multilineEditbox, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` multilineEditbox ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class multilineEditbox : textual
	---@field frame Frame
	---@field scrollframe InputScrollFrame
	---@field widget EditBox
	---@field label FontString|nil
	---@field setListener multilineEditbox_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---NOTE: Incomplete Toolbox-relevant definition for a Frame of `"InputScrollFrameTemplate"`
		---@class InputScrollFrame : ScrollFrame
		---@field ScrollBar ScrollController
		---@field EditBox EditBox
		---@field CharCount FontString

			---NOTE: Incomplete Toolbox-relevant definition for a Frame of `"ScrollControllerMixin"`
			---@class ScrollController : Frame
			---@field panExtentPercentage number
			---@field SetPanExtentPercentage fun(panExtentPercentage: number)

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_textual]: true, [typename_multilineEditbox]: true, }
		function _.getTypes() return {} end

			---@alias typename_multilineEditbox
			---| "MultilineEditbox"

		--| Events

		---@class multilineEditbox_setListener : textual_setListener
		---@field [string] fun(handler: multilineEditbox_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler multilineEditbox_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler multilineEditbox_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler multilineEditbox_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler multilineEditbox_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

--| Copybox

---Create a custom button with a toggled textline & editbox from which text can be copied
---***
---@param t? copyboxCreationData Optional parameters
---***
---@return copybox copybox References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), its child widgets & their custom values, utility functions and more wrapped in a table
function wt.CreateCopybox(t)

	--| Parameters

	---@class copyboxCreationData : labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject # t
	---@field name? string Unique string used to set the frame name | ***Default:*** `"Copybox"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_editbox|sizeData
	---@field layer? DrawLayer
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** `"GameFontNormalSmall"`<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via <code><i>WidgetToolbox</i>.CreateFont(...)</code> (even within this table definition).</li></ul>
	---@field color? color Apply the specified color to the text (overriding `t.font`)
	---@field justify? JustifyHorizontal Set the horizontal text alignment of the label (overriding `t.font`) | ***Default:*** `"LEFT"`
	---@field flipOnMouse? boolean Hide/Reveal the editbox on mouseover instead of after a click | ***Default:*** `false`
	---@field colorOnMouse? color If set, change the color of the text on mouseover to the specified color (if `t.flipOnMouse` is false) | ***Default:*** *no color change*
	---@field value? string The copyable text to be shown | ***Default:*** `""`

	--| Returns

	---@class copybox
	---@field frame Frame|nil
	---@field label FontString|nil
	---@field textual customEditbox|textual|nil
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_copybox]: true,}
		function _.getTypes() return {} end

			---@alias typename_copybox
			---| "Copybox"

	return {}
end

--| Popup Inputbox

---Show a movable input window with a textbox, accept and cancel buttons
---***
---@param t? popupInputBoxData Optional parameters
function wt.CreatePopupInputbox(t)

	--| Parameters

	---@class popupInputBoxData : positionableObject, tooltipDescribableWidget # t
	---@field title? string Text to be displayed as the title | ***Default:*** *(no title)*
	---@field text? string Text to set as the starting text inside the input editbox | ***Default:*** `""`
	---@field accept? fun(text: string) Function to call when the inputted text is accepted
	---@field cancel? function Function to call when the inputted text is dismissed

		---@class tooltipDescribableWidget
		---@field tooltip? widgetTooltipTextData List of text lines to be added to the tooltip of the widget displayed when mousing over the frame
end

--[ Numeric ]

---Create a non-GUI numeric base widget with number datamanagement logic
---***
---@param t? numericCreationData Optional parameters
---@param datamanager? datamanager Reference to an already existing datamanager to mutate into numeric instead of creating a new base widget
---***
---@return numeric numeric Reference to the new numeric widget, utility functions and more wrapped in a table
function wt.CreateNumeric(t, datamanager)

	--| Parameters

	---@class numericCreationData : datamanagerCreationData # t
	---@field fractional? integer If the value is fractional, display this many decimal digits | ***Default:*** *the most amount of digits present in the fractional part of* `t.min`, `t.max` *or* `t.step`
	---@field min? number Lower numeric value limit | ***Range:*** (`any`, `t.max`) | ***Default:*** `0`
	---@field max? number Upper numeric value limit | ***Range:*** (`t.min`, `any`) | ***Default:*** 100
	---@field step? number Add/subtract this much when calling `numeric.increase(...)` or `numeric.decrease(...)` | ***Range:*** (> `0`) | ***Default:*** 10% of range (`t.min`, `t.max`)
	---@field altStep? number If set, add/subtract this much when calling `numeric.increase(...)` or `numeric.decrease(...)` with `alt == true` | ***Range:*** (> `0`) | ***Default:*** *no alternative step value*
	---@field hardStep? boolean Use `t.step` to force the slider jump to step values on drag | ***Default:*** `true`
	---@field listeners? numeric_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): value: number|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `value` number|nil | ***Default:*** `t.min`<p>
	---@field saveData? fun(value: number) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `value` number</p>
	---@field value? number The starting value of the widget to set during initialization | ***Default:*** `t.getData()` or `t.default` if invalid
	---@field default? number Default value of the widget | ***Default:*** `t.min`

		---@class numeric_listeners : datamanager_listeners
		---@field loaded? numeric_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? numeric_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? numeric_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `numeric.setNumber(...)` was called
		---@field min? numeric_listener_min[] Ordered list of functions to call when a "min" event is invoked after `numeric.setMin(...)` was called
		---@field max? numeric_listener_max[] Ordered list of functions to call when a "max" event is invoked after `numeric.setMax(...)` was called
		---@field enabled? numeric_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `numeric.setEnabled(...)` was called
		---@field _? numeric_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class numeric_listener_loaded : eventHandlerIndex
			---@field handler numeric_handler_loaded Handler function to register for call

				---@alias numeric_handler_loaded
				---| fun(self: numeric, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` numeric ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class numeric_listener_saved : eventHandlerIndex
			---@field handler numeric_handler_saved Handler function to register for call

				---@alias numeric_handler_saved
				---| fun(self: numeric, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` numeric ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class numeric_listener_changed : eventHandlerIndex
			---@field handler numeric_handler_changed Handler function to register for call

				---@alias numeric_handler_changed
				---| fun(self: numeric, number: number, user: boolean) Called when an "changed" event is invoked after `numeric.setNumber(...)` was called<hr><p>@*param* `self` numeric ― Reference to the binary widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class numeric_listener_min : eventHandlerIndex
			---@field handler numeric_handler_min Handler function to register for call

				---@alias numeric_handler_min
				---| fun(self: numeric, limitMin: number) Called when an "min" event is invoked after `numeric.setMin(...)` was called<hr><p>@*param* `self` numeric ― Reference to the binary widget</p><p>@*param* `limitMin` number ― The current lower limit of the number value of the widget</p>

			---@class numeric_listener_max : eventHandlerIndex
			---@field handler numeric_handler_max Handler function to register for call

				---@alias numeric_handler_max
				---| fun(self: numeric, limitMax: number) Called when an "max" event is invoked after `numeric.setMax(...)` was called<hr><p>@*param* `self` numeric ― Reference to the binary widget</p><p>@*param* `limitMax` number ― The current upper limit of the number value of the widget</p>

			---@class numeric_listener_enabled : eventHandlerIndex
			---@field handler numeric_handler_enabled Handler function to register for call

				---@alias numeric_handler_enabled
				---| fun(self: numeric, state: boolean) Called when an "enabled" event is invoked after `numeric.setEnabled(...)` was called<hr><p>@*param* `self` numeric ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class numeric_listener_any : eventHandlerIndex
			---@field handler numeric_handler_any Handler function to register for call

				---@alias numeric_handler_any
				---| fun(self: numeric, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` numeric ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class numeric : datamanager
	---@field invoke numeric_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener numeric_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_numeric]: true, }
		function _.getTypes() return {} end

			---@alias typename_numeric
			---| "Numeric"

		--| Events

		---@class numeric_invoke : datamanager_invoke
		---@field min function Invoke a "min" event to notify registered listeners and call handlers
		---@field max function Invoke a "max" event to notify registered listeners and call handlers

		---@class numeric_setListener : datamanager_setListener
		---@field [string] fun(handler: numeric_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler numeric_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler numeric_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler numeric_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "min" widget event
			---@param handler numeric_handler_min Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.min(handler, callIndex) end

			---Register a listener for a "max" widget event
			---@param handler numeric_handler_max Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.max(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler numeric_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| Data management

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via `t.saveData(...)`
		---***
		---@param number? number Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _.saveData(number, silent) end

		---Get the currently stored data via `t.getData()`
		---@return number|nil
		function _.getData() end

		---Verify and save the provided data to storage via `t.saveData(...)` then load it to the widget via `t.loadData()`
		---***
		---@param number? number Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(number, handleChanges, silent) end

		---Get the currently set default value
		---@return number default
		function _.getDefault() return 0 end

		---Set the default value
		---@param number number | ***Default:*** *no change*
		function _.setDefault(number) end

		---Set and load the stored data managed by the widget to the default value specified via `t.default` at construction
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via `numeric.revertData()`
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via `numeric.snapshotData()`
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Returns the current value of the widget
		---@return number
		function _.getNumber() return 0 end

		---Set the value of the widget
		---***
		---@param number? number A valid number value within the specified `t.min`, `t.max` range | ***Default:*** `t.min`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		function _.setNumber(number, user, silent) end

		---Decrease the value of the widget by the specified step or alt step amount
		---@param alt? boolean If true, use alt step instead of step to decrease the value by | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _.decrease(alt, user, silent) end

		---Increase the value of the widget by the specified step or alt step amount
		---@param alt? boolean If true, use alt step instead of step to increase the value by | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _.increase(alt, user, silent) end

		--| Value limits

		---Return the current lower value limit of the widget
		---@return number
		function _.getMin() return 0 end

		---Set the lower value limit of the widget
		---***
		---@param number number Updates the lower limit value | ***Range:*** (`any`, `numeric.getMax()`) *capped automatically*
		---@param silent? boolean If false, invoke a "min" event and call registered listeners | ***Default:*** `false`
		function _.setMin(number, silent) end

		---Return the current upper value limit of the widget
		---@return number
		function _.getMax() return 0 end

		---Set the upper value limit of the widget
		---***
		---@param number number Updates the upper limit value | ***Range:*** (`numeric.getMin()`, `any`) *floored automatically*
		---@param silent? boolean If false, invoke a "max" event and call registered listeners | ***Default:*** `false`
		function _.setMax(number, silent) end

		--| Value step

		---Return the current value step of the widget
		---@return number
		function _.getStep() return 0 end

		---Return the current alternative value step of the widget
		---@return number|nil
		function _.getAltStep() end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

--| Slider

---Create a Blizzard slider GUI frame with enhanced widget functionality
---***
---@param t? sliderCreationData Optional parameters
---@param numeric? numeric Reference to an already existing numeric widget to mutate into a slider instead of creating a new base widget
---***
---@return numericSlider|numeric # References to the new [Slider](https://warcraft.wiki.gg/wiki/UIOBJECT_Slider), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), child widgets, utility functions and more wrapped in a table
function wt.CreateSlider(t, numeric)

	--| Parameters

	---@class sliderCreationData : numericCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, widgetWidthValue, visibleObject_base, liteObject, tooltipDescribableSettingsWidget # t
	---@field name? string Unique string used to set the frame name | ***Default:*** `"Slider"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field valuebox? boolean Whether or not should the slider have an [EditBox](https://warcraft.wiki.gg/wiki/UIOBJECT_EditBox) as a child to manually enter a precise value to move the slider to | ***Default:*** `true`
	---@field listeners? slider_listeners|numeric_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field events? table<ScriptSlider, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the slider frame and the functions to assign as event handlers called when they trigger<ul><li>***Example:*** "[OnValueChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnValueChanged)" whenever the value in the slider widget is modified.</li></ul>

		---@class slider_listeners : numeric_listeners
		---@field loaded? slider_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? slider_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? slider_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `slider.setNumber(...)` was called
		---@field min? slider_listener_min[] Ordered list of functions to call when a "min" event is invoked after `slider.setMin(...)` was called
		---@field max? slider_listener_max[] Ordered list of functions to call when a "max" event is invoked after `slider.setMax(...)` was called
		---@field enabled? slider_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `slider.setEnabled(...)` was called
		---@field _? slider_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class slider_listener_loaded : eventHandlerIndex
			---@field handler slider_handler_loaded Handler function to register for call

				---@alias slider_handler_loaded
				---| fun(self: slider, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class slider_listener_saved : eventHandlerIndex
			---@field handler slider_handler_saved Handler function to register for call

				---@alias slider_handler_saved
				---| fun(self: slider, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class slider_listener_changed : eventHandlerIndex
			---@field handler slider_handler_changed Handler function to register for call

				---@alias slider_handler_changed
				---| fun(self: slider, number: number, user: boolean) Called when an "changed" event is invoked after `slider.setNumber(...)` was called<hr><p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class slider_listener_min : eventHandlerIndex
			---@field handler slider_handler_min Handler function to register for call

				---@alias slider_handler_min
				---| fun(self: slider, limitMin: number) Called when an "min" event is invoked after `slider.setMin(...)` was called<hr><p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `limitMin` number ― The current lower limit of the number value of the widget</p>

			---@class slider_listener_max : eventHandlerIndex
			---@field handler slider_handler_max Handler function to register for call

				---@alias slider_handler_max
				---| fun(self: slider, limitMax: number) Called when an "max" event is invoked after `slider.setMax(...)` was called<hr><p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `limitMax` number ― The current upper limit of the number value of the widget</p>

			---@class slider_listener_enabled : eventHandlerIndex
			---@field handler slider_handler_enabled Handler function to register for call

				---@alias slider_handler_enabled
				---| fun(self: slider, state: boolean) Called when an "enabled" event is invoked after `slider.setEnabled(...)` was called<hr><p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class slider_listener_any : eventHandlerIndex
			---@field handler slider_handler_any Handler function to register for call

				---@alias slider_handler_any
				---| fun(self: slider, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Return

	---@class numericSlider : numeric
	---@field frame Frame
	---@field widget MinimalSliderWithSteppers
	---@field valuebox customEditbox|textual
	---@field setListener slider_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---NOTE: Incomplete Toolbox-relevant definition for a Frame of `"MinimalSliderWithSteppersTemplate"`
		---@class MinimalSliderWithSteppers : Slider
		---@field Slider Slider Main slider frame
		---@field Back Button Decrease value button
		---@field Forward Button Increase value button
		---@field TopText FontString Title text
		---@field MinText FontString Min value text
		---@field MaxText FontString Max value text

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_numeric]: true, [typename_slider]: true, }
		function _.getTypes() return {} end

			---@alias typename_slider
			---| "Slider"

		--| Events

		---@class slider_setListener : numeric_setListener
		---@field [string] fun(handler: slider_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler slider_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler slider_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler slider_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "min" widget event
			---@param handler slider_handler_min Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.min(handler, callIndex) end

			---Register a listener for a "max" widget event
			---@param handler slider_handler_max Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.max(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler slider_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

---Create a classic Blizzard slider GUI frame with enhanced widget functionality
---***
---@param t? classicSliderCreationData Optional parameters
---@param numeric? numeric Reference to an already existing numeric widget to mutate into a slider instead of creating a new base widget
---***
---@return classicSlider|numeric # References to the new [Slider](https://warcraft.wiki.gg/wiki/UIOBJECT_Slider), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), child widgets, utility functions and more wrapped in a table
function wt.CreateClassicSlider(t, numeric)

	--| Parameters

	---@class classicSliderCreationData : sliderCreationData # t
	---@field sideButtons? boolean Whether or not to add increase/decrease buttons next to the slider to change the value by the increment set in `t.step` | ***Default:*** `true`
	---@field listeners? classicSlider_listeners|numeric_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class classicSlider_listeners : numeric_listeners
		---@field loaded? classicSlider_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? classicSlider_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? classicSlider_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `classicSlider.setNumber(...)` was called
		---@field min? classicSlider_listener_min[] Ordered list of functions to call when a "min" event is invoked after `classicSlider.setMin(...)` was called
		---@field max? classicSlider_listener_max[] Ordered list of functions to call when a "max" event is invoked after `classicSlider.setMax(...)` was called
		---@field enabled? classicSlider_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `classicSlider.setEnabled(...)` was called
		---@field _? classicSlider_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class classicSlider_listener_loaded : eventHandlerIndex
			---@field handler classicSlider_handler_loaded Handler function to register for call

				---@alias classicSlider_handler_loaded
				---| fun(self: slider, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class classicSlider_listener_saved : eventHandlerIndex
			---@field handler classicSlider_handler_saved Handler function to register for call

				---@alias classicSlider_handler_saved
				---| fun(self: slider, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class classicSlider_listener_changed : eventHandlerIndex
			---@field handler classicSlider_handler_changed Handler function to register for call

				---@alias classicSlider_handler_changed
				---| fun(self: slider, number: number, user: boolean) Called when an "changed" event is invoked after `classicSlider.setNumber(...)` was called<hr><p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class classicSlider_listener_min : eventHandlerIndex
			---@field handler classicSlider_handler_min Handler function to register for call

				---@alias classicSlider_handler_min
				---| fun(self: slider, limitMin: number) Called when an "min" event is invoked after `classicSlider.setMin(...)` was called<hr><p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `limitMin` number ― The current lower limit of the number value of the widget</p>

			---@class classicSlider_listener_max : eventHandlerIndex
			---@field handler classicSlider_handler_max Handler function to register for call

				---@alias classicSlider_handler_max
				---| fun(self: slider, limitMax: number) Called when an "max" event is invoked after `classicSlider.setMax(...)` was called<hr><p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `limitMax` number ― The current upper limit of the number value of the widget</p>

			---@class classicSlider_listener_enabled : eventHandlerIndex
			---@field handler classicSlider_handler_enabled Handler function to register for call

				---@alias classicSlider_handler_enabled
				---| fun(self: slider, state: boolean) Called when an "enabled" event is invoked after `classicSlider.setEnabled(...)` was called<hr><p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class classicSlider_listener_any : eventHandlerIndex
			---@field handler classicSlider_handler_any Handler function to register for call

				---@alias classicSlider_handler_any
				---| fun(self: slider, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Return

	---@class classicSlider : numeric
	---@field frame Frame
	---@field widget Slider
	---@field label FontString|nil
	---@field min FontString
	---@field max FontString
	---@field valuebox customEditbox|textual
	---@field decreaseButton customButton|action
	---@field increaseButton customButton|action
	---@field setListener classicSlider_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_numeric]: true, [typename_classicSlider]: true, }
		function _.getTypes() return {} end

			---@alias typename_classicSlider
			---| "ClassicSlider"

		--| Events

		---@class classicSlider_setListener : numeric_setListener
		---@field [string] fun(handler: classicSlider_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler classicSlider_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler classicSlider_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler classicSlider_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "min" widget event
			---@param handler classicSlider_handler_min Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.min(handler, callIndex) end

			---Register a listener for a "max" widget event
			---@param handler classicSlider_handler_max Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.max(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler classicSlider_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

--[ Color ]

---Create a non-GUI colormanager base widget with color datamanagement logic
---***
---@param t? colormanagerCreationData Optional parameters
---@param datamanager? datamanager Reference to an already existing datamanager to mutate into a colormanager instead of creating a new base widget
---***
---@return colormanager colormanager Reference to the new color pick manager widget, utility functions and more wrapped in a table
function wt.CreateColormanager(t, datamanager)

	--| Parameters

	---@class colormanagerCreationData : datamanagerCreationData # t
	---@field listeners? colormanager_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field onCancel? function The function to be called when the color change is cancelled (after calling `t.onColorUpdate`)
	---@field getData? fun(): color: color|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `color` colorData|nil | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`</p>
	---@field saveData? fun(color: color) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `color` colorData</p>
	---@field value? colorData_whiteDefault Values to use as the starting color set during initialization | ***Default:*** `t.getData()` or `t.default` if invalid<ul><li>***Note:*** If the alpha start value was not set, configure the color picker to handle RBG values exclusively instead of the full RGBA.</li></ul>
	---@field default? color Default value of the widget | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`

		---@class colormanager_listeners : datamanager_listeners
		---@field loaded? colormanager_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? colormanager_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? colormanager_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `colormanager.setColor(...)` was called
		---@field enabled? colormanager_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `colormanager.setEnabled(...)` was called
		---@field _? colormanager_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class colormanager_listener_loaded : eventHandlerIndex
			---@field handler colormanager_handler_loaded Handler function to register for call

				---@alias colormanager_handler_loaded
				---| fun(self: colormanager, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` colormanager ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class colormanager_listener_saved : eventHandlerIndex
			---@field handler colormanager_handler_saved Handler function to register for call

				---@alias colormanager_handler_saved
				---| fun(self: colormanager, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` colormanager ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class colormanager_listener_changed : eventHandlerIndex
			---@field handler colormanager_handler_changed Handler function to register for call

				---@alias colormanager_handler_changed
				---| fun(self: colormanager, color: color, user: boolean) Called when an "changed" event is invoked after `colormanager.setColor(...)` was called<hr><p>@*param* `self` colormanager ― Reference to the binary widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class colormanager_listener_enabled : eventHandlerIndex
			---@field handler colormanager_handler_enabled Handler function to register for call

				---@alias colormanager_handler_enabled
				---| fun(self: colormanager, state: boolean) Called when an "enabled" event is invoked after `colormanager.setEnabled(...)` was called<hr><p>@*param* `self` colormanager ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class colormanager_listener_any : eventHandlerIndex
			---@field handler colormanager_handler_any Handler function to register for call

				---@alias colormanager_handler_any
				---| fun(self: colormanager, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` colormanager ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class colormanager : datamanager
	---@field invoke datamanager_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener colormanager_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_colormanager]: true, }
		function _.getTypes() return {} end

			---@alias typename_colormanager
			---| "Colormanager"

		--| Events

		---@class colormanager_setListener : datamanager_setListener
		---@field [string] fun(handler: colormanager_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler colormanager_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler colormanager_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "colored" widget event
			---@param handler colormanager_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.colored(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler colormanager_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| Data management

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via `t.saveData(...)`
		---***
		---@param color? color Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _.saveData(color, silent) end

		---Get the currently stored data via `t.getData()`
		---@return color|nil
		function _.getData() end

		---Verify and save the provided data to storage via `t.saveData(...)` then load it to the widget via `t.loadData()`
		---***
		---@param color? color Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(color, handleChanges, silent) end

		---Get the currently set default value
		---@return color default
		function _.getDefault() return {} end

		---Set the default value
		---@param color? color | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
		function _.setDefault(color) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via `colormanager.snapshotData()`
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via `colormanager.revertData()`
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the default value specified via `t.default` at construction
		---@param handleChanges? boolean If true, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Returns the currently set channel values wrapped in a color table
		---@return color
		function _.getColor() return {} end

		---Set the managed color values
		---***
		---@param color? color ***Default:*** { r = 1, g = 1, b = 1, a = 1 } *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "colored" event and call registered listeners | ***Default:*** `false`
		function _.setColor(color, user, silent) end

		--| Color wheel

		---Open the the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) for this color manager
		function _.openColorPicker() end

		---Return the active status of this color manager, whether the main color wheel window was opened for and is currently updating the color of this widget
		---@return boolean active True, if the color wheel has been opened for this color manager widget
		function _.isActive() return false end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

--| Colorpicker

---Create a color picker GUI frame with HEX(A) & RGB(A) input while utilizing the [ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame) wheel
---***
---@param t? colorpickerCreationData Optional parameters
---@param colormanager? colormanager Reference to an already existing color datamanager to mutate into a colorpicker instead of creating a new base widget
---***
---@return colorpicker|colormanager # Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateColorpicker(t, colormanager)

	--| Properties

	---@class colorpickerCreationData : colormanagerCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject, tooltipDescribableSettingsWidget # t
	---@field name? string Unique string used to set the frame name | ***Default:*** `"Colorpicker"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field width? number The height is defaulted to 36, the width may be specified | ***Default:*** 120
	---@field listeners? colorpicker_listeners|colormanager_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the color picker frame and the functions to assign as event handlers called when they trigger

		---@class colorpicker_listeners : colormanager_listeners
		---@field loaded? colorpicker_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? colorpicker_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? colorpicker_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `colorpicker.setColor(...)` was called
		---@field enabled? colorpicker_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `colorpicker.setEnabled(...)` was called
		---@field _? colorpicker_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class colorpicker_listener_loaded : eventHandlerIndex
			---@field handler colorpicker_handler_loaded Handler function to register for call

				---@alias colorpicker_handler_loaded
				---| fun(self: colorpicker, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` colorpicker ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by `t.getData()` and it was loaded to the widget</p>

			---@class colorpicker_listener_saved : eventHandlerIndex
			---@field handler colorpicker_handler_saved Handler function to register for call

				---@alias colorpicker_handler_saved
				---| fun(self: colorpicker, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` colorpicker ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via `t.saveData(...)`</p>

			---@class colorpicker_listener_changed : eventHandlerIndex
			---@field handler colorpicker_handler_changed Handler function to register for call

				---@alias colorpicker_handler_changed
				---| fun(self: colorpicker, color: color, user: boolean) Called when an "changed" event is invoked after `colorpicker.setColor(...)` was called<hr><p>@*param* `self` colorpicker ― Reference to the binary widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class colorpicker_listener_enabled : eventHandlerIndex
			---@field handler colorpicker_handler_enabled Handler function to register for call

				---@alias colorpicker_handler_enabled
				---| fun(self: colorpicker, state: boolean) Called when an "enabled" event is invoked after `colorpicker.setEnabled(...)` was called<hr><p>@*param* `self` colorpicker ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class colorpicker_listener_any : eventHandlerIndex
			---@field handler colorpicker_handler_any Handler function to register for call

				---@alias colorpicker_handler_any
				---| fun(self: colorpicker, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` colorpicker ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class colorpicker : colormanager
	---@field frame Frame
	---@field label FontString|nil
	---@field button colorpickerButton|customButton|action
	---@field hexBox customEditbox|textual
	---@field setListener colorpicker_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---Button to open the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) with
		---@class colorpickerButton : customButton
		---@field gradient Texture
		---@field checker Texture

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_datamanager]: true, [typename_colormanager]: true, [typename_colorpicker]: true, }
		function _.getTypes() return {} end

			---@alias typename_colorpicker
			---| "Colorpicker"

		--| Events

		---@class colorpicker_setListener : colormanager_setListener
		---@field [string] fun(handler: colorpicker_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler colorpicker_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler colorpicker_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "colored" widget event
			---@param handler colorpicker_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.colored(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler colorpicker_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

	return _
end

--[ Position ]

---Create a non-GUI positionmanager base widget with positioning datamanagement logic
---***
---@param t settingsmanagerCreationData Optional parameters
---@param datamanager? datamanager Reference to an already existing datamanager to mutate into a positionmanager instead of creating a new base widget
---***
---@return positionmanager positionmanager Reference to the new positionmanager widget, utility functions and more wrapped in a table
function wt.CreatePositionmanager(t, datamanager)
	---@alias typename_positionmanager
	---| "Positionmanager"

	---@class positionmanager : widget
	local _ = {}

	return _
end

--| Options Panel

---Create and set up position management for a specified frame within a panel frame
---***
---@param addon uiAddon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
---@param frame AnyFrameObject Reference to the frame to create the settings for
---@param getData fun(): table: positionPresetData|table Return a reference to the table within a SavedVariables(PerCharacter) addon database where data is committed to
---@param defaultData positionPresetData|table Reference to the table containing the default values<ul><li>***Note:*** The defaults table should contain values under matching keys to the values within *t.getData()*.</li></ul>
---@param settingsData positionOptionsSettingsData|table Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from<ul><li>***Note:*** A boolean value will be created under the key `keepInPlace` if it didn't already exist in this table.</li></ul>
---@param t positionManagementCreationData Optional parameters
---***
---@return positionPanel? table Components of the settings panel wrapped in a table | ***Default:*** `nil`
function wt.CreatePositionOptions(addon, frame, getData, defaultData, settingsData, t)

	--| Parameters

	---@class positionPresetData # defaultData
	---@field position positionData Table of parameters to call `frame`:[SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with
	---@field keepInBounds? boolean Whether to keep the frame within screen bounds whenever it's moved | ***Default:*** `false`
	---@field layer? widgetLayerOptions Table containing the screen layer parameters of the frame

		---@class widgetLayerOptions
		---@field strata? FrameStrata Strata to pin the frame to
		---@field level? integer The level of the frame to appear in within the specified strata
		---@field keepOnTop? boolean Whether to raise the frame level on mouse interaction | ***Default:*** `false`

	---@class positionOptionsSettingsData # settingsData
	---@field keepInPlace boolean If true, don't move `frame` when changing the anchor, update the offset values instead.

	---@class positionManagementCreationData : settingsWidgetPanel_frame
	---@field presets? presetItemList Reference to the table containing `frame` position presets to be managed by settings widgets added when set
	---@field setMovable? movabilityData_position When specified, set `frame` as movable, dynamically updating the position settings widgets when it's moved by the user
	---@field dataManagement? settingsData_position Register the widgets to settings datamanagement to be linked with the specified key under the specified category
	---@field onChangePosition? function Function to call after the value of `panel.widgets.position.anchor` `panel.widgets.position.relativeTo` `panel.widgets.position.relativePoint` `panel.widgets.position.offset.x` or `panel.widgets.position.offset.y` was changed by the user or via settings datamanagement before the base onChange handler is called built-in to the functionality of the settings panel template updating the position of `frame`
	---@field onChangeKeepInBounds? function Function to call after the value of `panel.widgets.position.keepInBounds` was changed by the user or via settings datamanagement before the base onChange handlers are called built-in to the functionality of the settings panel template updating `frame`
	---@field onChangeStrata? function Function to call after the value of `panel.widgets.layer.strata` was changed by the user or via settings datamanagement before the base onChange handlers are called built-in to the functionality of the settings panel template updating `frame`
	---@field onChangeLevel? function Function to call after the value of `panel.widgets.layer.level` was changed by the user or via settings datamanagement before the base onChange handlers are called built-in to the functionality of the settings panel template updating `frame`
	---@field onChangeKeepOnTop? function Function to call after the value of `panel.widgets.layer.keepOnTop` was changed by the user or via settings datamanagement before the base onChange handlers are called built-in to the functionality of the settings panel template updating `frame`

		---@class settingsWidgetPanel_frame : settingsWidgetPanel_base
		---@field name? string Refer to `frame` by this display name in the tooltips and descriptions of settings widgets | ***Default:*** `frame:GetName()`

			---@class settingsWidgetPanel_base
			---@field canvas Frame The canvas frame child item of an existing settings category page to add the panel to
			---@field dependencies? dependencyRule[] Automatically disable or enable all widgets in the new panel based on the rules described in subtables

		---@class presetItemList
		---@field items positionPresetItemData[] Table containing the dropdown items described within subtables
		---@field onPreset? fun(preset?: positionPresetItemData, index?: integer) Called after a preset is selected and applied via the dropdown widget or by calling `applyPreset`
		---@field custom? customPositionPresetData When set, add widgets to manage a user-modifiable custom preset

			---@class positionPresetItemData
			---@field title string Text to represent the item within the dropdown frame
			---@field data? positionPresetData|table Table containing the preset data to be modified by the position settings widgets and applied to `frame` on demand

			---@class customPositionPresetData
			---@field index? integer Index of the custom preset modifiable by the user | ***Default:*** `1`
			---@field getData fun(): positionPresetData|table Return a reference to the table within the SavedVariables(PerCharacter) addon database where the custom preset data is committed to when the custom preset is saved
			---@field defaultsTable positionPresetData|table Reference to the table containing the default custom preset values<ul>
			---@field onSave? function Called after saving the custom preset
			---@field onReset? function Called after resetting the custom preset before it is applied

		---@class movabilityData_position : movabilityData
		---@field modifier? ModifierKey|any The specific (or any) modifier key required to be pressed down to move `frame` (if `frame` has the "OnUpdate" script defined) | ***Default:*** `"SHIFT"`<ul><li>***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://warcraft.wiki.gg/wiki/API_IsModifierKeyDown) is used.</li></ul>

		---@class settingsData_position : settingsData_base
		---@field key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `"Position"`

	--| Returns

	---@class positionPanel : positionmanager
	---@field frame panel
	---@field widgets positionPanelWidgets
	---@field presets? positionPresetItemData[]
	local _ = {}

		---@class positionPanelWidgets
		---@field presets positionPanelWidgets_presets|nil
		---@field position positionPanelWidgets_position
		---@field layer positionPanelWidgets_layer|nil

			---@class positionPanelWidgets_presets
			---@field applyButton Frame|BackdropTemplate
			---@field applyMenu contextMenu
			---@field save action|actionButton|nil
			---@field reset action|actionButton|nil

			---@class positionPanelWidgets_position
			---@field relativePoint specialSelector|specialRadiogroup
			---@field anchor specialSelector|specialRadiogroup
			---@field keepInPlace binary|checkbox
			---@field offset { x: numeric|numericSlider, y: numeric|numericSlider }
			---@field keepInBounds binary|checkbox|nil

			---@class positionPanelWidgets_layer
			---@field strata specialSelector|specialRadiogroup|nil
			---@field keepOnTop binary|checkbox|nil
			---@field level numeric|numericSlider|nil

		---Apply a specific preset
		--- - ***Note:*** If the addon database position table doesn't contain relative frame and point key, value pairs, the position will be converted to absolute position after being applied.
		---***
		---@param i integer Index of the preset to be applied
		---***
		---@return boolean success Whether or not the preset under the specified index exists and it could be applied
		function _.applyPreset(i) return false end

		---Save the current position & visibility to the custom preset
		--- - ***Note:*** If the custom preset position data doesn't contain relative frame and point key, value pairs, the position will be converted to absolute position when saved.
		function _.saveCustomPreset() end

		--Reset the custom preset to its default state
		function _.resetCustomPreset() end

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_positionmanager]: true, [typename_positionPanel]: true,  }
		function _.getTypes() return {} end

			---@alias typename_positionPanel
			---| "PositionOptions"

end

--[ Font ]

---Create a non-GUI fontmanager base widget with font customization datamanagement logic
---***
---@param t settingsmanagerCreationData Optional parameters
---@param datamanager? datamanager Reference to an already existing datamanager to mutate into a fontmanager instead of creating a new base widget
---***
---@return fontmanager fontmanager Reference to the new fontmanager widget, utility functions and more wrapped in a table
function wt.CreateFontmanager(t, datamanager)
	---@alias typename_fontmanager
	---| "Fontmanager"

	---@class fontmanager : widget
	local _ = {}

	return _
end

--| Options Panel

---Create and set up font management for a specified text object ([FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString)) including access to a font family selector dropdown to pick a custom font from the Widget Tools fonts list
---***
---@param addon uiAddon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
---@param textline FontString Reference to the text object to create font options for
---@param getData fun(): table: fontOptionsData Return a reference to the table within a SavedVariables(PerCharacter) addon database where data is committed to
---@param defaultData fontOptionsData Reference to the table containing the default values
---@param t fontManagementCreationData Optional parameters
---***
---@return fontPanel? table Components of the settings panel wrapped in a table | ***Default:*** `nil`
function wt.CreateFontOptions(addon, textline, getData, defaultData, t)

	--| Parameters

	---@class fontOptionsData # defaultData
	---@field path string Path to the font file relative to the WoW client directory<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Fonts/Font.ttf), otherwise use `\\`.</li><li>***Note:*** **File format:** Font files must be in TTF or OTF format.</li></ul>
	---@field size number Font size
	---@field alignment JustifyHorizontal Horizontal text alignment
	---@field colors table<string, color>|textColorData_base List of named coloring options<ul><li>***Note:*** The default color of key "base" will be added if it's missing.</ul></li>

		---@class textColorData_base
		---@field base color

	---@class fontManagementCreationData : settingsWidgetPanel_text # t
	---@field colors? table<string, textColorInfo> Use this list of specifications to dictate what colors appear and how: their order and displayed name | ***Default:*** *none*<ul><li>***Note:*** If set, the default color of key "base" will be added if it's missing.</ul></li>
	---@field dataManagement? settingsData_font Register the widgets to settings datamanagement to be linked with the specified key under the specified category
	---@field onChangeFont? function Function to call after the value of `panel.widgets.path` or `panel.widgets.size` was changed by the user or via settings datamanagement before the base onChange handler is called built-in to the functionality of the settings panel template updating the position of `text`
	---@field onChangeSize? function Function to call after the value of `panel.widgets.position.keepInBounds` was changed by the user or via settings datamanagement before the base onChange handlers are called built-in to the functionality of the settings panel template updating `text`
	---@field onChangeAlignment? function Function to call after the value of `panel.widgets.layer.strata` was changed by the user or via settings datamanagement before the base onChange handlers are called built-in to the functionality of the settings panel template updating `text`
	---@field onChangeColor? fun(color: string) Function to call after the value of `panel.widgets.layer.level` was changed by the user or via settings datamanagement before the base onChange handlers are called built-in to the functionality of the settings panel template updating `text`

		---@class settingsWidgetPanel_text : settingsWidgetPanel_base
		---@field name? string Refer to `text` by this display name in the tooltips and descriptions of settings widgets | ***Default:*** `text:GetName()`

		---@class textColorInfo
		---@field index? integer Ordering index of the color | ***Default:*** *unspecified*
		---@field name? string Display name to set their widget and tooltip titles paired to their datamanagement keys | ***Default:*** *datamanagement key in Title case*
		---@field wrap? boolean If true, wrap the list of colors at this color (starting this one in a new row) | ***Default:*** `index == 1`

		---@class settingsData_font : settingsData_base
		---@field key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `"Font"`

	--| Returns

	---@class fontPanel : fontmanager
	---@field widgets fontPanelWidgets
	---@field frame Frame|panel
	local _ = {}

		---@class fontPanelWidgets
		---@field path selector|dropdownRadiogroup
		---@field size numeric|numericSlider
		---@field alignment specialSelector|specialRadiogroup
		---@field colors (colormanager|colorpicker)[]|nil

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_fontmanager]: true, [typename_fontPanel]: true, }
		function _.getTypes() return {} end

			---@alias typename_fontPanel
			---| "FontOptions"
end


--[[ SETTINGS ]]

---Create a non-GUI settingsmanager widget
---***
---@param t settingsmanagerCreationData Optional parameters
---@param widget? widget Reference to an already existing base widget to mutate into a settingsmanager instead of creating a new one
---***
---@return settingsmanager settingsmanager Reference to the new settingsmanager widget, utility functions and more wrapped in a table
function wt.CreateSettingsmanager(t, widget)

	--| Parameters

	---@class settingsmanagerCreationData : settingsmanagerCreationData_base, describableObject, togglableObject, settingsCategoryData, settingsmanagerEvents, initializableOptionsContainer, liteObject # t
	---@field append? boolean When setting the name of the settings category page, append `t.name` after `addon` | ***Default:*** `true` if `t.name` ~= nil
	---@field autoSave? boolean If true, automatically save the values of all widgets registered for settings datamanagement under settings keys listed in `t.dataManagement.keys`, committing their data to storage via <code><i>WidgetToolbox</i>.SaveOptionsData(...)</code> | ***Default:*** `true` if `t.dataManagement.keys` ~= nil<ul><li>***Note:*** If `t.dataManagement.keys` is not set, the automatic load will not be executed even if this is set to true.</li></ul>
	---@field autoLoad? boolean If true, automatically load all data to the widgets registered for settings datamanagement under settings keys listed in `t.dataManagement.keys` from storage via <code><i>WidgetToolbox</i>.LoadOptionsData(...)</code> | ***Default:*** `true` if `t.dataManagement.keys` ~= nil<ul><li>***Note:*** If `t.dataManagement.keys` is not set, the automatic load will not be executed even if this is set to true.</li></ul>
	---@field listeners? settingsmanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class settingsmanagerCreationData_base
		---@field register? boolean|settingsPage If true, register the new page to the Settings panel as a parent category or a subcategory of an already registered parent category if a reference to an existing settings category parent page provided | ***Default:*** `false`<ul><li>***Note:*** The page can be registered later via <code><i>WidgetToolbox</i>.RegisterSettingsPage(...)</code>.</li></ul>
		---@field name? string Unique string used to set the name of the canvas frame | ***Default:*** `addon`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
		---@field title? string Text to be shown as the title of the settings page | ***Default:*** [GetAddOnMetadata(`addon`, "title")](https://warcraft.wiki.gg/wiki/API_GetAddOnMetadata)
		---@field static? boolean If true, disable the "Restore Defaults" & "Revert Changes" buttons | ***Default:*** `false`

		---@class settingsCategoryData
		---@field dataManagement? settingsData_collection If set, register this settings page to settings datamanagement for batched data saving & loading and handling data changes of all linked widgets

			---@class settingsData_collection : settingsData_base
			---@field keys? string[] An ordered list of unique strings appended to `category` linking a subset of settings data rules to be handled together in the specified order via this settings category page | ***Default:*** `{ t.name }`

				---@class settingsData_base
				---@field category? string A unique string used for categorizing settings datamanagement rules & change handler scripts | ***Default:*** `addon`

		---@class settingsmanagerEvents
		---@field onLoad? fun(user: boolean) Called after the data of the settings widgets linked to this page has been loaded from storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onSave? fun(user: boolean) Called after the data of the settings widgets linked to this page has been committed to storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onApply? fun(user: boolean) Called after the data of the settings widgets linked to this page has been applied by calling change handlers<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onCancel? fun(user: boolean) Called after the changes are scrapped (for instance when the custom "Revert Changes" button is clicked)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onDefault? fun(user: boolean, category: boolean) Called after settings data handled by this settings page has been restored to default values (for example when the "Accept" or "These Settings" - affecting this settings category page only - is clicked in the dialogue opened by clicking on the "Restore Defaults" button)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p><p>@*param* `category` boolean — Marking whether the call is through <code>[<i>settingsCategory</i>].defaults(...)</code> or not (or example when "All Settings" have been clicked)</p>

		---@class initializableOptionsContainer : initializableContainer
		---@field initialize? fun(container?: Frame, width: number, height: number, category?: string, keys?: string[], name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? AnyFrameObject ― Reference to the frame to be set as the parent for child objects created during initialization (nil if `WidgetToolsDB.lite` is true)</p><p>@*param* `width` number The current width of the container frame (0 if `WidgetToolsDB.lite` is true)</p><p>@*param* `height` number The current height of the container frame (0 if `WidgetToolsDB.lite` is true)</p><p>@*param* `category`? string A unique string used for categorizing settings datamanagement rules & change handler scripts</p><p>@*param* `keys`? string[] Reference to `t.dataManagement.keys`, a list of unique strings appended to `category` linking a subset of settings data rules to be handled together in the specified order</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

		---@class settingsmanager_listeners : widget_listeners
		---@field loaded? settingsmanager_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after `settingsmanager.load(...)` was called
		---@field saved? settingsmanager_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after `settingsmanager.save(...)` was called
		---@field applied? settingsmanager_listener_applied[] Ordered list of functions to call when a "applied" event is invoked after `settingsmanager.apply(...)` was called
		---@field reverted? settingsmanager_listener_reverted[] Ordered list of functions to call when a "reverted" event is invoked after `settingsmanager.revert(...)` was called
		---@field reset? settingsmanager_listener_reset[] Ordered list of functions to call when a "reset" event is invoked after `settingsmanager.reset(...)` was called
		---@field enabled? settingsmanager_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `settingsmanager.setEnabled(...)` was called
		---@field _? settingsmanager_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class settingsmanager_listener_loaded : eventHandlerIndex
			---@field handler settingsmanager_handler_loaded Handler function to register for call

				---@alias settingsmanager_handler_loaded
				---| fun(self: settingsmanager, user: boolean) Called when an "loaded" event is invoked after `settingsmanager.load(...)` was called<hr><p>@*param* `self` settingsmanager ― Reference to the settingsmanager widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsmanager_listener_saved : eventHandlerIndex
			---@field handler settingsmanager_handler_saved Handler function to register for call

				---@alias settingsmanager_handler_saved
				---| fun(self: settingsmanager, user: boolean) Called when an "saved" event is invoked after `settingsmanager.save(...)` was called<hr><p>@*param* `self` settingsmanager ― Reference to the settingsmanager widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsmanager_listener_applied : eventHandlerIndex
			---@field handler settingsmanager_handler_applied Handler function to register for call

				---@alias settingsmanager_handler_applied
				---| fun(self: settingsmanager, user: boolean) Called when an "applied" event is invoked after `settingsmanager.apply(...)` was called<hr><p>@*param* `self` settingsmanager ― Reference to the settingsmanager widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsmanager_listener_reverted : eventHandlerIndex
			---@field handler settingsmanager_handler_reverted Handler function to register for call

				---@alias settingsmanager_handler_reverted
				---| fun(self: settingsmanager, user: boolean) Called when an "revert" event is invoked after `settingsmanager.revert(...)` was called<hr><p>@*param* `self` settingsmanager ― Reference to the settingsmanager widget</p><<p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsmanager_listener_reset : eventHandlerIndex
			---@field handler settingsmanager_handler_reset Handler function to register for call

				---@alias settingsmanager_handler_reset
				---| fun(self: settingsmanager, user: boolean) Called when an "reset" event is invoked after `settingsmanager.reset(...)` was called<hr><p>@*param* `self` settingsmanager ― Reference to the settingsmanager widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsmanager_listener_enabled : eventHandlerIndex
			---@field handler settingsmanager_handler_enabled Handler function to register for call

				---@alias settingsmanager_handler_enabled
				---| fun(self: settingsmanager, state: boolean) Called when an "enabled" event is invoked after `settingsmanager.setEnabled(...)` was called<hr><p>@*param* `self` settingsmanager ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class settingsmanager_listener_any : eventHandlerIndex
			---@field handler settingsmanager_handler_any Handler function to register for call

				---@alias settingsmanager_handler_any
				---| fun(self: settingsmanager, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` settingsmanager ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>	

	--| Returns

	---@class settingsmanager : widget
	---@field invoke settingsmanager_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener settingsmanager_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_settingsmanager]: true, }
		function _.getTypes() return {} end

			---@alias typename_settingsmanager
			---| "Settingsmanager"

		--| Events

		---@class settingsmanager_invoke : widget_invoke
		---@field loaded fun(user: boolean) Invoke a "loaded" event to notify registered listeners and call handlers
		---@field saved fun(user: boolean) Invoke a "saved" event to notify registered listeners and call handlers
		---@field applied fun(user: boolean) Invoke a "applied" event to notify registered listeners and call handlers
		---@field reverted fun(user: boolean) Invoke a "reverted" event to notify registered listeners and call handlers
		---@field reset fun(user: boolean) Invoke a "reset" event to notify registered listeners and call handlers

		---@class settingsmanager_setListener : widget_setListener
		---@field [string] fun(handler: settingsmanager_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler settingsmanager_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler settingsmanager_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "applied" widget event
			---@param handler settingsmanager_handler_applied Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.applied(handler, callIndex) end

			---Register a listener for a "reverted" widget event
			---@param handler settingsmanager_handler_reverted Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.reverted(handler, callIndex) end

			---Register a listener for a "reset" widget event
			---@param handler settingsmanager_handler_reset Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.reset(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler settingsmanager_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| Batched datamanagement

		---Force update all linked settings widgets in this category page
		---***
		---@param handleChanges? boolean If true, also call all registered change handlers | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.load(handleChanges, user, silent) end

		---Force save all settings data of this category page from all linked widgets
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _.save(user, silent) end

		---Apply settings data of this category page by calling all registered `onChange` handlers of all linked widgets
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "applied" event and call registered listeners | ***Default:*** `false`
		function _.apply(user, silent) end

		---Revert any changes made in this category page and reload all linked widget data
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "reverted" event and call registered listeners | ***Default:*** `false`
		function _.revert(user, silent) end

		---Reset all settings data of this category page to default values
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "reset" event and call registered listeners | ***Default:*** `false`
		function _.reset(user, silent) end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

--| Settings Page

---Create an new Settings Panel frame and add it to the Options
---***
---@param t? settingsPageCreationData Optional parameters
---@param settingsmanager? settingsmanager Reference to an already existing settings datamanager to mutate into a settings page instead of creating a new base widget
---***
---@return settingsPage|nil page Table containing references to the settings canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions
function wt.CreateSettingsPage(t, settingsmanager)

	--| Parameters

	---@class settingsPageCreationData : settingsmanagerCreationData_base, describableObject, settingsCategoryData, settingsmanagerEvents, initializableOptionsContainer, liteObject # t
	---@field append? boolean When setting the name of the settings category page, append `t.name` after `addon` | ***Default:*** `true` if `t.name` ~= nil
	---@field icon? string Path to the texture file to use as the icon of this settings page | ***Default:*** *the addon's logo specified in its TOC file with the "IconTexture" tag*
	---@field titleIcon? boolean Append `t.icon` to the title of the button of the setting page in the AddOns list of the Settings window as well | ***Default:*** `true` if `t.register == true`
	---@field scroll? settingsPageScrollData If set, make the canvas frame scrollable by creating a [ScrollFrame](https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame) as its child
	---@field autoSave? boolean If true, automatically save the values of all widgets registered for settings datamanagement under settings keys listed in `t.dataManagement.keys`, committing their data to storage via <code><i>WidgetToolbox</i>.SaveOptionsData(...)</code> | ***Default:*** `true` if `t.dataManagement.keys` ~= nil<ul><li>***Note:*** If `t.dataManagement.keys` is not set, the automatic load will not be executed even if this is set to true.</li></ul>
	---@field autoLoad? boolean If true, automatically load all data to the widgets registered for settings datamanagement under settings keys listed in `t.dataManagement.keys` from storage via <code><i>WidgetToolbox</i>.LoadOptionsData(...)</code> | ***Default:*** `true` if `t.dataManagement.keys` ~= nil<ul><li>***Note:*** If `t.dataManagement.keys` is not set, the automatic load will not be executed even if this is set to true.</li></ul>
	---@field arrangement? arrangementData_settingsPage If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table
	---@field listeners? settingsPage_listeners|settingsmanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class settingsPageScrollData : scrollSpeedData
		---@field height? number Set the height of the scrollable child frame to the specified value | ***Default:*** `0` *(no height)*
		---@field speed? number Percentage of one page of content to scroll at a time | ***Range:*** (`0`, `1`) | ***Default:*** `0.25`

		---@class arrangementData_settingsPage : arrangementRules
		---@field margins? spacingData_settingsPage Inset the content inside the canvas frame by the specified amount on each side
		---@field gaps? number The amount of space to leave between rows | ***Default:*** `44`
		---@field resize? boolean Set the height of the canvas frame to match the space taken up by the arranged content (including margins) | ***Default:*** `t.scroll ~= nil`

			---@class spacingData_settingsPage
			---@field l? number Space to leave on the left side | 10
			---@field r? number Space to leave on the right side (doesn't need to be negated) | ***Default:*** 10
			---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** `44`
			---@field b? number Space to leave at the bottom | ***Default:*** `44`

		---@class settingsPage_listeners: settingsmanager_listeners
		---@field loaded? settingsPage_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after `settingsPage.load(...)` was called
		---@field saved? settingsPage_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after `settingsPage.save(...)` was called
		---@field applied? settingsPage_listener_applied[] Ordered list of functions to call when a "applied" event is invoked after `settingsPage.apply(...)` was called
		---@field reverted? settingsPage_listener_reverted[] Ordered list of functions to call when a "reverted" event is invoked after `settingsPage.revert(...)` was called
		---@field reset? settingsPage_listener_reset[] Ordered list of functions to call when a "reset" event is invoked after `settingsPage.reset(...)` was called
		---@field enabled? settingsPage_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `settingsPage.setEnabled(...)` was called
		---@field _? settingsPage_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class settingsPage_listener_loaded : eventHandlerIndex
			---@field handler settingsPage_handler_loaded Handler function to register for call

				---@alias settingsPage_handler_loaded
				---| fun(self: settingsPage, user: boolean) Called when an "loaded" event is invoked after `settingsPage.load(...)` was called<hr><p>@*param* `self` settingsPage ― Reference to the settingsPage widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsPage_listener_saved : eventHandlerIndex
			---@field handler settingsPage_handler_saved Handler function to register for call

				---@alias settingsPage_handler_saved
				---| fun(self: settingsPage, user: boolean) Called when an "saved" event is invoked after `settingsPage.save(...)` was called<hr><p>@*param* `self` settingsPage ― Reference to the settingsPage widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsPage_listener_applied : eventHandlerIndex
			---@field handler settingsPage_handler_applied Handler function to register for call

				---@alias settingsPage_handler_applied
				---| fun(self: settingsPage, user: boolean) Called when an "applied" event is invoked after `settingsPage.apply(...)` was called<hr><p>@*param* `self` settingsPage ― Reference to the settingsPage widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsPage_listener_reverted : eventHandlerIndex
			---@field handler settingsPage_handler_reverted Handler function to register for call

				---@alias settingsPage_handler_reverted
				---| fun(self: settingsPage, user: boolean) Called when an "revert" event is invoked after `settingsPage.revert(...)` was called<hr><p>@*param* `self` settingsPage ― Reference to the settingsPage widget</p><<p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsPage_listener_reset : eventHandlerIndex
			---@field handler settingsPage_handler_reset Handler function to register for call

				---@alias settingsPage_handler_reset
				---| fun(self: settingsPage, user: boolean) Called when an "reset" event is invoked after `settingsPage.reset(...)` was called<hr><p>@*param* `self` settingsPage ― Reference to the settingsPage widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsPage_listener_enabled : eventHandlerIndex
			---@field handler settingsPage_handler_enabled Handler function to register for call

				---@alias settingsPage_handler_enabled
				---| fun(self: settingsPage, state: boolean) Called when an "enabled" event is invoked after `settingsPage.setEnabled(...)` was called<hr><p>@*param* `self` settingsPage ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class settingsPage_listener_any : eventHandlerIndex
			---@field handler settingsPage_handler_any Handler function to register for call

				---@alias settingsPage_handler_any
				---| fun(self: settingsPage, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` settingsPage ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>	

	--| Returns

	---@class settingsPage : settingsmanager
	---@field canvas? canvasFrame|Frame The settings page main canvas frame
	---@field category? table The registered settings category page
	---@field content? Frame The content frame to house the settings widgets or other page content
	---@field header? Frame The header frame containing the page title, description and icon
	---@field title FontString
	---@field description? FontString
	---@field iconTexture? string
	---@field icon? Texture
	---@field setListener settingsPage_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---@class canvasFrame : Frame
		---@field OnCommit function
		---@field OnRefresh function
		---@field OnDefault function

		---Returns the unique identifier key representing the reset defaults warning popup dialog in the global `StaticPopupDialogs` table, and used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
		---@return string
		function _.getResetPopupKey() return "" end

		---Toggle the availability of the reset defaults and revert changes cancel buttons for this page
		---***
		---@param state boolean? ***Default:*** `true`
		function _.setStatic(state) end

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_settingsmanager]: true, [typename_settingsPage]: true, }
		function _.getTypes() return {} end

			---@alias typename_settingsPage
			---| "SettingsPage"

		--| Events

		---@class settingsPage_setListener : settingsmanager_setListener
		---@field [string] fun(handler: settingsPage_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler settingsPage_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler settingsPage_handler_saved Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(handler, callIndex) end

			---Register a listener for a "applied" widget event
			---@param handler settingsPage_handler_applied Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.applied(handler, callIndex) end

			---Register a listener for a "reverted" widget event
			---@param handler settingsPage_handler_reverted Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.reverted(handler, callIndex) end

			---Register a listener for a "reset" widget event
			---@param handler settingsPage_handler_reset Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.reset(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler settingsPage_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| Utilities

		---Open the Settings window to this category page
		--- - ***Note:*** No category page will be opened if `WidgetToolsDB.lite` is true.
		function _.open() end
end

---Create an new Settings category with a parent page, its child pages, and set up shared settings datamanagement for them
---***
---@param addon uiAddon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
---@param parent settingsPageCreationData|settingsPage Settings page creation parameters to create, or reference to an existing *unregistered* settings page to set as the parent page for the new category<ul><li>***Note:*** If the provided parent candidate page is already registered (containing a `category` value), it will be dismissed and no new category will be created at all.</li></ul>
---@param pages? settingsPageCreationData[]|settingsPage[] List of settings page creation parameters to create, or references to an existing *unregistered* settings pages to add as subcategories under `parent`<ul><li>***Note:*** Already registered pages (which contain a `category` value) will be skipped and won't be included in the new category.</li></ul>
---@param t? settingsCategoryCreationData Optional parameters
---***
---@return settingsCategory|nil category Table containing references to settings pages and utility functions or nil if the specified `parent` was invalid
function wt.CreateSettingsCategory(addon, parent, pages, t)

	--| Parameters

	---@class settingsCategoryCreationData # t
	---@field onLoad? fun(user: boolean) Called after the data of the settings widgets linked to all pages of this settings category has been loaded from storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
	---@field onDefaults? fun(user: boolean) Called after settings data handled by all pages of this settings category has been restored to default values (for example when the "All Settings" option is clicked in the dialogue opened by clicking on the "Restore Defaults" button)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>

	--| Returns

	---@class settingsCategory
	---@field pages settingsPage[]
	local _ = {}

		---Force update the settings widgets for all pages in this category
		---***
		---@param handleChanges? boolean If true, also call all registered change handlers | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		function _.load(handleChanges, user) end

		---Reset all settings data to their default values for all pages in this category
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param callListeners? boolean If true, call the `onDefault` listeners (if set) of each individual category page separately | ***Default:*** `true`
		function _.defaults(user, callListeners) end

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_settingsCategory]: true, }
		function _.getTypes() return {} end

			---@alias typename_settingsCategory
			---| "SettingsCategory"
end

--[ Profiles ]

---Create a non-GUI profilemanager widget with live database management and profile selection logic
---***
---@param accountData CreateProfilemanager_param1 Reference to the account-bound SavedVariables addon database where profile data is to be stored
	--- - ***Note:*** A subtable will be created under the key `profiles` if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).
---@param characterData CreateProfilemanager_param2 Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified
	--- - ***Note:*** An integer value will be created under the key `activeProfile` if it doesn't already exist in this table.
---@param defaultData CreateProfilemanager_param3 A static table containing all default settings values to be cloned when creating a new profile or resetting one
---@param t? profilemanagerCreationData Optional parameters
---@param widget? widget Reference to an already existing base widget to mutate into a profilemanager instead of creating a new one
---***
---@return profilemanager? profilemanager Reference to the new profilemanager widget, utility functions and more wrapped in a table | ***Default:*** `nil`
function wt.CreateProfilemanager(accountData, characterData, defaultData, t, widget)

	--| Parameters

	---Reference to the account-bound SavedVariables addon database where profile data is to be stored
	--- - ***Note:*** A subtable will be created under the key `profiles` if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).
	---@alias CreateProfilemanager_param1 # accountData
	---| profileStorage
	---| table

		---@class profileStorage
		---@field profiles profile[] List of profiles

			---@class profile
			---@field title string Display name of the profile
			---@field data table Custom profile data

	---Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified
	--- - ***Note:*** An integer value will be created under the key `activeProfile` if it doesn't already exist in this table.
	---@alias CreateProfilemanager_param2 # characterData
	---| characterProfileData
	---| table

		---@class characterProfileData # characterData
		---@field activeProfile integer The index of the currently active profile | ***Default:*** `1`

	---A static table containing all default settings values to be cloned when creating a new profile or resetting one
	---@alias CreateProfilemanager_param3 # defaultData
	---| table

	---@class profilemanagerCreationData # t
	---@field category? string Category name to be used for identifying this group of profile data when modified in popups and chat messages | ***Default:*** `"Addon"`
	---@field valueChecker? fun(key: number|string, value: any): boolean Helper function for validating values when checking profile data, returning true if the value is to be accepted as valid
	---@field recoveryMap? table<string, recoveryData>|fun(tableToCheck: table, recoveredData: recoveredData): recoveryMap: table<string, recoveryData>|nil Static map or function returning a dynamically creatable map for removed but recoverable data
	---@field onRecovery? fun(tableToCheck: table) Function called after the data has been has been recovered via the `recoveryMap`
	---@field listeners? profilemanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class recoveryData
		---@field saveTo table List of references to the tables to save the recovered piece of data to
		---@field saveKey string|number Save the data under this kay within the specified recovery tables
		---@field convertSave? fun(recovered: any): converted: any Function to convert or modify the recovered old data before it is saved

			---@class recoveredData
			---@field keyChain string Chain of keys that used to point to the removed data<ul><li>***Example:*** `"keyOne[2].keyThree.keyFour[1]"`.</li></ul>
			---@field data any Recoverable piece of removed data

		---@class profilemanager_listeners : widget_listeners
		---@field loaded? profilemanager_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data profile list has been loaded and verified
		---@field activated? profilemanager_listener_activated[] Ordered list of functions to call when an "activated" event is invoked after a profile has been activated
		---@field created? profilemanager_listener_created[] Ordered list of functions to call when a "created" event is invoked after a new data profile has been initialized
		---@field renamed? profilemanager_listener_renamed[] Ordered list of functions to call when a "renamed" event is invoked after a data profile has been renamed
		---@field deleted? profilemanager_listener_deleted[] Ordered list of functions to call when a "deleted" event is invoked after a data profile has been removed from the database
		---@field reset? profilemanager_listener_reset[] Ordered list of functions to call when a "reset" event is invoked after a data profile has been reset to defaults
		---@field enabled? profilemanager_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `profilemanager.setEnabled(...)` was called
		---@field _? profilemanager_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class profilemanager_listener_loaded : eventHandlerIndex
			---@field handler profilemanager_handler_loaded Handler function to register for call

				---@alias profilemanager_handler_loaded
				---| fun(self: profilemanager, user: boolean) Called when an "loaded" event is invoked after the data profile list has been loaded and verified<hr><p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_activated : eventHandlerIndex
			---@field handler profilemanager_handler_activated Handler function to register for call

				---@alias profilemanager_handler_activated
				---| fun(self: profilemanager, index: integer, title: string, success: boolean, user: boolean) Called when an "activated" event is invoked after a profile has been activated<hr><p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `index` integer — The index of the active profile</p><p>@*param* `title` string — The title of the active profile</p><p>@*param* `success` boolean ― True if the active profile was changed successfully</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_created : eventHandlerIndex
			---@field handler profilemanager_handler_created Handler function to register for call

				---@alias profilemanager_handler_created
				---| fun(self: profilemanager, index: integer, title: string, user: boolean) Called when an "created" event is invoked after a new data profile has been initialized<hr><p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `index` integer — The index of the new profile</p><p>@*param* `title` string — The title of the new profile</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_renamed : eventHandlerIndex
			---@field handler profilemanager_handler_renamed Handler function to register for call

				---@alias profilemanager_handler_renamed
				---| fun(self: profilemanager, success: boolean, index: any, title?: string, user: boolean) Called when an "renamed" event is invoked after a data profile has been renamed<hr><p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile was renamed successfully</p><p>@*param* `index` any — The index of the profile attempted to be renamed</p><p>@*param* `title`? string — The new title of the profile attempted to be renamed</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_deleted : eventHandlerIndex
			---@field handler profilemanager_handler_deleted Handler function to register for call

				---@alias profilemanager_handler_deleted
				---| fun(self: profilemanager, success: boolean, index: any, title?: string, user: boolean) Called when an "deleted" event is invoked after a data profile has been removed from the database<hr><p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile was deleted successfully</p><p>@*param* `index` any — The original index of the profile attempted to be deleted</p><p>@*param* `title`? string — The title of the  profile attempted to be deleted</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_reset : eventHandlerIndex
			---@field handler profilemanager_handler_reset Handler function to register for call

				---@alias profilemanager_handler_reset
				---| fun(self: profilemanager, success: boolean, index: any, title?: string, user: boolean) Called when an "reset" event is invoked after a data profile has been reset to defaults<hr><p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile data was reset successfully</p><p>@*param* `index` any — The index of the profile attempted to be reset</p><p>@*param* `title`? string — The title of the profile attempted to be reset</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_enabled : eventHandlerIndex
			---@field handler profilemanager_handler_enabled Handler function to register for call

				---@alias profilemanager_handler_enabled
				---| fun(self: profilemanager, state: boolean) Called when an "enabled" event is invoked after `profilemanager.setEnabled(...)` was called<hr><p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class profilemanager_listener_any : eventHandlerIndex
			---@field handler profilemanager_handler_any Handler function to register for call

				---@alias profilemanager_handler_any
				---| fun(self: profilemanager, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class profilemanager : widget
	---@field data table Reference to live data table of the currently active profile
	---@field firstLoad boolean True, if the `accountData.profiles` table did not exist yet
	---@field newCharacter boolean True, if the `characterData.activeProfile` integer did not exist yet
	---@field invoke profilemanager_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener profilemanager_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_profilemanager]: true, }
		function _.getTypes() return {} end

			---@alias typename_profilemanager
			---| "Profilemanager"

		--| Events

		---@class profilemanager_invoke : widget_invoke
		---@field loaded fun(user: boolean) Invoke a "loaded" event to notify registered listeners and call handlers
		---@field activated fun(success: boolean, user: boolean) Invoke an "activated" event to notify registered listeners and call handlers
		---@field created fun(index: integer, title: string, user: boolean) Invoke a "created" event to notify registered listeners and call handlers
		---@field renamed fun(success: boolean, user: boolean, index: any, title?: string) Invoke a "renamed" event to notify registered listeners and call handlers
		---@field deleted fun(success: boolean, user: boolean, index: any, title?: string) Invoke a "deleted" event to notify registered listeners and call handlers
		---@field reset fun(success: boolean, user: boolean, index: any, title?: string) Invoke a "reset" event to notify registered listeners and call handlers

		---@class profilemanager_setListener : widget_setListener
		---@field [string] fun(handler: profilemanager_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler profilemanager_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for an "activated" widget event
			---@param handler profilemanager_handler_activated Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.activated(handler, callIndex) end

			---Register a listener for a "created" widget event
			---@param handler profilemanager_handler_created Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.created(handler, callIndex) end

			---Register a listener for a "renamed" widget event
			---@param handler profilemanager_handler_renamed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.renamed(handler, callIndex) end

			---Register a listener for a "deleted" widget event
			---@param handler profilemanager_handler_deleted Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.deleted(handler, callIndex) end

			---Register a listener for a "reset" widget event
			---@param handler profilemanager_handler_reset Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.reset(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler profilemanager_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| Utilities

		---Activate the specified settings profile
		---***
		---@param index? integer Index of the profile to set as the currently active settings profile | ***Default:*** *currently active profile index* or `1`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "applied" event and call registered listeners | ***Default:*** `false`
		---***
		---@return integer? index The index of the active profile | ***Default:*** `nil`
		function _.activate(index, user, silent) end

		---Find a profile by its display title and return its index
		---***
		---@param title string Name of the profile to find
		---@param skipFirst? boolean Set to `true` to find duplicate `title` | ***Default:*** `false`
		---@return integer? index
		function _.findIndex(title, skipFirst) end

		---Create a new settings profile
		---***
		---@param name? string Name tag to use when setting the display title of the new profile | ***Default:*** `duplicate and accountData.profiles[duplicate].title or "Profile"`
		---@param number? integer Starting value for the incremented number appended to `name` if it's used | ***Default:*** `2`
		---@param duplicate? integer Index of the profile to create the new profile as a duplicate of instead of using default data values
		---@param apply? boolean Whether to immediately set the new profile as the active profile or not | ***Default:*** `true`
		---@param index? integer Place the new profile under this specified index in `accountData.profile` instead of the end of the list | ***Range:*** (`1`, `#accountData.profiles + 1`)
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "created" event and call registered listeners | ***Default:*** `false`
		function _.create(name, number, duplicate, index, apply, user, silent) end

		---Rename the specified profile
		---@param index? integer Index of the profile to rename | ***Default:*** *currently active profile index*
		---@param name? string The new title of the profile to set | ***Default:*** `"Profile"`
		---@param number? integer Starting value for the incremented number appended to `name` if it's used | ***Default:*** `2`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "renamed" event and call registered listeners | ***Default:*** `false`
		---***
		---@return boolean # True on success, false if the operation failed
		function _.rename(index, name, number, user, silent) return false end

		---Delete the specified profile
		---***
		---@param index? integer Index of the profile to delete | ***Default:*** *currently active profile index*
		---@param unsafe? boolean If false, show a popup confirmation before attempting to delete the specified profile | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "deleted" event and call registered listeners | ***Default:*** `false`
		---***
		---@return boolean # True on success, false if the operation failed
		function _.delete(index, unsafe, user, silent) return false end

		---Reset the specified profile data to default values
		---***
		---@param index? integer Index of the profile to restore to defaults | ***Default:*** *currently active profile index*
		---@param unsafe? boolean If false, show a popup confirmation before attempting to reset the specified profile | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "reset" event and call registered listeners | ***Default:*** `false`
		---***
		---@return boolean # True on success, false if the operation failed
		function _.reset(index, unsafe, user, silent) return false end

		---Check & fix a profile data table based on the specified sample profile
		---***
		---@param profileData table Profile data table to check
		---@param compareWith? table  Profile data table to sample | ***Default:*** `defaultData`
		---***
		---@return table profileData Reference to `profileData` (it was already updated during the operation, no need for setting it again)
		function _.validate(profileData, compareWith) return {} end

		---Load profiles data
		---***
		---@param p? profileStorage Table holding the list of profiles to store | ***Default:*** *validate* `accountData` *(if the data is missing or invalid, set up a default profile)*
		---@param activeProfile? integer Index of the active profile to set | ***Default:*** *currently active profile index*
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "loaded" event and call registered listeners | ***Default:*** `false`
		function _.load(p, activeProfile, user, silent) end

	return _
end

--| Profiles Page

---Create and set up a new settings page with profile data handling and advanced backup management options
---***
---@param accountData CreateProfilemanager_param1 Reference to the account-bound SavedVariables addon database where profile data is to be stored
	--- - ***Note:*** A subtable will be created under the key `profiles` if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).
---@param characterData CreateProfilemanager_param2 Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified
	--- - ***Note:*** An integer value will be created under the key `activeProfile` if it doesn't already exist in this table.
---@param defaultData CreateProfilemanager_param3 A static table containing all default settings values to be cloned when creating a new profile or resetting one
---@param settingsData CreateProfilesPage_param4 Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from
--- - ***Note:*** A boolean value will be created under the key `compactBackup` if it didn't already exist in this table.
---@param t? profilesPageCreationData Optional parameters
---@param profilemanager? profilemanager Reference to an already existing profile datamanager to mutate into a profile management settings page instead of creating a new base widget
---***
---@return profilemanager|profilesPage? profilesPage Table containing references to the settings page, settings widgets grouped in subtables and utility functions by category | ***Default:*** `nil`
function wt.CreateProfilesPage(accountData, characterData, defaultData, settingsData, t, profilemanager)

	--| Parameters

	---Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from
	--- - ***Note:*** A boolean value will be created under the key `compactBackup` if it didn't already exist in this table.
	---@alias CreateProfilesPage_param4 # settingsData
	---| backupboxSettingsData
	---| table

		---@class backupboxSettingsData
		---@field compactBackup boolean Whether to skip including additional white spaces to the backup string for more readability

	---@class profilesPageCreationData : profilemanagerCreationData, settingsmanagerCreationData_base, settingsmanagerEvents, liteObject # t
	---@field name? string Unique string used to set the name of the canvas frame | ***Default:*** `"Profiles"`<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field title? string Text to be shown as the title of the settings page | ***Default:*** `"Data Management"`
	---@field description? string Text to be shown as the description below the title of the settings page | ***Default:*** *describing profiles & backup*
	---@field listeners? profilesPage_listeners|profilemanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field onImport? fun(success: boolean, data: table) Called after a settings backup string import has been performed by the user loading data for the currently active profile<hr><p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>
	---@field onImportAllProfiles? fun(success: boolean, data: table) Called after a settings backup string import has been performed by the user loading data for all profiles<p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>

		---@class profilesPage_listeners : profilemanager_listeners
		---@field loaded? profilesPage_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data profile list has been loaded and verified
		---@field activated? profilesPage_listener_activated[] Ordered list of functions to call when an "activated" event is invoked after a profile has been activated
		---@field created? profilesPage_listener_created[] Ordered list of functions to call when a "created" event is invoked after a new data profile has been initialized
		---@field renamed? profilesPage_listener_renamed[] Ordered list of functions to call when a "renamed" event is invoked after a data profile has been renamed
		---@field deleted? profilesPage_listener_deleted[] Ordered list of functions to call when a "deleted" event is invoked after a data profile has been removed from the database
		---@field reset? profilesPage_listener_reset[] Ordered list of functions to call when a "reset" event is invoked after a data profile has been reset to defaults
		---@field enabled? profilesPage_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `profilesPage.setEnabled(...)` was called
		---@field _? profilesPage_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class profilesPage_listener_loaded : eventHandlerIndex
			---@field handler profilesPage_handler_loaded Handler function to register for call

				---@alias profilesPage_handler_loaded
				---| fun(self: profilesPage, user: boolean) Called when an "loaded" event is invoked after the data profile list has been loaded and verified<hr><p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_activated : eventHandlerIndex
			---@field handler profilesPage_handler_activated Handler function to register for call

				---@alias profilesPage_handler_activated
				---| fun(self: profilesPage, index: integer, title: string, success: boolean, user: boolean) Called when an "activated" event is invoked after a profile has been activated<hr><p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `index` integer — The index of the active profile</p><p>@*param* `title` string — The title of the active profile</p><p>@*param* `success` boolean ― True if the active profile was changed successfully</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_created : eventHandlerIndex
			---@field handler profilesPage_handler_created Handler function to register for call

				---@alias profilesPage_handler_created
				---| fun(self: profilesPage, index: integer, title: string, user: boolean) Called when an "created" event is invoked after a new data profile has been initialized<hr><p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `index` integer — The index of the new profile</p><p>@*param* `title` string — The title of the new profile</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_renamed : eventHandlerIndex
			---@field handler profilesPage_handler_renamed Handler function to register for call

				---@alias profilesPage_handler_renamed
				---| fun(self: profilesPage, success: boolean, index: any, title?: string, user: boolean) Called when an "renamed" event is invoked after a data profile has been renamed<hr><p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile was renamed successfully</p><p>@*param* `index` any — The index of the profile attempted to be renamed</p><p>@*param* `title`? string — The new title of the profile attempted to be renamed</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_deleted : eventHandlerIndex
			---@field handler profilesPage_handler_deleted Handler function to register for call

				---@alias profilesPage_handler_deleted
				---| fun(self: profilesPage, success: boolean, index: any, title?: string, user: boolean) Called when an "deleted" event is invoked after a data profile has been removed from the database<hr><p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile was deleted successfully</p><p>@*param* `index` any — The original index of the profile attempted to be deleted</p><p>@*param* `title`? string — The title of the  profile attempted to be deleted</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_reset : eventHandlerIndex
			---@field handler profilesPage_handler_reset Handler function to register for call

				---@alias profilesPage_handler_reset
				---| fun(self: profilesPage, success: boolean, index: any, title?: string, user: boolean) Called when an "reset" event is invoked after a data profile has been reset to defaults<hr><p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile data was reset successfully</p><p>@*param* `index` any — The index of the profile attempted to be reset</p><p>@*param* `title`? string — The title of the profile attempted to be reset</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_enabled : eventHandlerIndex
			---@field handler profilesPage_handler_enabled Handler function to register for call

				---@alias profilesPage_handler_enabled
				---| fun(self: profilesPage, state: boolean) Called when an "enabled" event is invoked after `profilesPage.setEnabled(...)` was called<hr><p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class profilesPage_listener_any : eventHandlerIndex
			---@field handler profilesPage_handler_any Handler function to register for call

				---@alias profilesPage_handler_any
				---| fun(self: profilesPage, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class profilesPage : profilemanager
	---@field settings settingsPage
	---@field widgets? profilesPageWidgets Collection of profiles settings widgets
	---@field backup? profilesPageBackup Collection of backup settings widgets
	---@field backupAll? profilesPageBackup Collection of all profiles backup settings widgets
	---@field setListener profilesPage_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		---@class profilesPageWidgets
		---@field activate selector|dropdownRadiogroup
		---@field create action|actionButton
		---@field duplicate action|actionButton
		---@field rename action|actionButton
		---@field delete action|actionButton

		---@class profilesPageBackup
		---@field refresh function Update the backup box and load profile data of the selected scope to the backup string, formatted based on the compact setting
		---@field box textual|multilineEditbox
		---@field compact binary|checkbox
		---@field load action|actionButton
		---@field reset action|actionButton

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_profilemanager]: true, [typename_profilesPage]: true, }
		function _.getTypes() return {} end

			---@alias typename_profilesPage
			---| "ProfilesPage"

		--| Events

		---@class profilesPage_setListener : profilemanager_setListener
		---@field [string] fun(handler: profilesPage_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler profilesPage_handler_loaded Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(handler, callIndex) end

			---Register a listener for an "activated" widget event
			---@param handler profilesPage_handler_activated Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.activated(handler, callIndex) end

			---Register a listener for a "created" widget event
			---@param handler profilesPage_handler_created Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.created(handler, callIndex) end

			---Register a listener for a "renamed" widget event
			---@param handler profilesPage_handler_renamed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.renamed(handler, callIndex) end

			---Register a listener for a "deleted" widget event
			---@param handler profilesPage_handler_deleted Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.deleted(handler, callIndex) end

			---Register a listener for a "reset" widget event
			---@param handler profilesPage_handler_reset Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.reset(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler profilesPage_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end
end

--[ Addon ]

---Create a non-GUI addonmanager widget providing extended utility on top of Blizzard's [C_AddOns](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API#AddOns) & [C_AddOnProfiler](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API#AddOnProfiler) API collections
---***
---@param t? addonmanagerCreationData Optional parameters
---@param widget? widget Reference to an already existing base widget to mutate into an addonmanager instead of creating a new one
---***
---@return addonmanager? addonmanager Reference to the new addonmanager widget, utility functions and more wrapped in a table | ***Default:*** `nil`
function wt.CreateAddonmanager(t, widget)

	--| Parameters

	---@class addonmanagerCreationData : togglableObject
	---@field addon? uiAddon If a valid addon namespace name (its folder name, not the displayed title) or its loaded index is provided, load the metadata for it into the new addonmanager immediately | ***Default:*** *no addon, empty addonmanager*
	---@field changelog? { [table[]] : string[] } String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included<ul><li>***Note:*** The first line is expected to be the title containing the version number and/or the date of release.</li><li>***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).</li><li>***Examples:***<ul><li>**Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)</li><li>**Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)</li><li>**Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)</li><li>**Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)</li><li>**Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)</li><li>**Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
	---@field listeners? addonmanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class addonmanager_listeners : widget_listeners
		---@field changed? addonmanager_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after the info of the managed addon has been loaded
		---@field _? addonmanager_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class addonmanager_listener_changed : eventHandlerIndex
			---@field handler addonmanager_handler_changed Handler function to register for call

				---@alias addonmanager_handler_changed
				---| fun(self: addonmanager, addon: string, user: boolean) Called when an "changed" event is invoked after the info of the managed addon has been loaded<hr><p>@*param* `self` addonmanager ― Reference to the widget table</p><p>@*param* `addon` string ― Namespace name of the addon that was loaded by the manager</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class addonmanager_listener_enabled : eventHandlerIndex
			---@field handler addonmanager_handler_enabled Handler function to register for call

				---@alias addonmanager_handler_enabled
				---| fun(self: addonmanager, state: boolean) Called when an "enabled" event is invoked after `addonmanager.setEnabled(...)` was called<hr><p>@*param* `self` addonmanager ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class addonmanager_listener_any : eventHandlerIndex
			---@field handler addonmanager_handler_any Handler function to register for call

				---@alias addonmanager_handler_any
				---| fun(self: addonmanager, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` addonmanager ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class addonmanager : widget
	---@field invoke addonmanager_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener addonmanager_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_addonmanager]: true, }
		function _.getTypes() return {} end

			---@alias typename_addonmanager
			---| "Addonmanager"

		--| Events

		---@class addonmanager_invoke : widget_invoke
		---@field changed fun(addon: string, user: boolean) Invoke a "changed" event to notify registered listeners and call handlers

		---@class addonmanager_setListener : widget_setListener
		---@field [string] fun(handler: addonmanager_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "changed" widget event
			---@param handler addonmanager_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler profilesPage_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end

		--| Metadata

		---Addon namespace name of the addon managed by this widget
		---@return string | ***Default:*** `""`
		function _.getAddon() return "" end

		---Addon display title
		---@return string | ***Default:*** `""`
		function _.getTitle() return "" end

		---Latest version number text
		---@return string? ***Default:*** `nil`
		function _.getVersion() end

		---Date of the latest release
		---***
		---@return string? date Formatted date text
		---@return integer? day Day of the month
		---@return integer? month Month number
		---@return integer? year
		function _.getDate() end

		---Addon list category name
		---@return string? ***Default:*** `nil`
		function _.getCategory() end

		---Addon description notes
		---@return string? ***Default:*** `nil`
		function _.getNotes() end

		---Author name
		---@return string? ***Default:*** `nil`
		function _.getAuthor() end

		---License description
		---@return string? ***Default:*** `nil`
		function _.getLicense() end

		---CurseForge link
		---@return string? ***Default:*** `nil`
		function _.getCurseForgeLink() end

		---Wago link
		---@return string? ***Default:*** `nil`
		function _.getWagoLink() end

		---Repository link
		---@return string? ***Default:*** `nil`
		function _.getRepositoryLink() end

		---Contact link for feedback & bug reports
		---@return string? ***Default:*** `nil`
		function _.getIssuesLink() end

		---Sponsor names
		---@return string? # Semicolon separated tiers of comma separated lists of sponsor names | ***Default:*** `nil`
		function _.getSponsors() end

		---Addon logo texture file path
		---@return string? ***Default:*** `nil`
		function _.getLogo() end

		---Formatted changelog text of the latest release & the entire version history
		---@return string? latest ***Default:*** `nil`
		---@return string? full ***Default:*** `nil`
		function _.getChangelog() end

		--| Rebind

		---Change the addon managed by this widget
		---***
		---@param addon uiAddon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
		---@param changelog? CreateAddonmanager_setAddon_param1 String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included
		--- - ***Note:*** The first line is expected to be the title containing the version number and/or the date of release.
		--- - ***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).
		--- - ***Examples:***
		---   - **Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)
		---   - **Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)
		---   - **Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)
		---   - **Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)
		---   - **Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)
		---   - **Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		---***
		---@return boolean # True if the operation was successful
		function _.setAddon(addon, changelog, user, silent)

			---| Parameters

			---String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included
			--- - ***Note:*** The first line is expected to be the title containing the version number and/or the date of release.
			--- - ***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).
			--- - ***Examples:***
			---   - **Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)
			---   - **Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)
			---   - **Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)
			---   - **Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)
			---   - **Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)
			---   - **Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
			---@alias CreateAddonmanager_setAddon_param1
			---| { [table[]] : string[] }
			---| nil

			---| Returns

			return false
		end

	return _
end

--| Addon Page

---Create and set up a new settings page with about into for an addon
---***
---@param t? aboutPageCreationData Optional parameters
---@param addonmanager CreateAddonPage_param3? Reference to an already existing addonmanager to mutate into an addon about settings page instead of creating a new base widget
---***
---@return addonPage|nil aboutPage Table containing references to the canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions | ***Default:*** `nil`
function wt.CreateAddonPage(t, addonmanager)

	--| Parameters

	---@class aboutPageCreationData : settingsmanagerCreationData_base, addonmanagerCreationData # t
	---@field description? string Text to be shown as the description below the title of the settings page | ***Default:*** [GetAddOnMetadata(`addon`, "Notes")](https://warcraft.wiki.gg/wiki/API_GetAddOnMetadata)
	---@field static? boolean If true, disable the "Restore Defaults" & "Revert Changes" buttons | ***Default:*** `true`
	---@field listeners? addonPage_listeners|addonmanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class addonPage_listeners : addonmanager_listeners
		---@field changed? addonPage_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after the info of the managed addon has been loaded
		---@field _? addonPage_listener_any[] Ordered list of functions to call when a custom event is invoked

			---@class addonPage_listener_changed : eventHandlerIndex
			---@field handler addonPage_handler_changed Handler function to register for call

				---@alias addonPage_handler_changed
				---| fun(self: addonPage, addon: string, user: boolean) Called when an "changed" event is invoked after the info of the managed addon has been loaded<hr><p>@*param* `self` addonPage ― Reference to the widget table</p><p>@*param* `addon` string ― Namespace name of the addon that was loaded by the manager</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class addonPage_listener_enabled : eventHandlerIndex
			---@field handler addonPage_handler_enabled Handler function to register for call

				---@alias addonPage_handler_enabled
					---| fun(self: addonPage, state: boolean) Called when an "enabled" event is invoked after `addonPage.setEnabled(...)` was called<hr><p>@*param* `self` addonPage ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

			---@class addonPage_listener_any : eventHandlerIndex
			---@field handler addonPage_handler_any Handler function to register for call

				---@alias addonPage_handler_any
				---| fun(self: addonPage, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` addonPage ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	---Reference to an already existing addonmanager to mutate into an addon about settings page instead of creating a new base widget
	---@alias CreateAddonPage_param3 # addonmanager
	---| addonmanager
	---| nil

	--| Returns

	---@class addonPage : addonmanager
	---@field settings settingsPage
	---@field setAddon nil
	---@field setListener addonPage_setListener Hook a handler function as a listener for a widget event
	local _ = {}

		--| Type

		---Returns the type list of this widget
		---@return { [typename_widget]: true, [typename_addonmanager]: true, [typename_addonPage]: true, }
		function _.getTypes() return {} end

			---@alias typename_addonPage
			---| "AddonPage"

		--| Events

		---@class addonPage_setListener : addonmanager_setListener
		---@field [string] fun(handler: addonPage_handler_any, callIndex?: integer) Register a listener for a custom widget event
		local setListener = {}

			---Register a listener for a "changed" widget event
			---@param handler addonPage_handler_changed Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(handler, callIndex) end

			---Register a listener for a "enabled" widget event
			---@param handler addonPage_handler_enabled Handler function to call on trigger
			---@param callIndex? integer Set when to call the event handler in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(handler, callIndex) end
end