--| Namespace

---@class namespace
local ns = select(2, ...)

--[ Changelog ]

ns.changelog = {
    {
        "#V_Version 3.0_# #H_(23/4/2026)_#",
        "#F_热修复（版本 3.0.1）：_#",
        "#H_由于一个疏忽导致严重报错，自定义字体文件支持已暂时恢复为之前的方案（但现在由 Widget Tools 处理），直到下次更新。_# 我还删除了数个字体文件以减少安装体积。等计划中的完整自定义字体支持完成并发布后，将可以使用任意数量的自定义字体，届时就无需再捆绑这么多字体了。 #H_要使用此临时方案添加自定义字体文件，与之前相同，将_# #O_Interface/Addons/WidgetTools/Fonts/CUSTOM.ttf_# #H_替换为任意 TrueTypeFont 文件，并保持文件名完全一致即可。_#",
        "多个字体文件已被移除，不再随插件一起提供，因为我更希望优先减少文件体积，而大型字体文件对大多数用户帮助不大，反而违背这一目标。",
        "添加了 Wago ID 信息，以便 Wago 自动查找并下载插件依赖。",
        "#N_新增:_#",
        "新增对 Midnight 12.0.5 的支持。",
        "新增一个共享的自定义字体列表，所有插件现在都可以通过全局 #H_WidgetTools.resources_# 集合访问。 #H_一个名为_# #O_CUSTOM.ttf_# #H_的自定义字体文件现在可以放在 WoW 客户端目录下的_# #O_Fonts_# #H_文件夹中_#，Widget Tools 会自动识别。未来更新将扩展自定义字体管理功能。",
        "新增调试日志工具，可通过全局 #H_WidgetTools.debugging_# 集合访问。调试功能将在未来更新中扩展并整合进 Toolboxes。",
        "#C_更改:_#",
        "Toolbox 的加载结构已全面重构，不再支持旧版本。",
        "许多基础工具函数已移交给 Widget Tools（不再是 Toolbox 专属），可通过全局 #H_WidgetTools.utilities_# 集合访问。",
        "用于管理 Blizzard 全局 OnEvent（以及自定义事件）处理器的事件处理后台系统已更新，并新增可通过 #H_WidgetTools.utilities_# 全局访问的工具函数。",
        "大部分仅用于开发的注释已移出插件安装文件，以大幅减少安装体积。",
        "其他多项底层改进与优化。",
        "#F_修复:_#",
        "Widget Tools 在 AddOns 菜单中的右键菜单不再在首次打开后占据可点击区域。",
        "大量其他小型修复。",
        "#O_注意:_# 更多底层更改请查看 Toolboxes & Addons 页面上的 Widget Toolbox 更新日志。",
        "#H_感谢大家的帮助、建议与错误报告 !_# 如果遇到任何问题，请务必反馈！请尽量说明问题发生的时间、方式，以及（如相关）你正在使用的其他插件，以便我能更好地复现并修复问题。如有可能，请附上 Lua 报错信息与 taint 日志。",
    },
    {
        "#V_Version 2.2_# #H_(23/2/2026)_#",
        "#F_热修复:_#",
        "编辑框中的文字现在会再次正确适配其宽度。",
    },
    {
        "#V_Version 2.2_# #H_(13/2/2026)_#",
        "#F_热修复:_#",
        "编辑框中的文字现在会再次正确适配其宽度。",
    },
    {
        "#V_Version 2.1_# #H_(13/2/2026)_#",
        "#N_更新:_#",
        "新增对 Midnight 12.0.1、Mists of Pandaria 5.5.3、The Burning Crusade 2.5.5 与 Classic 1.15.8 的支持。",
        "底层改进。",
    },
    {
        "#V_Version 2.0_# #H_(8/6/2025)_#",
        "#N_新增:_#",
        "新增对 Mists of Pandaria Classic 5.5.0、The War Within 11.2 与 Classic 1.15.7 的支持。",
        "新增由 AI 翻译的所有 WoW 支持语言的本地化。 #H_注意：由于这些翻译由 AI 生成，因此包含错误。如果你愿意帮助我修复其中一些，或愿意协助将插件正确翻译为你的语言，请联系我！非常感谢所有帮助与错误报告！<3_#（更新日志暂时仅提供英文版本。）",
        "#H_新增轻量模式 !_# 启用后，Widget Tools 管理的设置页面将不会加载，从而节省资源。禁用后可再次访问插件的可见设置。（插件数据仍会在后台加载，不影响功能。）",
        "#H_新增定位可视化辅助 !_# 新增一项选项，可启用 Widget Tools 插件的定位可视化辅助，以帮助理解高级定位设置的工作方式，从而实现更精细的控制。",
        "新增开发者选项，可将 Frame Attributes（TableAttributeDisplay Frame）窗口加宽。",
        "新增 Widget Tools 聊天指令，使用：#H_/wt_#",
        "#H_#C_更改_# & #F_修复_#:_#",
        "复选框与设置页面的外观已更新，以匹配新的设置风格。",
        "大量底层改进与修复，以及其他小型更改与修复。",
        "#V_Version 2.0.1_# • #F_热修复:_#",
        "欢迎信息不再在每次界面加载时重复出现。",
        "轻量模式现在可以无错误地启用。",
        "调整了重载提示窗口的外观。",
    },
    {
        "#V_Version 1.12_# #H_(8/9/2023)_#",
        "#C_更改:_#",
        "Classic 中已从主设置页面移除快捷方式部分。",
        "底层改进。",
    },
    {
        "#V_Version 1.11_# #H_(7/18/2023)_#",
        "#C_更改:_#",
        "新增对 1.14.4（Classic）的支持，并保持对 1.14.3 的兼容（直到硬核模式补丁上线）。",
        "改进了 WotLK Classic 中的滚动体验。",
        "移除了确保编辑框在 Toolbox 1.5 版本下工作的兼容性代码。",
        "其他小型改进。",
    },
    {
        "#V_Version 1.10_# #H_(6/15/2023)_#",
        "#N_更新:_#",
        "新增对 10.1.5（Dragonflight）的支持。",
        "#F_修复:_#",
        "目标被隐藏后，提示框将不再停留在屏幕上。",
        "底层修复与改进。",
    },
    {
        "#V_Version 1.9_# #H_(5/17/2023)_#",
        "#C_更改:_#",
        "升级至新的 Dragonflight 插件图标处理方式。（Classic 客户端中自定义插件图标可能不会显示在界面选项中。）",
        "#F_修复:_#",
        "修复了 Dragonflight 中关闭设置面板后（例如更改按键绑定时）某些操作被阻止的问题。",
        "当前版本可在 WotLK Classic 3.4.2 PTR 中运行，但尚未完全完善（部分 UI 仍在现代化过程中）。",
        "其他底层改进与代码清理。",
    },
    {
        "#V_Version 1.8_# #H_(4/5/2023)_#",
        "#N_更新:_#",
        "新增对 10.1（Dragonflight）的支持。",
        "#F_修复:_#",
        "旧滚动条已被 Dragonflight 新滚动条替换，修复了因旧版本弃用而在 10.1 中出现的问题。",
        "其他多项底层修复与改进。",
    },
    {
        "#V_Version 1.7_# #H_(3/11/2023)_#",
        "#N_更新:_#",
        "新增选项，可在 Widget Tools 设置中禁用使用 Widget Toolboxes 的插件。",
        "新增对 10.0.7（Dragonflight）的支持。",
        "#C_更改:_#",
        "由于新资料片破坏了功能，Dragonflight 中已从主设置页面移除快捷方式部分（若问题解决，可能会重新加入）。",
        "其他小型更改。",
        "#F_修复:_#",
        "多项底层修复与改进。",
    },
    {
        "#V_Version 1.6_# #H_(2/7/2023)_#",
        "#N_更新:_#",
        "主设置页面新增赞助者（Sponsors）部分。\n#H_感谢大家的支持！这帮助我继续投入时间开发与维护这些插件。如果你也考虑支持开发，请查看链接了解当前可用方式。_#",
        "“关于”信息已重新整理并与支持链接合并。",
        "现在只会加载最新的更新说明。点击新按钮可在更大的窗口中查看完整更新日志。",
        "复选框现在更容易点击，即使输入被禁用，其提示框也会显示。",
        "新增对 10.0.5（Dragonflight）与 3.4.1（WotLK Classic）的支持。",
        "多项较小的更改与改进。",
        "#F_修复:_#",
        "Widget Tools 不再在每次加载界面后复制其设置。",
        "设置现在应能在 Dragonflight 中正确保存，自定义的“恢复默认”和“撤销更改”功能也应按预期工作（按页面生效，同时保留恢复整个插件默认值的选项）。",
        "同级的其他自定义上下文子菜单现在会在打开一个时自动关闭（更多上下文菜单改进将在未来更新中加入）。",
        "许多其他底层修复。",
    },
    {
        "#V_Version 1.5_# #H_(11/28/2020)_#",
        "#H_Widget Tools 在后台支持其他插件已超过一年。现在它被拆分为独立插件，以提供更高的可见性、透明度与更广泛的开发可能性。_#",
        "#N_更新:_#",
        "新增对 Dragonflight（正式服 10.0）的支持，并保持向下兼容。",
    }
}

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Chinese (simplified, PRC)
---@class widgetToolsStrings_zhCN
ns.strings = {
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