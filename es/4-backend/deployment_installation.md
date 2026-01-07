# Guía de Instalación y Despliegue - PHLEXMOD Framework

Este documento detalla los requerimientos técnicos y el procedimiento oficial para instalar y desplegar el framework PHLEXMOD en un entorno de producción.

## 1. Requerimientos del Sistema

### 1.1 Sistema Operativo
- **Recomendado:** Linux (Ubuntu 20.04/22.04 LTS o Debian 11/12).
- **Compatible:** Cualquier sistema tipo UNIX compatible con Docker o LEMP stack.

### 1.2 Servidor Web
- **Requerido:** Nginx.
- **Razón:** El framework utiliza reglas de reescritura específicas y manejo de archivos estáticos optimizado que dependen de la configuración de Nginx (ver sección 4).

### 1.3 Lenguaje: PHP
- **Versión:** 8.4.
- **Extensiones Requeridas:**
  - `pgsql` (Driver nativo de PostgreSQL).
  - `pdo_pgsql` (Driver PDO para PostgreSQL, si se usa Eloquent u ORMs futuros).
  - `mbstring` (Manejo de cadenas multibyte).
  - `curl` (Peticiones HTTP externas).
  - `json` (Manipulación de datos JSON).
  - `xml` (Procesamiento XML).
  - `openssl` (Encriptación y seguridad).
  - `gd` (Procesamiento de imágenes).
  - `zip` (Manejo de archivos comprimidos).
  - `redis` (Cache y sesiones).

### 1.4 Base de Datos
- **Motor:** PostgreSQL.
- **Versión:** 12, 13, 14 o 15.
- **Configuración:** Codificación UTF-8.

### 1.5 Cache y Sesiones
- **Servidor:** Redis.
- **Versión:** 6.0 o superior.
- **Configuración:**
  - Puerto default: 6379.
  - Bind: 127.0.0.1 (seguridad).

---

## 2. Instalación Paso a Paso

### Paso 1: Obtener el Código
Clonar el repositorio en el directorio web (ej. `/var/www/html/phlexmod`):

```bash
cd /var/www/html
git clone git@github.com:JAG-MEDIA-SERVICIOS-C-A/Phlexmod.git phlexmod
cd phlexmod
```

### Paso 2: Instalar Dependencias
PHLEXMOD no requiere Composer en runtime para operar en producción. Los assets del frontend están en `frontend/vendors/` y las librerías PHP incluidas están en `backend/lib/`.

Composer se utiliza únicamente en entornos de desarrollo/CI para instalar herramientas de pruebas (por ejemplo, PHPUnit en `vendor/bin/`).

### Paso 3: Configuración del Entorno
Copiar el archivo de configuración de ejemplo y editarlo:

```bash
cp core-config.sample.php core-config.php
nano core-config.php
```

**Variables Críticas a Configurar:**
- `PHLEXMOD_DB_HOST`, `PHLEXMOD_DB_USER`, `PHLEXMOD_DB_PASS`: Credenciales de BD.
- `PHLEXMOD_BASE_URL`: URL base del sistema (ej. `https://mi-sistema.com/`).
- `PHLEXMOD_LOG_PATH`: Ruta absoluta para logs.

### Paso 4: Permisos de Directorios
Asegurar que el usuario del servidor web (`www-data` o `nginx`) tenga permisos de escritura en directorios clave:

```bash
chown -R www-data:www-data /var/www/html/phlexmod
chmod -R 755 /var/www/html/phlexmod
# Permisos especiales para logs y caché
chmod -R 775 /var/www/html/phlexmod/storage/logs
```

---

## 3. Configuración de Nginx (Crítico)

El framework requiere una configuración específica de Nginx para manejar el enrutamiento de módulos y el proxy de recursos seguros.

### 3.1 PHP-FPM (Dual Setup) y Sockets

PHLEXMOD puede operar con un esquema dual para mantener compatibilidad con otros sistemas del servidor:

- **PHP-FPM 8.2 (default):** para aplicaciones existentes.
- **PHP-FPM 8.4 (PHLEXMOD):** pool dedicado para el dominio de PHLEXMOD.

En producción, el vhost de PHLEXMOD debe apuntar al socket del pool dedicado:

- `/var/run/php/php8.4-fpm-phlexmod.sock`

Comandos útiles para verificar:

```bash
ls -la /var/run/php/php*.sock
systemctl status php8.4-fpm --no-pager -l
systemctl status php8.2-fpm --no-pager -l
```

**Archivo:** `/etc/nginx/sites-available/phlexmod.conf`

```nginx
server {
    listen 80;
    server_name midominio.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name midominio.com;
    root /var/www/html/phlexmod;
    index index.php index.html;

    # SSL Config (Ejemplo básico)
    ssl_certificate /path/to/fullchain.pem;
    ssl_certificate_key /path/to/privkey.pem;

    # Logs
    access_log /var/log/nginx/phlexmod-access.log;
    error_log /var/log/nginx/phlexmod-error.log warn;

    # 1. Proxy de Recursos Seguros (IMPORTANTE)
    # Permite servir archivos JS/CSS de módulos protegidos a través de load_resource.php
    location ~ ^/frontend/load_resource\.php(/|$) {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock; # Si usas pool dedicado para PHLEXMOD, apunta al socket del pool
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

    # 2. Archivos Estáticos y Caché
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|webp|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, no-transform";
        try_files $uri =404;
    }
    
    # Archivos .map (Source Maps)
    location ~* \.[mM]ap$ {
        expires 1y;
        try_files $uri =404;
    }

    # 3. Enrutamiento Principal (Frontend)
    location / {
        try_files $uri $uri/ /frontend/index.php?$args;
    }

    # 4. Enrutamiento Backend (Engine)
    location /backend/ {
        try_files $uri $uri/ /backend/engine.php?$args;
    }

    # 5. Procesamiento PHP General
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_read_timeout 300;
    }

    # Seguridad: Bloquear acceso a archivos ocultos (.git, .env)
    location ~ /\.(?!well-known) {
        deny all;
    }
}
```

---

## 4. Despliegue y Actualización (Deployment)

Para actualizar una instancia en producción:

1.  **Backup:** Realizar copia de seguridad de base de datos y archivos de configuración (`core-config.php`).
2.  **Pull:** Descargar cambios del repositorio.
    ```bash
    git pull origin main
    ```
3.  **Dependencias:** Actualizar librerías.
    ```bash
    composer install --no-interaction --no-ansi
    ```
4.  **Limpieza:** Eliminar archivos temporales o de caché si aplica.
5.  **Verificación:** Revisar logs de Nginx (`tail -f /var/log/nginx/phlexmod-error.log`) para detectar problemas inmediatos.

### Notas sobre el Proxy de Recursos (`load_resource.php`)
Si se modifican módulos que incluyen nuevos tipos de archivos o rutas relativas complejas, verificar que `load_resource.php` tenga la lógica actualizada para permitir la resolución de rutas (`realpath`) como se ajustó en la versión 2.0.0.
