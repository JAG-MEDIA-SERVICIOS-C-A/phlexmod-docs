# Licenciamiento (PRO) — `License*`

## Archivos fuente

- `backend/core/LicenseManager.php`
- `backend/core/LicenseValidator.php`
- `backend/core/LicenseMiddleware.php`

## Propósito

Proveer validación de licencia (local/remote) y protección de features PRO.

## Componentes

### `PHLEXMOD\Core\LicenseManager`

Responsable de:

- CRUD de licencia en DB (`setting_license`).
- Generación de `installation_id`.

Métodos destacados:

- `getInstallationId()`
- `getLicense()`
- `saveLicense($licenseKey, $apiResponse = [])`
- `isExpired($license = null)`
- `incrementFailures()`
- `suspend()`
- `updateStatus($status)`
- `getStatusSummary()`

### `PHLEXMOD\Core\LicenseValidator`

- Valida licencia:
  - cache local (< 24h) o
  - API remota (`PHLEXMOD_LICENSE_API` o default `https://licenses.jagmedia.com.ve/api/validate`).
- Implementa grace period por fallos (default 7).

Métodos destacados:

- `validate($forceRemote = false)`
- `periodicValidation()` - para cron
- `isCacheValid($license)` - verifica caché de 24h
- `remoteValidation($license)` - llamada a API
- `localValidation($license)` - validación desde caché

### `PHLEXMOD\Core\LicenseMiddleware`

- `checkFeature($feature)` lanza excepción si no está permitido.
- `httpCheckFeature($feature)` devuelve JSON 403 con código `LICENSE_REQUIRED`.

Métodos destacados:

- `checkFeature($feature)` - valida feature específico
- `hasFeature($feature)` - versión sin excepción
- `getAvailableFeatures()` - lista features habilitados
- `requireLicense()` - requiere licencia válida
- `getStatus()` - estado completo para UI
- `isTrialMode()` - verifica modo trial

## Flujo de Validación

1. **Middleware** solicita validación a **LicenseValidator**
2. **Validator** verifica caché local (< 24h)
3. Si caché inválida o forzada, llama API remota
4. **LicenseManager** actualiza DB con respuesta API
5. **Middleware** permite/deniega acceso al feature

## Features PRO Disponibles

- `2fa` - Autenticación de dos factores
- `binance` - Integración con Binance API
- `sendgrid` - Servicio de email transaccional
- `websockets` - Comunicación en tiempo real

## Configuración

```php
// API endpoint (opcional)
define('PHLEXMOD_LICENSE_API', 'https://licenses.jagmedia.com.ve/api/validate');

// Grace period en días (opcional)
define('PHLEXMOD_LICENSE_GRACE_PERIOD', 7);
```

## Uso Básico

```php
// Requerir licencia válida
$middleware = new LicenseMiddleware();
$middleware->requireLicense();

// Verificar feature específico
$middleware->checkFeature('2fa'); // lanza excepción si no disponible

// Verificar sin excepción
if ($middleware->hasFeature('websockets')) {
    // usar websockets
}

// Obtener estado para UI
$status = $middleware->getStatus();
```

## Estructura de Base de Datos

```sql
-- Tabla principal de licencias
CREATE TABLE setting_license (
  id serial PRIMARY KEY,
  license_key varchar(255) NOT NULL UNIQUE,
  domain varchar(255),
  installation_id varchar(128) UNIQUE,
  activated_at timestamp DEFAULT NOW(),
  expires_at timestamp,
  max_users int4 DEFAULT 10,
  features_enabled jsonb DEFAULT '{"2fa": true, "binance": false, "sendgrid": false, "websockets": false}'::jsonb,
  status varchar(20) DEFAULT 'trial',
  last_validated timestamp DEFAULT NOW(),
  validation_failures int4 DEFAULT 0,
  api_response jsonb,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp DEFAULT NOW()
);
```

## Estados de Licencia

- **`trial`** - Modo de prueba (sin licencia)
- **`active`** - Licencia activa y válida
- **`expired`** - Licencia expirada
- **`suspended`** - Suspendida por fallos de validación

## Respuestas de Validación

### Local (Cache)
```json
{
  "valid": true,
  "source": "local",
  "message": "License valid (cached)",
  "features": {"2fa": true, "websockets": false}
}
```

### Remota (API)
```json
{
  "valid": true,
  "source": "remote",
  "message": "License validated successfully",
  "features": {"2fa": true, "binance": true, "sendgrid": true}
}
```

### Grace Period
```json
{
  "valid": true,
  "source": "grace",
  "message": "Validation failed, grace period active: Connection timeout",
  "features": {"2fa": true, "websockets": false}
}
```

## Errores Comunes

### License Required (HTTP 403)
```json
{
  "success": false,
  "error": "La característica 'websockets' no está habilitada en tu licencia",
  "code": "LICENSE_REQUIRED",
  "upgrade_url": "https://phlexmod.jagmedia.com.ve/upgrade"
}
```

### License Expired
```json
{
  "valid": false,
  "source": "local",
  "message": "License expired",
  "features": []
}
```

## Implementación en Módulos

### Para proteger un endpoint:
```php
<?php
// backend/modules/websockets/endpoints/connect.api.php
require_once __DIR__ . '/../../../core/LicenseMiddleware.php';

$middleware = new PHLEXMOD\Core\LicenseMiddleware();
$middleware->httpCheckFeature('websockets');

// Continuar con el código del endpoint...
```

### Para proteger en UI:
```php
<?php
// backend/modules/websockets/ui/dashboard.php
$middleware = new PHLEXMOD\Core\LicenseMiddleware();
$hasWebsockets = $middleware->hasFeature('websockets');

if (!$hasWebsockets) {
    echo '<div class="license-required">';
    echo '  <h3>Feature PRO Required</h3>';
    echo '  <p>Websockets require a PRO license.</p>';
    echo '  <a href="https://phlexmod.jagmedia.com.ve/upgrade" class="btn btn-primary">Upgrade Now</a>';
    echo '</div>';
    exit;
}
```

## Configuración de Cron

```bash
# Validación periódica (cada 6 horas)
0 */6 * * * /usr/bin/php /var/www/html/phlexmod/backend/core/cron_license_validation.php
```

```php
<?php
// backend/core/cron_license_validation.php
require_once __DIR__ . '/LicenseValidator.php';

$validator = new PHLEXMOD\Core\LicenseValidator();
$validator->periodicValidation();
```

## Logs del Sistema

- **`logs/license_validation.log`** - Registro de validaciones automáticas
- **`logs/license_access.log`** - Registro de acceso a features

## Consideraciones de Seguridad

- **Installation ID único** basado en características del servidor
- **Validación de dominio** evita transferencia de licencias
- **Límite de usuarios** configurable por licencia
- **Suspend automática** después de fallos consecutivos
- **Encriptación** de comunicación con API remota

## Actualización Manual

```php
<?php
// Forzar validación remota
$validator = new PHLEXMOD\Core\LicenseValidator();
$result = $validator->validate(true); // forceRemote = true

if ($result['valid']) {
    echo "License validated: " . $result['message'];
} else {
    echo "License invalid: " . $result['message'];
}
```
