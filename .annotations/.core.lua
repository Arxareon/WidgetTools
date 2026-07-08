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
---***
---@param t SortedPairs_param Table to be sorted (in an ascending order and/or alphabetically, based on the `<` operator)
---***
---@return function iterator Function returning the key, value pairs of the table in order
function utilities.SortedPairs(t)

	--| Parameters

	---Table to be sorted (in an ascending order and/or alphabetically, based on the `<` operator)
	---@alias SortedPairs_param # t
	---| table 

	return function() end
end

--[ Math ]

---Round a decimal fraction to the specified number of digits
---***
---@param number? Round_param1 A fractional number value to round | ***Default:*** `0`
---@param decimals? Round_param2 Specify the number of decimal places to round the number to | ***Default:*** `0`
---@return number
function utilities.Round(number, decimals)

	--| Parameters

	---A fractional number value to round | ***Default:*** `0`
	---@alias Round_param1 # number
	---| number
	---| nil

	---Specify the number of decimal places to round the number to | ***Default:*** `0`
	---@alias Round_param2 # decimals
	---| integer
	---| nil

	return 0
end

--[ Validation ]

--| Frame

---Check if a variable is a frame (or a backdrop object)
---@param t Frame|any
---***
---@return boolean|string # If `t` is recognized as a [`FrameScriptObject`](https://warcraft.wiki.gg/wiki/UIOBJECT_FrameScriptObject), return `true`, or, return the frame name if named or the debug name if unnamed but recognized as a UI [Object](https://warcraft.wiki.gg/wiki/UIOBJECT_Object) with a parent, otherwise, return false
function utilities.IsFrame(t) return false end

---Find a frame or region by its name (or a subregion if a key is included in the input string) and get a reference to it if it exists
---***
---@param s ToFrame_param Name of the frame to find (and the key of its child region appended to it after a period character)
---***
---@return AnyFrameObject|nil frame Reference to the object | ***Default:*** `nil`
function utilities.ToFrame(s)

	--| Parameters

	---Name of the frame to find (and the key of its child region appended to it after a period character)
	---@alias ToFrame_param # s
	---| string

	--| Returns

	---@alias AnyFrameObject # frame
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
---***
---@param path TryFont_param1 Font file path to test
---@param object? TryFont_param2 Font object to test `path` on | ***Default:*** `_G["WidgetToolsFontPathTestDummy"]`
--- - ***Note:*** If `path` lead to a valid valid font file, it will be safely applied to `object`.
---@param size? TryFont_param3 Font size to set | ***Default:*** `12`
---@param flags? TryFont_param4 Font styling options | ***Default:*** *(no styling):* `""`
---***
---@return boolean # True, if `path` was valid and the font could be applied to `object`
function utilities.TryFont(path, object, size, flags)

	--| Parameters

	---Font file path to test
	---@alias TryFont_param1
	---| string

	---Font object to test `path` on | ***Default:*** `_G["WidgetToolsFontPathTestDummy"]`
	--- - ***Note:*** If `path` lead to a valid valid font file, it will be safely applied to `object`.
	---@alias TryFont_param2
	---| Font
	---| FontString
	---| nil

	---Font size to set | ***Default:*** `12`
	---@alias TryFont_param3
	---| number
	---| nil

	---Font styling options | ***Default:*** *(no styling):* `""`
	---@alias TryFont_param4
	---| TBFFlags
	---| nil

	return false
end

--[ Formatting ]

---Format a number string with thousands separation and optional value rounding
---***
---@param value Thousands_param1 Number value to turn into a string with thousand separation
---@param decimals? Thousands_param2 Specify the number of decimal places to display if the number is a fractional value | ***Default:*** `0`
---@param round? Thousands_param3 Round the number value to the specified number of decimal places | ***Default:*** `true`
---@param trim? Thousands_param4 Trim trailing zeros in decimal places | ***Default:*** `true`
---***
---@return string # ***Default:*** `""`
function utilities.Thousands(value, decimals, round, trim)

	--| Parameters

	---Number value to turn into a string with thousand separation
	---@alias Thousands_param1 # value
	---| number

	---Specify the number of decimal places to display if the number is a fractional value | ***Default:*** `0`
	---@alias Thousands_param2 # decimals
	---| number
	---| nil

	---Round the number value to the specified number of decimal places | ***Default:*** `true`
	---@alias Thousands_param3 # round
	---| boolean
	---| nil

	---Trim trailing zeros in decimal places | ***Default:*** `true`
	---@alias Thousands_param4 # trim
	---| boolean
	---| nil

	return ""
end

