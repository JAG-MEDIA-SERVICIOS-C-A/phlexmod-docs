# 🚀 Curso de DevOps - Guía Práctica para PHLEXMOD

## 📋 Módulo 1: Fundamentos de DevOps

### 1.1 ¿Qué es DevOps?

**DevOps** es una metodología que combina desarrollo (Dev) y operaciones (Ops) para:

- Acelerar el ciclo de vida de desarrollo
- Mejorar la calidad del software
- Automatizar procesos de despliegue
- Fomentar la colaboración entre equipos

### 1.2 Principios Clave

- **CI/CD**: Integración Continua / Despliegue Continuo
- **IaC**: Infraestructura como Código
- **Monitorización**: Observabilidad del sistema
- **Seguridad**: DevSecOps integrado

---

## 🛠️ Módulo 2: Herramientas Esenciales

### 2.1 Control de Versiones (Git)

```bash
# Flujo básico de trabajo
git clone <repositorio>
git branch feature/nueva-funcionalidad
git add .
git commit -m "Descripción clara"
git push origin feature/nueva-funcionalidad
```

### 2.2 Automatización con Scripts

**Bash scripting para despliegue:**

```bash
#!/bin/bash
# deploy.sh
echo "🚀 Iniciando despliegue..."
git pull origin main
composer install --no-dev
php artisan migrate
systemctl restart apache2
echo "✅ Despliegue completado"
```

---

## 🐳 Módulo 3: Docker y Contenedores

### 3.1 Conceptos Básicos

- **Contenedor**: Entorno aislado para ejecutar aplicaciones
- **Imagen**: Plantilla para crear contenedores
- **Dockerfile**: Receta para construir imágenes

### 3.2 Dockerfile para PHLEXMOD

```dockerfile
FROM php:8.4-apache
# Instalar dependencias
RUN apt-get update && apt-get install -y \
    postgresql-client \
    unzip \
    libzip-dev \
    && docker-php-ext-install pdo_pgsql zip

# Copiar aplicación
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
```

### 3.3 docker-compose.yml

```yaml
version: '3.8'
services:
  phlexmod:
    build: .
    ports:
      - "8080:80"
    depends_on:
      - db
    environment:
      - PHLEXMOD_DB_HOST=db
      - PHLEXMOD_DB_DATABASE=phlexmod
  
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: phlexmod
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

---

## 🔄 Módulo 4: CI/CD con GitHub Actions

### 4.1 Workflow Básico

```yaml
# .github/workflows/deploy.yml
name: Deploy PHLEXMOD
on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'
      
      - name: Install dependencies
        run: composer install --prefer-dist --no-progress
      
      - name: Run tests
        run: vendor/bin/phpunit

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to server
        uses: appleboy/ssh-action@v0.1.5
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USERNAME }}
          key: ${{ secrets.SSH_KEY }}
          script: |
            cd /var/www/phlexmod
            git pull origin main
            composer install --no-dev
            systemctl restart apache2
```

---

## 🌐 Módulo 5: Gestión de Servidores

### 5.1 Configuración de Apache/Nginx

**Apache VirtualHost:**

```apache
<VirtualHost *:80>
    ServerName phlexmod.mia-architecture.com
    DocumentRoot /var/www/phlexmod/frontend
    
    <Directory /var/www/phlexmod/frontend>
        AllowOverride All
        Require all granted
    </Directory>
    
    # Proxy para API
    ProxyPass /api/ http://localhost:8080/
    ProxyPassReverse /api/ http://localhost:8080/
</VirtualHost>
```

### 5.2 SSL con Let's Encrypt

```bash
# Instalar certbot
sudo apt install certbot python3-certbot-apache

# Obtener certificado
sudo certbot --apache -d phlexmod.mia-architecture.com

