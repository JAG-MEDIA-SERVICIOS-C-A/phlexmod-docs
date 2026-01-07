# Seguridad: recuperación de acceso

## Cuándo usar recuperación

Usa el flujo de recuperación si:

- Perdiste tu segundo factor (2FA).
- No puedes generar códigos válidos.

## Qué esperar

- Se generará un código temporal.
- El código expira.
- Tras validación, el sistema puede desactivar temporalmente el 2FA para permitir el acceso.

## Referencia técnica (para soporte)

- Recuperación 2FA:
  - `backend/core/recovery-manager.php`
- Envío de correos:
  - `backend/core/mail-manager.php`
