--NOTE: Annotations are for development purposes only, providing live documentation via Lua Language Server. This file does not need to be loaded by the game client.

---@meta constructs


--[[ TOOLBOX ]]

local wt = {} ---@class toolbox


--[ Protoform Synthesis ]

---@alias rootTypename typename_construct

--[ Utilities ]

---Check if an object is a recognizable construct instance and it is of the specific type
---@param object IsType_param_object Reference to the object to check
---@param typename IsType_param_typename WidgetTools typename to check if `object` is an instance of this specific type
---@return IsWidget_return # `true` if the object is a widget (and optionally also of `typename`)
function wt.IsType(object, typename)

	--| Parameters

	---Reference to the object to check
	---@alias IsType_param_object any

	---WidgetTools typename to check if `object` is an instance of this specific type
	---@alias IsType_param_typename typename

		---@alias typename
		---| typename_construct
		---| typename_widget
		---| typename_list
		---| typename_container
		---| typename_panel
		---| typename_chatmanager
		---| typename_customContainer
		---| typename_action
		---| typename_button
		---| typename_customButton
		---| typename_datamanager
		---| typename_binary
		---| typename_radiobutton
		---| typename_checkbox
		---| typename_classicCheckbox
		---| typename_selectorBinary
		---| typename_selector
		---| typename_radiogroup
		---| typename_dropdownRadiogroup
		---| typename_anchorSelector
		---| typename_horizontalitySelector
		---| typename_verticalitySelector
		---| typename_strataSelector
		---| typename_fontSelector
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

	--| Returns

	---Return the `true` if the object is a widget (and optionally also of `typename`)
	---@alias IsWidget_return boolean

	return false
end


--[[ CONSTRUCT ]]

---Create a basic construct instance
---@param t construct_options
---@return construct
function wt.CreateConstruct(t)

	--| Parameters

	---@class construct_options
	---@field listeners? construct_listeners Table of key, value pairs of custom event tags and functions to assign as event handlers to call on trigger
	---@field properties? table<any, any> Default list of custom instance properties, unique property key and value pairs to assign

		---@class construct_listeners
		---@field [1]? table<eventTag, widget_listener[]> Table of key, value pairs of unique event identifier tags to register as custom events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? construct_listener_assigned[] Ordered list of functions to call when an "assigned" event is invoked after `construct:SetProperty(...)` was called

			---Unique event identifier tag
			---@alias eventTag string

			---@class construct_listener : indexedEventHandler
			---@field handler eventHandler Handler function to register for call

				---@class indexedEventHandler
				---@field callIndex? eventHandlerCallIndex

					---Set when to call the handler function in the execution order | ***Default:*** *last position*
					---@alias eventHandlerCallIndex integer?

				---Called when a custom event is invoked
				---@alias eventHandler fun(self: construct_self, ...: any)

					---Reference to the construct instance table
					---@alias construct_self construct

			---@class construct_listener_assigned : indexedEventHandler
			---@field handler construct_handler_assigned Handler function to register for call

				---Called when an "assigned" event is invoked after `construct:SetProperty(...)` was called
				---@alias construct_handler_assigned fun(self: construct_self, property: any, value: any)

	--| Returns

	local _ = {} ---@class construct

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, }
		function _:GetTypes() return {} end

			---@alias typename_construct "Construct"

		---Checks and returns if the type of this contruct matches the name provided
		---@param typename construct_IsType_typename WidgetTools typename to check if this instance is of this specific type
		---@return boolean
		function _:IsType(typename)

			--| Parameters

			---WidgetTools typename to check if this instance is of this specific type
			---@alias construct_IsType_typename typename|typename_construct

			return false
		end

		--[ Events ]

		---Add a new custom event to register listeners for, and invoke manually to call registered handlers
		---@param event eventTag Unique event identifier tag
		function _:AddEvent(event) end

		---Invoke a custom event to notify registered listeners and call handlers, passing arguments along
		---@param event eventTag Unique event identifier tag
		---@param ... any Leftover arguments to pass to event handlers as payload
		function _:Invoke(event, ...) end

		---Register a listener for a custom event to call the specified handler on trigger
		---@param event eventTag Unique event identifier tag
		---@param handler eventHandler Called when a custom event is invoked
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener(event, handler, callIndex) end

		---Register a listener for an "assigned" event to call the specified handler on trigger
		---@param handler construct_handler_assigned Called when an "assigned" event is invoked after `construct:SetProperty(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_assigned(handler, callIndex) end

		--[ Properties ]

		---Set a custom instance property
		---@param property any
		---@param value any
		---@param silent boolean? If `false`, invoke an "assigned" event and call registered listeners | ***Default:*** `false`
		function _:SetProperty(property, value, silent) end

		---Get the value of a custom instance property
		---@param property any
		function _:GetProperty(property) end

	return _
end


--[[ WIDGET ]]

---Create a basic non-GUI parentable widget instance with typename, event callback, child widget, enabled state and dependency management logic
---@param t? widget_options Optional parameters
---@return widget widget Reference to the new widget, utility functions and more wrapped in a widget table
function wt.CreateWidget(t)

	--| Parameters

	---Optional parameters
	---@class widget_options : construct_options, togglableObject
	---@field parent? widget Reference to the widget to set as the parent | ***Default:*** `nil` *no parent*
	---@field independent? boolean If `true`, keep the enabled state of this widget unlinked from the enabled state of its parent (when parented) | ***Default:*** `false`
	---@field childIndex? integer If set, add this widget at the specified order index in the current list of children of `parent` (if set) | ***Default:*** *last position*
	---@field listeners? widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class togglableObject
		---@field disabled? boolean If `true`, set the state of this widget to be disabled during initialization | ***Default:*** `false`<ul><li>***Note:*** Dependency rule evaluations may re-enable the widget after initialization.</li></ul>
		---@field dependencies? dependencyRule[] Automatically enable or disable the widget based on the set of rules described in subtables

			---@class dependencyRule
			---@field dependency dependencyType Tie the enabled state of the widget to this widget based on the specified directives
			---@field isData? boolean If `true`, tie the enabled state of the widget to the evaluation of the value of the data management `dependency`, or tie it to the enabled state of the `dependency` | ***Default:*** `false`
			---@field evaluate? dependencyEvaluator Call this function to evaluate the current enabled state or data value of `dependency`, enabling the dependent widget when `true`, or disabling it when `false` is returned | ***Default:*** `nil` *no evaluation*<ul><li>***Note:*** `evaluate` must be defined if `isData` is `true` and `dependency` is not a binary datamanager.</li>
			---@field index? integer The ordering index of the dependency to be checked in the list of all dependencies | ***Default:*** *append to the end of the list*

				---@alias dependencyType
				---| widget
				---| datamanager
				---| CheckButton
				---| EditBox
				---| Slider

				---@alias dependencyEvaluator fun(value?: any): evaluation: boolean

		---@class widget_listeners
		---@field [1]? table<eventTag, widget_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? widget_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `widget:SetEnabled(...)` was called
		---@field parent? widget_listener_parent[]
		---@field child? widget_listener_child[]

			---@class widget_listener : indexedEventHandler
			---@field handler widget_handler Handler function to register for call

				---Called when a custom event is invoked
				---@alias widget_handler fun(self: widget_self, ...: any)

					---Reference to the widget instance table
					---@alias widget_self widget

			---@class widget_listener_enabled : indexedEventHandler
			---@field handler widget_handler_enabled Handler function to register for call

				---Called when an "enabled" event is invoked after `widget:SetEnabled(...)` was called
				---@alias widget_handler_enabled fun(self: widget_self, state: widget_handler_enabled_state, user: widget_handler_enabled_user)

					---`true` if the widget is enabled
					---@alias widget_handler_enabled_state boolean

					---`true` if the event was flagged as invoked by an action taken by the user
					---@alias widget_handler_enabled_user boolean

			---@class widget_listener_parent : indexedEventHandler
			---@field handler widget_handler_parent Handler function to register for call

				---Called when an "parent" event is invoked after `widget:SetParent(...)` was called
				---@alias widget_handler_parent fun(self: widget_self, parent: widget)

			---@class widget_listener_child : indexedEventHandler
			---@field handler widget_handler_child Handler function to register for call

				---Called when a "child" event is invoked after `widget:AddChild(...)` or `widget:RemoveChild(...)` was called
				---@alias widget_handler_child fun(self: widget_self, child: widget, removal: boolean?)


	--| Returns

	local _ = {} ---@class widget : construct

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, }
		function _:GetTypes() return {} end

			---@alias typename_widget "Widget"

		--[ Events ]

		---Register a listener for a custom event to call the specified handler on trigger
		---@param event eventTag Unique event identifier tag
		---@param handler widget_handler Called when a custom event is invoked
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener(event, handler, callIndex) end

		---Register a listener for an "enabled" event to call the specified handler on trigger
		---@param handler widget_handler_enabled Called when an "enabled" event is invoked after `widget:SetEnabled(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_enabled(handler, callIndex) end

		--[ Hierarchy ]

		--| Child

		---Return the parent of this widget
		---@return widget|nil parent Reference to widget set as the parent | ***Default:*** `nil` *no parent is set*
		function _:GetParent() end

		---Set the parent of this widget (replacing the current parent if set)
		---@param parent widget? Reference to the widget to set as the new parent, or `nil` to remove the current parent | ***Default:*** `nil`
		--- - ***Note:*** If the direct parent or any ancestor of this widget is already set to `parent`, it will not be added again, ignoring `independent` & `index`.
		---@param independent? boolean If `true`, unlink the enabled state of this widget from the enabled state of `parent` by toggling its independency on | ***Default:*** `false`
		---@param index? integer If set, add this widget at the specified order index in the current list of children | ***Default:*** *last position*
		---@return boolean # `true` on success, `false` if `parent` was invalid
		---@return integer|nil # The current order index this widget was placed at | ***Default:*** `nil` *parent was not set*
		function _:SetParent(parent, independent, index) return false end

		---Check if this widget is set as independent and its enabled state is unlinked from the enabled state of its parent when parented
		---@return boolean
		function _:IsIndependent() return false end

		---Set whether to keep the enabled state of this widget unlinked from the enabled state of its parent when parented
		---@param independent? boolean ***Default:*** `true`
		function _:SetIndependent(independent) end

		--| Parent

		---Check if the specified widget is a child of this widget
		---@param child any
		---@return boolean
		function _:HasChild(child) return false end

		---Return a child at the specified order index
		---@param index integer
		---@return widget? child Reference to the child at `index` in the current list of children | ***Default:*** `nil` *no child found*
		function _:GetChild(index) end

		---Get a copy of the current list of children
		---@return widget[] children Ordered array of child widget references
		function _:GetChildren() return {} end

		---Assign a new child to this widget
		---@param child widget Reference to the widget to add
		--- - ***Note:*** If `child` was already added, it will not be added again, ignoring `independent` & `index`, returning `nil`.
		---@param independent? boolean If `true`, unlink the enabled state of `child` from the enabled state of this widget by toggling its independency on | ***Default:*** `false`
		---@param index? integer If set, add `child` at the specified order index in the current list of children | ***Default:*** *last position*
		--- - ***Note:*** Ordering indexes can shift as new children get injected or removed, but relative order is always preserved.
		---@return boolean # `true` on success, `false` if `child` was invalid
		---@return integer|nil # The current order index `child` was placed at | ***Default:*** `nil` *child was not added*
		function _:AddChild(child, independent, index) return false end

		---Remove a child from this widget
		---@param child widget Reference to the child widget to unassign
		function _:RemoveChild(child) end

		--[ State ]

		---Return the current enabled state of the widget
		---@return widget_isEnabled_return_enabled enabled `true` if the widget is enabled
		function _:IsEnabled()

			--| Returns

			---`true` if the widget is enabled
			---@alias widget_isEnabled_return_enabled boolean

			return false
		end

		---Set the enabled state of this widget
		---@param state widget_setEnabled_param_state Enable the input if `true`, disable if not | ***Default:*** `true`
		--- - ***Note:*** By default, `state` is overruled by the enabled state of the parent of this widget (if the relationship is not marked as independent) and the evaluation of all of the currently set dependencies of this widget.
		---@param ignoreParent widget_setEnabled_param_ignoreParent If `true`, ignore the enabled state of the parent of this widget (if set) even when the relationship is not independent | ***Default:*** `false`
		---@param ignoreDependencies widget_setEnabled_param_ignoreDependencies If `true`, force the state change ignoring and overruling all dependencies | ***Default:*** `false`
		---@param user widget_setEnabled_param_user If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent widget_setEnabled_param_silent If `false`, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _:SetEnabled(state, ignoreParent, ignoreDependencies, user, silent)

			--| Parameters

			---Enable the input if `true`, disable if not | ***Default:*** `true`
			--- - ***Note:*** By default, `state` is overruled by the enabled state of the parent of this widget (if the relationship is not marked as independent) and the evaluation of all of the currently set dependencies of this widget.
			---@alias widget_setEnabled_param_state boolean?

			---If `true`, ignore the enabled state of the parent of this widget (if set) even when the relationship is not independent | ***Default:*** `false`
			---@alias widget_setEnabled_param_ignoreParent boolean?

			---If `true`, force the state change ignoring and overruling all dependencies | ***Default:*** `false`
			---@alias widget_setEnabled_param_ignoreDependencies boolean?

			---If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
			---@alias widget_setEnabled_param_user boolean?

			---If `false`, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
			---@alias widget_setEnabled_param_silent boolean?
		end

		--| Dependencies

		---Add a new dependency tying the enabled state of the widget to specified dependency based on the specified rules
		---@param rule dependencyRule
		---@return boolean success `true` if the provided `rule` passed verification and the dependency was registered
		function _:AddDependency(rule) return false end

		---Replace all registered dependencies of this widget with the provided dependency rule list
		---@param rules? dependencyRule[] ***Default:*** `nil` *clear all current dependencies*
		function _:SetDependencies(rules) end

		---Check and evaluate all dependencies of this widget
		---@return boolean # `false` if any of the currently set dependencies evaluate to `false`, `true` if none do
		function _:CheckDependencies() return false end

	return _
end


--[[ LIST ]]

---Create a non-GUI list widget instance managing an ordered array of member items, assigning, creating, deactivating & reactivating child widgets of a specific type
---@param typenameItem typename Typename string to filter the children of this widget by to determine whether to assign them as list items
---@param count? integer Number of items to have in the list | ***Default:*** *no limit*
---@param t? list_options Optional parameters
---@return list list Reference to the new list instance, utility functions and more wrapped in a widget table
function wt.CreateList(typenameItem, count, t)

	--| Parameters

	---Optional parameters
	---@class list_options : widget_options
	---@field listeners? list_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class list_listeners : widget_listeners
		---@field added? list_listener_added[] Ordered list of functions to call when an "added" event is invoked after a child widget got list membership
		---@field removed? list_listener_removed[] Ordered list of functions to call when a "removed" event is invoked after a child widget lost list membership
		---@field updated? list_listener_updated[] Ordered list of functions to call when an "updated" event is invoked after `list:SetCount(...)` was called
		---@field enabled? list_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `list:SetEnabled(...)` was called
		---@field [1]? table<string, list_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked

			---@class list_listener_added : indexedEventHandler
			---@field handler list_handler_added Handler function to register for call

				---@alias list_handler_added
				---| fun(self: list, item: widget) Called when an "added" event is invoked after a child widget got list membership<p>@*param* `self` list ― Reference to the list widget instance</p><p>@*param* `item` widget ― Reference to the child widget item instance</p>

			---@class list_listener_removed : indexedEventHandler
			---@field handler list_handler_removed Handler function to register for call

				---@alias list_handler_removed
				---| fun(self: list, item: widget) Called when a "removed" event is invoked after a child widget lost list membership<p>@*param* `self` list ― Reference to the list widget instance</p><p>@*param* `item` widget ― Reference to the child widget item instance</p>

			---@class list_listener_updated : indexedEventHandler
			---@field handler list_handler_recounted Handler function to register for call

				---@alias list_handler_recounted
				---| fun(self: list, count: integer) Called when an "recounted" event is invoked after `list:SetCount(...)` was called<p>@*param* `self` list ― Reference to the list widget instance</p>

			---@class list_listener_enabled : indexedEventHandler
			---@field handler list_handler_enabled Handler function to register for call

				---Called when an "enabled" event is invoked after `list:SetEnabled(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `state` ― `true` if the widget is enabled</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias list_handler_enabled fun(self: list, state: boolean, user: boolean)

			---@class list_listener : indexedEventHandler
			---@field handler list_handler Handler function to register for call

				---Called when a custom event is invoked<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `...` — Any leftover arguments</p>
				---@alias list_handler fun(self: list, ...: any)

	--| Returns

	---@class list : widget
	local _ = {}

		---Set the number of items and update the list, adding new, removing unneeded or reusing existing inactive child widgets matching the filtered type of this list
		---@param count? integer Number of items to have in the list | ***Default:*** *no limit*
		---@param silent? boolean If `false`, invoke "updated" and "added" events and call registered listeners | ***Default:*** `false`
		function _:SetCount(count, silent) end

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_list]: true, }
		function _:GetTypes() return {} end

			---@alias typename_list "List"

		--[ Events ]


	return _
end


--[[ CONTAINER ]]

---Create a basic GUI container instance
---@param t? container_options Optional parameters
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return container|widget container References to the new container [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a widget table
function wt.CreateContainer(t, lite)

	--| Parameters

	---Optional parameters
	---@class container_options : widget_options, namedChildFrame, positionableScreenFrame, arrangeableFrame, visibleFrame, initializableContainerFrame, eventFrame
	---@field name? frameName ***Default:*** `"Container"`
	---@field append? boolean When setting the name, append `t.name` to the name of `t.parent` instead | ***Default:*** `true` if `t.name` ~= nil and `t.parent` ~= nil and `t.parent` ~= `UIParent`
	---@field width? nonNegativeNumber ***Default:*** `t.parent` and *width of the parent frame* or `0`<ul><li>***Note:*** Setting to 0 will result in the frame not being placed on the screen.</li></ul>
	---@field height? nonNegativeNumber ***Default:*** `0`<ul><li>***Note:*** If content is added, arranged and `t.arrangement.resize` is `true`, the height will be set dynamically based on the calculated height of the content.</li></ul>
	---@field listeners? container_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field arrangement? arrangementRules_container If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table
	---@field initialize? fun(container: container, canvas?: Frame, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<p>@*param* `container` container ― Reference to the container to be set as the parent for child objects created during initialization</p><p>@*param* `width` number The current width of the container frame (0 if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `height` number The current height of the container frame (0 if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

		---@class namedChildFrame : childFrame
		---@field name? frameName ***Default:*** `"Frame"`
		---@field append? boolean Instead of setting the specified name by itself, append it to the name of the specified parent frame | ***Default:*** `true` if t.parent ~= `UIParent`

			---@class childFrame
			---@field parentFrame? AnyFrameObject Reference to the frame to set as the parent

		---@class container_listeners : widget_listeners
		---@field [1]? table<string, container_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? container_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `container:SetEnabled(...)` was called

			---@class container_listener_enabled : indexedEventHandler
			---@field handler container_handler_enabled Handler function to register for call

				---Called when an "enabled" event is invoked after `container:SetEnabled(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `state` ― `true` if the widget is enabled</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias container_handler_enabled fun(self: container, state: boolean, user: boolean)

			---@class container_listener : indexedEventHandler
			---@field handler container_handler Handler function to register for call

				---Called when a custom event is invoked<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `...` — Any leftover arguments</p>
				---@alias container_handler fun(self: container, ...: any)

		---@class arrangementRules_container : arrangementRules
		---@field margins? spacingData_container Inset the content inside the container frame by the specified amount on each side
		---@field gaps? number The amount of space to leave between rows and items within rows | ***Default:*** 8
		---@field flip? boolean Fill the rows from right to left instead of left to right | ***Default:*** `false`
		---@field resize? boolean Set the height of the container frame to match the space taken up by the arranged content (including margins) | ***Default:*** `true`

			---@class spacingData_container : spacingData
			---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** `t.description` and 30 or 12

	---If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
	---@alias liteFlag boolean?

	--| Returns

	---@class container : widget, guiFrame
	local _ = {}

		---@class guiFrame
		---@field frame Frame Widget GUI parent frame

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_container]: true, }
		function _:GetTypes() return {} end

			---@alias typename_container "Container"

		--[ Events ]


	return _
end

