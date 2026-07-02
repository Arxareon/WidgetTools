--| Namespace

---@class namespace
local ns = select(2, ...)

--[ Changelog ]

ns.changelog = {
    {
        "#V_Version 3.0_# #H_(23/4/2026)_#",
        "#F_Hotfix (Version 3.0.1):_#",
        "#H_Die Unterstützung für benutzerdefinierte Schriftdateien wurde bis zum nächsten Update auf die vorherige Lösung zurückgesetzt (nun jedoch von Widget Tools verwaltet), da ein Versehen kritische Fehler verursachte._# Außerdem habe ich mehrere Schriftarten entfernt, um Speicherplatz zu sparen. Sobald die geplante Unterstützung für vollständig benutzerdefinierte Schriftarten fertiggestellt und veröffentlicht ist, können beliebig viele eigene Schriftarten verwendet werden, sodass es kaum noch nötig sein wird, so viele Schriftarten beizulegen. #H_Um mit dieser temporären Lösung eine benutzerdefinierte Schriftdatei hinzuzufügen, ersetze wie zuvor_# #O_Interface/Addons/WidgetTools/Fonts/CUSTOM.ttf_# #H_durch eine beliebige TrueTypeFont-Datei, wobei der Dateiname exakt beibehalten werden muss._#",
        "Mehrere Schriftarten wurden entfernt und werden nicht mehr mitgeliefert, da ich kleinere Dateigrößen priorisieren möchte und große Schriftdateien, die den meisten kaum Nutzen bringen, diesem Ziel entgegenstehen.",
        "Wago-ID-Informationen wurden hinzugefügt, um Wago dabei zu helfen, Addon-Abhängigkeiten automatisch zu finden und herunterzuladen.",
        "#N_Neu:_#",
        "Unterstützung für Midnight 12.0.5 hinzugefügt.",
        "Eine gemeinsame Liste benutzerdefinierter Schriftarten wurde hinzugefügt, auf die nun alle Addons über die globale #H_WidgetTools.resources_# Sammlung zugreifen können. #H_Eine benutzerdefinierte Schriftdatei namens_# #O_CUSTOM.ttf_# #H_kann jetzt im Hauptordner_# #O_Fonts_# #H_im WoW-Clientverzeichnis abgelegt werden,_# damit sie von Widget Tools erkannt wird. Die Verwaltung benutzerdefinierter Schriftdateien wird in zukünftigen Updates weiter ausgebaut.",
        "Neue Debug-Logging-Werkzeuge wurden eingeführt, die über die globale #H_WidgetTools.debugging_# Sammlung zugänglich sind. Debugging-Funktionen werden in zukünftigen Updates erweitert und in Toolboxes integriert.",
        "#C_Änderungen:_#",
        "Die Toolbox-Ladestruktur wurde überarbeitet; ältere Versionen werden nicht mehr unterstützt.",
        "Viele grundlegende Dienstprogramme wurden an Widget Tools übergeben (und sind nicht länger Toolbox-spezifisch), global zugänglich über die #H_WidgetTools.utilities_# Sammlung.",
        "Das Backend-System zur Ereignisverwaltung für Blizzard-weite OnEvent-Handler (und benutzerdefinierte Events) für Frames wurde aktualisiert, mit neuen global zugänglichen Dienstprogrammen über die #H_WidgetTools.utilities_# Sammlung.",
        "Die meisten Anmerkungen, die nur für die Entwicklung gedacht waren, wurden aus den installierten Addon-Dateien ausgelagert, um die Installationsgröße deutlich zu reduzieren.",
        "Mehrere weitere interne Änderungen und Verbesserungen.",
        "#F_Fixes:_#",
        "Das Kontextmenü im AddOns-Menü für Widget Tools wird nach dem ersten Öffnen nicht mehr den anklickbaren Bildschirmbereich blockieren.",
        "Zahlreiche weitere kleinere Fehlerbehebungen.",
        "#O_Hinweis:_# Siehe Widget Toolbox Changelog auf der Toolboxes & Addons Seite für weitere interne Änderungen.",
        "#H_Vielen Dank für eure Hilfe, Vorschläge & Fehlermeldungen !_# Wenn ihr auf Probleme stoßt, zögert nicht, sie zu melden! Gebt möglichst an, wann & wie sie auftreten und welche anderen Addons ihr verwendet (falls relevant), um mir die beste Chance zu geben, sie zu reproduzieren & zu beheben. Fügt nach Möglichkeit Lua-Fehlermeldungen und Taint-Logs bei (falls ihr wisst, wie man sie findet).",
    },
    {
        "#V_Version 2.2_# #H_(23/2/2026)_#",
        "#F_Hotfix:_#",
        "Text in Eingabefeldern wird wieder korrekt skaliert, sodass er in die Breite der Felder passt.",
    },
    {
        "#V_Version 2.2_# #H_(13/2/2026)_#",
        "#F_Hotfix:_#",
        "Text in Eingabefeldern wird wieder korrekt skaliert, sodass er in die Breite der Felder passt.",
    },
    {
        "#V_Version 2.1_# #H_(13/2/2026)_#",
        "#N_Updates:_#",
        "Unterstützung für Midnight 12.0.1, Mists of Pandaria 5.5.3, The Burning Crusade 2.5.5 & Classic 1.15.8 hinzugefügt.",
        "Interne Verbesserungen.",
    },
    {
        "#V_Version 2.0_# #H_(8/6/2025)_#",
        "#N_Neu:_#",
        "Unterstützung für Mists of Pandaria Classic 5.5.0, The War Within 11.2 & Classic 1.15.7 hinzugefügt.",
        "KI-übersetzte Lokalisierungen für alle von WoW unterstützten Sprachen hinzugefügt. #H_Hinweis: Da diese Übersetzungen von KI generiert wurden, enthalten sie Fehler. Wenn du helfen möchtest, einige davon zu korrigieren, oder wenn du freiwillig deine Hilfe anbieten möchtest, um dieses Addon korrekt in deine Sprache zu übersetzen, melde dich gerne! Jede Hilfe und jeder Fehlerbericht wird sehr geschätzt! <3_# (Das Changelog ist vorerst nur auf Englisch verfügbar.)",
        "#H_Ein neuer Lite-Modus wurde eingeführt !_# Wenn aktiviert, werden keine von Widget Tools verwalteten Einstellungsseiten für Addons geladen, die mit Widget Tools erstellt wurden, wodurch Ressourcen gespart werden. Deaktiviere ihn, um wieder auf sichtbare Addon-Einstellungen zuzugreifen. (Addondaten werden weiterhin im Hintergrund geladen, ohne die Funktionalität zu beeinträchtigen.)",
        "#H_Visuelle Hilfen für die Positionierung wurden hinzugefügt !_# Eine Option zum Aktivieren visueller Positionierungshilfen für Addons, die mit Widget Tools erstellt wurden, wurde eingeführt, um besser zu verstehen, wie die erweiterten Positionierungseinstellungen funktionieren und um volle Kontrolle über jedes Detail zu ermöglichen.",
        "Eine Option für Entwickler wurde hinzugefügt, um das Frame Attributes Fenster (TableAttributeDisplay Frame) breiter zu machen.",
        "Chatbefehle für Widget Tools hinzugefügt, nutze: #H_/wt_#",
        "#H_#C_Änderungen_# & #F_Fixes_#:_#",
        "Das Aussehen von Checkboxen & Einstellungsseiten wurde aktualisiert, um dem neuen Einstellungsstil zu entsprechen.",
        "Signifikante interne Verbesserungen & Fehlerbehebungen sowie weitere kleinere Änderungen & Fixes.",
        "#V_Version 2.0.1_# • #F_Hotfix:_#",
        "Begrüßungsnachrichten werden nicht mehr bei jedem Interface-Neuladen gespammt.",
        "Der Lite-Modus kann nun ohne Fehler aktiviert werden.",
        "Das Erscheinungsbild des Reload-Hinweisfensters wurde angepasst.",
    },
    {
        "#V_Version 1.12_# #H_(8/9/2023)_#",
        "#C_Änderungen:_#",
        "Verknüpfungen wurden in Classic von der Haupt-Einstellungsseite entfernt.",
        "Interne Verbesserungen.",
    },
    {
        "#V_Version 1.11_# #H_(7/18/2023)_#",
        "#C_Änderungen:_#",
        "Unterstützung für 1.14.4 (Classic) hinzugefügt, mit Rückwärtskompatibilität zu 1.14.3 (bis der Hardcore-Patch live geht).",
        "Scrollen wurde in WotLK Classic verbessert.",
        "Rückwärtskompatibilität für Eingabefelder mit Toolbox Version 1.5 wurde entfernt.",
        "Weitere kleine Verbesserungen.",
    },
    {
        "#V_Version 1.10_# #H_(6/15/2023)_#",
        "#N_Updates:_#",
        "Unterstützung für 10.1.5 (Dragonflight) hinzugefügt.",
        "#F_Fixes:_#",
        "Kein Tooltip bleibt mehr auf dem Bildschirm, nachdem sein Ziel ausgeblendet wurde.",
        "Interne Fehlerbehebungen & Verbesserungen.",
    },
    {
        "#V_Version 1.9_# #H_(5/17/2023)_#",
        "#C_Änderungen:_#",
        "Auf das neue Dragonflight-Addon-Logo-System aktualisiert. (Benutzerdefinierte Addon-Logos erscheinen möglicherweise nicht in den Interface-Optionen in Classic-Clients.)",
        "#F_Fixes:_#",
        "Ein Problem wurde behoben, bei dem Aktionen nach dem Schließen des Einstellungsfensters in bestimmten Situationen (z. B. beim Ändern von Tastenzuweisungen) in Dragonflight blockiert wurden.",
        "Die aktuelle Version läuft nun im WotLK Classic 3.4.2 PTR, ist jedoch noch nicht vollständig ausgereift (da Teile der UI weiterhin modernisiert werden).",
        "Weitere interne Verbesserungen & Codebereinigung.",
    },
    {
        "#V_Version 1.8_# #H_(4/5/2023)_#",
        "#N_Updates:_#",
        "Unterstützung für 10.1 (Dragonflight) hinzugefügt.",
        "#F_Fixes:_#",
        "Die alten Scrollleisten wurden durch die neuen Dragonflight-Scrollleisten ersetzt, wodurch alle Fehler behoben wurden, die durch die Abschaffung der alten Version entstanden waren.",
        "Mehrere weitere interne Fehlerbehebungen & Verbesserungen.",
    },
    {
        "#V_Version 1.7_# #H_(3/11/2023)_#",
        "#N_Updates:_#",
        "Eine Option wurde hinzugefügt, um Addons, die Widget Toolboxes verwenden, über die Widget Tools Einstellungen zu deaktivieren.",
        "Unterstützung für 10.0.7 (Dragonflight) hinzugefügt.",
        "#C_Änderungen:_#",
        "Der Abschnitt „Verknüpfungen“ wurde in Dragonflight von der Haupt-Einstellungsseite entfernt (da die neue Erweiterung die Funktion beschädigt hat – ich füge sie möglicherweise wieder hinzu, wenn das Problem behoben wird).",
        "Weitere kleinere Änderungen.",
        "#F_Fixes:_#",
        "Mehrere interne Fehlerbehebungen & Verbesserungen.",
    },
    {
        "#V_Version 1.6_# #H_(2/7/2023)_#",
        "#N_Updates:_#",
        "Ein neuer Sponsoren-Bereich wurde zur Haupt-Einstellungsseite hinzugefügt.\n#H_Vielen Dank für eure Unterstützung! Sie hilft mir, weiterhin Zeit in die Entwicklung und Pflege dieser Addons zu investieren. Wenn du ebenfalls erwägst, die Entwicklung zu unterstützen, folge den Links, um zu sehen, welche Möglichkeiten derzeit verfügbar sind._#",
        "Die „Über“-Informationen wurden neu angeordnet und mit den Support-Links kombiniert.",
        "Nur die neuesten Update-Hinweise werden jetzt geladen. Das vollständige Changelog ist in einem größeren Fenster verfügbar, wenn man auf einen neuen Button klickt.",
        "Checkboxen wurden leichter anklickbar gemacht, ihre Tooltips sind nun sichtbar, selbst wenn die Eingabe deaktiviert ist.",
        "Unterstützung für 10.0.5 (Dragonflight) & 3.4.1 (WotLK Classic) hinzugefügt.",
        "Zahlreiche weniger bedeutende Änderungen & Verbesserungen.",
        "#F_Fixes:_#",
        "Widget Tools wird nicht länger Kopien seiner Einstellungen nach jedem Ladebildschirm erstellen.",
        "Einstellungen sollten nun in Dragonflight korrekt gespeichert werden, und die benutzerdefinierten Funktionen „Standardwerte wiederherstellen“ und „Änderungen zurücksetzen“ sollten nun wie erwartet funktionieren – pro Einstellungsseite (mit der Option, weiterhin die Standardwerte für das gesamte Addon wiederherzustellen).",
        "Alle anderen geöffneten benutzerdefinierten Kontext-Untermenüs auf derselben Ebene sollten sich nun schließen, wenn eines geöffnet wird (weitere Verbesserungen am Kontextmenü sind für ein späteres Update geplant).",
        "Viele weitere interne Fehlerbehebungen.",
    },
    {
        "#V_Version 1.5_# #H_(11/28/2020)_#",
        "#H_Widget Tools hat über ein Jahr lang andere Addons im Hintergrund unterstützt. Nun wurde es als eigenes Addon ausgegliedert, um mehr Sichtbarkeit, Transparenz und erweiterte Entwicklungsmöglichkeiten zu bieten._#",
        "#N_Update:_#",
        "Unterstützung für Dragonflight (Retail 10.0) mit Rückwärtskompatibilität hinzugefügt.",
    }
}

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---German
---@class widgetToolsStrings_deDE
ns.strings = {
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
			debugging = {
				enabled = {
					label = "Debugging-Modus",
					tooltip = "Umschalten, um Debugging-Protokolle zu erstellen, zu speichern und im Chatfenster auszugeben.",
				},
			},
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
		debug = {
			description = "Debugging-Modus umschalten: speichert und zeigt Debug-Protokolle im Chat an",
			response = "Debugging wird nach dem Neuladen der Benutzeroberfläche #STATE sein.",
			hint = "Gib #COMMAND ein, um den Debugging-Modus zu deaktivieren.",
		},
	},
	separator = ".", -- Tausendertrennzeichen
	decimal = ",", -- Dezimalzeichen
}