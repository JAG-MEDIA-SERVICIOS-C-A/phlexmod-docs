> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Recuperación de 2FA — `recovery-manager.php`

## Archivo fuente

- `backend/core/recovery-manager.php`

## Propósito

Proveer un flujo de recuperación cuando un usuario pierde su segundo factor, generando un código temporal y desactivando 2FA tras validación.

## Clase `RecoveryManager`

### Constructor

- Requiere `$db`.
- Instancia:
  - `EmailManager`
  - `TwoFactorManager`

### Métodos

## `initiateRecoveryByEmail($email)`

- Verifica usuario con 2FA activo (`setting_user.two_factor_enabled = true`).
- Genera código de recuperación.
- Inserta en `setting_2fa_recovery_codes` con expiración (+15 min).
- Envía correo usando `EmailManager` y template `2fa_code`.

## `verifyRecoveryCode($code)`

- Valida que el código exista, no esté usado y no esté expirado.
- Marca como usado.
- Retorna `user_id`.

## `disableTwoFactorAuth($userId)`

- Transaccional.
- Actualiza:
  - `setting_user` (`two_factor_enabled=false`, `two_factor_method='none'`)
  - `setting_2fa_users` (`is_active=false`)
- Inserta audit en `setting_2fa_audit_log`.

## `completeRecovery($code)`

- Ejecuta `verifyRecoveryCode` → `disableTwoFactorAuth`.
- Envía email template `2FA_DISABLED`.

