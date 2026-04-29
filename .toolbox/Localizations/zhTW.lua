--| Locale

if GetLocale() ~= "zhTW" then return end

--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Chinese (traditional, Taiwan)
---@class toolboxStrings_zhTW
wt.strings = {
	chat = {
		welcome = {
			thanks = "感謝您使用#ADDON！",
			hint = "輸入#KEYWORD來查看聊天指令列表。",
			keywords = "#KEYWORD 或 #KEYWORD_ALTERNATE",
		},
		help = {
			list = "#ADDON 聊天指令列表：",
		},
	},
	popupInput = {
		title = "請輸入文字",
		tooltip = "按下" .. KEY_ENTER .. "以接受輸入的文字，或按" .. KEY_ESCAPE .. "以取消。",
	},
	reload = {
		title = "有待套用的變更",
		description = "請重新載入介面以套用變更。",
		accept = {
			label = "立即重載",
			tooltip = "您可以選擇現在重載介面以套用變更。",
		},
		cancel = {
			label = "稍後",
			tooltip = "稍後可使用 /reload 指令或登出來重載介面。",
		},
	},
	multiSelector = {
		locked = "已鎖定",
		minLimit = "至少需選擇 #MIN 個選項。",
		maxLimit = "一次只能選擇 #MAX 個選項。",
	},
	dropdown = {
		selected = "這是目前選擇的選項。",
		none = "尚未選擇任何選項。",
		open = "點擊以檢視選項列表。",
		previous = {
			label = "上一個選項",
			tooltip = "選擇上一個選項。",
		},
		next = {
			label = "下一個選項",
			tooltip = "選擇下一個選項。",
		},
		clear = "清除選取",
	},
	copyBox = "請按下：\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac) 來複製文字",
	slider = {
		value = {
			label = "請輸入數值",
			tooltip = "請輸入範圍內的數值。",
		},
		decrease = {
			label = "減少",
			tooltip = {
				"從數值中減去 #VALUE。",
				"按住 ALT 可減去 #VALUE。",
			},
		},
		increase = {
			label = "增加",
			tooltip = {
				"將 #VALUE 加到數值中。",
				"按住 ALT 可加上 #VALUE。",
			},
		},
	},
	color = {
		picker = {
			label = "選擇顏色",
			tooltip = "開啟顏色選擇器自訂顏色#ALPHA。",
			alpha = "並調整透明度",
		},
		hex = {
			label = "以 HEX 色碼新增",
			tooltip = "您也可以直接輸入 HEX 色碼來變更顏色。",
		}
	},
	settings = {
		save = "關閉時將套用變更。",
		cancel = {
			label = "還原變更",
			tooltip = "放棄本頁所有變更並載入已儲存的值。",
		},
		defaults = {
			label = "恢復預設值",
			tooltip = "將本頁（或整個分類）所有設定恢復為預設值。",
		},
		warning = "確定要將 #PAGE 頁面或 #CATEGORY 分類的所有設定恢復為預設值嗎？",
		warningSingle = "確定要將 #PAGE 頁面的設定恢復為預設值嗎？",
	},
	value = {
		copy = "複製數值",
		paste = "貼上數值",
		revert = "還原變更",
		restore = "恢復預設",
		note = "右鍵點擊可複製或還原。",
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
		lowMid = "低中層",
		highMid = "高中層",
		high = "低前景",
		higher = "中前景",
		highest = "高前景",
	},
	about = {
		title = "關於",
		description = "感謝您使用#ADDON！複製下方連結以提供回饋、取得協助或支持開發。",
		version = "版本",
		date = "日期",
		author = "作者",
		license = "授權",
		curseForge = "CurseForge 頁面",
		wago = "Wago 頁面",
		repository = "GitHub 儲存庫",
		issues = "問題與回饋",
		changelog = {
			label = "更新紀錄",
			tooltip = "此版本（#VERSION）所有變更、更新與修正說明。",
		},
		fullChangelog = {
			label = "#ADDON 更新紀錄",
			tooltip = "所有版本的完整更新說明列表。",
			open = {
				label = "更新紀錄",
				tooltip = "閱讀所有版本的完整更新說明。",
			},
		},
	},
	sponsors = {
		title = "贊助者",
		description = "感謝您的持續支持！",
	},
	dataManagement = {
		title = "資料管理",
		description = "透過匯入、匯出選項管理設定檔與備份以進一步設定#ADDON。",
	},
	profiles = {
		title = "設定檔",
		description = "為每個角色建立、編輯並套用專屬設定檔。",
		select = {
			label = "選擇設定檔",
			tooltip = "選擇目前角色要使用的設定檔。\n\n當設定變更並儲存時，啟用的設定檔資料會自動被覆蓋！",
			profile = "設定檔",
			main = "主要",
		},
		new = {
			label = "新增設定檔",
			tooltip = "建立新的預設設定檔。",
		},
		duplicate = {
			label = "複製",
			tooltip = "以目前啟用的設定檔資料建立新設定檔。",
		},
		rename = {
			label = "重新命名",
			tooltip = "重新命名目前啟用的設定檔。",
			description = "將 #PROFILE 重新命名為：",
		},
		delete = {
			tooltip = "刪除目前啟用的設定檔。",
			warning = "確定要移除目前啟用的 #PROFILE #ADDON 設定檔並永久刪除所有儲存資料嗎？"
		},
		reset = {
			warning = "確定要將目前啟用的 #PROFILE #ADDON 設定檔覆蓋為預設值嗎？",
		},
	},
	backup = {
		title = "備份",
		description = "匯入或匯出目前啟用設定檔的資料以儲存、分享、搬移設定，或手動編輯特定值。",
		box = {
			label = "匯入或匯出目前設定檔",
			tooltip = {
				"此欄位的備份字串包含目前啟用的設定檔資料。",
				"複製文字以儲存、分享或載入到其他帳號。",
				"若要從字串載入資料，請覆蓋此欄位內容後按" .. KEY_ENTER .. "或點擊#LOAD按鈕。",
				"注意：若您使用自訂字型或材質檔案，這些檔案不會隨字串一同轉移。需另外儲存並放入插件資料夾。",
				"請僅載入您自行驗證或信任來源的字串！",
			},
		},
		allProfiles = {
			label = "匯入或匯出所有設定檔",
			tooltipLine = "此欄位的備份字串包含所有設定檔及其資料，以及目前啟用的設定檔名稱。",
			open = {
				label = "所有設定檔",
				tooltip = "存取完整設定檔列表並備份或修改各自資料。",
			},
		},
		compact = {
			label = "精簡",
			tooltip = "切換精簡或可讀/可編輯檢視。",
		},
		load = {
			label = "載入",
			tooltip = "檢查目前字串並嘗試載入資料。",
		},
		reset = {
			tooltip = "放棄對字串的所有變更，並重設為目前儲存的資料。",
		},
		import = "載入字串",
		warning = "確定要嘗試載入目前輸入的字串嗎？\n\n所有未儲存的變更將被放棄。\n\n若您是從網路來源複製或他人傳送，請確認內容安全再載入。\n\n若不信任來源，建議取消以避免不預期的行為。",
		error = "無法驗證提供的備份字串，未載入任何資料。可能缺少字元或編輯時產生錯誤。",
	},
	position = {
		title = "位置",
		description = {
			static = "可在此微調#FRAME於螢幕上的位置。",
			movable = "按住 SHIFT 拖曳#FRAME至螢幕任意位置，並可於此微調。",
		},
		relativePoint = {
			label = "螢幕連結點",
			tooltip = "將#FRAME選定的錨點連結到此處選擇的螢幕點。",
		},
		-- relativeTo = {
		-- 	label = "連結到框架",
		-- 	tooltip = "輸入其他 UI 元素名稱，將#FRAME位置連結至該框架。\n\n可用 /framestack 指令查詢框架名稱。",
		-- },
		anchor = {
			label = "連結錨點",
			tooltip = "選擇#FRAME連結到螢幕點時要從哪個錨點對齊。",
		},
		keepInPlace = {
			label = "保持原位",
			tooltip = "變更#ANCHOR時不移動#FRAME，只更新偏移值。",
		},
		offsetX= {
			label = "水平偏移",
			tooltip = "設定#FRAME自選定#ANCHOR的水平（X軸）偏移量。",
		},
		offsetY = {
			label = "垂直偏移",
			tooltip = "設定#FRAME自選定#ANCHOR的垂直（Y軸）偏移量。",
		},
		keepInBounds = {
			label = "保持在螢幕內",
			tooltip = "確保#FRAME不會被移出螢幕範圍。",
		},
	},
	presets = {
		apply = {
			label = "套用預設位置",
			tooltip = "選擇並套用下列預設位置以變更#FRAME位置。",
			list = { "小地圖下方", },
			select = "選擇預設位置…",
		},
		save = {
			label = "更新#CUSTOM預設",
			tooltip = "將目前#FRAME的位置與顯示狀態儲存至#CUSTOM預設。",
			warning = "確定要以目前值覆蓋#CUSTOM預設嗎？",
		},
		reset = {
			label = "重設#CUSTOM預設",
			tooltip = "以預設值覆蓋#CUSTOM預設資料並套用。",
			warning = "確定要以預設值覆蓋#CUSTOM預設嗎？",
		},
	},
	layer = {
		strata = {
			label = "畫面層級",
			tooltip = "將#FRAME提升或降低至其他 UI 元素的前後。",
		},
		keepOnTop = {
			label = "滑鼠互動時顯示在最上層",
			tooltip = "互動時允許#FRAME在同一#STRATA內移到其他框架之上。",
		},
		level = {
			label = "框架層級",
			tooltip = "#FRAME在同一#STRATA堆疊中上下的精確位置。",
		},
	},
	font = {
		title = "文字",
		path = {
			label = "字體",
			tooltip = "選擇字體。",
			default = {
				label = "在地化預設字體",
				tooltip = "這是 Blizzard 使用的在地化預設字體。",
			},
			base = "這是遊戲本體的字體。",
			custom = "這是自訂字體。",
			otf = "OpenType 字體授權。",
			file = "檔案路徑：#PATH",
			replace = "自訂選項提供完整的自訂功能，讓您可以將 #FILE_CUSTOM 字體檔替換為在\n#FONTS_DIRECTORY\n中找到的任何 TrueType 字體檔，同時保持原本的 #FILE_CUSTOM 檔名。",
			reminder = "替換字體檔後，您可能需要完全重新啟動遊戲客戶端才能套用變更。",
		},
		size = {
			label = "大小",
			tooltip = "設定字體大小。",
		},
		alignment = {
			label = "對齊",
			tooltip = "選擇文字的水平對齊方式。",
		},
		color = {
			label = "#COLOR_TYPE 顏色",
			tooltip = "設定 #COLOR_TYPE 文字顏色。",
		},
	},
	date = "#YEAR/#MONTH/#DAY",
	override = "覆蓋",
	example = "範例",
}