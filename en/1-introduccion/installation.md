# Installation Guide

**Last updated:** December 2024

Follow these steps to get a PHLEXMOD instance running in your environment.

## Prerequisites

Ensure your system meets the following requirements:

- **PHP:** 8.4 or higher
- **Database:** PostgreSQL 12 or higher
- **Web Server:** Apache or Nginx
- **PHP Extensions:** `pgsql`, `pdo_pgsql`, `mbstring`, `json`, `curl`

---

## Recommended Method: Web Installer

This is the easiest and fastest way to get started.

### 1. Clone the Repository

Get the latest version of the code from GitHub.

```bash
git clone https://github.com/JAG-MEDIA-SERVICIOS-C-A/Phlexmod.git
cd Phlexmod
```

> **Note:** PHLEXMOD is **Air-Gapped Ready**. You do NOT need to run `composer install` or `npm install`. All necessary dependencies are included in the repository to ensure Technical Sovereignty.

### 2. Configure Web Server

Point your virtual server root (e.g., `DocumentRoot` in Apache) to the directory where you cloned the project.

### 3. Create the Database

Create an empty database in PostgreSQL. PHLEXMOD will handle creating the tables.

```bash
createdb -U postgres phlexmod
```

### 4. Run the Installer

Open your browser and navigate to `http://your-domain.com/installs/`

- Follow the on-screen instructions
- The installer will ask for database credentials
- It will automatically configure `core-config.php` and run DB scripts

### 5. Post-Installation Security

> ⚠️ **Important:** After the installer finishes, **delete or rename the `/installs` directory**. Leaving it accessible is a security risk.

---

## Permissions Configuration

The web server needs write permissions for the logs and uploads directories:

```bash
# Navigate to the backend directory
cd backend/

# Ensure directories exist
mkdir -p storage/logs
mkdir -p storage/uploads

# Assign permissions
sudo chown -R www-data:www-data storage/
sudo chmod -R 775 storage/
```

> **Note:** The correct path is `backend/storage/`, not in the project root.

---

## Web Server Configuration

### Apache

Configure `DocumentRoot` pointing to the project root. Ensure `mod_rewrite` is enabled.

### Nginx

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/html/phlexmod;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

---

## Troubleshooting

- **500 Error?** Check web server logs (`/var/log/apache2/error.log` or `/var/log/nginx/error.log`).
- **Database connection error?** Verify `backend/core/core-config.php` credentials manually if the installer failed.
- **Blank page?** Ensure PHP 8.4 is the active version (`php -v`) and `display_errors` is On during development.
