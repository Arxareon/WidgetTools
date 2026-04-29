--| Locale

if GetLocale() ~= "esES" then return end

--| Toolbox

---@type toolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "Version")]

if not wt then return end

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Spanish (Spain)
---@class toolboxStrings_esES
wt.strings = {
	chat = {
		welcome = {
			thanks = "¡Gracias por usar #ADDON!",
			hint = "Escribe #KEYWORD para ver la lista de comandos de chat.",
			keywords = "#KEYWORD o #KEYWORD_ALTERNATE",
		},
		help = {
			list = "Lista de comandos de chat de #ADDON:",
		},
	},
	popupInput = {
		title = "Especifica el texto",
		tooltip = "Pulsa " .. KEY_ENTER .. " para aceptar el texto especificado o " .. KEY_ESCAPE .. " para descartarlo."
	},
	reload = {
		title = "Cambios Pendientes",
		description = "Recarga la interfaz para aplicar los cambios pendientes.",
		accept = {
			label = "Recargar Ahora",
			tooltip = "Puedes elegir recargar la interfaz ahora para aplicar los cambios pendientes.",
		},
		cancel = {
			label = "Más tarde",
			tooltip = "Recarga la interfaz más tarde con el comando /reload o cerrando sesión.",
		},
	},
	multiSelector = {
		locked = "Bloqueado",
		minLimit = "Debes seleccionar al menos #MIN opciones.",
		maxLimit = "Solo se pueden seleccionar #MAX opciones a la vez.",
	},
	dropdown = {
		selected = "Esta es la opción seleccionada actualmente.",
		none = "No se ha seleccionado ninguna opción.",
		open = "Haz clic para ver la lista de opciones.",
		previous = {
			label = "Opción anterior",
			tooltip = "Seleccionar la opción anterior.",
		},
		next = {
			label = "Siguiente opción",
			tooltip = "Seleccionar la siguiente opción.",
		},
		clear = "Borrar selección",
	},
	copyBox = "Copia el texto pulsando:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Especifica el valor",
			tooltip = "Introduce cualquier valor dentro del rango.",
		},
		decrease = {
			label = "Disminuir",
			tooltip = {
				"Resta #VALUE al valor.",
				"Mantén ALT para restar #VALUE en su lugar.",
			},
		},
		increase = {
			label = "Aumentar",
			tooltip = {
				"Suma #VALUE al valor.",
				"Mantén ALT para sumar #VALUE en su lugar.",
			},
		},
	},
	color = {
		picker = {
			label = "Elige un color",
			tooltip = "Abre el selector de color para personalizar el color#ALPHA.",
			alpha = " y cambiar la opacidad",
		},
		hex = {
			label = "Añadir por código HEX",
			tooltip = "Puedes cambiar el color usando un código HEX en vez del selector de color.",
		}
	},
	settings = {
		save = "Los cambios se aplicarán al cerrar.",
		cancel = {
			label = "Revertir Cambios",
			tooltip = "Descarta todos los cambios realizados en esta página y carga los valores guardados.",
		},
		defaults = {
			label = "Restaurar Valores Predeterminados",
			tooltip = "Restaura todos los ajustes de esta página (o de toda la categoría) a los valores predeterminados.",
		},
		warning = "¿Seguro que quieres restablecer los ajustes de la página #PAGE o todos los ajustes de la categoría #CATEGORY a los valores predeterminados?",
		warningSingle = "¿Seguro que quieres restablecer los ajustes de la página #PAGE a los valores predeterminados?",
	},
	value = {
		copy = "Copiar valor",
		paste = "Pegar valor",
		revert = "Revertir Cambios",
		restore = "Restaurar Predeterminado",
		note = "Haz clic derecho para copiar o revertir.",
	},
	points = {
		left = "Izquierda",
		right = "Derecha",
		center = "Centro",
		top = {
			left = "Arriba Izquierda",
			right = "Arriba Derecha",
			center = "Arriba Centro",
		},
		bottom = {
			left = "Abajo Izquierda",
			right = "Abajo Derecha",
			center = "Abajo Centro",
		},
	},
	strata = {
		lowest = "Fondo Bajo",
		lower = "Fondo Medio",
		low = "Fondo Alto",
		lowMid = "Medio Bajo",
		highMid = "Medio Alto",
		high = "Primer Plano Bajo",
		higher = "Primer Plano Medio",
		highest = "Primer Plano Alto",
	},
	about = {
		title = "Acerca de",
		description = "¡Gracias por usar #ADDON! Copia los enlaces para saber cómo enviar comentarios, obtener ayuda y apoyar el desarrollo.",
		version = "Versión",
		date = "Fecha",
		author = "Autor",
		license = "Licencia",
		curseForge = "Página de CurseForge",
		wago = "Página de Wago",
		repository = "Repositorio GitHub",
		issues = "Incidencias y Comentarios",
		changelog = {
			label = "Notas de Actualización",
			tooltip = "Notas de todos los cambios, actualizaciones y correcciones introducidos en la última versión: #VERSION.",
		},
		fullChangelog = {
			label = "Historial de #ADDON",
			tooltip = "La lista completa de notas de actualización de todas las versiones del addon.",
			open = {
				label = "Historial",
				tooltip = "Lee la lista completa de notas de actualización de todas las versiones del addon.",
			},
		},
	},
	sponsors = {
		title = "Patrocinadores",
		description = "¡Tu apoyo continuo es muy apreciado! ¡Gracias!",
	},
	dataManagement = {
		title = "Gestión de Datos",
		description = "Configura más opciones de #ADDON gestionando perfiles y copias de seguridad mediante importación y exportación.",
	},
	profiles = {
		title = "Perfiles",
		description = "Crea, edita y aplica perfiles de opciones únicos para cada uno de tus personajes.",
		select = {
			label = "Seleccionar un Perfil",
			tooltip = "Elige el perfil de almacenamiento de opciones que se usará para tu personaje actual.\n\n¡Los datos del perfil activo se sobrescribirán automáticamente al modificar y guardar los ajustes!",
			profile = "Perfil",
			main = "Principal",
		},
		new = {
			label = "Nuevo Perfil",
			tooltip = "Crear un nuevo perfil predeterminado.",
		},
		duplicate = {
			label = "Duplicar",
			tooltip = "Crear un nuevo perfil copiando los datos del perfil activo.",
		},
		rename = {
			label = "Renombrar",
			tooltip = "Renombrar el perfil activo.",
			description = "Renombrar #PROFILE a:",
		},
		delete = {
			tooltip = "Eliminar el perfil activo.",
			warning = "¿Seguro que quieres eliminar el perfil de ajustes #PROFILE #ADDON activo y borrar permanentemente todos los datos almacenados en él?"
		},
		reset = {
			warning = "¿Seguro que quieres sobrescribir el perfil de ajustes #PROFILE #ADDON activo con los valores predeterminados?",
		},
	},
	backup = {
		title = "Copia de Seguridad",
		description = "Importa o exporta los datos del perfil activo para guardar, compartir o mover ajustes, o editar valores manualmente.",
		box = {
			label = "Importar o Exportar Perfil Actual",
			tooltip = {
				"La cadena de copia de seguridad en esta caja contiene los datos del perfil activo del addon.",
				"Copia el texto para guardar, compartir o cargar datos para otra cuenta.",
				"Para cargar datos desde una cadena, reemplaza el texto en esta caja y pulsa " .. KEY_ENTER .. " o haz clic en el botón #LOAD.",
				"Nota: Si usas archivos de fuentes o texturas personalizados, esos archivos no se transferirán con esta cadena. Deberás guardarlos aparte y pegarlos en la carpeta del addon para poder usarlos.",
				"¡Solo carga cadenas que hayas verificado tú mismo o en las que confíes en la fuente!",
			},
		},
		allProfiles = {
			label = "Importar o Exportar Todos los Perfiles",
			tooltipLine = "La cadena de copia de seguridad en esta caja contiene la lista de todos los perfiles del addon y los datos almacenados en cada uno, así como el nombre del perfil activo.",
			open = {
				label = "Todos los Perfiles",
				tooltip = "Accede a la lista completa de perfiles y haz copia de seguridad o modifica los datos almacenados en cada uno.",
			},
		},
		compact = {
			label = "Compacto",
			tooltip = "Alterna entre una vista compacta y una más legible/editable.",
		},
		load = {
			label = "Cargar",
			tooltip = "Comprueba la cadena actual e intenta cargar los datos desde ella.",
		},
		reset = {
			tooltip = "Descarta todos los cambios realizados en la cadena y restáurala para que contenga los datos actualmente guardados.",
		},
		import = "Cargar la cadena",
		warning = "¿Seguro que quieres intentar cargar la cadena insertada?\n\nTodos los cambios no guardados se descartarán.\n\nSi la has copiado de una fuente online o alguien te la ha enviado, solo cárgala después de revisar el código y saber lo que haces.\n\nSi no confías en la fuente, cancela para evitar acciones no deseadas.",
		error = "La cadena de copia de seguridad proporcionada no se pudo validar y no se cargaron datos. Puede que falten caracteres o se hayan introducido errores al editarla.",
	},
	position = {
		title = "Posición",
		description = {
			static = "Ajusta la posición de #FRAME en la pantalla con las opciones proporcionadas aquí.",
			movable = "Arrastra y suelta #FRAME manteniendo SHIFT para colocarlo en cualquier parte de la pantalla, ajústalo aquí.",
		},
		relativePoint = {
			label = "Punto de Anclaje en Pantalla",
			tooltip = "Vincula el punto de anclaje elegido de #FRAME al punto seleccionado aquí.",
		},
		-- relativeTo = {
		-- 	label = "Vincular a Marco",
		-- 	tooltip = "Escribe el nombre de otro elemento de la interfaz, un marco al que vincular la posición de #FRAME.\n\nDescubre los nombres de los marcos activando la interfaz de depuración con el comando /framestack.",
		-- },
		anchor = {
			label = "Punto de Anclaje",
			tooltip = "Selecciona desde qué punto debe anclarse #FRAME al vincularlo al punto de pantalla elegido.",
		},
		keepInPlace = {
			label = "Mantener en su sitio",
			tooltip = "No muevas #FRAME al cambiar el #ANCHOR, actualiza los valores de desplazamiento en su lugar.",
		},
		offsetX= {
			label = "Desplazamiento Horizontal",
			tooltip = "Establece la cantidad de desplazamiento horizontal (eje X) de #FRAME desde el #ANCHOR seleccionado.",
		},
		offsetY = {
			label = "Desplazamiento Vertical",
			tooltip = "Establece la cantidad de desplazamiento vertical (eje Y) de #FRAME desde el #ANCHOR seleccionado.",
		},
		keepInBounds = {
			label = "Mantener en los límites de la pantalla",
			tooltip = "Asegúrate de que #FRAME no pueda moverse fuera de los límites de la pantalla.",
		},
	},
	presets = {
		apply = {
			label = "Aplicar un Preajuste",
			tooltip = "Cambia la posición de #FRAME eligiendo y aplicando uno de estos preajustes.",
			list = { "Debajo del Minimapa", },
			select = "Selecciona un preajuste…",
		},
		save = {
			label = "Actualizar Preajuste #CUSTOM",
			tooltip = "Guarda la posición y visibilidad actual de #FRAME en el preajuste #CUSTOM.",
			warning = "¿Seguro que quieres sobrescribir el preajuste #CUSTOM con los valores actuales?",
		},
		reset = {
			label = "Restablecer Preajuste #CUSTOM",
			tooltip = "Sobrescribe los datos guardados del preajuste #CUSTOM con los valores predeterminados y aplícalo.",
			warning = "¿Seguro que quieres sobrescribir el preajuste #CUSTOM con los valores predeterminados?",
		},
	},
	layer = {
		strata = {
			label = "Capa de Pantalla",
			tooltip = "Sube o baja #FRAME para que esté delante o detrás de otros elementos de la interfaz.",
		},
		keepOnTop = {
			label = "Mostrar al interactuar con el ratón",
			tooltip = "Permite que #FRAME se mueva por encima de otros marcos en la misma #STRATA al interactuar con él.",
		},
		level = {
			label = "Nivel del Marco",
			tooltip = "La posición exacta de #FRAME por encima o por debajo de otros marcos en la misma pila #STRATA.",
		},
	},
	font = {
		title = "Texto",
		path = {
			label = "Fuente",
			tooltip = "Selecciona la fuente.",
			default = {
				label = "Predeterminada localizada",
				tooltip = "Esta es una fuente predeterminada localizada utilizada por Blizzard.",
			},
			base = "Esta es una fuente del juego base.",
			custom = "Esta es una fuente personalizada.",
			otf = "Licencia de fuente OpenType.",
			file = "Ruta del archivo: #PATH",
			replace = "La opción Personalizada ofrece una personalización completa, permitiéndote usar cualquier fuente sustituyendo el archivo #FILE_CUSTOM por cualquier otro archivo TrueType encontrado en\n#FONTS_DIRECTORY\nmanteniendo el nombre original del archivo #FILE_CUSTOM.",
			reminder = "Puede que necesites reiniciar completamente el cliente del juego después de reemplazar el archivo de fuente para aplicar el cambio.",
		},
		size = {
			label = "Tamaño",
			tooltip = "Establece el tamaño de la fuente.",
		},
		alignment = {
			label = "Alineación",
			tooltip = "Selecciona la alineación horizontal del texto.",
		},
		color = {
			label = "Color de #COLOR_TYPE",
			tooltip = "Establece el color del texto #COLOR_TYPE.",
		},
	},
	date = "#DAY/#MONTH/#YEAR",
	override = "Sobrescribir",
	example = "Ejemplo",
}