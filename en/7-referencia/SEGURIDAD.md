> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Auditoría de Seguridad (OWASP Top 10) — Phlexmod

Fecha: 2025-12-27

## Alcance

Auditoría estática (code review) enfocada en:

- Inyección (PHP/Postgres)
- XSS (PHP/JS)
- Seguridad en CLI
- Gestión de sesiones y autenticación
- Instalador web / scripts de instalación

## Metodología

- Revisión de patrones de riesgo (OWASP Top 10) en archivos PHP/JS.
- Identificación de *sinks* peligrosos (`pg_query` con concatenación, `shell_exec/exec`, `innerHTML`).
- Recomendaciones de mitigación con ejemplos de código.

---

## SEC-009 — Content Security Policy (CSP) demasiado estricto rompe carga de vendors

- **Ubicación**: `/index.php`, `frontend/index.php`
- **Descripción**: Se detectaron bloqueos masivos de recursos por CSP cuando la política se limitaba a `default-src 'self'`.
- **Síntomas**:
  - Bloqueo de scripts externos (ej. Google Tag Manager, jQuery/CDN, DataTables/CDN).
  - Bloqueo de scripts inline existentes en templates (inicializaciones en `<script>`).
  - Bloqueo de estilos inline (librerías como SweetAlert2 y componentes UI).
  - Bloqueo de `data:` en imágenes (ej. SVG base64) y de `connect-src` para WebSocket.

### Mitigación aplicada (SEC-009)

- Se sustituyó el CSP mínimo por uno **con directivas explícitas**:
  - `script-src` y `style-src` con allowlist de dominios usados actualmente.
  - `img-src` con `data:` y `https:`.
  - `connect-src` con `wss:`/`ws:`/`https:`.

**Nota**: Se mantiene `unsafe-inline` en `script-src` y `style-src` por compatibilidad con el estado actual del frontend (existen múltiples scripts/estilos inline en templates y vendors).

### Riesgo residual y plan de hardening

- `unsafe-inline` reduce la protección frente a XSS basado en inyección de inline scripts.
- Plan recomendado:
  - Migrar a CSP con `nonce` (generado por request) y aplicar `nonce` a scripts inline necesarios.
  - Mover inicializaciones inline a archivos `.js` versionados.
  - Eliminar `unsafe-inline` progresivamente y restringir aún más orígenes externos priorizando vendors locales.

---

## Hallazgos

## Estado de mitigación (2025-12-27)

| ID | Estado | Cambios aplicados |
| --- | --- | --- |
| SEC-001 | Mitigado | `installs/verificar.php` ahora bloquea por `core-config.php` y solo permite checks predefinidos (sin ejecución arbitraria). |
| SEC-002 | Mitigado | `instalar_dependencia.php` ya no acepta `command` del cliente; usa whitelist de `package` y bloquea post-instalación. |
| SEC-003 | Mitigado | `backend/modules/admin/settings/ui/usuarios/modal_editar.php` migrado a `pg_query_params` + eliminación de uso directo de `$_POST['a']`. |
| SEC-004 | Parcial | Se añadió hard lock en `installs/OLDInstall.php` (evita re-ejecución). Pendiente: eliminar `sudo`/claves fijas si se mantiene el instalador legacy. |
| SEC-005 | Pendiente | Se mantiene como recomendación (no se aplicó cambio en UI para evitar regresiones visuales). |
| SEC-006 | Mitigado | `tools/console/commands/make_endpoint.php` ya no genera `Access-Control-Allow-Origin: *` por defecto. |
| SEC-007 | Mitigado | `backend/core/auth-manager.php` ahora ejecuta `session_regenerate_id(true)` al autenticar. **CSRF implementado con cabeceras HTTP AJAX (X-CSRF-TOKEN) y validación centralizada en `frontend/index.php`.** |
| SEC-008 | Mitigado | Hard lock por `core-config.php` aplicado en `installs/*` (welcome, deploy, verificar_db, crear_usuario, etc.). |
| SEC-009 | Mitigado (compatibilidad) | **CSP actualizado** (de `default-src 'self'` estricto a directivas explícitas) para permitir vendors externos e inline scripts existentes sin romper UI. Ubicación: `/index.php` y `frontend/index.php`. |
| SEC-010 | Mitigado | **Hardening de Register**: CSRF end-to-end, `password_hash` consistente, y reducción de privilegios por defecto. Además, jQuery migrado a vendor local (reduce dependencia CDN/CSP). |

## SEC-001 — RCE por `shell_exec` ejecutando comando arbitrario

