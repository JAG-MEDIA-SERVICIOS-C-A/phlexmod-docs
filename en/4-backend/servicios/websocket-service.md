> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Servicio WebSocket de PhlexMod

Este documento detalla la configuración, gestión y solución de problemas del servicio WebSocket utilizado por PhlexMod para comunicaciones en tiempo real.

## Características Principales

- **Protocolo RFC 6455 Completo**: Soporte total para el estándar WebSocket, incluyendo handshake, tramas de texto, ping/pong y cierre de conexión.
- **Soporte WSS (SSL/TLS)**: Configuración segura automática si se detectan certificados SSL.
- **Arquitectura Modular**: Sistema de canales para que cada módulo pueda gestionar sus propias notificaciones.
- **Comunicación Interna**: Capacidad para recibir mensajes desde PHP (backend) sin necesidad de un cliente WebSocket.

## Configuración del Servicio Systemd

El servicio WebSocket se gestiona a través de systemd, lo que permite un inicio automático, reinicio en caso de fallo y gestión centralizada.

### Archivo de Servicio

Ubicación: `/etc/systemd/system/phlexmod-websocket.service`

```ini
[Unit]
Description=PhlexMod WebSocket Server
After=network.target

[Service]
Type=simple
User=root
Group=root
WorkingDirectory=/var/www/html/phlexmod/backend/core
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Environment="PHP_INI_SCAN_DIR=/etc/php/8.4/cli/conf.d"
ExecStart=/usr/bin/php8.4 -d display_errors=1 -d error_log=/var/log/phlexmod/php-error.log websocket-manager.php
Restart=always
RestartSec=10
StandardOutput=append:/var/log/phlexmod/websocket.log
StandardError=append:/var/log/phlexmod/websocket-error.log

[Install]
WantedBy=multi-user.target
```

## Gestión del Servicio

### Instalación del Servicio

1. Crear el archivo de servicio:

```bash
sudo nano /etc/systemd/system/phlexmod-websocket.service
```

1. Copiar el contenido del archivo de servicio mostrado anteriormente.

2. Guardar y cerrar el archivo (Ctrl+O, Enter, Ctrl+X).

3. Crear el directorio de logs si no existe:

```bash
sudo mkdir -p /var/log/phlexmod
sudo chmod 755 /var/log/phlexmod
```

### Habilitar el Servicio

Para que el servicio se inicie automáticamente al arrancar el sistema:

```bash
sudo systemctl enable phlexmod-websocket.service
```

### Iniciar el Servicio

```bash
sudo systemctl start phlexmod-websocket.service
```

### Detener el Servicio

```bash
sudo systemctl stop phlexmod-websocket.service
```

### Reiniciar el Servicio

```bash
sudo systemctl restart phlexmod-websocket.service
```

### Verificar el Estado del Servicio

```bash
sudo systemctl status phlexmod-websocket.service
```

## Configuración SSL para WebSocket Seguro (WSS)

El servicio WebSocket detecta automáticamente los certificados SSL definidos en `core-config.php`.

Constantes en `core-config.php`:

```php
define('PHLEXMOD_SSL_CERT', '/ruta/al/certificado/fullchain.pem');
define('PHLEXMOD_SSL_KEY', '/ruta/al/certificado/privkey.pem');
```

Si los archivos existen, el servidor iniciará en modo seguro (WSS). De lo contrario, iniciará en modo texto plano (WS).

## Integración Modular (Canales)

El sistema soporta canales para permitir que diferentes módulos envíen notificaciones específicas sin interferir con otros.

### En Backend (PHP)

Utilice el helper `websocket-helper.php` para enviar notificaciones.

**Enviar a un Usuario Específico:**

```php
require_once PHLEXMOD_CORE_PATH . 'websocket-helper.php';

sendWebSocketNotification(
    $userId,
    'Título',
    'Mensaje para el usuario',
    'success' // Tipo: info, success, warning, error
);
```

**Enviar a un Canal (Modular):**

```php
// Ejemplo: Notificación de ventas
sendWebSocketChannelNotification(
    'ventas',
    'Nueva Venta',
    'Se ha registrado una venta de $500',
    'info',
    ['sale_id' => 123]
);
```

### En Frontend (JavaScript)

El cliente se conecta automáticamente. Para escuchar canales específicos, utilice el método `subscribe`.

```javascript
// Suscribirse al canal de ventas
if (window.phlexmodWS) {
    window.phlexmodWS.subscribe('ventas');
    
    // Escuchar mensajes
    window.phlexmodWS.on('notification', (data) => {
        console.log('Notificación recibida:', data);
    });
}
```