---Convert the object to an appropriately formatted and colored string based on its type
---***
---@param object ToString_param Object to convert to a formatted text
---***
---@return string s Formatted output string
---@return "Frame"|"FrameScriptObject"|"table"|"boolean"|"number"|"string"|"any" t Recognized object type
---***
---<p></p>
function utilities.ToString(object)

	--| Parameters

	---Object to convert to a formatted text
	---@alias ToString_param # object
	---| any

	return "", "any"
end

---Convert a table into a formatted and colored string (appearing as a functional LUA code chunk but including coloring escape sequences)
--- - ***Example:*** Turning back into a loadable code chunk to then be useable as a table:
--- 	```
--- 	local success, loadedTable = pcall(loadstring("return " .. ns.ut.Clear(tableAsString)))
--- 	```
---***
---@param table TableToString_param1 Reference to the table to convert
---@param compact? TableToString_param2 Whether spaces and indentations should be trimmed or not | ***Default:*** `false`
---***
---@return string # ***Default:*** `(WidgetTools.utilities.ToString(table))`
function utilities.TableToString(table, compact)

	--| Parameters

	---Reference to the table to convert
	---@alias TableToString_param1 # table
	---| table

	---Whether spaces and indentations should be trimmed or not | ***Default:*** `false`
	---@alias TableToString_param2 # compact
	---| boolean

	return ""
end

---Get an assembled & fully formatted string of a specifically assembled changelog table
---***
---@param changelog FormatChangelog_param1 Ordered (descending) list of update note subtables of textlines with formatting directives
--- - ***Note:*** The first line is expected to be the title containing the version number and/or the date of release.
--- - ***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).
--- - ***Examples:***
---   - **Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)
---   - **Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)
---   - **Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)
---   - **Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)
---   - **Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)
---   - **Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
---@param latest? FormatChangelog_param2 If true, get the update notes (without the first title line) of only the latest version instead of the entire changelog | ***Default:*** false
---***
---@return string c # ***Default:*** ""
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
	---   - **Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
	---@alias FormatChangelog_param1 # changelog
	---| string[][]

	---If true, get the update notes (without the first title line) of only the latest version instead of the entire changelog | ***Default:*** false
	---@alias FormatChangelog_param2 # latest
	---| boolean
	---| nil

	return ""
end


--[ Table Management ]

---Protect a table by creating a deep proxy surrogate reference through which value access will be read-only via a protective metatable ruleset
--- - ***Note:*** The protection will "infect" any and all subtables when they are indexed through a proxy, meaning the read-only protection will be extended at any depth, including new subtables added to the original table structure of `t` after it was protected.
--- - ***Note:*** Tables for which `getmetatable(t)` returns "public" or "protected", will not be wrapped behind a new proxy.
---   - ***Example:*** Use `setmetatable(t, { __metatable = "public" })` to whitelist any table from getting read-only protection.
---***
---@param t Protect_param Reference to the table to create the proxy for
---***
---@return any # Reference to the new proxy table or `t` itself
function utilities.Protect(t)

	--| Parameters

	---Reference to the table to create the proxy for
	---@alias Protect_param # t
	---| any
end

--| Search

---Find the index of the first matching value in the array provided while also checking subtable branches via a deep search if no match was found at the first level
---***
---@param array FindIndex_param1 Array to search
---@param value FindIndex_param2 The value to find
---***
---@return integer|nil index ***Default:*** `nil`
function utilities.FindIndex(array, value)

	--| Parameters

	---Array to search
	---@alias FindIndex_param1 # array
	---| any[]

	---The value to find
	---@alias FindIndex_param2 # value
	---| any
end

---Find the first matching value and return its key via a deep search
---***
---@param t FindKey_param1 Reference to the table to find a value at a certain key in
---@param value FindKey_param2 Value to look for in `t` (including all subtables, recursively)
---***
---@return any match The first match of the key `value` was found paired to | ***Default:*** `nil`
function utilities.FindKey(t, value)

	--| Parameters

	---Reference to the table to find a value at a certain key in
	---@alias FindKey_param1 # t
	---| table

	---Value to look for in `t` (including all subtables, recursively)
	---@alias FindKey_param2 # value
	---| any
end

---Find and return the value at the first matching key via a deep search
---***
---@param t FindValue_param1 Reference to the table to find a value at a certain key in
---@param key FindValue_param2 Key to look for in `t` (including all subtables, recursively)
---***
---@return any match The first match of the value found at `key` | ***Default:*** `nil`
function utilities.FindValue(t, key)

	--| Parameters

	---Reference to the table to find a value at a certain key in
	---@alias FindValue_param1 # t
	---| table

	---Key to look for in `t` (including all subtables, recursively)
	---@alias FindValue_param2 # key
	---| any
