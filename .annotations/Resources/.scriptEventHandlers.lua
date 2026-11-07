--NOTE: Annotations are for development purposes only, providing live documentation via Lua Language Server. This file does not need to be loaded by the game client.

---@meta scriptEventHandlers

---Table of key, value pairs of script event tags and the handler functions called on trigger
---@alias scriptHandlers
---| scriptHandlers_Texture
---| scriptHandlers_Frame
---| scriptHandlers_ScrollFrame
---| scriptHandlers_Button
---| scriptHandlers_CheckButton
---| scriptHandlers_EditBox
---| scriptHandlers_Slider

---@class scriptHandlers_ScriptRegion_base<T>
---@field OnShow? fun(self: T) [`"OnShow"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnShow) script event handler
---@field OnHide? fun(self: T) [`"OnHide"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnHide) script event handler
---@field OnEnter? fun(self: T, isMotion: boolean) [`"OnEnter"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEnter) script event handler
---@field OnLeave? fun(self: T, isMotion: boolean) [`"OnLeave"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnLeave) script event handler
---@field OnMouseDown? fun(self: T, mouseButton: mouseButton) [`"OnMouseDown"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnMouseDown) script event handler
---@field OnMouseUp? fun(self: T, mouseButton: mouseButton, upInside: boolean) [`"OnMouseUp"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnMouseUp) script event handler
---@field OnMouseWheel? fun(self: T, delta: integer) [`"OnMouseWheel"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnMouseWheel) script event handler
---@field OnLoad? fun(self: T) [`"OnLoad"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnLoad) script event handler

---Table of key, value pairs of Texture script event tags and the handler functions called on trigger
---@class scriptHandlers_Texture: scriptHandlers_ScriptRegion_base<Texture>

