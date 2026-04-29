--| Locale

if GetLocale() ~= "krKR" then return end

--| Namespace

---@class addonNamespace
local ns = select(2, ...)

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Korean
---@class widgetToolsStrings_koKR
ns.rs.strings = {
	about = {
		version = "버전: #VERSION",
		date = "날짜: #DATE",
		author = "작성자: #AUTHOR",
		license = "라이선스: #LICENSE",
		toggle = {
			label = "사용함",
			tooltip = "이 애드온을 비활성화하려면 체크를 해제하세요.\n\n이 변경 사항은 인터페이스를 다시 불러온 후에만 적용됩니다. 비활성화되면, 이 애드온은 메인 AddOns 메뉴에서 다시 활성화하기 전까지 이 목록에 표시되지 않습니다.",
		},
	},
	specifications = {
		title = "사양",
		description = "선택적 기능을 조정 및 전환합니다. 채팅창에 /wt를 입력하여 명령어를 사용할 수 있습니다.",
		general = {
			title = "일반",
			description = "모든 의존 애드온에 영향을 주는 옵션입니다.",
			lite = {
				label = "라이트 모드",
				tooltip = "모든 Widget Toolboxes를 사용하는 애드온의 설정을 비활성화하여 리소스를 절약하고 인터페이스 로딩 속도를 높입니다.\n애드온 설정 데이터는 백그라운드에서 계속 저장 및 불러오며, 채팅 제어는 해당 기능을 사용하는 애드온에서 계속 사용할 수 있습니다.\n\n라이트 모드를 끄고 설정을 다시 활성화하려면 #COMMAND 채팅 명령어를 사용하거나, 미니맵 헤더의 달력 버튼 아래 AddOns 목록에서 Widget Tools를 클릭하세요(클래식에서는 사용 불가).",
			},
			positioningAids = {
				label = "위치 시각 보조",
				tooltip = "Widget Toolboxes를 사용하는 애드온의 설정 위젯을 통해 프레임을 배치할 때 시각적 보조 도구를 표시합니다.",
			},
		},
		dev = {
			title = "개발 도구",
			frameAttributes = {
				enabled = {
					label = "프레임 속성 크기 조절",
					tooltip = "프레임 속성 창(TableAttributeDisplay Frame) 내부의 테이블 너비를 사용자 지정합니다.",
				},
				width = {
					label = "프레임 속성 너비",
					tooltip = "프레임 속성 창의 스크롤 가능한 콘텐츠 테이블의 너비를 지정하세요.",
				},
			},
		},
	},
	toolboxes = {
		title = "툴박스 & 애드온",
		description = "등록된 #ADDON 툴박스의 특정 버전을 사용하는 현재 로드된 애드온 목록입니다.",
		toolbox = "툴박스 (#VERSION)",
	},
	compartment = {
		open = "클릭하여 특정 설정을 엽니다.",
		lite = "라이트 모드가 활성화됨. 클릭하여 비활성화.",
	},
	lite = {
		enable = {
			warning = "#ADDON이 라이트 모드일 때, 의존 애드온의 설정 UI가 로드되지 않습니다.\n\n정말로 라이트 모드를 켜고 전체 설정 기능을 비활성화하시겠습니까?",
			accept = "라이트 모드 활성화",
		},
		disable = {
			warning = "#ADDON이 라이트 모드이며, 의존 애드온의 설정 UI가 로드되지 않았습니다.\n\n라이트 모드를 꺼서 전체 기능의 설정을 다시 활성화하시겠습니까?",
			accept = "라이트 모드 비활성화",
		},
	},
	chat = {
		about = {
			description = "Widget Tools 정보 페이지 열기",
		},
		lite = {
			description = "라이트 모드 전환: 의존 애드온 설정을 불러올지 여부",
			response = "인터페이스를 다시 불러온 후 라이트 모드는 #STATE 상태가 됩니다.",
			reminder = "라이트 모드가 활성화되어 의존 애드온의 설정이 로드되지 않았습니다.\n#HINT",
			hint = "#COMMAND를 입력하여 라이트 모드를 비활성화하세요.",
		},
	},
	separator = ",", -- 천 단위 구분자
	decimal = ".", -- 소수점 문자
}