# Renovación automática
sudo crontab -e
# Agregar: 0 12 * * * /usr/bin/certbot renew --quiet
```

---

## 📊 Módulo 6: Monitorización y Logging

### 6.1 Monitorización Básica

```bash
# Script de monitoreo
#!/bin/bash
# monitor.sh
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')
MEM_USAGE=$(free | grep Mem | awk '{printf("%.1f"), $3/$2 * 100.0}')
DISK_USAGE=$(df -h / | awk 'NR==2{print $5}')

echo "CPU: ${CPU_USAGE}% | RAM: ${MEM_USAGE}% | Disco: ${DISK_USAGE}"

# Alerta si supera umbrales
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo "⚠️ Alerta: CPU alta (${CPU_USAGE}%)"
fi
```

### 6.2 Logs Centralizados

```php
// Logger personalizado para PHLEXMOD
class PHLEXMODLogger {
    private static $logFile = '/var/log/phlexmod/app.log';
    
    public static function log($level, $message) {
        $timestamp = date('Y-m-d H:i:s');
        $logEntry = "[$timestamp] [$level] $message" . PHP_EOL;
        file_put_contents(self::$logFile, $logEntry, FILE_APPEND);
    }
    
    public static function error($message) {
        self::log('ERROR', $message);
    }
    
    public static function info($message) {
        self::log('INFO', $message);
    }
}
```

---

## 🔒 Módulo 7: Seguridad DevOps

### 7.1 Buenas Prácticas de Seguridad

- **Variables de entorno**: No exponer credenciales
- **Firewall**: Configurar reglas restrictivas
- **Actualizaciones**: Mantener sistema actualizado
- **Backups**: Automatizar respaldos

### 7.2 Script de Backup

```bash
#!/bin/bash
# backup.sh
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/phlexmod"

# Backup base de datos
pg_dump -h localhost -U postgres phlexmod > $BACKUP_DIR/db_$DATE.sql

# Backup archivos
tar -czf $BACKUP_DIR/files_$DATE.tar.gz /var/www/phlexmod

# Limpiar backups antiguos (mantener 7 días)
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "✅ Backup completado: $DATE"
```

---

## 🚀 Módulo 8: Práctica con PHLEXMOD

### 8.1 Ejercicio 1: Dockerizar PHLEXMOD

1. Crear Dockerfile para la aplicación
2. Configurar docker-compose.yml con base de datos
3. Probar localmente con `docker-compose up`

### 8.2 Ejercicio 2: CI/CD para PHLEXMOD

1. Configurar GitHub Actions
2. Automatizar pruebas al hacer push
3. Desplegar automáticamente en staging

### 8.3 Ejercicio 3: Monitorización

1. Implementar sistema de logging
2. Crear dashboard de monitorización
3. Configurar alertas automáticas

---

## 📚 Recursos Adicionales

### Documentación Oficial

- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Apache Configuration](https://httpd.apache.org/docs/)

### Cursos Online

- [Docker Mastery](https://www.udemy.com/course/docker-mastery/)
- [DevOps Bootcamp](https://www.udemy.com/course/devops-bootcamp/)
- [Kubernetes](https://www.udemy.com/course/kubernetes-the-complete-guide/)

### Herramientas Útiles

- **VS Code**: Editor con extensiones DevOps
- **Postman**: Para probar APIs
- **Docker Desktop**: Gestión de contenedores
- **GitKraken**: Interfaz gráfica para Git

---

## 🎯 Proyecto Final: Pipeline Completo

Crear un pipeline completo para PHLEXMOD que incluya:

1. ✅ Tests automáticos
2. ✅ Build de Docker image
3. ✅ Despliegue en staging
4. ✅ Pruebas de integración
5. ✅ Despliegue en producción
6. ✅ Monitorización post-despliegue

---

## 📈 Ruta de Aprendizaje Sugerida

1. **Semana 1-2**: Fundamentos y Git
2. **Semana 3-4**: Docker y contenedores
3. **Semana 5-6**: CI/CD básico
4. **Semana 7-8**: Monitorización y logging
5. **Semana 9-10**: Seguridad y buenas prácticas
6. **Semana 11-12**: Proyecto final

---

 *Última actualización: Diciembre 2025*