- **Ubicación**: `installs/verificar.php` (líneas 1–24 aprox.)
- **Descripción**: **Mitigado.** El endpoint ya no acepta comandos arbitrarios. Ahora usa un parámetro `check` con lista blanca (ej. `uname`, `php`, `extensions`) y bloquea su ejecución si existe `core-config.php`.
- **Impacto**: **Crítico**
- **Riesgo**:
  - Permite ejecución de comandos en el servidor (RCE) si el archivo es accesible vía web.
  - Puede derivar en compromiso total del servidor, exfiltración de secretos y movimiento lateral.

### Recomendación de mitigación (SEC-001)

- **Opción recomendada (producción)**: deshabilitar el endpoint por completo.
- **Opción alternativa (solo instalador)**:
  - Validar que el instalador solo se ejecute si NO existe `core-config.php`.
  - Eliminar el parámetro `command` y reemplazarlo por una lista blanca de chequeos predefinidos.

**Ejemplo (whitelist estricta):**

```php
$check = isset($_POST['check']) ? (string)$_POST['check'] : '';
$checks = [
  'uname' => fn() => php_uname(),
  'php' => fn() => 'PHP ' . PHP_VERSION,
];
if (!isset($checks[$check])) {
  http_response_code(400);
  echo json_encode(['error' => 'Check no permitido']);
  exit;
}
$output = $checks[$check]();
```

---

## SEC-002 — Ejecución de comandos vía AJAX (instalación de dependencias)

- **Ubicación**: `instalar_dependencia.php` (líneas 4–79 aprox.)
- **Descripción**: **Mitigado.** El endpoint ya no acepta `command` desde el cliente; solo acepta `package` en lista blanca y ejecuta el comando predefinido. Además, se bloquea si existe `core-config.php`.
- **Impacto**: **Crítico**

### Riesgo

- Aunque hay una lista blanca por prefijo (`apt-get install -y`, etc.), **sigue existiendo superficie de ataque**:
  - Riesgo de abuso (instalación de paquetes no deseados, modificación del sistema).
  - Si el endpoint es accesible y el servidor corre como un usuario con permisos elevados, el impacto es mayor.

### Recomendación de mitigación (SEC-002)

- Asegurar que el instalador **no sea accesible** tras instalación:
  - Bloquear por `core-config.php` existente.
- No aceptar `command` desde el cliente. Aceptar solo un identificador:

```php
$allowedPackages = [
  'pgsql' => 'apt-get install -y php-pgsql',
  'curl' => 'apt-get install -y php-curl',
];

$pkg = $input['package'] ?? '';
if (!isset($allowedPackages[$pkg])) {
  http_response_code(400);
  echo json_encode(['success' => false, 'message' => 'Paquete no permitido']);
  exit;
}

exec($allowedPackages[$pkg] . ' 2>&1', $output, $code);
```

---

## SEC-003 — SQL Injection por concatenación directa en `pg_query`

- **Ubicación**: `backend/modules/admin/settings/ui/usuarios/modal_editar.php` (líneas 5–16 aprox.)
- **Descripción**: **Mitigado.** La consulta ya no concatena `$_POST['a']`. Se fuerza `(int)` y se usa `pg_query_params`.

```php
WHERE setting_user.uid = " . $_POST['a'] . "
```

- **Impacto**: **Crítico**

### Recomendación de mitigación (SEC-003)

- Validar/forzar entero y usar `pg_query_params`:

```php
$userId = isset($_POST['a']) ? (int)$_POST['a'] : 0;

$sql = "SELECT uid, clave, observ, codigo2 FROM setting_user WHERE uid = $1";
$rs = pg_query_params($conexion, $sql, [$userId]);
```

---

## SEC-004 — Exposición de credenciales / cifrado débil en instalador legacy

- **Ubicación**: `installs/OLDInstall.php` (líneas 13–90 aprox.)
- **Descripción**:
  - Genera un `core-config.php` con valores (incluye clave de cifrado fija `PASS_ENCRYPT = 'tr3w01$$'`).
  - Ejecuta `shell_exec('sudo usermod -aG www-data ...')`.
- **Impacto**: **Alto/Crítico** (dependiendo si el archivo es accesible en producción)

### Recomendación de mitigación (SEC-004)

- Asegurar que `installs/OLDInstall.php`:
  - No sea accesible en producción (remover del docroot o proteger por servidor web).
  - No genere claves fijas: usar `random_bytes()`.
  - Eliminar cualquier uso de `sudo` desde PHP.

---

## SEC-005 — Riesgo de XSS por uso de `innerHTML` en UI

