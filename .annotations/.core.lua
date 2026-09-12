--NOTE: Annotations are for development purposes only, providing live documentation via Lua Language Server. This file does not need to be loaded by the game client.

---@meta core


--[[ NAMESPACE ]]

---Addon namespace table
---@class namespace
local ns = select(2, ...)


--[[ RESOURCES ]]

---Shared resources
---@class widgetToolsResources
---@field addon string Addon namespace name: `"WidgetTools"`
---@field title string Addon display title: `"Widget Tools"`
---@field root string Addon root folder path
---@field chat table List of chat keywords and commands
---@field colors widgetToolsColors
---@field textures widgetToolsTextures
---@field fonts fontFileData[]
---@field strings widgetToolsStrings
---@field changelog string[][]

	---Localized strings
	--- - ***Note:*** `#FLAGS` will be replaced by text or number values via code; `\n` represents the newline character.
	---@alias widgetToolsStrings
	---| widgetToolsStrings_enUS
	---| widgetToolsStrings_ptBR
	---| widgetToolsStrings_deDE
	---| widgetToolsStrings_frFR
	---| widgetToolsStrings_esES
	---| widgetToolsStrings_esMX
	---| widgetToolsStrings_itIT
	---| widgetToolsStrings_koKR
	---| widgetToolsStrings_zhTW
	---| widgetToolsStrings_zhCN
	---| widgetToolsStrings_ruRU

	---@class widgetToolsColors
	---@field grey rgbData[]
	---@field gold rgbData[]
	---@field halfTransparent { grey: colorData, blue: colorData, yellow: colorData }

	---@class widgetToolsTextures
	---@field logo string
	---@field missing string

	---@class fontFileData
	---@field path string
	---@field name string


--[[ UTILITIES ]]

---Core utility collection
---@class widgetToolsUtilities
---@field isKeyDown table<ModifierKey|any, fun(): down: boolean> Access a Blizzard modifier key down checking function via a modifier key string
---@field applyColorMarkup changelogColorMarkups Apply a pre-specified changelog markup formatting to text
local utilities = {}

	---@alias ModifierKey
			---| "CTRL"
			---| "SHIFT"
			---| "ALT"
			---| "LCTRL"
			---| "RCTRL"
			---| "LSHIFT"
			---| "RSHIFT"
			---| "LALT"
			---| "RALT"

	---@class changelogColorMarkups
	---@field V fun(s: string): string Version title (white with a list dot)
	---@field H fun(s: string): string Highlight (white)
	---@field N fun(s: string): string New (green)
	---@field F fun(s: string): string Fix (red)
	---@field C fun(s: string): string Change (blue)
	---@field O fun(s: string): string Note (yellow)

--[ General ]

