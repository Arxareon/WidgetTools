--| Locale

if GetLocale() ~= "zhCN" then return end

--| Namespace

---@class addonNamespace
local ns = select(2, ...)

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Chinese (simplified, PRC)
---@class widgetToolsStrings_zhCN
ns.rs.strings = {
	about = {
		version = "版本：#VERSION",
		date = "日期：#DATE",
		author = "作者：#AUTHOR",
		license = "许可证：#LICENSE",
		toggle = {
			label = "已启用",
			tooltip = "取消勾选以禁用此插件。\n\n此更改仅在重新加载界面后生效。禁用后，此插件将不会出现在此列表中，直到在主插件菜单中重新启用。",
		},
	},
	specifications = {
		title = "规格",
		description = "调整并切换可选功能。在聊天中输入 /wt 使用聊天命令。",
		general = {
			title = "通用",
			description = "影响所有依赖插件的选项。",
			lite = {
				label = "精简模式",
				tooltip = "禁用所有使用 Widget Toolboxes 的插件设置，以节省资源并加快界面加载速度。\n插件设置数据仍会在后台保存和加载，使用聊天控制的插件依然可用。\n\n要关闭精简模式并重新启用设置，请使用 #COMMAND 聊天命令，或点击小地图标题栏日历按钮下方的 AddOns 列表中的 Widget Tools（经典服不可用）。",
			},
			positioningAids = {
				label = "定位视觉辅助",
				tooltip = "在通过使用 Widget Toolboxes 的插件设置组件定位框体时显示视觉辅助。",
			},
		},
		dev = {
			title = "开发工具",
			frameAttributes = {
				enabled = {
					label = "调整框体属性大小",
					tooltip = "自定义框体属性窗口（TableAttributeDisplay Frame）内表格的宽度。",
				},
				width = {
					label = "框体属性宽度",
					tooltip = "指定框体属性窗口中可滚动内容表格的宽度。",
				},
			},
		},
	},
	toolboxes = {
		title = "工具箱与插件",
		description = "当前已加载并使用已注册 #ADDON 工具箱特定版本的插件列表。",
		toolbox = "工具箱（#VERSION）",
	},
	compartment = {
		open = "点击以打开特定设置。",
		lite = "精简模式已启用。点击以禁用。",
	},
	lite = {
		enable = {
			warning = "当 #ADDON 处于精简模式时，依赖插件的设置界面将不会加载。\n\n确定要启用精简模式并禁用完整设置功能吗？",
			accept = "启用精简模式",
		},
		disable = {
			warning = "#ADDON 处于精简模式，依赖插件的设置界面尚未加载。\n\n是否要关闭精简模式并重新启用完整设置功能？",
			accept = "禁用精简模式",
		},
	},
	chat = {
		about = {
			description = "打开 Widget Tools 关于页面",
		},
		lite = {
			description = "切换精简模式：是否加载依赖插件设置",
			response = "界面重新加载后，精简模式将为 #STATE。",
			reminder = "精简模式已启用，依赖插件设置尚未加载。\n#HINT",
			hint = "输入 #COMMAND 以禁用精简模式。",
		},
	},
	separator = ",", -- 千位分隔符
	decimal = ".", -- 小数点符号
}