---@class scriptHandlers_Frame_base<T>: scriptHandlers_ScriptRegion_base<T>
---@field OnAttributeChanged? fun(self: T, attribute: string, value: any) [`"OnAttributeChanged"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) script event handler
---@field OnChar? fun(self: T, char: string) [`"OnChar"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnChar) script event handler
---@field OnDisable? fun(self: T) [`"OnDisable"`](https://warcraft.wiki.gg/wiki/Widget_script_handlers#Frame:~:text=in%20the%20frame.-,OnDisable,-(self)%20%2D%20Invoked) script event handler
---@field OnDragStart? fun(self: T, mouseButton: mouseButton) [`"OnDragStart"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnDragStart) script event handler
---@field OnDragStop? fun(self: T) [`"OnDragStop"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnDragStop) script event handler
---@field OnEnable? fun(self: T) [`"OnEnable"`](https://warcraft.wiki.gg/wiki/Widget_script_handlers#Frame:~:text=in%20the%20frame%2C-,OnEnable,-(self)%20%2D%20Invoked) script event handler
---@field OnEvent? fun(self: T, event: string, ...: any) [`"OnEvent"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) script event handler
---@field OnGamePadButtonDown? fun(self: T, gamepadButton: string) [`"OnGamePadButtonDown"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnGamePadButtonDown) script event handler
---@field OnGamePadButtonUp? fun(self: T, gamepadButton: string) [`"OnGamePadButtonUp"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnGamePadButtonUp) script event handler
---@field OnGamePadStick? fun(self: T, stick: string, x: signedNormalizedNumber, y: signedNormalizedNumber, distance: normalizedNumber) [`"OnGamePadStick"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnGamePadStick) script event handler
---@field OnHyperlinkClick? fun(self: T, payload: string, label: string, mouseButton: mouseButton, region: Region, left: number, bottom: number, width: nonNegativeNumber, height: nonNegativeNumber) [`"OnHyperlinkClick"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnHyperlinkClick) script event handler
---@field OnHyperlinkEnter? fun(self: T, payload: string, label: string, region: Region, left: number, bottom: number, width: nonNegativeNumber, height: nonNegativeNumber) [`"OnHyperlinkEnter"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnHyperlinkEnter) script event handler
---@field OnHyperlinkLeave? fun(self: T) [`"OnHyperlinkLeave"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnHyperlinkLeave) script event handler
---@field OnKeyDown? fun(self: T, key: string) [`"OnKeyDown"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnKeyDown) script event handler
---@field OnKeyUp? fun(self: T, key: string) [`"OnKeyUp"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnKeyUp) script event handler
---@field OnReceiveDrag? fun(self: T) [`"OnReceiveDrag"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnReceiveDrag) script event handler
---@field OnSizeChanged? fun(self: T, width: nonNegativeNumber, height: nonNegativeNumber) [`"OnSizeChanged"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnSizeChanged) script event handler
---@field OnUpdate? fun(self: T, elapsed: nonNegativeNumber) [`"OnUpdate"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate) script event handler

---Table of key, value pairs of Frame script event tags and the handler functions called on trigger
---@class scriptHandlers_Frame: scriptHandlers_Frame_base<Frame>

---Table of key, value pairs of ScrollFrame script event tags and the handler functions called on trigger
---@class scriptHandlers_ScrollFrame: scriptHandlers_Frame_base<ScrollFrame>
---@field OnHorizontalScroll? fun(self: ScrollFrame, offset: number) [`"OnHorizontalScroll"`](https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame#Script_Types:~:text=Script%20Types-,OnHorizontalScroll,-(self%2C) script event handler
---@field OnScrollRangeChanged? fun(self: ScrollFrame, horizontalRange: nonNegativeNumber, verticalRange: nonNegativeNumber) [`"OnScrollRangeChanged"`](https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame#Script_Types:~:text=OnScrollRangeChanged) script event handler
---@field OnVerticalScroll? fun(self: ScrollFrame, offset: number) [`"OnVerticalScroll"`](https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame#Script_Types:~:text=scroll%20position%20changes.-,OnVerticalScroll,-(self%2C) script event handler

---@class scriptHandlers_Button_base<T>: scriptHandlers_Frame_base<T>
---@field OnClick? fun(self: T, mouseButton?: mouseButton, down?: boolean) [`"OnClick"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick) script event handler
---@field OnDoubleClick? fun(self: T, mouseButton: mouseButton) [`"OnDoubleClick"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnDoubleClick) script event handler
---@field PostClick? fun(self: T, mouseButton: mouseButton, down: boolean) [`"PostClick"`](https://warcraft.wiki.gg/wiki/UIHANDLER_PostClick) script event handler
---@field PreClick? fun(self: T, mouseButton: mouseButton, down: boolean) [`"PreClick"`](https://warcraft.wiki.gg/wiki/UIHANDLER_PreClick) script event handler

---Table of key, value pairs of Button script event tags and the handler functions called on trigger
---@class scriptHandlers_Button: scriptHandlers_Button_base<Button>

---Table of key, value pairs of CheckButton script event tags and the handler functions called on trigger
---@class scriptHandlers_CheckButton: scriptHandlers_Button_base<CheckButton>

---Table of key, value pairs of EditBox script event tags and the handler functions called on trigger
---@class scriptHandlers_EditBox: scriptHandlers_Frame_base<EditBox>
---@field OnArrowPressed? fun(self: EditBox, key: string) [`"OnArrowPressed"`](https://warcraft.wiki.gg/wiki/Widget_script_handlers#EditBox:~:text=EditBox-,OnArrowPressed,-(self%2C) script event handler
---@field OnCharComposition? fun(self: EditBox, composition: string) [`"OnCharComposition"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnCharComposition) script event handler
---@field OnCursorChanged? fun(self: EditBox, x: nonNegativeNumber, y: nonPositiveNumber, width: nonNegativeNumber, height: nonNegativeNumber) [`"OnCursorChanged"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnCursorChanged) script event handler
---@field OnEditFocusGained? fun(self: EditBox) [`"OnEditFocusGained"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEditFocusGained) script event handler
---@field OnEditFocusLost? fun(self: EditBox) [`"OnEditFocusLost"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEditFocusLost) script event handler
---@field OnEnterPressed? fun(self: EditBox) [`"OnEnterPressed"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEnterPressed) script event handler
---@field OnEscapePressed? fun(self: EditBox) [`"OnEscapePressed"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEscapePressed) script event handler
---@field OnSpacePressed? fun(self: EditBox) [`"OnSpacePressed"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnSpacePressed) script event handler
---@field OnInputLanguageChanged? fun(self: EditBox, language: string) [`"OnInputLanguageChanged"`](https://warcraft.wiki.gg/wiki/Widget_script_handlers#EditBox:~:text=OnInputLanguageChanged) script event handler
---@field OnTabPressed? fun(self: EditBox) [`"OnTabPressed"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnTabPressed) script event handler
---@field OnTextChanged? fun(self: EditBox, userInput: boolean) [`"OnTextChanged"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnTextChanged) script event handler
---@field OnTextSet? fun(self: EditBox) [`"OnTextSet"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnTextSet) script event handler

---Table of key, value pairs of Slider script event tags and the handler functions called on trigger
---@class scriptHandlers_Slider: scriptHandlers_Frame_base<Slider>
---@field OnMinMaxChanged? fun(self: Slider, min: number, max: number) [`"OnMinMaxChanged"`](https://warcraft.wiki.gg/wiki/Widget_script_handlers#Slider:~:text=Slider-,OnMinMaxChanged,-(self%2C) script event handler
---@field OnValueChanged? fun(self: Slider, value: number, userInput: boolean) [`"OnValueChanged"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnValueChanged) script event handler