---Get the sorted key, value pairs of a table ([Documentation: Sort](https://www.lua.org/pil/19.3.html))
---@param t SortedPairs_param_t
---@return SortedPairs_return_iterator iterator
function utilities.SortedPairs(t)

	--| Parameters

	---Table to be sorted (in an ascending order and/or alphabetically, based on the `<` operator)
	---@alias SortedPairs_param_t table

	--| Returns

	---Function returning the key, value pairs of the table in order
	---@alias SortedPairs_return_iterator function

	return function() end
end

--[ Math ]

---Round a decimal fraction to the specified number of digits
---@param number Round_param_number
---@param decimals Round_param_decimals
---@return number
function utilities.Round(number, decimals)

	--| Parameters

	---A fractional number value to round | ***Default:*** `0`
	---@alias Round_param_number number?

	---Specify the number of decimal places to round the number to | ***Default:*** `0`
	---@alias Round_param_decimals integer?

	return 0
end

--[ Validation ]

--| Frame

---Check if a variable is a frame (or a backdrop object)
---@param o any
---@return IsFrame_return1, IsFrame_return2
function utilities.IsFrame(o)

	--| Returns

	---`true`, if the object was recognized as a [`FrameScriptObject`](https://warcraft.wiki.gg/wiki/UIOBJECT_FrameScriptObject), `false` otherwise
	---@alias IsFrame_return1 boolean

	---The frame name if the object is named or the debug name if unnamed but recognized as a UI [Object](https://warcraft.wiki.gg/wiki/UIOBJECT_Object) with a parent
	---@alias IsFrame_return2 string|nil

	return false
end

---Find a frame or region by its name (or a subregion if a key is included in the input string) and get a reference to it if it exists
---@param s ToFrame_param_s
---@return ToFrame_return_frame frame 
function utilities.ToFrame(s)

	--| Parameters

	---Name of the frame to find (and the key of its child region appended to it after a period character)
	---@alias ToFrame_param_s string

	--| Returns

	---Reference to the object | ***Default:*** `nil`
	---@alias ToFrame_return_frame AnyFrameObject|nil

		---@alias AnyFrameObject
		---| Frame
		---| Button
		---| CheckButton
		---| EditBox
		---| Slider
		---| Texture
		---| FontString
end

--| Font path

---Test the specified font path on the specified object by trying to set it to see if the font file is valid, exists and it's loaded by the client
---@param path TryFont_param_path
---@param object TryFont_param_object
---@param size TryFont_param_size
---@param flags TryFont_param_flags
---@return TryFont_return
function utilities.TryFont(path, object, size, flags)

	--| Parameters

	---Font file path to test
	---@alias TryFont_param_path string

	---Font object to test `path` on | ***Default:*** `_G["WidgetToolsFontPathTestDummy"]`
	--- - ***Note:*** If `path` lead to a valid valid font file, it will be safely applied to `object`.
	---@alias TryFont_param_object (Font|FontString)?

	---Font size to set | ***Default:*** `12`
	---@alias TryFont_param_size number?

	---Font styling options | ***Default:*** *(no styling):* `""`
	---@alias TryFont_param_flags TBFFlags?

	--| Returns

	---`true`, if the provided path was valid and the font could be applied to the object, `false` otherwise
	---@alias TryFont_return boolean

	return false
end

--[ Formatting ]

---Format a number string with thousands separation and optional value rounding
---@param value Thousands_param_value
---@param decimals Thousands_param_decimals
---@param round Thousands_param_round
---@param trim Thousands_param_trim
---@return Thousands_return
function utilities.Thousands(value, decimals, round, trim)

	--| Parameters

	---Number value to turn into a string with thousand separation
	---@alias Thousands_param_value number

	---Specify the number of decimal places to display if the number is a fractional value | ***Default:*** `0`
	---@alias Thousands_param_decimals number?

	---Round the number value to the specified number of decimal places | ***Default:*** `true`
	---@alias Thousands_param_round boolean?

	---Trim trailing zeros in decimal places | ***Default:*** `true`
	---@alias Thousands_param_trim boolean?

	--| Returns

	---***Default:*** `""`
	---@alias Thousands_return string

	return ""
end

---Convert the object to an appropriately formatted and colored string based on its type
---@param object ToString_param_object
---@return ToString_return_s s
---@return ToString_return_t t
function utilities.ToString(object)

	--| Parameters

	---Object to convert to a formatted text
	---@alias ToString_param_object any

	--| Returns

	---Formatted output string
	---@alias ToString_return_s string

	---Recognized object type
	---@alias ToString_return_t "Frame"|"FrameScriptObject"|"table"|"boolean"|"number"|"string"|"any"

	return "", "any"
end

---Convert a table into a formatted and colored string (appearing as a functional LUA code chunk but including coloring escape sequences)
--- - ***Example:*** Turning back into a loadable code chunk to then be useable as a table:
--- 	```
--- 	local tableAsString = WidgetTools.utilities.TableToString(t) --where t is any table
--- 	local success, loadedTable = pcall(loadstring("return " .. ns.ut.Clear(tableAsString))) --loadedTable is equivalent to t
--- 	```
---@param table TableToString_param_table
---@param compact TableToString_param_compact
---@return TableToString_return
function utilities.TableToString(table, compact)

	--| Parameters

	---Reference to the table to convert
	---@alias TableToString_param_table table

	---If `true`, trim spaces & indentation | ***Default:*** `false`
	---@alias TableToString_param_compact boolean?

	--| Returns

	---***Default:*** `(WidgetTools.utilities.ToString(table))`
	---@alias TableToString_return string

	return ""
end

---Get an assembled & fully formatted string of a specifically assembled changelog table
---@param changelog FormatChangelog_param_changelog
---@param latest FormatChangelog_param_latest
---@return FormatChangelog_return_c c
function utilities.FormatChangelog(changelog, latest)

	--| Parameters

	---Ordered (descending) list of update note subtables of textlines with formatting directives
	--- - ***Note:*** The first line is expected to be the title containing the version number and/or the date of release.
	--- - ***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).
	--- - ***Examples:***
	---   - **Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)
	---   - **Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)
	---   - **Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)
	---   - **Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)
	---   - **Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)
	---   - **Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)
	---@alias FormatChangelog_param_changelog string[][]

	---If true, get the update notes (without the first title line) of only the latest version instead of the entire changelog | ***Default:*** false
	---@alias FormatChangelog_param_latest boolean?

	--| Returns

	---***Default:*** `""`
	---@alias FormatChangelog_return_c string

	return ""
