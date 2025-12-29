# Documentación Técnica y de Desarrollo - PHLEXMOD Framework

Este documento consolida la información técnica, guía de desarrollo y registro de cambios para el framework PHLEXMOD.

## 1. Registro de Cambios Recientes (Changelog)

### Solución a Problemas de Carga y Estabilidad (19/12/2025)

#### Corrección en `load_resource.php` (Proxy de Recursos)

- **Problema:** Los módulos fallaban al cargar recursos CSS y endpoints (Error 403 Forbidden y MIME types incorrectos) debido a que el sistema bloqueaba rutas relativas (`../`). Esto ocurría por una discrepancia entre la ruta física del punto de montaje (`/mnt/volume_...`) y la ruta esperada (`/var/www/html/phlexmod`).
- **Solución:** Se implementó una detección dinámica de la ruta raíz permitida utilizando `realpath(__DIR__ . '/../')` en lugar de una ruta absoluta hardcodeada.
- **Impacto:** Ahora se permiten rutas relativas válidas siempre que resuelvan dentro del directorio raíz del proyecto, habilitando el funcionamiento correcto de `get_font_awesome.php` y hojas de estilo de módulos.

#### Optimización de Nginx

- **Problema:** Errores frecuentes `503 Service Temporarily Unavailable` al navegar entre módulos.
- **Causa:** Reglas de `limit_req` (rate limiting) demasiado estrictas en la configuración de Nginx para archivos PHP.

- **Solución:**
  - Se eliminó la directiva `limit_req` del bloque `location ~ \.php$`.
  - Se agregó manejo específico para archivos `.map` como estáticos para reducir carga en el backend.
- **Impacto:** Navegación fluida y estable entre módulos sin caídas del servicio.

---

## 2. Arquitectura del Core (`backend/core/`)

El núcleo del sistema gestiona la lógica fundamental, seguridad y utilidades transversales.

### Principio MIA (Núcleo Auto-Contenido)

- La **seguridad crítica** del sistema **no depende del estado de sesión** (cookies/`$_SESSION`) para funcionar correctamente.
- Los controles sensibles a manipulación (p.ej. anti-fuerza bruta) deben ser **stateless** desde la perspectiva del cliente.
- La fuente de verdad para intentos, bloqueos y auditoría es la **persistencia** (PostgreSQL) mediante tablas de seguridad.
- La sesión se utiliza únicamente para **estado de aplicación** (experiencia de usuario) una vez autenticado, no como mecanismo de seguridad crítico para decidir delays/bloqueos.

#### Anti-fuerza bruta (stateless)

- **Ubicación**: `backend/core/auth-manager.php`
- **Mecánica**:
  - `adaptiveDelay()` calcula el retardo en base al conteo de fallos recientes en `security_login_attempts` (ventana de 5 minutos).
  - Los bloqueos se persisten en `security_login_locks` y se consultan por IP.
  - El cliente no puede “resetear” el delay borrando cookies o manipulando sesión.

### `proxy-helper.php`

- **Ubicación:** `backend/core/proxy-helper.php`
- **Función:** Genera URLs seguras y ofuscadas para recursos estáticos (JS, CSS, imágenes).
- **Uso:** En lugar de enlazar directamente a un archivo, se utiliza `get_proxied_asset_url($ruta)`. Esto genera un enlace apuntando a `load_resource.php` con un token cifrado.
- **Seguridad:** Valida que el archivo solicitado esté dentro de las rutas permitidas (`frontend/`, `vendors/`, etc.) y previene el acceso directo no autorizado (Path Traversal), aunque permite referencias relativas controladas.

### `core-config.php`

- **Ubicación:** Raíz del proyecto (o `core-config.sample.php`).
- **Función:** Define constantes globales críticas como rutas del sistema, credenciales de base de datos y claves de encriptación.
- **Importante:** Define `PHLEXMOD_CORE_PATH`, `PHLEXMOD_MODULES_PATH`, entre otras.

---

## 3. Motor del Sistema (`backend/engine.php`)