## Logs y Depuración

### Logs del Servicio

Los logs se almacenan según la configuración `PHLEXMOD_LOG_PATH` (por defecto `storage/logs/`):

- Salida estándar: `.../storage/logs/websocket.log`
- Errores: `.../storage/logs/websocket-error.log`
- Errores de PHP: `.../storage/logs/php-error.log`

Para ver los logs en tiempo real:

```bash
tail -f /var/www/html/phlexmod/storage/logs/websocket.log
```

### Depuración del Cliente WebSocket

El cliente WebSocket (`websocket-client.js`) incluye funciones de depuración que se pueden activar en el navegador:

1. Abrir la consola del navegador (F12)
2. Observar los mensajes de log relacionados con WebSocket
3. Si es necesario, habilitar el modo de depuración en la configuración del cliente

## Solución de Problemas Comunes

### Problema: El WebSocket no se conecta (Error en la consola del navegador)

**Posibles causas y soluciones:**

1. **Servicio no iniciado:**

   ```bash
   sudo systemctl status phlexmod-websocket.service
   # Si está detenido:
   sudo systemctl start phlexmod-websocket.service
   ```

2. **Problemas con los certificados SSL:**
   - Verificar que los certificados existen y son válidos:

   ```bash
   sudo openssl x509 -in /etc/letsencrypt/live/phlexmod.jagmedia.com.ve/fullchain.pem -text -noout | grep -A2 Validity
   ```

   - Si los certificados han sido renovados, reiniciar el servicio:

   ```bash
   sudo systemctl restart phlexmod-websocket.service
   ```

3. **Firewall bloqueando el puerto:**

   ```bash
   sudo iptables -L | grep 9002
   # Si es necesario, permitir el puerto:
   sudo iptables -A INPUT -p tcp --dport 9002 -j ACCEPT
   ```

4. **Conflicto de dominio:**
   - Verificar que el cliente WebSocket está usando el dominio correcto (phlexmod.jagmedia.com.ve)
   - Revisar los logs para identificar intentos de conexión desde dominios incorrectos:

   ```bash
   sudo grep "flexmod.jagmedia.com.ve" /var/www/html/phlexmod/storage/logs/websocket.log
   ```

### Problema: El servicio falla con código de salida 200/CHDIR

**Causa:** La ruta definida en `WorkingDirectory` no existe. Esto suele ocurrir por un error tipográfico en el archivo de servicio (ej. `flexmod` en lugar de `phlexmod`).

**Solución:**

1. Editar el archivo de servicio:

   ```bash
   sudo nano /etc/systemd/system/phlexmod-websocket.service
   ```

2. Corregir la línea `WorkingDirectory`:

   ```ini
   WorkingDirectory=/var/www/html/phlexmod/backend/core
   ```

3. Recargar systemd y reiniciar:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart phlexmod-websocket.service
   ```

### Problema: Errores de SSL/TLS en la conexión WebSocket

**Posibles causas y soluciones:**

1. **Incompatibilidad de cifrados SSL:**
   - Revisar y actualizar la lista de cifrados en `websocket-manager.php`
   - Reiniciar el servicio después de los cambios

2. **Problemas con los parámetros Diffie-Hellman:**
   - Regenerar los parámetros DH:

   ```bash
   sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
   ```

   - Reiniciar el servicio:

   ```bash
   sudo systemctl restart phlexmod-websocket.service
   ```

## Migración de FlexMod a PhlexMod

Durante la migración del dominio de flexmod.jagmedia.com.ve a phlexmod.jagmedia.com.ve, se creó un nuevo servicio systemd (`phlexmod-websocket.service`) para reflejar el cambio de nombre. El servicio anterior (`flexmod-websocket.service`) puede ser deshabilitado y eliminado una vez que se confirme que el nuevo servicio funciona correctamente.

### Deshabilitar y Eliminar el Servicio Antiguo

```bash
sudo systemctl stop flexmod-websocket.service
sudo systemctl disable flexmod-websocket.service
sudo rm /etc/systemd/system/flexmod-websocket.service
sudo systemctl daemon-reload
```

## Notas Adicionales

- El servicio WebSocket se ejecuta como usuario root para garantizar acceso a los certificados SSL.
- El puerto predeterminado es 9002, definido en la configuración del framework (PHLEXMOD_WS_PORT).
- La conexión WebSocket segura (WSS) requiere que el sitio web se acceda a través de HTTPS.