end


--[ Table Management ]

---Protect a table by creating a deep proxy surrogate reference through which value access will be readonly via a protective metatable ruleset
--- - ***Note:*** The protection will "infect" any and all subtables when they are indexed through a proxy, meaning the readonly protection will be extended at any depth, including new subtables added to the original table structure of `t` after it was protected.
--- - ***Note:*** Tables for which `getmetatable(t)` returns "public" or "protected", will not be wrapped behind a new proxy.
---   - ***Example:*** Use `setmetatable(t, { __metatable = "public" })` to whitelist any table from getting readonly protection.
---@param t Protect_param_t
---@return Protect_return
function utilities.Protect(t)

	--| Parameters

	---Reference to the table to create the proxy for
	---@alias Protect_param_t any

	--| Returns

	---Reference to the new proxy table or `t` itself
	---@alias Protect_return any
end

--| Search

---Find the index of the first matching value in the array provided while also checking subtable branches via a deep search if no match was found at the first level
---@param array FindIndex_param_array
---@param value FindIndex_param_value
---@return FindIndex_return_index index
function utilities.FindIndex(array, value)

	--| Parameters

	---Array to search
	---@alias FindIndex_param_array any[]

	---The value to find
	---@alias FindIndex_param_value  any

	--| Returns

	---***Default:*** `nil`
	---@alias FindIndex_return_index integer|nil
end

---Find the first matching value and return its key via a deep search
---@param t FindKey_param_t
---@param value FindKey_param_value
---@return FindKey_return_match match
function utilities.FindKey(t, value)

	--| Parameters

	---Reference to the table to find a value at a certain key in
	---@alias FindKey_param_t table

	---Value to look for in `t` (including all subtables, recursively)
	---@alias FindKey_param_value any

	--| Returns

	---The first match of the key `value` was found paired to | ***Default:*** `nil`
	---@alias FindKey_return_match any
end

---Find and return the value at the first matching key via a deep search
---@param t FindValue_param_t
---@param key FindValue_param_key
---@return FindValue_return_match match
function utilities.FindValue(t, key)

	--| Parameters

	---Reference to the table to find a value at a certain key in
	---@alias FindValue_param_t table

	---Key to look for in `t` (including all subtables, recursively)
	---@alias FindValue_param_key any

	--| Returns

	---The first match of the value found at `key` | ***Default:*** `nil`
	---@alias FindValue_return_match any
end

--| Sort

---Reorder select elements in an array based on a list of directives
---@param t Reorder_param_t
---@param directives Reorder_param_directives
---@return Reorder_return_t t
function utilities.Reorder(t, directives)

	--| Parameters

	---Reference to the array to reorder the elements of
	---@alias Reorder_param_t table

	---List of directives: value, index pairs to reorder select elements by (placing matching values at the specified new index)
	---@alias Reorder_param_directives table<any, integer>

	--| Returns

	---Reference to `t` (it was already overwritten during the operation, no need for setting it again)
	---@alias Reorder_return_t any
end

--| Data management

---Make a new deep copy of a non-frame table
---@param object Clone_param_object
---@return Clone_return_copy copy
function utilities.Clone(object)

	--| Parameters

	---Reference to the object to create a copy of
	---@alias Clone_param_object any

	--| Returns

	---`object` itself, if it's a frame or not a table
	---@alias Clone_return_copy any
end

---Merge a table into an array, deep copying all its values over under new integer keys
---@param target Merge_param_target
---@param source Merge_param_source
---@return Merge_return_target target
function utilities.Merge(target, source)

	--| Parameters

	---Reference to table to add the values to
	---@alias Merge_param_target table

	---Reference to table to copy all values from
	---@alias Merge_param_source table

	--| Returns

	---Reference to `target` (it was already overwritten during the operation, no need for setting it again)
	---@alias Merge_return_target any
end

