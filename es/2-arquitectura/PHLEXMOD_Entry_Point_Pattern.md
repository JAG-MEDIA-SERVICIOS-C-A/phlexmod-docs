# PHLEXMOD Entry Point Pattern

**Patrón de Arquitectura Real - Basado en Código Existente**

*Versión 1.0 - Diciembre 2025*  
*Basado en análisis del código real de PHLEXMOD*

---

## 📋 Resumen Ejecutivo

**PHLEXMOD Entry Point Pattern** es un patrón de arquitectura web basado en **puntos de entrada dinámicos controlados por base de datos**. A diferencia de frameworks tradicionales con rutas hardcodeadas, PHLEXMOD utiliza una estructura de menú dinámico donde cada enlace del menú apunta a un "archivo de entrada" específico que se carga dinámicamente.

### 🎯 Características Fundamentales

- **Entry Points Dinámicos**: Archivos PHP definidos en base de datos
- **Menú Controlado por Privilegios**: Acceso basado en roles de usuario
- **Carga Modular de Recursos**: JS/CSS cargados bajo demanda
- **Enrutamiento Basado en DB**: Sin rutas estáticas, todo dinámico

---

## 🏛️ Fundamentos del Patrón

### Principios Core

#### 1. **Database-Driven Navigation**

El menú no está hardcodeado, se genera dinámicamente:

```sql
SELECT menu.enlace, menu.directorio, menu.descripcion 
FROM setting_menu sm
JOIN setting_privilege_user spu ON sm.codigo = spu.codigo
WHERE spu.uid = ? AND sm.codigo = ?
```

#### 2. **Entry Point Files**

Cada módulo tiene un archivo de entrada principal:

```
modules/profile/profile.php     ← Entry point
modules/users/users.php         ← Entry point
modules/settings/settings.php   ← Entry point
```

#### 3. **Dynamic Resource Loading**

Los recursos se cargan según el entry point activo:

```javascript
ModuleLoader.init({
    pathEncriptado: 'ruta_encriptada',
    documentphp: 'profile.php',    ← Entry point
    directorio: 'profile/',         ← Directorio
    endpoint: 'api_endpoint.php'
});
```

---

## 🏗️ Estructura del Patrón

### Flujo de Navegación

```
Usuario hace clic → Menú Dinámico → URL Encriptada → engine.php → 
Desencriptar Parámetros → Consultar DB → Cargar Entry Point → 
ModuleLoader → Cargar JS/CSS → Renderizar Página
```

### Componentes Esenciales

#### 1. **Navigation Generator (navigation-menu.php)**

- Genera menú HTML desde base de datos
- Aplica filtros por privilegios
- Crea URLs encriptadas
- Maneja estados activos

#### 2. **Entry Point Engine (engine.php)**

- Recibe parámetros encriptados
- Consulta base de datos para validar acceso
- Incluye el archivo de entrada correspondiente
- Configura rutas del módulo

#### 3. **Module Loader (module-loader.js)**

- Carga recursos JS/CSS dinámicamente
- Maneja errores de carga
- Soporta proxy para recursos
- Define variables globales del módulo

---

## 🔄 Flujo de Ejecución Detallado

### 1. **Generación del Menú**

```php
// navigation-menu.php - Líneas 215-255
$sqlModulo = "SELECT
    setting_user.uid, 
    setting_privilege_user.codigo, 
    setting_menu.descripcion, 
    setting_menu.enlace,         ← Entry point file
    setting_menu.directorio,     ← Module directory
    setting_menu.icon
FROM setting_user
LEFT JOIN setting_privilege_user ON ...
LEFT JOIN setting_menu ON ...
WHERE setting_user.uid = $1
AND setting_privilege_user.codigo > 1";
```

### 2. **Creación de Enlaces**

```php
// navigation-menu.php - Líneas 181-185
<a class="nav-link" href="index.php?modulo=<?= urlencode($idModulo); ?>&contenido=<?= urlencode($idEnlace); ?>">
    <span class="nav-link-text"><?= translate($descripcion, $translations) ?></span>
</a>
```

### 3. **Procesamiento del Engine**

