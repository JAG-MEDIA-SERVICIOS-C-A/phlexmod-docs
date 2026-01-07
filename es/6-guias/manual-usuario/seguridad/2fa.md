# Seguridad: 2FA (Doble Factor)

## Qué es 2FA

El 2FA agrega una capa extra de seguridad además de tu contraseña.

## Métodos comunes

Según la configuración, el sistema puede usar:

- **TOTP** (ej. Google Authenticator)
- **Email** (código enviado al correo)

## Recomendaciones

- Guarda tus códigos de respaldo si el sistema los genera.
- No compartas códigos ni capturas de pantalla.

## Referencia técnica (para soporte)

- Implementación 2FA:
  - `backend/core/auth-2fa-manager.php`
