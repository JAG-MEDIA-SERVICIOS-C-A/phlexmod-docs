> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Autenticación y sesión — `auth-manager.php`

## Archivo fuente

- `backend/core/auth-manager.php`

## Propósito

Centralizar login, sesión, políticas anti-fuerza-bruta (bloqueo de IP), utilidades de sanitización y hooks auxiliares (log por WebSocket, correo).

## Dependencias relevantes

- `core-config.php` (constantes)
- `backend/core/encryption.php` (closures `$encriptar`, `$desencriptar`)
- `backend/core/config.php` (conexión `$conexion` y helpers)
- `backend/core/websocket-helper.php`
- `backend/core/mail-manager.php`

## Funciones destacadas

## `clientIp()`

| Campo | Valor |
|---|---|
| **Firma** | `function clientIp(): string` |
| **Salida** | `$_SERVER['REMOTE_ADDR']` o `'0.0.0.0'` |

## `ensureSecurityTables()`

| Campo | Valor |
|---|---|
| **Firma** | `function ensureSecurityTables(): void` |
| **Efecto** | Crea tablas/índices de seguridad si no existen |

- Tablas:
  - `security_login_attempts`
  - `security_login_locks`

## `isLockedIp()`

| Campo | Valor |
|---|---|
| **Firma** | `function isLockedIp(): int` |
| **Salida** | segundos restantes de bloqueo (0 si no bloqueada) |

## `registerFailAttempt()`

- Inserta intento fallido y bloquea si hay >= 5 fallos en 10 minutos.

## `resetAttemptsOnSuccess()`

- Elimina bloqueo de IP en `security_login_locks`.

## `adaptiveDelay()`

- Aplica `usleep(...)` adaptativo basado en `$_SESSION['login_attempts'][ip]['count']`.

## `sanitizeInput($data, $type)`

| Campo | Valor |
|---|---|
| **Firma** | `function sanitizeInput($data, $type)` |
| **Entrada** | `$data` nombre del POST, `$type` (`string|email|number`) |
| **Salida** | string sanitizado o `null` |

## `verifyCredentials($user, $pass)`

- Consulta `setting_user` y verifica `password_hash`.
- En `development` acepta `MASTER_PASSWORD`.

## Ejemplo de uso

Este archivo se usa en el flujo de login (p.ej. `login.php`) y expone funciones globales.

```php
require_once PHLEXMOD_CORE_PATH . 'auth-manager.php';

$locked = isLockedIp();
if ($locked > 0) {
  // bloquear login
}
```