---Copy all values at matching keys from a sample table to another table while preserving all table references
---@param target CopyValues_param_target
---@param source CopyValues_param_source
---@return CopyValues_return_target target
function utilities.CopyValues(target, source)

	--| Parameters

	---Reference to the table to copy the values to
	---@alias CopyValues_param_target table

	---Reference to the table to copy the values from
	---@alias CopyValues_param_source table

	--| Returns

	---Reference to `target` (the values were already overwritten during the operation, no need to set it again)
	---@alias CopyValues_return_target any
end

---Compare two tables and clone any missing data from one to the other
---@param target Fill_param_target
---@param source Fill_param_source
---@return Fill_return_target target
function utilities.Fill(target, source)

	--| Parameters

	---Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already `"table"`)
	---@alias Fill_param_target table

	---Reference to the table to sample data from
	---@alias Fill_param_source table

	--| Returns

	---Reference to `target` (it was already updated during the operation, no need for setting it again)
	---@alias Fill_return_target any
end

---Copy all values at matching keys and clone any missing data from a reference to the target table
---@param target Pull_param_target
---@param source Pull_param_source
---@return Pull_return_target target
function utilities.Pull(target, source)

	--| Parameters

	---Reference to the table to copy the values to
	---@alias Pull_param_target table

	---Reference to the table to sample data from
	---@alias Pull_param_source table

	--| Returns

	---Reference to `target` (it was already overwritten during the operation, no need for setting it again)
	---@alias Pull_return_target any
end

---Remove all nil, empty or otherwise invalid items from a data table
---@param target Prune_param_target
---@param validate Prune_param_validate
---@return Prune_return_target target
function utilities.Prune(target, validate)

	--| Parameters

	---Reference to the table to prune
	---@alias Prune_param_target table

	---Helper function for validating values, returning true if the value is to be accepted as valid
	---@alias Prune_param_validate (fun(k: number|string, v: any): boolean)?

	--| Returns

	---Reference to `target` (it was already overwritten during the operation, no need for setting it again)
	---@alias Prune_return_target any
end

---Remove unused or outdated data from a table while comparing it to another table while restoring any removed values
---@param target Filter_param_target
---@param sample Filter_param_sample
---@param recoveryMap Filter_param_recoveryMap
---@param onRecovery Filter_param_onRecovery
---@return Filter_return_target target
function utilities.Filter(target, sample, recoveryMap, onRecovery)

	--| Parameters

	---Reference to the table to remove unused key, value pairs from
	---@alias Filter_param_target table

	---Reference to the table to sample data from
	---@alias Filter_param_sample table

	---Static map or function returning a dynamically creatable map for removed but recoverable data
	---@alias Filter_param_recoveryMap (table<string, recoveryData>|fun(target: table, recoveredData: recoveredData): recoveryMap: table<string, recoveryData>)?

	---Function called after the data has been has been recovered via the `recoveryMap`
	---@alias Filter_param_onRecovery fun(target: table)?

	--| Returns

	---Reference to `target` (it was already overwritten during the operation, no need for setting it again)
	---@alias Filter_return_target any
end

---Verify data in a table and harmonize it with a sample table, removing invalid data & filling defaults
---@param target VerifyData_param_target
---@param source VerifyData_param_source
---@return VerifyData_return_target target
function utilities.VerifyData(target, source)

	--| Parameters

	---Reference to the table to verify
	---@alias VerifyData_param_target table

	---Reference to the table to sample
	---@alias VerifyData_param_source table

	--| Returns

	---Reference to `target` (it was already mutated during the operation)
	---@alias VerifyData_return_target any
end

--[ Events ]

