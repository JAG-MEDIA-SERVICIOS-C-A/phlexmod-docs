> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Teatro Ribas - Documentación de Refactorización MIA

## Índice

1. [Introducción](#introducción)
2. [Arquitectura MIA](#arquitectura-mia)
3. [Estructura de Directorios](#estructura-de-directorios)
4. [Sistema de Contra-Extensiones](#sistema-de-contra-extensiones)
5. [Convenciones de Nomenclatura](#convenciones-de-nomenclatura)
6. [Integración con el Sistema Existente](#integración-con-el-sistema-existente)
7. [Proceso de Refactorización](#proceso-de-refactorización)
8. [Ejemplos Prácticos](#ejemplos-prácticos)
9. [Buenas Prácticas](#buenas-prácticas)
10. [Resolución de Problemas Comunes](#resolución-de-problemas-comunes)

## Introducción

Este documento establece las convenciones y guías para la refactorización del sistema Teatro Ribas siguiendo la arquitectura MIA (Modular Isolation Architecture). El objetivo es mantener la estructura de directorios existente mientras se mejora la organización y mantenibilidad del código mediante un sistema de contra-extensiones.

## Arquitectura MIA

La arquitectura MIA se basa en los siguientes principios:

- **Aislamiento Modular**: Cada módulo funciona independientemente
- **Estructura por Capas**: Separación clara de responsabilidades
- **Adaptabilidad**: Diseñado para adaptarse a cualquier tipo de proyecto
- **Reusabilidad**: Componentes reutilizables entre módulos

### Ventajas de MIA sobre MVC

1. **Aislamiento Modular Superior**: Cada módulo en MIA está completamente aislado con sus propias capas, mientras que en MVC los componentes suelen compartir recursos.
2. **Escalabilidad por Módulos**: MIA permite escalar horizontalmente sin afectar módulos existentes.
3. **Adaptabilidad a Proyectos Específicos**: MIA se adapta mejor a proyectos específicos manteniendo la estructura arquitectónica.
4. **Reducción de Conflictos**: MIA evita que los cambios en un módulo afecten a otros, ideal para sistemas multi-módulo.
5. **Estructura de Capas más Definida**: MIA define claramente cuatro capas con responsabilidades específicas.

## Estructura de Directorios

La nueva estructura de directorios será:

```
/backend/modulos/[módulo]/
├── js/            # JavaScript específico del módulo (un archivo por entrada)
├── endpoints/     # Endpoints PHP con consultas a tablas y lógica de negocio
├── ui/            # Interfaces de usuario HTML con poco PHP
└── css/           # Estilos específicos (opcional)
```

## Sistema de Contra-Extensiones

### Endpoints (`/endpoints/`)

#### Opción 1: Contra-Extensiones

| Contra-Extensión | Propósito | Ejemplo |
|------------------|-----------|---------|
| `.api.php` | Endpoints para comunicación AJAX | `eventos.api.php` |
| `.db.php` | Operaciones directas con la base de datos | `eventos.db.php` |
| `.logic.php` | Lógica de negocio y procesamiento | `eventos.logic.php` |

#### Opción 2: Prefijos

Como alternativa o complemento a las contra-extensiones, se pueden utilizar prefijos descriptivos que indiquen la acción que realiza el archivo:

| Prefijo | Propósito | Ejemplo |
|---------|-----------|---------|
| `get_` | Obtener datos simples (para selectores o campos individuales) | `get_evento.php` |
| `table_` | Obtener datos tabulares o listados completos | `table_eventos.php` |
| `save_` | Guardar datos nuevos o actualizados | `save_evento.php` |
| `delete_` | Eliminar datos | `delete_evento.php` |
| `select_` | Consultas específicas para selectores o dropdowns | `select_tipo_evento.php` |
| `consulta_` | Consultas generales o complejas | `consulta_evento.php` |

La elección entre contra-extensiones y prefijos dependerá del contexto específico del módulo y la preferencia del equipo de desarrollo. Lo importante es mantener la consistencia dentro de cada módulo.

### Interfaces de Usuario (`/ui/`)

| Contra-Extensión | Propósito | Ejemplo |
|------------------|-----------|---------|
| `.view.php` | Vistas generales | `evento.view.php` |
| `.form.php` | Formularios específicos | `evento.form.php` |
| `.list.php` | Listados y tablas | `eventos.list.php` |
| `.comp.php` | Componentes reutilizables | `calendario.comp.php` |

### JavaScript (`/js/`)

- **Importante**: Un solo archivo JS por entrada, con el mismo nombre que el archivo de entrada definido en el menú
- Ejemplo: Si el enlace en setting_menu es "registro.php", el JS será "registro.js"
- Este archivo se carga dinámicamente por main.php

#### Estructura Recomendada para Archivos JS

```javascript
// Namespace para el módulo
const ModuloNombre = {
    // Configuración inicial
    config: {
        // Configuraciones generales
        endpoints: {
            // Referencias a los endpoints con contra-extensiones
            consulta: `${PATH_ENDPOINTS}nombre.api.php`, // Actualizado de PATH_ENDPOINTS a PATH_ENDPOINTS
            datos: `${PATH_ENDPOINTS}datos.db.php`,
            // ...
        }
    },

    // Inicialización del módulo
    init: function() {
        // Código de inicialización
        // Ejemplo de carga de una vista usando PATH_UI
        $('#contenedor').load(`${PATH_UI}componente.view.php`);
    },

    // Métodos del módulo organizados por funcionalidad
    metodo1: function() {
        // Implementación
    },

    metodo2: function() {
        // Implementación
    }
};

// Inicialización automática cuando el documento está listo
$(document).ready(function() {
    ModuloNombre.init();
});
```

#### Refactorización de Referencias a Endpoints

Durante la refactorización, es necesario actualizar las referencias a los endpoints en los archivos JS:

**Antes de la Refactorización:**
```javascript
endpoints: {
    consultaRep: `${PATH_ENDPOINTS}consultarRepNacional.php`,
    bancos: `${PATH_ENDPOINTS}selectBancos.php`,
    save: `${PATH_ENDPOINTS}saveVenta.php`,
    // ...
}
```

**Después de la Refactorización:**
```javascript
endpoints: {
    consultaRep: `${PATH_ENDPOINTS}repNacional.api.php`, // Actualizado de PATH_ENDPOINTS a PATH_ENDPOINTS
    bancos: `${PATH_ENDPOINTS}bancos.api.php`,
    save: `${PATH_ENDPOINTS}ventas.api.php`,
    // ...
}
```

#### Tabla de Conversión de Nombres de Archivos

| Nombre Original | Nombre con Contra-Extensión | Tipo |
|-----------------|----------------------------|------|
| consultarRepNacional.php | repNacional.api.php | API Endpoint |
| selectBancos.php | bancos.api.php | API Endpoint |
| selectMetodoPago.php | metodoPago.api.php | API Endpoint |
| selectEvento.php | eventos.api.php | API Endpoint |
| selectLugar.php | lugares.api.php | API Endpoint |
| selectFilaAforo.php | filaAforo.api.php | API Endpoint |
| selectAsiento.php | asientos.api.php | API Endpoint |
| saveVenta.php | ventas.api.php | API Endpoint |
| getTicketPrice.php | ticketPrecio.api.php | API Endpoint |
| checkAsientoDisponible.php | asientoDisponible.api.php | API Endpoint |
| validarAsientos.php | asientosValidar.api.php | API Endpoint |

## Convenciones de Nomenclatura

### Nombres de Archivos

- Usar minúsculas para todos los nombres de archivos
- Usar singular para entidades individuales (ej: `evento.form.php`)
- Usar plural para colecciones (ej: `eventos.list.php`)
- Nombres descriptivos que indiquen claramente su propósito

### Nombres de Funciones y Variables

- Funciones: camelCase (ej: `obtenerEventos()`)
- Variables: camelCase (ej: `$listaEventos`)
- Constantes: UPPER_SNAKE_CASE (ej: `MAX_EVENTOS`)
- Clases: PascalCase (ej: `EventoHandler`)

## Integración con el Sistema Existente

### Carga de Módulos

El sistema actual carga los módulos basándose en la tabla `setting_menu` y los parámetros encriptados. Durante la refactorización, será necesario actualizar las rutas en `main.php`:

```php
// En main.php (versión actualizada)
$directorio = $rwMain['directorio'];
$enlace = $rwMain['enlace'];
// ...
$ruta_completa = "$buscarDirectorio$buscarArchivo";
if (file_exists($ruta_completa)) {
    include FLEXMOD_MODULOS_PATH . $directorio . $enlace;
} else {
    include FLEXMOD_FRONTE_PATH . 'notfount.php';
}
```

### Carga de JavaScript

El sistema actual carga dinámicamente el archivo JS correspondiente usando `endPoint.php` para desencriptar rutas. Durante la refactorización, será necesario actualizar las referencias de `endpoints` a `endpoints` y de `view` a `ui`:

```javascript
// En main.php (versión actualizada)
async function cargarModulo() {
    const pathEncriptado = $('#path_function').val();
    const documentphp = $('#file_funcion').val();
    let filename = documentphp.split(".");
    let documentjs = filename[0] + '.js';
    try {
        const pathDesencriptado = await desencriptarEnServidor(pathEncriptado);
        let rutaOriginal = pathDesencriptado;
        window.PATH_ENDPOINTS = rutaOriginal.replace('js/', 'endpoints/'); // Actualizado de PATH_ENDPOINTS a PATH_ENDPOINTS
        window.PATH_UI = rutaOriginal.replace('js/', 'ui/'); // Actualizado de PATH_UI a PATH_UI
        const script = document.createElement('script');
        script.src = pathDesencriptado + documentjs;
        document.head.appendChild(script);
    } catch (error) {
        console.error('Error al cargar el módulo:', error);
    }
}
```

### Desencriptación de Rutas

El sistema utiliza `endPoint.php` para desencriptar rutas y mantener la seguridad. Este mecanismo se mantiene sin cambios.

## Proceso de Refactorización

### Fase 1: Preparación

1. Crear una rama de desarrollo para la refactorización
2. Documentar la estructura actual de cada módulo
3. Identificar archivos que necesitan ser renombrados
4. **Actualizar `main.php` para reflejar la nueva estructura de directorios**

### Fase 2: Implementación por Módulo

Para cada módulo:

1. **Renombrar el directorio `endpoints` a `endpoints`**
2. **Renombrar el directorio `view` a `ui`**
3. Renombrar archivos de endpoints con las nuevas contra-extensiones
4. Renombrar archivos de ui con las nuevas contra-extensiones
5. Actualizar referencias internas si es necesario
6. Probar el módulo para asegurar que funciona correctamente

### Fase 3: Validación

1. Realizar pruebas completas del sistema
2. Verificar que todos los módulos funcionen correctamente
3. Documentar cualquier problema encontrado y su solución

### Proceso de Refactorización de JS y Endpoints

1. **Identificar todos los endpoints utilizados**:
   - Revisar la sección `config.endpoints` en cada archivo JS
   - Listar todos los archivos PHP referenciados

2. **Renombrar los archivos PHP**:
   - Seguir la convención de contra-extensiones (`.api.php`, `.db.php`, `.logic.php`)
   - Usar nombres descriptivos y concisos

3. **Actualizar las referencias en el JS**:
   - Modificar todas las rutas en `config.endpoints` para que apunten a los nuevos nombres de archivo
   - **Asegurarse de que las rutas apunten al nuevo directorio `endpoints` en lugar de `endpoints`**
   - Mantener la misma estructura de objeto para evitar cambios en el resto del código

4. **Probar cada endpoint**:
   - Verificar que cada llamada AJAX funcione correctamente después de la refactorización
   - Comprobar que los datos se envíen y reciban correctamente

5. **Documentar los cambios**:
   - Mantener un registro de los archivos renombrados
   - Actualizar cualquier documentación existente

## Ejemplos Prácticos

### Módulo de Eventos (Antes)

```
/backend/modulos/eventos/
├── js/
│   └── registro.js
├── endpoints/
│   ├── eventos_endpoints.php
│   └── eventos_db.php
└── view/
    ├── form_evento.php
    └── lista_eventos.php
```

### Módulo de Eventos (Después)

```
/backend/modulos/eventos/
├── js/
│   └── registro.js         # Se mantiene igual (nombre igual al archivo de entrada)
├── endpoints/              # Antes endpoints/
│   ├── eventos.api.php     # Antes eventos_endpoints.php
│   └── eventos.db.php      # Antes eventos_db.php
└── ui/                     # Antes view/
    ├── evento.form.php     # Antes form_evento.php
    └── eventos.list.php    # Antes lista_eventos.php
```

## Buenas Prácticas

### Organización del Código

- Cada archivo debe tener una única responsabilidad
- Documentar el propósito de cada archivo en un comentario al inicio
- Agrupar funciones relacionadas en el mismo archivo

### Documentación

- Documentar todas las funciones con comentarios descriptivos
- Incluir información sobre parámetros y valores de retorno
- Explicar lógica compleja o no obvia

### Seguridad

- Mantener el sistema de encriptación/desencriptación actual
- Validar todas las entradas de usuario
- Escapar adecuadamente las salidas para prevenir XSS
- Usar consultas preparadas para prevenir SQL injection

## Resolución de Problemas Comunes

### Referencias Rotas

Si después de renombrar un archivo o directorio hay referencias rotas:

1. Buscar en todo el proyecto referencias al nombre de archivo o directorio antiguo
2. Actualizar todas las referencias al nuevo nombre
3. Verificar que las inclusiones (`include`, `require`) usen la ruta correcta
4. **Verificar que las variables globales `PATH_ENDPOINTS` y `PATH_UI` estén correctamente actualizadas** (anteriormente PATH_ENDPOINTS y PATH_UI)

### Conflictos de JavaScript

Si hay problemas con la carga de JavaScript:

1. Verificar que el nombre del archivo JS coincida exactamente con el nombre base del archivo de entrada
2. Comprobar que el archivo JS esté en el directorio correcto
3. Revisar la consola del navegador para errores específicos
4. Verificar que `endPoint.php` esté desencriptando correctamente las rutas
5. **Comprobar que las rutas a los endpoints estén actualizadas para reflejar el nuevo directorio `endpoints` y que se esté usando la variable `PATH_ENDPOINTS` en lugar de `PATH_ENDPOINTS`**

---

## Conclusión

Esta refactorización mejorará significativamente la mantenibilidad y escalabilidad del sistema Teatro Ribas, manteniendo la compatibilidad con la estructura existente mientras se implementan los principios de la arquitectura MIA.

La adopción de una estructura de directorios más descriptiva (`endpoints` y `ui`) junto con el sistema de contra-extensiones proporciona una forma clara y consistente de identificar el propósito de cada archivo y componente, facilitando el desarrollo y mantenimiento del sistema a largo plazo.
