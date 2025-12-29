# MIA Architecture - Modular Isolation Architecture

*Versión 1.2 - Diciembre 2025*  
*Creado por JAG-Media Servicios, C.A.*  
*Implementación de Referencia: PHLEXMOD Framework v2.0.1*

---

## 📋 Resumen Ejecutivo

**MIA (Modular Isolation Architecture)** es un patrón de arquitectura de software diseñado para aplicaciones empresariales que prioriza el aislamiento modular, la seguridad por diseño y la mantenibilidad a largo plazo. A diferencia de otros patrones, MIA implementa un aislamiento estricto entre módulos mientras mantiene una integración cohesiva mediante "Contratos de Interfaz" bien definidos.

MIA nace como una solución intermedia entre la rigidez de los frameworks monolíticos tradicionales y la complejidad operativa de una arquitectura de microservicios, ofreciendo un balance pragmático para el desarrollo de aplicaciones departamentales y sistemas de gestión interna.

### 🎯 Objetivos Principales

- **Aislamiento Modular**: Cada módulo funciona como una unidad completamente independiente (una "caja negra").
- **Seguridad por Diseño**: La seguridad no es una capa adicional, sino un pilar fundamental en cada componente.
- **Evolución Adaptable**: El sistema puede crecer y modificarse sin dependencias frágiles o riesgo de regresiones en cascada.
- **Claridad para el Desarrollador**: Ofrecer reglas claras que reduzcan la carga cognitiva y prevengan malas prácticas.

---

## 🏛️ 1. Fundamentos del Patrón (Las Leyes)

MIA se sustenta en tres principios inquebrantables. Todo el código dentro del framework debe adherirse a estas leyes.

### 1.1. Principio de Aislamiento Estricto

Cada módulo es una unidad soberana. Debe poder funcionar y ser probado de forma independiente. Su conocimiento del resto del sistema es, por diseño, nulo.

### 1.2. Principio de Contratos de Interfaz

La comunicación entre el núcleo del sistema y los módulos, o entre módulos, nunca es directa. Siempre se realiza a través de "contratos" bien definidos: APIs, eventos o estructuras de datos validadas.

### 1.3. Principio de Seguridad Intrínseca

La seguridad es obligatoria y se aplica en el punto de entrada de cada componente. Ninguna parte del sistema confía ciegamente en otra.

---

## 🔧 2. Patrones de Implementación (Las Recetas del Código)

Estos son los patrones de diseño específicos que implementan los principios de MIA. Sirven como la "guía de estilo" para escribir código PHLEXMOD.

### 2.1. Patrón: `Módulo Soberano`

*Implementa: `Aislamiento Estricto`*

Este patrón dicta la estructura interna de cada módulo, garantizando que sea una "caja negra" autocontenida.

- **Estructura de Directorios Obligatoria:**

  ```text
  nombre-del-modulo/
  ├── js/               # Lógica de frontend (JavaScript)
  ├── endpoints/        # APIs internas del módulo (peticiones AJAX)
  ├── ui/               # Fragmentos de la interfaz de usuario (HTML/PHP)
  └── entry-point.php   # El único archivo que el motor puede incluir
  ```

- **Regla de Oro:** Un módulo **NUNCA** debe hacer `include`, `require` o cualquier tipo de acceso a archivos dentro de la carpeta de otro módulo.

### 2.2. Patrón: `Contrato de Inicialización Engine-Loader`

*Implementa: `Contratos de Interfaz`*

Este patrón define cómo el backend (motor) le pasa el control al frontend (cargador de módulos) de una manera controlada y segura.

- **Definición:** El `engine.php` (backend) y el `ModuleLoader.js` (frontend) actúan como una unidad cohesiva llamada "Capa de Contratos". No están completamente desacoplados, sino que operan bajo un acuerdo estricto.
- **El Contrato:** El `engine.php` renderiza un bloque de script que invoca a `ModuleLoader.init({...})`. El objeto pasado en esta función es el **contrato formal**.
- **Ejemplo del Contrato:**

  ```javascript
  ModuleLoader.init({
      pathEncriptado: "...", // Ruta encriptada al directorio /js del módulo
      documentphp: "...",    // Nombre del archivo entry-point a cargar
      identidad: "...",      // UID del usuario validado
      // etc.
  });
  ```

