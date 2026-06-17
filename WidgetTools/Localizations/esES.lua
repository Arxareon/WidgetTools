--| Namespace

---@class namespace
local ns = select(2, ...)

--[ Changelog ]

ns.changelog = {
    {
        "#V_Version 3.0_# #H_(23/4/2026)_#",
        "#F_Corrección urgente (Versión 3.0.1):_#",
        "#H_El soporte para archivos de fuentes personalizadas ha sido revertido a la solución anterior (aunque ahora gestionado por Widget Tools) hasta la próxima actualización, debido a que un descuido provocaba errores críticos._# También he eliminado varias fuentes para ahorrar espacio en disco. Una vez que el soporte planificado para fuentes totalmente personalizadas esté terminado y publicado, se podrán usar cualquier cantidad de fuentes personalizadas, por lo que no habrá necesidad de incluir tantas fuentes. #H_Para añadir un archivo de fuente personalizado con esta solución temporal, igual que antes, sustituye_# #O_Interface/Addons/WidgetTools/Fonts/CUSTOM.ttf_# #H_por cualquier archivo TrueTypeFont, manteniendo exactamente este nombre de archivo._#",
        "Se han eliminado varias fuentes y ya no se incluirán, porque prefiero priorizar tamaños de archivo más pequeños, y tener archivos de fuentes grandes que aportan poco beneficio para la mayoría va en contra de ese objetivo.",
        "Se ha añadido información de Wago ID para ayudar a Wago a encontrar y descargar automáticamente las dependencias del addon.",
        "#N_Nuevo:_#",
        "Se añadió compatibilidad con Midnight 12.0.5.",
        "Se ha añadido una lista compartida de fuentes personalizadas a la que ahora todos los addons pueden acceder mediante la colección global #H_WidgetTools.resources_#. #H_Un archivo de fuente personalizado llamado_# #O_CUSTOM.ttf_# #H_puede colocarse ahora en la carpeta principal_# #O_Fonts_# #H_dentro de la carpeta del cliente de WoW_# para que Widget Tools lo reconozca. La gestión de archivos de fuentes personalizadas se ampliará en futuras actualizaciones.",
        "Se han introducido nuevas herramientas de registro de depuración accesibles mediante la colección global #H_WidgetTools.debugging_#. Las funciones de depuración se ampliarán y se integrarán en las Toolboxes en futuras actualizaciones.",
        "#C_Cambios:_#",
        "La estructura de carga de la Toolbox ha sido renovada; las versiones antiguas ya no son compatibles.",
        "Muchas funciones básicas de utilidad han sido transferidas a Widget Tools (y ya no son específicas de la Toolbox), accesibles globalmente mediante la colección #H_WidgetTools.utilities_#.",
        "El sistema backend de gestión de eventos que controla los handlers OnEvent globales de Blizzard (y eventos personalizados) para Frames ha sido actualizado, con nuevas utilidades accesibles globalmente mediante la colección #H_WidgetTools.utilities_#.",
        "La mayoría de las anotaciones destinadas solo al desarrollo se han movido fuera de los archivos instalados del addon para reducir considerablemente el tamaño de instalación.",
        "Varios otros cambios y mejoras internas.",
        "#F_Correcciones:_#",
        "El menú contextual del menú AddOns para Widget Tools ya no ocupará el espacio clicable de la pantalla después de abrirse una vez.",
        "Numerosas otras correcciones menores.",
        "#O_Nota:_# Consulta el registro de cambios de Widget Toolbox en la página de Toolboxes & Addons para más cambios internos.",
        "#H_¡Gracias a todos por la ayuda, sugerencias y reportes de errores !_# Si encontráis algún problema, no dudéis en reportarlo. Intentad incluir cuándo y cómo ocurre, y qué otros addons usáis (si es relevante), para darme la mejor oportunidad de reproducirlo y corregirlo. Intentad proporcionar mensajes de error de Lua y registros de taint si sabéis cómo obtenerlos.",
    },
    {
        "#V_Version 2.2_# #H_(23/2/2026)_#",
        "#F_Corrección urgente:_#",
        "El texto en los cuadros de edición volverá a ajustarse correctamente al ancho de las cajas.",
    },
    {
        "#V_Version 2.2_# #H_(13/2/2026)_#",
        "#F_Corrección urgente:_#",
        "El texto en los cuadros de edición volverá a ajustarse correctamente al ancho de las cajas.",
    },
    {
        "#V_Version 2.1_# #H_(13/2/2026)_#",
        "#N_Actualizaciones:_#",
        "Se añadió compatibilidad con Midnight 12.0.1, Mists of Pandaria 5.5.3, The Burning Crusade 2.5.5 y Classic 1.15.8.",
        "Mejoras internas.",
    },
    {
        "#V_Version 2.0_# #H_(8/6/2025)_#",
        "#N_Nuevo:_#",
        "Se añadió compatibilidad con Mists of Pandaria Classic 5.5.0, The War Within 11.2 y Classic 1.15.7.",
        "Se añadieron localizaciones traducidas por IA para todos los idiomas soportados por WoW. #H_Nota: Como estas traducciones fueron generadas por IA, contienen errores. Si quieres ayudarme a corregir algunas, o si deseas ofrecerte voluntariamente para traducir este addon correctamente a tu idioma, ¡ponte en contacto! Toda ayuda y reporte de errores es enormemente apreciado. <3_# (El registro de cambios solo estará disponible en inglés por ahora.)",
        "#H_¡Se ha introducido un nuevo modo Lite !_# Cuando está activado, no se cargarán las páginas de configuración gestionadas por Widget Tools para los addons construidos con Widget Tools, ahorrando recursos en el proceso. Desactívalo para acceder de nuevo a las configuraciones visibles del addon. (Los datos del addon siguen cargándose en segundo plano sin afectar a la funcionalidad.)",
        "#H_¡Añadidas ayudas visuales para el posicionamiento !_# Se ha añadido una opción para activar ayudas visuales de posicionamiento para addons construidos con Widget Tools, para ayudar a comprender cómo funcionan los ajustes avanzados de posicionamiento y permitir un control total del detalle.",
        "Se añadió una opción para que los desarrolladores puedan hacer más ancho el Frame de Atributos (TableAttributeDisplay Frame).",
        "Se añadieron comandos de chat para Widget Tools, usa: #H_/wt_#",
        "#H_#C_Cambios_# & #F_Correcciones_#:_#",
        "La apariencia de las casillas de verificación y las páginas de configuración se ha actualizado para coincidir con el nuevo estilo de ajustes.",
        "Importantes mejoras internas y correcciones, además de otros cambios y arreglos menores.",
        "#V_Version 2.0.1_# • #F_Corrección urgente:_#",
        "Los mensajes de bienvenida ya no se repetirán cada vez que se cargue la interfaz.",
        "El modo Lite ahora puede activarse sin errores.",
        "Se ajustó la apariencia de la ventana de aviso de recarga.",
    },
    {
        "#V_Version 1.12_# #H_(8/9/2023)_#",
        "#C_Cambios:_#",
        "Se han eliminado los accesos directos de la página principal de configuración del addon en Classic.",
        "Mejoras internas.",
    },
    {
        "#V_Version 1.11_# #H_(7/18/2023)_#",
        "#C_Cambios:_#",
        "Se añadió compatibilidad con 1.14.4 (Classic) con retrocompatibilidad con 1.14.3 (hasta que el parche Hardcore esté activo).",
        "Se mejoró el desplazamiento en WotLK Classic.",
        "Se eliminó la retrocompatibilidad que garantizaba que los cuadros de edición funcionaran con Toolbox versión 1.5.",
        "Otras pequeñas mejoras.",
    },
    {
        "#V_Version 1.10_# #H_(6/15/2023)_#",
        "#N_Actualizaciones:_#",
        "Se añadió compatibilidad con 10.1.5 (Dragonflight).",
        "#F_Correcciones:_#",
        "Ningún tooltip permanecerá en pantalla después de que su objetivo haya sido ocultado.",
        "Correcciones y mejoras internas.",
    },
    {
        "#V_Version 1.9_# #H_(5/17/2023)_#",
        "#C_Cambios:_#",
        "Actualizado al nuevo sistema de logos de addons de Dragonflight. (Los logos personalizados pueden no aparecer en las Opciones de Interfaz en clientes Classic.)",
        "#F_Correcciones:_#",
        "Se corrigió un problema en Dragonflight donde ciertas acciones quedaban bloqueadas tras cerrar el panel de Configuración (por ejemplo, al cambiar atajos de teclado).",
        "La versión actual ahora funciona en el PTR de WotLK Classic 3.4.2, aunque aún no está completamente pulida (ya que partes de la interfaz siguen modernizándose).",
        "Otras mejoras internas y limpieza de código.",
    },
    {
        "#V_Version 1.8_# #H_(4/5/2023)_#",
        "#N_Actualizaciones:_#",
        "Se añadió compatibilidad con 10.1 (Dragonflight).",
        "#F_Correcciones:_#",
        "Las barras de desplazamiento antiguas han sido reemplazadas por las nuevas de Dragonflight, corrigiendo los errores que surgieron con 10.1 debido a la obsolescencia.",
        "Varias otras correcciones y mejoras internas.",
    },
    {
        "#V_Version 1.7_# #H_(3/11/2023)_#",
        "#N_Actualizaciones:_#",
        "Se añadió una opción para desactivar addons que usan Widget Toolboxes desde la configuración de Widget Tools.",
        "Se añadió compatibilidad con 10.0.7 (Dragonflight).",
        "#C_Cambios:_#",
        "La sección de Accesos Directos se ha eliminado de la página principal de configuración en Dragonflight (la nueva expansión rompió la función; podría volver si se soluciona).",
        "Otras pequeñas mejoras.",
        "#F_Correcciones:_#",
        "Varias correcciones y mejoras internas.",
    },
    {
        "#V_Version 1.6_# #H_(2/7/2023)_#",
        "#N_Actualizaciones:_#",
        "Se añadió una nueva sección de Patrocinadores a la página principal de Configuración.\n#H_¡Gracias por vuestro apoyo! Me ayuda a seguir dedicando tiempo al desarrollo y mantenimiento de estos addons. Si estás considerando apoyar el desarrollo, sigue los enlaces para ver las opciones disponibles._#",
        "La información de Acerca de se ha reorganizado y combinada con los enlaces de Soporte.",
        "Ahora solo se cargarán las notas de actualización más recientes. El registro de cambios completo está disponible en una ventana más grande al hacer clic en un nuevo botón.",
        "Las casillas de verificación ahora son más fáciles de pulsar, y sus tooltips son visibles incluso cuando la entrada está deshabilitada.",
        "Se añadió compatibilidad con 10.0.5 (Dragonflight) y 3.4.1 (WotLK Classic).",
        "Numerosos cambios y mejoras menores.",
        "#F_Correcciones:_#",
        "Widget Tools ya no creará copias de su Configuración tras cada pantalla de carga.",
        "Las configuraciones deberían guardarse correctamente en Dragonflight, y las funciones personalizadas de Restaurar Valores Predeterminados y Revertir Cambios deberían funcionar como se espera, por página de configuración (manteniendo la opción de restaurar valores predeterminados para todo el addon).",
        "Todos los demás submenús contextuales personalizados del mismo nivel deberían cerrarse ahora cuando uno se abre (más mejoras al menú contextual llegarán en una versión futura).",
        "Muchas otras correcciones internas.",
    },
    {
        "#V_Version 1.5_# #H_(11/28/2020)_#",
        "#H_Widget Tools ha estado dando soporte a otros addons en segundo plano durante más de un año. Ahora ha sido separado en su propio addon para ofrecer mayor visibilidad, transparencia y más opciones de desarrollo._#",
        "#N_Actualización:_#",
        "Se añadió compatibilidad con Dragonflight (Retail 10.0) con retrocompatibilidad.",
    }
}