```php
// engine.php - Líneas 36-59
$reqIdModulo = $desencriptar($_REQUEST["modulo"]?? null);
$reqIdEnlaces = $desencriptar($_REQUEST["contenido"]?? null);

$sqlMain = "SELECT 
    setting_privilege_user.uid,
    setting_privilege_user.codigo,
    setting_menu.enlace,        ← Entry point
    setting_menu.directorio,     ← Directory
    setting_menu.descripcion
FROM setting_privilege_user
INNER JOIN setting_menu ON ...
WHERE setting_privilege_user.uid = $1
AND setting_privilege_user.codigo = $2";
```

### 4. **Carga del Entry Point**

```php
// engine.php - Líneas 112-119
if (!defined('PHLEXMOD_ROUTE_SPECIFIES_MODULES_UI')) { 
    define('PHLEXMOD_ROUTE_SPECIFIES_MODULES_UI', PHLEXMOD_MODULES_PATH . $directorio."ui/"); 
}

$ruta_completa = $buscarDirectorio.$buscarArchivo;
if (file_exists($ruta_completa)) {
    include $ruta_completa;
}
```

---

## 🗂️ Estructura de Directorios

### Formato Estándar de Módulo

```
modules/
├── profile/                    ← Nombre del módulo
│   ├── profile.php             ← Entry point principal
│   ├── endpoints/              ← API endpoints
│   │   ├── *.api.php          ← Endpoints AJAX
│   │   ├── *.db.php           ← Acceso a datos
│   │   └── *.logic.php        ← Lógica de negocio
│   ├── ui/                     ← Componentes UI
│   │   ├── form.php           ← Formularios
│   │   ├── table.php          ← Tablas
│   │   ├── modal.php          ← Modales
│   │   └── view.php           ← Vistas
│   ├── js/                     ← Lógica JavaScript
│   │   └── profile.js         ← JS del módulo
│   └── css/                    ← Estilos
│       └── profile.css        ← CSS del módulo
└── [otros módulos...]
```

---

## 🛡️ Modelo de Seguridad

### Control de Acceso por Base de Datos

#### 1. **Validación de Privilegios**

```sql
-- Solo se muestran menús según privilegios del usuario
WHERE setting_user.uid = $1
AND setting_privilege_user.codigo > 1
AND setting_menu.codigo < 9000
```

#### 2. **Encriptación de Parámetros**

```php
// Todos los parámetros viajan encriptados
$moduloEncriptado = $encriptar($_SESSION['idLogin']);
$contenidoEncriptado = $encriptar($codigoMenu);
```

#### 3. **Validación en Engine**

```php
// engine.php valida que el usuario tenga acceso
$rsMain = pg_query_params($conexion, $sqlMain, [$reqIdModulo, $reqIdEnlaces]);
if (pg_fetch_assoc($rsMain)) {
    // Usuario tiene acceso, cargar entry point
} else {
    // Sin acceso, mostrar error
}
```

---

## 📊 Patrones de Implementación

### 1. **Entry Point Contract**

Todo entry point debe seguir este contrato:

```php
<?php
// entry-point-example.php
// 1. Validar acceso (opcional, engine ya lo hace)
// 2. Configurar variables locales
// 3. Incluir lógica del módulo
// 4. Renderizar UI

// Variables disponibles:
// window.IDENTIDAD - ID del usuario
// window.TIPOROL - Tipo de usuario
// window.PATH_ENDPOINTS - Ruta a endpoints
// window.PATH_UI - Ruta a componentes UI
// window.PATH_JS - Ruta a JavaScript
// window.PATH_CSS - Ruta a CSS
?>
```

### 2. **Module Loading Pattern**

```javascript
// module-loader.js - Patrón de carga
const ModuleLoader = {
    init: function(config) {
        this.config = config;
        this.cargarModulo();
    },
    
    cargarModulo: async function() {
        // 1. Desencriptar ruta del servidor
        // 2. Definir variables globales
        // 3. Cargar CSS (no bloqueante)
        // 4. Cargar JS (no bloqueante)
    }
};
```

---

## 🎯 Casos de Uso Ideales

### 1. **Aplicaciones Multi-rol**

- Diferentes menús por tipo de usuario
- Accesso granular por funcionalidad
- Entry points específicos por rol

### 2. **Sistemas Modulares**

- Funcionalidades independientes
- Carga bajo demanda de recursos
- Mantenimiento por módulo

### 3. **Aplicaciones Empresariales**

- Seguridad basada en base de datos
- Auditoría de accesos
- Configuración dinámica

