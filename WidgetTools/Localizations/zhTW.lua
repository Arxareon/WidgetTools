--| Namespace

---@class namespace
local ns = select(2, ...)

--[ Changelog ]

ns.changelog = {
    {
        "#V_Version 3.0_# #H_(23/4/2026)_#",
        "#F_熱修復（版本 3.0.1）：_#",
        "#H_由於一個疏忽導致嚴重錯誤，自訂字體檔案的支援已暫時恢復為先前的方案（但現在由 Widget Tools 處理），直到下一次更新。_# 我也移除了數個字體以減少安裝大小。當計畫中的完整自訂字體支援完成並發布後，將能使用任意數量的自訂字體，屆時就不需要再捆綁這麼多字體。 #H_要使用此臨時方案加入自訂字體檔案，與之前相同，請將_# #O_Interface/Addons/WidgetTools/Fonts/CUSTOM.ttf_# #H_替換為任意 TrueTypeFont 檔案，並保持完全相同的檔名。_#",
        "多個字體已被移除且不再隨附，因為我希望優先減少檔案大小，而大型字體檔案對大多數玩家幫助不大，反而違背此目標。",
        "新增 Wago ID 資訊，以協助 Wago 自動尋找並下載插件相依性。",
        "#N_新增:_#",
        "新增對 Midnight 12.0.5 的支援。",
        "新增一個共享的自訂字體列表，所有插件現在都能透過全域 #H_WidgetTools.resources_# 集合存取。 #H_一個名為_# #O_CUSTOM.ttf_# #H_的自訂字體檔案現在可以放在 WoW 客戶端資料夾內的_# #O_Fonts_# #H_資料夾中_#，Widget Tools 會自動辨識。未來更新將擴展自訂字體管理功能。",
        "新增除錯紀錄工具，可透過全域 #H_WidgetTools.debugging_# 集合存取。除錯功能將在未來更新中擴展並整合進 Toolboxes。",
        "#C_變更:_#",
        "Toolbox 的載入結構已全面重製，不再支援舊版本。",
        "許多基本工具函式已移交給 Widget Tools（不再是 Toolbox 專屬），可透過全域 #H_WidgetTools.utilities_# 集合存取。",
        "管理 Blizzard 全域 OnEvent（以及自訂事件）處理器的事件後端系統已更新，並新增可透過 #H_WidgetTools.utilities_# 全域存取的工具函式。",
        "大部分僅供開發使用的註解已移出插件安裝檔案，以大幅減少安裝大小。",
        "其他多項底層改善與優化。",
        "#F_修復:_#",
        "Widget Tools 在 AddOns 選單中的右鍵選單不會再在首次開啟後佔據可點擊區域。",
        "許多其他小型修正。",
        "#O_注意:_# 更多底層變更請查看 Toolboxes & Addons 頁面的 Widget Toolbox 更新紀錄。",
        "#H_感謝大家的協助、建議與錯誤回報 !_# 若遇到任何問題，請務必回報！請盡量說明問題發生的時間、方式，以及（若相關）你正在使用的其他插件，以便我能更容易重現並修正問題。如有可能，請附上 Lua 錯誤訊息與 taint 記錄。",
    },
    {
        "#V_Version 2.2_# #H_(23/2/2026)_#",
        "#F_熱修復:_#",
        "輸入框中的文字現在會再次正確調整以符合框體寬度。",
    },
    {
        "#V_Version 2.2_# #H_(13/2/2026)_#",
        "#F_熱修復:_#",
        "輸入框中的文字現在會再次正確調整以符合框體寬度。",
    },
    {
        "#V_Version 2.1_# #H_(13/2/2026)_#",
        "#N_更新:_#",
        "新增對 Midnight 12.0.1、Mists of Pandaria 5.5.3、The Burning Crusade 2.5.5 與 Classic 1.15.8 的支援。",
        "底層改善。",
    },
    {
        "#V_Version 2.0_# #H_(8/6/2025)_#",
        "#N_新增:_#",
        "新增對 Mists of Pandaria Classic 5.5.0、The War Within 11.2 與 Classic 1.15.7 的支援。",
        "新增由 AI 翻譯的所有 WoW 支援語言的本地化。 #H_注意：由於這些翻譯由 AI 生成，因此包含錯誤。如果你願意協助修正其中一些，或願意協助將插件正確翻譯為你的語言，請與我聯繫！非常感謝所有協助與錯誤回報！<3_#（更新紀錄目前僅提供英文版本。）",
        "#H_新增精簡模式（Lite Mode） !_# 啟用後，Widget Tools 管理的設定頁面將不會載入，以節省資源。停用後即可再次看到插件的設定頁面。（插件資料仍會在背景載入，不影響功能。）",
        "#H_新增定位視覺輔助 !_# 新增一項選項，可啟用 Widget Tools 插件的定位視覺輔助，以協助理解進階定位設定的運作方式，讓你能更精準地控制細節。",
        "新增開發者選項，可將 Frame Attributes（TableAttributeDisplay Frame）視窗加寬。",
        "新增 Widget Tools 聊天指令，使用：#H_/wt_#",
        "#H_#C_變更_# & #F_修復_#:_#",
        "核取方塊與設定頁面的外觀已更新，以符合新的設定風格。",
        "大量底層改善與修復，以及其他小型變更與修正。",
        "#V_Version 2.0.1_# • #F_熱修復:_#",
        "歡迎訊息不會再在每次介面載入時重複出現。",
        "精簡模式現在可以正常啟用，不會再出現錯誤。",
        "調整了重新載入提示視窗的外觀。",
    },
    {
        "#V_Version 1.12_# #H_(8/9/2023)_#",
        "#C_變更:_#",
        "Classic 中已從主設定頁面移除捷徑區段。",
        "底層改善。",
    },
    {
        "#V_Version 1.11_# #H_(7/18/2023)_#",
        "#C_變更:_#",
        "新增對 1.14.4（Classic）的支援，並保留對 1.14.3 的相容性（直到硬派模式補丁上線）。",
        "改善了 WotLK Classic 的捲動體驗。",
        "移除了確保輸入框能在 Toolbox 1.5 版本運作的相容性程式碼。",
        "其他小型改善。",
    },
    {
        "#V_Version 1.10_# #H_(6/15/2023)_#",
        "#N_更新:_#",
        "新增對 10.1.5（Dragonflight）的支援。",
        "#F_修復:_#",
        "目標被隱藏後，提示框將不再停留在畫面上。",
        "底層修復與改善。",
    },
    {
        "#V_Version 1.9_# #H_(5/17/2023)_#",
        "#C_變更:_#",
        "更新至新的 Dragonflight 插件圖示處理方式。（Classic 客戶端中自訂插件圖示可能不會顯示在介面選項中。）",
        "#F_修復:_#",
        "修正了 Dragonflight 中關閉設定面板後（例如更改按鍵綁定時）某些操作被阻止的問題。",
        "目前版本可在 WotLK Classic 3.4.2 PTR 中運作，但尚未完全完善（部分 UI 仍在現代化中）。",
        "其他底層改善與程式碼清理。",
    },
    {
        "#V_Version 1.8_# #H_(4/5/2023)_#",
        "#N_更新:_#",
        "新增對 10.1（Dragonflight）的支援。",
        "#F_修復:_#",
        "舊捲動條已被 Dragonflight 新捲動條取代，修正了因舊版棄用而在 10.1 出現的問題。",
        "其他多項底層修復與改善。",
    },
    {
        "#V_Version 1.7_# #H_(3/11/2023)_#",
        "#N_更新:_#",
        "新增選項，可在 Widget Tools 設定中停用使用 Widget Toolboxes 的插件。",
        "新增對 10.0.7（Dragonflight）的支援。",
        "#C_變更:_#",
        "由於新資料片破壞了功能，Dragonflight 中已從主設定頁面移除捷徑區段（若問題解決，可能會重新加入）。",
        "其他小型變更。",
        "#F_修復:_#",
        "多項底層修復與改善。",
    },
    {
        "#V_Version 1.6_# #H_(2/7/2023)_#",
        "#N_更新:_#",
        "主設定頁面新增贊助者（Sponsors）區段。\n#H_感謝你的支持！這讓我能持續投入時間開發與維護這些插件。如果你也考慮支持開發，請查看連結了解目前可用方式。_#",
        "「關於」資訊已重新整理並與支援連結合併。",
        "現在只會載入最新的更新說明。點擊新按鈕可在更大的視窗中查看完整更新紀錄。",
        "核取方塊現在更容易點擊，即使輸入被停用，其提示框仍會顯示。",
        "新增對 10.0.5（Dragonflight）與 3.4.1（WotLK Classic）的支援。",
        "多項較小的變更與改善。",
        "#F_修復:_#",
        "Widget Tools 不會再在每次載入畫面後複製其設定。",
        "設定現在應能在 Dragonflight 中正確儲存，自訂的「恢復預設」與「還原變更」功能也應能正常運作（逐頁生效，同時保留恢復整個插件預設值的選項）。",
        "同層級的其他自訂右鍵子選單現在會在開啟其中一個時自動關閉（未來更新將加入更多右鍵選單改善）。",
        "許多其他底層修復。",
    },
    {
        "#V_Version 1.5_# #H_(11/28/2020)_#",
        "#H_Widget Tools 已在背景支援其他插件超過一年。現在它被拆分為獨立插件，以提供更高的可見度、透明度與更廣泛的開發可能性。_#",
        "#N_更新:_#",
        "新增對 Dragonflight（正式服 10.0）的支援，並保留向下相容性。",
    }
}

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Chinese (traditional, Taiwan)
---@class widgetToolsStrings_zhTW
ns.strings = {
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