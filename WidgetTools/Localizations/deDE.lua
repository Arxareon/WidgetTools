--| Locale

if GetLocale() ~= "deDE" then return end

--| Namespace

---@class addonNamespace
local ns = select(2, ...)

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---German
---@class widgetToolsStrings_deDE
ns.rs.strings = {
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