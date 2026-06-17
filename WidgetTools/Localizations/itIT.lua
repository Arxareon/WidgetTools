--| Namespace

---@class namespace
local ns = select(2, ...)

--[ Changelog ]

ns.changelog = {
    {
        "#V_Version 3.0_# #H_(23/4/2026)_#",
        "#F_Hotfix (Versione 3.0.1):_#",
        "#H_Il supporto ai file di font personalizzati è stato ripristinato alla soluzione precedente (ora però gestita da Widget Tools) fino al prossimo aggiornamento, poiché una svista causava errori critici._# Ho anche rimosso diversi font per ridurre lo spazio su disco. Una volta completato e rilasciato il sistema pianificato per il supporto ai font completamente personalizzati, sarà possibile utilizzare qualsiasi numero di font personalizzati, rendendo inutile includerne così tanti nel pacchetto. #H_Per aggiungere un file di font personalizzato con questa soluzione temporanea, come prima, sostituisci_# #O_Interface/Addons/WidgetTools/Fonts/CUSTOM.ttf_# #H_con qualsiasi file TrueTypeFont, mantenendo esattamente questo nome._#",
        "Diversi font sono stati rimossi e non verranno più inclusi, poiché preferisco dare priorità a dimensioni di installazione più ridotte, e file di font molto grandi che offrono poco beneficio alla maggior parte degli utenti vanno contro questo obiettivo.",
        "Aggiunte informazioni Wago ID per aiutare Wago a trovare e scaricare automaticamente le dipendenze dell’addon.",
        "#N_Nuovo:_#",
        "Aggiunto il supporto per Midnight 12.0.5.",
        "È stata aggiunta una lista condivisa di font personalizzati a cui ora tutti gli addon possono accedere tramite la collezione globale #H_WidgetTools.resources_#. #H_Un file di font personalizzato chiamato_# #O_CUSTOM.ttf_# #H_può ora essere posizionato nella cartella principale_# #O_Fonts_# #H_all’interno della cartella del client di WoW_# per essere riconosciuto da Widget Tools. La gestione dei font personalizzati verrà ampliata nei futuri aggiornamenti.",
        "Introdotti nuovi strumenti di debug logging accessibili tramite la collezione globale #H_WidgetTools.debugging_#. Le funzionalità di debug verranno ampliate e integrate nelle Toolboxes nei prossimi aggiornamenti.",
        "#C_Modifiche:_#",
        "La struttura di caricamento della Toolbox è stata revisionata; le versioni precedenti non sono più supportate.",
        "Molte funzioni di utilità di base sono state trasferite a Widget Tools (e non sono più specifiche della Toolbox), accessibili globalmente tramite la collezione #H_WidgetTools.utilities_#.",
        "Il sistema backend di gestione degli eventi per gli handler OnEvent globali di Blizzard (e per eventi personalizzati) è stato aggiornato, con nuove utilità accessibili globalmente tramite la collezione #H_WidgetTools.utilities_#.",
        "La maggior parte delle annotazioni destinate esclusivamente allo sviluppo è stata spostata fuori dai file installati dell’addon, riducendo notevolmente la dimensione dell’installazione.",
        "Altre varie modifiche e miglioramenti interni.",
        "#F_Correzioni:_#",
        "Il menu contestuale di Widget Tools nel menu AddOns non occuperà più l’area cliccabile dello schermo dopo essere stato aperto una volta.",
        "Numerose altre piccole correzioni.",
        "#O_Nota:_# Consulta il changelog di Widget Toolbox nella pagina Toolboxes & Addons per ulteriori modifiche interne.",
        "#H_Grazie a tutti per l’aiuto, i suggerimenti e le segnalazioni di bug !_# Se riscontrate problemi, non esitate a segnalarli! Cercate di includere quando e come si verificano, e quali altri addon utilizzate (se rilevante), per darmi la migliore possibilità di riprodurli e correggerli. Fornite eventuali messaggi di errore Lua e log di taint se sapete come ottenerli.",
    },
    {
        "#V_Version 2.2_# #H_(23/2/2026)_#",
        "#F_Hotfix:_#",
        "Il testo nelle caselle di modifica verrà nuovamente ridimensionato correttamente per adattarsi alla larghezza delle caselle.",
    },
    {
        "#V_Version 2.2_# #H_(13/2/2026)_#",
        "#F_Hotfix:_#",
        "Il testo nelle caselle di modifica verrà nuovamente ridimensionato correttamente per adattarsi alla larghezza delle caselle.",
    },
    {
        "#V_Version 2.1_# #H_(13/2/2026)_#",
        "#N_Aggiornamenti:_#",
        "Aggiunto il supporto per Midnight 12.0.1, Mists of Pandaria 5.5.3, The Burning Crusade 2.5.5 e Classic 1.15.8.",
        "Miglioramenti interni.",
    },
    {
        "#V_Version 2.0_# #H_(8/6/2025)_#",
        "#N_Nuovo:_#",
        "Aggiunto il supporto per Mists of Pandaria Classic 5.5.0, The War Within 11.2 e Classic 1.15.7.",
        "Aggiunte localizzazioni tradotte tramite IA per tutte le lingue supportate da WoW. #H_Nota: Poiché queste traduzioni sono state generate da IA, contengono errori. Se desideri aiutarmi a correggerne alcune, o vuoi offrire volontariamente il tuo aiuto per tradurre correttamente questo addon nella tua lingua, contattami! Ogni aiuto e segnalazione di errore è immensamente apprezzato! <3_# (Il changelog sarà disponibile solo in inglese per ora.)",
        "#H_È stata introdotta una nuova modalità Lite !_# Quando attivata, nessuna pagina di impostazioni gestita da Widget Tools verrà caricata per gli addon costruiti con Widget Tools, risparmiando risorse. Disattivala per accedere nuovamente alle impostazioni visibili dell’addon. (I dati dell’addon vengono comunque caricati in background senza influire sulla funzionalità.)",
        "#H_Aggiunti aiuti visivi per il posizionamento !_# È stata introdotta un’opzione per attivare aiuti visivi di posizionamento per gli addon costruiti con Widget Tools, per aiutare a comprendere come funzionano le impostazioni avanzate di posizionamento e permettere un controllo preciso.",
        "Aggiunta un’opzione per gli sviluppatori per rendere più ampia la finestra Frame Attributes (TableAttributeDisplay Frame).",
        "Aggiunti comandi di chat per Widget Tools, usa: #H_/wt_#",
        "#H_#C_Modifiche_# & #F_Correzioni_#:_#",
        "L’aspetto delle caselle di controllo e delle pagine di impostazioni è stato aggiornato per allinearsi al nuovo stile delle impostazioni.",
        "Importanti miglioramenti interni e correzioni, oltre ad altre piccole modifiche.",
        "#V_Version 2.0.1_# • #F_Hotfix:_#",
        "I messaggi di benvenuto non verranno più ripetuti ogni volta che l’interfaccia viene caricata.",
        "La modalità Lite può ora essere attivata senza errori.",
        "L’aspetto della finestra di avviso di ricarica è stato regolato.",
    },
    {
        "#V_Version 1.12_# #H_(8/9/2023)_#",
        "#C_Modifiche:_#",
        "Le scorciatoie sono state rimosse dalla pagina principale delle impostazioni dell’addon in Classic.",
        "Miglioramenti interni.",
    },
    {
        "#V_Version 1.11_# #H_(7/18/2023)_#",
        "#C_Modifiche:_#",
        "Aggiunto il supporto per 1.14.4 (Classic) con retrocompatibilità per 1.14.3 (fino al rilascio della patch Hardcore).",
        "Migliorato lo scorrimento in WotLK Classic.",
        "Rimossa la retrocompatibilità che garantiva il funzionamento delle caselle di modifica con Toolbox versione 1.5.",
        "Altri piccoli miglioramenti.",
    },
    {
        "#V_Version 1.10_# #H_(6/15/2023)_#",
        "#N_Aggiornamenti:_#",
        "Aggiunto il supporto per 10.1.5 (Dragonflight).",
        "#F_Correzioni:_#",
        "Nessun tooltip rimarrà più sullo schermo dopo che il suo bersaglio è stato nascosto.",
        "Correzioni e miglioramenti interni.",
    },
    {
        "#V_Version 1.9_# #H_(5/17/2023)_#",
        "#C_Modifiche:_#",
        "Aggiornato al nuovo sistema di gestione dei loghi degli addon di Dragonflight. (I loghi personalizzati potrebbero non apparire nelle Opzioni Interfaccia nei client Classic.)",
        "#F_Correzioni:_#",
        "Risolto un problema in Dragonflight in cui alcune azioni venivano bloccate dopo la chiusura del pannello Impostazioni (ad esempio cambiando le associazioni dei tasti).",
        "La versione attuale ora funziona nel PTR di WotLK Classic 3.4.2, ma non è ancora completamente rifinita (poiché parti dell’interfaccia sono ancora in fase di modernizzazione).",
        "Ulteriori miglioramenti interni e pulizia del codice.",
    },
    {
        "#V_Version 1.8_# #H_(4/5/2023)_#",
        "#N_Aggiornamenti:_#",
        "Aggiunto il supporto per 10.1 (Dragonflight).",
        "#F_Correzioni:_#",
        "Le vecchie barre di scorrimento sono state sostituite con le nuove barre di Dragonflight, correggendo i bug emersi con la deprecazione in 10.1.",
        "Diverse altre correzioni e miglioramenti interni.",
    },
    {
        "#V_Version 1.7_# #H_(3/11/2023)_#",
        "#N_Aggiornamenti:_#",
        "Aggiunta un’opzione per disattivare gli addon che utilizzano Widget Toolboxes dalle impostazioni di Widget Tools.",
        "Aggiunto il supporto per 10.0.7 (Dragonflight).",
        "#C_Modifiche:_#",
        "La sezione Scorciatoie è stata rimossa dalla pagina principale delle impostazioni in Dragonflight (la nuova espansione ha rotto la funzionalità — potrei reinserirla se verrà risolta).",
        "Altre piccole modifiche.",
        "#F_Correzioni:_#",
        "Diverse correzioni e miglioramenti interni.",
    },
    {
        "#V_Version 1.6_# #H_(2/7/2023)_#",
        "#N_Aggiornamenti:_#",
        "È stata aggiunta una nuova sezione Sponsor alla pagina principale delle Impostazioni.\n#H_Grazie per il vostro supporto! Mi aiuta a continuare a dedicare tempo allo sviluppo e alla manutenzione di questi addon. Se state considerando di supportare lo sviluppo, seguite i link per vedere le opzioni disponibili._#",
        "Le informazioni Informazioni sono state riorganizzate e combinate con i link di Supporto.",
        "Ora verranno caricate solo le note dell’aggiornamento più recente. Il changelog completo è disponibile in una finestra più grande cliccando su un nuovo pulsante.",
        "Le caselle di controllo sono ora più facili da cliccare e i loro tooltip sono visibili anche quando l’input è disabilitato.",
        "Aggiunto il supporto per 10.0.5 (Dragonflight) e 3.4.1 (WotLK Classic).",
        "Numerose modifiche e miglioramenti minori.",
        "#F_Correzioni:_#",
        "Widget Tools non creerà più copie delle sue Impostazioni dopo ogni schermata di caricamento.",
        "Le impostazioni ora dovrebbero essere salvate correttamente in Dragonflight, e le funzionalità personalizzate Ripristina Predefiniti e Annulla Modifiche dovrebbero funzionare come previsto, per pagina di impostazioni (con l’opzione di ripristinare i predefiniti per l’intero addon).",
        "Tutti gli altri sottomenu contestuali personalizzati allo stesso livello ora dovrebbero chiudersi quando uno viene aperto (sono previste ulteriori migliorie ai menu contestuali in un aggiornamento futuro).",
        "Molte altre correzioni interne.",
    },
    {
        "#V_Version 1.5_# #H_(11/28/2020)_#",
        "#H_Widget Tools ha supportato altri addon in background per oltre un anno. Ora è stato separato in un addon autonomo per offrire maggiore visibilità, trasparenza e più possibilità di sviluppo._#",
        "#N_Aggiornamento:_#",
        "Aggiunto il supporto per Dragonflight (Retail 10.0) con retrocompatibilità.",
    }
}

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Italian
---@class widgetToolsStrings_itIT
ns.strings = {
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