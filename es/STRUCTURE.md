# Estructura de Módulos MIA (PHLEXMOD) v2.0.1

*Framework PHLEXMOD v2.0.1*  
*Arquitectura MIA v2.0.1*  
*Última actualización: 2025-12-30*  

> **Nota:** Para comprender la filosofía detrás de esta estructura, lee nuestro [Manifiesto](./1-introduccion/MANIFESTO.md).

Este documento define la estructura estándar de directorios y archivos para los módulos en PHLEXMOD, bajo la arquitectura MIA (Modular Isolation Architecture).

## Herramientas de Desarrollo (CLI)

Phlexmod incluye una poderosa interfaz de línea de comandos (`phlexmod`) diseñada para automatizar el ciclo de vida del desarrollo y garantizar la adherencia a la arquitectura MIA.

### Comandos Principales

#### 1. Crear Módulo (`make:module`)

Genera la estructura completa de un módulo y **lo registra automáticamente en la base de datos**, dejándolo listo para usar.

`./phlexmod make:module [nombre] [--scope=admin|user] [--type=simple|advanced]`

- **Crea:** Directorios `ui`, `js`, `endpoints`, `css`.
- **Genera:** Archivos con boilerplate educativo y funcional.
- **Registra:** Inserta el módulo en `setting_menu` y asigna permisos al admin.

#### 2. Crear Endpoint (`make:endpoint`)

Añade una nueva API REST al módulo siguiendo las convenciones de seguridad y respuesta JSON.

`./phlexmod make:endpoint [modulo] [nombre]`

#### 3. Escanear Cabeceras (`headers:scan`)

Herramienta de mantenimiento que asegura que todos los archivos tengan las cabeceras de licencia correctas (útil para CI/CD).

`./phlexmod headers:scan`

#### 4. Auditoría de Salud (`module:health`)

Escanea todos los módulos para verificar que cumplan con la arquitectura MIA (estructura de carpetas, archivos críticos y registro en base de datos).

`./phlexmod module:health`

---

## Estructura de Directorios

Cada módulo reside en `backend/modules/[scope]/[nombre_modulo]` y sigue esta estructura:

``

[nombre_modulo]/
├── endpoints/          # APIs y Controladores PHP (Backend puro)
├── js/                 # Lógica de Cliente (JavaScript)
├── ui/                 # Interfaz de Usuario (HTML/PHP)
│   ├── [nombre].main.ui.php   # Punto de entrada de la UI
│   ├── [nombre].modal.ui.php  # Plantilla única de Modal
│   └── [nombre].*.ui.php      # Otros fragmentos (form, table, etc.)
├── classes/            # Clases PHP específicas del módulo
├── docs/               # Documentación interna del módulo
├── [nombre_modulo].php # Entry Point del Módulo
└── install.sql         # Script de instalación (Menú y Privilegios)

``

## Detalle de Componentes

### 1. UI (Interfaz de Usuario)

La carpeta `ui` contiene toda la presentación visual. En la arquitectura MIA, **no se utiliza una subcarpeta `views/`**. Todos los fragmentos de interfaz residen directamente en `ui/` y siguen una convención de nombres estricta para identificar su propósito.

**Convención de Nombres (*.ui.php):**

- `[nombre].main.ui.php`: Vista principal del módulo (cargada por el Entry Point).
- `[nombre].modal.ui.php`: Estructura de ventana modal.
- `[nombre].form.ui.php`: Formularios (creación/edición).
- `[nombre].table.ui.php`: Tablas de datos.
- `[nombre].filter.ui.php`: Barras de filtros.

**Ejemplo:**

- `tesoreria.main.ui.php`
- `tesoreria.modal.ui.php`
- `tesoreria.form.ui.php`

Esta convención plana facilita la localización de archivos y evita la anidación innecesaria.

### 2. Modals (Gestión de Ventanas Modales)

En la arquitectura MIA, se recomienda utilizar un archivo `*.modal.ui.php` que defina la estructura base (shell) de la modal.

- **Ubicación:** `ui/[nombre_modulo].modal.ui.php`
- **Propósito:** Proporcionar el contenedor HTML para las modales.
- **Funcionamiento:**
    1. Se incluye en el archivo principal (`*.main.ui.php`).
    2. El contenido (Title, Body, Footer) se inyecta dinámicamente mediante JavaScript.

**Ejemplo de Estructura ([nombre].modal.ui.php):**

```html
<div class="modal fade" id="moduleModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="moduleModalTitle">Título</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" id="moduleModalBody">
        <!-- Contenido dinámico aquí -->
      </div>
      <div class="modal-footer" id="moduleModalFooter">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-primary" id="moduleModalAction">Guardar</button>
      </div>
    </div>
  </div>
</div>
```

### 3. JS (Lógica de Cliente)

El archivo JS principal (`js/[nombre_modulo].js`) debe contener la lógica para manipular la modal única.

**Métodos recomendados en el Manager:**

- `openModal(title, content)`: Abre la modal con contenido estático.
- `loadModal(title, url)`: Carga contenido asíncrono en la modal.

### 4. Endpoints

- Deben retornar JSON o HTML parcial (para las vistas).
- Se recomienda separar la lógica de negocio en `classes/`.

---

**Nota:** Esta estructura busca reducir la redundancia y facilitar el mantenimiento. Evite crear un archivo `modal_*.php` para cada acción (crear, editar, eliminar); reutilice la plantilla `generic.modal.php`.

## Convenciones de Nomenclatura

### Regla de Oro: Coherencia en Puntos de Entrada

Para que el motor (`engine.php`) y el cargador dinámico (`module-loader.js`) funcionen correctamente, los archivos principales deben compartir el mismo nombre base que el módulo.

**Ejemplo para un módulo llamado `inventario`:**

- **Entry Point PHP:** `inventario.php` (Debe coincidir con el campo `enlace` en la BD)
- **JavaScript Principal:** `js/inventario.js` (Cargado automáticamente)
- **Hoja de Estilos:** `css/inventario.css` (Cargada automáticamente)

> **¿Por qué?** El sistema deduce los nombres de los recursos estáticos (JS/CSS) basándose en el nombre del archivo PHP de entrada. Si no coinciden, el módulo cargará pero no tendrá su lógica ni estilos asociados.

### Contra-Extensiones
