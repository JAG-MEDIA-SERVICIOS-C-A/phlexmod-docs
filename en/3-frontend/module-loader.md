> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Cargador de módulos (Frontend) — `ModuleLoader`

## Propósito

`ModuleLoader` gestiona la carga dinámica del JS/CSS de cada módulo, a partir del nombre del archivo PHP de entrada y de una ruta cifrada generada por el backend.

**Origen (código fuente)**:
- `frontend/assets/js/module-loader.js`
- `backend/engine.php`
- `backend/core/api-endpoint.php`

## Flujo de carga (resumen)

1. `backend/engine.php` resuelve el módulo (menú/privilegios) y define la ruta física del módulo.
2. `backend/engine.php` cifra la ruta base del módulo (normalmente el `js/` del módulo) y llama a `ModuleLoader.init(...)`.
3. `ModuleLoader` llama al endpoint de desencriptación (`backend/core/api-endpoint.php`) para obtener una ruta utilizable en el cliente.
4. Según la respuesta, `ModuleLoader` usa:
   - **Proxy** (`load_resource.php?r=...&f=`) para cargar `../css/<modulo>.css` y `<modulo>.js`, o
   - **Legacy** (ruta directa) reemplazando `js/` por `endpoints/`, `ui/`, `css/`.

## Variables globales expuestas

| Variable | Descripción | Fuente |
|---|---|---|
| `window.PATH_JS` | Base para cargar JS del módulo | `frontend/assets/js/module-loader.js` |
| `window.PATH_CSS` | Base para cargar CSS del módulo | `frontend/assets/js/module-loader.js` |
| `window.PATH_ENDPOINTS` | Base para endpoints del módulo | `frontend/assets/js/module-loader.js` |
| `window.PATH_UI` | Base para UI del módulo | `frontend/assets/js/module-loader.js` |
| `window.IDENTIDAD` | Identidad (sesión) | `backend/engine.php` → `ModuleLoader.init()` |
| `window.TIPOROL` | Rol/tipo de usuario (sesión) | `backend/engine.php` → `ModuleLoader.init()` |

## Contrato esperado de archivos por módulo

`ModuleLoader` deriva el nombre del módulo desde `documentphp` (ej. `email.php` → `email`).

- **CSS**: `../css/<modulo>.css`
- **JS**: `<modulo>.js` (asumiendo base `js/`)

Si no existen, el loader **no bloquea** (solo `console.warn`).

**Origen (código fuente)**:
- Manejo no bloqueante: `frontend/assets/js/module-loader.js` (`cargarCSS`, `cargarJS`).

## Ejemplo (config inicial desde engine)

La configuración se entrega desde el backend en un bloque `<script>`.

**Origen (código fuente)**: `backend/engine.php`.

```html
<script type="text/javascript">
  ModuleLoader.init({
    pathEncriptado: '...',
    documentphp: 'email.php',
    directorio: 'admin/email/',
    endpoint: '...',
    identidad: '...',
    tiporol: '...'
  });
</script>
```
