--| Namespace

---@class namespace
local ns = select(2, ...)

--[ Changelog ]

ns.changelog = {
    {
        "#V_Version 3.0_# #H_(23/4/2026)_#",
        "#F_Hotfix (Versão 3.0.1):_#",
        "#H_O suporte a arquivos de fontes personalizadas foi revertido para a solução anterior (agora gerenciada pelo Widget Tools) até a próxima atualização, pois um descuido estava causando erros críticos._# Também removi várias fontes para economizar espaço em disco. Quando o suporte planejado para fontes totalmente personalizadas estiver concluído e lançado, qualquer quantidade de fontes personalizadas poderá ser usada, tornando desnecessário manter tantas fontes incluídas. #H_Para adicionar um arquivo de fonte personalizado com esta solução temporária, assim como antes, substitua_# #O_Interface/Addons/WidgetTools/Fonts/CUSTOM.ttf_# #H_por qualquer arquivo TrueTypeFont, mantendo exatamente esse nome._#",
        "Várias fontes foram removidas e não serão mais incluídas, pois prefiro priorizar tamanhos menores de arquivo, e arquivos de fontes grandes que oferecem pouco benefício para a maioria vão contra esse objetivo.",
        "Foram adicionadas informações de Wago ID para ajudar o Wago a encontrar e baixar automaticamente dependências do addon.",
        "#N_Novo:_#",
        "Adicionado suporte ao Midnight 12.0.5.",
        "Uma lista compartilhada de fontes personalizadas foi adicionada, e agora todos os addons podem acessá-la através da coleção global #H_WidgetTools.resources_#. #H_Um arquivo de fonte personalizado chamado_# #O_CUSTOM.ttf_# #H_pode agora ser colocado na pasta principal_# #O_Fonts_# #H_dentro da pasta do cliente do WoW_# para ser reconhecido pelo Widget Tools. A gestão de fontes personalizadas será expandida em futuras atualizações.",
        "Novas ferramentas de registro de depuração foram introduzidas, acessíveis pela coleção global #H_WidgetTools.debugging_#. As funcionalidades de depuração serão expandidas e integradas às Toolboxes em atualizações futuras.",
        "#C_Alterações:_#",
        "A estrutura de carregamento da Toolbox foi reformulada; versões antigas não são mais suportadas.",
        "Muitas funções utilitárias básicas foram transferidas para o Widget Tools (e não são mais específicas da Toolbox), acessíveis globalmente pela coleção #H_WidgetTools.utilities_#.",
        "O sistema backend de gerenciamento de eventos que controla os handlers OnEvent globais da Blizzard (e eventos personalizados) foi atualizado, com novas utilidades acessíveis globalmente pela coleção #H_WidgetTools.utilities_#.",
        "A maioria das anotações destinadas apenas ao desenvolvimento foi movida para fora dos arquivos instalados do addon, reduzindo significativamente o tamanho da instalação.",
        "Várias outras melhorias e alterações internas.",
        "#F_Correções:_#",
        "O menu de contexto do Widget Tools no menu AddOns não ocupará mais a área clicável da tela após ser aberto uma vez.",
        "Numerosas outras pequenas correções.",
        "#O_Nota:_# Veja o changelog do Widget Toolbox na página Toolboxes & Addons para mais alterações internas.",
        "#H_Obrigado a todos pela ajuda, sugestões e relatos de bugs !_# Caso encontre algum problema, não hesite em relatar! Inclua quando e como ocorreu, e quais outros addons você usa (quando relevante), para me dar a melhor chance de reproduzir e corrigir o problema. Inclua mensagens de erro Lua e logs de taint, se souber como obtê-los.",
    },
    {
        "#V_Version 2.2_# #H_(23/2/2026)_#",
        "#F_Hotfix:_#",
        "O texto nas caixas de edição voltará a ser dimensionado corretamente para caber na largura das caixas.",
    },
    {
        "#V_Version 2.2_# #H_(13/2/2026)_#",
        "#F_Hotfix:_#",
        "O texto nas caixas de edição voltará a ser dimensionado corretamente para caber na largura das caixas.",
    },
    {
        "#V_Version 2.1_# #H_(13/2/2026)_#",
        "#N_Atualizações:_#",
        "Adicionado suporte ao Midnight 12.0.1, Mists of Pandaria 5.5.3, The Burning Crusade 2.5.5 e Classic 1.15.8.",
        "Melhorias internas.",
    },
    {
        "#V_Version 2.0_# #H_(8/6/2025)_#",
        "#N_Novo:_#",
        "Adicionado suporte ao Mists of Pandaria Classic 5.5.0, The War Within 11.2 e Classic 1.15.7.",
        "Foram adicionadas localizações traduzidas por IA para todos os idiomas suportados pelo WoW. #H_Nota: Como essas traduções foram geradas por IA, elas contêm erros. Se quiser ajudar a corrigir algumas delas, ou se quiser se voluntariar para traduzir este addon corretamente para o seu idioma, entre em contato! Toda ajuda e relato de erro é muito apreciado! <3_# (O changelog estará disponível apenas em inglês por enquanto.)",
        "#H_Um novo modo Lite foi introduzido !_# Quando ativado, nenhuma página de configurações gerenciada pelo Widget Tools será carregada para addons construídos com Widget Tools, economizando recursos. Desative para acessar novamente as configurações visíveis do addon. (Os dados do addon continuam sendo carregados em segundo plano, sem afetar a funcionalidade.)",
        "#H_Ajudas visuais de posicionamento foram adicionadas !_# Uma opção para ativar ajudas visuais de posicionamento para addons construídos com Widget Tools foi introduzida, ajudando a entender como funcionam as configurações avançadas de posicionamento e permitindo controle total dos detalhes.",
        "Adicionada uma opção para desenvolvedores ampliarem a janela Frame Attributes (TableAttributeDisplay Frame).",
        "Adicionados comandos de chat para Widget Tools, use: #H_/wt_#",
        "#H_#C_Alterações_# & #F_Correções_#:_#",
        "A aparência das caixas de seleção e páginas de configurações foi atualizada para combinar com o novo estilo de configurações.",
        "Melhorias internas significativas, correções e outras pequenas alterações.",
        "#V_Version 2.0.1_# • #F_Hotfix:_#",
        "Mensagens de boas-vindas não serão mais exibidas repetidamente a cada carregamento da interface.",
        "O modo Lite agora pode ser ativado sem erros.",
        "A aparência da janela de aviso de recarregamento foi ajustada.",
    },
    {
        "#V_Version 1.12_# #H_(8/9/2023)_#",
        "#C_Alterações:_#",
        "Atalhos foram removidos da página principal de configurações do addon no Classic.",
        "Melhorias internas.",
    },
    {
        "#V_Version 1.11_# #H_(7/18/2023)_#",
        "#C_Alterações:_#",
        "Adicionado suporte à versão 1.14.4 (Classic), com retrocompatibilidade com 1.14.3 (até o patch Hardcore entrar no ar).",
        "A rolagem foi aprimorada no WotLK Classic.",
        "A retrocompatibilidade que garantia o funcionamento das caixas de edição com a Toolbox versão 1.5 foi removida.",
        "Outras pequenas melhorias.",
    },
    {
        "#V_Version 1.10_# #H_(6/15/2023)_#",
        "#N_Atualizações:_#",
        "Adicionado suporte ao 10.1.5 (Dragonflight).",
        "#F_Correções:_#",
        "Nenhuma tooltip permanecerá na tela após seu alvo ser ocultado.",
        "Correções e melhorias internas.",
    },
    {
        "#V_Version 1.9_# #H_(5/17/2023)_#",
        "#C_Alterações:_#",
        "Atualizado para o novo sistema de logotipos de addons do Dragonflight. (Logotipos personalizados podem não aparecer nas Opções de Interface em clientes Classic.)",
        "#F_Correções:_#",
        "Corrigido um problema no Dragonflight onde ações eram bloqueadas após fechar o painel de Configurações (por exemplo, ao alterar atalhos).",
        "A versão atual agora funciona no PTR do WotLK Classic 3.4.2, mas ainda não está totalmente refinada (pois partes da interface ainda estão sendo modernizadas).",
        "Outras melhorias internas e limpeza de código.",
    },
    {
        "#V_Version 1.8_# #H_(4/5/2023)_#",
        "#N_Atualizações:_#",
        "Adicionado suporte ao 10.1 (Dragonflight).",
        "#F_Correções:_#",
        "As barras de rolagem antigas foram substituídas pelas novas barras do Dragonflight, corrigindo erros que surgiram com a descontinuação no 10.1.",
        "Várias outras correções e melhorias internas.",
    },
    {
        "#V_Version 1.7_# #H_(3/11/2023)_#",
        "#N_Atualizações:_#",
        "Adicionada uma opção para desativar addons que usam Widget Toolboxes nas configurações do Widget Tools.",
        "Adicionado suporte ao 10.0.7 (Dragonflight).",
        "#C_Alterações:_#",
        "A seção de Atalhos foi removida da página principal de configurações no Dragonflight (a nova expansão quebrou a funcionalidade — posso adicioná-la novamente se for corrigida).",
        "Outras pequenas alterações.",
        "#F_Correções:_#",
        "Várias correções e melhorias internas.",
    },
    {
        "#V_Version 1.6_# #H_(2/7/2023)_#",
        "#N_Atualizações:_#",
        "Uma nova seção de Patrocinadores foi adicionada à página principal de Configurações.\n#H_Obrigado pelo seu apoio! Ele me ajuda a continuar dedicando tempo ao desenvolvimento e manutenção destes addons. Se você está considerando apoiar o desenvolvimento, siga os links para ver as opções disponíveis._#",
        "As informações Sobre foram reorganizadas e combinadas com os links de Suporte.",
        "Agora apenas as notas de atualização mais recentes serão carregadas. O changelog completo está disponível em uma janela maior ao clicar em um novo botão.",
        "As caixas de seleção agora são mais fáceis de clicar, e suas tooltips ficam visíveis mesmo quando a entrada está desativada.",
        "Adicionado suporte ao 10.0.5 (Dragonflight) e 3.4.1 (WotLK Classic).",
        "Numerosas alterações e melhorias menores.",
        "#F_Correções:_#",
        "O Widget Tools não criará mais cópias de suas Configurações após cada tela de carregamento.",
        "As configurações agora devem ser salvas corretamente no Dragonflight, e as funcionalidades personalizadas Restaurar Padrões e Reverter Alterações devem funcionar como esperado, por página de configurações (mantendo a opção de restaurar padrões para todo o addon).",
        "Todos os outros submenus de contexto personalizados no mesmo nível agora devem fechar quando um é aberto (mais melhorias no menu de contexto estão planejadas para uma versão futura).",
        "Muitas outras correções internas.",
    },
    {
        "#V_Version 1.5_# #H_(11/28/2020)_#",
        "#H_O Widget Tools tem apoiado outros addons em segundo plano por mais de um ano. Agora ele foi separado em um addon próprio para oferecer mais visibilidade, transparência e opções de desenvolvimento._#",
        "#N_Atualização:_#",
        "Adicionado suporte ao Dragonflight (Retail 10.0) com retrocompatibilidade.",
    }
}

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Portuguese (Brazil)
---@class widgetToolsStrings_ptBR
ns.strings = {
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
			debugging = {
				enabled = {
					label = "Modo de Depuração",
					tooltip = "Ative para criar, salvar e exibir entradas de log de depuração na janela de chat.",
				},
			},
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
		debug = {
			description = "Ativar o Modo de Depuração: salva e exibe logs de depuração no chat",
			response = "O modo de depuração ficará #STATE após recarregar a interface.",
			hint = "Digite #COMMAND para desativar o Modo de Depuração.",
		},
	},
	separator = ".", -- Separador de milhar
	decimal = ",", -- Caractere decimal
}