> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Logging — `Logger.php`

## Archivo fuente

- `backend/core/Logger.php`

## Propósito

Unificar logging a archivo (por nivel) y opcionalmente registrar acciones en base de datos (`setting_logs`).

## Clase `Logger`

### Niveles

La constante `Logger::LEVELS` define el orden:

- `DEBUG`
- `INFO`
- `NOTICE`
- `WARNING`
- `ERROR`
- `CRITICAL`
- `ALERT`
- `EMERGENCY`

### Configuración

- Directorio: `PHLEXMOD_LOG_PATH`
- Nivel mínimo: `PHLEXMOD_LOG_LEVEL` (default `DEBUG`)
- Retención: `PHLEXMOD_LOG_MAX_FILES` (default 30)

### Métodos estáticos

| Método | Propósito |
| --- | --- |
| `Logger::debug($message, $context = [])` | Log nivel DEBUG |
| `Logger::info(...)` | Log nivel INFO |
| `Logger::warning(...)` | Log nivel WARNING |
| `Logger::error(...)` | Log nivel ERROR |
| `Logger::critical(...)` | Log nivel CRITICAL |
| `Logger::alert(...)` | Log nivel ALERT |
| `Logger::emergency(...)` | Log nivel EMERGENCY |
| `Logger::logAction($action, $userId, $details, $ip = null)` | Inserta en `setting_logs` (con fallback a archivo) |

### Función global `log_message(...)`

- Existe un wrapper global si no está definido:

```php
log_message('INFO', 'Mensaje', ['k' => 'v']);
```

## Ejemplo

```php
require_once PHLEXMOD_CORE_PATH . 'Logger.php';

Logger::info('Evento', ['module' => 'admin/email']);
Logger::logAction('email.sent', $_SESSION['idLogin'] ?? 0, 'Enviado SMTP', null);
```