El archivo `engine.php` actúa como el controlador frontal para la lógica de negocio dentro del panel administrativo.

- **Flujo de Trabajo:**
  1. Recibe parámetros encriptados `modulo` y `contenido` vía GET/POST.
  2. Desencripta los parámetros para identificar el módulo y la acción solicitada.
  3. Verifica permisos de usuario contra la base de datos (`setting_privilege_user`).
  4. Define dinámicamente las rutas de recursos del módulo (`PHLEXMOD_ROUTE_SPECIFIES_MODULES_UI`, `PHLEXMOD_ROUTE_SPECIFIES_MODULES_JS`).
  5. Carga la vista principal del módulo e inicializa el `ModuleLoader` de JavaScript.

---

## 4. Frontend y Gestión de Recursos

### `load_resource.php`

- **Ubicación:** `frontend/load_resource.php`
- **Rol:** Proxy de archivos seguro. Es el único punto de entrada público para servir assets protegidos.
- **Funcionamiento:**
  - Recibe un token (`r`) o una ruta encriptada.
  - Valida la sesión del usuario.
  - Comprueba que el archivo real exista y esté dentro de los directorios permitidos (`whiteList`).
  - Sirve el archivo con los headers MIME correctos.
  - **Nota de Desarrollo:** Si necesitas cargar un recurso desde un módulo JS (ej: `../css/estilo.css`), este archivo validará que la ruta resuelta siga estando dentro de la raíz del proyecto.

### `vendor_loader.php`

- **Ubicación:** `frontend/vendor_loader.php` (y `dist/lite/vendor_loader.php`)
- **Rol:** Gestor de dependencias de frontend. Centraliza la inclusión de librerías de terceros (Bootstrap, jQuery, FontAwesome, etc.).
- **Uso:** Define la función `load_vendor_scripts($nombre)` que devuelve los tags HTML `<script>` o `<link>` necesarios, utilizando el `proxy-helper` para ofuscar las rutas.

---

## 5. Desarrollo de Módulos (`backend/modules/`)

El sistema utiliza una arquitectura modular. Cada funcionalidad principal reside en su propia carpeta dentro de `backend/modules/`.

### Estructura de un Módulo

Ejemplo: `backend/modules/admin/menu/`

```text
menu/
├── css/            # Estilos específicos del módulo
├── endpoints/      # Scripts PHP para peticiones AJAX (API interna)
├── js/             # Lógica JavaScript
├── ui/             # Vistas HTML/PHP parciales
└── menu.php        # Controlador o punto de entrada (opcional según implementación)
```

### Guía para Crear un Nuevo Módulo

1. **Crear Directorio:** En `backend/modules/tu_modulo/`.
2. **Estructura:** Crear subcarpetas `js`, `ui`, `endpoints`.
3. **Registro:** El módulo debe estar registrado en la base de datos (`setting_menu`) para ser accesible por el `engine.php`.
4. **Desarrollo Frontend:**
   - Usa `ui/` para tus formularios y tablas.
   - Usa `js/` para la lógica. El `engine.php` cargará automáticamente los scripts definidos.
   - Para llamadas AJAX, apunta a tus scripts en `endpoints/`.
   - **Importante:** Al hacer `fetch` o `ajax` a tus endpoints desde JS, usa rutas relativas como `../endpoints/mi_script.php`. El `load_resource.php` se encargará de resolverlo correctamente.

---

## 6. Sistema de Plantillas (`frontend/templates/`)

Contiene la estructura visual base del sistema.

- **Ubicación:** `frontend/templates/`
- **Uso:** `frontend/index.php` carga estas plantillas para armar el layout (Header, Sidebar, Footer) antes de inyectar el contenido del módulo gestionado por `engine.php`.

---

## Resumen de Rutas Críticas

- **Core Backend:** `/var/www/html/phlexmod/backend/core/`
- **Módulos:** `/var/www/html/phlexmod/backend/modules/`
- **Frontend Assets:** `/var/www/html/phlexmod/frontend/assets/`
- **Proxy Script:** `/var/www/html/phlexmod/frontend/load_resource.php`
