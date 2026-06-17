--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--[ Changelog ]

wt.changelog = {
    {
        "#V_Version 3.0_# #H_(23/4/2026)_#",
        "#F_Hotfix (Version 3.0.1):_#",
        "An mehreren Stellen wurden Schutzmechanismen hinzugefügt, um zu verhindern, dass fehlende oder ungültige Asset-Dateipfade (Schriftarten oder Texturen) kritische Fehler verursachen.",
        "#N_Neu:_#",
        "Unterstützung für Midnight 12.0.5 hinzugefügt.",
        "Die zuvor hinzugefügten Rechtsklick-Menüs für Einstellungen wurden weiter verbessert und verfügen nun über Kopieren-&-Einfügen‑Funktionen, um Werte leicht zwischen ähnlichen Einstellungstypen zu übertragen.",
        "Eine neue Vorlage für erweiterte Einstellungen zur Verwaltung von Schriftoptionen wurde hinzugefügt (weitere Schriftanpassungsoptionen folgen in zukünftigen Updates).",
        "#C_Änderungen:_#",
        "Das Aussehen der numerischen Einstellungs‑Slider wurde aktualisiert, um den neuen Blizzard‑Slidern zu entsprechen, wobei alle erweiterten Funktionen für mit Widget Tools Toolboxes erstellte Addons erhalten bleiben.",
        "Die Lade‑Struktur der Toolbox wurde überarbeitet; ältere Versionen werden nicht mehr unterstützt.",
        "Viele grundlegende Dienstprogramme wurden an Widget Tools übergeben (und sind nicht länger Toolbox‑spezifisch) und sind nun global über die WidgetTools.utilities‑Sammlung zugänglich.",
        "Toolbox‑spezifische Daten werden nicht länger in Frame‑Tabellen injiziert, sondern in toolbox‑spezifischen Tabellen gespeichert (einschließlich Tooltip‑ oder Container‑Layout‑Daten).",
        "Das Backend‑System zur Ereignisverwaltung für Blizzard‑weite OnEvent‑Handler (und benutzerdefinierte Events) für Frames wurde aktualisiert, mit neuen global zugänglichen Dienstprogrammen über die WidgetTools.utilities‑Sammlung.",
        "Anpassbare Frames, Buttons und andere Widgets müssen nun über neue Konstruktoren erstellt werden; die anpassbaren Flags wurden aus ihren Basisvarianten entfernt.",
        "Die meisten Annotations, die nur für die Entwicklung gedacht waren, wurden aus den installierten Addon‑Dateien ausgelagert, um die Installationsgröße deutlich zu reduzieren.",
        "Die Logik der Konstruktion der Datenverwaltungs‑Einstellungsseite (jetzt „Profile‑Seite“ genannt) wurde in ein Profilemanager‑Widget und eine darauf aufbauende GUI‑Mutation aufgeteilt, um mehr Flexibilität und Anpassbarkeit zu ermöglichen.",
        "Mehrere weitere interne Änderungen und Verbesserungen.",
        "#F_Hotfixes:_#",
        "Zahlreiche weitere kleinere Fehlerbehebungen.",
        "#H_Vielen Dank für eure Hilfe, Vorschläge & Fehlermeldungen!_# Wenn ihr auf Probleme stoßt, zögert nicht, sie zu melden! Gebt möglichst an, wann & wie sie auftreten und welche anderen Addons ihr verwendet (falls relevant), um mir die beste Chance zu geben, sie zu reproduzieren & zu beheben. Fügt nach Möglichkeit Lua‑Fehlermeldungen und Taint‑Logs bei (falls ihr wisst, wie man sie findet).",
    }
}

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---German
---@class toolboxStrings_deDE
wt.strings = {
	chat = {
		welcome = {
			thanks = "Danke, dass du #ADDON verwendest!",
			hint = "Gib #KEYWORD ein, um die Liste der Chatbefehle anzuzeigen.",
			keywords = "#KEYWORD oder #KEYWORD_ALTERNATE",
		},
		help = {
			list = "#ADDON Chatbefehlsliste:",
		},
	},
	popupInput = {
		title = "Text angeben",
		tooltip = "Drücke " .. KEY_ENTER .. ", um den angegebenen Text zu übernehmen, oder " .. KEY_ESCAPE .. ", um abzubrechen."
	},
	reload = {
		title = "Ausstehende Änderungen",
		description = "Lade das Interface neu, um die ausstehenden Änderungen anzuwenden.",
		accept = {
			label = "Jetzt neu laden",
			tooltip = "Du kannst das Interface jetzt neu laden, um die ausstehenden Änderungen anzuwenden.",
		},
		cancel = {
			label = "Später",
			tooltip = "Lade das Interface später mit dem Chatbefehl /reload oder durch Ausloggen neu.",
		},
	},
	multiSelector = {
		locked = "Gesperrt",
		minLimit = "Mindestens #MIN Optionen müssen ausgewählt werden.",
		maxLimit = "Es können nur #MAX Optionen gleichzeitig ausgewählt werden.",
	},
	dropdown = {
		selected = "Dies ist die aktuell ausgewählte Option.",
		none = "Es wurde keine Option ausgewählt.",
		open = "Klicke, um die Liste der Optionen anzuzeigen.",
		previous = {
			label = "Vorherige Option",
			tooltip = "Vorherige Option auswählen.",
		},
		next = {
			label = "Nächste Option",
			tooltip = "Nächste Option auswählen.",
		},
		clear = "Auswahl löschen",
	},
	copyBox = "Kopiere den Text mit:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Wert angeben",
			tooltip = "Gib einen Wert im gültigen Bereich ein.",
		},
		decrease = {
			label = "Verringern",
			tooltip = {
				"Subtrahiere #VALUE vom Wert.",
				"Halte ALT, um stattdessen #VALUE zu subtrahieren.",
			},
		},
		increase = {
			label = "Erhöhen",
			tooltip = {
				"Addiere #VALUE zum Wert.",
				"Halte ALT, um stattdessen #VALUE zu addieren.",
			},
		},
	},
	color = {
		picker = {
			label = "Farbe auswählen",
			tooltip = "Öffne den Farbwähler, um die Farbe#ALPHA anzupassen.",
			alpha = " und die Transparenz zu ändern",
		},
		hex = {
			label = "Per HEX-Farbcode hinzufügen",
			tooltip = "Du kannst die Farbe auch per HEX-Code ändern, anstatt den Farbwähler zu benutzen.",
		}
	},
	settings = {
		save = "Änderungen werden beim Schließen übernommen.",
		cancel = {
			label = "Änderungen verwerfen",
			tooltip = "Alle auf dieser Seite vorgenommenen Änderungen verwerfen und gespeicherte Werte laden.",
		},
		defaults = {
			label = "Standard wiederherstellen",
			tooltip = "Alle Einstellungen auf dieser Seite (oder der gesamten Kategorie) auf Standardwerte zurücksetzen.",
		},
		warning = "Bist du sicher, dass du die Einstellungen der Seite #PAGE oder alle Einstellungen der Kategorie #CATEGORY auf Standard zurücksetzen möchtest?",
		warningSingle = "Bist du sicher, dass du die Einstellungen der Seite #PAGE auf Standard zurücksetzen möchtest?",
	},
	value = {
		copy = "Wert kopieren",
		paste = "Wert einfügen",
		revert = "Änderungen verwerfen",
		restore = "Standard wiederherstellen",
		note = "Rechtsklick, um zu kopieren oder rückgängig zu machen.",
	},
	points = {
		left = "Links",
		right = "Rechts",
		center = "Mitte",
		top = {
			left = "Oben Links",
			right = "Oben Rechts",
			center = "Oben Mitte",
		},
		bottom = {
			left = "Unten Links",
			right = "Unten Rechts",
			center = "Unten Mitte",
		},
	},
	strata = {
		lowest = "Niedrigster Hintergrund",
		lower = "Mittlerer Hintergrund",
		low = "Höchster Hintergrund",
		lowMid = "Niedriges Mittel",
		highMid = "Hohes Mittel",
		high = "Niedriger Vordergrund",
		higher = "Mittlerer Vordergrund",
		highest = "Höchster Vordergrund",
	},
	about = {
		title = "Über",
		description = "Danke, dass du #ADDON verwendest! Kopiere die Links, um Feedback zu geben, Hilfe zu erhalten oder die Entwicklung zu unterstützen.",
		version = "Version",
		date = "Datum",
		author = "Autor",
		license = "Lizenz",
		curseForge = "CurseForge-Seite",
		wago = "Wago-Seite",
		repository = "GitHub-Repository",
		issues = "Probleme & Feedback",
		changelog = {
			label = "Update-Hinweise",
			tooltip = "Hinweise zu allen Änderungen, Updates & Fehlerbehebungen der neuesten Version: #VERSION.",
		},
		fullChangelog = {
			label = "#ADDON Changelog",
			tooltip = "Die vollständige Liste aller Update-Hinweise zu allen Addon-Versionen.",
			open = {
				label = "Changelog",
				tooltip = "Lies die vollständige Liste aller Update-Hinweise zu allen Addon-Versionen.",
			},
		},
	},
	sponsors = {
		title = "Sponsoren",
		description = "Deine fortlaufende Unterstützung wird sehr geschätzt! Vielen Dank!",
	},
	dataManagement = {
		title = "Datenverwaltung",
		description = "Konfiguriere #ADDON weiter, indem du Profile und Backups verwaltest, importierst oder exportierst.",
	},
	profiles = {
		title = "Profile",
		description = "Erstelle, bearbeite und verwende individuelle Optionsprofile für jeden deiner Charaktere.",
		select = {
			label = "Profil auswählen",
			tooltip = "Wähle das Optionsdaten-Profil, das für deinen aktuellen Charakter verwendet werden soll.\n\nDie Daten im aktiven Profil werden automatisch überschrieben, wenn Einstellungen geändert und gespeichert werden!",
			profile = "Profil",
			main = "Haupt",
		},
		new = {
			label = "Neues Profil",
			tooltip = "Ein neues Standardprofil erstellen.",
		},
		duplicate = {
			label = "Duplizieren",
			tooltip = "Ein neues Profil erstellen, das die Daten des aktuell aktiven Profils kopiert.",
		},
		rename = {
			label = "Umbenennen",
			tooltip = "Das aktuell aktive Profil umbenennen.",
			description = "#PROFILE umbenennen in:",
		},
		delete = {
			tooltip = "Das aktuell aktive Profil löschen.",
			warning = "Bist du sicher, dass du das aktuell aktive #PROFILE #ADDON-Einstellungsprofil entfernen und alle darin gespeicherten Daten dauerhaft löschen möchtest?"
		},
		reset = {
			warning = "Bist du sicher, dass du das aktuell aktive #PROFILE #ADDON-Einstellungsprofil mit Standardwerten überschreiben möchtest?",
		},
	},
	backup = {
		title = "Backup",
		description = "Importiere oder exportiere Daten des aktuell aktiven Profils, um Einstellungen zu speichern, zu teilen, zu übertragen oder Werte manuell zu bearbeiten.",
		box = {
			label = "Aktuelles Profil importieren oder exportieren",
			tooltip = {
				"Der Backup-String in diesem Feld enthält die Daten des aktuell aktiven Addon-Profils.",
				"Kopiere den Text, um Daten zu speichern, zu teilen oder für einen anderen Account zu laden.",
				"Um Daten aus einem String zu laden, ersetze den Text in diesem Feld und drücke " .. KEY_ENTER .. " oder klicke auf die #LOAD Schaltfläche.",
				"Hinweis: Wenn du eigene Schriftarten oder Texturen verwendest, werden diese Dateien nicht mit diesem String übertragen. Sie müssen separat gespeichert und in den Addon-Ordner eingefügt werden.",
				"Lade nur Strings, die du selbst überprüft hast oder deren Quelle du vertraust!",
			},
		},
		allProfiles = {
			label = "Alle Profile importieren oder exportieren",
			tooltipLine = "Der Backup-String in diesem Feld enthält die Liste aller Addon-Profile und die darin gespeicherten Daten sowie den Namen des aktuell aktiven Profils.",
			open = {
				label = "Alle Profile",
				tooltip = "Greife auf die vollständige Profilliste zu und sichere oder bearbeite die darin gespeicherten Daten.",
			},
		},
		compact = {
			label = "Kompakt",
			tooltip = "Zwischen einer kompakten und einer besser lesbaren/bearbeitbaren Ansicht umschalten.",
		},
		load = {
			label = "Laden",
			tooltip = "Überprüfe den aktuellen String und versuche, die Daten daraus zu laden.",
		},
		reset = {
			tooltip = "Alle Änderungen am String verwerfen und ihn auf die aktuell gespeicherten Daten zurücksetzen.",
		},
		import = "String laden",
		warning = "Bist du sicher, dass du versuchst, den aktuell eingefügten String zu laden?\n\nAlle nicht gespeicherten Änderungen werden verworfen.\n\nWenn du ihn aus einer Online-Quelle kopiert hast oder jemand ihn dir geschickt hat, lade ihn nur, nachdem du den Code überprüft hast und weißt, was du tust.\n\nWenn du der Quelle nicht vertraust, solltest du abbrechen, um unerwünschte Aktionen zu vermeiden.",
		error = "Der bereitgestellte Backup-String konnte nicht validiert werden und es wurden keine Daten geladen. Es könnten Zeichen fehlen oder Fehler wurden beim Bearbeiten eingefügt.",
	},
	position = {
		title = "Position",
		description = {
			static = "Feinabstimmung der Position von #FRAME auf dem Bildschirm über die hier bereitgestellten Optionen.",
			movable = "Ziehe #FRAME mit gedrückter SHIFT-Taste, um es beliebig zu positionieren, und passe es hier an.",
		},
		relativePoint = {
			label = "Verknüpfungspunkt Bildschirm",
			tooltip = "Verbinde den gewählten Ankerpunkt von #FRAME mit dem hier ausgewählten Verknüpfungspunkt.",
		},
		-- relativeTo = {
		-- 	label = "Mit Frame verknüpfen",
		-- 	tooltip = "Gib den Namen eines anderen UI-Elements ein, um die Position von #FRAME daran zu verknüpfen.\n\nDie Namen von Frames findest du über das Debug-UI mit dem Chatbefehl /framestack.",
		-- },
		anchor = {
			label = "Verknüpfungs-Ankerpunkt",
			tooltip = "Wähle, von welchem Punkt #FRAME verankert werden soll, wenn er mit dem gewählten Bildschirm-Punkt verknüpft wird.",
		},
		keepInPlace = {
			label = "Position beibehalten",
			tooltip = "#FRAME nicht verschieben, wenn der #ANCHOR geändert wird, sondern nur die Offset-Werte anpassen.",
		},
		offsetX= {
			label = "Horizontaler Versatz",
			tooltip = "Lege den horizontalen Versatz (X-Achse) von #FRAME zum gewählten #ANCHOR fest.",
		},
		offsetY = {
			label = "Vertikaler Versatz",
			tooltip = "Lege den vertikalen Versatz (Y-Achse) von #FRAME zum gewählten #ANCHOR fest.",
		},
		keepInBounds = {
			label = "Im Bildschirm halten",
			tooltip = "Stelle sicher, dass #FRAME nicht außerhalb des Bildschirms verschoben werden kann.",
		},
	},
	presets = {
		apply = {
			label = "Voreinstellung anwenden",
			tooltip = "Ändere die Position von #FRAME, indem du eine dieser Voreinstellungen auswählst und anwendest.",
			list = { "Unter der Minimap", },
			select = "Voreinstellung auswählen…",
		},
		save = {
			label = "#CUSTOM Voreinstellung aktualisieren",
			tooltip = "Speichere die aktuelle Position und Sichtbarkeit von #FRAME in der #CUSTOM Voreinstellung.",
			warning = "Bist du sicher, dass du die #CUSTOM Voreinstellung mit den aktuellen Werten überschreiben möchtest?",
		},
		reset = {
			label = "#CUSTOM Voreinstellung zurücksetzen",
			tooltip = "Überschreibe die gespeicherten #CUSTOM Voreinstellungsdaten mit den Standardwerten und wende sie an.",
			warning = "Bist du sicher, dass du die #CUSTOM Voreinstellung mit den Standardwerten überschreiben möchtest?",
		},
	},
	layer = {
		strata = {
			label = "Bildschirmebene",
			tooltip = "#FRAME vor oder hinter anderen UI-Elementen anzeigen.",
		},
		keepOnTop = {
			label = "Bei Mausinteraktion hervorheben",
			tooltip = "Erlaube, dass #FRAME bei Interaktion über anderen Frames derselben #STRATA angezeigt wird.",
		},
		level = {
			label = "Frame-Level",
			tooltip = "Die genaue Position von #FRAME über oder unter anderen Frames im selben #STRATA-Stack.",
		},
	},
	font = {
		title = "Text",
		path = {
			label = "Schriftart",
			tooltip = "Wähle die Schriftart aus.",
			default = {
				label = "Lokalisierte Standardschrift",
				tooltip = "Dies ist eine lokalisierte Standardschriftart, die von Blizzard verwendet wird.",
			},
			base = "Dies ist eine Grundspiel-Schriftart.",
			custom = "Dies ist eine benutzerdefinierte Schriftart.",
			otf = "OpenType-Schriftlizenz.",
			file = "Dateipfad: #PATH",
			replace = "Die Option Benutzerdefiniert bietet vollständige Anpassung, indem Sie die Schriftdatei #FILE_CUSTOM durch eine andere TrueType-Schriftdatei ersetzen, die in\n#FONTS_DIRECTORY\ngefunden wird, während der ursprüngliche Dateiname #FILE_CUSTOM beibehalten wird.",
			reminder = "Möglicherweise müssen Sie den Spielclient vollständig neu starten, nachdem Sie die Schriftdatei ersetzt haben, damit die Änderung wirksam wird.",
		},
		size = {
			label = "Größe",
			tooltip = "Stelle die Schriftgröße ein.",
		},
		alignment = {
			label = "Ausrichtung",
			tooltip = "Wähle die horizontale Textausrichtung.",
		},
		color = {
			label = "#COLOR_TYPE-Farbe",
			tooltip = "Lege die #COLOR_TYPE-Textfarbe fest.",
		},
	},
	date = "#DAY.#MONTH.#YEAR",
	override = "Überschreiben",
	example = "Beispiel",
}