> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Documentación API del Módulo de Correo Electrónico (Sistema de Administración)

## Descripción General

Esta documentación describe los endpoints API disponibles para el módulo de correo electrónico en el framework PHLEXMOD. Este módulo forma parte del **sistema de administración** (`backend/modules/admin/`) y no de los módulos de cliente. Estos endpoints permiten gestionar la configuración SMTP y las plantillas de correo electrónico que serán utilizadas por todo el sistema.

**Base URL (actual)**: `/backend/modules/admin/email/endpoints/`

**Compatibilidad (legacy)**: existe un conjunto adicional de endpoints bajo `backend/modules/admin/settings/endpoints/mail_api/`.

**Contexto**: Este módulo pertenece al sistema de administración y gestiona la configuración global de correo electrónico utilizada por todos los módulos del sistema PHLEXMOD.

## Índice

1. [Configuración SMTP](#configuración-smtp)
   - [Obtener Configuración SMTP](#obtener-configuración-smtp)
   - [Guardar Configuración SMTP](#guardar-configuración-smtp)
   - [Actualizar Configuración SMTP](#actualizar-configuración-smtp)
   - [Probar Configuración SMTP](#probar-configuración-smtp)
2. [Plantillas de Correo](#plantillas-de-correo)
   - [Listar Plantillas](#listar-plantillas)
   - [Obtener Plantilla](#obtener-plantilla)
   - [Crear Plantilla](#crear-plantilla)
   - [Actualizar Plantilla](#actualizar-plantilla)
   - [Eliminar Plantilla](#eliminar-plantilla)
   - [Probar Plantilla](#probar-plantilla)
3. [Integración con SendGrid](#integración-con-sendgrid)
   - [Probar SendGrid](#probar-sendgrid)
4. [Códigos de Estado](#códigos-de-estado)
5. [Manejo de Errores](#manejo-de-errores)

## Configuración SMTP

### Obtener Configuración SMTP

Recupera la configuración SMTP actual.

- **URL**: `/get_smtp_config.api.php`
- **Método**: `GET`
- **Parámetros**: Ninguno
- **Respuesta Exitosa**:
  ```json
  {
    "status": "success",
    "data": {
      "smtp_host": "smtp.example.com",
      "smtp_port": "587",
      "smtp_user": "user@example.com",
      "smtp_password": "********",
      "smtp_secure": "tls",
      "from_email": "noreply@example.com",
      "from_name": "Sistema PHLEXMOD"
    }
  }
  ```
- **Respuesta de Error**:
  ```json
  {
    "status": "error",
    "message": "No se pudo obtener la configuración SMTP"
  }
  ```

### Guardar Configuración SMTP

Guarda una nueva configuración SMTP.

- **URL**: `/save_smtp_config.api.php`
- **Método**: `POST`
- **Parámetros**:
  - `smtp_host` (string, requerido): Servidor SMTP
  - `smtp_port` (integer, requerido): Puerto SMTP (1-65535)
  - `smtp_user` (string, requerido): Usuario SMTP
  - `smtp_password` (string, requerido): Contraseña SMTP
  - `smtp_secure` (string, opcional): Tipo de seguridad (tls, ssl, ninguno)
  - `from_email` (string, requerido): Email del remitente
  - `from_name` (string, requerido): Nombre del remitente
- **Respuesta Exitosa**:
  ```json
  {
    "status": "success",
    "message": "Configuración SMTP guardada correctamente"
  }
  ```
- **Respuesta de Error**:
  ```json
  {
    "status": "error",
    "message": "Error al guardar la configuración SMTP"
  }
  ```

### Actualizar Configuración SMTP

Actualiza una configuración SMTP existente.

- **URL**: `/update_smtp_config.api.php`
- **Método**: `POST`
- **Parámetros**: Los mismos que para guardar configuración
- **Respuestas**: Las mismas que para guardar configuración

### Probar Configuración SMTP

Prueba la configuración SMTP enviando un correo de prueba.

- **URL**: `/test_smtp_config.api.php`
- **Método**: `POST`
- **Parámetros**:
  - `test_email` (string, requerido): Email de destino para la prueba
- **Respuesta Exitosa**:
  ```json
  {
    "status": "success",
    "message": "Correo de prueba enviado correctamente"
  }
  ```
- **Respuesta de Error**:
  ```json
  {
    "status": "error",
    "message": "Error al enviar el correo de prueba: [detalles del error]"
  }
  ```

## Plantillas de Correo

### Listar Plantillas

Obtiene todas las plantillas de correo disponibles.

- **URL**: `/get_email_templates.api.php`
- **Método**: `GET`
- **Parámetros**: Ninguno
- **Respuesta Exitosa**:
  ```json
  {
    "status": "success",
    "data": [
      {
        "id": 1,
        "name": "Bienvenida",
        "subject": "Bienvenido a nuestro sistema",
        "variables": "{\"variables\":[\"nombre\",\"empresa\"]}",
        "active": 1,
        "created_at": "2025-07-01 10:00:00",
        "updated_at": "2025-07-10 15:30:00"
      },
      {
        "id": 2,
        "name": "Recuperación de contraseña",
        "subject": "Recuperación de contraseña",
        "variables": "{\"variables\":[\"nombre\",\"enlace\"]}",
        "active": 1,
        "created_at": "2025-07-01 10:00:00",
        "updated_at": "2025-07-10 15:30:00"
      }
    ]
  }
  ```
- **Respuesta de Error**:
  ```json
  {
    "status": "error",
    "message": "Error al obtener las plantillas"
  }
  ```

### Obtener Plantilla

Obtiene una plantilla específica por su ID.

- **URL**: `/get_email_template.api.php`
- **Método**: `POST`
- **Parámetros**:
  - `id` (integer, requerido): ID de la plantilla
- **Respuesta Exitosa**:
  ```json
  {
    "status": "success",
    "template": {
      "id": 1,
      "name": "Bienvenida",
      "subject": "Bienvenido a nuestro sistema",
      "body": "<html><body><h1>¡Bienvenido, {{nombre}}!</h1><p>Gracias por registrarte en {{empresa}}.</p></body></html>",
      "variables": "{\"variables\":[\"nombre\",\"empresa\"]}",
      "active": 1,
      "created_at": "2025-07-01 10:00:00",
      "updated_at": "2025-07-10 15:30:00"
    }
  }
  ```
- **Respuesta de Error**:
  ```json
  {
    "status": "error",
    "message": "Plantilla no encontrada"
  }
  ```

### Crear Plantilla

Crea una nueva plantilla de correo.

- **URL**: `/create_email_template.api.php`
- **Método**: `POST`
- **Parámetros**:
  - `template_name` (string, requerido): Nombre de la plantilla
  - `template_subject` (string, requerido): Asunto del correo
  - `template_body` (string, requerido): Cuerpo HTML del correo
  - `template_variables` (string, requerido): Variables en formato JSON
  - `template_active` (string, opcional): Estado de activación (1=activo, 0=inactivo)
- **Respuesta Exitosa**:
  ```json
  {
    "status": "success",
    "message": "Plantilla creada correctamente",
    "template_id": 3
  }
  ```
- **Respuesta de Error**:
  ```json
  {
    "status": "error",
    "message": "Error al crear la plantilla: [detalles del error]"
  }
  ```

### Actualizar Plantilla

Actualiza una plantilla existente.

- **URL**: `/update_email_template.api.php`
- **Método**: `POST`
- **Parámetros**:
  - `template_id` (integer, requerido): ID de la plantilla
  - `template_name` (string, requerido): Nombre de la plantilla
  - `template_subject` (string, requerido): Asunto del correo
  - `template_body` (string, requerido): Cuerpo HTML del correo
  - `template_variables` (string, requerido): Variables en formato JSON
  - `template_active` (string, opcional): Estado de activación (1=activo, 0=inactivo)
- **Respuesta Exitosa**:
  ```json
  {
    "status": "success",
    "message": "Plantilla actualizada correctamente"
  }
  ```
- **Respuesta de Error**:
  ```json
  {
    "status": "error",
    "message": "Error al actualizar la plantilla: [detalles del error]"
  }
  ```

### Eliminar Plantilla

Elimina una plantilla existente.

- **URL**: `/delete_email_template.api.php`
- **Método**: `POST`
- **Parámetros**:
  - `id` (integer, requerido): ID de la plantilla
- **Respuesta Exitosa**:
  ```json
  {
    "status": "success",
    "message": "Plantilla eliminada correctamente"
  }
  ```
- **Respuesta de Error**:
  ```json
  {
    "status": "error",
    "message": "Error al eliminar la plantilla: [detalles del error]"
  }
  ```

### Probar Plantilla

Envía un correo de prueba utilizando una plantilla específica.

- **URL**: `/test_email_template.api.php`
- **Método**: `POST`
- **Parámetros**:
  - `template_id` (integer, requerido): ID de la plantilla
  - `test_email` (string, requerido): Email de destino para la prueba
  - `test_variables` (string, opcional): Variables de prueba en formato JSON
- **Respuesta Exitosa**:
  ```json
  {
    "status": "success",
    "message": "Correo de prueba enviado correctamente"
  }
  ```
- **Respuesta de Error**:
  ```json
  {
    "status": "error",
    "message": "Error al enviar el correo de prueba: [detalles del error]"
  }
  ```

## Integración con SendGrid

### Probar SendGrid

Prueba la integración con SendGrid enviando un correo de prueba.

- **URL**: `/test_sendgrid.api.php`
- **Método**: `POST`
- **Parámetros**:
  - `api_key` (string, requerido): API Key de SendGrid
  - `from_email` (string, requerido): Email del remitente
  - `from_name` (string, requerido): Nombre del remitente
  - `to_email` (string, requerido): Email de destino para la prueba
  - `subject` (string, requerido): Asunto del correo
  - `content` (string, requerido): Contenido HTML del correo
- **Respuesta Exitosa**:
  ```json
  {
    "status": "success",
    "message": "Correo enviado correctamente a través de SendGrid"
  }
  ```
- **Respuesta de Error**:
  ```json
  {
    "status": "error",
    "message": "Error al enviar el correo a través de SendGrid: [detalles del error]"
  }
  ```

## Códigos de Estado

Todos los endpoints utilizan los siguientes códigos de estado en sus respuestas:

- `success`: La operación se completó correctamente
- `error`: Ocurrió un error durante la operación

## Manejo de Errores

Todos los endpoints devuelven mensajes de error descriptivos en caso de fallo. Los errores comunes incluyen:

- Método HTTP no permitido
- Campos requeridos faltantes
- Errores de validación de datos
- Errores de conexión a la base de datos
- Errores de envío de correo

## Notas de Seguridad

- Todos los endpoints validan y sanitizan las entradas para prevenir inyecciones SQL y XSS
- Las contraseñas SMTP y API Keys se almacenan de forma segura
- Se recomienda acceder a estos endpoints solo desde el backend de la aplicación
- Los endpoints requieren autenticación a través del sistema de sesiones de PHLEXMOD

## Ubicación en la Estructura Modular

Este módulo sigue la estructura modular definida en `backend/modules/admin/<modulo>/` y se ubica específicamente en:

```
/backend/modules/admin/email/   # Módulo administrativo independiente
  ├── endpoints/               # Endpoints API del módulo de correo
  ├── ui/                      # Interfaces de usuario del módulo de correo
  ├── js/                      # Lógica JavaScript del módulo
  └── email.php                # Punto de entrada del módulo

/backend/modules/admin/settings/endpoints/mail_api/  # Legacy (si aplica)
```

Esta ubicación refleja que es un módulo administrativo y no un módulo de cliente.

---
**Versión de la documentación**: 1.0.0  
**Última actualización**: 2025-07-11  
**Autor**: JAG-Media Servicios, C.A.