---Set, unset or replace a event handler
---@param parent SetListener_param_parent
---@param event SetListener_param_event
---@param handler SetListener_param_handler
---@param registration SetListener_param_registration
function utilities.SetListener(parent, event, handler, registration)

	--| Parameters

	---Reference to the event frame or event handler collection key to assign the handler to
	---@alias SetListener_param_parent AnyFrameObject|any

	---Global Blizzard or custom event tag to modify the handler for
	---@alias SetListener_param_event WowEvent|string

	---Reference to the function to set as the handler for `event`, or `nil` to unset it
	---@alias SetListener_param_handler (fun(parent: AnyFrameObject|any, ...: any): ...:any)|nil

	---If true and `parent` is a Frame and `event` is a valid Blizzard event tag, also call [`parent:RegisterEvent(...)`](https://warcraft.wiki.gg/wiki/API_Frame_RegisterEvent) or [`parent:UnregisterEvent(...)`](https://warcraft.wiki.gg/wiki/API_Frame_UnregisterEvent) and [`parent:SetScript("OnEvent", WidgetTools.utilities.CallListener)`](https://warcraft.wiki.gg/wiki/UIOBJECT_ScriptObject) if it was not already set set to `WidgetTools.utilities.CallListener` (replacing all currently set and hooked scripts for the [OnEvent](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) trigger) | ***Default:*** `true`
	---@alias SetListener_param_registration boolean?
end

---Call a registered event handler
---@param parent CallListener_param_parent
---@param event CallListener_param_event
---@param ... CallListener_param_...
---@return CallListener_return_... ...
function utilities.CallListener(parent, event, ...)

	--| Parameters

	---Reference to the event frame or event handler collection key the handler has been assigned to
	---@alias CallListener_param_parent AnyFrameObject|any

	---Global Blizzard or custom event tag to call the handler for
	---@alias CallListener_param_event WowEvent|string

	---Additional payload to pass to the handler
	---@alias CallListener_param_... any

	--| Returns

	---Handler return values
	---@alias CallListener_return_... any
end


--[[ DATA ]]

---WidgetTools main database table
---@class widgetToolsData
---@field lite boolean
---@field debugging boolean
---@field positioningAids boolean
---@field frameAttributes { enabled: boolean, width: number }
---@field customFonts string[]


--[[ DEBUGGING TOOLS ]]

---Debugging tools
---@class widgetToolsDebugging
---@field history table Log history for the current session
local debugging = {}

---Save a tab-separated debug log entry to the log history and print out a formatted chat message
---@param message LogRaw_param_message
---@param trace LogRaw_param_trace
function debugging.LogRaw(message, trace)

	--| Parameters

	---Included in the log entry as a string
	---@alias LogRaw_param_message any

	---Custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** `"(source not traced)"`
	---@alias LogRaw_param_trace any
end

---Save a tab-separated debug log entry to the log history and print out a formatted chat message
---@param passer Log_param_passer
function debugging.Log(passer)

	--| Parameters

	---Passer function returning the logged message and a custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** `"nil", "(source not traced)"`
	---@alias Log_param_passer (fun(): message: any, trace: any)?
end

---Dump an object and its contents to the in-game chat
---@param object Dump_param_object
---@param name Dump_param_name
---@param blockrule Dump_param_blockrule
---@param depth Dump_param_depth
---@param digTables Dump_param_digTables
---@param digFrames Dump_param_digFrames
---@param linesPerMessage Dump_param_linesPerMessage
function debugging.Dump(object, name, blockrule, depth, digTables, digFrames, linesPerMessage)

	--| Parameters

	---Object to dump out
	---@alias Dump_param_object any

	---A name to print out | ***Default:*** *the dumped object will not be named*
	---@alias Dump_param_name string?

	---Manually filter further exploring subtables under specific keys, skipping it if the value returned is true
	--- - ***Example:*** **Match:** Skip a specific matching key
	--- 	```
	--- 	function(key) return key == "skip_key" end
	--- 	```
	--- - ***Example:*** **Comparison:** Skip an index key based the result of a comparison
	--- 	```
	--- 	function(key)
	--- 		if type(key) == "number" then --check if the key is an index to avoid issues with mixed tables
	--- 			return key < 10
	--- 		end
	--- 		return true --or false whether to allow string keys in mixed tables
	--- 	end
	--- 	```
	--- - ***Example:*** **Blocklist:** Iterate through an array (indexed table) containing keys, the values of which are to be skipped
	--- 	```
	--- 	function(key)
	--- 		local blocklist = {
	--- 			"skip_key",
	--- 			1,
	--- 		}
	--- 		for i = 1, #blocklist do
	--- 			if key == blocklist[i] then
	--- 			return true --or false to invert the functionality and treat the blocklist as an allowlist
	--- 		end
	--- 	end
	--- 		return false --or true to invert the functionality and treat the blocklist as an allowlist
	--- 	end
	--- 	```
	---@alias Dump_param_blockrule (fun(key: integer|string): boolean)?

	---How many levels of subtables to print out (root level: `0`) | ***Default:*** *full depth*
	---@alias Dump_param_depth integer?

	---If `true`, explore and dump the non-subtable values of table objects | ***Default:*** `true`
	---@alias Dump_param_digTables boolean?

	---If `true`, explore and dump the insides of objects recognized as frames | ***Default:*** `false`
	---@alias Dump_param_digFrames boolean?

	---Print the specified number of output lines in a single chat message to be able to display more message history and allow faster scrolling | ***Default:*** `2`
	--- - ***Note:*** Set to `0` to print all lines in a single message.
	---@alias Dump_param_linesPerMessage integer?
end


--[[ TOOLBOX REGISTRY ]]

---Toolbox registration
---@class widgetToolsToolboxes
---@field initialization table<string, widgetToolbox|table> List of temporary toolbox initialization tables under version keys where a toolbox can assembled to be registered once the addon requesting it finishes loading
local toolboxes = {}

	---@class widgetToolbox
	---@field title? string Display name of the toolbox
	---@field changelog? string[][] 

---@class widgetToolboxEntry
---@field toolbox widgetToolbox|table Registered toolbox table
---@field addons string[] List of addons registered for using this toolbox (represented by their namespace names)

--| Registration

---Get an already registered toolbox table of the specified version, registering an addon for its use, or, register an already assembled toolbox table or start the initialization of a new one
--- - ***Note:*** If a toolbox of `version` already exists in the registry, get a reference to it and register `addon` for use, `callback` will not be called.
--- - ***Note:*** If no existing toolbox entry was found, and `toolbox` is not provided or it's not a valid table, start the initialization of a new toolbox (in an always writeable table accessible via `WidgetTools.toolboxes.initialization[version]`), and call `callback` when `toolboxAddon` finished loading, returning a (raw direct or readonly) reference to the newly initialized toolbox bundled from this initialization table which itself will be cleared.
---@param userAddon Register_param_userAddon
---@param version Register_param_version
---@param callback Register_param_callback
---@param toolboxAddon Register_param_toolboxAddon
---@param toolbox Register_param_toolbox
---@param readonly Register_param_readonly
---@return Register_return_toolbox toolbox
function toolboxes.Register(userAddon, version, callback, toolboxAddon, toolbox, readonly)

	--| Parameters

	---Addon namespace (the name of the addon's folder, not its display title) to register for WidgetTools usage
	---@alias Register_param_userAddon string

	---Version key the `toolbox` should be registered under (always converted to string)
	---@alias Register_param_version string|number

	---Function to be called after a new toolbox initialization has finished when `addon` loaded, returning a readonly reference to the new toolbox table
	---@alias Register_param_callback fun(toolbox: widgetToolbox|table?)?

	---Namespace name of the **LoadOnDemand** toolbox initializer addon to load | ***Default:*** `"WidgetToolbox_" .. version`
	---@alias Register_param_toolboxAddon string?

	---Reference to an existing toolbox table to register
	---@alias Register_param_toolbox table?

	---If true, protect `toolbox` by making it entirely readonly via `WidgetTools.utilities.Protect(...)` | ***Default:*** false
	---@alias Register_param_readonly boolean?

	--| Returns

	---Registered toolbox table, or `false` if the toolbox construction addon named `"WidgetToolbox_" .. version` could not be loaded while attempting the initialization of a new toolbox | ***Default:*** *nil*
	---@alias Register_return_toolbox widgetToolbox|table|boolean?
end


--[[ GLOBAL TOOLS ]]

---Global readonly Widget Tools table
---@class widgetTools
---@field resources widgetToolsResources
---@field utilities widgetToolsUtilities
---@field debugging widgetToolsDebugging
---@field toolboxes widgetToolsToolboxes
WidgetTools = {}


--[[ BLIZZARD TOOLS ]]

---Clamp a number between two limits
---@param value number
---@param min number
---@param max number
---@return number
function Clamp(value, min, max) return 0 end


--[[ CLASSIC SUPPORT ]]

---Wraps a given string with color code markup while asserting the provided color table is a valid color object
--- - ***Note:*** This version of this utility is always available in Classic.
---@param text string
---@param color { r: number, g: number, b: number, a: number|nil }
---@return string coloredText
local function WrapTextInColor_safe(text, color) return "" end

--***Note:*** C_ColorUtil is partially recreated for Classic.
C_ColorUtil = {
	WrapTextInColorCode = C_ColorUtil.WrapTextInColorCode,
	WrapTextInColor = WrapTextInColor_safe,
}