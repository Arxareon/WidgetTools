--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--[ Changelog ]

wt.changelog = {
    {
        "#V_Version 3.0_# #H_(23/4/2026)_#",
        "#F_Hotfix (Version 3.0.1):_#",
        "Des sécurités ont été ajoutées à plusieurs endroits pour empêcher que des chemins de fichiers de ressources manquants ou invalides (polices ou textures) provoquent des erreurs critiques.",
        "#N_Nouveau:_#",
        "Ajout de la compatibilité avec Midnight 12.0.5.",
        "Les menus contextuels (clic droit) ajoutés précédemment pour les paramètres ont été améliorés avec des fonctions de copier/coller permettant de transférer facilement des valeurs entre types de paramètres similaires.",
        "Ajout d’un nouveau modèle avancé de paramètres pour la gestion des options de Polices (davantage d’options de personnalisation arriveront dans de futures mises à jour).",
        "#C_Modifications:_#",
        "L’apparence des curseurs numériques de paramètres a été mise à jour pour correspondre aux nouveaux curseurs Blizzard, tout en conservant toutes les fonctionnalités améliorées habituelles pour les addons construits avec Widget Tools Toolboxes.",
        "La structure de chargement de la Toolbox a été remaniée ; les anciennes versions ne sont plus prises en charge.",
        "De nombreuses fonctions utilitaires de base ont été transférées vers Widget Tools (et ne sont plus spécifiques à la Toolbox), accessibles globalement via la collection WidgetTools.utilities.",
        "Les données spécifiques à la Toolbox ne seront plus injectées dans les tables de frames, mais stockées dans des tables dédiées à la Toolbox (y compris les données d’agencement de tooltips ou de conteneurs).",
        "Le système backend de gestion des événements pour les gestionnaires OnEvent globaux de Blizzard (et les événements personnalisés) a été mis à jour, avec de nouveaux utilitaires accessibles globalement via WidgetTools.utilities.",
        "Les Frames, Boutons et autres widgets personnalisables doivent désormais être créés via de nouveaux constructeurs ; les indicateurs de personnalisation ont été retirés de leurs versions de base.",
        "La plupart des annotations destinées uniquement au développement ont été déplacées hors des fichiers installés de l’addon afin de réduire considérablement la taille d’installation.",
        "La logique de construction de la page de gestion des données (désormais appelée page de profils) a été séparée en un widget profilemanager et une mutation d’interface par-dessus, permettant davantage de flexibilité et de personnalisation.",
        "Plusieurs autres améliorations et changements internes.",
        "#F_Correctifs:_#",
        "De nombreux autres correctifs mineurs.",
        "#H_Merci à tous pour votre aide, vos suggestions et vos rapports de bugs !_# Si vous rencontrez un problème, n’hésitez pas à le signaler ! Essayez d’indiquer quand et comment il se produit, ainsi que les autres addons utilisés (si pertinent), afin de me donner les meilleures chances de le reproduire et de le corriger. Fournissez si possible les messages d’erreur Lua et les journaux de taint (si vous savez comment les obtenir).",
    }
}

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---French
---@class toolboxStrings_frFR
wt.strings = {
	chat = {
		welcome = {
			thanks = "Merci d'utiliser #ADDON !",
			hint = "Tapez #KEYWORD pour voir la liste des commandes du chat.",
			keywords = "#KEYWORD ou #KEYWORD_ALTERNATE",
		},
		help = {
			list = "Liste des commandes du chat de #ADDON :",
		},
	},
	popupInput = {
		title = "Spécifiez le texte",
		tooltip = "Appuyez sur " .. KEY_ENTER .. " pour valider le texte ou sur " .. KEY_ESCAPE .. " pour annuler."
	},
	reload = {
		title = "Modifications en attente",
		description = "Rechargez l'interface pour appliquer les modifications en attente.",
		accept = {
			label = "Recharger maintenant",
			tooltip = "Vous pouvez choisir de recharger l'interface maintenant pour appliquer les modifications en attente.",
		},
		cancel = {
			label = "Plus tard",
			tooltip = "Rechargez l'interface plus tard avec la commande /reload ou en vous déconnectant.",
		},
	},
	multiSelector = {
		locked = "Verrouillé",
		minLimit = "Au moins #MIN options doivent être sélectionnées.",
		maxLimit = "Seulement #MAX options peuvent être sélectionnées à la fois.",
	},
	dropdown = {
		selected = "Ceci est l'option actuellement sélectionnée.",
		none = "Aucune option n'a été sélectionnée.",
		open = "Cliquez pour voir la liste des options.",
		previous = {
			label = "Option précédente",
			tooltip = "Sélectionner l'option précédente.",
		},
		next = {
			label = "Option suivante",
			tooltip = "Sélectionner l'option suivante.",
		},
		clear = "Effacer la sélection",
	},
	copyBox = "Copiez le texte en appuyant sur :\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Spécifiez la valeur",
			tooltip = "Entrez une valeur dans la plage autorisée.",
		},
		decrease = {
			label = "Diminuer",
			tooltip = {
				"Soustraire #VALUE de la valeur.",
				"Maintenez ALT pour soustraire #VALUE à la place.",
			},
		},
		increase = {
			label = "Augmenter",
			tooltip = {
				"Ajouter #VALUE à la valeur.",
				"Maintenez ALT pour ajouter #VALUE à la place.",
			},
		},
	},
	color = {
		picker = {
			label = "Choisir une couleur",
			tooltip = "Ouvrez le sélecteur de couleur pour personnaliser la couleur#ALPHA.",
			alpha = " et modifier l'opacité",
		},
		hex = {
			label = "Ajouter via code couleur HEX",
			tooltip = "Vous pouvez changer la couleur via un code HEX au lieu d'utiliser le sélecteur de couleur.",
		}
	},
	settings = {
		save = "Les modifications seront appliquées à la fermeture.",
		cancel = {
			label = "Annuler les modifications",
			tooltip = "Annuler toutes les modifications apportées à cette page et charger les valeurs enregistrées.",
		},
		defaults = {
			label = "Restaurer les valeurs par défaut",
			tooltip = "Restaurer tous les paramètres de cette page (ou de la catégorie entière) aux valeurs par défaut.",
		},
		warning = "Êtes-vous sûr de vouloir réinitialiser les paramètres de la page #PAGE ou tous les paramètres de la catégorie #CATEGORY aux valeurs par défaut ?",
		warningSingle = "Êtes-vous sûr de vouloir réinitialiser les paramètres de la page #PAGE aux valeurs par défaut ?",
	},
	value = {
		copy = "Copier la valeur",
		paste = "Coller la valeur",
		revert = "Annuler les modifications",
		restore = "Restaurer la valeur par défaut",
		note = "Clique droit pour copier ou annuler.",
	},
	points = {
		left = "Gauche",
		right = "Droite",
		center = "Centre",
		top = {
			left = "Haut gauche",
			right = "Haut droite",
			center = "Haut centre",
		},
		bottom = {
			left = "Bas gauche",
			right = "Bas droite",
			center = "Bas centre",
		},
	},
	strata = {
		lowest = "Arrière-plan bas",
		lower = "Arrière-plan moyen",
		low = "Arrière-plan haut",
		lowMid = "Bas milieu",
		highMid = "Haut milieu",
		high = "Premier plan bas",
		higher = "Premier plan moyen",
		highest = "Premier plan haut",
	},
	about = {
		title = "À propos",
		description = "Merci d'utiliser #ADDON ! Copiez les liens pour savoir comment donner votre avis, obtenir de l'aide et soutenir le développement.",
		version = "Version",
		date = "Date",
		author = "Auteur",
		license = "Licence",
		curseForge = "Page CurseForge",
		wago = "Page Wago",
		repository = "Dépôt GitHub",
		issues = "Problèmes & Retours",
		changelog = {
			label = "Notes de mise à jour",
			tooltip = "Notes de tous les changements, mises à jour et corrections introduits dans la dernière version : #VERSION.",
		},
		fullChangelog = {
			label = "Historique de #ADDON",
			tooltip = "La liste complète des notes de mise à jour de toutes les versions de l'addon.",
			open = {
				label = "Historique",
				tooltip = "Lire la liste complète des notes de mise à jour de toutes les versions de l'addon.",
			},
		},
	},
	sponsors = {
		title = "Sponsors",
		description = "Votre soutien continu est très apprécié ! Merci !",
	},
	dataManagement = {
		title = "Gestion des données",
		description = "Configurez davantage #ADDON en gérant les profils et sauvegardes via les options d'import/export.",
	},
	profiles = {
		title = "Profils",
		description = "Créez, modifiez et appliquez des profils d'options uniques pour chacun de vos personnages.",
		select = {
			label = "Sélectionner un profil",
			tooltip = "Choisissez le profil de stockage des options à utiliser pour votre personnage actuel.\n\nLes données du profil actif seront automatiquement écrasées lorsque les paramètres seront modifiés et enregistrés !",
			profile = "Profil",
			main = "Principal",
		},
		new = {
			label = "Nouveau profil",
			tooltip = "Créer un nouveau profil par défaut.",
		},
		duplicate = {
			label = "Dupliquer",
			tooltip = "Créer un nouveau profil en copiant les données du profil actif.",
		},
		rename = {
			label = "Renommer",
			tooltip = "Renommer le profil actif.",
			description = "Renommer #PROFILE en :",
		},
		delete = {
			tooltip = "Supprimer le profil actif.",
			warning = "Êtes-vous sûr de vouloir supprimer le profil de paramètres #PROFILE #ADDON actif et de supprimer définitivement toutes les données qui y sont stockées ?"
		},
		reset = {
			warning = "Êtes-vous sûr de vouloir écraser le profil de paramètres #PROFILE #ADDON actif avec les valeurs par défaut ?",
		},
	},
	backup = {
		title = "Sauvegarde",
		description = "Importez ou exportez les données du profil actif pour sauvegarder, partager ou transférer les paramètres, ou modifier des valeurs manuellement.",
		box = {
			label = "Importer ou exporter le profil actuel",
			tooltip = {
				"La chaîne de sauvegarde dans cette boîte contient les données du profil actif de l'addon.",
				"Copiez le texte pour sauvegarder, partager ou charger des données pour un autre compte.",
				"Pour charger des données à partir d'une chaîne, remplacez le texte dans cette boîte, puis appuyez sur " .. KEY_ENTER .. " ou cliquez sur le bouton #LOAD.",
				"Remarque : Si vous utilisez des fichiers de police ou de texture personnalisés, ces fichiers ne seront pas transférés avec cette chaîne. Ils devront être enregistrés séparément et placés dans le dossier de l'addon pour être utilisables.",
				"Ne chargez que des chaînes que vous avez vérifiées vous-même ou dont vous faites confiance à la source !",
			},
		},
		allProfiles = {
			label = "Importer ou exporter tous les profils",
			tooltipLine = "La chaîne de sauvegarde dans cette boîte contient la liste de tous les profils de l'addon et les données stockées dans chacun, ainsi que le nom du profil actif.",
			open = {
				label = "Tous les profils",
				tooltip = "Accédez à la liste complète des profils et sauvegardez ou modifiez les données stockées dans chacun.",
			},
		},
		compact = {
			label = "Compact",
			tooltip = "Basculer entre une vue compacte et une vue plus lisible/modifiable.",
		},
		load = {
			label = "Charger",
			tooltip = "Vérifiez la chaîne actuelle et essayez de charger les données à partir de celle-ci.",
		},
		reset = {
			tooltip = "Annuler toutes les modifications apportées à la chaîne et la réinitialiser pour contenir les données actuellement enregistrées.",
		},
		import = "Charger la chaîne",
		warning = "Êtes-vous sûr de vouloir tenter de charger la chaîne actuellement insérée ?\n\nToutes les modifications non enregistrées seront annulées.\n\nSi vous l'avez copiée d'une source en ligne ou si quelqu'un vous l'a envoyée, ne la chargez qu'après avoir vérifié le code et être sûr de ce que vous faites.\n\nSi vous ne faites pas confiance à la source, annulez pour éviter toute action indésirable.",
		error = "La chaîne de sauvegarde fournie n'a pas pu être validée et aucune donnée n'a été chargée. Il se peut qu'il manque des caractères ou que des erreurs aient été introduites lors de l'édition.",
	},
	position = {
		title = "Position",
		description = {
			static = "Ajustez précisément la position de #FRAME à l'écran via les options fournies ici.",
			movable = "Faites glisser #FRAME en maintenant SHIFT pour le positionner n'importe où à l'écran, puis ajustez-le ici.",
		},
		relativePoint = {
			label = "Point d'ancrage à l'écran",
			tooltip = "Attachez le point d'ancrage choisi de #FRAME au point de liaison sélectionné ici.",
		},
		-- relativeTo = {
		-- 	label = "Lier à une frame",
		-- 	tooltip = "Tapez le nom d'un autre élément d'interface pour lier la position de #FRAME.\n\nTrouvez les noms des frames en activant l'interface de debug via la commande /framestack.",
		-- },
		anchor = {
			label = "Point d'ancrage",
			tooltip = "Sélectionnez à partir de quel point #FRAME doit être ancré lors de la liaison au point d'écran choisi.",
		},
		keepInPlace = {
			label = "Garder en place",
			tooltip = "Ne déplacez pas #FRAME lors du changement de #ANCHOR, mettez à jour les valeurs de décalage à la place.",
		},
		offsetX= {
			label = "Décalage horizontal",
			tooltip = "Définissez la quantité de décalage horizontal (axe X) de #FRAME à partir de l'#ANCHOR sélectionné.",
		},
		offsetY = {
			label = "Décalage vertical",
			tooltip = "Définissez la quantité de décalage vertical (axe Y) de #FRAME à partir de l'#ANCHOR sélectionné.",
		},
		keepInBounds = {
			label = "Garder dans les limites de l'écran",
			tooltip = "Assurez-vous que #FRAME ne puisse pas être déplacé hors de l'écran.",
		},
	},
	presets = {
		apply = {
			label = "Appliquer un préréglage",
			tooltip = "Changez la position de #FRAME en choisissant et en appliquant un de ces préréglages.",
			list = { "Sous la Minicarte", },
			select = "Sélectionnez un préréglage…",
		},
		save = {
			label = "Mettre à jour le préréglage #CUSTOM",
			tooltip = "Enregistrez la position et la visibilité actuelles de #FRAME dans le préréglage #CUSTOM.",
			warning = "Êtes-vous sûr de vouloir écraser le préréglage #CUSTOM avec les valeurs actuelles ?",
		},
		reset = {
			label = "Réinitialiser le préréglage #CUSTOM",
			tooltip = "Écrasez les données du préréglage #CUSTOM avec les valeurs par défaut, puis appliquez-le.",
			warning = "Êtes-vous sûr de vouloir écraser le préréglage #CUSTOM avec les valeurs par défaut ?",
		},
	},
	layer = {
		strata = {
			label = "Calque d'écran",
			tooltip = "Montez ou descendez #FRAME pour qu'il soit devant ou derrière d'autres éléments de l'interface.",
		},
		keepOnTop = {
			label = "Révéler lors d'une interaction souris",
			tooltip = "Permettre à #FRAME d'être déplacé au-dessus d'autres frames dans la même #STRATA lors d'une interaction.",
		},
		level = {
			label = "Niveau de frame",
			tooltip = "La position exacte de #FRAME au-dessus ou en dessous d'autres frames dans la même pile #STRATA.",
		},
	},
	font = {
		title = "Texte",
		path = {
			label = "Police",
			tooltip = "Sélectionnez la police.",
			default = {
				label = "Police par défaut localisée",
				tooltip = "Ceci est une police par défaut localisée utilisée par Blizzard.",
			},
			base = "Ceci est une police du jeu de base.",
			custom = "Ceci est une police personnalisée.",
			otf = "Licence de police OpenType.",
			file = "Chemin du fichier : #PATH",
			replace = "L’option Personnalisée offre une personnalisation complète en vous permettant d’utiliser n’importe quelle police en remplaçant le fichier de police #FILE_CUSTOM par n’importe quel autre fichier TrueType trouvé dans\n#FONTS_DIRECTORY\ntout en conservant son nom de fichier #FILE_CUSTOM.",
			reminder = "Vous devrez peut-être redémarrer complètement le client du jeu après avoir remplacé le fichier de police pour appliquer le changement.",
		},
		size = {
			label = "Taille",
			tooltip = "Définissez la taille de la police.",
		},
		alignment = {
			label = "Alignement",
			tooltip = "Sélectionnez l’alignement horizontal du texte.",
		},
		color = {
			label = "Couleur #COLOR_TYPE",
			tooltip = "Définissez la couleur du texte #COLOR_TYPE.",
		},
	},
	date = "#DAY/#MONTH/#YEAR",
	override = "Écraser",
	example = "Exemple",
}