--| Locale

if GetLocale() ~= "frFR" then return end

--| Namespace

---@class addonNamespace
local ns = select(2, ...)

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---French
---@class widgetToolsStrings_frFR
ns.rs.strings = {
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