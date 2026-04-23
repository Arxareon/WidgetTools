--| Namespace

---@class addonNamespace
local ns = select(2, ...)

--| Shared resources

---@class widgetToolsResources
ns.rs = {}

ns.rs.addon = ...
ns.rs.title = select(2, C_AddOns.GetAddOnInfo(ns.rs.addon)):gsub("^%s*(.-)%s*$", "%1")
ns.rs.root = "Interface/AddOns/" .. ns.rs.addon .. "/"


--[[ ASSETS ]]

ns.rs.colors = {
	grey = {
		{ r = 0.7, g = 0.7, b = 0.7 },
		{ r = 0.54, g = 0.54, b = 0.54 },
	},
	gold = {
		{ r = 1, g = 0.76, b = 0.07 },
		{ r = 0.8, g = 0.62, b = 0.1 },
	},
	halfTransparent = {
		grey = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 },
		blue = { r = 0.7, g = 0.9, b = 1, a = 0.5 },
		yellow = { r = 1, g = 0.9, b = 0.7, a = 0.5 },
	},
	-- normal = NORMAL_FONT_COLOR,
	-- highlight = HIGHLIGHT_FONT_COLOR,
	-- disabled = GRAY_FONT_COLOR,
	-- warning = RED_FONT_COLOR,
}

ns.rs.textures = {
	logo = ns.rs.root .. "Textures/Logo.tga",
	missing = ns.rs.root .. "Textures/MissingLogo.tga",
	alphaBG = ns.rs.root .. "Textures/AlphaBG.tga",
	gradientBG = ns.rs.root .. "Textures/GradientBG.tga",
}

ns.rs.fonts = {
	{
		name = "Arbutus Slab",
		path = ns.rs.root .. "Fonts/ArbutusSlab.ttf",
	},
	{
		name = "Arial Narrow",
		path = "Fonts/ARIALN.ttf",
	},
	{
		name = "Bonbon",
		path = ns.rs.root .. "Fonts/Bonbon.ttf",
	},
	{
		name = "Caesar Dressing",
		path = ns.rs.root .. "Fonts/CaesarDressing.ttf",
	},
	{
		name = "Domine",
		path = ns.rs.root .. "Fonts/Domine.ttf",
	},
	{
		name = "Friz Quadrata",
		path = "Fonts/FRIZQT__.TTF",
	},
	{
		name = "Germania One",
		path = ns.rs.root .. "Fonts/GermaniaOne.ttf",
	},
	{
		name = "Molle",
		path = ns.rs.root .. "Fonts/Molle.ttf",
	},
	{
		name = "Morpheus",
		path = "Fonts/MORPHEUS.ttf",
	},
	{
		name = "Oregano",
		path = ns.rs.root .. "Fonts/Oregano.ttf",
	},
	{
		name = "Oxanium",
		path = ns.rs.root .. "Fonts/Oxanium.ttf",
	},
	{
		name = "Reem Kufi",
		path = ns.rs.root .. "Fonts/ReemKufi.ttf",
	},
	{
		name = "Righteous",
		path = ns.rs.root .. "Fonts/Righteous.ttf",
	},
	{
		name = "Sancreek",
		path = ns.rs.root .. "Fonts/Sancreek.ttf",
	},
	{
		name = "Skurri",
		path = "Fonts/skurri.ttf",
	},
	{
		name = "Underdog",
		path =  ns.rs.root .. "Fonts/Underdog.ttf",
	},
	{
		name = "Zen Dots",
		path =  ns.rs.root .. "Fonts/ZenDots.ttf",
	},
	{
		name = "CUSTOM", --REMOVE temporarily reinstated CUSTOM font solution once full custom font file support has been added
		path =  ns.rs.root .. "Fonts/CUSTOM.ttf",
	},
}


--[[ STRINGS ]]

