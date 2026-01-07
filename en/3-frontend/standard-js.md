> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Estándar de Desarrollo JavaScript

Para mantener la consistencia, modularidad y evitar colisiones en el espacio global, todo desarrollo JavaScript en PHLEXMOD debe seguir el patrón de **Objeto Literal (Namespace)**.

## Estructura Base

Cada módulo JS debe encapsular su lógica dentro de una constante única.

```javascript
/** 
 * Nombre del Archivo: ejemplo.js
 * Descripción: Gestión de [Funcionalidad]
 * 
 * @package    PHLEXMOD-Framework
 * @subpackage Backend/modules/<namespace>/<modulo>/js
 */

const modEjemplo = {
    // =============================================
    // 1. CONFIGURACIÓN
    // =============================================
    config: {
        endpoints: {
            listar: `${PATH_ENDPOINTS}listar.api.php`,
            guardar: `${PATH_ENDPOINTS}guardar.api.php`
        },
        selectors: {
            tabla: '#tablaEjemplo',
            form: '#formEjemplo',
            modal: '#modalEjemplo'
        },
        mensajes: {
            error: 'Error de conexión',
            exito: 'Operación exitosa'
        }
    },

    // =============================================
    // 2. INICIALIZACIÓN
    // =============================================
    init: function() {
        this.cacheElements();
        this.bindEvents();
        this.inicializarComponentes();
    },

    cacheElements: function() {
        const s = this.config.selectors;
        this.$tabla = $(s.tabla);
        this.$form = $(s.form);
    },

    // =============================================
    // 3. EVENTOS
    // =============================================
    bindEvents: function() {
        this.$form.on('submit', this.onSubmit.bind(this));
    },

    // =============================================
    // 4. LÓGICA
    // =============================================
    onSubmit: function(e) {
        e.preventDefault();
        // Lógica de guardado...
    },

    // =============================================
    // 5. CARGA DE VISTAS Y COMPONENTES
    // =============================================
    
    /**
     * IMPORTANTE: Contenedor de Modales
     * El framework provee un contenedor global único en el layout principal (engine.php):
     * <div id="cargarModal"></div>
     * 
     * Todas las cargas de modales dinámicos DEBEN apuntar a este ID.
     */

    /**
     * Ejemplo: Cargar un modal desde UI
     */
    cargarModalEdicion: function(id) {
        // Usar PATH_UI para cargar vistas parciales (HTML/PHP)
        const url = `${PATH_UI}modal_editar.php`;
        
        // Usar contenedor estándar #cargarModal
        $('#cargarModal').load(url, { id: id }, function() {
            // Inicializar componentes tras la carga AJAX
            modEjemplo.inicializarSelect2();
            $('#modalEditar').modal('show');
        });
    },

    /**
     * Ejemplo: Cargar un script JS adicional (Lazy Loading)
     * Utilidad: Cargar lógica compleja solo cuando se necesita
     */
    cargarComponenteGraficas: function() {
        // Usar PATH_JS para cargar scripts del módulo
        const scriptUrl = `${PATH_JS}graficas_helper.js`;
        
        $.getScript(scriptUrl)
            .done(function() {
                // El script ya está cargado y ejecutado
                GraficasHelper.init('#miChart');
            })
            .fail(function() {
                console.error('No se pudo cargar el componente de gráficas');
            });
    }
};

// Auto-inicialización (Opcional, si el módulo lo requiere al cargar)
// $(document).ready(() => modEjemplo.init());
```

## Reglas de Oro

1.  **Encapsulamiento**: Nunca declarar funciones o variables sueltas en el root del archivo (`function miFuncion() {}`). Todo debe ser método o propiedad del objeto principal.
2.  **Selectores Centralizados**: Usar `this.config.selectors` para evitar strings mágicos (`$('#miId')`) dispersos por el código.
3.  **Endpoints Dinámicos**: Siempre prefijar con `${PATH_ENDPOINTS}` (inyectado por el sistema). Nunca hardcodear rutas relativas como `../../api/`.
4.  **Binding de Contexto**: Al pasar métodos como callbacks de eventos, usar `.bind(this)` para no perder la referencia al objeto módulo.
    *   *Correcto*: `.on('click', this.guardar.bind(this))`
    *   *Incorrecto*: `.on('click', this.guardar)` (el `this` dentro de guardar será el elemento DOM, no el módulo).

## Variables Globales Disponibles

El `ModuleLoader` y `engine.php` inyectan las siguientes constantes globales antes de cargar tu script:

*   `PATH_ENDPOINTS`: Ruta a la carpeta `endpoints/` del módulo actual.
*   `PATH_UI`: Ruta a la carpeta `ui/` del módulo actual.
*   `PATH_JS`: Ruta a la carpeta `js/` del módulo actual.
*   `PATH_CSS`: Ruta a la carpeta `css/` del módulo actual.
*   `IDENTIDAD`: ID del usuario logueado.
*   `TIPOROL`: Rol del usuario actual.

## Documentación (JSDoc)

Es obligatorio incluir bloques JSDoc para el archivo y para métodos complejos.

```javascript
/**
 * Envía los datos al servidor
 * @param {Object} data - Datos del formulario
 * @returns {Promise}
 */
guardarDatos: function(data) { ... }
```