- **Ubicación**: `frontend/templates/login/form_login_2fa.php` (línea ~148 en adelante)
- **Descripción**: se asigna `this.innerHTML = ...`.
- **Impacto**: **Medio** (sube a Alto si el contenido incluye datos no confiables)

### Recomendación de mitigación (SEC-005)

- Preferir `textContent` para texto.
- Si se requiere HTML, asegurar que el contenido sea constante o sanitizado.

Ejemplo:

```js
this.textContent = 'Enviando...';
```

---

## SEC-006 — CORS permisivo en endpoints generados por CLI

- **Ubicación**: `tools/console/commands/make_endpoint.php` (líneas 157–164 aprox.)
- **Descripción**: **Mitigado.** El template ya no incluye CORS `*` por defecto.

```php
header('Access-Control-Allow-Origin: *');
```

- **Impacto**: **Medio**

### Recomendación (SEC-006)

- No habilitar CORS `*` por defecto.
- Generar endpoints con CORS deshabilitado y documentar el ajuste manual por módulo.

---

## SEC-007 — Sesión/Auth: controles faltantes comunes (CSRF / session fixation)

- **Ubicación**: `backend/core/auth-manager.php` (múltiples secciones)
- **Descripción**:
  - Hay endurecimiento parcial de cookies (httponly/secure/samesite) y bloqueo de IP.

---

## SEC-010 — Hardening del flujo Register (CSRF + Password Hash + Mínimo Privilegio)

- **Ubicación**:
  - `frontend/register.php`
  - `frontend/templates/register/header_register.php`
  - `frontend/templates/register/form_register.php`
  - `frontend/assets/js/register.js`
  - `backend/modules/admin/settings/endpoints/register/register.php`
  - `vendor_loader.php` + `frontend/vendors/jquery/jquery-3.6.0.min.js`
- **Descripción**: Se endureció el flujo de registro para reducir exposición a CSRF, asegurar almacenamiento correcto de contraseñas y eliminar escalada de privilegios por defecto.

### Mitigación aplicada (SEC-010)

- **CSRF end-to-end**:
  - Se garantiza `$_SESSION['csrf_token']` al cargar `frontend/register.php`.
  - Se expone token vía `<meta name="csrf-token">` y campo hidden `csrf_token` en el form.
  - El JS envía `X-CSRF-TOKEN` y `X-Requested-With: XMLHttpRequest`.
  - El endpoint valida con `hash_equals()` antes de procesar.

- **Contraseña (OWASP)**:
  - Registro usa `password_hash()` y persiste en `setting_user.password_hash`.
  - Se elimina dependencia de `encrypt(...)` para contraseñas en el flujo de registro.

- **Mínimo privilegio**:
  - Se limita la asignación inicial de privilegios.
  - Se evita dar permisos de modificar/borrar/anular/etc. a un usuario recién creado.

- **Vendors locales**:

  - `vendor_loader.php` carga jQuery desde `frontend/vendors/jquery/` en vez de CDN.
  - Reduce dependencia externa y facilita endurecimiento CSP (menos dominios externos en allowlist).

---

## SEC-008 — Re-ejecución del instalador

- **Ubicación**: `instalar_dependencia.php`, `installs/*`, `instalar_dependencia.php`
- **Descripción**: **Mitigado.** Se aplicó hard lock por `core-config.php` en los scripts del instalador (se devuelve 403 cuando el sistema ya está configurado).
- **Impacto**: **Alto**

### Recomendación (SEC-008)

- Añadir un “lock” de instalación, por ejemplo:
  - `storage/.installed` o validación de `core-config.php` existente.
- Bloquear rutas `/installs/` desde Nginx/Apache en producción.

---

## Revisión de `.gitignore`

- **Ubicación**: `.gitignore`
- **Hallazgo**:
  - Se excluyen correctamente secretos: `.env*`, `core-config.php`.
  - Se excluyen logs: `storage/logs/*`, `*.log`.
  - Se excluye `projectmanager/` y `scripts/` (nota: si ya están trackeados, Git los seguirá versionando).

### Recomendación (`.gitignore`)

- Verificar que no existan secretos en el historial Git (ej. `core-config.php` no trackeado).
- Confirmar que `storage/logs/` esté excluido en todos los entornos.

---

## Resumen Ejecutivo

- **Críticos (bloqueantes para producción)**:
  - `SEC-001`, `SEC-002`, `SEC-003`
- **Altos**:
  - `SEC-004`, `SEC-008`
- **Medios**:
  - `SEC-005`, `SEC-006`, `SEC-007`