ns.changelog = {
	{
		"#V_Version 3.0_# #H_(23/4/2026)_#",
		"#F_Hotfix (Version 3.0.1):_#",
		"#H_The custom font file support has been reverted to the previous solution (but now handled by Widget Tools) until the next update because an oversight caused critical errors._# I have also removed several fonts to save on disk space. Once the planned custom font support is finished and released, any number of fully custom fonts will be usable to there will be little need to keep so many fonts bundled in. #H_To add a custom font file with this temporary solution, similarly like before, replace_# #O_Interface/Addons/WidgetTools/Fonts/CUSTOM.ttf_# #H_with any TrueTypeFont file, while keeping this exact file name._#",
		"Several fonts have been removed and will no not be bundled in because I would rather prioritize smaller file sizes, and having large font files that offer little benefit for most is in opposition to that goal.",
		"Added Wago ID information to help Wago to find and download addon dependencies automatically.",
		"#N_New:_#",
		"Added Midnight 12.0.5 support.",
		"A shared list of custom fonts have been added that all addons can now access via the global #H_WidgetTools.resources_# collection. #H_One custom font file named_# #O_CUSTOM.ttf_# #H_can now be placed in the main_# #O_Fonts_# #H_folder right inside the WoW client folder._# to be recognized by Widget Tools. Custom font file management is planned to be extended on in future updates.",
		"Introduced new debug logging tools accessible via the global #H_WidgetTools.debugging_# collection. Debugging features are to be expanded on and to be incorporated into Toolboxes in future updates.",
		"#C_Changes:_#",
		"The Toolbox loading structure has been overhauled, older versions are no longer supported.",
		"Many basic utility functions have been handed over to Widget Tools (and are no longer Toolbox-specific), accessible in code globally via the #H_WidgetTools.utilities_# collection.",
		"Updated the event handling backend system managing Blizzard global OnEvent (and custom event) handlers for Frames with new utilities accessible globally via the #H_WidgetTools.utilities_# collection.",
		"Most annotations that offer development-only benefits have been moved outside of installed addon files to greatly reduce install size.",
		"Several other under the hood changes & improvements.",
		"#F_Fixes:_#",
		"The AddOns menu context menu for Widget Tools will no longer take over the clickable screen space after being opened once.",
		"Numerous other smaller fixes.",
		"#O_Note:_# See Widget Toolbox  changelog on the Toolboxes & Addons page for further under the hood changes.",
		"#H_Thank you all for the help, suggestions & bug reports!_# If you encounter any issues, do not hesitate to report them! Try including when & how they occur, and which other addons are you using (when relevant) to give me the best chance of being able to reproduce & fix them. Try proving any Lua script error messages and taint logs (if you know how).",
	},
	{
		"#V_Version 2.2_# #H_(23/2/2026)_#",
		"#F_Hotfix:_#",
		"Text in editboxes will once again be properly sized to fit the width of the boxes.",
	},
	{
		"#V_Version 2.2_# #H_(13/2/2026)_#",
		"#F_Hotfix:_#",
		"Text in editboxes will once again be properly sized to fit the width of the boxes.",
	},
	{
		"#V_Version 2.1_# #H_(13/2/2026)_#",
		"#N_Updates:_#",
		"Added Midnight 12.0.1, Mists of Pandaria 5.5.3, The Burning Crusade 2.5.5 & Classic 1.15.8 support.",
		"Under the hood improvements.",
	},
	{
		"#V_Version 2.0_# #H_(8/6/2025)_#",
		"#N_New:_#",
		"Added Mists of Pandaria Classic 5.5.0, The War Within 11.2 support & Classic 1.15.7.",
		"Added AI-translated localizations for every language supported by WoW. #H_Note: Since these translations were generated by AI, they contain errors. If you'd like to help me fix some of them, or you'd like to volunteer to offer your aid to translate this addon to your language properly, do get in touch! Any help and error reports are greatly appreciated! <3_# (The Changelog will only be available in English for now.)",
		"#H_A new Lite mode has been introduced!_# When enabled, no settings pages managed by Widget Tools will be loaded for addons built with Widget Tools saving some resources in the process. Disable to access visible addon settings again. (Addon data is still loaded in the background causing no disruptions for addon functionality.)",
		"#H_Added visual aids for positioning!_# An option to enable positioning visual aids for addons built with Widget Tools has been introduced to help with understanding how the advanced positioning settings work to allow you to be in control of the finest detail.",
		"Added an option for developers to make the Frame Attributes window (TableAttributeDisplay Frame) wider.",
		"Added chat commands for Widget Tools, use: #H_/wt_# to access.",
		"#H_#C_Changes_# & #F_Fixes_#:_#",
		"The look of checkboxes & settings pages have been updated to match the new settings style.",
		"Significant under the hood improvements & fixes and other smaller changes & fixes.",
		"#V_Version 2.0.1_# • #F_Hotfix:_#",
		"Welcome messages will no longer be spammed each time the interface loads.",
		"Lite mode can now be enabled without errors.",
		"Adjusted the appearance of the Reload notice window.",
	},
	{
		"#V_Version 1.12_# #H_(8/9/2023)_#",
		"#C_Changes:_#",
		"Shortcuts have been removed from the main addon settings page in Classic.",
		"Under the hood improvements.",
	},
	{
		"#V_Version 1.11_# #H_(7/18/2023)_#",
		"#C_Changes:_#",
		"Added 1.14.4 (Classic) support with 1.14.3 backwards compatibility (until the Hardcore patch goes live).",
		"Scrolling has been improved in WotLK Classic.",
		"Backwards compatibility ensuring editboxes work with Toolbox version 1.5 has been removed.",
		"Other small improvements.",
	},
	{
		"#V_Version 1.10_# #H_(6/15/2023)_#",
		"#N_Updates:_#",
		"Added 10.1.5 (Dragonflight) support.",
		"#F_Fixes:_#",
		"No tooltip will stay on the screen after its target was hidden.",
		"Under the hood fixes & improvements.",
	},
	{
		"#V_Version 1.9_# #H_(5/17/2023)_#",
		"#C_Changes:_#",
		"Upgraded to the new Dragonflight addon logo handling. (Custom addon logos may not appear in the Interface Options in Classic clients.)",
		"#F_Fixes:_#",
		"Fixed an issue with actions being blocked after closing the Settings panel in certain situation (like changing Keybindings) in Dragonflight.",
		"The current version will now run in the WotLK Classic 3.4.2 PTR but it's not yet fully polished (as parts of the UI are still being modernized).",
		"Other small under the hood improvements & code cleanup.",
	},
	{
		"#V_Version 1.8_# #H_(4/5/2023)_#",
		"#N_Updates:_#",
		"Added 10.1 (Dragonflight) support.",
		"#F_Fixes:_#",
		"The old scrollbars have been replaced with the new scrollbars in Dragonflight, fixing any bugs that emerged with 10.1 as a result of deprecation.",
		"Several other under the hood fixes & improvements.",
	},
	{
		"#V_Version 1.7_# #H_(3/11/2023)_#",
		"#N_Updates:_#",
		"Added an option to disable addons using Widget Toolboxes from the Widget Tools settings.",
		"Added 10.0.7 (Dragonflight) support.",
		"#C_Changes:_#",
		"The Shortcuts section form the main settings page has been removed in Dragonflight (since the new expansion broke the feature - I may readd it if it gets resolved).",
		"Other smaller changes.",
		"#F_Fixes:_#",
		"Several under the hood fixes & improvements.",
	},
	{
		"#V_Version 1.6_# #H_(2/7/2023)_#",
		"#N_Updates:_#",
		"A new Sponsors section has been added to the main Settings page.\n#H_Thank you for your support! It helps me continue to spend time on developing and maintaining these addons. If you are considering supporting development as well, follow the links to see what ways are currently available._#",
		"The About info has been rearranged and combined with the Support links.",
		"Only the most recent update notes will be loaded now. The full Changelog is available in a bigger window when clicking on a new button.",
		"Made checkboxes more easily clickable, their tooltips are now visible even when the input is disabled.",
		"Added 10.0.5 (Dragonflight) & 3.4.1 (WotLK Classic) support.",
		"Numerous less notable changes & improvements.",
		"#F_Fixes:_#",
		"Widget Tools will no longer copies of its Settings after each loading screen.",
		"Settings should now be properly saved in Dragonflight, the custom Restore Defaults and Revert Changes functionalities should also work as expected now, on a per Settings page basis (with the option of restoring defaults for the whole addon kept).",
		"All other open custom Context Submenus on the same level should now close when one is opened (more Context Menu improvements are planned for a later release).",
		"Many other under the hood fixes.",
	},
	{
		"#V_Version 1.5_# #H_(11/28/2020)_#",
		"#H_Widget Tools has been supporting other addons in the background for over a year. Now, it has been separated into its own addon for more visibility, transparency and to offer wider development options._#",
		"#N_Update:_#",
		"Added Dragonflight (Retail 10.0) support with backwards compatibility.",
	}
}

