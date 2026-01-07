> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# 2FA (TOTP / Email) — `auth-2fa-manager.php`

## Archivo fuente

- `backend/core/auth-2fa-manager.php`

## Propósito

Gestionar activación y verificación de 2FA (TOTP principalmente) y soporte de códigos de respaldo.

## Clases

## `SimpleQRProvider`

Implementa `RobThree\Auth\Providers\Qr\IQRCodeProvider` usando `ImageChartsQRCodeProvider`.

## `TwoFactorManager`

Constructor:
- Requiere conexión DB.
- Define `issuer = PHLEXMOD_NAME_APP`.

Métodos relevantes (públicos):

- `getQRCode($label, $secret)`
- `activateForUser($userId, $method = 'totp')`
- `generateBackupCodes($userId)`
- `generateQRCode($userId, $secret)`
- `verifyCode($userId, $code)`
- `initiate2FARecovery($userId)` (continuación en el archivo)

## Tablas

- `setting_2fa_users`
- `setting_user`
- `setting_system_config` (config `backup_codes`)

## Notas

- Para TOTP usa `RobThree\Auth\TwoFactorAuth` con ventana configurada.
- Al activar, actualiza `setting_user.two_factor_enabled` y `setting_user.two_factor_method`.

