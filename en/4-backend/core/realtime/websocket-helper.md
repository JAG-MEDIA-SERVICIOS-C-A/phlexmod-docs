> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# WebSocket Helper — `websocket-helper.php`

## Archivo fuente

- `backend/core/websocket-helper.php`

## Propósito

Permitir que PHP envíe notificaciones/eventos al servidor WebSocket sin implementar cliente WS completo (usa socket TCP y JSON + newline).

## Funciones

## `sendWebSocketMessage(array $data, ?int $targetUserId = null, ?string $channel = null): bool`

| Parámetro | Tipo | Descripción |
| --- | --- | --- |
| `$data` | `array` | payload serializable a JSON |
| `$targetUserId` | `int\|null` | si se define, la notificación se orienta al usuario |
| `$channel` | `string\|null` | canal lógico (modular) |

- Conecta a `127.0.0.1` y puerto `PHLEXMOD_WS_PORT` (default 9002).
- Agrega `timestamp`.
- Envía JSON con `\n` final.

## `sendWebSocketNotification(...)`

- Conveniencia para notificaciones a usuario.

## `sendWebSocketChannelNotification(...)`

- Conveniencia para notificaciones por canal.

## `sendWebSocketDataUpdate(...)`

- Conveniencia para eventos `data_update` (create/update/delete).

## Ejemplo

```php
require_once PHLEXMOD_CORE_PATH . 'websocket-helper.php';

sendWebSocketNotification(
  123,
  'Título',
  'Mensaje',
  'success',
  ['module' => 'admin/email']
);
```
