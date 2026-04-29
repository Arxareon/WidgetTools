--| Locale

if GetLocale() ~= "ptBR" then return end

--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Portuguese (Brazil)
---@class toolboxStrings_ptBR
wt.strings = {
	chat = {
		welcome = {
			thanks = "Obrigado por usar #ADDON!",
			hint = "Digite #KEYWORD para ver a lista de comandos do chat.",
			keywords = "#KEYWORD ou #KEYWORD_ALTERNATE",
		},
		help = {
			list = "Lista de comandos do chat do #ADDON:",
		},
	},
	popupInput = {
		title = "Especifique o texto",
		tooltip = "Pressione " .. KEY_ENTER .. " para aceitar o texto especificado ou " .. KEY_ESCAPE .. " para cancelar.",
	},
	reload = {
		title = "Alterações Pendentes",
		description = "Recarregue a interface para aplicar as alterações pendentes.",
		accept = {
			label = "Recarregar Agora",
			tooltip = "Você pode escolher recarregar a interface agora para aplicar as alterações pendentes.",
		},
		cancel = {
			label = "Depois",
			tooltip = "Recarregue a interface depois com o comando /reload ou saindo do jogo.",
		},
	},
	multiSelector = {
		locked = "Bloqueado",
		minLimit = "Pelo menos #MIN opções devem ser selecionadas.",
		maxLimit = "Apenas #MAX opções podem ser selecionadas ao mesmo tempo.",
	},
	dropdown = {
		selected = "Esta é a opção atualmente selecionada.",
		none = "Nenhuma opção foi selecionada.",
		open = "Clique para ver a lista de opções.",
		previous = {
			label = "Opção anterior",
			tooltip = "Selecionar a opção anterior.",
		},
		next = {
			label = "Próxima opção",
			tooltip = "Selecionar a próxima opção.",
		},
		clear = "Limpar seleção",
	},
	copyBox = "Copie o texto pressionando:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Especifique o valor",
			tooltip = "Digite qualquer valor dentro do intervalo.",
		},
		decrease = {
			label = "Diminuir",
			tooltip = {
				"Subtrai #VALUE do valor.",
				"Segure ALT para subtrair #VALUE em vez disso.",
			},
		},
		increase = {
			label = "Aumentar",
			tooltip = {
				"Adiciona #VALUE ao valor.",
				"Segure ALT para adicionar #VALUE em vez disso.",
			},
		},
	},
	color = {
		picker = {
			label = "Escolher uma cor",
			tooltip = "Abra o seletor de cores para personalizar a cor#ALPHA.",
			alpha = " e alterar a opacidade",
		},
		hex = {
			label = "Adicionar via código HEX",
			tooltip = "Você pode alterar a cor via código HEX em vez de usar o seletor de cores.",
		}
	},
	settings = {
		save = "As alterações serão finalizadas ao fechar.",
		cancel = {
			label = "Reverter Alterações",
			tooltip = "Desfazer todas as alterações feitas nesta página e carregar os valores salvos.",
		},
		defaults = {
			label = "Restaurar Padrões",
			tooltip = "Restaurar todas as configurações desta página (ou categoria) para os valores padrão.",
		},
		warning = "Tem certeza que deseja redefinir as configurações da página #PAGE ou todas as configurações da categoria #CATEGORY para os padrões?",
		warningSingle = "Tem certeza que deseja redefinir as configurações da página #PAGE para os padrões?",
	},
	value = {
		copy = "Copiar Valor",
		paste = "Colar Valor",
		revert = "Reverter Alterações",
		restore = "Restaurar Padrão",
		note = "Clique com o botão direito para copiar ou reverter.",
	},
	points = {
		left = "Esquerda",
		right = "Direita",
		center = "Centro",
		top = {
			left = "Superior Esquerdo",
			right = "Superior Direito",
			center = "Superior Centro",
		},
		bottom = {
			left = "Inferior Esquerdo",
			right = "Inferior Direito",
			center = "Inferior Centro",
		},
	},
	strata = {
		lowest = "Plano de Fundo Baixo",
		lower = "Plano de Fundo Médio",
		low = "Plano de Fundo Alto",
		lowMid = "Meio Baixo",
		highMid = "Meio Alto",
		high = "Primeiro Plano Baixo",
		higher = "Primeiro Plano Médio",
		highest = "Primeiro Plano Alto",
	},
	about = {
		title = "Sobre",
		description = "Obrigado por usar #ADDON! Copie os links para saber como enviar feedback, obter ajuda e apoiar o desenvolvimento.",
		version = "Versão",
		date = "Data",
		author = "Autor",
		license = "Licença",
		curseForge = "Página CurseForge",
		wago = "Página Wago",
		repository = "Repositório GitHub",
		issues = "Problemas & Feedback",
		changelog = {
			label = "Notas da Atualização",
			tooltip = "Notas de todas as mudanças, atualizações e correções introduzidas na versão mais recente: #VERSION.",
		},
		fullChangelog = {
			label = "Changelog do #ADDON",
			tooltip = "A lista completa de notas de atualização de todas as versões do addon.",
			open = {
				label = "Changelog",
				tooltip = "Leia a lista completa de notas de atualização de todas as versões do addon.",
			},
		},
	},
	sponsors = {
		title = "Patrocinadores",
		description = "Seu apoio contínuo é muito apreciado! Obrigado!",
	},
	dataManagement = {
		title = "Gerenciamento de Dados",
		description = "Configure ainda mais as opções do #ADDON gerenciando perfis e backups através das opções de importação e exportação.",
	},
	profiles = {
		title = "Perfis",
		description = "Crie, edite e aplique perfis de opções exclusivos para cada um dos seus personagens.",
		select = {
			label = "Selecionar um Perfil",
			tooltip = "Escolha o perfil de armazenamento de dados de opções a ser usado para seu personagem atual.\n\nOs dados do perfil ativo serão sobrescritos automaticamente quando as configurações forem modificadas e salvas!",
			profile = "Perfil",
			main = "Principal",
		},
		new = {
			label = "Novo Perfil",
			tooltip = "Criar um novo perfil padrão.",
		},
		duplicate = {
			label = "Duplicar",
			tooltip = "Criar um novo perfil, copiando os dados do perfil ativo.",
		},
		rename = {
			label = "Renomear",
			tooltip = "Renomear o perfil ativo.",
			description = "Renomear #PROFILE para:",
		},
		delete = {
			tooltip = "Excluir o perfil ativo.",
			warning = "Tem certeza que deseja remover o perfil de configurações #PROFILE #ADDON ativo e excluir permanentemente todos os dados armazenados nele?"
		},
		reset = {
			warning = "Tem certeza que deseja sobrescrever o perfil de configurações #PROFILE #ADDON ativo com os valores padrão?",
		},
	},
	backup = {
		title = "Backup",
		description = "Importe ou exporte dados do perfil ativo para salvar, compartilhar, mover configurações ou editar valores manualmente.",
		box = {
			label = "Importar ou Exportar Perfil Atual",
			tooltip = {
				"A string de backup nesta caixa contém os dados do perfil ativo do addon.",
				"Copie o texto para salvar, compartilhar ou carregar dados para outra conta.",
				"Para carregar dados de uma string que você possui, substitua o texto nesta caixa e pressione " .. KEY_ENTER .. " ou clique no botão #LOAD.",
				"Nota: Se você estiver usando arquivos de fonte ou textura personalizados, esses arquivos não serão transferidos com esta string. Eles precisarão ser salvos separadamente e colados na pasta do addon para serem utilizáveis.",
				"Carregue apenas strings que você mesmo verificou ou confia na fonte!",
			},
		},
		allProfiles = {
			label = "Importar ou Exportar Todos os Perfis",
			tooltipLine = "A string de backup nesta caixa contém a lista de todos os perfis do addon e os dados armazenados em cada um, bem como o nome do perfil ativo.",
			open = {
				label = "Todos os Perfis",
				tooltip = "Acesse a lista completa de perfis e faça backup ou modifique os dados armazenados em cada um.",
			},
		},
		compact = {
			label = "Compacto",
			tooltip = "Alternar entre uma visualização compacta e uma mais legível/editável.",
		},
		load = {
			label = "Carregar",
			tooltip = "Verifique a string atual e tente carregar os dados dela.",
		},
		reset = {
			tooltip = "Desfazer todas as alterações feitas na string e restaurá-la para conter os dados atualmente armazenados.",
		},
		import = "Carregar a string",
		warning = "Tem certeza que deseja tentar carregar a string inserida?\n\nTodas as alterações não salvas serão descartadas.\n\nSe você a copiou de uma fonte online ou alguém lhe enviou, só carregue após verificar o código e saber o que está fazendo.\n\nSe não confiar na fonte, cancele para evitar ações indesejadas.",
		error = "A string de backup fornecida não pôde ser validada e nenhum dado foi carregado. Pode estar faltando caracteres ou erros podem ter sido introduzidos se foi editada.",
	},
	position = {
		title = "Posição",
		description = {
			static = "Ajuste a posição de #FRAME na tela usando as opções fornecidas aqui.",
			movable = "Arraste e solte #FRAME segurando SHIFT para posicioná-lo em qualquer lugar da tela, ajuste aqui.",
		},
		relativePoint = {
			label = "Ponto de Ligação na Tela",
			tooltip = "Anexe o ponto de ancoragem escolhido de #FRAME ao ponto de ligação selecionado aqui.",
		},
		-- relativeTo = {
		-- 	label = "Vincular a Quadro",
		-- 	tooltip = "Digite o nome de outro elemento da interface, um quadro para vincular a posição de #FRAME.\n\nDescubra os nomes dos quadros ativando a interface de depuração com o comando /framestack.",
		-- },
		anchor = {
			label = "Ponto de Ancoragem",
			tooltip = "Selecione de qual ponto #FRAME deve ser ancorado ao vincular ao ponto da tela escolhido.",
		},
		keepInPlace = {
			label = "Manter no lugar",
			tooltip = "Não mova #FRAME ao alterar o #ANCHOR, atualize os valores de deslocamento em vez disso.",
		},
		offsetX= {
			label = "Deslocamento Horizontal",
			tooltip = "Defina a quantidade de deslocamento horizontal (eixo X) de #FRAME a partir do #ANCHOR selecionado.",
		},
		offsetY = {
			label = "Deslocamento Vertical",
			tooltip = "Defina a quantidade de deslocamento vertical (eixo Y) de #FRAME a partir do #ANCHOR selecionado.",
		},
		keepInBounds = {
			label = "Manter dentro da tela",
			tooltip = "Certifique-se de que #FRAME não possa ser movido para fora dos limites da tela.",
		},
	},
	presets = {
		apply = {
			label = "Aplicar um Predefinido",
			tooltip = "Altere a posição de #FRAME escolhendo e aplicando um destes predefinidos.",
			list = { "Abaixo do Minimap", },
			select = "Selecione um predefinido…",
		},
		save = {
			label = "Atualizar Predefinido #CUSTOM",
			tooltip = "Salve a posição e visibilidade atuais de #FRAME no predefinido #CUSTOM.",
			warning = "Tem certeza que deseja sobrescrever o predefinido #CUSTOM com os valores atuais?",
		},
		reset = {
			label = "Redefinir Predefinido #CUSTOM",
			tooltip = "Sobrescreva os dados do predefinido #CUSTOM com os valores padrão e aplique.",
			warning = "Tem certeza que deseja sobrescrever o predefinido #CUSTOM com os valores padrão?",
		},
	},
	layer = {
		strata = {
			label = "Camada da Tela",
			tooltip = "Eleve ou abaixe #FRAME para ficar à frente ou atrás de outros elementos da interface.",
		},
		keepOnTop = {
			label = "Revelar ao interagir com o mouse",
			tooltip = "Permitir que #FRAME seja movido acima de outros quadros na mesma #STRATA ao ser interagido.",
		},
		level = {
			label = "Nível do Quadro",
			tooltip = "A posição exata de #FRAME acima ou abaixo de outros quadros na mesma pilha #STRATA.",
		},
	},
	font = {
		title = "Texto",
		path = {
			label = "Fonte",
			tooltip = "Selecione a fonte.",
			default = {
				label = "Padrão Localizado",
				tooltip = "Esta é uma fonte padrão localizada usada pela Blizzard.",
			},
			base = "Esta é uma fonte do jogo base.",
			custom = "Esta é uma fonte personalizada.",
			otf = "Licença de fonte OpenType.",
			file = "Caminho do arquivo: #PATH",
			replace = "A opção Personalizada oferece total customização, permitindo que você use qualquer fonte substituindo o arquivo de fonte #FILE_CUSTOM por qualquer outro arquivo TrueType encontrado em\n#FONTS_DIRECTORY\nmantendo o nome original do arquivo #FILE_CUSTOM.",
			reminder = "Pode ser necessário reiniciar completamente o cliente do jogo após substituir o arquivo de fonte para aplicar a alteração.",
		},
		size = {
			label = "Tamanho",
			tooltip = "Defina o tamanho da fonte.",
		},
		alignment = {
			label = "Alinhamento",
			tooltip = "Selecione o alinhamento horizontal do texto.",
		},
		color = {
			label = "Cor de #COLOR_TYPE",
			tooltip = "Defina a cor do texto #COLOR_TYPE.",
		},
	},
	date = "#DAY/#MONTH/#YEAR",
	override = "Sobrescrever",
	example = "Exemplo",
}