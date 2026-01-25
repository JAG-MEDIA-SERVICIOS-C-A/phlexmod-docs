# Guía de Instalación y Configuración Inicial

**Última actualización:** Enero 2026

## 1. Requisitos del Sistema

Antes de comenzar, asegúrese de que su servidor cumpla con los siguientes requisitos mínimos. PHLEXMOD está diseñado para ser ligero pero requiere componentes modernos.

### Software Base
- **Sistema Operativo:** Ubuntu 22.04 LTS / Debian 12 (Recomendado)
- **Servidor Web:** Nginx (Recomendado) o Apache 2.4+
- **Base de Datos:** PostgreSQL 13+
- **Lenguaje:** PHP 8.4 (FPM)
- **Cache (Opcional pero recomendado):** Redis 6+

### Extensiones PHP Requeridas
Asegúrese de instalar las siguientes extensiones:
- `pgsql` y `pdo_pgsql` (Conexión a base de datos)
- `mbstring` (Manejo de cadenas)
- `curl` (Peticiones externas)
- `json` (Procesamiento de datos)
- `xml` (Manipulación de XML)
- `zip` (Manejo de archivos comprimidos)
- `gd` (Procesamiento de imágenes)

---

## 2. Instalación Paso a Paso

### Paso 1: Obtener el Código
Clone el repositorio oficial en su directorio web (ej. `/var/www/html/phlexmod`):

```bash
cd /var/www/html
git clone https://github.com/JAG-MEDIA-SERVICIOS-C-A/Phlexmod.git phlexmod
cd phlexmod
```

### Paso 2: Permisos de Archivos
El servidor web necesita permisos de escritura en directorios específicos para logs, uploads y caché.

```bash
# Asignar propietario al usuario web (www-data)
sudo chown -R www-data:www-data /var/www/html/phlexmod

# Directorios críticos de escritura
sudo chmod -R 775 backend/storage/logs
sudo chmod -R 775 backend/storage/uploads
sudo chmod -R 775 backend/storage/cache
```

### Paso 3: Base de Datos
Cree una base de datos vacía y un usuario dedicado en PostgreSQL.

```sql
CREATE DATABASE phlexmod;
CREATE USER phlexmod_user WITH ENCRYPTED PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON DATABASE phlexmod TO phlexmod_user;
```

### Paso 4: Configuración del Core
Copie el archivo de ejemplo y configure sus credenciales.

```bash
cp core-config.sample.php core-config.php
nano core-config.php
```

Edite las siguientes constantes:
```php
define('PHLEXMOD_DB_HOST', 'localhost');
define('PHLEXMOD_DB_DATABASE', 'phlexmod');
define('PHLEXMOD_DB_USER', 'phlexmod_user');
define('PHLEXMOD_DB_PASS', 'secure_password');
```

### Paso 5: Inicialización de BD
Ejecute el script de migración inicial para crear las tablas base.

```bash
# Desde la raíz del proyecto
php tools/console/phlexmod db:seed
```
*Si no tiene acceso a la consola, puede importar `database/schema.sql` manualmente.*

---

## 3. Configuración de Nginx

Cree un nuevo bloque de servidor en `/etc/nginx/sites-available/phlexmod`:

```nginx
server {
    listen 80;
    server_name su-dominio.com;
    root /var/www/html/phlexmod;
    index index.php;

    # Seguridad: Denegar acceso a directorios sensibles
    location ~ ^/(backend|tools|docs|installs)/ {
        deny all;
        return 403;
    }

    # Configuración principal
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    # Procesamiento PHP
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Seguridad: Cabeceras recomendadas
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";
}
```

Active el sitio y reinicie Nginx:
```bash
sudo ln -s /etc/nginx/sites-available/phlexmod /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## 4. Verificación Post-Instalación

1. Navegue a `http://su-dominio.com/frontend/login.php`.
2. Debería ver la pantalla de inicio de sesión.
3. Ingrese con las credenciales por defecto (si usó el seeder) o cree un primer usuario vía consola.

> **Nota de Seguridad:** Elimine el directorio `/installs` si existe, ya que contiene scripts de despliegue que no deben ser accesibles públicamente.