---Create a basic GUI container instance with customizable UI elements
---@param t? container_options Optional parameters
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return customContainer|widget container References to the new customizable container [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a widget table
function wt.CreateCustomContainer(t, lite)

	--| Parameters

	---Optional parameters
	---@class customContainer_options : container_options, backdropData
	---@field background? backdropBackgroundData_customContainer Table containing the parameters used for the background
	---@field border? backdropBorderData_customContainer Table containing the parameters used for the border
	---@field listeners? customContainer_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field arrangement? arrangementRules_customContainer If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table
	---@field initialize? fun(container: customContainer, canvas?: Frame|BackdropTemplate, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<p>@*param* `container` container|customContainer ― Reference to the container to be set as the parent for child objects created during initialization</p><p>@*param* `width` number The current width of the container frame (0 if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `height` number The current height of the container frame (0 if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

		---@class customContainer_listeners : widget_listeners
		---@field [1]? table<string, customContainer_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? customContainer_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `customContainer:SetEnabled(...)` was called

			---@class customContainer_listener_enabled : indexedEventHandler
			---@field handler customContainer_handler_enabled Handler function to register for call

				---Called when an "enabled" event is invoked after `customContainer:SetEnabled(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `state` ― `true` if the widget is enabled</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias customContainer_handler_enabled fun(self: customContainer, state: boolean, user: boolean)

			---@class customContainer_listener : indexedEventHandler
			---@field handler customContainer_handler Handler function to register for call

				---Called when a custom event is invoked<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `...` — Any leftover arguments</p>
				---@alias customContainer_handler fun(self: customContainer, ...: any)

		---@class backdropBackgroundData_customContainer
		---@field texture? backdropBackgroundTextureData_customContainer Parameters used for setting the background texture
		---@field color? backgroundColorData_customContainer Apply the specified color to the background texture

			---@class backdropBackgroundTextureData_customContainer : backdropBackgroundTextureData
			---@field size? number Size of a single background tile square | ***Default:*** 5
			---@field insets? insetData_customContainer Offset the position of the background texture from the edges of the frame inward

				---@class insetData_customContainer
				---@field l? number Left side | ***Default:*** 4
				---@field r? number Right side | ***Default:*** 4
				---@field t? number Top | ***Default:*** 4
				---@field b? number Bottom | ***Default:*** 4

			---@class backgroundColorData_customContainer
			---@field r? normalizedNumber Red | ***Default:*** `0.175`
			---@field g? normalizedNumber Green | ***Default:*** `0.175`
			---@field b? normalizedNumber Blue | ***Default:*** `0.175`
			---@field a? normalizedNumber Opacity | ***Default:*** `0.65`

		---@class backdropBorderData_customContainer
		---@field texture? backdropBorderTextureData_customContainer Parameters used for setting the border texture
		---@field color? borderColorData_customContainer Apply the specified color to the border texture

			---@class backdropBorderTextureData_customContainer : backdropBorderTextureData
			---@field width? nonNegativeNumber Width of the backdrop edge | ***Default:*** 16

			---@class borderColorData_customContainer
			---@field r? normalizedNumber Red | ***Default:*** `0.75`
			---@field g? normalizedNumber Green | ***Default:*** `0.75`
			---@field b? normalizedNumber Blue | ***Default:*** `0.75`
			---@field a? normalizedNumber Opacity | ***Default:*** `0.5`

		---@class arrangementRules_customContainer : arrangementRules
		---@field margins? spacingData_customContainer Inset the content inside the container frame by the specified amount on each side
		---@field gaps? number The amount of space to leave between rows and items within rows | ***Default:*** 8
		---@field flip? boolean Fill the rows from right to left instead of left to right | ***Default:*** `false`
		---@field resize? boolean Set the height of the container frame to match the space taken up by the arranged content (including margins) | ***Default:*** `true`

			---@class spacingData_customContainer : spacingData
			---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** `t.description` and 30 or 12

	--| Returns

	---@class customContainer : container
	---@field frame Frame|BackdropTemplate Widget GUI customizable parent frame with BackdropTemplate
	local __ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_customContainer]: true, }
		function __:GetTypes() return {} end

			---@alias typename_customContainer "CustomContainer"

		--[ Events ]


	return _
end

--[ Panel ]

---Create a GUI container panel instance with customized panel UI
---@param t? panel_options Optional parameters
---@param ancestor? customContainer Reference to an already existing custom container instance to turn into a panel instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return panel|widget panel References to the new panel [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a widget table
function wt.CreatePanel(t, ancestor, lite)

	--| Parameters

	---Optional parameters
	---@class panel_options : customContainer_options, labeledChildFrame, describableFrame, positionableScreenFrame, arrangeableFrame, visibleFrame, backdropData, eventFrame
	---@field name? frameName ***Default:*** `"Panel"`
	---@field width? nonNegativeNumber ***Default:*** `t.parent` and *width of the parent frame* - 20 or `0`
	---@field height? nonNegativeNumber ***Default:*** `0`<ul><li>***Note:*** If content is added, arranged and `t.arrangeContent.resize` is `true`, the height will be set dynamically based on the calculated height of the content.</li></ul>
	---@field background? backdropBackgroundData_panel Table containing the parameters used for the background
	---@field border? backdropBorderData_panel Table containing the parameters used for the border
	---@field listeners? panel_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field arrangement? arrangementRules_panel If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table
	---@field initialize? fun(container: panel, canvas?: Frame|BackdropTemplate, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<p>@*param* `container` container|panel ― Reference to the container to be set as the parent for child objects created during initialization</p><p>@*param* `width` number The current width of the container frame (0 if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `height` number The current height of the container frame (0 if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

		---@class panel_listeners : widget_listeners
		---@field [1]? table<string, panel_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? panel_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `panel:SetEnabled(...)` was called

			---@class panel_listener_enabled : indexedEventHandler
			---@field handler panel_handler_enabled Handler function to register for call

				---Called when an "enabled" event is invoked after `panel:SetEnabled(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `state` ― `true` if the widget is enabled</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias panel_handler_enabled fun(self: panel, state: boolean, user: boolean)

			---@class panel_listener : indexedEventHandler
			---@field handler panel_handler Handler function to register for call

				---Called when a custom event is invoked<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `...` — Any leftover arguments</p>
				---@alias panel_handler fun(self: panel, ...: any)

		---@class labeledChildFrame : titledChildObject, labeledObject_base

			---@class titledChildObject : namedChildFrame, titledObject_base

				---@class titledObject_base
				---@field title? string Text to be displayed as the title | ***Default:*** `t.name`

			---@class labeledObject_base
			---@field label? boolean Whether to show the title textline or not | ***Default:*** `true`

		---@class describableFrame
		---@field description? string Text to be displayed as the subtitle or description | ***Default:*** *no description textline shown*

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
			---@field r? normalizedNumber Red | ***Default:*** `0.175`
			---@field g? normalizedNumber Green | ***Default:*** `0.175`
			---@field b? normalizedNumber Blue | ***Default:*** `0.175`
			---@field a? normalizedNumber Opacity | ***Default:*** `0.65`

		---@class backdropBorderData_panel
		---@field texture? backdropBorderTextureData_panel Parameters used for setting the border texture
		---@field color? borderColorData_panel Apply the specified color to the border texture

			---@class backdropBorderTextureData_panel : backdropBorderTextureData
			---@field width? nonNegativeNumber Width of the backdrop edge | ***Default:*** 16

			---@class borderColorData_panel
			---@field r? normalizedNumber Red | ***Default:*** `0.75`
			---@field g? normalizedNumber Green | ***Default:*** `0.75`
			---@field b? normalizedNumber Blue | ***Default:*** `0.75`
			---@field a? normalizedNumber Opacity | ***Default:*** `0.5`

		---@class arrangementRules_panel : arrangementRules
		---@field margins? spacingData_panel Inset the content inside the container frame by the specified amount on each side
		---@field gaps? number The amount of space to leave between rows and items within rows | ***Default:*** 8
		---@field flip? boolean Fill the rows from right to left instead of left to right | ***Default:*** `false`
		---@field resize? boolean Set the height of the container frame to match the space taken up by the arranged content (including margins) | ***Default:*** `true`

			---@class spacingData_panel : spacingData
			---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** `t.description` and 30 or 12

	--| Returns

	---@class panel : customContainer
	---@field title? FontString Reference to the title textline appearing above the panel
	---@field description? FontString Reference to the description textline appearing in the panel
	local _ = {}

	--[ Types ]

	---Returns the type list of this widget
	---@return { [typename_construct]: true, [typename_widget]: true, [typename_panel]: true, }
	function _:GetTypes() return {} end

		---@alias typename_panel "Panel"

	--[ Events ]

	---@class panel_addListener : widget_addListener
	---@field [string] fun(handler: panel_handler, callIndex?: integer) Register a listener for a custom widget event
	local addListener = {}

		---Register a listener for an "enabled" widget event
		---@param handler panel_handler_enabled Handler function to call on trigger
		---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
		function _:AddListener_enabled(handler, callIndex) end

	return _
end


--[[ ACTION ]]

---Create a non-GUI action widget instance with custom trigger logic
---@param t? action_options Optional parameters
---@return action action Reference to the new action instance, utility functions and more wrapped in a widget table
function wt.CreateAction(t, ancestor)

	--| Parameters

	---Optional parameters
	---@class action_options : widget_options
	---@field action? fun(self: action, user?: boolean) Function to call when the action is triggered<p>@*param* `self` action — Reference to the widget table</p><p>@*param* `user`? boolean — Marking whether the call is due to a user interaction or not | ***Default:*** `false`</p>
	---@field listeners? action_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class action_listeners : widget_listeners
		---@field [1]? table<string, action_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field triggered? action_listener_triggered[] Ordered list of functions to call when a "triggered" event is invoked after `action:trigger(...)` was called
		---@field enabled? action_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `action:SetEnabled(...)` was called

			---@class action_listener_triggered : indexedEventHandler
			---@field handler action_handler_triggered Handler function to register for call

				---Called when a "triggered" event is invoked after `action:trigger(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias action_handler_triggered fun(self: action, user: boolean)

			---@class action_listener_enabled : indexedEventHandler
			---@field handler action_handler_enabled Handler function to register for call

				---Called when an "enabled" event is invoked after `action:SetEnabled(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `state` ― `true` if the widget is enabled</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias action_handler_enabled fun(self: action, state: boolean, user: boolean)

			---@class action_listener : indexedEventHandler
			---@field handler action_handler Handler function to register for call

				---Called when a custom event is invoked<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `...` — Any leftover arguments</p>
				---@alias action_handler fun(self: action, ...: any)

	--| Returns

	---@class action : widget
	local _ = {}

		---Trigger the registered action (if the widget is enabled)
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "trigger" event and call registered listeners | ***Default:*** `false`
		function _:Trigger(user, silent) end

		---Set the function to call on trigger
		---@param call action_setAction_param1
		function _:SetAction(call)

			--| Parameters

			---Function to call when the action is triggered<p>@*param* `self` — Reference to the widget table</p><p>@*param* `user` — Marking whether the call is due to a user interaction or not | ***Default:*** `false`</p>
			---@alias action_setAction_param1 fun(self: action, user?: boolean)
		end

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_action]: true, }
		function _:GetTypes() return {} end

			---@alias typename_action "Action"

		--[ Events ]

		---Register a listener for a custom event to call the specified handler on trigger
		---@param event eventTag Unique event identifier tag
		---@param handler action_handler Called when a custom event is invoked
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener(event, handler, callIndex) end

		---Register a listener for an "enabled" event to call the specified handler on trigger
		---@param handler action_handler_enabled Called when an "enabled" event is invoked after `action:SetEnabled(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_enabled(handler, callIndex) end

		---Register a listener for a "triggered" event to call the specified handler on trigger
		---@param handler action_handler_triggered Called when a "triggered" event is invoked after `action:trigger(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_triggered(handler, callIndex) end

	return _
end

--[ Button ]

---Create a Blizzard button GUI frame instance with enhanced widget functionality
---@param t? actionButton_options Optional parameters
---@param ancestor? action Reference to an already existing action instance to turn into a button instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return actionButton|action # References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a widget table
function wt.CreateButton(t, ancestor, lite)

	--| Parameters

	---Optional parameters
	---@class actionButton_options : action_options, labeledChildFrame, tooltipDescribableWidget, arrangeableFrame, positionableFrame, visibleFrame, eventFrame
	---@field name? frameName ***Default:*** `"Button"`
	---@field titleOffset? offsetData Offset the position of the label of the button
	---@field width? nonNegativeNumber ***Default:*** `80`
	---@field height? nonNegativeNumber ***Default:*** `22`
	---@field font? labelFontOptions_highlight
	---@field action? fun(self: actionButton, user?: boolean) Function to call when the action is triggered<p>@*param* `self` actionButton — Reference to the widget table</p><p>@*param* `user`? boolean — Marking whether the call is due to a user interaction or not | ***Default:*** `false`</p>
	---@field listeners? button_listeners|action_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field events? scriptHandlers_Button

		---List of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label | ***Default:*** *normal sized default Blizzard UI fonts*
		--- - ***Note:*** A new font object (or a modified copy of an existing one) can be created via <code><i>WidgetToolbox</i>.CreateFont(...)</code> (even within this table definition).
		---@class labelFontOptions_highlight
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** `"GameFontNormal"`
		---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is being hovered | ***Default:*** `"GameFontHighlight"`
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** `"GameFontDisable"`

		---@class button_listeners : action_listeners
		---@field [1]? table<string, button_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field trigger? button_listener_triggered[] Ordered list of functions to call when a "triggered" event is invoked after `button:trigger(...)` was called
		---@field enabled? button_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `button:SetEnabled(...)` was called

			---@class button_listener_triggered : indexedEventHandler
			---@field handler button_handler_triggered Handler function to register for call

				---Called when a "triggered" event is invoked after `button:trigger(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an button taken by the user</p>
				---@alias button_handler_triggered fun(self: actionButton)

			---@class button_listener_enabled : indexedEventHandler
			---@field handler button_handler_enabled Handler function to register for call

				---Called when an "enabled" event is invoked after `button:SetEnabled(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `state` ― `true` if the widget is enabled</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias button_handler_enabled fun(self: actionButton, state: boolean, user: boolean)

			---@class button_listener : indexedEventHandler
			---@field handler button_handler Handler function to register for call

				---Called when a custom event is invoked<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `...` — Any leftover arguments</p>
				---@alias button_handler fun(self: actionButton, ...: any)

		--- - ***Note:*** Use `t.onEvent` to set [`"OnEvent"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) handlers for global events.
		--- - ***Note:*** Use `t.attributes` to set [`"OnAttributeChanged"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) handlers for custom frame attribute change events.
		--- - ***Note:*** `t.action` will automatically be called when an [`"OnClick"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick) widget events, there is no need to register it here as well.
		---@alias buttonEvents scriptHandlers_Button

	--| Returns

	---@class actionButton : action
	---@field label FontString|nil
	---@field highlight Frame Frame to catch mouse interactions and serve as a hover trigger to be able to show the tooltip or when the button is disabled
	---@field template Button
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_action]: true, [typename_button]: true, }
		function _:GetTypes() return {} end

			---@alias typename_button "Button"

		--[ Events ]

		---Register a listener for a custom event to call the specified handler on trigger
		---@param event eventTag Unique event identifier tag
		---@param handler button_handler Called when a custom event is invoked
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener(event, handler, callIndex) end

		---Register a listener for an "enabled" event to call the specified handler on trigger
		---@param handler button_handler_enabled Called when an "enabled" event is invoked after `button:SetEnabled(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_enabled(handler, callIndex) end

		---Register a listener for a "triggered" event to call the specified handler on trigger
		---@param handler button_handler_triggered Called when a "triggered" event is invoked after `button:trigger(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_triggered(handler, callIndex) end

		--[ Action ]

		---Set the function to call on trigger
		---@param call button_setAction_param1
		function _:SetAction(call)

			--| Parameters

			---Function to call when the action is triggered<p>@*param* `self` — Reference to the widget table</p><p>@*param* `user` — Marking whether the call is due to a user interaction or not | ***Default:*** `false`</p>
			---@alias button_setAction_param1 fun(self: actionButton, user?: boolean)
		end

	return _
end

---Create a Blizzard button GUI frame instance with customizable UI elements and enhanced widget functionality
---@param t? customButton_options Optional parameters
---@param ancestor? action Reference to an already existing action instance to turn into a custom button instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return customButton|action # References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button) (inheriting [BackdropTemplate](https://warcraft.wiki.gg/wiki/BackdropTemplate)), utility functions and more wrapped in a widget table
function wt.CreateCustomButton(t, ancestor, lite)

	--| Parameters

	---Optional parameters
	---@class customButton_options : actionButton_options, customizableObject
	---@field font? labelFontOptions_small_highlight Table of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label | ***Default:*** *small default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via <code><i>WidgetToolbox</i>.CreateFont(...)</code> (even within this table definition).</li></ul>
	---@field action? fun(self: customButton, user?: boolean) Function to call when the action is triggered<p>@*param* `self` customButton — Reference to the widget table</p><p>@*param* `user`? boolean — Marking whether the call is due to a user interaction or not | ***Default:*** `false`</p>
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
		---@field [1]? table<string, customButton_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field trigger? customButton_listener_triggered[] Ordered list of functions to call when a "triggered" event is invoked after `customButton:trigger(...)` was called
		---@field enabled? customButton_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `customButton:SetEnabled(...)` was called

			---@class customButton_listener_triggered : indexedEventHandler
			---@field handler customButton_handler_triggered Handler function to register for call

				---Called when a "triggered" event is invoked after `customButton:trigger(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an customButton taken by the user</p>
				---@alias customButton_handler_triggered fun(self: customButton)

			---@class customButton_listener_enabled : indexedEventHandler
			---@field handler customButton_handler_enabled Handler function to register for call

				---Called when an "enabled" event is invoked after `customButton:SetEnabled(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `state` ― `true` if the widget is enabled</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias customButton_handler_enabled fun(self: customButton, state: boolean, user: boolean)

			---@class customButton_listener : indexedEventHandler
			---@field handler customButton_handler Handler function to register for call

				---Called when a custom event is invoked<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `...` — Any leftover arguments</p>
				---@alias customButton_handler fun(self: customButton, ...: any)

	--| Returns

	---@class customButton : actionButton
	---@field template Button|BackdropTemplate
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_action]: true, [typename_button]: true, [typename_customButton]: true, }
		function _:GetTypes() return {} end

			---@alias typename_customButton "CustomButton"

		--[ Events ]

		---Register a listener for a custom event to call the specified handler on trigger
		---@param event eventTag Unique event identifier tag
		---@param handler customButton_handler Called when a custom event is invoked
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener(event, handler, callIndex) end

		---Register a listener for an "enabled" event to call the specified handler on trigger
		---@param handler customButton_handler_enabled Called when an "enabled" event is invoked after `button:SetEnabled(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_enabled(handler, callIndex) end

		---Register a listener for a "triggered" event to call the specified handler on trigger
		---@param handler customButton_handler_triggered Called when a "triggered" event is invoked after `button:trigger(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_triggered(handler, callIndex) end

		--[ Action ]

		---Set the function to call on trigger
		---@param call customButton_setAction_param1
		function _:SetAction(call)

			--| Parameters

			---Function to call when the action is triggered<p>@*param* `self` — Reference to the widget table</p><p>@*param* `user` — Marking whether the call is due to a user interaction or not | ***Default:*** `false`</p>
			---@alias customButton_setAction_param1 fun(self: customButton, user?: boolean)
		end

	return _
end


--[[ DATAMANAGER ]]

---Create a non-GUI datamanager widget instance with generic data management logic
---@param t? datamanager_options Optional parameters
---@return datamanager datamanager Reference to the new datamanager widget, utility functions and more wrapped in a widget table
function wt.CreateDatamanager(t)

	--| Parameters

	---Optional parameters
	---@class datamanager_options : widget_options
	---@field listeners? datamanager_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field value? any The starting state of the widget to set during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid
	---@field default? any Default value of the widget | ***Default:*** `nil`
	---@field reader? datamanager_reader
	---@field writer? datamanager_writer
	---@field instantSave? boolean Immediately commit the data to storage whenever it's changed via the widget | ***Default:*** `true`
	---@field dataManagement? settingsData If set, register this widget to settings data management for batched data saving & loading and handling data changes

		---@class datamanager_listeners : widget_listeners
		---@field [1]? table<string, datamanager_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? datamanager_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? datamanager_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? datamanager_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `datamanager:SetValue(...)` was called
		---@field enabled? datamanager_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `datamanager:SetEnabled(...)` was called

			---@class datamanager_listener_loaded : indexedEventHandler
			---@field handler datamanager_handler_loaded Handler function to register for call

				---Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `success` ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>
				---@alias datamanager_handler_loaded fun(self: datamanager, success: boolean)

			---@class datamanager_listener_saved : indexedEventHandler
			---@field handler datamanager_handler_saved Handler function to register for call

				---Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `success` ― `true` if data was committed successfully via `t.data.write(...)`</p>
				---@alias datamanager_handler_saved fun(self: datamanager, success: boolean)

			---@class datamanager_listener_changed : indexedEventHandler
			---@field handler datamanager_handler_changed Handler function to register for call

				---Called when a "changed" event is invoked after `datamanager:SetValue(...)` was called<p>@*param* `self` ― Reference to the binary widget</p><p>@*param* `value` ― Current value of the widget</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias datamanager_handler_changed fun(self: datamanager, value: any, user: boolean)

			---@class datamanager_listener_enabled : indexedEventHandler
			---@field handler datamanager_handler_enabled Handler function to register for call

				---Called when an "enabled" event is invoked after `datamanager:SetEnabled(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `state` ― `true` if the widget is enabled</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias datamanager_handler_enabled fun(self: datamanager, state: boolean, user: boolean)

			---@class datamanager_listener : indexedEventHandler
			---@field handler datamanager_handler Handler function to register for call

				---Called when a custom event is invoked<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `...` — Any leftover arguments</p>
				---@alias datamanager_handler fun(self: datamanager, ...: any)

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)<p>@*return* `data` — ***Default:*** `nil`</p>
		---@alias datamanager_reader fun(): data: datamanager_data

			---***Default:*** `nil`
			---@alias datamanager_data any

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)<p>@*param* `data` — ***Default:*** `nil`</p>
		---@alias datamanager_writer fun(data: datamanager_data)

		---@class settingsData
		---@field category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** `"WidgetTools"` *(register as a global rule)*
		---@field key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `""` *(category-wide rule)*
		---@field index? integer Set when to place this widget in the execution order when saving or loading batched settings data | ***Default:*** *last position*
		---@field onChange? table<string|integer, function|string> table<string|integer, function|string> List of new or already defined functions to call after the value of the widget was changed by the user or via settings data management<ul><li><code>[<i>key</i>]</code>? string|integer ― A unique string appended to `category` to point to a newly defined function to be added to settings data management or just the index of the next function name | ***Default:*** *next assigned index*</li><li><code>[<i>value</i>]</code> function|string ― The new function to register under its unique key, or the key of an already existing function</li><ul><li>***Note:*** Function definitions will be replaced by key references when they are registered to settings data management. Functions registered under duplicate keys are overwritten.</li></ul></ul>

	--| Returns

	---@class datamanager : widget
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, }
		function _:GetTypes() return {} end

			---@alias typename_datamanager "Datamanager"

		--[ Events ]

		---Register a listener for a custom event to call the specified handler on trigger
		---@param event eventTag Unique event identifier tag
		---@param handler datamanager_handler Called when a custom event is invoked
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener(event, handler, callIndex) end

		---Register a listener for an "enabled" event to call the specified handler on trigger
		---@param handler datamanager_handler_enabled Called when an "enabled" event is invoked after `datamanager:SetEnabled(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_enabled(handler, callIndex) end

		---Register a listener for a "loaded" widget event to call the specified handler on trigger
		---@param handler datamanager_handler_loaded Called when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_loaded(handler, callIndex) end

		---Register a listener for a "saved" widget event to call the specified handler on trigger
		---@param handler datamanager_handler_saved Called when an "saved" event is invoked after the data of this widget has been saved to storage
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_saved(handler, callIndex) end

		---Register a listener for a "changed" widget event to call the specified handler on trigger
		---@param handler datamanager_handler_changed Called when a "changed" event is invoked after `datamanager:SetValue(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_changed(handler, callIndex) end

		--[ Value ]

		---Validate a value to be accepted by the widget
		---@param value? datamanager_value_currentDefault ***Default:*** *current value*
		---@return datamanager_value
		function _:Verify(value) end

			---***Default:*** *current value*
			---@alias datamanager_value_currentDefault datamanager_value?

				---@alias datamanager_value any

		---Turn a value into a formatted string
		---@param value datamanager_value_currentDefault ***Default:*** *current value*
		---@return string
		function _:Format(value) return "" end

		---Returns the current value of the widget
		---@return datamanager_value
		function _:GetValue() end

		---Verify and set the value of the widget
		---@param value datamanager_value_readDefault ***Default:*** `t.data.read()` or *current default value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _:SetValue(value, handleChanges, user, silent) end

			---***Default:*** `t.data.read()` or *current default value*
			---@alias datamanager_value_readDefault datamanager_value?

		---Turn a value into a formatted string
		---@param value datamanager_value_currentDefault ***Default:*** *current value*
		---@return string
		function _:Format(value) return "" end

		--| Default

		---Get the currently set default value
		---@return datamanager_value
		function _:GetDefault() end

		---Set the default value
		---@param value datamanager_default ***Default:*** *current default value*
		function _:SetDefault(value) end

			---***Default:*** *current default value*
			---@alias datamanager_default any?

		---Set and load the stored data managed by the widget to the currently set default value
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:Reset(handleChanges, silent) end

		--| Snapshot

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value
		---@param stored? boolean If `true`, use the data from storage to create the snapshot instead of using the current value of the widget | ***Default:*** `false`
		function _:Snapshot(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:Revert(handleChanges, silent) end

		--[ Storage ]

		---Read the data from storage via the provided or the currently set reader utility then verify and load it to the widget
		---@param reader? datamanager_reader|false If set, call this function to read the data from storage (and convert, evaluate or modify it as needed), and set it as the default reader, or if `false`, clear the currently set reader to disconnect this widget from reading storage data | ***Default:*** *last used reader*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _:Load(reader, handleChanges, silent) end

		---Save the current value of the widget to storage via the provided or the currently set writer utility
		---@param writer? datamanager_writer|false If set, call this function to write the data to storage (and convert, evaluate or modify it as needed), and set it as the default writer, or if `false`, clear the currently set writer to disconnect this widget from writing storage data | ***Default:*** *last used writer*
		---@param silent? boolean If `false`, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _:Save(writer, silent) end

		---Set whether to immediately commit the data to storage whenever it's changed via the widget
		---@param instantSave boolean? ***Default:*** `true`
		function _:SetInstantSave(instantSave) end

	return _
end


--[[ BINARY ]]

---Create a non-GUI binary datamanager widget instance with boolean data management logic
---@param t? binary_options Optional parameters
---@return binary binary Reference to the new binary widget, utility functions and more wrapped in a widget table
function wt.CreateBinary(t)

	--| Parameters

	---Optional parameters
	---@class binary_options : datamanager_options
	---@field listeners? binary_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field value? boolean The starting state of the widget to set during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid
	---@field default? boolean Default value of the widget | ***Default:*** `false`

		---@class binary_listeners : datamanager_listeners
		---@field [1]? table<string, binary_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? binary_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? binary_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? binary_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `binary:SetState(...)` was called
		---@field enabled? binary_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `binary:SetEnabled(...)` was called

			---@class binary_listener_loaded : indexedEventHandler
			---@field handler binary_handler_loaded Handler function to register for call

				---Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `success` ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>
				---@alias binary_handler_loaded fun(self: binary, success: boolean)

			---@class binary_listener_saved : indexedEventHandler
			---@field handler binary_handler_saved Handler function to register for call

				---Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `success` ― `true` if data was committed successfully via `t.data.write(...)`</p>
				---@alias binary_handler_saved fun(self: binary, success: boolean)

			---@class binary_listener_changed : indexedEventHandler
			---@field handler binary_handler_changed Handler function to register for call

				---Called when a "changed" event is invoked after `binary:SetState(...)` was called<p>@*param* `self` ― Reference to the binary widget</p><p>@*param* `state` ― `true` if the widget is enabled</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias binary_handler_changed fun(self: binary, state: boolean, user: boolean)

			---@class binary_listener_enabled : indexedEventHandler
			---@field handler binary_handler_enabled Handler function to register for call

				---Called when an "enabled" event is invoked after `binary:SetEnabled(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `state` ― `true` if the widget is enabled</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias binary_handler_enabled fun(self: binary, state: boolean, user: boolean)

			---@class binary_listener : indexedEventHandler
			---@field handler binary_handler Handler function to register for call

				---Called when a custom event is invoked<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `...` — Any leftover arguments</p>
				---@alias binary_handler fun(self: binary, ...: any)



	---
	---@alias binary_data boolean? ***Default:*** `false`

	--| Returns

	---@class binary : datamanager
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_binary]: true, }
		function _:GetTypes() return {} end

			---@alias typename_binary "Binary"

		--[ Events ]

		---@class binary_addListener : datamanager_addListener
		---@field [string] fun(handler: binary_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler binary_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler binary_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler binary_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler binary_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Data ]

		---Validate a value to be accepted by the widget
		---@param value? any
		---***
		---@return boolean # ***Default:*** `false`
		function _:Verify(value) return false end

		---Turn a logical state into formatted string
		---***
		---@param state? boolean ***Default:*** *current value*
		---@return string
		function _:Format(state) return "" end

		---Verify and save the provided data or the current value of the widget to storage via the specified writer utility
		---***
		---@param state? boolean Data to be saved | ***Default:*** *current value*
		---@param silent? boolean If `false`, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _:SaveData(state, silent) end

		---Get the currently stored data via the specified reader utility
		---@return boolean # ***Default:*** *current value*
		function _:GetData() return false end

		---Verify and save the provided data to storage via the specified writer utility then load it to the widget via `t.loadData()`
		---***
		---@param state? boolean Data to be saved | ***Default:*** *current value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:SetData(state, handleChanges, silent) end

		---Get the currently set default value
		---@return boolean
		function _:GetDefault() return false end

		---Set the default value
		---@param state? boolean ***Default:*** `false`
		function _:SetDefault(state) end

		---Returns the current logical state of the widget
		---@return boolean
		function _:GetValue() return false end

		---Verify and set the logical state of the widget to the provided state
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param state? boolean ***Default:*** `false`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "flipped" event and call registered listeners | ***Default:*** `false`
		function _:SetValue(state, handleChanges, user, silent) end

		---Flip the current logical state of the widget
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "flipped" event and call registered listeners | ***Default:*** `false`
		function _:Flip(handleChanges, user, silent) end

	return _
end

--[ Toggle Button]

---Create a Blizzard checkbox GUI frame instance with enhanced widget functionality
---@param t? checkbox_options Optional parameters
---@param ancestor? binary Reference to an already existing binary datamanager instance to turn into a checkbox instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return checkbox|binary # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a widget table
function wt.CreateCheckbox(t, ancestor, lite)

	--| Parameters

	---Optional parameters
	---@class checkbox_options : binary_options, labeledChildFrame, tooltipDescribableWidget, arrangeableFrame, positionableFrame, visibleFrame, eventFrame, tooltipDescribableSettingsWidget
	---@field name? frameName ***Default:*** `"Radio"`
	---@field width? nonNegativeNumber ***Default:*** `t.label and 190 or t.height`
	---@field height? nonNegativeNumber ***Default:*** `26`
	---@field font? labelFontOptions List of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label | ***Default:*** *normal sized default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via <code><i>WidgetToolbox</i>.CreateFont(...)</code> (even within this table definition).</li></ul>
	---@field listeners? checkbox_listeners|binary_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field events? checkboxEvents

		---@class tooltipDescribableSettingsWidget
		---@field showDefault? boolean If `true`, show the default value of the widget in its tooltip and display the reset button its the utility menu | ***Default:*** `true`
		---@field utilityMenu? boolean If `true`, assign a context menu to the settings widget frame to allow for quickly resetting changes or the default value | ***Default:*** `true`

		---@class labelFontOptions
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** `"GameFontHighlight"`
		---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in a highlighted state | ***Default:*** `"GameFontNormal"`
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** `"GameFontDisable"`

		---@class checkbox_listeners : binary_listeners
		---@field [1]? table<string, checkbox_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? binary_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? binary_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? checkbox_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `checkbox:SetState(...)` was called
		---@field enabled? checkbox_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `checkbox:SetEnabled(...)` was called

			---@class checkbox_listener_loaded : indexedEventHandler
			---@field handler checkbox_handler_loaded Handler function to register for call

				---@alias checkbox_handler_loaded
				---| fun(self: checkbox, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` checkbox ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class checkbox_listener_saved : indexedEventHandler
			---@field handler checkbox_handler_saved Handler function to register for call

				---@alias checkbox_handler_saved
				---| fun(self: checkbox, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` checkbox ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class checkbox_listener_changed : indexedEventHandler
			---@field handler checkbox_handler_changed Handler function to register for call

				---@alias checkbox_handler_changed
				---| fun(self: checkbox, state: boolean, user: boolean) Called when a "changed" event is invoked after `checkbox:SetState(...)` was called<p>@*param* `self` checkbox ― Reference to the checkbox widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class checkbox_listener_enabled : indexedEventHandler
			---@field handler checkbox_handler_enabled Handler function to register for call

				---@alias checkbox_handler_enabled
			---| fun(self: checkbox, state: boolean, user: boolean) Called when an "enabled" event is invoked after `checkbox:SetEnabled(...)` was called<p>@*param* `self` checkbox ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class checkbox_listener : indexedEventHandler
			---@field handler checkbox_handler Handler function to register for call

				---@alias checkbox_handler
				---| fun(self: checkbox, ...: any) Called when a custom event is invoked<p>@*param* `self` checkbox ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

		--- - ***Note:*** Use `t.onEvent` to set [`"OnEvent"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) handlers for global events.
		--- - ***Note:*** Use `t.attributes` to set [`"OnAttributeChanged"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) handlers for custom frame attribute change events.
		---@alias checkboxEvents scriptHandlers_CheckButton

	--| Returns

	---@class checkbox: binary, guiFrame
	---@field template SettingsCheckbox Checkbox
	---@field label FontString|nil
	local _ = {}

		---NOTE: Incomplete Toolbox-relevant definition for a Frame of `"SettingsCheckboxTemplate"`
		---@class SettingsCheckbox : CheckButton
		---@field HoverBackground Frame

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_binary]: true, [typename_checkbox]: true, }
		function _:GetTypes() return {} end

			---@alias typename_checkbox "Checkbox"

		--[ Events ]

		---Register a listener for a custom event to call the specified handler on trigger
		---@param event eventTag Unique event identifier tag
		---@param handler datamanager_handler Called when a custom event is invoked
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener(event, handler, callIndex) end

		---Register a listener for an "enabled" event to call the specified handler on trigger
		---@param handler checkbox_handler_enabled Called when an "enabled" event is invoked after `checkbox:SetEnabled(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_enabled(handler, callIndex) end

		---Register a listener for a "loaded" widget event to call the specified handler on trigger
		---@param handler checkbox_handler_loaded Called when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_loaded(handler, callIndex) end

		---Register a listener for a "saved" widget event to call the specified handler on trigger
		---@param handler checkbox_handler_saved Called when an "saved" event is invoked after the data of this widget has been saved to storage
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_saved(handler, callIndex) end

		---Register a listener for a "changed" widget event to call the specified handler on trigger
		---@param handler checkbox_handler_changed Called when a "changed" event is invoked after `checkbox:SetValue(...)` was called
		---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
		function _:AddListener_changed(handler, callIndex) end

	return _
end

---Create a classic Blizzard checkbox GUI frame instance with enhanced widget functionality
---@param t? classicCheckbox_options Optional parameters
---@param ancestor? binary Reference to an already existing binary datamanager instance to turn into a classic checkbox instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return classicCheckbox|binary # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a widget table
function wt.CreateClassicCheckbox(t, ancestor, lite)

	--| Parameters

	---Optional parameters
	---@class classicCheckbox_options : checkbox_options
	---@field listeners? classicCheckbox_listeners|binary_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field font nil

		---@class classicCheckbox_listeners : binary_listeners
		---@field [1]? table<string, classicCheckbox_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? classicCheckbox_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? classicCheckbox_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? classicCheckbox_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `classicCheckbox:SetState(...)` was called
		---@field enabled? classicCheckbox_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `classicCheckbox:SetEnabled(...)` was called

			---@class classicCheckbox_listener_loaded : indexedEventHandler
			---@field handler classicCheckbox_handler_loaded Handler function to register for call

				---@alias classicCheckbox_handler_loaded
				---| fun(self: classicCheckbox, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` classicCheckbox ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class classicCheckbox_listener_saved : indexedEventHandler
			---@field handler classicCheckbox_handler_saved Handler function to register for call

				---@alias classicCheckbox_handler_saved
				---| fun(self: classicCheckbox, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` classicCheckbox ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class classicCheckbox_listener_changed : indexedEventHandler
			---@field handler classicCheckbox_handler_changed Handler function to register for call

				---@alias classicCheckbox_handler_changed
				---| fun(self: classicCheckbox, state: boolean, user: boolean) Called when a "changed" event is invoked after `classicCheckbox:SetState(...)` was called<p>@*param* `self` classicCheckbox ― Reference to the classicCheckbox widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class classicCheckbox_listener_enabled : indexedEventHandler
			---@field handler classicCheckbox_handler_enabled Handler function to register for call

				---@alias classicCheckbox_handler_enabled
			---| fun(self: classicCheckbox, state: boolean, user: boolean) Called when an "enabled" event is invoked after `classicCheckbox:SetEnabled(...)` was called<p>@*param* `self` classicCheckbox ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class classicCheckbox_listener : indexedEventHandler
			---@field handler classicCheckbox_handler Handler function to register for call

				---@alias classicCheckbox_handler
				---| fun(self: classicCheckbox, ...: any) Called when a custom event is invoked<p>@*param* `self` classicCheckbox ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class classicCheckbox : binary, guiFrame
	---@field template CheckButton|BackdropTemplate Checkbox
	---@field label FontString|nil
	---@field addListener classicCheckbox_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_binary]: true, [typename_classicCheckbox]: true, }
		function _:GetTypes() return {} end

			---@alias typename_classicCheckbox "ClassicCheckbox"

		--[ Events ]

		---@class classicCheckbox_addListener : binary_addListener
		---@field [string] fun(handler: classicCheckbox_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler classicCheckbox_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler classicCheckbox_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler classicCheckbox_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler classicCheckbox_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end

---Create a classic Blizzard radio button GUI frame instance with enhanced widget functionality
---@param t? radiobutton_options Optional parameters
---@param ancestor? binary Reference to an already existing binary datamanager instance to turn into a radio button instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return radiobutton|binary # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a widget table
function wt.CreateRadiobutton(t, ancestor, lite)

	--| Parameters

	---Optional parameters
	---@class radiobutton_options : checkbox_options
	---@field width? nonNegativeNumber ***Default:***  `t.label and 180 or t.height`
	---@field height? nonNegativeNumber ***Default:*** `18`
	---@field clearable? boolean Whether this radio button should be clearable by right clicking on it or not | ***Default:*** `false`<ul><li>***Note:*** The radio button will be registered for `"RightButtonUp"` triggers to call "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" events with `button = "RightButton"`.</li></ul>
	---@field listeners? radiobutton_listeners|binary_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field events? radioButtonEvents

		---@class labelFontOptions_small
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** `"GameFontHighlightSmall"`
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** `"GameFontDisableSmall"`

		---@class radiobutton_listeners : binary_listeners
		---@field [1]? table<string, radiobutton_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? radiobutton_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? radiobutton_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? radiobutton_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `radiobutton:SetState(...)` was called
		---@field enabled? radiobutton_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `radiobutton:SetEnabled(...)` was called

			---@class radiobutton_listener_loaded : indexedEventHandler
			---@field handler radiobutton_handler_loaded Handler function to register for call

				---@alias radiobutton_handler_loaded
				---| fun(self: radiobutton, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` radiobutton ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class radiobutton_listener_saved : indexedEventHandler
			---@field handler radiobutton_handler_saved Handler function to register for call

				---@alias radiobutton_handler_saved
				---| fun(self: radiobutton, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` radiobutton ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class radiobutton_listener_changed : indexedEventHandler
			---@field handler radiobutton_handler_changed Handler function to register for call

				---@alias radiobutton_handler_changed
				---| fun(self: radiobutton, state: boolean, user: boolean) Called when a "changed" event is invoked after `radiobutton:SetState(...)` was called<p>@*param* `self` radiobutton ― Reference to the radiobutton widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class radiobutton_listener_enabled : indexedEventHandler
			---@field handler radiobutton_handler_enabled Handler function to register for call

				---@alias radiobutton_handler_enabled
			---| fun(self: radiobutton, state: boolean, user: boolean) Called when an "enabled" event is invoked after `radiobutton:SetEnabled(...)` was called<p>@*param* `self` radiobutton ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class radiobutton_listener : indexedEventHandler
			---@field handler radiobutton_handler Handler function to register for call

				---@alias radiobutton_handler
				---| fun(self: radiobutton, ...: any) Called when a custom event is invoked<p>@*param* `self` radiobutton ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

		--- - ***Note:*** Use `t.onEvent` to set [`"OnEvent"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) handlers for global events.
		--- - ***Note:*** Use `t.attributes` to set [`"OnAttributeChanged"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) handlers for custom frame attribute change events.
		---@alias radioButtonEvents scriptHandlers_CheckButton

	--| Returns

	---@class radiobutton: binary, guiFrame
	---@field template CheckButton Radio button
	---@field label FontString|nil
	---@field addListener radiobutton_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_binary]: true, [typename_radiobutton]: true, }
		function _:GetTypes() return {} end

			---@alias typename_radiobutton "Radiobutton"

		--[ Events ]

		---@class radiobutton_addListener : binary_addListener
		---@field [string] fun(handler: radiobutton_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler radiobutton_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler radiobutton_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler radiobutton_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler radiobutton_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end


--[[ SELECTOR ]]

---Create a non-GUI selector datamanager widget instance (managing a set of binary datamanager child widgets) with integer (selection index) data management logic
---@param t? selector_options Optional parameters
---@return selector selector Reference to the new selector widget, utility functions and more wrapped in a widget table
function wt.CreateSelector(t)

	--| Items

	---@class selectorBinary : binary
	local i = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_binary]: true, [typename_selectorBinary]: true }
		function _:GetTypes() return {} end

			---@alias typename_selectorBinary "SelectorBinary"

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return integer|nil selected ***Default:*** *current value*
		local function reader() end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param data? integer ***Default:*** *current value*
		local function writer(data) end ---@cast writer +?

	---Optional parameters
	---@class selector_options : datamanager_options, selector_options_base
	---@field items? integer Number of binary datamanager children of the selector group to set up, representing all selectable options
	---@field listeners? selector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): selected: integer|nil Utility called to read the data from storage (and convert, evaluate or modify it as needed)<p>@*return* `selected` integer|nil | ***Default:*** `nil` *(no selection)*</p>
	---@field saveData? fun() Utility called to write the data to storage (and convert, evaluate or modify it as needed)<p>@*param* `selected`? integer</p>
	---@field value? integer The index of the item to be set as selected during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid or 1 if `t.clearable` is `false`
	---@field default? integer Default value of the widget | ***Default:*** `1 or nil` *(no selection)* if `t.clearable` is `true`

		---@class selector_options_base
		---@field clearable? boolean If `true`, the value of the selector input should be clearable and allowed to be set to nil | ***Default:*** `false`

		---@class selector_listeners : datamanager_listeners
		---@field [1]? table<string, selector_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? selector_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `selector:SetEnabled(...)` was called
		---@field loaded? selector_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? selector_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? selector_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `selector:SetSelected(...)` was called or an option was clicked or cleared
		---@field updated? selector_listener_updated[] Ordered list of functions to call when an "updated" event is invoked after `selector:UpdateItems(...)` was called
		---@field added? selector_listener_added[] Ordered list of functions to call when an "added" event is invoked when a new binary item is added to the selector via `selector:UpdateItems(...)`

			---@class selector_listener_loaded : indexedEventHandler
			---@field handler selector_handler_loaded Handler function to register for call

				---@alias selector_handler_loaded
				---| fun(self: selector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` selector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class selector_listener_saved : indexedEventHandler
			---@field handler selector_handler_saved Handler function to register for call

				---@alias selector_handler_saved
				---| fun(self: selector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` selector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class selector_listener_changed : indexedEventHandler
			---@field handler selector_handler_changed Handler function to register for call

				---@alias selector_handler_changed
				---| fun(self: selector, selected?: integer, user: boolean) Called when an "changed" event is invoked after `selector:SetSelected(...)` was called or an option was clicked or cleared<p>@*param* `self` selector ― Reference to the selector widget</p><p>@*param* `selected` integer ― The index of the currently selected item</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class selector_listener_updated : indexedEventHandler
			---@field handler selector_handler_updated Handler function to register for call

				---@alias selector_handler_updated
				---| fun(self: selector) Called when an "updated" event is invoked after `selector:UpdateItems(...)` was called<p>@*param* `self` selector ― Reference to the selector widget</p>

			---@class selector_listener_added : indexedEventHandler
			---@field handler selector_handler_updated Handler function to register for call

				---@alias selector_handler_added
				---| fun(self: selector, binary: binary|selectorBinary) Called when a new binary item is added to the selector via `selector:UpdateItems(...)`<p>@*param* `self` selector ― Reference to the selector widget</p><p>@*param* `binary` binary|selectorBinary ― Reference to the binary widget added to the selector</p>

			---@class selector_listener_enabled : indexedEventHandler
			---@field handler selector_handler_enabled Handler function to register for call

				---@alias selector_handler_enabled
				---| fun(self: selector, state: boolean, user: boolean) Called when an "enabled" event is invoked after `selector:SetEnabled(...)` was called<p>@*param* `self` selector ― Reference to the selector widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class selector_listener : indexedEventHandler
			---@field handler selector_handler Handler function to register for call

				---@alias selector_handler
				---| fun(self: selector, ...: any) Called when a custom event is invoked<p>@*param* `self` selector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class selector : datamanager, list
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_selector]: true, }
		function _:GetTypes() return {} end

			---@alias typename_selector "Selector"

		--[ Events ]

		---@class selector_invoke : datamanager_invoke
		---@field updated function Invoke a "updated" event to notify registered listeners and call handlers
		---@field added fun(binary: binary|selectorBinary) Invoke an "added" event to notify registered listeners and call handlers

		---@class selector_addListener : datamanager_addListener
		---@field [string] fun(handler: selector_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler selector_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler selector_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler selector_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for a "updated" widget event
			---@param handler selector_handler_updated Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_updated(handler, callIndex) end

			---Register a listener for a "added" widget event
			---@param handler selector_handler_added Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_added(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler selector_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Items ]

		---Update the list of items currently set for the selector widget, updating its parameters and binary datamanagers
		--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
		--- - ***Note:*** The currently selected item may not be the same after an item was removed. In that case, the item at the same index will be set as selected instead. If one or more items from the last indexes were removed, the new last item will be selected, correct the selection if needed.
		---@param items selectorItemData[] Ordered set of item data used to set up binary datamanager children of the selector group, representing all selectable options
		---@param silent? boolean If `false`, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
		function _:UpdateItems(items, silent) end

		--[ Data ]

		---Validate a value to be accepted by the widget
		---@param value any
		---***
		---@return integer|nil ***Default:*** *current value*
		function _:Verify(value) end

		---Verify and save the provided data or the current value of the widget to storage via the specified writer utility
		---***
		---@param data? wrappedInteger If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param silent? boolean If `false`, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _:SaveData(data, silent) end

		---Get the currently stored data via the specified reader utility
		---@return integer|nil
		function _:GetData() end

		---Verify and save the provided data to storage via the specified writer utility then load it to the widget via `t.loadData()`
		---***
		---@param data? wrappedInteger If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:SetData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return integer|nil default
		function _:GetDefault() end

		---Set the default value
		---@param index integer|nil | ***Default:*** *no change*
		function _:SetDefault(index) end

		---Returns the index of the currently selected item or nil if there is no selection
		---@return integer|nil index
		function _:GetValue() end

		---Verify and set the specified item as selected
		---***
		---@param index? integer ***Default:*** `nil` *(no selection)*
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "selected" event and call registered listeners | ***Default:*** `false`
		function _:SetValue(index, user, silent) end

	return _
end

---Create a non-GUI anchor selector datamanager widget instance (managing a set of binary datamanager child widgets) with anchor point data management logic
---@param t? anchorSelector_options Optional parameters
---@return anchorSelector selector Reference to the new selector widget, utility functions and more wrapped in a widget table
function wt.CreateAnchorSelector(t)

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return boolean data
		local function reader() return false end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param data? boolean
		local function writer(data) end ---@cast writer +?

	---Optional parameters
	---@class anchorSelector_options : datamanager_options, selector_options_base
	---@field listeners? anchorSelector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): value: integer|anchorSelectorValueTypes|nil Utility called to read the data from storage (and convert, evaluate or modify it as needed)<p>@*return* `value` integer|AnchorPoint|JustifyH|JustifyV|FrameStrata|nil — The index or the value of the item to be set as selected ***Default:*** `nil` *(no selection)*</p>
	---@field saveData? fun(value?: anchorSelectorValueTypes) Utility called to write the data to storage (and convert, evaluate or modify it as needed)<p>@*param* `value`? AnchorPoint|JustifyH|JustifyV|FrameStrata</p>
	---@field value? integer|anchorSelectorValueTypes The item to be set as selected during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid or *option 1* if `t.clearable` is `false`
	---@field default? integer|anchorSelectorValueTypes Default value of the widget | ***Default:*** *option 1* or nil *(no selection)* if `t.clearable` is `true`
	t = { reader = reader, writer = writer, }

		---@alias anchorSelectorValueTypes
		---| FramePoint
		---| JustifyHorizontal
		---| JustifyVertical
		---| FrameStrata

		---@class anchorSelector_listeners : datamanager_listeners
		---@field [1]? table<string, anchorSelector_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? anchorSelector_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `anchorSelector:SetEnabled(...)` was called
		---@field loaded? anchorSelector_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? anchorSelector_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? anchorSelector_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `anchorSelector:SetSelected(...)` was called or an option was clicked or cleared

			---@class anchorSelector_listener_loaded : indexedEventHandler
			---@field handler anchorSelector_handler_loaded Handler function to register for call

				---@alias anchorSelector_handler_loaded
				---| fun(self: anchorSelector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` anchorSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class anchorSelector_listener_saved : indexedEventHandler
			---@field handler anchorSelector_handler_saved Handler function to register for call

				---@alias anchorSelector_handler_saved
				---| fun(self: anchorSelector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` anchorSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class anchorSelector_listener_changed : indexedEventHandler
			---@field handler anchorSelector_handler_changed Handler function to register for call

				---@alias anchorSelector_handler_changed
				---| fun(self: anchorSelector, selected?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata, user: boolean) Called when an "changed" event is invoked after `anchorSelector:SetSelected(...)` was called or an option was clicked or cleared<p>@*param* `self` anchorSelector ― Reference to the selector widget</p><p>@*param* `selected` AnchorPoint|JustifyH|JustifyV|FrameStrata ― The currently selected value</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class anchorSelector_listener_enabled : indexedEventHandler
			---@field handler anchorSelector_handler_enabled Handler function to register for call

				---@alias anchorSelector_handler_enabled
				---| fun(self: anchorSelector, state: boolean, user: boolean) Called when an "enabled" event is invoked after `anchorSelector:SetEnabled(...)` was called<p>@*param* `self` anchorSelector ― Reference to the selector widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class anchorSelector_listener : indexedEventHandler
			---@field handler anchorSelector_handler Handler function to register for call

				---@alias anchorSelector_handler
				---| fun(self: anchorSelector, ...: any) Called when a custom event is invoked<p>@*param* `self` anchorSelector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class anchorSelector : selector
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_anchorSelector]: true, }
		function _:GetTypes() return {} end

			---@alias typename_anchorSelector "AnchorSelector"

		--[ Events ]

			---Register a listener for a "loaded" widget event
			---@param handler anchorSelector_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler anchorSelector_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler anchorSelector_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler anchorSelector_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Data ]

		---Verify and save the provided data or the current value of the widget to storage via the specified writer utility
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param silent? boolean If `false`, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _:SaveData(data, silent) end

		---Get the currently stored data via the specified reader utility
		---@return anchorSelectorValueTypes|nil
		function _:GetData() end

		---Verify and save the provided data to storage via the specified writer utility then load it to the widget via `t.loadData()`
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:SetData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return anchorSelectorValueTypes|nil default
		function _:GetDefault() end

		---Set the default value
		---***
		---@param selected integer|anchorSelectorValueTypes|nil | ***Default:*** *no change*
		---<p></p>
		function _:SetDefault(selected) end

		---Returns the value of the currently selected item or nil if there is no selection
		---@return anchorSelectorValueTypes|nil selected
		---<p></p>
		function _:GetValue() end

		---Set the specified item as selected
		---***
		---@param selected integer|anchorSelectorValueTypes|nil The index or the value of the item to be set as selected | ***Default:*** *no selection:* `nil`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "selected" event and call registered listeners | ***Default:*** `false`
		---<p></p>
		function _:SetValue(selected, user, silent) end

	return _
end

---Create a non-GUI verticality selector datamanager widget instance (managing a set of binary datamanager child widgets) with vertical text justification data management logic
---@param t? verticalitySelector_options Optional parameters
---@return verticalitySelector selector Reference to the new selector widget, utility functions and more wrapped in a widget table
function wt.CreateVerticalitySelector(t)

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return boolean data
		local function reader() return false end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param data? boolean
		local function writer(data) end ---@cast writer +?

	---Optional parameters
	---@class verticalitySelector_options : datamanager_options, selector_options_base
	---@field listeners? verticalitySelector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): value: integer|verticalitySelectorValueTypes|nil Utility called to read the data from storage (and convert, evaluate or modify it as needed)<p>@*return* `value` integer|AnchorPoint|JustifyH|JustifyV|FrameStrata|nil — The index or the value of the item to be set as selected ***Default:*** `nil` *(no selection)*</p>
	---@field saveData? fun(value?: verticalitySelectorValueTypes) Utility called to write the data to storage (and convert, evaluate or modify it as needed)<p>@*param* `value`? AnchorPoint|JustifyH|JustifyV|FrameStrata</p>
	---@field value? integer|verticalitySelectorValueTypes The item to be set as selected during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid or *option 1* if `t.clearable` is `false`
	---@field default? integer|verticalitySelectorValueTypes Default value of the widget | ***Default:*** *option 1* or nil *(no selection)* if `t.clearable` is `true`
	t = { reader = reader, writer = writer, }

		---@alias verticalitySelectorValueTypes
		---| FramePoint
		---| JustifyHorizontal
		---| JustifyVertical
		---| FrameStrata

		---@class verticalitySelector_listeners : datamanager_listeners
		---@field [1]? table<string, verticalitySelector_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? verticalitySelector_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `verticalitySelector:SetEnabled(...)` was called
		---@field loaded? verticalitySelector_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? verticalitySelector_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? verticalitySelector_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `verticalitySelector:SetSelected(...)` was called or an option was clicked or cleared

			---@class verticalitySelector_listener_loaded : indexedEventHandler
			---@field handler verticalitySelector_handler_loaded Handler function to register for call

				---@alias verticalitySelector_handler_loaded
				---| fun(self: verticalitySelector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` verticalitySelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class verticalitySelector_listener_saved : indexedEventHandler
			---@field handler verticalitySelector_handler_saved Handler function to register for call

				---@alias verticalitySelector_handler_saved
				---| fun(self: verticalitySelector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` verticalitySelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class verticalitySelector_listener_changed : indexedEventHandler
			---@field handler verticalitySelector_handler_changed Handler function to register for call

				---@alias verticalitySelector_handler_changed
				---| fun(self: verticalitySelector, selected?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata, user: boolean) Called when an "changed" event is invoked after `verticalitySelector:SetSelected(...)` was called or an option was clicked or cleared<p>@*param* `self` verticalitySelector ― Reference to the selector widget</p><p>@*param* `selected` AnchorPoint|JustifyH|JustifyV|FrameStrata ― The currently selected value</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class verticalitySelector_listener_enabled : indexedEventHandler
			---@field handler verticalitySelector_handler_enabled Handler function to register for call

				---@alias verticalitySelector_handler_enabled
				---| fun(self: verticalitySelector, state: boolean, user: boolean) Called when an "enabled" event is invoked after `verticalitySelector:SetEnabled(...)` was called<p>@*param* `self` verticalitySelector ― Reference to the selector widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class verticalitySelector_listener : indexedEventHandler
			---@field handler verticalitySelector_handler Handler function to register for call

				---@alias verticalitySelector_handler
				---| fun(self: verticalitySelector, ...: any) Called when a custom event is invoked<p>@*param* `self` verticalitySelector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class verticalitySelector : datamanager
	---@field items selectorBinary[]
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_verticalitySelector]: true, }
		function _:GetTypes() return {} end

			---@alias typename_verticalitySelector "VerticalitySelector"

		--[ Events ]

			---Register a listener for a "loaded" widget event
			---@param handler verticalitySelector_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler verticalitySelector_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler verticalitySelector_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler verticalitySelector_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Data ]

		---Verify and save the provided data or the current value of the widget to storage via the specified writer utility
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param silent? boolean If `false`, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _:SaveData(data, silent) end

		---Get the currently stored data via the specified reader utility
		---@return verticalitySelectorValueTypes|nil
		function _:GetData() end

		---Verify and save the provided data to storage via the specified writer utility then load it to the widget via `t.loadData()`
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:SetData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return verticalitySelectorValueTypes|nil default
		function _:GetDefault() end

		---Set the default value
		---***
		---@param selected integer|verticalitySelectorValueTypes|nil | ***Default:*** *no change*
		---<p></p>
		function _:SetDefault(selected) end

		---Returns the value of the currently selected item or nil if there is no selection
		---@return verticalitySelectorValueTypes|nil selected
		---<p></p>
		function _:GetValue() end

		---Set the specified item as selected
		---***
		---@param selected integer|verticalitySelectorValueTypes|nil The index or the value of the item to be set as selected | ***Default:*** *no selection:* `nil`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "selected" event and call registered listeners | ***Default:*** `false`
		---<p></p>
		function _:SetValue(selected, user, silent) end

	return _
end

---Create a non-GUI horizontality selector datamanager widget instance (managing a set of binary datamanager child widgets) with horizontal text justification data management logic
---@param t? horizontalitySelector_options Optional parameters
---@return horizontalitySelector selector Reference to the new selector widget, utility functions and more wrapped in a widget table
function wt.CreateHorizontalitySelector(t)

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return boolean data
		local function reader() return false end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param data? boolean
		local function writer(data) end ---@cast writer +?

	---Optional parameters
	---@class horizontalitySelector_options : datamanager_options, selector_options_base
	---@field listeners? horizontalitySelector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): value: integer|horizontalitySelectorValueTypes|nil Utility called to read the data from storage (and convert, evaluate or modify it as needed)<p>@*return* `value` integer|AnchorPoint|JustifyH|JustifyV|FrameStrata|nil — The index or the value of the item to be set as selected ***Default:*** `nil` *(no selection)*</p>
	---@field saveData? fun(value?: horizontalitySelectorValueTypes) Utility called to write the data to storage (and convert, evaluate or modify it as needed)<p>@*param* `value`? AnchorPoint|JustifyH|JustifyV|FrameStrata</p>
	---@field value? integer|horizontalitySelectorValueTypes The item to be set as selected during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid or *option 1* if `t.clearable` is `false`
	---@field default? integer|horizontalitySelectorValueTypes Default value of the widget | ***Default:*** *option 1* or nil *(no selection)* if `t.clearable` is `true`
	t = { reader = reader, writer = writer, }

		---@alias horizontalitySelectorValueTypes
		---| FramePoint
		---| JustifyHorizontal
		---| JustifyVertical
		---| FrameStrata

		---@class horizontalitySelector_listeners : datamanager_listeners
		---@field [1]? table<string, horizontalitySelector_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? horizontalitySelector_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `horizontalitySelector:SetEnabled(...)` was called
		---@field loaded? horizontalitySelector_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? horizontalitySelector_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? horizontalitySelector_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `horizontalitySelector:SetSelected(...)` was called or an option was clicked or cleared

			---@class horizontalitySelector_listener_loaded : indexedEventHandler
			---@field handler horizontalitySelector_handler_loaded Handler function to register for call

				---@alias horizontalitySelector_handler_loaded
				---| fun(self: horizontalitySelector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` horizontalitySelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class horizontalitySelector_listener_saved : indexedEventHandler
			---@field handler horizontalitySelector_handler_saved Handler function to register for call

				---@alias horizontalitySelector_handler_saved
				---| fun(self: horizontalitySelector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` horizontalitySelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class horizontalitySelector_listener_changed : indexedEventHandler
			---@field handler horizontalitySelector_handler_changed Handler function to register for call

				---@alias horizontalitySelector_handler_changed
				---| fun(self: horizontalitySelector, selected?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata, user: boolean) Called when an "changed" event is invoked after `horizontalitySelector:SetSelected(...)` was called or an option was clicked or cleared<p>@*param* `self` horizontalitySelector ― Reference to the selector widget</p><p>@*param* `selected` AnchorPoint|JustifyH|JustifyV|FrameStrata ― The currently selected value</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class horizontalitySelector_listener_enabled : indexedEventHandler
			---@field handler horizontalitySelector_handler_enabled Handler function to register for call

				---@alias horizontalitySelector_handler_enabled
				---| fun(self: horizontalitySelector, state: boolean, user: boolean) Called when an "enabled" event is invoked after `horizontalitySelector:SetEnabled(...)` was called<p>@*param* `self` horizontalitySelector ― Reference to the selector widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class horizontalitySelector_listener : indexedEventHandler
			---@field handler horizontalitySelector_handler Handler function to register for call

				---@alias horizontalitySelector_handler
				---| fun(self: horizontalitySelector, ...: any) Called when a custom event is invoked<p>@*param* `self` horizontalitySelector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class horizontalitySelector : datamanager
	---@field items selectorBinary[]
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_horizontalitySelector]: true, }
		function _:GetTypes() return {} end

			---@alias typename_horizontalitySelector "HorizontalitySelector"

		--[ Events ]

			---Register a listener for a "loaded" widget event
			---@param handler horizontalitySelector_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler horizontalitySelector_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler horizontalitySelector_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler horizontalitySelector_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Data ]

		---Verify and save the provided data or the current value of the widget to storage via the specified writer utility
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param silent? boolean If `false`, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _:SaveData(data, silent) end

		---Get the currently stored data via the specified reader utility
		---@return horizontalitySelectorValueTypes|nil
		function _:GetData() end

		---Verify and save the provided data to storage via the specified writer utility then load it to the widget via `t.loadData()`
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:SetData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return horizontalitySelectorValueTypes|nil default
		function _:GetDefault() end

		---Set the default value
		---***
		---@param selected integer|horizontalitySelectorValueTypes|nil | ***Default:*** *no change*
		---<p></p>
		function _:SetDefault(selected) end

		---Returns the value of the currently selected item or nil if there is no selection
		---@return horizontalitySelectorValueTypes|nil selected
		---<p></p>
		function _:GetValue() end

		---Set the specified item as selected
		---***
		---@param selected integer|horizontalitySelectorValueTypes|nil The index or the value of the item to be set as selected | ***Default:*** *no selection:* `nil`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "selected" event and call registered listeners | ***Default:*** `false`
		---<p></p>
		function _:SetValue(selected, user, silent) end

	return _
