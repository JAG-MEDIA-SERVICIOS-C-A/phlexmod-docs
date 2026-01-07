# Flujo PHP → JS (Backend como comunicador)

## Objetivo

Documentar cómo el backend (PHP) prepara el contexto y entrega información para que el frontend (JS) cargue recursos del módulo y consuma endpoints sin exponer rutas del servidor.

## Fuentes (código)

- `backend/engine.php`
- `backend/core/api-endpoint.php`
- `frontend/assets/js/module-loader.js`
- `vendor_loader.php`

## Secuencia

### 1) Resolución de módulo y permisos (RBAC)

- El motor consulta privilegios y datos de menú para el usuario.

**Origen (código fuente)**: `backend/engine.php`.

- Tablas involucradas (mínimo):
  - `setting_privilege_user`
  - `setting_menu`

### 2) Preparación de rutas del módulo

- El motor define rutas internas a `ui/` y `js/` (según el `directorio` resuelto).

**Origen (código fuente)**: `backend/engine.php`.

### 3) Cifrado de la ruta base de recursos

- El motor cifra la ruta del `js/` del módulo y la entrega al loader.

**Origen (código fuente)**:
- Cifrado: `backend/core/encryption.php` (invocado desde `backend/engine.php`).

### 4) Desencriptación controlada en servidor

- El loader llama a `backend/core/api-endpoint.php`.
- El endpoint valida que la ruta desencriptada esté dentro de directorios permitidos.
- Devuelve una URL base tipo proxy: `load_resource.php?r=<token>&f=`.

**Origen (código fuente)**: `backend/core/api-endpoint.php`.

### 5) Consumo desde JS

- Con la URL base del proxy, el loader deriva:
  - `PATH_ENDPOINTS = proxy + encodeURIComponent('../endpoints/')`
  - `PATH_UI = proxy + encodeURIComponent('../ui/')`
  - `PATH_CSS = proxy + encodeURIComponent('../css/')`

**Origen (código fuente)**: `frontend/assets/js/module-loader.js`.

## Carga de vendors (frontend transversal)

- Los vendors se registran centralmente.
- Evitar incluir `<script>` manual en vistas para prevenir doble carga.

**Origen (código fuente)**: `vendor_loader.php`.