end

--| Sort

---Reorder select elements in an array based on a list of directives
---***
---@param t Reorder_param1 Reference to the array to reorder the elements of
---@param directives Reorder_param2 List of directives: value, index pairs to reorder select elements by (placing matching values at the specified new index)
---***
---@return any t Reference to `t` (it was already overwritten during the operation, no need for setting it again)
function utilities.Reorder(t, directives)

	--| Parameters

	---Reference to the array to reorder the elements of
	---@alias Reorder_param1 # t
	---| table

	---List of directives: value, index pairs to reorder select elements by (placing matching values at the specified new index)
	---@alias Reorder_param2 # t
	---| table<any, integer>
end

--| Data management

---Make a new deep copy of a non-frame table
---***
---@param object Clone_param Reference to the object to create a copy of
---***
---@return any copy Returns `object` itself if it's a frame or not a table
function utilities.Clone(object)

	--| Parameters

	---Reference to the object to create a copy of
	---@alias Clone_param # object
	---| any
end

---Merge a table into an array, deep copying all its values over under new integer keys
---***
---@param target Merge_param1 Table to add the values to
---@param source Merge_param2 Table to copy all values from
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function utilities.Merge(target, source)

	--| Parameters

	---Reference to table to add the values to
	---@alias Merge_param1 # target
	---| table

	---Reference to table to copy all values from
	---@alias Merge_param2 # source
	---| table
end

---Copy all values at matching keys from a sample table to another table while preserving all table references
---***
---@param target CopyValues_param1 Reference to the table to copy the values to
---@param source CopyValues_param2 Reference to the table to copy the values from
---***
---@return any target Reference to `target` (the values were already overwritten during the operation, no need to set it again)
function utilities.CopyValues(target, source)

	--| Parameters

	---Reference to the table to copy the values to
	---@alias CopyValues_param1 # target
	---| table

	---Reference to the table to copy the values from
	---@alias CopyValues_param2 # source
	---| table
end

---Compare two tables and clone any missing data from one to the other
---***
---@param target Fill_param1 Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already `"table"`)
---@param source Fill_param2 Reference to the table to sample data from
---***
---@return any target Reference to `target` (it was already updated during the operation, no need for setting it again)
function utilities.Fill(target, source)

	--| Parameters

	---Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already `"table"`)
	---@alias Fill_param1 # target
	---| table

	---Reference to the table to sample data from
	---@alias Fill_param2 # source
	---| table
end

---Copy all values at matching keys and clone any missing data from a reference to the target table
---***
---@param target Pull_param1 Reference to the table to copy the values to
---@param source Pull_param2 Reference to the table to sample data from
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function utilities.Pull(target, source)

	--| Parameters

	---Reference to the table to copy the values to
	---@alias Pull_param1 # target
	---| table

	---Reference to the table to sample data from
	---@alias Pull_param2 # source
	---| table
end

---Remove all nil, empty or otherwise invalid items from a data table
---***
---@param target Prune_param1 Reference to the table to prune
---@param validate? Prune_param2 Helper function for validating values, returning true if the value is to be accepted as valid
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function utilities.Prune(target, validate)

	--| Parameters

	---Reference to the table to prune
	---@alias Prune_param1 # target
	---| table

	---Helper function for validating values, returning true if the value is to be accepted as valid
	---@alias Prune_param2 # validate
	---| fun(k: number|string, v: any): boolean
	---| nil
end

---Remove unused or outdated data from a table while comparing it to another table while restoring any removed values
---***
---@param target Filter_param1 Reference to the table to remove unused key, value pairs from
---@param sample Filter_param2 Reference to the table to sample data from
---@param recoveryMap? Filter_param3 Static map or function returning a dynamically creatable map for removed but recoverable data
---@param onRecovery? Filter_param4 Function called after the data has been has been recovered via the `recoveryMap`
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function utilities.Filter(target, sample, recoveryMap, onRecovery)

	--| Parameters

	---Reference to the table to remove unused key, value pairs from
	---@alias Filter_param1 # target
	---| table

	---Reference to the table to sample data from
	---@alias Filter_param2 # sample
	---| table

	---Static map or function returning a dynamically creatable map for removed but recoverable data
	---@alias Filter_param3 # recoveryMap
	---| table<string, recoveryData>
	---| fun(target: table, recoveredData: recoveredData): recoveryMap: table<string, recoveryData>
	---| nil

	---Function called after the data has been has been recovered via the `recoveryMap`
	---@alias Filter_param4 # onRecovery
	---| nil
	---| fun(target: table)