end

---Create a non-GUI strata selector datamanager widget instance (managing a set of binary datamanager child widgets) with frame strata data management logic
---@param t? strataSelector_options Optional parameters
---@return strataSelector selector Reference to the new selector widget, utility functions and more wrapped in a widget table
function wt.CreateStrataSelector(t)

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return boolean data
		local function reader() return false end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param data? boolean
		local function writer(data) end ---@cast writer +?

	---Optional parameters
	---@class strataSelector_options : datamanager_options, selector_options_base
	---@field listeners? strataSelector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): value: integer|strataSelectorValueTypes|nil Utility called to read the data from storage (and convert, evaluate or modify it as needed)<p>@*return* `value` integer|AnchorPoint|JustifyH|JustifyV|FrameStrata|nil — The index or the value of the item to be set as selected ***Default:*** `nil` *(no selection)*</p>
	---@field saveData? fun(value?: strataSelectorValueTypes) Utility called to write the data to storage (and convert, evaluate or modify it as needed)<p>@*param* `value`? AnchorPoint|JustifyH|JustifyV|FrameStrata</p>
	---@field value? integer|strataSelectorValueTypes The item to be set as selected during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid or *option 1* if `t.clearable` is `false`
	---@field default? integer|strataSelectorValueTypes Default value of the widget | ***Default:*** *option 1* or nil *(no selection)* if `t.clearable` is `true`
	t = { reader = reader, writer = writer, }

		---@alias strataSelectorValueTypes
		---| FramePoint
		---| JustifyHorizontal
		---| JustifyVertical
		---| FrameStrata

		---@class strataSelector_listeners : datamanager_listeners
		---@field [1]? table<string, strataSelector_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? strataSelector_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `strataSelector:SetEnabled(...)` was called
		---@field loaded? strataSelector_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? strataSelector_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? strataSelector_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `strataSelector:SetSelected(...)` was called or an option was clicked or cleared

			---@class strataSelector_listener_loaded : indexedEventHandler
			---@field handler strataSelector_handler_loaded Handler function to register for call

				---@alias strataSelector_handler_loaded
				---| fun(self: strataSelector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` strataSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class strataSelector_listener_saved : indexedEventHandler
			---@field handler strataSelector_handler_saved Handler function to register for call

				---@alias strataSelector_handler_saved
				---| fun(self: strataSelector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` strataSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class strataSelector_listener_changed : indexedEventHandler
			---@field handler strataSelector_handler_changed Handler function to register for call

				---@alias strataSelector_handler_changed
				---| fun(self: strataSelector, selected?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata, user: boolean) Called when an "changed" event is invoked after `strataSelector:SetSelected(...)` was called or an option was clicked or cleared<p>@*param* `self` strataSelector ― Reference to the selector widget</p><p>@*param* `selected` AnchorPoint|JustifyH|JustifyV|FrameStrata ― The currently selected value</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class strataSelector_listener_enabled : indexedEventHandler
			---@field handler strataSelector_handler_enabled Handler function to register for call

				---@alias strataSelector_handler_enabled
				---| fun(self: strataSelector, state: boolean, user: boolean) Called when an "enabled" event is invoked after `strataSelector:SetEnabled(...)` was called<p>@*param* `self` strataSelector ― Reference to the selector widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class strataSelector_listener : indexedEventHandler
			---@field handler strataSelector_handler Handler function to register for call

				---@alias strataSelector_handler
				---| fun(self: strataSelector, ...: any) Called when a custom event is invoked<p>@*param* `self` strataSelector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class strataSelector : datamanager
	---@field items selectorBinary[]
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_strataSelector]: true, }
		function _:GetTypes() return {} end

			---@alias typename_strataSelector "StrataSelector"

		--[ Events ]

			---Register a listener for a "loaded" widget event
			---@param handler strataSelector_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler strataSelector_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler strataSelector_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler strataSelector_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Data ]

		---Verify and save the provided data or the current value of the widget to storage via the specified writer utility
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param silent? boolean If `false`, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _:SaveData(data, silent) end

		---Get the currently stored data via the specified reader utility
		---@return strataSelectorValueTypes|nil
		function _:GetData() end

		---Verify and save the provided data to storage via the specified writer utility then load it to the widget via `t.loadData()`
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:SetData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return strataSelectorValueTypes|nil default
		function _:GetDefault() end

		---Set the default value
		---***
		---@param selected integer|strataSelectorValueTypes|nil | ***Default:*** *no change*
		---<p></p>
		function _:SetDefault(selected) end

		---Returns the value of the currently selected item or nil if there is no selection
		---@return strataSelectorValueTypes|nil selected
		---<p></p>
		function _:GetValue() end

		---Set the specified item as selected
		---***
		---@param selected integer|strataSelectorValueTypes|nil The index or the value of the item to be set as selected | ***Default:*** *no selection:* `nil`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "selected" event and call registered listeners | ***Default:*** `false`
		---<p></p>
		function _:SetValue(selected, user, silent) end

	return _
