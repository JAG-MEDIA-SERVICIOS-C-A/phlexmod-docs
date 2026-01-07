# Guía de Prueba de Despliegue y Cambio de Dominio

## Problemas Identificados (Basado en experiencia real)

### 1. URLs Hardcodeadas Críticas
- **core-config.php**: `PHLEXMOD_WS_HOST` hardcodeado
- **Certificados SSL**: Rutas absolutas hardcodeadas
- **Base de datos**: Referencias de dominio en tablas de configuración

### 2. Problemas de Sesión y Tokens
- **api-endpoint.php**: Sistema de proxy con tokens basados en session_id
- **Mapeo de recursos**: Dependencia de Redis/Sesión que se rompe al cambiar dominio
- **Cookies**: Dominio de sesión incorrecto

### 3. Assets y Recursos Estáticos
- **Paths de recursos**: Rutas relativas que pueden romperse
- **Vendors**: Dependencias externas con whitelist de dominios
- **Caching**: CDN y caché de navegador con dominio anterior

## Procedimiento de Prueba de Despliegue

### Fase 1: Pre-Despliegue

#### 1.1 Backup Completo
```bash
# Backup base de datos
pg_dump -h localhost -U postgres -d phlexmod > backup_pre_deploy.sql

# Backup archivos
tar -czf backup_files_pre_deploy.tar.gz \
    --exclude='vendor/' \
    --exclude='node_modules/' \
    --exclude='*.log' \
    .
```

#### 1.2 Detección de URLs Hardcodeadas
```bash
# Buscar URLs hardcodeadas en PHP
grep -r "http[s]://[^/]*" --include="*.php" . | grep -v vendor

# Buscar referencias de dominio en SQL
grep -r "nuevo-dominio.com" --include="*.sql" .

# Buscar referencias en JavaScript
grep -r "localhost\|127\.0\.0\.1" --include="*.js" . | grep -v vendor
```

#### 1.3 Validación de Configuración
```bash
# Verificar configuración actual
php -r "include 'core-config.php'; echo PHLEXMOD_BASE_URL . PHP_EOL;"
php -r "include 'core-config.php'; echo PHLEXMOD_WS_HOST . PHP_EOL;"
```

### Fase 2: Actualización de Dominio

#### 2.1 Script de Actualización Automática
```bash
#!/bin/bash
# update_domain.sh

NEW_DOMAIN="$1"
if [ -z "$NEW_DOMAIN" ]; then
    echo "Uso: $0 <nuevo_dominio.com>"
    exit 1
fi

echo "Actualizando dominio a: $NEW_DOMAIN"

# Actualizar core-config.php
sed -i "s/phlexmod\.mia-architecture\.com/$NEW_DOMAIN/g" core-config.php

# Actualizar certificados SSL si es necesario
sed -i "s|/etc/letsencrypt/live/[^/]*|/etc/letsencrypt/live/$NEW_DOMAIN|g" core-config.php

# Actualizar base de datos
psql -h localhost -U postgres -d phlexmod -c "
UPDATE setting_general_config 
SET config_value = REPLACE(config_value, 'phlexmod.mia-architecture.com', '$NEW_DOMAIN')
WHERE config_value LIKE '%phlexmod.mia-architecture.com%';
"

echo "Actualización completada para $NEW_DOMAIN"
```

#### 2.2 Actualización Manual Requerida

**core-config.php:**
```php
// Cambiar línea 104
if (!defined('PHLEXMOD_WS_HOST')) { define('PHLEXMOD_WS_HOST', 'nuevo-dominio.com'); }

// Cambiar líneas 107-108 si es necesario
if (!defined('PHLEXMOD_SSL_CERT')) { define('PHLEXMOD_SSL_CERT', '/etc/letsencrypt/live/nuevo-dominio.com/fullchain.pem'); }
if (!defined('PHLEXMOD_SSL_KEY')) { define('PHLEXMOD_SSL_KEY', '/etc/letsencrypt/live/nuevo-dominio.com/privkey.pem'); }
```

### Fase 3: Pruebas Post-Despliegue

#### 3.1 Verificación de Funcionalidad Básica
```bash
# Test 1: Acceso a login
curl -I https://nuevo-dominio.com/frontend/login.php

# Test 2: API endpoints
curl -X POST https://nuevo-dominio.com/backend/core/api-endpoint.php \
    -d "datosEncriptados=test" \
    -H "Content-Type: application/x-www-form-urlencoded"

# Test 3: Carga de recursos
curl -I https://nuevo-dominio.com/frontend/assets/css/main.css
```

#### 3.2 Verificación de Sistema de Proxy
```javascript
// Test en navegador console
fetch('/backend/core/api-endpoint.php', {
    method: 'POST',
    body: new FormData().append('datosEncriptados', 'test')
}).then(r => r.json()).then(console.log);
```

