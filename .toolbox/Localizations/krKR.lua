--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--[ Changelog ]

wt.changelog = {
    {
        "#V_Version 3.0_# #H_(23/4/2026)_#",
        "#F_핫픽스 (버전 3.0.1):_#",
        "여러 위치에 보호 장치를 추가하여 누락되었거나 잘못된 에셋 파일 경로(폰트 또는 텍스처)로 인해 치명적인 오류가 발생하지 않도록 했습니다.",
        "#N_새로운 기능:_#",
        "Midnight 12.0.5 지원이 추가되었습니다.",
        "이전에 추가된 설정 우클릭 메뉴가 더욱 향상되어, 유사한 유형의 설정 간에 값을 쉽게 이동할 수 있도록 복사 및 붙여넣기 기능이 추가되었습니다.",
        "폰트 옵션을 관리하기 위한 새로운 고급 설정 템플릿이 추가되었습니다 (향후 업데이트에서 더 많은 폰트 사용자 지정 옵션이 제공될 예정입니다).",
        "#C_변경 사항:_#",
        "설정 숫자 슬라이더의 외형이 새로운 블리자드 슬라이더와 일치하도록 업데이트되었으며, Widget Tools Toolboxes로 제작된 애드온의 모든 향상된 기능은 그대로 유지됩니다.",
        "Toolbox 로딩 구조가 전면 개편되었으며, 이전 버전은 더 이상 지원되지 않습니다.",
        "많은 기본 유틸리티 기능이 Widget Tools로 이전되어 이제 Toolbox 전용이 아니며, WidgetTools.utilities 컬렉션을 통해 전역적으로 접근할 수 있습니다.",
        "Toolbox 전용 데이터는 더 이상 프레임 테이블에 주입되지 않으며, 툴팁 또는 컨테이너 배치 데이터 등을 포함한 Toolbox 전용 테이블에 저장됩니다.",
        "블리자드 전역 OnEvent(및 사용자 정의 이벤트) 핸들러를 관리하는 이벤트 처리 백엔드 시스템이 업데이트되었으며, WidgetTools.utilities 컬렉션을 통해 전역적으로 접근 가능한 새로운 유틸리티가 추가되었습니다.",
        "사용자 지정 가능한 프레임, 버튼 및 기타 위젯은 이제 새로운 생성자를 통해 만들어야 하며, 기본 객체에서 사용자 지정 플래그가 제거되었습니다.",
        "개발 전용 주석 대부분이 설치된 애드온 파일 외부로 이동되어 설치 용량이 크게 줄었습니다.",
        "데이터 관리 설정 페이지(이제 '프로필 페이지'로 명명)의 구성 로직이 profilemanager 위젯과 그 위에 적용되는 GUI 변형으로 분리되어, 향후 개발 유연성과 사용자 지정 가능성이 향상되었습니다.",
        "기타 여러 내부 변경 및 개선이 이루어졌습니다.",
        "#F_핫픽스들:_#",
        "수많은 기타 작은 수정 사항이 포함되었습니다.",
        "#H_도움, 제안 및 버그 제보에 감사드립니다 !_# 문제가 발생하면 언제든지 제보해주세요. 문제가 언제, 어떻게 발생했는지, 그리고 (관련이 있다면) 어떤 다른 애드온을 사용 중인지 알려주시면 재현 및 수정에 큰 도움이 됩니다. 가능하다면 Lua 오류 메시지와 taint 로그도 함께 제공해주세요.",
    }
}

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Korean
---@class toolboxStrings_koKR
wt.strings = {
	chat = {
		welcome = {
			thanks = "#ADDON을(를) 사용해 주셔서 감사합니다!",
			hint = "#KEYWORD를 입력하여 채팅 명령어 목록을 확인하세요.",
			keywords = "#KEYWORD 또는 #KEYWORD_ALTERNATE",
		},
		help = {
			list = "#ADDON 채팅 명령어 목록:",
		},
	},
	popupInput = {
		title = "텍스트를 입력하세요",
		tooltip = KEY_ENTER .. "를 눌러 입력한 텍스트를 적용하거나 " .. KEY_ESCAPE .. "를 눌러 취소합니다."
	},
	reload = {
		title = "적용 대기 중인 변경 사항",
		description = "변경 사항을 적용하려면 인터페이스를 다시 불러오세요.",
		accept = {
			label = "지금 다시 불러오기",
			tooltip = "지금 인터페이스를 다시 불러와 변경 사항을 적용할 수 있습니다.",
		},
		cancel = {
			label = "나중에",
			tooltip = "/reload 명령어나 로그아웃으로 나중에 인터페이스를 다시 불러올 수 있습니다.",
		},
	},
	multiSelector = {
		locked = "잠김",
		minLimit = "#MIN개 이상의 옵션을 선택해야 합니다.",
		maxLimit = "한 번에 #MAX개 옵션만 선택할 수 있습니다.",
	},
	dropdown = {
		selected = "현재 선택된 옵션입니다.",
		none = "선택된 옵션이 없습니다.",
		open = "옵션 목록을 보려면 클릭하세요.",
		previous = {
			label = "이전 옵션",
			tooltip = "이전 옵션을 선택합니다.",
		},
		next = {
			label = "다음 옵션",
			tooltip = "다음 옵션을 선택합니다.",
		},
		clear = "선택 지우기",
	},
	copyBox = "텍스트 복사:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "값 지정",
			tooltip = "범위 내의 값을 입력하세요.",
		},
		decrease = {
			label = "감소",
			tooltip = {
				"값에서 #VALUE만큼 뺍니다.",
				"ALT를 누르고 있으면 #VALUE만큼 더 뺍니다.",
			},
		},
		increase = {
			label = "증가",
			tooltip = {
				"값에 #VALUE만큼 더합니다.",
				"ALT를 누르고 있으면 #VALUE만큼 더 더합니다.",
			},
		},
	},
	color = {
		picker = {
			label = "색상 선택",
			tooltip = "색상 선택기를 열어 색상#ALPHA을(를) 지정하세요.",
			alpha = " 및 투명도 변경",
		},
		hex = {
			label = "HEX 색상 코드로 추가",
			tooltip = "색상 선택기 대신 HEX 코드로 색상을 변경할 수 있습니다.",
		}
	},
	settings = {
		save = "닫을 때 변경 사항이 적용됩니다.",
		cancel = {
			label = "변경 사항 되돌리기",
			tooltip = "이 페이지에서 변경한 내용을 모두 취소하고 저장된 값을 불러옵니다.",
		},
		defaults = {
			label = "기본값 복원",
			tooltip = "이 페이지(또는 전체 카테고리)의 모든 설정을 기본값으로 복원합니다.",
		},
		warning = "#PAGE 페이지 또는 #CATEGORY 카테고리의 모든 설정을 기본값으로 초기화하시겠습니까?",
		warningSingle = "#PAGE 페이지의 설정을 기본값으로 초기화하시겠습니까?",
	},
	value = {
		copy = "값 복사",
		paste = "값 붙여넣기",
		revert = "변경 사항 되돌리기",
		restore = "기본값 복원",
		note = "오른쪽 클릭으로 복사하거나 되돌릴 수 있습니다.",
	},
	points = {
		left = "왼쪽",
		right = "오른쪽",
		center = "가운데",
		top = {
			left = "왼쪽 상단",
			right = "오른쪽 상단",
			center = "가운데 상단",
		},
		bottom = {
			left = "왼쪽 하단",
			right = "오른쪽 하단",
			center = "가운데 하단",
		},
	},
	strata = {
		lowest = "최하단 배경",
		lower = "중간 배경",
		low = "상위 배경",
		lowMid = "하위 중간",
		highMid = "상위 중간",
		high = "하위 전경",
		higher = "중간 전경",
		highest = "상위 전경",
	},
	about = {
		title = "정보",
		description = "#ADDON을(를) 사용해 주셔서 감사합니다! 피드백, 도움 요청, 개발 지원 방법은 링크를 참고하세요.",
		version = "버전",
		date = "날짜",
		author = "제작자",
		license = "라이선스",
		curseForge = "CurseForge 페이지",
		wago = "Wago 페이지",
		repository = "GitHub 저장소",
		issues = "문제 및 피드백",
		changelog = {
			label = "업데이트 노트",
			tooltip = "최신 버전(#VERSION)에 적용된 모든 변경, 업데이트, 수정 사항 노트입니다.",
		},
		fullChangelog = {
			label = "#ADDON 변경 기록",
			tooltip = "모든 애드온 버전의 전체 업데이트 노트 목록입니다.",
			open = {
				label = "변경 기록",
				tooltip = "모든 애드온 버전의 전체 업데이트 노트를 확인하세요.",
			},
		},
	},
	sponsors = {
		title = "후원자",
		description = "지속적인 후원에 진심으로 감사드립니다!",
	},
	dataManagement = {
		title = "데이터 관리",
		description = "프로필 및 백업을 가져오기/내보내기로 #ADDON 설정을 추가로 관리하세요.",
	},
	profiles = {
		title = "프로필",
		description = "각 캐릭터별로 고유한 옵션 프로필을 생성, 편집, 적용할 수 있습니다.",
		select = {
			label = "프로필 선택",
			tooltip = "현재 캐릭터에 사용할 옵션 데이터 저장 프로필을 선택하세요.\n\n활성 프로필의 데이터는 설정을 수정하고 저장할 때 자동으로 덮어씌워집니다!",
			profile = "프로필",
			main = "메인",
		},
		new = {
			label = "새 프로필",
			tooltip = "새 기본 프로필을 생성합니다.",
		},
		duplicate = {
			label = "복제",
			tooltip = "현재 활성 프로필의 데이터를 복사하여 새 프로필을 만듭니다.",
		},
		rename = {
			label = "이름 변경",
			tooltip = "현재 활성 프로필의 이름을 변경합니다.",
			description = "#PROFILE의 이름을 다음으로 변경:",
		},
		delete = {
			tooltip = "현재 활성 프로필을 삭제합니다.",
			warning = "현재 활성 #PROFILE #ADDON 설정 프로필을 삭제하고 저장된 모든 데이터를 영구적으로 삭제하시겠습니까?"
		},
		reset = {
			warning = "현재 활성 #PROFILE #ADDON 설정 프로필을 기본값으로 덮어쓰시겠습니까?",
		},
	},
	backup = {
		title = "백업",
		description = "현재 활성 프로필의 데이터를 가져오기/내보내기로 저장, 공유, 이동하거나 값을 직접 수정할 수 있습니다.",
		box = {
			label = "현재 프로필 가져오기/내보내기",
			tooltip = {
				"이 상자의 백업 문자열에는 현재 활성 애드온 프로필 데이터가 포함되어 있습니다.",
				"텍스트를 복사하여 데이터를 저장, 공유하거나 다른 계정에 불러올 수 있습니다.",
				"가지고 있는 문자열로 데이터를 불러오려면 이 상자의 텍스트를 덮어쓴 후 " .. KEY_ENTER .. "를 누르거나 #LOAD 버튼을 클릭하세요.",
				"참고: 커스텀 폰트나 텍스처 파일을 사용하는 경우, 해당 파일은 이 문자열로 함께 전송되지 않습니다. 별도로 저장 후 애드온 폴더에 넣어야 사용할 수 있습니다.",
				"직접 확인했거나 신뢰하는 소스의 문자열만 불러오세요!",
			},
		},
		allProfiles = {
			label = "모든 프로필 가져오기/내보내기",
			tooltipLine = "이 상자의 백업 문자열에는 모든 애드온 프로필 목록과 각 프로필에 저장된 데이터, 그리고 현재 활성 프로필 이름이 포함되어 있습니다.",
			open = {
				label = "모든 프로필",
				tooltip = "전체 프로필 목록에 접근하여 각 프로필의 데이터를 백업하거나 수정할 수 있습니다.",
			},
		},
		compact = {
			label = "간단히",
			tooltip = "간단한 보기와 더 읽기 쉽고 편집 가능한 보기로 전환합니다.",
		},
		load = {
			label = "불러오기",
			tooltip = "현재 문자열을 확인하고 데이터를 불러옵니다.",
		},
		reset = {
			tooltip = "문자열에 적용된 모든 변경 사항을 취소하고 현재 저장된 데이터로 초기화합니다.",
		},
		import = "문자열 불러오기",
		warning = "현재 입력된 문자열을 불러오시겠습니까?\n\n저장되지 않은 모든 변경 사항이 취소됩니다.\n\n온라인 소스에서 복사했거나 다른 사람이 보낸 경우, 내부 코드를 확인하고 신뢰할 수 있을 때만 불러오세요.\n\n신뢰하지 않는 소스라면 원치 않는 동작을 방지하기 위해 취소하는 것이 좋습니다.",
		error = "제공된 백업 문자열을 검증할 수 없어 데이터를 불러오지 못했습니다. 일부 문자가 누락되었거나 편집 중 오류가 발생했을 수 있습니다.",
	},
	position = {
		title = "위치",
		description = {
			static = "#FRAME의 화면 내 위치를 여기서 세밀하게 조정하세요.",
			movable = "SHIFT를 누른 채 #FRAME을 드래그하여 원하는 위치로 옮기고, 여기서 세밀하게 조정하세요.",
		},
		relativePoint = {
			label = "화면 기준점",
			tooltip = "#FRAME의 선택한 기준점을 여기서 선택한 연결점에 붙입니다.",
		},
		-- relativeTo = {
		-- 	label = "프레임에 연결",
		-- 	tooltip = "다른 UI 요소(프레임) 이름을 입력하여 #FRAME의 위치를 연결할 수 있습니다.\n\n/framestack 명령어로 프레임 이름을 확인할 수 있습니다.",
		-- },
		anchor = {
			label = "연결 기준점",
			tooltip = "선택한 화면 기준점에 연결할 때 #FRAME이 어느 지점에서 고정될지 선택하세요.",
		},
		keepInPlace = {
			label = "위치 유지",
			tooltip = "#ANCHOR를 변경해도 #FRAME을 이동하지 않고 오프셋 값만 업데이트합니다.",
		},
		offsetX= {
			label = "수평 오프셋",
			tooltip = "선택한 #ANCHOR로부터 #FRAME의 수평(X축) 오프셋을 설정합니다.",
		},
		offsetY = {
			label = "수직 오프셋",
			tooltip = "선택한 #ANCHOR로부터 #FRAME의 수직(Y축) 오프셋을 설정합니다.",
		},
		keepInBounds = {
			label = "화면 내에 유지",
			tooltip = "#FRAME이 화면 밖으로 나가지 않도록 합니다.",
		},
	},
	presets = {
		apply = {
			label = "프리셋 적용",
			tooltip = "#FRAME의 위치를 아래 프리셋 중 하나를 선택해 변경하세요.",
			list = { "미니맵 아래", },
			select = "프리셋 선택…",
		},
		save = {
			label = "#CUSTOM 프리셋 업데이트",
			tooltip = "현재 #FRAME의 위치와 표시 상태를 #CUSTOM 프리셋에 저장합니다.",
			warning = "#CUSTOM 프리셋을 현재 값으로 덮어쓰시겠습니까?",
		},
		reset = {
			label = "#CUSTOM 프리셋 초기화",
			tooltip = "저장된 #CUSTOM 프리셋 데이터를 기본값으로 덮어쓰고 적용합니다.",
			warning = "#CUSTOM 프리셋을 기본값으로 덮어쓰시겠습니까?",
		},
	},
	layer = {
		strata = {
			label = "화면 레이어",
			tooltip = "#FRAME을 다른 UI 요소보다 앞이나 뒤로 이동시킵니다.",
		},
		keepOnTop = {
			label = "마우스 상호작용 시 위로 표시",
			tooltip = "마우스 상호작용 시 #FRAME이 같은 #STRATA 내 다른 프레임 위로 이동할 수 있도록 허용합니다.",
		},
		level = {
			label = "프레임 레벨",
			tooltip = "같은 #STRATA 스택 내에서 #FRAME이 위/아래에 위치할 정확한 레벨입니다.",
		},
	},
	font = {
		title = "텍스트",
		path = {
			label = "글꼴",
			tooltip = "글꼴을 선택하세요.",
			default = {
				label = "지역화된 기본 글꼴",
				tooltip = "이것은 블리자드에서 사용하는 지역화된 기본 글꼴입니다.",
			},
			base = "이것은 기본 게임 글꼴입니다.",
			custom = "이것은 사용자 지정 글꼴입니다.",
			otf = "OpenType 글꼴 라이선스.",
			file = "파일 경로: #PATH",
			replace = "사용자 지정 옵션은 #FILE_CUSTOM 글꼴 파일을\n#FONTS_DIRECTORY\n내에서 찾을 수 있는 다른 TrueType 글꼴 파일로 교체하여 완전한 사용자 지정을 제공합니다. 단, 원래의 #FILE_CUSTOM 파일 이름은 유지해야 합니다.",
			reminder = "글꼴 파일을 교체한 후 변경 사항을 적용하려면 게임 클라이언트를 완전히 재시작해야 할 수 있습니다.",
		},
		size = {
			label = "크기",
			tooltip = "글꼴 크기를 설정하세요.",
		},
		alignment = {
			label = "정렬",
			tooltip = "텍스트의 가로 정렬을 선택하세요.",
		},
		color = {
			copy = "값 복사",
			paste = "값 붙여넣기",
		},
	},
	date = "#YEAR년 #MONTH월 #DAY일",
	override = "덮어쓰기",
	example = "예시",
}