end

---Verify data in a table and harmonize it with a sample table, removing invalid data & filling defaults
---@param target VerifyData_param1 Reference to the table to verify
---@param source VerifyData_param2 Reference to the table to sample
---@return any target Reference to `target` (it was already mutated during the operation)
function utilities.VerifyData(target, source)

	--| Parameters

	---Reference to the table to verify
	---@alias VerifyData_param1 # target
	---| table

	---Reference to the table to sample
	---@alias VerifyData_param2 # source
	---| table
end

--[ Events ]

---Set, unset or replace a event handler
---***
---@param parent SetListener_param1 Reference to the event frame or event handler collection key to assign the handler to
---@param event SetListener_param2 Global Blizzard or custom event tag to modify the handler for
---@param handler SetListener_param3 Reference to the function to set as the handler for `event`, or `nil` to unset it
---@param registration? SetListener_param4 If true and `parent` is a Frame and `event` is a valid Blizzard event tag, also call [`parent:RegisterEvent(...)`](https://warcraft.wiki.gg/wiki/API_Frame_RegisterEvent) or [`parent:UnregisterEvent(...)`](https://warcraft.wiki.gg/wiki/API_Frame_UnregisterEvent) and [`parent:SetScript("OnEvent", WidgetTools.utilities.CallListener)`](https://warcraft.wiki.gg/wiki/UIOBJECT_ScriptObject) of it was not already set set to `WidgetTools.utilities.CallListener` (replacing all currently set and hooked scripts for the [OnEvent](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) trigger) | ***Default:*** `true`
---***
---<p></p>
function utilities.SetListener(parent, event, handler, registration)

	--| Parameters

	---Reference to the event frame or event handler collection key to assign the handler to
	---@alias SetListener_param1 # parent
	---| AnyFrameObject
	---| any

	---Global Blizzard or custom event tag to modify the handler for
	---@alias SetListener_param2 # event
	---| WowEvent
	---| string

	---Reference to the function to set as the handler for `event`, or `nil` to unset it
	---@alias SetListener_param3 # handler
	---| fun(parent: AnyFrameObject|any, ...: any): ...:any
	---| nil

	---If true and `parent` is a Frame and `event` is a valid Blizzard event tag, also call [`parent:RegisterEvent(...)`](https://warcraft.wiki.gg/wiki/API_Frame_RegisterEvent) or [`parent:UnregisterEvent(...)`](https://warcraft.wiki.gg/wiki/API_Frame_UnregisterEvent) and [`parent:SetScript("OnEvent", WidgetTools.utilities.CallListener)`](https://warcraft.wiki.gg/wiki/UIOBJECT_ScriptObject) of it was not already set set to `WidgetTools.utilities.CallListener` (replacing all currently set and hooked scripts for the [OnEvent](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) trigger) | ***Default:*** `true`
	---@alias SetListener_param4 # registration
	---| boolean
	---| nil
end

---Call a registered event handler
---***
---@param parent CallListener_param1 Reference to the event frame or event handler collection key the handler has been assigned to
---@param event CallListener_param2 Global Blizzard or custom event tag to call the handler for
---@param ... any Additional payload to pass to the handler
---***
---@return any ... Handler return values
---***
---<p></p>
function utilities.CallListener(parent, event, ...)

	--| Parameters

	---Reference to the event frame or event handler collection key the handler has been assigned to
	---@alias CallListener_param1 # parent
	---| AnyFrameObject
	---| any

	---Global Blizzard or custom event tag to call the handler for
	---@alias CallListener_param2 # event
	---| WowEvent
	---| string
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
---***
---@param message? LogRaw_param1 Included in the log entry as a string
---@param trace? LogRaw_param2 Custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** `"(source not traced)"`
function debugging.LogRaw(message, trace)

	--| Parameters

	---Included in the log entry as a string
	---@alias LogRaw_param1 # message
	---| any

	---Custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** `"(source not traced)"`
	---@alias LogRaw_param2 # trace
	---| any
end

---Save a tab-separated debug log entry to the log history and print out a formatted chat message
---***
---@param passer? Log_param1 Included in the log entry as a string
function debugging.Log(passer)

	--| Parameters

	---Passer function returning the logged message and a custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** `"nil", "(source not traced)"`
	---@alias Log_param1 # passer
	---| fun(): message: any, trace: any
	---| nil
end

---Dump an object and its contents to the in-game chat
---***
---@param object Dump_param1 Object to dump out
---@param name? Dump_param2 A name to print out | ***Default:*** *the dumped object will not be named*
---@param blockrule? Dump_param3 Manually filter further exploring subtables under specific keys, skipping it if the value returned is true
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
---@param depth? Dump_param4 How many levels of subtables to print out (root level: `0`) | ***Default:*** *full depth*
---@param digTables? Dump_param5 If `true`, explore and dump the non-subtable values of table objects | ***Default:*** `true`
---@param digFrames? Dump_param6 If `true`, explore and dump the insides of objects recognized as frames | ***Default:*** `false`
---@param linesPerMessage? Dump_param7 Print the specified number of output lines in a single chat message to be able to display more message history and allow faster scrolling | ***Default:*** `2`
--- - ***Note:*** Set to `0` to print all lines in a single message.
function debugging.Dump(object, name, blockrule, depth, digTables, digFrames, linesPerMessage)

	--| Parameters

	---Object to dump out
	---@alias Dump_param1 # object
	---| any

	---A name to print out | ***Default:*** *the dumped object will not be named*
	---@alias Dump_param2 # name
	---| string
	---| nil

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
	---@alias Dump_param3 # blockrule
	---| fun(key: integer|string): boolean
	---| nil

	---How many levels of subtables to print out (root level: `0`) | ***Default:*** *full depth*
	---@alias Dump_param4 # depth
	---| integer
	---| nil

	---If `true`, explore and dump the non-subtable values of table objects | ***Default:*** `true`
	---@alias Dump_param5 # digTables
	---| boolean
	---| nil

	---If `true`, explore and dump the insides of objects recognized as frames | ***Default:*** `false`
	---@alias Dump_param6 # digFrames
	---| boolean
	---| nil

	---Print the specified number of output lines in a single chat message to be able to display more message history and allow faster scrolling | ***Default:*** `2`
	--- - ***Note:*** Set to `0` to print all lines in a single message.
	---@alias Dump_param7 # linesPerMessage
	---| integer
	---| nil
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
---@field toolbox widgetToolbox|table Read-only proxy reference to the registered toolbox table
---@field addons string[] List of addons registered for using this toolbox (represented by their namespace names)

--| Registration

---Get a read-only reference to the toolbox of the specified version from the registry, register an already assembled one as a new entry, or start initializing a new toolbox table, linked to the specified addon for use
--- - ***Note:*** If a toolbox of `version` already exists in the registry, get a read-only reference to it and register `addon` for use, `callback` will not be called.
--- - ***Note:*** If no existing toolbox entry was found, and `toolbox` is not provided or it's not a valid table, start the initialization of a new toolbox in the a readable table accessible via `WidgetTools.toolboxes.initialization[version]`, and call `callback` when `toolboxAddon` finished loading, returning a read-only reference to the newly initialized toolbox bundled from this initialization table which itself will be cleared.
---***
---@param userAddon Register_param1 Addon namespace (the name of the addon's folder, not its display title) to register for WidgetTools usage
---@param version Register_param2 Version key the `toolbox` should be registered under (always converted to string)
---@param callback? Register_param3 Function to be called after a new toolbox initialization has finished when `toolboxAddon` loaded, returning a read-only reference to the new toolbox table
---@param toolboxAddon? Register_param4 Namespace name of the **LoadOnDemand** toolbox initializer addon to load to start initializing a new toolbox | ***Default:*** `"WidgetToolbox_" .. version`
---@param toolbox? Register_param5 Reference to an existing toolbox table to register as a new entry
---***
---@return widgetToolbox|table|boolean? toolbox Read-only reference to the registered toolbox table, or `false` if the toolbox construction addon named `"WidgetToolbox_" .. version` could not be loaded while attempting the initialization of a new toolbox | ***Default:*** *nil*
function toolboxes.Register(userAddon, version, callback, toolboxAddon, toolbox)

	--| Parameters

	---Addon namespace (the name of the addon's folder, not its display title) to register for WidgetTools usage
	---@alias Register_param1 # userAddon
	---| string

	---Version key the `toolbox` should be registered under (always converted to string)
	---@alias Register_param2 # version
	---| string
	---| number

	---Function to be called after a new toolbox initialization has finished when `addon` loaded, returning a read-only reference to the new toolbox table
	---@alias Register_param3 # callback
	---| nil
	---| fun(toolbox: widgetToolbox|table?)

	---Namespace name of the **LoadOnDemand** toolbox initializer addon to load | ***Default:*** `"WidgetToolbox_" .. version`
	---@alias Register_param4 # toolboxAddon
	---| string
	---| nil

	---Reference to an existing toolbox table to register
	---@alias Register_param5 # toolbox
	---| table
	---| nil
end


--[[ GLOBAL TOOLS ]]

---Global read-only Widget Tools table
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