--[ Strings ]

--NOTE: #FLAGS will be replaced by text or number values via code; \n represents the newline character

---Spanish (Spain)
---@class widgetToolsStrings_esES
ns.strings = {
	about = {
		version = "Versión: #VERSION",
		date = "Fecha: #DATE",
		author = "Autor: #AUTHOR",
		license = "Licencia: #LICENSE",
		toggle = {
			label = "Activado",
			tooltip = "Desmarca para desactivar este addon.\n\nEste cambio solo tendrá efecto después de recargar la interfaz. Una vez desactivado, este addon no aparecerá en esta lista hasta que se vuelva a activar en el menú principal de AddOns.",
		},
	},
	specifications = {
		title = "Especificaciones",
		description = "Ajusta y activa/desactiva funciones opcionales. Escribe /wt en el chat para usar comandos.",
		general = {
			title = "General",
			description = "Opciones que afectan a todos los addons dependientes.",
			lite = {
				label = "Modo Lite",
				tooltip = "Desactiva la configuración de TODOS los addons que usan Widget Toolboxes para ahorrar recursos y hacer que la interfaz cargue más rápido.\nLos datos de configuración de los addons seguirán guardándose y cargándose en segundo plano, y el control por chat seguirá disponible para los addons que lo usen.\n\nPara desactivar el Modo Lite y volver a activar la configuración, usa el comando de chat #COMMAND o haz clic en Widget Tools en la lista de AddOns bajo el botón del calendario en la cabecera del Minimapa (no disponible en Classic).",
			},
			positioningAids = {
				label = "Ayudas Visuales de Posicionamiento",
				tooltip = "Muestra ayudas visuales al posicionar marcos mediante los widgets de configuración de addons que usan Widget Toolboxes.",
			},
		},
		dev = {
			title = "Herramientas de Desarrollo",
			frameAttributes = {
				enabled = {
					label = "Redimensionar atributos del marco",
					tooltip = "Personaliza el ancho de la tabla dentro de la ventana de Atributos del Marco (TableAttributeDisplay Frame).",
				},
				width = {
					label = "Ancho de los atributos del marco",
					tooltip = "Especifica el ancho de la tabla de contenido desplazable en la ventana de Atributos del Marco.",
				},
			},
		},
	},
	toolboxes = {
		title = "Toolboxes y Addons",
		description = "Lista de los addons actualmente cargados que usan versiones específicas de las toolboxes #ADDON registradas.",
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Haz clic para abrir configuraciones específicas.",
		lite = "El modo Lite está activado. Haz clic para desactivar.",
	},
	lite = {
		enable = {
			warning = "Cuando #ADDON está en Modo Lite, la interfaz de configuración de los addons dependientes no se cargará.\n\n¿Seguro que quieres activar el Modo Lite y desactivar la funcionalidad completa de la configuración?",
			accept = "Activar Modo Lite",
		},
		disable = {
			warning = "#ADDON está en Modo Lite, la interfaz de configuración de los addons dependientes no se ha cargado.\n\n¿Deseas desactivar el Modo Lite para volver a activar la configuración con funcionalidad completa?",
			accept = "Desactivar Modo Lite",
		},
	},
	chat = {
		about = {
			description = "Abre la página de información de Widget Tools",
		},
		lite = {
			description = "Alternar Modo Lite: cargar o no la configuración de los addons dependientes",
			response = "El Modo Lite estará #STATE después de recargar la interfaz.",
			reminder = "El Modo Lite está activado, la configuración de los addons dependientes no se ha cargado.\n#HINT",
			hint = "Escribe #COMMAND para desactivar el Modo Lite.",
		},
	},
	separator = ".", -- Separador de miles
	decimal = ",", -- Carácter decimal
}