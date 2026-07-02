--| Namespace

---@class namespace
local ns = select(2, ...)

--[ Changelog ]

ns.changelog = {
    {
        "#V_Version 3.0_# #H_(23/4/2026)_#",
        "#F_Hotfix (Version 3.0.1):_#",
        "#H_Le support des fichiers de polices personnalisées a été rétabli à la solution précédente (désormais gérée par Widget Tools) jusqu’à la prochaine mise à jour, car un oubli provoquait des erreurs critiques._# J’ai également retiré plusieurs polices afin de réduire la taille d’installation. Une fois le système prévu pour les polices entièrement personnalisées terminé et publié, n’importe quel nombre de polices personnalisées pourra être utilisé, rendant inutile l’inclusion d’autant de polices. #H_Pour ajouter un fichier de police personnalisé avec cette solution temporaire, comme auparavant, remplacez_# #O_Interface/Addons/WidgetTools/Fonts/CUSTOM.ttf_# #H_par n’importe quel fichier TrueTypeFont, en conservant exactement ce nom de fichier._#",
        "Plusieurs polices ont été retirées et ne seront plus incluses, car je préfère privilégier une taille d’addon plus réduite, et de gros fichiers de polices apportant peu de bénéfice pour la majorité vont à l’encontre de cet objectif.",
        "Ajout des informations Wago ID pour aider Wago à détecter et télécharger automatiquement les dépendances de l’addon.",
        "#N_Nouveau:_#",
        "Ajout de la compatibilité avec Midnight 12.0.5.",
        "Une liste partagée de polices personnalisées a été ajoutée, accessible désormais par tous les addons via la collection globale #H_WidgetTools.resources_#. #H_Un fichier de police personnalisé nommé_# #O_CUSTOM.ttf_# #H_peut maintenant être placé dans le dossier principal_# #O_Fonts_# #H_à la racine du dossier du client WoW_# pour être reconnu par Widget Tools. La gestion des polices personnalisées sera étendue dans de futures mises à jour.",
        "Introduction de nouveaux outils de journalisation de débogage accessibles via la collection globale #H_WidgetTools.debugging_#. Les fonctionnalités de débogage seront étendues et intégrées aux Toolboxes dans de futures mises à jour.",
        "#C_Modifications:_#",
        "La structure de chargement de la Toolbox a été remaniée ; les anciennes versions ne sont plus prises en charge.",
        "De nombreuses fonctions utilitaires de base ont été transférées vers Widget Tools (et ne sont plus spécifiques à la Toolbox), accessibles globalement via la collection #H_WidgetTools.utilities_#.",
        "Le système backend de gestion des événements pour les gestionnaires OnEvent globaux de Blizzard (et les événements personnalisés) a été mis à jour, avec de nouveaux utilitaires accessibles globalement via la collection #H_WidgetTools.utilities_#.",
        "La plupart des annotations destinées uniquement au développement ont été déplacées hors des fichiers installés de l’addon afin de réduire considérablement la taille d’installation.",
        "Plusieurs autres améliorations et changements internes.",
        "#F_Correctifs:_#",
        "Le menu contextuel de Widget Tools dans le menu AddOns ne bloquera plus la zone cliquable de l’écran après avoir été ouvert une première fois.",
        "De nombreux autres correctifs mineurs.",
        "#O_Remarque:_# Consultez le changelog de Widget Toolbox sur la page Toolboxes & Addons pour davantage de changements internes.",
        "#H_Merci à tous pour votre aide, vos suggestions et vos rapports de bugs !_# Si vous rencontrez un problème, n’hésitez pas à le signaler ! Essayez d’indiquer quand et comment il se produit, ainsi que les autres addons utilisés (si pertinent), afin de me donner les meilleures chances de le reproduire et de le corriger. Fournissez si possible les messages d’erreur Lua et les journaux de taint.",
    },
    {
        "#V_Version 2.2_# #H_(23/2/2026)_#",
        "#F_Hotfix:_#",
        "Le texte dans les champs de saisie sera de nouveau correctement ajusté à la largeur des boîtes.",
    },
    {
        "#V_Version 2.2_# #H_(13/2/2026)_#",
        "#F_Hotfix:_#",
        "Le texte dans les champs de saisie sera de nouveau correctement ajusté à la largeur des boîtes.",
    },
    {
        "#V_Version 2.1_# #H_(13/2/2026)_#",
        "#N_Mises à jour:_#",
        "Ajout de la compatibilité avec Midnight 12.0.1, Mists of Pandaria 5.5.3, The Burning Crusade 2.5.5 et Classic 1.15.8.",
        "Améliorations internes.",
    },
    {
        "#V_Version 2.0_# #H_(8/6/2025)_#",
        "#N_Nouveau:_#",
        "Ajout de la compatibilité avec Mists of Pandaria Classic 5.5.0, The War Within 11.2 et Classic 1.15.7.",
        "Ajout de localisations traduites par IA pour toutes les langues prises en charge par WoW. #H_Remarque : Comme ces traductions ont été générées par IA, elles contiennent des erreurs. Si vous souhaitez m’aider à en corriger certaines, ou si vous souhaitez contribuer à une traduction correcte dans votre langue, contactez-moi ! Toute aide et tout rapport d’erreur est grandement apprécié ! <3_# (Le changelog ne sera disponible qu’en anglais pour le moment.)",
        "#H_Un nouveau mode Lite a été introduit !_# Lorsqu’il est activé, aucune page de paramètres gérée par Widget Tools ne sera chargée pour les addons construits avec Widget Tools, économisant ainsi des ressources. Désactivez-le pour retrouver les paramètres visibles de l’addon. (Les données de l’addon continuent d’être chargées en arrière-plan sans perturber son fonctionnement.)",
        "#H_Ajout d’aides visuelles pour le positionnement !_# Une option permettant d’activer des aides visuelles de positionnement pour les addons construits avec Widget Tools a été ajoutée, afin de mieux comprendre le fonctionnement des paramètres avancés de positionnement et de vous donner un contrôle précis.",
        "Ajout d’une option permettant aux développeurs d’élargir la fenêtre Frame Attributes (TableAttributeDisplay Frame).",
        "Ajout de commandes de chat pour Widget Tools, utilisez : #H_/wt_#",
        "#H_#C_Modifications_# & #F_Correctifs_#:_#",
        "L’apparence des cases à cocher et des pages de paramètres a été mise à jour pour correspondre au nouveau style de paramètres.",
        "Améliorations internes importantes, correctifs et autres changements mineurs.",
        "#V_Version 2.0.1_# • #F_Hotfix:_#",
        "Les messages de bienvenue ne seront plus spammés à chaque rechargement de l’interface.",
        "Le mode Lite peut désormais être activé sans erreurs.",
        "L’apparence de la fenêtre d’avertissement de rechargement a été ajustée.",
    },
    {
        "#V_Version 1.12_# #H_(8/9/2023)_#",
        "#C_Modifications:_#",
        "Les raccourcis ont été retirés de la page principale des paramètres de l’addon en Classic.",
        "Améliorations internes.",
    },
    {
        "#V_Version 1.11_# #H_(7/18/2023)_#",
        "#C_Modifications:_#",
        "Ajout de la compatibilité avec 1.14.4 (Classic), avec rétrocompatibilité 1.14.3 (jusqu’à la mise en ligne du patch Hardcore).",
        "Amélioration du défilement dans WotLK Classic.",
        "La rétrocompatibilité garantissant le fonctionnement des champs de saisie avec Toolbox version 1.5 a été retirée.",
        "Autres petites améliorations.",
    },
    {
        "#V_Version 1.10_# #H_(6/15/2023)_#",
        "#N_Mises à jour:_#",
        "Ajout de la compatibilité avec 10.1.5 (Dragonflight).",
        "#F_Correctifs:_#",
        "Aucun tooltip ne restera affiché après que sa cible ait été masquée.",
        "Correctifs et améliorations internes.",
    },
    {
        "#V_Version 1.9_# #H_(5/17/2023)_#",
        "#C_Modifications:_#",
        "Mise à niveau vers le nouveau système de logos d’addons de Dragonflight. (Les logos personnalisés peuvent ne pas apparaître dans les Options d’Interface sur les clients Classic.)",
        "#F_Correctifs:_#",
        "Correction d’un problème dans Dragonflight où certaines actions étaient bloquées après la fermeture du panneau de Paramètres (par exemple lors du changement de raccourcis clavier).",
        "La version actuelle fonctionne désormais sur le PTR WotLK Classic 3.4.2, mais n’est pas encore totalement finalisée (certaines parties de l’interface étant encore modernisées).",
        "Autres améliorations internes et nettoyage du code.",
    },
    {
        "#V_Version 1.8_# #H_(4/5/2023)_#",
        "#N_Mises à jour:_#",
        "Ajout de la compatibilité avec 10.1 (Dragonflight).",
        "#F_Correctifs:_#",
        "Les anciennes barres de défilement ont été remplacées par les nouvelles barres de Dragonflight, corrigeant les bugs apparus avec la dépréciation dans 10.1.",
        "Plusieurs autres correctifs et améliorations internes.",
    },
    {
        "#V_Version 1.7_# #H_(3/11/2023)_#",
        "#N_Mises à jour:_#",
        "Ajout d’une option permettant de désactiver les addons utilisant Widget Toolboxes depuis les paramètres de Widget Tools.",
        "Ajout de la compatibilité avec 10.0.7 (Dragonflight).",
        "#C_Modifications:_#",
        "La section Raccourcis a été retirée de la page principale des paramètres en Dragonflight (la nouvelle extension ayant cassé la fonctionnalité — elle pourrait revenir si le problème est résolu).",
        "Autres petites modifications.",
        "#F_Correctifs:_#",
        "Plusieurs correctifs et améliorations internes.",
    },
    {
        "#V_Version 1.6_# #H_(2/7/2023)_#",
        "#N_Mises à jour:_#",
        "Une nouvelle section Sponsors a été ajoutée à la page principale des Paramètres.\n#H_Merci pour votre soutien ! Il m’aide à continuer de consacrer du temps au développement et à la maintenance de ces addons. Si vous envisagez de soutenir le développement, suivez les liens pour voir les options disponibles._#",
        "Les informations À propos ont été réorganisées et combinées avec les liens de Support.",
        "Seules les notes de mise à jour les plus récentes seront désormais chargées. Le changelog complet est disponible dans une fenêtre plus grande en cliquant sur un nouveau bouton.",
        "Les cases à cocher sont désormais plus faciles à cliquer, et leurs tooltips restent visibles même lorsque l’entrée est désactivée.",
        "Ajout de la compatibilité avec 10.0.5 (Dragonflight) et 3.4.1 (WotLK Classic).",
        "De nombreux changements et améliorations mineurs.",
        "#F_Correctifs:_#",
        "Widget Tools ne créera plus de copies de ses Paramètres après chaque écran de chargement.",
        "Les paramètres devraient maintenant être correctement enregistrés dans Dragonflight, et les fonctionnalités personnalisées Restaurer les valeurs par défaut et Annuler les modifications devraient fonctionner comme prévu, page par page (avec l’option de restaurer les valeurs par défaut pour tout l’addon).",
        "Tous les autres sous-menus contextuels personnalisés du même niveau devraient désormais se fermer lorsqu’un autre est ouvert (d’autres améliorations du menu contextuel sont prévues pour une version ultérieure).",
        "De nombreux autres correctifs internes.",
    },
    {
        "#V_Version 1.5_# #H_(11/28/2020)_#",
        "#H_Widget Tools a soutenu d’autres addons en arrière-plan pendant plus d’un an. Il est maintenant séparé en un addon indépendant pour offrir plus de visibilité, de transparence et davantage de possibilités de développement._#",
        "#N_Mise à jour:_#",
        "Ajout de la compatibilité avec Dragonflight (Retail 10.0) avec rétrocompatibilité.",
    }
}

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---French
---@class widgetToolsStrings_frFR
ns.strings = {
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
			debugging = {
				enabled = {
					label = "Mode Débogage",
					tooltip = "Active pour créer, enregistrer et afficher des entrées de journal de débogage dans la fenêtre de discussion.",
				},
			},
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
		debug = {
			description = "Activer le Mode Débogage : enregistre et affiche les journaux de débogage dans la fenêtre de discussion",
			response = "Le mode de débogage sera #STATE après le rechargement de l’interface.",
			hint = "Tapez #COMMAND pour désactiver le Mode Débogage.",
		},
	},
	separator = " ", -- Séparateur de milliers
	decimal = ",", -- Caractère décimal
}