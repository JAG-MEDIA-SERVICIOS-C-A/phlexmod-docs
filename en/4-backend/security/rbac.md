> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Seguridad y Control de Acceso (RBAC)

PHLEXMOD implementa un sistema de autenticación robusto y un control de acceso basado en roles (RBAC) gestionado principalmente a través de la base de datos y el `auth-manager.php`.

## Autenticación (`auth-manager.php`)

El archivo `backend/core/auth-manager.php` es el responsable de gestionar el ciclo de vida de la sesión y la validación de credenciales.

### Características
- **Soporte Multi-factor (2FA):** Compatible con TOTP (Google Authenticator) y códigos por correo electrónico.
- **Protección contra Fuerza Bruta:** Bloqueo temporal de IPs tras múltiples intentos fallidos.
- **Retardo Adaptativo:** Introduce pausas artificiales en las respuestas de login para desalentar ataques automatizados.
- **Registro de Auditoría:** Almacena intentos de acceso y bloqueos en `security_login_attempts` y `security_login_locks`.

### Flujo de Login
1. **Sanitización:** Los datos de entrada (`login`, `password`) son limpiados.
2. **Verificación IP:** Se consulta si la IP está bloqueada.
3. **Consulta BD:** Se busca el usuario en la tabla `setting_user`.
4. **Verificación Password:** Se usa `password_verify` contra el hash almacenado.
5. **Evaluación 2FA:** Si está activo, se redirige al flujo de verificación de segundo factor.
6. **Creación de Sesión:** Se establecen las variables de sesión críticas.

## Variables de Sesión

Una vez autenticado, el sistema dispone de las siguientes variables globales en `$_SESSION`:

- `$_SESSION['idLogin']`: ID único del usuario (`uid`).
- `$_SESSION['login']`: Nombre de usuario.
- `$_SESSION['tipou']`: Rol o tipo de usuario (clave para el RBAC).
- `$_SESSION['iddep']`: ID del departamento asociado.
- `$_SESSION['avatar']`: Iniciales o URL del avatar.

## Tablas de Seguridad

El sistema se apoya en las siguientes estructuras de base de datos (PostgreSQL):

### `setting_user`
Almacena la información principal de los usuarios.
- `uid`: ID primario.
- `usuario`: Nombre de login.
- `password_hash`: Contraseña encriptada.
- `tipou`: Rol del usuario.
- `two_factor_enabled`: Flag booleano ('t'/'f').

### `setting_2fa_users`
Configuración específica del segundo factor.
- `secret_key`: Semilla para TOTP.
- `method`: 'totp' o 'email'.

### `security_login_attempts` y `security_login_locks`
Tablas volátiles para el control de intentos fallidos y bloqueos de IP.

## Implementación de Permisos

Actualmente, el control de acceso a módulos se realiza mediante la validación de "Privilegios" almacenados en la base de datos, que vinculan el `tipou` (rol) con los módulos disponibles en el menú.

El `engine.php` consulta estos privilegios antes de cargar cualquier módulo. Si un usuario intenta acceder a un módulo para el cual no tiene permiso, el motor devuelve un error 403 o redirige.
