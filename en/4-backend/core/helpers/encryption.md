> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Cifrado — `encryption.php`

## Archivo fuente

- `backend/core/encryption.php`

## Propósito

Proveer dos closures globales (`$encriptar`, `$desencriptar`) para cifrar/descifrar valores (normalmente rutas o parámetros de navegación) usando AES con IV dinámico.

## Dependencias

- Constantes requeridas (desde `core-config.php`):
  - `PHLEXMOD_PASS_ENCRYPT` (clave)
  - `PHLEXMOD_METHOD_ENCRYPT` (método, por defecto se usa `aes-256-cbc` en instalaciones típicas)

## Closures

## `$encriptar`

| Campo | Valor |
|---|---|
| **Firma** | `$encriptar = function ($valor) use ($method, $clave)` |
| **Entrada** | `$valor` (`string|null`) |
| **Salida** | `string|null` (Base64 con IV + ciphertext) |

### Reglas

- Si `$valor` es `null`, retorna `null`.
- Genera un IV aleatorio por operación.
- Retorna `base64_encode($iv . $texto_cifrado)`.

## `$desencriptar`

| Campo | Valor |
|---|---|
| **Firma** | `$desencriptar = function ($valor) use ($method, $clave)` |
| **Entrada** | `$valor` (`string|null`) |
| **Salida** | `string|null` |

### Reglas

- Si `$valor` es `null`, retorna `null`.
- Si `base64_decode` falla, retorna `null`.
- Valida longitud de IV y payload antes de descifrar.

## Ejemplo

```php
require_once PHLEXMOD_CORE_PATH . 'encryption.php';

$token = $encriptar('/var/www/html/phlexmod/backend/modules/admin/email/js/');
$ruta = $desencriptar($token);
```