end

---Create a non-GUI font selector datamanager widget instance (managing a set of binary datamanager child widgets) with font path data management logic
---@param t? fontSelector_options Optional parameters
---@return fontSelector selector Reference to the new selector widget, utility functions and more wrapped in a widget table
function wt.CreateFontSelector(t)

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return boolean data
		local function reader() return false end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param data? boolean
		local function writer(data) end ---@cast writer +?

	---Optional parameters
	---@class fontSelector_options : datamanager_options, selector_options_base
	---@field listeners? fontSelector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): value: integer|fontSelectorValueTypes|nil Utility called to read the data from storage (and convert, evaluate or modify it as needed)<p>@*return* `value` integer|AnchorPoint|JustifyH|JustifyV|FrameStrata|nil — The index or the value of the item to be set as selected ***Default:*** `nil` *(no selection)*</p>
	---@field saveData? fun(value?: fontSelectorValueTypes) Utility called to write the data to storage (and convert, evaluate or modify it as needed)<p>@*param* `value`? AnchorPoint|JustifyH|JustifyV|FrameStrata</p>
	---@field value? integer|fontSelectorValueTypes The item to be set as selected during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid or *option 1* if `t.clearable` is `false`
	---@field default? integer|fontSelectorValueTypes Default value of the widget | ***Default:*** *option 1* or nil *(no selection)* if `t.clearable` is `true`
	t = { reader = reader, writer = writer, }

		---@alias fontSelectorValueTypes
		---| FramePoint
		---| JustifyHorizontal
		---| JustifyVertical
		---| FrameStrata

		---@class fontSelector_listeners : datamanager_listeners
		---@field [1]? table<string, fontSelector_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? fontSelector_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `fontSelector:SetEnabled(...)` was called
		---@field loaded? fontSelector_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? fontSelector_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? fontSelector_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `fontSelector:SetSelected(...)` was called or an option was clicked or cleared

			---@class fontSelector_listener_loaded : indexedEventHandler
			---@field handler fontSelector_handler_loaded Handler function to register for call

				---@alias fontSelector_handler_loaded
				---| fun(self: fontSelector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` fontSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class fontSelector_listener_saved : indexedEventHandler
			---@field handler fontSelector_handler_saved Handler function to register for call

				---@alias fontSelector_handler_saved
				---| fun(self: fontSelector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` fontSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class fontSelector_listener_changed : indexedEventHandler
			---@field handler fontSelector_handler_changed Handler function to register for call

				---@alias fontSelector_handler_changed
				---| fun(self: fontSelector, selected?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata, user: boolean) Called when an "changed" event is invoked after `fontSelector:SetSelected(...)` was called or an option was clicked or cleared<p>@*param* `self` fontSelector ― Reference to the selector widget</p><p>@*param* `selected` AnchorPoint|JustifyH|JustifyV|FrameStrata ― The currently selected value</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class fontSelector_listener_enabled : indexedEventHandler
			---@field handler fontSelector_handler_enabled Handler function to register for call

				---@alias fontSelector_handler_enabled
				---| fun(self: fontSelector, state: boolean, user: boolean) Called when an "enabled" event is invoked after `fontSelector:SetEnabled(...)` was called<p>@*param* `self` fontSelector ― Reference to the selector widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class fontSelector_listener : indexedEventHandler
			---@field handler fontSelector_handler Handler function to register for call

				---@alias fontSelector_handler
				---| fun(self: fontSelector, ...: any) Called when a custom event is invoked<p>@*param* `self` fontSelector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class fontSelector : datamanager
	---@field items selectorBinary[]
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_fontSelector]: true, }
		function _:GetTypes() return {} end

			---@alias typename_fontSelector "FontSelector"

		--[ Events ]

			---Register a listener for a "loaded" widget event
			---@param handler fontSelector_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler fontSelector_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler fontSelector_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler fontSelector_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Data ]

		---Verify and save the provided data or the current value of the widget to storage via the specified writer utility
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param silent? boolean If `false`, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _:SaveData(data, silent) end

		---Get the currently stored data via the specified reader utility
		---@return fontSelectorValueTypes|nil
		function _:GetData() end

		---Verify and save the provided data to storage via the specified writer utility then load it to the widget via `t.loadData()`
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:SetData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return fontSelectorValueTypes|nil default
		function _:GetDefault() end

		---Set the default value
		---***
		---@param selected integer|fontSelectorValueTypes|nil | ***Default:*** *no change*
		---<p></p>
		function _:SetDefault(selected) end

		---Returns the value of the currently selected item or nil if there is no selection
		---@return fontSelectorValueTypes|nil selected
		---<p></p>
		function _:GetValue() end

		---Set the specified item as selected
		---***
		---@param selected integer|fontSelectorValueTypes|nil The index or the value of the item to be set as selected | ***Default:*** *no selection:* `nil`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "selected" event and call registered listeners | ***Default:*** `false`
		---<p></p>
		function _:SetValue(selected, user, silent) end

	return _
end

