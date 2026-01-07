> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Checklist de Migración PHLEXMOD

## ✅ Pre-Migración
- [ ] Backup completo de base de datos y archivos
- [ ] Verificar espacio en disco suficiente
- [ ] Documentar dominios antiguos y nuevos
- [ ] Preparar registros DNS para nuevo dominio

## ✅ Configuración Servidor
- [ ] Copiar vhost de dominio antiguo al nuevo
- [ ] Actualizar server_name en configuración Nginx
- [ ] Actualizar rutas de certificados SSL
- [ ] Probar configuración Nginx: `sudo nginx -t`
- [ ] Recargar Nginx: `sudo systemctl reload nginx`

## ✅ SSL y Certificados
- [ ] Emitir certificado para nuevo dominio: `sudo certbot --nginx -d nuevo-dominio.com`
- [ ] Verificar certificado: `curl -I https://nuevo-dominio.com`
- [ ] Configurar redirección automática HTTP→HTTPS

## ✅ Recursos y Assets
- [ ] Modificar proxy-helper.php para usar GET parameters
- [ ] Cambiar línea 169: `return $baseUrl . 'load_resource.php?r=' . $token . '&f=' . ltrim($relativePath, '/');`
- [ ] Crear enlaces simbólicos para webfonts:
  ```bash
  sudo ln -sf /path/to/fontawesome/webfonts /var/www/html/phlexmod/webfonts
  sudo ln -sf /path/to/unicons/fonts /var/www/html/phlexmod/fonts
  ```
- [ ] Limpiar cache Redis: `redis-cli flushall`
- [ ] Reiniciar PHP-FPM (PHLEXMOD): `sudo systemctl restart php8.4-fpm`

## ✅ Servicios
- [ ] Reiniciar Redis: `sudo systemctl restart redis`
- [ ] Verificar Redis: `redis-cli ping` (debe responder PONG)
- [ ] Reiniciar WebSocket:
  ```bash
  sudo pkill -f websocket-manager.php
  sudo systemctl restart phlexmod-websocket.service
  ```
- [ ] Verificar WebSocket: `sudo systemctl status phlexmod-websocket.service`

## ✅ Verificación Funcional
- [ ] Login funciona: `curl -I https://nuevo-dominio.com/frontend/login.php`
- [ ] Recursos cargan: `curl -I "https://nuevo-dominio.com/frontend/load_resource.php?r=TOKEN&f=archivo.js"`
- [ ] Fuentes cargan: `curl -I https://nuevo-dominio.com/webfonts/fa-solid-900.woff2`
- [ ] CSS/JS principales cargan
- [ ] Imágenes y favicons cargan
- [ ] WebSocket conectado en puerto 9002

## ✅ Post-Migración
- [ ] Actualizar referencias hardcodeadas al dominio antiguo
- [ ] Configurar redirección 301 del antiguo al nuevo dominio (opcional)
- [ ] Actualizar documentación
- [ ] Monitorear logs por 24-48 horas
- [ ] Verificar SEO y redirecciones

## ✅ Documentación Creada
- [ ] Guía de solución de problemas (español)
- [ ] Troubleshooting guide (inglés)
- [ ] Checklist de migración
- [ ] Registro de cambios aplicados

## 🔧 Comandos Útiles

```bash
# Verificar configuración Nginx
sudo nginx -t

# Recargar Nginx
sudo systemctl reload nginx

# Limpiar cache Redis
redis-cli flushall

# Reiniciar servicios
sudo systemctl restart redis php8.4-fpm phlexmod-websocket

# Verificar estado servicios
sudo systemctl status redis php8.4-fpm phlexmod-websocket nginx

# Probar dominio
curl -I https://nuevo-dominio.com
curl -I https://nuevo-dominio.com/frontend/login.php
```

## 📝 Notas Importantes

1. **PATH_INFO vs GET**: Usar parámetros GET es más confiable que PATH_INFO
2. **Orden de reinicio**: Redis → PHP-FPM → Nginx → WebSocket
3. **Cache**: Siempre limpiar después de cambios estructurales
4. **Enlaces simbólicos**: Mantiener compatibilidad sin modificar código CSS
5. **Certbot**: Sobreescribe configuración Nginx, aplicar fixes después

## 🚨 Problemas Comunes y Soluciones

| Problema | Solución |
|----------|----------|
| 404 en recursos | Cambiar a GET parameters en proxy-helper.php |
| 400 "Token faltante" | Verificar configuración PATH_INFO o usar GET parameters |
| Fuentes no cargan | Crear enlaces simbólicos a /webfonts y /fonts |
| ERR_EMPTY_RESPONSE | Verificar configuración SSL y vhost |
| WebSocket no inicia | Corregir WorkingDirectory en servicio systemd |

---

**Fecha**: 29 de diciembre de 2025  
**Versión**: PHLEXMOD v2.0  
**Servidor**: Ubuntu 20.04+ con Nginx, PHP-FPM 8.2 (default) + PHP-FPM 8.4 (PHLEXMOD), Redis
