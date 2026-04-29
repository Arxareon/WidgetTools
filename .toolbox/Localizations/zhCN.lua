--| Locale

if GetLocale() ~= "zhCN" then return end

--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Chinese (simplified, PRC)
---@class toolboxStrings_zhCN
wt.strings = {
	chat = {
		welcome = {
			thanks = "感谢您使用#ADDON！",
			hint = "输入#KEYWORD查看聊天命令列表。",
			keywords = "#KEYWORD 或 #KEYWORD_ALTERNATE",
		},
		help = {
			list = "#ADDON 聊天命令列表：",
		},
	},
	popupInput = {
		title = "请输入文本",
		tooltip = "按" .. KEY_ENTER .. "确认输入的文本，或按" .. KEY_ESCAPE .. "取消。",
	},
	reload = {
		title = "待应用更改",
		description = "请重新加载界面以应用待处理的更改。",
		accept = {
			label = "立即重载",
			tooltip = "您可以选择现在重载界面以应用更改。",
		},
		cancel = {
			label = "稍后",
			tooltip = "稍后可通过/reload命令或注销来重载界面。",
		},
	},
	multiSelector = {
		locked = "已锁定",
		minLimit = "至少需要选择 #MIN 个选项。",
		maxLimit = "一次只能选择 #MAX 个选项。",
	},
	dropdown = {
		selected = "这是当前选中的选项。",
		none = "尚未选择任何选项。",
		open = "点击查看选项列表。",
		previous = {
			label = "上一个选项",
			tooltip = "选择上一个选项。",
		},
		next = {
			label = "下一个选项",
			tooltip = "选择下一个选项。",
		},
		clear = "清除选择",
	},
	copyBox = "按下：\n" .. CTRL_KEY_TEXT .. " + C (Windows)\n" .. COMMAND .. " + C (Mac) 复制文本",
	slider = {
		value = {
			label = "请输入数值",
			tooltip = "输入范围内的任意数值。",
		},
		decrease = {
			label = "减少",
			tooltip = {
				"从当前值减去#VALUE。",
				"按住ALT可减去#VALUE。",
			},
		},
		increase = {
			label = "增加",
			tooltip = {
				"将#VALUE加到当前值。",
				"按住ALT可加上#VALUE。",
			},
		},
	},
	color = {
		picker = {
			label = "选择颜色",
			tooltip = "打开颜色选择器自定义颜色#ALPHA。",
			alpha = "并调整透明度",
		},
		hex = {
			label = "通过HEX颜色码添加",
			tooltip = "您可以通过HEX颜色码更改颜色，而不是使用颜色选择器。",
		}
	},
	settings = {
		save = "关闭时将应用更改。",
		cancel = {
			label = "撤销更改",
			tooltip = "放弃本页所有更改并加载已保存的值。",
		},
		defaults = {
			label = "恢复默认",
			tooltip = "将本页（或整个分类）的所有设置恢复为默认值。",
		},
		warning = "确定要将#PAGE页面或#CATEGORY分类的所有设置恢复为默认值吗？",
		warningSingle = "确定要将#PAGE页面的设置恢复为默认值吗？",
	},
	value = {
		copy = "复制数值",
		paste = "粘贴数值",
		revert = "撤销更改",
		restore = "恢复默认",
		note = "右键点击可复制或撤销。",
	},
	points = {
		left = "左",
		right = "右",
		center = "中",
		top = {
			left = "左上",
			right = "右上",
			center = "上中",
		},
		bottom = {
			left = "左下",
			right = "右下",
			center = "下中",
		},
	},
	strata = {
		lowest = "最低背景",
		lower = "中等背景",
		low = "高背景",
		lowMid = "低中层",
		highMid = "高中层",
		high = "低前景",
		higher = "中前景",
		highest = "高前景",
	},
	about = {
		title = "关于",
		description = "感谢您使用#ADDON！复制下方链接以反馈、获取帮助或支持开发。",
		version = "版本",
		date = "日期",
		author = "作者",
		license = "许可证",
		curseForge = "CurseForge页面",
		wago = "Wago页面",
		repository = "GitHub仓库",
		issues = "问题与反馈",
		changelog = {
			label = "更新说明",
			tooltip = "本次版本（#VERSION）所有更改、更新与修复说明。",
		},
		fullChangelog = {
			label = "#ADDON更新日志",
			tooltip = "所有插件版本的完整更新说明列表。",
			open = {
				label = "更新日志",
				tooltip = "阅读所有插件版本的完整更新说明。",
			},
		},
	},
	sponsors = {
		title = "赞助者",
		description = "非常感谢您的持续支持！",
	},
	dataManagement = {
		title = "数据管理",
		description = "通过导入、导出选项管理配置文件和备份以进一步配置#ADDON。",
	},
	profiles = {
		title = "配置文件",
		description = "为每个角色创建、编辑并应用专属配置文件。",
		select = {
			label = "选择配置文件",
			tooltip = "选择当前角色要使用的配置文件。\n\n当设置更改并保存时，激活的配置文件数据会自动被覆盖！",
			profile = "配置文件",
			main = "主",
		},
		new = {
			label = "新建配置文件",
			tooltip = "创建新的默认配置文件。",
		},
		duplicate = {
			label = "复制",
			tooltip = "以当前激活的配置文件数据创建新配置文件。",
		},
		rename = {
			label = "重命名",
			tooltip = "重命名当前激活的配置文件。",
			description = "将#PROFILE重命名为：",
		},
		delete = {
			tooltip = "删除当前激活的配置文件。",
			warning = "确定要移除当前激活的#PROFILE #ADDON配置文件并永久删除其中所有数据吗？"
		},
		reset = {
			warning = "确定要将当前激活的#PROFILE #ADDON配置文件覆盖为默认值吗？",
		},
	},
	backup = {
		title = "备份",
		description = "导入或导出当前激活配置文件的数据以保存、分享、迁移设置，或手动编辑特定值。",
		box = {
			label = "导入或导出当前配置文件",
			tooltip = {
				"此框中的备份字符串包含当前激活的插件配置文件数据。",
				"复制文本以保存、分享或为其他账号加载数据。",
				"如需从字符串加载数据，请覆盖此框内文本后按" .. KEY_ENTER .. "或点击#LOAD按钮。",
				"注意：如果您使用自定义字体或材质文件，这些文件不会随字符串一起转移。需单独保存并放入插件文件夹。",
				"请仅加载您自己验证或信任来源的字符串！",
			},
		},
		allProfiles = {
			label = "导入或导出所有配置文件",
			tooltipLine = "此框中的备份字符串包含所有插件配置文件及其数据，以及当前激活配置文件的名称。",
			open = {
				label = "所有配置文件",
				tooltip = "访问完整配置文件列表并备份或修改各自数据。",
			},
		},
		compact = {
			label = "精简",
			tooltip = "在精简和更易读/可编辑视图间切换。",
		},
		load = {
			label = "加载",
			tooltip = "检查当前字符串并尝试加载数据。",
		},
		reset = {
			tooltip = "放弃对字符串的所有更改，并重置为当前保存的数据。",
		},
		import = "加载字符串",
		warning = "确定要尝试加载当前输入的字符串吗？\n\n所有未保存的更改将被放弃。\n\n如果您是从网络来源复制或他人发送，仅在确认内容安全时加载。\n\n如不信任来源，建议取消以避免意外操作。",
		error = "无法验证提供的备份字符串，未加载任何数据。可能缺少字符或编辑时出现错误。",
	},
	position = {
		title = "位置",
		description = {
			static = "可在此微调#FRAME在屏幕上的位置。",
			movable = "按住SHIFT拖动#FRAME到屏幕任意位置，并可在此微调。",
		},
		relativePoint = {
			label = "屏幕锚点",
			tooltip = "将#FRAME选定的锚点连接到此处选择的屏幕点。",
		},
		-- relativeTo = {
		-- 	label = "连接到框体",
		-- 	tooltip = "输入其他UI元素名称，将#FRAME位置连接到该框体。\n\n可用/framestack命令查询框体名称。",
		-- },
		anchor = {
			label = "连接锚点",
			tooltip = "选择#FRAME连接到屏幕点时要从哪个锚点对齐。",
		},
		keepInPlace = {
			label = "保持原位",
			tooltip = "更改#ANCHOR时不移动#FRAME，只更新偏移值。",
		},
		offsetX= {
			label = "水平偏移",
			tooltip = "设置#FRAME相对于选定#ANCHOR的水平（X轴）偏移量。",
		},
		offsetY = {
			label = "垂直偏移",
			tooltip = "设置#FRAME相对于选定#ANCHOR的垂直（Y轴）偏移量。",
		},
		keepInBounds = {
			label = "保持在屏幕内",
			tooltip = "确保#FRAME不会被移出屏幕范围。",
		},
	},
	presets = {
		apply = {
			label = "应用预设",
			tooltip = "选择并应用下列预设以更改#FRAME位置。",
			list = { "小地图下方", },
			select = "选择预设…",
		},
		save = {
			label = "更新#CUSTOM预设",
			tooltip = "将当前#FRAME的位置和可见性保存到#CUSTOM预设。",
			warning = "确定要用当前值覆盖#CUSTOM预设吗？",
		},
		reset = {
			label = "重置#CUSTOM预设",
			tooltip = "用默认值覆盖#CUSTOM预设数据并应用。",
			warning = "确定要用默认值覆盖#CUSTOM预设吗？",
		},
	},
	layer = {
		strata = {
			label = "屏幕层级",
			tooltip = "将#FRAME提升或降低到其他UI元素的前后。",
		},
		keepOnTop = {
			label = "鼠标交互时置顶",
			tooltip = "允许#FRAME在同一#STRATA内与其他框体交互时置于其上方。",
		},
		level = {
			label = "框体层级",
			tooltip = "#FRAME在同一#STRATA堆栈中上下的精确位置。",
		},
	},
	font = {
		title = "文本",
		path = {
			label = "字体",
			tooltip = "选择字体。",
			default = {
				label = "本地化默认字体",
				tooltip = "这是 Blizzard 使用的本地化默认字体。",
			},
			base = "这是基础游戏字体。",
			custom = "这是自定义字体。",
			otf = "OpenType 字体许可。",
			file = "文件路径：#PATH",
			replace = "自定义选项提供完全自定义功能，允许你将 #FILE_CUSTOM 字体文件替换为在\n#FONTS_DIRECTORY\n中找到的任何 TrueType 字体文件，同时保持原有的 #FILE_CUSTOM 文件名。",
			reminder = "替换字体文件后，你可能需要完全重启游戏客户端才能应用更改。",
		},
		size = {
			label = "大小",
			tooltip = "设置字体大小。",
		},
		alignment = {
			label = "对齐",
			tooltip = "选择文本的水平对齐方式。",
		},
		color = {
			label = "#COLOR_TYPE 颜色",
			tooltip = "设置 #COLOR_TYPE 文本颜色。",
		},
	},
	date = "#YEAR/#MONTH/#DAY",
	override = "覆盖",
	example = "示例",
}