---Create a non-GUI multiselector datamanager widget instance (managing a set of binary datamanager child widgets) with boolean mask data management logic
---@param t? multiselector_options Optional parameters
---@return multiselector multiselector Reference to the new multiselector widget, utility functions and more wrapped in a widget table
function wt.CreateMultiselector(t)

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return boolean data
		local function reader() return false end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param data? boolean
		local function writer(data) end ---@cast writer +?

	---Optional parameters
	---@class multiselector_options : datamanager_options
	---@field items? (selectorItemData|binary)[] Table containing subtables with data used to create item widgets, or already existing binary datamanagers
	---@field limits? limitValues Parameters to specify the limits of the number of selectable items
	---@field listeners? multiselector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): selections: boolean[] Utility called to read the data from storage (and convert, evaluate or modify it as needed)<p>@*return* `selections` boolean[] | ***Default:*** *no selected items: `false[]`*</p>
	---@field saveData? fun(selections?: boolean[]) Utility called to write the data to storage (and convert, evaluate or modify it as needed)<p>@*param* `selections`? boolean[] | ***Default:*** *no selected items: `false[]`*</p>
	---@field value? boolean[] Ordered list of item states to set during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid
	---@field default? boolean[] Default value of the widget | ***Default:*** *no selected items: `false[]`*
	t = { reader = reader, writer = writer, }

		---@class limitValues
		---@field min? integer The minimal number of items that need to be selected at all times | ***Default:*** `1`
		---@field max? integer The maximal number of items that can be selected at once | ***Default:*** `#t.items` *(all items)*

		---@class multiselector_listeners : datamanager_listeners
		---@field [1]? table<string, multiselector_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? multiselector_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `multiselector:SetEnabled(...)` was called
		---@field loaded? multiselector_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? multiselector_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? multiselector_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `multiselector:SetSelected(...)` was called or an option was clicked or cleared
		---@field updated? multiselector_listener_updated[] Ordered list of functions to call when an "updated" event is invoked after `multiselector:UpdateItems(...)` was called
		---@field added? multiselector_listener_added[] Ordered list of functions to call when an "added" event is invoked when a new binary item is added to the selector via `multiselector:UpdateItems(...)`
		---@field limited? multiselector_listener_limited[] Ordered list of functions to call when a "limited" event is invoked after a lower limit update occurs

			---@class multiselector_listener_loaded : indexedEventHandler
			---@field handler multiselector_handler_loaded Handler function to register for call

				---@alias multiselector_handler_loaded
				---| fun(self: multiselector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class multiselector_listener_saved : indexedEventHandler
			---@field handler multiselector_handler_saved Handler function to register for call

				---@alias multiselector_handler_saved
				---| fun(self: multiselector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class multiselector_listener_changed : indexedEventHandler
			---@field handler multiselector_handler_changed Handler function to register for call

				---@alias multiselector_handler_changed
				---| fun(self: multiselector, selections: boolean[], user: boolean) Called when an "changed" event is invoked after `multiselector:SetSelected(...)` was called or an option was clicked or cleared<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `selections` boolean[] ― Indexed list of the current item states</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class multiselector_listener_updated : indexedEventHandler
			---@field handler multiselector_handler_updated Handler function to register for call

				---@alias multiselector_handler_updated
				---| fun(self: multiselector) Called when an "updated" event is invoked after `multiselector:UpdateItems(...)` was called<p>@*param* `self` multiselector ― Reference to the selector widget</p>

			---@class multiselector_listener_added : indexedEventHandler
			---@field handler multiselector_handler_added Handler function to register for call

				---@alias multiselector_handler_added
				---| fun(self: multiselector, binary: binary|selectorBinary) Called when a new binary item is added to the selector via `multiselector:UpdateItems(...)`<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `binary` binary|selectorBinary ― Reference to the binary widget added to the selector</p>

			---@class multiselector_listener_limited : indexedEventHandler
			---@field handler multiselector_handler_limited Handler function to register for call

				---@alias multiselector_handler_limited
				---| fun(self: multiselector, min: boolean, max: boolean) Called when a "limited" event is invoked after a limit update occurs<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `min` boolean ― `true` if the number of selected items is equal to lower than the specified lower limit</p><p>@*param* `max` boolean ― `true` if the number of selected items is equal to higher than the specified upper limit</p>

			---@class multiselector_listener_enabled : indexedEventHandler
			---@field handler multiselector_handler_enabled Handler function to register for call

				---@alias multiselector_handler_enabled
				---| fun(self: multiselector, state: boolean, user: boolean) Called when an "enabled" event is invoked after `multiselector:SetEnabled(...)` was called<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class multiselector_listener : indexedEventHandler
			---@field handler multiselector_handler Handler function to register for call

				---@alias multiselector_handler
				---| fun(self: multiselector, ...: any) Called when a custom event is invoked<p>@*param* `self` multiselector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class multiselector : datamanager
	---@field items selectorBinary[]
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_multiselector]: true, }
		function _:GetTypes() return {} end

			---@alias typename_multiselector "Multiselector"

		--[ Events ]

		---@class multiselector_invoke : datamanager_invoke
		---@field updated function Invoke a "updated" event to notify registered listeners and call handlers
		---@field added fun(binary: binary|selectorBinary) Invoke an "added" event to notify registered listeners and call handlers
		---@field limited fun(count: integer) Invoke a "limited" event to notify registered listeners and call handlers

		---@class multiselector_addListener : datamanager_addListener
		---@field [string] fun(handler: multiselector_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler multiselector_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler multiselector_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler multiselector_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for a "updated" widget event
			---@param handler multiselector_handler_updated Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_updated(handler, callIndex) end

			---Register a listener for a "added" widget event
			---@param handler multiselector_handler_added Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_added(handler, callIndex) end

			---Register a listener for a "limited" widget event
			---@param handler multiselector_handler_limited Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_limited(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler multiselector_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Items ]

		---Update the list of items currently set for the selector widget, updating its parameters and binary widgets
		--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
		--- - ***Note:*** The currently selected item may not be the same after item were removed. In that case, the new item at the same index will be selected instead. If one or more items from the last indexes were removed, the new last item at the reduced count index will be selected. Use `selector:SetSelected(...)` to correct the selection if needed!
		---@param newItems (selectorItemData|binary|selectorBinary)[] Table containing subtables with data used to update the binary widgets, or already existing binary widgets
		---@param silent? boolean If `false`, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
		function _.updateItems(newItems, silent) end

		--[ Data ]

		---Verify and save the provided data or the current value of the widget to storage via the specified writer utility
		---@param data? wrappedBooleanArray If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param silent? boolean If `false`, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _:SaveData(data, silent) end

		---Get the currently stored data via the specified reader utility
		---@return boolean[]|nil
		function _:GetData() end

		---Verify and save the provided data to storage via the specified writer utility then load it to the widget via `t.loadData()`
		---@param data? wrappedBooleanArray If set, save the value wrapped in this table | ***Default:*** *current value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:SetData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return boolean[] default
		function _:GetDefault() return {} end

		---Set the default value
		---@param selections? boolean[] | ***Default:*** *no selected items: `false[]`*
		function _:SetDefault(selections) end

		---Returns the list of all items and their current states
		---@return boolean[] selections Indexed list of item states
		function _:GetValue() return {} end

		---Set the specified items as selected
		---@param selections? boolean[] Indexed list of item states | ***Default:*** *no selected items: `false[]`*
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke "selected" and "limited" events and call registered listeners | ***Default:*** `false`
		function _:SetValue(selections, user, silent) end

		---Set the specified item as selected
		---@param index integer Index of the item | ***Range:*** (`1`, `#selector.items`)
		---@param selected? boolean If `true`, set the item at this index as selected | ***Default:*** `false`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke "selected" and "limited" events and call registered listeners | ***Default:*** `false`
		function _:SetSelected(index, selected, user, silent) end

	return _
end

--[ Toggle Button Group ]

---Create a radio button selector GUI frame instance to pick one out of multiple options with enhanced widget functionality
---@param t? radiogroup_options Optional parameters
---@param ancestor? selector Reference to an already existing selector instance to turn into a radio button group container instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@return radiogroup|selector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a widget table
function wt.CreateRadiogroup(t, ancestor)

	--| Parameters

	---Optional parameters
	---@class radiogroup_options : selector_options, selectorFrame_options, radiogroup_options_base
	---@field width? nonNegativeNumber The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or `t.label` and 180 or 0 *(whichever is greater)*<ul><li>***Note:*** The width of each individual item will be set to `t.width` if `t.columns` is 1 and `t.width` is specified.</li></ul>
	---@field items? selectorItemData[] Ordered set of item data used to set up radio button children of the selector group and the container frame, representing all selectable options
	---@field columns? integer Arrange the newly created widget items in a grid with the specified number of columns instead of a vertical list | ***Default:*** `1`
	---@field labels? boolean Whether or not to add the labels to the right of each newly created widget item | ***Default:*** `true`
	---@field listeners? radiogroup_listeners|selector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class selectorFrame_options : labeledChildFrame, tooltipDescribableWidget, arrangeableFrame, positionableFrame, visibleFrame, eventFrame
		---@field name? frameName ***Default:*** `"Selector"`

		---@class radiogroup_options_base : tooltipDescribableSettingsWidget
		---@field clearable? boolean If `true`, the selector input should be clearable by right clicking on its radio buttons, setting the selected value to nil | ***Default:*** `false`

		---@class selectorItemData
		---@field title? string Text to be shown as on the label of the toggle button representing the item within the selector container frame (if `t.labels` is `true`)
		---@field tooltip? itemTooltipTextData List of textlines to be added to the tooltip of the item displayed when mousing over the toggle button

			---@class itemTooltipTextData : tooltipTextData
			---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** <code>t.items[<i>index</i>].title</code>

		---@class radiogroup_listeners : selector_listeners
		---@field [1]? table<string, radiogroup_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? radiogroup_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? radiogroup_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? radiogroup_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `radiogroup:SetSelected(...)` was called or an option was clicked or cleared
		---@field updated? radiogroup_listener_updated[] Ordered list of functions to call when an "updated" event is invoked after `radiogroup:UpdateItems(...)` was called
		---@field added? radiogroup_listener_added[] Ordered list of functions to call when an "added" event is invoked when a new binary item is added to the radiogroup via `radiogroup:UpdateItems(...)`
		---@field enabled? radiogroup_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `radiogroup:SetEnabled(...)` was called

			---@class radiogroup_listener_loaded : indexedEventHandler
			---@field handler radiogroup_handler_loaded Handler function to register for call

				---@alias radiogroup_handler_loaded
				---| fun(self: radiogroup, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class radiogroup_listener_saved : indexedEventHandler
			---@field handler radiogroup_handler_saved Handler function to register for call

				---@alias radiogroup_handler_saved
				---| fun(self: radiogroup, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class radiogroup_listener_changed : indexedEventHandler
			---@field handler radiogroup_handler_changed Handler function to register for call

				---@alias radiogroup_handler_changed
				---| fun(self: radiogroup, selected?: integer, user: boolean) Called when an "changed" event is invoked after `radiogroup:SetSelected(...)` was called or an option was clicked or cleared<p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p><p>@*param* `selected` integer ― The index of the currently selected item</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class radiogroup_listener_updated : indexedEventHandler
			---@field handler radiogroup_handler_updated Handler function to register for call

				---@alias radiogroup_handler_updated
				---| fun(self: radiogroup) Called when an "updated" event is invoked after `radiogroup:UpdateItems(...)` was called<p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p>

			---@class radiogroup_listener_added : indexedEventHandler
			---@field handler radiogroup_handler_updated Handler function to register for call

				---@alias radiogroup_handler_added
				---| fun(self: radiogroup, binary: binary|selectorBinary) Called when a new binary item is added to the radiogroup via `radiogroup:UpdateItems(...)`<p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p><p>@*param* `binary` binary|selectorBinary ― Reference to the binary widget added to the radiogroup</p>

			---@class radiogroup_listener_enabled : indexedEventHandler
			---@field handler radiogroup_handler_enabled Handler function to register for call

				---@alias radiogroup_handler_enabled
				---| fun(self: radiogroup, state: boolean, user: boolean) Called when an "enabled" event is invoked after `radiogroup:SetEnabled(...)` was called<p>@*param* `self` radiogroup ― Reference to the radiogroup widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class radiogroup_listener : indexedEventHandler
			---@field handler radiogroup_handler Handler function to register for call

				---@alias radiogroup_handler
				---| fun(self: radiogroup, ...: any) Called when a custom event is invoked<p>@*param* `self` radiogroup ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class radiogroup : selector, guiFrame
	---@field label FontString|nil
	---@field items selectorRadiobutton[] The list of radio button widgets linked together in this selector
	---@field addListener radiogroup_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		---Update the list of items currently set for the selector widget, updating its parameters and radio button widgets
		--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed after the automatic rearrangement done by the container component did not produce the desired result.
		--- - ***Note:*** The currently selected item may not be the same after an item was removed. In that case, the item at the same index will be set as selected instead. If one or more items from the last indexes were removed, the new last item will be selected, correct the selection if needed.
		---@param items selectorItemData_radioButton[] Ordered set of item data used to set up radio button children of the selector group and the conteiner frame, representing all selectable options
		---@param silent? boolean If `false`, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
		function _:UpdateItems(items, silent) end

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_selector]: true, [typename_radiogroup]: true, }
		function _:GetTypes() return {} end

			---@alias typename_radiogroup "Radiogroup"

		--[ Events ]

		---@class radiogroup_addListener : selector_addListener
		---@field [string] fun(handler: radiogroup_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler radiogroup_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler radiogroup_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler radiogroup_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for a "updated" widget event
			---@param handler radiogroup_handler_updated Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_updated(handler, callIndex) end

			---Register a listener for a "added" widget event
			---@param handler radiogroup_handler_added Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_added(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler radiogroup_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end

---Create a dropdown radio button selector GUI frame instance to pick one out of multiple options with enhanced widget functionality
---@param t? dropdownRadiogroup_options Optional parameters
---@param ancestor? selector Reference to an already existing selector instance to turn into a dropdown radio button group container instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@return dropdownRadiogroup|selector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, a toggle [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a widget table
function wt.CreateDropdownRadiogroup(t, ancestor)

	--| Parameters

	---Optional parameters
	---@class dropdownRadiogroup_options : radiogroup_options, widgetWidthValue, tooltipDescribableSettingsWidget
	---@field name? frameName ***Default:*** `"Dropdown"`
	---@field width? nonNegativeNumber The width of the dropdown frame containing the toggle and (optionally) cycle buttons and the label (if `t.label` is `true`) | ***Default:*** `180`
	---@field scrollThreshold? integer Number of items to show before changing the dropdown menu to be scrollable | ***Default:*** 15<ul><li>***Note:*** Scrollability does not change when the number of items change after the initial setup.</li></ul>
	---@field text? string The default text to display on the dropdown when no item is selected | ***Default:*** `""`
	---@field clearable? boolean If `true`, the selector input should be clearable by right clicking on its radio buttons, or, if `t.utilityMenu` is `false`, the dropdown toggle button itself (if `true`, a clear selection option is added to the utility menu instead), setting the selected value to nil | ***Default:*** `false`
	---@field autoClose? boolean Close the dropdown menu after an item is selected by the user | ***Default:*** `true`
	---@field cycleButtons? boolean Add previous & next item buttons next to the dropdown | ***Default:*** `true`
	---@field listeners? dropdownRadiogroup_listeners|radiogroup_listeners|selector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class widgetWidthValue
		---@field width? nonNegativeNumber ***Default:*** `180`

		---@class dropdownRadiogroup_listeners : radiogroup_listeners
		---@field [1]? table<string, dropdownRadiogroup_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? dropdownRadiogroup_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? dropdownRadiogroup_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? dropdownRadiogroup_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `dropdownRadiogroup:SetSelected(...)` was called or an option was clicked or cleared
		---@field updated? dropdownRadiogroup_listener_updated[] Ordered list of functions to call when an "updated" event is invoked after `dropdownRadiogroup:UpdateItems(...)` was called
		---@field added? dropdownRadiogroup_listener_added[] Ordered list of functions to call when an "added" event is invoked when a new binary item is added to the dropdownRadiogroup via `dropdownRadiogroup:UpdateItems(...)`
		---@field enabled? dropdownRadiogroup_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `dropdownRadiogroup:SetEnabled(...)` was called

			---@class dropdownRadiogroup_listener_loaded : indexedEventHandler
			---@field handler dropdownRadiogroup_handler_loaded Handler function to register for call

				---@alias dropdownRadiogroup_handler_loaded
				---| fun(self: dropdownRadiogroup, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class dropdownRadiogroup_listener_saved : indexedEventHandler
			---@field handler dropdownRadiogroup_handler_saved Handler function to register for call

				---@alias dropdownRadiogroup_handler_saved
				---| fun(self: dropdownRadiogroup, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class dropdownRadiogroup_listener_changed : indexedEventHandler
			---@field handler dropdownRadiogroup_handler_changed Handler function to register for call

				---@alias dropdownRadiogroup_handler_changed
				---| fun(self: dropdownRadiogroup, selected?: integer, user: boolean) Called when an "selected" event is invoked after `dropdownRadiogroup:SetSelected(...)` was called or an option was clicked or cleared<p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p><p>@*param* `selected` integer ― The index of the currently selected item</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class dropdownRadiogroup_listener_updated : indexedEventHandler
			---@field handler dropdownRadiogroup_handler_updated Handler function to register for call

				---@alias dropdownRadiogroup_handler_updated
				---| fun(self: dropdownRadiogroup) Called when an "updated" event is invoked after `dropdownRadiogroup:UpdateItems(...)` was called<p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p>

			---@class dropdownRadiogroup_listener_added : indexedEventHandler
			---@field handler dropdownRadiogroup_handler_updated Handler function to register for call

				---@alias dropdownRadiogroup_handler_added
				---| fun(self: dropdownRadiogroup, binary: binary|selectorBinary) Called when a new binary item is added to the dropdownRadiogroup via `dropdownRadiogroup:UpdateItems(...)`<p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p><p>@*param* `binary` binary|selectorBinary ― Reference to the binary widget added to the dropdownRadiogroup</p>

			---@class dropdownRadiogroup_listener_enabled : indexedEventHandler
			---@field handler dropdownRadiogroup_handler_enabled Handler function to register for call

				---@alias dropdownRadiogroup_handler_enabled
				---| fun(self: dropdownRadiogroup, state: boolean, user: boolean) Called when an "enabled" event is invoked after `dropdownRadiogroup:SetEnabled(...)` was called<p>@*param* `self` dropdownRadiogroup ― Reference to the dropdownRadiogroup widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class dropdownRadiogroup_listener : indexedEventHandler
			---@field handler dropdownRadiogroup_handler Handler function to register for call

				---@alias dropdownRadiogroup_handler
				---| fun(self: dropdownRadiogroup, ...: any) Called when a custom event is invoked<p>@*param* `self` dropdownRadiogroup ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class dropdownRadiogroup : radiogroup
	---@field holder Frame Main holder frame for the dropdown toggle, buttons and title
	---@field menu panel Panel container holding the dropdown selector widget
	---@field content Frame
	---@field toggle customButton
	---@field previous customButton
	---@field next customButton
	---@field addListener dropdownRadiogroup_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		---Set the text displayed on the label of the toggle button
		---***
		---@param text? string ***Default:*** <code>t.items[<i>index</i>].title</code> *(the title of the currently selected item)* or "…" *(if there is no selection)*
		---@param silent? boolean If `false`, invoke a "labeled" event and call registered listeners | ***Default:*** `false`
		function _:SetText(text, silent) end

		---Toggle the dropdown menu
		---@param state? boolean ***Default:*** `not selector.list:IsVisible()`
		function _.toggleMenu(state) end

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_selector]: true, [typename_radiogroup]: true, [typename_dropdownRadiogroup]: true, }
		function _:GetTypes() return {} end

			---@alias typename_dropdownRadiogroup "DropdownRadiogroup"

		--[ Events ]

		---@class dropdownRadiogroup_addListener : radiogroup_addListener
		---@field [string] fun(handler: dropdownRadiogroup_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler dropdownRadiogroup_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler dropdownRadiogroup_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler dropdownRadiogroup_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for a "updated" widget event
			---@param handler dropdownRadiogroup_handler_updated Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_updated(handler, callIndex) end

			---Register a listener for a "added" widget event
			---@param handler dropdownRadiogroup_handler_added Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_added(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler dropdownRadiogroup_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end

---Create a special radio button selector GUI frame instance to pick an Anchor Point, a horizontal or vertical text alignment or Frame Strata value with enhanced widget functionality
---@param itemset CreateSpecialRadiogroup_param_itemset Specify what type of selector should be created
--- - ***Note:*** Value is overwritten by `ancestor:GetItemset()` if a valid `selector` is provided.
---@param t? specialRadiogroup_options Optional parameters
---@param ancestor? specialSelector Reference to an already existing special selector instance to turn into a special radio button group container instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@return specialSelector|specialRadiogroup # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a widget table
function wt.CreateSpecialRadiogroup(itemset, t, ancestor)

	--| Parameters

	---Specify what type of selector should be created
	--- - ***Note:*** Value is overwritten by `ancestor:GetItemset()` if a valid `selector` is provided.
	---@alias CreateSpecialRadiogroup_param_itemset SpecialSelectorItemset?

	---Optional parameters
	---@class specialRadiogroup_options : specialSelector_options, selectorFrame_options, radiogroup_options_base
	---@field listeners? specialRadiogroup_listeners|specialSelector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class specialRadiogroup_listeners : specialSelector_listeners
		---@field [1]? table<string, specialRadiogroup_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? specialRadiogroup_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? specialRadiogroup_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? specialRadiogroup_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `specialRadiogroup:SetSelected(...)` was called or an option was clicked or cleared
		---@field enabled? specialRadiogroup_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `specialRadiogroup:SetEnabled(...)` was called

			---@class specialRadiogroup_listener_loaded : indexedEventHandler
			---@field handler specialRadiogroup_handler_loaded Handler function to register for call

				---@alias specialRadiogroup_handler_loaded
				---| fun(self: specialSelector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class specialRadiogroup_listener_saved : indexedEventHandler
			---@field handler specialRadiogroup_handler_saved Handler function to register for call

				---@alias specialRadiogroup_handler_saved
				---| fun(self: specialSelector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class specialRadiogroup_listener_changed : indexedEventHandler
			---@field handler specialRadiogroup_handler_changed Handler function to register for call

				---@alias specialRadiogroup_handler_changed
				---| fun(self: specialSelector, selected?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata, user: boolean) Called when an "changed" event is invoked after `specialRadiogroup:SetSelected(...)` was called or an option was clicked or cleared<p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `selected` AnchorPoint|JustifyH|JustifyV|FrameStrata ― The currently selected value</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class specialRadiogroup_listener_enabled : indexedEventHandler
			---@field handler specialRadiogroup_handler_enabled Handler function to register for call

				---@alias specialRadiogroup_handler_enabled
				---| fun(self: specialSelector, state: boolean, user: boolean) Called when an "enabled" event is invoked after `specialRadiogroup:SetEnabled(...)` was called<p>@*param* `self` specialSelector ― Reference to the selector widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class specialRadiogroup_listener : indexedEventHandler
			---@field handler specialRadiogroup_handler Handler function to register for call

				---@alias specialRadiogroup_handler
				---| fun(self: specialSelector, ...: any) Called when a custom event is invoked<p>@*param* `self` specialSelector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class specialRadiogroup : specialSelector, guiFrame
	---@field label FontString|nil
	---@field items selectorRadiobutton[] The list of radio button widgets linked together in this selector
	---@field addListener specialRadiogroup_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_specialSelector]: true, [typename_specialRadiogroup]: true, }
		function _:GetTypes() return {} end

			---@alias typename_specialRadiogroup "SpecialRadiogroup"

		--[ Events ]

		---@class specialRadiogroup_addListener : specialSelector_addListener
		---@field [string] fun(handler: specialRadiogroup_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler specialRadiogroup_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler specialRadiogroup_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler specialRadiogroup_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler specialRadiogroup_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end

---Create a checkbox selector GUI frame instance to pick multiple options out of a list with enhanced widget functionality
---@param t? checkgroup_options Optional parameters
---@param ancestor? multiselector Reference to an already existing multiselector instance to turn into a checkbox group container instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@return checkgroup|multiselector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a widget table
function wt.CreateCheckgroup(t, ancestor)

	--| Parameters

	---Optional parameters
	---@class checkgroup_options : multiselector_options, selectorFrame_options, tooltipDescribableSettingsWidget
	---@field width? nonNegativeNumber The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or `t.label` and 160 or 0 *(whichever is greater)*<ul><li>***Note:*** The width of each individual item will be set to `t.width` if `t.columns` is 1 and `t.width` is specified.</li></ul>
	---@field items? selectorItemData[] Ordered set of item data used to set up checkbox children of the selector group and the conteiner frame, representing all selectable options
	---@field labels? boolean Whether or not to add the labels to the right of each newly created widget item | ***Default:*** `true`
	---@field columns? integer Arrange the newly created widget items in a grid with the specified number of columns instead of a vertical list | ***Default:*** `1`
	---@field listeners? checkgroup_listeners|multiselector_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class checkgroup_listeners : multiselector_listeners
		---@field [1]? table<string, checkgroup_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? checkgroup_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? checkgroup_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? checkgroup_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after `checkgroup:SetSelected(...)` was called or an option was clicked or cleared
		---@field updated? checkgroup_listener_updated[] Ordered list of functions to call when an "updated" event is invoked after `checkgroup:UpdateItems(...)` was called
		---@field added? checkgroup_listener_added[] Ordered list of functions to call when an "added" event is invoked when a new binary item is added to the selector via `checkgroup:UpdateItems(...)`
		---@field min? checkgroup_listener_limited[] Ordered list of functions to call when a "limited" event is invoked after a lower limit update occurs
		---@field enabled? checkgroup_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `checkgroup:SetEnabled(...)` was called

			---@class checkgroup_listener_loaded : indexedEventHandler
			---@field handler checkgroup_handler_loaded Handler function to register for call

				---@alias checkgroup_handler_loaded
				---| fun(self: multiselector, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class checkgroup_listener_saved : indexedEventHandler
			---@field handler checkgroup_handler_saved Handler function to register for call

				---@alias checkgroup_handler_saved
				---| fun(self: multiselector, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class checkgroup_listener_changed : indexedEventHandler
			---@field handler checkgroup_handler_changed Handler function to register for call

				---@alias checkgroup_handler_changed
				---| fun(self: multiselector, selections: boolean[], user: boolean) Called when an "changed" event is invoked after `checkgroup:SetSelected(...)` was called or an option was clicked or cleared<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `selections` boolean[] ― Indexed list of the current item states</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class checkgroup_listener_updated : indexedEventHandler
			---@field handler checkgroup_handler_updated Handler function to register for call

				---@alias checkgroup_handler_updated
				---| fun(self: multiselector) Called when an "updated" event is invoked after `checkgroup:UpdateItems(...)` was called<p>@*param* `self` multiselector ― Reference to the selector widget</p>

			---@class checkgroup_listener_added : indexedEventHandler
			---@field handler checkgroup_handler_added Handler function to register for call

				---@alias checkgroup_handler_added
				---| fun(self: multiselector, binary: binary|selectorBinary) Called when a new binary item is added to the selector via `checkgroup:UpdateItems(...)`<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `binary` binary|selectorBinary ― Reference to the binary widget added to the selector</p>

			---@class checkgroup_listener_limited : indexedEventHandler
			---@field handler checkgroup_handler_limited Handler function to register for call

				---@alias checkgroup_handler_limited
				---| fun(self: multiselector, min: boolean, max: boolean, passed: boolean) Called when a "limited" event is invoked after a limit update occurs<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `min` boolean ― `true` if the number of selected items is equal to lower than the specified lower limit</p><p>@*param* `max` boolean ― `true` if the number of selected items is equal to higher than the specified upper limit</p><p>@*param* `passed` boolean ― `true` if the number of selected items is below or over the specified lower or upper limit</p>

			---@class checkgroup_listener_enabled : indexedEventHandler
			---@field handler checkgroup_handler_enabled Handler function to register for call

				---@alias checkgroup_handler_enabled
				---| fun(self: multiselector, state: boolean, user: boolean) Called when an "enabled" event is invoked after `checkgroup:SetEnabled(...)` was called<p>@*param* `self` multiselector ― Reference to the selector widget</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class checkgroup_listener : indexedEventHandler
			---@field handler checkgroup_handler Handler function to register for call

				---@alias checkgroup_handler
				---| fun(self: multiselector, ...: any) Called when a custom event is invoked<p>@*param* `self` multiselector ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class checkgroup : multiselector, guiFrame
	---@field label FontString|nil
	---@field items selectorCheckbox[] The list of checkbox widgets linked together in this selector
	---@field addListener checkgroup_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		---Update the list of items currently set for the selector widget, updating its parameters and checkbox widgets
		--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed after the automatic rearrangement done by the container component did not produce the desired result.
		--- - ***Note:*** The currently selected item may not be the same after an item was removed. In that case, the item at the same index will be set as selected instead. If one or more items from the last indexes were removed, the new last item will be selected, correct the selections if needed.
		---@param items selectorItemData_checkbox[] Ordered set of item data used to set up checkbox children of the selector group and the conteiner frame, representing all selectable options
		---@param silent? boolean If `false`, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
		function _:UpdateItems(items, silent) end


		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_multiselector]: true, [typename_checkgroup]: true, }
		function _:GetTypes() return {} end

			---@alias typename_checkgroup "Checkgroup"

		--[ Events ]

		---@class checkgroup_addListener : multiselector_addListener
		---@field [string] fun(handler: checkgroup_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler checkgroup_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler checkgroup_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler checkgroup_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for a "updated" widget event
			---@param handler checkgroup_handler_updated Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_updated(handler, callIndex) end

			---Register a listener for a "added" widget event
			---@param handler checkgroup_handler_added Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_added(handler, callIndex) end

			---Register a listener for a "limited" widget event
			---@param handler checkgroup_handler_limited Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_limited(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler checkgroup_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end


--[[ TEXT ]]

---Create a non-GUI textual datamanager widget instance with string data management logic
---@param t? textual_options Optional parameters
---@return textual textual Reference to the new textual datamanager, utility functions and more wrapped in a widget table
function wt.CreateTextual(t)

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return string|nil text ***Default:*** `""`
		local function reader() end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param text? string
		local function writer(text) end ---@cast writer +?

	---Optional parameters
	---@class textual_options : datamanager_options
	---@field color? color Apply the specified color to all text in the editbox (overriding all font objects set in `t.font`)
	---@field listeners? textual_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field value? string The starting text to be set during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid
	---@field default? string Default value of the widget | ***Default:*** `""`

		---@class textual_listeners : datamanager_listeners
		---@field [1]? table<string, textual_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? textual_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? textual_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? textual_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `textual:SetText(...)` was called
		---@field enabled? textual_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `textual:SetEnabled(...)` was called

			---@class textual_listener_loaded : indexedEventHandler
			---@field handler textual_handler_loaded Handler function to register for call

				---@alias textual_handler_loaded
				---| fun(self: textual, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class textual_listener_saved : indexedEventHandler
			---@field handler textual_handler_saved Handler function to register for call

				---@alias textual_handler_saved
				---| fun(self: textual, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class textual_listener_changed : indexedEventHandler
			---@field handler textual_handler_changed Handler function to register for call

				---@alias textual_handler_changed
				---| fun(self: textual, text: string, user: boolean) Called when an "changed" event is invoked after `textual:SetText(...)` was called<p>@*param* `self` textual ― Reference to the binary widget</p><p>@*param* `text` string ― The current value of the widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class textual_listener_enabled : indexedEventHandler
			---@field handler textual_handler_enabled Handler function to register for call

				---@alias textual_handler_enabled
				---| fun(self: textual, state: boolean, user: boolean) Called when an "enabled" event is invoked after `textual:SetEnabled(...)` was called<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class textual_listener : indexedEventHandler
			---@field handler textual_handler Handler function to register for call

				---@alias textual_handler
				---| fun(self: textual, ...: any) Called when a custom event is invoked<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class textual : datamanager
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_textual]: true, }
		function _:GetTypes() return {} end

			---@alias typename_textual "Textual"

		--[ Events ]

		---@class textual_addListener : datamanager_listeners
		---@field [string] fun(handler: textual_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler textual_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler textual_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler textual_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler textual_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Data ]

		---Verify and save the provided data or the current value of the widget to storage via the specified writer utility
		---***
		---@param text? string Data to be saved | ***Default:*** *current value*
		---@param silent? boolean If `false`, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _:SaveData(text, silent) end

		---Get the currently stored data via the specified reader utility
		---@return string|nil
		function _:GetData() end

		---Verify and save the provided data to storage via the specified writer utility then load it to the widget via `t.loadData()`
		---***
		---@param text? string Data to be saved | ***Default:*** *current value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:SetData(text, handleChanges, silent) end

		---Get the currently set default value
		---@return string default
		function _:GetDefault() return "" end

		---Set the default value
		---@param text string | ***Default:*** `""`
		function _:SetDefault(text) end

		---Returns the current text value of the widget
		---@return string
		function _:GetValue() return "" end

		---Set the text value of the widget
		---***
		---@param text? string ***Default:*** `""`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _:SetValue(text, user, silent) end

	return _
end

--[ Editbox]

---Create a default single-line Blizzard editbox GUI frame instance with enhanced widget functionality
---@param t? editbox_options Optional parameters
---@param ancestor? textual Reference to an already existing textual datamanager instance to turn into an editbox instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return textualEditbox|textual # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a widget table
function wt.CreateEditbox(t, ancestor, lite)

	--| Properties

	---Optional parameters
	---@class editbox_options : textual_options, labeledChildFrame, tooltipDescribableWidget, arrangeableFrame, positionableFrame, visibleFrame, eventFrame, tooltipDescribableSettingsWidget
	---@field name? frameName ***Default:*** `"Textbox"`
	---@field width? nonNegativeNumber ***Default:***  `180`
	---@field height? nonNegativeNumber ***Default:*** `18`
	---@field insets? insetData Table containing padding values by which to offset the position of the text in the editbox
	---@field font? labelFontOptions_editbox List of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via <code><i>WidgetToolbox</i>.CreateFont(...)</code> (even within this table definition).</li></ul>
	---@field justify? justifyData_left Set the justification of the text (overriding all font objects set in `t.font`)
	---@field charLimit? number The value to limit the character count by | ***Default:*** `0` *(no limit)*
	---@field readOnly? boolean The text will be uneditable if `true` | ***Default:*** `false`
	---@field focusOnShow? boolean Focus the editbox when its shown and highlight the text | ***Default:*** `false`
	---@field keepFocused? boolean Keep the editbox focused while its being shown | ***Default:*** `false`
	---@field unfocusOnEnter? boolean Whether to automatically clear the focus from the editbox when the ENTER key is pressed | ***Default:*** `true`
	---@field resetCursor? boolean If `true`, set the cursor position to the beginning of the string after setting the text via `textual:SetText(...)` | ***Default:*** `true`
	---@field listeners? editbox_listeners|textual_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field events? editboxEvents

		---@class labelFontOptions_editbox
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** *default font based on the frame template*
		---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is being hovered | ***Default:*** *default font based on the frame template*
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** *default font based on the frame template*

		---@class justifyData_left
		---@field h? JustifyHorizontal Horizontal text alignment| ***Default:*** `"LEFT"`
		---@field v? JustifyVertical Vertical text alignment | ***Default:*** `"MIDDLE"`

		---@class editbox_listeners : textual_listeners
		---@field [1]? table<string, editbox_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? editbox_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? editbox_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? editbox_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `editbox:SetText(...)` was called
		---@field enabled? editbox_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `editbox:SetEnabled(...)` was called

			---@class editbox_listener_loaded : indexedEventHandler
			---@field handler editbox_handler_loaded Handler function to register for call

				---@alias editbox_handler_loaded
				---| fun(self: textual, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class editbox_listener_saved : indexedEventHandler
			---@field handler editbox_handler_saved Handler function to register for call

				---@alias editbox_handler_saved
				---| fun(self: textual, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class editbox_listener_changed : indexedEventHandler
			---@field handler editbox_handler_changed Handler function to register for call

				---@alias editbox_handler_changed
				---| fun(self: textual, text: string, user: boolean) Called when an "changed" event is invoked after `editbox:SetText(...)` was called<p>@*param* `self` textual ― Reference to the binary widget</p><p>@*param* `text` string ― The current value of the widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class editbox_listener_enabled : indexedEventHandler
			---@field handler editbox_handler_enabled Handler function to register for call

				---@alias editbox_handler_enabled
				---| fun(self: textual, state: boolean, user: boolean) Called when an "enabled" event is invoked after `editbox:SetEnabled(...)` was called<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class editbox_listener : indexedEventHandler
			---@field handler editbox_handler Handler function to register for call

				---@alias editbox_handler
				---| fun(self: textual, ...: any) Called when a custom event is invoked<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

		--- - ***Note:*** Use `t.onEvent` to set [`"OnEvent"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) handlers for global events.
		--- - ***Note:*** Use `t.attributes` to set [`"OnAttributeChanged"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) handlers for custom frame attribute change events.
		---@alias editboxEvents scriptHandlers_EditBox

	--| Returns

	---@class textualEditbox : textual, guiFrame
	---@field template EditBox
	---@field label FontString|nil
	---@field addListener editbox_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_textual]: true, [typename_editbox]: true, }
		function _:GetTypes() return {} end

			---@alias typename_editbox "Editbox"

		--[ Events ]

		---@class editbox_addListener : textual_listeners
		---@field [string] fun(handler: editbox_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler editbox_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler editbox_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler editbox_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler editbox_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end

---Create a single-line Blizzard editbox GUI frame instance with customizable UI elements and enhanced widget functionality
---@param t? customEditbox_options Optional parameters
---@param ancestor? textual Reference to an already existing textual datamanager instance to turn into a customizable editbox instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return customEditbox|textual # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a widget table
function wt.CreateCustomEditbox(t, ancestor, lite)

	--| Properties

	---Optional parameters
	---@class customEditbox_options : editbox_options, customizableObject
	---@field listeners? customEditbox_listeners|textual_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class customEditbox_listeners : textual_listeners
		---@field [1]? table<string, customEditbox_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? customEditbox_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? customEditbox_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? customEditbox_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `customEditbox:SetText(...)` was called
		---@field enabled? customEditbox_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `customEditbox:SetEnabled(...)` was called

			---@class customEditbox_listener_loaded : indexedEventHandler
			---@field handler customEditbox_handler_loaded Handler function to register for call

				---@alias customEditbox_handler_loaded
				---| fun(self: textual, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class customEditbox_listener_saved : indexedEventHandler
			---@field handler customEditbox_handler_saved Handler function to register for call

				---@alias customEditbox_handler_saved
				---| fun(self: textual, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class customEditbox_listener_changed : indexedEventHandler
			---@field handler customEditbox_handler_changed Handler function to register for call

				---@alias customEditbox_handler_changed
				---| fun(self: textual, text: string, user: boolean) Called when an "changed" event is invoked after `customEditbox:SetText(...)` was called<p>@*param* `self` textual ― Reference to the binary widget</p><p>@*param* `text` string ― The current value of the widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class customEditbox_listener_enabled : indexedEventHandler
			---@field handler customEditbox_handler_enabled Handler function to register for call

				---@alias customEditbox_handler_enabled
				---| fun(self: textual, state: boolean, user: boolean) Called when an "enabled" event is invoked after `customEditbox:SetEnabled(...)` was called<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class customEditbox_listener : indexedEventHandler
			---@field handler customEditbox_handler Handler function to register for call

				---@alias customEditbox_handler
				---| fun(self: textual, ...: any) Called when a custom event is invoked<p>@*param* `self` textual ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class customEditbox : textual, guiFrame
	---@field template EditBox|BackdropTemplate
	---@field label FontString|nil
	---@field addListener customEditbox_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_textual]: true, [typename_customEditbox]: true, }
		function _:GetTypes() return {} end

			---@alias typename_customEditbox "CustomEditbox"

		--[ Events ]

		---@class customEditbox_addListener : textual_addListener
		---@field [string] fun(handler: customEditbox_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler customEditbox_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler customEditbox_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler customEditbox_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler customEditbox_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end

---Create a default multiline Blizzard editbox GUI frame instance with enhanced widget functionality
---@param t? multilineEditbox_options Optional parameters
---@param ancestor? textual Reference to an already existing textual datamanager instance to turn into a multiline editbox instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return multilineEditbox|textual # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a widget table
function wt.CreateMultilineEditbox(t, ancestor, lite)

	--| Parameters

	---Optional parameters
	---@class multilineEditbox_options : editbox_options, scrollSpeedData
	---@field width? nonNegativeNumber
	---@field height? nonNegativeNumber
	---@field charCount? boolean Show or hide the remaining number of characters | ***Default:*** `t.charLimit` > 0
	---@field scrollToTop? boolean Automatically scroll to the top when the text is loaded or changed while not being actively edited | ***Default:*** `false`
	---@field scrollEvents? scriptHandlers_ScrollFrame
	---@field listeners? multilineEditbox_listeners|textual_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class multilineEditbox_listeners : textual_listeners
		---@field [1]? table<string, multilineEditbox_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? multilineEditbox_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? multilineEditbox_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? multilineEditbox_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `multilineEditbox:SetText(...)` was called
		---@field enabled? multilineEditbox_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `multilineEditbox:SetEnabled(...)` was called

			---@class multilineEditbox_listener_loaded : indexedEventHandler
			---@field handler multilineEditbox_handler_loaded Handler function to register for call

				---@alias multilineEditbox_handler_loaded
				---| fun(self: multilineEditbox, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` multilineEditbox ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class multilineEditbox_listener_saved : indexedEventHandler
			---@field handler multilineEditbox_handler_saved Handler function to register for call

				---@alias multilineEditbox_handler_saved
				---| fun(self: multilineEditbox, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` multilineEditbox ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class multilineEditbox_listener_changed : indexedEventHandler
			---@field handler multilineEditbox_handler_changed Handler function to register for call

				---@alias multilineEditbox_handler_changed
				---| fun(self: multilineEditbox, text: string, user: boolean) Called when an "changed" event is invoked after `multilineEditbox:SetText(...)` was called<p>@*param* `self` multilineEditbox ― Reference to the binary widget</p><p>@*param* `text` string ― The current value of the widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class multilineEditbox_listener_enabled : indexedEventHandler
			---@field handler multilineEditbox_handler_enabled Handler function to register for call

				---@alias multilineEditbox_handler_enabled
				---| fun(self: multilineEditbox, state: boolean, user: boolean) Called when an "enabled" event is invoked after `multilineEditbox:SetEnabled(...)` was called<p>@*param* `self` multilineEditbox ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class multilineEditbox_listener : indexedEventHandler
			---@field handler multilineEditbox_handler Handler function to register for call

				---@alias multilineEditbox_handler
				---| fun(self: multilineEditbox, ...: any) Called when a custom event is invoked<p>@*param* `self` multilineEditbox ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class multilineEditbox : textual, guiFrame
	---@field scrollframe InputScrollFrame
	---@field template EditBox
	---@field label FontString|nil
	---@field addListener multilineEditbox_addListener Hook a handler function as a listener for a widget event
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

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_textual]: true, [typename_multilineEditbox]: true, }
		function _:GetTypes() return {} end

			---@alias typename_multilineEditbox "MultilineEditbox"

		--[ Events ]

		---@class multilineEditbox_addListener : textual_addListener
		---@field [string] fun(handler: multilineEditbox_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler multilineEditbox_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler multilineEditbox_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler multilineEditbox_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler multilineEditbox_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end

--[ Copybox]

---Create a custom button with a toggled textline & editbox from which text can be copied
---@param t? copybox_options Optional parameters
---@return copybox copybox References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), its child widgets & their custom values, utility functions and more wrapped in a widget table
function wt.CreateCopybox(t)

	--| Parameters

	---Optional parameters
	---@class copybox_options : labeledChildFrame, tooltipDescribableWidget, arrangeableFrame, positionableFrame, visibleFrame
	---@field name? frameName ***Default:*** `"Copybox"`
	---@field width? nonNegativeNumber ***Default:***  `180`
	---@field height? nonNegativeNumber ***Default:*** `18`
	---@field layer? DrawLayer
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** `"GameFontNormalSmall"`<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via <code><i>WidgetToolbox</i>.CreateFont(...)</code> (even within this table definition).</li></ul>
	---@field color? color Apply the specified color to the text (overriding `t.font`)
	---@field justify? JustifyHorizontal Set the horizontal text alignment of the label (overriding `t.font`) | ***Default:*** `"LEFT"`
	---@field flipOnMouse? boolean Hide/Reveal the editbox on mouseover instead of after a click | ***Default:*** `false`
	---@field colorOnMouse? color If set, change the color of the text on mouseover to the specified color (if `t.flipOnMouse` is `false`) | ***Default:*** *no color change*
	---@field value? string The copyable text to be shown | ***Default:*** `""`

	--| Returns

	---@class copybox : guiFrame
	---@field label FontString|nil
	---@field textual customEditbox|textual|nil
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_copybox]: true,}
		function _:GetTypes() return {} end

			---@alias typename_copybox "Copybox"

	return {}
end

--[ Popup Inputbox]

---Show a movable input window with a textbox, accept and cancel buttons
---@param t? popupInputBoxData
function wt.CreatePopupInputbox(t)

	--| Parameters

	---Optional parameters
	---@class popupInputBoxData : positionableFrame, tooltipDescribableWidget
	---@field title? string Text to be displayed as the title | ***Default:*** *(no title)*
	---@field text? string Text to set as the starting text inside the input editbox | ***Default:*** `""`
	---@field accept? fun(text: string) Function to call when the inputted text is accepted
	---@field cancel? function Function to call when the inputted text is dismissed

		---@class tooltipDescribableWidget
		---@field tooltip? widgetTooltipTextData List of textlines to be added to the tooltip of the widget displayed when mousing over the frame

			---@class widgetTooltipTextData : tooltipTextData
			---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** `t.title`
end


--[[ NUMERIC ]]

---Create a non-GUI numeric datamanager widget instance with number data management logic
---@param t? numeric_options Optional parameters
---@return numeric numeric Reference to the new numeric widget, utility functions and more wrapped in a widget table
function wt.CreateNumeric(t)

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return boolean data
		local function reader() return false end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param data? boolean
		local function writer(data) end ---@cast writer +?

	---Optional parameters
	---@class numeric_options : datamanager_options
	---@field fractional? integer If the value is fractional, display this many decimal digits | ***Default:*** *the most amount of digits present in the fractional part of* `t.min`, `t.max` *or* `t.step`
	---@field min? number Lower numeric value limit | ***Range:*** (`any`, `t.max`) | ***Default:*** `0`
	---@field max? number Upper numeric value limit | ***Range:*** (`t.min`, `any`) | ***Default:*** 100
	---@field step? nonNegativeNumber Add/subtract this much when calling `numeric.increase(...)` or `numeric.decrease(...)` | ***Default:*** 10% of range (`t.min`, `t.max`)
	---@field altStep? nonNegativeNumber If set, add/subtract this much when calling `numeric.increase(...)` or `numeric.decrease(...)` with `alt == true` | ***Default:*** *no alternative step value*
	---@field hardStep? boolean Use `t.step` to force the slider jump to step values on drag | ***Default:*** `true`
	---@field listeners? numeric_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): value: number|nil Utility called to read the data from storage (and convert, evaluate or modify it as needed)<p>@*return* `value` number|nil | ***Default:*** `t.min`<p>
	---@field saveData? fun(value: number) Utility called to write the data to storage (and convert, evaluate or modify it as needed)<p>@*param* `value` number</p>
	---@field value? number The starting value of the widget to set during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid
	---@field default? number Default value of the widget | ***Default:*** `t.min`
	t = { reader = reader, writer = writer, }

		---@class numeric_listeners : datamanager_listeners
		---@field [1]? table<string, numeric_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field enabled? numeric_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `numeric:SetEnabled(...)` was called
		---@field loaded? numeric_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? numeric_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? numeric_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `numeric:SetNumber(...)` was called
		---@field min? numeric_listener_min[] Ordered list of functions to call when a "min" event is invoked after `numeric:SetMin(...)` was called
		---@field max? numeric_listener_max[] Ordered list of functions to call when a "max" event is invoked after `numeric:SetMax(...)` was called

			---@class numeric_listener_loaded : indexedEventHandler
			---@field handler numeric_handler_loaded Handler function to register for call

				---@alias numeric_handler_loaded
				---| fun(self: numeric, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` numeric ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class numeric_listener_saved : indexedEventHandler
			---@field handler numeric_handler_saved Handler function to register for call

				---@alias numeric_handler_saved
				---| fun(self: numeric, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` numeric ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class numeric_listener_changed : indexedEventHandler
			---@field handler numeric_handler_changed Handler function to register for call

				---@alias numeric_handler_changed
				---| fun(self: numeric, number: number, user: boolean) Called when an "changed" event is invoked after `numeric:SetNumber(...)` was called<p>@*param* `self` numeric ― Reference to the binary widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class numeric_listener_min : indexedEventHandler
			---@field handler numeric_handler_min Handler function to register for call

				---@alias numeric_handler_min
				---| fun(self: numeric, limitMin: number) Called when an "min" event is invoked after `numeric:SetMin(...)` was called<p>@*param* `self` numeric ― Reference to the binary widget</p><p>@*param* `limitMin` number ― The current lower limit of the number value of the widget</p>

			---@class numeric_listener_max : indexedEventHandler
			---@field handler numeric_handler_max Handler function to register for call

				---@alias numeric_handler_max
				---| fun(self: numeric, limitMax: number) Called when an "max" event is invoked after `numeric:SetMax(...)` was called<p>@*param* `self` numeric ― Reference to the binary widget</p><p>@*param* `limitMax` number ― The current upper limit of the number value of the widget</p>

			---@class numeric_listener_enabled : indexedEventHandler
			---@field handler numeric_handler_enabled Handler function to register for call

				---@alias numeric_handler_enabled
				---| fun(self: numeric, state: boolean, user: boolean) Called when an "enabled" event is invoked after `numeric:SetEnabled(...)` was called<p>@*param* `self` numeric ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class numeric_listener : indexedEventHandler
			---@field handler numeric_handler Handler function to register for call

				---@alias numeric_handler
				---| fun(self: numeric, ...: any) Called when a custom event is invoked<p>@*param* `self` numeric ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class numeric : datamanager
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_numeric]: true, }
		function _:GetTypes() return {} end

			---@alias typename_numeric "Numeric"

		--[ Events ]

		---@class numeric_invoke : datamanager_invoke
		---@field min function Invoke a "min" event to notify registered listeners and call handlers
		---@field max function Invoke a "max" event to notify registered listeners and call handlers

		---@class numeric_addListener : datamanager_addListener
		---@field [string] fun(handler: numeric_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler numeric_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler numeric_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler numeric_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for a "min" widget event
			---@param handler numeric_handler_min Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_min(handler, callIndex) end

			---Register a listener for a "max" widget event
			---@param handler numeric_handler_max Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_max(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler numeric_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Data ]

		---Verify and save the provided data or the current value of the widget to storage via the specified writer utility
		---***
		---@param number? number Data to be saved | ***Default:*** *current value*
		---@param silent? boolean If `false`, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _:SaveData(number, silent) end

		---Get the currently stored data via the specified reader utility
		---@return number|nil
		function _:GetData() end

		---Verify and save the provided data to storage via the specified writer utility then load it to the widget via `t.loadData()`
		---***
		---@param number? number Data to be saved | ***Default:*** *current value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:SetData(number, handleChanges, silent) end

		---Get the currently set default value
		---@return number default
		function _:GetDefault() return 0 end

		---Set the default value
		---@param number number | ***Default:*** *no change*
		function _:SetDefault(number) end

		---Returns the current value of the widget
		---@return number
		function _:GetValue() return 0 end

		---Set the value of the widget
		---***
		---@param number? number A valid number value within the specified `t.min`, `t.max` range | ***Default:*** `t.min`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _:SetValue(number, user, silent) end

		---Decrease the value of the widget by the specified step or alt step amount
		---@param alt? boolean If `true`, use alt step instead of step to decrease the value by | ***Default:*** `false`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _:Decrease(alt, user, silent) end

		---Increase the value of the widget by the specified step or alt step amount
		---@param alt? boolean If `true`, use alt step instead of step to increase the value by | ***Default:*** `false`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _:Increase(alt, user, silent) end

		--| Value limits

		---Return the current lower value limit of the widget
		---@return number
		function _:GetMin() return 0 end

		---Set the lower value limit of the widget
		---***
		---@param number number Updates the lower limit value | ***Range:*** (`any`, `numeric:GetMax()`) *capped automatically*
		---@param silent? boolean If `false`, invoke a "min" event and call registered listeners | ***Default:*** `false`
		function _:SetMin(number, silent) end

		---Return the current upper value limit of the widget
		---@return number
		function _:GetMax() return 0 end

		---Set the upper value limit of the widget
		---***
		---@param number number Updates the upper limit value | ***Range:*** (`numeric:GetMin()`, `any`) *floored automatically*
		---@param silent? boolean If `false`, invoke a "max" event and call registered listeners | ***Default:*** `false`
		function _:SetMax(number, silent) end

		--| Value step

		---Return the current value step of the widget
		---@return number
		function _:GetStep() return 0 end

		---Return the current alternative value step of the widget
		---@return number|nil
		function _:GetAltStep() end

	return _
end

--[ Slider]

---Create a Blizzard slider GUI frame instance with enhanced widget functionality
---@param t? slider_options Optional parameters
---@param ancestor? numeric Reference to an already existing numeric datamanager instance to turn into a slider instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return numericSlider|numeric # References to the new [Slider](https://warcraft.wiki.gg/wiki/UIOBJECT_Slider), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), child widgets, utility functions and more wrapped in a widget table
function wt.CreateSlider(t, ancestor, lite)

	--| Parameters

	---Optional parameters
	---@class slider_options : numeric_options, labeledChildFrame, tooltipDescribableWidget, arrangeableFrame, positionableFrame, widgetWidthValue, visibleFrame, eventFrame, tooltipDescribableSettingsWidget
	---@field name? frameName ***Default:*** `"Slider"`
	---@field valuebox? boolean Whether or not should the slider have an [EditBox](https://warcraft.wiki.gg/wiki/UIOBJECT_EditBox) as a child to manually enter a precise value to move the slider to | ***Default:*** `true`
	---@field listeners? slider_listeners|numeric_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field events? sliderEvents

		---@class slider_listeners : numeric_listeners
		---@field [1]? table<string, slider_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? slider_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? slider_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? slider_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `slider:SetNumber(...)` was called
		---@field min? slider_listener_min[] Ordered list of functions to call when a "min" event is invoked after `slider:SetMin(...)` was called
		---@field max? slider_listener_max[] Ordered list of functions to call when a "max" event is invoked after `slider:SetMax(...)` was called
		---@field enabled? slider_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `slider:SetEnabled(...)` was called

			---@class slider_listener_loaded : indexedEventHandler
			---@field handler slider_handler_loaded Handler function to register for call

				---@alias slider_handler_loaded
				---| fun(self: slider, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class slider_listener_saved : indexedEventHandler
			---@field handler slider_handler_saved Handler function to register for call

				---@alias slider_handler_saved
				---| fun(self: slider, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class slider_listener_changed : indexedEventHandler
			---@field handler slider_handler_changed Handler function to register for call

				---@alias slider_handler_changed
				---| fun(self: slider, number: number, user: boolean) Called when an "changed" event is invoked after `slider:SetNumber(...)` was called<p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class slider_listener_min : indexedEventHandler
			---@field handler slider_handler_min Handler function to register for call

				---@alias slider_handler_min
				---| fun(self: slider, limitMin: number) Called when an "min" event is invoked after `slider:SetMin(...)` was called<p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `limitMin` number ― The current lower limit of the number value of the widget</p>

			---@class slider_listener_max : indexedEventHandler
			---@field handler slider_handler_max Handler function to register for call

				---@alias slider_handler_max
				---| fun(self: slider, limitMax: number) Called when an "max" event is invoked after `slider:SetMax(...)` was called<p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `limitMax` number ― The current upper limit of the number value of the widget</p>

			---@class slider_listener_enabled : indexedEventHandler
			---@field handler slider_handler_enabled Handler function to register for call

				---@alias slider_handler_enabled
				---| fun(self: slider, state: boolean, user: boolean) Called when an "enabled" event is invoked after `slider:SetEnabled(...)` was called<p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class slider_listener : indexedEventHandler
			---@field handler slider_handler Handler function to register for call

				---@alias slider_handler
				---| fun(self: slider, ...: any) Called when a custom event is invoked<p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

		--- - ***Note:*** Use `t.onEvent` to set [`"OnEvent"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) handlers for global events.
		--- - ***Note:*** Use `t.attributes` to set [`"OnAttributeChanged"`](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) handlers for custom frame attribute change events.
		---@alias sliderEvents scriptHandlers_Slider

	--| Return

	---@class numericSlider : numeric, guiFrame
	---@field template MinimalSliderWithSteppers
	---@field valuebox customEditbox|textual
	---@field addListener slider_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		---NOTE: Incomplete Toolbox-relevant definition for a Frame of `"MinimalSliderWithSteppersTemplate"`
		---@class MinimalSliderWithSteppers : Slider
		---@field Slider Slider Main slider frame
		---@field Back Button Decrease value button
		---@field Forward Button Increase value button
		---@field TopText FontString Title text
		---@field MinText FontString Min value text
		---@field MaxText FontString Max value text

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_numeric]: true, [typename_slider]: true, }
		function _:GetTypes() return {} end

			---@alias typename_slider "Slider"

		--[ Events ]

		---@class slider_addListener : numeric_addListener
		---@field [string] fun(handler: slider_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler slider_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler slider_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler slider_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for a "min" widget event
			---@param handler slider_handler_min Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_min(handler, callIndex) end

			---Register a listener for a "max" widget event
			---@param handler slider_handler_max Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_max(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler slider_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end

---Create a classic Blizzard slider GUI frame instance with enhanced widget functionality
---@param t? classicSlider_options Optional parameters
---@param ancestor? numeric Reference to an already existing numeric datamanager instance to turn into a classic slider instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return classicSlider|numeric # References to the new [Slider](https://warcraft.wiki.gg/wiki/UIOBJECT_Slider), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), child widgets, utility functions and more wrapped in a widget table
function wt.CreateClassicSlider(t, ancestor, lite)

	--| Parameters

	---Optional parameters
	---@class classicSlider_options : slider_options
	---@field sideButtons? boolean Whether or not to add increase/decrease buttons next to the slider to change the value by the increment set in `t.step` | ***Default:*** `true`
	---@field listeners? classicSlider_listeners|numeric_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class classicSlider_listeners : numeric_listeners
		---@field [1]? table<string, classicSlider_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? classicSlider_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? classicSlider_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? classicSlider_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `classicSlider:SetNumber(...)` was called
		---@field min? classicSlider_listener_min[] Ordered list of functions to call when a "min" event is invoked after `classicSlider:SetMin(...)` was called
		---@field max? classicSlider_listener_max[] Ordered list of functions to call when a "max" event is invoked after `classicSlider:SetMax(...)` was called
		---@field enabled? classicSlider_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `classicSlider:SetEnabled(...)` was called

			---@class classicSlider_listener_loaded : indexedEventHandler
			---@field handler classicSlider_handler_loaded Handler function to register for call

				---@alias classicSlider_handler_loaded
				---| fun(self: slider, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class classicSlider_listener_saved : indexedEventHandler
			---@field handler classicSlider_handler_saved Handler function to register for call

				---@alias classicSlider_handler_saved
				---| fun(self: slider, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class classicSlider_listener_changed : indexedEventHandler
			---@field handler classicSlider_handler_changed Handler function to register for call

				---@alias classicSlider_handler_changed
				---| fun(self: slider, number: number, user: boolean) Called when an "changed" event is invoked after `classicSlider:SetNumber(...)` was called<p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class classicSlider_listener_min : indexedEventHandler
			---@field handler classicSlider_handler_min Handler function to register for call

				---@alias classicSlider_handler_min
				---| fun(self: slider, limitMin: number) Called when an "min" event is invoked after `classicSlider:SetMin(...)` was called<p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `limitMin` number ― The current lower limit of the number value of the widget</p>

			---@class classicSlider_listener_max : indexedEventHandler
			---@field handler classicSlider_handler_max Handler function to register for call

				---@alias classicSlider_handler_max
				---| fun(self: slider, limitMax: number) Called when an "max" event is invoked after `classicSlider:SetMax(...)` was called<p>@*param* `self` slider ― Reference to the binary widget</p><p>@*param* `limitMax` number ― The current upper limit of the number value of the widget</p>

			---@class classicSlider_listener_enabled : indexedEventHandler
			---@field handler classicSlider_handler_enabled Handler function to register for call

				---@alias classicSlider_handler_enabled
				---| fun(self: slider, state: boolean, user: boolean) Called when an "enabled" event is invoked after `classicSlider:SetEnabled(...)` was called<p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class classicSlider_listener : indexedEventHandler
			---@field handler classicSlider_handler Handler function to register for call

				---@alias classicSlider_handler
				---| fun(self: slider, ...: any) Called when a custom event is invoked<p>@*param* `self` slider ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Return

	---@class classicSlider : numeric, guiFrame
	---@field template Slider
	---@field label FontString|nil
	---@field min FontString
	---@field max FontString
	---@field valuebox customEditbox|textual
	---@field decreaseButton customButton|action
	---@field increaseButton customButton|action
	---@field addListener classicSlider_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_numeric]: true, [typename_classicSlider]: true, }
		function _:GetTypes() return {} end

			---@alias typename_classicSlider "ClassicSlider"

		--[ Events ]

		---@class classicSlider_addListener : numeric_addListener
		---@field [string] fun(handler: classicSlider_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler classicSlider_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler classicSlider_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "changed" widget event
			---@param handler classicSlider_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for a "min" widget event
			---@param handler classicSlider_handler_min Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_min(handler, callIndex) end

			---Register a listener for a "max" widget event
			---@param handler classicSlider_handler_max Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_max(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler classicSlider_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end


--[[ COLOR ]]

---Create a non-GUI colormanager datamanager widget instance with color data management logic
---@param t? colormanager_options Optional parameters
---@return colormanager colormanager Reference to the new color pick manager widget, utility functions and more wrapped in a widget table
function wt.CreateColormanager(t)

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return boolean data
		local function reader() return false end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param data? boolean
		local function writer(data) end ---@cast writer +?

	---Optional parameters
	---@class colormanager_options : datamanager_options
	---@field listeners? colormanager_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field onCancel? function The function to be called when the color change is cancelled (after calling `t.onColorUpdate`)
	---@field getData? fun(): color: color|nil Utility called to read the data from storage (and convert, evaluate or modify it as needed)<p>@*return* `color` colorData|nil | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`</p>
	---@field saveData? fun(color: color) Utility called to write the data to storage (and convert, evaluate or modify it as needed)<p>@*param* `color` colorData</p>
	---@field value? colorData_whiteDefault Values to use as the starting color set during initialization | ***Default:*** `t.data.read()` or `t.default` if invalid<ul><li>***Note:*** If the alpha start value was not set, configure the color picker to handle RBG values exclusively instead of the full RGBA.</li></ul>
	---@field default? color Default value of the widget | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`

		---@class colormanager_listeners : datamanager_listeners
		---@field [1]? table<string, colormanager_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? colormanager_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? colormanager_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? colormanager_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `colormanager:SetColor(...)` was called
		---@field enabled? colormanager_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `colormanager:SetEnabled(...)` was called

			---@class colormanager_listener_loaded : indexedEventHandler
			---@field handler colormanager_handler_loaded Handler function to register for call

				---@alias colormanager_handler_loaded
				---| fun(self: colormanager, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` colormanager ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class colormanager_listener_saved : indexedEventHandler
			---@field handler colormanager_handler_saved Handler function to register for call

				---@alias colormanager_handler_saved
				---| fun(self: colormanager, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` colormanager ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class colormanager_listener_changed : indexedEventHandler
			---@field handler colormanager_handler_changed Handler function to register for call

				---@alias colormanager_handler_changed
				---| fun(self: colormanager, color: color, user: boolean) Called when an "changed" event is invoked after `colormanager:SetColor(...)` was called<p>@*param* `self` colormanager ― Reference to the binary widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class colormanager_listener_enabled : indexedEventHandler
			---@field handler colormanager_handler_enabled Handler function to register for call

				---@alias colormanager_handler_enabled
				---| fun(self: colormanager, state: boolean, user: boolean) Called when an "enabled" event is invoked after `colormanager:SetEnabled(...)` was called<p>@*param* `self` colormanager ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class colormanager_listener : indexedEventHandler
			---@field handler colormanager_handler Handler function to register for call

				---@alias colormanager_handler
				---| fun(self: colormanager, ...: any) Called when a custom event is invoked<p>@*param* `self` colormanager ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class colormanager : datamanager
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_colormanager]: true, }
		function _:GetTypes() return {} end

			---@alias typename_colormanager "Colormanager"

		--[ Events ]

		---@class colormanager_addListener : datamanager_addListener
		---@field [string] fun(handler: colormanager_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler colormanager_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler colormanager_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "colored" widget event
			---@param handler colormanager_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_colored(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler colormanager_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Data ]

		---Verify and save the provided data or the current value of the widget to storage via the specified writer utility
		---***
		---@param color? color Data to be saved | ***Default:*** *current value*
		---@param silent? boolean If `false`, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _:SaveData(color, silent) end

		---Get the currently stored data via the specified reader utility
		---@return color|nil
		function _:GetData() end

		---Verify and save the provided data to storage via the specified writer utility then load it to the widget via `t.loadData()`
		---***
		---@param color? color Data to be saved | ***Default:*** *current value*
		---@param handleChanges? boolean If `true`, call the specified `t.onChange` handlers | ***Default:*** `true`
		---@param silent? boolean If `false`, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _:SetData(color, handleChanges, silent) end

		---Get the currently set default value
		---@return color default
		function _:GetDefault() return {} end

		---Set the default value
		---@param color? color | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
		function _:SetDefault(color) end

		---Returns the currently set channel values wrapped in a color table
		---@return color
		function _:GetValue() return {} end

		---Set the managed color values
		---***
		---@param color? color ***Default:*** { r = 1, g = 1, b = 1, a = 1 } *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "colored" event and call registered listeners | ***Default:*** `false`
		function _:SetValue(color, user, silent) end

		--[ Color Wheel ]

		---Open the the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) for this color manager
		function _:OpenColorPicker() end

		---Return the active status of this color manager, whether the main color wheel window was opened for and is currently updating the color of this widget
		---@return boolean active `true` if the color wheel has been opened for this color manager widget
		function _:IsActive() return false end

	return _
end

--[ Colorpicker ]

---Create a color picker GUI frame instance with HEX(A) & RGB(A) input while utilizing the [ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame) wheel
---@param t? colorpicker_options Optional parameters
---@param ancestor? colormanager Reference to an already existing color datamanager instance to turn into a colorpicker instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return colorpicker|colormanager # Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a widget table
function wt.CreateColorpicker(t, ancestor, lite)

	--| Properties

	---Optional parameters
	---@class colorpicker_options : colormanager_options, labeledChildFrame, tooltipDescribableWidget, arrangeableFrame, positionableFrame, visibleFrame, eventFrame, tooltipDescribableSettingsWidget
	---@field name? frameName ***Default:*** `"Colorpicker"`
	---@field width? nonNegativeNumber The height is defaulted to 36, the width may be specified | ***Default:*** 120
	---@field listeners? colorpicker_listeners|colormanager_listeners|datamanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class colorpicker_listeners : colormanager_listeners
		---@field [1]? table<string, colorpicker_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? colorpicker_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? colorpicker_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? colorpicker_listener_changed[] Ordered list of functions to call when a "changed" event is invoked after `colorpicker:SetColor(...)` was called
		---@field enabled? colorpicker_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `colorpicker:SetEnabled(...)` was called

			---@class colorpicker_listener_loaded : indexedEventHandler
			---@field handler colorpicker_handler_loaded Handler function to register for call

				---@alias colorpicker_handler_loaded
				---| fun(self: colorpicker, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<p>@*param* `self` colorpicker ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was returned by `t.data.read()` and it was loaded to the widget</p>

			---@class colorpicker_listener_saved : indexedEventHandler
			---@field handler colorpicker_handler_saved Handler function to register for call

				---@alias colorpicker_handler_saved
				---| fun(self: colorpicker, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<p>@*param* `self` colorpicker ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if data was committed successfully via `t.data.write(...)`</p>

			---@class colorpicker_listener_changed : indexedEventHandler
			---@field handler colorpicker_handler_changed Handler function to register for call

				---@alias colorpicker_handler_changed
				---| fun(self: colorpicker, color: color, user: boolean) Called when an "changed" event is invoked after `colorpicker:SetColor(...)` was called<p>@*param* `self` colorpicker ― Reference to the binary widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class colorpicker_listener_enabled : indexedEventHandler
			---@field handler colorpicker_handler_enabled Handler function to register for call

				---@alias colorpicker_handler_enabled
				---| fun(self: colorpicker, state: boolean, user: boolean) Called when an "enabled" event is invoked after `colorpicker:SetEnabled(...)` was called<p>@*param* `self` colorpicker ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class colorpicker_listener : indexedEventHandler
			---@field handler colorpicker_handler Handler function to register for call

				---@alias colorpicker_handler
				---| fun(self: colorpicker, ...: any) Called when a custom event is invoked<p>@*param* `self` colorpicker ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class colorpicker : colormanager, guiFrame
	---@field label FontString|nil
	---@field button colorpickerButton|customButton|action
	---@field hexBox customEditbox|textual
	---@field addListener colorpicker_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		---Button to open the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) with
		---@class colorpickerButton : customButton
		---@field gradient Texture
		---@field checker Texture

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_datamanager]: true, [typename_colormanager]: true, [typename_colorpicker]: true, }
		function _:GetTypes() return {} end

			---@alias typename_colorpicker "Colorpicker"

		--[ Events ]

		---@class colorpicker_addListener : colormanager_addListener
		---@field [string] fun(handler: colorpicker_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler colorpicker_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler colorpicker_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "colored" widget event
			---@param handler colorpicker_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_colored(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler colorpicker_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

	return _
end


--[[ POSITION ]]

---Create a non-GUI position datamanager widget instance with frame positioning data management logic
---@param t positionmanager_options Optional parameters
---@return positionmanager positionmanager Reference to the new positionmanager widget, utility functions and more wrapped in a widget table
function wt.CreatePositionmanager(t)

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return boolean data
		local function reader() return false end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param data? boolean
		local function writer(data) end ---@cast writer +?

	---Optional parameters
	---@class positionmanager_options : datamanager_options, settingsmanager_options
	t = { reader = reader, writer = writer, }

	--| Returns

	---@class positionmanager : widget
	local _ = {}

	---@alias typename_positionmanager "Positionmanager"

	return _
end

--[ Panel ]

---Create and set up a positionmanager widget instance for a specified frame within an options panel frame
---@param addon uiAddon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
---@param frame AnyFrameObject Reference to the frame to create the settings for
---@param getData fun(): table: positionPresetData|table Return a reference to the table within a SavedVariables(PerCharacter) addon database where data is committed to
---@param defaultData positionPresetData|table Reference to the table containing the default values<ul><li>***Note:*** The defaults table should contain values under matching keys to the values within *t.data.read()*.</li></ul>
---@param settingsData positionOptionsSettingsData|table Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from<ul><li>***Note:*** A boolean value will be created under the key `keepInPlace` if it didn't already exist in this table.</li></ul>
---@param t positionManagement_options Optional parameters
---@return positionPanel? table Components of the settings panel wrapped in a table | ***Default:*** `nil`
function wt.CreatePositionOptions(addon, frame, getData, defaultData, settingsData, t)

	--| Parameters

	---@class positionPresetData # defaultData
	---@field position positionData Table of parameters to call [`frame:SetPoint(...)`](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with
	---@field keepInBounds? boolean Whether to keep the frame within screen bounds whenever it's moved | ***Default:*** `false`
	---@field layer? widgetLayerOptions Table containing the screen layer parameters of the frame

		---@class widgetLayerOptions
		---@field strata? FrameStrata Strata to pin the frame to
		---@field level? integer The level of the frame to appear in within the specified strata
		---@field keepOnTop? boolean Whether to raise the frame level on mouse interaction | ***Default:*** `false`

	---@class positionOptionsSettingsData # settingsData
	---@field keepInPlace boolean If `true`, don't move `frame` when changing the anchor, update the offset values instead.

	---Optional parameters
	---@class positionManagement_options : settingsWidgetPanel_frame
	---@field presets? presetItemList Reference to the table containing `frame` position presets to be managed by settings widgets added when set
	---@field setMovable? movabilityData_position When specified, set `frame` as movable, dynamically updating the position settings widgets when it's moved by the user
	---@field dataManagement? settingsData_position Register the widgets to settings data management to be linked with the specified key under the specified category
	---@field onChangePosition? function Function to call after the value of `panel.widgets.position.anchor` `panel.widgets.position.relativeTo` `panel.widgets.position.relativePoint` `panel.widgets.position.offset.x` or `panel.widgets.position.offset.y` was changed by the user or via settings data management before the base onChange handler is called built-in to the functionality of the settings panel template updating the position of `frame`
	---@field onChangeKeepInBounds? function Function to call after the value of `panel.widgets.position.keepInBounds` was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating `frame`
	---@field onChangeStrata? function Function to call after the value of `panel.widgets.layer.strata` was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating `frame`
	---@field onChangeLevel? function Function to call after the value of `panel.widgets.layer.level` was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating `frame`
	---@field onChangeKeepOnTop? function Function to call after the value of `panel.widgets.layer.keepOnTop` was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating `frame`

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
	---@field panel panel
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
		function _:ApplyPreset(i) return false end

		---Save the current position & visibility to the custom preset
		--- - ***Note:*** If the custom preset position data doesn't contain relative frame and point key, value pairs, the position will be converted to absolute position when saved.
		function _:SaveCustomPreset() end

		--Reset the custom preset to its default state
		function _:ResetCustomPreset() end

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_positionmanager]: true, [typename_positionPanel]: true,  }
		function _:GetTypes() return {} end

			---@alias typename_positionPanel "PositionOptions"

end


--[[ FONT ]]

---Create a non-GUI font datamanager widget instance with font customization data management logic
---@param t fontmanager_options Optional parameters
---@return fontmanager fontmanager Reference to the new fontmanager widget, utility functions and more wrapped in a widget table
function wt.CreateFontmanager(t)

	--| Parameters

		---Utility called to read the data from storage (and convert, evaluate or modify it as needed)
		---***
		---@return boolean data
		local function reader() return false end ---@cast reader +?

		---Utility called to write the data to storage (and convert, evaluate or modify it as needed)
		---***
		---@param data? boolean
		local function writer(data) end ---@cast writer +?

	---Optional parameters
	---@class fontmanager_options : datamanager_options, settingsmanager_options
	t = { reader = reader, writer = writer, }

	--| Returns

	---@class fontmanager : widget
	local _ = {}

	---@alias typename_fontmanager "Fontmanager"

	return _
end

--[ Panel ]

---Create and set up a fontmanager widget instance for a specified text object ([FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString)) including access to a font family selector dropdown to pick a custom font from the Widget Tools fonts list
---@param addon uiAddon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
---@param textline FontString Reference to the text object to create font options for
---@param getData fun(): table: fontOptionsData Return a reference to the table within a SavedVariables(PerCharacter) addon database where data is committed to
---@param defaultData fontOptionsData Reference to the table containing the default values
---@param t fontManagement_options Optional parameters
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

	---Optional parameters
	---@class fontManagement_options : settingsWidgetPanel_text
	---@field colors? table<string, textColorInfo> Use this list of specifications to dictate what colors appear and how: their order and displayed name | ***Default:*** *none*<ul><li>***Note:*** If set, the default color of key "base" will be added if it's missing.</ul></li>
	---@field dataManagement? settingsData_font Register the widgets to settings data management to be linked with the specified key under the specified category
	---@field onChangeFont? function Function to call after the value of `panel.widgets.path` or `panel.widgets.size` was changed by the user or via settings data management before the base onChange handler is called built-in to the functionality of the settings panel template updating the position of `text`
	---@field onChangeSize? function Function to call after the value of `panel.widgets.position.keepInBounds` was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating `text`
	---@field onChangeAlignment? function Function to call after the value of `panel.widgets.layer.strata` was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating `text`
	---@field onChangeColor? fun(color: string) Function to call after the value of `panel.widgets.layer.level` was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating `text`

		---@class settingsWidgetPanel_text : settingsWidgetPanel_base
		---@field name? string Refer to `text` by this display name in the tooltips and descriptions of settings widgets | ***Default:*** `text:GetName()`

		---@class textColorInfo
		---@field index? integer Ordering index of the color | ***Default:*** *unspecified*
		---@field name? string Display name to set their widget and tooltip titles paired to their data management keys | ***Default:*** *data management key in Title case*
		---@field wrap? boolean If `true`, wrap the list of colors at this color (starting this one in a new row) | ***Default:*** `index == 1`

		---@class settingsData_font : settingsData_base
		---@field key? string A unique string appended to `category` linking a subset of settings data rules to be handled together | ***Default:*** `"Font"`

	--| Returns

	---@class fontPanel : fontmanager
	---@field panel panel
	---@field widgets fontPanelWidgets
	local _ = {}

		---@class fontPanelWidgets
		---@field path selector|dropdownRadiogroup
		---@field size numeric|numericSlider
		---@field alignment specialSelector|specialRadiogroup
		---@field colors (colormanager|colorpicker)[]|nil

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_fontmanager]: true, [typename_fontPanel]: true, }
		function _:GetTypes() return {} end

			---@alias typename_fontPanel "FontOptions"
end


--[[ SETTINGS ]]

---Create a non-GUI settingsmanager widget instance
---@param t settingsmanager_options Optional parameters
---@return settingsmanager settingsmanager Reference to the new settingsmanager widget, utility functions and more wrapped in a widget table
function wt.CreateSettingsmanager(t)

	--| Parameters

	---Optional parameters
	---@class settingsmanager_options : settingsmanager_options_base, describableFrame, togglableObject, settingsCategoryData, settingsmanagerEvents, initializableOptionsContainer
	---@field append? boolean When setting the name of the settings category page, append `t.name` after `addon` | ***Default:*** `true` if `t.name` ~= nil
	---@field autoSave? boolean If `true`, automatically save the values of all widgets registered for settings data management under settings keys listed in `t.dataManagement.keys`, committing their data to storage via <code><i>WidgetToolbox</i>.SaveOptionsData(...)</code> | ***Default:*** `true` if `t.dataManagement.keys` ~= nil<ul><li>***Note:*** If `t.dataManagement.keys` is not set, the automatic load will not be executed even if this is set to `true`.</li></ul>
	---@field autoLoad? boolean If `true`, automatically load all data to the widgets registered for settings data management under settings keys listed in `t.dataManagement.keys` from storage via <code><i>WidgetToolbox</i>.LoadOptionsData(...)</code> | ***Default:*** `true` if `t.dataManagement.keys` ~= nil<ul><li>***Note:*** If `t.dataManagement.keys` is not set, the automatic load will not be executed even if this is set to `true`.</li></ul>
	---@field listeners? settingsmanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class settingsmanager_options_base : widget_options
		---@field register? boolean|settingsPage If `true`, register the new page to the Settings panel as a parent category or a subcategory of an already registered parent category if a reference to an existing settings category parent page provided | ***Default:*** `false`<ul><li>***Note:*** The page can be registered later via <code><i>WidgetToolbox</i>.RegisterSettingsPage(...)</code>.</li></ul>
		---@field name? frameName ***Default:*** `addon`
		---@field title? string Text to be shown as the title of the settings page | ***Default:*** [`GetAddOnMetadata(addon, "title")`](https://warcraft.wiki.gg/wiki/API_C_AddOns.GetAddOnMetadata)
		---@field static? boolean If `true`, disable the "Restore Defaults" & "Revert Changes" buttons | ***Default:*** `false`

		---@class settingsCategoryData
		---@field dataManagement? settingsData_collection If set, register this settings page to settings data management for batched data saving & loading and handling data changes of all linked widgets

			---@class settingsData_collection : settingsData_base
			---@field keys? string[] An ordered list of unique strings appended to `category` linking a subset of settings data rules to be handled together in the specified order via this settings category page | ***Default:*** `{ t.name }`

				---@class settingsData_base
				---@field category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** `addon`

		---@class settingsmanagerEvents
		---@field onLoad? fun(user: boolean) Called after the data of the settings widgets linked to this page has been loaded from storage<p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onSave? fun(user: boolean) Called after the data of the settings widgets linked to this page has been committed to storage<p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onApply? fun(user: boolean) Called after the data of the settings widgets linked to this page has been applied by calling change handlers<p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onCancel? fun(user: boolean) Called after the changes are scrapped (for instance when the custom "Revert Changes" button is clicked)<p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onDefault? fun(user: boolean, category: boolean) Called after settings data handled by this settings page has been restored to default values (for example when the "Accept" or "These Settings" - affecting this settings category page only - is clicked in the dialogue opened by clicking on the "Restore Defaults" button)<p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p><p>@*param* `category` boolean — Marking whether the call is through <code>[<i>settingsCategory</i>].defaults(...)</code> or not (or example when "All Settings" have been clicked)</p>

		---@class initializableOptionsContainer : initializableContainerFrame
		---@field initialize? fun(canvas?: Frame, width: number, height: number, category?: string, keys?: string[], name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<p>@*param* `canvas`? AnyFrameObject ― Reference to the frame to be set as the parent for child objects created during initialization (`nil` if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `width` number The current width of the container frame (0 if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `height` number The current height of the container frame (0 if `WidgetToolsDB.lite` is `true`)</p><p>@*param* `category`? string A unique string used for categorizing settings data management rules & change handler scripts</p><p>@*param* `keys`? string[] Reference to `t.dataManagement.keys`, a list of unique strings appended to `category` linking a subset of settings data rules to be handled together in the specified order</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

		---@class settingsmanager_listeners : widget_listeners
		---@field [1]? table<string, settingsmanager_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? settingsmanager_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after `settingsmanager:Load(...)` was called
		---@field saved? settingsmanager_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after `settingsmanager:Save(...)` was called
		---@field applied? settingsmanager_listener_applied[] Ordered list of functions to call when a "applied" event is invoked after `settingsmanager:Apply(...)` was called
		---@field reverted? settingsmanager_listener_reverted[] Ordered list of functions to call when a "reverted" event is invoked after `settingsmanager:Revert(...)` was called
		---@field reset? settingsmanager_listener_reset[] Ordered list of functions to call when a "reset" event is invoked after `settingsmanager:Reset(...)` was called
		---@field enabled? settingsmanager_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `settingsmanager:SetEnabled(...)` was called

			---@class settingsmanager_listener_loaded : indexedEventHandler
			---@field handler settingsmanager_handler_loaded Handler function to register for call

				---@alias settingsmanager_handler_loaded
				---| fun(self: settingsmanager, user: boolean) Called when an "loaded" event is invoked after `settingsmanager:Load(...)` was called<p>@*param* `self` settingsmanager ― Reference to the settingsmanager widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsmanager_listener_saved : indexedEventHandler
			---@field handler settingsmanager_handler_saved Handler function to register for call

				---@alias settingsmanager_handler_saved
				---| fun(self: settingsmanager, user: boolean) Called when an "saved" event is invoked after `settingsmanager:Save(...)` was called<p>@*param* `self` settingsmanager ― Reference to the settingsmanager widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsmanager_listener_applied : indexedEventHandler
			---@field handler settingsmanager_handler_applied Handler function to register for call

				---@alias settingsmanager_handler_applied
				---| fun(self: settingsmanager, user: boolean) Called when an "applied" event is invoked after `settingsmanager:Apply(...)` was called<p>@*param* `self` settingsmanager ― Reference to the settingsmanager widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsmanager_listener_reverted : indexedEventHandler
			---@field handler settingsmanager_handler_reverted Handler function to register for call

				---@alias settingsmanager_handler_reverted
				---| fun(self: settingsmanager, user: boolean) Called when an "revert" event is invoked after `settingsmanager:Revert(...)` was called<p>@*param* `self` settingsmanager ― Reference to the settingsmanager widget</p><<p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsmanager_listener_reset : indexedEventHandler
			---@field handler settingsmanager_handler_reset Handler function to register for call

				---@alias settingsmanager_handler_reset
				---| fun(self: settingsmanager, user: boolean) Called when an "reset" event is invoked after `settingsmanager:Reset(...)` was called<p>@*param* `self` settingsmanager ― Reference to the settingsmanager widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsmanager_listener_enabled : indexedEventHandler
			---@field handler settingsmanager_handler_enabled Handler function to register for call

				---@alias settingsmanager_handler_enabled
				---| fun(self: settingsmanager, state: boolean, user: boolean) Called when an "enabled" event is invoked after `settingsmanager:SetEnabled(...)` was called<p>@*param* `self` settingsmanager ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsmanager_listener : indexedEventHandler
			---@field handler settingsmanager_handler Handler function to register for call

				---@alias settingsmanager_handler
				---| fun(self: settingsmanager, ...: any) Called when a custom event is invoked<p>@*param* `self` settingsmanager ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>	

	--| Returns

	---@class settingsmanager : widget
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_settingsmanager]: true, }
		function _:GetTypes() return {} end

			---@alias typename_settingsmanager "Settingsmanager"

		--[ Events ]

		---@class settingsmanager_invoke : widget_invoke
		---@field loaded fun(user: boolean) Invoke a "loaded" event to notify registered listeners and call handlers
		---@field saved fun(user: boolean) Invoke a "saved" event to notify registered listeners and call handlers
		---@field applied fun(user: boolean) Invoke a "applied" event to notify registered listeners and call handlers
		---@field reverted fun(user: boolean) Invoke a "reverted" event to notify registered listeners and call handlers
		---@field reset fun(user: boolean) Invoke a "reset" event to notify registered listeners and call handlers

		---@class settingsmanager_addListener : widget_addListener
		---@field [string] fun(handler: settingsmanager_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler settingsmanager_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler settingsmanager_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "applied" widget event
			---@param handler settingsmanager_handler_applied Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_applied(handler, callIndex) end

			---Register a listener for a "reverted" widget event
			---@param handler settingsmanager_handler_reverted Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_reverted(handler, callIndex) end

			---Register a listener for a "reset" widget event
			---@param handler settingsmanager_handler_reset Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_reset(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler settingsmanager_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Batched Data Management ]

		---Force update all linked settings widgets in this category page
		---***
		---@param handleChanges? boolean If `true`, also call all registered change handlers | ***Default:*** `false`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _:Load(handleChanges, user, silent) end

		---Force save all settings data of this category page from all linked widgets
		---***
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _:Save(user, silent) end

		---Apply settings data of this category page by calling all registered `onChange` handlers of all linked widgets
		---***
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke an "applied" event and call registered listeners | ***Default:*** `false`
		function _:Apply(user, silent) end

		---Revert any changes made in this category page and reload all linked widget data
		---***
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "reverted" event and call registered listeners | ***Default:*** `false`
		function _:Revert(user, silent) end

		---Reset all settings data of this category page to default values
		---***
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "reset" event and call registered listeners | ***Default:*** `false`
		function _:Reset(user, silent) end

	return _
end

--[ Settings Page ]

---Create an new settings page and add it to the Options menu
---@param t? settingsPage_options Optional parameters
---@param ancestor? settingsmanager Reference to an already existing settings datamanager instance to turn into a settings page instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@return settingsPage|settingsmanager page Table containing references to the settings canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions
function wt.CreateSettingsPage(t, ancestor)

	--| Parameters

	---Optional parameters
	---@class settingsPage_options : settingsmanager_options_base, describableFrame, settingsCategoryData, settingsmanagerEvents, initializableOptionsContainer
	---@field append? boolean When setting the name of the settings category page, append `t.name` after `addon` | ***Default:*** `true` if `t.name` ~= nil
	---@field icon? string Path to the texture file to use as the icon of this settings page | ***Default:*** *the addon's logo specified in its TOC file with the "IconTexture" tag*
	---@field titleIcon? boolean Append `t.icon` to the title of the button of the setting page in the AddOns list of the Settings window as well | ***Default:*** `true` if `t.register == true`
	---@field scroll? settingsPageScrollData If set, make the canvas frame scrollable by creating a [ScrollFrame](https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame) as its child
	---@field autoSave? boolean If `true`, automatically save the values of all widgets registered for settings data management under settings keys listed in `t.dataManagement.keys`, committing their data to storage via <code><i>WidgetToolbox</i>.SaveOptionsData(...)</code> | ***Default:*** `true` if `t.dataManagement.keys` ~= nil<ul><li>***Note:*** If `t.dataManagement.keys` is not set, the automatic load will not be executed even if this is set to `true`.</li></ul>
	---@field autoLoad? boolean If `true`, automatically load all data to the widgets registered for settings data management under settings keys listed in `t.dataManagement.keys` from storage via <code><i>WidgetToolbox</i>.LoadOptionsData(...)</code> | ***Default:*** `true` if `t.dataManagement.keys` ~= nil<ul><li>***Note:*** If `t.dataManagement.keys` is not set, the automatic load will not be executed even if this is set to `true`.</li></ul>
	---@field arrangement? arrangementData_settingsPage If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table
	---@field listeners? settingsPage_listeners|settingsmanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class settingsPageScrollData : scrollSpeedData
		---@field height? nonNegativeNumber Set the height of the scrollable child frame to the specified value | ***Default:*** `0` *(no height)*
		---@field speed? normalizedNumber Percentage of one page of content to scroll at a time | ***Default:*** `0.25`

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
		---@field [1]? table<string, settingsPage_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? settingsPage_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after `settingsPage:Load(...)` was called
		---@field saved? settingsPage_listener_saved[] Ordered list of functions to call when an "saved" event is invoked after `settingsPage:Save(...)` was called
		---@field applied? settingsPage_listener_applied[] Ordered list of functions to call when a "applied" event is invoked after `settingsPage:Apply(...)` was called
		---@field reverted? settingsPage_listener_reverted[] Ordered list of functions to call when a "reverted" event is invoked after `settingsPage:Revert(...)` was called
		---@field reset? settingsPage_listener_reset[] Ordered list of functions to call when a "reset" event is invoked after `settingsPage:Reset(...)` was called
		---@field enabled? settingsPage_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `settingsPage:SetEnabled(...)` was called

			---@class settingsPage_listener_loaded : indexedEventHandler
			---@field handler settingsPage_handler_loaded Handler function to register for call

				---@alias settingsPage_handler_loaded
				---| fun(self: settingsPage, user: boolean) Called when an "loaded" event is invoked after `settingsPage:Load(...)` was called<p>@*param* `self` settingsPage ― Reference to the settingsPage widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsPage_listener_saved : indexedEventHandler
			---@field handler settingsPage_handler_saved Handler function to register for call

				---@alias settingsPage_handler_saved
				---| fun(self: settingsPage, user: boolean) Called when an "saved" event is invoked after `settingsPage:Save(...)` was called<p>@*param* `self` settingsPage ― Reference to the settingsPage widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsPage_listener_applied : indexedEventHandler
			---@field handler settingsPage_handler_applied Handler function to register for call

				---@alias settingsPage_handler_applied
				---| fun(self: settingsPage, user: boolean) Called when an "applied" event is invoked after `settingsPage:Apply(...)` was called<p>@*param* `self` settingsPage ― Reference to the settingsPage widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsPage_listener_reverted : indexedEventHandler
			---@field handler settingsPage_handler_reverted Handler function to register for call

				---@alias settingsPage_handler_reverted
				---| fun(self: settingsPage, user: boolean) Called when an "revert" event is invoked after `settingsPage:Revert(...)` was called<p>@*param* `self` settingsPage ― Reference to the settingsPage widget</p><<p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsPage_listener_reset : indexedEventHandler
			---@field handler settingsPage_handler_reset Handler function to register for call

				---@alias settingsPage_handler_reset
				---| fun(self: settingsPage, user: boolean) Called when an "reset" event is invoked after `settingsPage:Reset(...)` was called<p>@*param* `self` settingsPage ― Reference to the settingsPage widget</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsPage_listener_enabled : indexedEventHandler
			---@field handler settingsPage_handler_enabled Handler function to register for call

				---@alias settingsPage_handler_enabled
				---| fun(self: settingsPage, state: boolean, user: boolean) Called when an "enabled" event is invoked after `settingsPage:SetEnabled(...)` was called<p>@*param* `self` settingsPage ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class settingsPage_listener : indexedEventHandler
			---@field handler settingsPage_handler Handler function to register for call

				---@alias settingsPage_handler
				---| fun(self: settingsPage, ...: any) Called when a custom event is invoked<p>@*param* `self` settingsPage ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>	

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
	---@field addListener settingsPage_addListener Hook a handler function as a listener for a widget event
	local _ = {}

		---@class canvasFrame : Frame
		---@field OnCommit function
		---@field OnRefresh function
		---@field OnDefault function

		---Returns the unique identifier key representing the reset defaults warning popup dialog in the global `StaticPopupDialogs` table, and used as the parameter when calling [`StaticPopup_Show()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [`StaticPopup_Hide()`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
		---@return string
		function _:SetResetPopupKey() return "" end

		---Toggle the availability of the reset defaults and revert changes cancel buttons for this page
		---***
		---@param state boolean? ***Default:*** `true`
		function _:SetStatic(state) end

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_settingsmanager]: true, [typename_settingsPage]: true, }
		function _:GetTypes() return {} end

			---@alias typename_settingsPage "SettingsPage"

		--[ Events ]

		---@class settingsPage_addListener : settingsmanager_addListener
		---@field [string] fun(handler: settingsPage_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler settingsPage_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for a "saved" widget event
			---@param handler settingsPage_handler_saved Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_saved(handler, callIndex) end

			---Register a listener for a "applied" widget event
			---@param handler settingsPage_handler_applied Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_applied(handler, callIndex) end

			---Register a listener for a "reverted" widget event
			---@param handler settingsPage_handler_reverted Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_reverted(handler, callIndex) end

			---Register a listener for a "reset" widget event
			---@param handler settingsPage_handler_reset Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_reset(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler settingsPage_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Utilities ]

		---Open the Settings window to this category page
		--- - ***Note:*** No category page will be opened if `WidgetToolsDB.lite` is `true`.
		function _:Open() end
end

---Create an new settings category with a parent page, its child pages, and set up shared settings data management for them
---@param addon uiAddon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
---@param parent settingsPage_options|settingsPage Settings page creation parameters to create, or reference to an existing *unregistered* settings page to set as the parent page for the new category<ul><li>***Note:*** If the provided parent candidate page is already registered (containing a `category` value), it will be dismissed and no new category will be created at all.</li></ul>
---@param pages? settingsPage_options[]|settingsPage[] List of settings page creation parameters to create, or references to an existing *unregistered* settings pages to add as subcategories under `parent`<ul><li>***Note:*** Already registered pages (which contain a `category` value) will be skipped and won't be included in the new category.</li></ul>
---@param t? settingsCategory_options Optional parameters
---@return settingsCategory|nil category Table containing references to settings pages and utility functions or nil if the specified `parent` was invalid
function wt.CreateSettingsCategory(addon, parent, pages, t)

	--| Parameters

	---Optional parameters
	---@class settingsCategory_options
	---@field onLoad? fun(user: boolean) Called after the data of the settings widgets linked to all pages of this settings category has been loaded from storage<p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
	---@field onDefaults? fun(user: boolean) Called after settings data handled by all pages of this settings category has been restored to default values (for example when the "All Settings" option is clicked in the dialogue opened by clicking on the "Restore Defaults" button)<p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>

	--| Returns

	---@class settingsCategory
	---@field pages settingsPage[]
	local _ = {}

		---Force update the settings widgets for all pages in this category
		---***
		---@param handleChanges? boolean If `true`, also call all registered change handlers | ***Default:*** `false`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		function _:Load(handleChanges, user) end

		---Reset all settings data to their default values for all pages in this category
		---***
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param callListeners? boolean If `true`, call the `onDefault` listeners (if set) of each individual category page separately | ***Default:*** `true`
		function _:Defaults(user, callListeners) end

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_settingsCategory]: true, }
		function _:GetTypes() return {} end

			---@alias typename_settingsCategory "SettingsCategory"
end


--[[ PROFILES ]]

---Create a non-GUI profilemanager widget instance with live database management and profile selection logic
---@param accountData CreateProfilemanager_param1 Reference to the account-bound SavedVariables addon database where profile data is to be stored
	--- - ***Note:*** A subtable will be created under the key `profiles` if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).
---@param characterData CreateProfilemanager_param2 Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified
	--- - ***Note:*** An integer value will be created under the key `activeProfile` if it doesn't already exist in this table.
---@param defaultData CreateProfilemanager_param3 A static table containing all default settings values to be cloned when creating a new profile or resetting one
---@param t? profilemanager_options Optional parameters
---@return profilemanager|nil profilemanager Reference to the new profilemanager widget, utility functions and more wrapped in a widget table | ***Default:*** `nil`
function wt.CreateProfilemanager(accountData, characterData, defaultData, t)

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

	---Optional parameters
	---@class profilemanager_options : widget_options
	---@field category? string Category name to be used for identifying this group of profile data when modified in popups and chat messages | ***Default:*** `"Addon"`
	---@field valueChecker? fun(key: number|string, value: any): boolean Helper function for validating values when checking profile data, returning `true` if the value is to be accepted as valid
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
		---@field [1]? table<string, profilemanager_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? profilemanager_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data profile list has been loaded and verified
		---@field activated? profilemanager_listener_activated[] Ordered list of functions to call when an "activated" event is invoked after a profile has been activated
		---@field created? profilemanager_listener_created[] Ordered list of functions to call when a "created" event is invoked after a new data profile has been initialized
		---@field renamed? profilemanager_listener_renamed[] Ordered list of functions to call when a "renamed" event is invoked after a data profile has been renamed
		---@field deleted? profilemanager_listener_deleted[] Ordered list of functions to call when a "deleted" event is invoked after a data profile has been removed from the database
		---@field reset? profilemanager_listener_reset[] Ordered list of functions to call when a "reset" event is invoked after a data profile has been reset to defaults
		---@field enabled? profilemanager_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `profilemanager:SetEnabled(...)` was called

			---@class profilemanager_listener_loaded : indexedEventHandler
			---@field handler profilemanager_handler_loaded Handler function to register for call

				---@alias profilemanager_handler_loaded
				---| fun(self: profilemanager, user: boolean) Called when an "loaded" event is invoked after the data profile list has been loaded and verified<p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_activated : indexedEventHandler
			---@field handler profilemanager_handler_activated Handler function to register for call

				---@alias profilemanager_handler_activated
				---| fun(self: profilemanager, success: boolean, user: boolean, index?: integer, title?: string) Called when an "activated" event is invoked after a profile has been activated<p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `index` integer — The index of the active profile</p><p>@*param* `title` string — The title of the active profile</p><p>@*param* `success` boolean ― `true` if the active profile was changed successfully</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_created : indexedEventHandler
			---@field handler profilemanager_handler_created Handler function to register for call

				---@alias profilemanager_handler_created
				---| fun(self: profilemanager, user: boolean, index: integer, title: string) Called when an "created" event is invoked after a new data profile has been initialized<p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `index` integer — The index of the new profile</p><p>@*param* `title` string — The title of the new profile</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_renamed : indexedEventHandler
			---@field handler profilemanager_handler_renamed Handler function to register for call

				---@alias profilemanager_handler_renamed
				---| fun(self: profilemanager, success: boolean, user: boolean, index: any, title?: string) Called when an "renamed" event is invoked after a data profile has been renamed<p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if the profile was renamed successfully</p><p>@*param* `index` any — The index of the profile attempted to be renamed</p><p>@*param* `title`? string — The new title of the profile attempted to be renamed</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_deleted : indexedEventHandler
			---@field handler profilemanager_handler_deleted Handler function to register for call

				---@alias profilemanager_handler_deleted
				---| fun(self: profilemanager, success: boolean, user: boolean, index: any, title?: string) Called when an "deleted" event is invoked after a data profile has been removed from the database<p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if the profile was deleted successfully</p><p>@*param* `index` any — The original index of the profile attempted to be deleted</p><p>@*param* `title`? string — The title of the  profile attempted to be deleted</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_reset : indexedEventHandler
			---@field handler profilemanager_handler_reset Handler function to register for call

				---@alias profilemanager_handler_reset
				---| fun(self: profilemanager, success: boolean, user: boolean, index: any, title?: string) Called when an "reset" event is invoked after a data profile has been reset to defaults<p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if the profile data was reset successfully</p><p>@*param* `index` any — The index of the profile attempted to be reset</p><p>@*param* `title`? string — The title of the profile attempted to be reset</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener_enabled : indexedEventHandler
			---@field handler profilemanager_handler_enabled Handler function to register for call

				---@alias profilemanager_handler_enabled
				---| fun(self: profilemanager, state: boolean, user: boolean) Called when an "enabled" event is invoked after `profilemanager:SetEnabled(...)` was called<p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanager_listener : indexedEventHandler
			---@field handler profilemanager_handler Handler function to register for call

				---@alias profilemanager_handler
				---| fun(self: profilemanager, ...: any) Called when a custom event is invoked<p>@*param* `self` profilemanager ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class profilemanager : widget
	---@field data table Reference to live data table of the currently active profile
	---@field firstLoad boolean `true` if the `accountData.profiles` table did not exist yet
	---@field newCharacter boolean `true` if the `characterData.activeProfile` integer did not exist yet
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_profilemanager]: true, }
		function _:GetTypes() return {} end

			---@alias typename_profilemanager "Profilemanager"

		--[ Events ]

		---@class profilemanager_invoke : widget_invoke
		---@field loaded fun(user: boolean) Invoke a "loaded" event to notify registered listeners and call handlers
		---@field activated fun(success: boolean, user: boolean) Invoke an "activated" event to notify registered listeners and call handlers
		---@field created fun(user: boolean, index: integer, title: string) Invoke a "created" event to notify registered listeners and call handlers
		---@field renamed fun(success: boolean, user: boolean, index: any, title?: string) Invoke a "renamed" event to notify registered listeners and call handlers
		---@field deleted fun(success: boolean, user: boolean, index: any, title?: string) Invoke a "deleted" event to notify registered listeners and call handlers
		---@field reset fun(success: boolean, user: boolean, index: any, title?: string) Invoke a "reset" event to notify registered listeners and call handlers

		---@class profilemanager_addListener : widget_addListener
		---@field [string] fun(handler: profilemanager_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler profilemanager_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for an "activated" widget event
			---@param handler profilemanager_handler_activated Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_activated(handler, callIndex) end

			---Register a listener for a "created" widget event
			---@param handler profilemanager_handler_created Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_created(handler, callIndex) end

			---Register a listener for a "renamed" widget event
			---@param handler profilemanager_handler_renamed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_renamed(handler, callIndex) end

			---Register a listener for a "deleted" widget event
			---@param handler profilemanager_handler_deleted Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_deleted(handler, callIndex) end

			---Register a listener for a "reset" widget event
			---@param handler profilemanager_handler_reset Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_rset(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler profilemanager_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Utilities ]

		---Activate the specified settings profile
		---***
		---@param index? integer Index of the profile to set as the currently active settings profile | ***Default:*** *currently active profile index* or `1`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke an "applied" event and call registered listeners | ***Default:*** `false`
		---***
		---@return integer? index The index of the active profile | ***Default:*** `nil`
		function _:Activate(index, user, silent) end

		---Find a profile by its display title and return its index
		---***
		---@param title string Name of the profile to find
		---@param skipFirst? boolean Set to `true` to find duplicate `title` | ***Default:*** `false`
		---@return integer? index
		function _:FindIndex(title, skipFirst) end

		---Create a new settings profile
		---***
		---@param name? string Name tag to use when setting the display title of the new profile | ***Default:*** `duplicate and accountData.profiles[duplicate].title or "Profile"`
		---@param number? integer Starting value for the incremented number appended to `name` if it's used | ***Default:*** `2`
		---@param duplicate? integer Index of the profile to create the new profile as a duplicate of instead of using default data values
		---@param apply? boolean Whether to immediately set the new profile as the active profile or not | ***Default:*** `true`
		---@param index? integer Place the new profile under this specified index in `accountData.profile` instead of the end of the list | ***Range:*** (`1`, `#accountData.profiles + 1`)
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke an "created" event and call registered listeners | ***Default:*** `false`
		function _:Create(name, number, duplicate, index, apply, user, silent) end

		---Rename the specified profile
		---@param index? integer Index of the profile to rename | ***Default:*** *currently active profile index*
		---@param name? string The new title of the profile to set | ***Default:*** `"Profile"`
		---@param number? integer Starting value for the incremented number appended to `name` if it's used | ***Default:*** `2`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke an "renamed" event and call registered listeners | ***Default:*** `false`
		---***
		---@return boolean # `true` on success, `false` if the operation failed
		function _:Rename(index, name, number, user, silent) return false end

		---Delete the specified profile
		---***
		---@param index? integer Index of the profile to delete | ***Default:*** *currently active profile index*
		---@param unsafe? boolean If `false`, show a popup confirmation before attempting to delete the specified profile | ***Default:*** `false`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke an "deleted" event and call registered listeners | ***Default:*** `false`
		---***
		---@return boolean # `true` on success, `false` if the operation failed
		function _:Delete(index, unsafe, user, silent) return false end

		---Reset the specified profile data to default values
		---***
		---@param index? integer Index of the profile to restore to defaults | ***Default:*** *currently active profile index*
		---@param unsafe? boolean If `false`, show a popup confirmation before attempting to reset the specified profile | ***Default:*** `false`
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke an "reset" event and call registered listeners | ***Default:*** `false`
		---***
		---@return boolean # `true` on success, `false` if the operation failed
		function _:Reset(index, unsafe, user, silent) return false end

		---Check & fix a profile data table based on the specified sample profile
		---***
		---@param profileData table Profile data table to check
		---@param compareWith? table  Profile data table to sample | ***Default:*** `defaultData`
		---***
		---@return table profileData Reference to `profileData` (it was already updated during the operation, no need for setting it again)
		function _:Validate(profileData, compareWith) return {} end

		---Load profiles data
		---***
		---@param p? profileStorage Table holding the list of profiles to store | ***Default:*** *validate* `accountData` *(if the data is missing or invalid, set up a default profile)*
		---@param activeProfile? integer Index of the active profile to set | ***Default:*** *currently active profile index*
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke an "loaded" event and call registered listeners | ***Default:*** `false`
		function _:Load(p, activeProfile, user, silent) end

	return _
end

--[ Settings Page ]

---Create and set up a new settings page with profile data handling and advanced backup management options
---@param accountData CreateProfilemanager_param1 Reference to the account-bound SavedVariables addon database where profile data is to be stored
--- - ***Note:*** A subtable will be created under the key `profiles` if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).
---@param characterData CreateProfilemanager_param2 Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified
--- - ***Note:*** An integer value will be created under the key `activeProfile` if it doesn't already exist in this table.
---@param defaultData CreateProfilemanager_param3 A static table containing all default settings values to be cloned when creating a new profile or resetting one
---@param settingsData CreateProfilesPage_param4 Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from
--- - ***Note:*** A boolean value will be created under the key `compactBackup` if it didn't already exist in this table.
---@param t? profilesPage_options Optional parameters
---@param ancestor? profilemanager Reference to an already existing profile datamanager instance to turn into a profile management settings page instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return profilemanager|profilesPage|nil profilesPage Table containing references to the settings page, settings widgets grouped in subtables and utility functions by category | ***Default:*** `nil`
function wt.CreateProfilesPage(accountData, characterData, defaultData, settingsData, t, ancestor, lite)

	--| Parameters

	---Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from
	--- - ***Note:*** A boolean value will be created under the key `compactBackup` if it didn't already exist in this table.
	---@alias CreateProfilesPage_param4 # settingsData
	---| backupboxSettingsData
	---| table

		---@class backupboxSettingsData
		---@field compactBackup boolean Whether to skip including additional white spaces to the backup string for more readability

	---Optional parameters
	---@class profilesPage_options : profilemanager_options, settingsmanager_options_base, settingsmanagerEvents
	---@field name? frameName ***Default:*** `"Profiles"`
	---@field title? string Text to be shown as the title of the settings page | ***Default:*** `"Data Management"`
	---@field description? string Text to be shown as the description below the title of the settings page | ***Default:*** *describing profiles & backup*
	---@field listeners? profilesPage_listeners|profilemanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field onImport? fun(success: boolean, data: table) Called after a settings backup string import has been performed by the user loading data for the currently active profile<p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>
	---@field onImportAllProfiles? fun(success: boolean, data: table) Called after a settings backup string import has been performed by the user loading data for all profiles<p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>

		---@class profilesPage_listeners : profilemanager_listeners
		---@field [1]? table<string, profilesPage_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field loaded? profilesPage_listener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data profile list has been loaded and verified
		---@field activated? profilesPage_listener_activated[] Ordered list of functions to call when an "activated" event is invoked after a profile has been activated
		---@field created? profilesPage_listener_created[] Ordered list of functions to call when a "created" event is invoked after a new data profile has been initialized
		---@field renamed? profilesPage_listener_renamed[] Ordered list of functions to call when a "renamed" event is invoked after a data profile has been renamed
		---@field deleted? profilesPage_listener_deleted[] Ordered list of functions to call when a "deleted" event is invoked after a data profile has been removed from the database
		---@field reset? profilesPage_listener_reset[] Ordered list of functions to call when a "reset" event is invoked after a data profile has been reset to defaults
		---@field enabled? profilesPage_listener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after `profilesPage:SetEnabled(...)` was called

			---@class profilesPage_listener_loaded : indexedEventHandler
			---@field handler profilesPage_handler_loaded Handler function to register for call

				---@alias profilesPage_handler_loaded
				---| fun(self: profilesPage, user: boolean) Called when an "loaded" event is invoked after the data profile list has been loaded and verified<p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_activated : indexedEventHandler
			---@field handler profilesPage_handler_activated Handler function to register for call

				---@alias profilesPage_handler_activated
				---| fun(self: profilesPage, index: integer, title: string, success: boolean, user: boolean) Called when an "activated" event is invoked after a profile has been activated<p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `index` integer — The index of the active profile</p><p>@*param* `title` string — The title of the active profile</p><p>@*param* `success` boolean ― `true` if the active profile was changed successfully</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_created : indexedEventHandler
			---@field handler profilesPage_handler_created Handler function to register for call

				---@alias profilesPage_handler_created
				---| fun(self: profilesPage, index: integer, title: string, user: boolean) Called when an "created" event is invoked after a new data profile has been initialized<p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `index` integer — The index of the new profile</p><p>@*param* `title` string — The title of the new profile</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_renamed : indexedEventHandler
			---@field handler profilesPage_handler_renamed Handler function to register for call

				---@alias profilesPage_handler_renamed
				---| fun(self: profilesPage, success: boolean, index: any, title?: string, user: boolean) Called when an "renamed" event is invoked after a data profile has been renamed<p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if the profile was renamed successfully</p><p>@*param* `index` any — The index of the profile attempted to be renamed</p><p>@*param* `title`? string — The new title of the profile attempted to be renamed</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_deleted : indexedEventHandler
			---@field handler profilesPage_handler_deleted Handler function to register for call

				---@alias profilesPage_handler_deleted
				---| fun(self: profilesPage, success: boolean, index: any, title?: string, user: boolean) Called when an "deleted" event is invoked after a data profile has been removed from the database<p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if the profile was deleted successfully</p><p>@*param* `index` any — The original index of the profile attempted to be deleted</p><p>@*param* `title`? string — The title of the  profile attempted to be deleted</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_reset : indexedEventHandler
			---@field handler profilesPage_handler_reset Handler function to register for call

				---@alias profilesPage_handler_reset
				---| fun(self: profilesPage, success: boolean, index: any, title?: string, user: boolean) Called when an "reset" event is invoked after a data profile has been reset to defaults<p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `success` boolean ― `true` if the profile data was reset successfully</p><p>@*param* `index` any — The index of the profile attempted to be reset</p><p>@*param* `title`? string — The title of the profile attempted to be reset</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener_enabled : indexedEventHandler
			---@field handler profilesPage_handler_enabled Handler function to register for call

				---@alias profilesPage_handler_enabled
				---| fun(self: profilesPage, state: boolean, user: boolean) Called when an "enabled" event is invoked after `profilesPage:SetEnabled(...)` was called<p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class profilesPage_listener : indexedEventHandler
			---@field handler profilesPage_handler Handler function to register for call

				---@alias profilesPage_handler
				---| fun(self: profilesPage, ...: any) Called when a custom event is invoked<p>@*param* `self` profilesPage ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class profilesPage : profilemanager
	---@field settings settingsPage
	---@field widgets? profilesPageWidgets Collection of profiles settings widgets
	---@field backup? profilesPageBackup Collection of backup settings widgets
	---@field backupAll? profilesPageBackup Collection of all profiles backup settings widgets
	---@field addListener profilesPage_addListener Hook a handler function as a listener for a widget event
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

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_profilemanager]: true, [typename_profilesPage]: true, }
		function _:GetTypes() return {} end

			---@alias typename_profilesPage "ProfilesPage"

		--[ Events ]

		---@class profilesPage_addListener : profilemanager_addListener
		---@field [string] fun(handler: profilesPage_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "loaded" widget event
			---@param handler profilesPage_handler_loaded Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_loaded(handler, callIndex) end

			---Register a listener for an "activated" widget event
			---@param handler profilesPage_handler_activated Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_activated(handler, callIndex) end

			---Register a listener for a "created" widget event
			---@param handler profilesPage_handler_created Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_created(handler, callIndex) end

			---Register a listener for a "renamed" widget event
			---@param handler profilesPage_handler_renamed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_renamed(handler, callIndex) end

			---Register a listener for a "deleted" widget event
			---@param handler profilesPage_handler_deleted Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_deleted(handler, callIndex) end

			---Register a listener for a "reset" widget event
			---@param handler profilesPage_handler_reset Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_reset(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler profilesPage_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end
end


--[[ ADDON ]]

---Create a non-GUI addonmanager instance providing extended utility on top of Blizzard's [C_AddOns](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API#AddOns) & [C_AddOnProfiler](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API#AddOnProfiler) API collections
---@param t? addonmanager_options Optional parameters
---@return addonmanager addonmanager Reference to the new addonmanager instance, utility functions and more wrapped in a construct table
function wt.CreateAddonmanager(t)

	--| Parameters

	---Optional parameters
	---@class addonmanager_options : widget_options
	---@field addon? uiAddon If a valid addon namespace name (its folder name, not the displayed title) or its loaded index is provided, load the metadata for it into the new addonmanager immediately | ***Default:*** *no addon, empty addonmanager*
	---@field changelog? { [table[]] : string[] } String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included<ul><li>***Note:*** The first line is expected to be the title containing the version number and/or the date of release.</li><li>***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).</li><li>***Examples:***<ul><li>**Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)</li><li>**Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)</li><li>**Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)</li><li>**Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)</li><li>**Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)</li><li>**Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
	---@field listeners? addonmanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class addonmanager_listeners : widget_listeners
		---@field [1]? table<string, addonmanager_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field changed? addonmanager_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after the info of the managed addon has been loaded

			---@class addonmanager_listener_changed : indexedEventHandler
			---@field handler addonmanager_handler_changed Handler function to register for call

				---@alias addonmanager_handler_changed
				---| fun(self: addonmanager, addon: string, user: boolean) Called when an "changed" event is invoked after the info of the managed addon has been loaded<p>@*param* `self` addonmanager ― Reference to the widget table</p><p>@*param* `addon` string ― Namespace name of the addon that was loaded by the manager</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class addonmanager_listener_enabled : indexedEventHandler
			---@field handler addonmanager_handler_enabled Handler function to register for call

				---@alias addonmanager_handler_enabled
				---| fun(self: addonmanager, state: boolean, user: boolean) Called when an "enabled" event is invoked after `addonmanager:SetEnabled(...)` was called<p>@*param* `self` addonmanager ― Reference to the widget table</p><p>@*param* `state` boolean ― `true` if the widget is enabled</p><p>@*param* `user` boolean ― `true` if the event was flagged as invoked by an action taken by the user</p>

			---@class addonmanager_listener : indexedEventHandler
			---@field handler addonmanager_handler Handler function to register for call

				---@alias addonmanager_handler
				---| fun(self: addonmanager, ...: any) Called when a custom event is invoked<p>@*param* `self` addonmanager ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class addonmanager : widget
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_addonmanager]: true, }
		function _:GetTypes() return {} end

			---@alias typename_addonmanager "Addonmanager"

		--[ Events ]

		---@class addonmanager_invoke : widget_invoke
		---@field changed fun(addon: string, user: boolean) Invoke a "changed" event to notify registered listeners and call handlers

		---@class addonmanager_addListener : widget_addListener
		---@field [string] fun(handler: addonmanager_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "changed" widget event
			---@param handler addonmanager_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler profilesPage_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end

		--[ Metadata ]

		---Namespace name of the addon
		---@return string | ***Default:*** `""`
		function _:GetName() return "" end

		---Displayed title
		---@return string | ***Default:*** `""`
		function _:GetTitle() return "" end

		---Description notes
		---@return string? ***Default:*** `nil`
		function _:GetNotes() end

		---Logo texture file path
		---@return string? ***Default:*** `nil`
		function _:GetLogo() end

		---Addon list category name
		---@return string? ***Default:*** `nil`
		function _:GetCategory() end

		---Author name
		---@return string? ***Default:*** `nil`
		function _:GetAuthor() end

		---Latest version number text
		---@return string? ***Default:*** `nil`
		function _:GetVersion() end

		---Formatted date string of the latest release
		---@return string? date
		function _:GetDate() end

		---Raw day, month and year values of the date of the latest release
		---@return integer? day
		---@return integer? month
		---@return integer? year
		function _:GetDateValues() end

		---License description
		---@return string? ***Default:*** `nil`
		function _:GetLicense() end

		---CurseForge link
		---@return string? ***Default:*** `nil`
		function _:GetCurseForgeLink() end

		---Wago link
		---@return string? ***Default:*** `nil`
		function _:GetWagoLink() end

		---Repository link
		---@return string? ***Default:*** `nil`
		function _:GetRepositoryLink() end

		---Contact link for feedback & bug reports
		---@return string? ***Default:*** `nil`
		function _:GetIssuesLink() end

		---Sponsor names by tiers
		---@return string[][]? # Semicolon separated tiers of comma separated lists of sponsor names split into a nested array of tiers and names | ***Default:*** `nil`
		function _:GetSponsors() end

		---Formatted changelog text of the latest release
		---@return string? # ***Default:*** `nil`
		function _:GetChangelog() end

		---Formatted changelog text of the entire version history
		---@return string? # ***Default:*** `nil`
		function _:GetChangelogHistory() end

		--[ Rebind ]

		---Change the addon managed by this widget
		---***
		---@param addon uiAddon The name of the addon's folder (the addon namespace, not its displayed title) or its loaded index
		---@param changelog CreateAddonmanager_setAddon_param_changelog String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included
		--- - ***Note:*** The first line is expected to be the title containing the version number and/or the date of release.
		--- - ***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).
		--- - ***Examples:***
		---   - **Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)
		---   - **Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)
		---   - **Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)
		---   - **Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)
		---   - **Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)
		---   - **Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
		---@param user? boolean If `true`, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If `false`, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		---***
		---@return boolean # `true` if the operation was successful
		function _:SetAddon(addon, changelog, user, silent)

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
			---@alias CreateAddonmanager_setAddon_param_changelog { [table[]] : string[] }?

			---| Returns

			return false
		end

	return _
