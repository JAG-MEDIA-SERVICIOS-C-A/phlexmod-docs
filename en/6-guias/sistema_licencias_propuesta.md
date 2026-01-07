> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Propuesta de Sistema de Gestión de Licencias para PhlexMod
**DOCUMENTO CONFIDENCIAL - NO COMPARTIR**
Fecha: 11 de julio de 2025

## Resumen Ejecutivo

Este documento detalla la propuesta para implementar un sistema de gestión de licencias seguro para PhlexMod, diseñado para prevenir la modificación no autorizada y el cracking. La solución propuesta combina verificación servidor-cliente, encriptación avanzada, y técnicas de vinculación de hardware.

## Tabla de Contenidos

1. [Arquitectura del Sistema](#1-arquitectura-del-sistema)
2. [Implementación de Seguridad](#2-implementación-de-seguridad)
3. [Integración con PhlexMod](#3-integración-con-phlexmod)
4. [Pruebas y Despliegue](#4-pruebas-y-despliegue)
5. [Especificaciones Técnicas](#5-especificaciones-técnicas)
6. [Cronograma de Implementación](#6-cronograma-de-implementación)

## 1. Arquitectura del Sistema

### 1.1 Servidor de Licencias

#### Base de Datos
```sql
CREATE TABLE licenses (
    id VARCHAR(36) PRIMARY KEY,
    license_key VARCHAR(255) NOT NULL,
    status ENUM('active', 'suspended', 'expired', 'revoked') NOT NULL DEFAULT 'active',
    expiration_date DATETIME NOT NULL,
    license_type ENUM('trial', 'standard', 'premium', 'enterprise') NOT NULL,
    max_activations INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE clients (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    company VARCHAR(255),
    contact_info TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE license_client (
    license_id VARCHAR(36) NOT NULL,
    client_id VARCHAR(36) NOT NULL,
    PRIMARY KEY (license_id, client_id),
    FOREIGN KEY (license_id) REFERENCES licenses(id),
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

CREATE TABLE activations (
    id VARCHAR(36) PRIMARY KEY,
    license_id VARCHAR(36) NOT NULL,
    hardware_id VARCHAR(255) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    user_agent TEXT NOT NULL,
    activation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_check_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'deactivated') DEFAULT 'active',
    FOREIGN KEY (license_id) REFERENCES licenses(id)
);

CREATE TABLE verification_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    license_id VARCHAR(36) NOT NULL,
    activation_id VARCHAR(36) NOT NULL,
    verification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45) NOT NULL,
    result ENUM('success', 'failed', 'warning') NOT NULL,
    details TEXT,
    FOREIGN KEY (license_id) REFERENCES licenses(id),
    FOREIGN KEY (activation_id) REFERENCES activations(id)
);
```

### 1.2 API de Licencias

#### Endpoints

| Endpoint | Método | Descripción | Parámetros | Respuesta |
|----------|--------|-------------|------------|-----------|
| `/api/license/validate` | POST | Valida una licencia | `license_key`, `hardware_id` | Estado de validez, tiempo restante |
| `/api/license/activate` | POST | Activa una licencia en una nueva instalación | `license_key`, `hardware_id`, `client_info` | Token de activación |
| `/api/license/status` | GET | Verifica el estado actual | `license_key`, `activation_token` | Estado detallado |
| `/api/license/deactivate` | POST | Desactiva en una instalación | `license_key`, `activation_token` | Confirmación |
| `/api/license/heartbeat` | POST | Actualiza estado de actividad | `license_key`, `activation_token` | Confirmación |

### 1.3 Cliente de Verificación

#### Flujo de Verificación
1. Verificación inicial durante la instalación
2. Verificación en cada inicio de sesión
3. Verificaciones periódicas en segundo plano (cada 24 horas)
4. Verificaciones adicionales en operaciones críticas

## 2. Implementación de Seguridad

### 2.1 Encriptación y Almacenamiento

#### Generación de Licencias
- Formato de licencia: `XXXX-XXXX-XXXX-XXXX-XXXX`
- Cada licencia contiene información codificada:
  - Tipo de licencia (4 bits)
  - Fecha de expiración (16 bits)
  - ID único (64 bits)
  - Checksum (16 bits)

#### Almacenamiento Local
- Datos de licencia encriptados con AES-256
- Clave de encriptación derivada de múltiples factores del hardware
- Almacenamiento en ubicaciones no estándar del sistema

### 2.2 Huella Digital del Sistema

La huella digital se generará combinando:
- MAC address de la interfaz de red principal
- ID del disco duro principal
- Nombre de host
- Características del CPU
- Configuración de BIOS (cuando sea posible)

```javascript
// Pseudocódigo para generación de huella digital
function generateHardwareId() {
    let components = [];
    
    // Obtener MAC address
    components.push(getMacAddress());
    
    // Obtener ID de disco
    components.push(getDiskId());
    
    // Obtener hostname
    components.push(getHostname());
    
    // Obtener información de CPU
    components.push(getCpuInfo());
    
    // Hash de componentes
    return sha256(components.join('|'));
}
```

### 2.3 Ofuscación y Protección

#### Código JavaScript
- Ofuscación avanzada con herramientas como JavaScript Obfuscator
- Implementación de anti-debugging
- Verificaciones de integridad del código

#### Código PHP
- Protección con ionCube o similar
- Implementación de verificaciones anti-tampering
- Separación de lógica crítica en componentes protegidos

### 2.4 Comunicaciones Seguras

- Todas las comunicaciones utilizarán HTTPS con TLS 1.3
- Implementación de Certificate Pinning
- Tokens JWT con tiempo de expiración corto (1 hora)
- Firmas HMAC para verificar integridad de mensajes

## 3. Integración con Flexmod

### 3.1 Puntos de Integración

#### Proceso de Instalación
```php
// En el proceso de instalación
function completeInstallation($config) {
    // Resto del proceso de instalación...
    
    // Activación de licencia
    $licenseKey = $config['license_key'];
    $hardwareId = generateHardwareId();
    
    $activationResult = activateLicense($licenseKey, $hardwareId);
    
    if (!$activationResult['success']) {
        throw new InstallationException('Error de activación de licencia: ' . $activationResult['message']);
    }
    
    // Almacenar token de activación de forma segura
    storeActivationToken($activationResult['activation_token']);
    
    return true;
}
```

#### Verificación en Inicio de Sesión
```php
// En el proceso de login
function authenticateUser($username, $password) {
    // Verificar licencia antes de autenticar
    $licenseStatus = checkLicenseStatus();
    
    if (!$licenseStatus['valid']) {
        logAuthFailure('License validation failed: ' . $licenseStatus['message']);
        return [
            'success' => false,
            'message' => 'Error de validación de licencia'
        ];
    }
    
    // Continuar con la autenticación normal...
}
```

#### Verificación Periódica
```javascript
// En el cliente JavaScript
function setupPeriodicCheck() {
    // Verificar cada 24 horas
    setInterval(() => {
        performLicenseCheck()
            .then(result => {
                if (!result.valid) {
                    handleInvalidLicense(result);
                }
            })
            .catch(error => {
                // Manejar errores de conexión
                logVerificationError(error);
            });
    }, 24 * 60 * 60 * 1000);
}
```

### 3.2 Mecanismos de Bloqueo Gradual

En caso de detección de licencia inválida:

1. **Primer nivel**: Mostrar advertencia y limitar algunas funciones
2. **Segundo nivel**: Limitar severamente la funcionalidad
3. **Tercer nivel**: Modo de solo lectura
4. **Cuarto nivel**: Bloqueo completo con opción de reactivación

## 4. Pruebas y Despliegue

### 4.1 Plan de Pruebas

#### Pruebas de Seguridad
- Análisis estático de código
- Pruebas de penetración
- Simulación de intentos de bypass
- Pruebas de resistencia a modificación de memoria

#### Pruebas Funcionales
- Verificación de activación/desactivación
- Pruebas de cambio de hardware
- Escenarios de expiración de licencia
- Pruebas de recuperación

### 4.2 Plan de Despliegue

1. Implementación de infraestructura de servidor
2. Desarrollo de componentes de backend
3. Desarrollo de componentes de cliente
4. Integración con Flexmod
5. Pruebas internas
6. Despliegue beta con clientes seleccionados
7. Despliegue general

## 5. Especificaciones Técnicas

### 5.1 Requisitos de Servidor

- PHP 7.4+ o PHP 8.0+
- MySQL 5.7+ o MariaDB 10.2+
- Soporte para OpenSSL
- Soporte para encriptación AES-256
- Certificado SSL válido

### 5.2 Requisitos de Cliente

- Navegadores modernos con soporte para:
  - localStorage/sessionStorage
  - WebCrypto API
  - Fetch API
- JavaScript habilitado

### 5.3 Librerías y Dependencias

#### Backend (PHP)
- Firebase JWT para tokens
- Defuse/php-encryption para encriptación
- Ramsey/uuid para generación de IDs

#### Frontend (JavaScript)
- crypto-js para operaciones criptográficas
- fingerprintjs para identificación de navegador
- axios para comunicaciones HTTP

## 6. Cronograma de Implementación

| Fase | Duración | Fechas Estimadas |
|------|----------|------------------|
| Diseño de Arquitectura | 2-3 semanas | Agosto 2025 |
| Implementación de Seguridad | 3-4 semanas | Septiembre 2025 |
| Integración con Flexmod | 2-3 semanas | Octubre 2025 |
| Pruebas y Despliegue | 2 semanas | Noviembre 2025 |
| Monitoreo y Ajustes | Continuo | Diciembre 2025+ |

## Consideraciones Adicionales

### Modo Offline
Se implementará un sistema de caché que permita la operación sin conexión durante un período limitado (configurable, por defecto 7 días).

### Actualizaciones de Seguridad
El sistema incluirá un mecanismo para actualizar remotamente los componentes de seguridad sin necesidad de actualizar toda la aplicación.

### Cumplimiento Legal
El sistema está diseñado para cumplir con regulaciones de privacidad como GDPR y CCPA, minimizando la recolección de datos personales.

---

**Nota**: Este documento es confidencial y contiene información sensible sobre la implementación de seguridad. No debe ser compartido fuera del equipo de desarrollo autorizado.

```
-- Tabla de licencias adaptada a tu estructura
CREATE TABLE "public"."setting_licenses" (
  "id" varchar(36) PRIMARY KEY,
  "license_key" varchar(255) NOT NULL,
  "status" int2 NOT NULL, -- Usar el mismo patrón de estatus que otras tablas
  "expiration_date" timestamp(6) NOT NULL,
  "license_type" int2 NOT NULL, -- Tipo de licencia
  "max_activations" int4 NOT NULL DEFAULT 1,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de activaciones adaptada
CREATE TABLE "public"."setting_license_activations" (
  "id" varchar(36) PRIMARY KEY,
  "license_id" varchar(36) NOT NULL,
  "uid" int4 NOT NULL, -- Referencia a setting_user
  "hardware_id" varchar(255) NOT NULL,
  "ip_address" varchar(45) NOT NULL,
  "user_agent" text NOT NULL,
  "activation_date" timestamp DEFAULT CURRENT_TIMESTAMP,
  "last_check_date" timestamp DEFAULT CURRENT_TIMESTAMP,
  "status" int2 DEFAULT 1, -- Usar el mismo patrón de estatus
  FOREIGN KEY ("license_id") REFERENCES "public"."setting_licenses"("id"),
  FOREIGN KEY ("uid") REFERENCES "public"."setting_user"("uid")
);

-- Tabla de tipos de licencia
CREATE TABLE "public"."setting_license_types" (
  "id" serial PRIMARY KEY,
  "type_name" varchar(60) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default"
);
```

```
-- Tabla de licencias adaptada a tu estructura
CREATE TABLE "public"."setting_licenses" (
  "id" serial PRIMARY KEY,
  "license_key" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "status" int2 NOT NULL,
  "expiration_date" timestamp(6) NOT NULL,
  "license_type" int2 NOT NULL,
  "max_activations" int4 NOT NULL DEFAULT 1,
  "created_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de tipos de licencia
CREATE TABLE "public"."setting_license_types" (
  "id" serial PRIMARY KEY,
  "type_name" varchar(60) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default"
);

-- Tabla de activaciones adaptada
CREATE TABLE "public"."setting_license_activations" (
  "id" serial PRIMARY KEY,
  "license_id" int4 NOT NULL,
  "uid" int4 NOT NULL,
  "hardware_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "ip_address" varchar(45) COLLATE "pg_catalog"."default" NOT NULL,
  "user_agent" text COLLATE "pg_catalog"."default" NOT NULL,
  "activation_date" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "last_check_date" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "status" int2 DEFAULT 1,
  FOREIGN KEY ("license_id") REFERENCES "public"."setting_licenses"("id"),
  FOREIGN KEY ("uid") REFERENCES "public"."setting_user"("uid")
);

-- Tabla de verificaciones
CREATE TABLE "public"."setting_license_verifications" (
  "id" serial PRIMARY KEY,
  "license_id" int4 NOT NULL,
  "activation_id" int4 NOT NULL,
  "verification_date" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "ip_address" varchar(45) COLLATE "pg_catalog"."default" NOT NULL,
  "result" int2 NOT NULL,
  "details" text COLLATE "pg_catalog"."default",
  FOREIGN KEY ("license_id") REFERENCES "public"."setting_licenses"("id"),
  FOREIGN KEY ("activation_id") REFERENCES "public"."setting_license_activations"("id")
);
```