---

## 📈 Beneficios del Patrón

### Ventajas Técnicas

| Característica | Framework Tradicional | PHLEXMOD Entry Point |
|----------------|---------------------|----------------------|
| **Flexibilidad** | Rutas estáticas | Menú dinámico |
| **Seguridad** | A nivel de código | A nivel de datos |
| **Mantenimiento** | Centralizado | Por módulo |
| **Rendimiento** | Carga completa | Carga bajo demanda |
| **Complejidad** | Alta | Media |

### Métricas de Calidad

- **Acoplamiento**: Bajo (módulos independientes)
- **Cohesión**: Alta (funcionalidad agrupada)
- **Flexibilidad**: Alta (configurable por DB)
- **Seguridad**: Alta (control por privilegios)

---

## 🔧 Implementación de Referencia

### Entry Point de Ejemplo

```php
<?php
// modules/profile/profile.php
// Entry point para módulo de perfil

// 1. Configuración local
$moduleName = 'profile';
$moduleTitle = 'Perfil de Usuario';

// 2. Lógica de negocio
require_once 'endpoints/profile.logic.php';

// 3. Renderizar UI
?>
<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <h3><?= $moduleTitle ?></h3>
            <div id="profile-content">
                <!-- Contenido dinámico -->
            </div>
        </div>
    </div>
</div>

<script>
// ModuleLoader ya configuró las variables globales
ProfileModule.init();
</script>
```

---

## 🚀 Evolución y Mejoras

### Versiones del Patrón

#### v1.0 (Actual) - Fundamentos

- ✅ Entry points dinámicos
- ✅ Menú controlado por DB
- ✅ Carga modular de recursos
- ✅ Encriptación de parámetros

#### v1.1 - Mejoras Planeadas

- 🔄 Validación mejorada de entry points
- 🔄 Caching de menús
- 🔄 Optimización de consultas DB
- 🔄 Manejo de errores mejorado

#### v1.2 - Características Avanzadas

- 📋 Entry points anidados
- 📋 Configuración por módulo
- 📋 Testing integrado
- 📋 Documentación automática

---

## 📚 Comparación con Otros Patrones

### PHLEXMOD vs MVC Tradicional

| Característica | MVC Tradicional | PHLEXMOD Entry Point |
|----------------|-----------------|----------------------|
| **Enrutamiento** | Routes.php | Base de datos |
| **Controladores** | Clases estáticas | Entry points PHP |
| **Vistas** | Templates separados | UI en módulos |
| **Flexibilidad** | Media | Alta |

### PHLEXMOD vs SPA Frameworks

| Característica | SPA Frameworks | PHLEXMOD Entry Point |
|----------------|-----------------|----------------------|
| **Rendering** | Cliente | Servidor |
| **SEO** | Requiere configuración | Nativo |
| **Complejidad** | Alta | Media |
| **Rendimiento** | Variable | Predecible |

---

## 🛠️ Herramientas y Soporte

### Herramientas Nativas

- **Navigation Generator**: Menú dinámico automático
- **Module Loader**: Carga de recursos bajo demanda
- **Encryption Helper**: Encriptación de parámetros
- **Database Schema**: Estructura optimizada

### Herramientas de Desarrollo

- **Entry Point Generator**: Crear estructura estándar
- **Menu Builder**: Constructor visual de menús
- **Privilege Manager**: Gestor de privilegios
- **Module Tester**: Testing de entry points

---

## 📄 Licencia y Uso

**PHLEXMOD Entry Point Pattern** es parte del framework PHLEXMOD bajo licencia MIT.

---

## 🎯 Conclusión

**PHLEXMOD Entry Point Pattern** es una solución pragmática para aplicaciones web que necesitan flexibilidad en la navegación y seguridad basada en roles. Su enfoque de base de datos para el control de acceso y su sistema de entry points dinámicos lo hacen ideal para aplicaciones empresariales donde los requisitos de acceso cambian frecuentemente.

El patrón demuestra que no siempre se necesitan arquitecturas complejas para resolver problemas reales. A veces, una solución simple pero bien diseñada basada en las capacidades existentes de PHP puede ser más efectiva que frameworks sobrecargados.

---

**PHLEXMOD Entry Point Pattern - Simplicidad y Flexibilidad en Armonía** 🚀
