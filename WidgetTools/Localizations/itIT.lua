--| Locale

if GetLocale() ~= "itIT" then return end

--| Namespace

---@class addonNamespace
local ns = select(2, ...)

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Italian
---@class widgetToolsStrings_itIT
ns.rs.strings = {
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