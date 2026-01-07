> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# User Agent / Device Info — `user_info.php`

## Archivo fuente

- `backend/core/user_info.php`

## Propósito

Detectar información básica del cliente (IP, OS, navegador, tipo de dispositivo) a partir de variables de entorno (`$_SERVER`).

## Clase `UserInfo`

## `UserInfo::get_ip()`

- Busca IP en múltiples headers (`HTTP_X_FORWARDED_FOR`, `REMOTE_ADDR`, etc.).

## `UserInfo::get_os()`

- Devuelve un string con OS aproximado basado en regex sobre `HTTP_USER_AGENT`.

## `UserInfo::get_browser()`

- Devuelve un string con navegador aproximado basado en regex.

## `UserInfo::get_device()`

- Devuelve `Tablet`, `Mobile` o `Computer`.

## Ejemplo

```php
include PHLEXMOD_CORE_PATH . 'user_info.php';

$ip = UserInfo::get_ip();
$os = UserInfo::get_os();
$browser = UserInfo::get_browser();
$device = UserInfo::get_device();
```
