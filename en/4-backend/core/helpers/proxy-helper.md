> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Proxy de recursos — `proxy-helper.php`

## Archivo fuente

- `backend/core/proxy-helper.php`

## Propósito

Ocultar rutas reales del servidor y servir recursos (assets del core y vendors) a través del proxy (`frontend/load_resource.php`) usando un token asociado a sesión (y opcionalmente Redis) para mapear una raíz autorizada.

## Funciones

## `get_proxied_asset_url($webPath)`

| Campo | Valor |
|---|---|
| **Firma** | `function get_proxied_asset_url($webPath): string` |
| **Entrada** | `$webPath` ruta web (`/frontend/...`, `assets/...`, `vendors/...`) o ruta absoluta del filesystem |
| **Salida** | URL ofuscada del proxy (ruta tipo `.../load_resource.php/<token>/<relativePath>`) |

### Comportamiento

- Asegura sesión (usa `PHLEXMOD_SESSION_NAME_WEB` si está definida).
- Resuelve `$webPath` a una ruta absoluta existente (`realpath`).
- Determina una **raíz autorizada** (`$authRoot`):
  - Si el recurso pertenece a `vendors/<vendorName>/`, autoriza la carpeta del vendor.
  - Si detecta `/modules/`, autoriza la raíz del módulo (nota: la lógica depende de la forma del path real).
- Genera un token `sha256` basado en un `proxy_salt` de sesión + `$authRoot`.
- Guarda el mapeo `token -> authRoot` en:
  - Redis (`proxy_map:<token>`, TTL 7200s) si está disponible, o
  - `$_SESSION['resource_map'][token]` como fallback.
- Devuelve la URL del proxy usando `PHLEXMOD_WEB_URL` si está definida, o `/frontend/` por defecto.

### Consideraciones

- Si no existe el archivo o no se puede iniciar sesión, retorna `$webPath` tal cual.
- Si `$webPath` comienza por `http`, se considera externo y se retorna tal cual.

### Ejemplo

```php
require_once PHLEXMOD_CORE_PATH . 'proxy-helper.php';

$jsUrl = get_proxied_asset_url('/frontend/assets/js/module-loader.js');
echo "<script src=\"{$jsUrl}\"></script>";
```

## `get_proxied_image_url($path)`

| Campo | Valor |
|---|---|
| **Firma** | `function get_proxied_image_url($path): string` |
| **Entrada** | `$path` ruta a imagen (ej. `/assets/img/logo.png` o `logo.png`) |
| **Salida** | URL ofuscada del proxy |

### Comportamiento

- Si `$path` no empieza por `/` ni por `assets/`, asume `'/assets/img/' . $path`.
- Delegación: retorna `get_proxied_asset_url($imgPath)`.

### Ejemplo

```php
<img src="<?= get_proxied_image_url('logo.png') ?>" alt="Logo">
```
