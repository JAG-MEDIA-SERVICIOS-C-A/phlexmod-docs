# Correo (SMTP/SendGrid) — `mail-manager.php`

## Archivo fuente

- `backend/core/mail-manager.php`

## Propósito

Enviar correos usando:

- SMTP (preferido si existe configuración en BD), o
- SendGrid (fallback si no hay config SMTP en BD).

## Clase `EmailManager`

### Dependencias

- `backend/core/config.php`
- `backend/core/Logger.php`
- PHPMailer en `backend/lib/PHPMailer/` (si se usa SMTP)
- SendGrid SDK si existe en `backend/lib/sendgrid-php/`

### Métodos

## `enviarCorreo($toEmail, $templateName, $variables = [])`

- Obtiene config SMTP desde `setting_email_config`.
- Si hay SMTP:
  - usa `enviarCorreoSMTP(...)`.
- Si no hay SMTP:
  - usa `enviarCorreoSendGrid(...)`.

## Templates

- `setting_email_templates` (subject, body, active)
- Variables soportadas como placeholders:
  - `{{nombre}}` o `{{ nombre }}`

## Ejemplo

```php
require_once PHLEXMOD_CORE_PATH . 'mail-manager.php';

$email = new EmailManager($conexion);
$email->enviarCorreo('user@example.com', 'two_factor_code', ['nombre' => 'Juan']);
```