ns.rs.chat = {
	keyword = "wt",
	commands = {
		about = "about",
		lite = "lite",
		debug = "debug",
	}
}

--[ Localizations ]

--List of localization constructors for [WoW locales](https://warcraft.wiki.gg/wiki/API_GetLocale#Values)
local localizations = {
	--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character
	--CHECK AI translations (from enUS)

	--English
	enUS = function()
		---@type widgetToolsStrings_enUS
		local _ = {
			about = {
				version = "Version: #VERSION",
				date = "Date: #DATE",
				author = "Author: #AUTHOR",
				license = "License: #LICENSE",
				toggle = {
					label = "Enabled",
					tooltip = "Uncheck to disable this addon.\n\nThis change will only take effect after the interface is reloaded. Once it has been disabled, this addon will not show up in this list until it's reenabled within the main AddOns menu.",
				},
			},
			specifications = {
				title = "Specifications",
				description = "Tune & toggle select optional features. Type /wt in chat to use chat commands.",
				general = {
					title = "General",
					description = "Options affecting all reliant addons.",
					lite = {
						label = "Lite Mode",
						tooltip = "Disable the settings of ALL addons using Widget Toolboxes to conserve resources and make the interface load faster.\nAddon settings data will still be saved & loaded in the background, and chat control will remain available for addons that use it.\n\nTo turn Lite Mode off and settings back on, use the #COMMAND chat command, or click on Widget Tools within the AddOns list under the calendar button in the header of the Minimap (not available in Classic)",
					},
					positioningAids = {
						label = "Positioning Visual Aids",
						tooltip = "Display visual aids when positioning frames wia settings widgets of addons which use Widget Toolboxes under the hood.",
					},
				},
				dev = {
					title = "Development Tools",
					debugging = {
						enabled = {
							label = "Debugging Mode",
							tooltip = "Toggle to create, save and print debugging log entries to the chat window.",
						},
					},
					frameAttributes = {
						enabled = {
							label = "Resize Frame Attributes",
							tooltip = "Customize the width of the table inside the Frame Attributes window (TableAttributeDisplay Frame).",
						},
						width = {
							label = "Frame Attributes Width",
							tooltip = "Specify the width of the scrollable content table in the Frame Attributes window.",
						},
					},
				},
			},
			toolboxes = {
				title = "Toolboxes & Addons",
				description = "The list of currently loaded addons using specific versions of registered #ADDON toolboxes.",
				toolbox = "Toolbox (#VERSION)",
			},
			compartment = {
				open = "Click to open specific settings.",
				lite = "Lite mode is enabled. Click to disable.",
			},
			lite = {
				enable = {
					warning = "When #ADDON is in Lite Mode, the settings UI for dependant addons will not be loaded.\n\nAre you sure you want to turn on Lite Mode and disable full settings functionality?",
					accept = "Enable Lite Mode",
				},
				disable = {
					warning = "#ADDON is in Lite Mode, the settings UI for dependant addons have not been loaded.\n\nDo you wish to turn off Lite Mode to reenable settings with full functionality?",
					accept = "Disable Lite Mode",
				},
			},
			chat = {
				about = {
					description = "Open the Widget Tools about page",
				},
				lite = {
					description = "Toggle Lite Mode: to load dependant addon settings or not",
					response = "Lite Mode will be #STATE after the interface is reloaded.",
					reminder = "Lite Mode is enabled, settings for dependant addons have not been loaded.\n#HINT",
					hint = "Type #COMMAND to disable Lite Mode.",
				},
				debug = {
					description = "Toggle Debugging Mode: save and display debug logs in chat",
					response = "Debugging will be #STATE after the interface is reloaded.",
					hint = "Type #COMMAND to disable Debugging Mode.",
				},
			},
			separator = ",", --Thousand separator character
			decimal = ".", --Decimal character
		}

		return _
	end,

	--Portuguese (Brazil)
	ptBR = function()
		---@type widgetToolsStrings_ptBR
		local _ = {
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

		return _
	end,

	--German
	deDE = function()
		---@type widgetToolsStrings_deDE
		local _ = {
			about = {
				version = "Version: #VERSION",
				date = "Datum: #DATE",
				author = "Autor: #AUTHOR",
				license = "Lizenz: #LICENSE",
				toggle = {
					label = "Aktiviert",
					tooltip = "Deaktivieren, um dieses Addon auszuschalten.\n\nDiese Änderung wird erst nach einem Neuladen der Benutzeroberfläche wirksam. Sobald es deaktiviert wurde, erscheint dieses Addon nicht mehr in dieser Liste, bis es im Haupt-AddOns-Menü wieder aktiviert wird.",
				},
			},
			specifications = {
				title = "Spezifikationen",
				description = "Wähle und passe optionale Funktionen an. Gib /wt im Chat ein, um Chatbefehle zu verwenden.",
				general = {
					title = "Allgemein",
					description = "Optionen, die alle abhängigen Addons betreffen.",
					lite = {
						label = "Lite-Modus",
						tooltip = "Deaktiviert die Einstellungen ALLER Addons, die Widget Toolboxes verwenden, um Ressourcen zu sparen und das Laden der Oberfläche zu beschleunigen.\nAddoneinstellungen werden weiterhin im Hintergrund gespeichert und geladen, und die Chatsteuerung bleibt für Addons verfügbar, die sie nutzen.\n\nUm den Lite-Modus zu deaktivieren und die Einstellungen wieder zu aktivieren, verwende den Chatbefehl #COMMAND oder klicke auf Widget Tools in der AddOns-Liste unter dem Kalender-Button im Minimap-Header (nicht verfügbar in Classic).",
					},
					positioningAids = {
						label = "Positionierungshilfen",
						tooltip = "Zeigt visuelle Hilfen beim Positionieren von Frames über Einstellungs-Widgets von Addons, die Widget Toolboxes verwenden.",
					},
				},
				dev = {
					title = "Entwicklertools",
					frameAttributes = {
						enabled = {
							label = "Frame-Attribute skalieren",
							tooltip = "Passe die Breite der Tabelle im Fenster Frame-Attribute (TableAttributeDisplay Frame) an.",
						},
						width = {
							label = "Breite der Frame-Attribute",
							tooltip = "Gib die Breite der scrollbaren Inhaltstabelle im Fenster Frame-Attribute an.",
						},
					},
				},
			},
			toolboxes = {
				title = "Toolboxes & Addons",
				description = "Liste der aktuell geladenen Addons, die bestimmte Versionen registrierter #ADDON-Toolboxes verwenden.",
				toolbox = "Toolbox (#VERSION)",
			},
			compartment = {
				open = "Klicken, um spezifische Einstellungen zu öffnen.",
				lite = "Lite-Modus ist aktiviert. Klicken zum Deaktivieren.",
			},
			lite = {
				enable = {
					warning = "Wenn #ADDON im Lite-Modus ist, wird die Einstellungsoberfläche für abhängige Addons nicht geladen.\n\nBist du sicher, dass du den Lite-Modus aktivieren und die vollständige Einstellungsfunktionalität deaktivieren möchtest?",
					accept = "Lite-Modus aktivieren",
				},
				disable = {
					warning = "#ADDON ist im Lite-Modus, die Einstellungsoberfläche für abhängige Addons wurde nicht geladen.\n\nMöchtest du den Lite-Modus deaktivieren, um die Einstellungen mit voller Funktionalität wieder zu aktivieren?",
					accept = "Lite-Modus deaktivieren",
				},
			},
			chat = {
				about = {
					description = "Öffnet die Widget Tools Info-Seite",
				},
				lite = {
					description = "Lite-Modus umschalten: Einstellungen abhängiger Addons laden oder nicht",
					response = "Der Lite-Modus wird nach dem Neuladen der Oberfläche #STATE sein.",
					reminder = "Lite-Modus ist aktiviert, Einstellungen für abhängige Addons wurden nicht geladen.\n#HINT",
					hint = "Gib #COMMAND ein, um den Lite-Modus zu deaktivieren.",
				},
			},
			separator = ".", -- Tausendertrennzeichen
			decimal = ",", -- Dezimalzeichen
		}

		return _
	end,

	--French
	frFR = function()
		---@type widgetToolsStrings_frFR
		local _ = {
			about = {
				version = "Version : #VERSION",
				date = "Date : #DATE",
				author = "Auteur : #AUTHOR",
				license = "Licence : #LICENSE",
				toggle = {
					label = "Activé",
					tooltip = "Décochez pour désactiver cet addon.\n\nCe changement ne prendra effet qu'après le rechargement de l'interface. Une fois désactivé, cet addon n'apparaîtra plus dans cette liste jusqu'à ce qu'il soit réactivé dans le menu principal des AddOns.",
				},
			},
			specifications = {
				title = "Spécifications",
				description = "Ajustez et activez/désactivez certaines fonctionnalités optionnelles. Tapez /wt dans le chat pour utiliser les commandes.",
				general = {
					title = "Général",
					description = "Options affectant tous les addons dépendants.",
					lite = {
						label = "Mode Léger",
						tooltip = "Désactive les paramètres de TOUS les addons utilisant Widget Toolboxes pour économiser des ressources et accélérer le chargement de l'interface.\nLes données de configuration des addons seront toujours sauvegardées et chargées en arrière-plan, et le contrôle par chat restera disponible pour les addons qui l'utilisent.\n\nPour désactiver le Mode Léger et réactiver les paramètres, utilisez la commande de chat #COMMAND ou cliquez sur Widget Tools dans la liste des AddOns sous le bouton calendrier dans l'en-tête de la Minicarte (non disponible en Classic).",
					},
					positioningAids = {
						label = "Aides Visuelles de Positionnement",
						tooltip = "Affiche des aides visuelles lors du positionnement des cadres via les widgets de configuration des addons utilisant Widget Toolboxes.",
					},
				},
				dev = {
					title = "Outils de Développement",
					frameAttributes = {
						enabled = {
							label = "Redimensionner les attributs du cadre",
							tooltip = "Personnalisez la largeur du tableau dans la fenêtre des Attributs du Cadre (TableAttributeDisplay Frame).",
						},
						width = {
							label = "Largeur des attributs du cadre",
							tooltip = "Spécifiez la largeur du tableau de contenu défilant dans la fenêtre des Attributs du Cadre.",
						},
					},
				},
			},
			toolboxes = {
				title = "Toolboxes & Addons",
				description = "Liste des addons actuellement chargés utilisant des versions spécifiques des toolboxes #ADDON enregistrées.",
				toolbox = "Toolbox (#VERSION)",
			},
			compartment = {
				open = "Cliquez pour ouvrir les paramètres spécifiques.",
				lite = "Le mode Léger est activé. Cliquez pour désactiver.",
			},
			lite = {
				enable = {
					warning = "Lorsque #ADDON est en Mode Léger, l'interface des paramètres pour les addons dépendants ne sera pas chargée.\n\nÊtes-vous sûr de vouloir activer le Mode Léger et désactiver la fonctionnalité complète des paramètres ?",
					accept = "Activer le Mode Léger",
				},
				disable = {
					warning = "#ADDON est en Mode Léger, l'interface des paramètres pour les addons dépendants n'a pas été chargée.\n\nVoulez-vous désactiver le Mode Léger pour réactiver les paramètres avec toutes les fonctionnalités ?",
					accept = "Désactiver le Mode Léger",
				},
			},
			chat = {
				about = {
					description = "Ouvre la page À propos de Widget Tools",
				},
				lite = {
					description = "Activer/désactiver le Mode Léger : charger ou non les paramètres des addons dépendants",
					response = "Le Mode Léger sera #STATE après le rechargement de l'interface.",
					reminder = "Le Mode Léger est activé, les paramètres des addons dépendants n'ont pas été chargés.\n#HINT",
					hint = "Tapez #COMMAND pour désactiver le Mode Léger.",
				},
			},
			separator = " ", -- Séparateur de milliers
			decimal = ",", -- Caractère décimal
		}

		return _
	end,

	--Spanish (Spain)
	esES = function()
		---@type widgetToolsStrings_esES
		local _ = {
			about = {
				version = "Versión: #VERSION",
				date = "Fecha: #DATE",
				author = "Autor: #AUTHOR",
				license = "Licencia: #LICENSE",
				toggle = {
					label = "Activado",
					tooltip = "Desmarca para desactivar este addon.\n\nEste cambio solo tendrá efecto después de recargar la interfaz. Una vez desactivado, este addon no aparecerá en esta lista hasta que se vuelva a activar en el menú principal de AddOns.",
				},
			},
			specifications = {
				title = "Especificaciones",
				description = "Ajusta y activa/desactiva funciones opcionales. Escribe /wt en el chat para usar comandos.",
				general = {
					title = "General",
					description = "Opciones que afectan a todos los addons dependientes.",
					lite = {
						label = "Modo Lite",
						tooltip = "Desactiva la configuración de TODOS los addons que usan Widget Toolboxes para ahorrar recursos y hacer que la interfaz cargue más rápido.\nLos datos de configuración de los addons seguirán guardándose y cargándose en segundo plano, y el control por chat seguirá disponible para los addons que lo usen.\n\nPara desactivar el Modo Lite y volver a activar la configuración, usa el comando de chat #COMMAND o haz clic en Widget Tools en la lista de AddOns bajo el botón del calendario en la cabecera del Minimapa (no disponible en Classic).",
					},
					positioningAids = {
						label = "Ayudas Visuales de Posicionamiento",
						tooltip = "Muestra ayudas visuales al posicionar marcos mediante los widgets de configuración de addons que usan Widget Toolboxes.",
					},
				},
				dev = {
					title = "Herramientas de Desarrollo",
					frameAttributes = {
						enabled = {
							label = "Redimensionar atributos del marco",
							tooltip = "Personaliza el ancho de la tabla dentro de la ventana de Atributos del Marco (TableAttributeDisplay Frame).",
						},
						width = {
							label = "Ancho de los atributos del marco",
							tooltip = "Especifica el ancho de la tabla de contenido desplazable en la ventana de Atributos del Marco.",
						},
					},
				},
			},
			toolboxes = {
				title = "Toolboxes y Addons",
				description = "Lista de los addons actualmente cargados que usan versiones específicas de las toolboxes #ADDON registradas.",
				toolbox = "Toolbox (#VERSION)",
			},
			compartment = {
				open = "Haz clic para abrir configuraciones específicas.",
				lite = "El modo Lite está activado. Haz clic para desactivar.",
			},
			lite = {
				enable = {
					warning = "Cuando #ADDON está en Modo Lite, la interfaz de configuración de los addons dependientes no se cargará.\n\n¿Seguro que quieres activar el Modo Lite y desactivar la funcionalidad completa de la configuración?",
					accept = "Activar Modo Lite",
				},
				disable = {
					warning = "#ADDON está en Modo Lite, la interfaz de configuración de los addons dependientes no se ha cargado.\n\n¿Deseas desactivar el Modo Lite para volver a activar la configuración con funcionalidad completa?",
					accept = "Desactivar Modo Lite",
				},
			},
			chat = {
				about = {
					description = "Abre la página de información de Widget Tools",
				},
				lite = {
					description = "Alternar Modo Lite: cargar o no la configuración de los addons dependientes",
					response = "El Modo Lite estará #STATE después de recargar la interfaz.",
					reminder = "El Modo Lite está activado, la configuración de los addons dependientes no se ha cargado.\n#HINT",
					hint = "Escribe #COMMAND para desactivar el Modo Lite.",
				},
			},
			separator = ".", -- Separador de miles
			decimal = ",", -- Carácter decimal
		}

		return _
	end,

	--Spanish (Mexico)
	esMX = function()
		---@type widgetToolsStrings_esMX
		local _ = {
			about = {
				version = "Versión: #VERSION",
				date = "Fecha: #DATE",
				author = "Autor: #AUTHOR",
				license = "Licencia: #LICENSE",
				toggle = {
					label = "Activado",
					tooltip = "Desmarca para desactivar este addon.\n\nEste cambio solo tendrá efecto después de recargar la interfaz. Una vez desactivado, este addon no aparecerá en esta lista hasta que se vuelva a activar en el menú principal de AddOns.",
				},
			},
			specifications = {
				title = "Especificaciones",
				description = "Ajusta y activa/desactiva funciones opcionales. Escribe /wt en el chat para usar comandos.",
				general = {
					title = "General",
					description = "Opciones que afectan a todos los addons dependientes.",
					lite = {
						label = "Modo Lite",
						tooltip = "Desactiva la configuración de TODOS los addons que usan Widget Toolboxes para ahorrar recursos y hacer que la interfaz cargue más rápido.\nLos datos de configuración de los addons seguirán guardándose y cargándose en segundo plano, y el control por chat seguirá disponible para los addons que lo usen.\n\nPara desactivar el Modo Lite y volver a activar la configuración, usa el comando de chat #COMMAND o haz clic en Widget Tools en la lista de AddOns bajo el botón del calendario en la cabecera del Minimapa (no disponible en Classic).",
					},
					positioningAids = {
						label = "Ayudas Visuales de Posicionamiento",
						tooltip = "Muestra ayudas visuales al posicionar marcos mediante los widgets de configuración de addons que usan Widget Toolboxes.",
					},
				},
				dev = {
					title = "Herramientas de Desarrollo",
					frameAttributes = {
						enabled = {
							label = "Redimensionar atributos del marco",
							tooltip = "Configura el ancho de la tabla dentro de la ventana de Atributos del Marco (TableAttributeDisplay Frame).",
						},
						width = {
							label = "Ancho de los atributos del marco",
							tooltip = "Especifica el ancho de la tabla de contenido desplazable en la ventana de Atributos del Marco.",
						},
					},
				},
			},
			toolboxes = {
				title = "Toolboxes y Addons",
				description = "Lista de los addons actualmente cargados que usan versiones específicas de las toolboxes #ADDON registradas.",
				toolbox = "Toolbox (#VERSION)",
			},
			compartment = {
				open = "Haz clic para abrir configuraciones específicas.",
				lite = "El modo Lite está activado. Haz clic para desactivar.",
			},
			lite = {
				enable = {
					warning = "Cuando #ADDON está en Modo Lite, la interfaz de configuración de los addons dependientes no se cargará.\n\n¿Seguro que quieres activar el Modo Lite y desactivar la funcionalidad completa de la configuración?",
					accept = "Activar Modo Lite",
				},
				disable = {
					warning = "#ADDON está en Modo Lite, la interfaz de configuración de los addons dependientes no se ha cargado.\n\n¿Deseas desactivar el Modo Lite para volver a activar la configuración con funcionalidad completa?",
					accept = "Desactivar Modo Lite",
				},
			},
			chat = {
				about = {
					description = "Abre la página de información de Widget Tools",
				},
				lite = {
					description = "Alternar Modo Lite: cargar o no la configuración de los addons dependientes",
					response = "El Modo Lite estará #STATE después de recargar la interfaz.",
					reminder = "El Modo Lite está activado, la configuración de los addons dependientes no se ha cargado.\n#HINT",
					hint = "Escribe #COMMAND para desactivar el Modo Lite.",
				},
			},
			separator = ".", -- Separador de miles
			decimal = ",", -- Carácter decimal
		}

		return _
	end,

	--Italian
	itIT = function()
		---@type widgetToolsStrings_itIT
		local _ = {
			about = {
				version = "Versione: #VERSION",
				date = "Data: #DATE",
				author = "Autore: #AUTHOR",
				license = "Licenza: #LICENSE",
				toggle = {
					label = "Abilitato",
					tooltip = "Deseleziona per disabilitare questo addon.\n\nQuesta modifica avrà effetto solo dopo il ricaricamento dell'interfaccia. Una volta disabilitato, questo addon non apparirà in questo elenco finché non verrà riabilitato dal menu principale AddOns.",
				},
			},
			specifications = {
				title = "Specifiche",
				description = "Regola e attiva/disattiva funzionalità opzionali. Digita /wt in chat per usare i comandi.",
				general = {
					title = "Generale",
					description = "Opzioni che influenzano tutti gli addon dipendenti.",
					lite = {
						label = "Modalità Lite",
						tooltip = "Disabilita le impostazioni di TUTTI gli addon che usano Widget Toolboxes per risparmiare risorse e velocizzare il caricamento dell'interfaccia.\nI dati delle impostazioni degli addon saranno comunque salvati e caricati in background, e il controllo tramite chat rimarrà disponibile per gli addon che lo utilizzano.\n\nPer disattivare la Modalità Lite e riattivare le impostazioni, usa il comando chat #COMMAND o clicca su Widget Tools nell'elenco AddOns sotto il pulsante calendario nell'intestazione della Minimap (non disponibile in Classic).",
					},
					positioningAids = {
						label = "Aiuti Visivi di Posizionamento",
						tooltip = "Mostra aiuti visivi quando si posizionano i frame tramite i widget delle impostazioni degli addon che usano Widget Toolboxes.",
					},
				},
				dev = {
					title = "Strumenti di Sviluppo",
					frameAttributes = {
						enabled = {
							label = "Ridimensiona Attributi del Frame",
							tooltip = "Personalizza la larghezza della tabella nella finestra Attributi del Frame (Frame TableAttributeDisplay).",
						},
						width = {
							label = "Larghezza Attributi del Frame",
							tooltip = "Specifica la larghezza della tabella di contenuto scorrevole nella finestra Attributi del Frame.",
						},
					},
				},
			},
			toolboxes = {
				title = "Toolboxes & Addon",
				description = "Elenco degli addon attualmente caricati che usano versioni specifiche delle toolboxes #ADDON registrate.",
				toolbox = "Toolbox (#VERSION)",
			},
			compartment = {
				open = "Clicca per aprire impostazioni specifiche.",
				lite = "Modalità Lite abilitata. Clicca per disabilitare.",
			},
			lite = {
				enable = {
					warning = "Quando #ADDON è in Modalità Lite, l'interfaccia delle impostazioni per gli addon dipendenti non verrà caricata.\n\nSei sicuro di voler attivare la Modalità Lite e disabilitare la piena funzionalità delle impostazioni?",
					accept = "Abilita Modalità Lite",
				},
				disable = {
					warning = "#ADDON è in Modalità Lite, l'interfaccia delle impostazioni per gli addon dipendenti non è stata caricata.\n\nVuoi disattivare la Modalità Lite per riabilitare le impostazioni con piena funzionalità?",
					accept = "Disabilita Modalità Lite",
				},
			},
			chat = {
				about = {
					description = "Apri la pagina informazioni di Widget Tools",
				},
				lite = {
					description = "Attiva/disattiva Modalità Lite: caricare o meno le impostazioni degli addon dipendenti",
					response = "La Modalità Lite sarà #STATE dopo il ricaricamento dell'interfaccia.",
					reminder = "La Modalità Lite è abilitata, le impostazioni per gli addon dipendenti non sono state caricate.\n#HINT",
					hint = "Digita #COMMAND per disabilitare la Modalità Lite.",
				},
			},
			separator = ".", -- Separatore delle migliaia
			decimal = ",", -- Carattere decimale
		}

		return _
	end,

	--Korean
	koKR = function()
		---@type widgetToolsStrings_koKR
		local _ = {
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

		return _
	end,

	--Chinese (traditional, Taiwan)
	zhTW = function()
		---@type widgetToolsStrings_zhTW
		local _ = {
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

		return _
	end,

	--Chinese (simplified, PRC)
	zhCN = function()
		---@type widgetToolsStrings_zhCN
		local _ = {
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

		return _
	end,

	--Russian
	ruRU = function()
		---@type widgetToolsStrings_ruRU
		local ruRU = {
			about = {
				version = "Версия: #VERSION",
				date = "Дата: #DATE",
				author = "Автор: #AUTHOR",
				license = "Лицензия: #LICENSE",
				toggle = {
					label = "Включено",
					tooltip = "Снимите галочку, чтобы отключить этот аддон.\n\nИзменения вступят в силу только после перезагрузки интерфейса. После отключения этот аддон не будет отображаться в этом списке, пока вы не включите его снова в главном меню AddOns.",
				},
			},
			specifications = {
				title = "Спецификации",
				description = "Настройте и включайте/отключайте дополнительные функции. Введите /wt в чате для использования команд.",
				general = {
					title = "Общие",
					description = "Опции, влияющие на все зависимые аддоны.",
					lite = {
						label = "Лёгкий режим",
						tooltip = "Отключает настройки ВСЕХ аддонов, использующих Widget Toolboxes, чтобы сэкономить ресурсы и ускорить загрузку интерфейса.\nДанные настроек аддонов всё равно будут сохраняться и загружаться в фоновом режиме, а управление через чат останется доступным для аддонов, которые его используют.\n\nЧтобы отключить Лёгкий режим и вернуть настройки, используйте команду чата #COMMAND или кликните по Widget Tools в списке AddOns под кнопкой календаря в заголовке миникарты (недоступно в Classic).",
					},
					positioningAids = {
						label = "Визуальные помощники позиционирования",
						tooltip = "Показывать визуальные подсказки при позиционировании фреймов через виджеты настроек аддонов, использующих Widget Toolboxes.",
					},
				},
				dev = {
					title = "Инструменты разработчика",
					frameAttributes = {
						enabled = {
							label = "Изменить размер атрибутов фрейма",
							tooltip = "Настройте ширину таблицы внутри окна атрибутов фрейма (TableAttributeDisplay Frame).",
						},
						width = {
							label = "Ширина атрибутов фрейма",
							tooltip = "Укажите ширину прокручиваемой таблицы содержимого в окне атрибутов фрейма.",
						},
					},
				},
			},
			toolboxes = {
				title = "Toolboxes и Аддоны",
				description = "Список загруженных аддонов, использующих определённые версии зарегистрированных #ADDON toolboxes.",
				toolbox = "Toolbox (#VERSION)",
			},
			compartment = {
				open = "Нажмите, чтобы открыть определённые настройки.",
				lite = "Лёгкий режим включён. Нажмите, чтобы отключить.",
			},
			lite = {
				enable = {
					warning = "Когда #ADDON в Лёгком режиме, интерфейс настроек для зависимых аддонов не будет загружен.\n\nВы уверены, что хотите включить Лёгкий режим и отключить полную функциональность настроек?",
					accept = "Включить Лёгкий режим",
				},
				disable = {
					warning = "#ADDON в Лёгком режиме, интерфейс настроек для зависимых аддонов не был загружен.\n\nХотите отключить Лёгкий режим и вернуть полную функциональность настроек?",
					accept = "Отключить Лёгкий режим",
				},
			},
			chat = {
				about = {
					description = "Открыть страницу о Widget Tools",
				},
				lite = {
					description = "Переключить Лёгкий режим: загружать ли настройки зависимых аддонов",
					response = "Лёгкий режим будет #STATE после перезагрузки интерфейса.",
					reminder = "Лёгкий режим включён, настройки зависимых аддонов не были загружены.\n#HINT",
					hint = "Введите #COMMAND, чтобы отключить Лёгкий режим.",
				},
			},
			separator = " ", -- Разделитель тысяч
			decimal = ",", -- Десятичный разделитель
		}

		return ruRU
	end
}

--| Load localized strings

ns.rs.strings = localizations[GetLocale()]()
localizations = nil


--[[ CLASSIC SUPPORT ]]

if not C_ColorUtil then C_ColorUtil = {
	WrapTextInColorCode = WrapTextInColorCode,
	WrapTextInColor = function(text, color)
		if type(color) ~= "table" then return text end

		if type(color["GenerateHexColor"]) ~= "function" then color = CreateColor(color.r, color.g, color.b, color.a) end

		return WrapTextInColor(text, color)
	end,
} end