end

--[ Settings Page ]

---Create and set up a new static settings page with read-only addon about info
---@param t? addonPage_options Optional parameters
---@param ancestor? addonmanager Reference to an already existing addonmanager instance to turn into an addon about settings page instead of creating a new instance to mutate (reusing its own already set parameters retaining their current values)
--- - ***Note:*** If an empty Addonmanager is provided with no addon set (even if `t.addon` is set), the settings page will not be created and `addonmanager` is returned.
--- - ***Note:*** If the settings page is created, `addonmanager` will be turned to readn-only (along with the settings page), disabling its `SetAddon(...)` call.
---@param lite? liteFlag If `false`, overrule Lite Mode and use full GUI functionality even when `WidgetToolsDB.lite` is `true` | ***Default:*** `true`
---@return addonPage|addonmanager aboutPage Table containing references to the canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions | ***Default:*** `addonmanager`
function wt.CreateAddonPage(t, ancestor, lite)

	--| Parameters

	---Optional parameters
	---@class addonPage_options : settingsmanager_options_base, addonmanager_options
	---@field description? string Text to be shown as the description below the title of the settings page | ***Default:*** [`GetAddOnNotes(addon)`](https://warcraft.wiki.gg/wiki/API_C_AddOns.GetAddOnNotes)
	---@field static? boolean If `true`, disable the "Restore Defaults" & "Revert Changes" buttons | ***Default:*** `true`
	---@field listeners? addonPage_listeners|addonmanager_listeners|widget_listeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class addonPage_listeners : addonmanager_listeners
		---@field [1]? table<string, addonPage_listener[]> Table of key, value pairs of unique event identifier tags to register as custom widget events and ordered lists of handler functions to register for call when the event they are assigned to is invoked
		---@field changed? addonPage_listener_changed[] Ordered list of functions to call when an "changed" event is invoked after the info of the managed addon has been loaded

			---@class addonPage_listener_changed : indexedEventHandler
			---@field handler addonPage_handler_changed Handler function to register for call

				---Called when an "changed" event is invoked after the info of the managed addon has been loaded<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `addon` ― Namespace name of the addon that was loaded by the manager</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias addonPage_handler_changed fun(self: addonPage, addon: string, user: boolean)

			---@class addonPage_listener_enabled : indexedEventHandler
			---@field handler addonPage_handler_enabled Handler function to register for call

				---Called when an "enabled" event is invoked after `addonPage:SetEnabled(...)` was called<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `state` ― `true` if the widget is enabled</p><p>@*param* `user` ― `true` if the event was flagged as invoked by an action taken by the user</p>
				---@alias addonPage_handler_enabled fun(self: addonPage, state: boolean, user: boolean)

			---@class addonPage_listener : indexedEventHandler
			---@field handler addonPage_handler Handler function to register for call

				---Called when a custom event is invoked<p>@*param* `self` ― Reference to the widget table</p><p>@*param* `...` — Any leftover arguments</p>
				---@alias addonPage_handler fun(self: addonPage, ...: any)

	--| Returns

	---@class addonPage : addonmanager
	---@field settings settingsPage
	---@field SetAddon nil
	local _ = {}

		--[ Types ]

		---Returns the type list of this widget
		---@return { [typename_construct]: true, [typename_widget]: true, [typename_addonmanager]: true, [typename_addonPage]: true, }
		function _:GetTypes() return {} end

			---@alias typename_addonPage "AddonPage"

		--[ Events ]

		---@class addonPage_addListener : addonmanager_addListener
		---@field [string] fun(handler: addonPage_handler, callIndex?: integer) Register a listener for a custom widget event
		local addListener = {}

			---Register a listener for a "changed" widget event
			---@param handler addonPage_handler_changed Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_changed(handler, callIndex) end

			---Register a listener for an "enabled" widget event
			---@param handler addonPage_handler_enabled Handler function to call on trigger
			---@param callIndex? eventHandlerCallIndex Set when to call the event handler in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end
end


--[[ CHAT COMMANDS ]]

---Create a non-GUI chatmanager instance and register a list of chat keywords and related commands for use
---@param keywords string[] List of addon-specific keywords to register to listen to when typed as slash commands
--- - ***Note:*** A slash character (`/`) will appended before each keyword specified here during registration, it doesn't need to be included.
---@param t? chatmanager_options Optional parameters
---@return CreateChatmanager_return_chatmanager chatmanager ***Default:*** `nil`
function wt.CreateChatmanager(keywords, t)

	--| Parameters

	---Optional parameters
	---@class chatmanager_options : widget_options
	---@field commands? chatCommandData[] Indexed table with the list of commands to register under the specified `keywords`
	---@field addon? uiAddon|addonmanager Namespace name or manager widget of the addon to use as branding for printed chat messages
	---@field colors? chatCommandColors Color palette used when printing out default-formatted chat messages
	---@field defaultHandler? fun(commandManager: chatmanager, command: string, ...: string) Default handler function to call when an unrecognized command is typed, executed before a help command is triggered, listing all registered commands<p>@*param* `commandManager` commandManager ― Reference to the command manager</p><p>@*param* `command` string ― The unrecognized command typed after the keyword (separated by a space character)</p><p>@*param* `...` string Payload of the command typed, any words following the command name separated by spaces (split, returned unpacked)</p>
	---@field onWelcome? function Called when the welcome message with keyword hints is printed out

		---@class chatCommandData
		---@field command string Name of the slash command word (no spaces) to recognize after the keyword (separated by a space character)
		---@field description? string|fun(): string Note to append to the first specified keyword and `command` in this command's line in the list printed out via the help command(s)
		---@field handler? fun(manager: chatmanager, ...: string): result: boolean|nil, ...: any Function to be called when the specific command was recognized after being typed into chat<p>@*param* `...` string ― Payload of the command typed, any words following the command name separated by spaces split and returned one by one</p><p>@*return* `result`? boolean|nil ― Call <code>[<i>value</i>].onSuccess</code> if `true` or <code>[<i>value</i>].onError</code> if `false` (not nil) after the operation | ***Default:*** `nil` *(no response)*</p><p>@*return* `...` any ― Leftover arguments to be passed over to response handler scripts</p>
		---@field success? string|fun(...: any): string Response message (or a function returning the message string) to print out on success after<code>commands[<i>value</i>].handler</code> returns with `true`<p>@*param* `...` any ― Leftover arguments passed over by the handler script</p>
		---@field error? string|fun(...: any): string Response message (or a function returning the message string) to print out on error after<code>commands[<i>value</i>].handler</code> returns with `false` (not nil)<p>@*param* `...` any ― Any leftover arguments passed over by the handler script</p>
		---@field onSuccess? fun(manager: chatmanager, ...: any) Function to call after<code>commands[<i>value</i>].handler</code> returns with `true` to handle a successful result (after `success` is printed)<p>@*param* `manager` chatCommandManager ― Reference to this chat command manager</p><p>@*param* `...` any ― Any leftover arguments returned by the handler script will be passed over</p>
		---@field onError? fun(manager: chatmanager, ...: any) Function to call after<code>commands[<i>value</i>].handler</code> returns with `false` (not nil) to handle a failed result (after `error` is printed)<p>@*param* `manager` chatCommandManager ― Reference to this chat command manager</p><p>@*param* `...` any ― Any leftover arguments returned by the handler script will be passed over</p>
		---@field hidden? boolean Skip printing this command when listing out chat commands on help | ***Default:*** `false`<ul><li>***Note:*** If `onHelp` is specified, it will still be called even if the command is hidden.</li></ul>
		---@field help? boolean If `true`, call `chatCommandManager.help()` on trigger | ***Default:*** `false`
		---@field onHelp? function Function to call after a specified help command has been triggered or an invalid command is typed with the specified keywords

		---@class chatCommandColors
		---@field title? color Color for the addon title used for branding chat messages | ***Default:*** `YELLOW_FONT_COLOR`
		---@field content? color Color for chat message contents appended after the title (used for success & error responses) | ***Default:*** `WHITE_FONT_COLOR`
		---@field command? color Used to color the registered chat commands when they are being listed | ***Default:*** `LIGHTBLUE_FONT_COLOR`
		---@field description? color Used to color the description of registered chat commands when they are being listed | ***Default:*** `LIGHTGRAY_FONT_COLOR`

	--| Returns

	---***Default:*** `nil`
	---@alias CreateChatmanager_return_chatmanager chatmanager|nil

		---`Chatmanager` WidgetTools construct instance table
		---@class chatmanager : construct
		local _ = {}

			---comment
			---@return string
			function GetKeywords() return "" end

			---Set the command list of this chatmanager
			---@param commands chatCommandData[] Array of commands to register under the chat keyword managed by this chatmanager
			function _:SetCommands(commands) end

			---Print out a formatted chat message
			---@param message string Message content
			---@param title? string Title to start the message with | ***Default:*** *(addon title)*<ul><li>***Note:*** If "IconTexture" is specified in the TOC file of `addon`, a logo will also be included at the start of the message.</li></ul>
			---@param contentColor? chatCommandColorNames|color ***Default:*** `"content"`
			---@param titleColor? chatCommandColorNames|color ***Default:*** `"title"`
			function _:Print(message, title, titleColor, contentColor) end

				---@alias chatCommandColorNames
				---| "title"
				---| "content"
				---| "command"
				---| "description"

			--Print a welcome message with a hint about chat keywords
			function _:Welcome() end

			--Trigger a help command, listing all registered chat commands with their specified descriptions, calling their onHelp handlers
			function _:Help() end

			---Find and a specific command by its name and call its handler script
			---***
			---@param command string Name of the slash command word (no spaces)
			---@param ... any Any further arguments are used as the payload of the command, passed over to its handler
			---***
			---@return boolean # Whether the command was found and the handler called successfully
			function _:Trigger(command, ...) return false end

			--[ Types ]

			---Returns the type list of this widget
			---@return { [typename_construct]: true, [typename_widget]: true, [typename_chatmanager]: true, }
			function _:GetTypes() return {} end

				---@alias typename_chatmanager "Chatmanager"

			--[ Events ]

			---Register a listener for a custom event to call the specified handler on trigger
			---@param event eventTag Unique event identifier tag
			---@param handler chatmanager_handler Called when a custom event is invoked
			---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
			function _:AddListener(event, handler, callIndex) end

			---Register a listener for an "enabled" event to call the specified handler on trigger
			---@param handler chatmanager_handler_enabled Called when an "enabled" event is invoked after `chatmanager:SetEnabled(...)` was called
			---@param callIndex? eventHandlerCallIndex Set when to call the handler function in the execution order | ***Default:*** *last position*
			function _:AddListener_enabled(handler, callIndex) end
end