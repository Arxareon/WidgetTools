--| Locale

if GetLocale() ~= "itIT" then return end

--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Italian
---@class toolboxStrings_itIT
wt.strings = {
	chat = {
		welcome = {
			thanks = "Grazie per aver utilizzato #ADDON!",
			hint = "Digita #KEYWORD per vedere la lista dei comandi della chat.",
			keywords = "#KEYWORD o #KEYWORD_ALTERNATE",
		},
		help = {
			list = "Lista dei comandi della chat di #ADDON:",
		},
	},
	popupInput = {
		title = "Specifica il testo",
		tooltip = "Premi " .. KEY_ENTER .. " per accettare il testo specificato o " .. KEY_ESCAPE .. " per annullare."
	},
	reload = {
		title = "Modifiche in sospeso",
		description = "Ricarica l'interfaccia per applicare le modifiche in sospeso.",
		accept = {
			label = "Ricarica ora",
			tooltip = "Puoi scegliere di ricaricare l'interfaccia ora per applicare le modifiche in sospeso.",
		},
		cancel = {
			label = "Più tardi",
			tooltip = "Ricarica l'interfaccia più tardi con il comando /reload o disconnettendoti.",
		},
	},
	multiSelector = {
		locked = "Bloccato",
		minLimit = "Devono essere selezionate almeno #MIN opzioni.",
		maxLimit = "Possono essere selezionate solo #MAX opzioni alla volta.",
	},
	dropdown = {
		selected = "Questa è l'opzione attualmente selezionata.",
		none = "Nessuna opzione selezionata.",
		open = "Clicca per vedere la lista delle opzioni.",
		previous = {
			label = "Opzione precedente",
			tooltip = "Seleziona l'opzione precedente.",
		},
		next = {
			label = "Opzione successiva",
			tooltip = "Seleziona l'opzione successiva.",
		},
		clear = "Cancella selezione",
	},
	copyBox = "Copia il testo premendo:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Specifica il valore",
			tooltip = "Inserisci un valore compreso nell'intervallo.",
		},
		decrease = {
			label = "Diminuisci",
			tooltip = {
				"Sottrai #VALUE dal valore.",
				"Tieni premuto ALT per sottrarre #VALUE invece.",
			},
		},
		increase = {
			label = "Aumenta",
			tooltip = {
				"Aggiungi #VALUE al valore.",
				"Tieni premuto ALT per aggiungere #VALUE invece.",
			},
		},
	},
	color = {
		picker = {
			label = "Scegli un colore",
			tooltip = "Apri il selettore colori per personalizzare il colore#ALPHA.",
			alpha = " e cambia l'opacità",
		},
		hex = {
			label = "Aggiungi tramite codice colore HEX",
			tooltip = "Puoi cambiare il colore tramite codice HEX invece di usare il selettore colori.",
		}
	},
	settings = {
		save = "Le modifiche saranno applicate alla chiusura.",
		cancel = {
			label = "Annulla modifiche",
			tooltip = "Annulla tutte le modifiche fatte in questa pagina e carica i valori salvati.",
		},
		defaults = {
			label = "Ripristina predefiniti",
			tooltip = "Ripristina tutte le impostazioni di questa pagina (o dell'intera categoria) ai valori predefiniti.",
		},
		warning = "Sei sicuro di voler ripristinare le impostazioni della pagina #PAGE o tutte le impostazioni della categoria #CATEGORY ai valori predefiniti?",
		warningSingle = "Sei sicuro di voler ripristinare le impostazioni della pagina #PAGE ai valori predefiniti?",
	},
	value = {
		copy = "Copia valore",
		paste = "Incolla valore",
		revert = "Annulla modifiche",
		restore = "Ripristina predefinito",
		note = "Clic destro per copiare o annullare.",
	},
	points = {
		left = "Sinistra",
		right = "Destra",
		center = "Centro",
		top = {
			left = "Alto Sinistra",
			right = "Alto Destra",
			center = "Alto Centro",
		},
		bottom = {
			left = "Basso Sinistra",
			right = "Basso Destra",
			center = "Basso Centro",
		},
	},
	strata = {
		lowest = "Sfondo Basso",
		lower = "Sfondo Medio",
		low = "Sfondo Alto",
		lowMid = "Medio Basso",
		highMid = "Medio Alto",
		high = "Primo Piano Basso",
		higher = "Primo Piano Medio",
		highest = "Primo Piano Alto",
	},
	about = {
		title = "Informazioni",
		description = "Grazie per aver utilizzato #ADDON! Copia i link per sapere come inviare feedback, ottenere aiuto e supportare lo sviluppo.",
		version = "Versione",
		date = "Data",
		author = "Autore",
		license = "Licenza",
		curseForge = "Pagina CurseForge",
		wago = "Pagina Wago",
		repository = "Repository GitHub",
		issues = "Problemi & Feedback",
		changelog = {
			label = "Note di aggiornamento",
			tooltip = "Note di tutti i cambiamenti, aggiornamenti e correzioni introdotti con l'ultima versione: #VERSION.",
		},
		fullChangelog = {
			label = "Changelog di #ADDON",
			tooltip = "L'elenco completo delle note di aggiornamento di tutte le versioni dell'addon.",
			open = {
				label = "Changelog",
				tooltip = "Leggi l'elenco completo delle note di aggiornamento di tutte le versioni dell'addon.",
			},
		},
	},
	sponsors = {
		title = "Sponsor",
		description = "Il tuo continuo supporto è molto apprezzato! Grazie!",
	},
	dataManagement = {
		title = "Gestione Dati",
		description = "Configura ulteriormente #ADDON gestendo profili e backup tramite importazione ed esportazione.",
	},
	profiles = {
		title = "Profili",
		description = "Crea, modifica e applica profili di opzioni unici per ciascuno dei tuoi personaggi.",
		select = {
			label = "Seleziona un Profilo",
			tooltip = "Scegli il profilo di archiviazione delle opzioni da usare per il tuo personaggio attuale.\n\nI dati nel profilo attivo verranno sovrascritti automaticamente quando le impostazioni vengono modificate e salvate!",
			profile = "Profilo",
			main = "Principale",
		},
		new = {
			label = "Nuovo Profilo",
			tooltip = "Crea un nuovo profilo predefinito.",
		},
		duplicate = {
			label = "Duplica",
			tooltip = "Crea un nuovo profilo copiando i dati dal profilo attivo.",
		},
		rename = {
			label = "Rinomina",
			tooltip = "Rinomina il profilo attivo.",
			description = "Rinomina #PROFILE in:",
		},
		delete = {
			tooltip = "Elimina il profilo attivo.",
			warning = "Sei sicuro di voler rimuovere il profilo #PROFILE #ADDON attivo e cancellare definitivamente tutti i dati in esso contenuti?"
		},
		reset = {
			warning = "Sei sicuro di voler sovrascrivere il profilo #PROFILE #ADDON attivo con i valori predefiniti?",
		},
	},
	backup = {
		title = "Backup",
		description = "Importa o esporta i dati del profilo attivo per salvare, condividere o spostare le impostazioni, o modificare manualmente i valori.",
		box = {
			label = "Importa o Esporta Profilo Attuale",
			tooltip = {
				"La stringa di backup in questa casella contiene i dati del profilo attivo dell'addon.",
				"Copia il testo per salvare, condividere o caricare dati per un altro account.",
				"Per caricare dati da una stringa, sostituisci il testo in questa casella e premi " .. KEY_ENTER .. " o clicca sul pulsante #LOAD.",
				"Nota: Se usi file di font o texture personalizzati, questi file non verranno trasferiti con questa stringa. Dovranno essere salvati separatamente e inseriti nella cartella dell'addon per essere utilizzabili.",
				"Carica solo stringhe che hai verificato personalmente o di cui ti fidi della fonte!",
			},
		},
		allProfiles = {
			label = "Importa o Esporta Tutti i Profili",
			tooltipLine = "La stringa di backup in questa casella contiene l'elenco di tutti i profili dell'addon e i dati memorizzati in ciascuno, oltre al nome del profilo attivo.",
			open = {
				label = "Tutti i Profili",
				tooltip = "Accedi all'elenco completo dei profili e fai backup o modifica i dati memorizzati in ciascuno.",
			},
		},
		compact = {
			label = "Compatto",
			tooltip = "Alterna tra una visualizzazione compatta e una più leggibile/modificabile.",
		},
		load = {
			label = "Carica",
			tooltip = "Controlla la stringa attuale e prova a caricare i dati da essa.",
		},
		reset = {
			tooltip = "Annulla tutte le modifiche apportate alla stringa e ripristinala ai dati attualmente salvati.",
		},
		import = "Carica la stringa",
		warning = "Sei sicuro di voler tentare di caricare la stringa inserita?\n\nTutte le modifiche non salvate verranno annullate.\n\nSe l'hai copiata da una fonte online o qualcuno te l'ha inviata, caricala solo dopo aver controllato il codice e sapere cosa stai facendo.\n\nSe non ti fidi della fonte, annulla per evitare azioni indesiderate.",
		error = "La stringa di backup fornita non può essere validata e nessun dato è stato caricato. Potrebbero mancare caratteri o essere stati introdotti errori durante la modifica.",
	},
	position = {
		title = "Posizione",
		description = {
			static = "Regola la posizione di #FRAME sullo schermo tramite le opzioni qui fornite.",
			movable = "Trascina #FRAME tenendo premuto SHIFT per posizionarlo ovunque sullo schermo, regola qui.",
		},
		relativePoint = {
			label = "Punto di Collegamento Schermo",
			tooltip = "Collega il punto di ancoraggio scelto di #FRAME al punto selezionato qui.",
		},
		-- relativeTo = {
		-- 	label = "Collega a Frame",
		-- 	tooltip = "Digita il nome di un altro elemento UI, un frame a cui collegare la posizione di #FRAME.\n\nScopri i nomi dei frame attivando la UI di debug tramite il comando /framestack.",
		-- },
		anchor = {
			label = "Punto di Ancoraggio",
			tooltip = "Seleziona da quale punto #FRAME deve essere ancorato quando si collega al punto schermo scelto.",
		},
		keepInPlace = {
			label = "Mantieni in posizione",
			tooltip = "Non spostare #FRAME quando cambi #ANCHOR, aggiorna invece i valori di offset.",
		},
		offsetX= {
			label = "Offset Orizzontale",
			tooltip = "Imposta la quantità di offset orizzontale (asse X) di #FRAME dal #ANCHOR selezionato.",
		},
		offsetY = {
			label = "Offset Verticale",
			tooltip = "Imposta la quantità di offset verticale (asse Y) di #FRAME dal #ANCHOR selezionato.",
		},
		keepInBounds = {
			label = "Mantieni nei limiti dello schermo",
			tooltip = "Assicurati che #FRAME non possa essere spostato fuori dai limiti dello schermo.",
		},
	},
	presets = {
		apply = {
			label = "Applica un Predefinito",
			tooltip = "Cambia la posizione di #FRAME scegliendo e applicando uno di questi predefiniti.",
			list = { "Sotto la Minimap", },
			select = "Seleziona un predefinito…",
		},
		save = {
			label = "Aggiorna Predefinito #CUSTOM",
			tooltip = "Salva la posizione e la visibilità attuali di #FRAME nel predefinito #CUSTOM.",
			warning = "Sei sicuro di voler sovrascrivere il predefinito #CUSTOM con i valori attuali?",
		},
		reset = {
			label = "Ripristina Predefinito #CUSTOM",
			tooltip = "Sovrascrivi i dati salvati del predefinito #CUSTOM con i valori predefiniti e applicalo.",
			warning = "Sei sicuro di voler sovrascrivere il predefinito #CUSTOM con i valori predefiniti?",
		},
	},
	layer = {
		strata = {
			label = "Livello Schermo",
			tooltip = "Alza o abbassa #FRAME per essere davanti o dietro altri elementi UI.",
		},
		keepOnTop = {
			label = "Mostra all'interazione del mouse",
			tooltip = "Consenti a #FRAME di essere spostato sopra altri frame nello stesso #STRATA quando viene interagito.",
		},
		level = {
			label = "Livello del Frame",
			tooltip = "La posizione esatta di #FRAME sopra o sotto altri frame nello stesso stack #STRATA.",
		},
	},
	font = {
		title = "Testo",
		path = {
			label = "Carattere",
			tooltip = "Seleziona il carattere.",
			default = {
				label = "Predefinito localizzato",
				tooltip = "Questo è un carattere predefinito localizzato usato da Blizzard.",
			},
			base = "Questo è un carattere del gioco base.",
			custom = "Questo è un carattere personalizzato.",
			otf = "Licenza del font OpenType.",
			file = "Percorso del file: #PATH",
			replace = "L’opzione Personalizzato offre una completa personalizzazione permettendoti di usare qualsiasi carattere sostituendo il file #FILE_CUSTOM con un qualsiasi altro file TrueType trovato in\n#FONTS_DIRECTORY\nmantenendo il nome originale del file #FILE_CUSTOM.",
			reminder = "Potrebbe essere necessario riavviare completamente il client di gioco dopo aver sostituito il file del carattere per applicare la modifica.",
		},
		size = {
			label = "Dimensione",
			tooltip = "Imposta la dimensione del carattere.",
		},
		alignment = {
			label = "Allineamento",
			tooltip = "Seleziona l’allineamento orizzontale del testo.",
		},
		color = {
			label = "Colore #COLOR_TYPE",
			tooltip = "Imposta il colore del testo #COLOR_TYPE.",
		},
	},
	date = "#DAY/#MONTH/#YEAR",
	override = "Sovrascrivi",
	example = "Esempio",
}