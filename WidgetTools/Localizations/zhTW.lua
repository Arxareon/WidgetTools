--| Locale

if GetLocale() ~= "zhTW" then return end

--| Namespace

---@class addonNamespace
local ns = select(2, ...)

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Chinese (traditional, Taiwan)
---@class widgetToolsStrings_zhTW
ns.rs.strings = {
	about = {
		version = "版本：#VERSION",
		date = "日期：#DATE",
		author = "作者：#AUTHOR",
		license = "授權：#LICENSE",
		toggle = {
			label = "已啟用",
			tooltip = "取消勾選以停用此插件。\n\n此變更僅會在重新載入介面後生效。一旦停用，此插件將不會出現在此清單中，直到在主插件選單中重新啟用為止。",
		},
	},
	specifications = {
		title = "規格",
		description = "調整並切換選用功能。輸入 /wt 於聊天中以使用指令。",
		general = {
			title = "一般",
			description = "影響所有相依插件的選項。",
			lite = {
				label = "精簡模式",
				tooltip = "停用所有使用 Widget Toolboxes 插件的設定，以節省資源並加快介面載入速度。\n插件設定資料仍會在背景儲存與載入，且使用聊天控制的插件仍可使用該功能。\n\n若要關閉精簡模式並重新啟用設定，請使用 #COMMAND 聊天指令，或點擊小地圖標頭下方日曆按鈕旁的 AddOns 清單中的 Widget Tools（經典版無法使用）。",
			},
			positioningAids = {
				label = "定位視覺輔助",
				tooltip = "當使用採用 Widget Toolboxes 的插件設定元件定位框架時，顯示視覺輔助工具。",
			},
		},
		dev = {
			title = "開發工具",
			frameAttributes = {
				enabled = {
					label = "調整框架屬性大小",
					tooltip = "自訂框架屬性視窗（TableAttributeDisplay Frame）內表格的寬度。",
				},
				width = {
					label = "框架屬性寬度",
					tooltip = "指定框架屬性視窗中可捲動內容表格的寬度。",
				},
			},
		},
	},
	toolboxes = {
		title = "工具箱與插件",
		description = "目前已載入並使用已註冊 #ADDON 工具箱特定版本的插件清單。",
		toolbox = "工具箱（#VERSION）",
	},
	compartment = {
		open = "點擊以開啟特定設定。",
		lite = "精簡模式已啟用。點擊以停用。",
	},
	lite = {
		enable = {
			warning = "當 #ADDON 處於精簡模式時，相依插件的設定介面將不會載入。\n\n確定要啟用精簡模式並停用完整設定功能嗎？",
			accept = "啟用精簡模式",
		},
		disable = {
			warning = "#ADDON 處於精簡模式，相依插件的設定介面尚未載入。\n\n是否要關閉精簡模式並重新啟用完整設定功能？",
			accept = "停用精簡模式",
		},
	},
	chat = {
		about = {
			description = "開啟 Widget Tools 關於頁面",
		},
		lite = {
			description = "切換精簡模式：是否載入相依插件設定",
			response = "介面重新載入後，精簡模式將會是 #STATE。",
			reminder = "精簡模式已啟用，相依插件設定尚未載入。\n#HINT",
			hint = "輸入 #COMMAND 以停用精簡模式。",
		},
	},
	separator = ",", -- 千分位分隔符號
	decimal = ".", -- 小數點符號
}