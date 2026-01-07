> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Gestor de Correo (`mail-manager.php`)

Clase centralizada para el envío de correos electrónicos transaccionales y notificaciones del sistema. Soporta múltiples drivers (SMTP, SendGrid) y gestión de plantillas en base de datos.

## 📍 Archivo Fuente
`backend/core/mail-manager.php`

## 🚀 Características
*   **Soporte Multi-Driver**: Prioriza SMTP (si está configurado en BD), con fallback automático a SendGrid API.
*   **Plantillas Dinámicas**: Carga asuntos y cuerpos HTML desde la tabla `setting_email_templates`.
*   **Sustitución de Variables**: Reemplaza marcadores `{{ variable }}` con datos reales de forma segura (escaping HTML automático).

## 📋 Configuración

### Base de Datos (`setting_email_config`)
Si existe un registro en esta tabla, el sistema intentará usar SMTP.
*   `host`: Servidor SMTP.
*   `port`: Puerto (587, 465, 25).
*   `username`: Usuario de autenticación.
*   `password`: Contraseña.
*   `encryption`: `tls` o `ssl`.
*   `from_email` / `from_name`: Remitente por defecto.

### Fallback (SendGrid)
Si no hay config SMTP, usa constantes definidas en `core-config.php`:
*   `SENDGRID_API_KEY`
*   `SENDGRID_FROM_EMAIL`
*   `SENDGRID_FROM_NAME`

## 💻 API de la Clase `EmailManager`

### `enviarCorreo($toEmail, $templateName, $variables = [])`
Método principal de envío.

*   **$toEmail**: Dirección del destinatario.
*   **$templateName**: Nombre único de la plantilla en `setting_email_templates`.
*   **$variables**: Array asociativo `['clave' => 'valor']` para reemplazar en la plantilla.

**Retorno**: `true` si se envió, `false` o error en caso contrario.

### Ejemplo de Uso

```php
$mailManager = new EmailManager($dbConnection);

$vars = [
    'nombre' => 'Juan Perez',
    'codigo' => '123456'
];

if ($mailManager->enviarCorreo('juan@email.com', '2fa_code', $vars)) {
    echo "Correo enviado exitosamente";
}
```

## 📂 Dependencias
*   **PHPMailer**: Para envíos SMTP (`backend/lib/PHPMailer`).
*   **sendgrid-php**: Para envíos vía API SendGrid (`backend/lib/sendgrid-php`).
