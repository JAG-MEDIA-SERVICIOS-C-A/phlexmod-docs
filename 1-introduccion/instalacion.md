# Guía de Instalación

**Última actualización:** Diciembre 2024

Sigue estos pasos para tener una instancia de PHLEXMOD funcionando en tu entorno.

## Requisitos Previos

Asegúrate de que tu sistema cumple con los siguientes requisitos:

- **PHP:** 8.2 o superior
- **Base de datos:** PostgreSQL 12 o superior
- **Servidor web:** Apache o Nginx
- **Extensiones PHP:** `pgsql`, `pdo_pgsql`, `mbstring`, `json`, `curl`

---

## Método Recomendado: Instalador Web

Este es el método más fácil y rápido para empezar.

### 1. Clonar el Repositorio

Obtén la última versión del código desde GitHub.

```bash
git clone https://github.com/JAG-MEDIA-SERVICIOS-C-A/Phlexmod.git
cd Phlexmod
```

### 2. Configurar el Servidor Web

Apunta la raíz de tu servidor virtual (ej. `DocumentRoot` en Apache) al directorio donde clonaste el proyecto.

### 3. Crear la Base de Datos

Crea una base de datos vacía en PostgreSQL. PHLEXMOD se encargará de crear las tablas.

```bash
createdb -U postgres phlexmod
```

### 4. Ejecutar el Instalador

Abre tu navegador y navega a `http://tu-dominio.com/installs/`

- Sigue las instrucciones en pantalla
- El instalador te pedirá las credenciales de la base de datos
- Se encargará de configurar `core-config.php` y ejecutar los scripts de BD automáticamente

### 5. Seguridad Post-Instalación

> ⚠️ **Importante:** Después de que el instalador finalice, **elimina o renombra el directorio `/installs`**. Dejarlo accesible es un riesgo de seguridad.

---

## Configuración de Permisos

El servidor web necesita permisos para escribir en los directorios de logs y subidas:

```bash
# Navega al directorio del backend
cd backend/

# Asegúrate de que los directorios existen
mkdir -p storage/logs
mkdir -p storage/uploads

# Asigna los permisos
sudo chown -R www-data:www-data storage/
sudo chmod -R 775 storage/
```

> **Nota:** La ruta correcta es `backend/storage/`, no en la raíz del proyecto.

---

## Configuración del Servidor Web

### Apache

Configura el `DocumentRoot` apuntando a la raíz del proyecto. Asegúrate de tener `mod_rewrite` habilitado.

### Nginx

```nginx
server {
    listen 80;
    server_name tu-dominio.com;
    root /var/www/html/phlexmod;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    }
}
```

---

## Verificación

Una vez completados los pasos, navega a la raíz de tu proyecto. Deberías ver la pantalla de inicio de sesión de PHLEXMOD.

Si encuentras errores, revisa el archivo `backend/storage/logs/phlexmod.log` para obtener más detalles.

---
