> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Rutas y Configuración

PHLEXMOD centraliza su configuración global en el archivo `core-config.php` ubicado en la raíz del proyecto. Este archivo define constantes esenciales para el funcionamiento del framework, siguiendo los principios de aislamiento modular.

> **Importante:** El archivo `core-config.php` contiene credenciales sensibles y **no debe ser rastreado por git**. Utiliza `core-config.sample.php` como plantilla.

## Constantes de Sistema

### Rutas de Directorios (Filesystem)
Definen la ubicación física de los componentes en el servidor.

| Constante | Descripción | Valor Típico |
|-----------|-------------|--------------|
| `PHLEXMOD_PATH` | Ruta base del script ejecutado | `/var/www/html/phlexmod` |
| `PHLEXMOD_BACKEND_PATH` | Ruta al backend | `.../backend/` |
| `PHLEXMOD_FRONTEND_PATH` | Ruta al frontend | `.../frontend/` |
| `PHLEXMOD_MODULES_PATH` | Directorio base de módulos | `.../backend/modules/` |
| `PHLEXMOD_MODULES_ADMIN_PATH` | Módulos administrativos | `.../backend/modules/admin/` |
| `PHLEXMOD_CORE_PATH` | Núcleo del framework | `.../backend/core/` |
| `PHLEXMOD_VENDOR_PATH` | Librerías de terceros | `/frontend/vendors/` |

### URLs (Web)
Definen las direcciones públicas accesibles vía navegador.

| Constante | Descripción |
|-----------|-------------|
| `PHLEXMOD_BASE_URL` | URL raíz del proyecto (ej: `https://midominio.com/`) |
| `PHLEXMOD_WEB_URL` | URL base del frontend |
| `PHLEXMOD_ASSETS_PATH` | Ruta relativa a assets públicos |

## Configuración de Base de Datos
PHLEXMOD utiliza PostgreSQL como motor principal.

```php
define('PHLEXMOD_DB_HOST', 'localhost');
define('PHLEXMOD_DB_PORT', '5432');
define('PHLEXMOD_DB_DATABASE', 'phlexmod');
define('PHLEXMOD_DB_USER', 'postgres');
define('PHLEXMOD_DB_PASS', 'tu_contraseña');
```

## Seguridad y Sesión

- `PHLEXMOD_SESSION_NAME_WEB`: Nombre de la cookie de sesión.
- `PHLEXMOD_PASS_ENCRYPT`: Clave maestra para encriptación reversible (openssl).
- `PHLEXMOD_METHOD_ENCRYPT`: Algoritmo de cifrado (default: `aes-256-cbc`).
- `PHLEXMOD_TIME_ZONE_WEB`: Zona horaria (default: `America/Caracas`).

## Variables de Entorno y Meta

- `ENVIRONMENT`: `development` o `production`.
- `PHLEXMOD_VERSION_APP`: Versión actual del aplicativo.
- `PHLEXMOD_META_*`: Configuración de SEO y metadatos HTML (Author, Description, Keywords).

## Configuración de Logs

- `PHLEXMOD_LOG_PATH`: Directorio de logs (`storage/logs/`).
- `PHLEXMOD_LOG_LEVEL`: Nivel de detalle (`DEBUG`, `ERROR`, etc.).

## Integraciones (Ejemplos)

El archivo también puede contener constantes para servicios externos:
- **SendGrid:** `PHLEXMOD_SENDGRID_API_KEY`
- **WebSocket:** `PHLEXMOD_WS_HOST`, `PHLEXMOD_WS_PORT`
- **Binance/Bancos:** Keys específicas de APIs financieras.
