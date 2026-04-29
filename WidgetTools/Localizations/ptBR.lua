--| Locale

if GetLocale() ~= "ptBR" then return end

--| Namespace

---@class addonNamespace
local ns = select(2, ...)

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Portuguese (Brazil)
---@class widgetToolsStrings_ptBR
ns.rs.strings = {
	about = {
		version = "Versão: #VERSION",
		date = "Data: #DATE",
		author = "Autor: #AUTHOR",
		license = "Licença: #LICENSE",
		toggle = {
			label = "Ativado",
			tooltip = "Desmarque para desativar este addon.\n\nEsta alteração só terá efeito após a interface ser recarregada. Uma vez desativado, este addon não aparecerá nesta lista até ser reativado no menu principal de AddOns.",
		},
	},
	specifications = {
		title = "Especificações",
		description = "Ajuste e ative/desative recursos opcionais. Digite /wt no chat para usar comandos.",
		general = {
			title = "Geral",
			description = "Opções que afetam todos os addons dependentes.",
			lite = {
				label = "Modo Lite",
				tooltip = "Desativa as configurações de TODOS os addons que usam Widget Toolboxes para economizar recursos e tornar o carregamento da interface mais rápido.\nOs dados das configurações dos addons ainda serão salvos e carregados em segundo plano, e o controle via chat permanecerá disponível para addons que o utilizam.\n\nPara desativar o Modo Lite e reativar as configurações, use o comando de chat #COMMAND ou clique em Widget Tools na lista de AddOns sob o botão de calendário no cabeçalho do Minimap (não disponível no Classic).",
			},
			positioningAids = {
				label = "Auxílios Visuais de Posicionamento",
				tooltip = "Exibe auxílios visuais ao posicionar quadros via widgets de configurações de addons que usam Widget Toolboxes.",
			},
		},
		dev = {
			title = "Ferramentas de Desenvolvimento",
			frameAttributes = {
				enabled = {
					label = "Redimensionar Atributos do Quadro",
					tooltip = "Personalize a largura da tabela dentro da janela de Atributos do Quadro (Frame TableAttributeDisplay).",
				},
				width = {
					label = "Largura dos Atributos do Quadro",
					tooltip = "Especifique a largura da tabela de conteúdo rolável na janela de Atributos do Quadro.",
				},
			},
		},
	},
	toolboxes = {
		title = "Toolboxes & Addons",
		description = "Lista dos addons atualmente carregados usando versões específicas das toolboxes #ADDON registradas.",
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Clique para abrir configurações específicas.",
		lite = "Modo Lite está ativado. Clique para desativar.",
	},
	lite = {
		enable = {
			warning = "Quando #ADDON está no Modo Lite, a interface de configurações dos addons dependentes não será carregada.\n\nTem certeza de que deseja ativar o Modo Lite e desabilitar a funcionalidade completa das configurações?",
			accept = "Ativar Modo Lite",
		},
		disable = {
			warning = "#ADDON está no Modo Lite, a interface de configurações dos addons dependentes não foi carregada.\n\nDeseja desativar o Modo Lite para reativar as configurações com funcionalidade completa?",
			accept = "Desativar Modo Lite",
		},
	},
	chat = {
		about = {
			description = "Abrir a página sobre o Widget Tools",
		},
		lite = {
			description = "Alternar Modo Lite: carregar ou não as configurações dos addons dependentes",
			response = "O Modo Lite será #STATE após a interface ser recarregada.",
			reminder = "Modo Lite está ativado, as configurações dos addons dependentes não foram carregadas.\n#HINT",
			hint = "Digite #COMMAND para desativar o Modo Lite.",
		},
	},
	separator = ".", -- Separador de milhar
	decimal = ",", -- Caractere decimal
}