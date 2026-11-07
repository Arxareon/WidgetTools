--NOTE: Annotations are for development purposes only, providing live documentation via Lua Language Server. This file does not need to be loaded by the game client.

---@meta utilities


--[[ TOOLBOX ]]

---Widget Toolbox table
---@class toolbox : widgetToolbox
---@field addon string Toolbox sub-addon namespace name
---@field title string Toolbox sub-addon display title
---@field root string Toolbox sub-addon root folder path
---@field version string Toolbox version number string
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

		---@class wrappedInteger
		---@field index? integer ***Default:*** `nil` *(no selection)*

		---@class wrappedBooleanArray
		---@field states? boolean[] Indexed list of current item states in order | ***Default:*** `false`[] *(no selected items)*

		---@class wrappedAnchor
		---@field value? FramePoint ***Default:*** `nil` *(no selection)*

		---@class wrappedJustifyH
		---@field value? JustifyHorizontal ***Default:*** `nil` *(no selection)*

		---@class wrappedJustifyV
		---@field value? JustifyVertical ***Default:*** `nil` *(no selection)*

		---@class wrappedStrata
		---@field value? FrameStrata ***Default:*** `nil` *(no selection)*

		---@alias color
		---| rgbData
		---| colorData
		---| colorRGBA
		---| colorRGB

			---@class colorData : rgbData, alpha_opaqueDefault

				---@class rgbData
				---@field r normalizedNumber
				---@field g normalizedNumber
				---@field b normalizedNumber

				---@class alpha_opaqueDefault
				---@field a? normalizedNumber | ***Default:*** `1`

		---@class positionData : positionData_base
		---@field offset? offsetData

			---@class positionData_base
			---@field anchor? FramePoint ***Default:*** `"TOPLEFT"`
			---@field relativeTo? AnyFrameObject|ScriptRegion|string|"nil" Frame or ScriptRegion reference or name, or "nil" to anchor relative to screen dimensions | ***Default:*** `"nil"`<ul><li>***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).</li><li>***Note:*** Default to "nil" when an invalid frame name is provided.</li></ul>
			---@field relativePoint? FramePoint ***Default:*** `anchor`

			---@class offsetData
			---@field x? number Horizontal offset value | ***Default:*** `0`
			---@field y? number Vertical offset value | ***Default:*** `0`

			---@class fontData
			---@field path string Path to the font file relative to the WoW client directory<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Fonts/Font.ttf), otherwise use `\\`.</li><li>***Note:*** **File format:** Font files must be in TTF or OTF format.</li></ul>
			---@field size number The default display size of the new font object
			---@field style TBFFlags Comma separated string of font styling flags


--[[ TABLE MANAGEMENT ]]

---Align all keys in a table to a reference table, filling missing values and removing mismatched or invalid pairs
---@param targetTable HarmonizeData_param_targetTable Reference to the table to get into alignment with the sample
---@param tableToSample HarmonizeData_param_tableToSample Reference to the table to sample keys & data from
---@return HarmonizeData_return_targetTable targetTable Reference to `targetTable` (it was already overwritten during the operation, no need for setting it again)
function wt.HarmonizeData(targetTable, tableToSample)

	--| Parameters

	---Reference to the table to get into alignment with the sample
	---@alias HarmonizeData_param_targetTable table

	---Reference to the table to sample keys & data from
	---@alias HarmonizeData_param_tableToSample table

	--| Returns

	---Reference to `targetTable` (it was already overwritten during the operation, no need for setting it again)
	---@alias HarmonizeData_return_targetTable table|any
end


--[[ DATA MANAGEMENT ]]

--| Conversion