- **Regla de Oro:** Cualquier dato necesario para la inicialización de un módulo en el frontend DEBE ser parte de este contrato.

### 2.3. Patrón: `Zona de Sanitización`

*Implementa: `Seguridad Intrínseca`*

Este patrón asegura que ningún dato externo no validado pueda penetrar en la lógica de negocio del sistema.

- **Definición:** Cada archivo que actúa como punto de entrada de datos externos (principalmente `engine.php` y los archivos en `/endpoints`) **DEBE** comenzar con un bloque de código denominado "Zona de Sanitización".
- **La Regla:** Dentro de esta zona, toda variable superglobal (`$_GET`, `$_POST`, `$_REQUEST`, `$_SESSION`) debe ser leída, validada y sanitizada usando `filter_var()`, y asignada a una variable local.
- **Ejemplo de Zona de Sanitización:**

  ```php
  // ========================================
  // Variables de Entrada (Sanitizadas)
  // ========================================
  $modulo_id = filter_var($desencriptar($_REQUEST["modulo"] ?? null), FILTER_VALIDATE_INT);
  $user_role = filter_var($_SESSION['tipou'], FILTER_SANITIZE_STRING);
  ```

- **Regla de Oro:** Después de este bloque, el uso de variables superglobales está prohibido. Solo se deben usar las variables locales ya sanitizadas.

---

## 🚫 3. Anti-Patrones (Prácticas Prohibidas)

Tan importante como saber qué hacer es saber qué NO hacer. Violar estas reglas rompe la arquitectura MIA y se considera un bug.

### 3.1. Anti-Patrón: `Acoplamiento Cruzado de Módulos`

- **Descripción:** Un módulo (ej. `profile/`) intenta incluir o acceder a un archivo de otro módulo (ej. `reports/`) usando rutas relativas como `include('../reports/some-file.php')`.
- **Por qué está mal:** Rompe el Principio de Aislamiento Estricto. Los módulos dejan de ser soberanos y se crea una dependencia frágil.

### 3.2. Anti-Patrón: `Entrada Cruda`

- **Descripción:** Usar `$_GET['id']` o `$_POST['email']` directamente en una consulta a la base de datos, en una lógica de negocio o al imprimir en HTML.
- **Por qué está mal:** Rompe el Principio de Seguridad Intrínseca y es la causa principal de vulnerabilidades de Inyección SQL y XSS. Es una violación directa del Patrón `Zona de Sanitización`.

### 3.3. Anti-Patrón: `Contaminación del Motor`

- **Descripción:** Añadir al `engine.php` lógica de presentación compleja (formularios, tablas, modales) que es específica de un solo módulo.
- **Por qué está mal:** Viola la responsabilidad del motor como orquestador. El `engine.php` puede renderizar el "esqueleto" común (como la cabecera), pero la "carne" (el contenido específico) pertenece a los archivos `ui/` del módulo.

---

## 🏗️ 4. Implementación de Referencia: PHLEXMOD v2.0.1

Las secciones a continuación demuestran cómo los principios y patrones de MIA se aplican en el código real del framework.

### 4.1. El Motor (`engine.php`) como Orquestador

El motor implementa el Patrón `Zona de Sanitización` al principio, define el estado, y luego actúa como orquestador central, cumpliendo su rol en el `Contrato Engine-Loader`.

### 4.2. Modelo de Seguridad en Capas

La seguridad en PHLEXMOD es un ejemplo directo del Principio de `Seguridad Intrínseca`:

- **Nivel 1: Sanitización:** Patrón `Zona de Sanitización`.
- **Nivel 2: Encriptación:** Los parámetros sensibles en la URL y en los contratos JS están encriptados.
- **Nivel 3: Validación de Privilegios:** Se verifica en la base de datos que el usuario tiene permiso explícito para acceder al módulo.
- **Nivel 4: Aislamiento de Sesión:** Los datos de sesión también se sanitizan en la `Zona de Sanitización`.

### 4.3. Flujos de Comunicación

Los diagramas de flujo muestran visualmente los `Contratos de Interfaz` en acción.

#### Flujo 1: Carga de Módulo