#### 3.3 Verificación de Base de Datos
```sql
-- Verificar que no queden referencias al dominio anterior
SELECT * FROM setting_general_config 
WHERE config_value LIKE '%antiguo-dominio.com%';

-- Verificar configuración de WebSocket
SELECT * FROM setting_websocket_config;
```

### Fase 4: Validación de Integración

#### 4.1 Pruebas de Módulos Críticos
- **Login y autenticación**: Verificar que funcionen cookies y sesiones
- **Carga de módulos**: Probar engine.php y module-loader.js
- **API endpoints**: Verificar que respondan correctamente
- **Assets**: Confirmar que CSS/JS carguen correctamente

#### 4.2 Pruebas de WebSocket (si aplica)
```javascript
// Test de conexión WebSocket
const ws = new WebSocket('wss://nuevo-dominio.com:9002');
ws.onopen = () => console.log('WebSocket conectado');
ws.onerror = (e) => console.error('WebSocket error:', e);
```

## Checklist de Validación

### ✅ Pre-Despliegue
- [ ] Backup completo de base de datos y archivos
- [ ] Documentación de configuración actual
- [ ] Identificación de URLs hardcodeadas
- [ ] Verificación de dependencias externas

### ✅ Durante Despliegue
- [ ] Actualización de core-config.php
- [ ] Actualización de base de datos
- [ ] Configuración de SSL/TLS
- [ ] Reinicio de servicios necesarios

### ✅ Post-Despliegue
- [ ] Verificación de acceso a login
- [ ] Prueba de autenticación
- [ ] Carga correcta de assets
- [ ] Funcionamiento de APIs
- [ ] Conexión WebSocket (si aplica)
- [ ] Limpieza de caché y cookies
- [ ] Verificación de logs de errores

## Problemas Comunes y Soluciones

### Problema 1: Sesiones no funcionan después del cambio
**Causa**: Cookies configuradas para dominio anterior
**Solución**: 
```php
// Limpiar cookies antiguas
setcookie(PHLEXMOD_SESSION_NAME_WEB, '', time() - 3600, '/', '.antiguo-dominio.com');
setcookie(PHLEXMOD_SESSION_NAME_WEB, '', time() - 3600, '/', '.nuevo-dominio.com');
```

### Problema 2: Assets no cargan
**Causa**: Paths relativos rotos o proxy caído
**Solución**: 
```bash
# Limpiar caché de Redis
redis-cli FLUSHALL

# Reiniciar servidor web
sudo systemctl restart apache2
# o
sudo systemctl restart nginx
```

### Problema 3: WebSocket no conecta
**Causa**: Configuración SSL o dominio incorrecto
**Solución**: Verificar configuración en core-config.php y certificados

### Problema 4: APIs responden con error de desencriptación
**Causa**: Tokens de sesión inválidos
**Solución**: Limpiar sesión y Redis, luego probar login nuevamente

## Script Automatizado de Validación

```bash
#!/bin/bash
# validate_domain_change.sh

DOMAIN="$1"
echo "Validando despliegue en: $DOMAIN"

# Test básico
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN/frontend/login.php)
if [ "$HTTP_CODE" != "200" ]; then
    echo "❌ Error: Login no responde (HTTP $HTTP_CODE)"
    exit 1
fi

# Test API
API_RESPONSE=$(curl -s -X POST https://$DOMAIN/backend/core/api-endpoint.php \
    -d "datosEncriptados=test" | jq -r '.error // .ruta')
if [[ "$API_RESPONSE" == *"error"* ]]; then
    echo "❌ Error: API endpoint no funciona"
    exit 1
fi

# Test assets
CSS_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN/frontend/assets/css/main.css)
if [ "$CSS_CODE" != "200" ]; then
    echo "❌ Error: CSS no carga (HTTP $CSS_CODE)"
    exit 1
fi

echo "✅ Todas las pruebas básicas pasaron"
```

## Recomendaciones

1. **Ambiente de Staging**: Siempre probar en ambiente intermedio antes de producción
2. **Blue-Green Deployment**: Mantener versión anterior funcionando mientras se prueba la nueva
3. **Monitoreo**: Implementar alertas para detectar problemas rápidamente
4. **Documentación**: Mantener registro de todos los cambios realizados
5. **Rollback Automático**: Tener script de reversión listo en caso de fallos

## Comandos de Emergencia

```bash
# Rollback rápido
git checkout HEAD~1 -- core-config.php
sudo systemctl restart apache2
redis-cli FLUSHALL

# Verificar errores en tiempo real
tail -f /var/log/apache2/error.log
tail -f storage/logs/app.log
```
