# WebSocket Server — `websocket-manager.php`

## Archivo fuente

- `backend/core/websocket-manager.php`

## Propósito

Servidor WebSocket (RFC 6455) para comunicación en tiempo real.

## Operación

- Se ejecuta como proceso CLI (idealmente bajo systemd).
- Soporta modo TCP y modo TLS (WSS) si hay certificados configurados.

## Componentes

## Clase `WebSocketServer`

- Maneja:
  - `handshake`
  - registro de clientes
  - suscripciones por canal
  - mensajes internos desde localhost (JSON directo)

## Mensajes internos

El server acepta JSON directo (sin handshake) **solo** desde localhost (127.0.0.1 / ::1). Esto permite que `websocket-helper.php` envíe notificaciones vía socket.

## SSL

- Si `PHLEXMOD_SSL_CERT` / `PHLEXMOD_SSL_KEY` existen, inicia WSS.
- Si no existen, cae a TCP.

## Ejecución

```bash
php backend/core/websocket-manager.php
```