```text
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Cliente   │───▶│   Engine    │───▶│  Validación │
│  (Browser)  │    │  (Router)   │    │ (Privilegios)│
└─────────────┘    └─────────────┘    └─────────────┘
                          │                   │
                          ▼                   ▼
                   ┌─────────────┐    ┌─────────────┐
                   │ ModuleLoader│◀───│   Database  │
                   │  (Contrato) │    │  (setting_*)│
                   └─────────────┘    └─────────────┘
                          │
                          ▼
                   ┌─────────────┐
                   │ Entry Point │
                   │  (módulo)   │
                   └─────────────┘
```

#### Flujo 2: Petición AJAX a Endpoint

```text
Cliente → api-endpoint.php → Zona Sanitización → Lógica → Respuesta JSON
```

#### Flujo 3: Carga Dinámica de Recursos

```text
ModuleLoader.init() → Desencriptar ruta → Cargar CSS → Cargar JS → Inicializar
```

---

## 📊 5. Tablas Críticas del Sistema

### 5.1. setting_menu

Define los entry points disponibles en el sistema:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| codigo | INT | ID único del entry point |
| enlace | VARCHAR | Archivo PHP del módulo |
| descripcion | VARCHAR | Nombre traducible |
| icon | VARCHAR | Clase de icono |
| directorio | VARCHAR | Carpeta del módulo |
| info | VARCHAR | Descripción del módulo |

### 5.2. setting_privilege_user

Define los privilegios de acceso por usuario:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| uid | INT | ID del usuario |
| codigo | INT | ID del entry point permitido |

### 5.3. setting_user

Define los usuarios del sistema:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | INT | ID único |
| tipou | VARCHAR | Tipo/rol del usuario |
| iddep | INT | ID de departamento |

---

## 🎯 6. Variables del Contrato Engine-Loader

### Backend (PHP) → Define

```php
PHLEXMOD_MODULES_PATH              // Ruta a módulos estándar
PHLEXMOD_MODULES_ADMIN_PATH        // Ruta a módulos admin
PHLEXMOD_ROUTE_SPECIFIES_MODULES_UI // Ruta UI del módulo actual
PHLEXMOD_ROUTE_SPECIFIES_MODULES_JS // Ruta JS del módulo actual
```

### Frontend (JavaScript) → Recibe

```javascript
window.IDENTIDAD      // ID del usuario (del contrato)
window.TIPOROL        // Tipo de usuario (del contrato)
window.PATH_ENDPOINTS // Ruta a endpoints del módulo
window.PATH_UI        // Ruta a vistas del módulo
window.PATH_JS        // Ruta a JS del módulo
window.MODULE_NAME    // Nombre del módulo actual
```

---

## 🚀 7. Evolución y Roadmap

| Versión | Estado | Descripción |
|---------|--------|-------------|
| **v1.0** | ✅ Completado | Fundamentos: Aislamiento, Contratos, Seguridad |
| **v1.1** | ✅ Completado | Mejoras: Switch case, filter_var(), código documentado |
| **v1.2** | ✅ Actual | Documentación: Patrones formalizados, Anti-patrones |
| **v2.0** | 🔄 Futuro | Rendimiento: Lazy loading, cache inteligente |

---

## 📄 8. Licencia y Contacto

**MIA Architecture** se publica bajo licencia **Creative Commons Attribution 4.0 International (CC BY 4.0)**.

- **Repositorio**: <https://github.com/JAG-MEDIA-SERVICIOS-C-A/Phlexmod>
- **Documentación**: <https://phlexmod.jagmedia.com.ve/docs>
- **Soporte**: <soporte@jag-media.com.ve>

---

## 🎯 Conclusión

**MIA Architecture** implementada en **PHLEXMOD Framework v2.0.1** demuestra que es posible lograr un balance entre aislamiento modular y cohesión funcional. El patrón `Contrato Engine-Loader` es la pieza clave que permite esta integración sin sacrificar la seguridad ni la mantenibilidad.

Las "Leyes" (principios), las "Recetas" (patrones) y los "Anti-Patrones" (prohibiciones) forman un marco completo para el desarrollo consistente y seguro.

---

**MIA Architecture + PHLEXMOD Framework** 🚀