---Return a position table used by WidgetTools assembled from the provided values which are returned by [`Region:GetPoint(...)`](https://warcraft.wiki.gg/wiki/API_Region_GetPoint)
---@param anchor PackPosition_param_anchor Base anchor point | ***Default:*** `"TOPLEFT"`
---@param relativeTo PackPosition_param_relativeTo Relative to this Frame or `ScriptRegion`
---@param relativePoint PackPosition_param_relativePoint Relative anchor point
---@param offsetX PackPosition_param_offsetX ***Default:*** `0`
---@param offsetY PackPosition_param_offsetY ***Default:*** `0`
---@return PackPosition_return Table containing the position values as used by WidgetTools
function wt.PackPosition(anchor, relativeTo, relativePoint, offsetX, offsetY)

	--| Parameters

	---Base anchor point | ***Default:*** `"TOPLEFT"`
	---@alias PackPosition_param_anchor FramePoint?

	---Relative to this Frame or `ScriptRegion`
	---@alias PackPosition_param_relativeTo AnyFrameObject|ScriptRegion|string|"nil"?

	---Relative anchor point
	---@alias PackPosition_param_relativePoint FramePoint?

	---***Default:*** `0`
	---@alias PackPosition_param_offsetX number?

	---***Default:*** `0`
	---@alias PackPosition_param_offsetY number?

	--| Returns

	---Table containing the position values as used by WidgetTools
	---@alias PackPosition_return positionData

	return {}
end

---Extract, verify and return the position values used by [`Region:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) from a position table used by WidgetTools
---@param t UnpackPosition_param_t Table containing parameters to call [`Region:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with
---@return UnpackPosition_return_anchor anchor ***Default:*** `"TOPLEFT"`
---@return UnpackPosition_return_relativeTo relativeTo ***Default:*** `"nil"` *(anchor relative to screen dimensions)*
--- - ***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).
---@return UnpackPosition_return_relativePoint relativePoint Relative anchor point
---@return UnpackPosition_return_offsetX offsetX ***Default:*** `0`
---@return UnpackPosition_return_offsetY offsetY ***Default:*** `0`
function wt.UnpackPosition(t)

	--| Parameters

	---Table containing parameters to call [`Region:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with
	---@alias UnpackPosition_param_t positionData?

	--| Returns

	---***Default:*** `"TOPLEFT"`
	---@alias UnpackPosition_return_anchor FramePoint

	---***Default:*** `"nil"` *(anchor relative to screen dimensions)*
	--- - ***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).
	---@alias UnpackPosition_return_relativeTo AnyFrameObject|ScriptRegion|string|"nil"|nil

	---Relative anchor point
	---@alias UnpackPosition_return_relativePoint FramePoint|nil

	---***Default:*** `0`
	---@alias UnpackPosition_return_offsetX number|nil

	---***Default:*** `0`
	---@alias UnpackPosition_return_offsetY number|nil

	return "TOPLEFT"
end

--[ Color ]

--| Verification

---Check if a variable is a valid color table
---@param t any
---@return color|false
function wt.IsColor(t) return false end

---Check & silently repair a color data table
---@param color any
---@return VerifyColor_return ***Default:*** `{ r = 1, g = 1, b = 1, a = 1 }`
function wt.VerifyColor(color)

	--| Returns

	---***Default:*** `{ r = 1, g = 1, b = 1, a = 1 }`
	---@alias VerifyColor_return color

	return { r = 1, g = 1, b = 1 }
end

--| Conversion

---Return a table constructed from color values
---@param red PackColor_param ***Default:*** `1`
---@param green PackColor_param ***Default:*** `1`
---@param blue PackColor_param ***Default:*** `1`
---@param alpha PackColor_param ***Default:*** `1`
---@return PackColor_return Table containing the color values
function wt.PackColor(red, green, blue, alpha)

	--| Parameters

	---***Default:*** `1`
	---@alias PackColor_param normalizedNumber?

	--| Returns

	---Table containing the color values
	---@alias PackColor_return colorData

	return {}
end

---Extract, verify and return the color values found in a table
---@param color UnpackColor_param_color Table containing the color values | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
---@param alpha UnpackColor_param_alpha Specify whether to return the full RGBA set or just the RGB values | ***Default:*** `true`
---@return UnpackColor_return_rgb r ***Default:*** `1`
---@return UnpackColor_return_rgb g ***Default:*** `1`
---@return UnpackColor_return_rgb b ***Default:*** `1`
---@return normalizedNumber? a
function wt.UnpackColor(color, alpha)

	--| Parameters

	---Table containing the color values | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
	---@alias UnpackColor_param_color color?

	---Specify whether to return the full RGBA set or just the RGB values | ***Default:*** `true`
	---@alias UnpackColor_param_alpha boolean?

	--| Returns

	---***Default:*** `1`
	---@alias UnpackColor_return_rgb normalizedNumber

	return 1, 1, 1
end

---Convert normalized RGB(A) color values to HEX color code
---@param color ColorToHex_param_color The normalized RGB(A) color data values from all channels | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
---@param alphaFirst ColorToHex_param_alphaFirst Put the alpha value first: ARGB output instead of RGBA | ***Default:*** `false`
---@param hashtag ColorToHex_param_hashtag Whether to add a `"#"` to the beginning of the color description | ***Default:*** `true`
---@return ColorToHex_return_hex hex Color code in HEX format
--- - ***Examples:***
--- 	- **RGB:** *`"#2266BB"`*
--- 	- **RGBA:** *`"#2266BBAA"`*
function wt.ColorToHex(color, alphaFirst, hashtag)

	--| Parameters

	---The normalized RGB(A) color data values from all channels | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
	---@alias ColorToHex_param_color color?

	---Put the alpha value first: ARGB output instead of RGBA | ***Default:*** `false`
	---@alias ColorToHex_param_alphaFirst boolean?

	---Whether to add a `"#"` to the beginning of the color description | ***Default:*** `true`
	---@alias ColorToHex_param_hashtag boolean?

	--| Returns

	---Color code in HEX format
	--- - ***Examples:***
	--- 	- **RGB:** *`"#2266BB"`*
	--- 	- **RGBA:** *`"#2266BBAA"`*
	---@alias ColorToHex_return_hex string

	return ""
end

---Convert a HEX color code into normalized RGB(A)
---@param hex HexToColor_param_hex String in HEX color code format
--- - ***Examples:***
--- 	- **RGB:** *`"#2266BB"` (where `"#"` is optional)*
--- 	- **RGBA:** *`"#2266BBAA"` (where `"#"` is optional)*
---@return HexToColor_return_rgb r ***Default:*** `1`
---@return HexToColor_return_rgb g ***Default:*** `1`
---@return HexToColor_return_rgb b ***Default:*** `1`
---@return normalizedNumber? a
function wt.HexToColor(hex)

	--| Parameters

	---String in HEX color code format
	--- - ***Examples:***
	--- 	- **RGB:** *`"#2266BB"` (where `"#"` is optional)*
	--- 	- **RGBA:** *`"#2266BBAA"` (where `"#"` is optional)*
	---@alias HexToColor_param_hex string

	--| Returns

	---***Default:*** `1`
	---@alias HexToColor_return_rgb number

	return 1, 1, 1
end

---Brighten or darken the RGB values of a color by an exponent
---@param color AdjustGamma_param_color Table containing the color values
---@param exponent AdjustGamma_param_exponent ***Default:*** `0.55`
--- - ***Note:*** Values greater than 1 darken, smaller than 1 brighten the color.
---@return AdjustGamma_return_color color Reference to `color` (it was already updated during the operation, no need for setting it again)
function wt.AdjustGamma(color, exponent)

	--| Parameters

	---Table containing the color values
	---@alias AdjustGamma_param_color color

	---***Default:*** `0.55`
	--- - ***Note:*** Values greater than 1 darken, smaller than 1 brighten the color.
	---@alias AdjustGamma_param_exponent number?

	--| Returns

	---Reference to `color` (it was already updated during the operation, no need for setting it again)
	---@alias AdjustGamma_return_color any
end

---Turn a color data table into a Blizzard color manager object
---@param color CreateColor_param_color Table containing the color values
---@return colorRGB|colorRGBA
function wt.CreateColor(color)

	--| Parameters

	---Table containing the color values
	---@alias CreateColor_param_color colorData|rgbData

	return {}
end


--[[ FORMATTING ]]

--[ Escape Sequences ]

---Create a markup texture string snippet via escape sequences based on the specified values
---@param path Texture_param_path Path to the specific texture file relative to the root directory of the specific WoW client
--- - ***Note:*** Use of `/` as separator is recommended (***Example:*** `"Interface/AddOns/AddonNameKey/Textures/TextureImage.tga"`), otherwise use `\\`.
--- - ***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.
--- - ***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.
---@param width? Texture_param_width ***Default:*** *width of the texture file*
---@param height? Texture_param_height ***Default:*** `width`
---@param offsetX? Texture_param_offset ***Default:*** `0`
---@param offsetY? Texture_param_offset ***Default:*** `0`
---@param t Texture_param_t Additional optional parameters
---@return Texture_return ***Default:*** `""`
function wt.Texture(path, width, height, offsetX, offsetY, t)

	--| Parameters

	---Path to the specific texture file relative to the root directory of the specific WoW client
	--- - ***Note:*** Use of `/` as separator is recommended (***Example:*** `"Interface/AddOns/AddonNameKey/Textures/TextureImage.tga"`), otherwise use `\\`.
	--- - ***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.
	--- - ***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.
	---@alias Texture_param_path string

	---***Default:*** *width of the texture file*
	---@alias Texture_param_width number?

	---***Default:*** `width`
	---@alias Texture_param_height number?

	---***Default:*** `0`
	---@alias Texture_param_offset number?

	---Additional optional parameters
	---@alias Texture_param_t table?

	--| Returns

	---***Default:*** `""`
	---@alias Texture_return string

	return ""
end

---Remove most visual formatting (like coloring) & other (like hyperlink) [escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences) from a string
--- - ***Note:*** *Grammar* escape sequences are not yet supported, and will not be removed.
---@param s string
---@return string s
function wt.Clear(s) return "" end

--[ Hyperlinks ]

---Format a clickable hyperlink text via escape sequences
---@param linkType Hyperlink_param_linkType [Type of the hyperlink](https://warcraft.wiki.gg/wiki/Hyperlinks#Types) determining how it's being handled and what payload it carries
---@param content Hyperlink_param_content A colon-separated chain of parameters determined by `linkType` (Example: "content1:content2:content3") | ***Default:*** `""`
---@param text Hyperlink_param_text Clickable text to be displayed as the hyperlink | ***Default:*** `"Link"`
---@return Hyperlink_return ***Default:*** `""`
function wt.Hyperlink(linkType, content, text)

	--| Parameters

	---[Type of the hyperlink](https://warcraft.wiki.gg/wiki/Hyperlinks#Types) determining how it's being handled and what payload it carries
	---@alias Hyperlink_param_linkType HyperlinkType|"addon"|"mawpower"

	---A colon-separated chain of parameters determined by `linkType` (Example: "content1:content2:content3") | ***Default:*** `""`
	---@alias Hyperlink_param_content string?

	---Clickable text to be displayed as the hyperlink | ***Default:*** `"Link"`
	---@alias Hyperlink_param_text string?

	--| Returns

	---***Default:*** `""`
	---@alias Hyperlink_return string

	return ""
end

---Format a custom clickable addon hyperlink text via escape sequences
---@param addon CustomHyperlink_param_addon The name of the addon's folder (the addon namespace, not its displayed title)
---@param linkType CustomHyperlink_param_linkType A unique key signifying the type of the hyperlink specific to the addon (if the addon handles multiple different custom types of hyperlinks) in order to be able to set unique hyperlink click handlers via <code><i>WidgetToolbox</i>.SetHyperlinkHandler(...)</code> | ***Default:*** `"-"`
---@param content CustomHyperlink_param_content A colon-separated chain of data strings carried by the hyperlink to be provided to the handler function (Example: "content1:content2:content3") | ***Default:*** `""`
---@param text Hyperlink_param_text Clickable text to be displayed as the hyperlink | ***Default:*** `"Link"`
---@return Hyperlink_return ***Default:*** `""`
function wt.CustomHyperlink(addon, linkType, content, text)

	--| Parameters

	---The name of the addon's folder (the addon namespace, not its displayed title)
	---@alias CustomHyperlink_param_addon string

	---A unique key signifying the type of the hyperlink specific to the addon (if the addon handles multiple different custom types of hyperlinks) in order to be able to set unique hyperlink click handlers via <code><i>WidgetToolbox</i>.SetHyperlinkHandler(...)</code> | ***Default:*** `"-"`
	---@alias CustomHyperlink_param_linkType string?

	---A colon-separated chain of data strings carried by the hyperlink to be provided to the handler function (Example: "content1:content2:content3") | ***Default:*** `""`
	---@alias CustomHyperlink_param_content string?

	return ""
end

---Register a function to handle custom hyperlink clicks
---@param addon SetHyperlinkHandler_param_addon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
--- - ***Note:*** Duplicate addon key that already had rules registered under will be overwritten.
---@param linkType SetHyperlinkHandler_param_linkType Unique custom hyperlink type key used to identify the specific handler function | ***Default:*** `"-"`
---@param handler SetHyperlinkHandler_param_handler Function to be called with the list of content data strings carried by the hyperlink returned one by one when clicking on a hyperlink text created via <code><i>WidgetToolbox</i>.CustomHyperlink(...)</code>
function wt.SetHyperlinkHandler(addon, linkType, handler)

	--| Parameters

	---The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
	--- - ***Note:*** Duplicate addon key that already had rules registered under will be overwritten.
	---@alias SetHyperlinkHandler_param_addon string

	---Unique custom hyperlink type key used to identify the specific handler function | ***Default:*** `"-"`
	---@alias SetHyperlinkHandler_param_linkType string?

	---Function to be called with the list of content data strings carried by the hyperlink returned one by one when clicking on a hyperlink text created via <code><i>WidgetToolbox</i>.CustomHyperlink(...)</code>
	---@alias SetHyperlinkHandler_param_handler fun(...)
end


--[[ FRAME MANAGEMENT ]]

--[ Constructors ]

--| Base frame

---Create & set up a new basic frame
---@param t? frame_options Optional parameters
---@return Frame frame
function wt.CreateFrame(t)

	--| Parameters

	---Optional parameters
	---@class frame_options : positionableScreenFrame, arrangeableFrame, visibleFrame, initializableContainerFrame, eventFrame
	---@field parentFrame? AnyFrameObject Reference to the frame to set as the parent of the new frame | ***Default:*** `nil` *(parentless frame)*<ul><li>***Note:*** You may use [`Region:SetParent(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegion_SetParent) to set the parent frame later.</li></ul>
	---@field name? frameName ***Default:*** `nil` *(anonymous frame)*
	---@field append? boolean When setting the name, append `t.name` to the name of `t.parent` instead | ***Default:*** `true` if `t.name` ~= nil and `t.parent` ~= nil and `t.parent` ~= `UIParent`
	---@field width? number ***Default:*** `0`<ul><li>***Note:*** Omitting or setting to `0` will result in the frame being invisible and not getting placed on the screen.</li></ul>
	---@field height? number ***Default:*** `0`<ul><li>***Note:*** Omitting or setting to 0 will result in the frame being invisible and not getting placed on the screen.</li></ul>

		---@class positionableScreenFrame : positionableFrame
		---@field keepInBounds? boolean Whether to keep the frame within screen bounds whenever it's moved | ***Default:*** `false`

			---@class positionableFrame
			---@field position? positionData Table of parameters to call [`Region:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** `"TOPLEFT"`

		---@class arrangeableFrame
		---@field arrange? arrangementDirective When set, automatically position the frame in a columns within rows arrangement in its parent container via <code><i>WidgetToolbox</i>.ArrangeContent(t.parent, ...)</code>

			---@class arrangementDirective
			---@field wrap? boolean Place the frame into a new row within its container instead of adding it to the current row being filled | ***Default:*** `true`<ul><li>***Note:*** If the item would not fit in the row with other items in there, it will automatically be placed in a new row.</li></ul>
			---@field index? integer The ordering index of the frame by which to be placed during arrangement | ***Default:*** *use the ordering of the children of the parent container frame*

		---@class visibleFrame
		---@field visible? boolean Whether to make the frame visible during initialization or not | ***Default:*** `true`
		---@field frameStrata? FrameStrata Pin the frame to the specified strata
		---@field frameLevel? integer The ordering level of the frame within its strata to set
		---@field keepOnTop? boolean Whether to raise the frame level on mouse interaction | ***Default:*** `false`

		---@class initializableContainerFrame
		---@field arrangement? arrangementRules If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table
		---@field initialize? fun(canvas?: Frame, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<p>@*param* `container`? AnyFrameObject ― Reference to the frame to be set as the parent for child objects created during initialization (`nil` if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `width` number The current width of the container frame (0 if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `height` number The current height of the container frame (0 if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

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

		---@class eventFrame
		---@field events? scriptHandlers_Frame
		---@field onEvent? globalEventList
		---@field attributes? attributeList

		---Unique string used to set the frame name
		--- - ***Note:*** Space characters will be removed from the final frame name.
		---@alias frameName string

	return {}
end

---Create & set up a new customizable frame with BackdropTemplate
---@param t? frame_options Optional parameters
---@return Frame|BackdropTemplate frame
function wt.CreateCustomFrame(t) return {} end

--| Scrollframe

---Create an empty vertically scrollable frame
---@param t? scrollframe_options Optional parameters
---@return Frame scrollChild
---@return ScrollFrame scrollframe
function wt.CreateScrollframe(t)

	--| Parameters

	---Optional parameters
	---@class scrollframe_options : childFrame, positionableFrame, initializableContainerFrame, scrollSpeedData, eventFrame
	---@field name? string Appended to the name of `t.parent` when setting the names of the name of the scroll parent and its scrollable child frame | ***Default:*** `"Scroller"` *(for the scrollable child frame)*<ul><li>***Note:*** Space characters will be removed from the frame names.</li></ul>
	---@field width? number ***Default:*** `t.parentFrame` and *width of the parent frame* or `0`
	---@field height? number ***Default:*** `t.parentFrame` and *height of the parent frame* or `0`
	---@field scrollWidth? number Horizontal size of the scrollable child frame | ***Default:*** `t.width - 16`
	---@field scrollHeight? number Vertical size of the scrollable child frame | ***Default:*** `0`
	---@field events? scriptHandlers_ScrollFrame

		---@class scrollSpeedData
		---@field scrollSpeed? normalizedNumber Percentage of one page of content to scroll at a time | ***Default:*** `0.25`

	return {}, {}
end

--[ Position ]

---Set the position and anchoring of a frame (when it is unknown which parameters will be `nil`)
---@param frame SetPosition_param_frame Reference to the frame to be moved
---@param position SetPosition_param_position Table of parameters to call [`frame:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** `"TOPLEFT"`
---@param unlink SetPosition_param_unlink If `true`, unlink the position of `frame` from `position.relativeTo` (preventing anchor family connections) by moving a positioning aid frame to `position` first, convert its position to absolute, breaking relative links (making it relative to screen points instead), then move `frame` to the position of the aid | ***Default:*** `false`
---@param userPlaced SetPosition_param_userPlaced Remember the position if [`frame:IsMovable()`](https://warcraft.wiki.gg/wiki/API_Frame_IsMovable) | ***Default:*** `true`
function wt.SetPosition(frame, position, unlink, userPlaced)

	--| Parameters

	---Reference to the frame to be moved
	---@alias SetPosition_param_frame AnyFrameObject

	---Table of parameters to call [`frame:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** `"TOPLEFT"`
	---@alias SetPosition_param_position positionData?

	---If `true`, unlink the position of `frame` from `position.relativeTo` (preventing anchor family connections) by moving a positioning aid frame to `position` first, convert its position to absolute, breaking relative links (making it relative to screen points instead), then move `frame` to the position of the aid | ***Default:*** `false`
	---@alias SetPosition_param_unlink boolean?

	---Remember the position if [`frame:IsMovable()`](https://warcraft.wiki.gg/wiki/API_Frame_IsMovable) | ***Default:*** `true`
	---@alias SetPosition_param_userPlaced boolean?
end

---Set the anchor of a frame while keeping its positioning by updating its relative offsets
---@param frame SetAnchor_param_frame Reference to the frame to be update
---@param anchor SetAnchor_param_anchor New anchor point to set
---@return SetAnchor_return_offsetX offsetX The new horizontal offset value | ***Default:*** `nil`
---@return SetAnchor_return_offsetY offsetY The new vertical offset value | ***Default:*** `nil`
function wt.SetAnchor(frame, anchor)

	--| Parameters

	---Reference to the frame to be update
	---@alias SetAnchor_param_frame AnyFrameObject

	---New anchor point to set
	---@alias SetAnchor_param_anchor FramePoint

	--| Returns

	---The new horizontal offset value | ***Default:*** `nil`
	---@alias SetAnchor_return_offsetX number?

	---The new vertical offset value | ***Default:*** `nil`
	---@alias SetAnchor_return_offsetY number?
end

---Convert the position of a frame positioned relative to another to absolute position (making it relative to screen points, the `UIParent` instead)
---@param frame ConvertToAbsolutePosition_param_frame Reference to the frame the position of which to be converted to absolute position
---@param keepAnchor ConvertToAbsolutePosition_param_keepAnchor If `true`, restore the original anchor of `frame` (as its closest anchor to the nearest screen point will be chosen after conversion) | ***Default:*** `true`
function wt.ConvertToAbsolutePosition(frame, keepAnchor)

	--| Parameters

	---Reference to the frame the position of which to be converted to absolute position
	---@alias ConvertToAbsolutePosition_param_frame AnyFrameObject

	---If `true`, restore the original anchor of `frame` (as its closest anchor to the nearest screen point will be chosen after conversion) | ***Default:*** `true`
	---@alias ConvertToAbsolutePosition_param_keepAnchor boolean?
end

--| Arrangement

---Set the arrangement ordering description of a child frame by which to automatically position it in a columns within rows arrangement in its parent container via <code><i>WidgetToolbox</i>.ArrangeContent(...)</code>
---@param frame SetArrangementDirective_param_frame Reference to the child frame to set the arrangement ordering description for
---@param index SetArrangementDirective_param_index If set, use this ordering index for `frame` by which to schedule placing it during arrangement (instead of relying on its child index), or if `nil`, delete the ordering directive set for `frame`
---@param wrap SetArrangementDirective_param_wrap If `true`, place `frame` into a new row within its container instead of adding it to the current row being filled, or if `nil`, delete the wrapping directive set for `frame`
--- - ***Note:*** If the item would not fit in the row with other items in there, it will automatically be placed in a new row.
---@param skip SetArrangementDirective_param_skip If `true`, ignore all other directives and don't include `frame` in the arrangement when positioning the children of the parent frame, or if `nil`, delete the skipping directive set for `frame`
function wt.SetArrangementDirective(frame, index, wrap, skip)

	--| Parameters

	---Reference to the child frame to set the arrangement ordering description for
	---@alias SetArrangementDirective_param_frame AnyFrameObject

	---If set, use this ordering index for `frame` by which to schedule placing it during arrangement (instead of relying on its child index), or if `nil`, delete the ordering directive set for `frame`
	---@alias SetArrangementDirective_param_index integer|nil

	---If `true`, place `frame` into a new row within its container instead of adding it to the current row being filled, or if `nil`, delete the wrapping directive set for `frame`
	--- - ***Note:*** If the item would not fit in the row with other items in there, it will automatically be placed in a new row.
	---@alias SetArrangementDirective_param_wrap boolean|nil

	---If `true`, ignore all other directives and don't include `frame` in the arrangement when positioning the children of the parent frame, or if `nil`, delete the skipping directive set for `frame`
	---@alias SetArrangementDirective_param_skip boolean|nil
end

---Arrange the child frames of a container frame into stacked rows based on the parameters provided
--- - ***Note:*** The frames will be arranged into columns based on the the number of child frames assigned to a given row, anchored to "TOPLEFT", "TOP" and "TOPRIGHT" in order (by default) up to 3 frames. Columns in rows with more frames will be attempted to be spaced out evenly between the frames placed at the main 3 anchors.
---@param container ArrangeContent_param_container Reference to the parent container frame the child frames of which are to be arranged based on their arrangement descriptions
---@param t ArrangeContent_param_t Arrange the child frames of `container` based on the specifications provided in this table
function wt.ArrangeContent(container, t)

	--| Parameters

	---Reference to the parent container frame the child frames of which are to be arranged based on their arrangement descriptions
	---@alias ArrangeContent_param_container Frame

	---Arrange the child frames of `container` based on the specifications provided in this table
	---@alias ArrangeContent_param_t arrangementRules?
end

--| Movability

---Set the movability of a frame based in the specified values
---@param frame SetMovability_param_frame Reference to the frame to make movable/unmovable
---@param movable? SetMovability_param_movable Whether to make the frame movable or unmovable | ***Default:*** `false`
---@param t? SetMovability_param_t When specified, set `frame` as movable, dynamically updating the position settings widgets when it's moved by the user
function wt.SetMovability(frame, movable, t)

	--| Parameters

	---Reference to the frame to make movable/unmovable
	---@alias SetMovability_param_frame AnyFrameObject

	---Whether to make the frame movable or unmovable | ***Default:*** `false`
	---@alias SetMovability_param_movable boolean?

	---When specified, set `frame` as movable, dynamically updating the position settings widgets when it's moved by the user
	---@alias SetMovability_param_t movabilityData?

		---@class movabilityData
		---@field modifier? ModifierKey|any The specific (or any) modifier key required to be pressed down to move `t.frame` (if `t.frame` has the "OnUpdate" script defined) | ***Default:*** `nil` *(no modifier)*<ul><li>***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://warcraft.wiki.gg/wiki/API_IsModifierKeyDown) is used.</li></ul>
		---@field triggers? Frame[] List of frames that should handle inputs to initiate or stop the movement when interacted with | ***Default:*** `t.frame`
		---@field events? movementEvents Table containing functions to call when certain movement events occur
		---@field cursor? boolean If `true`, change the cursor to a movement cross when mousing over `t.frame` and `t.modifier` is pressed down if set | ***Default:*** `t.modifier ~= nil`

			---@class movementEvents
			---@field onStart? function Function to call when `frame` starts moving
			---@field onMove? function Function to call every with frame update while `frame` is moving (if `frame` has the "OnUpdate" script defined)
			---@field onStop? function Function to call when the movement of `frame` is stopped and the it was moved successfully
			---@field onCancel? function Function to call when the movement of `frame` is cancelled (because the modifier key was released early as an example)
end

--[ Visibility ]

---Set the visibility of a frame based on the value provided
---@param frame SetVisibility_param_frame Reference to the frame to hide or show
---@param visible SetVisibility_param_visible If `false`, hide the frame, show it if `true` | ***Default:*** `false`
function wt.SetVisibility(frame, visible)

	--| Parameters

	---Reference to the frame to hide or show
	---@alias SetVisibility_param_frame AnyFrameObject

	---If `false`, hide the frame, show it if `true` | ***Default:*** `false`
	---@alias SetVisibility_param_visible boolean?
end

--[ Backdrop ]

---Set the backdrop of a frame with BackdropTemplate with the specified parameters safely
---@param frame SetBackdrop_param_frame Reference to the frame to set the backdrop of
--- - ***Note:*** The template of `frame` must have been set as: `BackdropTemplateMixin and "BackdropTemplate"`.
---@param backdrop SetBackdrop_param_backdrop Parameters to set the custom backdrop with | ***Default:*** `nil` *(remove the backdrop)*
---@param updates SetBackdrop_param_updates Table of backdrop update rules, modifying the specified parameters on trigger
--- - ***Note:*** All update rules are additive, calling <code><i>WidgetToolbox</i>.SetBackdrop(...)</code> multiple times with `updates` specified *will not* override previously set update rules. The base `backdrop` values used for these old rules *will not* change by setting a new backdrop via <code><i>WidgetToolbox</i>.SetBackdrop(...)</code> either!
function wt.SetBackdrop(frame, backdrop, updates)

	--| Parameters

	---Reference to the frame to set the backdrop of
	--- - ***Note:*** The template of `frame` must have been set as: `BackdropTemplateMixin and "BackdropTemplate"`.
	---@alias SetBackdrop_param_frame backdropFrame|BackdropTemplate|AnyFrameObject

		---@class backdropFrame
		---@field backdropInfo backdropInfo

	---Parameters to set the custom backdrop with | ***Default:*** `nil` *(remove the backdrop)*
	---@alias SetBackdrop_param_backdrop backdropData?

		---@class backdropData # backdrop
		---@field background? backdropBackgroundData Table containing the parameters used for the background
		---@field border? backdropBorderData Table containing the parameters used for the border

			---@class backdropBackgroundData
			---@field texture? backdropBackgroundTextureData Parameters used for setting the background texture
			---@field color? color Apply the specified color to the background texture

			---@class backdropBorderData
			---@field texture? backdropBorderTextureData Parameters used for setting the border texture
			---@field color? color Apply the specified color to the border texture

	---Table of backdrop update rules, modifying the specified parameters on trigger
	--- - ***Note:*** All update rules are additive, calling <code><i>WidgetToolbox</i>.SetBackdrop(...)</code> multiple times with `updates` specified *will not* override previously set update rules. The base `backdrop` values used for these old rules *will not* change by setting a new backdrop via <code><i>WidgetToolbox</i>.SetBackdrop(...)</code> either!
	---@alias SetBackdrop_param_updates backdropUpdateRule[]?

		---@class backdropUpdateRule # updates
		---@field triggers? AnyFrameObject[] References to the frames to add the listener script to | ***Default:*** `{ frame }`
		---@field rules table<AnyScriptType, string|fun(frame: AnyFrameObject, self: AnyFrameObject, ...: any): backdropUpdate: backdropUpdateData|nil, fill: boolean|nil> List of events and update actions returning backdrop values to update the backdrop with, or, if they are set but not valid functions to call, restore the base `backdrop` unconditionally on event trigger<ul><li>***Note:*** Return an empty table `{}` for `backdropUpdate` and `true` for `fill` in order to restore the base `backdrop` after evaluation.</li><li>***Note:*** Return an empty table `{}` for `backdropUpdate` and `false` or `nil` for `fill` to do nothing (keep the current backdrop).</li></ul><p>@*param* `frame` AnyFrameObject ― Reference to backdrop frame</p><p>@*param* `self` AnyFrameObject ― Reference to the specific trigger frame</p><p>@*param* `...` any ― Any leftover arguments will be passed from the handler script to <code>updates[<i>key</i>].rule</code></p><p>@*return* `backdropUpdate`? backdropUpdateData|nil ― Parameters to update the backdrop with | ***Default:*** `nil` *(remove the backdrop)*</p><p>@*return* `fill`? boolean|nil ― If `true`, fill the specified defaults for the unset values in `backdropUpdate` with the values provided in `backdrop` at matching keys, if `false`, fill them with their corresponding values from the currently set values of [`frame.backdropInfo`](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure), [`frame:GetBackdropColor()`](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods) and [`frame:GetBackdropBorderColor()`](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods) | ***Default:*** `false`</p>

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
			---@field background? backdropUpdateBackgroundData Table containing the parameters used for the background | ***Default:*** `backdrop.background` if `fill == true` *(if it's `false`, keep the currently set values of [`frame.backdropInfo`](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure) and [`frame:GetBackdropColor()`](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*
			---@field border? backdropUpdateBorderData Table containing the parameters used for the border | ***Default:*** `backdrop` if `fill == true` *(if it's `false`, keep the currently set values of [`frame.backdropInfo`](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure) and [`frame:GetBackdropBorderColor()`](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

				---@class backdropUpdateBackgroundData
				---@field texture? backdropBackgroundTextureData Parameters used for setting the background texture | ***Default:*** `backdrop.background.texture` if `fill == true` *(if it's `false`, keep the currently set values of [`frame.backdropInfo`](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure))*
				---@field color? color Apply the specified color to the background texture | ***Default:*** `backdrop.background.color` if `fill == true` *(if it's `false`, keep the currently set values of [`frame:GetBackdropColor()`](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

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
				---@field texture? backdropBorderTextureData Parameters used for setting the border texture | ***Default:*** `backdrop.border.texture` if `fill == true` *(if it's `false`, keep the currently set values of [`frame.backdropInfo`](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure))*
				---@field color? color Apply the specified color to the border texture | ***Default:*** `backdrop.border.color` if `fill == true` *(if it's `false`, keep the currently set values of [`frame:GetBackdropBorderColor()`](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

					---@class backdropBorderTextureData
					---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** `"Interface/Tooltips/UI-Tooltip-Border"`<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
					---@field width number Width of the backdrop edge
end

--[ Dependencies ]

---Assign dependency rule listeners from a defined a ruleset
---@param rules AddDependencies_param_rules Indexed table containing the dependency rules to add
---@param setState AddDependencies_param_setState Function to call to set the state of the frame, enabling it on a `true`, or disabling it on a `false` input
function wt.AddDependencies(rules, setState)

	--| Parameters

	---Indexed table containing the dependency rules to add
	---@alias AddDependencies_param_rules dependencyRule[]

	---Function to call to set the state of the frame, enabling it on a `true`, or disabling it on a `false` input
	---@alias AddDependencies_param_setState fun(state: boolean)
end

---Check and evaluate all dependencies in a ruleset
---@param rules CheckDependencies_param_rules Indexed table containing the dependency rules to check
---@return boolean? state
function wt.CheckDependencies(rules)

	--| Parameters

	---Indexed table containing the dependency rules to check
	---@alias CheckDependencies_param_rules dependencyRule[]
end


--[[ TEXT ]]

--[ Font ]

---Create a new [Font](https://warcraft.wiki.gg/wiki/UIOBJECT_Font) object to be used when setting the look of a [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) using a [FontInstance](https://warcraft.wiki.gg/wiki/UIOBJECT_FontInstance)
---@param name CreateFont_param_name A unique identifier name to set for the hew font object to be accessed by and referred to later
--- - ***Note:*** If a font object with that name already exists, it will **not** be overwritten and its reference key will be returned.
--- - ***Example:*** Access the reference to the font object created via the globals table: `local customFont = _G["CustomFontName"]`.
---@param t? font_options Optional parameters
---@return CreateFont_return_name name Name of the Font object | ***Default*** `"GameFontNormal"`
---@return CreateFont_return_font font Font object reference | ***Default*** `GameFontNormal`
function wt.CreateFont(name, t)

	--| Parameters

	---A unique identifier name to set for the hew font object to be accessed by and referred to later
	--- - ***Note:*** If a font object with that name already exists, it will **not** be overwritten and its reference key will be returned.
	--- - ***Example:*** Access the reference to the font object created via the globals table: `local customFont = _G["CustomFontName"]`.
	---@alias CreateFont_param_name string

	---Optional parameters
	---@class font_options
	---@field template? FontObject An existing [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to copy as a baseline
	---@field font? fontData Table containing font properties used for [`FontInstance:SetFont(...)`](https://warcraft.wiki.gg/wiki/API_FontInstance_SetFont) (overriding `t.template`)
	---@field color? colorData_whiteDefault|color Apply the specified color to the font (overriding `t.template`)
	---@field spacing? number Set the character spacing of the text using this font (overriding `t.template`)
	---@field shadow? { offset: offsetData, color: colorData_blackDefault|color } Set a text shadow with the following parameters (overriding `t.template`)
	---@field justify? justifyData_centered Set the justification of the text using font (overriding `t.template`)
	---@field wrap? boolean Whether or not to allow the text lines using this font to wrap (overriding `t.template`)

		---@class colorData_whiteDefault : colorData
		---@field r? normalizedNumber Red | ***Default:*** `1`
		---@field g? normalizedNumber Green | ***Default:*** `1`
		---@field b? normalizedNumber Blue | ***Default:*** `1`

		---@class colorData_blackDefault : colorData
		---@field r? normalizedNumber Red | ***Default:*** `0`
		---@field g? normalizedNumber Green | ***Default:*** `0`
		---@field b? normalizedNumber Blue | ***Default:*** `0`

		---@class justifyData_centered : justifyData_left
		---@field h? JustifyHorizontal Horizontal text alignment| ***Default:*** `"CENTER"`

	--| Returns

	---Name of the Font object | ***Default*** `"GameFontNormal"`
	---@alias CreateFont_return_name string

	---Font object reference | ***Default*** `GameFontNormal`
	---@alias CreateFont_return_font Font

	return "", {}
end

--[ Textline ]

---Create a rendered text object ([FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString)) with the specified parameters
---@param t? text_options Optional parameters
---@return FontString text
function wt.CreateText(t)

	--| Parameters

	---Optional parameters
	---@class text_options : positionableFrame
	---@field parentFrame? AnyFrameObject Reference to parent frame to create and assign the text to | ***Default:*** `UIParent`
	---@field name? string Appended to the name of `t.parent` used to set the name of the new [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** `"Text"`
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
---@param frame CreateTitle_param_frame Reference to the frame to add the title textline to
---@param t? title_options Optional parameters
---@return CreateTitle_return Reference to the title textline | ***Default:*** `nil`
function wt.CreateTitle(frame, t)

	--| Parameters

	---Reference to the frame to add the title textline to
	---@alias CreateTitle_param_frame AnyFrameObject

	---Optional parameters
	---@class title_options
	---@field anchor? FramePoint ***Default:*** `"TOPLEFT"`
	---@field offset? offsetData The offset from the anchor point relative to the specified frame
	---@field width? number ***Default:*** *width of the text*
	---@field text? string Text to be shown as the main title of the frame
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** `"GameFontHighlight"`
	---@field color? color Apply the specified color to the title (overriding `t.font`)
	---@field justify? JustifyHorizontal Set the horizontal text alignment (overriding `t.font`) | ***Default:*** `"LEFT"`

	--| Returns

	---Reference to the title textline | ***Default:*** `nil`
	---@alias CreateTitle_return FontString?
end

---Add a description to a titled frame
---@param title CreateDescription_param_title Reference to the already existing title textline to place the description next to
---@param t? description_options Optional parameters
---@return CreateDescription_return Reference to the description textline | ***Default:*** `nil`
function wt.CreateDescription(title, t)

	--| Parameters

	---Reference to the already existing title textline to place the description next to
	---@alias CreateDescription_param_title FontString

	---Optional parameters
	---@class description_options
	---@field offset? offsetData The offset from the default position (right side of the separator to the right of `t.title`)
	---@field width? number ***Default:*** *width of the parent frame of `t.title` - width of `t.title` (& separator, offsets)*
	---@field widthOffset? number Increase the calculated with by this amount | ***Default:*** `0`
	---@field spacer? number Space to leave between `t.title` & the separator and the separator & the description | ***Default:*** 5
	---@field text? string Text to be shown as the description of the frame
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** `"GameFontHighlightSmall2"`
	---@field color? descriptionColorData|color Apply the specified color to the description (overriding `t.font`)
	---@field justify? JustifyHorizontal Set the horizontal text alignment (overriding `t.font`) | ***Default:*** `"LEFT"`

		---@class descriptionColorData
		---@field r? normalizedNumber Red | ***Default:*** `HIGHLIGHT_FONT_COLOR.r`
		---@field g? normalizedNumber Green | ***Default:*** `HIGHLIGHT_FONT_COLOR.g`
		---@field b? normalizedNumber Blue | ***Default:*** `HIGHLIGHT_FONT_COLOR.b`
		---@field a? normalizedNumber Opacity | ***Default:*** `0.55`

	--| Returns

	---Reference to the description textline | ***Default:*** `nil`
	---@alias CreateDescription_return FontString?
end


--[[ TEXTURE ]]

---Create a [Texture](https://warcraft.wiki.gg/wiki/UIOBJECT_Texture) image [TextureBase](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) object
---@param frame CreateTexture_param_frame Reference to the frame to set as the parent of the new texture
---@param t texture_options Optional parameters
---@param updates CreateTexture_param_updates Table of key, value pairs containing the list of events to link texture changes to, and what parameters to change
---@return CreateTexture_return_texture texture ***Default:*** `nil`
function wt.CreateTexture(frame, t, updates)

	--| Parameters

	---Reference to the frame to set as the parent of the new texture
	---@alias CreateTexture_param_frame AnyFrameObject

	---Optional parameters
	---@class texture_options : positionableFrame, pathData_ChatFrameDefault
	---@field name? string Appended to the name of `t.parent` used to set the name of the new texture | ***Default:*** `"Texture"`<ul><li>***Note:*** Space characters will be removed form frame name.</li></ul>
	---@field width? number ***Default:*** *width of parent*
	---@field height? number ***Default:*** *height of parent*
	---@field atlas? string Name of the texture atlas to use instead of creating a texture based on `t.path`<ul><li>***Note:*** Settings this will override whatever `t.path` is set to.</li></ul>
	---@field layer? DrawLayer
	---@field level? drawLevel Sublevel to set within the specified draw layer
	---@field tile? tileData Set the tiling behaviour of the texture | ***Default:*** *no tiling*
	---@field wrap? wrapData Set the warp mode for each axis
	---@field filterMode? FilterMode | ***Default:*** `"LINEAR"`
	---@field flip? axisData Mirror the texture on the horizontal and/or vertical axis
	---@field color? color Apply the specified color to the texture
	---@field edges? edgeCoordinates Edge coordinate offsets
	---@field vertices? vertexCoordinates Vertex coordinate offsets<ul><li>***Note:*** Setting texture coordinate offsets is exclusive between edges and vertices. If set, `t.edges` will be used first ignoring `t.vertices`.</li></ul>
	---@field events? table<ScriptRegionScriptType, fun(self: Texture, ...: any)> Table of key, value pairs of [texture object script event tags](https://warcraft.wiki.gg/wiki/UIOBJECT_Texture#Script_Types) and the handler functions called on trigger

		---@class pathData_ChatFrameDefault
		---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** `"Interface/ChatFrame/ChatFrameBackground"`<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>

		---@class tileData
		---@field h? boolean Horizontal | ***Default:*** `false`
		---@field v? boolean Vertical | ***Default:*** `false`

		---@class wrapData
		---@field h? WrapMode|boolean Horizontal | ***Value:*** `true`: `"REPEAT"` |***Default:*** `"CLAMP"`
		---@field v? WrapMode|boolean Vertical | ***Value:*** `true`: `"REPEAT"` |***Default:*** `"CLAMP"`

		---@class axisData
		---@field h? boolean Horizontal x axis | ***Default:*** `false`
		---@field v? boolean Vertical y axis | ***Default:*** `false`

		---@class edgeCoordinates
		---@field l normalizedNumber Left | ***Default:*** `0`
		---@field r normalizedNumber Right | ***Default:*** `1`
		---@field t normalizedNumber Top | ***Value:*** *using canvas coordinates (inverted y axis)* | ***Default:*** `0`
		---@field b normalizedNumber Bottom | ***Value:*** *using canvas coordinates (inverted y axis)* | ***Default:*** `1`

		---@class vertexCoordinates
		---@field topLeft vertexCoordinates_topLeft
		---@field topRight vertexCoordinates_topRight
		---@field bottomLeft vertexCoordinates_bottomLeft
		---@field bottomRight vertexCoordinates_bottomRight

				---@class vertexCoordinates_topLeft
				---@field x normalizedNumber ***Default:*** `0`
				---@field y normalizedNumber ***Value:*** *using canvas coordinates (inverted y axis)* | ***Default:*** `0`

				---@class vertexCoordinates_topRight
				---@field x normalizedNumber ***Default:*** `1`
				---@field y normalizedNumber ***Value:*** *using canvas coordinates (inverted y axis)* | ***Default:*** `0`

				---@class vertexCoordinates_bottomLeft
				---@field x normalizedNumber ***Default:*** `0`
				---@field y normalizedNumber ***Value:*** *using canvas coordinates (inverted y axis)* | ***Default:*** `1`

				---@class vertexCoordinates_bottomRight
				---@field x normalizedNumber ***Default:*** `1`
				---@field y normalizedNumber ***Value:*** *using canvas coordinates (inverted y axis)* | ***Default:*** `1`

		---@alias ScriptRegionScriptType
		---| "OnShow"
		---| "OnHide"
		---| "OnEnter"
		---| "OnLeave"
		---| "OnMouseDown"
		---| "OnMouseUp"
		---| "OnMouseWheel"
		---| "OnLoad"

	---@class textureUpdateRule # updates
	---@field frame? AnyFrameObject Reference to the frame to add the listener script to | ***Default:*** `t.parent`
	---@field rule? fun(self: Frame, ...: any): data: textureUpdateData|nil Evaluate the event and specify the texture updates to set, or, if nil, restore the base values unconditionally on event trigger<p>@*param* `self` AnyFrameObject — Reference to <code>updates[<i>key</i>].frame</code></p><p>@*param* `...` any — Any leftover arguments will be passed from the handler script to <code>updates[<i>key</i>].rule</code></p><p>@*return* `data` textureUpdateData|nil — Parameters to update the texture with | ***Default:*** `t`<p>

		---@class textureUpdateData
		---@field position? positionData Table of parameters to call [`Region:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** `t.position`
		---@field width? number ***Default:*** `t.width`
		---@field height? number ***Default:*** `t.height`
		---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** `t.path`<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
		---@field layer? DrawLayer | ***Default:*** `t.layer`
		---@field level? drawLevel Sublevel to set within the specified draw layer | ***Default:*** `t.level`
		---@field tile? tileData Set the tiling behaviour of the texture | ***Default:*** `t.tile`
		---@field wrap? wrapData Set the warp mode for each axis | ***Default:*** `t.wrap`
		---@field filterMode? FilterMode | ***Default:*** `t.filterMode`
		---@field flip? axisData Mirror the texture on the horizontal and/or vertical axis | ***Default:*** `t.flip`
		---@field color? color Apply the specified color to the texture | ***Default:*** `t.color`
		---@field edges? edgeCoordinates Edge coordinate offsets ***Default:*** `t.edges`
		---@field vertices? vertexCoordinates Vertex coordinate offsets ***Default:*** `t.vertices`<ul><li>***Note:*** Setting texture coordinate offsets is exclusive between edges and vertices. If set, `t.edges` will be used first ignoring `t.vertices`.</li></ul>

	---Table of key, value pairs containing the list of events to link texture changes to, and what parameters to change
	---@alias CreateTexture_param_updates table<AnyScriptType, textureUpdateRule>?

	--| Returns

	---***Default:*** `nil`
	---@alias CreateTexture_return_texture Texture?
end

---Create a [Line](https://warcraft.wiki.gg/wiki/UIOBJECT_Line) [TextureBase](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) object
---@param frame CreateLine_param_frame Reference to the frame to set as the parent of the new line
---@param t line_options Optional parameters
---@return CreateLine_return_line line ***Default:*** `nil`
function wt.CreateLine(frame, t)

	--| Parameters

	---Reference to the frame to set as the parent of the new line
	---@alias CreateLine_param_frame AnyFrameObject

	---Optional parameters
	---@class line_options
	---@field name? string Appended to the name of `t.parent` used to set the name of the new line | ***Default:*** `"Line"`
	---@field startPosition? pointData Parameters to call [`Line:SetStartPoint(...)`](https://warcraft.wiki.gg/wiki/API_Line_SetStartPoint) with | ***Default:*** `"TOPLEFT"`
	---@field endPosition? pointData Parameters to call [`Line:SetEndPoint(...)`](https://warcraft.wiki.gg/wiki/API_Line_SetEndPoint) with | ***Default:*** `"TOPLEFT"`
	---@field thickness? number ***Default:*** 4
	---@field layer? DrawLayer
	---@field level? drawLevel Sublevel to set within the draw layer specified with `t.layer`
	---@field color? color Apply the specified color to the line

		---@class pointData
		---@field relativeTo AnyFrameObject
		---@field relativePoint FramePoint
		---@field offset? offsetData

	--| Returns

	---***Default:*** `nil`
	---@alias CreateLine_return_line Line?
end


--[[ TOOLTIP ]]

--[ Game Tooltip ]

---Create and set up a new custom GameTooltip frame
---@param name CreateTooltip_param_name Unique string piece to place in the name of the the tooltip to distinguish it from other tooltips (use the addon namespace string as an example)
---@return GameTooltip tooltip
function wt.CreateTooltip(name)

	--| Parameters

	---Unique string piece to place in the name of the the tooltip to distinguish it from other tooltips (use the addon namespace string as an example)
	---@alias CreateTooltip_param_name string

	return {}
end

--[ Management ]

---@alias AnyTooltipData
---| tooltipData
---| widgetTooltipTextData
---| itemTooltipTextData
---| addonCompartmentTooltipData

---Register tooltip data and set up a GameTooltip for a frame to be toggled on hover
---@param frame AddTooltip_param_frame Owner frame the tooltip to be registered for
--- - ***Note:*** If tooltip data for `owner` has already been added to the registry, it will be fully overwritten with `t`.
--- - ***Note:*** Duplicate triggers may still be added if `duplicate` is set to `true`.
---@param t? tooltipData Optional tooltip parameters
---@param toggle? tooltipToggleData Optional tooltip toggle parameters
---@param duplicate AddTooltip_param_duplicate If `true`, execute even if tooltip data has already been registered for `owner`, potentially adding duplicate toggle triggers, or, automatically call <code><i>WidgetToolbox</i>.UpdateTooltipData(...)</code> instead to avoid this | ***Default:*** `false`
---@return AddTooltip_return Reference to the tooltip data table registered for `owner` to display the tooltip info by | ***Default:*** `nil`
function wt.AddTooltip(frame, t, toggle, duplicate)

	--| Parameters

	---Owner frame the tooltip to be registered for
	--- - ***Note:*** If tooltip data for `owner` has already been added to the registry, it will be fully overwritten with `t`.
	--- - ***Note:*** Duplicate triggers may still be added if `duplicate` is set to `true`.
	---@alias AddTooltip_param_frame AnyFrameObject

	--| Parameters

	---Optional tooltip parameters
	---@class tooltipData : tooltipFrameData, tooltipTextData
	---@field anchor? TooltipAnchor ***Default:*** `"ANCHOR_CURSOR"`
	---@field offset? offsetData Values to offset the position of <code><i>tooltipData</i>.tooltip</code> by
	---@field position? positionData_base|positionData Table of parameters to call [`Region:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via `t.anchor` | ***Default:*** `"TOPLEFT"` if <code><i>tooltipData</i>.anchor</code> == "ANCHOR_NONE"<ul><li>***Note:*** `t.offset` will be used when calling [`Region:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) as well.</li></ul>
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

	---Optional tooltip toggle parameters
	---@class tooltipToggleData
	---@field triggers? Frame[] List of references to additional frames to add hover events to to toggle <code><i>tooltipData</i>.tooltip</code> for `owner` besides `owner` itself
	---@field checkParent? boolean Whether to check if `owner` is being hovered before hiding <code><i>tooltipData</i>.tooltip</code> when triggers stop being hovered | ***Default:*** `true`
	---@field replace? boolean If `false`, while <code><i>tooltipData</i>.tooltip</code> is already visible for a different owner, don't change it | ***Default:*** `true`<ul><li>***Note:*** If <code><i>tooltipData</i>.tooltip</code> is already shown for `owner`, <code><i>WidgetToolbox</i>.UpdateTooltip(...)</code> will be called anyway.</li></ul>

	---If `true`, execute even if tooltip data has already been registered for `owner`, potentially adding duplicate toggle triggers, or, automatically call <code><i>WidgetToolbox</i>.UpdateTooltipData(...)</code> instead to avoid this | ***Default:*** `false`
	---@alias AddTooltip_param_duplicate boolean?

	--| Returns

	---Reference to the tooltip data table registered for `owner` to display the tooltip info by | ***Default:*** `nil`
	---@alias AddTooltip_return tooltipData|nil
end

---Update and show a GameTooltip already set up to be toggled for a frame
---@param frame UpdateTooltip_param_frame Owner frame the tooltip to be updated for
--- - ***Note:*** If no entry has been registered for `owner` in the tooltip data registry via <code><i>WidgetToolbox</i>.AddTooltip(...)</code> yet, no tooltip will be shown.
---@param t UpdateTooltip_param_t Use this set of parameters to update the tooltip for `owner` with | ***Default:*** *(fill values from the data in the registry)*
function wt.UpdateTooltip(frame, t)

	--| Parameters

	---Owner frame the tooltip to be updated for
	--- - ***Note:*** If no entry has been registered for `owner` in the tooltip data registry via <code><i>WidgetToolbox</i>.AddTooltip(...)</code> yet, no tooltip will be shown.
	---@alias UpdateTooltip_param_frame AnyFrameObject

	---Use this set of parameters to update the tooltip for `owner` with | ***Default:*** *(fill values from the data in the registry)*
	---@alias UpdateTooltip_param_t tooltipUpdateData|tooltipData?

		---@class tooltipUpdateData
		---@field title? string String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR) | ***Default:*** `owner.tooltipData.title`
		---@field lines? tooltipLineData[] Table containing the lists of parameters for the text lines after the title | ***Default:*** `owner.tooltipData.lines`
		---@field tooltip? GameTooltip Reference to the tooltip frame to set up | ***Default:*** `owner.tooltipData.tooltip`
		---@field offset? offsetData Values to offset the position of <code><i>tooltipData</i>.tooltip</code> by | ***Default:*** `owner.tooltipData.offset`
		---@field position? positionData_base|positionData Table of parameters to call [`Region:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via `t.anchor` | ***Default:*** `owner.tooltipData.position`
		---@field flipColors? boolean Flip the default color values of the title and the text lines | ***Default:*** `owner.tooltipData.flipColors`
		---@field anchor? TooltipAnchor [GameTooltip anchor](https://warcraft.wiki.gg/wiki/API_GameTooltip_SetOwner) | ***Default:*** `owner.tooltipData.anchor`
end

---Verify and update the tooltip data values stored in the registry for a frame
---@param frame UpdateTooltipData_param_frame Owner frame the tooltip data to be updated for
--- - ***Note:*** If no entry has been registered for `owner` in the tooltip data registry via <code><i>WidgetToolbox</i>.AddTooltip(...)</code> yet, no data will be changed.
---@param t UpdateTooltipData_param_t The parameters to update the tooltip with are to be provided in this table | ***Default:*** *(fill values from the data in the registry or use default values for required values missing from the registry)*
---@param linesUpdate UpdateTooltipData_param_linesUpdate If `true`, replace the full set of lines in the registry with `t.lines`, or if explicitly `false`, append the lines to the current list of lines, or if `nil` or something else, adjust the values of existing lines at matching indexes instead without adding or removing lines | ***Default:*** `nil`
---@return UpdateTooltipData_return Reference to the tooltip data table registered for `owner` to display the tooltip info by | ***Default:*** `nil`
function wt.UpdateTooltipData(frame, t, linesUpdate)

	--| Parameters

	---Owner frame the tooltip data to be updated for
	--- - ***Note:*** If no entry has been registered for `owner` in the tooltip data registry via <code><i>WidgetToolbox</i>.AddTooltip(...)</code> yet, no data will be changed.
	---@alias UpdateTooltipData_param_frame AnyFrameObject

	---The parameters to update the tooltip with are to be provided in this table | ***Default:*** *(fill values from the data in the registry or use default values for required values missing from the registry)*
	---@alias UpdateTooltipData_param_t tooltipUpdateData|tooltipData?

	---If `true`, replace the full set of lines in the registry with `t.lines`, or if explicitly `false`, append the lines to the current list of lines, or if `nil` or something else, adjust the values of existing lines at matching indexes instead without adding or removing lines | ***Default:*** `nil`
	---@alias UpdateTooltipData_param_linesUpdate boolean|nil

	--| Returns

	---Reference to the tooltip data table registered for `owner` to display the tooltip info by | ***Default:*** `nil`
	---@alias UpdateTooltipData_return tooltipData|nil
end

---Add default value and utility menu hint tooltip lines to widget tooltip tables
---@param frames AddWidgetTooltipLines_param_frames List of reference to the frames to add the tooltip lines to<ul><li>***Note:*** If no entry has been registered for a frame in the list in the tooltip data registry via <code><i>WidgetToolbox</i>.AddTooltip(...)</code> yet, no changes will be made for that frame.</li></ul>
---@param default AddWidgetTooltipLines_param_default Default value, formatted | ***Default:*** *(don't show default value)*
---@param utilityNote AddWidgetTooltipLines_param_utilityNote If `true`, add a note for the utility context menu | ***Default:*** `true`
function wt.AddWidgetTooltipLines(frames, default, utilityNote)

	--| Parameters

	---List of reference to the frames to add the tooltip lines to<ul><li>***Note:*** If no entry has been registered for a frame in the list in the tooltip data registry via <code><i>WidgetToolbox</i>.AddTooltip(...)</code> yet, no changes will be made for that frame.</li></ul>
	---@alias AddWidgetTooltipLines_param_frames AnyFrameObject[]

	---Default value, formatted | ***Default:*** *(don't show default value)*
	---@alias AddWidgetTooltipLines_param_default string?

	---If `true`, add a note for the utility context menu | ***Default:*** `true`
	---@alias AddWidgetTooltipLines_param_utilityNote boolean?
end


--[[ POPUP ]]

--[ Dialog ]

---Register the data for a Blizzard popup dialog for use
---@param key RegisterPopupDialog_param_key Unique string to be used as the identifier key in the global `StaticPopupDialogs` table | ***Default:*** *table id of `t` or a random ID string*
--- - ***Note:*** the default value will be appended to `key` even if its set and a valid string if that key already exist in the global `StaticPopupDialogs` table.
---@param t? popupDialogData Optional parameters
---@return RegisterPopupDialog_return_key The unique identifier key the popup data was created under in the global `StaticPopupDialogs` table used as the parameter when calling [`StaticPopup_Show()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [`StaticPopup_Hide()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
function wt.RegisterPopupDialog(key, t)

	--| Parameters

	---Unique string to be used as the identifier key in the global `StaticPopupDialogs` table | ***Default:*** *table id of `t` or a random ID string*
	--- - ***Note:*** the default value will be appended to `key` even if its set and a valid string if that key already exist in the global `StaticPopupDialogs` table.
	---@alias RegisterPopupDialog_param_key string?

	---Optional parameters
	---@class popupDialogData
	---@field text? string The text to display as the message in the popup window
	---@field accept? string The text to display on the label of the accept button | ***Default:*** <code><i>WidgetToolbox</i>.strings.misc.accept</code>
	---@field cancel? string The text to display on the label of the cancel button | ***Default:*** <code><i>WidgetToolbox</i>.strings.misc.cancel</code>
	---@field alt? string The text to display on the label of the third alternative button
	---@field onAccept? function Called when the accept button is pressed and an OnAccept event happens
	---@field onCancel? function Called when the cancel button is pressed, the popup is overwritten (by another popup for instance) or the popup expires and an OnCancel event happens
	---@field onAlt? function Called when the alternative button is pressed and an OnAlt event happens

	---The unique identifier key the popup data was created under in the global `StaticPopupDialogs` table used as the parameter when calling [`StaticPopup_Show()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [`StaticPopup_Hide()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
	---@alias RegisterPopupDialog_return_key string

	return ""
end

---Update already existing Blizzard popup dialog data
---@param key UpdatePopupDialog_param_key The unique identifier key representing the defaults warning popup dialog in the global `StaticPopupDialogs` table, and used as the parameter when calling [`StaticPopup_Show()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [`StaticPopup_Hide()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
---@param t? popupDialogData Optional parameters
---@return UpdatePopupDialog_return_key key The unique identifier key created for this popup in the global `StaticPopupDialogs` table used as the parameter when calling [`StaticPopup_Show()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [`StaticPopup_Hide()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide) | ***Default:*** `nil`
function wt.UpdatePopupDialog(key, t)

	--| Parameters

	---The unique identifier key representing the defaults warning popup dialog in the global `StaticPopupDialogs` table, and used as the parameter when calling [`StaticPopup_Show()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [`StaticPopup_Hide()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
	---@alias UpdatePopupDialog_param_key string

	--| Returns

	---The unique identifier key created for this popup in the global `StaticPopupDialogs` table used as the parameter when calling [`StaticPopup_Show()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [`StaticPopup_Hide()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide) | ***Default:*** `nil`
	---@alias UpdatePopupDialog_return_key string?
end

--[ Reload Notice ]

---Show a movable reload notice window on screen with a reload now and cancel button
---@param t? reloadNoticeData Optional parameters
---@return CreateReloadNotice_return_reload reload Reference to the reload notice panel frame
function wt.CreateReloadNotice(t)

	--| Parameters

	---Optional parameters
	---@class reloadNoticeData
	---@field title? string Text to be shown as the title of the reload notice | ***Default:*** `"Pending Changes"` *(when the language is set to English)*
	---@field message? string Text to be shown as the message of the reload notice | ***Default:*** `"Reload the interface to apply the pending changes."` *(when the language is set to English)*
	---@field position? reloadFramePositionData Table of parameters to call [`Region:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** `"TOPRIGHT"`, `-300`, `-80`

		---@class reloadFramePositionData : positionData_base
		---@field anchor? FramePoint ***Default:*** `"TOPRIGHT"`
		---@field offset? reloadFrameOffsetData

			---@class reloadFrameOffsetData
			---@field x? number Horizontal offset value | ***Default:*** -300
			---@field y? number Vertical offset value | ***Default:*** -80

	--| Returns

	---Reference to the reload notice panel frame
	---@alias CreateReloadNotice_return_reload Frame

	return {}
end


--[[ ADDON COMPARTMENT ]]

---Set up the [Addon Compartment](https://warcraft.wiki.gg/wiki/Addon_compartment#Automatic_registration) functionality by registering global functions for call
---@param addon SetUpAddonCompartment_param_addon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
---@param calls SetUpAddonCompartment_param_calls Functions to call wrapped in a table
--- - ***Note:*** `AddonCompartmentFunc`, `AddonCompartmentFuncOnEnter` and/or `AddonCompartmentFuncOnLeave` must be set in the specified `addon`'s TOC file to enable this functionality, defining the names of the global functions to be set for call.
---@param tooltip SetUpAddonCompartment_param_tooltip List of textlines to be added to the tooltip of the addon compartment button displayed when mousing over it
--- - ***Note:*** Both `AddonCompartmentFuncOnEnter` and `AddonCompartmentFuncOnLeave` must be set in the specified `addon`'s TOC file to enable this functionality, defining the names of the global functions to be overloaded.
function wt.SetUpAddonCompartment(addon, calls, tooltip)

	--| Parameters

	---The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
	---@alias SetUpAddonCompartment_param_addon uiAddon

	---Functions to call wrapped in a table
	--- - ***Note:*** `AddonCompartmentFunc`, `AddonCompartmentFuncOnEnter` and/or `AddonCompartmentFuncOnLeave` must be set in the specified `addon`'s TOC file to enable this functionality, defining the names of the global functions to be set for call.
	---@alias SetUpAddonCompartment_param_calls addonCompartmentFunctions?

		---@class addonCompartmentFunctions
		---@field onClick? fun(addon: string, button: string, frame: Button) Called when the `addon`'s compartment button is clicked<ul><li>***Note:*** `AddonCompartmentFunc`, must be set in the specified `addon`'s TOC file, defining the name of the global function to be set for call.</li></ul>
		---@field onEnter? fun(addon: string, frame: Button|Frame) Called when the `addon`'s compartment button is being hovered before the tooltip (if set) is shown<ul><li>***Note:*** `AddonCompartmentFuncOnEnter`, must be set in the specified `addon`'s TOC file, defining the name of the global function to be set for call.</li></ul>
		---@field onLeave? fun(addon: string, frame: Button|Frame) Called when the `addon`'s compartment button is stopped being hovered before the tooltip (if set) is hidden<ul><li>***Note:*** `AddonCompartmentFuncOnLeave`, must be set in the specified `addon`'s TOC file, defining the name of the global function to be set for call.</li></ul>

	---List of textlines to be added to the tooltip of the addon compartment button displayed when mousing over it
	--- - ***Note:*** Both `AddonCompartmentFuncOnEnter` and `AddonCompartmentFuncOnLeave` must be set in the specified `addon`'s TOC file to enable this functionality, defining the names of the global functions to be overloaded.
	---@alias SetUpAddonCompartment_param_tooltip addonCompartmentTooltipData|tooltipData?

		---@class addonCompartmentTooltipData : tooltipFrameData, tooltipTextData
		---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** [`GetAddOnMetadata(addon, "title")`](https://warcraft.wiki.gg/wiki/API_C_AddOns.GetAddOnMetadata)
end


--[[ SETTINGS ]]

---Settings data management rule registry
---@class settingsRegistry
---@field rules table<string, settingsRule[]> Collection of rules describing where to save/load settings data to/from, and what change handlers to call in the process linked to each specific settings category under an addon
---@field changeHandlers table<string, function> List of pairs of addon-specific unique keys and change handler scripts

	---@class settingsRule
	---@field widget DataWidgetType Reference to the widget to be saved & loaded data to/from with defined `loadData` and `saveData` functions
	---@field onChange? string[] List of keys referencing functions to be called after the value of `widget` was changed by the user or via settings data management

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
--- - ***Note:*** No settings page will be registered if `WidgetToolsDB.lite` is `true`.
---@param page settingsPage Reference to the settings page to register to Settings
---@param parent? settingsPage Reference to the parent settings page to set `page` as a child category page of | ***Default:*** *set as a parent category page*
---@param icon? boolean If `true`, append the icon set for the settings page to its button title in the AddOns list of the Settings window as well | ***Default:*** `true` if `parent == nil`
function wt.RegisterSettingsPage(page, parent, icon) end

--[ Data Management ]

---Register a settings data management entry for a settings widget to the settings data management registry for batched data handling
---***
---@param widget DataWidgetType Reference to the widget to be saved & loaded data to/from with defined `widget.loadData()` & `widget.saveData()` functions
---@param t settingsData Optional parameters
---***
---@return integer|nil index The index for the new entry for `widget` where it ended up in the settings data management registry | ***Default:*** `nil`
function wt.AddSettingsDataManagementEntry(widget, t) end

---Load all data from storage to the widgets specified in the settings data management registry in the specified `category` under the specified `key` by calling `datamanager.loadData(...)` for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
---@param handleChanges? boolean If `true`, also call all registered change handlers | ***Default:*** `false`
function wt.LoadSettingsData(category, key, handleChanges) end

---Save all data from the widgets to storage specified in the settings data management registry in the specified `category` under the specified `key` by calling `datamanager.saveData(...)` for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.SaveSettingsData(category, key) end

---Call all `onChange` handlers registered in the settings data management registry in the specified `category` under the specified `key`
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.ApplySettingsData(category, key) end

---Set a data snapshot for each widget specified in the settings data management registry in the specified `category` under the specified `key` calling `datamanager.revertData()` for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.SnapshotSettingsData(category, key) end

---Set & load the stored data managed by each widget specified in the settings data management registry in the specified `category` under the specified `key` by calling `datamanager.revertData()` for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.RevertSettingsData(category, key) end

---Set & load the default data managed by each widget specified in the settings data management registry in the specified `category` under the specified `key` by calling `datamanager.resetData()` for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.ResetSettingsData(category, key) end

---Handle changes for widgets in the settings data management registry in the specified `category` under the specified `key` by calling registered `onChange` handlers for each
---@param index integer Filter the call of change handlers to only include the list under the specified index not each list in the specified `category` under the specified `key`
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** `"WidgetTools"` *(global rule)*
---@param key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
function wt.HandleWidgetChanges(index, category, key) end


--[[ CONTEXT MENU ]]

---Create a Blizzard context menu
---@param t? contextMenu_options Optional parameters
---***
---@return contextMenu menu Table containing a reference to the root description of the context menu
function wt.CreateContextMenu(t)

	--| Parameters

	---Optional parameters
	---@class contextMenu_options : contextMenu_options_base
	---@field triggers? contextMenuTriggerData[] List of trigger frames and behavior to link to toggle the context menu | ***Default:*** *(no triggers)*

		---@class contextMenu_options_base
		---@field load? fun(menu: contextMenu|contextSubmenu) This function will be called while setting up the menu to perform specific tasks like creating menu content items right away<p>@*param* `menu` contextMenu|contextSubmenu ― Reference to the container of menu elements (such as titles, widgets, dividers or other frames) for menu items to be added to during initialization</p>

		---@class contextMenuTriggerData
		---@field frame AnyFrameObject? Reference to the frame to set as a trigger | ***Default:*** `UIParent` *(opened at cursor position)*
		---@field rightClick? boolean If `true`, create and open the context menu via a right-click mouse click event on `frame` | ***Default:*** `true`
		---@field leftClick? boolean If `true`, create and open the context menu via a left-click mouse click event on `frame` | ***Default:*** `false`
		---@field hover? boolean If `true`, create and open the context menu via a mouse hover event on `frame` | ***Default:*** `false`
		---@field condition? fun(action: "click"|"hover"|nil): boolean Function to call and evaluate before creating and opening the menu: if the returned value is not `true`, don't open the menu

	--| Returns

	---@class contextMenu
	---@field rootDescription? RootMenuDescriptionProxy Container of menu elements (such as titles, widgets, dividers or other frames)
	local _ = {}

		---Open the context menu
		---@param triggerIndex? integer Index of the trigger to activate to have the menu opened defined in `t.triggers` | ***Default:*** `1`
		---@param action "click"|"hover"|nil The action that prompted the menu to be opened | ***Default:*** *no action:* `nil`
		function _:Open(triggerIndex, action) end

	return _
end

---Create a Blizzard context menu attached to a custom button frame to open it
---@param t? popupMenu_options Optional parameters
---***
---@return Frame|BackdropTemplate trigger Reference to the custom frame used as a menu opener trigger button
---@return contextMenu menu Table containing a reference to the root description of the context menu
function wt.CreatePopupMenu(t)

	--| Parameters

	---Optional parameters
	---@class popupMenu_options : labeledChildFrame, tooltipDescribableWidget, positionableScreenFrame, arrangeableFrame, visibleFrame, contextMenu_options_base, eventFrame
	---@field parentFrame? AnyFrameObject Reference to the frame to set as the parent of the new frame | ***Default:*** `nil` *(parentless frame)*<ul><li>***Note:*** You may use [`Region:SetParent(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegion_SetParent) to set the parent frame later.</li></ul>
	---@field name? frameName ***Default:*** `"PopupMenu"`
	---@field width? number ***Default:*** `180`
	---@field height? number ***Default:*** `26`

	return {}, {}
end

--[ Elements ]

---Create a submenu item for an already existing Blizzard context menu
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new submenu to
---@param t? contextSubmenu_options Optional parameters
---***
---@return contextSubmenu|nil menu Table containing a reference to the root description of the context menu
function wt.CreateSubmenu(menu, t)

	--| Parameters

	---@class contextSubmenu # menu
	---@field rootDescription ElementMenuDescriptionProxy Container of menu elements (such as titles, widgets, dividers or other frames)

	---Optional parameters
	---@class contextSubmenu_options : contextMenu_options_base
	---@field title? string Text to be shown on the opener button item representing the submenu within the parent menu | ***Default:*** `"Submenu"`
end

---Create a textline item for an already existing Blizzard context menu
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? menuTextline_options Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil textline Reference to the context textline UI object
function wt.CreateMenuTextline(menu, t)

	--| Parameters

	---Optional parameters
	---@class menuTextline_options : queuedMenuItem
	---@field text? string Text to be shown on the textline item within the parent menu | ***Default:*** `"Title"`

		---Optional parameters
		---@class queuedMenuItem
		---@field queue? boolean If `true`, the item will only appear when additional items are added to the menu | ***Default:*** `false`
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
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? menuButton_options Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil button Reference to the context button UI object
function wt.CreateMenuButton(menu, t)

	--| Parameters

	---Optional parameters
	---@class menuButton_options
	---@field title? string Text to be shown on the button item within the parent menu | ***Default:*** `"Button"`
	---@field action? fun(...: any) Function to call when the button is clicked in the menu<p>@*param* `...` any</p>
end