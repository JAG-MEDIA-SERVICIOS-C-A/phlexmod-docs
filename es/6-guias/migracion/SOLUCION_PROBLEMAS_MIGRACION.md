# Guía de Solución de Problemas - Migración PHLEXMOD

## Problemas Comunes y Soluciones

### 1. Recursos No Cargan (404/400 en load_resource.php)

**Síntomas:**
- Errores 404 o 400 en `load_resource.php/TOKEN/archivo.js`
- La aplicación carga pero sin CSS, JS, imágenes
- Login funciona pero recursos fallan

**Causa:**
PATH_INFO no se configura correctamente en Nginx para URLs tipo `/load_resource.php/TOKEN/archivo`

**Solución:**
Cambiar formato de URLs de PATH_INFO a parámetros GET:

```php
// En /var/www/html/phlexmod/backend/core/proxy-helper.php línea 169:

// ANTES (PATH_INFO - no funciona):
return $baseUrl . 'load_resource.php/' . $token . '/' . ltrim($relativePath, '/');

// AHORA (parámetros GET - funciona):
return $baseUrl . 'load_resource.php?r=' . $token . '&f=' . ltrim($relativePath, '/');
```

**Pasos para aplicar:**
1. Editar `/var/www/html/phlexmod/backend/core/proxy-helper.php`
2. Modificar línea 169 como se muestra arriba
3. Limpiar cache: `redis-cli flushall`
4. Reiniciar PHP-FPM (PHLEXMOD): `sudo systemctl restart php8.4-fpm`
5. Verificar nuevas URLs en el código fuente de la página

### 2. Fuentes WebFonts No Cargan (404 en /webfonts/ y /fonts/)

**Síntomas:**
- Errores 404 en `/webfonts/fa-solid-900.woff2`
- Errores 404 en `/fonts/line/unicons-14.woff2`
- Iconos FontAwesome y Unicons no se muestran

**Causa:**
Los archivos CSS referencian rutas relativas que no existen en la estructura del proyecto.

**Solución:**
Crear enlaces simbólicos a las ubicaciones reales:

```bash
# Enlaces simbólicos para fuentes
sudo ln -sf /var/www/html/phlexmod/frontend/vendors/fontawesome/webfonts /var/www/html/phlexmod/webfonts
sudo ln -sf /var/www/html/phlexmod/frontend/vendors/unicons/fonts /var/www/html/phlexmod/fonts
```

**Verificación:**
```bash
# Probar URLs
curl -I "https://phlexmod.mia-architecture.com/webfonts/fa-solid-900.woff2"
curl -I "https://phlexmod.mia-architecture.com/fonts/line/unicons-14.woff2"
```

### 3. Configuración Nginx para Nuevo Dominio

**Síntomas:**
- ERR_EMPTY_RESPONSE al acceder al nuevo dominio
- Redirecciones incorrectas
- SSL no funciona

**Solución:**
Replicar configuración exacta del dominio antiguo:

```bash
# Copiar configuración existente
sudo cp /etc/nginx/sites-available/phlexmod.conf /etc/nginx/sites-available/phlexmod.mia-architecture.com.conf

# Cambiar domain name
sudo sed -i 's/server_name phlexmod\.jagmedia\.com\.ve;/server_name phlexmod.mia-architecture.com;/g' /etc/nginx/sites-available/phlexmod.mia-architecture.com.conf

# Actualizar certificados SSL
sudo sed -i 's|/etc/letsencrypt/live/phlexmod\.jagmedia\.com\.ve/|/etc/letsencrypt/live/phlexmod.mia-architecture.com/|g' /etc/nginx/sites-available/phlexmod.mia-architecture.com.conf

# Habilitar y recargar
sudo ln -sf /etc/nginx/sites-available/phlexmod.mia-architecture.com.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# Configurar SSL con Certbot
sudo certbot --nginx -d phlexmod.mia-architecture.com --redirect --non-interactive --agree-tos --email admin@mia-architecture.com
```

### 4. Reiniciar Servicios Críticos

**WebSocket:**
```bash
# Detener proceso zombie si existe
sudo pkill -f websocket-manager.php

# Corregir WorkingDirectory en servicio si es necesario
sudo sed -i 's|WorkingDirectory=/var/www/html/flexmod|WorkingDirectory=/var/www/html/phlexmod|' /etc/systemd/system/phlexmod-websocket.service

# Reiniciar servicio
sudo systemctl daemon-reload
sudo systemctl restart phlexmod-websocket.service
```

**Redis:**
```bash
sudo systemctl restart redis
redis-cli ping  # Debe responder PONG
```

**PHP-FPM:**
```bash
sudo systemctl restart php8.4-fpm
```

### 5. Limpieza de Cache

**Redis:**
```bash
redis-cli flushall
```

**Cache de archivos:**
```bash
sudo rm -rf /var/www/html/phlexmod/cache/*
```

**OPcache:**
```bash
sudo systemctl restart php8.4-fpm
```

## Verificación Final

Después de aplicar soluciones, verificar:

```bash
# 1. Login funciona
curl -I "https://phlexmod.mia-architecture.com/frontend/login.php"

# 2. Recursos con parámetros GET funcionan
curl -I "https://phlexmod.mia-architecture.com/frontend/load_resource.php?r=TOKEN&f=archivo.js"

# 3. Fuentes cargan
curl -I "https://phlexmod.mia-architecture.com/webfonts/fa-solid-900.woff2"

# 4. WebSocket activo
sudo systemctl status phlexmod-websocket.service

# 5. Redis funcional
redis-cli ping
```

## Notas Importantes

1. **PATH_INFO vs GET**: Los parámetros GET son más confiables que PATH_INFO en Nginx
2. **Enlaces simbólicos**: Útiles para mantener compatibilidad con rutas hardcodeadas
3. **Cache**: Siempre limpiar cache después de cambios estructurales
4. **Servicios**: Reiniciar servicios en orden: Redis → PHP-FPM → Nginx → WebSocket
5. **SSL**: Certbot sobreescribe configuraciones, aplicar fixes después de ejecutarlo

## Contacto y Soporte

- Documentación actualizada: [Fecha de creación]
- Válido para: PHLEXMOD en Ubuntu 20.04+ con Nginx, PHP-FPM 8.2 (default) + PHP-FPM 8.4 (PHLEXMOD), Redis
- Dominio de ejemplo: phlexmod.mia-architecture.com
